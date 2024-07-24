# Mekanism Chemical Tank Input <RepoLink path="lib/input/mekanism/ChemicalTankInputAdapter.lua" />

```lua
telem.input.mekanism.chemicalTank (
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
      description: 'Peripheral ID of the Chemical Tank'
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
{ "basic", "advanced", "storage" }
```
</template>
</PropertiesTable>

## Usage

```lua{4}
local telem = require 'telem'

local backplane = telem.backplane()
  :addInput('my_chemtank', telem.input.mekanism.chemicalTank('right', '*'))
  :cycleEvery(5)()
```

Given a Chemical Tank peripheral on the `right` side of the computer, this appends the following metrics to the backplane (grouped by category here for clarity):

### Basic

<MetricTable
  prefix="mekchemtank:"
  :metrics="[
    { name: 'fill_item_count',    value: '0 - inf',   unit: 'item'  },
    { name: 'filled_percentage',  value: '0.0 - 1.0'                },
    { name: 'drain_item_count',   value: '0 - inf',   unit: 'item'  }
  ]"
/>

### Advanced

```lua
DUMPING_MODES = { IDLE = 1, DUMPING_EXCESS = 2, DUMPING = 3 }
```

<MetricTable
  prefix="mekchemtank:"
  :metrics="[
    { name: 'dumping_mode', value: 'DUMPING_MODES value' }
  ]"
/>

### Storage

<MetricTable
  prefix="mekchemtank:"
  :metrics="[
    { name: 'stored',   value: '0.0 - inf', unit: 'B' },
    { name: 'capacity', value: '0.0 - inf', unit: 'B' },
    { name: 'needed',   value: '0.0 - inf', unit: 'B' }
  ]"
/>

## Storage
If the tank contains a chemical, a storage metric is added for the chemical. Given a chemical tank with the following contents:

![Mekanism Basic Chemical Tank with contents](/assets/mekanism-chem-tank.webp)

The following metric would be added:

<MetricTable
  prefix="storage:"
  :metrics="[
    { name: 'mekanism:ethene', value: '47', unit: 'B' }
  ]"
/>