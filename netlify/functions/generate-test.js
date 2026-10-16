const path = require("path");
const fs = require("fs");
const { createClient } = require("@supabase/supabase-js");
const PDFDocument = require("pdfkit");
const {
  AlignmentType,
  BorderStyle,
  Document,
  Packer,
  Paragraph,
  Table,
  TableCell,
  TableRow,
  TextRun,
  VerticalAlign,
  WidthType,
} = require("docx");
const { normalizeBookKey } = require("./bibleBooks.cjs");

const MAX_BODY_CHARS = 180 * 1024;
const ALLOWED_ROLES = new Set(["admin", "instructor", "indrumator"]);
const COLORS = { black: "000000", white: "FFFFFF" };
const PUBLIC_SUPABASE_URL = "https://pdkfqytododevpilpxet.supabase.co";
const PUBLIC_SUPABASE_KEY = "sb_publishable_9SE72Dov4XTRfAGoXhL1Nw_kbdPfK4z";
const PDF_FONT_DIRECTORY_CANDIDATES = [
  path.join(process.cwd(), "node_modules/dejavu-fonts-ttf/ttf"),
  path.join(__dirname, "../../node_modules/dejavu-fonts-ttf/ttf"),
  path.join(__dirname, "node_modules/dejavu-fonts-ttf/ttf"),
];

function pdfFontPath(fileName) {
  const candidates = PDF_FONT_DIRECTORY_CANDIDATES.map((directory) => path.join(directory, fileName));
  return candidates.find((candidate) => fs.existsSync(candidate)) || candidates[0];
}

const PDF_FONT = pdfFontPath("DejaVuSerif.ttf");
const PDF_FONT_BOLD = pdfFontPath("DejaVuSerif-Bold.ttf");

function respond(statusCode, payload, headers = {}) {
  return {
    statusCode,
    headers: { "Content-Type": "application/json", "Cache-Control": "no-store", ...headers },
    body: JSON.stringify(payload),
  };
}

function text(value, fallback = "") {
  const result = String(value ?? fallback).replace(/[\u0000-\u0008\u000B\u000C\u000E-\u001F]/g, "");
  return result.trim();
}

function run(value, size = 24, bold = false) {
  const safeValue = String(value ?? "").replace(/[\u0000-\u0008\u000B\u000C\u000E-\u001F]/g, "");
  return new TextRun({ text: safeValue, bold, font: "Times New Roman", size, color: COLORS.black });
}

function line(value, size = 24, bold = false, indent = 0, keepNext = false) {
  return new Paragraph({
    children: [run(value, size, bold)],
    indent: indent ? { left: indent } : undefined,
    spacing: { before: 0, after: 0, line: 225 },
    keepNext,
  });
}

function heading(value) {
  return line(value, 26, true, 0, true);
}

function questionText(question) {
  return text(question?.text || question?.prompt || "Întrebare fără text");
}

function referenceText(question) {
  const book = text(question?.book);
  const sourceReferences = Array.isArray(question?.source_references)
    ? question.source_references
    : typeof question?.source_references === "string"
      ? question.source_references.split(/[\n,;]+/)
      : [];
  const references = [...new Set(sourceReferences
    .map((reference) => text(reference).replace(/[‐‑‒–—]/g, "-"))
    .filter(Boolean))];

  if (references.length) {
    let questionBookIncluded = false;
    const normalizedBook = normalizeBookKey(book);
    return references.map((reference) => {
      const isQualified = /^(?:[1-3]\s*)?[\p{L}][\p{L}.\s]*\s+\d+:\d+/u.test(reference);
      if (isQualified) {
        if (normalizedBook && normalizeBookKey(reference).startsWith(`${normalizedBook} `)) questionBookIncluded = true;
        return reference;
      }
      if (!book || questionBookIncluded) return reference;
      questionBookIncluded = true;
      return `${book} ${reference}`;
    }).join(", ");
  }

  const chapter = text(question?.chapter);
  if (book && chapter) return `${book} ${chapter}`;
  return book;
}

function questionWithReferences(question, statement = questionText(question)) {
  const references = referenceText(question);
  return references ? `${statement} (${references})` : statement;
}

function optionText(option) {
  return text(typeof option === "string" ? option : option?.text ?? option?.label ?? "");
}

function normalizedOptions(question) {
  return Array.isArray(question?.options) ? question.options.slice(0, 3) : [];
}

function normalizedPairs(question) {
  const source = Array.isArray(question?.pairs) && question.pairs.length
    ? question.pairs
    : Array.isArray(question?.options)
      ? question.options
      : [];
  return source
    .slice(0, 5).map((pair) => ({
        left: text(pair?.left ?? pair?.stanga),
        right: text(pair?.right ?? pair?.dreapta),
      }))
    .filter((pair) => pair.left && pair.right);
}

function answerLines(question, number) {
  const options = normalizedOptions(question);
  const children = [line(`${number}. ${questionWithReferences(question)}`, 24, false, 0, options.length > 0)];
  options.forEach((option, index) => {
    children.push(line(`${"     "}${String.fromCharCode(97 + index)}) ${optionText(option)}`, 24, false, 0, index < options.length - 1));
  });
  return children;
}

function noBorders() {
  return {
    top: { style: BorderStyle.NONE, size: 0, color: COLORS.white },
    bottom: { style: BorderStyle.NONE, size: 0, color: COLORS.white },
    left: { style: BorderStyle.NONE, size: 0, color: COLORS.white },
    right: { style: BorderStyle.NONE, size: 0, color: COLORS.white },
    insideHorizontal: { style: BorderStyle.NONE, size: 0, color: COLORS.white },
    insideVertical: { style: BorderStyle.NONE, size: 0, color: COLORS.white },
  };
}

function matchingTable(question) {
  const pairs = normalizedPairs(question);
  const rows = pairs.map((pair, index) => new TableRow({
    children: [
      new TableCell({
        width: { size: 5000, type: WidthType.DXA },
        verticalAlign: VerticalAlign.CENTER,
        children: [line(`__${index + 1}. ${pair.left}`)],
      }),
      new TableCell({
        width: { size: 3000, type: WidthType.DXA },
        verticalAlign: VerticalAlign.CENTER,
        children: [line(`${String.fromCharCode(97 + index)}. ${pair.right}`)],
      }),
    ],
  }));
  return new Table({
    width: { size: 8000, type: WidthType.DXA },
    borders: noBorders(),
    rows,
  });
}

function buildDocument(payload) {
  const title = text(payload.title, "Test 1 Talantul în negoț");
  const tf = Array.isArray(payload.sections?.tf) ? payload.sections.tf.slice(0, 10) : [];
  const abcOne = Array.isArray(payload.sections?.abc_one) ? payload.sections.abc_one.slice(0, 10) : [];
  const match = Array.isArray(payload.sections?.match) ? payload.sections.match.slice(0, 1) : [];
  const abcMulti = Array.isArray(payload.sections?.abc_multi) ? payload.sections.abc_multi.slice(0, 3) : [];
  const children = [
    new Paragraph({
      alignment: AlignmentType.CENTER,
      children: [run(title, 30, true)],
      spacing: { before: 0, after: 0, line: 240 },
    }),
    line(""),
    heading("I. Puneți A (adevărat) sau F (fals) în dreptul fiecărei afirmații:"),
  ];

  tf.forEach((question, index) => children.push(line(
    questionWithReferences(question, `_ ${index + 1}. ${questionText(question)}`),
  )));
  children.push(heading("II. Încercuiți litera corespunzătoare răspunsului corect (doar un singur răspuns corect)"));
  abcOne.forEach((question, index) => children.push(...answerLines(question, index + 1)));
  children.push(heading(match[0]
    ? questionWithReferences(match[0], "III. Faceți asocierea dintre cele două coloane:")
    : "III. Faceți asocierea dintre cele două coloane:"));
  if (match[0]) children.push(matchingTable(match[0]));
  children.push(heading("IV. Încercuiți litera corespunzătoare răspunsului corect (pot fi unul, două, trei sau nici un răspuns corect)"));
  abcMulti.forEach((question, index) => children.push(...answerLines(question, index + 1)));

  return new Document({
    creator: "Akademia",
    title,
    description: "Test generat din întrebările selectate",
    sections: [{
      properties: {
        page: {
          size: { width: 12240, height: 15840 },
          margin: { top: 200, bottom: 200, left: 1440, right: 1440 },
        },
      },
      children,
    }],
  });
}

function contentSections(payload) {
  return {
    title: text(payload.title, "Test 1 Talantul în negoț"),
    tf: Array.isArray(payload.sections?.tf) ? payload.sections.tf.slice(0, 10) : [],
    abcOne: Array.isArray(payload.sections?.abc_one) ? payload.sections.abc_one.slice(0, 10) : [],
    match: Array.isArray(payload.sections?.match) ? payload.sections.match.slice(0, 1) : [],
    abcMulti: Array.isArray(payload.sections?.abc_multi) ? payload.sections.abc_multi.slice(0, 3) : [],
  };
}

function pdfWrite(document, value, { size = 12, bold = false, align = "left", indent = 0, color = COLORS.black } = {}) {
  document.font(bold ? PDF_FONT_BOLD : PDF_FONT).fontSize(size).fillColor(color).text(String(value ?? ""), {
    align,
    indent,
    lineGap: 0,
    paragraphGap: 0,
  });
}

function pdfMeasureText(document, value, { size = 12, bold = false, indent = 0 } = {}) {
  document.font(bold ? PDF_FONT_BOLD : PDF_FONT).fontSize(size);
  const width = document.page.width - document.page.margins.left - document.page.margins.right - indent;
  return document.heightOfString(String(value ?? ""), { width, lineGap: 0, paragraphGap: 0 }) + 3;
}

function pdfQuestionHeight(document, question, statement, includeOptions = false) {
  let height = pdfMeasureText(document, questionWithReferences(question, statement));
  if (includeOptions) {
    normalizedOptions(question).forEach((option, optionIndex) => {
      height += pdfMeasureText(document, `${"     "}${String.fromCharCode(97 + optionIndex)}) ${optionText(option)}`);
    });
  }
  return height + 3;
}

function pdfWriteQuestion(document, question, statement, includeOptions = false) {
  const options = includeOptions ? normalizedOptions(question) : [];
  pdfEnsureSpace(document, pdfQuestionHeight(document, question, statement, includeOptions));
  pdfWrite(document, questionWithReferences(question, statement));
  options.forEach((option, optionIndex) => {
    pdfWrite(document, `${"     "}${String.fromCharCode(97 + optionIndex)}) ${optionText(option)}`);
  });
}

function pdfSectionHeading(document, value, nextQuestionHeight = 0) {
  pdfEnsureSpace(document, pdfMeasureText(document, value, { size: 13, bold: true }) + nextQuestionHeight + 3);
  pdfWrite(document, value, { size: 13, bold: true });
}

function pdfEnsureSpace(document, height = 20) {
  if (document.y + height > document.page.height - 10) document.addPage();
}

function pdfMatchingMeasurements(document, question) {
  const pairs = normalizedPairs(question);
  const left = document.page.margins.left;
  const gap = 18;
  const width = (document.page.width - document.page.margins.left - document.page.margins.right - gap) / 2;
  document.font(PDF_FONT).fontSize(12);
  const measurements = pairs.map((pair, index) => {
    const leftText = `__${index + 1}. ${pair.left}`;
    const rightText = `${String.fromCharCode(97 + index)}. ${pair.right}`;
    return {
      leftText,
      rightText,
      height: Math.max(
        document.heightOfString(leftText, { width, lineGap: 0 }),
        document.heightOfString(rightText, { width, lineGap: 0 }),
      ),
    };
  });
  return { measurements, left, gap, width };
}

function pdfMatchingHeight(document, question) {
  const { measurements } = pdfMatchingMeasurements(document, question);
  return measurements.reduce((total, row) => total + row.height + 2, 0) + 6;
}

function writePdfMatchingTable(document, question) {
  const { measurements, left, gap, width } = pdfMatchingMeasurements(document, question);
  pdfEnsureSpace(document, measurements.reduce((total, row) => total + row.height + 2, 0));
  measurements.forEach(({ leftText, rightText, height }) => {
    const y = document.y;
    document.text(leftText, left, y, { width, lineGap: 0 });
    document.text(rightText, left + width + gap, y, { width, lineGap: 0 });
    document.y = y + height + 2;
  });
  document.x = left;
}

function buildPdf(payload) {
  const { title, tf, abcOne, match, abcMulti } = contentSections(payload);
  return new Promise((resolve, reject) => {
    const document = new PDFDocument({
      size: "LETTER",
      margins: { top: 10, bottom: 10, left: 72, right: 72 },
      compress: true,
    });
    const chunks = [];
    document.on("data", (chunk) => chunks.push(chunk));
    document.on("end", () => resolve(Buffer.concat(chunks)));
    document.on("error", reject);

    pdfWrite(document, title, { size: 15, bold: true, align: "center" });
    document.moveDown(1.4);
    pdfSectionHeading(document, "I. Puneți A (adevărat) sau F (fals) în dreptul fiecărei afirmații:", tf[0]
      ? pdfQuestionHeight(document, tf[0], `_ 1. ${questionText(tf[0])}`)
      : 0);
    tf.forEach((question, index) => {
      pdfWriteQuestion(document, question, `_ ${index + 1}. ${questionText(question)}`);
    });
    pdfSectionHeading(document, "II. Încercuiți litera corespunzătoare răspunsului corect (doar un singur răspuns corect)", abcOne[0]
      ? pdfQuestionHeight(document, abcOne[0], `1. ${questionText(abcOne[0])}`, true)
      : 0);
    abcOne.forEach((question, index) => {
      pdfWriteQuestion(document, question, `${index + 1}. ${questionText(question)}`, true);
    });
    pdfSectionHeading(document, match[0]
      ? questionWithReferences(match[0], "III. Faceți asocierea dintre cele două coloane:")
      : "III. Faceți asocierea dintre cele două coloane:", match[0]
      ? pdfMatchingHeight(document, match[0])
      : 0);
    if (match[0]) {
      writePdfMatchingTable(document, match[0]);
    }
    pdfSectionHeading(document, "IV. Încercuiți litera corespunzătoare răspunsului corect (pot fi unul, două, trei sau nici un răspuns corect)", abcMulti[0]
      ? pdfQuestionHeight(document, abcMulti[0], `1. ${questionText(abcMulti[0])}`, true)
      : 0);
    abcMulti.forEach((question, index) => {
      pdfWriteQuestion(document, question, `${index + 1}. ${questionText(question)}`, true);
    });
    document.end();
  });
}

function htmlEscape(value) {
  return String(value ?? "")
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/\"/g, "&quot;");
}

function htmlLine(value, className = "") {
  return `<p class="${className}">${htmlEscape(value)}</p>`;
}

function buildWordHtml(payload) {
  const { title, tf, abcOne, match, abcMulti } = contentSections(payload);
  const parts = [htmlLine(title, "title"), htmlLine("I. Puneți A (adevărat) sau F (fals) în dreptul fiecărei afirmații:", "heading")];
  tf.forEach((question, index) => parts.push(htmlLine(
    questionWithReferences(question, `_ ${index + 1}. ${questionText(question)}`),
  )));
  parts.push(htmlLine("II. Încercuiți litera corespunzătoare răspunsului corect (doar un singur răspuns corect)", "heading"));
  abcOne.forEach((question, index) => {
    parts.push(htmlLine(`${index + 1}. ${questionWithReferences(question)}`));
    normalizedOptions(question).forEach((option, optionIndex) => parts.push(htmlLine(`${"     "}${String.fromCharCode(97 + optionIndex)}) ${optionText(option)}`, "option")));
  });
  parts.push(htmlLine(match[0]
    ? questionWithReferences(match[0], "III. Faceți asocierea dintre cele două coloane:")
    : "III. Faceți asocierea dintre cele două coloane:", "heading"));
  if (match[0]) {
    const rows = normalizedPairs(match[0]).map((pair, index) => `<tr><td>${htmlEscape(`__${index + 1}. ${pair.left}`)}</td><td>${htmlEscape(`${String.fromCharCode(97 + index)}. ${pair.right}`)}</td></tr>`).join("");
    parts.push(`<table class="matching"><tbody>${rows}</tbody></table>`);
  }
  parts.push(htmlLine("IV. Încercuiți litera corespunzătoare răspunsului corect (pot fi unul, două, trei sau nici un răspuns corect)", "heading"));
  abcMulti.forEach((question, index) => {
    parts.push(htmlLine(`${index + 1}. ${questionWithReferences(question)}`));
    normalizedOptions(question).forEach((option, optionIndex) => parts.push(htmlLine(`${"     "}${String.fromCharCode(97 + optionIndex)}) ${optionText(option)}`, "option")));
  });
  return `<!doctype html><html><head><meta charset="utf-8"><style>
    @page { size: Letter; margin: 0.14in 1in; }
    body { margin: 0; color: #000; font-family: "Times New Roman", Times, serif; font-size: 12pt; line-height: 1.1; }
    p { margin: 0; padding: 0; }
    .title { margin-bottom: 16pt; text-align: center; font-size: 15pt; font-weight: 700; }
    .heading { margin-top: 0; page-break-after: avoid; font-size: 13pt; font-weight: 700; }
    .option { padding-left: 0.35in; }
    .matching { width: 100%; border: 0; border-collapse: collapse; margin: 0; page-break-inside: avoid; }
    .matching td { width: 50%; border: 0; padding: 0; vertical-align: top; }
  </style></head><body>${parts.join("")}</body></html>`;
}

async function authorize(event) {
  const token = String(event.headers?.authorization || event.headers?.Authorization || "")
    .replace(/^Bearer\s+/i, "").trim();
  if (!token) return null;
  const supabaseUrl = process.env.SUPABASE_URL || PUBLIC_SUPABASE_URL;
  const supabaseKey = process.env.SUPABASE_SERVICE_ROLE_KEY
    || process.env.SUPABASE_ANON_KEY
    || process.env.SUPABASE_PUBLISHABLE_KEY
    || PUBLIC_SUPABASE_KEY;
  const supabase = createClient(supabaseUrl, supabaseKey, {
    auth: { autoRefreshToken: false, persistSession: false },
  });
  const { data: userData, error: userError } = await supabase.auth.getUser(token);
  if (userError || !userData?.user) return null;
  const { data: account } = await supabase.from("accounts").select("role")
    .eq("id", userData.user.id).maybeSingle();
  return account && ALLOWED_ROLES.has(String(account.role || "").toLowerCase()) ? userData.user : null;
}

exports.handler = async (event) => {
  if (event.httpMethod !== "POST") return respond(405, { error: "Method not allowed" });
  if (String(event.body || "").length > MAX_BODY_CHARS) return respond(413, { error: "Testul este prea mare." });
  try {
    const user = await authorize(event);
    if (!user) return respond(403, { error: "Doar îndrumătorii și administratorii pot genera teste." });
    const payload = JSON.parse(event.body || "{}");
    const format = String(payload.format || "docx").toLowerCase();
    if (!new Set(["docx", "doc", "pdf"]).has(format)) return respond(400, { error: "Formatul solicitat nu este acceptat." });
    let buffer;
    let contentType;
    let extension;
    if (format === "pdf") {
      buffer = await buildPdf(payload);
      contentType = "application/pdf";
      extension = "pdf";
    } else if (format === "doc") {
      buffer = Buffer.from(buildWordHtml(payload), "utf8");
      contentType = "application/msword";
      extension = "doc";
    } else {
      const document = buildDocument(payload);
      buffer = await Packer.toBuffer(document);
      contentType = "application/vnd.openxmlformats-officedocument.wordprocessingml.document";
      extension = "docx";
    }
    return {
      statusCode: 200,
      isBase64Encoded: true,
      headers: {
        "Content-Type": contentType,
        "Content-Disposition": `attachment; filename=Test-Talantul-in-negot.${extension}`,
        "Cache-Control": "no-store",
      },
      body: buffer.toString("base64"),
    };
  } catch (error) {
    console.error(error);
    return respond(500, { error: "Testul nu a putut fi generat." });
  }
};

exports.buildDocument = buildDocument;
exports.buildPdf = buildPdf;
exports.buildWordHtml = buildWordHtml;
