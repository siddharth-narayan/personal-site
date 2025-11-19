<svelte:head>
    <title>Blog Posts</title> 
</svelte:head>

<script lang="ts">
    import { page } from "$app/stores";
    import { footers } from "$lib/footers";
    import type { Component } from "svelte";
    import "../../markdown.css"
    
    let { data } = $props()
    let { slug } = $page.params
    
    // This is horrible :)
    let Footer: Component = footers[slug as keyof typeof footers]

</script>

<div class="flex flex-col gap-4 typst-body">
    {#if data}
        {@html data.html}
    {/if}
    {#if Footer}
        <Footer/>
    {/if}
</div>