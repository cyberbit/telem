---
telem:
  adapter:
    id: 'pressurizedTube'
    name: 'Pressurized Tube'
    categories: '{ "basic", "transfer" }'
---

<script setup>
  import { data as metrics } from './common/metrics.data.ts'
</script>

# Mekanism Pressurized Tube Input <RepoLink path="lib/input/mekanism/PressurizedTubeInputAdapter.lua" />

<!--@include: ./common/preamble.md -->

### Basic

<MetricTable
  prefix="mektube:"
  :metrics="[
    { name: 'filled_percentage', value: '0.0 - 1.0' },
  ]"
/>

### Transfer

<MetricTable
  prefix="mektube:"
  :metrics="[
    { name: 'buffer', value: '0.0 - inf', unit: 'B' },
    { name: 'capacity', value: '0.0 - inf', unit: 'B' },
    { name: 'needed', value: '0.0 - inf', unit: 'B' },
  ]"
/>