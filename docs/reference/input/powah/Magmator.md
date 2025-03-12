---
telem:
  adapter:
    id: 'magmator'
    name: 'Magmator'
    categories: '{ "basic" }'
---

<script setup>
  import { data as metrics } from './common/metrics.data.ts'
</script>

# Powah Magmator Input <RepoLink path="lib/input/powah/MagmatorInputAdapter.lua" />

<!--@include: ./common/preamble.md -->

### Basic

<MetricTable
  prefix="powahmagmator:"
  :metrics="[
    { name: 'burning',        value: '0 or 1'               },
    { name: 'fluid',          value: '0.0 - inf', unit: 'B' },
    { name: 'fluid_capacity', value: '0.0 - inf', unit: 'B' },
    ...metrics.energy.basic
  ]"
/>