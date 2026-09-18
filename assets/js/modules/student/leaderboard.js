import { supabase } from "../../core/supabaseClient.js";
import { requireAnyRole } from "../../core/authGuard.js";
import {
  aggregateLeaderboard,
  ATTEMPTS_TABLE,
  getStartOfMonthISO,
  getStartOfTodayISO,
  getStartOfWeekISO,
  getStartOfYearISO,
} from "./contestConfig.js";

const els = {
  subtitle: document.getElementById("leaderboardSubtitle"),
  updated: document.getElementById("leaderboardUpdated"),
  metric: document.getElementById("leaderboardMetric"),
  period: document.getElementById("leaderboardPeriod"),
  list: document.getElementById("leaderboard"),
};

const periodLabels = {
  today: "Astăzi",
  week: "Săptămâna curentă",
  month: "Luna curentă",
  year: "Anul curent",
  all: "Total",
};

let allRows = [];

function getPeriodStart(period) {
  if (period === "today") return new Date(getStartOfTodayISO());
  if (period === "week") return new Date(getStartOfWeekISO());
  if (period === "month") return new Date(getStartOfMonthISO());
  if (period === "year") return new Date(getStartOfYearISO());
  return null;
}

function aggregateForSelection() {
  const start = getPeriodStart(els.period.value);
  const rows = start
    ? allRows.filter((row) => new Date(row.created_at) >= start)
    : allRows;
  const aggregated = aggregateLeaderboard(rows);
  if (els.metric.value === "tests") {
    aggregated.sort((a, b) => b.tests - a.tests || b.points - a.points || a.student_username.localeCompare(b.student_username));
  }
  return aggregated;
}

function render(rows) {
  els.list.replaceChildren();
  if (!rows.length) {
    els.list.textContent = "Nu există rezultate pentru perioada aleasă.";
    els.list.classList.add("muted");
    return;
  }

  els.list.classList.remove("muted");
  const fragment = document.createDocumentFragment();
  rows.slice(0, 20).forEach((row, index) => {
    const item = document.createElement("div");
    item.className = "leaderboard-row";

    const rank = document.createElement("strong");
    rank.textContent = `#${index + 1}`;
    const username = document.createElement("span");
    username.textContent = row.student_username;
    const score = document.createElement("span");
    score.className = "leaderboard-score";
    score.textContent = els.metric.value === "tests" ? `${row.tests} teste` : `${row.points}p`;
    const secondary = document.createElement("span");
    secondary.className = "leaderboard-secondary";
    secondary.textContent = els.metric.value === "tests" ? `${row.points}p` : `${row.tests} teste`;

    item.append(rank, username, score, secondary);
    fragment.append(item);
  });
  els.list.append(fragment);
}

function refresh() {
  const periodLabel = periodLabels[els.period.value] || "Total";
  const metricLabel = els.metric.value === "tests" ? "Teste" : "Puncte";
  render(aggregateForSelection());
  els.subtitle.textContent = `${metricLabel} · ${periodLabel}`;
  els.updated.textContent = periodLabel;
}

async function init() {
  await requireAnyRole(["student", "instructor", "admin"]);

  const { data, error } = await supabase
    .from(ATTEMPTS_TABLE)
    .select("student_username, points_total, max_points, created_at")
    .order("created_at", { ascending: false });

  if (error) {
    console.error(error);
    els.list.textContent = "Clasamentul nu a putut fi încărcat.";
    els.subtitle.textContent = "Încearcă din nou.";
    return;
  }

  allRows = data || [];
  els.metric.addEventListener("change", refresh);
  els.period.addEventListener("change", refresh);
  refresh();
}

init();
