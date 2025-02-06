---
telem:
  adapter:
    id: 'solarGenerator'
    name: 'Solar Generator'
    categories: '{ "basic", "advanced", "energy" }'
    requiresMekGen: true
---

<script setup>
  import { data as metrics } from './common/metrics.data.ts'
</script>

# Mekanism Solar Generator Input <RepoLink path="lib/input/mekanism/SolarGeneratorInputAdapter.lua" />

<!--@include: ./common/preamble.md -->

### Basic

<MetricTable
  prefix="meksolargen:"
  :metrics="[
    { name: 'sees_sun', value: '0 or 1' },
    ...metrics.genericMachine.basic,
    ...metrics.generator.basic
  ]"
/>

### Advanced

<MetricTable
  prefix="meksolargen:"
  :metrics="[
    ...metrics.genericMachine.advanced
  ]"
/>

### Energy

<MetricTable
  prefix="meksolargen:"
  :metrics="[
    ...metrics.genericMachine.energy,
    ...metrics.generator.energy
  ]"
/>