---
outline: deep
---

# Item Storage Input <RepoLink path="lib/input/ItemStorageInputAdapter.lua" />

```lua
telem.input.itemStorage (peripheralID: string)
```

This adapter produces a metric for each item ID in an item storage peripheral (chest, barrel, etc.), with the metric name being the item ID and the value being the total number of that item in storage.

## Usage

```lua{4}
local telem = require 'telem'

local backplane = telem.backplane()
  :addInput('my_items', telem.input.itemStorage('minecraft:chest_2'))
  :cycleEvery(1)()
```

Given a chest peripheral with the ID `minecraft:chest_2` and the following inventory:

![Minecraft inventory with 45 redstone and 8 spruce planks](/assets/inventory.png)

This appends the following metrics to the backplane:

<MetricTable
  :metrics="[
    {
      name: 'storage:minecraft:redstone',
      value: 45,
      unit: 'item',
      adapter: 'my_items',
      source: 'minecraft:chest_2'
    },
    {
      name: 'storage:minecraft:spruce_planks',
      value: 8,
      unit: 'item',
      adapter: 'my_items',
      source: 'minecraft:chest_2'
    }
  ]"
/>