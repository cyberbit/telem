---
telem:
  adapter:
    id: 'solarPanel'
    name: 'Solar Panel'
    categories: '{ "basic" }'
---

<script setup>
  import { data as metrics } from './common/metrics.data.ts'
</script>

# Powah Solar Panel Input <RepoLink path="lib/input/powah/SolarPanelInputAdapter.lua" />

<!--@include: ./common/preamble.md -->

### Basic

<MetricTable
  prefix="powahsolar:"
  :metrics="[
    { name: 'sees_sky', value: '0 or 1' },
    ...metrics.energy.basic
  ]"
/>