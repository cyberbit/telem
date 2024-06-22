local o = require 'telem.lib.ObjectModel'
local t = require 'telem.lib.util'
local fn = require 'telem.vendor'.fluent.fn

local BaseMekanismInputAdapter = require 'telem.lib.input.mekanism.BaseMekanismInputAdapter'

local BioGeneratorInputAdapter = o.class(BaseMekanismInputAdapter)
BioGeneratorInputAdapter.type = 'BioGeneratorInputAdapter'

function BioGeneratorInputAdapter:constructor (peripheralName, categories)
    self:super('constructor', peripheralName)

    -- TODO this will be a configurable feature later
    self.prefix = 'mekbiogen:'

    -- TODO make these constants
    local allCategories = {
        'basic',
        'advanced',
        'fuel',
        'energy'
    }

    if not categories then
        self.categories = { 'basic' }
    elseif categories == '*' then
        self.categories = allCategories
    else
        self.categories = categories
    end

    self.queries = {
        basic = {
            bio_fuel_filled_percentage  = fn():call('getBioFuelFilledPercentage'),
        },
        fuel = {
            bio_fuel                    = fn():call('getBioFuel'):get('amount'):div(1000):fluid(),
            bio_fuel_capacity           = fn():call('getBioFuelCapacity'):div(1000):fluid(),
            bio_fuel_needed             = fn():call('getBioFuelNeeded'):div(1000):fluid(),
        }
    }
    
    self:withGenericMachineQueries()
    self:withGeneratorQueries()
end

return BioGeneratorInputAdapter

