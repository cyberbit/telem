---
telem:
  adapter:
    id: 'evaporationPlant'
    name: 'Thermal Evaporation Plant'
    categories: '{ "basic", "advanced", "input", "output", "formation" }'
---

<script setup>
  import { data as metrics } from './common/metrics.data.ts'
</script>

# Mekanism Thermal Evaporation Plant Input <RepoLink path="lib/input/mekanism/ThermalEvaporationPlantInputAdapter.lua" />

<!--@include: ./common/preamble.md -->

### Basic

<MetricTable
  prefix="mekevap:"
  :metrics="[
    { name: 'input_filled_percentage',  value: '0.0 - 1.0'                },
    { name: 'output_filled_percentage', value: '0.0 - 1.0'                },
    { name: 'input_input_item_count',   value: '0 - inf',   unit: 'item'  },
    { name: 'input_output_item_count',  value: '0 - inf',   unit: 'item'  },
    { name: 'output_input_item_count',  value: '0 - inf',   unit: 'item'  },
    { name: 'output_output_item_count', value: '0 - inf',   unit: 'item'  },
    { name: 'production_amount',        value: '0.0 - inf', unit: 'B/t'   },
    { name: 'temperature',              value: '0.0 - inf', unit: 'K'     }
  ]"
/>

### Advanced

<MetricTable
  prefix="mekevap:"
  :metrics="[
    { name: 'environmental_loss', value: '0.0 - 1.0' },
  ]"
/>

### Input

<MetricTable
  prefix="mekevap:"
  :metrics="[
    { name: 'input',          value: '0.0 - inf', unit: 'B' },
    { name: 'input_capacity', value: '0.0 - inf', unit: 'B' },
    { name: 'input_needed',   value: '0.0 - inf', unit: 'B' }
  ]"
/>

### Output

<MetricTable
  prefix="mekevap:"
  :metrics="[
    { name: 'output',           value: '0.0 - inf', unit: 'B' },
    { name: 'output_capacity',  value: '0.0 - inf', unit: 'B' },
    { name: 'output_needed',    value: '0.0 - inf', unit: 'B' }
  ]"
/>

### Formation

<MetricTable
  prefix="mekevap:"
  :metrics="[
    ...metrics.multiblock.formation,
    { name: 'active_solars', value: '0 - inf' }
  ]"
/>