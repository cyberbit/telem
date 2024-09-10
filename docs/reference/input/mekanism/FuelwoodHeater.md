---
telem:
  adapter:
    id: 'fuelwoodHeater'
    name: 'Fuelwood Heater'
    categories: '{ "basic", "advanced" }'
---

<script setup>
  import { data as metrics } from './common/metrics.data.ts'
</script>

# Mekanism Fuelwood Heater Input <RepoLink path="lib/input/mekanism/FuelwoodHeaterInputAdapter.lua" />

<!--@include: ./common/preamble.md -->

### Basic

<MetricTable
  prefix="mekfuelheater:"
  :metrics="[
    { name: 'fuel_count',   value: '0 - inf',   unit: 'item'  },
    { name: 'temperature',  value: '0.0 - inf', unit: 'K'     }
  ]"
/>

### Advanced

<MetricTable
  prefix="mekfuelheater:"
  :metrics="[
    { name: 'environmental_loss', value: '0.0 - inf' }
  ]"
/>
