import { supabase } from "../core/supabaseClient.js";
import { requireAnyRole } from "../core/authGuard.js";
import {
  DEFAULT_STUDY_CATEGORY,
  DEFAULT_STUDY_PERIOD,
  STUDY_CATEGORIES,
  STUDY_PERIODS,
  getStudyCategory,
  getStudyPlan,
} from "../core/studyPlan.js";

const els = {
  status: document.getElementById("bibliographyStatus"),
  period: document.getElementById("periodFilter"),
  categoryWrap: document.getElementById("categoryFilterWrap"),
  category: document.getElementById("categoryFilter"),
  categoryHeading: document.getElementById("categoryHeading"),
  categoryBadge: document.getElementById("categoryBadge"),
  categoryBooksIntro: document.getElementById("categoryBooksIntro"),
  books: document.getElementById("bookList"),
  memorization: document.getElementById("memorizationTitle"),
};

let role = "student";
let studentCategory = DEFAULT_STUDY_CATEGORY;

function fillSelect(select, options, selected) {
  if (!select) return;
  select.replaceChildren();
  options.forEach(({ value, label }) => select.append(new Option(label, value)));
  select.value = selected;
}

function render() {
  const period = els.period.value || DEFAULT_STUDY_PERIOD;
  const category = role === "student" ? studentCategory : (els.category.value || DEFAULT_STUDY_CATEGORY);
  const categoryMeta = getStudyCategory(category);
  const plan = getStudyPlan(period);
  const books = plan.categories[category] || plan.categories[DEFAULT_STUDY_CATEGORY] || [];

  els.categoryHeading.textContent = categoryMeta.label;
  els.categoryBadge.textContent = role === "student" ? "Categoria ta" : categoryMeta.label;
  els.categoryBooksIntro.textContent = `Cărțile recomandate pentru ${categoryMeta.label.toLocaleLowerCase("ro")} în perioada ${period}.`;
  els.books.replaceChildren();
  books.forEach((book) => {
    const item = document.createElement("li");
    item.textContent = book;
    els.books.append(item);
  });
  els.memorization.textContent = plan.memorare;
  els.status.textContent = role === "student"
    ? `Bibliografia ta pentru perioada ${period}.`
    : `Bibliografia pentru ${categoryMeta.label.toLocaleLowerCase("ro")} în perioada ${period}.`;
}

async function loadAccount(session) {
  const username = session?.user?.user_metadata?.username;
  if (!username) return null;
  const { data, error } = await supabase
    .from("accounts")
    .select("role, study_category")
    .eq("username", username)
    .maybeSingle();
  if (error) throw error;
  return Array.isArray(data) ? data[0] || null : data;
}

async function init() {
  const auth = await requireAnyRole(["student", "instructor", "admin"]);
  if (!auth) return;
  role = auth.account?.role || "student";

  fillSelect(els.period, STUDY_PERIODS.map((period) => ({ value: period, label: period })), DEFAULT_STUDY_PERIOD);
  if (role === "student") {
    const account = await loadAccount(auth.session);
    studentCategory = account?.study_category || DEFAULT_STUDY_CATEGORY;
    els.categoryWrap?.setAttribute("hidden", "");
  } else {
    fillSelect(els.category, STUDY_CATEGORIES, DEFAULT_STUDY_CATEGORY);
    els.categoryWrap?.removeAttribute("hidden");
    els.category.addEventListener("change", render);
  }

  els.period.addEventListener("change", render);
  render();
}

init().catch((error) => {
  console.error(error);
  els.status.textContent = "Bibliografia nu a putut fi încărcată.";
});
