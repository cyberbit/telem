---
telem:
  adapter:
    id: 'wasteBarrel'
    name: 'Radioactive Waste Barrel'
    categories: '{ "basic", "storage" }'
---

<script setup>
  import { data as metrics } from './common/metrics.data.ts'
</script>

# Mekanism Radioactive Waste Barrel Input <RepoLink path="lib/input/mekanism/RadioactiveWasteBarrelInputAdapter.lua" />

<!--@include: ./common/preamble.md -->

### Basic

<MetricTable
  prefix="mekwastebarrel:"
  :metrics="[
    { name: 'filled_percentage',  value: '0.0 - 1.0' }
  ]"
/>

### Storage

<MetricTable
  prefix="mekwastebarrel:"
  :metrics="[
    { name: 'stored',   value: '0.0 - inf', unit: 'B' },
    { name: 'capacity', value: '0.0 - inf', unit: 'B' },
    { name: 'needed',   value: '0.0 - inf', unit: 'B' }
  ]"
/>

## Storage
If the barrel contains a chemical, a storage metric is added for the chemical. Given a waste barrel with the following contents:

![Mekanism Radioactive Waste Barrel with contents](/assets/mekanism-waste-barrel-contents.webp)

The following metric would be added:

<MetricTable
  prefix="storage:"
  :metrics="[
    { name: 'mekanism:spent_nuclear_waste', value: '491.92', unit: 'B' }
  ]"
/>