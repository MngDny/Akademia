import { supabase } from "../../core/supabaseClient.js";
import { requireRole } from "../../core/authGuard.js";
import {
  ATTEMPTS_TABLE,
  getEffectiveMaxPoints,
  getEffectivePoints,
  getStartOfMonthISO,
  getStartOfWeekISO,
} from "./contestConfig.js";

const els = {
  status: document.getElementById("studentStatus"),
  yearFilter: document.getElementById("yearFilter"),
  performancePeriod: document.getElementById("performancePeriod"),
  testsCount: document.getElementById("testsCount"),
  totalPoints: document.getElementById("totalPoints"),
  weekPoints: document.getElementById("weekPoints"),
  monthPoints: document.getElementById("monthPoints"),
  avgPoints: document.getElementById("avgPoints"),
  bestPercent: document.getElementById("bestPercent"),
  weekTests: document.getElementById("weekTests"),
  monthTests: document.getElementById("monthTests"),
  lastResultDate: document.getElementById("lastResultDate"),
  lastResultScore: document.getElementById("lastResultScore"),
  lastResultCorrect: document.getElementById("lastResultCorrect"),
  lastResultDuration: document.getElementById("lastResultDuration"),
};

const currentYear = new Date().getFullYear();
let allRows = [];

function formatDuration(seconds) {
  const mins = Math.floor(Number(seconds || 0) / 60);
  const secs = Number(seconds || 0) % 60;
  return `${String(mins).padStart(2, "0")}:${String(secs).padStart(2, "0")}`;
}

function buildYearFilter() {
  if (!els.yearFilter) return;
  els.yearFilter.replaceChildren();

  for (let year = currentYear; year >= 2025; year -= 1) {
    const option = new Option(String(year), String(year));
    option.selected = year === currentYear;
    els.yearFilter.append(option);
  }

  const allOption = new Option("Toți anii", "all");
  els.yearFilter.append(allOption);
  els.yearFilter.value = String(currentYear);
}

function selectedYear() {
  return els.yearFilter?.value || String(currentYear);
}

function selectedYearLabel() {
  return selectedYear() === "all" ? "Toți anii" : selectedYear();
}

function filterRowsByYear() {
  const year = selectedYear();
  if (year === "all") return allRows;
  return allRows.filter((row) => new Date(row.created_at).getFullYear() === Number(year));
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
    const percent = maxPoints > 0 ? Math.round((points / maxPoints) * 100) : 0;

    bestPercent = Math.max(bestPercent, percent);
    if (createdAt >= startWeek) {
      weekPoints += points;
      weekTests += 1;
    }
    if (createdAt >= startMonth) {
      monthPoints += points;
      monthTests += 1;
    }
  });

  els.testsCount.textContent = String(totalTests);
  els.totalPoints.textContent = String(totalPoints);
  els.weekPoints.textContent = String(weekPoints);
  els.monthPoints.textContent = String(monthPoints);
  els.avgPoints.textContent = String(totalTests ? Math.round(totalPoints / totalTests) : 0);
  els.bestPercent.textContent = `${bestPercent}%`;
  els.weekTests.textContent = String(weekTests);
  els.monthTests.textContent = String(monthTests);
  els.performancePeriod.textContent = selectedYearLabel();
}

function loadLastResult(rows) {
  if (!rows.length) {
    els.lastResultDate.textContent = "-";
    els.lastResultScore.textContent = "-";
    els.lastResultCorrect.textContent = "-";
    els.lastResultDuration.textContent = "-";
    return;
  }

  const latest = [...rows].sort((a, b) => new Date(b.created_at) - new Date(a.created_at))[0];
  const pointsTotal = getEffectivePoints(latest);
  const maxPoints = getEffectiveMaxPoints(latest);
  const percent = maxPoints ? Math.round((pointsTotal / maxPoints) * 100) : 0;

  els.lastResultDate.textContent = new Date(latest.created_at).toLocaleString("ro-RO");
  els.lastResultScore.textContent = `${pointsTotal}/${maxPoints}p (${percent}%)`;
  els.lastResultCorrect.textContent = `${latest.total_correct_answers ?? 0}/${latest.total_questions ?? 0}`;
  els.lastResultDuration.textContent = formatDuration(latest.duration_seconds);
}

function renderDashboard() {
  const rows = filterRowsByYear();
  loadStudentStats(rows);
  loadLastResult(rows);
  els.status.textContent = `Statistici pentru ${selectedYearLabel()}`;
}

async function init() {
  const { session } = await requireRole("student");
  buildYearFilter();

  const { data, error } = await supabase
    .from(ATTEMPTS_TABLE)
    .select("created_at, points_total, max_points, total_correct_answers, total_questions, duration_seconds")
    .eq("student_auth_id", session.user.id)
    .order("created_at", { ascending: false });

  if (error) {
    console.error(error);
    els.status.textContent = "Nu s-au putut încărca statisticile.";
    return;
  }

  allRows = data || [];
  els.yearFilter?.addEventListener("change", renderDashboard);
  renderDashboard();
}

init();
