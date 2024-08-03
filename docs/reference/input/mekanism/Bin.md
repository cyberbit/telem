---
telem:
  adapter:
    id: 'bin'
    name: 'Bin'
    categories: '{ "basic" }'
---

# Mekanism Bin Input <RepoLink path="lib/input/mekanism/BinInputAdapter.lua" />

<!--@include: ./common/preamble.md -->

### Basic

<MetricTable
  prefix="mekbin:"
  :metrics="[
    { name: 'stored',   value: '0 - inf', unit: 'item' },
    { name: 'capacity', value: '0 - inf', unit: 'item' }
  ]"
/>

## Storage
If the bin contains items, a storage metric is added for the item. Given a bin with the following contents:

![Mekanism Basic Bin with contents](/assets/mekanism-bin.png)

The following metric would be added:

<MetricTable
  prefix="storage:"
  :metrics="[
    { name: 'minecraft:lime_concrete_powder', value: '71', unit: 'item' }
  ]"
/>