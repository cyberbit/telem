---
telem:
  adapter:
    id: 'fluidTank'
    name: 'Fluid Tank'
    categories: '{ "basic", "storage" }'
---

<script setup>
  import { data as metrics } from './common/metrics.data.ts'
</script>

# Mekanism Fluid Tank Input <RepoLink path="lib/input/mekanism/FluidTankInputAdapter.lua" />

<!--@include: ./common/preamble.md -->

### Basic

<MetricTable
  prefix="mekfluidtank:"
  :metrics="[
    { name: 'filled_percentage',  value: '0.0 - 1.0'              },
    { name: 'input_item_count',   value: '0 - inf', unit: 'item'  },
    { name: 'output_item_count',  value: '0 - inf', unit: 'item'  }
  ]"
/>

### Storage

<MetricTable
  prefix="mekfluidtank:"
  :metrics="[
    { name: 'stored', value: '0.0 - inf',   unit: 'B' },
    { name: 'capacity', value: '0.0 - inf', unit: 'B' },
    { name: 'needed', value: '0.0 - inf',   unit: 'B' }
  ]"
/>

## Storage
If the tank contains a fluid, a storage metric is added for the fluid. Given a fluid tank with the following contents:

![Mekanism Advanced Fluid Tank with contents](/assets/mekanism-fluid-tank.webp)

The following metric would be added:

<MetricTable
  prefix="storage:"
  :metrics="[
    { name: 'mekanism:oxygen', value: '52', unit: 'B' }
  ]"
/>