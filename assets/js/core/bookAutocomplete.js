import { normalizeBookKey } from "./bibleBooks.js";

function normalizeSearch(value) {
  return String(value || "")
    .toLowerCase()
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .trim();
}

function uniqueBooks(values) {
  const seen = new Set();
  return values
    .map((value) => String(value || "").trim())
    .filter((value) => {
      const key = normalizeBookKey(value);
      if (!key || seen.has(key)) return false;
      seen.add(key);
      return true;
    });
}

/**
 * Turns a text input into a searchable single-book picker.
 * The input stays usable as a live text filter while suggestions are shown.
 */
export function mountBookAutocomplete({
  input,
  options = [],
  onInput = () => {},
  onSelect = () => {},
  emptyText = "Nicio carte găsită.",
  maxVisible = 14,
} = {}) {
  if (!input) return null;

  const host = document.createElement("div");
  host.className = "book-autocomplete";
  input.parentNode.insertBefore(host, input);
  host.appendChild(input);

  const menu = document.createElement("div");
  menu.className = "book-autocomplete-menu";
  menu.id = `${input.id || "book"}-suggestions`;
  menu.setAttribute("role", "listbox");
  menu.hidden = true;
  host.appendChild(menu);

  const toggle = document.createElement("button");
  toggle.type = "button";
  toggle.className = "book-autocomplete-toggle";
  toggle.setAttribute("aria-label", "Deschide lista de cărți");
  toggle.setAttribute("aria-haspopup", "listbox");
  toggle.textContent = "⌄";
  host.appendChild(toggle);

  const clear = document.createElement("button");
  clear.type = "button";
  clear.className = "book-autocomplete-clear";
  clear.setAttribute("aria-label", "Șterge filtrul de carte");
  clear.textContent = "×";
  clear.hidden = true;
  host.appendChild(clear);

  input.setAttribute("role", "combobox");
  input.setAttribute("aria-autocomplete", "list");
  input.setAttribute("aria-controls", menu.id);
  input.setAttribute("aria-expanded", "false");

  let bookOptions = uniqueBooks(options);
  let activeIndex = -1;
  let selectedValue = "";

  function setExpanded(expanded) {
    menu.hidden = !expanded;
    input.setAttribute("aria-expanded", String(expanded));
    toggle.setAttribute("aria-label", expanded ? "Închide lista de cărți" : "Deschide lista de cărți");
    host.classList.toggle("is-open", expanded);
  }

  function visibleOptions() {
    const query = normalizeSearch(input.value);
    if (!query) return bookOptions.slice(0, maxVisible);
    return bookOptions
      .filter((book) => normalizeSearch(book).includes(query))
      .slice(0, maxVisible);
  }

  function updateClearButton() {
    clear.hidden = !input.value;
  }

  function renderMenu() {
    const matches = visibleOptions();
    activeIndex = Math.min(activeIndex, matches.length - 1);
    menu.replaceChildren();

    if (!matches.length) {
      const empty = document.createElement("p");
      empty.className = "book-autocomplete-empty";
      empty.textContent = emptyText;
      menu.appendChild(empty);
      return matches;
    }

    matches.forEach((book, index) => {
      const option = document.createElement("button");
      option.type = "button";
      option.className = "book-autocomplete-option";
      option.textContent = book;
      option.setAttribute("role", "option");
      option.setAttribute("aria-selected", String(index === activeIndex));
      option.addEventListener("mousedown", (event) => event.preventDefault());
      option.addEventListener("click", () => select(book));
      menu.appendChild(option);
    });

    return matches;
  }

  function select(book, { notify = true } = {}) {
    selectedValue = book;
    input.value = book;
    updateClearButton();
    setExpanded(false);
    activeIndex = -1;
    if (notify) onSelect(book);
  }

  function open() {
    activeIndex = -1;
    renderMenu();
    setExpanded(true);
  }

  function clearValue() {
    selectedValue = "";
    input.value = "";
    updateClearButton();
    setExpanded(false);
    onInput("");
    input.focus();
  }

  input.addEventListener("focus", open);
  input.addEventListener("input", () => {
    const exact = bookOptions.find((book) => normalizeBookKey(book) === normalizeBookKey(input.value));
    selectedValue = exact || "";
    updateClearButton();
    open();
    onInput(input.value);
  });
  input.addEventListener("keydown", (event) => {
    const matches = visibleOptions();
    if (event.key === "ArrowDown") {
      event.preventDefault();
      if (menu.hidden) open();
      activeIndex = Math.min(activeIndex + 1, matches.length - 1);
      renderMenu();
    } else if (event.key === "ArrowUp") {
      event.preventDefault();
      if (menu.hidden) open();
      activeIndex = Math.max(activeIndex - 1, 0);
      renderMenu();
    } else if (event.key === "Enter" && !menu.hidden && activeIndex >= 0 && matches[activeIndex]) {
      event.preventDefault();
      select(matches[activeIndex]);
    } else if (event.key === "Escape") {
      setExpanded(false);
    }
  });

  clear.addEventListener("click", clearValue);
  toggle.addEventListener("click", () => {
    if (menu.hidden) {
      input.focus();
      open();
    } else {
      setExpanded(false);
    }
  });
  document.addEventListener("click", (event) => {
    if (!host.contains(event.target)) setExpanded(false);
  });

  updateClearButton();

  return {
    setOptions(nextOptions = []) {
      bookOptions = uniqueBooks(nextOptions);
      const exact = bookOptions.find((book) => normalizeBookKey(book) === normalizeBookKey(input.value));
      selectedValue = exact || "";
      if (!menu.hidden) renderMenu();
    },
    setValue(value = "", { notify = false } = {}) {
      const exact = bookOptions.find((book) => normalizeBookKey(book) === normalizeBookKey(value));
      selectedValue = exact || "";
      input.value = exact || String(value || "");
      updateClearButton();
      if (notify) onSelect(selectedValue || input.value);
    },
    getValue() {
      return selectedValue || input.value.trim();
    },
    getSelectedValue() {
      return selectedValue;
    },
    clear: clearValue,
  };
}
