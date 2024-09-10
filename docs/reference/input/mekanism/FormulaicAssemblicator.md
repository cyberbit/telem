---
telem:
  adapter:
    id: 'assemblicator'
    name: 'Formulaic Assemblicator'
    categories: '{ "basic", "advanced", "energy", "recipe" }'
---

<script setup>
  import { data as metrics } from './common/metrics.data.ts'
</script>

# Mekanism Formulaic Assemblicator Input <RepoLink path="lib/input/mekanism/FormulaicAssemblicatorInputAdapter.lua" />

<!--@include: ./common/preamble.md -->

### Basic

<MetricTable
  prefix="mekassemblicator:"
  :metrics="[
    { name: 'input_slot_usage',   value: '0 - inf' },
    { name: 'input_slot_count',   value: '0 - inf' },
    { name: 'output_slot_usage',  value: '0 - inf' },
    { name: 'output_slot_count',  value: '0 - inf' },
    ...metrics.genericMachine.basic
  ]"
/>

### Advanced

<MetricTable
  prefix="mekassemblicator:"
  :metrics="[
    { name: 'valid_formula',  value: '0 or 1' },
    { name: 'auto_mode',      value: '0 or 1' },
    { name: 'stock_control',  value: '0 or 1' },
    ...metrics.genericMachine.advanced
  ]"
/>

### Energy

<MetricTable
  prefix="mekassemblicator:"
  :metrics="[
    ...metrics.genericMachine.energy
  ]"
/>

### Recipe

<MetricTable
  prefix="mekassemblicator:"
  :metrics="[
    ...metrics.recipeProgress.recipe
  ]"
/>