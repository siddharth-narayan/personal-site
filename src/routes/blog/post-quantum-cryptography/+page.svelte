<script>
    import { onMount } from 'svelte'
    import { marked } from 'marked';

    export let markdownContent = "";

    let htmlContent = '';
    $: {
        if(markdownContent != ""){
            htmlContent = marked(markdownContent, { breaks: true });
        }
    }

    let curve = ""
    onMount(() => {
        fetch('https://novaphaze.com/curves.json').then(response => {
            let curveName = response.headers.get("x-ssl-curve")
            response.json().then(json => {
                if (curveName?.startsWith("0x")){
                    curve = json[curveName]["name"]
                    console.log(json[curveName]["name"])
                } else {
                    curve = curveName
                }
            })
        })
        fetch('https://novaphaze.com/pqcrypt.md').then(response => {
            response.text().then(text => {
                console.log(text)
                markdownContent = text
            })
        })
    })
</script>

<div class="flex flex-col gap-8">
    <h1 class="text-4xl border-b border-secondary p-4 w-full text-center">Post Quantum Cryptography</h1>
    <div class="w-[40em] self-center text-justify">
        <p>Welcome to my first ever blog post! I'm going to go over the process of everything post quantum that I've worked on for the past month or so.</p>
        <p>This adventure started a long time ago, when Veritasium released a video on post quantum cryptography</p>
        <div class="markdown-body flex flex-col gap-4">
            {@html htmlContent}
        </div>
        {#if curve != ""}
            {#if curve.includes("kyber")}
                <div class="green">
                    <p>You ARE connected with a post quantum key exchange. Be proud, you are one of only a few people!</p>
                </div>
            {:else}
                <div class="red">
                    <p>You are NOT connected with a post quantum key exchange. (Don't worry, basically nobody is)</p>
                </div>
            {/if}                
        {/if}
    </div>
</div>

<style>
    .green {
        color: green;
    }
    .red {
        color: red;
    }
</style>