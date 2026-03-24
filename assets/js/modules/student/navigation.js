import { supabase } from "../../core/supabaseClient.js";

const sidebar = document.getElementById("sidebar");

if (!sidebar) {
  throw new Error("Containerul barei laterale student (#sidebar) lipseste.");
}

const currentPath = window.location.pathname;
const navClass = (active) => (active ? "nav-item active" : "nav-item");

sidebar.innerHTML = `
  <div class="brand">AKADEMIA</div>
  <div class="brand-subtitle">Portal Student</div>

  <div class="nav-section-title">Navigare</div>
  <nav class="nav">
    <a class="${navClass(currentPath.includes("/portal/student/dashboard.html"))}" href="/portal/student/dashboard.html">Tablou de bord</a>
    <a class="${navClass(currentPath.includes("/portal/student/quiz.html"))}" href="/portal/student/quiz.html">Test nou</a>
    <a class="${navClass(currentPath.includes("/portal/student/learning.html"))}" href="/portal/student/learning.html">Mediu de invatare</a>
    <a class="${navClass(currentPath.includes("/portal/student/results.html"))}" href="/portal/student/results.html">Rezultate</a>
    <a class="${navClass(currentPath.includes("/portal/student/leaderboard.html"))}" href="/portal/student/leaderboard.html">Clasament</a>
  </nav>

  <div class="sidebar-footer">
    <button id="logoutBtn" class="btn danger">Deconectare</button>
  </div>
`;

const toggleButton = document.createElement("button");
toggleButton.className = "menu-toggle";
toggleButton.type = "button";
toggleButton.setAttribute("aria-label", "Deschide meniul");
toggleButton.textContent = "☰";

const overlay = document.createElement("div");
overlay.className = "overlay";

document.body.append(toggleButton, overlay);

const closeMenu = () => {
  sidebar.classList.remove("open");
  overlay.classList.remove("active");
};

toggleButton.addEventListener("click", () => {
  sidebar.classList.toggle("open");
  overlay.classList.toggle("active");
});
overlay.addEventListener("click", closeMenu);
document.querySelectorAll(".nav-item").forEach((link) => link.addEventListener("click", closeMenu));

document.getElementById("logoutBtn")?.addEventListener("click", async () => {
  await supabase.auth.signOut();
  window.location.href = "/login.html";
});
