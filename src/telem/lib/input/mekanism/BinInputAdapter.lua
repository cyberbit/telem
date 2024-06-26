local fn = require 'telem.vendor'.fluent.fn

local base      = require 'telem.lib.input.mekanism.BaseMekanismInputAdapter'
local Metric    = require 'telem.lib.Metric'

local BinInputAdapter = base.mintAdapter('BinInputAdapter')

function BinInputAdapter:beforeRegister ()
    self.prefix = 'mekbin:'

    self.queries = {
        storage = {
            stored      = fn():call('getStored'):get('count'):with('unit', 'item'),
            capacity    = fn():call('getCapacity'):with('unit', 'item'),
        },
    }

    self.storageQueries = {
        fn():call('getStored'):transform(function (v)
            return { Metric{ name = v.name, value = v.count, unit = 'item' } }
        end)
    }

    -- getComparatorLevel
    -- getDirection
    
    -- TODO only supports comparator and direction
    -- self:withGenericMachineQueries()
end

return BinInputAdapter