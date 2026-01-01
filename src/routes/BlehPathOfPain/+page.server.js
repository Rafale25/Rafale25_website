import { PRIVATE_SUPABASE_URL, PRIVATE_SUPABASE_SERVICE_KEY } from '$env/static/private'
import { createClient } from '@supabase/supabase-js'

const USE_DIRECTLY_FROM_STORAGE = true

export const load = async () => {
    const supabaseClient = createClient(PRIVATE_SUPABASE_URL, PRIVATE_SUPABASE_SERVICE_KEY)

    const { data: { publicUrl }, error } = supabaseClient
        .storage
        .from('web_games')
        .getPublicUrl('')

    return {
        publicUrl
    }
}
