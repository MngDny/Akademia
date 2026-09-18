import { supabase } from "../../core/supabaseClient.js";
import { normalizeRole } from "../../core/authGuard.js";
import { initPasswordVisibility } from "../../core/passwordVisibility.js";
import { mountPortal } from "../../core/portalShell.js";
import { closeProfileDialog, fetchUserStats, formatProfileDate, openProfileDialog, renderUserStats, roleNames } from "../../core/userStats.js";
import { DEFAULT_STUDY_CATEGORY, STUDY_CATEGORIES, getStudyCategory } from "../../core/studyPlan.js";

let isCreatingUser = false;
let users = [];
let currentUserId;
let profileUser = null;

mountPortal("admin", { onLogout: async () => {
  const { error } = await supabase.auth.signOut();
  if (error) throw error;
  window.location.href = "/login.html";
} });
initPasswordVisibility();

function fillStudyCategorySelect(select, selected = DEFAULT_STUDY_CATEGORY) {
  select.replaceChildren();
  STUDY_CATEGORIES.forEach(({ value, label }) => select.append(new Option(label, value)));
  select.value = selected;
}

function studyCategoryLabel(value) {
  return getStudyCategory(value).label;
}

function syncCreateCategoryField() {
  const isStudent = document.getElementById("role").value === "student";
  document.getElementById("createCategoryField").hidden = !isStudent;
}

async function init() {
  const { data: { session } } = await supabase.auth.getSession();
  if (!session) { window.location.href = "/login.html"; return; }
  const { data: account } = await supabase.from("accounts").select("role")
    .eq("username", session.user.user_metadata?.username).single();
  if (!account || account.role !== "admin") {
    await supabase.auth.signOut();
    window.location.href = "/login.html";
    return;
  }
  currentUserId = session.user.id;
  fillStudyCategorySelect(document.getElementById("studyCategory"));
  fillStudyCategorySelect(document.getElementById("editStudyCategory"));
  document.getElementById("role").addEventListener("change", syncCreateCategoryField);
  document.getElementById("editRole").addEventListener("change", syncEditCategoryField);
  syncCreateCategoryField();
  document.querySelector("#createUserSection form").addEventListener("submit", createUser);
  document.querySelectorAll(".menu-item").forEach(item => {
    item.addEventListener("click", (event) => {
      event.preventDefault();
      const section = item.dataset.section;
      history.replaceState(null, "", `${window.location.pathname}#section=${section}`);
      switchSection(section);
    });
  });
  document.getElementById("userSearch").addEventListener("input", renderUsers);
  document.getElementById("roleFilter").addEventListener("change", renderUsers);
  document.getElementById("closeUserDialog").addEventListener("click", closeProfile);
  document.getElementById("userDialog").addEventListener("click", (event) => {
    if (event.target.id === "userDialog") closeProfile();
  });
  document.addEventListener("keydown", (event) => {
    if (event.key === "Escape" && !document.getElementById("userDialog").hidden) closeProfile();
  });
  document.getElementById("editUserBtn").addEventListener("click", () => setEditMode(true));
  document.getElementById("cancelEditBtn").addEventListener("click", () => setEditMode(false));
  document.getElementById("saveUserBtn").addEventListener("click", saveProfile);
  const initialSection = new URLSearchParams(window.location.hash.slice(1)).get("section") || "create-user";
  switchSection(initialSection, false);
}

function switchSection(section, focus = true) {
  const manage = section === "manage-users";
  document.querySelectorAll(".menu-item").forEach((item) => {
    const active = item.dataset.section === section;
    item.classList.toggle("active", active);
    if (active) item.setAttribute("aria-current", "page");
    else item.removeAttribute("aria-current");
  });
  document.getElementById("createUserSection").hidden = manage;
  document.getElementById("manageUsersSection").hidden = !manage;
  const heading = document.getElementById(manage ? "usersTitle" : "createTitle");
  if (focus) { heading.tabIndex = -1; heading.focus(); }
  if (manage && !users.length) loadUsers();
}

async function createUser(event) {
  event.preventDefault();
  if (isCreatingUser) return;
  const result = document.getElementById("result");
  const button = document.getElementById("createUserBtn");
  isCreatingUser = true;
  button.disabled = true;
  button.textContent = "Se creează contul…";
  result.className = "muted";
  result.textContent = "";
  try {
    const response = await fetch("/.netlify/functions/create-user", {
      method: "POST", headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        email: document.getElementById("email").value.trim(),
        password: document.getElementById("password").value,
        username: document.getElementById("username").value.trim(),
        role: document.getElementById("role").value,
        studyCategory: document.getElementById("studyCategory").value,
      }),
    });
    const data = await response.json();
    result.className = response.ok ? "success" : "error";
    result.textContent = response.ok ? "Cont creat cu succes. Îl găsești în lista de utilizatori." : (data.error || "Contul nu a putut fi creat. Încearcă din nou.");
    if (response.ok) {
      event.target.reset();
      document.getElementById("password").type = "password";
      initPasswordVisibility();
    }
  } catch {
    result.className = "error";
    result.textContent = "Conexiunea nu a reușit. Datele completate au fost păstrate. Încearcă din nou.";
  } finally {
    isCreatingUser = false;
    button.disabled = false;
    button.textContent = "Creează utilizator";
  }
}

async function loadUsers() {
  const summary = document.getElementById("usersSummary");
  summary.textContent = "Se încarcă utilizatorii…";
  try {
    const { data, error } = await supabase.from("accounts").select("id, username, role, study_category, created_at");
    if (error) throw error;
    users = data || [];
    renderUsers();
  } catch {
    summary.textContent = "Nu am putut încărca utilizatorii. Redeschide această secțiune pentru a încerca din nou.";
  }
}

function renderUsers() {
  const term = document.getElementById("userSearch").value.trim().toLocaleLowerCase("ro");
  const role = document.getElementById("roleFilter").value;
  const filtered = users.filter(user => String(user.username || "").toLocaleLowerCase("ro").includes(term) && (!role || normalizeRole(user.role) === role));
  const container = document.getElementById("usersList");
  container.replaceChildren();
  document.getElementById("usersSummary").textContent = `${filtered.length} din ${users.length} utilizatori`;
  if (!filtered.length) {
    const empty = document.createElement("p");
    empty.className = "empty-state";
    empty.textContent = users.length ? "Niciun utilizator găsit. Încearcă alt nume sau alt rol." : "Comunitatea începe aici. Creează primul cont.";
    container.append(empty);
  }
  filtered.forEach(user => {
    const row = document.createElement("div");
    row.className = "user-row";
    const info = document.createElement("div");
    info.className = "user-info";
    const name = document.createElement("strong");
    name.textContent = user.username;
    const badge = document.createElement("span");
    badge.className = "user-role";
    badge.textContent = roleNames[normalizeRole(user.role)] || user.role;
    if (normalizeRole(user.role) === "student") {
      const category = document.createElement("span");
      category.className = "user-category";
      category.textContent = studyCategoryLabel(user.study_category);
      info.append(category);
    }
    info.append(name, badge);
    row.append(info);
    const actions = document.createElement("div");
    actions.className = "user-actions";
    const view = document.createElement("button");
    view.type = "button";
    view.className = "btn sm";
    view.textContent = "Vezi info";
    view.addEventListener("click", () => showProfile(user));
    actions.append(view);
    if (user.id !== currentUserId) {
      const edit = document.createElement("button");
      edit.type = "button";
      edit.className = "btn sm";
      edit.textContent = "Editează";
      edit.addEventListener("click", () => showProfile(user, true));
      actions.append(edit);
      const button = document.createElement("button");
      button.type = "button";
      button.className = "delete-btn";
      button.textContent = "Șterge";
      button.setAttribute("aria-label", `Șterge utilizatorul ${user.username}`);
      button.addEventListener("click", () => deleteUser(user, button));
      actions.append(button);
    } else {
      const self = document.createElement("span");
      self.className = "muted user-self-label";
      self.textContent = "Contul tău";
      actions.append(self);
    }
    row.append(actions);
    container.append(row);
  });
}

function setEditMode(editing) {
  document.getElementById("userEditForm").hidden = !editing;
  document.getElementById("editUserBtn").hidden = editing;
  document.getElementById("cancelEditBtn").hidden = !editing;
  document.getElementById("saveUserBtn").hidden = !editing;
  if (editing) document.getElementById("editUsername").focus();
}

function syncEditCategoryField() {
  const isStudent = document.getElementById("editRole").value === "student";
  const field = document.getElementById("editStudyCategory");
  field.disabled = !isStudent;
  field.closest(".field").hidden = !isStudent;
}

async function showProfile(user, editing = false) {
  profileUser = { ...user, role: normalizeRole(user.role) };
  document.getElementById("userDialogTitle").textContent = user.username || "Utilizator";
  document.getElementById("userDialogMeta").textContent = roleNames[profileUser.role] || profileUser.role || "-";
  document.getElementById("userDialogUsername").textContent = user.username || "-";
  document.getElementById("userDialogRole").textContent = roleNames[profileUser.role] || profileUser.role || "-";
  document.getElementById("userDialogCreated").textContent = formatProfileDate(user.created_at);
  document.getElementById("userDialogCategory").textContent = profileUser.role === "student" ? studyCategoryLabel(user.study_category) : "Nu se aplică";
  document.getElementById("editUsername").value = user.username || "";
  document.getElementById("editRole").value = profileUser.role;
  document.getElementById("editStudyCategory").value = user.study_category || DEFAULT_STUDY_CATEGORY;
  syncEditCategoryField();
  document.getElementById("userDialogStatus").textContent = "Se încarcă statisticile…";
  document.getElementById("userDialogStats").replaceChildren();
  setEditMode(editing);
  openProfileDialog(document.getElementById("userDialog"));
  try {
    const stats = await fetchUserStats(profileUser);
    renderUserStats(document.getElementById("userDialogStats"), profileUser, stats);
    document.getElementById("userDialogStatus").textContent = "Statisticile sunt actualizate.";
  } catch (error) {
    console.error(error);
    document.getElementById("userDialogStatus").textContent = "Statisticile nu au putut fi încărcate.";
  }
}

function closeProfile() {
  closeProfileDialog(document.getElementById("userDialog"));
  profileUser = null;
}

async function saveProfile() {
  if (!profileUser) return;
  const username = document.getElementById("editUsername").value.trim();
  const role = document.getElementById("editRole").value;
  const studyCategory = document.getElementById("editStudyCategory").value;
  const status = document.getElementById("userDialogStatus");
  if (username.length < 3) { status.textContent = "Numele trebuie să aibă cel puțin 3 caractere."; return; }
  const button = document.getElementById("saveUserBtn");
  button.disabled = true;
  button.textContent = "Se salvează…";
  try {
    const { data: { session } } = await supabase.auth.getSession();
    const response = await fetch("/.netlify/functions/update-user", {
      method: "POST",
      headers: { "Content-Type": "application/json", ...(session?.access_token ? { Authorization: `Bearer ${session.access_token}` } : {}) },
      body: JSON.stringify({ userId: profileUser.id, username, role, studyCategory }),
    });
    const data = await response.json();
    if (!response.ok) throw new Error(data.error || "update");
    const updated = { ...profileUser, username, role, study_category: role === "student" ? studyCategory : null };
    users = users.map((item) => item.id === updated.id ? updated : item);
    profileUser = updated;
    renderUsers();
    setEditMode(false);
    document.getElementById("userDialogTitle").textContent = username;
    document.getElementById("userDialogMeta").textContent = roleNames[role];
    document.getElementById("userDialogUsername").textContent = username;
    document.getElementById("userDialogRole").textContent = roleNames[role];
    document.getElementById("userDialogCategory").textContent = role === "student" ? studyCategoryLabel(studyCategory) : "Nu se aplică";
    status.textContent = "Modificările au fost salvate.";
  } catch (error) {
    console.error(error);
    status.textContent = error.message === "update" ? "Utilizatorul nu a putut fi actualizat." : error.message;
  } finally {
    button.disabled = false;
    button.textContent = "Salvează modificările";
  }
}

async function deleteUser(user, button) {
  if (!confirm(`Ștergi definitiv contul „${user.username}”? Această acțiune nu poate fi anulată.`)) return;
  button.disabled = true;
  button.textContent = "Se șterge…";
  try {
    const response = await fetch("/.netlify/functions/delete-user", {
      method: "POST", headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ userId: user.id }),
    });
    if (!response.ok) throw new Error("delete");
    users = users.filter(item => item.id !== user.id);
    renderUsers();
    document.getElementById("userSearch").focus();
  } catch {
    document.getElementById("usersSummary").textContent = "Contul nu a putut fi șters. Încearcă din nou.";
    button.disabled = false;
    button.textContent = "Șterge";
  }
}
init().catch(() => { document.getElementById("result").textContent = "Conexiunea nu a reușit. Reîncarcă pagina pentru a încerca din nou."; });
