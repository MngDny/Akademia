import { supabase } from "../../core/supabaseClient.js";

const errorEl = document.getElementById("error");
const button = document.getElementById("loginBtn");
const btnText = document.getElementById("btnText");
const spinner = document.getElementById("spinner");

button.addEventListener("click", login);

async function login() {
  errorEl.innerText = "";

  // loading state
  button.disabled = true;
  btnText.innerText = "Se autentifică...";
  spinner.classList.remove("hidden");

  const email = document.getElementById("email").value;
  const password = document.getElementById("password").value;

  const { data, error } = await supabase.auth.signInWithPassword({
    email,
    password
  });

  if (error) {
    showError("Email sau parolă incorectă.");
    return;
  }

  const user = data.user;
  const username = user.user_metadata?.username;

  if (!username) {
    showError("Profil invalid.");
    return;
  }

  const { data: account, error: accError } = await supabase
    .from("accounts")
    .select("role")
    .eq("username", username)
    .single();

  if (accError || !account) {
    showError("Contul nu este configurat.");
    return;
  }

  redirectByRole(account.role);
}

function showError(message) {
  errorEl.innerText = message;
  button.disabled = false;
  btnText.innerText = "Autentificare";
  spinner.classList.add("hidden");
}

function redirectByRole(role) {
  if (role === "admin") {
    window.location.href = "/portal/admin/dashboard.html";
  } else if (role === "indrumator") {
    window.location.href = "/portal/indrumator/dashboard.html";
  } else {
    window.location.href = "/portal/participant/dashboard.html";
  }
}
