---
telem:
  adapter:
    id: 'mechanicalPipe'
    name: 'Mechanical Pipe'
    categories: '{ "basic", "transfer" }'
---

<script setup>
  import { data as metrics } from './common/metrics.data.ts'
</script>

# Mekanism Mechanical Pipe Input <RepoLink path="lib/input/mekanism/MechanicalPipeInputAdapter.lua" />

<!--@include: ./common/preamble.md -->

### Basic

<MetricTable
  prefix="mekpipe:"
  :metrics="[
    { name: 'filled_percentage', value: '0.0 - 1.0' },
  ]"
/>

### Transfer

<MetricTable
  prefix="mekpipe:"
  :metrics="[
    { name: 'buffer', value: '0.0 - inf', unit: 'B' },
    { name: 'capacity', value: '0.0 - inf', unit: 'B' },
    { name: 'needed', value: '0.0 - inf', unit: 'B' },
  ]"
/>