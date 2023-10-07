local o = require 'telem.lib.ObjectModel'
local t = require 'telem.lib.util'

local InputAdapter      = require 'telem.lib.InputAdapter'
local Metric            = require 'telem.lib.Metric'
local MetricCollection  = require 'telem.lib.MetricCollection'

local ChemicalTankInputAdapter = o.class(InputAdapter)
ChemicalTankInputAdapter.type = 'ChemicalTankInputAdapter'

function ChemicalTankInputAdapter:constructor (peripheralName, categories)
    self:super('constructor')

    -- TODO this will be a configurable feature later
    self.prefix = 'mekchemtank:'

    -- TODO make these constants
    local allCategories = {
        'basic',
    }

    if not categories then
        self.categories = { 'basic' }
    elseif categories == '*' then
        self.categories = allCategories
    else
        self.categories = categories
    end

    -- boot components
    self:setBoot(function ()
        self.components = {}

        self:addComponentByPeripheralID(peripheralName)
    end)()
end

function ChemicalTankInputAdapter:read ()
    self:boot()

    local source, tank = next(self.components)

    local metrics = MetricCollection()

    local loaded = {}

    for _,v in ipairs(self.categories) do
        -- skip, already loaded
        if loaded[v] then
            -- do nothing

        -- Literally all we have lmao
        elseif v == 'basic' then
            metrics:insert(Metric{ name = self.prefix .. 'capacity', value = tank.getCapacity(), unit = "mB", source = source })
            metrics:insert(Metric{ name = self.prefix .. 'stored', value = tank.getStored().amount, unit = "mB", source = source }) -- might error might not, no clue!
            metrics:insert(Metric{ name = self.prefix .. 'filled_percentage', value = tank.getFilledPercentage(), unit = nil, source = source })
        end

        loaded[v] = true
    end

    return metrics
end

return ChemicalTankInputAdapter

