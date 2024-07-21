<svelte:head>
    <title>Blog Posts</title> 
</svelte:head>

<script>
	import { onMount } from "svelte";
    import { marked } from 'marked';
    import { page } from '$app/stores';

    export let markdownContent = "**Loading :)**";

    let slug = $page.params.slug;
    let htmlContent = '';

    $: { htmlContent = marked(markdownContent, { breaks: true }); }

    onMount(() => {
        fetch('/blog/' + slug + '.md').then(response => {
            response.text().then(text => {
                console.log(text)
                markdownContent = text
            })
        })
    })
</script>

<div class="markdown-body flex flex-col gap-4">
    {@html htmlContent}
</div>