---
telem:
  adapter:
    id: 'inductionMatrix'
    name: 'Induction Matrix'
    categories: '{ "basic", "advanced", "energy", "formation" }'
    requiresMekGen: true
---

<script setup>
  import { data as metrics } from './common/metrics.data.ts'
</script>

# Mekanism Induction Matrix Input <RepoLink path="lib/input/mekanism/InductionMatrixInputAdapter.lua" />

<!--@include: ./common/preamble.md -->

### Basic

<MetricTable
  prefix="mekinduction:"
  :metrics="[
    ...metrics.genericMachine.basic,
    { name: 'energy_input',             value: '0.0 - inf', unit: 'FE/t' },
    { name: 'energy_output',            value: '0.0 - inf', unit: 'FE/t' },
    { name: 'energy_transfer_cap',      value: '0 - inf',   unit: 'FE/t' }
  ]"
/>

### Advanced

<MetricTable
  prefix="mekinduction:"
  :metrics="[
    ...metrics.genericMachine.advanced,
  ]"
/>

### Energy

<MetricTable
  prefix="mekinduction:"
  :metrics="[
    ...metrics.genericMachine.energy,
  ]"
/>

### Formation

<MetricTable
  prefix="mekinduction:"
  :metrics="[
    ...metrics.multiblock.formation,
    { name: 'installed_cells',     value: '0 - inf' },
    { name: 'installed_providers', value: '0 - inf' }
  ]"
/>