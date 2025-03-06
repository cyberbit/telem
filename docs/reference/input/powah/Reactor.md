---
telem:
  adapter:
    id: 'reactor'
    name: 'Reactor'
    categories: '{ "basic" }'
---

<script setup>
  import { data as metrics } from './common/metrics.data.ts'
</script>

# Powah Reactor Input <RepoLink path="lib/input/powah/ReactorInputAdapter.lua" />

<!--@include: ./common/preamble.md -->

### Basic

<MetricTable
  prefix="powahreactor:"
  :metrics="[
    { name: 'running',      value: '0 or 1'                 },
    { name: 'fuel',         value: '0.0 - 100.0', unit: '%' },
    { name: 'carbon',       value: '0.0 - 100.0', unit: '%' },
    { name: 'redstone',     value: '0.0 - 100.0', unit: '%' },
    { name: 'temperature',  value: '0.0 - 100.0', unit: '%' },
    ...metrics.energy.basic
  ]"
/>