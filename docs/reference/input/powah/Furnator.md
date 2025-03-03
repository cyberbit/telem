---
telem:
  adapter:
    id: 'furnator'
    name: 'Furnator'
    categories: '{ "basic" }'
---

<script setup>
  import { data as metrics } from './common/metrics.data.ts'
</script>

# Powah Furnator Input <RepoLink path="lib/input/powah/FurnatorInputAdapter.lua" />

<!--@include: ./common/preamble.md -->

### Basic

<MetricTable
  prefix="powahfurnator:"
  :metrics="[
    { name: 'burning',  value: '0 or 1'                 },
    { name: 'carbon',   value: '0.0 - 100.0', unit: '%' },
    ...metrics.energy.basic
  ]"
/>