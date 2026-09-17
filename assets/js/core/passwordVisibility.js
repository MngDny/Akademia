export function initPasswordVisibility(root = document) {
  const wrappers = Array.from(root.querySelectorAll(".password-wrapper"));

  wrappers.forEach((wrapper) => {
    const input = wrapper.querySelector("input");
    const toggle = wrapper.querySelector(".toggle-password");

    if (!input || !toggle) return;
    toggle.setAttribute("type", "button");

    const sync = () => {
      const isHidden = input.type === "password";
      toggle.innerHTML = `<img class="icon" src="/assets/icons/${isHidden ? "eye" : "eye-off"}.svg" alt="" aria-hidden="true">`;
      toggle.setAttribute("aria-label", isHidden ? "Arată parola" : "Ascunde parola");
      toggle.setAttribute("title", isHidden ? "Arată parola" : "Ascunde parola");
      toggle.setAttribute("aria-pressed", String(!isHidden));
    };

    sync();

    if (toggle.dataset.bound === "true") return;
    toggle.dataset.bound = "true";

    toggle.addEventListener("click", () => {
      input.type = input.type === "password" ? "text" : "password";
      sync();
    });
  });
}
