---
telem:
  adapter:
    id: 'nutritionalLiquifier'
    name: 'Nutritional Liquifier'
    categories: '{ "basic", "advanced", "output", "energy", "recipe" }'
---

<script setup>
  import { data as metrics } from './common/metrics.data.ts'
</script>

# Mekanism Nutritional Liquifier Input <RepoLink path="lib/input/mekanism/NutritionalLiquifierInputAdapter.lua" />

<!--@include: ./common/preamble.md -->

### Basic

<MetricTable
  prefix="mekliquifier:"
  :metrics="[
    { name: 'input_count',                value: '0 - inf',   unit: 'item'  },
    { name: 'output_filled_percentage',   value: '0.0 - 1.0'                },
    { name: 'container_fill_item_count',  value: '0 - inf',   unit: 'item'  },
    { name: 'output_item_count',          value: '0 - inf',   unit: 'item'  },
    { name: 'energy_usage',               value: '0.0 - inf', unit: 'FE/t'  },
    ...metrics.genericMachine.basic
  ]"
/>

### Advanced

<MetricTable
  prefix="mekliquifier:"
  :metrics="[
    ...metrics.genericMachine.advanced
  ]"
/>

### Output

<MetricTable
  prefix="mekliquifier:"
  :metrics="[
    { name: 'output',           value: '0.0 - inf', unit: 'B' },
    { name: 'output_capacity',  value: '0.0 - inf', unit: 'B' },
    { name: 'output_needed',    value: '0.0 - inf', unit: 'B' }
  ]"
/>

### Energy

<MetricTable
  prefix="mekliquifier:"
  :metrics="[
    ...metrics.genericMachine.energy
  ]"
/>

### Recipe

<MetricTable
  prefix="mekliquifier:"
  :metrics="[
    ...metrics.recipeProgress.recipe
  ]"
/>