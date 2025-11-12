<svelte:head>
    <title>Image Gallery</title> 
</svelte:head>

<h1 class="text-4xl border-b border-secondary p-4 w-full text-center">Images</h1>

<div style="display: flex; flex-wrap: wrap; gap: 1rem;">
  {#each data.images as image}
    <img src={`${image}`} alt={image} />
  {/each}
</div>

<script>
  export let data;
</script>