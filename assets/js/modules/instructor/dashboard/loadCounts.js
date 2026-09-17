import { supabase } from "../../../core/supabaseClient.js";
import { requireInstructor } from "../../../core/authGuard.js";
import { BIBLE_BOOKS, mergeBookOptions, normalizeBookKey } from "../../../core/bibleBooks.js";
import { mountBookAutocomplete } from "../../../core/bookAutocomplete.js";

await requireInstructor();

const TABLES = {
  tf: "questions_tf",
  abc_one: "questions_abc_one",
  abc_multi: "questions_abc_multi",
  match: "questions_match",
};

const filterInput = document.getElementById("instructorBookFilter");
const filterInfo = document.getElementById("instructorBookFilterInfo");
const rowsByType = {};
let bookAutocomplete = null;

function normalizeSearch(value) {
  return String(value || "")
    .toLowerCase()
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .trim();
}

function matchesBook(row) {
  const query = normalizeSearch(filterInput?.value || "");
  if (!query) return true;

  const selectedBook = normalizeBookKey(bookAutocomplete?.getSelectedValue() || "");
  const rowBook = normalizeBookKey(row?.book);
  return selectedBook ? rowBook === selectedBook : rowBook.includes(query);
}

function updateCategoryLinks() {
  const query = String(filterInput?.value || "").trim();
  document.querySelectorAll(".dashboard-grid .stat-card[data-type]").forEach((card) => {
    const type = card.dataset.type;
    const suffix = query ? `&book=${encodeURIComponent(query)}` : "";
    card.href = `/portal/instructor/questions/list.html?type=${type}${suffix}`;
  });
}

function renderCounts() {
  const query = String(filterInput?.value || "").trim();
  const visibleCount = (key) => {
    const rows = rowsByType[key];
    if (!Array.isArray(rows)) return "—";
    return rows.filter(matchesBook).length;
  };

  Object.keys(TABLES).forEach((key) => {
    const el = document.getElementById(`count_${key}`);
    if (el) el.textContent = String(visibleCount(key));
  });

  if (filterInfo) {
    filterInfo.textContent = query ? (bookAutocomplete?.getSelectedValue() || query) : "Toate cărțile";
  }

  updateCategoryLinks();
}

async function loadCounts() {
  const entries = await Promise.all(Object.entries(TABLES).map(async ([key, table]) => {
    const { data, error } = await supabase
      .from(table)
      .select("book")
      .limit(5000);
    return [key, Array.isArray(data) ? data : [], error];
  }));

  const allBooks = [...BIBLE_BOOKS];
  entries.forEach(([key, rows, error]) => {
    rowsByType[key] = error ? null : rows;
    if (!error) allBooks.push(...rows.map((row) => row?.book));
  });

  bookAutocomplete?.setOptions(mergeBookOptions(allBooks));
  renderCounts();

  entries.forEach(([key, _rows, error]) => {
    const el = document.getElementById(`count_${key}`);
    if (error && el) {
      el.textContent = "—";
      el.title = "Date indisponibile. Reîncarcă pagina pentru a încerca din nou.";
    }
  });
}

bookAutocomplete = mountBookAutocomplete({
  input: filterInput,
  options: BIBLE_BOOKS,
  onInput: renderCounts,
  onSelect: renderCounts,
});

const initialBook = new URL(window.location.href).searchParams.get("book");
if (initialBook) bookAutocomplete?.setValue(initialBook);

loadCounts().catch((error) => {
  console.error(error);
  Object.keys(TABLES).forEach((key) => {
    const el = document.getElementById(`count_${key}`);
    if (el) {
      el.textContent = "—";
      el.title = "Date indisponibile. Reîncarcă pagina pentru a încerca din nou.";
    }
  });
});
