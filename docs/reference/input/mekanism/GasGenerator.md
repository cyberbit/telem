---
telem:
  adapter:
    id: 'gasGenerator'
    name: 'Gas Generator'
    categories: '{ "basic", "advanced", "fuel", "energy" }'
    requiresMekGen: true
---

<script setup>
  import { data as metrics } from './common/metrics.data.ts'
</script>

# Mekanism Gas Generator Input <RepoLink path="lib/input/mekanism/GasGeneratorInputAdapter.lua" />

<!--@include: ./common/preamble.md -->

### Basic

<MetricTable
  prefix="mekgasgen:"
  :metrics="[
    { name: 'fuel_filled_percentage', value: '0.0 - 1.0'                },
    { name: 'burn_rate',              value: '0.0 - inf', unit: 'B/t'   },
    { name: 'fuel_item_count',        value: '0 - inf',   unit: 'item'  },
    ...metrics.genericMachine.basic,
    ...metrics.generator.basic
  ]"
/>

### Advanced

<MetricTable
  prefix="mekgasgen:"
  :metrics="[
    ...metrics.genericMachine.advanced
  ]"
/>

### Fuel

<MetricTable
  prefix="mekgasgen:"
  :metrics="[
    { name: 'fuel',           value: '0.0 - inf', unit: 'B' },
    { name: 'fuel_capacity',  value: '0.0 - inf', unit: 'B' },
    { name: 'fuel_needed',    value: '0.0 - inf', unit: 'B' }
  ]"
/>

### Energy

<MetricTable
  prefix="mekgasgen:"
  :metrics="[
    ...metrics.genericMachine.energy,
    ...metrics.generator.energy
  ]"
/>