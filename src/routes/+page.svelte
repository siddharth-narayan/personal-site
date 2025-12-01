<script lang="ts">
    import { onMount } from "svelte";

    let html = $state("");

    onMount(async () => {
        let response = await fetch("/build/index.html");
        if (!response.ok) {
            return;
        }

        html = await response.text();
    });
</script>

<svelte:head>
    <title>Blog Posts</title>
</svelte:head>

<div class="flex flex-col gap-4 typst-body">
    {@html html}
</div>
