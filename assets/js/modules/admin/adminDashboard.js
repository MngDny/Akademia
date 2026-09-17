import { supabase } from "../../core/supabaseClient.js";
import { normalizeRole } from "../../core/authGuard.js";
import { initPasswordVisibility } from "../../core/passwordVisibility.js";
import { mountPortal } from "../../core/portalShell.js";

let isCreatingUser = false;
let users = [];
let currentUserId;
const roleNames = { student: "Student", instructor: "Îndrumător", admin: "Administrator" };

mountPortal("admin", { onLogout: async () => {
  const { error } = await supabase.auth.signOut();
  if (error) throw error;
  window.location.href = "/login.html";
} });
initPasswordVisibility();

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
  document.querySelector("#createUserSection form").addEventListener("submit", createUser);
  document.querySelectorAll(".menu-item").forEach(item => {
    item.addEventListener("click", () => {
      document.querySelectorAll(".menu-item").forEach(other => {
        other.classList.toggle("active", other === item);
        if (other === item) other.setAttribute("aria-current", "page");
        else other.removeAttribute("aria-current");
      });
      const manage = item.dataset.section === "manage-users";
      document.getElementById("createUserSection").hidden = manage;
      document.getElementById("manageUsersSection").hidden = !manage;
      const heading = document.getElementById(manage ? "usersTitle" : "createTitle");
      heading.tabIndex = -1;
      heading.focus();
      if (manage) loadUsers();
    });
  });
  document.getElementById("userSearch").addEventListener("input", renderUsers);
  document.getElementById("roleFilter").addEventListener("change", renderUsers);
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
    const { data, error } = await supabase.from("accounts").select("id, username, role");
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
    info.append(name, badge);
    row.append(info);
    if (user.id === currentUserId) {
      const self = document.createElement("span");
      self.className = "muted";
      self.textContent = "Contul tău";
      row.append(self);
    } else {
      const button = document.createElement("button");
      button.type = "button";
      button.className = "delete-btn";
      button.textContent = "Șterge";
      button.setAttribute("aria-label", `Șterge utilizatorul ${user.username}`);
      button.addEventListener("click", () => deleteUser(user, button));
      row.append(button);
    }
    container.append(row);
  });
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
