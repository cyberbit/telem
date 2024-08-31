---
telem:
  adapter:
    id: 'electricPump'
    name: 'Electric Pump'
    categories: '{ "basic", "advanced", "output", "energy" }'
---

<script setup>
  import { data as metrics } from './common/metrics.data.ts'
</script>

# Mekanism Electric Pump Input <RepoLink path="lib/input/mekanism/ElectricPumpInputAdapter.lua" />

<!--@include: ./common/preamble.md -->

### Basic

<MetricTable
  prefix="mekpump:"
  :metrics="[
    { name: 'input_item_count',         value: '0 - inf', unit: 'item'  },
    { name: 'output_item_count',        value: '0 - inf', unit: 'item'  },
    { name: 'fluid_filled_percentage',  value: '0.0 - 1.0'              },
    ...metrics.genericMachine.basic
  ]"
/>

### Advanced

<MetricTable
  prefix="mekpump:"
  :metrics="[
    ...metrics.genericMachine.advanced
  ]"
/>

### Energy

<MetricTable
  prefix="mekpump:"
  :metrics="[
    ...metrics.genericMachine.energy
  ]"
/>

### Output

<MetricTable
  prefix="mekpump:"
  :metrics="[
    { name: 'fluid',          value: '0.0 - inf', unit: 'B' },
    { name: 'fluid_capacity', value: '0.0 - inf', unit: 'B' },
    { name: 'fluid_needed',   value: '0.0 - inf', unit: 'B' }
  ]"
/>
