---
telem:
  adapter:
    id: 'universalCable'
    name: 'Universal Cable'
    categories: '{ "basic", "transfer" }'
---

<script setup>
  import { data as metrics } from './common/metrics.data.ts'
</script>

# Mekanism Universal Cable Input <RepoLink path="lib/input/mekanism/UniversalCableInputAdapter.lua" />

<!--@include: ./common/preamble.md -->

### Basic

<MetricTable
  prefix="mekcable:"
  :metrics="[
    { name: 'filled_percentage', value: '0.0 - 1.0' },
  ]"
/>

### Transfer

<MetricTable
  prefix="mekcable:"
  :metrics="[
    { name: 'buffer', value: '0.0 - inf', unit: 'FE' },
    { name: 'capacity', value: '0.0 - inf', unit: 'FE' },
    { name: 'needed', value: '0.0 - inf', unit: 'FE' },
  ]"
/>