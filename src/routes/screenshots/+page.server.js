import { env } from '$env/dynamic/private'
import { createClient } from '@supabase/supabase-js'

const USE_DIRECTLY_FROM_STORAGE = true

async function getScreenshotsFromDatabase(supabaseClient, bucketPublicUrl)
{
    const { data: imagesDescriptions, error } = await supabaseClient
        .from('Screenshots')
        .select()
    // console.log(data, error)

    const screenshots = imagesDescriptions.map(image => ({
        url: (bucketPublicUrl + image.name),
        description: image.description
    }))

    return screenshots
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

    return screenshots
}

export const load = async () => {
    return {
        screenshots: [
            {
                url: 'https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/image1.png',
                description: 'empty description'
            },
            {
                url: 'https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/image1.png',
                description: 'empty description'
            },
            {
                url: 'https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/image1.png',
                description: 'empty description'
            },
            {
                url: 'https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/image1.png',
                description: 'empty description'
            },
            {
                url: 'https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/image1.png',
                description: 'empty description'
            },
            {
                url: 'https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/image1.png',
                description: 'empty description'
            },
            {
                url: 'https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/image1.png',
                description: 'empty description'
            },
            {
                url: 'https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/image1.png',
                description: 'empty description'
            },
            {
                url: 'https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/image1.png',
                description: 'empty description'
            },
            {
                url: 'https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/image1.png',
                description: 'empty description'
            },
            {
                url: 'https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/image1.png',
                description: 'empty description'
            },
            {
                url: 'https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/image1.png',
                description: 'empty description'
            },
            {
                url: 'https://uwjsmorezfnlutlzzebh.supabase.co/storage/v1/object/public/public_storage/image1.png',
                description: 'empty description'
            },
        ]
    }

    let result = null
    const supabaseClient = createClient(env.PRIVATE_SUPABASE_URL, env.PRIVATE_SUPABASE_SERVICE_KEY)

    const { data: { publicUrl: bucketPublicUrl }, error } = supabaseClient
        .storage
        .from('public_storage')
        .getPublicUrl('')

    result = USE_DIRECTLY_FROM_STORAGE ?
        await getScreenshotsFromStorage(supabaseClient, bucketPublicUrl)
        : await getScreenshotsFromDatabase(supabaseClient, bucketPublicUrl)

    return { screenshots: result }
}