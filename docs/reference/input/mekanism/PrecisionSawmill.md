---
telem:
  adapter:
    id: 'precisionSawmill'
    name: 'Precision Sawmill'
    categories: '{ "basic", "advanced", "energy", "recipe" }'
---

<script setup>
  import { data as metrics } from './common/metrics.data.ts'
</script>

# Mekanism Precision Sawmill Input <RepoLink path="lib/input/mekanism/PrecisionSawmillInputAdapter.lua" />

<!--@include: ./common/preamble.md -->

### Basic

<MetricTable
  prefix="meksaw:"
  :metrics="[
    { name: 'input_count',            value: '0 - inf',   unit: 'item'  },
    { name: 'output_count',           value: '0 - inf',   unit: 'item'  },
    { name: 'output_secondary_count', value: '0 - inf',   unit: 'item'  },
    { name: 'energy_usage',           value: '0.0 - inf', unit: 'FE/t'  },
    ...metrics.genericMachine.basic
  ]"
/>

### Advanced

<MetricTable
  prefix="meksaw:"
  :metrics="[
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
    ...metrics.recipeProgress.recipe,
  ]"
/>