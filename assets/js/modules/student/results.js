import { supabase } from "../../core/supabaseClient.js";
import { requireRole } from "../../core/authGuard.js";
import { ATTEMPTS_TABLE, getEffectiveMaxPoints, getEffectivePoints } from "./contestConfig.js";

const els = {
  subtitle: document.getElementById("resultsSubtitle"),
  search: document.getElementById("searchInput"),
  clearBtn: document.getElementById("clearBtn"),
  body: document.getElementById("resultsBody"),
  empty: document.getElementById("emptyState"),
};

let allRows = [];

function formatDuration(seconds) {
  const mins = Math.floor(seconds / 60);
  const secs = seconds % 60;
  return `${String(mins).padStart(2, "0")}:${String(secs).padStart(2, "0")}`;
}

function render(rows) {
  els.body.innerHTML = "";

  if (!rows.length) {
    els.empty.style.display = "block";
    return;
  }

  els.empty.style.display = "none";

  rows.forEach((row) => {
    const pointsTotal = getEffectivePoints(row);
    const maxPoints = getEffectiveMaxPoints(row);
    const pct = maxPoints ? Math.round((pointsTotal / maxPoints) * 100) : 0;
    const tr = document.createElement("tr");
    tr.innerHTML = `
      <td>${new Date(row.created_at).toLocaleString("ro-RO")}</td>
      <td>${pointsTotal}/${maxPoints} (${pct}%)</td>
      <td>${row.total_correct_answers}/${row.total_questions}</td>
      <td>${formatDuration(row.duration_seconds || 0)}</td>
      <td>TF ${row.tf_correct}/${row.tf_total}, ABC1 ${row.abc_one_correct}/${row.abc_one_total}, Asociere ${row.match_pairs_correct} perechi, ABCM ${row.abc_multi_correct}/${row.abc_multi_total}</td>
    `;

    els.body.appendChild(tr);
  });
}

function applySearch() {
  const term = (els.search.value || "").toLowerCase().trim();
  if (!term) {
    render(allRows);
    return;
  }

  const filtered = allRows.filter((row) => {
    const created = new Date(row.created_at).toLocaleString("ro-RO").toLowerCase();
    return created.includes(term) || String(getEffectivePoints(row)).includes(term);
  });

  render(filtered);
}

async function loadResults(studentId) {
  const { data, error } = await supabase
    .from(ATTEMPTS_TABLE)
    .select("*")
    .eq("student_auth_id", studentId)
    .order("created_at", { ascending: false });

  if (error) {
    console.error(error);
    els.subtitle.textContent = "Eroare la încărcarea rezultatelor. Verifică setup-ul tabelei.";
    return;
  }

  allRows = data || [];

  els.subtitle.textContent = allRows.length
    ? `${allRows.length} rezultate salvate`
    : "Nu ai rezultate inregistrate momentan.";

  render(allRows);
}

function clearResults() {
  const ok = confirm("Sigur vrei să ștergi tot istoricul de rezultate?");
  if (!ok) return;

  els.subtitle.textContent = "Ștergerea completă se face din Supabase (control administrativ).";
}

async function init() {
  const { session } = await requireRole("student");
  await loadResults(session.user.id);

  els.search.addEventListener("input", applySearch);
  els.clearBtn.addEventListener("click", clearResults);
}

init();
