import { goto } from "$app/navigation"
import { error, redirect } from "@sveltejs/kit"

// +page.js
export async function load({ fetch, params, url }) {
    let slug = params.slug
    if (!slug) {
        slug = "index"
    }

    if (url.pathname.startsWith("/build")) {
        // Asset not found in static folder, so it fell back to here
        // We can maybe check for any dynamic files (added in after build) just in case

        return error(404)
    }

    // Perhaps better?
    // console.log("fetching: " + url.origin + '/build/' + params.slug + '.html')

    // There's like 3 different ways to fetch
    // let response = await fetch(url.origin + '/build/' + params.slug + '.html')
    let response = await fetch('http://localhost:3000/build/' + params.slug + '.html')
    // let response = await fetch('/build/' + params.slug + '.html')

    console.log(response.status)
    if (!response.ok) {
        return
    }

    let html = await response.text()
    // console.log(html)
    return { html: html }
}
