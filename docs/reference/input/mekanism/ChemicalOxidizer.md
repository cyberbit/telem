---
telem:
  adapter:
    id: 'chemicalOxidizer'
    name: 'Chemical Oxidizer'
    categories: '{ "basic", "advanced", "output", "energy", "recipe" }'
---

<script setup>
  import { data as metrics } from './common/metrics.data.ts'
</script>

# Mekanism Chemical Oxidizer Input <RepoLink path="lib/input/mekanism/ChemicalOxidizerInputAdapter.lua" />

<!--@include: ./common/preamble.md -->

### Basic

<MetricTable
  prefix="mekchemoxidizer:"
  :metrics="[
    { name: 'input_count',              value: '0 - inf',   unit: 'item'  },
    { name: 'output_filled_percentage', value: '0.0 - 1.0'                },
    { name: 'output_item_count',        value: '0 - inf',   unit: 'item'  },
    { name: 'energy_usage',             value: '0.0 - inf', unit: 'FE/t'  },
    ...metrics.genericMachine.basic
  ]"
/>

### Advanced

<MetricTable
  prefix="mekchemoxidizer:"
  :metrics="[
    ...metrics.genericMachine.advanced
  ]"
/>

### Output

<MetricTable
  prefix="mekchemoxidizer:"
  :metrics="[
    { name: 'output',           value: '0.0 - inf', unit: 'B' },
    { name: 'output_capacity',  value: '0.0 - inf', unit: 'B' },
    { name: 'output_needed',    value: '0.0 - inf', unit: 'B' }
  ]"
/>

### Energy

<MetricTable
  prefix="mekchemoxidizer:"
  :metrics="[
    ...metrics.genericMachine.energy
  ]"
/>

### Recipe

<MetricTable
  prefix="mekchemoxidizer:"
  :metrics="[
    ...metrics.recipeProgress.recipe
  ]"
/>