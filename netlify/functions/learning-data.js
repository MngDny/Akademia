const { createClient } = require("@supabase/supabase-js");
const { BIBLE_BOOKS, normalizeBookKey } = require("./bibleBooks.cjs");

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

async function getBooks(supabase) {
  const byKey = new Map();

  for (const book of BIBLE_BOOKS) byKey.set(normalizeBookKey(book), book);

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

  const canonical = BIBLE_BOOKS.filter((book) => byKey.has(normalizeBookKey(book)));
  const extras = [...byKey.values()].filter((book) => !BIBLE_BOOKS.some((canonicalBook) => normalizeBookKey(canonicalBook) === normalizeBookKey(book)));
  return [...canonical, ...extras.sort((a, b) => a.localeCompare(b, "ro"))];
}

async function getQuestionsByBooks(supabase, books) {
  const bookKeys = new Set(books.map(normalizeBookKey));
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
    rowsByType[type] = rows.filter((row) => bookKeys.has(normalizeBookKey(row?.book)));
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
      let books = [];
      try {
        const parsed = query.books ? JSON.parse(query.books) : [];
        books = Array.isArray(parsed) ? parsed : [];
      } catch {
        books = String(query.books || "").split(",");
      }
      if (!books.length && query.book) books = [query.book];
      books = books.map(normalizeBookDisplay).filter(Boolean);
      if (!books.length) {
        return respond(400, { error: "Selectează cel puțin o carte." });
      }

      const rowsByType = await getQuestionsByBooks(supabase, books);
      return respond(200, { books, rowsByType });
    }

    return respond(400, { error: "Action invalid. Folosește action=books sau action=questions." });
  } catch (error) {
    console.error(error);
    return respond(500, { error: "Eroare internă la încărcarea datelor de învățare." });
  }
};
