---
outline: deep
---

# Basalt Graph Output <Badge type="warning" text="beta" /> <RepoLink path="lib/output/basalt/GraphOutputAdapter.lua" />

```lua
telem.output.basalt.graph (
  frame: Basalt.Container,
  filter: string,
  bg: color,
  fg: color,
  maxEntries: number
)
```

::: warning Peer Dependencies
Requires **[Basalt 1.7+](https://basalt.madefor.cc/)**. This is **not** included in the installer's dependencies due to size.
:::

Search the available metrics using the syntax defined in [`find`](/reference/MetricCollection#find) and output a graph to a specified [Basalt container](https://basalt.madefor.cc/#/objects/Container). If a matching metric is found, the metric value is pushed to the graph buffer.

The X axis (horizontal value) represents the number of data points recorded, and has a default width of `50`, which can be overridden by passing `maxEntries` in the constructor. The Y axis (vertical) represents the value of the metric over time. Once the fixed width of the graph is reached, the oldest values will be dropped from the buffer when new values are added. The minimum and maximum range of the Y axis is determined by the minimum and maximum metric values in the graph buffer. The background of the widget and all labels will be `bg`, and the graph/text color will be `fg`.

The value label is designed to shorten itself using SI suffixes to fit within the available width.

<PropertiesTable
  :properties="[
    {
      name: 'frame',
      type: 'Basalt.Container',
      default: 'nil',
      description: 'Container to draw in. While any Container subtype should work, specify a Frame, BaseFrame, MonitorFrame, or Flexbox for best results.'
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
      name: 'maxEntries',
      type: 'number',
      default: '50',
      description: 'Maximum entries in the graph buffer'
    }
  ]"
/>

## Usage

```lua{15}
local telem = require 'telem'
local basalt = require 'basalt'

-- increase monitor resolution
peripheral.call('top', 'setTextScale', 0.5)

local monitor = basalt.addMonitor():setMonitor('top')

local backplane = telem.backplane()
  :addInput('custom_rand', telem.input.custom(function ()
    return {
      rand = math.random() * 10000000
    }
  end))
  :addOutput('monitor_rand1', telem.output.basalt.graph(monitor, 'rand', colors.green, colors.white))

-- you could use a Basalt thread to run the backplane as well
parallel.waitForAny(
  basalt.autoUpdate,
  
  -- include cycleEvery last!
  backplane:cycleEvery(0.1)
)
```

## Behavior

### MonitorFrame (3x2 Advanced Monitor)

![Basalt Graph output to Monitor Frame](/assets/basalt-graph.webp)