# Mekanism Bin Input <RepoLink path="lib/input/mekanism/BinInputAdapter.lua" />

```lua
telem.input.mekanism.bin (
	peripheralID: string,
	categories?: string[] | '*'
)
```

::: warning Mod Dependencies
Requires **Mekanism**.
:::

See the Usage section for a complete list of the metrics in each category.

<PropertiesTable
  :properties="[
    {
      name: 'peripheralID',
      type: 'string',
      default: 'nil',
      description: 'Peripheral ID of the Bin'
    },
		{
			name: 'categories',
			type: 'string[] | &quot;*&quot;',
			default: '{ &quot;basic&quot; }'
		}
  ]"
>
<template v-slot:categories>

List of metric categories to query. The value `"*"` can be used to include all categories, which are listed below.

```lua
{ "basic" }
```
</template>
</PropertiesTable>

## Usage

```lua{4}
local telem = require 'telem'

local backplane = telem.backplane()
  :addInput('my_bin', telem.input.mekanism.bin('right', '*'))
  :cycleEvery(5)()
```

Given a Bin peripheral on the `right` side of the computer, this appends the following metrics to the backplane (grouped by category here for clarity):

### Basic

<MetricTable
  prefix="mekbin:"
  :metrics="[
    { name: 'stored',   value: '0 - inf', unit: 'item' },
    { name: 'capacity', value: '0 - inf', unit: 'item' }
  ]"
/>

## Storage
If the bin contains items, a storage metric is added for the item. Given a bin with the following contents:

![Mekanism Basic Bin with contents](/assets/mekanism-bin.png)

The following metric would be added:

<MetricTable
  prefix="storage:"
  :metrics="[
    { name: 'minecraft:lime_concrete_powder', value: '71', unit: 'item' }
  ]"
/>