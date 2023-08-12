#!/bin/bash

mkdir -p dist
echo 'building...'
luacc telem.init -o dist/telem.lua -i src \
    telem.lib.Backplane \
    telem.lib.Metric \
    telem.lib.util \
    telem.lib.MetricCollection \
    telem.lib.ObjectModel \
    telem.lib.input.MEStorageInputAdapter \
    telem.lib.input.RefinedStorageInputAdapter \
    telem.lib.input \
    telem.lib.input.ItemStorageInputAdapter \
    telem.lib.input.mekanism.FissionReactorInputAdapter \
    telem.lib.input.mekanism.IndustrialTurbineInputAdapter \
    telem.lib.input.mekanism.InductionMatrixInputAdapter \
    telem.lib.input.mekanism.FusionReactorInputAdapter \
    telem.lib.input.FluidStorageInputAdapter \
    telem.lib.input.HelloWorldInputAdapter \
    telem.lib.output.HelloWorldOutputAdapter \
    telem.lib.output \
    telem.lib.output.GrafanaOutputAdapter \
    telem.lib.InputAdapter \
    telem.lib.OutputAdapter

echo 'squishing...'
luamin -f dist/telem.lua > dist/telem.min.lua