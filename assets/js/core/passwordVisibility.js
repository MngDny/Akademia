export function initPasswordVisibility(root = document) {
  const wrappers = Array.from(root.querySelectorAll(".password-wrapper"));

  wrappers.forEach((wrapper) => {
    const input = wrapper.querySelector("input");
    const toggle = wrapper.querySelector(".toggle-password");

    if (!input || !toggle) return;
    if (toggle.dataset.bound === "true") return;

    toggle.dataset.bound = "true";
    toggle.setAttribute("type", "button");

    const sync = () => {
      const isHidden = input.type === "password";
      toggle.textContent = isHidden ? "👁" : "🙈";
      toggle.setAttribute("aria-label", isHidden ? "Arată parola" : "Ascunde parola");
      toggle.setAttribute("title", isHidden ? "Arată parola" : "Ascunde parola");
    };

    sync();

    toggle.addEventListener("click", () => {
      input.type = input.type === "password" ? "text" : "password";
      sync();
    });
  });
}
