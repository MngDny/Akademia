export const QUESTION_REPORTS_TABLE = "question_reports";

const reasonLabels = {
  incorrect: "Răspuns sau informație greșită",
  ambiguous: "Întrebarea este neclară",
  typo: "Greșeală de scriere",
  other: "Altă problemă",
};

function questionKey(question) {
  return `${question?.type || ""}:${question?.id || ""}`;
}

export function mountQuestionReport({
  supabase,
  button,
  dialog,
  form,
  questionLabel,
  reason,
  message,
  status,
  closeButton,
  cancelButton,
  getQuestion,
  getStudent,
}) {
  if (!button || !dialog || !form) return { refresh: () => {} };

  let isSubmitting = false;
  const submitted = new Set();

  function setStatus(text, className = "muted") {
    if (!status) return;
    status.className = className;
    status.textContent = text;
  }

  function close() {
    dialog.hidden = true;
    button.focus();
  }

  function open() {
    const question = getQuestion?.();
    if (!question) return;

    form.reset();
    setStatus("");
    const book = question.meta?.book || "Carte necunoscută";
    const chapter = question.meta?.chapter ? ` · Capitol ${question.meta.chapter}` : "";
    if (questionLabel) questionLabel.textContent = `${book}${chapter}: ${question.prompt || "Întrebarea curentă"}`;
    dialog.hidden = false;
    reason?.focus();
  }

  async function submit(event) {
    event.preventDefault();
    if (isSubmitting) return;

    const question = getQuestion?.();
    const student = getStudent?.();
    if (!question || !student?.id) {
      setStatus("Întrebarea nu mai este disponibilă.", "error");
      return;
    }

    const key = questionKey(question);
    if (submitted.has(key)) {
      setStatus("Ai trimis deja o raportare pentru această întrebare.", "muted");
      return;
    }

    const studentMessage = String(message?.value || "").trim();
    isSubmitting = true;
    if (form.querySelector("[type=submit]")) form.querySelector("[type=submit]").disabled = true;
    setStatus("Se trimite raportarea…", "muted");

    try {
      const { data: existing, error: existingError } = await supabase
        .from(QUESTION_REPORTS_TABLE)
        .select("id, status")
        .eq("student_auth_id", student.id)
        .eq("question_id", String(question.id))
        .in("status", ["open", "in_review"])
        .limit(1);

      if (!existingError && Array.isArray(existing) && existing.length) {
        submitted.add(key);
        setStatus("Ai trimis deja o raportare pentru această întrebare.", "muted");
        return;
      }

      const { error } = await supabase.from(QUESTION_REPORTS_TABLE).insert({
        student_auth_id: student.id,
        student_username: student.username || "student",
        question_type: question.type,
        question_id: String(question.id),
        question_book: question.meta?.book || null,
        question_chapter: question.meta?.chapter ?? null,
        question_text: question.prompt || "",
        reason_code: reason?.value || "other",
        student_message: studentMessage || null,
        status: "open",
      });

      if (error) throw error;
      submitted.add(key);
      setStatus("Raportarea a fost trimisă. O vom verifica în curând.", "success");
      form.reset();
    } catch (error) {
      console.error(error);
      setStatus("Raportarea nu a putut fi trimisă. Încearcă din nou.", "error");
    } finally {
      isSubmitting = false;
      if (form.querySelector("[type=submit]")) form.querySelector("[type=submit]").disabled = false;
    }
  }

  function refresh() {
    const question = getQuestion?.();
    button.disabled = !question;
    if (question && submitted.has(questionKey(question))) {
      button.title = "Ai raportat deja această întrebare în sesiunea curentă.";
    } else {
      button.title = "Raportează o problemă la această întrebare";
    }
  }

  button.addEventListener("click", open);
  closeButton?.addEventListener("click", close);
  cancelButton?.addEventListener("click", close);
  form.addEventListener("submit", submit);
  dialog.addEventListener("click", (event) => {
    if (event.target === dialog) close();
  });
  refresh();

  return { refresh, close };
}

export function getQuestionReportReasonLabel(code) {
  return reasonLabels[code] || reasonLabels.other;
}
