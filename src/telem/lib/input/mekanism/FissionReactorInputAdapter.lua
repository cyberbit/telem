local o = require 'telem.lib.ObjectModel'
local t = require 'telem.lib.util'
local fn = require 'telem.vendor'.fluent.fn

local BaseMekanismInputAdapter = require 'telem.lib.input.mekanism.BaseMekanismInputAdapter'

local FissionReactorInputAdapter = o.class(BaseMekanismInputAdapter)
FissionReactorInputAdapter.type = 'FissionReactorInputAdapter'

function FissionReactorInputAdapter:constructor (peripheralName, categories)
    self:super('constructor', peripheralName)

    -- TODO this will be a configurable feature later
    self.prefix = 'mekfission:'

    -- TODO make these constants
    local allCategories = {
        'basic',
        'advanced',
        'fuel',
        'coolant',
        'waste',
        'formation'
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
            status                              = fn():callElse('getStatus', 0):toFlag(),
            burn_rate                           = fn():callElse('getBurnRate', 0):div(1000):fluidRate(),
            max_burn_rate                       = fn():callElse('getMaxBurnRate', 0):div(1000):fluidRate(),
            temperature                         = fn():callElse('getTemperature', 0):temp(),
            damage_percent                      = fn():callElse('getDamagePercent', 0),
            fuel_filled_percentage              = fn():callElse('getFuelFilledPercentage', 0),
            coolant_filled_percentage           = fn():callElse('getCoolantFilledPercentage', 0),
            heated_coolant_filled_percentage    = fn():callElse('getHeatedCoolantFilledPercentage', 0),
            waste_filled_percentage             = fn():callElse('getWasteFilledPercentage', 0)
        },
        advanced = {
            actual_burn_rate                    = fn():callElse('getActualBurnRate', 0):div(1000):fluidRate(),
            environmental_loss                  = fn():callElse('getEnvironmentalLoss', 0),
            heating_rate                        = fn():callElse('getHeatingRate', 0):div(1000):fluidRate(),
        },
        coolant = {
            coolant                             = fn():callElse('getCoolant', { amount = 0 }):get('amount'):div(1000):fluid(),
            coolant_capacity                    = fn():callElse('getCoolantCapacity', 0):div(1000):fluid(),
            coolant_needed                      = fn():callElse('getCoolantNeeded', 0):div(1000):fluid(),
            heated_coolant                      = fn():callElse('getHeatedCoolant', { amount = 0 }):get('amount'):div(1000):fluid(),
            heated_coolant_capacity             = fn():callElse('getHeatedCoolantCapacity', 0):div(1000):fluid(),
            heated_coolant_needed               = fn():callElse('getHeatedCoolantNeeded', 0):div(1000):fluid()
        },
        fuel = {
            fuel                                = fn():callElse('getFuel', { amount = 0 }):get('amount'):div(1000):fluid(),
            fuel_capacity                       = fn():callElse('getFuelCapacity', 0):div(1000):fluid(),
            fuel_needed                         = fn():callElse('getFuelNeeded', 0):div(1000):fluid()
        },
        waste = {
            waste                               = fn():callElse('getWaste', { amount = 0 }):get('amount'):div(1000):fluid(),
            waste_capacity                      = fn():callElse('getWasteCapacity', 0):div(1000):fluid(),
            waste_needed                        = fn():callElse('getWasteNeeded', 0):div(1000):fluid()
        },
        formation = {
            force_disabled                      = fn():callElse('isForceDisabled', 0):toFlag(),
            fuel_assemblies                     = fn():callElse('getFuelAssemblies', 0),
            fuel_surface_area                   = fn():callElse('getFuelSurfaceArea', 0):with('unit', 'm²'),
            heat_capacity                       = fn():callElse('getHeatCapacity', 0):with('unit', 'J/K'),
            boil_efficiency                     = fn():callElse('getBoilEfficiency', 0),
        }
    }

    self:withMultiblockQueries()

    -- getMinPos
    -- getRedstoneMode
    -- getMaxPos
    -- getRedstoneLogicStatus
    -- getLogicMode
end

return FissionReactorInputAdapter