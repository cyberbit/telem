# Mekanism Industrial Turbine Input <RepoLink path="lib/input/mekanism/IndustrialTurbineInputAdapter.lua" />

```lua
telem.input.mekanism.industrialTurbine (
	peripheralID: string,
	categories?: string[] | '*'
)
```

::: warning Mod Dependencies
Requires **Mekanism** and **Mekanism Generators**.
:::

This adapter produces a metric for most of the available information from a Turbine Valve. By default, the metrics are limited to an opinionated basic list, but this can be expanded with the `categories` parameter at initialization. The default `basic` category provides all the information needed to safely monitor the industrial turbine.

See the Usage section for a complete list of the metrics in each category.

<PropertiesTable
  :properties="[
    {
      name: 'peripheralID',
      type: 'string',
      default: 'nil',
      description: 'Peripheral ID of the Turbine Valve'
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
{ "basic", "advanced", "energy", "steam", "formation" }
```
</template>
</PropertiesTable>

## Usage

```lua
-- LUT for mekturbine:dumping_mode metric
local DUMPING_MODES = 

local telem = require 'telem'

local backplane = telem.backplane()
	:addInput('my_turbine', telem.input.mekanism.industrialTurbine('right', '*'))
  :cycleEvery(5)()
```

Given a Turbine Valve peripheral on the `right` side of the computer, this appends the following metrics to the backplane (grouped by category here for clarity):

### Basic

<MetricTable
  all-adapters="my_turbine"
  all-sources="right"
  :metrics="[
    {
      name: 'mekturbine:energy_filled_percentage',
      value: '0.0 - 1.0',
      adapter: 'my_turbine',
      source: 'right'
    },
    {
      name: 'mekturbine:energy_production_rate',
      value: '0.0 - inf',
      unit: 'FE/t',
      adapter: 'my_turbine',
      source: 'right'
    },
    {
      name: 'mekturbine:energy_max_production',
      value: '0.0 - inf',
      unit: 'FE/t',
      adapter: 'my_turbine',
      source: 'right'
    },
    {
      name: 'mekturbine:steam_filled_percentage',
      value: '0.0 - 1.0',
      adapter: 'my_turbine',
      source: 'right'
    }
  ]"
/>

### Advanced

```lua
DUMPING_MODES = { IDLE = 1, DUMPING_EXCESS = 2, DUMPING = 3 }
```

<MetricTable
  all-adapters="my_turbine"
  all-sources="right"
  :metrics="[
    {
      name: 'mekturbine:comparator_level',
      value: '0 - 15',
      adapter: 'my_turbine',
      source: 'right'
    },
    {
      name: 'mekturbine:dumping_mode',
      value: 'DUMPING_MODES value',
      adapter: 'my_turbine',
      source: 'right'
    },
    {
      name: 'mekturbine:flow_rate',
      value: '0.0 - inf',
      unit: 'B/t',
      adapter: 'my_turbine',
      source: 'right'
    },
    {
      name: 'mekturbine:max_flow_rate',
      value: '0.0 - inf',
      unit: 'B/t',
      adapter: 'my_turbine',
      source: 'right'
    }
  ]"
/>

### Energy

<MetricTable
  all-adapters="my_turbine"
  all-sources="right"
  :metrics="[
    {
      name: 'mekturbine:energy',
      value: '0 - inf',
      unit: 'FE',
      adapter: 'my_turbine',
      source: 'right'
    },
    {
      name: 'mekturbine:max_energy',
      value: '0 - inf',
      unit: 'FE',
      adapter: 'my_turbine',
      source: 'right'
    },
    {
      name: 'mekturbine:energy_needed',
      value: '0 - inf',
      unit: 'FE',
      adapter: 'my_turbine',
      source: 'right'
    }
  ]"
/>

### Steam

<MetricTable
  all-adapters="my_turbine"
  all-sources="right"
  :metrics="[
    {
      name: 'mekturbine:steam_input_rate',
      value: '0.0 - inf',
      unit: 'B/t'
    },
    {
      name: 'mekturbine:steam',
      value: '0.0 - inf',
      unit: 'B'
    },
    {
      name: 'mekturbine:steam_capacity',
      value: '0.0 - inf',
      unit: 'B'
    },
    {
      name: 'mekturbine:steam_needed',
      value: '0.0 - inf',
      unit: 'B'
    }
  ]"
/>

### Formation

<MetricTable
  all-adapters="my_turbine"
  all-sources="right"
  :metrics="[
    {
      name: 'mekturbine:formed',
      value: '0 or 1'
    },
    {
      name: 'mekturbine:height',
      value: '0 - inf',
      unit: 'm'
    },
    {
      name: 'mekturbine:length',
      value: '0 - inf',
      unit: 'm'
    },
    {
      name: 'mekturbine:width',
      value: '0 - inf',
      unit: 'm'
    },
    {
      name: 'mekturbine:blades',
      value: '0 - inf'
    },
    {
      name: 'mekturbine:coils',
      value: '0 - inf'
    },
    {
      name: 'mekturbine:condensers',
      value: '0 - inf'
    },
    {
      name: 'mekturbine:dispersers',
      value: '0 - inf'
    },
    {
      name: 'mekturbine:vents',
      value: '0 - inf'
    },
    {
      name: 'mekturbine:max_water_output',
      value: '0.0 - inf',
      unit: 'B/t'
    }
  ]"
/>