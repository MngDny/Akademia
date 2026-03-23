import { supabase } from "../../../core/supabaseClient.js";
import { requireRole } from "../../../core/authGuard.js";

const tableByType = {
  tf: "questions_tf",
  abc_one: "questions_abc_one",
  abc_multi: "questions_abc_multi",
  match: "questions_match",
};

const typeLabel = {
  tf: "Adevărat / Fals",
  abc_one: "ABC One",
  abc_multi: "ABC Multi",
  match: "Asociere",
};

const els = {
  sourceTabs: document.getElementById("sourceTabs"),
  textPanel: document.getElementById("textPanel"),
  filePanel: document.getElementById("filePanel"),
  sourceText: document.getElementById("sourceText"),
  sourceFile: document.getElementById("sourceFile"),
  fileInfo: document.getElementById("fileInfo"),
  extractBtn: document.getElementById("extractBtn"),
  saveSelectedBtn: document.getElementById("saveSelectedBtn"),
  statusMsg: document.getElementById("statusMsg"),
  groupSummary: document.getElementById("groupSummary"),
  reviewHost: document.getElementById("reviewHost"),
};

let activeSource = "text";
let currentItems = [];
let activeUsername = "";
const REQUIRED_MATCH_PAIRS = 5;

function setStatus(text) {
  els.statusMsg.textContent = text || "";
}

function escapeHtml(value) {
  return String(value || "")
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&#39;");
}

function setSource(source) {
  activeSource = source;
  const tabs = Array.from(els.sourceTabs.querySelectorAll(".source-tab"));
  tabs.forEach((tab) => {
    tab.classList.toggle("is-active", tab.dataset.source === source);
  });

  els.textPanel.classList.toggle("hidden", source !== "text");
  els.filePanel.classList.toggle("hidden", source !== "file");
}

function summarizeGroups(items) {
  const grouped = {
    tf: items.filter((item) => item.type === "tf").length,
    abc_one: items.filter((item) => item.type === "abc_one").length,
    abc_multi: items.filter((item) => item.type === "abc_multi").length,
    match: items.filter((item) => item.type === "match").length,
  };

  els.groupSummary.textContent = `${items.length} total | TF: ${grouped.tf} | ABC One: ${grouped.abc_one} | ABC Multi: ${grouped.abc_multi} | Asociere: ${grouped.match}`;
}

function renderOptionsEditor(item, index) {
  if (item.type === "tf") {
    const isTrueCorrect = Boolean(item.options?.[0]?.correct);
    return `
      <div>
        <label class="label" for="tfCorrect_${index}">Răspuns corect</label>
        <select id="tfCorrect_${index}" class="input" data-field="tfCorrect" data-index="${index}">
          <option value="true" ${isTrueCorrect ? "selected" : ""}>Adevărat</option>
          <option value="false" ${!isTrueCorrect ? "selected" : ""}>Fals</option>
        </select>
      </div>
    `;
  }

  if (item.type === "abc_one" || item.type === "abc_multi") {
    const options = Array.isArray(item.options) ? item.options : [];
    const safeOptions = [0, 1, 2].map((i) => ({
      text: options[i]?.text || "",
      correct: Boolean(options[i]?.correct),
    }));

    const optionRows = safeOptions
      .map((opt, optIndex) => {
        const checkControl = item.type === "abc_one"
          ? `<input type="radio" name="correctOne_${index}" data-field="abcCorrectOne" data-index="${index}" data-opt="${optIndex}" ${opt.correct ? "checked" : ""} />`
          : `<input type="checkbox" data-field="abcCorrectMulti" data-index="${index}" data-opt="${optIndex}" ${opt.correct ? "checked" : ""} />`;

        return `
          <div class="option-row">
            <input class="input" data-field="abcOptionText" data-index="${index}" data-opt="${optIndex}" value="${escapeHtml(opt.text)}" />
            <label>${checkControl} corect</label>
          </div>
        `;
      })
      .join("");

    return `
      <div class="option-grid">
        ${optionRows}
      </div>
    `;
  }

  const pairLines = (Array.isArray(item.pairs) ? item.pairs : [])
    .map((pair) => `${pair.left || ""} => ${pair.right || ""}`)
    .join("\n");

  return `
    <div>
      <label class="label" for="pairs_${index}">Perechi (un rând: stânga => dreapta)</label>
      <textarea id="pairs_${index}" class="input pairs-input" data-field="pairs" data-index="${index}">${escapeHtml(pairLines)}</textarea>
    </div>
  `;
}

function renderReview(items) {
  els.reviewHost.innerHTML = "";
  els.saveSelectedBtn.disabled = items.length === 0;

  if (!items.length) {
    els.reviewHost.innerHTML = '<p class="muted">Nu există întrebări de review.</p>';
    return;
  }

  items.forEach((item, index) => {
    const card = document.createElement("article");
    card.className = "review-card";

    const titleInput = item.type === "match"
      ? ""
      : `
        <div>
          <label class="label" for="text_${index}">Text întrebare</label>
          <textarea id="text_${index}" class="textarea" rows="3" data-field="text" data-index="${index}">${escapeHtml(item.text || "")}</textarea>
        </div>
      `;

    card.innerHTML = `
      <div class="review-top">
        <label><input type="checkbox" data-field="selected" data-index="${index}" ${item.selected ? "checked" : ""} /> Selectează pentru adăugare</label>
        <span class="review-type">${typeLabel[item.type] || item.type}</span>
      </div>

      <div class="review-grid">
        <div>
          <label class="label" for="chapter_${index}">Capitol</label>
          <input id="chapter_${index}" class="input" type="number" min="1" data-field="chapter" data-index="${index}" value="${escapeHtml(item.chapter)}" />
        </div>
        <div>
          <label class="label" for="difficulty_${index}">Dificultate</label>
          <input id="difficulty_${index}" class="input" type="number" min="1" max="5" data-field="difficulty" data-index="${index}" value="${escapeHtml(item.difficulty)}" />
        </div>
        <div>
          <label class="label" for="book_${index}">Carte</label>
          <input id="book_${index}" class="input" type="text" data-field="book" data-index="${index}" value="${escapeHtml(item.book || "")}" />
        </div>
        <div>
          <label class="label" for="status_${index}">Status</label>
          <select id="status_${index}" class="input" data-field="status" data-index="${index}">
            <option value="active" ${item.status === "active" ? "selected" : ""}>Activ</option>
            <option value="draft" ${item.status === "draft" ? "selected" : ""}>Ciornă</option>
            <option value="archived" ${item.status === "archived" ? "selected" : ""}>Arhivat</option>
          </select>
        </div>
      </div>

      ${titleInput}
      ${renderOptionsEditor(item, index)}
    `;

    els.reviewHost.appendChild(card);
  });
}

function readFileAsPayload(file) {
  return new Promise((resolve, reject) => {
    const reader = new FileReader();
    reader.onload = () => {
      const raw = String(reader.result || "");
      const splitIndex = raw.indexOf(",");
      if (splitIndex < 0) {
        reject(new Error("Nu am putut citi fișierul."));
        return;
      }

      resolve({
        fileName: file.name,
        mimeType: file.type || "application/octet-stream",
        base64: raw.slice(splitIndex + 1),
      });
    };
    reader.onerror = () => reject(new Error("Eroare la citirea fișierului."));
    reader.readAsDataURL(file);
  });
}

function normalizeClientItems(items) {
  return (Array.isArray(items) ? items : [])
    .filter((item) => tableByType[item.type])
    .map((item) => ({
      ...item,
      chapter: Number.isInteger(Number(item.chapter)) ? Number(item.chapter) : 1,
      difficulty: Number.isInteger(Number(item.difficulty)) ? Number(item.difficulty) : 1,
      book: String(item.book || "Import AI").trim() || "Import AI",
      status: ["active", "draft", "archived"].includes(String(item.status || ""))
        ? String(item.status)
        : "draft",
      selected: true,
    }));
}

async function callExtractApi(payload) {
  const endpointCandidates = [
    "/.netlify/functions/extract-questions",
    "http://localhost:8888/.netlify/functions/extract-questions",
    "http://127.0.0.1:8888/.netlify/functions/extract-questions",
  ];

  const requestOptions = {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify(payload),
  };

  let lastError = null;

  for (const endpoint of endpointCandidates) {
    try {
      const response = await fetch(endpoint, requestOptions);
      const data = await response.json();

      if (!response.ok) {
        throw new Error(data?.error || "Eroare la extragere.");
      }

      return data;
    } catch (error) {
      lastError = error;
    }
  }

  throw lastError || new Error("Nu am putut contacta funcția de extragere.");
}

async function extractQuestions() {
  setStatus("");
  els.extractBtn.disabled = true;

  try {
    let payload = null;

    if (activeSource === "text") {
      const text = (els.sourceText.value || "").trim();
      if (!text) {
        throw new Error("Lipește mai întâi textul sursă.");
      }

      payload = {
        sourceType: "text",
        text,
      };
    } else {
      const file = els.sourceFile.files?.[0];
      if (!file) {
        throw new Error("Selectează mai întâi un fișier PDF sau imagine.");
      }

      payload = {
        sourceType: "file",
        ...(await readFileAsPayload(file)),
      };
    }

    setStatus("Extragem întrebările cu AI...");

    const data = await callExtractApi(payload);

    currentItems = normalizeClientItems(data.items);
    summarizeGroups(currentItems);
    renderReview(currentItems);
    setStatus(`Extragere finalizată: ${currentItems.length} întrebări detectate.`);
  } catch (error) {
    console.error(error);
    setStatus(error?.message || "Eroare la extragere.");
    currentItems = [];
    summarizeGroups(currentItems);
    renderReview(currentItems);
  } finally {
    els.extractBtn.disabled = false;
  }
}

function updateItemFromField(target) {
  const index = Number.parseInt(target.dataset.index || "-1", 10);
  if (!Number.isInteger(index) || index < 0 || index >= currentItems.length) return;

  const field = target.dataset.field;
  const item = currentItems[index];

  if (field === "selected") {
    item.selected = Boolean(target.checked);
    return;
  }

  if (field === "chapter") {
    item.chapter = Number.parseInt(target.value || "", 10) || 1;
    return;
  }

  if (field === "difficulty") {
    item.difficulty = Number.parseInt(target.value || "", 10) || 1;
    return;
  }

  if (field === "book") {
    item.book = String(target.value || "").trim();
    return;
  }

  if (field === "status") {
    item.status = String(target.value || "draft").trim();
    return;
  }

  if (field === "text") {
    item.text = String(target.value || "").trim();
    return;
  }

  if (field === "tfCorrect") {
    const isTrueCorrect = target.value === "true";
    item.options = [
      { text: "Adevărat", correct: isTrueCorrect },
      { text: "Fals", correct: !isTrueCorrect },
    ];
    return;
  }

  if (field === "abcOptionText") {
    const optIndex = Number.parseInt(target.dataset.opt || "-1", 10);
    if (!Array.isArray(item.options)) item.options = [];
    if (!item.options[optIndex]) item.options[optIndex] = { text: "", correct: false };
    item.options[optIndex].text = String(target.value || "").trim();
    return;
  }

  if (field === "abcCorrectOne") {
    const optIndex = Number.parseInt(target.dataset.opt || "-1", 10);
    if (!Array.isArray(item.options)) item.options = [];
    [0, 1, 2].forEach((i) => {
      if (!item.options[i]) item.options[i] = { text: "", correct: false };
      item.options[i].correct = i === optIndex;
    });
    return;
  }

  if (field === "abcCorrectMulti") {
    const optIndex = Number.parseInt(target.dataset.opt || "-1", 10);
    if (!Array.isArray(item.options)) item.options = [];
    if (!item.options[optIndex]) item.options[optIndex] = { text: "", correct: false };
    item.options[optIndex].correct = Boolean(target.checked);
    return;
  }

  if (field === "pairs") {
    const lines = String(target.value || "")
      .split("\n")
      .map((line) => line.trim())
      .filter(Boolean);

    item.pairs = lines
      .map((line) => {
        const splitAt = line.includes("=>") ? line.split("=>") : line.split("->");
        if (splitAt.length < 2) return null;

        const left = String(splitAt[0] || "").trim();
        const right = String(splitAt.slice(1).join("=>") || "").trim();

        if (!left || !right) return null;
        return { left, right };
      })
      .filter(Boolean);
  }
}

function buildInsertPayload(item) {
  const chapter = Number.parseInt(String(item.chapter || ""), 10);
  const difficulty = Number.parseInt(String(item.difficulty || ""), 10);
  const book = String(item.book || "").trim();
  const status = String(item.status || "draft").trim();

  if (!Number.isInteger(chapter) || chapter <= 0) {
    throw new Error("Capitol invalid într-una dintre întrebări.");
  }

  if (!Number.isInteger(difficulty) || difficulty <= 0) {
    throw new Error("Dificultate invalidă într-una dintre întrebări.");
  }

  if (!book) {
    throw new Error("Carte lipsă într-una dintre întrebări.");
  }

  const basePayload = {
    chapter,
    difficulty,
    book,
    status,
    added_by: activeUsername || "necunoscut",
    created_at: new Date().toISOString(),
  };

  if (item.type === "match") {
    const pairs = (Array.isArray(item.pairs) ? item.pairs : [])
      .map((pair) => ({
        left: String(pair?.left || "").trim(),
        right: String(pair?.right || "").trim(),
      }))
      .filter((pair) => pair.left && pair.right);

    if (pairs.length < REQUIRED_MATCH_PAIRS) {
      throw new Error(`Întrebarea de asociere trebuie să aibă minim ${REQUIRED_MATCH_PAIRS} perechi.`);
    }

    return {
      table: tableByType[item.type],
      payload: {
        ...basePayload,
        pairs: pairs.slice(0, REQUIRED_MATCH_PAIRS),
      },
    };
  }

  const text = String(item.text || "").trim();
  if (!text) {
    throw new Error("Text lipsă într-una dintre întrebări.");
  }

  if (item.type === "tf") {
    const isTrueCorrect = Boolean(item.options?.[0]?.correct);

    return {
      table: tableByType[item.type],
      payload: {
        ...basePayload,
        text,
        options: [
          { text: "Adevărat", correct: isTrueCorrect },
          { text: "Fals", correct: !isTrueCorrect },
        ],
      },
    };
  }

  const options = (Array.isArray(item.options) ? item.options : [])
    .slice(0, 3)
    .map((opt) => ({
      text: String(opt?.text || "").trim(),
      correct: Boolean(opt?.correct),
    }));

  if (options.length !== 3 || options.some((opt) => !opt.text)) {
    throw new Error("Întrebările ABC trebuie să aibă 3 opțiuni completate.");
  }

  if (item.type === "abc_one") {
    const firstCorrect = options.findIndex((opt) => opt.correct);
    const safeIndex = firstCorrect >= 0 ? firstCorrect : 0;
    options.forEach((opt, index) => {
      opt.correct = index === safeIndex;
    });
  }

  if (item.type === "abc_multi" && !options.some((opt) => opt.correct)) {
    throw new Error("Întrebarea ABC Multi trebuie să aibă cel puțin un răspuns corect.");
  }

  return {
    table: tableByType[item.type],
    payload: {
      ...basePayload,
      text,
      options,
    },
  };
}

async function saveSelected() {
  setStatus("");
  els.saveSelectedBtn.disabled = true;

  try {
    const selected = currentItems.filter((item) => item.selected);
    if (!selected.length) {
      throw new Error("Selectează cel puțin o întrebare.");
    }

    const rowsByTable = {
      questions_tf: [],
      questions_abc_one: [],
      questions_abc_multi: [],
      questions_match: [],
    };

    selected.forEach((item) => {
      const prepared = buildInsertPayload(item);
      rowsByTable[prepared.table].push(prepared.payload);
    });

    for (const [table, rows] of Object.entries(rowsByTable)) {
      if (!rows.length) continue;

      const { error } = await supabase.from(table).insert(rows);
      if (error) {
        throw new Error(`Eroare la inserare în ${table}: ${error.message}`);
      }
    }

    setStatus(`Au fost adăugate ${selected.length} întrebări în baza de date.`);
    currentItems = currentItems.filter((item) => !item.selected);
    summarizeGroups(currentItems);
    renderReview(currentItems);
  } catch (error) {
    console.error(error);
    setStatus(error?.message || "Eroare la salvare.");
  } finally {
    els.saveSelectedBtn.disabled = currentItems.length === 0;
  }
}

function bindEvents() {
  els.sourceTabs.addEventListener("click", (event) => {
    const btn = event.target.closest(".source-tab");
    if (!btn) return;
    setSource(btn.dataset.source);
  });

  els.sourceFile.addEventListener("change", () => {
    const file = els.sourceFile.files?.[0];
    els.fileInfo.textContent = file ? `${file.name} (${Math.ceil(file.size / 1024)} KB)` : "";
  });

  els.extractBtn.addEventListener("click", extractQuestions);
  els.saveSelectedBtn.addEventListener("click", saveSelected);

  els.reviewHost.addEventListener("input", (event) => {
    const target = event.target;
    if (!(target instanceof HTMLElement)) return;
    if (!target.dataset?.field) return;
    updateItemFromField(target);
  });

  els.reviewHost.addEventListener("change", (event) => {
    const target = event.target;
    if (!(target instanceof HTMLElement)) return;
    if (!target.dataset?.field) return;
    updateItemFromField(target);
  });
}

async function init() {
  const { session } = await requireRole("instructor");
  activeUsername = session?.user?.user_metadata?.username || "";
  bindEvents();
  setSource("text");
  summarizeGroups([]);
  renderReview([]);
}

init();
