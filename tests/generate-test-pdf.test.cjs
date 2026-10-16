const assert = require("node:assert/strict");
const test = require("node:test");
const JSZip = require("jszip");
const { Packer } = require("docx");
const { PDFParse } = require("pdf-parse");
const { buildDocument, buildPdf, buildWordHtml } = require("../netlify/functions/generate-test.js");

const payload = {
    title: "Test de verificare",
    sections: {
      tf: [{ text: "Elcana locuia la Rama.", book: "1 Samuel", chapter: 1, source_references: ["1:1", "1:2"] }],
      abc_one: [{ text: "Cum se numea soția lui Elcana?", book: "1 Samuel", chapter: 1, source_references: ["1 Samuel 1:2", "1:4"], options: [{ text: "Ana" }, { text: "Penina" }] }],
      match: [{ book: "1 Samuel", chapter: 1, source_references: ["1:3", "1:5"], pairs: [
        { left: "Ana", right: "S-a rugat Domnului" },
        { left: "Elcana", right: "S-a suit la Silo" },
        { left: "Eli", right: "A slujit Domnului" },
        { left: "Samuel", right: "A fost dus la Silo" },
        { left: "Penina", right: "A avut copii" },
      ] }],
      abc_multi: [{ text: "Ce afirmații sunt corecte?", book: "1 Samuel", chapter: 2, options: [
        { text: "Prima opțiune", correct: true },
        { text: "A doua opțiune", correct: false },
        { text: "A treia opțiune", correct: true },
      ] }],
    },
};

test("generate-test keeps compact references beside each PDF question", async () => {
  const pdf = await buildPdf(payload);

  assert.ok(Buffer.isBuffer(pdf));
  assert.equal(pdf.subarray(0, 5).toString("ascii"), "%PDF-");
  assert.ok(pdf.length > 1000);

  const parser = new PDFParse({ data: pdf });
  try {
    const parsed = await parser.getText();
    assert.match(parsed.text, /Elcana locuia la Rama\. \(1 Samuel 1:1, 1:2\)/);
    assert.match(parsed.text, /Cum se numea soția lui Elcana\? \(1 Samuel 1:2, 1:4\)/);
    assert.match(parsed.text, /Faceți asocierea dintre cele două coloane: \(1 Samuel 1:3,\s*1:5\)/);
    assert.match(parsed.text, /Ce afirmații sunt corecte\? \(1 Samuel 2\)/);
  } finally {
    await parser.destroy();
  }
});

test("generate-test keeps compact references beside questions in both Word formats", async () => {
  const html = buildWordHtml(payload);
  assert.match(html, /Elcana locuia la Rama\. \(1 Samuel 1:1, 1:2\)/);
  assert.match(html, /Cum se numea soția lui Elcana\? \(1 Samuel 1:2, 1:4\)/);
  assert.match(html, /Faceți asocierea dintre cele două coloane: \(1 Samuel 1:3, 1:5\)/);
  assert.match(html, /Ce afirmații sunt corecte\? \(1 Samuel 2\)/);
  assert.doesNotMatch(html, /class="references"/);

  const docxBuffer = await Packer.toBuffer(buildDocument(payload));
  const archive = await JSZip.loadAsync(docxBuffer);
  const documentXml = await archive.file("word/document.xml").async("string");
  assert.match(documentXml, /Elcana locuia la Rama\. \(1 Samuel 1:1, 1:2\)/);
  assert.match(documentXml, /Cum se numea soția lui Elcana\? \(1 Samuel 1:2, 1:4\)/);
  assert.match(documentXml, /Faceți asocierea dintre cele două coloane: \(1 Samuel 1:3, 1:5\)/);
  assert.match(documentXml, /Ce afirmații sunt corecte\? \(1 Samuel 2\)/);
});
