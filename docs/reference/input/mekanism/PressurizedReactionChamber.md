---
telem:
  adapter:
    id: 'reactionChamber'
    name: 'Pressurized Reaction Chamber'
    categories: '{ "basic", "advanced", "input", "output", "energy", "recipe" }'
---

<script setup>
  import { data as metrics } from './common/metrics.data.ts'
</script>

# Mekanism Pressurized Reaction Chamber Input <RepoLink path="lib/input/mekanism/PressurizedReactionChamberInputAdapter.lua" />

<!--@include: ./common/preamble.md -->

### Basic

<MetricTable
  prefix="mekreaction:"
  :metrics="[
    { name: 'input_fluid_filled_percentage',  value: '0.0 - 1.0'                },
    { name: 'input_gas_filled_percentage',    value: '0.0 - 1.0'                },
    { name: 'input_item_count',               value: '0 - inf',   unit: 'item'  },
    { name: 'output_item_count',              value: '0 - inf',   unit: 'item'  },
    { name: 'output_gas_filled_percentage',   value: '0.0 - 1.0'                },
    { name: 'energy_usage',                   value: '0.0 - inf', unit: 'FE/t'  },
    ...metrics.genericMachine.basic
  ]"
/>

### Advanced

<MetricTable
  prefix="mekreaction:"
  :metrics="[
    ...metrics.genericMachine.advanced
  ]"
/>

### Input

<MetricTable
  prefix="mekreaction:"
  :metrics="[
    { name: 'input_fluid',          value: '0.0 - inf', unit: 'B' },
    { name: 'input_fluid_capacity', value: '0.0 - inf', unit: 'B' },
    { name: 'input_fluid_needed',   value: '0.0 - inf', unit: 'B' },
    { name: 'input_gas',            value: '0.0 - inf', unit: 'B' },
    { name: 'input_gas_capacity',   value: '0.0 - inf', unit: 'B' },
    { name: 'input_gas_needed',     value: '0.0 - inf', unit: 'B' }
  ]"
/>

### Output

<MetricTable
  prefix="mekreaction:"
  :metrics="[
    { name: 'output',           value: '0.0 - inf', unit: 'B' },
    { name: 'output_capacity',  value: '0.0 - inf', unit: 'B' },
    { name: 'output_needed',    value: '0.0 - inf', unit: 'B' }
  ]"
/>

### Energy

<MetricTable
  prefix="mekreaction:"
  :metrics="[
    ...metrics.genericMachine.energy
  ]"
/>

### Recipe

<MetricTable
  prefix="mekreaction:"
  :metrics="[
    ...metrics.recipeProgress.recipe,
  ]"
/>