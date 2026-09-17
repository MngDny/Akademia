import { supabase } from "../../core/supabaseClient.js";
import { requireRole } from "../../core/authGuard.js";
import { ATTEMPTS_TABLE, getEffectiveMaxPoints, getEffectivePoints } from "./contestConfig.js";
import { BIBLE_BOOKS, mergeBookOptions, normalizeBookKey } from "../../core/bibleBooks.js";
import { mountBookAutocomplete } from "../../core/bookAutocomplete.js";

const els = {
  subtitle: document.getElementById("resultsSubtitle"),
  search: document.getElementById("searchInput"),
  bookFilter: document.getElementById("bookFilter"),
  body: document.getElementById("resultsBody"),
  empty: document.getElementById("emptyState"),
};

let allRows = [];
let bookAutocomplete = null;

function normalizeSearch(value) {
  return String(value || "")
    .toLowerCase()
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .trim();
}

function formatDuration(seconds) {
  const mins = Math.floor(seconds / 60);
  const secs = seconds % 60;
  return `${String(mins).padStart(2, "0")}:${String(secs).padStart(2, "0")}`;
}

function render(rows) {
  els.body.innerHTML = "";

  if (!rows.length) {
    if (els.bookFilter?.value) {
      els.empty.textContent = "Nu există rezultate pentru cartea selectată.";
    } else if (els.search.value.trim()) {
      els.empty.textContent = "Niciun rezultat pentru această căutare. Încearcă altă dată sau alt punctaj.";
    } else {
      els.empty.textContent = "Rezultatele tale vor apărea aici după primul test.";
    }
    els.empty.style.display = "block";
    return;
  }

  els.empty.style.display = "none";

  rows.forEach((row) => {
    const pointsTotal = getEffectivePoints(row);
    const maxPoints = getEffectiveMaxPoints(row);
    const pct = maxPoints ? Math.round((pointsTotal / maxPoints) * 100) : 0;
    const tr = document.createElement("tr");
    tr.innerHTML = `
      <td>${new Date(row.created_at).toLocaleString("ro-RO")}</td>
      <td>${pointsTotal}/${maxPoints} (${pct}%)</td>
      <td>${row.total_correct_answers}/${row.total_questions}</td>
      <td>${formatDuration(row.duration_seconds || 0)}</td>
      <td>TF ${row.tf_correct}/${row.tf_total}, ABC1 ${row.abc_one_correct}/${row.abc_one_total}, Asociere ${row.match_pairs_correct} perechi, ABCM ${row.abc_multi_correct}/${row.abc_multi_total}</td>
    `;

    els.body.appendChild(tr);
  });
}

function applySearch() {
  const term = (els.search.value || "").toLowerCase().trim();
  const bookQuery = normalizeSearch(els.bookFilter?.value || "");
  const selectedBook = normalizeBookKey(bookAutocomplete?.getSelectedValue() || "");
  if (!term && !bookQuery) {
    render(allRows);
    return;
  }

  const filtered = allRows.filter((row) => {
    const created = new Date(row.created_at).toLocaleString("ro-RO").toLowerCase();
    const rowBooks = Array.isArray(row.breakdown) ? row.breakdown.map((item) => normalizeSearch(item.book)) : [];
    const hasBook = !bookQuery || rowBooks.some((book) => selectedBook ? normalizeBookKey(book) === selectedBook : book.includes(bookQuery));
    return hasBook && (!term || created.includes(term) || String(getEffectivePoints(row)).includes(term));
  });

  render(filtered);
}

async function loadResults(studentId) {
  const { data, error } = await supabase
    .from(ATTEMPTS_TABLE)
    .select("*")
    .eq("student_auth_id", studentId)
    .order("created_at", { ascending: false });

  if (error) {
    console.error(error);
    els.subtitle.textContent = "Eroare la încărcarea rezultatelor. Reîncarcă pagina pentru a încerca din nou.";
    return;
  }

  allRows = data || [];

  bookAutocomplete?.setOptions(mergeBookOptions([
    ...BIBLE_BOOKS,
    ...allRows.flatMap((row) => Array.isArray(row.breakdown) ? row.breakdown.map((item) => item.book) : []),
  ]));

  els.subtitle.textContent = allRows.length
    ? `${allRows.length} rezultate salvate`
    : "Nu ai rezultate inregistrate momentan.";

  render(allRows);
}

async function init() {
  const { session } = await requireRole("student");
  bookAutocomplete = mountBookAutocomplete({
    input: els.bookFilter,
    options: BIBLE_BOOKS,
    onInput: applySearch,
    onSelect: applySearch,
  });
  await loadResults(session.user.id);

  els.search.addEventListener("input", applySearch);
}

init();
