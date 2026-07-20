---
outline: deep
---

# Custom Output <RepoLink path="lib/output/CustomOutputAdapter.lua" />

```lua
telem.output.custom (func: fun(collection: MetricCollection))
```

::: tip
Since `v0.10.0`, using this adapter through `telem.output.custom` is not required. Passing a function to the `addOutput` method of a [Backplane](/reference/Backplane) instance will automatically wrap it with this adapter.
:::

Wraps a user-provided function for custom output implementations. Need to write out metrics to a file? Toggle redstone lamps when a threshold is reached? Update a custom GUI dashboard? Anything is possible!

The provided function is used as a metric consumer. Internally, `func` is called with one argument, `collection`, which is the [MetricCollection](/reference/MetricCollection) created by the [Backplane](/reference/Backplane) during a cycle.

<PropertiesTable
  :properties="[
    {
      name: 'func',
      type: 'fun(collection: MetricCollection)',
      default: 'nil',
      description: 'Function executed when writing to this output adapter'
    }
  ]"
/>

## Usage

```lua{18-22}
local telem = require 'telem'

local backplane = telem.backplane()
  :addInput('hello_in', telem.input.helloWorld(123))
  :addInput('custom_long', telem.input.custom(function ()
    return
      telem.metric('custom_long_1', 456),
      telem.metric('custom_long_2', 503.123),
      telem.metric{
        name = 'custom_long_detail',
        value = math.random(),
        unit = 'randoms',
        source = 'lua:math.random'
      }
  end))

  -- v0.10.0 and newer
  :addOutput('custom_out', function (collection)
    for _,v in pairs(collection.metrics) do
      print('% ', v)
    end
  end)

  -- v0.9.x and older
  :addOutput('custom_out', telem.output.custom(function (collection)
    for _,v in pairs(collection.metrics) do
      print('% ', v)
    end
  end))
  :cycleEvery(1)()
```

## Behavior

The example usage will produce the following output every cycle:

```
%  custom_long_1 = 456 from custom_long
%  custom_long_2 = 503.123 from custom_long
%  custom_long_detail = 0.872219000824 randoms from custom_long (lua:math.random)
%  hello_world = 123 from hello_in
```