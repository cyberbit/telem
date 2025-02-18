---
telem:
  adapter:
    id: 'sawingFactory'
    name: 'Sawing Factory'
    categories: '{ "basic", "advanced", "energy", "recipe" }'
---

<script setup>
  import { data as metrics } from './common/metrics.data.ts'
</script>

# Mekanism Sawing Factory Input <RepoLink path="lib/input/mekanism/SawingFactoryInputAdapter.lua" />

<!--@include: ./common/preamble.md -->

### Basic

<MetricTable
  prefix="meksaw:"
  :metrics="[
    { name: 'input_count_sum',            value: '0 - inf',   unit: 'item' },
    { name: 'output_count_sum',           value: '0 - inf',   unit: 'item' },
    { name: 'output_secondary_count_sum', value: '0 - inf',   unit: 'item' },
    { name: 'energy_usage',               value: '0.0 - inf', unit: 'FE/t' },
    ...metrics.genericMachine.basic
  ]"
/>

### Advanced

<MetricTable
  prefix="meksaw:"
  :metrics="[
    { name: 'auto_sort', value: '0 or 1' },
    ...metrics.genericMachine.advanced
  ]"
/>

### Energy

<MetricTable
  prefix="meksaw:"
  :metrics="[
    ...metrics.genericMachine.energy
  ]"
/>

### Recipe

<MetricTable
  prefix="meksaw:"
  :metrics="[
    ...metrics.recipeProgress.recipeFactory,
  ]"
/>