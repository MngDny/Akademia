export const BIBLE_BOOKS = Object.freeze([
  "Geneza", "Exodul", "Leviticul", "Numeri", "Deuteronomul", "Iosua",
  "Judecători", "Rut", "1 Samuel", "2 Samuel", "1 Regi", "2 Regi",
  "1 Cronici", "2 Cronici", "Ezra", "Neemia", "Estera", "Iov", "Psalmii",
  "Proverbele", "Eclesiastul", "Cântarea Cântărilor", "Isaia", "Ieremia",
  "Plângerile lui Ieremia", "Ezechiel", "Daniel", "Osea", "Ioel", "Amos",
  "Obadia", "Iona", "Mica", "Naum", "Habacuc", "Țefania", "Hagai", "Zaharia",
  "Maleahi", "Matei", "Marcu", "Luca", "Ioan", "Faptele Apostolilor", "Romani",
  "1 Corinteni", "2 Corinteni", "Galateni", "Efeseni", "Filipeni", "Coloseni",
  "1 Tesaloniceni", "2 Tesaloniceni", "1 Timotei", "2 Timotei", "Tit", "Filimon",
  "Evrei", "Iacov", "1 Petru", "2 Petru", "1 Ioan", "2 Ioan", "3 Ioan", "Iuda",
  "Apocalipsa",
]);

export function normalizeBookKey(value) {
  return String(value || "")
    .trim()
    .toLowerCase()
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .replace(/\s+/g, " ");
}

export function mergeBookOptions(values = []) {
  const byKey = new Map(BIBLE_BOOKS.map((book) => [normalizeBookKey(book), book]));
  for (const value of values) {
    const display = String(value || "").trim();
    const key = normalizeBookKey(display);
    if (display && key && !byKey.has(key)) byKey.set(key, display);
  }
  return [...byKey.values()];
}

export function readBooksFromUrl(search = window.location.search) {
  try {
    const raw = new URLSearchParams(search).get("books");
    const parsed = raw ? JSON.parse(raw) : [];
    if (!Array.isArray(parsed)) return [];
    const canonicalKeys = new Map(BIBLE_BOOKS.map((book) => [normalizeBookKey(book), book]));
    return parsed.map((book) => canonicalKeys.get(normalizeBookKey(book)) || String(book || "").trim()).filter(Boolean);
  } catch {
    return [];
  }
}

export function summarizeBooks(selected = [], total = BIBLE_BOOKS.length) {
  if (!selected.length) return "Nicio carte selectată. Alege cel puțin una.";
  const preview = selected.slice(0, 3).join(", ");
  const more = selected.length > 3 ? ` +${selected.length - 3}` : "";
  return `${selected.length} ${selected.length === 1 ? "carte selectată" : "cărți selectate"} din ${total}: ${preview}${more}`;
}
