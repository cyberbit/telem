---
telem:
  adapter:
    id: 'isotopicCentrifuge'
    name: 'Isotopic Centrifuge'
    categories: '{ "basic", "advanced", "input", "output", "energy" }'
---

<script setup>
  import { data as metrics } from './common/metrics.data.ts'
</script>

# Mekanism Isotopic Centrifuge Input <RepoLink path="lib/input/mekanism/IsotopicCentrifugeInputAdapter.lua" />

<!--@include: ./common/preamble.md -->

### Basic

<MetricTable
  prefix="mekcentrifuge:"
  :metrics="[
    { name: 'input_item_count',         value: '0 - inf',   unit: 'item'  },
    { name: 'input_filled_percentage',  value: '0.0 - inf'                },
    { name: 'output_filled_percentage', value: '0.0 - inf'                },
    { name: 'output_item_count',        value: '0 - inf',   unit: 'item'  },
    { name: 'energy_usage',             value: '0.0 - inf', unit: 'FE/t'  },
    ...metrics.genericMachine.basic
  ]"
/>

### Advanced

<MetricTable
  prefix="mekcentrifuge:"
  :metrics="[
    ...metrics.genericMachine.advanced
  ]"
/>

### Input

<MetricTable
  prefix="mekcentrifuge:"
  :metrics="[
    { name: 'input',          value: '0.0 - inf', unit: 'B' },
    { name: 'input_capacity', value: '0.0 - inf', unit: 'B' },
    { name: 'input_needed',   value: '0.0 - inf', unit: 'B' }
  ]"
/>

### Output

<MetricTable
  prefix="mekcentrifuge:"
  :metrics="[
    { name: 'output',           value: '0.0 - inf', unit: 'B' },
    { name: 'output_capacity',  value: '0.0 - inf', unit: 'B' },
    { name: 'output_needed',    value: '0.0 - inf', unit: 'B' }
  ]"
/>

### Energy

<MetricTable
  prefix="mekcentrifuge:"
  :metrics="[
    ...metrics.genericMachine.energy
  ]"
/>
