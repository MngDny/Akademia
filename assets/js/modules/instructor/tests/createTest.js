import { supabase } from "../../../core/supabaseClient.js";
import { requireAnyRole } from "../../../core/authGuard.js";
import { BIBLE_BOOKS, normalizeBookKey } from "../../../core/bibleBooks.js";
import { TEST_STRUCTURE, TYPE_ORDER } from "../../student/contestConfig.js";

const TYPE_META = {
  tf: { table: "questions_tf", label: "Adevărat / Fals" },
  abc_one: { table: "questions_abc_one", label: "Un singur răspuns" },
  match: { table: "questions_match", label: "Asociere" },
  abc_multi: { table: "questions_abc_multi", label: "Răspunsuri multiple" },
};

const els = {
  bookSearch: document.getElementById("bookSearch"),
  bookList: document.getElementById("bookList"),
  selectedBookChips: document.getElementById("selectedBookChips"),
  selectionSummary: document.getElementById("selectionSummary"),
  selectAllBooksBtn: document.getElementById("selectAllBooksBtn"),
  clearBooksBtn: document.getElementById("clearBooksBtn"),
  chaptersSection: document.getElementById("chaptersSection"),
  chaptersHelp: document.getElementById("chaptersHelp"),
  chapterList: document.getElementById("chapterList"),
  selectAllChaptersBtn: document.getElementById("selectAllChaptersBtn"),
  clearChaptersBtn: document.getElementById("clearChaptersBtn"),
  builderStatus: document.getElementById("builderStatus"),
  availabilityBadge: document.getElementById("availabilityBadge"),
  availabilityStatus: document.getElementById("availabilityStatus"),
  availabilityList: document.getElementById("availabilityList"),
  difficultyRange: document.getElementById("difficultyRange"),
  difficultyValue: document.getElementById("difficultyValue"),
  difficultyHint: document.getElementById("difficultyHint"),
  testTitle: document.getElementById("testTitle"),
  generateTestBtn: document.getElementById("generateTestBtn"),
  generateDocBtn: document.getElementById("generateDocBtn"),
  generatePdfBtn: document.getElementById("generatePdfBtn"),
  downloadStatus: document.getElementById("downloadStatus"),
};

const state = {
  selectedBooks: new Set(),
  availableChapters: [],
  selectedChapters: new Set(),
  chapterRequest: 0,
  availabilityRequest: 0,
  availabilityCounts: null,
  availabilityReady: false,
  availabilityError: false,
  generating: false,
};

function shuffle(items) {
  const result = [...items];
  for (let index = result.length - 1; index > 0; index -= 1) {
    const other = Math.floor(Math.random() * (index + 1));
    [result[index], result[other]] = [result[other], result[index]];
  }
  return result;
}

function canonicalBook(value) {
  const key = normalizeBookKey(value);
  return BIBLE_BOOKS.find((book) => normalizeBookKey(book) === key) || String(value || "").trim();
}

function selectedBooks() {
  return [...state.selectedBooks];
}

function selectedChapters() {
  return [...state.selectedChapters].sort((a, b) => a - b);
}

function difficultyTarget() {
  const value = Number(els.difficultyRange.value);
  return Number.isFinite(value) ? Math.min(100, Math.max(0, value)) : 50;
}

function difficultyPercent(value) {
  const numeric = Number(value);
  if (!Number.isFinite(numeric)) return 50;
  if (numeric <= 5) return Math.round((Math.min(5, Math.max(1, numeric)) - 1) * 25);
  return Math.round(Math.min(100, Math.max(0, numeric)));
}

function isAvailableQuestion(row) {
  const status = String(row?.status || "").trim().toLocaleLowerCase("ro").normalize("NFD").replace(/[\u0300-\u036f]/g, "");
  return !["draft", "ciorna", "archived", "arhivat"].includes(status);
}

function prioritizeByDifficulty(rows, target) {
  return [...rows]
    .map((row) => ({ row, distance: Math.abs(difficultyPercent(row.difficulty) - target), tie: Math.random() }))
    .sort((left, right) => left.distance - right.distance || left.tie - right.tie)
    .map(({ row }) => row);
}

function setStatus(element, message, kind = "") {
  element.textContent = message;
  element.className = `form-status${kind ? ` ${kind}` : ""}`;
}

function renderSelectedBooks() {
  els.selectedBookChips.replaceChildren();
  selectedBooks().forEach((book) => {
    const chip = document.createElement("span");
    chip.className = "selected-book-chip";
    chip.append(document.createTextNode(book));
    const remove = document.createElement("button");
    remove.type = "button";
    remove.className = "selected-book-remove";
    remove.setAttribute("aria-label", `Elimină ${book}`);
    remove.textContent = "×";
    remove.addEventListener("click", () => toggleBook(book, false));
    chip.append(remove);
    els.selectedBookChips.append(chip);
  });
}

function renderBookList() {
  const term = els.bookSearch.value.trim().toLocaleLowerCase("ro");
  els.bookList.replaceChildren();
  BIBLE_BOOKS.filter((book) => !term || book.toLocaleLowerCase("ro").includes(term)).forEach((book) => {
    const label = document.createElement("label");
    label.className = `test-book-option${state.selectedBooks.has(book) ? " is-selected" : ""}`;
    const input = document.createElement("input");
    input.type = "checkbox";
    input.checked = state.selectedBooks.has(book);
    input.addEventListener("change", () => toggleBook(book, input.checked));
    const text = document.createElement("span");
    text.textContent = book;
    label.append(input, text);
    els.bookList.append(label);
  });
}

function renderSummary() {
  const books = selectedBooks();
  if (!books.length) {
    els.selectionSummary.textContent = "Nicio carte selectată";
  } else if (books.length === 1) {
    const chapters = selectedChapters();
    els.selectionSummary.textContent = chapters.length ? `${books[0]} · ${chapters.length} capitole` : `${books[0]} · toate capitolele`;
  } else {
    els.selectionSummary.textContent = `${books.length} cărți selectate`;
  }
  const disabled = !books.length || !state.availabilityReady || state.availabilityError || state.generating;
  [els.generateTestBtn, els.generateDocBtn, els.generatePdfBtn].forEach((button) => { button.disabled = disabled; });
}

function renderAvailability() {
  const books = selectedBooks();
  els.availabilityList.replaceChildren();
  if (!books.length) {
    els.availabilityBadge.textContent = "Așteaptă selecția";
    els.availabilityBadge.className = "availability-badge";
    els.availabilityStatus.textContent = "Selectează cel puțin o carte pentru a verifica întrebările.";
    return;
  }
  if (!state.availabilityReady) {
    els.availabilityBadge.textContent = "Se verifică";
    els.availabilityBadge.className = "availability-badge is-loading";
    els.availabilityStatus.textContent = "Verific dacă există suficiente întrebări pentru structura completă a testului…";
    return;
  }
  const shortages = TYPE_ORDER.filter((type) => (state.availabilityCounts?.[type] || 0) < TEST_STRUCTURE[type]);
  els.availabilityBadge.textContent = shortages.length ? "Insuficient" : "Suficient";
  els.availabilityBadge.className = `availability-badge ${shortages.length ? "is-error" : "is-ready"}`;
  els.availabilityStatus.textContent = shortages.length
    ? "Nu sunt suficiente întrebări pentru a genera testul."
    : "Ai suficiente întrebări pentru toate cele 4 secțiuni.";
  TYPE_ORDER.forEach((type) => {
    const item = document.createElement("li");
    const available = state.availabilityCounts?.[type] || 0;
    const needed = TEST_STRUCTURE[type];
    item.className = available < needed ? "is-short" : "is-enough";
    item.innerHTML = `<span>${TYPE_META[type].label}</span><strong>${available}/${needed}</strong>`;
    els.availabilityList.append(item);
  });
}

async function checkAvailability() {
  const books = selectedBooks();
  const request = ++state.availabilityRequest;
  state.availabilityReady = false;
  state.availabilityError = false;
  state.availabilityCounts = null;
  renderAvailability();
  renderSummary();
  if (!books.length) return;
  const chapters = books.length === 1 ? selectedChapters() : [];
  try {
    const results = await Promise.all(TYPE_ORDER.map(async (type) => {
      const { table } = TYPE_META[type];
      let query = supabase.from(table).select("*").in("book", books).limit(500);
      if (chapters.length) query = query.in("chapter", chapters);
      const { data, error } = await query;
      if (error) throw error;
      const rows = (data || []).filter((row) => isAvailableQuestion(row) && books.some((book) => normalizeBookKey(book) === normalizeBookKey(row.book)));
      return [type, type === "match" ? rows.filter(hasEnoughMatchPairs).length : rows.length];
    }));
    if (request !== state.availabilityRequest) return;
    state.availabilityCounts = Object.fromEntries(results);
    state.availabilityReady = true;
    state.availabilityError = TYPE_ORDER.some((type) => state.availabilityCounts[type] < TEST_STRUCTURE[type]);
    renderAvailability();
    renderSummary();
  } catch (error) {
    console.error(error);
    if (request !== state.availabilityRequest) return;
    state.availabilityReady = true;
    state.availabilityError = true;
    state.availabilityCounts = null;
    els.availabilityBadge.textContent = "Verificare eșuată";
    els.availabilityBadge.className = "availability-badge is-error";
    els.availabilityStatus.textContent = "Nu am putut verifica întrebările. Încearcă din nou sau verifică conexiunea.";
    renderSummary();
  }
}

function renderDifficulty() {
  const value = difficultyTarget();
  els.difficultyValue.textContent = `${value} / 100`;
  if (value <= 33) {
    els.difficultyHint.textContent = "Vor fi prioritizate întrebările mai ușoare.";
  } else if (value >= 67) {
    els.difficultyHint.textContent = "Vor fi prioritizate întrebările mai dificile.";
  } else {
    els.difficultyHint.textContent = `Întrebările apropiate de dificultatea ${value} vor fi prioritizate.`;
  }
}

function renderChapters() {
  els.chapterList.replaceChildren();
  state.availableChapters.forEach((chapter) => {
    const label = document.createElement("label");
    label.className = `chapter-option${state.selectedChapters.has(chapter) ? " is-selected" : ""}`;
    const input = document.createElement("input");
    input.type = "checkbox";
    input.checked = state.selectedChapters.has(chapter);
    input.addEventListener("change", () => {
      if (input.checked) state.selectedChapters.add(chapter);
      else state.selectedChapters.delete(chapter);
      renderChapters();
      renderSummary();
      checkAvailability();
    });
    const text = document.createElement("span");
    text.textContent = `Cap. ${chapter}`;
    label.append(input, text);
    els.chapterList.append(label);
  });
  els.chaptersHelp.textContent = state.availableChapters.length
    ? "Selectează capitolele dorite sau păstrează toate capitolele."
    : "Nu există capitole disponibile pentru această carte.";
}

async function loadChapters(book) {
  const request = ++state.chapterRequest;
  state.availableChapters = [];
  state.selectedChapters.clear();
  renderChapters();
  setStatus(els.builderStatus, "Se încarcă lista capitolelor…");
  try {
    const results = await Promise.all(Object.values(TYPE_META).map(async ({ table }) => {
      const { data, error } = await supabase.from(table).select("chapter").eq("book", book).limit(1000);
      if (error) throw error;
      return data || [];
    }));
    if (request !== state.chapterRequest) return;
    state.availableChapters = [...new Set(results.flat().map((row) => Number(row.chapter)).filter(Number.isInteger).filter((chapter) => chapter > 0))].sort((a, b) => a - b);
    renderChapters();
    setStatus(els.builderStatus, "");
    checkAvailability();
  } catch (error) {
    console.error(error);
    if (request !== state.chapterRequest) return;
    renderChapters();
    setStatus(els.builderStatus, "Capitolele nu au putut fi încărcate. Poți genera testul din toată cartea.", "error");
    checkAvailability();
  }
}

function updateChapterVisibility() {
  const books = selectedBooks();
  const oneBook = books.length === 1;
  els.chaptersSection.hidden = !oneBook;
  if (oneBook) loadChapters(books[0]);
  else {
    state.chapterRequest += 1;
    state.availableChapters = [];
    state.selectedChapters.clear();
    renderChapters();
    setStatus(els.builderStatus, "");
    checkAvailability();
  }
}

function toggleBook(book, selected) {
  if (selected) state.selectedBooks.add(book);
  else state.selectedBooks.delete(book);
  renderBookList();
  renderSelectedBooks();
  updateChapterVisibility();
  renderSummary();
}

function getQuestionText(row) {
  return String(row?.text || "Întrebare fără text").trim();
}

function matchPairs(row) {
  const source = Array.isArray(row?.pairs) && row.pairs.length ? row.pairs : Array.isArray(row?.options) ? row.options : [];
  return source.filter((pair) => String(pair?.left ?? pair?.stanga ?? "").trim() && String(pair?.right ?? pair?.dreapta ?? "").trim());
}

function hasEnoughMatchPairs(row) {
  return matchPairs(row).length >= 5;
}

async function fetchQuestions(type, books, chapters) {
  const { table } = TYPE_META[type];
  let query = supabase.from(table).select("*").in("book", books).order("created_at", { ascending: false }).limit(500);
  if (chapters.length) query = query.in("chapter", chapters);
  const { data, error } = await query;
  if (error) throw error;
  const rows = (data || []).filter((row) => isAvailableQuestion(row) && books.some((book) => normalizeBookKey(book) === normalizeBookKey(row.book)));
  const valid = type === "match" ? rows.filter(hasEnoughMatchPairs) : rows;
  const needed = TEST_STRUCTURE[type];
  if (valid.length < needed) {
    throw new Error(`${TYPE_META[type].label}: sunt necesare ${needed}, dar sunt disponibile doar ${valid.length}.`);
  }
  return prioritizeByDifficulty(shuffle(valid), difficultyTarget()).slice(0, needed);
}

async function buildSections() {
  const books = selectedBooks();
  const chapters = books.length === 1 ? selectedChapters() : [];
  const result = {};
  for (const type of TYPE_ORDER) result[type] = await fetchQuestions(type, books, chapters);
  return result;
}

function safeFilename(value) {
  return String(value || "Test-Talantul-in-negot").replace(/[^a-z0-9ăâîșțĂÂÎȘȚ ._-]/gi, "").trim().replace(/\s+/g, "-") || "Test-Talantul-in-negot";
}

const FORMAT_META = {
  docx: { button: () => els.generateTestBtn, extension: "docx", label: "Word (.docx)", idle: "Descarcă Word (.docx)" },
  doc: { button: () => els.generateDocBtn, extension: "doc", label: "Word (.doc)", idle: "Descarcă Word (.doc)" },
  pdf: { button: () => els.generatePdfBtn, extension: "pdf", label: "PDF", idle: "Descarcă PDF" },
};

async function generateTest(format = "docx") {
  const meta = FORMAT_META[format] || FORMAT_META.docx;
  state.generating = true;
  [els.generateTestBtn, els.generateDocBtn, els.generatePdfBtn].forEach((button) => { button.disabled = true; });
  meta.button().textContent = `Se pregătește ${meta.label}…`;
  setStatus(els.downloadStatus, `Se aleg întrebările și se generează ${meta.label}…`);
  try {
    const sections = await buildSections();
    const { data: { session } } = await supabase.auth.getSession();
    const response = await fetch("/.netlify/functions/generate-test", {
      method: "POST",
      headers: { "Content-Type": "application/json", ...(session?.access_token ? { Authorization: `Bearer ${session.access_token}` } : {}) },
      body: JSON.stringify({ title: els.testTitle.value.trim() || "Test 1 Talantul în negoț", sections, format, difficulty: difficultyTarget() }),
    });
    if (!response.ok) {
      let message = "Testul nu a putut fi generat.";
      try { message = (await response.json()).error || message; } catch { /* response may be non-JSON */ }
      throw new Error(message);
    }
    const blob = await response.blob();
    const url = URL.createObjectURL(blob);
    const anchor = document.createElement("a");
    anchor.href = url;
    anchor.download = `${safeFilename(els.testTitle.value)}.${meta.extension}`;
    document.body.append(anchor);
    anchor.click();
    anchor.remove();
    window.setTimeout(() => URL.revokeObjectURL(url), 1000);
    setStatus(els.downloadStatus, `Test generat în ${meta.label}: ${Object.values(sections).flat().length} întrebări. Descărcarea a început.`, "success");
  } catch (error) {
    console.error(error);
    setStatus(els.downloadStatus, error.message || "Testul nu a putut fi generat.", "error");
  } finally {
    state.generating = false;
    meta.button().textContent = meta.idle;
    renderSummary();
  }
}

function init() {
  renderBookList();
  renderSelectedBooks();
  renderDifficulty();
  renderAvailability();
  renderSummary();
  els.bookSearch.addEventListener("input", renderBookList);
  els.difficultyRange.addEventListener("input", renderDifficulty);
  els.selectAllBooksBtn.addEventListener("click", () => {
    BIBLE_BOOKS.forEach((book) => state.selectedBooks.add(book));
    toggleBookState();
  });
  els.clearBooksBtn.addEventListener("click", () => { state.selectedBooks.clear(); toggleBookState(); });
  els.selectAllChaptersBtn.addEventListener("click", () => { state.selectedChapters = new Set(state.availableChapters); renderChapters(); renderSummary(); checkAvailability(); });
  els.clearChaptersBtn.addEventListener("click", () => { state.selectedChapters.clear(); renderChapters(); renderSummary(); checkAvailability(); });
  els.generateTestBtn.addEventListener("click", () => generateTest("docx"));
  els.generateDocBtn.addEventListener("click", () => generateTest("doc"));
  els.generatePdfBtn.addEventListener("click", () => generateTest("pdf"));
}

function toggleBookState() {
  renderBookList();
  renderSelectedBooks();
  updateChapterVisibility();
  renderSummary();
}

async function start() {
  await requireAnyRole(["instructor", "admin"]);
  init();
}

start().catch((error) => {
  console.error(error);
  setStatus(els.builderStatus, "Nu am putut încărca generatorul de teste.", "error");
});
