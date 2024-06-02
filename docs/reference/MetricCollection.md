---
outline: deep
---

# MetricCollection <Badge type="info" text="API" /> <RepoLink path="lib/MetricCollection.lua" />

MetricCollection is a wrapper for a list of [Metric](Metric) elements, with some utility functions attached.

## Properties

<PropertiesTable
  :properties="[
    {
      name: 'metrics',
      type: 'Metric[]',
      default: '{}',
      description: 'List storing the Metric elements.'
    }
  ]"
/>

## Methods

### `MetricCollection`

```lua
MetricCollection ({ [string]: number })
MetricCollection (metric1: Metric, metric2?: Metric, ...)
```

There are two MetricCollection constructor signatures. One requires a table of name-value pairs, and the other requires a list of Metric elements.

 1. **Simple MetricCollection**

    Create a new collection from a provided table, using the table keys as metric names and the values as the metric values. If the use case only requires name and value on [Metric](Metric) elements, this is the most concise way to instantiate a MetricCollection.

    ```lua
    local telem = require 'telem'

    local simpleCollection = telem.metricCollection({
      metric_name = 123,
      other_metric_name = 456.789
    })
    ```

 2. **Detailed MetricCollection**

    Create a new collection from the provided [Metric](Metric) arguments.

    ```lua
    local telem = require 'telem'

    local detailedCollection = telem.metricCollection(
      telem.metric('metric_name', 123),
      telem.metric{ name = 'other_metric_name', value = 456.789 }
    )
    ```

### `insert`

```lua
MetricCollection:insert (element: Metric): MetricCollection
```

Insert a [Metric](Metric) into the collection.


### `find`

```lua
MetricCollection:find (filter: string): Metric | nil
```

Returns the first [Metric](Metric) in this collection (in `pairs()` order) that matches the provided filter. See below for usage examples.

```lua
-- {PROPERTY} represents a property read from the Metric
-- [text] indicates an optional section

'[{name}]@[{adapter}]'
```

## Usage

```lua
local telem = require 'telem'

-- Peripheral setup:
--  * Chest contains 5 Redstone Dust and 1 Oak Log
--  * Refined Storage system contains 2 Redstone Dust
local backplane = telem.backplane()

backplane:addInput('my_chest', telem.input.itemStorage('minecraft:chest'))
backplane:addInput('my_rs', telem.input.refinedStorage('rsBridge_0'))

-- run a cycle to load metrics
backplane:cycle()

-- expected state of backplane.metrics:
local metrics = {
  -- this is metric A
  Metric({
    name = 'storage:minecraft:redstone_dust',
    value = 5,
    adapter = 'my_chest',
    source = 'minecraft:chest',
    unit = 'item',
  }),

  -- this is metric B
  Metric({
    name = 'storage:minecraft:oak_log',
    value = 1,
    adapter = 'my_chest',
    source = 'minecraft:chest',
    unit = 'item',
  }),

  -- this is metric C
  Metric({
    name = 'storage:minecraft:redstone_dust',
    value = 2,
    adapter = 'my_rs',
    source = 'rsBridge_0',
    unit = 'item',
  })
}

------------------
-- Example filters

print(backplane.metrics:find('storage:minecraft:oak_log')) -- returns metric B
print(backplane.metrics:find('@my_chest')) -- returns metric A
print(backplane.metrics:find('storage:minecraft:redstone_dust')) -- returns metric A
print(backplane.metrics:find('storage:minecraft:redstone_dust@my_rs')) -- returns metric C
```