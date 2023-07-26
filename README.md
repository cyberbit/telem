# Telem - Trivial Extract and Load Engine for Minecraft

[![Build](https://github.com/cyberbit/telem/actions/workflows/build.yml/badge.svg)](https://github.com/cyberbit/telem/actions/workflows/build.yml)

## Install
```
wget https://get.telem.cc telem.lua
```

## Usage
```lua
local telem = require 'telem'

local backplane = telem.backplane()                  -- setup the fluent interface
  :addInput('hello_in', telem.input.helloWorld(123)) -- add a named input
  :addOutput('hello_out', telem.output.helloWorld()) -- add a named output

-- call a function that reads all inputs and writes all outputs, then waits 3 seconds, repeating indefinitely
backplane:cycleEvery(3)()

-- alternative threadable option
parallel.waitForAny(
  backplane:cycleEvery(3),
  
  function ()
    while true do
      -- listen for events, control your reactor, etc.
      
      -- make sure to yield somewhere in your loop or the backplane will not cycle correctly
      sleep()
    end
  end)
```

## Input Adapters
```lua
-- generic storage adapters
telem.input.itemStorage(peripheral_id)
telem.input.fluidStorage(peripheral_id)

-- Advanced Peripherals
telem.input.refinedStorage(RS_Bridge_peripheral_id)
telem.input.meStorage(ME_Bridge_peripheral_id)

-- Mekanism
telem.input.mekanism.fissionReactor(logic_adapter_peripheral_id)
telem.input.mekanism.inductionMatrix(port_peripheral_id)
telem.input.mekanism.industrialTurbine(valve_peripheral_id)

-- more to come!
```

## Output Adapters
You will need to set up a free account on Grafana Cloud to use the Grafana output. The methodology utilizes [InfluxDB's line protocol](https://grafana.com/docs/grafana-cloud/data-configuration/metrics/metrics-influxdb/push-from-telegraf/).
```lua
-- hello world
telem.output.helloWorld()

-- Grafana (via InfluxDB)
telem.output.grafana(endpoint, apiKey)

-- more to come!
```
