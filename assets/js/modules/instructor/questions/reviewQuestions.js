import { supabase } from "../../../core/supabaseClient.js";
import { requireRole } from "../../../core/authGuard.js";

const questionTypes = {
  tf: { table: "questions_tf", label: "Adevărat / Fals", kind: "options" },
  abc_one: { table: "questions_abc_one", label: "Un singur răspuns", kind: "options" },
  abc_multi: { table: "questions_abc_multi", label: "Răspunsuri multiple", kind: "options" },
  match: { table: "questions_match", label: "Asociere", kind: "pairs" },
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
};

let questions = [];
let loading = false;

function escapeHtml(value) {
  return String(value ?? "")
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&#39;");
}

function normalize(value) {
  return String(value || "").toLocaleLowerCase("ro").normalize("NFD").replace(/[\u0300-\u036f]/g, "").trim();
}

function setMessage(text = "", kind = "") {
  elements.message.textContent = text;
  elements.message.className = `review-message${kind ? ` ${kind}` : ""}`;
}

function references(row) {
  return Array.isArray(row.source_references) ? row.source_references.filter(Boolean) : [];
}

function searchText(question) {
  const answers = question.type === "match"
    ? (question.pairs || []).flatMap((pair) => [pair.left, pair.right])
    : (question.options || []).map((option) => option?.text);
  return normalize([
    question.text,
    question.book,
    question.chapter,
    question.added_by,
    ...references(question),
    ...answers,
  ].join(" "));
}

function filteredQuestions() {
  const search = normalize(elements.search.value);
  const book = elements.book.value;
  const type = elements.type.value;
  return questions.filter((question) =>
    (!book || question.book === book)
    && (!type || question.type === type)
    && (!search || searchText(question).includes(search))
  );
}

function renderAnswerOptions(question) {
  const options = Array.isArray(question.options) ? question.options : [];
  if (!options.length) return '<p class="muted">Nu sunt salvate variante de răspuns.</p>';

  return `<div class="answer-list">${options.map((option, index) => {
    const correct = Boolean(option?.correct);
    const label = question.type === "tf" ? "" : String.fromCharCode(65 + index);
    return `<div class="answer-review-row${correct ? " is-correct" : ""}">
      <span class="answer-marker" aria-hidden="true">${correct ? "✓" : escapeHtml(label || "•")}</span>
      <span class="answer-text">${escapeHtml(option?.text || "(fără text)")}</span>
      ${correct ? '<span class="correct-label">Răspuns corect</span>' : ""}
    </div>`;
  }).join("")}</div>`;
}

function renderPairs(question) {
  const pairs = Array.isArray(question.pairs) ? question.pairs : [];
  if (!pairs.length) return '<p class="muted">Nu sunt salvate perechi.</p>';
  return `<div class="match-list">${pairs.map((pair, index) => `<div class="match-review-row">
    <span class="match-review-side"><strong>${index + 1}.</strong> ${escapeHtml(pair?.left || "(fără element)")}</span>
    <span class="match-review-arrow" aria-hidden="true">→</span>
    <span class="match-review-side">${escapeHtml(pair?.right || "(fără asociere)")}</span>
  </div>`).join("")}</div>`;
}

function renderCard(question) {
  const config = questionTypes[question.type];
  const refChips = references(question).length
    ? references(question).map((reference) => `<span class="reference-chip">${escapeHtml(reference)}</span>`).join("")
    : '<span class="muted">Fără referință salvată</span>';
  const prompt = question.type === "match"
    ? "Asociază elementele cu descrierile indicate."
    : question.text || "Întrebarea nu are text.";
  const answers = config.kind === "pairs" ? renderPairs(question) : renderAnswerOptions(question);
  const editor = `/portal/instructor/questions/add.html?type=${encodeURIComponent(question.type)}&edit=${encodeURIComponent(question.id)}`;

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
      <a class="btn sm" href="${editor}">Editează</a>
      <span class="spacer"></span>
      <button class="btn reject-review sm" type="button" data-action="reject">Respinge și arhivează</button>
      <button class="btn approve-review sm" type="button" data-action="approve">Aprobă și activează</button>
    </div>
  </article>`;
}

function render() {
  const rows = filteredQuestions();
  elements.summary.textContent = questions.length
    ? `${questions.length} de verificat${rows.length !== questions.length ? ` · ${rows.length} afișate` : ""}`
    : "Nu există întrebări în așteptare.";
  elements.list.innerHTML = rows.map(renderCard).join("");
  elements.list.hidden = rows.length === 0;
  elements.empty.hidden = questions.length > 0 || loading;
  if (questions.length > 0 && rows.length === 0) {
    elements.empty.hidden = false;
    elements.empty.querySelector("strong").textContent = "Nu există rezultate pentru filtrele alese.";
    elements.empty.querySelector("span").textContent = "Schimbă căutarea, cartea sau tipul întrebării.";
  } else {
    elements.empty.querySelector("strong").textContent = "Nu sunt întrebări în această listă.";
    elements.empty.querySelector("span").textContent = "Întrebările generate cu AI apar aici până sunt aprobate sau respinse.";
  }
}

async function loadQuestions() {
  if (loading) return;
  loading = true;
  elements.refresh.disabled = true;
  elements.summary.textContent = "Se încarcă întrebările...";
  setMessage();
  try {
    const results = await Promise.all(Object.entries(questionTypes).map(async ([type, config]) => {
      const contentColumns = config.kind === "pairs" ? "pairs" : "text,options";
      const { data, error } = await supabase
        .from(config.table)
        .select(`id,${contentColumns},chapter,difficulty,book,source_references,status,added_by,created_at`)
        .eq("status", "pending_review")
        .order("created_at", { ascending: true })
        .limit(2000);
      if (error) throw new Error(`${config.label}: ${error.message}`);
      return (data || []).map((row) => ({ ...row, type, key: `${type}:${row.id}` }));
    }));

    questions = results.flat().sort((left, right) => {
      const bookOrder = String(left.book || "").localeCompare(String(right.book || ""), "ro");
      return bookOrder || Number(left.chapter || 0) - Number(right.chapter || 0)
        || String(left.created_at || "").localeCompare(String(right.created_at || ""));
    });

    const selectedBook = elements.book.value;
    const books = [...new Set(questions.map((question) => question.book).filter(Boolean))]
      .sort((left, right) => left.localeCompare(right, "ro"));
    elements.book.innerHTML = '<option value="">Toate cărțile</option>'
      + books.map((book) => `<option value="${escapeHtml(book)}">${escapeHtml(book)}</option>`).join("");
    if (books.includes(selectedBook)) elements.book.value = selectedBook;
    render();
  } catch (error) {
    console.error(error);
    questions = [];
    elements.list.replaceChildren();
    elements.empty.hidden = true;
    elements.summary.textContent = "Întrebările nu au putut fi încărcate.";
    setMessage(error?.message || "A apărut o eroare la încărcarea cozii.", "error");
  } finally {
    loading = false;
    elements.refresh.disabled = false;
  }
}

async function changeStatus(question, status, button) {
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
    questions = questions.filter((item) => item.key !== question.key);
    setMessage(status === "active" ? "Întrebarea a fost aprobată și este activă." : "Întrebarea a fost respinsă și arhivată.", "success");
    render();
  } catch (error) {
    console.error(error);
    setMessage(error?.message || "Statusul întrebării nu a putut fi schimbat.", "error");
    button.disabled = false;
  }
}

async function init() {
  await requireRole("instructor");
  elements.search.addEventListener("input", render);
  elements.book.addEventListener("change", render);
  elements.type.addEventListener("change", render);
  elements.refresh.addEventListener("click", loadQuestions);
  elements.list.addEventListener("click", async (event) => {
    const button = event.target.closest("button[data-action]");
    if (!button) return;
    const card = button.closest("[data-question-key]");
    const question = questions.find((item) => item.key === card?.dataset.questionKey);
    if (!question) return;
    await changeStatus(question, button.dataset.action === "approve" ? "active" : "archived", button);
  });
  await loadQuestions();
}

init();
