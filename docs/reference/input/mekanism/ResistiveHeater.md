---
telem:
  adapter:
    id: 'resistiveHeater'
    name: 'Resistive Heater'
    categories: '{ "basic", "advanced", "energy" }'
---

<script setup>
  import { data as metrics } from './common/metrics.data.ts'
</script>

# Mekanism Resistive Heater Input <RepoLink path="lib/input/mekanism/ResistiveHeaterInputAdapter.lua" />

<!--@include: ./common/preamble.md -->

### Basic

<MetricTable
  prefix="mekresheater:"
  :metrics="[
    { name: 'energy_filled_percentage', value: '0.0 - 1.0'                },
    { name: 'energy_usage_target',      value: '0.0 - inf', unit: 'FE/t'  },
    {
      name: 'energy_usage',             value: '0.0 - inf', unit: 'FE/t',
      badge: { type: 'warning', text: 'Mekanism 10.3+' }
    },
    { name: 'temperature',              value: '0.0 - inf', unit: 'K'     }
  ]"
/>

### Advanced

<MetricTable
  prefix="mekresheater:"
  :metrics="[
    { name: 'environmental_loss', value: '0.0 - 1.0' }
  ]"
/>

### Energy

<MetricTable
  prefix="mekresheater:"
  :metrics="[
    { name: 'energy',         value: '0.0 - inf', unit: 'FE' },
    { name: 'max_energy',     value: '0.0 - inf', unit: 'FE' },
    { name: 'energy_needed',  value: '0.0 - inf', unit: 'FE' }
  ]"
/>