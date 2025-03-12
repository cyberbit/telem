---
telem:
  adapter:
    id: 'energyCell'
    name: 'Energy Cell'
    categories: '{ "basic" }'
---

<script setup>
  import { data as metrics } from './common/metrics.data.ts'
</script>

# Powah Energy Cell Input <RepoLink path="lib/input/powah/EnergyCellInputAdapter.lua" />

<!--@include: ./common/preamble.md -->

### Basic

<MetricTable
  prefix="powahcell:"
  :metrics="[
    ...metrics.energy.basic
  ]"
/>