import { supabase } from "../../core/supabaseClient.js";
import { mountPortal } from "../../core/portalShell.js";

mountPortal("student", {
  onLogout: async () => {
    const { error } = await supabase.auth.signOut();
    if (error) throw error;
    window.location.href = "/login.html";
  },
});
