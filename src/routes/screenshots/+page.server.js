import { env } from '$env/dynamic/private'
import { createClient } from '@supabase/supabase-js'

const USE_DIRECTLY_FROM_STORAGE = true

async function getScreenshotsFromDatabase()
{
    const supabase = createClient(env.PRIVATE_SUPABASE_URL, env.PRIVATE_SUPABASE_SERVICE_KEY)

    let bucketPublicUrl = null
    let images_descriptions = null

    {
        const { data, error } = await supabase
            .from('Screenshots')
            .select()

        // console.log(data, error)
        images_descriptions = data
    }

    {
        const { data, error } = await supabase
            .storage
            .from('public_storage')
            .getPublicUrl('')

        bucketPublicUrl = data.publicUrl
    }

    const screenshots = images_descriptions.map(image => ({
        url: (bucketPublicUrl + image.name),
        description: image.description
    }))

    return screenshots
}

async function getScreenshotsFromStorage()
{
    const supabase = createClient(env.PRIVATE_SUPABASE_URL, env.PRIVATE_SUPABASE_SERVICE_KEY)

    let bucketPublicUrl = null
    let images = null

    {
        const { data, error } = await supabase
            .storage
            .from('public_storage')
            .getPublicUrl('')

        bucketPublicUrl = data.publicUrl
    }

    {
        const { data, error } = await supabase
            .storage
            .from('public_storage')
            .list()

        console.log(data)
        images = data
    }

    const screenshots = images.map(image => ({
        url: (bucketPublicUrl + image.name),
        description: image.id
    }))

    return screenshots
}

export const load = async ({ cookies, url }) => {

    let result = null

    if (USE_DIRECTLY_FROM_STORAGE) {
        result = await getScreenshotsFromStorage()
    } else {
        result = await getScreenshotsFromDatabase()
    }

    return { screenshots: result }
}