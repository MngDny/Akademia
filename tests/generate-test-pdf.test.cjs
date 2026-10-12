const assert = require("node:assert/strict");
const test = require("node:test");
const { buildPdf } = require("../netlify/functions/generate-test.js");

test("generate-test builds a PDF containing all four question sections", async () => {
  const pdf = await buildPdf({
    title: "Test de verificare",
    sections: {
      tf: [{ text: "Elcana locuia la Rama. " }],
      abc_one: [{ text: "Cum se numea soția lui Elcana?", options: [{ text: "Ana" }, { text: "Penina" }] }],
      match: [{ pairs: [
        { left: "Ana", right: "S-a rugat Domnului" },
        { left: "Elcana", right: "S-a suit la Silo" },
        { left: "Eli", right: "A slujit Domnului" },
        { left: "Samuel", right: "A fost dus la Silo" },
        { left: "Penina", right: "A avut copii" },
      ] }],
      abc_multi: [{ text: "Ce afirmații sunt corecte?", options: [
        { text: "Prima opțiune", correct: true },
        { text: "A doua opțiune", correct: false },
        { text: "A treia opțiune", correct: true },
      ] }],
    },
  });

  assert.ok(Buffer.isBuffer(pdf));
  assert.equal(pdf.subarray(0, 5).toString("ascii"), "%PDF-");
  assert.ok(pdf.length > 1000);
});
