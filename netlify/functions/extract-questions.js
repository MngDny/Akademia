const fs = require("node:fs");
const path = require("node:path");
const { PDFParse } = require("pdf-parse");

const OPENAI_URL = "https://api.openai.com/v1/chat/completions";

function readEnvValueFromLocalFile(key) {
  try {
    const envPath = path.join(process.cwd(), ".env");
    if (!fs.existsSync(envPath)) return "";

    const raw = fs.readFileSync(envPath, "utf8");
    const lines = raw.split(/\r?\n/);

    for (const line of lines) {
      const trimmed = line.trim();
      if (!trimmed || trimmed.startsWith("#")) continue;

      const sepIndex = trimmed.indexOf("=");
      if (sepIndex <= 0) continue;

      const envKey = trimmed.slice(0, sepIndex).trim();
      if (envKey !== key) continue;

      const envValue = trimmed.slice(sepIndex + 1).trim();
      return envValue.replace(/^['\"]|['\"]$/g, "");
    }
  } catch (_err) {
    return "";
  }

  return "";
}

function resolveOpenAiKey() {
  const direct = String(process.env.OPENAI_API_KEY || "").trim();
  if (direct) return direct;

  return readEnvValueFromLocalFile("OPENAI_API_KEY");
}

function withCors(statusCode, body) {
  return {
    statusCode,
    headers: {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Headers": "Content-Type",
      "Access-Control-Allow-Methods": "POST,OPTIONS",
      "Content-Type": "application/json",
    },
    body: JSON.stringify(body),
  };
}

function parseJsonSafely(raw) {
  const cleaned = String(raw || "").trim();
  if (!cleaned) return null;

  try {
    return JSON.parse(cleaned);
  } catch (_e) {
    const fenced = cleaned.match(/```(?:json)?\s*([\s\S]*?)```/i);
    if (!fenced) return null;

    try {
      return JSON.parse(fenced[1].trim());
    } catch (_err) {
      return null;
    }
  }
}

async function buildUserContentParts({ sourceType, text, fileName, mimeType, base64 }) {
  const parts = [];

  if (sourceType === "text") {
    if (!text) {
      throw new Error("Textul este gol.");
    }

    parts.push({
      type: "text",
      text,
    });
    return parts;
  }

  if (sourceType !== "file") {
    throw new Error("Sursă invalidă. Folosește text sau file.");
  }

  if (!base64) {
    throw new Error("Fișierul este gol.");
  }

  const lowerMime = mimeType.toLowerCase();

  // For PDFs, parse text locally first to avoid long OpenAI file-processing timeouts.
  if (lowerMime.includes("pdf")) {
    const fileBuffer = Buffer.from(base64, "base64");
    const parser = new PDFParse({ data: fileBuffer });
    let parsed = null;
    try {
      parsed = await parser.getText();
    } finally {
      await parser.destroy();
    }

    const pdfText = String(parsed?.text || "").replace(/\s+/g, " ").trim();

    if (!pdfText) {
      throw new Error("Nu am putut extrage text din PDF.");
    }

    const truncated = pdfText.slice(0, 22000);
    parts.push({
      type: "text",
      text: `Nume fișier: ${fileName}\n\nConținut PDF (trunchiat):\n${truncated}`,
    });
    return parts;
  }

  // For images, use image input explicitly.
  if (lowerMime.startsWith("image/")) {
    parts.push({
      type: "text",
      text: `Nume fișier imagine: ${fileName}`,
    });
    parts.push({
      type: "image_url",
      image_url: {
        url: `data:${mimeType};base64,${base64}`,
      },
    });
    return parts;
  }

  throw new Error("Tip de fișier neacceptat. Folosește PDF sau imagine.");
}

function buildJsonSchema() {
  return {
    name: "question_items",
    strict: true,
    schema: {
      type: "object",
      properties: {
        items: {
          type: "array",
          items: {
            type: "object",
            properties: {
              type: { type: "string", enum: ["tf", "abc_one", "abc_multi", "match"] },
              text: { type: "string" },
              correct: { type: "boolean" },
              options: {
                type: "array",
                items: {
                  type: "object",
                  properties: {
                    text: { type: "string" },
                    correct: { type: "boolean" },
                  },
                  required: ["text", "correct"],
                  additionalProperties: false,
                },
              },
              pairs: {
                type: "array",
                items: {
                  type: "object",
                  properties: {
                    left: { type: "string" },
                    right: { type: "string" },
                  },
                  required: ["left", "right"],
                  additionalProperties: false,
                },
              },
              chapter: { anyOf: [{ type: "integer" }, { type: "string" }] },
              difficulty: { anyOf: [{ type: "integer" }, { type: "string" }] },
              book: { type: "string" },
              status: { type: "string", enum: ["active", "draft", "archived"] },
            },
            required: ["type", "text", "correct", "options", "pairs", "chapter", "difficulty", "book", "status"],
            additionalProperties: false,
          },
        },
      },
      required: ["items"],
      additionalProperties: false,
    },
  };
}

function normalizeItem(rawItem) {
  const type = String(rawItem?.type || "").trim();
  const chapter = Number.parseInt(String(rawItem?.chapter || ""), 10);
  const difficulty = Number.parseInt(String(rawItem?.difficulty || ""), 10);

  const common = {
    type,
    chapter: Number.isInteger(chapter) && chapter > 0 ? chapter : 1,
    difficulty: Number.isInteger(difficulty) && difficulty > 0 ? difficulty : 1,
    book: String(rawItem?.book || "").trim() || "Import AI",
    status: ["active", "draft", "archived"].includes(String(rawItem?.status || "").trim())
      ? String(rawItem?.status || "").trim()
      : "draft",
  };

  if (type === "tf") {
    const text = String(rawItem?.text || "").trim();
    const correct = rawItem?.correct === false ? false : true;
    if (!text) return null;

    return {
      ...common,
      text,
      options: [
        { text: "Adevărat", correct },
        { text: "Fals", correct: !correct },
      ],
    };
  }

  if (type === "abc_one" || type === "abc_multi") {
    const text = String(rawItem?.text || "").trim();
    const sourceOptions = Array.isArray(rawItem?.options) ? rawItem.options : [];
    const options = sourceOptions
      .map((o) => ({
        text: String(o?.text || "").trim(),
        correct: Boolean(o?.correct),
      }))
      .filter((o) => o.text)
      .slice(0, 3);

    if (!text || options.length !== 3) return null;

    if (type === "abc_one") {
      const firstCorrectIndex = options.findIndex((o) => o.correct);
      const safeIndex = firstCorrectIndex >= 0 ? firstCorrectIndex : 0;
      options.forEach((opt, index) => {
        opt.correct = index === safeIndex;
      });
    }

    if (type === "abc_multi" && !options.some((o) => o.correct)) {
      options[0].correct = true;
    }

    return {
      ...common,
      text,
      options,
    };
  }

  if (type === "match") {
    const sourcePairs = Array.isArray(rawItem?.pairs) ? rawItem.pairs : [];
    const pairs = sourcePairs
      .map((pair) => ({
        left: String(pair?.left ?? pair?.stanga ?? "").trim(),
        right: String(pair?.right ?? pair?.dreapta ?? "").trim(),
      }))
      .filter((pair) => pair.left && pair.right);

    if (pairs.length < 2) return null;

    return {
      ...common,
      pairs,
    };
  }

  return null;
}

function buildPrompt() {
  return [
    "Primești material educațional în limba română (text, PDF sau imagine).",
    "Extrage întrebări pentru concurs biblic și clasifică-le strict în tipurile: tf, abc_one, abc_multi, match.",
    "Returnează maxim 30 de întrebări (cele mai bune și clare), ca să nu depășești token limit.",
    "Reguli:",
    "1) Răspunde EXCLUSIV JSON valid.",
    "2) Schema JSON: { \"items\": [ ... ] }.",
    "3) Pentru tf: {type,text,correct,chapter,difficulty,book,status} unde correct este true/false.",
    "4) Pentru abc_one / abc_multi: {type,text,options,chapter,difficulty,book,status}.",
    "5) options trebuie să aibă exact 3 elemente cu forma {text,correct}.",
    "6) Pentru abc_one exact 1 opțiune corectă; pentru abc_multi minim 1 opțiune corectă.",
    "7) Pentru match: {type,pairs,chapter,difficulty,book,status}, pairs este listă de {left,right}, minim 2 perechi.",
    "8) status poate fi active, draft sau archived (preferat draft).",
    "9) Nu include explicații, markdown sau text suplimentar.",
    "10) Dacă nu există întrebări suficiente, întoarce items gol.",
    "11) Include mereu câmpurile text, correct, options, pairs pentru fiecare item.",
    "12) Pentru câmpuri nefolosite pe tipul curent, pune valori implicite: text=\"\", correct=false, options=[], pairs=[].",
  ].join("\n");
}

exports.handler = async (event) => {
  if (event.httpMethod === "OPTIONS") {
    return withCors(200, { ok: true });
  }

  if (event.httpMethod !== "POST") {
    return withCors(405, { error: "Method not allowed" });
  }

  const openAiKey = resolveOpenAiKey();

  if (!openAiKey) {
    return withCors(500, {
      error: "OPENAI_API_KEY nu este configurată pe server.",
    });
  }

  try {
    const payload = JSON.parse(event.body || "{}");
    const sourceType = String(payload?.sourceType || "").trim();
    const text = String(payload?.text || "").trim();
    const fileName = String(payload?.fileName || "document").trim();
    const mimeType = String(payload?.mimeType || "application/octet-stream").trim();
    const base64 = String(payload?.base64 || "").trim();

    const userContentParts = await buildUserContentParts({
      sourceType,
      text,
      fileName,
      mimeType,
      base64,
    });

    const messages = [
      {
        role: "system",
        content: "Ești un parser de întrebări. Respectă schema JSON strictă, fără text adițional.",
      },
      {
        role: "user",
        content: [
          {
            type: "text",
            text: buildPrompt(),
          },
          ...userContentParts,
        ],
      },
    ];

    const openAiResponse = await fetch(OPENAI_URL, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${openAiKey}`,
      },
      body: JSON.stringify({
        model: "gpt-4.1-mini",
        temperature: 0,
        max_tokens: 4000,
        response_format: {
          type: "json_schema",
          json_schema: buildJsonSchema(),
        },
        messages,
      }),
    });

    if (!openAiResponse.ok) {
      const errText = await openAiResponse.text();
      return withCors(502, {
        error: "Eroare de la OpenAI.",
        details: errText.slice(0, 1200),
      });
    }

    const data = await openAiResponse.json();
  const rawText = String(data?.choices?.[0]?.message?.content || "").trim();
    const parsed = parseJsonSafely(rawText);

    if (!parsed || !Array.isArray(parsed.items)) {
      return withCors(422, {
        error: "Nu am putut interpreta răspunsul AI în format JSON valid.",
        raw: rawText.slice(0, 1200),
      });
    }

    const normalizedItems = parsed.items
      .map(normalizeItem)
      .filter(Boolean);

    const grouped = {
      tf: normalizedItems.filter((item) => item.type === "tf").length,
      abc_one: normalizedItems.filter((item) => item.type === "abc_one").length,
      abc_multi: normalizedItems.filter((item) => item.type === "abc_multi").length,
      match: normalizedItems.filter((item) => item.type === "match").length,
    };

    return withCors(200, {
      items: normalizedItems,
      grouped,
      total: normalizedItems.length,
    });
  } catch (error) {
    return withCors(500, {
      error: error?.message || "Eroare internă.",
    });
  }
};
