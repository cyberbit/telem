---
telem:
  adapter:
    id: 'sps'
    name: 'Supercritical Phase Shifter'
    categories: '{ "basic", "input", "output", "energy", "formation" }'
---

<script setup>
  import { data as metrics } from './common/metrics.data.ts'
</script>

# Mekanism Supercritical Phase Shifter Input <RepoLink path="lib/input/mekanism/SupercriticalPhaseShifterInputAdapter.lua" />

<!--@include: ./common/preamble.md -->

### Basic

<MetricTable
  prefix="meksps:"
  :metrics="[
    { name: 'input_filled_percentage',  value: '0.0 - 1.0'              },
    { name: 'output_filled_percentage', value: '0.0 - 1.0'              },
    { name: 'process_rate',             value: '0.0 - inf', unit: 'B/t' },
    { name: 'energy_filled_percentage', value: '0.0 - 1.0'              }
  ]"
/>

### Input

<MetricTable
  prefix="meksps:"
  :metrics="[
    { name: 'input',           value: '0.0 - inf', unit: 'B' },
    { name: 'input_capacity',  value: '0.0 - inf', unit: 'B' },
    { name: 'input_needed',    value: '0.0 - inf', unit: 'B' }
  ]"
/>

### Output

<MetricTable
  prefix="meksps:"
  :metrics="[
    { name: 'output',           value: '0.0 - inf', unit: 'B' },
    { name: 'output_capacity',  value: '0.0 - inf', unit: 'B' },
    { name: 'output_needed',    value: '0.0 - inf', unit: 'B' }
  ]"
/>

### Energy

<MetricTable
  prefix="meksps:"
  :metrics="[
    { name: 'energy',         value: '0.0 - inf', unit: 'FE' },
    { name: 'max_energy',     value: '0.0 - inf', unit: 'FE' },
    { name: 'energy_needed',  value: '0.0 - inf', unit: 'FE' }
  ]"
/>

### Formation

<MetricTable
  prefix="meksps:"
  :metrics="[
    ...metrics.multiblock.formation,
    { name: 'coils',  value: '0 - inf'  }
  ]"
/>