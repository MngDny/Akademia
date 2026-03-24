import { supabase } from "../../core/supabaseClient.js";
import { normalizeRole } from "../../core/authGuard.js";
import { initPasswordVisibility } from "../../core/passwordVisibility.js";

const errorEl = document.getElementById("error");
const successEl = document.getElementById("success");
const button = document.getElementById("loginBtn");
const btnText = document.getElementById("btnText");
const spinner = document.getElementById("spinner");
const forgotPasswordLink = document.getElementById("forgotPasswordLink");

initPasswordVisibility();

button.addEventListener("click", login);
forgotPasswordLink?.addEventListener("click", onForgotPassword);

async function login() {
  clearMessages();

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

async function onForgotPassword(event) {
  event.preventDefault();
  clearMessages();

  const email = String(document.getElementById("email")?.value || "").trim().toLowerCase();
  if (!email) {
    showError("Introdu email-ul ca să trimitem linkul de resetare.");
    return;
  }

  button.disabled = true;
  btnText.innerText = "Se trimite linkul...";
  spinner.classList.remove("hidden");

  try {
    const redirectTo = `${window.location.origin}/reset-password.html`;
    const { error } = await supabase.auth.resetPasswordForEmail(email, {
      redirectTo,
    });

    if (error) {
      showError("Nu am putut trimite email-ul de resetare. Verifică adresa introdusă.");
      return;
    }

    showSuccess("Am trimis linkul de resetare pe email. Verifică inbox-ul și spam-ul.");
  } catch (error) {
    console.error(error);
    showError("Eroare de rețea. Încearcă din nou.");
  } finally {
    button.disabled = false;
    btnText.innerText = "Autentificare";
    spinner.classList.add("hidden");
  }
}

function clearMessages() {
  errorEl.innerText = "";
  if (successEl) {
    successEl.innerText = "";
  }
}

function showError(message) {
  clearMessages();
  errorEl.innerText = message;
  button.disabled = false;
  btnText.innerText = "Autentificare";
  spinner.classList.add("hidden");
}

function showSuccess(message) {
  clearMessages();
  if (successEl) {
    successEl.innerText = message;
  }
}

function redirectByRole(role) {
  const normalizedRole = normalizeRole(role);

  if (normalizedRole === "admin") {
    window.location.href = "/portal/admin/dashboard.html";
  } else if (normalizedRole === "instructor") {
    window.location.href = "/portal/instructor/dashboard.html";
  } else {
    window.location.href = "/portal/student/dashboard.html";
  }
}
