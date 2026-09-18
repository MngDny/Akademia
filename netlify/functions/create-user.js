const { createClient } = require('@supabase/supabase-js')

const DEFAULT_STUDY_CATEGORY = '2-3'
const STUDY_CATEGORIES = new Set(['2-3', '4-5', '6-7', '8-9', '10-11', '12-plus'])

exports.handler = async (event) => {
  try {
    const { email, password, username, role, studyCategory } = JSON.parse(event.body)
    const normalizedRole = String(role || '').trim().toLowerCase()
    const selectedCategory = STUDY_CATEGORIES.has(studyCategory) ? studyCategory : DEFAULT_STUDY_CATEGORY

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
        role: normalizedRole,
        study_category: normalizedRole === 'student' ? selectedCategory : null
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
