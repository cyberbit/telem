---
telem:
  adapter:
    id: 'purifyingFactory'
    name: 'Purifying Factory'
    categories: '{ "basic", "advanced", "input", "energy", "recipe" }'
---

<script setup>
  import { data as metrics } from './common/metrics.data.ts'
</script>

# Mekanism Purifying Factory Input <RepoLink path="lib/input/mekanism/PurifyingFactoryInputAdapter.lua" />

<!--@include: ./common/preamble.md -->

### Basic

<MetricTable
  prefix="mekpurify:"
  :metrics="[
    { name: 'chemical_item_count',        value: '0 - inf',   unit: 'item'  },
    { name: 'chemical_filled_percentage', value: '0.0 - 1.0'                },
    { name: 'input_count_sum',            value: '0 - inf',   unit: 'item'  },
    { name: 'output_count_sum',           value: '0 - inf',   unit: 'item'  },
    { name: 'energy_usage',               value: '0.0 - inf', unit: 'FE/t'  },
    ...metrics.genericMachine.basic
  ]"
/>

### Advanced

<MetricTable
  prefix="mekpurify:"
  :metrics="[
    { name: 'auto_sort', value: '0 or 1' },
    ...metrics.genericMachine.advanced
  ]"
/>

### Input

<MetricTable
  prefix="mekpurify:"
  :metrics="[
    { name: 'chemical',           value: '0.0 - inf', unit: 'B' },
    { name: 'chemical_capacity',  value: '0.0 - inf', unit: 'B' },
    { name: 'chemical_needed',    value: '0.0 - inf', unit: 'B' }
  ]"
/>

### Energy

<MetricTable
  prefix="mekpurify:"
  :metrics="[
    ...metrics.genericMachine.energy
  ]"
/>

### Recipe

<MetricTable
  prefix="mekpurify:"
  :metrics="[
    ...metrics.recipeProgress.recipeFactory,
  ]"
/>