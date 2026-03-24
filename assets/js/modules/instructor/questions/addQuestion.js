// addQuestion.js

import { supabase } from "../../../core/supabaseClient.js";
import { requireRole } from "../../../core/authGuard.js";
import { getTypeFromUrl, mustGetConfig } from "./config.js";

const els = {
  pageTitle: document.getElementById("pageTitle"),
  pageSubtitle: document.getElementById("pageSubtitle"),
  backBtn: document.getElementById("backBtn"),
  formHost: document.getElementById("formHost"),
  saveBtn: document.getElementById("saveBtn"),
  result: document.getElementById("result"),
};

const REQUIRED_MATCH_PAIRS = 5;

let activeType = "tf";
let activeCfg = null;
let activeUsername = "";
let editId = null;
let bookDropdownOpen = false;
let bookOutsideClickBound = false;

const BIBLE_BOOK_OPTIONS = [
  "Geneza",
  "Exodul",
  "Leviticul",
  "Numeri",
  "Deuteronomul",
  "Iosua",
  "Judecatori",
  "Rut",
  "1 Samuel",
  "2 Samuel",
  "1 Regi",
  "2 Regi",
  "1 Cronici",
  "2 Cronici",
  "Ezra",
  "Neemia",
  "Estera",
  "Iov",
  "Psalmii",
  "Proverbele",
  "Eclesiastul",
  "Cantarea Cantarilor",
  "Isaia",
  "Ieremia",
  "Plangerile lui Ieremia",
  "Ezechiel",
  "Daniel",
  "Osea",
  "Ioel",
  "Amos",
  "Obadia",
  "Iona",
  "Mica",
  "Naum",
  "Habacuc",
  "Tefania",
  "Hagai",
  "Zaharia",
  "Maleahi",
  "Matei",
  "Marcu",
  "Luca",
  "Ioan",
  "Faptele Apostolilor",
  "Romani",
  "1 Corinteni",
  "2 Corinteni",
  "Galateni",
  "Efeseni",
  "Filipeni",
  "Coloseni",
  "1 Tesaloniceni",
  "2 Tesaloniceni",
  "1 Timotei",
  "2 Timotei",
  "Tit",
  "Filimon",
  "Evrei",
  "Iacov",
  "1 Petru",
  "2 Petru",
  "1 Ioan",
  "2 Ioan",
  "3 Ioan",
  "Iuda",
  "Apocalipsa",
];

function normalizeSearchText(value) {
  return String(value || "")
    .toLowerCase()
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "");
}

function renderMetadataFields() {
  return `
    <div class="metadata-grid">
      <div>
        <label class="label" for="chapterInput">Capitol</label>
        <input id="chapterInput" class="input" type="number" min="1" placeholder="Ex: 3" />
      </div>

      <div>
        <label class="label" for="difficultyInput">Dificultate</label>
        <input id="difficultyInput" class="input" type="number" min="1" max="5" placeholder="1-5" />
      </div>

      <div>
        <label class="label" for="bookInput">Carte</label>
        <div class="book-combobox" id="bookCombobox">
          <input id="bookInput" class="input" type="text" placeholder="Alege cartea biblică" autocomplete="off" />
          <button id="bookToggleBtn" class="book-toggle-btn" type="button" aria-label="Deschide lista de cărți">▼</button>
          <div id="bookDropdown" class="book-dropdown" hidden></div>
        </div>
      </div>

      <div>
        <label class="label" for="statusInput">Status</label>
        <select id="statusInput" class="input">
          <option value="active">Activ</option>
          <option value="draft">Ciornă</option>
          <option value="archived">Arhivat</option>
        </select>
      </div>
    </div>
  `;
}

function renderTypeSpecificFields(type) {
  if (type === "match") {
    return `
      <label class="label">Perechi (stânga -> dreapta)</label>
      <div class="pairs-grid">
        <input class="input pair-left" data-index="0" placeholder="Stânga 1" />
        <input class="input pair-right" data-index="0" placeholder="Dreapta 1" />
        <input class="input pair-left" data-index="1" placeholder="Stânga 2" />
        <input class="input pair-right" data-index="1" placeholder="Dreapta 2" />
        <input class="input pair-left" data-index="2" placeholder="Stânga 3" />
        <input class="input pair-right" data-index="2" placeholder="Dreapta 3" />
        <input class="input pair-left" data-index="3" placeholder="Stânga 4" />
        <input class="input pair-right" data-index="3" placeholder="Dreapta 4" />
        <input class="input pair-left" data-index="4" placeholder="Stânga 5" />
        <input class="input pair-right" data-index="4" placeholder="Dreapta 5" />
      </div>
      <p class="muted">Sunt necesare exact ${REQUIRED_MATCH_PAIRS} perechi pentru întrebarea de asociere.</p>
    `;
  }

  const optionsBlock =
    type === "tf"
      ? `
        <label class="label">Răspuns corect</label>
        <input type="hidden" id="tfCorrectInput" value="true" />
        <div class="answer-chip-group" id="tfAnswerGroup">
          <button type="button" class="answer-chip is-selected" data-kind="tf" data-value="true">Adevărat</button>
          <button type="button" class="answer-chip" data-kind="tf" data-value="false">Fals</button>
        </div>
      `
      : `
        <label class="label">Opțiuni răspuns</label>
        <div class="options-grid">
          <input class="input option-input" data-index="0" placeholder="Opțiunea 1" />
          <input class="input option-input" data-index="1" placeholder="Opțiunea 2" />
          <input class="input option-input" data-index="2" placeholder="Opțiunea 3" />
        </div>

        <label class="label">Răspuns corect</label>
        ${
          type === "abc_one"
            ? `
              <input type="hidden" id="correctOneInput" value="0" />
              <div class="answer-chip-group" id="correctOneGroup">
                <button type="button" class="answer-chip is-selected" data-kind="one" data-index="0">Opțiunea 1</button>
                <button type="button" class="answer-chip" data-kind="one" data-index="1">Opțiunea 2</button>
                <button type="button" class="answer-chip" data-kind="one" data-index="2">Opțiunea 3</button>
              </div>
            `
            : `
              <div class="answer-chip-group" id="correctMultiGroup">
                <button type="button" class="answer-chip" data-kind="multi" data-index="0">Opțiunea 1</button>
                <button type="button" class="answer-chip" data-kind="multi" data-index="1">Opțiunea 2</button>
                <button type="button" class="answer-chip" data-kind="multi" data-index="2">Opțiunea 3</button>
              </div>
            `
        }
      `;

  return `
    <label class="label" for="textInput">Text întrebare</label>
    <textarea id="textInput" class="textarea" rows="4" placeholder="Scrie întrebarea..."></textarea>
    ${optionsBlock}
  `;
}

function renderForm(type) {
  els.formHost.innerHTML = `
    ${renderMetadataFields()}
    ${renderTypeSpecificFields(type)}
  `;

  bindBookComboboxInteractions();
  bindAnswerInteractions(type);
}

function renderBookDropdown(filterText = "") {
  const dropdown = document.getElementById("bookDropdown");
  if (!dropdown) return;

  const needle = normalizeSearchText(filterText);
  const options = needle
    ? BIBLE_BOOK_OPTIONS.filter((book) => normalizeSearchText(book).includes(needle))
    : BIBLE_BOOK_OPTIONS;

  if (!options.length) {
    dropdown.innerHTML = '<p class="book-dropdown-empty">Nicio carte găsită.</p>';
    return;
  }

  dropdown.innerHTML = options
    .map((book) => `<button type="button" class="book-option" data-book="${book}">${book}</button>`)
    .join("");

  dropdown.querySelectorAll(".book-option").forEach((btn) => {
    btn.addEventListener("click", () => {
      const input = document.getElementById("bookInput");
      if (input) {
        input.value = btn.dataset.book || "";
      }
      closeBookDropdown();
    });
  });
}

function openBookDropdown() {
  const dropdown = document.getElementById("bookDropdown");
  const combobox = document.getElementById("bookCombobox");
  const input = document.getElementById("bookInput");
  if (!dropdown || !combobox || !input) return;

  renderBookDropdown(input.value || "");
  dropdown.hidden = false;
  combobox.classList.add("is-open");
  bookDropdownOpen = true;
}

function closeBookDropdown() {
  const dropdown = document.getElementById("bookDropdown");
  const combobox = document.getElementById("bookCombobox");
  if (!dropdown || !combobox) return;

  dropdown.hidden = true;
  combobox.classList.remove("is-open");
  bookDropdownOpen = false;
}

function bindBookComboboxInteractions() {
  const input = document.getElementById("bookInput");
  const toggle = document.getElementById("bookToggleBtn");
  const combobox = document.getElementById("bookCombobox");

  if (!input || !toggle || !combobox) return;

  input.addEventListener("focus", () => {
    openBookDropdown();
  });

  input.addEventListener("input", () => {
    openBookDropdown();
    renderBookDropdown(input.value || "");
  });

  input.addEventListener("keydown", (event) => {
    if (event.key === "Escape") {
      closeBookDropdown();
    }
  });

  toggle.addEventListener("click", () => {
    if (bookDropdownOpen) {
      closeBookDropdown();
      return;
    }
    openBookDropdown();
  });

  if (!bookOutsideClickBound) {
    document.addEventListener("click", (event) => {
      const currentCombobox = document.getElementById("bookCombobox");
      if (!currentCombobox) return;
      if (!currentCombobox.contains(event.target)) {
        closeBookDropdown();
      }
    });
    bookOutsideClickBound = true;
  }
}

function setSingleChipSelection(selector, value) {
  const chips = Array.from(document.querySelectorAll(selector));
  chips.forEach((chip) => {
    chip.classList.toggle("is-selected", chip.dataset.value === String(value) || chip.dataset.index === String(value));
  });
}

function updateOptionChipLabels() {
  const optionInputs = Array.from(document.querySelectorAll(".option-input"));
  optionInputs.forEach((input, index) => {
    const label = input.value.trim() || `Opțiunea ${index + 1}`;

    const oneChip = document.querySelector(`#correctOneGroup .answer-chip[data-index='${index}']`);
    if (oneChip) oneChip.textContent = label;

    const multiChip = document.querySelector(`#correctMultiGroup .answer-chip[data-index='${index}']`);
    if (multiChip) multiChip.textContent = label;
  });
}

function bindAnswerInteractions(type) {
  if (type === "tf") {
    const hidden = document.getElementById("tfCorrectInput");
    document.querySelectorAll("#tfAnswerGroup .answer-chip").forEach((chip) => {
      chip.addEventListener("click", () => {
        hidden.value = chip.dataset.value;
        setSingleChipSelection("#tfAnswerGroup .answer-chip", chip.dataset.value);
      });
    });
    return;
  }

  document.querySelectorAll(".option-input").forEach((input) => {
    input.addEventListener("input", updateOptionChipLabels);
  });
  updateOptionChipLabels();

  if (type === "abc_one") {
    const hidden = document.getElementById("correctOneInput");
    document.querySelectorAll("#correctOneGroup .answer-chip").forEach((chip) => {
      chip.addEventListener("click", () => {
        hidden.value = chip.dataset.index;
        setSingleChipSelection("#correctOneGroup .answer-chip", chip.dataset.index);
      });
    });
    return;
  }

  document.querySelectorAll("#correctMultiGroup .answer-chip").forEach((chip) => {
    chip.addEventListener("click", () => {
      chip.classList.toggle("is-selected");
    });
  });
}

function setCommonValues(row) {
  document.getElementById("chapterInput").value = row.chapter ?? "";
  document.getElementById("difficultyInput").value = row.difficulty ?? "";
  const rowBook = String(row.book || "").trim();
  document.getElementById("bookInput").value = rowBook;

  if (rowBook && !BIBLE_BOOK_OPTIONS.some((book) => book.toLowerCase() === rowBook.toLowerCase())) {
    BIBLE_BOOK_OPTIONS.push(rowBook);
  }

  document.getElementById("statusInput").value = row.status || "active";
}

function setOptionsValues(row, type) {
  document.getElementById("textInput").value = row.text || "";

  const options = Array.isArray(row.options) ? row.options : [];

  if (type === "tf") {
    const trueOption = options.find((o) => String(o?.text || "").toLowerCase() === "adevărat");
    const selected = trueOption?.correct ? "true" : "false";
    const hidden = document.getElementById("tfCorrectInput");
    if (hidden) hidden.value = selected;
    setSingleChipSelection("#tfAnswerGroup .answer-chip", selected);
    return;
  }

  const optionInputs = Array.from(document.querySelectorAll(".option-input"));
  optionInputs.forEach((input, index) => {
    const value = options[index]?.text ?? "";
    input.value = value;
  });
  updateOptionChipLabels();

  if (type === "abc_one") {
    const correctIndex = options.findIndex((o) => Boolean(o?.correct));
    const safeIndex = correctIndex >= 0 && correctIndex <= 2 ? correctIndex : 0;
    const hidden = document.getElementById("correctOneInput");
    if (hidden) hidden.value = String(safeIndex);
    setSingleChipSelection("#correctOneGroup .answer-chip", safeIndex);
    return;
  }

  const chips = Array.from(document.querySelectorAll("#correctMultiGroup .answer-chip"));
  chips.forEach((chip, index) => {
    chip.classList.toggle("is-selected", Boolean(options[index]?.correct));
  });
}

function setPairsValues(row) {
  const pairs = Array.isArray(row.pairs) ? row.pairs : [];
  const leftEls = Array.from(document.querySelectorAll(".pair-left"));
  const rightEls = Array.from(document.querySelectorAll(".pair-right"));

  leftEls.forEach((leftEl, index) => {
    const pair = pairs[index] || {};
    leftEl.value = pair.left ?? pair.stanga ?? "";
    rightEls[index].value = pair.right ?? pair.dreapta ?? "";
  });
}

async function loadForEdit() {
  if (!editId) return;

  const { data, error } = await supabase
    .from(activeCfg.table)
    .select("*")
    .eq("id", editId)
    .single();

  if (error || !data) {
    console.error(error);
    els.result.textContent = "Nu am putut încărca întrebarea pentru editare.";
    return;
  }

  setCommonValues(data);

  if (activeCfg.dataKind === "pairs") {
    setPairsValues(data);
  } else {
    setOptionsValues(data, activeType);
  }
}

function readCommonPayload() {
  const chapter = Number.parseInt(document.getElementById("chapterInput")?.value || "", 10);
  const difficulty = Number.parseInt(document.getElementById("difficultyInput")?.value || "", 10);
  const bookRaw = (document.getElementById("bookInput")?.value || "").trim();
  const status = (document.getElementById("statusInput")?.value || "active").trim();

  const matchedBook = BIBLE_BOOK_OPTIONS.find(
    (item) => item.toLowerCase() === bookRaw.toLowerCase(),
  );

  if (!Number.isInteger(chapter) || chapter <= 0) {
    throw new Error("Capitolul trebuie să fie un număr întreg mai mare decât 0.");
  }

  if (!Number.isInteger(difficulty) || difficulty <= 0) {
    throw new Error("Dificultatea trebuie să fie un număr întreg mai mare decât 0.");
  }

  if (!matchedBook) {
    throw new Error("Selectează o carte validă din lista de sugestii.");
  }

  const payload = {
    chapter,
    difficulty,
    book: matchedBook,
    status,
    added_by: activeUsername || "necunoscut",
  };

  if (!editId) {
    payload.created_at = new Date().toISOString();
  }

  return payload;
}

function readOptionsPayload(type) {
  const text = (document.getElementById("textInput")?.value || "").trim();
  if (!text) {
    throw new Error("Completează textul întrebării.");
  }

  if (type === "tf") {
    const selected = document.getElementById("tfCorrectInput")?.value;
    const isTrueCorrect = selected === "true";

    return {
      text,
      options: [
        { text: "Adevărat", correct: isTrueCorrect },
        { text: "Fals", correct: !isTrueCorrect },
      ],
    };
  }

  const optionEls = Array.from(document.querySelectorAll(".option-input"));
  const options = optionEls.map((el) => (el.value || "").trim());
  if (options.some((value) => !value)) {
    throw new Error("Completează toate cele 3 opțiuni.");
  }

  const indexes = options.map((value, index) => ({ value, index }));

  if (type === "abc_one") {
    const correctIndex = Number.parseInt(document.getElementById("correctOneInput")?.value || "-1", 10);

    if (![0, 1, 2].includes(correctIndex)) {
      throw new Error("Selectează un răspuns corect.");
    }

    return {
      text,
      options: indexes.map((item) => ({
        text: item.value,
        correct: item.index === correctIndex,
      })),
    };
  }

  const checked = new Set(Array.from(document.querySelectorAll("#correctMultiGroup .answer-chip.is-selected")).map((el) => Number.parseInt(el.dataset.index, 10)));

  if (!indexes.some((item) => checked.has(item.index))) {
    throw new Error("Selectează cel puțin un răspuns corect.");
  }

  return {
    text,
    options: indexes.map((item) => ({
      text: item.value,
      correct: checked.has(item.index),
    })),
  };
}

function readPairsPayload() {
  const leftEls = Array.from(document.querySelectorAll(".pair-left"));
  const rightEls = Array.from(document.querySelectorAll(".pair-right"));

  const pairs = leftEls
    .map((leftEl, index) => ({
      left: (leftEl.value || "").trim(),
      right: (rightEls[index]?.value || "").trim(),
    }))
    .filter((pair) => pair.left && pair.right);

  if (pairs.length !== REQUIRED_MATCH_PAIRS) {
    throw new Error(`Completează exact ${REQUIRED_MATCH_PAIRS} perechi.`);
  }

  return { pairs };
}

async function save() {
  els.result.textContent = "";

  try {
    const basePayload = readCommonPayload();
    const specificPayload =
      activeCfg.dataKind === "pairs" ? readPairsPayload() : readOptionsPayload(activeType);

    const payload = { ...basePayload, ...specificPayload };

    const query = editId
      ? supabase.from(activeCfg.table).update(payload).eq("id", editId)
      : supabase.from(activeCfg.table).insert(payload);

    const { error } = await query;

    if (error) {
      throw error;
    }

    els.result.textContent = editId
      ? "Întrebarea a fost actualizată cu succes."
      : "Întrebarea a fost salvată cu succes.";

    if (!editId) {
      renderForm(activeType);
    }
  } catch (error) {
    console.error(error);
    els.result.textContent = error?.message || "Eroare la salvare.";
  }
}

async function init() {
  const { session } = await requireRole("instructor");

  const url = new URL(window.location.href);
  activeType = getTypeFromUrl() || "tf";
  activeCfg = mustGetConfig(activeType);
  activeUsername = session?.user?.user_metadata?.username || "";
  editId = url.searchParams.get("edit");

  els.pageTitle.textContent = editId
    ? `Editează întrebare - ${activeCfg.title}`
    : `Adaugă întrebare - ${activeCfg.title}`;
  els.pageSubtitle.textContent = `Tabel: ${activeCfg.table}${activeUsername ? ` | Autor: ${activeUsername}` : ""}`;

  els.saveBtn.textContent = editId ? "Actualizează" : "Salvează";

  els.backBtn.href = `/portal/instructor/questions/list.html?type=${activeType}`;
  renderForm(activeType);

  await loadForEdit();

  els.saveBtn.addEventListener("click", save);
}

init();