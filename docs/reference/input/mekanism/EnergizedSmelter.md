---
telem:
  adapter:
    id: 'energizedSmelter'
    name: 'Energized Smelter'
    categories: '{ "basic", "advanced", "energy", "recipe" }'
---

<script setup>
  import { data as metrics } from './common/metrics.data.ts'
</script>

# Mekanism Energized Smelter Input <RepoLink path="lib/input/mekanism/EnergizedSmelterInputAdapter.lua" />

<!--@include: ./common/preamble.md -->

### Basic

<MetricTable
  prefix="meksmelt:"
  :metrics="[
    { name: 'input_count',  value: '0 - inf',   unit: 'item' },
    { name: 'output_count', value: '0 - inf',   unit: 'item' },
    { name: 'energy_usage', value: '0.0 - inf', unit: 'FE/t' },
    ...metrics.genericMachine.basic
  ]"
/>

### Advanced

<MetricTable
  prefix="meksmelt:"
  :metrics="[
    ...metrics.genericMachine.advanced
  ]"
/>

### Energy

<MetricTable
  prefix="meksmelt:"
  :metrics="[
    ...metrics.genericMachine.energy
  ]"
/>

### Recipe

<MetricTable
  prefix="meksmelt:"
  :metrics="[
    ...metrics.recipeProgress.recipe
  ]"
/>