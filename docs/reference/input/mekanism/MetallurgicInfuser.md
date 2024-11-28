---
telem:
  adapter:
    id: 'metallurgicInfuser'
    name: 'Metallurgic Infuser'
    categories: '{ "basic", "advanced", "input", "energy", "recipe" }'
---

<script setup>
  import { data as metrics } from './common/metrics.data.ts'
</script>

# Mekanism Metallurgic Infuser Input <RepoLink path="lib/input/mekanism/MetallurgicInfuserInputAdapter.lua" />

<!--@include: ./common/preamble.md -->

### Basic

<MetricTable
  prefix="mekmetalinfuse:"
  :metrics="[
    { name: 'input_count',              value: '0 - inf',   unit: 'item'  },
    { name: 'infuse_item_count',        value: '0 - inf',   unit: 'item'  },
    { name: 'infuse_filled_percentage', value: '0.0 - 1.0'                },
    { name: 'output_count',             value: '0 - inf',   unit: 'item'  },
    { name: 'energy_usage',             value: '0.0 - inf', unit: 'FE/t'  },
    ...metrics.genericMachine.basic
  ]"
/>

### Advanced

<MetricTable
  prefix="mekmetalinfuse:"
  :metrics="[
    ...metrics.genericMachine.advanced
  ]"
/>

### Input

<MetricTable
  prefix="mekmetalinfuse:"
  :metrics="[
    { name: 'infuse',           value: '0.0 - inf', unit: 'B' },
    { name: 'infuse_capacity',  value: '0.0 - inf', unit: 'B' },
    { name: 'infuse_needed',    value: '0.0 - inf', unit: 'B' }
  ]"
/>

### Energy

<MetricTable
  prefix="mekmetalinfuse:"
  :metrics="[
    ...metrics.genericMachine.energy
  ]"
/>

### Recipe

<MetricTable
  prefix="mekmetalinfuse:"
  :metrics="[
    ...metrics.recipeProgress.recipe,
  ]"
/>