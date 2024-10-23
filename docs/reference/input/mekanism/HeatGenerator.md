---
telem:
  adapter:
    id: 'heatGenerator'
    name: 'Heat Generator'
    categories: '{ "basic", "advanced", "fuel", "energy" }'
    requiresMekGen: true
---

<script setup>
  import { data as metrics } from './common/metrics.data.ts'
</script>

# Mekanism Heat Generator Input <RepoLink path="lib/input/mekanism/HeatGeneratorInputAdapter.lua" />

<!--@include: ./common/preamble.md -->

### Basic

<MetricTable
  prefix="mekheatgen:"
  :metrics="[
    { name: 'fuel_item_count',        value: '0 - inf',   unit: 'item'  },
    { name: 'lava_filled_percentage', value: '0.0 - 1.0'                },
    { name: 'temperature',            value: '0.0 - inf', unit: 'K'     },
    ...metrics.genericMachine.basic,
    ...metrics.generator.basic
  ]"
/>

### Advanced

<MetricTable
  prefix="mekheatgen:"
  :metrics="[
    { name: 'transfer_loss',      value: '0.0 - inf' },
    { name: 'environmental_loss', value: '0.0 - inf' },
    ...metrics.genericMachine.advanced
  ]"
/>

### Fuel

<MetricTable
  prefix="mekheatgen:"
  :metrics="[
    { name: 'lava',           value: '0.0 - inf', unit: 'B' },
    { name: 'lava_capacity',  value: '0.0 - inf', unit: 'B' },
    { name: 'lava_needed',    value: '0.0 - inf', unit: 'B' }
  ]"
/>

### Energy

<MetricTable
  prefix="mekheatgen:"
  :metrics="[
    ...metrics.genericMachine.energy,
    ...metrics.generator.energy
  ]"
/>