import { supabase } from "../../../core/supabaseClient.js";
import { normalizeRole, requireRole } from "../../../core/authGuard.js";
import { closeProfileDialog, fetchUserStats, formatProfileDate, openProfileDialog, renderUserStats, roleNames } from "../../../core/userStats.js";

const els = {
  subtitle: document.getElementById("studentsSubtitle"),
  total: document.getElementById("totalStudents"),
  today: document.getElementById("todayStudents"),
  search: document.getElementById("searchInput"),
  body: document.getElementById("studentsBody"),
  empty: document.getElementById("emptyState"),
};

let allRows = [];

function formatDate(value) {
  if (!value) return "-";
  const date = new Date(value);
  if (Number.isNaN(date.getTime())) return "-";
  return date.toLocaleString("ro-RO");
}

function render(rows) {
  els.body.innerHTML = "";

  if (!rows.length) {
    els.empty.style.display = "block";
    return;
  }

  els.empty.style.display = "none";

  rows.forEach((row, index) => {
    const tr = document.createElement("tr");
    tr.innerHTML = `
      <td>${index + 1}</td>
      <td>${row.username || "-"}</td>
      <td>${normalizeRole(row.role) === "student" ? "Student" : row.role}</td>
      <td>${formatDate(row.created_at)}</td>
    `;
    const actionCell = document.createElement("td");
    const button = document.createElement("button");
    button.type = "button";
    button.className = "btn sm";
    button.textContent = "Vezi info";
    button.addEventListener("click", () => showStudentProfile(row));
    actionCell.append(button);
    tr.append(actionCell);
    els.body.appendChild(tr);
  });
}

function applySearch() {
  const term = (els.search.value || "").toLowerCase().trim();
  if (!term) {
    render(allRows);
    return;
  }

  const filtered = allRows.filter((row) => String(row.username || "").toLowerCase().includes(term));
  render(filtered);
}

function computeStats(rows) {
  const today = new Date();
  today.setHours(0, 0, 0, 0);

  const todayCount = rows.filter((row) => {
    const createdAt = new Date(row.created_at);
    return !Number.isNaN(createdAt.getTime()) && createdAt >= today;
  }).length;

  els.total.textContent = String(rows.length);
  els.today.textContent = String(todayCount);
  els.subtitle.textContent = `${rows.length} studenți înregistrați`;
}

async function init() {
  await requireRole("instructor");

  const { data, error } = await supabase
    .from("accounts")
    .select("id, username, role, created_at")
    .in("role", ["student", "participant"])
    .order("created_at", { ascending: false });

  if (error) {
    console.error(error);
    els.subtitle.textContent = "Eroare la încărcarea studenților.";
    return;
  }

  allRows = data || [];
  computeStats(allRows);
  render(allRows);

  els.search.addEventListener("input", applySearch);
  document.getElementById("closeStudentDialog").addEventListener("click", closeStudentProfile);
  document.getElementById("studentDialog").addEventListener("click", (event) => {
    if (event.target.id === "studentDialog") closeStudentProfile();
  });
  document.addEventListener("keydown", (event) => {
    if (event.key === "Escape" && !document.getElementById("studentDialog").hidden) closeStudentProfile();
  });
}

async function showStudentProfile(student) {
  document.getElementById("studentDialogTitle").textContent = student.username || "Student";
  document.getElementById("studentDialogMeta").textContent = roleNames.student;
  document.getElementById("studentDialogUsername").textContent = student.username || "-";
  document.getElementById("studentDialogCreated").textContent = formatProfileDate(student.created_at);
  document.getElementById("studentDialogStats").replaceChildren();
  document.getElementById("studentDialogStatus").textContent = "Se încarcă statisticile…";
  openProfileDialog(document.getElementById("studentDialog"));
  try {
    const stats = await fetchUserStats({ ...student, role: "student" });
    renderUserStats(document.getElementById("studentDialogStats"), student, stats);
    document.getElementById("studentDialogStatus").textContent = "Statisticile sunt actualizate.";
  } catch (error) {
    console.error(error);
    document.getElementById("studentDialogStatus").textContent = "Statisticile nu au putut fi încărcate.";
  }
}

function closeStudentProfile() {
  closeProfileDialog(document.getElementById("studentDialog"));
}

init();
