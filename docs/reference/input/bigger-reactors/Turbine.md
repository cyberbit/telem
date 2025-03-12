---
telem:
  adapter:
    id: 'turbine'
    name: 'Turbine'
    categories: '{ "basic", "fluid", "energy" }'
---

<script setup>
  import { data as metrics } from './common/metrics.data.ts'
</script>

# Bigger Reactors Turbine Input <RepoLink path="lib/input/biggerReactors/TurbineInputAdapter.lua" />

<!--@include: ./common/preamble.md -->

### Basic

<MetricTable
  prefix="brturbine:"
  :metrics="[
    { name: 'coil_engaged', value: '0 or 1'                 },
    { name: 'flow_rate',    value: '0.0 - inf', unit: 'B/t' },
    { name: 'input',        value: '0.0 - inf', unit: 'B'   },
    { name: 'output',       value: '0.0 - inf', unit: 'B'   },
    { name: 'rpm',          value: '0.0 - inf', unit: 'RPM' },
    { name: 'efficiency',   value: '0.0 - inf'              },
    ...metrics.genericMachine.basic,
    ...metrics.generator.basic
  ]"
/>

### Fluid

<MetricTable
  prefix="brturbine:"
  :metrics="[
    { name: 'nominal_flow_rate',  value: '0.0 - inf', unit: 'B/t' },
    { name: 'max_flow_rate',      value: '0.0 - inf', unit: 'B/t' },
    { name: 'input_capacity',     value: '0.0 - inf', unit: 'B'   },
    { name: 'output_capacity',    value: '0.0 - inf', unit: 'B'   }
  ]"
/>

### Energy

<MetricTable
  prefix="brturbine:"
  :metrics="[
    ...metrics.generator.energy
  ]"
/>