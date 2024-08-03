---
telem:
  adapter:
    id: 'chemicalWasher'
    name: 'Chemical Washer'
    categories: '{ "basic", "advanced", "input", "output", "energy" }'
---

<script setup>
  import { data as metrics } from './common/metrics.data.ts'
</script>

# Mekanism Chemical Washer Input <RepoLink path="lib/input/mekanism/ChemicalWasherInputAdapter.lua" />

<!--@include: ./common/preamble.md -->

### Basic

<MetricTable
  prefix="mekwasher:"
  :metrics="[
    { name: 'fluid_filled_percentage',          value: '0.0 - 1.0'                },
    { name: 'input_slurry_filled_percentage',   value: '0.0 - 1.0'                },
    { name: 'output_slurry_filled_percentage',  value: '0.0 - 1.0'                },
    { name: 'input_fluid_item_count',           value: '0 - inf',   unit: 'item'  },
    { name: 'output_fluid_item_count',          value: '0 - inf',   unit: 'item'  },
    { name: 'energy_usage',                     value: '0.0 - inf', unit: 'FE/t'  },
    ...metrics.genericMachine.basic
  ]"
/>

### Advanced

<MetricTable
  prefix="mekwasher:"
  :metrics="[
    ...metrics.genericMachine.advanced
  ]"
/>


### Input

<MetricTable
  prefix="mekwasher:"
  :metrics="[
    { name: 'fluid',                  value: '0.0 - inf', unit: 'B' },
    { name: 'fluid_capacity',         value: '0.0 - inf', unit: 'B' },
    { name: 'fluid_needed',           value: '0.0 - inf', unit: 'B' },
    { name: 'input_slurry',           value: '0.0 - inf', unit: 'B' },
    { name: 'input_slurry_capacity',  value: '0.0 - inf', unit: 'B' },
    { name: 'input_slurry_needed',    value: '0.0 - inf', unit: 'B' }
  ]"
/>

### Output

<MetricTable
  prefix="mekwasher:"
  :metrics="[
    { name: 'output_slurry',          value: '0.0 - inf', unit: 'B' },
    { name: 'output_slurry_capacity', value: '0.0 - inf', unit: 'B' },
    { name: 'output_slurry_needed',   value: '0.0 - inf', unit: 'B' }
  ]"
/>

### Energy

<MetricTable
  prefix="mekwasher:"
  :metrics="[
    ...metrics.genericMachine.energy
  ]"
/>