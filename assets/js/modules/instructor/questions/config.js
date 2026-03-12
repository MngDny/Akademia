// config.js
// Configurare centralizata pentru tipurile de intrebari.

const baseListColumns = ["id", "chapter", "difficulty", "book", "status", "added_by", "created_at"];

export const questionConfig = {
  tf: {
    title: "Adevărat / Fals",
    table: "questions_tf",
    textColumn: "text",
    dataKind: "options",
    listColumns: [...baseListColumns, "text", "options"],
  },
  abc_one: {
    title: "ABC One",
    table: "questions_abc_one",
    textColumn: "text",
    dataKind: "options",
    listColumns: [...baseListColumns, "text", "options"],
  },
  abc_multi: {
    title: "ABC Multi",
    table: "questions_abc_multi",
    textColumn: "text",
    dataKind: "options",
    listColumns: [...baseListColumns, "text", "options"],
  },
  match: {
    title: "Asociere",
    table: "questions_match",
    textColumn: null,
    dataKind: "pairs",
    listColumns: [...baseListColumns, "pairs"],
  },
};

export function getTypeFromUrl() {
  const url = new URL(window.location.href);
  return url.searchParams.get("type");
}

export function mustGetConfig(type) {
  const cfg = questionConfig[type];
  if (!cfg) {
    throw new Error(`Unknown question type: ${type}`);
  }
  return cfg;
}

export function getPreviewText(row, cfg) {
  if (cfg.dataKind === "pairs") {
    const firstPair = Array.isArray(row.pairs) ? row.pairs[0] : null;
    if (!firstPair) return "Fără perechi";

    const left = firstPair.left ?? firstPair.stanga ?? "";
    const right = firstPair.right ?? firstPair.dreapta ?? "";
    return `${left} -> ${right}`.trim();
  }

  return row[cfg.textColumn] || "Fără text";
}