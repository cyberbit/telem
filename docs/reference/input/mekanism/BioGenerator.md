---
telem:
  adapter:
    id: 'bioGenerator'
    name: 'Bio Generator'
    categories: '{ "basic", "advanced", "fuel", "energy" }'
    requiresMekGen: true
---

<script setup>
  import { data as metrics } from './common/metrics.data.ts'
</script>

# Mekanism Bio Generator Input <RepoLink path="lib/input/mekanism/BioGeneratorInputAdapter.lua" />

<!--@include: ./common/preamble.md -->

### Basic

<MetricTable
  prefix="mekbiogen:"
  :metrics="[
    ...metrics.genericMachine.basic,
    ...metrics.generator.basic,
    { name: 'bio_fuel_filled_percentage', value: '0.0 - 1.0'  },
    { name: 'bio_fuel_item_count',        value: '0 - inf'    }
  ]"
/>

### Advanced

<MetricTable
  prefix="mekbiogen:"
  :metrics="[
    ...metrics.genericMachine.advanced
  ]"
/>

### Fuel

<MetricTable
  prefix="mekbiogen:"
  :metrics="[
    { name: 'bio_fuel',           value: '0.0 - inf', unit: 'B' },
    { name: 'bio_fuel_capacity',  value: '0.0 - inf', unit: 'B' },
    { name: 'bio_fuel_needed',    value: '0.0 - inf', unit: 'B' }
  ]"
/>

### Energy

<MetricTable
  prefix="mekbiogen:"
  :metrics="[
    ...metrics.genericMachine.energy,
    ...metrics.generator.energy
  ]"
/>