<script lang="ts">
    import { type Speeds, getSpeeds, setSpeeds } from "$lib/api/speed";

    let speeds = $state<Speeds>({
        led1: 0,
        led2: 0,
        led3: 0,
    });

    $effect(() => {
        const run = async () => {
            try {
                speeds = await getSpeeds();
            } catch (error) {
                console.error("Failed to fetch speeds:", error);
            }
        };
        run();
    });

    const handleSpeedChange = async (led: keyof Speeds, newSpeed: number) => {
        try {
            const res = await setSpeeds({ ...speeds, [led]: newSpeed });
            console.log(`Speed for ${led} updated to ${newSpeed} ms`, res);
        } catch (error) {
            console.error(`Failed to update speed for ${led}:`, error);
        }
    };
</script>

<main class="p-4 mt-6 mx-auto max-w-4xl">
    <h1 class="text-3xl font-bold mb-4">LED Speeds</h1>

    <div class="flex flex-wrap gap-4">
        <div class="bg-white p-4 rounded shadow flex-1">
            <h2 class="text-xl font-semibold mb-2 text-green-600">Green</h2>
            <label class="text-lg flex gap-2 items-center">
                <input
                    type="number"
                    min="0"
                    bind:value={speeds.led1}
                    onchange={() => handleSpeedChange("led1", speeds.led1)}
                    class="mt-2 p-2 border rounded w-full"
                />
                ms
            </label>
        </div>
        <div class="bg-white p-4 rounded shadow flex-1">
            <h2 class="text-xl font-semibold mb-2 text-amber-600">Orange</h2>
            <label class="text-lg flex gap-2 items-center">
                <input
                    type="number"
                    min="0"
                    bind:value={speeds.led2}
                    onchange={() => handleSpeedChange("led2", speeds.led2)}
                    class="mt-2 p-2 border rounded w-full"
                />
                ms
            </label>
        </div>
        <div class="bg-white p-4 rounded shadow flex-1">
            <h2 class="text-xl font-semibold mb-2 text-red-600">Red</h2>
            <label class="text-lg flex gap-2 items-center">
                <input
                    type="number"
                    min="0"
                    bind:value={speeds.led3}
                    onchange={() => handleSpeedChange("led3", speeds.led3)}
                    class="mt-2 p-2 border rounded w-full"
                />
                ms
            </label>
        </div>
    </div>
</main>
