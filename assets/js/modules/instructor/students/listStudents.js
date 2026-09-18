import { supabase } from "../../../core/supabaseClient.js";
import { normalizeRole, requireRole } from "../../../core/authGuard.js";
import { closeProfileDialog, fetchUserStats, formatProfileDate, openProfileDialog, renderUserStats, roleNames } from "../../../core/userStats.js";
import { DEFAULT_STUDY_CATEGORY, STUDY_CATEGORIES, getStudyCategory } from "../../../core/studyPlan.js";

const els = {
  subtitle: document.getElementById("studentsSubtitle"),
  total: document.getElementById("totalStudents"),
  today: document.getElementById("todayStudents"),
  search: document.getElementById("searchInput"),
  body: document.getElementById("studentsBody"),
  empty: document.getElementById("emptyState"),
  dialog: document.getElementById("studentDialog"),
  editForm: document.getElementById("studentEditForm"),
  editCategory: document.getElementById("editStudentCategory"),
  editButton: document.getElementById("editStudentBtn"),
  cancelEditButton: document.getElementById("cancelStudentEditBtn"),
  saveButton: document.getElementById("saveStudentBtn"),
};

let allRows = [];
let activeStudent = null;

function fillCategorySelect() {
  els.editCategory.replaceChildren();
  STUDY_CATEGORIES.forEach(({ value, label }) => els.editCategory.append(new Option(label, value)));
}

function categoryLabel(value) {
  return getStudyCategory(value).label;
}

function formatDate(value) {
  if (!value) return "-";
  const date = new Date(value);
  if (Number.isNaN(date.getTime())) return "-";
  return date.toLocaleString("ro-RO");
}

function render(rows) {
  els.body.replaceChildren();
  els.empty.style.display = rows.length ? "none" : "block";
  rows.forEach((row, index) => {
    const tr = document.createElement("tr");
    [
      String(index + 1),
      row.username || "-",
      categoryLabel(row.study_category),
      normalizeRole(row.role) === "student" ? "Student" : row.role,
      formatDate(row.created_at),
    ].forEach((value) => {
      const td = document.createElement("td");
      td.textContent = value;
      tr.append(td);
    });
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
  render(term ? allRows.filter((row) => String(row.username || "").toLowerCase().includes(term)) : allRows);
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

function setEditMode(editing) {
  els.editForm.hidden = !editing;
  els.editButton.hidden = editing;
  els.cancelEditButton.hidden = !editing;
  els.saveButton.hidden = !editing;
  if (editing) els.editCategory.focus();
}

async function showStudentProfile(student, editing = false) {
  activeStudent = student;
  document.getElementById("studentDialogTitle").textContent = student.username || "Student";
  document.getElementById("studentDialogMeta").textContent = roleNames.student;
  document.getElementById("studentDialogUsername").textContent = student.username || "-";
  document.getElementById("studentDialogCategory").textContent = categoryLabel(student.study_category);
  document.getElementById("studentDialogRole").textContent = roleNames.student;
  document.getElementById("studentDialogCreated").textContent = formatProfileDate(student.created_at);
  els.editCategory.value = student.study_category || DEFAULT_STUDY_CATEGORY;
  document.getElementById("studentDialogStats").replaceChildren();
  document.getElementById("studentDialogStatus").textContent = "Se încarcă statisticile...";
  setEditMode(editing);
  openProfileDialog(els.dialog);
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
  closeProfileDialog(els.dialog);
  activeStudent = null;
  setEditMode(false);
}

async function saveStudentCategory() {
  if (!activeStudent) return;
  const studyCategory = els.editCategory.value;
  const status = document.getElementById("studentDialogStatus");
  els.saveButton.disabled = true;
  els.saveButton.textContent = "Se salvează...";
  try {
    const { data: { session } } = await supabase.auth.getSession();
    const response = await fetch("/.netlify/functions/update-user", {
      method: "POST",
      headers: { "Content-Type": "application/json", ...(session?.access_token ? { Authorization: `Bearer ${session.access_token}` } : {}) },
      body: JSON.stringify({ userId: activeStudent.id, username: activeStudent.username, role: "student", studyCategory }),
    });
    const data = await response.json();
    if (!response.ok) throw new Error(data.error || "update");
    activeStudent = { ...activeStudent, study_category: studyCategory };
    allRows = allRows.map((row) => row.id === activeStudent.id ? activeStudent : row);
    render(allRows);
    document.getElementById("studentDialogCategory").textContent = categoryLabel(studyCategory);
    setEditMode(false);
    status.textContent = "Categoria a fost actualizată.";
  } catch (error) {
    console.error(error);
    status.textContent = error.message === "update" ? "Categoria nu a putut fi actualizată." : error.message;
  } finally {
    els.saveButton.disabled = false;
    els.saveButton.textContent = "Salvează modificările";
  }
}

async function init() {
  await requireRole("instructor");
  fillCategorySelect();

  const { data, error } = await supabase
    .from("accounts")
    .select("id, username, role, study_category, created_at")
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
  els.editButton.addEventListener("click", () => setEditMode(true));
  els.cancelEditButton.addEventListener("click", () => setEditMode(false));
  els.saveButton.addEventListener("click", saveStudentCategory);
  document.getElementById("closeStudentDialog").addEventListener("click", closeStudentProfile);
  els.dialog.addEventListener("click", (event) => { if (event.target === els.dialog) closeStudentProfile(); });
  document.addEventListener("keydown", (event) => {
    if (event.key === "Escape" && !els.dialog.hidden) closeStudentProfile();
  });
}

init();
