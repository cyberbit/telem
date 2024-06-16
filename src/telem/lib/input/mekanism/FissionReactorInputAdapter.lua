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
            status                              = fn():call('getStatus'):toFlag(),
            burn_rate                           = fn():call('getBurnRate'):div(1000):fluidRate(),
            max_burn_rate                       = fn():call('getMaxBurnRate'):div(1000):fluidRate(),
            temperature                         = fn():call('getTemperature'):temp(),
            damage_percent                      = fn():call('getDamagePercent'),
            fuel_filled_percentage              = fn():call('getFuelFilledPercentage'),
            coolant_filled_percentage           = fn():call('getCoolantFilledPercentage'),
            heated_coolant_filled_percentage    = fn():call('getHeatedCoolantFilledPercentage'),
            waste_filled_percentage             = fn():call('getWasteFilledPercentage')
        },
        advanced = {
            actual_burn_rate                    = fn():call('getActualBurnRate'):div(1000):fluidRate(),
            environmental_loss                  = fn():call('getEnvironmentalLoss'),
            heating_rate                        = fn():call('getHeatingRate'):div(1000):fluidRate(),
        },
        coolant = {
            coolant                             = fn():call('getCoolant'):get('amount'):div(1000):fluid(),
            coolant_capacity                    = fn():call('getCoolantCapacity'):div(1000):fluid(),
            coolant_needed                      = fn():call('getCoolantNeeded'):div(1000):fluid(),
            heated_coolant                      = fn():call('getHeatedCoolant'):get('amount'):div(1000):fluid(),
            heated_coolant_capacity             = fn():call('getHeatedCoolantCapacity'):div(1000):fluid(),
            heated_coolant_needed               = fn():call('getHeatedCoolantNeeded'):div(1000):fluid()
        },
        fuel = {
            fuel                                = fn():call('getFuel'):get('amount'):div(1000):fluid(),
            fuel_capacity                       = fn():call('getFuelCapacity'):div(1000):fluid(),
            fuel_needed                         = fn():call('getFuelNeeded'):div(1000):fluid()
        },
        waste = {
            waste                               = fn():call('getWaste'):get('amount'):div(1000):fluid(),
            waste_capacity                      = fn():call('getWasteCapacity'):div(1000):fluid(),
            waste_needed                        = fn():call('getWasteNeeded'):div(1000):fluid()
        },
        formation = {
            formed                              = fn():call('isFormed'):toFlag(),
            force_disabled                      = fn():call('isForceDisabled'):toFlag(),
            height                              = fn():call('getHeight'):with('unit', 'm'),
            length                              = fn():call('getLength'):with('unit', 'm'),
            width                               = fn():call('getWidth'):with('unit', 'm'),
            fuel_assemblies                     = fn():call('getFuelAssemblies'),
            fuel_surface_area                   = fn():call('getFuelSurfaceArea'):with('unit', 'm²'),
            heat_capacity                       = fn():call('getHeatCapacity'):with('unit', 'J/K'),
            boil_efficiency                     = fn():call('getBoilEfficiency')
        }
    }

    -- not sure if these are useful, but they return strings anyway which are not Metric compatible, RIP
    -- fission.getLogicMode()
    -- fission.getRedstoneLogicStatus()
end

return FissionReactorInputAdapter