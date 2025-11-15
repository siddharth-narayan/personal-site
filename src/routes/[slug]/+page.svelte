<svelte:head>
    <title>Blog Posts</title> 
</svelte:head>

<script>
	import { onMount } from "svelte";
    import { page } from '$app/stores';
    import { goto } from '$app/navigation';
    let slug = $page.params.slug;
    let html = $state("")

    if (!slug || slug === "") {
        slug = "index"
    }

    onMount(() => {
        fetch('/content/' + slug + '.html').then(async response => {
            if (!response.ok) {
                if (response.status == 404) {
                    goto("/error")
                }
                return
            }

            html = await response.text()
        })
    })

</script>

<div class="flex flex-col gap-4">
    {@html html}
</div>