import { supabase } from "./supabaseClient.js";
import { normalizeRole } from "./authGuard.js";

export const roleNames = {
  student: "Student",
  instructor: "Îndrumător",
  admin: "Administrator",
};

export function formatProfileDate(value) {
  if (!value) return "Nu este disponibil";
  const date = new Date(value);
  return Number.isNaN(date.getTime()) ? "Nu este disponibil" : date.toLocaleString("ro-RO");
}

function averageScore(attempts) {
  const scored = attempts.filter((attempt) => Number(attempt.max_points) > 0);
  if (!scored.length) return null;
  return scored.reduce((sum, attempt) => sum + (Number(attempt.points_total || 0) / Number(attempt.max_points)) * 100, 0) / scored.length;
}

export async function fetchUserStats(user) {
  const role = normalizeRole(user.role);
  let attempts = [];
  let questionsCreated = 0;

  if (role === "student") {
    const { data, error } = await supabase
      .from("student_test_attempts")
      .select("points_total, max_points, total_correct_answers, total_questions, created_at")
      .eq("student_auth_id", user.id)
      .order("created_at", { ascending: false });
    if (error) throw error;
    attempts = data || [];
  }

  if (role === "instructor") {
    const tables = ["questions_tf", "questions_abc_one", "questions_abc_multi", "questions_match"];
    const results = await Promise.all(tables.map(async (table) => {
      const { data, error } = await supabase.from(table).select("id").eq("added_by", user.username);
      if (error) return [];
      return data || [];
    }));
    questionsCreated = results.reduce((sum, rows) => sum + rows.length, 0);
  }

  const latestAttempt = attempts[0];
  const lastActivity = latestAttempt?.created_at || user.created_at;
  return {
    attempts: attempts.length,
    questionsCreated,
    averageScore: averageScore(attempts),
    bestScore: attempts.length ? Math.max(...attempts.map((attempt) => Number(attempt.max_points) > 0 ? (Number(attempt.points_total || 0) / Number(attempt.max_points)) * 100 : 0)) : null,
    lastActivity,
    totalCorrect: attempts.reduce((sum, attempt) => sum + Number(attempt.total_correct_answers || 0), 0),
    totalQuestions: attempts.reduce((sum, attempt) => sum + Number(attempt.total_questions || 0), 0),
  };
}

function stat(label, value, detail = "") {
  const item = document.createElement("div");
  item.className = "profile-stat";
  const labelElement = document.createElement("span");
  labelElement.className = "profile-stat-label";
  labelElement.textContent = label;
  const valueElement = document.createElement("strong");
  valueElement.textContent = value;
  item.append(labelElement, valueElement);
  if (detail) {
    const detailElement = document.createElement("small");
    detailElement.textContent = detail;
    item.append(detailElement);
  }
  return item;
}

export function renderUserStats(container, user, stats) {
  container.replaceChildren();
  const role = normalizeRole(user.role);
  if (role === "student") {
    const score = stats.averageScore === null ? "-" : `${Math.round(stats.averageScore)}%`;
    const best = stats.bestScore === null ? "-" : `${Math.round(stats.bestScore)}%`;
    container.append(
      stat("Teste rezolvate", String(stats.attempts)),
      stat("Scor mediu", score),
      stat("Cel mai bun scor", best),
      stat("Răspunsuri corecte", `${stats.totalCorrect}/${stats.totalQuestions}`),
    );
  } else if (role === "instructor") {
    container.append(
      stat("Întrebări create", String(stats.questionsCreated)),
      stat("Ultima activitate", formatProfileDate(stats.lastActivity)),
    );
  } else {
    container.append(
      stat("Rol", roleNames[role] || user.role || "-"),
      stat("Ultima activitate", formatProfileDate(stats.lastActivity)),
    );
  }
}

export function openProfileDialog(dialog) {
  dialog.hidden = false;
  dialog.setAttribute("aria-hidden", "false");
  dialog.querySelector("button")?.focus();
}

export function closeProfileDialog(dialog) {
  dialog.hidden = true;
  dialog.setAttribute("aria-hidden", "true");
}
