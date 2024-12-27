---
telem:
  adapter:
    id: 'paintingMachine'
    name: 'Painting Machine'
    categories: '{ "basic", "advanced", "input", "energy", "recipe" }'
---

<script setup>
  import { data as metrics } from './common/metrics.data.ts'
</script>

# Mekanism Painting Machine Input <RepoLink path="lib/input/mekanism/PaintingMachineInputAdapter.lua" />

<!--@include: ./common/preamble.md -->

### Basic

<MetricTable
  prefix="mekpainting:"
  :metrics="[
    { name: 'input_pigment_item_count',         value: '0 - inf',   unit: 'item'  },
    { name: 'input_pigment_filled_percentage',  value: '0.0 - 1.0'                },
    { name: 'input_item_count',                 value: '0 - inf',   unit: 'item'  },
    { name: 'output_count',                     value: '0 - inf',   unit: 'item'  },
    { name: 'energy_usage',                     value: '0.0 - inf', unit: 'FE/t'  },
    ...metrics.genericMachine.basic
  ]"
/>

### Advanced

<MetricTable
  prefix="mekpainting:"
  :metrics="[
    ...metrics.genericMachine.advanced
  ]"
/>

### Input

<MetricTable
  prefix="mekpainting:"
  :metrics="[
    { name: 'input_pigment',          value: '0.0 - inf', unit: 'B' },
    { name: 'input_pigment_capacity', value: '0.0 - inf', unit: 'B' },
    { name: 'input_pigment_needed',   value: '0.0 - inf', unit: 'B' }
  ]"
/>

### Energy

<MetricTable
  prefix="mekpainting:"
  :metrics="[
    ...metrics.genericMachine.energy
  ]"
/>

### Recipe

<MetricTable
  prefix="mekpainting:"
  :metrics="[
    ...metrics.recipeProgress.recipe,
  ]"
/>