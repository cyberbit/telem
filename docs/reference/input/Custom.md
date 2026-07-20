---
outline: deep
---

# Custom Input <RepoLink path="lib/input/CustomInputAdapter.lua" />

```lua
telem.input.custom (func: fun(): { [string]: number })
telem.input.custom (func: fun(): Metric, Metric?, ...)
```

::: tip
Since `v0.10.0`, using this adapter through `telem.input.custom` is not required. Passing a function to the `addInput` method of a [Backplane](/reference/Backplane) instance will automatically wrap it with this adapter.
:::

This adapter wraps a user-provided function for custom input implementations. Need to read a specific file? Query a network of mining turtles? Generate random numbers? Anything is possible!

## Usage

Internally, the provided function is wrapped in a [MetricCollection](/reference/MetricCollection) constructor, so anything that works with a MetricCollection constructor should work as a return value.

```lua{5-21}
local telem = require 'telem'

local backplane = telem.backplane()
  -- v0.10.0 and newer
  :addInput('custom_short', function ()
    return {
      custom_short_1 = 929,
      custom_short_2 = 424.2
    }
  end)
  :addInput('custom_long', function ()
    return
      telem.metric('custom_long_1', 456),
      telem.metric('custom_long_2', 503.123),
      telem.metric({
        name = 'custom_long_detail',
        value = math.random(),
        unit = 'randoms',
        source = 'lua:math.random'
      })
  end)

  -- v0.9.x and older
  :addInput('custom_short_old', telem.input.custom(function ()
    return {
      custom_short_1 = 929,
      custom_short_2 = 424.2
    }
  end))
  :cycleEvery(1)()
```

This appends the following metrics to the backplane:

<MetricTable
  show-heritage
  :metrics="[
    {
      name: 'custom_short_1',
      value: 929,
      adapter: 'custom_short'
    },
    {
      name: 'custom_short_2',
      value: 424.2,
      adapter: 'custom_short'
    },
    {
      name: 'custom_long_1',
      value: 456,
      adapter: 'custom_long'
    },
    {
      name: 'custom_long_2',
      value: 503.123,
      adapter: 'custom_long'
    },
    {
      name: 'custom_long_detail',
      value: 0.41373943296609,
      unit: 'randoms',
      adapter: 'custom_long',
      source: 'lua:math.random'
    }
  ]"
/>