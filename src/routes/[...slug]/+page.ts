import { goto } from "$app/navigation"
import { error, redirect } from "@sveltejs/kit"

// +page.js
export async function load({ fetch, params, url }) {
    let slug = params.slug
    if (!slug) {
        slug = "index"
    }

    if (url.pathname.startsWith("/build")) {
        return error(404)
    }

    console.log("url: " + url.pathname + " slug: " + slug)

    let response = await fetch('http://localhost:3000/build/' + params.slug + '.html')
    console.log(response.status)
    if (!response.ok) {
        return
    }

    let html = await response.text()
    // console.log(html)
    return { html: html }
}
