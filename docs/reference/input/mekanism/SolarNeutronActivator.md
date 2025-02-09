---
telem:
  adapter:
    id: 'neutronActivator'
    name: 'Solar Neutron Activator'
    categories: '{ "basic", "input", "output" }'
---

<script setup>
  import { data as metrics } from './common/metrics.data.ts'
</script>

# Mekanism Solar Neutron Activator Input <RepoLink path="lib/input/mekanism/SolarNeutronActivatorInputAdapter.lua" />

<!--@include: ./common/preamble.md -->

### Basic

<MetricTable
  prefix="mekactivator:"
  :metrics="[
    { name: 'input_item_count',               value: '0 - inf',   unit: 'item'  },
    { name: 'input_filled_percentage',        value: '0.0 - 1.0'                },
    { name: 'output_filled_percentage',       value: '0.0 - 1.0'                },
    { name: 'output_item_count',              value: '0 - inf',   unit: 'item'  },
    { name: 'production_rate',                value: '0.0 - inf', unit: 'B/t'   },
    { name: 'peak_production_rate',           value: '0.0 - inf', unit: 'B/t'   },
    {
      name: 'sees_sun',                       value: '0 or 1',
      badge: { type: 'warning', text: 'Mekanism 10.3+' }
    }
  ]"
/>

### Input

<MetricTable
  prefix="mekactivator:"
  :metrics="[
    { name: 'input',          value: '0.0 - inf', unit: 'B' },
    { name: 'input_capacity', value: '0.0 - inf', unit: 'B' },
    { name: 'input_needed',   value: '0.0 - inf', unit: 'B' }
  ]"
/>

### Output

<MetricTable
  prefix="mekactivator:"
  :metrics="[
    { name: 'output',           value: '0.0 - inf', unit: 'B' },
    { name: 'output_capacity',  value: '0.0 - inf', unit: 'B' },
    { name: 'output_needed',    value: '0.0 - inf', unit: 'B' }
  ]"
/>