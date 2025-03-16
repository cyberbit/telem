local o                      = require 'telem.lib.ObjectModel'
local fl                     = require 'telem.vendor'.fluent
local fn                     = fl.fn

local InputAdapter           = require 'telem.lib.InputAdapter'
local Metric                 = require 'telem.lib.Metric'
local MetricCollection       = require 'telem.lib.MetricCollection'

local BaseCreateInputAdapter = o.class(InputAdapter)
BaseCreateInputAdapter.type  = 'BaseCreateInputAdapter'

function BaseCreateInputAdapter:constructor(peripheralName, categories)
    self:super('constructor')

    self.prefix = 'create:'

    self.categories = categories or { 'basic' }

    ---@type table<string, table<string, cyberbit.Fluent>>
    self.queries = {}

    ---@type cyberbit.Fluent[]
    self.storageQueries = {}

    -- boot components
    self:setBoot(function()
        self.components = {}

        self:addComponentByPeripheralID(peripheralName)
    end)()

    self:beforeRegister()

    self:register()
end

function BaseCreateInputAdapter:beforeRegister()
    -- nothing by default, should be overridden by subclasses
end

function BaseCreateInputAdapter:register()
    local allCategories = fl(self.queries):keys():result()

    if self.categories == '*' then
        self.categories = allCategories
    elseif type(self.categories) == 'table' then
        self.categories = fl(self.categories):intersect(allCategories):result()
    else
        error('categories must be a list of categories or "*"')
    end

    return self
end

------ Static Methods ------

function BaseCreateInputAdapter.mintAdapter(type)
    local adapter = o.class(BaseCreateInputAdapter)
    adapter.type = type

    function adapter:constructor(peripheralName, categories)
        self:super('constructor', peripheralName, categories)
    end

    return adapter
end

return BaseCreateInputAdapter
