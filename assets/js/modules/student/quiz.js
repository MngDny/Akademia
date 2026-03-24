import { supabase } from "../../core/supabaseClient.js";
import { requireRole } from "../../core/authGuard.js";
import {
  ATTEMPTS_TABLE,
  OFFICIAL_BONUS_POINTS,
  POINTS,
  TEST_STRUCTURE,
  TYPE_ORDER,
  getTestMaxPoints,
} from "./contestConfig.js";

const TYPE_META = {
  tf: { table: "questions_tf", title: "Adevărat / Fals" },
  abc_one: { table: "questions_abc_one", title: "ABC One" },
  match: { table: "questions_match", title: "Asociere" },
  abc_multi: { table: "questions_abc_multi", title: "ABC Multi" },
};

const REQUIRED_MATCH_PAIRS = 5;
const BOOK_SELECTION_STORAGE_KEY = "akademia.quiz.selectedBooks.v1";

const els = {
  timer: document.getElementById("timerMinutes"),
  booksSearch: document.getElementById("booksSearch"),
  booksChecklist: document.getElementById("booksChecklist"),
  selectAllBooksBtn: document.getElementById("selectAllBooksBtn"),
  clearBooksBtn: document.getElementById("clearBooksBtn"),
  booksInfo: document.getElementById("booksInfo"),
  startBtn: document.getElementById("startBtn"),
  setupMessage: document.getElementById("setupMessage"),
  meta: document.getElementById("quizMeta"),
  questionText: document.getElementById("questionText"),
  answerHost: document.getElementById("answerHost"),
  prevBtn: document.getElementById("prevBtn"),
  nextBtn: document.getElementById("nextBtn"),
  submitBtn: document.getElementById("submitBtn"),
  resultHost: document.getElementById("resultHost"),
};

const state = {
  studentId: "",
  username: "",
  questions: [],
  answers: {},
  current: 0,
  deadline: 0,
  startTime: 0,
  timerId: null,
  finished: false,
  availableBooks: [],
  selectedBooks: new Set(),
};

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

function normalizeRow(type, row) {
  if (type === "match") {
    const pairs = Array.isArray(row.pairs) ? row.pairs : [];
    return {
      id: row.id,
      type,
      prompt: `Asociază corect perechile (capitol ${row.chapter ?? "-"})`,
      kind: "pairs",
      pairs: pairs.slice(0, REQUIRED_MATCH_PAIRS).map((p) => ({
        left: p.left ?? p.stanga ?? "",
        right: p.right ?? p.dreapta ?? "",
      })),
      meta: row,
    };
  }

  return {
    id: row.id,
    type,
    prompt: row.text || "Întrebare fără text",
    kind: "options",
    options: parseOptions(row.options),
    multi: type === "abc_multi",
    meta: row,
  };
}

function normalizeBookName(value) {
  return String(value || "").trim();
}

function loadStoredSelectedBooks() {
  try {
    const raw = window.localStorage.getItem(BOOK_SELECTION_STORAGE_KEY);
    if (!raw) return [];

    const parsed = JSON.parse(raw);
    if (!Array.isArray(parsed)) return [];

    return parsed
      .map((value) => normalizeBookName(value))
      .filter(Boolean);
  } catch (_error) {
    return [];
  }
}

function persistSelectedBooks() {
  try {
    window.localStorage.setItem(
      BOOK_SELECTION_STORAGE_KEY,
      JSON.stringify([...state.selectedBooks]),
    );
  } catch (_error) {
    // localStorage may be blocked; continue without persistence
  }
}

function isValidBookName(value) {
  const v = normalizeBookName(value);
  if (!v) return false;
  if (/^\d+$/.test(v)) return false;
  if (v.length < 2) return false;
  return /[A-Za-zĂÂÎȘȚăâîșț]/.test(v);
}

function applyBookFilter(query, selectedBooks) {
  const safeBooks = Array.isArray(selectedBooks)
    ? selectedBooks.map(normalizeBookName).filter(Boolean)
    : [];

  if (!safeBooks.length) {
    return query;
  }

  return query.in("book", safeBooks);
}

function getSelectedBooks() {
  return [...state.selectedBooks];
}

function updateBooksInfo() {
  if (!els.booksInfo) return;

  const selected = getSelectedBooks();
  const total = state.availableBooks.length;

  if (!total) {
    els.booksInfo.textContent = "Nu există cărți disponibile în baza de întrebări.";
    return;
  }

  if (!selected.length) {
    els.booksInfo.textContent = `Nicio carte selectată. Selectează cel puțin una din ${total}.`;
    return;
  }

  const preview = selected.slice(0, 4).join(", ");
  const more = selected.length > 4 ? ` +${selected.length - 4} altele` : "";
  els.booksInfo.textContent = `Selectate ${selected.length}/${total}: ${preview}${more}`;
}

function renderBooksChecklist() {
  const host = els.booksChecklist;
  if (!host) return;

  const allBooks = state.availableBooks;
  const query = normalizeBookName(els.booksSearch?.value || "").toLowerCase();
  const filtered = query
    ? allBooks.filter((book) => book.toLowerCase().includes(query))
    : allBooks;

  host.innerHTML = "";

  if (!allBooks.length) {
    const empty = document.createElement("p");
    empty.className = "books-checklist-empty";
    empty.textContent = "Nu există cărți disponibile.";
    host.appendChild(empty);
    updateBooksInfo();
    return;
  }

  if (!filtered.length) {
    const empty = document.createElement("p");
    empty.className = "books-checklist-empty";
    empty.textContent = "Nicio carte nu corespunde căutării.";
    host.appendChild(empty);
    updateBooksInfo();
    return;
  }

  filtered.forEach((book) => {
    const label = document.createElement("label");
    label.className = "book-check-item";

    const checkbox = document.createElement("input");
    checkbox.type = "checkbox";
    checkbox.checked = state.selectedBooks.has(book);
    checkbox.addEventListener("change", () => {
      if (checkbox.checked) {
        state.selectedBooks.add(book);
      } else {
        state.selectedBooks.delete(book);
      }
      persistSelectedBooks();
      updateBooksInfo();
    });

    const text = document.createElement("span");
    text.textContent = book;

    label.appendChild(checkbox);
    label.appendChild(text);
    host.appendChild(label);
  });

  updateBooksInfo();
}

async function fetchBooksForType(type) {
  const table = TYPE_META[type].table;

  const { data: activeRows, error: activeError } = await supabase
    .from(table)
    .select("book")
    .eq("status", "active")
    .limit(500);

  let rows = Array.isArray(activeRows) ? activeRows : [];

  if (activeError || rows.length === 0) {
    const { data, error } = await supabase
      .from(table)
      .select("book")
      .limit(500);

    if (error) throw error;
    rows = Array.isArray(data) ? data : [];
  }

  return rows
    .map((row) => normalizeBookName(row?.book))
    .filter(isValidBookName);
}

async function loadAvailableBooks() {
  if (els.booksChecklist) {
    els.booksChecklist.innerHTML = '<p class="books-checklist-empty">Se încarcă lista de cărți...</p>';
  }

  const groups = await Promise.all(TYPE_ORDER.map((type) => fetchBooksForType(type)));
  const allBooks = groups.flat();

  const uniqueBooks = [...new Set(allBooks)]
    .sort((a, b) => a.localeCompare(b, "ro"));

  state.availableBooks = uniqueBooks;
  const stored = loadStoredSelectedBooks();
  const validStored = stored.filter((book) => uniqueBooks.includes(book));
  state.selectedBooks = new Set(validStored);
  renderBooksChecklist();
}

async function fetchQuestions(type, needCount, selectedBooks = []) {
  const table = TYPE_META[type].table;

  const normalizeRowsByType = (rows) => {
    const safeRows = Array.isArray(rows) ? rows : [];
    if (type !== "match") return safeRows;

    return safeRows.filter((row) => {
      const pairs = Array.isArray(row?.pairs) ? row.pairs : [];
      return pairs.length >= REQUIRED_MATCH_PAIRS;
    });
  };

  let activeQuery = supabase
    .from(table)
    .select("*")
    .eq("status", "active")
    .order("created_at", { ascending: false })
    .limit(300);

  activeQuery = applyBookFilter(activeQuery, selectedBooks);

  const { data: activeRows, error: activeError } = await activeQuery;

  let rows = normalizeRowsByType(activeRows);

  if (activeError || rows.length < needCount) {
    let fallbackQuery = supabase
      .from(table)
      .select("*")
      .order("created_at", { ascending: false })
      .limit(300);

    fallbackQuery = applyBookFilter(fallbackQuery, selectedBooks);

    const { data, error } = await fallbackQuery;

    if (error) throw error;
    rows = normalizeRowsByType(data);
  }

  if (rows.length < needCount) {
    const filterLabel = Array.isArray(selectedBooks) && selectedBooks.length
      ? ` (filtru cărți: ${selectedBooks.join(", ")})`
      : "";
    throw new Error(`Nu există suficiente întrebări pentru ${TYPE_META[type].title}. Necesare: ${needCount}, disponibile: ${rows.length}.${filterLabel}`);
  }

  return shuffle(rows).slice(0, needCount).map((row) => normalizeRow(type, row));
}

async function buildOfficialTest(selectedBooks) {
  const chunks = [];

  for (const type of TYPE_ORDER) {
    const need = TEST_STRUCTURE[type];
    const questions = await fetchQuestions(type, need, selectedBooks);
    chunks.push(...questions);
  }

  return chunks;
}

function saveAnswer(questionIndex, value) {
  state.answers[questionIndex] = value;
  updateSubmitState();
}

function getOptionText(question, index) {
  const opt = question.options?.[Number(index)];
  return opt?.text || `Opțiunea ${Number(index) + 1}`;
}

function getUserAnswerLabel(question, answer) {
  if (question.kind === "pairs") {
    if (!answer || typeof answer !== "object") return "(fără răspuns)";
    return question.pairs
      .map((pair, i) => `${pair.left} -> ${answer[String(i)] || "(necompletat)"}`)
      .join("; ");
  }

  if (question.multi) {
    if (!Array.isArray(answer) || !answer.length) return "(fără răspuns)";
    return answer.map((idx) => getOptionText(question, idx)).join(", ");
  }

  if (!Number.isInteger(answer)) return "(fără răspuns)";
  return getOptionText(question, answer);
}

function getCorrectAnswerLabel(question) {
  if (question.kind === "pairs") {
    return question.pairs.map((pair) => `${pair.left} -> ${pair.right}`).join("; ");
  }

  const correctIndexes = question.options
    .map((opt, index) => ({ index, correct: Boolean(opt.correct) }))
    .filter((item) => item.correct)
    .map((item) => item.index);

  if (!correctIndexes.length) return "(nespecificat)";
  return correctIndexes.map((idx) => getOptionText(question, idx)).join(", ");
}

function renderOptionsQuestion(question, idx) {
  const hasSavedAnswer = Object.prototype.hasOwnProperty.call(state.answers, idx);
  const saved = hasSavedAnswer ? state.answers[idx] : (question.multi ? [] : null);

  if (question.multi && !hasSavedAnswer) {
    saveAnswer(idx, []);
  }

  const items = question.options
    .map((opt, i) => {
      const isChecked = question.multi
        ? Array.isArray(saved) && saved.includes(i)
        : saved === i;

      const input = question.multi
        ? `<input class="option-input is-multi" type="checkbox" data-index="${i}" ${isChecked ? "checked" : ""} />`
        : `<input class="option-input is-single" type="radio" name="currentAnswer" value="${i}" ${isChecked ? "checked" : ""} />`;

      return `
        <label class="option-item${isChecked ? " is-selected" : ""}">
          ${input}
          <span class="option-content">${opt.text || `Opțiunea ${i + 1}`}</span>
        </label>
      `;
    })
    .join("");

  els.answerHost.innerHTML = `<div class="option-list">${items}</div>`;

  const updateSelectedClasses = () => {
    els.answerHost.querySelectorAll(".option-item").forEach((label) => {
      const input = label.querySelector(".option-input");
      label.classList.toggle("is-selected", Boolean(input?.checked));
    });
  };

  if (question.multi) {
    els.answerHost.querySelectorAll("input[type='checkbox']").forEach((el) => {
      el.addEventListener("change", () => {
        const selected = Array.from(els.answerHost.querySelectorAll("input[type='checkbox']:checked")).map((c) => Number(c.dataset.index));
        saveAnswer(idx, selected);
        updateSelectedClasses();
      });
    });
  } else {
    els.answerHost.querySelectorAll("input[type='radio']").forEach((el) => {
      el.addEventListener("change", () => {
        saveAnswer(idx, Number(el.value));
        updateSelectedClasses();
      });
    });
  }

  updateSelectedClasses();
}

function renderPairsQuestion(question, idx) {
  const saved = state.answers[idx] || {};
  const rightOptions = shuffle(question.pairs.map((pair) => pair.right));

  const rows = question.pairs
    .map((pair, i) => {
      const options = rightOptions
        .map((right) => `<option value="${right}" ${saved[i] === right ? "selected" : ""}>${right}</option>`)
        .join("");

      return `
        <div class="pair-item">
          <p class="pair-left">${pair.left}</p>
          <select class="pair-select" data-index="${i}">
            <option value="">Alege varianta...</option>
            ${options}
          </select>
        </div>
      `;
    })
    .join("");

  els.answerHost.innerHTML = `<div class="pair-list">${rows}</div>`;

  els.answerHost.querySelectorAll(".pair-select").forEach((sel) => {
    sel.addEventListener("change", () => {
      const current = { ...(state.answers[idx] || {}) };
      current[sel.dataset.index] = sel.value;
      saveAnswer(idx, current);
    });
  });
}

function renderCurrentQuestion() {
  const question = state.questions[state.current];
  if (!question) return;

  els.meta.textContent = `Întrebarea ${state.current + 1} din ${state.questions.length} | Tip: ${TYPE_META[question.type].title}`;
  els.questionText.textContent = question.prompt;

  if (question.kind === "pairs") {
    renderPairsQuestion(question, state.current);
  } else {
    renderOptionsQuestion(question, state.current);
  }

  els.prevBtn.disabled = state.current === 0 || state.finished;
  els.nextBtn.disabled = state.current >= state.questions.length - 1 || state.finished;
  updateSubmitState();
}

function isEqualSet(a, b) {
  if (a.length !== b.length) return false;
  const setA = new Set(a);
  return b.every((item) => setA.has(item));
}

function evaluateOptionsQuestion(question, answer) {
  const correctIndexes = question.options
    .map((opt, index) => ({ correct: Boolean(opt.correct), index }))
    .filter((item) => item.correct)
    .map((item) => item.index);

  if (question.multi) {
    const selected = Array.isArray(answer) ? answer : [];
    const isCorrect = isEqualSet(correctIndexes, selected);
    return { isCorrect, points: isCorrect ? POINTS.abc_multi : 0, correctPairs: 0 };
  }

  const isCorrect = correctIndexes.length ? Number(answer) === correctIndexes[0] : false;
  const points = question.type === "tf" ? (isCorrect ? POINTS.tf : 0) : (isCorrect ? POINTS.abc_one : 0);
  return { isCorrect, points, correctPairs: 0 };
}

function evaluatePairsQuestion(question, answer) {
  if (!answer || typeof answer !== "object") {
    return { isCorrect: false, points: 0, correctPairs: 0 };
  }

  const correctPairs = question.pairs.reduce((acc, pair, index) => {
    return acc + (answer[String(index)] === pair.right ? 1 : 0);
  }, 0);

  const points = Math.min(POINTS.matchMax, correctPairs * POINTS.matchPair);
  return {
    isCorrect: correctPairs === question.pairs.length,
    points,
    correctPairs,
  };
}

function isQuestionAnswered(question, index) {
  const answer = state.answers[index];

  if (question.kind === "pairs") {
    if (!answer || typeof answer !== "object") return false;
    const filled = question.pairs.filter((_, pairIndex) => {
      const value = answer[String(pairIndex)] ?? answer[pairIndex];
      return typeof value === "string" && value.trim().length > 0;
    }).length;

    return filled === question.pairs.length;
  }

  if (question.multi) {
    return Object.prototype.hasOwnProperty.call(state.answers, index)
      && Array.isArray(answer);
  }

  return Number.isInteger(answer);
}

function getUnansweredCount() {
  return state.questions.reduce((count, question, index) => {
    return count + (isQuestionAnswered(question, index) ? 0 : 1);
  }, 0);
}

function updateSubmitState() {
  const hasQuestions = state.questions.length > 0;
  const unanswered = hasQuestions ? getUnansweredCount() : 0;
  const canSubmit = hasQuestions && !state.finished && unanswered === 0;

  els.submitBtn.disabled = !canSubmit;
  if (state.finished) {
    els.submitBtn.textContent = "Test trimis";
  } else if (!hasQuestions) {
    els.submitBtn.textContent = "Trimite testul";
  } else if (canSubmit) {
    els.submitBtn.textContent = "Trimite testul";
  } else {
    els.submitBtn.textContent = `Completează toate întrebările (${unanswered} rămase)`;
  }

  els.submitBtn.title = canSubmit
    ? "Toate întrebările sunt completate."
    : (hasQuestions ? `Completează toate întrebările. Rămase: ${unanswered}` : "Pornește testul mai întâi.");
}

function stopTimer() {
  if (state.timerId) {
    clearInterval(state.timerId);
    state.timerId = null;
  }
}

async function persistAttempt(summary) {
  const payload = {
    student_auth_id: state.studentId,
    student_username: state.username,
    total_questions: summary.totalQuestions,
    total_correct_answers: summary.totalCorrect,
    points_total: summary.pointsTotal,
    max_points: summary.maxPoints,
    duration_seconds: summary.durationSeconds,
    tf_total: summary.tfTotal,
    tf_correct: summary.tfCorrect,
    abc_one_total: summary.abcOneTotal,
    abc_one_correct: summary.abcOneCorrect,
    abc_multi_total: summary.abcMultiTotal,
    abc_multi_correct: summary.abcMultiCorrect,
    match_pairs_total: summary.matchPairsTotal,
    match_pairs_correct: summary.matchPairsCorrect,
    breakdown: summary.breakdown,
  };

  const { error } = await supabase.from(ATTEMPTS_TABLE).insert(payload);
  if (error) throw error;
}

async function finishQuiz(reason = "manual") {
  if (state.finished) return;

  state.finished = true;
  stopTimer();

  const summary = {
    totalQuestions: state.questions.length,
    totalCorrect: 0,
    pointsTotal: 0,
    maxPoints: getTestMaxPoints(5),
    durationSeconds: Math.max(0, Math.round((Date.now() - state.startTime) / 1000)),
    tfTotal: TEST_STRUCTURE.tf,
    tfCorrect: 0,
    abcOneTotal: TEST_STRUCTURE.abc_one,
    abcOneCorrect: 0,
    abcMultiTotal: TEST_STRUCTURE.abc_multi,
    abcMultiCorrect: 0,
    matchPairsTotal: 5,
    matchPairsCorrect: 0,
    breakdown: [],
  };

  state.questions.forEach((question, index) => {
    const answer = state.answers[index];
    const evaluation = question.kind === "pairs"
      ? evaluatePairsQuestion(question, answer)
      : evaluateOptionsQuestion(question, answer);

    if (evaluation.isCorrect) {
      summary.totalCorrect += 1;
    }

    summary.pointsTotal += evaluation.points;

    if (question.type === "tf" && evaluation.isCorrect) summary.tfCorrect += 1;
    if (question.type === "abc_one" && evaluation.isCorrect) summary.abcOneCorrect += 1;
    if (question.type === "abc_multi" && evaluation.isCorrect) summary.abcMultiCorrect += 1;
    if (question.type === "match") {
      summary.matchPairsTotal = Math.max(summary.matchPairsTotal, question.pairs.length);
      summary.matchPairsCorrect = evaluation.correctPairs;
    }

    summary.breakdown.push({
      question_id: question.id,
      question_prompt: question.prompt,
      type: question.type,
      is_correct: evaluation.isCorrect,
      points: evaluation.points,
      correct_pairs: evaluation.correctPairs,
      user_answer: getUserAnswerLabel(question, answer),
      correct_answer: getCorrectAnswerLabel(question),
    });
  });

  const wrongAnswers = summary.breakdown.filter((item) => !item.is_correct);

  summary.maxPoints = (TEST_STRUCTURE.tf * POINTS.tf)
    + (TEST_STRUCTURE.abc_one * POINTS.abc_one)
    + (TEST_STRUCTURE.abc_multi * POINTS.abc_multi)
    + Math.min(POINTS.matchMax, summary.matchPairsTotal * POINTS.matchPair)
    + OFFICIAL_BONUS_POINTS;

  summary.pointsTotal += OFFICIAL_BONUS_POINTS;

  const pct = summary.maxPoints ? Math.round((summary.pointsTotal / summary.maxPoints) * 100) : 0;
  const klass = pct >= 80 ? "result-good" : pct >= 50 ? "result-mid" : "result-bad";
  const reasonText = reason === "timeout" ? "Timpul a expirat." : "Test trimis.";

  let persistMessage = "Rezultatul a fost salvat în baza de date.";
  try {
    await persistAttempt(summary);
  } catch (error) {
    console.error(error);
    persistMessage = "Rezultatul nu a putut fi salvat. Verifică SQL-ul pentru tabela student_test_attempts.";
  }

  els.resultHost.innerHTML = `
    <div class="card" style="max-width:100%;">
      <h3>Rezultat final</h3>
      <p class="${klass}">${reasonText} Ai obținut ${summary.pointsTotal}/${summary.maxPoints} puncte (${pct}%).</p>
      <p class="muted">Include bonus din oficiu: +${OFFICIAL_BONUS_POINTS} puncte.</p>
      <p class="muted">Corecte: ${summary.totalCorrect}/${summary.totalQuestions} | TF: ${summary.tfCorrect}/${summary.tfTotal}, ABC One: ${summary.abcOneCorrect}/${summary.abcOneTotal}, ABC Multi: ${summary.abcMultiCorrect}/${summary.abcMultiTotal}, Asociere: ${summary.matchPairsCorrect}/${summary.matchPairsTotal} perechi.</p>
      <p class="muted">${persistMessage}</p>
      ${wrongAnswers.length > 0 ? `
        <button id="toggleWrongBtn" class="btn danger" type="button">Vezi întrebări greșite (${wrongAnswers.length})</button>
        <div id="wrongReview" class="wrong-review" hidden>
          <p class="card-meta">Întrebări la care ai greșit:</p>
          <div class="wrong-list">
            ${wrongAnswers.map((item, idx) => `
              <div class="wrong-item">
                <p class="wrong-item-title">#${idx + 1} · ${TYPE_META[item.type]?.title || item.type}</p>
                <p class="wrong-item-text">${item.question_prompt}</p>
                <p class="wrong-answer-line"><strong>Răspunsul tău:</strong> ${item.user_answer}</p>
                <p class="wrong-answer-line"><strong>Răspuns corect:</strong> ${item.correct_answer}</p>
              </div>
            `).join("")}
          </div>
        </div>
      ` : ""}
      <div class="actions-row">
        <a class="btn" href="/portal/student/results.html">Vezi istoric</a>
        <a class="btn" href="/portal/student/leaderboard.html">Vezi clasament</a>
        <a class="btn primary" href="/portal/student/quiz.html">Încearcă din nou</a>
      </div>
    </div>
  `;

  renderCurrentQuestion();

  const toggleWrongBtn = document.getElementById("toggleWrongBtn");
  const wrongReview = document.getElementById("wrongReview");
  if (toggleWrongBtn && wrongReview) {
    toggleWrongBtn.addEventListener("click", () => {
      const isHidden = wrongReview.hasAttribute("hidden");
      if (isHidden) {
        wrongReview.removeAttribute("hidden");
        toggleWrongBtn.textContent = "Ascunde întrebări greșite";
      } else {
        wrongReview.setAttribute("hidden", "hidden");
        toggleWrongBtn.textContent = `Vezi întrebări greșite (${wrongAnswers.length})`;
      }
    });
  }
}

function startCountdown(minutes) {
  state.startTime = Date.now();
  state.deadline = state.startTime + minutes * 60 * 1000;

  stopTimer();

  state.timerId = setInterval(() => {
    const diff = state.deadline - Date.now();

    if (diff <= 0) {
      els.meta.textContent = "Timp rămas: 00:00";
      finishQuiz("timeout");
      return;
    }

    const mins = String(Math.floor(diff / 60000)).padStart(2, "0");
    const secs = String(Math.floor((diff % 60000) / 1000)).padStart(2, "0");
    const current = state.questions[state.current];
    els.meta.textContent = `Întrebarea ${state.current + 1} din ${state.questions.length} | Tip: ${current ? TYPE_META[current.type].title : "-"} | Timp rămas: ${mins}:${secs}`;
  }, 500);
}

async function startQuiz() {
  els.setupMessage.textContent = "";
  els.resultHost.innerHTML = "";

  const minutes = Number.parseInt(els.timer.value || "45", 10);

  if (!Number.isInteger(minutes) || minutes < 10 || minutes > 120) {
    els.setupMessage.textContent = "Timpul trebuie să fie între 10 și 120 minute.";
    return;
  }

  const selectedBooks = getSelectedBooks();
  if (!selectedBooks.length) {
    els.setupMessage.textContent = "Selectează cel puțin o carte înainte să pornești testul.";
    return;
  }

  els.setupMessage.textContent = "Se încarcă întrebările testului oficial după cărțile selectate...";

  try {
    const questions = await buildOfficialTest(selectedBooks);

    state.questions = questions;
    state.answers = {};
    state.current = 0;
    state.finished = false;

    renderCurrentQuestion();
    startCountdown(minutes);

    els.setupMessage.textContent = `Test pornit: ${questions.length} întrebări în ordinea oficială, filtrate după ${selectedBooks.length} cărți.`;
  } catch (error) {
    console.error(error);
    els.setupMessage.textContent = error?.message || "Eroare la încărcarea întrebărilor.";
  }
}

function bindActions() {
  els.startBtn.addEventListener("click", startQuiz);

  els.booksSearch?.addEventListener("input", () => {
    renderBooksChecklist();
  });

  els.selectAllBooksBtn?.addEventListener("click", () => {
    state.selectedBooks = new Set(state.availableBooks);
    persistSelectedBooks();
    renderBooksChecklist();
  });

  els.clearBooksBtn?.addEventListener("click", () => {
    state.selectedBooks = new Set();
    persistSelectedBooks();
    renderBooksChecklist();
  });

  els.prevBtn.addEventListener("click", () => {
    if (state.current > 0) {
      state.current -= 1;
      renderCurrentQuestion();
    }
  });

  els.nextBtn.addEventListener("click", () => {
    if (state.current < state.questions.length - 1) {
      state.current += 1;
      renderCurrentQuestion();
    }
  });

  els.submitBtn.addEventListener("click", () => {
    if (!state.questions.length || state.finished || els.submitBtn.disabled) return;

    const unanswered = getUnansweredCount();
    const confirmText = unanswered > 0
      ? `Ești sigur că vrei să trimiți testul? Nu ai răspuns la ${unanswered} întrebări.`
      : "Ești sigur că vrei să trimiți testul?";

    const ok = window.confirm(confirmText);
    if (!ok) return;

    finishQuiz("manual");
  });
}

async function init() {
  const { session } = await requireRole("student");
  state.studentId = session.user.id;
  state.username = session?.user?.user_metadata?.username || "student";

  try {
    await loadAvailableBooks();
  } catch (error) {
    console.error(error);
    if (els.setupMessage) {
      els.setupMessage.textContent = "Nu am putut încărca lista de cărți. Reîncarcă pagina.";
    }
  }

  bindActions();
}

init();
