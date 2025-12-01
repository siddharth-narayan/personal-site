<div class="flex flex-col h-full xs:text-xs sm:text-sm md:text-base">
    <div class="border-b border-secondary flex gap-2 justify-center sticky mb-8">
        <a href="/" class=" hover:text-accent p-4 transition-all transition-duration: 150ms;">Home</a>
        <a href="/blog" class=" hover:text-accent p-4 transition-all transition-duration: 150ms;">Blog</a>
        <a href="/images" class=" hover:text-accent p-4 transition-all transition-duration: 150ms;">My Pictures</a>
    </div>

    <main class="flex-grow self-center flex flex-col gap-8 w-[min(50em,80vw)]">
    <slot></slot>
    </main> 
</div>