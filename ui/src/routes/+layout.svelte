<script lang="ts">
	import "../app.css";

	let { children } = $props();
</script>

<svelte:head>
	<title>Bare metal svelte demo</title>
	<meta name="description" content="Control the speed of LED animations." />
	<meta name="viewport" content="width=device-width, initial-scale=1" />
</svelte:head>

{@render children()}
