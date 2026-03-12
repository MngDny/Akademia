import { supabase } from "../../core/supabaseClient.js";

const sidebar = document.getElementById("sidebar");

if (!sidebar) {
  throw new Error("Containerul barei laterale pentru instructor (#sidebar) lipsește.");
}

const currentPath = window.location.pathname;
const currentType = new URLSearchParams(window.location.search).get("type") || "tf";

const isDashboard = currentPath.includes("/portal/instructor/dashboard.html");
const isQuestionsListPage = currentPath.includes("/portal/instructor/questions/list.html");
const isQuestionsAddPage = currentPath.includes("/portal/instructor/questions/add.html");
const isStudentsPage = currentPath.includes("/portal/instructor/students/");

const navLinkClass = (isActive) => (isActive ? "nav-item active" : "nav-item");
const navSubLinkClass = (isActive) => (isActive ? "nav-subitem active" : "nav-subitem");

sidebar.innerHTML = `
  <div class="brand">AKADEMIA</div>
  <div class="brand-subtitle">Portal Îndrumător</div>

  <div class="nav-section-title">General</div>
  <nav class="nav">
    <a class="${navLinkClass(isDashboard)} nav-item-link" href="/portal/instructor/dashboard.html">Tablou de bord</a>

    <details id="questionsListMenu" class="menu-dropdown ${isQuestionsListPage ? "active" : ""}" ${isQuestionsListPage ? "open" : ""}>
      <summary class="nav-item nav-summary">Listă întrebări</summary>
      <div class="submenu-wrap">
        <a class="${navSubLinkClass(isQuestionsListPage && currentType === "tf")}" href="/portal/instructor/questions/list.html?type=tf">Adevărat / Fals</a>
        <a class="${navSubLinkClass(isQuestionsListPage && currentType === "abc_one")}" href="/portal/instructor/questions/list.html?type=abc_one">ABC One</a>
        <a class="${navSubLinkClass(isQuestionsListPage && currentType === "abc_multi")}" href="/portal/instructor/questions/list.html?type=abc_multi">ABC Multi</a>
        <a class="${navSubLinkClass(isQuestionsListPage && currentType === "match")}" href="/portal/instructor/questions/list.html?type=match">Asociere</a>
      </div>
    </details>

    <details id="questionsAddMenu" class="menu-dropdown ${isQuestionsAddPage ? "active" : ""}" ${isQuestionsAddPage ? "open" : ""}>
      <summary class="nav-item nav-summary">Adaugă întrebări</summary>
      <div class="submenu-wrap">
        <a class="${navSubLinkClass(isQuestionsAddPage && currentType === "tf")}" href="/portal/instructor/questions/add.html?type=tf">Adevărat / Fals</a>
        <a class="${navSubLinkClass(isQuestionsAddPage && currentType === "abc_one")}" href="/portal/instructor/questions/add.html?type=abc_one">ABC One</a>
        <a class="${navSubLinkClass(isQuestionsAddPage && currentType === "abc_multi")}" href="/portal/instructor/questions/add.html?type=abc_multi">ABC Multi</a>
        <a class="${navSubLinkClass(isQuestionsAddPage && currentType === "match")}" href="/portal/instructor/questions/add.html?type=match">Asociere</a>
      </div>
    </details>

    <a class="${navLinkClass(isStudentsPage)} nav-item-link" href="/portal/instructor/students/list.html">Studenți</a>
  </nav>

  <div class="sidebar-footer">
    <button id="logoutBtn" class="btn danger">Deconectare</button>
  </div>
`;

const toggleButton = document.createElement("button");
toggleButton.className = "menu-toggle";
toggleButton.id = "menuToggle";
toggleButton.type = "button";
toggleButton.setAttribute("aria-label", "Deschide meniul");
toggleButton.textContent = "☰";

const overlay = document.createElement("div");
overlay.className = "overlay";
overlay.id = "menuOverlay";

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

document.querySelectorAll(".nav-item-link, .nav-subitem").forEach((link) => {
  link.addEventListener("click", closeMenu);
});

const listMenu = document.getElementById("questionsListMenu");
const addMenu = document.getElementById("questionsAddMenu");

// Force initial accordion state to match current page,
// avoiding browser-restored open states where both groups appear active.
if (listMenu && addMenu) {
  listMenu.open = isQuestionsListPage;
  addMenu.open = isQuestionsAddPage;
}

const dropdowns = Array.from(document.querySelectorAll(".menu-dropdown"));
dropdowns.forEach((details) => {
  details.addEventListener("toggle", () => {
    if (!details.open) return;
    dropdowns.forEach((other) => {
      if (other !== details) {
        other.open = false;
      }
    });
  });
});

const logoutButton = document.getElementById("logoutBtn");

if (logoutButton) {
  logoutButton.addEventListener("click", async () => {
    await supabase.auth.signOut();
    window.location.href = "/login.html";
  });
}