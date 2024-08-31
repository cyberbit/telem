---
telem:
  adapter:
    id: 'dynamicTank'
    name: 'Dynamic Tank'
    categories: '{ "basic", "storage", "formation" }'
---

<script setup>
  import { data as metrics } from './common/metrics.data.ts'
</script>

# Mekanism Dynamic Tank Input <RepoLink path="lib/input/mekanism/DynamicTankInputAdapter.lua" />

<!--@include: ./common/preamble.md -->

### Basic

<MetricTable
  prefix="mekdyntank:"
  :metrics="[
    { name: 'filled_percentage', value: '0.0 - 1.0'                 },
    { name: 'input_item_count',  value: '0 - inf',    unit: 'item'  },
    { name: 'output_item_count', value: '0 - inf',    unit: 'item'  }
  ]"
/>

### Storage

<MetricTable
  prefix="mekdyntank:"
  :metrics="[
    { name: 'stored',             value: '0.0 - inf', unit: 'B' },
    { name: 'fluid_capacity',     value: '0.0 - inf', unit: 'B' },
    { name: 'chemical_capacity',  value: '0.0 - inf', unit: 'B' }
  ]"
/>

### Formation

<MetricTable
  prefix="mekdyntank:"
  :metrics="[
    ...metrics.multiblock.formation
  ]"
/>


## Storage
Dynamic tanks may hold either a fluid or a chemical. If the tank is not empty, a storage metric is added for the contents. Given a dynamic tank with the following contents:

![Mekanism Dynamic Tank with contents](/assets/mekanism-dynamic-tank.webp)

The following metric would be added:

<MetricTable
  prefix="storage:"
  :metrics="[
    { name: 'tconstruct:molten_ender', value: '7455.75', unit: 'B' }
  ]"
/>