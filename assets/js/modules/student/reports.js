import { supabase } from "../../core/supabaseClient.js";
import { requireRole } from "../../core/authGuard.js";
import { getQuestionReportReasonLabel, QUESTION_REPORTS_TABLE } from "../../core/questionReports.js";

const els = {
  subtitle: document.getElementById("reportsSubtitle"),
  filter: document.getElementById("reportStatusFilter"),
  list: document.getElementById("studentReportsList"),
};

const statusLabels = {
  open: "Deschisă",
  in_review: "În verificare",
  resolved: "Rezolvată",
  rejected: "Respinsă",
};

let reports = [];

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

function render() {
  const status = els.filter.value;
  const filtered = reports.filter((report) => !status || report.status === status);
  els.list.replaceChildren();

  if (!filtered.length) {
    const empty = document.createElement("div");
    empty.className = "report-empty";
    empty.append(
      textElement("strong", "", reports.length ? "Nicio raportare pentru acest status." : "Nu ai trimis încă raportări."),
      textElement("span", "", reports.length ? "Alege alt filtru pentru a vedea și celelalte raportări." : "Poți raporta o problemă direct dintr-o întrebare."),
    );
    els.list.append(empty);
    return;
  }

  filtered.forEach((report) => {
    const card = document.createElement("article");
    card.className = "report-card";

    const header = document.createElement("div");
    header.className = "report-card-header";
    const heading = document.createElement("div");
    heading.append(
      textElement("h2", "", report.question_book || "Întrebare raportată"),
      textElement("p", "report-card-meta", [
        report.question_chapter ? `Capitol ${report.question_chapter}` : null,
        getQuestionReportReasonLabel(report.reason_code),
        formatDate(report.created_at),
      ].filter(Boolean).join(" · ")),
    );
    const badge = textElement("span", `report-status report-status-${report.status}`, statusLabels[report.status] || report.status || "Deschisă");
    header.append(heading, badge);

    card.append(header, textElement("p", "report-question-text", report.question_text || "Întrebarea nu mai este disponibilă."));
    if (report.student_message) card.append(textElement("p", "report-message", `Mesajul tău: ${report.student_message}`));
    if (report.reviewer_message) card.append(textElement("p", "report-message", `Răspunsul echipei: ${report.reviewer_message}`));
    els.list.append(card);
  });
}

async function init() {
  const { session } = await requireRole("student");
  const { data, error } = await supabase
    .from(QUESTION_REPORTS_TABLE)
    .select("*")
    .eq("student_auth_id", session.user.id)
    .order("created_at", { ascending: false });

  if (error) {
    console.error(error);
    els.subtitle.textContent = "Raportările nu au putut fi încărcate.";
    els.list.append(textElement("p", "report-empty", "Încearcă din nou mai târziu."));
    return;
  }

  reports = data || [];
  els.subtitle.textContent = `${reports.length} ${reports.length === 1 ? "raportare" : "raportări"}`;
  els.filter.addEventListener("change", render);
  render();
}

init();
