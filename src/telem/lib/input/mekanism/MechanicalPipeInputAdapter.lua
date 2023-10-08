local o = require 'telem.lib.ObjectModel'
local t = require 'telem.lib.util'

local InputAdapter      = require 'telem.lib.InputAdapter'
local Metric            = require 'telem.lib.Metric'
local MetricCollection  = require 'telem.lib.MetricCollection'

local MechanicalPipeInputAdapter = o.class(InputAdapter)
MechanicalPipeInputAdapter.type = 'MechanicalPipeInputAdapter'

function MechanicalPipeInputAdapter:constructor (peripheralName, categories)
    self:super('constructor')

    -- TODO this will be a configurable feature later
    self.prefix = 'mekmechpipe:'

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

function MechanicalPipeInputAdapter:read ()
    self:boot()

    local source, tube = next(self.components)

    local metrics = MetricCollection()

    local loaded = {}

    for _,v in ipairs(self.categories) do
        -- skip, already loaded
        if loaded[v] then
            -- do nothing

        -- Literally all we have lmao
        elseif v == 'basic' then
            metrics:insert(Metric{ name = self.prefix .. 'buffer', value = tube.getBuffer() / 1000, unit = "B", source = source })
            metrics:insert(Metric{ name = self.prefix .. 'capacity', value = tube.getCapacity() / 1000, unit = "B", source = source }) -- might error might not, no clue!
            metrics:insert(Metric{ name = self.prefix .. 'needed', value = tube.getNeeded() / 1000, unit = "B", source = source })
            metrics:insert(Metric{ name = self.prefix .. 'filled_percentage', value = tube.getFilledPercentage(), unit = nil, source = source })
        end

        loaded[v] = true
    end

    return metrics
end

return MechanicalPipeInputAdapter

