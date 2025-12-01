import { error } from "@sveltejs/kit"

export async function load({ fetch, params, url }) {
    let slug = params.slug
    if (!slug) {
        slug = "index"
    }

    // Catch any /build paths not in /static
    if (url.pathname.startsWith("/build")) {
        return error(404)
    }

    let response = await fetch('/build/' + params.slug + '.html')
    if (!response.ok) {
        return
    }

    let html = await response.text()
    return { html: html }
}