# Telem - Trivial Extract and Load Engine for Minecraft

[![Build](https://github.com/cyberbit/telem/actions/workflows/build.yml/badge.svg)](https://github.com/cyberbit/telem/actions/workflows/build.yml)
[![PineStore](https://t.ly/y3cQ1)](https://pinestore.cc/projects/14/telem)

Tired of creating complex logic to monitor inventory or production? Want something more modern, modular, and scalable? Want something that can empower a dashboard like the screenshot below? You have come to the right place.

![image](https://github.com/cyberbit/telem/assets/7350183/22e0862b-a56e-4ec5-ac9d-956c7aa075bb)

## Requirements
- ComputerCraft (Tweaked and Restitched also supported)
- `http` access for installer and certain adapters

> **Note:** These docs are being actively written so please excuse my dust! If you have questions, post them [in this discussion](https://github.com/cyberbit/telem/discussions/12).

## Install
This runs the installer. You have a choice to install minified, packaged, and source versions.
```
wget run https://get.telem.cc
```

## Usage
### Please visit [telem.cc](https://telem.cc) for full documentation.
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
* Hello World (testing)
* Item Storage
* Fluid Storage
* Refined Storage (RS Bridge)
* ME Storage (ME Bridge)
* Mekanism Fission Reactor
* Mekanism Fusion Reactor
* Mekanism Induction Matrix
* Mekanism Industrial Turbine
* Custom Inputs
* **Secure Modems ✨**
* _More to come!_

## Output Adapters
* Hello World (testing)
* Grafana* (Grafana Cloud or self-hosted)
* Basalt labels
* Custom Outputs
* **Secure Modems ✨**
* _More to come!_

*You will need to set up a free account on Grafana Cloud or provision a self-hosted Grafana + InfluxDB + Telegraf instance to use the Grafana output. A more detailed guide for Grafana is planned for the future.

