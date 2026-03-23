const { createClient } = require("@supabase/supabase-js");

const USERNAME_RE = /^[a-z0-9._-]{3,24}$/;
const EMAIL_RE = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
const PASSWORD_RE = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z\d]).{10,72}$/;
const MAX_BODY_CHARS = 8 * 1024;

function respond(statusCode, payload) {
  return {
    statusCode,
    headers: {
      "Content-Type": "application/json",
      "Cache-Control": "no-store",
      "X-Content-Type-Options": "nosniff",
      "Referrer-Policy": "same-origin",
    },
    body: JSON.stringify(payload),
  };
}

function parseJsonBody(event) {
  const raw = String(event.body || "");
  if (!raw || raw.length > MAX_BODY_CHARS) {
    throw new Error("Cerere invalidă.");
  }

  try {
    return JSON.parse(raw);
  } catch {
    throw new Error("JSON invalid.");
  }
}

exports.handler = async (event) => {
  if (event.httpMethod !== "POST") {
    return respond(405, { error: "Method not allowed" });
  }

  try {
    const payload = parseJsonBody(event);

    const username = String(payload?.username || "")
      .trim()
      .toLowerCase();
    const email = String(payload?.email || "")
      .trim()
      .toLowerCase();
    const password = String(payload?.password || "");

    if (!USERNAME_RE.test(username)) {
      return respond(400, { error: "Username invalid." });
    }

    if (!EMAIL_RE.test(email) || email.length > 120) {
      return respond(400, { error: "Email invalid." });
    }

    if (!PASSWORD_RE.test(password)) {
      return respond(400, { error: "Parolă invalidă." });
    }

    // Reject any attempt to elevate privileges through payload tampering.
    const unsafeRole = payload?.role || payload?.user_metadata?.role || payload?.app_metadata?.role;
    if (unsafeRole && String(unsafeRole).toLowerCase() !== "student") {
      return respond(403, { error: "Rol nepermis." });
    }

    const supabase = createClient(
      process.env.SUPABASE_URL,
      process.env.SUPABASE_SERVICE_ROLE_KEY,
      {
        auth: {
          autoRefreshToken: false,
          persistSession: false,
        },
      },
    );

    const { data: existingUser, error: existingUserError } = await supabase
      .from("accounts")
      .select("id")
      .eq("username", username)
      .limit(1)
      .maybeSingle();

    if (existingUserError) {
      throw existingUserError;
    }

    if (existingUser) {
      return respond(409, { error: "Username deja folosit." });
    }

    const { data: created, error: createError } = await supabase.auth.admin.createUser({
      email,
      password,
      email_confirm: true,
      user_metadata: {
        username,
        registration_source: "self-service",
      },
      app_metadata: {
        role: "student",
      },
    });

    if (createError || !created?.user?.id) {
      const createMessage = String(createError?.message || "").toLowerCase();
      if (createMessage.includes("already") || createMessage.includes("exists")) {
        return respond(409, { error: "Email deja folosit." });
      }
      throw createError || new Error("Nu s-a putut crea utilizatorul.");
    }

    const userId = created.user.id;

    const { error: accountError } = await supabase
      .from("accounts")
      .insert({
        id: userId,
        username,
        role: "student",
      });

    if (accountError) {
      await supabase.auth.admin.deleteUser(userId);
      const accountMessage = String(accountError.message || "").toLowerCase();
      if (accountMessage.includes("duplicate") || accountMessage.includes("unique")) {
        return respond(409, { error: "Date deja folosite." });
      }
      throw accountError;
    }

    return respond(201, {
      message: "Cont student creat.",
      role: "student",
    });
  } catch (error) {
    console.error(error);
    return respond(500, { error: "Eroare internă la înregistrare." });
  }
};
