return {
    helloWorld = require 'telem.lib.input.HelloWorldInputAdapter',

    -- storage
    itemStorage = require 'telem.lib.input.ItemStorageInputAdapter',
    fluidStorage = require 'telem.lib.input.FluidStorageInputAdapter',
    refinedStorage = require 'telem.lib.input.RefinedStorageInputAdapter',
    meStorage = require 'telem.lib.input.MEStorageInputAdapter',

    mekanism = {
        fissionReactor = require 'telem.lib.input.mekanism.FissionReactorInputAdapter',
        inductionMatrix = require 'telem.lib.input.mekanism.InductionMatrixInputAdapter',
        industrialTurbine = require 'telem.lib.input.mekanism.IndustrialTurbineInputAdapter',
    }
}