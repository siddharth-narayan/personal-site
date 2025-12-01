<svelte:head>
    <title>Blog Posts</title> 
</svelte:head>

<script lang="ts">
    let { data } = $props()
</script>

<div class="flex flex-col gap-4 typst-body">
    {#if data}
        {@html data.html}
    {/if}
</div>