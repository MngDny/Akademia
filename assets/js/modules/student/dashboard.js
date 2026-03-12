import { supabase } from "../../core/supabaseClient.js";
import { requireRole } from "../../core/authGuard.js";

const RESULT_KEY_PREFIX = "akademia_student_results_";

const els = {
  studentName: document.getElementById("studentName"),
  status: document.getElementById("studentStatus"),
  lastResult: document.getElementById("lastResult"),
  countTf: document.getElementById("count_tf"),
  countAbcOne: document.getElementById("count_abc_one"),
  countAbcMulti: document.getElementById("count_abc_multi"),
  countMatch: document.getElementById("count_match"),
};

async function loadCount(table, target) {
  const { count } = await supabase
    .from(table)
    .select("*", { count: "exact", head: true })
    .eq("status", "active");

  target.textContent = String(count || 0);
}

function loadLastResult(username) {
  const key = `${RESULT_KEY_PREFIX}${username}`;
  const rows = JSON.parse(localStorage.getItem(key) || "[]");

  if (!rows.length) {
    els.lastResult.textContent = "Nu ai inca un rezultat salvat.";
    return;
  }

  const latest = rows[0];
  const pct = latest.total ? Math.round((latest.correct / latest.total) * 100) : 0;

  els.lastResult.textContent = `${new Date(latest.date).toLocaleString("ro-RO")}: ${latest.correct}/${latest.total} (${pct}%) - ${latest.mode === "mixed" ? "mod mixt" : latest.type}`;
}

function bindCardNavigation() {
  document.querySelectorAll(".stat-card").forEach((card) => {
    card.addEventListener("click", () => {
      const type = card.dataset.type;
      window.location.href = `/portal/student/quiz.html?type=${type}`;
    });
  });
}

async function init() {
  const { session } = await requireRole("student");

  const username = session?.user?.user_metadata?.username || "student";
  els.studentName.textContent = username;
  els.status.textContent = "Alege tipul de antrenament sau pornește un quiz mixt pentru simulare de concurs.";

  await Promise.all([
    loadCount("questions_tf", els.countTf),
    loadCount("questions_abc_one", els.countAbcOne),
    loadCount("questions_abc_multi", els.countAbcMulti),
    loadCount("questions_match", els.countMatch),
  ]);

  loadLastResult(username);
  bindCardNavigation();
}

init();
