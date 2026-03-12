import { supabase } from "../../core/supabaseClient.js";
import { requireRole } from "../../core/authGuard.js";
import {
  aggregateLeaderboard,
  ATTEMPTS_TABLE,
  getEffectiveMaxPoints,
  getEffectivePoints,
  getStartOfMonthISO,
  getStartOfWeekISO,
} from "./contestConfig.js";

const els = {
  studentName: document.getElementById("studentName"),
  status: document.getElementById("studentStatus"),
  testsCount: document.getElementById("testsCount"),
  totalPoints: document.getElementById("totalPoints"),
  weekPoints: document.getElementById("weekPoints"),
  monthPoints: document.getElementById("monthPoints"),
  avgPoints: document.getElementById("avgPoints"),
  bestPercent: document.getElementById("bestPercent"),
  weekTests: document.getElementById("weekTests"),
  monthTests: document.getElementById("monthTests"),
  studyHint: document.getElementById("studyHint"),
  lastResultDate: document.getElementById("lastResultDate"),
  lastResultScore: document.getElementById("lastResultScore"),
  lastResultCorrect: document.getElementById("lastResultCorrect"),
  lastResultDuration: document.getElementById("lastResultDuration"),
  weekRank: document.getElementById("weekRank"),
  monthRank: document.getElementById("monthRank"),
  weekLeaderboard: document.getElementById("weekLeaderboard"),
  monthLeaderboard: document.getElementById("monthLeaderboard"),
};

function formatDuration(seconds) {
  const mins = Math.floor(Number(seconds || 0) / 60);
  const secs = Number(seconds || 0) % 60;
  return `${String(mins).padStart(2, "0")}:${String(secs).padStart(2, "0")}`;
}

function renderLeaderboard(container, rows, currentUsername) {
  if (!rows.length) {
    container.textContent = "Nu există rezultate în această perioadă.";
    container.classList.add("muted");
    return;
  }

  container.classList.remove("muted");
  container.innerHTML = rows
    .slice(0, 10)
    .map((row, index) => `
      <div class="leaderboard-row ${row.student_username === currentUsername ? "is-self" : ""}">
        <strong>#${index + 1}</strong>
        <span>${row.student_username}</span>
        <span>${row.points}p / ${row.tests} teste</span>
      </div>
    `)
    .join("");
}

function loadStudentStats(rows) {
  const totalTests = rows.length;
  const totalPoints = rows.reduce((sum, row) => sum + getEffectivePoints(row), 0);

  const startWeek = new Date(getStartOfWeekISO());
  const startMonth = new Date(getStartOfMonthISO());

  let weekPoints = 0;
  let monthPoints = 0;
  let weekTests = 0;
  let monthTests = 0;
  let bestPercent = 0;

  rows.forEach((row) => {
    const createdAt = new Date(row.created_at);
    const points = getEffectivePoints(row);
    const maxPoints = getEffectiveMaxPoints(row);
    const pct = maxPoints > 0 ? Math.round((points / maxPoints) * 100) : 0;

    if (pct > bestPercent) bestPercent = pct;

    if (createdAt >= startWeek) {
      weekPoints += points;
      weekTests += 1;
    }

    if (createdAt >= startMonth) {
      monthPoints += points;
      monthTests += 1;
    }
  });

  const avgPoints = totalTests ? Math.round(totalPoints / totalTests) : 0;

  let hint = "Finalizează primul test pentru a primi o recomandare personalizată.";
  if (totalTests > 0) {
    if (bestPercent < 40) {
      hint = "Concentrează-te pe întrebările TF și ABC One. Repetă un test scurt zilnic pentru consolidare.";
    } else if (bestPercent < 70) {
      hint = "Progres bun. Analizează întrebările greșite și țintește minimum 1 test complet pe săptămână.";
    } else {
      hint = "Nivel foarte bun. Menține ritmul și încearcă să crești constanța în fiecare săptămână.";
    }
  }

  els.testsCount.textContent = String(totalTests);
  els.totalPoints.textContent = String(totalPoints);
  els.weekPoints.textContent = String(weekPoints);
  els.monthPoints.textContent = String(monthPoints);
  els.avgPoints.textContent = String(avgPoints);
  els.bestPercent.textContent = `${bestPercent}%`;
  els.weekTests.textContent = String(weekTests);
  els.monthTests.textContent = String(monthTests);
  els.studyHint.textContent = hint;
}

function loadLastResult(rows) {
  if (!rows.length) {
    els.lastResultDate.textContent = "-";
    els.lastResultScore.textContent = "-";
    els.lastResultCorrect.textContent = "-";
    els.lastResultDuration.textContent = "-";
    return;
  }

  const latest = rows[0];
  const pointsTotal = getEffectivePoints(latest);
  const maxPoints = getEffectiveMaxPoints(latest);
  const pct = maxPoints ? Math.round((pointsTotal / maxPoints) * 100) : 0;

  els.lastResultDate.textContent = new Date(latest.created_at).toLocaleString("ro-RO");
  els.lastResultScore.textContent = `${pointsTotal}/${maxPoints}p (${pct}%)`;
  els.lastResultCorrect.textContent = `${latest.total_correct_answers}/${latest.total_questions}`;
  els.lastResultDuration.textContent = formatDuration(latest.duration_seconds || 0);
}

function updateRankChip(chip, leaderboardRows, username) {
  const rankIndex = leaderboardRows.findIndex((row) => row.student_username === username);
  if (rankIndex === -1) {
    chip.textContent = "Fără poziție";
    return;
  }

  chip.textContent = `Loc #${rankIndex + 1}`;
}

async function loadLeaderboards(username) {
  const weekStart = getStartOfWeekISO();
  const monthStart = getStartOfMonthISO();

  const [weekRes, monthRes] = await Promise.all([
    supabase
      .from(ATTEMPTS_TABLE)
      .select("student_username, points_total, max_points")
      .gte("created_at", weekStart),
    supabase
      .from(ATTEMPTS_TABLE)
      .select("student_username, points_total, max_points")
      .gte("created_at", monthStart),
  ]);

  if (weekRes.error) {
    console.error(weekRes.error);
    els.weekLeaderboard.textContent = "Eroare la încărcarea clasamentului săptămânal.";
  } else {
    const weekRows = aggregateLeaderboard(weekRes.data || []);
    renderLeaderboard(els.weekLeaderboard, weekRows, username);
    updateRankChip(els.weekRank, weekRows, username);
  }

  if (monthRes.error) {
    console.error(monthRes.error);
    els.monthLeaderboard.textContent = "Eroare la încărcarea clasamentului lunar.";
  } else {
    const monthRows = aggregateLeaderboard(monthRes.data || []);
    renderLeaderboard(els.monthLeaderboard, monthRows, username);
    updateRankChip(els.monthRank, monthRows, username);
  }
}

async function init() {
  const { session } = await requireRole("student");

  const username = session?.user?.user_metadata?.username || "student";
  els.studentName.textContent = username;
  els.status.textContent = "Profil activ pentru testul oficial Talantul in Negot.";

  const { data, error } = await supabase
    .from(ATTEMPTS_TABLE)
    .select("created_at, points_total, max_points, total_correct_answers, total_questions, duration_seconds")
    .eq("student_auth_id", session.user.id)
    .order("created_at", { ascending: false });

  if (error) {
    console.error(error);
    els.status.textContent = "Nu s-au putut încărca statisticile. Verifică setup-ul tabelului nou.";
    return;
  }

  const rows = data || [];
  loadStudentStats(rows);
  loadLastResult(rows);

  await loadLeaderboards(username);
}

init();
