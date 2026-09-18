// A single navigation and mobile-menu implementation for every portal.
export const icon = (name, extraClass = "") =>
  `<img class="icon ${extraClass}" src="/assets/icons/${name}.svg" alt="" aria-hidden="true" width="19" height="19">`;

const roles = { student: "Student", instructor: "Îndrumător", admin: "Administrator" };
const questionTypes = [
  ["tf", "Adevărat / Fals"], ["abc_one", "Un singur răspuns"],
  ["abc_multi", "Răspunsuri multiple"], ["match", "Asociere"],
];

export function mountPortal(role, { onLogout } = {}) {
  const sidebar = document.getElementById("sidebar");
  const main = document.querySelector("main");
  if (!sidebar || !main) return;
  const path = window.location.pathname;
  const type = new URLSearchParams(window.location.search).get("type") || "tf";
  const link = (href, label, symbol, active = path === href, sub = false) =>
    `<a class="${sub ? "nav-subitem" : "nav-item"}${active ? " active" : ""}" href="${href}"${active ? ' aria-current="page"' : ""}>${symbol ? icon(symbol) : ""}<span>${label}</span></a>`;
  const group = (page, label, symbol) => {
    const active = path === `/portal/instructor/questions/${page}.html`;
    return `<details class="menu-dropdown${active ? " active" : ""}" ${active ? "open" : ""}>
      <summary class="nav-item nav-summary">${icon(symbol)}<span>${label}</span>${icon("chevron-down", "chevron")}</summary>
      <div class="submenu-wrap">${questionTypes.map(([key, title]) => link(`/portal/instructor/questions/${page}.html?type=${key}`, title, null, active && type === key, true)).join("")}</div>
    </details>`;
  };
  let navigation = "";
  if (role === "student") {
    navigation = [
      ["dashboard", "Privire de ansamblu", "layout-dashboard"],
      ["bibliography", "Bibliografie", "book-open"],
      ["learning", "Mediu de învățare", "book-open"],
      ["quiz", "Test nou", "clipboard-check"],
      ["results", "Rezultatele mele", "chart-no-axes-combined"],
      ["leaderboard", "Clasament", "trophy"],
      ["reports", "Raportările mele", "shield-check"],
    ].map(([page, title, symbol]) => link(`/portal/student/${page}.html`, title, symbol)).join("");
  } else if (role === "instructor") {
    navigation = link("/portal/instructor/dashboard.html", "Privire de ansamblu", "layout-dashboard") +
      link("/portal/instructor/bibliography.html", "Bibliografie", "book-open") +
      group("list", "Biblioteca de întrebări", "book-open") + group("add", "Adaugă întrebare", "plus") +
      link("/portal/instructor/questions/import.html", "Import cu AI", "upload") +
      link("/portal/instructor/tests/create.html", "Generează test", "clipboard-check") +
      link("/portal/instructor/students/list.html", "Studenți", "users") +
      link("/portal/student/leaderboard.html", "Clasament", "trophy") +
      link("/portal/instructor/reports.html", "Raportări", "shield-check");
  } else {
    const adminSection = new URLSearchParams(window.location.hash.slice(1)).get("section") || "create-user";
    const dashboardPath = "/portal/admin/dashboard.html";
    const createActive = path === dashboardPath && adminSection === "create-user";
    const manageActive = path === dashboardPath && adminSection === "manage-users";
    navigation = `<a class="menu-item${createActive ? " active" : ""}" data-section="create-user" href="${dashboardPath}#section=create-user" aria-controls="createUserSection"${createActive ? ' aria-current="page"' : ""}>${icon("plus")}<span>Creează utilizator</span></a>
      <a class="menu-item${manageActive ? " active" : ""}" data-section="manage-users" href="${dashboardPath}#section=manage-users" aria-controls="manageUsersSection"${manageActive ? ' aria-current="page"' : ""}>${icon("users")}<span>Utilizatori</span></a>
      ${link("/portal/admin/bibliography.html", "Bibliografie", "book-open")}
      ${link("/portal/student/leaderboard.html", "Clasament", "trophy")}
      ${link("/portal/admin/reports.html", "Raportări", "shield-check")}`;
  }
  sidebar.setAttribute("aria-label", `Navigare ${roles[role]}`);
  sidebar.innerHTML = `
    <a class="brand" href="/portal/${role}/dashboard.html"><img src="/assets/favicon.svg" alt="" width="36" height="36">akademia</a>
    <button class="menu-close" type="button" aria-label="Închide meniul">${icon("x")}</button>
    <div class="brand-subtitle">Portal ${roles[role]}</div>
    <p class="nav-section-title">Spațiul tău</p>
    <nav class="nav" aria-label="Meniu principal">${navigation}</nav>
    <div class="sidebar-footer">
      <div class="sidebar-note"><strong>${role === "student" ? "Puțin în fiecare zi." : "Împreună, mai departe."}</strong><p>${role === "student" ? "Fiecare întrebare te aduce mai aproape de următorul tău progres." : "Un spațiu organizat pentru învățare și pentru oamenii din spatele ei."}</p></div>
      <button id="logoutBtn" class="logout-btn" type="button">${icon("log-out")}Deconectare</button>
      <p id="navigationStatus" class="muted" role="status"></p>
    </div>`;

  main.id = "main-content";
  main.tabIndex = -1;
  const skip = document.createElement("a");
  skip.className = "skip-link";
  skip.href = "#main-content";
  skip.textContent = "Sari la conținut";
  document.body.prepend(skip);
  const toggle = document.createElement("button");
  toggle.type = "button";
  toggle.className = "menu-toggle";
  toggle.setAttribute("aria-label", "Deschide meniul");
  toggle.setAttribute("aria-controls", "sidebar");
  toggle.setAttribute("aria-expanded", "false");
  toggle.innerHTML = icon("menu");
  const overlay = document.createElement("div");
  overlay.className = "overlay";
  overlay.setAttribute("aria-hidden", "true");
  document.body.append(toggle, overlay);
  const mobile = window.matchMedia("(max-width: 960px)");
  let previouslyFocused = null;
  function setMenu(open, restoreFocus = true) {
    open = open && mobile.matches;
    if (open) previouslyFocused = document.activeElement;
    sidebar.classList.toggle("open", open);
    overlay.classList.toggle("active", open);
    document.body.classList.toggle("menu-open", open);
    toggle.setAttribute("aria-expanded", String(open));
    toggle.setAttribute("aria-label", open ? "Închide meniul" : "Deschide meniul");
    sidebar.inert = mobile.matches && !open;
    main.inert = open;
    if (open) sidebar.querySelector(".menu-close").focus();
    else if (restoreFocus && previouslyFocused) { previouslyFocused.focus(); previouslyFocused = null; }
  }
  setMenu(false, false);
  toggle.addEventListener("click", () => setMenu(!sidebar.classList.contains("open")));
  sidebar.querySelector(".menu-close").addEventListener("click", () => setMenu(false));
  overlay.addEventListener("click", () => setMenu(false));
  mobile.addEventListener("change", () => setMenu(false));
  document.addEventListener("keydown", (event) => {
    if (!sidebar.classList.contains("open")) return;
    if (event.key === "Escape") { event.preventDefault(); setMenu(false); }
    if (event.key !== "Tab") return;
    const focusable = [...sidebar.querySelectorAll("a[href], button:not(:disabled), summary")].filter(el => !el.closest("details:not([open]) .submenu-wrap"));
    const first = focusable[0], last = focusable.at(-1);
    if (event.shiftKey && document.activeElement === first) { event.preventDefault(); last.focus(); }
    else if (!event.shiftKey && document.activeElement === last) { event.preventDefault(); first.focus(); }
  });
  sidebar.querySelectorAll("a, .menu-item").forEach(el => el.addEventListener("click", () => setMenu(false)));
  const logout = sidebar.querySelector("#logoutBtn");
  logout.addEventListener("click", async () => {
    logout.disabled = true;
    try { await onLogout?.(); }
    catch { sidebar.querySelector("#navigationStatus").textContent = "Deconectarea nu a reușit. Încearcă din nou."; }
    finally { logout.disabled = false; }
  });
  return { closeMenu: () => setMenu(false) };
}
