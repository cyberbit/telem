---
telem:
  adapter:
    id: 'infusingFactory'
    name: 'Infusing Factory'
    categories: '{ "basic", "advanced", "input", "energy", "recipe" }'
---

<script setup>
  import { data as metrics } from './common/metrics.data.ts'
</script>

# Mekanism Infusing Factory Input <RepoLink path="lib/input/mekanism/InfusingFactoryInputAdapter.lua" />

<!--@include: ./common/preamble.md -->

### Basic

<MetricTable
  prefix="mekmetalinfuse:"
  :metrics="[
    { name: 'input_count_sum',          value: '0 - inf',   unit: 'item'  },
    { name: 'infuse_item_count',        value: '0 - inf',   unit: 'item'  },
    { name: 'infuse_filled_percentage', value: '0.0 - 1.0'                },
    { name: 'output_count_sum',         value: '0 - inf',   unit: 'item'  },
    { name: 'energy_usage',             value: '0.0 - inf', unit: 'FE/t'  },
    ...metrics.genericMachine.basic
  ]"
/>

### Advanced

<MetricTable
  prefix="mekmetalinfuse:"
  :metrics="[
    { name: 'auto_sort', value: '0 or 1' },
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
    ...metrics.recipeProgress.recipeFactory,
  ]"
/>