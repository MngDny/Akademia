import { supabase } from "./supabaseClient.js";

export function normalizeRole(role) {
  if (role === "indrumator") return "instructor";
  if (role === "participant") return "student";
  return role;
}

export async function requireRole(role) {
  const { data: { session } } = await supabase.auth.getSession();

  if (!session) {
    window.location.href = "/login.html";
    return;
  }

  const username = session.user.user_metadata?.username;

  const { data: account } = await supabase
    .from("accounts")
    .select("role")
    .eq("username", username)
    .single();

  const normalizedRequiredRole = normalizeRole(role);
  const normalizedAccountRole = normalizeRole(account?.role);

  if (!account || normalizedAccountRole !== normalizedRequiredRole) {
    await supabase.auth.signOut();
    window.location.href = "/login.html";
  }

  return {
    session,
    account: account ? { ...account, role: normalizedAccountRole } : account,
  };
}

export async function requireInstructor() {
  return requireRole("instructor");
}

// Backward-compatible alias used by existing imports.
export async function requireIndrumator() {
  return requireInstructor();
}
