---
telem:
  adapter:
    id: 'combiner'
    name: 'Combiner'
    categories: '{ "basic", "advanced", "energy", "recipe" }'
---

<script setup>
  import { data as metrics } from './common/metrics.data.ts'
</script>

# Mekanism Combiner Input <RepoLink module path="modules/mekanism/CombinerInputAdapter.lua" />

<!--@include: ./common/preamble.md -->

### Basic

<MetricTable
  prefix="mekcombine:"
  :metrics="[
    { name: 'input_main_count',       value: '0 - inf',   unit: 'item' },
    { name: 'input_secondary_count',  value: '0 - inf',   unit: 'item' },
    { name: 'output_count',           value: '0 - inf',   unit: 'item' },
    { name: 'energy_usage',           value: '0.0 - inf', unit: 'FE/t' },
    ...metrics.genericMachine.basic
  ]"
/>

### Advanced

<MetricTable
  prefix="mekcombine:"
  :metrics="[
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
    ...metrics.recipeProgress.recipe
  ]"
/>