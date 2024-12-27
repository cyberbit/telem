---
telem:
  adapter:
    id: 'pigmentExtractor'
    name: 'Pigment Extractor'
    categories: '{ "basic", "advanced", "output", "energy", "recipe" }'
---

<script setup>
  import { data as metrics } from './common/metrics.data.ts'
</script>

# Mekanism Pigment Extractor Input <RepoLink path="lib/input/mekanism/PigmentExtractorInputAdapter.lua" />

<!--@include: ./common/preamble.md -->

### Basic

<MetricTable
  prefix="mekpigmentextractor:"
  :metrics="[
    { name: 'input_count',              value: '0 - inf',   unit: 'item'  },
    { name: 'output_item_count',        value: '0 - inf',   unit: 'item'  },
    { name: 'output_filled_percentage', value: '0.0 - 1.0'                },
    { name: 'energy_usage',             value: '0.0 - inf', unit: 'FE/t'  },
    ...metrics.genericMachine.basic
  ]"
/>

### Advanced

<MetricTable
  prefix="mekpigmentextractor:"
  :metrics="[
    ...metrics.genericMachine.advanced
  ]"
/>

### Output

<MetricTable
  prefix="mekpigmentextractor:"
  :metrics="[
    { name: 'output',           value: '0.0 - inf', unit: 'B' },
    { name: 'output_capacity',  value: '0.0 - inf', unit: 'B' },
    { name: 'output_needed',    value: '0.0 - inf', unit: 'B' }
  ]"
/>

### Energy

<MetricTable
  prefix="mekpigmentextractor:"
  :metrics="[
    ...metrics.genericMachine.energy
  ]"
/>

### Recipe

<MetricTable
  prefix="mekpigmentextractor:"
  :metrics="[
    ...metrics.recipeProgress.recipe,
  ]"
/>