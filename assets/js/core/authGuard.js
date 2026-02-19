import { supabase } from "./supabaseClient.js";

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

  if (!account || account.role !== role) {
    await supabase.auth.signOut();
    window.location.href = "/login.html";
  }

  return { session, account };
}
