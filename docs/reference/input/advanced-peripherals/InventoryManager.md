---
telem:
  adapter:
    id: 'inventoryManager'
    name: 'Inventory Manager'
    categories: '{ "basic" }'
---

# Advanced Peripherals Inventory Manager Input <RepoLink path="lib/input/advancedPeripherals/InventoryManagerInputAdapter.lua" />

<!--@include: ./common/preamble.md -->

### Basic

<MetricTable
  prefix="apinv:"
  :metrics="[
    { name: 'equipped',                   value: '0 or 1'   },
    { name: 'equipped_helmet',            value: '0 or 1'   },
    { name: 'equipped_chestplate',        value: '0 or 1'   },
    { name: 'equipped_leggings',          value: '0 or 1'   },
    { name: 'equipped_boots',             value: '0 or 1'   },
    { name: 'inventory_available',        value: '0 or 1'   },
    { name: 'inventory_slots_available',  value: '0 - inf'  }
  ]"
/>

## Storage

Given an Inventory Manager peripheral containing a memory card tied to a player with the following inventory:

![Player inventory](/assets/inventory.png)

This appends the following metrics to the backplane:

<MetricTable
  prefix="storage:"
  :metrics="[
    { name: 'minecraft:redstone',       value: 45,  unit: 'item' },
    { name: 'minecraft:spruce_planks',  value: 8,   unit: 'item' }
  ]"
/>