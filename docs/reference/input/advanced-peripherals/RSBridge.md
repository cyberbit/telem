---
telem:
  adapter:
    id: 'rsBridge'
    name: 'RS Bridge'
    categories: '{ "basic", "energy", "storage" }'
    requiresMod: 'Refined Storage'
---

# Advanced Peripherals RS Bridge Input <RepoLink path="lib/input/advancedPeripherals/RSBridgeInputAdapter.lua" />

<!--@include: ./common/preamble.md -->

### Basic

<MetricTable
  prefix="aprsbridge:"
  :metrics="[
    { name: 'energy_usage', value: '0.0 - inf', unit: 'FE/t' },
  ]"
/>

### Energy

<MetricTable
  prefix="aprsbridge:"
  :metrics="[
    { name: 'energy',     value: '0.0 - inf', unit: 'FE' },
    { name: 'max_energy', value: '0.0 - inf', unit: 'FE' }
  ]"
/>

### Storage

<MetricTable
  prefix="aprsbridge:"
  :metrics="[
    { name: 'item_disk_capacity',       value: '0 - inf',   unit: 'item'  },
    { name: 'item_external_capacity',   value: '0 - inf',   unit: 'item'  },
    { name: 'fluid_disk_capacity',      value: '0.0 - inf', unit: 'B'     },
    { name: 'fluid_external_capacity',  value: '0.0 - inf', unit: 'B'     }
  ]"
/>

## Storage

Given an RS Bridge peripheral attached to a Refined Storage network with the following stored items and fluids:

![Refined Storage Fluid Grid and Grid inventory](/assets/rs-inventory.webp)

This appends the following metrics to the backplane:

<MetricTable
  prefix="storage:"
  :metrics="[
    { name: 'minecraft:lava',       value: 23.810,  unit: 'B'     },
    { name: 'minecraft:oak_planks', value: 3,       unit: 'item'  },
    { name: 'minecraft:redstone',   value: 459,     unit: 'item'  }
  ]"
/>