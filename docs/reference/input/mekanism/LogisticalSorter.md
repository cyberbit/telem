---
telem:
  adapter:
    id: 'logisticalSorter'
    name: 'Logistical Sorter'
    categories: '{ "basic" }'
---

<script setup>
  import { data as metrics } from './common/metrics.data.ts'
</script>

# Mekanism Logistical Sorter Input <RepoLink path="lib/input/mekanism/LogisticalSorterInputAdapter.lua" />

<!--@include: ./common/preamble.md -->

### Basic

<MetricTable
  prefix="meklogsorter:"
  :metrics="[
    { name: 'comparator_level', value: '0 - 15' },
  ]"
/>