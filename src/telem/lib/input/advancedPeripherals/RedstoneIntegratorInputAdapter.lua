local fl = require 'telem.vendor'.fluent
local fn = fl.fn

local base = require 'telem.lib.input.advancedPeripherals.BaseAdvancedPeripheralsInputAdapter'

local RedstoneIntegratorInputAdapter = base.mintAdapter('RedstoneIntegratorInputAdapter')

function RedstoneIntegratorInputAdapter:beforeRegister (peripheralName, categories, sides)
    self.prefix = 'apredstone:'
    
    self.sides = sides or '*'

    local allRelativeSides = {
        'right', 'left', 'front', 'back', 'top', 'bottom',
    }

    local allCardinalSides = {
        'north', 'south', 'east', 'west', 'up', 'down'
    }

    local allSides = fl({allRelativeSides, allCardinalSides}):flatten():result()

    if self.sides == '*' then
        self.sides = allRelativeSides
    elseif type(self.sides) == 'table' then
        self.sides = fl(self.sides):intersect(allSides):result()
    else
        error('sides must be a list of sides or "*"')
    end

    self.queries = {
        basic = {}
    }

    for _, side in ipairs(self.sides) do
        self.queries.basic['input_' .. side]            = fn():call('getInput', side):toFlag()
        self.queries.basic['input_analog_' .. side]     = fn():call('getAnalogInput', side)

        -- TODO is there any reason to include these?
        -- self.queries.basic['output_' .. side]           = fn():call('getOutput', side):toFlag()
        -- self.queries.basic['output_analog_' .. side]    = fn():call('getAnalogOutput', side)
    end
end

return RedstoneIntegratorInputAdapter