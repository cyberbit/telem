---
telem:
  adapter:
    id: 'boiler'
    name: 'Thermoelectric Boiler'
    categories: '{ "basic", "advanced", "water", "steam", "coolant", "formation" }'
---

<script setup>
  import { data as metrics } from './common/metrics.data.ts'
</script>

# Mekanism Thermoelectric Boiler Input <RepoLink path="lib/input/mekanism/ThermoelectricBoilerInputAdapter.lua" />

<!--@include: ./common/preamble.md -->

### Basic

<MetricTable
  prefix="mekboiler:"
  :metrics="[
    { name: 'boil_rate',                        value: '0 - inf', unit: 'B/t' },
    { name: 'max_boil_rate',                    value: '0 - inf', unit: 'B/t' },
    { name: 'temperature',                      value: '0 - inf', unit: 'K'   },
    { name: 'water_filled_percentage',          value: '0.0 - 1.0'            },
    { name: 'steam_filled_percentage',          value: '0.0 - 1.0'            },
    { name: 'cooled_coolant_filled_percentage', value: '0.0 - 1.0'            },
    { name: 'heated_coolant_filled_percentage', value: '0.0 - 1.0'            }
  ]"
/>

### Advanced

<MetricTable
  prefix="mekboiler:"
  :metrics="[
    {
      name: 'environmental_loss', value: '0.0 - inf',
      badge: { type: 'warning', text: 'Mekanism 10.3+' }
    },
  ]"
/>

### Water

<MetricTable
  prefix="mekboiler:"
  :metrics="[
    { name: 'water',          value: '0.0 - inf', unit: 'B' },
    { name: 'water_capacity', value: '0.0 - inf', unit: 'B' },
    { name: 'water_needed',   value: '0.0 - inf', unit: 'B' }
  ]"
/>

### Coolant

<MetricTable
  prefix="mekboiler:"
  :metrics="[
    { name: 'cooled_coolant',           value: '0.0 - inf', unit: 'B' },
    { name: 'cooled_coolant_capacity',  value: '0.0 - inf', unit: 'B' },
    { name: 'cooled_coolant_needed',    value: '0.0 - inf', unit: 'B' },
    { name: 'heated_coolant',           value: '0.0 - inf', unit: 'B' },
    { name: 'heated_coolant_capacity',  value: '0.0 - inf', unit: 'B' },
    { name: 'heated_coolant_needed',    value: '0.0 - inf', unit: 'B' }
  ]"
/>

### Formation

<MetricTable
  prefix="mekboiler:"
  :metrics="[
    ...metrics.multiblock.formation,
    { name: 'boil_capacity',  value: '0.0 - inf', unit: 'B' },
    { name: 'superheaters',   value: '0 - inf'              }
  ]"
/>