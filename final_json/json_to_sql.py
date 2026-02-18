import json
import unicodedata

INPUT_FILE = "asociere_final.json"
TABLE_NAME = "questions_match"

def normalize(text):
    if text is None:
        return None
    text = unicodedata.normalize("NFKD", text)
    return text.encode("ascii", "ignore").decode("ascii")

def sql_escape(value):
    if value is None:
        return "NULL"
    return "'" + value.replace("'", "''") + "'"

with open(INPUT_FILE, "r", encoding="utf-8") as f:
    data = json.load(f)

values = []

for q in data:
    text = normalize(q.get("text"))
    options = json.dumps(q.get("options"), ensure_ascii=False)
    chapter = q.get("chapter")
    difficulty = q.get("difficulty")
    book = normalize(q.get("book"))
    status = normalize(q.get("status"))
    added_by = normalize(q.get("added_by"))

    values.append(
        f"({sql_escape(text)}, {sql_escape(options)}, {chapter}, {difficulty}, "
        f"{sql_escape(book)}, {sql_escape(status)}, {sql_escape(added_by)})"
    )

sql = f"""
INSERT INTO {TABLE_NAME}
(text, options, chapter, difficulty, book, status, added_by)
VALUES
{",\n".join(values)};
"""

with open("output4.sql", "w", encoding="utf-8") as f:
    f.write(sql)

print("✅ output4.sql generat cu succes")
