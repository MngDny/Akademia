import { supabase } from "../../core/supabaseClient.js";
import { requireRole } from "../../core/authGuard.js";
import {
  BIBLE_BOOKS,
  mergeBookOptions,
  normalizeBookKey,
  readBooksFromUrl,
} from "../../core/bibleBooks.js";
import { mountQuestionReport } from "../../core/questionReports.js";

const TYPE_META = {
  tf: { table: "questions_tf", title: "Adevărat / Fals" },
  abc_one: { table: "questions_abc_one", title: "Un singur răspuns" },
  match: { table: "questions_match", title: "Asociere" },
  abc_multi: { table: "questions_abc_multi", title: "Răspunsuri multiple" },
};

const TYPE_ORDER = ["tf", "abc_one", "match", "abc_multi"];
const MIN_MATCH_PAIRS = 2;
const STORAGE_KEY = "akademia.learning.progress.v1";

const els = {
  learningBookSearch: document.getElementById("learningBookSearch"),
  learningBookList: document.getElementById("learningBookList"),
  learningBookInfo: document.getElementById("learningBookInfo"),
  selectedLearningBookChips: document.getElementById("selectedLearningBookChips"),
  learningSelectAllBtn: document.getElementById("learningSelectAllBtn"),
  learningClearBtn: document.getElementById("learningClearBtn"),
  learningStartBtn: document.getElementById("learningStartBtn"),
  learningStatus: document.getElementById("learningStatus"),
  learningMeta: document.getElementById("learningMeta"),
  learningQuestionText: document.getElementById("learningQuestionText"),
  learningAnswerHost: document.getElementById("learningAnswerHost"),
  learningCheckBtn: document.getElementById("learningCheckBtn"),
  learningPrevBtn: document.getElementById("learningPrevBtn"),
  learningNextBtn: document.getElementById("learningNextBtn"),
  reportQuestionBtn: document.getElementById("reportQuestionBtn"),
  questionReportDialog: document.getElementById("questionReportDialog"),
  closeQuestionReportBtn: document.getElementById("closeQuestionReportBtn"),
  cancelQuestionReportBtn: document.getElementById("cancelQuestionReportBtn"),
  questionReportForm: document.getElementById("questionReportForm"),
  questionReportQuestion: document.getElementById("questionReportQuestion"),
  questionReportReason: document.getElementById("questionReportReason"),
  questionReportMessage: document.getElementById("questionReportMessage"),
  questionReportStatus: document.getElementById("questionReportStatus"),
  learningNavigator: document.getElementById("learningNavigator"),
  learningProgressText: document.getElementById("learningProgressText"),
  learningProgressFill: document.getElementById("learningProgressFill"),
  learningStats: document.getElementById("learningStats"),
  learningModeBtns: Array.from(document.querySelectorAll(".learning-mode-btn")),
};

const state = {
  studentId: "",
  username: "",
  accessToken: "",
  selectedBooks: new Set(),
  books: [],
  questions: [],
  answers: {},
  statuses: {},
  currentKey: "",
  mode: "all",
};

let reportControl = { refresh: () => {} };

function questionKey(question) {
  return `${question.type}:${question.id}`;
}

function normalizeBookName(value) {
  return String(value || "").trim();
}

async function fetchLearningData(action, params = {}) {
  const query = new URLSearchParams({ action });
  for (const [key, value] of Object.entries(params)) {
    query.set(key, Array.isArray(value) ? JSON.stringify(value) : value);
  }
  const qs = query.toString();
  const response = await fetch(`/.netlify/functions/learning-data?${qs}`, {
    method: "GET",
    headers: {
      Authorization: `Bearer ${state.accessToken}`,
    },
  });

  const data = await response.json();
  if (!response.ok) {
    throw new Error(data?.error || "Nu am putut încărca datele pentru mediu de învățare.");
  }

  return data;
}

function normalizeSearch(value) {
  return String(value || "")
    .toLowerCase()
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "");
}

function shuffle(array) {
  const arr = [...array];
  for (let i = arr.length - 1; i > 0; i -= 1) {
    const j = Math.floor(Math.random() * (i + 1));
    [arr[i], arr[j]] = [arr[j], arr[i]];
  }
  return arr;
}

function parseOptions(options) {
  if (!Array.isArray(options)) return [];
  return options.map((opt) => {
    if (typeof opt === "string") return { text: opt, correct: false };
    return {
      text: opt?.text ?? opt?.label ?? "",
      correct: Boolean(opt?.correct),
    };
  });
}

function normalizeQuestion(type, row) {
  if (type === "match") {
    const pairs = Array.isArray(row?.pairs) ? row.pairs : [];
    if (pairs.length < MIN_MATCH_PAIRS) return null;

    const normalizedPairs = pairs
      .map((p) => ({
        left: p.left ?? p.stanga ?? "",
        right: p.right ?? p.dreapta ?? "",
      }))
      .filter((p) => String(p.left || "").trim() && String(p.right || "").trim());

    if (normalizedPairs.length < MIN_MATCH_PAIRS) return null;

    return {
      id: row.id,
      type,
      prompt: `Asociaza corect perechile (${row.book || "-"}, cap. ${row.chapter ?? "-"})`,
      kind: "pairs",
      pairs: normalizedPairs,
      matchOptions: shuffle(
        normalizedPairs.map((p) => p.right).filter(Boolean),
      ),
      meta: row,
    };
  }

  return {
    id: row.id,
    type,
    prompt: row.text || "Intrebare fara text",
    kind: "options",
    options: parseOptions(row.options),
    multi: type === "abc_multi",
    meta: row,
  };
}

function getStoredProgress() {
  try {
    const raw = window.localStorage.getItem(STORAGE_KEY);
    if (!raw) return {};
    const parsed = JSON.parse(raw);
    return parsed && typeof parsed === "object" ? parsed : {};
  } catch {
    return {};
  }
}

function saveStoredProgress(progress) {
  try {
    window.localStorage.setItem(STORAGE_KEY, JSON.stringify(progress));
  } catch {
    // ignore storage failures
  }
}

function persistCurrentBookProgress() {
  if (!state.selectedBooks.size) return;

  const progress = getStoredProgress();
  progress[sessionBookKey()] = {
    answers: state.answers,
    statuses: state.statuses,
    updatedAt: new Date().toISOString(),
  };

  saveStoredProgress(progress);
}

function restoreCurrentBookProgress() {
  const progress = getStoredProgress();
  const entry = progress[sessionBookKey()];

  if (!entry || typeof entry !== "object") {
    state.answers = {};
    state.statuses = {};
    return;
  }

  const validKeys = new Set(state.questions.map((q) => questionKey(q)));
  const answers = entry.answers && typeof entry.answers === "object" ? entry.answers : {};
  const statuses = entry.statuses && typeof entry.statuses === "object" ? entry.statuses : {};

  state.answers = Object.fromEntries(Object.entries(answers).filter(([key]) => validKeys.has(key)));
  state.statuses = Object.fromEntries(Object.entries(statuses).filter(([key]) => validKeys.has(key)));
}

function sessionBookKey() {
  return [...state.selectedBooks]
    .sort((a, b) => normalizeBookKey(a).localeCompare(normalizeBookKey(b)))
    .join("|");
}

function getFilteredQuestions() {
  if (state.mode === "all") return state.questions;

  return state.questions.filter((question) => {
    const status = state.statuses[questionKey(question)] || "unanswered";
    if (state.mode === "wrong") return status === "wrong";
    if (state.mode === "correct") return status === "correct";
    return status === "unanswered";
  });
}

function ensureCurrentQuestion() {
  const filtered = getFilteredQuestions();
  if (!filtered.length) {
    state.currentKey = "";
    return;
  }

  const stillExists = filtered.some((q) => questionKey(q) === state.currentKey);
  if (!stillExists) {
    state.currentKey = questionKey(filtered[0]);
  }
}

function getCurrentQuestion() {
  const filtered = getFilteredQuestions();
  return filtered.find((q) => questionKey(q) === state.currentKey) || null;
}

function getQuestionStatus(question) {
  return state.statuses[questionKey(question)] || "unanswered";
}

function evaluateQuestion(question, answer) {
  if (question.kind === "pairs") {
    if (!answer || typeof answer !== "object") return false;

    return question.pairs.every((pair, idx) => {
      const v = answer[String(idx)] ?? answer[idx];
      return String(v || "") === String(pair.right);
    });
  }

  const correctIndexes = question.options
    .map((opt, idx) => ({ idx, correct: Boolean(opt.correct) }))
    .filter((o) => o.correct)
    .map((o) => o.idx);

  if (question.multi) {
    const selected = Array.isArray(answer) ? [...answer].sort((a, b) => a - b) : [];
    const correct = [...correctIndexes].sort((a, b) => a - b);
    if (selected.length !== correct.length) return false;
    return selected.every((value, i) => value === correct[i]);
  }

  return Number(answer) === Number(correctIndexes[0]);
}

function getOptionText(question, idx) {
  return question.options?.[idx]?.text || `Opțiunea ${idx + 1}`;
}

function renderBooks() {
  const host = els.learningBookList;
  if (!host) return;

  const query = normalizeSearch(els.learningBookSearch?.value || "");
  const filtered = query
    ? state.books.filter((book) => normalizeSearch(book).includes(query))
    : state.books;

  host.innerHTML = "";

  if (!state.books.length) {
    host.innerHTML = '<p class="learning-empty">Nu există cărți disponibile.</p>';
    return;
  }

  if (!filtered.length) {
    host.innerHTML = '<p class="learning-empty">Nicio carte găsită. Încearcă altă căutare.</p>';
    return;
  }

  filtered.forEach((book) => {
    const label = document.createElement("label");
    label.className = "book-check-item";
    const checkbox = document.createElement("input");
    checkbox.type = "checkbox";
    checkbox.checked = state.selectedBooks.has(book);
    checkbox.setAttribute("aria-label", `Selectează ${book}`);
    checkbox.addEventListener("change", () => {
      if (checkbox.checked) state.selectedBooks.add(book);
      else state.selectedBooks.delete(book);
      persistSelectedBooks();
      renderBooks();
      updateBookInfo();
    });
    const text = document.createElement("span");
    text.textContent = book;
    label.append(checkbox, text);
    host.appendChild(label);
  });
}

function updateBookInfo() {
  const selected = [...state.selectedBooks];
  if (els.learningBookInfo) {
    els.learningBookInfo.textContent = selected.length
      ? `${selected.length} ${selected.length === 1 ? "carte" : "cărți"}`
      : "Niciuna";
  }
  renderSelectedBookChips();
}

function renderSelectedBookChips() {
  const host = els.selectedLearningBookChips;
  if (!host) return;

  host.replaceChildren();
  const selected = [...state.selectedBooks];
  if (!selected.length) {
    const empty = document.createElement("span");
    empty.className = "selected-books-empty";
    empty.textContent = "Alege cel puțin o carte.";
    host.append(empty);
    return;
  }

  selected.forEach((book) => {
    const chip = document.createElement("button");
    chip.type = "button";
    chip.className = "selected-book-chip";
    chip.setAttribute("aria-label", `Elimină ${book}`);

    const label = document.createElement("span");
    label.textContent = book;
    const remove = document.createElement("span");
    remove.className = "selected-book-remove";
    remove.setAttribute("aria-hidden", "true");
    remove.textContent = "×";

    chip.append(label, remove);
    chip.addEventListener("click", () => {
      state.selectedBooks.delete(book);
      persistSelectedBooks();
      renderBooks();
      updateBookInfo();
    });
    host.append(chip);
  });
}

function persistSelectedBooks() {
  try {
    window.localStorage.setItem("akademia.learning.selectedBooks.v1", JSON.stringify([...state.selectedBooks]));
  } catch {
    // Storage is optional; the selection still works for the current session.
  }
}

function restoreSelectedBooks(availableBooks) {
  let stored = [];
  try {
    stored = JSON.parse(window.localStorage.getItem("akademia.learning.selectedBooks.v1") || "[]");
  } catch {
    stored = [];
  }
  const urlBooks = readBooksFromUrl();
  const requested = urlBooks.length ? urlBooks : (Array.isArray(stored) ? stored : []);
  state.selectedBooks = new Set(requested
    .map((book) => availableBooks.find((item) => normalizeBookKey(item) === normalizeBookKey(book)))
    .filter(Boolean));
}

function renderProgress() {
  const total = state.questions.length;
  const correct = state.questions.filter((q) => getQuestionStatus(q) === "correct").length;
  const wrong = state.questions.filter((q) => getQuestionStatus(q) === "wrong").length;
  const unanswered = total - correct - wrong;
  const answered = correct + wrong;
  const percent = total ? Math.round((answered / total) * 100) : 0;

  if (els.learningProgressText) {
    els.learningProgressText.textContent = `${answered}/${total} răspunse`;
  }
  if (els.learningProgressFill) {
    els.learningProgressFill.style.width = `${percent}%`;
  }
  if (els.learningStats) {
    els.learningStats.textContent = `Corecte: ${correct} · Greșite: ${wrong} · Nerăspunse: ${unanswered}`;
  }
}

function renderNavigator() {
  const host = els.learningNavigator;
  if (!host) return;

  const filtered = getFilteredQuestions();
  host.innerHTML = "";

  if (!state.questions.length) {
    host.innerHTML = '<p class="learning-empty">Întrebările vor apărea aici după ce începi sesiunea.</p>';
    return;
  }

  if (!filtered.length) {
    host.innerHTML = '<p class="learning-empty">Nu există întrebări pentru filtrul curent.</p>';
    return;
  }

  filtered.forEach((question, idx) => {
    const key = questionKey(question);
    const status = getQuestionStatus(question);

    const btn = document.createElement("button");
    btn.type = "button";
    btn.className = `learning-nav-chip is-${status}${state.currentKey === key ? " is-current" : ""}`;
    btn.textContent = String(idx + 1);
    const statusLabel = { correct: "răspuns corect", wrong: "răspuns greșit", unanswered: "fără răspuns" }[status];
    btn.setAttribute("aria-label", `Întrebarea ${idx + 1}, ${statusLabel}`);
    if (state.currentKey === key) btn.setAttribute("aria-current", "step");
    btn.title = `${TYPE_META[question.type]?.title || question.type} · ${({ correct: "Corect", wrong: "Greșit", unanswered: "Fără răspuns" })[status]}`;
    btn.addEventListener("click", () => {
      state.currentKey = key;
      renderAll();
    });

    host.appendChild(btn);
  });
}

function renderAnswerHost(question) {
  if (!question) {
    els.learningAnswerHost.innerHTML = "";
    return;
  }

  const key = questionKey(question);
  const saved = state.answers[key];

  if (question.kind === "pairs") {
    const optionsHtml = question.matchOptions
      .map((opt) => `<option value="${opt}">${opt}</option>`)
      .join("");

    const rows = question.pairs
      .map((pair, index) => {
        const value = saved?.[String(index)] || "";
        return `
          <div class="pair-item">
            <p class="pair-left">${pair.left}</p>
            <select class="pair-select" data-index="${index}">
              <option value="">Alege varianta...</option>
              ${optionsHtml}
            </select>
          </div>
        `;
      })
      .join("");

    els.learningAnswerHost.innerHTML = `<div class="pair-list">${rows}</div>`;

    els.learningAnswerHost.querySelectorAll(".pair-select").forEach((el) => {
      const index = String(el.dataset.index);
      const value = saved?.[index] || "";
      if (value) el.value = value;

      el.addEventListener("change", () => {
        const current = { ...(state.answers[key] || {}) };
        current[index] = el.value;
        state.answers[key] = current;
        persistCurrentBookProgress();
      });
    });

    return;
  }

  const isMulti = question.multi;
  const options = question.options
    .map((opt, idx) => {
      const checked = isMulti
        ? Array.isArray(saved) && saved.includes(idx)
        : Number(saved) === idx;

      const input = isMulti
        ? `<input class="option-input is-multi" type="checkbox" data-index="${idx}" ${checked ? "checked" : ""} />`
        : `<input class="option-input is-single" type="radio" name="learningAnswer" value="${idx}" ${checked ? "checked" : ""} />`;

      return `
        <label class="option-item${checked ? " is-selected" : ""}">
          ${input}
          <span class="option-content">${opt.text || `Opțiunea ${idx + 1}`}</span>
        </label>
      `;
    })
    .join("");

  els.learningAnswerHost.innerHTML = `<div class="option-list">${options}</div>`;

  const updateClasses = () => {
    els.learningAnswerHost.querySelectorAll(".option-item").forEach((label) => {
      const input = label.querySelector(".option-input");
      label.classList.toggle("is-selected", Boolean(input?.checked));
    });
  };

  if (isMulti) {
    els.learningAnswerHost.querySelectorAll("input[type='checkbox']").forEach((input) => {
      input.addEventListener("change", () => {
        const values = Array.from(
          els.learningAnswerHost.querySelectorAll("input[type='checkbox']:checked"),
        ).map((el) => Number(el.dataset.index));
        state.answers[key] = values;
        persistCurrentBookProgress();
        updateClasses();
      });
    });
  } else {
    els.learningAnswerHost.querySelectorAll("input[type='radio']").forEach((input) => {
      input.addEventListener("change", () => {
        state.answers[key] = Number(input.value);
        persistCurrentBookProgress();
        updateClasses();
      });
    });
  }
}

function renderCurrentQuestion() {
  ensureCurrentQuestion();
  const current = getCurrentQuestion();

  if (!current) {
    els.learningMeta.textContent = state.questions.length ? "Nu există întrebări pentru filtrul selectat." : "Alege una sau mai multe cărți și apasă Începe să exersezi.";
    els.learningQuestionText.textContent = state.questions.length ? "Schimbă filtrul pentru a continua." : "Pregătit să descoperi ceva nou?";
    els.learningAnswerHost.innerHTML = "";
    els.learningCheckBtn.disabled = true;
    els.learningPrevBtn.disabled = true;
    els.learningNextBtn.disabled = true;
    reportControl.refresh();
    return;
  }

  const filtered = getFilteredQuestions();
  const idx = filtered.findIndex((q) => questionKey(q) === state.currentKey);
  const status = getQuestionStatus(current);

  const statusLabel = { correct: "Corect", wrong: "Greșit", unanswered: "Fără răspuns" }[status];
  els.learningMeta.textContent = `Întrebarea ${idx + 1} din ${filtered.length} · ${TYPE_META[current.type].title} · ${statusLabel}`;
  els.learningQuestionText.textContent = current.prompt;

  renderAnswerHost(current);

  els.learningCheckBtn.disabled = false;
  els.learningPrevBtn.disabled = idx <= 0;
  els.learningNextBtn.disabled = idx >= filtered.length - 1;
  reportControl.refresh();
}

function renderAll() {
  renderProgress();
  renderNavigator();
  renderCurrentQuestion();

  els.learningModeBtns.forEach((btn) => {
    btn.classList.toggle("is-active", btn.dataset.mode === state.mode);
    btn.setAttribute("aria-pressed", String(btn.dataset.mode === state.mode));
  });
}

function goToRelativeQuestion(step) {
  const filtered = getFilteredQuestions();
  if (!filtered.length) return;

  const idx = filtered.findIndex((q) => questionKey(q) === state.currentKey);
  if (idx < 0) return;

  const next = idx + step;
  if (next < 0 || next >= filtered.length) return;

  state.currentKey = questionKey(filtered[next]);
  renderAll();
}

function checkCurrentAnswer() {
  const question = getCurrentQuestion();
  if (!question) return;

  const key = questionKey(question);
  const answer = state.answers[key];

  const hasAnswer = question.kind === "pairs"
    ? answer && typeof answer === "object" && Object.values(answer).some((v) => String(v || "").trim())
    : question.multi
      ? Array.isArray(answer)
      : Number.isInteger(answer);

  if (!hasAnswer) {
    els.learningStatus.textContent = "Alege un răspuns înainte de verificare.";
    return;
  }

  const isCorrect = evaluateQuestion(question, answer);
  state.statuses[key] = isCorrect ? "correct" : "wrong";
  persistCurrentBookProgress();

  els.learningStatus.textContent = isCorrect
    ? "Corect. Foarte bine!"
    : "Încă un pas de învățare. Revino la această întrebare în filtrul Greșite.";

  renderAll();
}

async function loadBooks() {
  els.learningStatus.textContent = "Se încarcă lista de cărți…";

  try {
    const data = await fetchLearningData("books");
    state.books = (Array.isArray(data?.books) ? data.books : [])
      .map((book) => normalizeBookName(book))
      .filter(Boolean);
    state.books = mergeBookOptions(state.books);
  } catch (error) {
    console.error(error);
    state.books = [...BIBLE_BOOKS];
    els.learningStatus.textContent = "Lista locală cu cele 66 de cărți este disponibilă.";
  }

  restoreSelectedBooks(state.books);

  renderBooks();
  updateBookInfo();
  if (!els.learningStatus.textContent.includes("Lista locală")) {
    els.learningStatus.textContent = "";
  }
}

async function startLearning() {
  if (els.learningStartBtn.disabled) return;
  els.learningStatus.textContent = "";

  const selectedBooks = [...state.selectedBooks];
  if (!selectedBooks.length) {
    els.learningStatus.textContent = "Alege cel puțin o carte înainte de a începe.";
    return;
  }

  els.learningStatus.textContent = "Se pregătesc întrebările…";
  els.learningStartBtn.disabled = true;
  els.learningStartBtn.textContent = "Se pregătește sesiunea…";

  try {
    const data = await fetchLearningData("questions", { books: selectedBooks });
    const rowsByType = data?.rowsByType || {};

    const all = TYPE_ORDER.flatMap((type) => {
      const rows = Array.isArray(rowsByType[type]) ? rowsByType[type] : [];
      return rows
        .map((row) => normalizeQuestion(type, row))
        .filter(Boolean);
    });

    state.questions = shuffle(all);

    if (!state.questions.length) {
      state.answers = {};
      state.statuses = {};
      state.currentKey = "";
      renderAll();
      els.learningStatus.textContent = "Nu există întrebări pentru cărțile selectate.";
      return;
    }

    restoreCurrentBookProgress();
    state.currentKey = questionKey(state.questions[0]);
    ensureCurrentQuestion();
    renderAll();

    els.learningQuestionText.tabIndex = -1;
    els.learningQuestionText.focus();
    els.learningStatus.textContent = `Sesiune începută: ${state.questions.length} întrebări din ${selectedBooks.length} ${selectedBooks.length === 1 ? "carte" : "cărți"}.`;
  } catch (error) {
    console.error(error);
    els.learningStatus.textContent = error?.message || "Întrebările nu s-au încărcat. Încearcă din nou.";
  } finally {
    els.learningStartBtn.disabled = false;
    els.learningStartBtn.textContent = "Începe să exersezi";
  }
}

function bindActions() {
  els.learningBookSearch?.addEventListener("input", () => {
    renderBooks();
  });

  els.learningSelectAllBtn?.addEventListener("click", () => {
    state.selectedBooks = new Set(state.books);
    persistSelectedBooks();
    renderBooks();
    updateBookInfo();
  });

  els.learningClearBtn?.addEventListener("click", () => {
    state.selectedBooks.clear();
    persistSelectedBooks();
    renderBooks();
    updateBookInfo();
  });

  els.learningStartBtn?.addEventListener("click", startLearning);
  els.learningCheckBtn?.addEventListener("click", checkCurrentAnswer);
  els.learningPrevBtn?.addEventListener("click", () => goToRelativeQuestion(-1));
  els.learningNextBtn?.addEventListener("click", () => goToRelativeQuestion(1));

  els.learningModeBtns.forEach((btn) => {
    btn.addEventListener("click", () => {
      state.mode = btn.dataset.mode || "all";
      renderAll();
    });
  });
}

async function init() {
  const { session } = await requireRole("student");
  state.studentId = session?.user?.id || "";
  state.username = session?.user?.user_metadata?.username || "student";
  state.accessToken = session?.access_token || "";

  reportControl = mountQuestionReport({
    supabase,
    button: els.reportQuestionBtn,
    dialog: els.questionReportDialog,
    form: els.questionReportForm,
    questionLabel: els.questionReportQuestion,
    reason: els.questionReportReason,
    message: els.questionReportMessage,
    status: els.questionReportStatus,
    closeButton: els.closeQuestionReportBtn,
    cancelButton: els.cancelQuestionReportBtn,
    getQuestion: () => getCurrentQuestion(),
    getStudent: () => ({ id: state.studentId, username: state.username }),
  });

  bindActions();
  await loadBooks();
  renderAll();
}

init().catch(() => { els.learningStatus.textContent = "Nu am putut încărca sesiunea. Reîncarcă pagina pentru a încerca din nou."; });
