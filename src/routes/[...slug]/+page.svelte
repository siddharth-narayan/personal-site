<svelte:head>
    <title>Blog Posts</title> 
</svelte:head>

<script lang="ts">

    let { data } = $props()
    
    // console.log(data.html)
</script>

<div class="flex flex-col gap-4">
    {#if data}
        {@html data.html}
    {/if}
    
</div>