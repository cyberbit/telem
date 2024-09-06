---
telem:
  adapter:
    id: 'energyCube'
    name: 'Energy Cube'
    categories: '{ "basic", "energy", "advanced" }'
---

<script setup>
  import { data as metrics } from './common/metrics.data.ts'
</script>

# Mekanism Energy Cube Input <RepoLink path="lib/input/mekanism/EnergyCubeInputAdapter.lua" />

<!--@include: ./common/preamble.md -->

### Basic

<MetricTable
  prefix="mekenergycube:"
  :metrics="[
    { name: 'charge_item_count',    value: '0 - inf', unit: 'item' },
    { name: 'discharge_item_count', value: '0 - inf', unit: 'item' },
    ...metrics.genericMachine.basic
  ]"
/>

### Advanced

<MetricTable
  prefix="mekenergycube:"
  :metrics="[
    ...metrics.genericMachine.advanced
  ]"
/>

### Energy

<MetricTable
  prefix="mekenergycube:"
  :metrics="[
    ...metrics.genericMachine.energy
  ]"
/>