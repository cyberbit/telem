---
outline: deep
---

# Getting Started

## Install

This runs the installer. You can choose between a minified release (two smallest files), a packaged release (two readable files), or a full source release (many readable files).

```bash
wget run https://pinestore.cc/d/14
```

Resources will be installed to a `telem` folder in the current directory. A simple `require()` will load the library.

```lua
local telem = require 'telem'
```

## Concepts

### Metric

The fundamental element of Telem is a <span class="mention">[Metric](reference/Metric)</span>, which is just a scalar (numeric) value with some properties attached to it.

**Metric values MUST be scalar. Strings are not permitted.** The reason for this is simple; [telemetry](https://en.wikipedia.org/wiki/Telemetry) means "remote measurement," and a string (name, etc.) is not a "measurement" of anything.

Metrics also support a variety of labels which are exposed as string properties:

- name: **Required.** The primary label used to reference the metric.
- adapter: The name of the adapter producing the metric. This is applied automatically for all input adapters.
- source: The name of the component the adapter queried to produce the metric.
- unit: A string describing the kind of value being measured.

### MetricCollection

A [MetricCollection](reference/MetricCollection)  is a list of Metric elements, with some special properties attached. Luckily, those special properties are currently unused, so for the moment it’s just a list of Metric elements!

### Adapters

There are two types of adapters: [InputAdapter](reference/InputAdapter) and [OutputAdapter](reference/OutputAdapter). The base classes themselves are abstract classes and cannot be instantiated. Instead, there are several implementations of these adapters targeting generic resource providers and machinery from supported mods.

Explore the pages in the **Input** and **Output** sections to learn more about the specific adapters.

### Backplane

The [Backplane](reference/Backplane) is the main API interface of Telem. Any configured adapters will be attached here and read/written when a cycle is requested.

You can learn more about Backplane by visiting the Backplane API listing.

### Middleware

[Middleware](reference/Middleware) is a powerful feature of Telem that allows you to transform metrics in a variety of ways. You can calculate deltas, rates, and averages of existing metrics, or craft your own using custom middleware.

Take a look at the pages in the Middleware section to learn more.

## Hello World

To familiarize yourself with the syntax, create the following program:

```lua
local telem = require 'telem'

-- setup the backplane
local backplane = telem.backplane()

-- Hello World input will always output a single metric with a specified value
local hello_in = telem.input.helloWorld(123)

-- Hello World output will print a line with each metric's name and value
local hello_out = telem.output.helloWorld()

-- add input and output with names
backplane:addInput('hello_in', hello_in)
backplane:addOutput('hello_out', telem.output.helloWorld())

-- read all inputs and write all outputs, then wait 3 seconds, repeating indefinitely
parallel.waitForAny(
	backplane:cycleEvery(3)
)
```

For a dedicated telemetric computer reading a storage interface, this is sufficient:

```lua
local telem = require 'telem'

-- chain methods together for more compact and readable code
local backplane = telem.backplane()
  :addInput('storage', telem.input.itemStorage('right'))
  :addOutput('hello', telem.output.helloWorld())

parallel.waitForAny(
	backplane:cycleEvery(3)
)
```

If you need to run other tasks on the computer, replace the parallel call with the following:

```lua
parallel.waitForAny(
  function ()
    while true do
      -- listen for events, control your reactor, etc.
      
      -- yield somewhere in your loop or the backplane will not cycle correctly
      sleep()
    end
  end,

  -- cycleEvery() may return multiple functions, so ensure it
  -- is the last argument to waitForAny!
  backplane:cycleEvery(3),
)
```