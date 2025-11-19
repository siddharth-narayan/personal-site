import { goto } from "$app/navigation"
import { redirect } from "@sveltejs/kit"

// +page.js
export async function load({ fetch, params, url }) {
    console.log("url: " + url.pathname)
    if (url.pathname.startsWith("/build")) {
        return
    }
    
    let response = await fetch('/build/' + params.slug + '.html')
    if (!response.ok) {
        if (response.status == 404) {
            throw redirect(301, "/")
        }
        return
    }

    let html = await response.text()
    // console.log(html)
    return { html: html }
}