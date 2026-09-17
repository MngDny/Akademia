import { supabase } from "../../core/supabaseClient.js";
import { mountPortal } from "../../core/portalShell.js";

const reviewerRole = new URLSearchParams(window.location.search).get("from") === "admin" ? "admin" : "instructor";

mountPortal(reviewerRole, {
  onLogout: async () => {
    const { error } = await supabase.auth.signOut();
    if (error) throw error;
    window.location.href = "/login.html";
  },
});
