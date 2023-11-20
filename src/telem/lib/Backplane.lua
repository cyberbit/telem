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

    -- last recorded state
    self.collection = MetricCollection()

    self.asyncCycleHandlers = {}
end

-- TODO allow auto-named inputs based on type
function Backplane:addInput (name, input)
    assert(type(name) == 'string', 'name must be a string')
    assert(o.instanceof(input, InputAdapter), 'Input must be an InputAdapter')

    -- propagate debug state
    if self.debugState then
        input:debug(self.debugState)
    end

    self.inputs[name] = input
    table.insert(self.inputKeys, name)

    if input.asyncCycleHandler then
        self:addAsyncCycleHandler(name, input.asyncCycleHandler)
    end

    return self
end

function Backplane:addOutput (name, output)
    assert(type(name) == 'string', 'name must be a string')
    assert(o.instanceof(output, OutputAdapter), 'Output must be an OutputAdapter')

    self:dlog('Backplane:addOutput :: adding output: ' .. name)

    -- propagate debug state
    if self.debugState then
        output:debug(self.debugState)
    end

    self.outputs[name] = output
    table.insert(self.outputKeys, name)

    if output.asyncCycleHandler then
        self:dlog('Backplane:addOutput :: registering async handler for ' .. name)

        self:addAsyncCycleHandler(name, function ()
            self:dlog('Backplane:asyncCycleHandler (closure) :: executing async handler for ' .. name)
                
            local results = {pcall(output.asyncCycleHandler, self)}
    
            if not table.remove(results, 1) then
                t.log('Output fault in async handler for "' .. name .. '":')
                t.pprint(table.remove(results, 1))
            end
        end)
    end

    return self
end

function Backplane:addAsyncCycleHandler (adapter, handler)
    table.insert(self.asyncCycleHandlers, handler)
end

-- NYI
function Backplane:processMiddleware ()
    --
    return self
end

function Backplane:cycle()
    local tempMetrics = {}
    local metrics = MetricCollection()

    self:dlog('Backplane:cycle :: ' .. os.date())
    self:dlog('Backplane:cycle :: cycle START !')

    self:dlog('Backplane:cycle :: reading inputs...')

    -- read inputs
    for _, key in ipairs(self.inputKeys) do
        local input = self.inputs[key]

        self:dlog('Backplane:cycle ::  - ' .. key)

        local results = {pcall(input.read, input)}

        if not table.remove(results, 1) then
            t.log('Input fault for "' .. key .. '":')
            t.pprint(table.remove(results, 1))
        else
            local inputMetrics = table.remove(results, 1)

            -- attach adapter name
            for _,v in ipairs(inputMetrics.metrics) do
                v.adapter = key .. (v.adapter and ':' .. v.adapter or '')

                table.insert(tempMetrics, v)
            end
        end
    end

    -- TODO process middleware

    self:dlog('Backplane:cycle :: sorting metrics...')

    -- sort
    -- TODO make this a middleware
    table.sort(tempMetrics, function (a,b) return a.name < b.name end)
    for _,v in ipairs(tempMetrics) do
        metrics:insert(v)
    end

    self:dlog('Backplane:cycle :: saving state...')

    self.collection = metrics

    self:dlog('Backplane:cycle :: writing outputs...')

    -- write outputs
    for _, key in pairs(self.outputKeys) do
        local output = self.outputs[key]

        self:dlog('Backplane:cycle ::  - ' .. key)

        local results = {pcall(output.write, output, metrics)}

        if not table.remove(results, 1) then
            t.log('Output fault for "' .. key .. '":')
            t.pprint(table.remove(results, 1))
        end
    end

    self:dlog('Backplane:cycle :: cycle END !')

    return self
end

-- return a function to cycle this Backplane on a set interval
function Backplane:cycleEvery(seconds)
    local selfCycle = function()
        while true do
            self:cycle()

            t.sleep(seconds)
        end
    end

    -- TODO
    -- this will break support for backplane:cycleEvery(3)() if
    -- async-enabled adapters are attached. docs should be updated
    -- to either remove the direct launching as an option, or
    -- add guidance to all async-enabled adapters to use parallel.
    if #{self.asyncCycleHandlers} > 0 then
        self:dlog('Backplane:cycleEvery :: found async handlers, returning function list')

        return selfCycle, table.unpack(self.asyncCycleHandlers)
    end

    self:dlog('Backplane:cycleEvery :: no async handlers found, returning cycle function')
    return selfCycle
end

function Backplane:debug(debug)
    self.debugState = debug and true or false

    return self
end

function Backplane:dlog(msg)
    if self.debugState then t.log(msg) end
end

return Backplane