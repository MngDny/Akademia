const errorEl = document.getElementById("error");
const successEl = document.getElementById("success");
const button = document.getElementById("registerBtn");
const btnText = document.getElementById("btnText");
const spinner = document.getElementById("spinner");

const USERNAME_RE = /^[a-z0-9._-]{3,24}$/;
const EMAIL_RE = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
const PASSWORD_RE = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z\d]).{10,72}$/;

button.addEventListener("click", onRegister);
document.addEventListener("keydown", (event) => {
  if (event.key === "Enter") {
    onRegister();
  }
});

async function onRegister() {
  clearMessages();

  const username = String(document.getElementById("username").value || "")
    .trim()
    .toLowerCase();
  const email = String(document.getElementById("email").value || "").trim().toLowerCase();
  const password = String(document.getElementById("password").value || "");
  const confirmPassword = String(document.getElementById("confirmPassword").value || "");

  if (!USERNAME_RE.test(username)) {
    showError("Username invalid. Folosește 3-24 caractere: litere mici, cifre, . _ -");
    return;
  }

  if (!EMAIL_RE.test(email) || email.length > 120) {
    showError("Email invalid.");
    return;
  }

  if (!PASSWORD_RE.test(password)) {
    showError("Parola trebuie să aibă 10-72 caractere, cu litere mari/mici, cifră și simbol.");
    return;
  }

  if (password !== confirmPassword) {
    showError("Parolele nu coincid.");
    return;
  }

  setLoading(true);

  try {
    const response = await fetch("/.netlify/functions/register-student", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ username, email, password }),
    });

    const data = await response.json();

    if (!response.ok) {
      showError(data?.error || "Nu s-a putut crea contul.");
      return;
    }

    showSuccess("Cont student creat cu succes. Vei fi redirecționat la autentificare...");

    setTimeout(() => {
      window.location.href = "/login.html";
    }, 1400);
  } catch (error) {
    console.error(error);
    showError("Eroare de rețea. Încearcă din nou.");
  } finally {
    setLoading(false);
  }
}

function setLoading(isLoading) {
  button.disabled = isLoading;
  btnText.innerText = isLoading ? "Se creează contul..." : "Creează cont student";
  spinner.classList.toggle("hidden", !isLoading);
}

function clearMessages() {
  errorEl.textContent = "";
  successEl.textContent = "";
}

function showError(message) {
  setLoading(false);
  errorEl.textContent = message;
}

function showSuccess(message) {
  successEl.textContent = message;
}
