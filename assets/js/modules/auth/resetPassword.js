import { supabase } from "../../core/supabaseClient.js";
import { initPasswordVisibility } from "../../core/passwordVisibility.js";

const errorEl = document.getElementById("error");
const successEl = document.getElementById("success");
const button = document.getElementById("resetBtn");
const btnText = document.getElementById("btnText");
const spinner = document.getElementById("spinner");

initPasswordVisibility();

const PASSWORD_RE = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z\d]).{10,72}$/;

button?.addEventListener("click", onResetPassword);

document.addEventListener("keydown", (event) => {
  if (event.key === "Enter") {
    onResetPassword();
  }
});

async function onResetPassword() {
  clearMessages();

  const newPassword = String(document.getElementById("newPassword")?.value || "");
  const confirmNewPassword = String(document.getElementById("confirmNewPassword")?.value || "");

  if (!PASSWORD_RE.test(newPassword)) {
    showError("Parola trebuie să aibă 10-72 caractere, cu litere mari/mici, cifră și simbol.");
    return;
  }

  if (newPassword !== confirmNewPassword) {
    showError("Parolele nu coincid.");
    return;
  }

  setLoading(true);

  try {
    const { data: sessionData, error: sessionError } = await supabase.auth.getSession();
    if (sessionError) {
      showError("Link de resetare invalid sau expirat. Cere un link nou.");
      return;
    }

    if (!sessionData?.session) {
      showError("Deschide această pagină din linkul primit pe email.");
      return;
    }

    const { error } = await supabase.auth.updateUser({
      password: newPassword,
    });

    if (error) {
      showError("Nu am putut actualiza parola. Încearcă din nou.");
      return;
    }

    showSuccess("Parola a fost actualizată. Vei fi redirecționat la autentificare...");

    await supabase.auth.signOut();
    setTimeout(() => {
      window.location.href = "/login.html";
    }, 1300);
  } catch (error) {
    console.error(error);
    showError("Eroare de rețea. Încearcă din nou.");
  } finally {
    setLoading(false);
  }
}

function setLoading(isLoading) {
  if (!button || !btnText || !spinner) return;
  button.disabled = isLoading;
  btnText.innerText = isLoading ? "Se actualizează..." : "Actualizează parola";
  spinner.classList.toggle("hidden", !isLoading);
}

function clearMessages() {
  if (errorEl) errorEl.textContent = "";
  if (successEl) successEl.textContent = "";
}

function showError(message) {
  setLoading(false);
  if (errorEl) errorEl.textContent = message;
}

function showSuccess(message) {
  if (successEl) successEl.textContent = message;
}
