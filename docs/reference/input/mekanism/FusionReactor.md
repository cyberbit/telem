# Mekanism Fusion Reactor Input <RepoLink path="lib/input/mekanism/FusionReactorInputAdapter.lua" />

```lua
telem.input.mekanism.fusionReactor (
	peripheralID: string,
	categories?: string[] | '*'
)
```

::: warning Mod Dependencies
Requires **Mekanism** and **Mekanism Generators**.
:::

This adapter produces a metric for most of the available information from a Fusion Reactor Logic Adapter. By default, the metrics are limited to an opinionated basic list, but this can be expanded with the `categories` parameter at initialization. The default `basic` category provides all the information needed to monitor any implemented safety measures for fusion reactors.

See the Usage section for a complete list of the metrics in each category.

<PropertiesTable
  :properties="[
    {
      name: 'peripheralID',
      type: 'string',
      default: 'nil',
      description: 'Peripheral ID of the Fusion Reactor Logic Adapter'
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
{ "basic", "coolant", "fuel", "formation" }
```
</template>
</PropertiesTable>

## Usage

```lua{4}
local telem = require 'telem'

local backplane = telem.backplane()
	:addInput('my_fusion', telem.input.mekanism.fusionReactor('right', '*'))
  :cycleEvery(5)()
```

Given a Fusion Reactor Logic Adapter peripheral on the `right` side of the computer, this appends the following metrics to the backplane (grouped by category here for clarity):

### Basic

<MetricTable
  :metrics="[
    {
      name: 'mekfusion:plasma_temperature',
      value: '0.0 - inf',
      unit: 'K'
    },
    {
      name: 'mekfusion:case_temperature',
      value: '0.0 - inf',
      unit: 'K'
    },
    {
      name: 'mekfusion:water_filled_percentage',
      value: '0.0 - 1.0'
    },
    {
      name: 'mekfusion:steam_filled_percentage',
      value: '0.0 - 1.0'
    },
    {
      name: 'mekfusion:tritium_filled_percentage',
      value: '0.0 - 1.0'
    },
    {
      name: 'mekfusion:deuterium_filled_percentage',
      value: '0.0 - 1.0'
    },
    {
      name: 'mekfusion:dt_fuel_filled_percentage',
      value: '0.0 - 1.0'
    },
    {
      name: 'mekfusion:production_rate',
      value: '0.0 - inf',
      unit: 'FE/t'
    },
    {
      name: 'mekfusion:injection_rate',
      value: '0.0 - inf',
      unit: 'B/t'
    },
    {
      name: 'mekfusion:min_injection_rate',
      value: '0.0 - inf',
      unit: 'B/t'
    },
    {
      name: 'mekfusion:max_plasma_temperature',
      value: '0.0 - inf',
      unit: 'K'
    },
    {
      name: 'mekfusion:max_casing_temperature',
      value: '0.0 - inf',
      unit: 'K'
    },
    {
      name: 'mekfusion:passive_generation_rate',
      value: '0.0 - inf',
      unit: 'FE/t'
    },
    {
      name: 'mekfusion:ignition_temperature',
      value: '0.0 - inf',
      unit: 'K'
    }
  ]"
/>

### Coolant

<MetricTable
  :metrics="[
    {
      name: 'mekfusion:water_capacity',
      value: '0 - inf',
      unit: 'B'
    },
    {
      name: 'mekfusion:water_needed',
      value: '0.0 - inf',
      unit: 'B'
    },
    {
      name: 'mekfusion:steam_capacity',
      value: '0 - inf',
      unit: 'B'
    },
    {
      name: 'mekfusion:steam_needed',
      value: '0.0 - inf',
      unit: 'B'
    }
  ]"
/>

### Fuel

<MetricTable
  :metrics="[
    {
      name: 'mekfusion:tritium_capacity',
      value: '0 - inf',
      unit: 'B'
    },
    {
      name: 'mekfusion:tritium_needed',
      value: '0.0 - inf',
      unit: 'B'
    },
    {
      name: 'mekfusion:deuterium_capacity',
      value: '0 - inf',
      unit: 'B'
    },
    {
      name: 'mekfusion:deuterium_needed',
      value: '0.0 - inf',
      unit: 'B'
    },
    {
      name: 'mekfusion:dt_fuel_capacity',
      value: '0 - inf',
      unit: 'B'
    },
    {
      name: 'mekfusion:dt_fuel_needed',
      value: '0.0 - inf',
      unit: 'B'
    }
  ]"
/>

### Formation

<MetricTable
  :metrics="[
    {
      name: 'mekfusion:formed',
      value: '0 or 1'
    },
    {
      name: 'mekfusion:height',
      value: '0 - inf',
      unit: 'm'
    },
    {
      name: 'mekfusion:length',
      value: '0 - inf',
      unit: 'm'
    },
    {
      name: 'mekfusion:width',
      value: '0 - inf',
      unit: 'm'
    },
    {
      name: 'mekfusion:active_cooled_logic',
      value: '0 or 1'
    }
  ]"
/>

## Known Issues
Due to a bug in the mod, versions of Mekanism older than 10.3.3 will return incorrect `getProductionRate` values for fusion reactors, causing the `mekfusion:production_rate` metric to be identical to the maximum theoretical production rate.