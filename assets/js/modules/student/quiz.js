import { supabase } from "../../core/supabaseClient.js";
import { requireRole } from "../../core/authGuard.js";

const RESULT_KEY_PREFIX = "akademia_student_results_";

const TYPE_MAP = {
  tf: { table: "questions_tf", title: "Adevărat / Fals" },
  abc_one: { table: "questions_abc_one", title: "ABC One" },
  abc_multi: { table: "questions_abc_multi", title: "ABC Multi" },
  match: { table: "questions_match", title: "Asociere" },
};

const els = {
  quizMode: document.getElementById("quizMode"),
  quizType: document.getElementById("quizType"),
  count: document.getElementById("questionCount"),
  timer: document.getElementById("timerMinutes"),
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
  username: "",
  mode: "single",
  type: "tf",
  questions: [],
  answers: {},
  current: 0,
  deadline: 0,
  timerId: null,
  finished: false,
};

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
      pairs: pairs.map((p) => ({
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

async function fetchByType(type, limit) {
  const table = TYPE_MAP[type].table;

  let query = supabase
    .from(table)
    .select("*")
    .order("created_at", { ascending: false })
    .limit(limit);

  const { data: activeRows, error: activeError } = await query.eq("status", "active");

  if (!activeError && (activeRows || []).length) {
    return (activeRows || []).map((row) => normalizeRow(type, row));
  }

  const { data, error } = await supabase
    .from(table)
    .select("*")
    .order("created_at", { ascending: false })
    .limit(limit);

  if (error) throw error;
  return (data || []).map((row) => normalizeRow(type, row));
}

function shuffle(array) {
  const arr = [...array];
  for (let i = arr.length - 1; i > 0; i -= 1) {
    const j = Math.floor(Math.random() * (i + 1));
    [arr[i], arr[j]] = [arr[j], arr[i]];
  }
  return arr;
}

async function loadQuestions(mode, type, count) {
  if (mode === "mixed") {
    const perType = Math.max(1, Math.ceil(count / 4));
    const chunks = await Promise.all(Object.keys(TYPE_MAP).map((t) => fetchByType(t, perType)));
    return shuffle(chunks.flat()).slice(0, count);
  }

  return fetchByType(type, count);
}

function setModeFromUrl() {
  const url = new URL(window.location.href);
  const mode = url.searchParams.get("mode");
  const type = url.searchParams.get("type");

  if (mode === "mixed") {
    els.quizMode.value = "mixed";
  }

  if (type && TYPE_MAP[type]) {
    els.quizType.value = type;
  }

  toggleTypeVisibility();
}

function toggleTypeVisibility() {
  const isMixed = els.quizMode.value === "mixed";
  els.quizType.disabled = isMixed;
  els.quizType.style.opacity = isMixed ? "0.6" : "1";
}

function saveAnswer(questionIndex, value) {
  state.answers[questionIndex] = value;
}

function renderOptionsQuestion(question, idx) {
  const saved = state.answers[idx] || (question.multi ? [] : null);

  const items = question.options
    .map((opt, i) => {
      const input = question.multi
        ? `<input type="checkbox" data-index="${i}" ${Array.isArray(saved) && saved.includes(i) ? "checked" : ""} />`
        : `<input type="radio" name="currentAnswer" value="${i}" ${saved === i ? "checked" : ""} />`;

      return `<label class="option-item">${input} ${opt.text || `Opțiune ${i + 1}`}</label>`;
    })
    .join("");

  els.answerHost.innerHTML = `<div class="option-list">${items}</div>`;

  if (question.multi) {
    els.answerHost.querySelectorAll("input[type='checkbox']").forEach((el) => {
      el.addEventListener("change", () => {
        const selected = Array.from(els.answerHost.querySelectorAll("input[type='checkbox']:checked")).map((c) => Number(c.dataset.index));
        saveAnswer(idx, selected);
      });
    });
  } else {
    els.answerHost.querySelectorAll("input[type='radio']").forEach((el) => {
      el.addEventListener("change", () => {
        saveAnswer(idx, Number(el.value));
      });
    });
  }
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
          <strong>${pair.left}</strong>
          <select class="input pair-select" data-index="${i}">
            <option value="">Selectează...</option>
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

  els.meta.textContent = `Întrebarea ${state.current + 1} din ${state.questions.length} | Tip: ${TYPE_MAP[question.type].title}`;
  els.questionText.textContent = question.prompt;

  if (question.kind === "pairs") {
    renderPairsQuestion(question, state.current);
  } else {
    renderOptionsQuestion(question, state.current);
  }

  els.prevBtn.disabled = state.current === 0 || state.finished;
  els.nextBtn.disabled = state.current >= state.questions.length - 1 || state.finished;
  els.submitBtn.disabled = state.finished || !state.questions.length;
}

function isEqualSet(a, b) {
  if (a.length !== b.length) return false;
  const setA = new Set(a);
  return b.every((item) => setA.has(item));
}

function evaluateQuestion(question, answer) {
  if (question.kind === "pairs") {
    if (!answer || typeof answer !== "object") return false;
    return question.pairs.every((pair, index) => answer[String(index)] === pair.right);
  }

  const correctIndexes = question.options
    .map((opt, index) => ({ correct: Boolean(opt.correct), index }))
    .filter((item) => item.correct)
    .map((item) => item.index);

  if (question.multi) {
    const selected = Array.isArray(answer) ? answer : [];
    return isEqualSet(correctIndexes, selected);
  }

  return correctIndexes.length ? Number(answer) === correctIndexes[0] : false;
}

function stopTimer() {
  if (state.timerId) {
    clearInterval(state.timerId);
    state.timerId = null;
  }
}

function storeResult(correct) {
  const total = state.questions.length;
  const secondsSpent = Math.max(0, Math.round((Date.now() - (state.deadline - Number(els.timer.value) * 60000)) / 1000));

  const result = {
    id: crypto.randomUUID(),
    date: new Date().toISOString(),
    mode: state.mode,
    type: state.mode === "mixed" ? "mixt" : TYPE_MAP[state.type].title,
    total,
    correct,
    secondsSpent,
  };

  const key = `${RESULT_KEY_PREFIX}${state.username}`;
  const existing = JSON.parse(localStorage.getItem(key) || "[]");
  localStorage.setItem(key, JSON.stringify([result, ...existing].slice(0, 200)));
}

function finishQuiz(reason = "manual") {
  if (state.finished) return;
  state.finished = true;
  stopTimer();

  const correct = state.questions.reduce((acc, question, index) => acc + (evaluateQuestion(question, state.answers[index]) ? 1 : 0), 0);
  const pct = state.questions.length ? Math.round((correct / state.questions.length) * 100) : 0;

  storeResult(correct);

  const klass = pct >= 80 ? "result-good" : pct >= 50 ? "result-mid" : "result-bad";
  const reasonText = reason === "timeout" ? "Timpul a expirat." : "Test trimis.";

  els.resultHost.innerHTML = `
    <div class="card" style="max-width:100%;">
      <h3>Rezultat final</h3>
      <p class="${klass}">${reasonText} Ai obținut ${correct} din ${state.questions.length} (${pct}%).</p>
      <div class="actions-row">
        <a class="btn" href="/portal/student/results.html">Vezi istoric</a>
        <a class="btn primary" href="/portal/student/quiz.html?mode=${state.mode}${state.mode === "single" ? `&type=${state.type}` : ""}">Încearcă din nou</a>
      </div>
    </div>
  `;

  renderCurrentQuestion();
}

function startCountdown(minutes) {
  state.deadline = Date.now() + minutes * 60 * 1000;

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
    els.meta.textContent = `Întrebarea ${state.current + 1} din ${state.questions.length} | Tip: ${current ? TYPE_MAP[current.type].title : "-"} | Timp rămas: ${mins}:${secs}`;
  }, 500);
}

async function startQuiz() {
  els.setupMessage.textContent = "";
  els.resultHost.innerHTML = "";

  const mode = els.quizMode.value;
  const type = els.quizType.value;
  const count = Number.parseInt(els.count.value || "20", 10);
  const minutes = Number.parseInt(els.timer.value || "30", 10);

  if (!Number.isInteger(count) || count < 5 || count > 60) {
    els.setupMessage.textContent = "Numărul de întrebări trebuie să fie între 5 și 60.";
    return;
  }

  if (!Number.isInteger(minutes) || minutes < 5 || minutes > 120) {
    els.setupMessage.textContent = "Timpul trebuie să fie între 5 și 120 minute.";
    return;
  }

  els.setupMessage.textContent = "Se încarcă întrebările...";

  try {
    const questions = await loadQuestions(mode, type, count);

    if (!questions.length) {
      els.setupMessage.textContent = "Nu există întrebări disponibile pentru această configurare.";
      return;
    }

    state.mode = mode;
    state.type = type;
    state.questions = questions;
    state.answers = {};
    state.current = 0;
    state.finished = false;

    renderCurrentQuestion();
    startCountdown(minutes);

    els.setupMessage.textContent = `Quiz pornit: ${questions.length} întrebări.`;
  } catch (error) {
    console.error(error);
    els.setupMessage.textContent = "Eroare la încărcarea întrebărilor.";
  }
}

function bindActions() {
  els.quizMode.addEventListener("change", toggleTypeVisibility);
  els.startBtn.addEventListener("click", startQuiz);

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

  els.submitBtn.addEventListener("click", () => finishQuiz("manual"));
}

async function init() {
  const { session } = await requireRole("student");
  state.username = session?.user?.user_metadata?.username || "student";

  setModeFromUrl();
  bindActions();
}

init();
