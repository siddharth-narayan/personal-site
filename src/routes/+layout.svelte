<script>
    import "../app.css";
</script>
<div class="flex flex-col h-full">
    <div class="border-b border-secondary flex justify-center sticky mb-8">
        <a href="/" class=" hover:text-accent p-4 transition-all transition-duration: 150ms;">Home</a>
        <a href="/blog/" class=" hover:text-accent p-4 transition-all transition-duration: 150ms;">Blog</a>
        <a href="/websites/" class=" hover:text-accent p-4 transition-all transition-duration: 150ms;">Useful Websites</a>
    </div>

    <main class="flex-grow self-center w-[50vw]">
    <slot></slot>
    </main>

    <div class="border-t border-secondary flex justify-center sticky mt-8">
        <a href="/" class=" hover:text-accent p-4 transition-all transition-duration: 150ms;">Home</a>
        <a href="/blog/" class=" hover:text-accent p-4 transition-all transition-duration: 150ms;">Blog</a>
        <a href="/websites/" class=" hover:text-accent p-4 transition-all transition-duration: 150ms;">Useful Websites</a>
    </div>
</div>