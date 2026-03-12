import { supabase } from "../../core/supabaseClient.js";
import { requireRole } from "../../core/authGuard.js";
import {
  aggregateLeaderboard,
  ATTEMPTS_TABLE,
  getStartOfMonthISO,
  getStartOfWeekISO,
} from "./contestConfig.js";

const els = {
  subtitle: document.getElementById("leaderboardSubtitle"),
  week: document.getElementById("weekLeaderboard"),
  month: document.getElementById("monthLeaderboard"),
};

function render(container, rows) {
  if (!rows.length) {
    container.textContent = "Nu există rezultate în această perioadă.";
    container.classList.add("muted");
    return;
  }

  container.classList.remove("muted");
  container.innerHTML = rows
    .slice(0, 20)
    .map((row, index) => `
      <div class="leaderboard-row">
        <strong>#${index + 1}</strong>
        <span>${row.student_username}</span>
        <span>${row.points}p / ${row.tests} teste</span>
      </div>
    `)
    .join("");
}

async function init() {
  await requireRole("student");

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
    els.week.textContent = "Eroare la încărcarea clasamentului săptămânal.";
  } else {
    render(els.week, aggregateLeaderboard(weekRes.data || []));
  }

  if (monthRes.error) {
    console.error(monthRes.error);
    els.month.textContent = "Eroare la încărcarea clasamentului lunar.";
  } else {
    render(els.month, aggregateLeaderboard(monthRes.data || []));
  }

  els.subtitle.textContent = "Clasamente calculate după puncte totale și număr de teste.";
}

init();
