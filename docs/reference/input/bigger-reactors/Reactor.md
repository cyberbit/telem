---
telem:
  adapter:
    id: 'reactor'
    name: 'Reactor'
    categories: '{ "basic", "fuel", "coolant", "energy", "formation" }'
---

<script setup>
  import { data as metrics } from './common/metrics.data.ts'
</script>

# Bigger Reactors Reactor Input <RepoLink path="lib/input/biggerReactors/ReactorInputAdapter.lua" />

<!--@include: ./common/preamble.md -->

### Basic

<MetricTable
  prefix="brreactor:"
  :metrics="[
    { name: 'burn_rate',                value: '0.0 - inf', unit: 'B/t' },
    { name: 'ambient_temperature',      value: '0.0 - inf', unit: 'K'   },
    { name: 'casing_temperature',       value: '0.0 - inf', unit: 'K'   },
    { name: 'fuel_temperature',         value: '0.0 - inf', unit: 'K'   },
    { name: 'fuel_reactivity',          value: '0.0 - inf'              },
    {
      name: 'coolant_transition_rate',  value: '0.0 - inf', unit: 'B/t',
      badge: { type: 'warning', text: 'Active reactor only' }
    },
    ...metrics.genericMachine.basic
  ]"
/>

### Fuel

<MetricTable
  prefix="brreactor:"
  :metrics="[
    { name: 'fuel',           value: '0.0 - inf', unit: 'B' },
    { name: 'fuel_capacity',  value: '0.0 - inf', unit: 'B' },
    { name: 'reactant',       value: '0.0 - inf', unit: 'B' },
    { name: 'waste',          value: '0.0 - inf', unit: 'B' }
  ]"
/>

### Coolant

::: warning Active reactor only
The coolant metrics are only available for active reactors.
:::

<MetricTable
  prefix="brreactor:"
  :metrics="[
    { name: 'coolant_hot',                  value: '0.0 - inf', unit: 'B'   },
    { name: 'coolant_cold',                 value: '0.0 - inf', unit: 'B'   },
    { name: 'coolant_capacity',             value: '0.0 - inf', unit: 'B'   },
    { name: 'coolant_max_transition_rate',  value: '0.0 - inf', unit: 'B/t' }
  ]"
/>

### Energy

::: warning Passive reactor only
The energy metrics are only available for passive reactors.
:::

<MetricTable
  prefix="brreactor:"
  :metrics="[
    ...metrics.generator.energy
  ]"
/>

### Formation

<MetricTable
  prefix="brreactor:"
  :metrics="[
    { name: 'control_rods', value: '0 - inf' }
  ]"
/>