const { createClient } = require("@supabase/supabase-js");

const USERNAME_RE = /^[a-z0-9._-]{3,40}$/;
const ALLOWED_ROLES = new Set(["student", "instructor", "admin"]);
const STUDY_CATEGORIES = new Set(["2-3", "4-5", "6-7", "8-9", "10-11", "12-plus"]);

function respond(statusCode, payload) {
  return {
    statusCode,
    headers: { "Content-Type": "application/json", "Cache-Control": "no-store" },
    body: JSON.stringify(payload),
  };
}

function normalizeRole(role) {
  return String(role || "").toLowerCase() === "participant" ? "student" : String(role || "").toLowerCase();
}

exports.handler = async (event) => {
  if (event.httpMethod !== "POST") return respond(405, { error: "Method not allowed" });

  try {
    const token = String(event.headers?.authorization || event.headers?.Authorization || "")
      .replace(/^Bearer\s+/i, "").trim();
    if (!token) return respond(401, { error: "Sesiune lipsă." });

    const payload = JSON.parse(event.body || "{}");
    const userId = String(payload.userId || "").trim();
    const username = String(payload.username || "").trim().toLowerCase();
    const requestedRole = normalizeRole(payload.role);
    const studyCategory = String(payload.studyCategory || "").trim();
    if (!userId || !USERNAME_RE.test(username) || !ALLOWED_ROLES.has(requestedRole)) {
      return respond(400, { error: "Datele utilizatorului sunt invalide." });
    }

    const supabase = createClient(process.env.SUPABASE_URL, process.env.SUPABASE_SERVICE_ROLE_KEY, {
      auth: { autoRefreshToken: false, persistSession: false },
    });
    const { data: caller, error: callerError } = await supabase.auth.getUser(token);
    if (callerError || !caller?.user) return respond(401, { error: "Sesiune invalidă." });

    const { data: callerAccount, error: callerAccountError } = await supabase
      .from("accounts").select("role").eq("id", caller.user.id).maybeSingle();
    if (callerAccountError || !callerAccount) return respond(403, { error: "Nu ai permisiunea să editezi utilizatori." });
    const callerRole = normalizeRole(callerAccount.role);
    if (callerRole !== "admin" && callerRole !== "instructor") {
      return respond(403, { error: "Nu ai permisiunea să editezi utilizatori." });
    }

    const { data: target, error: targetError } = await supabase
      .from("accounts").select("id, username, role, study_category").eq("id", userId).maybeSingle();
    if (targetError) throw targetError;
    if (!target) return respond(404, { error: "Utilizatorul nu există." });

    const targetRole = normalizeRole(target.role);
    if (callerRole === "instructor" && targetRole !== "student") {
      return respond(403, { error: "Îndrumătorii pot modifica doar categoria studenților." });
    }
    if (callerRole === "instructor" && requestedRole !== "student") {
      return respond(403, { error: "Îndrumătorii nu pot schimba rolul utilizatorului." });
    }
    if (requestedRole === "student" && !STUDY_CATEGORIES.has(studyCategory)) {
      return respond(400, { error: "Categoria de studiu este invalidă." });
    }

    if (callerRole === "admin") {
      const { data: existing, error: existingError } = await supabase
        .from("accounts").select("id").eq("username", username).neq("id", userId).maybeSingle();
      if (existingError) throw existingError;
      if (existing) return respond(409, { error: "Username deja folosit." });

      const { error: accountError } = await supabase.from("accounts").update({
        username,
        role: requestedRole,
        study_category: requestedRole === "student" ? studyCategory : null,
      }).eq("id", userId);
      if (accountError) throw accountError;

      const { error: authError } = await supabase.auth.admin.updateUserById(userId, {
        user_metadata: {
          username,
          ...(requestedRole === "student" ? { study_category: studyCategory } : {}),
        },
      });
      if (authError) throw authError;
    } else {
      const { error: accountError } = await supabase.from("accounts")
        .update({ study_category: studyCategory }).eq("id", userId);
      if (accountError) throw accountError;
    }

    return respond(200, {
      message: "Utilizator actualizat.",
      username: callerRole === "admin" ? username : target.username,
      role: callerRole === "admin" ? requestedRole : target.role,
      studyCategory,
    });
  } catch (error) {
    console.error(error);
    return respond(500, { error: "Utilizatorul nu a putut fi actualizat." });
  }
};
