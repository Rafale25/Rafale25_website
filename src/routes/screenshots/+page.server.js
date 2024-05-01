import { PRIVATE_SUPABASE_URL, PRIVATE_SUPABASE_SERVICE_KEY } from '$env/static/private'
import { createClient } from '@supabase/supabase-js'

const USE_DIRECTLY_FROM_STORAGE = true

async function getScreenshotsFromDatabase(supabaseClient, bucketPublicUrl)
{
    const { data: imagesDescriptions, error } = await supabaseClient
        .from('Screenshots')
        .select()

    const screenshots = imagesDescriptions.map(image => ({
        url: (bucketPublicUrl + image.name),
        description: image.description
    }))

    return {screenshots, error}
}

async function getScreenshotsFromStorage(supabaseClient, bucketPublicUrl)
{
    const { data: images, error } = await supabaseClient
        .storage
        .from('public_storage')
        .list()

    const screenshots = images.map(image => ({
        url: (bucketPublicUrl + image.name),
        description: image.id
    }))

    return {screenshots, error}
}

export const load = async () => {
    const supabaseClient = createClient(PRIVATE_SUPABASE_URL, PRIVATE_SUPABASE_SERVICE_KEY)

    const { data: { publicUrl: bucketPublicUrl } } = supabaseClient
        .storage
        .from('public_storage')
        .getPublicUrl('')

    const {screenshots, error} = USE_DIRECTLY_FROM_STORAGE ?
        await getScreenshotsFromStorage(supabaseClient, bucketPublicUrl)
        : await getScreenshotsFromDatabase(supabaseClient, bucketPublicUrl)

    return {
        screenshots,
        error
    }
}