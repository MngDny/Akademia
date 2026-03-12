import { supabase } from "../../../core/supabaseClient.js";
import { requireInstructor } from "../../../core/authGuard.js";

await requireInstructor();

async function loadCounts() {
  const tables = {
    tf: "questions_tf",
    abc_one: "questions_abc_one",
    abc_multi: "questions_abc_multi",
    match: "questions_match"
  };

  for (const key in tables) {
    const { count } = await supabase
      .from(tables[key])
      .select("*", { count: "exact", head: true });

    document.getElementById(`count_${key}`).innerText = count || 0;
  }
}

loadCounts();

document.querySelectorAll(".stat-card").forEach(card => {
  card.addEventListener("click", () => {
    const type = card.dataset.type;
    window.location.href = `/portal/instructor/questions/list.html?type=${type}`;
  });
});