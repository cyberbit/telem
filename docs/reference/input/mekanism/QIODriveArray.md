---
telem:
  adapter:
    id: 'qioDriveArray'
    name: 'QIO Drive Array'
    categories: '{ "basic", "advanced", "storage" }'
---

# Mekanism QIO Drive Array Input <RepoLink path="lib/input/mekanism/QIODriveArrayInputAdapter.lua" />

<!--@include: ./common/preamble.md -->

### Basic

<MetricTable
  prefix="mekqioarray:"
  :metrics="[
    { name: 'frequency_selected',   value: '0 or 1' },
    { name: 'item_filled_percentage', value: '0.0 - 1.0' },
    { name: 'type_filled_percentage', value: '0.0 - 1.0' }
  ]"
/>

### Advanced

```lua
DRIVE_STATUSES = { READY = 1, NONE = 2, OFFLINE = 3, NEAR_FULL = 4, FULL = 5 }
```

<MetricTable
  prefix="mekqioarray:"
  :metrics="[
    {
      name: 'drive_status_N', value: 'DRIVE_STATUSES value',
      badge: { type: 'tip', text: 'Indexed per drive' }
    }
  ]"
/>

### Storage

<MetricTable
  prefix="mekqioarray:"
  :metrics="[
    { name: 'item_count',     value: '0 - inf', unit: 'item'  },
    { name: 'item_capacity',  value: '0 - inf', unit: 'item'  },
    { name: 'type_count',     value: '0 - inf'                },
    { name: 'type_capacity',  value: '0 - inf'                }
  ]"
/>

## Storage

::: tip Frequency Scope
Due to Mekanism limitations, only the items in the specified drive array peripheral are exposed as metrics. To see the full contents of a frequency, use a separate peripheral/adapter per drive array.
:::

If the drive array contains items in its drives, a storage metric is added for each item. Given a drive array with the following contents (as shown in a QIO Dashboard):

![Mekanism QIO Dashboard with contents](/assets/mekanism-qio-inventory.webp)

The following metrics would be added:

<MetricTable
  prefix="storage:"
  :metrics="[
    { name: 'minecraft:glowstone_dust', value: '48', unit: 'item' },
    { name: 'minecraft:redstone', value: '459', unit: 'item' }
  ]"
/>