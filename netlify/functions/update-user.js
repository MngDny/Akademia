const { createClient } = require("@supabase/supabase-js");

const USERNAME_RE = /^[a-z0-9._-]{3,40}$/;
const ALLOWED_ROLES = new Set(["student", "instructor", "admin"]);

function respond(statusCode, payload) {
  return {
    statusCode,
    headers: { "Content-Type": "application/json", "Cache-Control": "no-store" },
    body: JSON.stringify(payload),
  };
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
    const role = String(payload.role || "").trim().toLowerCase();
    if (!userId || !USERNAME_RE.test(username) || !ALLOWED_ROLES.has(role)) {
      return respond(400, { error: "Datele utilizatorului sunt invalide." });
    }

    const supabase = createClient(process.env.SUPABASE_URL, process.env.SUPABASE_SERVICE_ROLE_KEY, {
      auth: { autoRefreshToken: false, persistSession: false },
    });
    const { data: caller, error: callerError } = await supabase.auth.getUser(token);
    if (callerError || !caller?.user) return respond(401, { error: "Sesiune invalidă." });

    const { data: callerAccount, error: callerAccountError } = await supabase
      .from("accounts").select("role").eq("id", caller.user.id).maybeSingle();
    if (callerAccountError || !callerAccount || String(callerAccount.role).toLowerCase() !== "admin") {
      return respond(403, { error: "Nu ai permisiunea să editezi utilizatori." });
    }

    const { data: existing, error: existingError } = await supabase
      .from("accounts").select("id").eq("username", username).neq("id", userId).maybeSingle();
    if (existingError) throw existingError;
    if (existing) return respond(409, { error: "Username deja folosit." });

    const { error: accountError } = await supabase.from("accounts")
      .update({ username, role }).eq("id", userId);
    if (accountError) throw accountError;

    const { error: authError } = await supabase.auth.admin.updateUserById(userId, {
      user_metadata: { username },
    });
    if (authError) throw authError;

    return respond(200, { message: "Utilizator actualizat.", username, role });
  } catch (error) {
    console.error(error);
    return respond(500, { error: "Utilizatorul nu a putut fi actualizat." });
  }
};
