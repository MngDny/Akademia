const { createClient } = require('@supabase/supabase-js')

exports.handler = async (event) => {
  try {
    const { email, password, username, role } = JSON.parse(event.body)

    const supabase = createClient(
      process.env.SUPABASE_URL,
      process.env.SUPABASE_SERVICE_ROLE_KEY
    )

    // 1️⃣ Creează user în auth
    const { data: userData, error: userError } =
      await supabase.auth.admin.createUser({
        email,
        password,
        email_confirm: true,
        user_metadata: { username }
      })

    if (userError) throw userError

    // 2️⃣ Inserează în accounts cu ID identic
    const { error: accError } = await supabase
      .from('accounts')
      .insert({
        id: userData.user.id,
        username,
        role
      })

    if (accError) throw accError

    return {
      statusCode: 200,
      body: JSON.stringify({ message: "User created successfully" })
    }

  } catch (err) {
    return {
      statusCode: 500,
      body: JSON.stringify({ error: err.message })
    }
  }
}
