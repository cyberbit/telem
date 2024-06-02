---
outline: deep
---

# Basalt Label Output <Badge type="warning" text="beta" /> <RepoLink path="lib/output/basalt/LabelOutputAdapter.lua" />

```lua
telem.output.basalt.label (
  frame: Basalt.Container,
  filter: string,
  bg: color,
  fg: color,
  fontSize?: number
)
```

::: warning Peer Dependencies
Requires **[Basalt 1.7+](https://basalt.madefor.cc/)**. This is **not** included in the installer's dependencies due to size.
:::

Search the available metrics using the syntax defined in [`find`](/reference/MetricCollection#find) and output a label to a specified [Basalt container](https://basalt.madefor.cc/#/objects/Container). If a matching metric is found, the metric name is drawn in the top left of the provided Container, and the value is drawn in the center of the container using the specified font size. The background of the widget and all labels will be `bg`, and the text color will be `fg`.

If the name label overflows the available width, it will auto-scroll to the left after a period of time, looping back around and pausing again. This will repeat indefinitely. The value label is designed to shorten itself using SI suffixes to fit within the available width.

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
      name: 'fontSize',
      type: 'number',
      default: '2',
      description: 'Font size of metric value'
    }
  ]"
/>

## Usage

::: code-group
```lua{12} [MonitorFrame]
local telem = require 'telem'
local basalt = require 'basalt'

local monitor = basalt.addMonitor():setMonitor('top')

local backplane = telem.backplane()
  :addInput('custom_rand', telem.input.custom(function ()
    return {
      rand = math.random() * 10000000
    }
  end))
  :addOutput('monitor_rand1', telem.output.basalt.label(monitor, 'rand', colors.green, colors.white))

-- you could use a Basalt thread to run the backplane as well
parallel.waitForAny(
  basalt.autoUpdate,
  
  -- include cycleEvery last!
  backplane:cycleEvery(1)
)
```
```lua{12} [MonitorFrame long label]
local telem = require 'telem'
local basalt = require 'basalt'

local monitor = basalt.addMonitor():setMonitor('top')

local backplane = telem.backplane()
  :addInput('custom_rand', telem.input.custom(function ()
    return {
      rand_with_very_long_label = math.random() * 10000000
    }
  end))
  :addOutput('monitor_rand2', telem.output.basalt.label(monitor, 'rand_with_very_long_label', colors.red, colors.white))

-- you could use a Basalt thread to run the backplane as well
parallel.waitForAny(
  basalt.autoUpdate,
  
  -- include cycleEvery last!
  backplane:cycleEvery(1)
)
```
:::

## Behavior

### MonitorFrame (2x2 Advanced Monitor)

![Basalt Label output to Monitor Frame with short label](/assets/basalt-label-short.webp)

### MonitorFrame long label (2x2 Advanced Monitor)

![Basalt Label output to Monitor Frame with long label](/assets/basalt-label-long.webp)

## Advanced Examples

### 2x5 grid in a MonitorFrame (5x5 Advanced Monitor)

Metrics in code and screenshot are mismatched but the frame setup should be accurate.
    
```lua
local multiview = basalt.addMonitor()
  :setMonitor('top')
  :setBackground(colors.black)

local mframe4 = multiview:addFrame()
    :setPosition(1,1)
    :setSize('parent.w/2-1', 'parent.h/5-1')

local mframe5 = multiview:addFrame()
    :setPosition('parent.w/2', 1)
    :setSize('parent.w/2', 'parent.h/5-1')

local mframe6 = multiview:addFrame()
    :setPosition(1,'parent.h/5')
    :setSize('parent.w/2-1', 'parent.h/5-1')

local mframe7 = multiview:addFrame()
    :setPosition('parent.w/2','parent.h/5')
    :setSize('parent.w/2', 'parent.h/5-1')

local mframe8 = multiview:addFrame()
    :setPosition(1,'2*parent.h/5')
    :setSize('parent.w/2-1', 'parent.h/5-1')

local mframe9 = multiview:addFrame()
    :setPosition('parent.w/2','2*parent.h/5')
    :setSize('parent.w/2', 'parent.h/5-1')

local mframe10 = multiview:addFrame()
    :setPosition(1,'3*parent.h/5')
    :setSize('parent.w/2-1', 'parent.h/5-1')

local mframe11 = multiview:addFrame()
    :setPosition('parent.w/2','3*parent.h/5')
    :setSize('parent.w/2', 'parent.h/5-1')

local mframe12 = multiview:addFrame()
    :setPosition(1,'4*parent.h/5')
    :setSize('parent.w/2-1', 'parent.h/5-1')

local mframe13 = multiview:addFrame()
    :setPosition('parent.w/2','4*parent.h/5')
    :setSize('parent.w/2', 'parent.h/5-1')

local backplane = telem.backplane()
  -- inputs
  :addInput('custom_rand', telem.input.custom(function ()
    return
      telem.metric('rand', math.random() * 10000000)
  end))

  -- outputs
  :addOutput('basalt_4', telem.output.basalt.label(mframe4, 'rand', colors.black, colors.green))
  :addOutput('basalt_5', telem.output.basalt.label(mframe5, 'rand', colors.black, colors.red))
  :addOutput('basalt_6', telem.output.basalt.label(mframe6, 'rand', colors.black, colors.cyan))
  :addOutput('basalt_7', telem.output.basalt.label(mframe7, 'rand', colors.black, colors.white))
  :addOutput('basalt_8', telem.output.basalt.label(mframe8, 'rand', colors.black, colors.orange))
  :addOutput('basalt_9', telem.output.basalt.label(mframe9, 'rand', colors.black, colors.blue))
  :addOutput('basalt_10', telem.output.basalt.label(mframe10, 'rand', colors.black, colors.pink))
  :addOutput('basalt_11', telem.output.basalt.label(mframe11, 'rand', colors.black, colors.purple))
  :addOutput('basalt_12', telem.output.basalt.label(mframe12, 'rand', colors.black, colors.magenta))
  :addOutput('basalt_13', telem.output.basalt.label(mframe13, 'rand', colors.black, colors.lime))
```

![10x Basalt Label outputs in a grid on a single monitor](/assets/basalt-label-grid.png)