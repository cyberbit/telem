---
telem:
  adapter:
    id: 'apns'
    name: 'Antiprotonic Nucleosynthesizer'
    categories: '{ "basic", "advanced", "input", "output", "energy", "recipe" }'
---

<script setup>
  import { data as metrics } from './common/metrics.data.ts'
</script>

# Mekanism Antiprotonic Nucleosynthesizer Input <RepoLink path="lib/input/mekanism/AntiprotonicNucleosynthesizerInputAdapter.lua" />

<!--@include: ./common/preamble.md -->

### Basic

<MetricTable
  prefix="mekapns:"
  :metrics="[
    { name: 'input_chemical_filled_percentage', value: '0.0 - 1.0'                },
    { name: 'input_item_count',                 value: '0 - inf',   unit: 'item'  },
    { name: 'output_item_count',                value: '0 - inf',   unit: 'item'  },
    { name: 'energy_usage',                     value: '0.0 - inf', unit: 'FE/t'  },
    ...metrics.genericMachine.basic
  ]"
/>

### Advanced

<MetricTable
  prefix="mekapns:"
  :metrics="[
    ...metrics.genericMachine.advanced
  ]"
/>

### Input

<MetricTable
  prefix="mekapns:"
  :metrics="[
    { name: 'input_chemical',           value: '0.0 - inf', unit: 'B' },
    { name: 'input_chemical_capacity',  value: '0.0 - inf', unit: 'B' },
    { name: 'input_chemical_needed',    value: '0.0 - inf', unit: 'B' }
  ]"
/>

### Energy

<MetricTable
  prefix="mekapns:"
  :metrics="[
    ...metrics.genericMachine.energy
  ]"
/>

### Recipe

<MetricTable
  prefix="mekapns:"
  :metrics="[
    ...metrics.recipeProgress.recipe,
  ]"
/>