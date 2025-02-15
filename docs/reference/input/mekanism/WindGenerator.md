---
telem:
  adapter:
    id: 'windGenerator'
    name: 'Wind Generator'
    categories: '{ "basic", "advanced", "energy" }'
    requiresMekGen: true
---

<script setup>
  import { data as metrics } from './common/metrics.data.ts'
</script>

# Mekanism Wind Generator Input <RepoLink path="lib/input/mekanism/WindGeneratorInputAdapter.lua" />

<!--@include: ./common/preamble.md -->

### Basic

<MetricTable
  prefix="mekwindgen:"
  :metrics="[
    { name: 'blacklisted_dimension', value: '0 or 1' },
    ...metrics.genericMachine.basic,
    ...metrics.generator.basic
  ]"
/>

### Advanced

<MetricTable
  prefix="mekwindgen:"
  :metrics="[
    ...metrics.genericMachine.advanced
  ]"
/>

### Energy

<MetricTable
  prefix="mekwindgen:"
  :metrics="[
    ...metrics.genericMachine.energy,
    ...metrics.generator.energy
  ]"
/>