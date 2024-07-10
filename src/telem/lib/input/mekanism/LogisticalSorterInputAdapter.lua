local fn = require 'telem.vendor'.fluent.fn

local base = require 'telem.lib.input.mekanism.BaseMekanismInputAdapter'

local LogisticalSorterInputAdapter = base.mintAdapter('LogisticalSorterInputAdapter')

function LogisticalSorterInputAdapter:beforeRegister ()
    self.prefix = 'meklogsorter:'

    self.queries = {
        basic = {
            comparator_level    = fn():call('getComparatorLevel'),
        },
    }
end

return LogisticalSorterInputAdapter