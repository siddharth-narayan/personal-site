<script lang="ts">
    import { onMount } from "svelte";

    let curve = $state("");
    let curves = $state("");

    onMount(async () => {
        let response = await fetch("/assets/curves.json", {
            cache: "no-store",
        });
        let json = await response.json();

        curve = convertRawKeyName(response.headers.get("x-ssl-curve"), json);
        let curvesArray = response.headers.get("x-ssl-curves")?.split(":");
        if (curvesArray != undefined) {
            for (let i = 0; i < curvesArray.length; i++) {
                curvesArray[i] = convertRawKeyName(curvesArray[i], json);
            }
            curves = curvesArray.join(", ");
        }
    });

    function convertRawKeyName(rawName: string | null, keys: any): string {
        if (rawName == null) {
            return "";
        }

        if (rawName?.startsWith("0x")) {
            if (keys[rawName] == undefined) {
                return "";
            }
            return keys[rawName];
        } else {
            return rawName;
        }
    }
</script>

<svelte:head>
    <title>Post Quantum Cryptography</title>
</svelte:head>

{#if curve != ""}
    {#if curve.includes("kyber") || curve.includes("MLKEM")}
        <div class="green">
            <p>
                Connected with curve {curve}. This means that your device is
                using post quantum cryptography
            </p>
        </div>
    {:else}
        <div class="red">
            <p>
                Connected with curve {curve}. This means that your device is not
                using post quantum cryptography
            </p>
        </div>
    {/if}
    <p>
        This device sent a ClientHello saying that it supports the following
        curves: {curves}
    </p>
{/if}

<style>
    .green {
        color: green;
    }
    .red {
        color: red;
    }
</style>
