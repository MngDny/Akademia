import json
import unicodedata
from pathlib import Path

INPUT_DIR = "clean_json"
OUTPUT_DIR = "final_json"

Path(OUTPUT_DIR).mkdir(exist_ok=True)

# ========= UTILS =========

def remove_diacritics(text):
    if not isinstance(text, str):
        return text
    return "".join(
        c for c in unicodedata.normalize("NFD", text)
        if unicodedata.category(c) != "Mn"
    )

def normalize_difficulty(value):
    if not value:
        return 50

    value = remove_diacritics(value).lower()

    if value == "usor":
        return 25
    if value == "mediu":
        return 50
    if value == "greu":
        return 75

    return 50

def clean_value(val):
    if str(val) == "NaN":
        return None
    return remove_diacritics(val)

# ========= PROCESS =========

def process_file(filename):
    with open(f"{INPUT_DIR}/{filename}", encoding="utf-8") as f:
        data = json.load(f)

    cleaned = []

    for item in data:
        new_item = {}

        for key, value in item.items():
            if key == "difficulty":
                new_item["difficulty"] = normalize_difficulty(value)
            elif isinstance(value, list):
                # options / pairs
                new_list = []
                for elem in value:
                    new_elem = {
                        k: clean_value(v) for k, v in elem.items()
                    }
                    new_list.append(new_elem)
                new_item[key] = new_list
            else:
                new_item[key] = clean_value(value)

        cleaned.append(new_item)

    out_name = filename.replace("_clean", "_final")
    with open(f"{OUTPUT_DIR}/{out_name}", "w", encoding="utf-8") as f:
        json.dump(cleaned, f, ensure_ascii=False, indent=2)

    print(f"✔ {out_name} ({len(cleaned)} intrebari)")

# ========= RUN =========

files = [
    "tf_clean.json",
    "abc_one_clean.json",
    "abc_multiple_clean.json",
    "asociere_clean.json"
]

for file in files:
    process_file(file)

print("🎉 Normalizare completa!")
