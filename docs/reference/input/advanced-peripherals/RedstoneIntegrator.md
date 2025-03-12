# Advanced Peripherals Redstone Integrator Input <RepoLink path="lib/input/advancedPeripherals/RedstoneIntegratorInputAdapter.lua" />

```lua
telem.input.advancedPeripherals.redstoneIntegrator (
  peripheralID: string,
  categories?: string[] | '*',
  sides?: string[] | '*'
)
```

::: warning Mod Dependencies
Requires **Advanced Peripherals**.
:::

See the Usage section for a complete list of the metrics in each category.

<PropertiesTable
  :properties="[
    {
      name: 'peripheralID',
      type: 'string',
      default: 'nil',
      description: 'Peripheral ID of the Redstone Integrator'
    },
    {
      name: 'categories',
      type: 'string[] | &quot;*&quot;',
      default: '{ &quot;basic&quot; }'
    },
    {
      name: 'sides',
      type: 'string[] | &quot;*&quot;',
      default: '&quot;*&quot;'
    }
  ]"
>
<template v-slot:categories>

List of metric categories to query. The value `"*"` can be used to include all categories, which are listed below.

```lua
{ "basic" }
```
</template>
<template v-slot:sides>

List of sides to query. Can be relative (`left`, `right`, etc.) or cardinal (`north`, `south`, etc.). The default value `"*"` can be used to include all relative sides.
</template>
</PropertiesTable>

## Usage

```lua{4-7}
local telem = require 'telem'

local backplane = telem.backplane()
  :addInput(
    'my_redstoneIntegrator',
    telem.input.advancedPeripherals.redstoneIntegrator('right', '*', '*')
  )
  :cycleEvery(5)()
```

Given a Redstone Integrator peripheral on the `right` side of the computer, this appends the following metrics to the backplane (grouped by category here for clarity):

### Basic

<MetricTable
  prefix="apredstone:"
  :metrics="[
    {
      name: 'input_N',        value: '0 or 1',
      badge: { type: 'tip', text: 'Indexed per side' }
    },
    {
      name: 'input_analog_N', value: '0 - 15',
      badge: { type: 'tip', text: 'Indexed per side' }
    }
  ]"
/>
