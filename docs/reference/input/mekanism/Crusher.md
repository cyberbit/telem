---
telem:
  adapter:
    id: 'crusher'
    name: 'Crusher'
    categories: '{ "basic", "advanced", "energy", "recipe" }'
---

<script setup>
  import { data as metrics } from './common/metrics.data.ts'
</script>

# Mekanism Crusher Input <RepoLink module path="modules/mekanism/CrusherInputAdapter.lua" />

<!--@include: ./common/preamble.md -->

### Basic

<MetricTable
  prefix="mekcrush:"
  :metrics="[
    { name: 'input_count',  value: '0 - inf',   unit: 'item' },
    { name: 'output_count', value: '0 - inf',   unit: 'item' },
    { name: 'energy_usage', value: '0.0 - inf', unit: 'FE/t' },
    ...metrics.genericMachine.basic
  ]"
/>

### Advanced

<MetricTable
  prefix="mekcrush:"
  :metrics="[
    ...metrics.genericMachine.advanced
  ]"
/>

### Energy

<MetricTable
  prefix="mekcrush:"
  :metrics="[
    ...metrics.genericMachine.energy
  ]"
/>

### Recipe

<MetricTable
  prefix="mekcrush:"
  :metrics="[
    ...metrics.recipeProgress.recipe
  ]"
/>