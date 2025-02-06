---
telem:
  adapter:
    id: 'rotaryCondensentrator'
    name: 'Rotary Condensentrator'
    categories: '{ "basic", "advanced", "gas", "fluid", "energy" }'
---

<script setup>
  import { data as metrics } from './common/metrics.data.ts'
</script>

# Mekanism Rotary Condensentrator Input <RepoLink path="lib/input/mekanism/RotaryCondensentratorInputAdapter.lua" />

<!--@include: ./common/preamble.md -->

### Basic

<MetricTable
  prefix="mekcondense:"
  :metrics="[
    { name: 'condensentrating',         value: '0 or 1'                   },
    { name: 'gas_input_item_count',     value: '0 - inf',   unit: 'item'  },
    { name: 'gas_filled_percentage',    value: '0.0 - 1.0'                },
    { name: 'gas_output_item_count',    value: '0 - inf',   unit: 'item'  },
    { name: 'fluid_input_item_count',   value: '0 - inf',   unit: 'item'  },
    { name: 'fluid_filled_percentage',  value: '0.0 - 1.0'                },
    { name: 'fluid_output_item_count',  value: '0 - inf',   unit: 'item'  },
    { name: 'energy_usage',             value: '0.0 - inf', unit: 'FE/t'  },
    ...metrics.genericMachine.basic
  ]"
/>

### Advanced

<MetricTable
  prefix="mekcondense:"
  :metrics="[
    ...metrics.genericMachine.advanced
  ]"
/>

### Gas

<MetricTable
  prefix="mekcondense:"
  :metrics="[
    { name: 'gas',          value: '0.0 - inf', unit: 'B' },
    { name: 'gas_capacity', value: '0.0 - inf', unit: 'B' },
    { name: 'gas_needed',   value: '0.0 - inf', unit: 'B' }
  ]"
/>

### Fluid

<MetricTable
  prefix="mekcondense:"
  :metrics="[
    { name: 'fluid',           value: '0.0 - inf', unit: 'B' },
    { name: 'fluid_capacity',  value: '0.0 - inf', unit: 'B' },
    { name: 'fluid_needed',    value: '0.0 - inf', unit: 'B' }
  ]"
/>

### Energy

<MetricTable
  prefix="mekcondense:"
  :metrics="[
    ...metrics.genericMachine.energy
  ]"
/>