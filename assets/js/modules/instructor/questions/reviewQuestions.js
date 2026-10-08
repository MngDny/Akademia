import { supabase } from "../../../core/supabaseClient.js";
import { requireRole } from "../../../core/authGuard.js";

const PAGE_SIZE = 50;
const questionTypes = {
  tf: { label: "Adevărat / Fals", kind: "options", table: "questions_tf" },
  abc_one: { label: "Un singur răspuns", kind: "options", table: "questions_abc_one" },
  abc_multi: { label: "Răspunsuri multiple", kind: "options", table: "questions_abc_multi" },
  match: { label: "Asociere", kind: "pairs", table: "questions_match" },
};

const elements = {
  summary: document.getElementById("queueSummary"),
  message: document.getElementById("reviewMessage"),
  list: document.getElementById("reviewList"),
  empty: document.getElementById("emptyState"),
  search: document.getElementById("searchInput"),
  book: document.getElementById("bookFilter"),
  type: document.getElementById("typeFilter"),
  refresh: document.getElementById("refreshBtn"),
  pagination: document.getElementById("reviewPagination"),
  pageSummary: document.getElementById("pageSummary"),
  previous: document.getElementById("previousPageBtn"),
  next: document.getElementById("nextPageBtn"),
  bookSuggestions: document.getElementById("reviewBookSuggestions"),
};

let questions = [];
let booksLoaded = false;
let loading = false;
let editingKey = "";
let page = 0;
let totalCount = 0;
let searchTimer = null;

function escapeHtml(value) {
  return String(value ?? "")
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&#39;");
}

function normalize(value) {
  return String(value || "")
    .toLocaleLowerCase("ro")
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .trim();
}

function setMessage(text = "", kind = "") {
  elements.message.textContent = text;
  elements.message.className = `review-message${kind ? ` ${kind}` : ""}`;
}

function references(row) {
  return Array.isArray(row.source_references) ? row.source_references.filter(Boolean) : [];
}

function optionText(option) {
  if (typeof option === "string") return option;
  return option?.text ?? option?.label ?? "";
}

function renderAnswerOptions(question) {
  const options = Array.isArray(question.options) ? question.options : [];
  if (!options.length) return '<p class="muted">Nu sunt salvate variante de răspuns.</p>';

  return `<div class="answer-list">${options.map((option, index) => {
    const correct = Boolean(typeof option === "object" && option?.correct);
    const label = question.type === "tf" ? "" : String.fromCharCode(65 + index);
    return `<div class="answer-review-row${correct ? " is-correct" : ""}">
      <span class="answer-marker" aria-hidden="true">${correct ? "✓" : escapeHtml(label || "•")}</span>
      <span class="answer-text">${escapeHtml(optionText(option) || "(fără text)")}</span>
      ${correct ? '<span class="correct-label">Răspuns corect</span>' : ""}
    </div>`;
  }).join("")}</div>`;
}

function renderPairs(question) {
  const pairs = Array.isArray(question.pairs) ? question.pairs : [];
  if (!pairs.length) return '<p class="muted">Nu sunt salvate perechi.</p>';
  return `<div class="match-list">${pairs.map((pair, index) => `<div class="match-review-row">
    <span class="match-review-side"><strong>${index + 1}.</strong> ${escapeHtml(pair?.left ?? pair?.stanga ?? "(fără element)")}</span>
    <span class="match-review-arrow" aria-hidden="true">→</span>
    <span class="match-review-side">${escapeHtml(pair?.right ?? pair?.dreapta ?? "(fără asociere)")}</span>
  </div>`).join("")}</div>`;
}

function renderEditorOption(question, option, index, selectedCorrectIndex) {
  const correctInput = question.type === "abc_multi"
    ? `<input type="checkbox" name="correctOption" value="${index}"${option?.correct ? " checked" : ""} aria-label="Marchează varianta ${index + 1} ca răspuns corect" />`
    : `<input type="radio" name="correctOption" value="${index}"${index === selectedCorrectIndex ? " checked" : ""} aria-label="Marchează varianta ${index + 1} ca răspuns corect" />`;
  const canRemove = question.type !== "tf";
  return `<div class="review-option-row" data-option-row data-original-index="${index}">
    <input class="input" type="text" name="optionText" value="${escapeHtml(optionText(option))}" aria-label="Textul variantei ${index + 1}" placeholder="Varianta ${index + 1}" />
    <label class="review-correct-toggle">${correctInput}<span>Corect</span></label>
    ${canRemove ? `<button class="btn sm review-remove-row" type="button" data-action="remove-option" aria-label="Elimină varianta ${index + 1}">Elimină</button>` : ""}
  </div>`;
}

function editorOptions(question) {
  let options = Array.isArray(question.options) ? question.options : [];
  if (question.type === "tf") {
    options = [...options];
    if (!options.length) options = [{ text: "Adevărat", correct: true }, { text: "Fals", correct: false }];
    while (options.length < 2) options.push({ text: options.length === 0 ? "Adevărat" : "Fals", correct: false });
  }

  const selectedCorrectIndex = options.findIndex((option) => Boolean(option?.correct));
  return `<div class="review-editor-options" data-options-host>
    ${options.map((option, index) => renderEditorOption(question, option, index, selectedCorrectIndex)).join("")}
  </div>
  ${question.type === "tf" ? '<p class="review-editor-help">Alege care dintre cele două afirmații reprezintă răspunsul corect.</p>' : '<button class="btn sm" type="button" data-action="add-option">＋ Adaugă variantă</button>'}`;
}

function editorPairs(question) {
  const pairs = Array.isArray(question.pairs) ? question.pairs : [];
  return `<div class="review-editor-pairs" data-pairs-host>
    ${pairs.map((pair, index) => `<div class="review-pair-row" data-pair-row data-original-index="${index}">
      <input class="input" type="text" name="pairLeft" value="${escapeHtml(pair?.left ?? pair?.stanga ?? "")}" aria-label="Elementul din stânga, perechea ${index + 1}" placeholder="Element stânga ${index + 1}" />
      <input class="input" type="text" name="pairRight" value="${escapeHtml(pair?.right ?? pair?.dreapta ?? "")}" aria-label="Elementul asociat, perechea ${index + 1}" placeholder="Element dreapta ${index + 1}" />
      <button class="btn sm review-remove-row" type="button" data-action="remove-pair" aria-label="Elimină perechea ${index + 1}">Elimină</button>
    </div>`).join("")}
  </div>
  <button class="btn sm" type="button" data-action="add-pair">＋ Adaugă pereche</button>
  <p class="review-editor-help">Asocierile folosite în teste trebuie să aibă cel puțin cinci perechi complete.</p>`;
}

function renderEditor(question) {
  const config = questionTypes[question.type];
  const safeId = escapeHtml(question.id.replaceAll("-", ""));
  const selectedStatus = question.status || "pending_review";
  const statusOptions = [
    ["pending_review", "De verificat"],
    ["active", "Activ"],
    ["draft", "Ciornă"],
    ["archived", "Arhivat"],
  ];
  const specificFields = config.kind === "pairs"
    ? `<div class="question-editor-field full"><span class="question-editor-label">Perechi de asociat</span>${editorPairs(question)}</div>`
    : `<div class="question-editor-field full">
        <label for="questionText-${safeId}">Textul întrebării</label>
        <textarea id="questionText-${safeId}" class="textarea" name="questionText" rows="3" required>${escapeHtml(question.text || "")}</textarea>
      </div>
      <div class="question-editor-field full"><span class="question-editor-label">Variante de răspuns și cheia corectă</span>${editorOptions(question)}</div>`;

  return `<form class="question-editor" novalidate>
    <div class="question-editor-heading">
      <div><h3>Editează întrebarea</h3><p class="review-editor-help">${escapeHtml(config.label)} · ID ${escapeHtml(question.id)}</p></div>
    </div>
    <div class="question-editor-grid">
      ${specificFields}
      <label class="question-editor-field"><span>Carte</span><input class="input" type="text" name="book" list="reviewBookSuggestions" value="${escapeHtml(question.book || "")}" required /></label>
      <label class="question-editor-field"><span>Capitol</span><input class="input" type="number" name="chapter" min="1" step="1" value="${escapeHtml(question.chapter ?? "")}" required /></label>
      <label class="question-editor-field"><span>Dificultate (1–5)</span><input class="input" type="number" name="difficulty" min="1" max="5" step="1" value="${escapeHtml(question.difficulty ?? "")}" required /></label>
      <label class="question-editor-field"><span>Status</span><select class="input" name="status">${statusOptions.map(([value, label]) => `<option value="${value}"${selectedStatus === value ? " selected" : ""}>${label}</option>`).join("")}</select></label>
      <label class="question-editor-field"><span>Adăugată de</span><input class="input" type="text" name="added_by" value="${escapeHtml(question.added_by || "")}" /></label>
      <label class="question-editor-field full"><span>Referințe biblice (câte una pe rând)</span><textarea class="textarea" name="source_references" rows="3">${escapeHtml(references(question).join("\n"))}</textarea></label>
    </div>
    <div class="question-editor-actions">
      <button class="btn" type="button" data-action="cancel-edit">Anulează</button>
      <button class="btn primary" type="submit">Salvează modificările</button>
    </div>
  </form>`;
}

function renderCard(question) {
  const config = questionTypes[question.type];
  if (editingKey === question.key) {
    return `<article class="question-review-card is-editing" data-question-key="${escapeHtml(question.key)}">${renderEditor(question)}</article>`;
  }

  const refChips = references(question).length
    ? references(question).map((reference) => `<span class="reference-chip">${escapeHtml(reference)}</span>`).join("")
    : '<span class="muted">Fără referință salvată</span>';
  const prompt = question.type === "match"
    ? "Asociază elementele cu descrierile indicate."
    : question.text || "Întrebarea nu are text.";
  const answers = config.kind === "pairs" ? renderPairs(question) : renderAnswerOptions(question);

  return `<article class="question-review-card" data-question-key="${escapeHtml(question.key)}">
    <div class="question-review-top">
      <span class="review-type">${escapeHtml(config.label)}</span>
      <span class="review-chip pending">De verificat</span>
      <span class="review-chip">Dificultate ${escapeHtml(question.difficulty ?? "—")}</span>
      <div class="question-review-meta">
        <span>${escapeHtml(question.book || "Carte necunoscută")}, capitolul ${escapeHtml(question.chapter ?? "—")}</span>
        <span>Adăugată de ${escapeHtml(question.added_by || "necunoscut")}</span>
      </div>
    </div>
    <div class="question-review-body">
      <h2 class="question-review-prompt">${escapeHtml(prompt)}</h2>
      ${question.type === "match" ? '<p class="question-review-subtitle">Răspunsurile corecte sunt afișate ca perechi.</p>' : ""}
      <section class="question-review-section" aria-label="Referințe biblice">
        <h3>Referințe biblice</h3>
        <div class="reference-list">${refChips}</div>
      </section>
      <section class="question-review-section" aria-label="Răspunsuri">
        <h3>${question.type === "match" ? "Asocieri corecte" : "Variante și cheie de răspuns"}</h3>
        ${answers}
      </section>
    </div>
    <div class="question-review-actions">
      <button class="btn sm edit-review" type="button" data-action="edit">Editează aici</button>
      <span class="spacer"></span>
      <button class="btn reject-review sm" type="button" data-action="reject">Respinge și arhivează</button>
      <button class="btn approve-review sm" type="button" data-action="approve">Aprobă și activează</button>
    </div>
  </article>`;
}

function updateControls() {
  const disabled = loading || Boolean(editingKey);
  elements.search.disabled = disabled;
  elements.book.disabled = disabled;
  elements.type.disabled = disabled;
  elements.refresh.disabled = disabled;
  elements.previous.disabled = disabled || page <= 0;
  elements.next.disabled = disabled || (page + 1) * PAGE_SIZE >= totalCount;
  elements.pagination.hidden = totalCount <= PAGE_SIZE;
  elements.list.setAttribute("aria-busy", String(loading));
}

function render() {
  const start = totalCount ? page * PAGE_SIZE + 1 : 0;
  const end = Math.min((page + 1) * PAGE_SIZE, totalCount);
  elements.summary.textContent = loading
    ? "Se încarcă întrebările..."
    : `${totalCount} ${totalCount === 1 ? "întrebare de verificat" : "întrebări de verificat"}`;
  elements.pageSummary.textContent = totalCount ? `Afișez ${start}–${end} din ${totalCount}` : "Nu există întrebări de afișat";
  elements.list.innerHTML = questions.map(renderCard).join("");
  elements.list.hidden = questions.length === 0;
  elements.empty.hidden = questions.length > 0 || loading;
  if (!totalCount && !loading) {
    elements.empty.querySelector("strong").textContent = "Nu există întrebări pentru filtrele alese.";
    elements.empty.querySelector("span").textContent = "Schimbă căutarea, cartea sau tipul întrebării.";
  }
  updateControls();
}

async function loadBookFilters() {
  const { data, error } = await supabase
    .from("question_review_books")
    .select("book")
    .order("book", { ascending: true });
  if (error) throw new Error(`Lista cărților nu a putut fi încărcată: ${error.message}`);

  const selectedBook = elements.book.value;
  const books = [...new Set((data || []).map((row) => row.book).filter(Boolean))];
  elements.book.replaceChildren(new Option("Toate cărțile", ""));
  elements.bookSuggestions.replaceChildren();
  books.forEach((book) => {
    elements.book.add(new Option(book, book));
    elements.bookSuggestions.append(new Option(book, book));
  });
  if (books.includes(selectedBook)) elements.book.value = selectedBook;
  booksLoaded = true;
}

function buildQueueQuery() {
  let query = supabase
    .from("question_review_queue")
    .select("type,id,text,options,pairs,chapter,difficulty,book,source_references,status,added_by,created_at", { count: "exact" })
    .order("book", { ascending: true, nullsFirst: false })
    .order("chapter", { ascending: true, nullsFirst: false })
    .order("created_at", { ascending: true, nullsFirst: false })
    .order("type", { ascending: true })
    .order("id", { ascending: true });

  const search = normalize(elements.search.value);
  if (search) query = query.ilike("search_text", `%${search}%`);
  if (elements.book.value) query = query.eq("book", elements.book.value);
  if (elements.type.value) query = query.eq("type", elements.type.value);
  return query.range(page * PAGE_SIZE, (page + 1) * PAGE_SIZE - 1);
}

async function loadQuestions({ refreshBooks = false } = {}) {
  if (loading) return false;
  loading = true;
  updateControls();
  elements.summary.textContent = "Se încarcă întrebările...";
  setMessage();

  let loadFailed = false;
  try {
    if (refreshBooks || !booksLoaded) await loadBookFilters();
    let response = await buildQueueQuery();
    if (response.error) throw response.error;
    totalCount = response.count || 0;

    const lastPage = Math.max(0, Math.ceil(totalCount / PAGE_SIZE) - 1);
    if (page > lastPage) {
      page = lastPage;
      response = await buildQueueQuery();
      if (response.error) throw response.error;
      totalCount = response.count || 0;
    }

    questions = (response.data || []).map((row) => ({ ...row, key: `${row.type}:${row.id}` }));
    return true;
  } catch (error) {
    console.error(error);
    loadFailed = true;
    questions = [];
    totalCount = 0;
    elements.summary.textContent = "Întrebările nu au putut fi încărcate.";
    setMessage(error?.message || "A apărut o eroare la încărcarea cozii.", "error");
    return false;
  } finally {
    loading = false;
    render();
    if (loadFailed) elements.summary.textContent = "Întrebările nu au putut fi încărcate.";
  }
}

function addOptionRow(form) {
  const host = form.querySelector("[data-options-host]");
  if (!host) return;
  const row = document.createElement("div");
  row.className = "review-option-row";
  row.dataset.optionRow = "";
  row.dataset.originalIndex = "-1";
  const questionType = form.closest("[data-question-key]")?.dataset.questionKey.split(":")[0];
  const correctInputType = questionType === "abc_multi" ? "checkbox" : "radio";
  row.innerHTML = `<input class="input" type="text" name="optionText" value="" placeholder="Variantă nouă" />
    <label class="review-correct-toggle"><input type="${correctInputType}" name="correctOption" value="" aria-label="Marchează varianta nouă ca răspuns corect" /><span>Corect</span></label>
    <button class="btn sm review-remove-row" type="button" data-action="remove-option">Elimină</button>`;
  host.append(row);
  syncOptionRows(form);
}

function syncOptionRows(form) {
  const rows = [...form.querySelectorAll("[data-option-row]")];
  rows.forEach((row, index) => {
    row.dataset.index = String(index);
    const text = row.querySelector('[name="optionText"]');
    const correct = row.querySelector('[name="correctOption"]');
    const remove = row.querySelector('[data-action="remove-option"]');
    text.placeholder = `Varianta ${index + 1}`;
    text.setAttribute("aria-label", `Textul variantei ${index + 1}`);
    if (correct) {
      correct.value = String(index);
      correct.setAttribute("aria-label", `Marchează varianta ${index + 1} ca răspuns corect`);
    }
    if (remove) remove.setAttribute("aria-label", `Elimină varianta ${index + 1}`);
  });
}

function addPairRow(form) {
  const host = form.querySelector("[data-pairs-host]");
  if (!host) return;
  const row = document.createElement("div");
  row.className = "review-pair-row";
  row.dataset.pairRow = "";
  row.dataset.originalIndex = "-1";
  row.innerHTML = `<input class="input" type="text" name="pairLeft" value="" placeholder="Element stânga" />
    <input class="input" type="text" name="pairRight" value="" placeholder="Element dreapta" />
    <button class="btn sm review-remove-row" type="button" data-action="remove-pair">Elimină</button>`;
  host.append(row);
  syncPairRows(form);
}

function syncPairRows(form) {
  [...form.querySelectorAll("[data-pair-row]")].forEach((row, index) => {
    row.querySelector('[name="pairLeft"]').placeholder = `Element stânga ${index + 1}`;
    row.querySelector('[name="pairLeft"]').setAttribute("aria-label", `Elementul din stânga, perechea ${index + 1}`);
    row.querySelector('[name="pairRight"]').placeholder = `Element dreapta ${index + 1}`;
    row.querySelector('[name="pairRight"]').setAttribute("aria-label", `Elementul asociat, perechea ${index + 1}`);
    row.querySelector('[data-action="remove-pair"]').setAttribute("aria-label", `Elimină perechea ${index + 1}`);
  });
}

function readEditorPayload(question, form) {
  const formData = new FormData(form);
  const chapter = Number.parseInt(String(formData.get("chapter") || ""), 10);
  const difficulty = Number.parseInt(String(formData.get("difficulty") || ""), 10);
  const book = String(formData.get("book") || "").trim();
  const status = String(formData.get("status") || "");
  const addedBy = String(formData.get("added_by") || "").trim();

  if (!book) throw new Error("Completează numele cărții.");
  if (!Number.isInteger(chapter) || chapter < 1) throw new Error("Capitolul trebuie să fie un număr întreg mai mare decât 0.");
  if (!Number.isInteger(difficulty) || difficulty < 1 || difficulty > 5) throw new Error("Dificultatea trebuie să fie un număr întreg între 1 și 5.");
  if (!["pending_review", "active", "draft", "archived"].includes(status)) throw new Error("Alege un status valid.");

  const payload = {
    chapter,
    difficulty,
    book,
    status,
    added_by: addedBy || null,
    source_references: [...new Set(String(formData.get("source_references") || "").split(/[\n,;]+/).map((value) => value.trim()).filter(Boolean))],
  };

  if (question.type === "match") {
    const rows = [...form.querySelectorAll("[data-pair-row]")];
    const existingPairCount = Array.isArray(question.pairs) ? question.pairs.length : 0;
    const minimumToPreserve = Math.max(1, Math.min(5, existingPairCount));
    if (rows.length < minimumToPreserve) throw new Error(`Păstrează cel puțin ${minimumToPreserve} perechi pentru această întrebare.`);
    if (status === "active" && rows.length < 5) throw new Error("Ca să activezi o întrebare de asociere, completează cel puțin cinci perechi.");
    payload.pairs = rows.map((row) => {
      const originalIndex = Number.parseInt(row.dataset.originalIndex || "-1", 10);
      const source = originalIndex >= 0 ? question.pairs?.[originalIndex] : null;
      const pair = {
        ...(source && typeof source === "object" && !Array.isArray(source) ? source : {}),
        left: row.querySelector('[name="pairLeft"]').value.trim(),
        right: row.querySelector('[name="pairRight"]').value.trim(),
      };
      return pair;
    });
    if (payload.pairs.some((pair) => !pair.left || !pair.right)) throw new Error("Completează ambele elemente pentru fiecare pereche.");
    return payload;
  }

  payload.text = String(formData.get("questionText") || "").trim();
  if (!payload.text) throw new Error("Completează textul întrebării.");

  const optionRows = [...form.querySelectorAll("[data-option-row]")];
  const minOptions = question.type === "tf" ? 2 : 2;
  if (optionRows.length < minOptions) throw new Error("Adaugă cel puțin două variante de răspuns.");
  const correctValues = new Set([...form.querySelectorAll('[name="correctOption"]:checked')].map((input) => input.value));
  if (!correctValues.size) throw new Error("Marchează cel puțin un răspuns corect.");
  if (question.type !== "abc_multi" && correctValues.size !== 1) throw new Error("Alege exact un răspuns corect.");

  payload.options = optionRows.map((row, index) => {
    const originalIndex = Number.parseInt(row.dataset.originalIndex || "-1", 10);
    const source = originalIndex >= 0 ? question.options?.[originalIndex] : null;
    const option = {
      ...(source && typeof source === "object" && !Array.isArray(source) ? source : {}),
      text: row.querySelector('[name="optionText"]').value.trim(),
      correct: correctValues.has(String(index)),
    };
    return option;
  });
  if (payload.options.some((option) => !option.text)) throw new Error("Completează textul fiecărei variante de răspuns.");
  return payload;
}

async function saveQuestion(question, form) {
  try {
    const payload = readEditorPayload(question, form);
    form.querySelectorAll("input, textarea, select, button").forEach((control) => { control.disabled = true; });
    setMessage("Se salvează modificările...");
    if (payload.status === "archived" && !confirm("Arhivezi această întrebare? Nu va mai apărea în coada de verificare.")) {
      form.querySelectorAll("input, textarea, select, button").forEach((control) => { control.disabled = false; });
      setMessage();
      return;
    }

    const { data, error } = await supabase
      .from(questionTypes[question.type].table)
      .update(payload)
      .eq("id", question.id)
      .eq("status", "pending_review")
      .select("id")
      .maybeSingle();
    if (error) throw error;
    if (!data?.id) throw new Error("Întrebarea nu a fost salvată. Reîncarcă lista pentru a verifica dacă a fost revizuită între timp.");

    editingKey = "";
    const loaded = await loadQuestions();
    if (loaded) setMessage(payload.status === "active" ? "Întrebarea a fost salvată și activată." : "Modificările au fost salvate.", "success");
  } catch (error) {
    console.error(error);
    setMessage(error?.message || "Întrebarea nu a putut fi salvată.", "error");
    form.querySelectorAll("input, textarea, select, button").forEach((control) => { control.disabled = false; });
  }
}

async function changeStatus(question, status, button) {
  if (status === "active" && question.type === "match" && (question.pairs || []).length < 5) {
    setMessage("Întrebările de asociere active trebuie să aibă cel puțin cinci perechi. Editează întrebarea și adaugă perechile lipsă.", "error");
    return;
  }
  if (status === "archived" && !confirm("Respinge întrebarea și arhiveaz-o? O poți reactiva ulterior din biblioteca de întrebări.")) return;
  button.disabled = true;
  setMessage(status === "active" ? "Se activează întrebarea..." : "Se arhivează întrebarea...");
  try {
    const { data, error } = await supabase
      .from(questionTypes[question.type].table)
      .update({ status })
      .eq("id", question.id)
      .eq("status", "pending_review")
      .select("id")
      .maybeSingle();
    if (error) throw error;
    if (!data?.id) throw new Error("Întrebarea nu a fost modificată. Reîncarcă lista și verifică dacă a fost deja revizuită.");
    const loaded = await loadQuestions();
    if (loaded) setMessage(status === "active" ? "Întrebarea a fost aprobată și este activă." : "Întrebarea a fost respinsă și arhivată.", "success");
  } catch (error) {
    console.error(error);
    setMessage(error?.message || "Statusul întrebării nu a putut fi schimbat.", "error");
    button.disabled = false;
  }
}

function handleFilterChange() {
  if (editingKey || loading) return;
  page = 0;
  loadQuestions();
}

async function init() {
  await requireRole("instructor");
  elements.search.addEventListener("input", () => {
    clearTimeout(searchTimer);
    searchTimer = setTimeout(handleFilterChange, 250);
  });
  elements.book.addEventListener("change", handleFilterChange);
  elements.type.addEventListener("change", handleFilterChange);
  elements.refresh.addEventListener("click", () => loadQuestions({ refreshBooks: true }));
  elements.previous.addEventListener("click", () => {
    if (loading || editingKey || page <= 0) return;
    page -= 1;
    loadQuestions();
  });
  elements.next.addEventListener("click", () => {
    if (loading || editingKey || (page + 1) * PAGE_SIZE >= totalCount) return;
    page += 1;
    loadQuestions();
  });

  elements.list.addEventListener("click", async (event) => {
    const button = event.target.closest("button[data-action]");
    if (!button || loading) return;
    const card = button.closest("[data-question-key]");
    const question = questions.find((item) => item.key === card?.dataset.questionKey);
    if (!question) return;

    const action = button.dataset.action;
    if (editingKey && editingKey !== question.key) {
      setMessage("Salvează sau anulează editarea curentă înainte să modifici altă întrebare.", "error");
      return;
    }
    if (action === "edit") {
      editingKey = question.key;
      render();
    } else if (action === "cancel-edit") {
      editingKey = "";
      render();
      setMessage();
    } else if (action === "add-option") {
      addOptionRow(card.querySelector(".question-editor"));
    } else if (action === "remove-option") {
      button.closest("[data-option-row]")?.remove();
      syncOptionRows(card.querySelector(".question-editor"));
    } else if (action === "add-pair") {
      addPairRow(card.querySelector(".question-editor"));
    } else if (action === "remove-pair") {
      button.closest("[data-pair-row]")?.remove();
      syncPairRows(card.querySelector(".question-editor"));
    } else if (action === "approve") {
      await changeStatus(question, "active", button);
    } else if (action === "reject") {
      await changeStatus(question, "archived", button);
    }
  });

  elements.list.addEventListener("submit", async (event) => {
    const form = event.target.closest("form.question-editor");
    if (!form) return;
    event.preventDefault();
    if (loading) return;
    const card = form.closest("[data-question-key]");
    const question = questions.find((item) => item.key === card?.dataset.questionKey);
    if (question) await saveQuestion(question, form);
  });

  await loadQuestions();
}

init().catch((error) => {
  console.error(error);
  elements.summary.textContent = "Ecranul de verificare nu a putut fi încărcat.";
  setMessage(error?.message || "A apărut o eroare la inițializarea verificării.", "error");
});
