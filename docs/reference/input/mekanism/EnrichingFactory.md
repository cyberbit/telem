---
telem:
  adapter:
    id: 'enrichingFactory'
    name: 'Enriching Factory'
    categories: '{ "basic", "advanced", "energy", "recipe" }'
---

<script setup>
  import { data as metrics } from './common/metrics.data.ts'
</script>

# Mekanism Enriching Factory Input <RepoLink path="lib/input/mekanism/EnrichingFactoryInputAdapter.lua" />

<!--@include: ./common/preamble.md -->

### Basic

<MetricTable
  prefix="mekenrich:"
  :metrics="[
    { name: 'input_count_sum',  value: '0 - inf',   unit: 'item' },
    { name: 'output_count_sum', value: '0 - inf',   unit: 'item' },
    { name: 'energy_usage',     value: '0.0 - inf', unit: 'FE/t' },
    ...metrics.genericMachine.basic
  ]"
/>

### Advanced

<MetricTable
  prefix="mekenrich:"
  :metrics="[
    { name: 'auto_sort', value: '0 or 1' },
    ...metrics.genericMachine.advanced
  ]"
/>

### Energy

<MetricTable
  prefix="mekenrich:"
  :metrics="[
    ...metrics.genericMachine.energy
  ]"
/>

### Recipe

<MetricTable
  prefix="mekenrich:"
  :metrics="[
    ...metrics.recipeProgress.recipeFactory
  ]"
/>