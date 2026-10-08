const fs = require("node:fs");
const path = require("node:path");

const TABLE_BY_TYPE = {
  tf: "questions_tf",
  abc_one: "questions_abc_one",
  abc_multi: "questions_abc_multi",
  match: "questions_match",
};

function sqlString(value) {
  return `'${String(value ?? "").replaceAll("'", "''")}'`;
}

function sqlJson(value) {
  return `${sqlString(JSON.stringify(value ?? null))}::jsonb`;
}

function sqlTextArray(values) {
  const refs = Array.isArray(values) ? values : [];
  return refs.length
    ? `ARRAY[${refs.map(sqlString).join(", ")}]::text[]`
    : "ARRAY[]::text[]";
}

function validateItem(item, index) {
  const label = `Întrebarea ${index + 1}`;
  if (!TABLE_BY_TYPE[item?.type]) throw new Error(`${label}: tip necunoscut.`);
  if (!String(item.book || "").trim()) throw new Error(`${label}: lipsește cartea.`);
  if (!Number.isInteger(Number(item.chapter)) || Number(item.chapter) < 1) throw new Error(`${label}: capitol invalid.`);
  if (!Number.isInteger(Number(item.difficulty)) || Number(item.difficulty) < 1 || Number(item.difficulty) > 5) {
    throw new Error(`${label}: dificultatea trebuie să fie între 1 și 5.`);
  }
  if (!["active", "pending_review", "draft", "archived"].includes(item.status)) throw new Error(`${label}: status invalid.`);
  if (!Array.isArray(item.source_references) || !item.source_references.length) {
    throw new Error(`${label}: adaugă cel puțin o referință biblică.`);
  }
  if (item.source_references.some((reference) => !String(reference || "").trim())) {
    throw new Error(`${label}: există o referință biblică goală.`);
  }
  if (item.type !== "match" && !String(item.text || "").trim()) {
    throw new Error(`${label}: textul întrebării este gol.`);
  }

  if (item.type === "tf" && (!Array.isArray(item.options) || item.options.length !== 2 || item.options.filter((option) => option.correct).length !== 1)) {
    throw new Error(`${label}: întrebarea Adevărat/Fals trebuie să aibă exact un răspuns corect.`);
  }
  if ((item.type === "abc_one" || item.type === "abc_multi") && (!String(item.text || "").trim() || !Array.isArray(item.options) || item.options.length !== 3 || item.options.some((option) => !String(option?.text || "").trim()))) {
    throw new Error(`${label}: întrebarea cu variante trebuie să aibă exact trei opțiuni.`);
  }
  if (item.type === "abc_one" && item.options.filter((option) => option.correct).length !== 1) {
    throw new Error(`${label}: întrebarea cu un răspuns trebuie să aibă exact un răspuns corect.`);
  }
  if (item.type === "abc_multi" && !item.options.some((option) => option.correct)) {
    throw new Error(`${label}: întrebarea cu răspunsuri multiple trebuie să aibă răspuns corect.`);
  }
  if (item.type === "match" && (!Array.isArray(item.pairs) || item.pairs.length !== 5 || item.pairs.some((pair) => !String(pair?.left || "").trim() || !String(pair?.right || "").trim()))) {
    throw new Error(`${label}: întrebarea de asociere trebuie să aibă exact cinci perechi.`);
  }
}

function insertStatement(type, items) {
  const table = TABLE_BY_TYPE[type];
  const isMatch = type === "match";
  const valueColumns = isMatch
    ? ["pairs", "chapter", "difficulty", "book", "source_references", "status", "added_by"]
    : ["text", "options", "chapter", "difficulty", "book", "source_references", "status", "added_by"];
  const insertColumns = [...valueColumns, "created_at"];

  const valueRows = items.map((item) => {
    const baseValues = isMatch
      ? [
          sqlJson(item.pairs),
          Number(item.chapter),
          Number(item.difficulty),
          sqlString(item.book),
          sqlTextArray(item.source_references),
          sqlString(item.status || "active"),
          sqlString("Codex"),
        ]
      : [
          sqlString(item.text),
          sqlJson(item.options),
          Number(item.chapter),
          Number(item.difficulty),
          sqlString(item.book),
          sqlTextArray(item.source_references),
          sqlString(item.status || "active"),
          sqlString("Codex"),
        ];
    return `  (${baseValues.join(", ")})`;
  });

  const identityMatch = isMatch
    ? `existing.pairs = incoming.pairs`
    : `existing.text = incoming.text`;

  return [
    `insert into public.${table} (${insertColumns.join(", ")})`,
    `select ${valueColumns.map((column) => `incoming.${column}`).join(", ")}, now()`,
    `from (values\n${valueRows.join(",\n")}\n) as incoming (${valueColumns.join(", ")})`,
    `where not exists (`,
    `  select 1 from public.${table} existing`,
    `  where existing.book = incoming.book`,
    `    and existing.chapter = incoming.chapter`,
    `    and existing.source_references = incoming.source_references`,
    `    and ${identityMatch}`,
    `);`,
  ].join("\n");
}

function updateExistingStatusStatement(type, items) {
  const table = TABLE_BY_TYPE[type];
  const isMatch = type === "match";
  const identityColumn = isMatch ? "pairs" : "text";
  const identityValue = item => isMatch ? sqlJson(item.pairs) : sqlString(item.text);
  const values = items.map((item) => `  (${sqlString(item.book)}, ${Number(item.chapter)}, ${sqlTextArray(item.source_references)}, ${sqlString(item.status)}, ${identityValue(item)})`);
  return [
    `update public.${table} as existing`,
    `set status = incoming.status`,
    `from (values\n${values.join(",\n")}\n) as incoming (book, chapter, source_references, status, ${identityColumn})`,
    `where existing.added_by = 'Codex'`,
    `  and existing.book = incoming.book`,
    `  and existing.chapter = incoming.chapter`,
    `  and existing.source_references = incoming.source_references`,
    `  and existing.${identityColumn} = incoming.${identityColumn};`,
  ].join("\n");
}

function main() {
  const inputPath = path.resolve(process.argv[2] || "final_json/1_samuel_1_questions.json");
  const outputPath = path.resolve(process.argv[3] || "final_json/1_samuel_1_seed.sql");
  const data = JSON.parse(fs.readFileSync(inputPath, "utf8"));
  const items = Array.isArray(data) ? data : data.items;
  if (!Array.isArray(items) || !items.length) throw new Error("Fișierul nu conține o listă de întrebări.");

  items.forEach(validateItem);

  const statements = [
    "begin;",
    "alter table public.questions_tf add column if not exists source_references text[] not null default '{}';",
    "alter table public.questions_abc_one add column if not exists source_references text[] not null default '{}';",
    "alter table public.questions_abc_multi add column if not exists source_references text[] not null default '{}';",
    "alter table public.questions_match add column if not exists source_references text[] not null default '{}';",
  ];

  for (const type of Object.keys(TABLE_BY_TYPE)) {
    const typedItems = items.filter((item) => item.type === type);
    if (typedItems.length) {
      statements.push(updateExistingStatusStatement(type, typedItems));
      statements.push(insertStatement(type, typedItems));
    }
  }

  statements.push("commit;", "");
  fs.writeFileSync(outputPath, statements.join("\n\n"), "utf8");
  process.stdout.write(`SQL pregătit pentru ${items.length} întrebări: ${outputPath}\n`);
}

main();
