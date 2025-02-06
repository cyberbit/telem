---
telem:
  adapter:
    id: 'seismicVibrator'
    name: 'Seismic Vibrator'
    categories: '{ "basic", "energy" }'
---

# Mekanism Seismic Vibrator Input <RepoLink path="lib/input/mekanism/SeismicVibratorInputAdapter.lua" />

<!--@include: ./common/preamble.md -->

### Basic

<MetricTable
  prefix="mekseismic:"
  :metrics="[
    { name: 'energy_filled_percentage', value: '0.0 - 1.0' }
  ]"
/>

### Energy

<MetricTable
  prefix="mekseismic:"
  :metrics="[
    { name: 'energy',         value: '0.0 - inf', unit: 'FE' },
    { name: 'max_energy',     value: '0.0 - inf', unit: 'FE' },
    { name: 'energy_needed',  value: '0.0 - inf', unit: 'FE' }
  ]"
/>

## Storage <Badge text="Mekanism 10.3+" type="warning" />
If an active Seismic Vibrator is in a chunk containing non-air blocks, a storage metric is added for each block ID scanned (including the Seismic Vibrator), ignoring air.

Given a chunk with 1 layer of dirt, 2 layers of stone, and 1 layer of bedrock, the following metrics would be added:

<MetricTable
  prefix="storage:"
  :metrics="[
    { name: 'mekanism:seismic_vibrator', value: '1', unit: 'item' },
    { name: 'minecraft:dirt', value: '256', unit: 'item' },
    { name: 'minecraft:stone', value: '512', unit: 'item' },
    { name: 'minecraft:bedrock', value: '256', unit: 'item' }
  ]"
/>