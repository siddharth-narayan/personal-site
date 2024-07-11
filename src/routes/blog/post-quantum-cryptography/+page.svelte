<svelte:head>
    <title>Post Quantum Cryptography</title> 
</svelte:head>

<script>
    import { onMount } from 'svelte'
    import { marked } from 'marked';

    export let markdownContent = "**Loading :)**";

    let htmlContent = '';
    $: { htmlContent = marked(markdownContent, { breaks: true }); }

    let curve = ""
    let curves = ""
    onMount(() => {
        fetch('https://novaphaze.com/curves.json').then(response => {
            let curveName = response.headers.get("x-ssl-curve")
            curves = response.headers.get("x-ssl-curves")
            response.json().then(json => {
                if (curveName?.startsWith("0x")){
                    curve = json[curveName]["name"]
                    console.log(json[curveName]["name"])
                } else {
                    curve = curveName
                }
            })
        })
        fetch('../pqcrypt.md').then(response => {
            response.text().then(text => {
                console.log(text)
                markdownContent = text
            })
        })
    })
</script>

<div class="flex flex-col gap-8">
    <div class="w-[40em] self-center">
        <div class="markdown-body flex flex-col gap-4">
            {@html htmlContent}
        </div>
        <br>
        {#if curve != ""}
            {#if curve.includes("kyber")}
                <div class="green">
                    <p>Connected with curve {curve}. This means that your device is using post quantum cryptography</p>
                </div>
            {:else}
                <div class="red">
                    <p>Connected with curve {curve}. This means that your device is not using post quantum cryptography</p>
                </div>
            {/if}
            <p>This device sent a ClientHello saying that it supports the following curves: {curves}</p>
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
    .unjustify {
        text-justify: inter-character;
    }
</style>