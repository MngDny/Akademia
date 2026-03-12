import { requireRole } from "../../core/authGuard.js";

const RESULT_KEY_PREFIX = "akademia_student_results_";

const els = {
  subtitle: document.getElementById("resultsSubtitle"),
  search: document.getElementById("searchInput"),
  clearBtn: document.getElementById("clearBtn"),
  body: document.getElementById("resultsBody"),
  empty: document.getElementById("emptyState"),
};

let allRows = [];
let username = "";

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
    const pct = row.total ? Math.round((row.correct / row.total) * 100) : 0;
    const tr = document.createElement("tr");
    tr.innerHTML = `
      <td>${new Date(row.date).toLocaleString("ro-RO")}</td>
      <td>${row.mode === "mixed" ? "Mixt" : "Single"}</td>
      <td>${row.type}</td>
      <td>${row.correct}/${row.total} (${pct}%)</td>
      <td>${formatDuration(row.secondsSpent || 0)}</td>
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
    const mode = row.mode === "mixed" ? "mixt" : "single";
    return mode.includes(term) || String(row.type || "").toLowerCase().includes(term);
  });

  render(filtered);
}

function loadResults() {
  const key = `${RESULT_KEY_PREFIX}${username}`;
  allRows = JSON.parse(localStorage.getItem(key) || "[]");

  els.subtitle.textContent = allRows.length
    ? `${allRows.length} rezultate salvate`
    : "Nu ai rezultate inregistrate momentan.";

  render(allRows);
}

function clearResults() {
  const ok = confirm("Sigur vrei sa stergi tot istoricul de rezultate?");
  if (!ok) return;

  const key = `${RESULT_KEY_PREFIX}${username}`;
  localStorage.removeItem(key);
  allRows = [];
  render(allRows);
  els.subtitle.textContent = "Istoricul a fost șters.";
}

async function init() {
  const { session } = await requireRole("student");
  username = session?.user?.user_metadata?.username || "student";

  loadResults();

  els.search.addEventListener("input", applySearch);
  els.clearBtn.addEventListener("click", clearResults);
}

init();
