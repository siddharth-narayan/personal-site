<svelte:head>
    <title>Blog Posts</title> 
</svelte:head>

<div class="flex flex-col gap-8">
    <h1 class="text-4xl border-b border-secondary p-4 w-full text-center">Blog Posts</h1>
    <div class="w-[20em] self-center text-justify text-2xl">
        <ul>
            <li><a href="/blog/post-quantum-cryptography/">Post Quantum Cryptography</a></li>
        </ul>
        
    </div>
</div>

<style>
    li::marker {
        content: '• ';
        font-size: 1.2em;
    }
</style>
