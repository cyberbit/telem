---
telem:
  adapter:
    id: 'fluidicPlenisher'
    name: 'Fluidic Plenisher'
    categories: '{ "basic", "advanced", "input", "energy" }'
---

<script setup>
  import { data as metrics } from './common/metrics.data.ts'
</script>

# Mekanism Fluidic Plenisher Input <RepoLink path="lib/input/mekanism/FluidicPlenisherInputAdapter.lua" />

<!--@include: ./common/preamble.md -->

### Basic

<MetricTable
  prefix="mekplenisher:"
  :metrics="[
    { name: 'input_item_count',         value: '0 - inf', unit: 'item'  },
    { name: 'output_item_count',        value: '0 - inf', unit: 'item'  },
    { name: 'fluid_filled_percentage',  value: '0.0 - 1.0'              },
    ...metrics.genericMachine.basic
  ]"
/>

### Advanced

<MetricTable
  prefix="mekplenisher:"
  :metrics="[
    ...metrics.genericMachine.advanced
  ]"
/>

### Input

<MetricTable
  prefix="mekplenisher:"
  :metrics="[
    { name: 'fluid',          value: '0.0 - inf', unit: 'B' },
    { name: 'fluid_capacity', value: '0.0 - inf', unit: 'B' },
    { name: 'fluid_needed',   value: '0.0 - inf', unit: 'B' }
  ]"
/>

### Energy

<MetricTable
  prefix="mekplenisher:"
  :metrics="[
    ...metrics.genericMachine.energy
  ]"
/>