local o = require 'telem.lib.ObjectModel'
local t = require 'telem.lib.util'

local InputAdapter = o.class()
InputAdapter.type = 'InputAdapter'

local Middleware = require 'telem.lib.BaseMiddleware'

function InputAdapter:constructor()
    assert(self.type ~= InputAdapter.type, 'InputAdapter cannot be instantiated')

    self.debugState = false

    self.prefix = ''
    self.asyncCycleHandler = nil
    
    self.middlewares = {}
    
    -- boot components
    self:setBoot(function ()
        self.components = {}
    end)()
end

function InputAdapter:setBoot(proc)
    assert(type(proc) == 'function', 'proc must be a function')

    self.boot = proc

    return self.boot
end

function InputAdapter:setAsyncCycleHandler(proc)
    assert(type(proc) == 'function', 'proc must be a function')
    
    self.asyncCycleHandler = proc

    return self.asyncCycleHandler
end

function InputAdapter:addComponentByPeripheralID (id)
    local tempComponent = peripheral.wrap(id)

    assert(tempComponent, 'Could not find peripheral ID ' .. id)

    self.components[id] = tempComponent
end

function InputAdapter:addComponentByPeripheralType (type)
    local key = type .. '_' .. #{self.components}

    local tempComponent = peripheral.find(type)

    assert(tempComponent, 'Could not find peripheral type ' .. type)

    self.components[key] = tempComponent
end

function InputAdapter:read ()
    self:boot()

    t.err(self.type .. ' has not implemented read()')
end

function InputAdapter:middleware (...)
    local args = {...}

    for _, middleware in ipairs(args) do
        self:addMiddleware(middleware)
    end

    return self
end

function InputAdapter:addMiddleware (middleware)
    assert(o.instanceof(middleware, Middleware), 'middleware must be a Middleware')

    table.insert(self.middlewares, middleware)

    return self
end

function InputAdapter:debug(debug)
    self.debugState = debug and true or false

    return self
end

function InputAdapter:dlog(msg)
    if self.debugState then t.log(msg) end
end

return InputAdapter