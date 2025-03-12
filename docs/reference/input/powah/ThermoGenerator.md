---
telem:
  adapter:
    id: 'thermoGenerator'
    name: 'Thermo Generator'
    categories: '{ "basic" }'
---

<script setup>
  import { data as metrics } from './common/metrics.data.ts'
</script>

# Powah Thermo Generator Input <RepoLink path="lib/input/powah/ThermoGeneratorInputAdapter.lua" />

<!--@include: ./common/preamble.md -->

### Basic

<MetricTable
  prefix="powahthermo:"
  :metrics="[
    { name: 'coolant',  value: '0.0 - inf', unit: 'B' },
    ...metrics.energy.basic
  ]"
/>