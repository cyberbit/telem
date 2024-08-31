---
telem:
  adapter:
    id: 'electrolyticSeparator'
    name: 'Electrolytic Separator'
    categories: '{ "basic", "advanced", "input", "output", "energy" }'
---

<script setup>
  import { data as metrics } from './common/metrics.data.ts'
</script>

# Mekanism Electrolytic Separator Input <RepoLink path="lib/input/mekanism/ElectrolyticSeparatorInputAdapter.lua" />

<!--@include: ./common/preamble.md -->

### Basic

<MetricTable
  prefix="mekseparator:"
  :metrics="[
    { name: 'input_filled_percentage',        value: '0.0 - 1.0'                },
    { name: 'input_item_count',               value: '0 - inf',   unit: 'item'  },
    { name: 'output_left_filled_percentage',  value: '0.0 - 1.0'                },
    { name: 'output_left_item_count',         value: '0 - inf',   unit: 'item'  },
    { name: 'output_right_filled_percentage', value: '0.0 - 1.0'                },
    { name: 'output_right_item_count',        value: '0 - inf',   unit: 'item'  },
    { name: 'energy_usage',                   value: '0.0 - inf', unit: 'FE/t'  },
    ...metrics.genericMachine.basic
  ]"
/>

### Advanced

<MetricTable
  prefix="mekseparator:"
  :metrics="[
    ...metrics.genericMachine.advanced
  ]"
/>

### Input

<MetricTable
  prefix="mekseparator:"
  :metrics="[
    { name: 'input',          value: '0.0 - inf', unit: 'B' },
    { name: 'input_capacity', value: '0.0 - inf', unit: 'B' },
    { name: 'input_needed',   value: '0.0 - inf', unit: 'B' }
  ]"
/>

### Output

<MetricTable
  prefix="mekseparator:"
  :metrics="[
    { name: 'output_left',            value: '0.0 - inf', unit: 'B' },
    { name: 'output_left_capacity',   value: '0.0 - inf', unit: 'B' },
    { name: 'output_left_needed',     value: '0.0 - inf', unit: 'B' },
    { name: 'output_right',           value: '0.0 - inf', unit: 'B' },
    { name: 'output_right_capacity',  value: '0.0 - inf', unit: 'B' },
    { name: 'output_right_needed',    value: '0.0 - inf', unit: 'B' }
  ]"
/>

### Energy

<MetricTable
  prefix="mekseparator:"
  :metrics="[
    ...metrics.genericMachine.energy
  ]"
/>