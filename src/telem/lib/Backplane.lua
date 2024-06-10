local o = require 'telem.lib.ObjectModel'
local t = require 'telem.lib.util'

local InputAdapter     = require 'telem.lib.InputAdapter'
local OutputAdapter    = require 'telem.lib.OutputAdapter'
local MetricCollection = require 'telem.lib.MetricCollection'
local Middleware       = require 'telem.lib.BaseMiddleware'

local Backplane = o.class()
Backplane.type = 'Backplane'

function Backplane:constructor ()
    self.debugState = false
    
    self.loaded = false
    self.cacheState = false
    self.lastCache = 0
    self.cacheRate = 1

    self.inputs = {}
    self.outputs = {}
    self.middlewares = {}

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

function Backplane:middleware (...)
    local args = {...}

    for _, middleware in ipairs(args) do
        self:addMiddleware(middleware)
    end

    return self
end

function Backplane:addMiddleware (middleware)
    assert(o.instanceof(middleware, Middleware), 'middleware must be a Middleware')

    table.insert(self.middlewares, middleware)

    return self
end

function Backplane:addAsyncCycleHandler (adapter, handler)
    table.insert(self.asyncCycleHandlers, handler)
end

function Backplane:processMiddleware (middlewares, collection)
    assert(middlewares and type(middlewares) == 'table', 'middlewares must be a list of Middleware')

    local newCollection = collection

    for _, middleware in ipairs(middlewares) do
        local results = {pcall(middleware.handle, middleware, newCollection)}

        if not table.remove(results, 1) then
            t.log('Middleware fault:')
            t.pprint(table.remove(results, 1))
        end

        newCollection = table.remove(results, 1)
    end

    return newCollection
end

function Backplane:cycle()
    local tempMetrics = {}
    local metrics = MetricCollection()

    self:dlog('Backplane:cycle :: ' .. os.date())
    self:dlog('Backplane:cycle :: cycle START !')

    -- load output states
    if not self.loaded and self.cacheState then
        self:dlog('Backplane:cycle :: loading state...')

        local inf = fs.open('/.telem/state', 'r')

        if inf then
            local cache = textutils.unserialize(inf.readAll()) or {}
            inf.close()

            for k, v in pairs(cache) do
                local output = self.outputs[k]

                if output and output.isCacheable then
                    self:dlog('Backplane:cycle ::  - ' .. k)

                    local results = {pcall(output.loadState, output, v)}

                    if not table.remove(results, 1) then
                        t.log('loadState fault for "' .. k .. '":')
                        t.pprint(table.remove(results, 1))
                    end
                end
            end
        end
    end

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
            local inputCollection = table.remove(results, 1)

            -- process input middleware
            local processedInputCollection = self:processMiddleware(input.middlewares, inputCollection)

            for _,v in ipairs(processedInputCollection.metrics) do
                -- attach adapter name
                v.adapter = key .. (v.adapter and ':' .. v.adapter or '')

                table.insert(tempMetrics, v)
            end
        end
    end

    self:dlog('Backplane:cycle :: committing metrics...')

    for _,v in ipairs(tempMetrics) do
        metrics:insert(v)
    end

    self:dlog('Backplane:cycle :: saving state...')

    self:dlog('Backplane:cycle ::  - Backplane')

    self.collection = metrics

    -- cache output states
    if self.cacheState then
        local time = os.epoch('utc')

        if self.lastCache + self.cacheRate * 1000 <= time then
            local cache = {}

            for _, key in pairs(self.outputKeys) do
                local output = self.outputs[key]

                if output.isCacheable then
                    self:dlog('Backplane:cycle ::  - ' .. key)

                    local results = {pcall(output.getState, output)}

                    if not table.remove(results, 1) then
                        t.log('getState fault for "' .. key .. '":')
                        t.pprint(table.remove(results, 1))
                    end

                    cache[key] = table.remove(results, 1)
                end
            end

            fs.makeDir('/.telem')
            local outf = fs.open('/.telem/state', 'w')
            outf.write(textutils.serialize(cache, { compact = true }))
            outf.flush()

            self.lastCache = time
        end
    end

    self:dlog('Backplane:cycle :: processing middleware...')

    self.collection = self:processMiddleware(self.middlewares, self.collection)

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

    if not self.loaded then
        self.loaded = true
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

-- trigger eager layout updates on all attached outputs with updateLayout functions
function Backplane:updateLayouts()
    self:dlog('Backplane:updateLayouts :: Updating layouts...')

    for _, key in pairs(self.outputKeys) do
        local output = self.outputs[key]

        if type(output.updateLayout) == 'function' then
            self:dlog('Backplane:updateLayouts ::  - ' .. key)

            local results = {pcall(output.updateLayout, output)}

            if not table.remove(results, 1) then
                t.log('Update layout fault for "' .. key .. '":')
                t.pprint(table.remove(results, 1))
            end
        end
    end

    self:dlog('Backplane:updateLayouts :: Layouts updated')
end

function Backplane:cache(cache)
    self.cacheState = cache and true or false

    return self
end

function Backplane:debug(debug)
    self.debugState = debug and true or false

    return self
end

function Backplane:dlog(msg)
    if self.debugState then t.log(msg) end
end

return Backplane