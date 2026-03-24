import { initPasswordVisibility } from "../../core/passwordVisibility.js";

const supabase = window.supabase.createClient(
  "https://pdkfqytododevpilpxet.supabase.co",
  "sb_publishable_9SE72Dov4XTRfAGoXhL1Nw_kbdPfK4z",
);

let isCreatingUser = false;

async function init() {
  const {
    data: { session },
  } = await supabase.auth.getSession();

  if (!session) {
    window.location.href = "/login.html";
    return;
  }

  const username = session.user.user_metadata?.username;

  const { data: account } = await supabase
    .from("accounts")
    .select("role")
    .eq("username", username)
    .single();

  if (!account || account.role !== "admin") {
    await supabase.auth.signOut();
    window.location.href = "/login.html";
    return;
  }

  document.getElementById("logout").onclick = async () => {
    await supabase.auth.signOut();
    window.location.href = "/login.html";
  };

  const createUserForm = document.querySelector("#createUserSection form");
  if (createUserForm) {
    createUserForm.addEventListener("submit", createUser);
  }

  initPasswordVisibility();

  document.querySelectorAll(".menu-item").forEach((item) => {
    item.addEventListener("click", function () {
      if (window.innerWidth <= 768) {
        toggleMenu();
      }

      document
        .querySelectorAll(".menu-item")
        .forEach((i) => i.classList.remove("active"));

      this.classList.add("active");

      const section = this.dataset.section;

      document.getElementById("createUserSection").style.display =
        section === "create-user" ? "block" : "none";

      document.getElementById("manageUsersSection").style.display =
        section === "manage-users" ? "block" : "none";

      if (section === "manage-users") {
        loadUsers();
      }
    });
  });
}

async function createUser(event) {
  if (event) {
    event.preventDefault();
  }

  if (isCreatingUser) {
    return;
  }

  const email = document.getElementById("email").value.trim();
  const password = document.getElementById("password").value;
  const username = document.getElementById("username").value.trim();
  const role = document.getElementById("role").value;
  const result = document.getElementById("result");
  const createBtn = document.getElementById("createUserBtn");

  isCreatingUser = true;
  createBtn.disabled = true;
  result.innerText = "Se creează utilizatorul...";

  try {
    const res = await fetch("/.netlify/functions/create-user", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ email, password, username, role }),
    });

    const data = await res.json();

    if (res.ok) {
      result.innerText = "Utilizator creat!";
    } else {
      result.innerText = data.error || "Eroare la creare utilizator";
    }
  } catch (error) {
    console.error(error);
    result.innerText = "Eroare de rețea. Încearcă din nou.";
  } finally {
    isCreatingUser = false;
    createBtn.disabled = false;
  }
}
async function loadUsers() {
  const { data, error } = await supabase
    .from("accounts")
    .select("id, username, role");

  if (error) {
    console.error(error);
    return;
  }

  const container = document.getElementById("usersList");
  container.innerHTML = "";

  data.forEach((user) => {
    const row = document.createElement("div");
    row.className = "user-row";

    row.innerHTML = `
      <div class="user-info">
        <strong>${user.username}</strong>
        <span class="user-role">${user.role}</span>
      </div>
      <button class="delete-btn" onclick="deleteUser('${user.id}')">Șterge</button>
    `;

    container.appendChild(row);
  });
}

window.toggleMenu = function () {
  const sidebar = document.querySelector(".sidebar");
  const overlay = document.querySelector(".overlay");

  sidebar.classList.toggle("open");
  overlay.classList.toggle("active");
};
window.deleteUser = async function (id) {
  if (!confirm("Sigur vrei să ștergi userul?")) return;

  const res = await fetch("/.netlify/functions/delete-user", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ userId: id }),
  });

  if (res.ok) {
    loadUsers();
  } else {
    alert("Eroare la ștergere");
  }
};
init();
