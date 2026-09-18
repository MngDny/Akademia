import { supabase } from "../../core/supabaseClient.js";
import { normalizeRole } from "../../core/authGuard.js";
import { mountPortal } from "../../core/portalShell.js";

async function mountForCurrentRole() {
  let role = "student";
  const { data: { session } } = await supabase.auth.getSession();
  if (session) {
    const { data: account } = await supabase.from("accounts").select("role")
      .eq("username", session.user.user_metadata?.username).single();
    role = normalizeRole(account?.role) || "student";
  }
  mountPortal(role, {
    onLogout: async () => {
      const { error } = await supabase.auth.signOut();
      if (error) throw error;
      window.location.href = "/login.html";
    },
  });
}

mountForCurrentRole();
