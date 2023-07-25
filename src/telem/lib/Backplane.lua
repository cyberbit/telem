local o = require 'telem.lib.ObjectModel'
local t = require 'telem.lib.util'

local InputAdapter     = require 'telem.lib.InputAdapter'
local OutputAdapter    = require 'telem.lib.OutputAdapter'
local MetricCollection = require 'telem.lib.MetricCollection'

local Backplane = o.class()
Backplane.type = 'Backplane'

function Backplane:constructor ()
    self.debugState = false

    self.inputs = {}
    self.outputs = {}

    -- workaround to guarantee processing order
    self.inputKeys = {}
    self.outputKeys = {}
end

-- TODO allow auto-named inputs based on type
function Backplane:addInput (name, input)
    assert(type(name) == 'string', 'name must be a string')
    assert(o.instanceof(input, InputAdapter), 'Input must be an InputAdapter')

    self.inputs[name] = input
    table.insert(self.inputKeys, name)

    return self
end

function Backplane:addOutput (name, output)
    assert(type(name) == 'string', 'name must be a string')
    assert(o.instanceof(output, OutputAdapter), 'Output must be an OutputAdapter')

    self.outputs[name] = output
    table.insert(self.outputKeys, name)

    return self
end

-- NYI
function Backplane:processMiddleware ()
    --
    return self
end

function Backplane:cycle()
    local tempMetrics = {}
    local metrics = MetricCollection()

    self:dlog('** cycle START !')

    self:dlog('reading inputs...')

    -- read inputs
    for _, key in ipairs(self.inputKeys) do
        local input = self.inputs[key]

        self:dlog(' - ' .. key)

        local results = {pcall(input.read, input)}

        if not table.remove(results, 1) then
            t.log('Input fault for "' .. key .. '":')
            t.pprint(table.remove(results, 1))
        else
            local inputMetrics = table.remove(results, 1)

            -- attach adapter name
            for _,v in ipairs(inputMetrics.metrics) do
                v.adapter = key

                table.insert(tempMetrics, v)
            end
        end
    end

    -- TODO process middleware

    -- t.pprint(tempMetrics)

    self:dlog('sorting metrics...')

    -- sort
    -- TODO make this a middleware
    table.sort(tempMetrics, function (a,b) return a.name < b.name end)
    for _,v in ipairs(tempMetrics) do
        metrics:insert(v)
    end

    self:dlog('writing outputs...')

    -- write outputs
    for _, key in pairs(self.outputKeys) do
        local output = self.outputs[key]

        self:dlog(' - ' .. key)

        local results = {pcall(output.write, output, metrics)}

        if not table.remove(results, 1) then
            t.log('Output fault for "' .. key .. '":')
            t.pprint(table.remove(results, 1))
        end
    end

    self:dlog('** cycle END !')

    return self
end

-- return a function to cycle this Backplane on a set interval
function Backplane:cycleEvery(seconds)
    return function()
        while true do
            self:cycle()

            t.sleep(seconds)
        end
    end
end

function Backplane:debug(debug)
    self.debugState = debug and true or false

    return self
end

function Backplane:dlog(msg)
    if self.debugState then t.log(msg) end
end

return Backplane