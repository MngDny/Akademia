const supabaseClient = supabase.createClient(
  "https://pdkfqytododevpilpxet.supabase.co",
  "sb_publishable_9SE72Dov4XTRfAGoXhL1Nw_kbdPfK4z"
);

async function login() {
  const email = document.getElementById("email").value;
  const password = document.getElementById("password").value;

  const { data, error } = await supabaseClient.auth.signInWithPassword({
    email,
    password
  });

  if (error) {
    document.getElementById("error").innerText = error.message;
    return;
  }

  const user = data.user;

  const { data: account, error: accError } = await supabaseClient
    .from("accounts")
    .select("role")
    .eq("username", user.user_metadata.username)
    .single();

  if (accError) {
    document.getElementById("error").innerText = "Profil lipsă!";
    return;
  }

  if (account.role === "admin") {
    window.location.href = "/admin/index.html";
  } else if (account.role === "indrumator") {
    window.location.href = "/indrumator/index.html";
  } else {
    window.location.href = "/participant/index.html";
  }
}
