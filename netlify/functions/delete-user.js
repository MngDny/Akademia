const { createClient } = require('@supabase/supabase-js')

exports.handler = async (event) => {
  try {
    const { userId } = JSON.parse(event.body)

    const supabase = createClient(
      process.env.SUPABASE_URL,
      process.env.SUPABASE_SERVICE_ROLE_KEY
    )

    const { error } = await supabase.auth.admin.deleteUser(userId)

    if (error) throw error

    return {
      statusCode: 200,
      body: JSON.stringify({ message: "User deleted successfully" })
    }

  } catch (err) {
    return {
      statusCode: 500,
      body: JSON.stringify({ error: err.message })
    }
  }
}
