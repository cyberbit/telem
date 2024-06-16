---
outline: deep
---

# Area Chart Output <Badge type="warning" text="beta" /> <RepoLink path="lib/output/plotter/ChartAreaOutputAdapter.lua" />

```lua
telem.output.plotter.area (
  win: window,
  filter: string,
  bg: color,
  fg: color,
  baseline: number,
  maxEntries: number
)
```

::: tip
This adapter is [cacheable](/reference/Backplane#cache).
:::

Search the available metrics using the syntax defined in [`find`](/reference/MetricCollection#find) and output an area chart to a specified window. If a matching metric is found, the metric value is pushed to the chart buffer.

The X axis (horizontal value) represents the number of data points recorded, and has a default width of `50`, which can be overridden by passing `maxEntries` in the constructor. The Y axis (vertical) represents the value of the metric over time. Once the fixed width of the graph is reached, the oldest values will be dropped from the buffer when new values are added. The minimum and maximum range of the Y axis is determined by the minimum and maximum metric values in the graph buffer. The background of the widget and all labels will be `bg`, and the graph/text color will be `fg`.

The `baseline` parameter sets the Y value at which the area will be bounded, and defaults to `0`. Values between the baseline and the metric value will be filled with the `fg` color.

The minimum and maximum labels are designed to shorten themselves using SI suffixes to fit within the available width.

<PropertiesTable
  :properties="[
    {
      name: 'win',
      type: 'window instance',
      default: 'nil',
      description: 'Window to draw in. Any window-compatible object should work; however, you will need to wrap term.current() and monitor peripherals using window.create() for them to work properly.'
    },
    {
      name: 'filter',
      type: 'string',
      default: 'nil',
      description: 'Filter to match against Metric elements'
    },
    {
      name: 'bg',
      type: 'color',
      default: 'nil',
      description: 'Background color (colors.*)'
    },
    {
      name: 'fg',
      type: 'color',
      default: 'nil',
      description: 'Foreground color (colors.*)'
    },
    {
      name: 'baseline',
      type: 'number',
      default: '0',
      description: 'Baseline value for the area chart'
    },
    {
      name: 'maxEntries',
      type: 'number',
      default: '50',
      description: 'Maximum entries in the chart buffer'
    }
  ]"
>
<template v-slot:win>

Window to draw in. Any window-compatible object should work; however, you will need to wrap `term.current()` and monitor peripherals using `window.create()` for them to work properly.
</template>
<template v-slot:bg>

Background color, one of `colors.*`
</template>
<template v-slot:fg>

Foreground color, one of `colors.*`
</template>
</PropertiesTable>

## Usage

```lua{18}
local telem = require 'telem'

local mon = peripheral.wrap('top')
mon.setTextScale(0.5)
local monw, monh = mon.getSize()
local win = window.create(mon, 1, 1, monw, monh)

local step = 1

local backplane = telem.backplane()
  :addInput('custom_rand', telem.input.custom(function ()
    step = step + 1

    return {
      rand = math.sin(2 * math.pi * (step / 50))
    }
  end))
  :addOutput('monitor_rand1', telem.output.plotter.area(win, 'rand', colors.black, colors.red, 0))

parallel.waitForAny(
  backplane:cycleEvery(0.1)
)
```

## Behavior

![Plotter Area Chart output](/assets/plotter-chartarea.webp)