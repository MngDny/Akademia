// listQuestions.js

import { supabase } from "../../../core/supabaseClient.js";
import { requireRole } from "../../../core/authGuard.js";
import { getPreviewText, getTypeFromUrl, mustGetConfig } from "./config.js";
import { BIBLE_BOOKS, mergeBookOptions, normalizeBookKey } from "../../../core/bibleBooks.js";
import { mountBookAutocomplete } from "../../../core/bookAutocomplete.js";

const els = {
  pageTitle: document.getElementById("pageTitle"),
  pageSubtitle: document.getElementById("pageSubtitle"),
  addBtn: document.getElementById("addBtn"),
  tableBody: document.getElementById("tableBody"),
  emptyState: document.getElementById("emptyState"),
  searchInput: document.getElementById("searchInput"),
  bookFilter: document.getElementById("bookFilter"),
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

function render(rows, cfg) {
  els.tableBody.innerHTML = "";

  if (!rows.length) {
    els.emptyState.style.display = "block";
    return;
  }
  els.emptyState.style.display = "none";

  for (const row of rows) {
    const tr = document.createElement("tr");
    const shortId = String(row.id || "").slice(0, 8);
    const preview = getPreviewText(row, cfg);
    const meta = [
      row.chapter ? `Capitol ${row.chapter}` : null,
      row.difficulty ? `Dificultate ${row.difficulty}` : null,
      row.book || null,
      row.status || null,
    ]
      .filter(Boolean)
      .join(" | ");

    tr.innerHTML = `
      <td title="${row.id ?? ""}">${shortId}</td>
      <td>
        <div>${preview}</div>
        <small class="muted">${meta || "Fără metadate"}</small>
      </td>
      <td>
        <a class="btn sm" href="/portal/instructor/questions/add.html?type=${typeFromCfg(cfg)}&edit=${row.id}">Editează</a>
        <button class="btn danger sm" data-action="delete" data-id="${row.id}">Șterge</button>
      </td>
    `;

    els.tableBody.appendChild(tr);
  }
}

function applySearch(cfg) {
  const q = (els.searchInput.value || "").toLowerCase().trim();
  const bookQuery = normalizeSearch(els.bookFilter?.value || "");
  const selectedBook = normalizeBookKey(bookAutocomplete?.getSelectedValue() || "");
  if (!q && !bookQuery) return render(allRows, cfg);

  const filtered = allRows.filter((r) => {
    const preview = getPreviewText(r, cfg).toLowerCase();
    const book = normalizeSearch(r.book);
    const status = String(r.status || "").toLowerCase();
    const chapter = String(r.chapter || "");
    const difficulty = String(r.difficulty || "");

    return (!bookQuery || (selectedBook ? normalizeBookKey(r.book) === selectedBook : book.includes(bookQuery))) && (
      preview.includes(q)
      || book.includes(q)
      || status.includes(q)
      || chapter.includes(q)
      || difficulty.includes(q)
    );
  });

  render(filtered, cfg);
}

async function load(cfg) {
  const { data, error } = await supabase
    .from(cfg.table)
    .select(cfg.listColumns.join(","))
    .order("created_at", { ascending: false });

  if (error) {
    console.error(error);
    els.pageSubtitle.textContent = "Eroare la încărcarea întrebărilor.";
    allRows = [];
    render([], cfg);
    return;
  }

  allRows = data || [];
  bookAutocomplete?.setOptions(mergeBookOptions([
    ...BIBLE_BOOKS,
    ...allRows.map((row) => row.book),
  ]));
  els.pageSubtitle.textContent = `${allRows.length} întrebări`;
  if (els.bookFilter?.value) applySearch(cfg);
  else render(allRows, cfg);
}

async function deleteRow(cfg, id) {
  const ok = confirm("Sigur vrei să ștergi această întrebare?");
  if (!ok) return;

  const { error } = await supabase.from(cfg.table).delete().eq("id", id);

  if (error) {
    alert("Eroare la ștergere.");
    console.error(error);
    return;
  }

  await load(cfg);
}

async function init() {
  // Role guard
  await requireRole("instructor");

  const type = getTypeFromUrl();
  const cfg = mustGetConfig(type);

  els.pageTitle.textContent = `Întrebări - ${cfg.title}`;
  els.addBtn.href = `/portal/instructor/questions/add.html?type=${type}`;

  els.searchInput.addEventListener("input", () => applySearch(cfg));
  bookAutocomplete = mountBookAutocomplete({
    input: els.bookFilter,
    options: BIBLE_BOOKS,
    onInput: () => applySearch(cfg),
    onSelect: () => applySearch(cfg),
  });
  const initialBook = new URL(window.location.href).searchParams.get("book");
  if (initialBook) bookAutocomplete.setValue(initialBook);

  els.tableBody.addEventListener("click", async (e) => {
    const btn = e.target.closest("button");
    if (!btn) return;

    const action = btn.dataset.action;
    const id = btn.dataset.id;

    if (action === "delete" && id) {
      await deleteRow(cfg, id);
    }
  });

  await load(cfg);
}

function typeFromCfg(cfg) {
  if (cfg.table === "questions_tf") return "tf";
  if (cfg.table === "questions_abc_one") return "abc_one";
  if (cfg.table === "questions_abc_multi") return "abc_multi";
  return "match";
}

init();
