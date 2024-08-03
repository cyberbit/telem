---
telem:
  adapter:
    id: 'chemicalCrystallizer'
    name: 'Chemical Crystallizer'
    categories: '{ "basic", "advanced", "input", "output", "energy", "recipe" }'
---

<script setup>
  import { data as metrics } from './common/metrics.data.ts'
</script>

# Mekanism Chemical Crystallizer Input <RepoLink path="lib/input/mekanism/ChemicalCrystallizerInputAdapter.lua" />

<!--@include: ./common/preamble.md -->

### Basic

<MetricTable
  prefix="mekcrystallizer:"
  :metrics="[
    { name: 'input_filled_percentage',  value: '0.0 - 1.0'                },
    { name: 'input_item_count',         value: '0 - inf',   unit: 'item'  },
    { name: 'energy_usage',             value: '0.0 - inf', unit: 'FE/t'  },
    ...metrics.genericMachine.basic
  ]"
/>

### Advanced

<MetricTable
  prefix="mekcrystallizer:"
  :metrics="[
    ...metrics.genericMachine.advanced
  ]"
/>

### Input

<MetricTable
  prefix="mekcrystallizer:"
  :metrics="[
    { name: 'input',          value: '0.0 - inf', unit: 'B' },
    { name: 'input_capacity', value: '0.0 - inf', unit: 'B' },
    { name: 'input_needed',   value: '0.0 - inf', unit: 'B' }
  ]"
/>

### Output

<MetricTable
  prefix="mekcrystallizer:"
  :metrics="[
    { name: 'output_count', value: '0 - inf', unit: 'item' }
  ]"
/>

### Energy

<MetricTable
  prefix="mekcrystallizer:"
  :metrics="[
    ...metrics.genericMachine.energy
  ]"
/>

### Recipe

<MetricTable
  prefix="mekcrystallizer:"
  :metrics="[
    ...metrics.recipeProgress.recipe
  ]"
/>