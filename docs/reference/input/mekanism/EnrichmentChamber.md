---
telem:
  adapter:
    id: 'enrichmentChamber'
    name: 'Enrichment Chamber'
    categories: '{ "basic", "advanced", "energy", "recipe" }'
---

<script setup>
  import { data as metrics } from './common/metrics.data.ts'
</script>

# Mekanism Enrichment Chamber Input <RepoLink path="lib/input/mekanism/EnrichmentChamberInputAdapter.lua" />

<!--@include: ./common/preamble.md -->

### Basic

<MetricTable
  prefix="mekenrich:"
  :metrics="[
    { name: 'input_count',  value: '0 - inf',   unit: 'item' },
    { name: 'output_count', value: '0 - inf',   unit: 'item' },
    { name: 'energy_usage', value: '0.0 - inf', unit: 'FE/t' },
    ...metrics.genericMachine.basic
  ]"
/>

### Advanced

<MetricTable
  prefix="mekenrich:"
  :metrics="[
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
    ...metrics.recipeProgress.recipe
  ]"
/>