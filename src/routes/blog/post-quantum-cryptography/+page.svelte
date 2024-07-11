<svelte:head>
    <title>Post Quantum Cryptography</title> 
</svelte:head>

<script lang="ts">
    import { onMount } from 'svelte'
    import { marked } from 'marked';

    export let markdownContent = "**Loading :)**";

    let htmlContent = '';
    $: { htmlContent = marked(markdownContent, { breaks: true }); }

    let curve = ""
    let curves = "";
    onMount(() => {
        fetch('/curves.json', {cache: "no-store"}).then(response => {
            response.json().then(json => {
                curve = convertRawKeyName(response.headers.get("x-ssl-curve"), json)
                let curvesArray = response.headers.get("x-ssl-curves")?.split(":")
                if ( curvesArray != undefined) {
                    for (let i = 0; i < curvesArray.length; i++) {
                        curvesArray[i] = convertRawKeyName(curvesArray[i], json)
                    }
                    curves = curvesArray.join("")
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

    function convertRawKeyName(rawName: string | null, keys: any): string {
        if (rawName == null) {
            return ""
        }

        if (rawName?.startsWith("0x")){
            return keys[rawName]
        } else {
            return rawName
        }
    }
</script>

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
