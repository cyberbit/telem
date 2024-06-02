---
outline: deep
---

# Backplane <Badge type="info" text="API" /> <RepoLink path="lib/Backplane.lua" />

Backplane is the primary interface of Telem. Its job is to read all assigned [InputAdapter](InputAdapter) objects, merge the returned [MetricCollection](MetricCollection) values together, perform any necessary post-processing, and write the merged collection to all assigned [OutputAdapter](OutputAdapter) objects. This process is called a **cycle**, and there are methods available to run cycles on a schedule.

## Properties

::: warning
All properties are set by Backplane and should not be mutated outside of this class.
:::

<PropertiesTable
  :properties="[
    {
      name: 'debugState',
      type: 'boolean',
      default: 'false',
      description: 'Internal debug state.',
      setBy: true
    },
    {
      name: 'inputs',
      type: '{ [string]: InputAdapter }',
      default: '{}',
      description: 'Dictionary of assigned inputs.',
      setBy: true
    },
    {
      name: 'outputs',
      type: '{ [string]: OutputAdapter }',
      default: '{}',
      description: 'Dictionary of assigned outputs.',
      setBy: true
    },
    {
      name: 'inputKeys',
      type: 'string[]',
      default: '[]',
      description: 'List of InputAdapter names in processing order.',
      setBy: true
    },
    {
      name: 'outputKeys',
      type: 'string[]',
      default: '[]',
      description: 'List of OutputAdapter names in processing order.',
      setBy: true
    },
    {
      name: 'collection',
      type: 'MetricCollection',
      default: 'MetricCollection()',
      description: 'Output collection from last cycle.',
      setBy: true
    },
    {
      name: 'asyncCycleHandlers',
      type: 'fun()[]',
      default: '{}',
      description: 'List of async cycle handlers.',
      setBy: true
    }
  ]"
/>

## Methods

### `Backplane`

```lua
Backplane ()
```

Create a new Backplane.

### `addInput`

```lua
Backplane:addInput (name: string, input: InputAdapter): self
```

Assigns an [InputAdapter](InputAdapter) with the specified name to this Backplane. The input name will be used as an adapter label on each [Metric](Metric) during a cycle.

::: warning
It is recommended to have unique input names. While not strictly prohibited, behavior of `cycle()` with duplicate input names is undefined. This will be enforced in a future update.
:::

### `addOutput`

```lua
Backplane:addOutput (name: string, output: OutputAdapter): self
```

Assigns an [OutputAdapter](OutputAdapter) with the specified name to this Backplane. If the adapter has set an async cycle handler, the handler will also be registered in this Backplane.

### `addAsyncCycleHandler`

```lua
Backplane:addAsyncCycleHandler (adapter: string, handler: fun())
```

Registers an async cycle handler for the specified adapter name.

### `cycle`

```lua
Backplane:cycle (): self
```

At a high level, this function simply reads all the inputs and writes the collections to all the outputs. Below is a more detailed structure of this procedure:

- Initialize a temporary [MetricCollection](MetricCollection) `tempCollection`
- Loop over `self.inputs` in assignment order. For each [InputAdapter](InputAdapter) :
  - Call `input.read()`  in protected mode
  - If call fails, log an input fault to terminal and skip to next input
  - For each [Metric](Metric) in the results, set `metric.adapter` to the name of the input. If `metric.adapter` is already set, prefix with the name of the input plus `:`.
- Sort `tempCollection` alphabetically by ascending metric name
  ::: warning
  This step will eventually be implemented as an optional Middleware step.
  :::
- Set `self.collection` to `tempCollection`
- Loop over `self.outputs` in assignment order. For each [OutputAdapter](OutputAdapter) :
  - Call `output.write(tempCollection)` in protected mode
  - If call fails, log an output fault to terminal and skip to next output
- Return `self`

### `cycleEvery`

```lua
Backplane:cycleEvery (n: number): fun()
```

Returns a function that runs `cycle()`, sleeps for `n` seconds, and repeats. If any async cycle handlers have been registered, they will be individually returned from this function after the cycle scheduler, for example: `return selfCycle, asyncHandler1, asyncHandler2`.

### `updateLayouts`

```lua
Backplane:updateLayouts (): self
```

Trigger eager layout updates on all attached outputs with `updateLayout` functions, such as [ChartLineOutputAdapter](output/ChartLine) and other graphical adapters. Note that "eager" means the outputs will be re-rendered immediately after the layout is updated.

### `debug`

```lua
Backplane:debug (state: boolean)
```

Set internal debug state. When `state` is `true`, Backplane will write verbose information to the terminal during a cycle. When `state` is `false`, Backplane will only write adapter faults to the terminal. Any adapters added *after* calling `debug()` will also have their debug state set to the same value.

## Usage

```lua
local telem = require 'telem'

local backplane = telem.backplane()

backplane:addInput('hello_in', telem.input.helloWorld(123))
backplane:addOutput('hello_out', telem.output.helloWorld())

-- run a single cycle (useful for custom scheduling)
backplane:cycle()

-- run a cycle every 5 seconds forever
parallel.waitForAll(
  backplane:cycleEvery(5),

  function ()
    while true do
      -- reactor.preventMeltdown()
      -- animals.feed()
      -- mission.accomplish()
      
      -- REMEMBER TO YIELD!
      sleep()
    end
  end
)
```