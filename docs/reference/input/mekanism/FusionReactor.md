---
telem:
  adapter:
    id: 'fusionReactor'
    name: 'Fusion Reactor'
    categories: '{ "basic", "coolant", "fuel", "formation" }'
    requiresMekGen: true
---

<script setup>
  import { data as metrics } from './common/metrics.data.ts'
</script>

# Mekanism Fusion Reactor Input <RepoLink path="lib/input/mekanism/FusionReactorInputAdapter.lua" />

<!--@include: ./common/preamble.md -->

### Basic

<MetricTable
  prefix="mekfusion:"
  :metrics="[
    { name: 'plasma_temperature',           value: '0.0 - inf', unit: 'K'     },
    { name: 'case_temperature',             value: '0.0 - inf', unit: 'K'     },
    { name: 'water_filled_percentage',      value: '0.0 - 1.0'                },
    { name: 'steam_filled_percentage',      value: '0.0 - 1.0'                },
    { name: 'tritium_filled_percentage',    value: '0.0 - 1.0'                },
    { name: 'deuterium_filled_percentage',  value: '0.0 - 1.0'                },
    { name: 'dt_fuel_filled_percentage',    value: '0.0 - 1.0'                },
    {
      name: 'production_rate',              value: '0.0 - inf', unit: 'FE/t',
      badge: { type: 'warning', text: 'Mekanism 10.3+' },
    },
    { name: 'injection_rate',               value: '0.0 - inf', unit: 'B/t'   },
    { name: 'min_injection_rate',           value: '0.0 - inf', unit: 'B/t'   },
    { name: 'max_plasma_temperature',       value: '0.0 - inf', unit: 'K'     },
    { name: 'max_casing_temperature',       value: '0.0 - inf', unit: 'K'     },
    { name: 'passive_generation_rate',      value: '0.0 - inf', unit: 'FE/t'  },
    { name: 'ignition_temperature',         value: '0.0 - inf', unit: 'K'     }
  ]"
/>

### Coolant

<MetricTable
  prefix="mekfusion:"
  :metrics="[
    { name: 'water',          value: '0.0 - inf', unit: 'B' },
    { name: 'water_capacity', value: '0.0 - inf', unit: 'B' },
    { name: 'water_needed',   value: '0.0 - inf', unit: 'B' },
    { name: 'steam',          value: '0.0 - inf', unit: 'B' },
    { name: 'steam_capacity', value: '0.0 - inf', unit: 'B' },
    { name: 'steam_needed',   value: '0.0 - inf', unit: 'B' }
  ]"
/>

### Fuel

<MetricTable
  prefix="mekfusion:"
  :metrics="[
    { name: 'tritium',            value: '0.0 - inf', unit: 'B' },
    { name: 'tritium_capacity',   value: '0.0 - inf', unit: 'B' },
    { name: 'tritium_needed',     value: '0.0 - inf', unit: 'B' },
    { name: 'deuterium',          value: '0.0 - inf', unit: 'B' },
    { name: 'deuterium_capacity', value: '0.0 - inf', unit: 'B' },
    { name: 'deuterium_needed',   value: '0.0 - inf', unit: 'B' },
    { name: 'dt_fuel',            value: '0.0 - inf', unit: 'B' },
    { name: 'dt_fuel_capacity',   value: '0.0 - inf', unit: 'B' },
    { name: 'dt_fuel_needed',     value: '0.0 - inf', unit: 'B' }
  ]"
/>

### Formation

<MetricTable
  prefix="mekfusion:"
  :metrics="[
    ...metrics.multiblock.formation,
    {
      name: 'active_cooled_logic',
      value: '0 or 1'
    }
  ]"
/>

## Known Issues
Due to a bug in the mod, versions of Mekanism older than 10.3.3 will return incorrect `getProductionRate` values for fusion reactors, causing the `mekfusion:production_rate` metric to be identical to the maximum theoretical production rate.