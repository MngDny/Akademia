import { supabase } from "../../core/supabaseClient.js";
import { requireRole } from "../../core/authGuard.js";
import { getQuestionReportReasonLabel, QUESTION_REPORTS_TABLE } from "../../core/questionReports.js";

const els = {
  subtitle: document.getElementById("reportsSubtitle"),
  search: document.getElementById("reportSearch"),
  filter: document.getElementById("reportStatusFilter"),
  list: document.getElementById("reviewReportsList"),
};

const statusLabels = {
  open: "Deschisă",
  in_review: "În verificare",
  resolved: "Rezolvată",
  rejected: "Respinsă",
};

const questionTables = {
  tf: "questions_tf",
  abc_one: "questions_abc_one",
  abc_multi: "questions_abc_multi",
  match: "questions_match",
};

let reports = [];
let reviewer = { id: "", username: "" };
let reviewerRole = "instructor";

function textElement(tag, className, text) {
  const element = document.createElement(tag);
  element.className = className;
  element.textContent = text;
  return element;
}

function formatDate(value) {
  if (!value) return "";
  return new Date(value).toLocaleString("ro-RO");
}

function reportMatches(report) {
  const status = els.filter.value;
  const query = els.search.value.trim().toLocaleLowerCase("ro");
  if (status && report.status !== status) return false;
  if (!query) return true;
  return [report.question_text, report.question_book, report.student_username, report.student_message]
    .filter(Boolean)
    .join(" ")
    .toLocaleLowerCase("ro")
    .includes(query);
}

function buildStatusSelect(report) {
  const select = document.createElement("select");
  select.className = "input";
  select.id = `report-status-${report.id}`;
  select.setAttribute("aria-label", `Status pentru raportarea ${report.id}`);
  Object.entries(statusLabels).forEach(([value, label]) => {
    const option = new Option(label, value);
    option.selected = value === report.status;
    select.append(option);
  });
  return select;
}

function buildReviewCard(report) {
  const card = document.createElement("article");
  card.className = "report-card";

  const header = document.createElement("div");
  header.className = "report-card-header";
  const heading = document.createElement("div");
  heading.append(
    textElement("h2", "", report.question_book || "Întrebare raportată"),
    textElement("p", "report-card-meta", [
      `Student: ${report.student_username || "necunoscut"}`,
      report.question_chapter ? `Capitol ${report.question_chapter}` : null,
      getQuestionReportReasonLabel(report.reason_code),
      formatDate(report.created_at),
    ].filter(Boolean).join(" · ")),
  );
  const badge = textElement("span", `report-status report-status-${report.status}`, statusLabels[report.status] || report.status || "Deschisă");
  header.append(heading, badge);

  card.append(header, textElement("p", "report-question-text", report.question_text || "Întrebarea nu mai este disponibilă."));
  if (report.student_message) card.append(textElement("p", "report-message", `Mesajul studentului: ${report.student_message}`));
  if (report.reviewer_message) card.append(textElement("p", "report-message", `Ultimul răspuns: ${report.reviewer_message}`));

  const reviewForm = document.createElement("div");
  reviewForm.className = "report-review-form";
  const statusField = document.createElement("div");
  statusField.className = "field";
  const statusLabel = document.createElement("label");
  statusLabel.className = "label";
  statusLabel.htmlFor = `report-status-${report.id}`;
  statusLabel.textContent = "Status";
  const statusSelect = buildStatusSelect(report);
  statusField.append(statusLabel, statusSelect);

  const messageField = document.createElement("div");
  messageField.className = "field";
  const messageId = `report-message-${report.id}`;
  const messageLabel = document.createElement("label");
  messageLabel.className = "label";
  messageLabel.htmlFor = messageId;
  messageLabel.textContent = "Mesaj pentru student";
  const message = document.createElement("textarea");
  message.id = messageId;
  message.rows = 3;
  message.maxLength = 1000;
  message.placeholder = "Explică verificarea sau ce ai modificat...";
  message.value = report.reviewer_message || "";
  messageField.append(messageLabel, message);

  const actions = document.createElement("div");
  actions.className = "report-review-actions";
  const edit = document.createElement("a");
  edit.className = "btn";
  const adminSource = reviewerRole === "admin" ? "&from=admin" : "";
  edit.href = `/portal/instructor/questions/add.html?type=${encodeURIComponent(report.question_type)}&edit=${encodeURIComponent(report.question_id)}${adminSource}`;
  edit.textContent = "Editează întrebarea";
  const remove = document.createElement("button");
  remove.type = "button";
  remove.className = "btn danger";
  remove.textContent = "Șterge întrebarea";
  const save = document.createElement("button");
  save.type = "button";
  save.className = "btn primary";
  save.textContent = "Salvează raportarea";
  save.addEventListener("click", () => updateReport(report, statusSelect, message, save));
  remove.addEventListener("click", () => deleteQuestion(report, remove));
  actions.append(edit, remove, save);

  reviewForm.append(statusField, messageField, actions);
  card.append(reviewForm);
  return card;
}

function render() {
  const filtered = reports.filter(reportMatches);
  els.list.replaceChildren();
  els.subtitle.textContent = `${filtered.length} din ${reports.length} raportări`;

  if (!filtered.length) {
    const empty = document.createElement("div");
    empty.className = "report-empty";
    empty.append(
      textElement("strong", "", reports.length ? "Nicio raportare pentru filtrul curent." : "Nu există raportări noi."),
      textElement("span", "", reports.length ? "Schimbă statusul sau termenul de căutare." : "Când un student semnalează o problemă, raportarea va apărea aici."),
    );
    els.list.append(empty);
    return;
  }

  filtered.forEach((report) => els.list.append(buildReviewCard(report)));
}

async function loadReports() {
  const { data, error } = await supabase
    .from(QUESTION_REPORTS_TABLE)
    .select("*")
    .order("created_at", { ascending: false });

  if (error) throw error;
  reports = data || [];
  render();
}

async function updateReport(report, statusSelect, message, button) {
  button.disabled = true;
  button.textContent = "Se salvează…";
  try {
    const { error } = await supabase
      .from(QUESTION_REPORTS_TABLE)
      .update({
        status: statusSelect.value,
        reviewer_message: message.value.trim() || null,
        reviewed_by: reviewer.id || null,
        reviewed_by_username: reviewer.username || null,
        reviewed_at: new Date().toISOString(),
        updated_at: new Date().toISOString(),
      })
      .eq("id", report.id);
    if (error) throw error;
    await loadReports();
  } catch (error) {
    console.error(error);
    button.disabled = false;
    button.textContent = "Salvează raportarea";
    alert("Raportarea nu a putut fi actualizată.");
  }
}

async function deleteQuestion(report, button) {
  const table = questionTables[report.question_type];
  if (!table) return;
  if (!confirm("Ștergi definitiv întrebarea raportată? Raportarea va fi marcată rezolvată.")) return;

  button.disabled = true;
  button.textContent = "Se șterge…";
  try {
    const { error: deleteError } = await supabase.from(table).delete().eq("id", report.question_id);
    if (deleteError) throw deleteError;
    const { error: reportError } = await supabase
      .from(QUESTION_REPORTS_TABLE)
      .update({
        status: "resolved",
        reviewer_message: "Întrebarea a fost ștearsă după verificarea raportării.",
        reviewed_by: reviewer.id || null,
        reviewed_by_username: reviewer.username || null,
        reviewed_at: new Date().toISOString(),
        updated_at: new Date().toISOString(),
      })
      .eq("id", report.id);
    if (reportError) throw reportError;
    await loadReports();
  } catch (error) {
    console.error(error);
    button.disabled = false;
    button.textContent = "Șterge întrebarea";
    alert("Întrebarea sau raportarea nu a putut fi actualizată.");
  }
}

async function init() {
  reviewerRole = window.location.pathname.includes("/admin/") ? "admin" : "instructor";
  const { session } = await requireRole(reviewerRole);
  reviewer = {
    id: session?.user?.id || "",
    username: session?.user?.user_metadata?.username || "",
  };
  els.search.addEventListener("input", render);
  els.filter.addEventListener("change", render);
  try {
    await loadReports();
  } catch (error) {
    console.error(error);
    els.subtitle.textContent = "Raportările nu au putut fi încărcate.";
    els.list.append(textElement("p", "report-empty", "Verifică tabelul question_reports și încearcă din nou."));
  }
}

init();
