---
telem:
  adapter:
    id: 'combiningFactory'
    name: 'Combining Factory'
    categories: '{ "basic", "advanced", "energy", "recipe" }'
---

<script setup>
  import { data as metrics } from './common/metrics.data.ts'
</script>

# Mekanism Combining Factory Input <RepoLink path="lib/input/mekanism/CombiningFactoryInputAdapter.lua" />

<!--@include: ./common/preamble.md -->

### Basic

<MetricTable
  prefix="mekcombine:"
  :metrics="[
    { name: 'input_main_count_sum',   value: '0 - inf',   unit: 'item' },
    { name: 'input_secondary_count',  value: '0 - inf',   unit: 'item' },
    { name: 'output_count_sum',       value: '0 - inf',   unit: 'item' },
    { name: 'energy_usage',           value: '0.0 - inf', unit: 'FE/t' },
    ...metrics.genericMachine.basic
  ]"
/>

### Advanced

<MetricTable
  prefix="mekcombine:"
  :metrics="[
    { name: 'auto_sort', value: '0 or 1' },
    ...metrics.genericMachine.advanced
  ]"
/>


### Energy

<MetricTable
  prefix="mekcombine:"
  :metrics="[
    ...metrics.genericMachine.energy
  ]"
/>

### Recipe

<MetricTable
  prefix="mekcombine:"
  :metrics="[
    ...metrics.recipeProgress.recipeFactory
  ]"
/>