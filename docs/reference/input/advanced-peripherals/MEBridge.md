---
telem:
  adapter:
    id: 'meBridge'
    name: 'ME Bridge'
    categories: '{ "basic", "energy", "storage" }'
    requiresMod: 'Applied Energistics 2'
---

# Advanced Peripherals ME Bridge Input <RepoLink path="lib/input/advancedPeripherals/MEBridgeInputAdapter.lua" />

<!--@include: ./common/preamble.md -->

### Basic

<MetricTable
  prefix="apmebridge:"
  :metrics="[
    { name: 'energy_usage',       value: '0.0 - inf', unit: 'FE/t'  },
    { name: 'item_storage_used',  value: '0 - inf',   unit: 'bytes' },
    { name: 'fluid_storage_used', value: '0 - inf',   unit: 'bytes' },
    { name: 'cell_count',         value: '0 - inf'                  }
  ]"
/>

### Energy

<MetricTable
  prefix="apmebridge:"
  :metrics="[
    { name: 'energy',     value: '0.0 - inf', unit: 'FE'  },
    { name: 'max_energy', value: '0.0 - inf', unit: 'FE'  }
  ]"
/>

### Storage

<MetricTable
  prefix="apmebridge:"
  :metrics="[
    { name: 'item_storage_capacity',    value: '0 - inf', unit: 'bytes' },
    { name: 'item_storage_available',   value: '0 - inf', unit: 'bytes' },
    { name: 'fluid_storage_capacity',   value: '0 - inf', unit: 'bytes' },
    { name: 'fluid_storage_available',  value: '0 - inf', unit: 'bytes' }
  ]"
/>

## Storage

Given an ME Bridge peripheral attached to an ME storage network with the following stored items and fluids:

![Applied Energistics ME Terminal inventory](/assets/me-inventory.webp)

This appends the following metrics to the backplane:

<MetricTable
  prefix="storage:"
  :metrics="[
    { name: 'minecraft:lava',       value: 29.25, unit: 'B'     },
    { name: 'minecraft:oak_planks', value: 3,     unit: 'item'  },
    { name: 'minecraft:redstone',   value: 1408,  unit: 'item'  }
  ]"
/>

If Applied Mekanistics is installed, any stored chemicals and gases will also be included as metrics.