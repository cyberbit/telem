---
telem:
  adapter:
    id: 'dissolutionChamber'
    name: 'Chemical Dissolution Chamber'
    categories: '{ "basic", "advanced", "input", "output", "energy", "recipe" }'
---

<script setup>
  import { data as metrics } from './common/metrics.data.ts'
</script>

# Mekanism Chemical Dissolution Chamber Input <RepoLink path="lib/input/mekanism/ChemicalDissolutionChamberInputAdapter.lua" />

<!--@include: ./common/preamble.md -->

### Basic

<MetricTable
  prefix="mekdissolution:"
  :metrics="[
    { name: 'input_gas_filled_percentage',  value: '0.0 - 1.0'                },
    { name: 'input_gas_item_count',         value: '0 - inf',   unit: 'item'  },
    { name: 'input_item_count',             value: '0 - inf',   unit: 'item'  },
    { name: 'output_filled_percentage',     value: '0.0 - 1.0'                },
    { name: 'output_item_count',            value: '0 - inf',   unit: 'item'  },
    { name: 'energy_usage',                 value: '0.0 - inf', unit: 'FE/t'  },
    ...metrics.genericMachine.basic
  ]"
/>

### Advanced

<MetricTable
  prefix="mekdissolution:"
  :metrics="[
    ...metrics.genericMachine.advanced
  ]"
/>

### Input

<MetricTable
  prefix="mekdissolution:"
  :metrics="[
    { name: 'input_gas',          value: '0.0 - inf', unit: 'B' },
    { name: 'input_gas_needed',   value: '0.0 - inf', unit: 'B' },
    { name: 'input_gas_capacity', value: '0.0 - inf', unit: 'B' }
  ]"
/>

### Output

<MetricTable
  prefix="mekdissolution:"
  :metrics="[
    { name: 'output_needed',    value: '0.0 - inf', unit: 'B' },
    { name: 'output_capacity',  value: '0.0 - inf', unit: 'B' },
    { name: 'output',           value: '0.0 - inf', unit: 'B' }
  ]"
/>

### Energy

<MetricTable
  prefix="mekdissolution:"
  :metrics="[
    ...metrics.genericMachine.energy
  ]"
/>

### Recipe

<MetricTable
  prefix="mekdissolution:"
  :metrics="[
    ...metrics.recipeProgress.recipe
  ]"
/>