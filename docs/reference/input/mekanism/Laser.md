---
telem:
  adapter:
    id: 'laser'
    name: 'Laser'
    categories: '{ "basic", "energy" }'
---

<script setup>
  import { data as metrics } from './common/metrics.data.ts'
</script>

# Mekanism Laser Input <RepoLink path="lib/input/mekanism/LaserInputAdapter.lua" />

<!--@include: ./common/preamble.md -->

### Basic

<MetricTable
  prefix="meklaser:"
  :metrics="[
    ...metrics.genericMachine.basic
  ]"
/>

### Energy

<MetricTable
  prefix="meklaser:"
  :metrics="[
    ...metrics.genericMachine.energy
  ]"
/>