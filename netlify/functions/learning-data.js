const { createClient } = require("@supabase/supabase-js");

const TABLES = {
  tf: "questions_tf",
  abc_one: "questions_abc_one",
  match: "questions_match",
  abc_multi: "questions_abc_multi",
};

function respond(statusCode, payload) {
  return {
    statusCode,
    headers: {
      "Content-Type": "application/json",
      "Cache-Control": "no-store",
    },
    body: JSON.stringify(payload),
  };
}

function getBearerToken(event) {
  const header = event.headers?.authorization || event.headers?.Authorization || "";
  const [scheme, token] = String(header).split(" ");
  if (scheme !== "Bearer" || !token) return "";
  return token.trim();
}

async function requireStudent(supabase, token) {
  if (!token) return { ok: false, status: 401, error: "Unauthorized" };

  const { data: userData, error: userError } = await supabase.auth.getUser(token);
  if (userError || !userData?.user?.id) {
    return { ok: false, status: 401, error: "Sesiune invalidă" };
  }

  const userId = userData.user.id;

  const { data: account, error: accountError } = await supabase
    .from("accounts")
    .select("role")
    .eq("id", userId)
    .maybeSingle();

  if (accountError) throw accountError;

  const role = String(account?.role || "").toLowerCase();
  if (role !== "student" && role !== "participant") {
    return { ok: false, status: 403, error: "Acces permis doar pentru student" };
  }

  return { ok: true, userId };
}

function normalizeBookDisplay(value) {
  return String(value || "").trim();
}

function normalizeBookKey(value) {
  return normalizeBookDisplay(value)
    .toLowerCase()
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .replace(/\s+/g, " ");
}

async function getBooks(supabase) {
  const byKey = new Map();

  for (const table of Object.values(TABLES)) {
    const { data, error } = await supabase
      .from(table)
      .select("book")
      .neq("status", "archived")
      .limit(5000);

    if (error) throw error;

    for (const row of Array.isArray(data) ? data : []) {
      const display = normalizeBookDisplay(row?.book);
      const key = normalizeBookKey(display);
      if (!display || !key || byKey.has(key)) continue;
      byKey.set(key, display);
    }
  }

  const unique = [...byKey.values()].sort((a, b) => a.localeCompare(b, "ro"));
  return unique;
}

async function getQuestionsByBook(supabase, book) {
  const bookKey = normalizeBookKey(book);
  const rowsByType = {};

  for (const [type, table] of Object.entries(TABLES)) {
    const baseColumns = type === "match"
      ? "id,book,chapter,status,created_at,pairs"
      : "id,book,chapter,status,created_at,text,options";

    const { data, error } = await supabase
      .from(table)
      .select(baseColumns)
      .neq("status", "archived")
      .order("created_at", { ascending: false })
      .limit(5000);

    if (error) throw error;

    const rows = Array.isArray(data) ? data : [];
    rowsByType[type] = rows.filter((row) => normalizeBookKey(row?.book) === bookKey);
  }

  return rowsByType;
}

exports.handler = async (event) => {
  if (event.httpMethod !== "GET") {
    return respond(405, { error: "Method not allowed" });
  }

  try {
    const token = getBearerToken(event);

    const supabase = createClient(
      process.env.SUPABASE_URL,
      process.env.SUPABASE_SERVICE_ROLE_KEY,
      { auth: { autoRefreshToken: false, persistSession: false } },
    );

    const auth = await requireStudent(supabase, token);
    if (!auth.ok) {
      return respond(auth.status, { error: auth.error });
    }

    const query = event.queryStringParameters || {};
    const action = String(query.action || "").trim();

    if (action === "books") {
      const books = await getBooks(supabase);
      return respond(200, { books });
    }

    if (action === "questions") {
      const book = normalizeBookDisplay(query.book);
      if (!book) {
        return respond(400, { error: "Parametrul book este obligatoriu." });
      }

      const rowsByType = await getQuestionsByBook(supabase, book);
      return respond(200, { book, rowsByType });
    }

    return respond(400, { error: "Action invalid. Folosește action=books sau action=questions." });
  } catch (error) {
    console.error(error);
    return respond(500, { error: "Eroare internă la încărcarea datelor de învățare." });
  }
};
