
---------------------------------------------------------
----------------Auto generated code block----------------
---------------------------------------------------------

do
    local searchers = package.searchers or package.loaders
    local origin_seacher = searchers[2]
    searchers[2] = function(path)
        local files =
        {
------------------------
-- Modules part begin --
------------------------

["telem.lib.Backplane"] = function()
--------------------
-- Module: 'telem.lib.Backplane'
--------------------
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
end,

["telem.lib.Metric"] = function()
--------------------
-- Module: 'telem.lib.Metric'
--------------------
local o = require 'telem.lib.ObjectModel'
local t = require 'telem.lib.util'

local Metric = o.class()
Metric.type = 'Metric'

function Metric:constructor (data, data2)
    local datum

    if type(data) == 'table' then
        datum = data
    else
        datum = { name = data, value = data2 }
    end

    self.name = assert(datum.name, 'Metric must have a name')
    self.value = assert(datum.value, 'Metric must have a value')
    self.unit = datum.unit or nil
    self.source = datum.source or nil
    self.adapter = datum.adapter or nil
end

function Metric:__tostring ()
    local label = self.name .. ' = ' .. self.value

    -- TODO unit source adapter
    local unit, source, adapter

    unit = self.unit and ' ' .. self.unit or ''
    source = self.source and ' (' .. self.source .. ')' or ''
    adapter = self.adapter and ' from ' .. self.adapter or ''

    -- t.pprint(unit)
    -- t.pprint(source)
    -- t.pprint(adapter)

    return label .. unit .. adapter .. source
end

return Metric
end,

["telem.lib.util"] = function()
--------------------
-- Module: 'telem.lib.util'
--------------------
-- TODO write my own pretty_print
local pretty = { pretty_print = print }

local function tsleep(num)
    local sec = tonumber(os.clock() + num)
    while (os.clock() < sec) do end
end

local function log(msg)
    print('TELEM :: '..msg)
end

local function err(msg)
    error('TELEM :: '..msg)
end

local function pprint(dater)
    return pretty.pretty_print(dater)
end

-- via https://www.lua.org/pil/19.3.html
local function skpairs(t, f)
    local a = {}
    for n in pairs(t) do table.insert(a, n) end
    table.sort(a, f)
    local i = 0
    local iter = function ()
        i = i + 1
        if a[i] == nil then return nil
        else return a[i], t[a[i]]
        end
    end
    return iter
end

return {
    log = log,
    err = err,
    pprint = pprint,
    skpairs = skpairs,
    sleep = os.sleep or tsleep
}
end,

["telem.lib.MetricCollection"] = function()
--------------------
-- Module: 'telem.lib.MetricCollection'
--------------------
local o = require 'telem.lib.ObjectModel'
local t = require 'telem.lib.util'

local Metric = require 'telem.lib.Metric'

local MetricCollection = o.class()
MetricCollection.type = 'MetricCollection'

function MetricCollection:constructor (...)
    self.metrics = {}
    self.context = {}

    local firstArg = select(1, ...)

    if type(firstArg) == 'table' and not o.instanceof(firstArg, Metric) then
        for name, value in pairs(firstArg) do
            self:insert(Metric(name, value))
        end
    else
        for _, v in next, {...} do
            self:insert(v)
        end
    end
end

function MetricCollection:insert (element)
    assert(o.instanceof(element, Metric), 'Element must be a Metric')
    table.insert(self.metrics, element)

    return self
end

function MetricCollection:setContext (ctx)
    self.context = { table.unpack(ctx) }

    return self
end

return MetricCollection
end,

["telem.lib.ObjectModel"] = function()
--------------------
-- Module: 'telem.lib.ObjectModel'
--------------------
--
-- Lua object model implementation
--
-- By Shira-3749
-- Source: https://github.com/Shira-3749/lua-object-model
--

local a='Lua 5.1'==_VERSION;local unpack=unpack or table.unpack;local function b(c,...)local d={}setmetatable(d,c)if c.constructor then c.constructor(d,...)end;return d end;local function e(d,f,...)if nil==d.___superScope then d.___superScope={}end;local g=d.___superScope[f]local h;if nil~=g then h=g.__parent else h=d.__parent end;d.___superScope[f]=h;local i={pcall(h[f],d,...)}local j=table.remove(i,1)d.___superScope[f]=g;if not j then error(i[1])end;return unpack(i)end;local function k(d,l)local c=getmetatable(d)while c do if c==l then return true end;c=c.__parent end;return false end;local function m(d)if d.destructor then d:destructor()end end;local function c(n)local c={}if n then for o,p in pairs(n)do c[o]=p end;c.__parent=n end;c.__index=c;if not n and not a then c.__gc=m end;if n then c.super=e end;local q={__call=b}setmetatable(c,q)return c end;return{class=c,instanceof=k,new=b,super=e}
end,

["telem.lib.input.MEStorageInputAdapter"] = function()
--------------------
-- Module: 'telem.lib.input.MEStorageInputAdapter'
--------------------
local o = require 'telem.lib.ObjectModel'
local t = require 'telem.lib.util'

local InputAdapter      = require 'telem.lib.InputAdapter'
local Metric            = require 'telem.lib.Metric'
local MetricCollection  = require 'telem.lib.MetricCollection'

local MEStorageInputAdapter = o.class(InputAdapter)
MEStorageInputAdapter.type = 'MEStorageInputAdapter'

function MEStorageInputAdapter:constructor (peripheralName)
    self:super('constructor')

    -- TODO this will be a configurable feature later
    self.prefix = 'storage:'

    self:addComponentByPeripheralID(peripheralName)
end

function MEStorageInputAdapter:read ()
    local source, storage = next(self.components)
    local items = storage.listItems()
    local fluids = storage.listFluid()

    local metrics = MetricCollection()

    for _,v in pairs(items) do
        if v then metrics:insert(Metric({ name = self.prefix .. v.name, value = v.amount, unit = 'item', source = source })) end
    end

    for _,v in pairs(fluids) do
        if v then metrics:insert(Metric({ name = self.prefix .. v.name, value = v.amount / 1000, unit = 'B', source = source })) end
    end

    return metrics
end

return MEStorageInputAdapter
end,

["telem.lib.input.RefinedStorageInputAdapter"] = function()
--------------------
-- Module: 'telem.lib.input.RefinedStorageInputAdapter'
--------------------
local o = require 'telem.lib.ObjectModel'
local t = require 'telem.lib.util'

local InputAdapter      = require 'telem.lib.InputAdapter'
local Metric            = require 'telem.lib.Metric'
local MetricCollection  = require 'telem.lib.MetricCollection'

local RefinedStorageInputAdapter = o.class(InputAdapter)
RefinedStorageInputAdapter.type = 'RefinedStorageInputAdapter'

function RefinedStorageInputAdapter:constructor (peripheralName)
    self:super('constructor')

    -- TODO this will be a configurable feature later
    self.prefix = 'storage:'

    self:addComponentByPeripheralID(peripheralName)
end

function RefinedStorageInputAdapter:read ()
    local source, storage = next(self.components)
    local items = storage.listItems()
    local fluids = storage.listFluids()

    local metrics = MetricCollection()

    for _,v in pairs(items) do
        if v then metrics:insert(Metric({ name = self.prefix .. v.name, value = v.amount, unit = 'item', source = source })) end
    end

    for _,v in pairs(fluids) do
        if v then metrics:insert(Metric({ name = self.prefix .. v.name, value = v.amount / 1000, unit = 'B', source = source })) end
    end

    return metrics
end

return RefinedStorageInputAdapter
end,

["telem.lib.input"] = function()
--------------------
-- Module: 'telem.lib.input'
--------------------
return {
    helloWorld = require 'telem.lib.input.HelloWorldInputAdapter',

    -- storage
    itemStorage = require 'telem.lib.input.ItemStorageInputAdapter',
    fluidStorage = require 'telem.lib.input.FluidStorageInputAdapter',
    refinedStorage = require 'telem.lib.input.RefinedStorageInputAdapter',
    meStorage = require 'telem.lib.input.MEStorageInputAdapter',

    mekanism = {
        fissionReactor = require 'telem.lib.input.mekanism.FissionReactorInputAdapter',
        inductionMatrix = require 'telem.lib.input.mekanism.InductionMatrixInputAdapter',
        industrialTurbine = require 'telem.lib.input.mekanism.IndustrialTurbineInputAdapter',
    }
}
end,

["telem.lib.input.ItemStorageInputAdapter"] = function()
--------------------
-- Module: 'telem.lib.input.ItemStorageInputAdapter'
--------------------
local o = require 'telem.lib.ObjectModel'
local t = require 'telem.lib.util'

local InputAdapter      = require 'telem.lib.InputAdapter'
local Metric            = require 'telem.lib.Metric'
local MetricCollection  = require 'telem.lib.MetricCollection'

local ItemStorageInputAdapter = o.class(InputAdapter)
ItemStorageInputAdapter.type = 'ItemStorageInputAdapter'

function ItemStorageInputAdapter:constructor (peripheralName)
    self:super('constructor')

    -- TODO this will be a configurable feature later
    self.prefix = 'storage:'

    self:addComponentByPeripheralID(peripheralName)
end

function ItemStorageInputAdapter:read ()
    local source, itemStorage = next(self.components)
    local items = itemStorage.list()

    local tempMetrics = {}

    for _,v in pairs(items) do
        if v then
            local prefixkey = self.prefix .. v.name
            tempMetrics[prefixkey] = (tempMetrics[prefixkey] or 0) + v.count
        end
    end

    local metrics = MetricCollection()

    for k,v in pairs(tempMetrics) do
        if v then metrics:insert(Metric({ name = k, value = v, unit = 'item', source = source })) end
    end

    return metrics
end

return ItemStorageInputAdapter
end,

["telem.lib.input.mekanism.FissionReactorInputAdapter"] = function()
--------------------
-- Module: 'telem.lib.input.mekanism.FissionReactorInputAdapter'
--------------------
local o = require 'telem.lib.ObjectModel'
local t = require 'telem.lib.util'

local InputAdapter      = require 'telem.lib.InputAdapter'
local Metric            = require 'telem.lib.Metric'
local MetricCollection  = require 'telem.lib.MetricCollection'

local FissionReactorInputAdapter = o.class(InputAdapter)
FissionReactorInputAdapter.type = 'FissionReactorInputAdapter'

function FissionReactorInputAdapter:constructor (peripheralName, categories)
    self:super('constructor')

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

    self:addComponentByPeripheralID(peripheralName)
end

function FissionReactorInputAdapter:read ()
    local source, fission = next(self.components)

    local metrics = MetricCollection()

    local loaded = {}

    for _,v in ipairs(self.categories) do
        -- skip, already loaded
        if loaded[v] then
            -- do nothing

        -- minimum necessary for monitoring a fission reactor safely
        elseif v == 'basic' then
            metrics:insert(Metric{ name = self.prefix .. 'status', value = (fission.getStatus() and 1 or 0), unit = nil, source = source })
            metrics:insert(Metric{ name = self.prefix .. 'burn_rate', value = fission.getBurnRate() / 1000, unit = 'B/t', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'max_burn_rate', value = fission.getMaxBurnRate() / 1000, unit = 'B/t', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'temperature', value = fission.getTemperature(), unit = 'K', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'damage_percent', value = fission.getDamagePercent(), unit = nil, source = source })
            metrics:insert(Metric{ name = self.prefix .. 'fuel_filled_percentage', value = fission.getFuelFilledPercentage(), unit = nil, source = source })
            metrics:insert(Metric{ name = self.prefix .. 'coolant_filled_percentage', value = fission.getCoolantFilledPercentage(), unit = nil, source = source })
            metrics:insert(Metric{ name = self.prefix .. 'heated_coolant_filled_percentage', value = fission.getHeatedCoolantFilledPercentage(), unit = nil, source = source })
            metrics:insert(Metric{ name = self.prefix .. 'waste_filled_percentage', value = fission.getWasteFilledPercentage(), unit = nil, source = source })

        -- some further production metrics
        elseif v == 'advanced' then
            metrics:insert(Metric{ name = self.prefix .. 'actual_burn_rate', value = fission.getActualBurnRate() / 1000, unit = 'B/t', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'environmental_loss', value = fission.getEnvironmentalLoss(), unit = nil, source = source })
            metrics:insert(Metric{ name = self.prefix .. 'heating_rate', value = fission.getHeatingRate() / 1000, unit = 'B/t', source = source })

        elseif v == 'coolant' then
            metrics:insert(Metric{ name = self.prefix .. 'coolant', value = fission.getCoolant().amount / 1000, unit = 'B', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'coolant_capacity', value = fission.getCoolantCapacity() / 1000, unit = 'B', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'coolant_needed', value = fission.getCoolantNeeded() / 1000, unit = 'B', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'heated_coolant', value = fission.getHeatedCoolant().amount / 1000, unit = 'B', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'heated_coolant_capacity', value = fission.getHeatedCoolantCapacity() / 1000, unit = 'B', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'heated_coolant_needed', value = fission.getHeatedCoolantNeeded() / 1000, unit = 'B', source = source })

        elseif v == 'fuel' then
            metrics:insert(Metric{ name = self.prefix .. 'fuel', value = fission.getFuel().amount / 1000, unit = 'B', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'fuel_capacity', value = fission.getFuelCapacity() / 1000, unit = 'B', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'fuel_needed', value = fission.getFuelNeeded(), unit = 'B', source = source })

        elseif v == 'waste' then
            metrics:insert(Metric{ name = self.prefix .. 'waste', value = fission.getWaste().amount / 1000, unit = 'B', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'waste_capacity', value = fission.getWasteCapacity() / 1000, unit = 'B', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'waste_needed', value = fission.getWasteNeeded() / 1000, unit = 'B', source = source })

        -- measurements based on the multiblock structure itself
        elseif v == 'formation' then
            metrics:insert(Metric{ name = self.prefix .. 'formed', value = (fission.isFormed() and 1 or 0), unit = nil, source = source })
            metrics:insert(Metric{ name = self.prefix .. 'force_disabled', value = (fission.isForceDisabled() and 1 or 0), unit = nil, source = source })
            metrics:insert(Metric{ name = self.prefix .. 'height', value = fission.getHeight(), unit = 'm', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'length', value = fission.getLength(), unit = 'm', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'width', value = fission.getWidth(), unit = 'm', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'fuel_assemblies', value = fission.getFuelAssemblies(), unit = nil, source = source })
            metrics:insert(Metric{ name = self.prefix .. 'fuel_surface_area', value = fission.getFuelSurfaceArea(), unit = 'm²', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'heat_capacity', value = fission.getHeatCapacity(), unit = 'J/K', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'boil_efficiency',  value = fission.getBoilEfficiency(), unit = nil, source = source })
        end

        loaded[v] = true

        -- not sure if these are useful, but they return strings anyway which are not Metric compatible, RIP
        -- metrics:insert(Metric{ name = self.prefix .. 'logic_mode', value = fission.getLogicMode(), unit = nil, source = source })
        -- metrics:insert(Metric{ name = self.prefix .. 'redstone_logic_status', value = fission.getRedstoneLogicStatus(), unit = nil, source = source })
        -- metrics:insert(Metric{ name = self.prefix .. 'redstone_mode', value = fission.getRedstoneLogicStatus(), unit = nil, source = source })
    end

    return metrics
end

return FissionReactorInputAdapter
end,

["telem.lib.input.mekanism.IndustrialTurbineInputAdapter"] = function()
--------------------
-- Module: 'telem.lib.input.mekanism.IndustrialTurbineInputAdapter'
--------------------
local o = require 'telem.lib.ObjectModel'
local t = require 'telem.lib.util'

local InputAdapter      = require 'telem.lib.InputAdapter'
local Metric            = require 'telem.lib.Metric'
local MetricCollection  = require 'telem.lib.MetricCollection'

local IndustrialTurbineInputAdapter = o.class(InputAdapter)
IndustrialTurbineInputAdapter.type = 'IndustrialTurbineInputAdapter'

local DUMPING_MODES = {
    IDLE = 1,
    DUMPING_EXCESS = 2,
    DUMPING = 3,
}

function IndustrialTurbineInputAdapter:constructor (peripheralName, categories)
    self:super('constructor')

    -- TODO this will be a configurable feature later
    self.prefix = 'mekturbine:'

    local allCategories = {
        'basic',
        'advanced',
        'energy',
        'steam',
        'formation'
    }

    if not categories then
        self.categories = { 'basic' }
    elseif categories == '*' then
        self.categories = allCategories
    else
        self.categories = categories
    end

    self:addComponentByPeripheralID(peripheralName)
end

function IndustrialTurbineInputAdapter:read ()
    local source, turbine = next(self.components)

    local metrics = MetricCollection()

    local loaded = {}

    for _,v in ipairs(self.categories) do
        -- skip, already loaded
        if loaded[v] then
            -- do nothing

        -- minimum necessary for monitoring a fission reactor safely
        elseif v == 'basic' then
            metrics:insert(Metric{ name = self.prefix .. 'energy_filled_percentage', value = turbine.getEnergyFilledPercentage(), unit = nil, source = source })
            metrics:insert(Metric{ name = self.prefix .. 'energy_production_rate', value = mekanismEnergyHelper.joulesToFE(turbine.getProductionRate()), unit = 'FE/t', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'energy_max_production', value = mekanismEnergyHelper.joulesToFE(turbine.getMaxProduction()), unit = 'FE/t', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'steam_filled_percentage', value = turbine.getSteamFilledPercentage(), unit = nil, source = source })

        -- some further production metrics
        elseif v == 'advanced' then
            metrics:insert(Metric{ name = self.prefix .. 'comparator_level', value = turbine.getComparatorLevel(), unit = nil, source = source })
            metrics:insert(Metric{ name = self.prefix .. 'dumping_mode', value = DUMPING_MODES[turbine.getDumpingMode()], unit = nil, source = source })
            metrics:insert(Metric{ name = self.prefix .. 'flow_rate', value = turbine.getFlowRate() / 1000, unit = 'B/t', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'max_flow_rate', value = turbine.getMaxFlowRate() / 1000, unit = 'B/t', source = source })

        elseif v == 'energy' then
            metrics:insert(Metric{ name = self.prefix .. 'energy', value = mekanismEnergyHelper.joulesToFE(turbine.getEnergy()), unit = 'FE', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'max_energy', value = mekanismEnergyHelper.joulesToFE(turbine.getMaxEnergy()), unit = 'FE', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'energy_needed', value = mekanismEnergyHelper.joulesToFE(turbine.getEnergyNeeded()), unit = 'FE', source = source })

        elseif v == 'steam' then
            metrics:insert(Metric{ name = self.prefix .. 'steam_input_rate', value = turbine.getLastSteamInputRate() / 1000, unit = 'B/t', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'steam', value = turbine.getSteam().amount / 1000, unit = 'B', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'steam_capacity', value = turbine.getSteamCapacity() / 1000, unit = 'B', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'steam_needed', value = turbine.getSteamNeeded() / 1000, unit = 'B', source = source })

        -- measurements based on the multiblock structure itself
        elseif v == 'formation' then
            metrics:insert(Metric{ name = self.prefix .. 'formed', value = (turbine.isFormed() and 1 or 0), unit = nil, source = source })
            metrics:insert(Metric{ name = self.prefix .. 'height', value = turbine.getHeight(), unit = 'm', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'length', value = turbine.getLength(), unit = 'm', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'width', value = turbine.getWidth(), unit = 'm', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'blades', value = turbine.getBlades(), unit = nil, source = source })
            metrics:insert(Metric{ name = self.prefix .. 'coils', value = turbine.getCoils(), unit = nil, source = source })
            metrics:insert(Metric{ name = self.prefix .. 'condensers', value = turbine.getCondensers(), unit = nil, source = source })
            metrics:insert(Metric{ name = self.prefix .. 'dispersers', value = turbine.getDispersers(), unit = nil, source = source })
            metrics:insert(Metric{ name = self.prefix .. 'vents', value = turbine.getVents(), unit = nil, source = source })
            metrics:insert(Metric{ name = self.prefix .. 'max_water_output', value = turbine.getMaxWaterOutput() / 1000, unit = 'B/t', source = source })
        end

        loaded[v] = true

        -- not sure if these are useful, but they return types which are not Metric compatible, RIP
        -- turbine.getMaxPos(),
        -- turbine.getMinPos(),
    end

    return metrics
end

return IndustrialTurbineInputAdapter
end,

["telem.lib.input.mekanism.InductionMatrixInputAdapter"] = function()
--------------------
-- Module: 'telem.lib.input.mekanism.InductionMatrixInputAdapter'
--------------------
local o = require 'telem.lib.ObjectModel'
local t = require 'telem.lib.util'

local InputAdapter      = require 'telem.lib.InputAdapter'
local Metric            = require 'telem.lib.Metric'
local MetricCollection  = require 'telem.lib.MetricCollection'

local InductionMatrixInputAdapter = o.class(InputAdapter)
InductionMatrixInputAdapter.type = 'InductionMatrixInputAdapter'

function InductionMatrixInputAdapter:constructor (peripheralName, categories)
    self:super('constructor')

    -- TODO this will be a configurable feature later
    self.prefix = 'mekinduction:'

    local allCategories = {
        'basic',
        'advanced',
        'energy',
        'formation'
    }

    if not categories then
        self.categories = { 'basic' }
    elseif categories == '*' then
        self.categories = allCategories
    else
        self.categories = categories
    end

    self:addComponentByPeripheralID(peripheralName)
end

function InductionMatrixInputAdapter:read ()
    local source, induction = next(self.components)

    local metrics = MetricCollection()

    local loaded = {}

    for _,v in ipairs(self.categories) do
        -- skip, already loaded
        if loaded[v] then
            -- do nothing

        -- minimum necessary for monitoring a fission reactor safely
        elseif v == 'basic' then
            metrics:insert(Metric{ name = self.prefix .. 'energy_filled_percentage', value = induction.getEnergyFilledPercentage(), unit = nil, source = source })
            metrics:insert(Metric{ name = self.prefix .. 'energy_input', value = mekanismEnergyHelper.joulesToFE(induction.getLastInput()), unit = 'FE/t', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'energy_output', value = mekanismEnergyHelper.joulesToFE(induction.getLastOutput()), unit = 'FE/t', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'energy_transfer_cap', value = mekanismEnergyHelper.joulesToFE(induction.getTransferCap()), unit = 'FE/t', source = source })

        -- some further production metrics
        elseif v == 'advanced' then
            metrics:insert(Metric{ name = self.prefix .. 'comparator_level', value = induction.getComparatorLevel(), unit = nil, source = source })

        elseif v == 'energy' then
            metrics:insert(Metric{ name = self.prefix .. 'energy', value = mekanismEnergyHelper.joulesToFE(induction.getEnergy()), unit = 'FE', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'max_energy', value = mekanismEnergyHelper.joulesToFE(induction.getMaxEnergy()), unit = 'FE', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'energy_needed', value = mekanismEnergyHelper.joulesToFE(induction.getEnergyNeeded()), unit = 'FE', source = source })

        -- measurements based on the multiblock structure itself
        elseif v == 'formation' then
            metrics:insert(Metric{ name = self.prefix .. 'formed', value = (induction.isFormed() and 1 or 0), unit = nil, source = source })
            metrics:insert(Metric{ name = self.prefix .. 'height', value = induction.getHeight(), unit = 'm', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'length', value = induction.getLength(), unit = 'm', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'width', value = induction.getWidth(), unit = 'm', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'installed_cells', value = induction.getInstalledCells(), unit = nil, source = source })
            metrics:insert(Metric{ name = self.prefix .. 'installed_providers', value = induction.getInstalledProviders(), unit = nil, source = source })
        end

        loaded[v] = true

        -- not sure if these are useful, but they return types which are not Metric compatible, RIP
        -- induction.getInputItem()
        -- induction.getOutputItem()
        -- induction.getMaxPos()
        -- induction.getMinPos()
    end

    return metrics
end

return InductionMatrixInputAdapter
end,

["telem.lib.input.FluidStorageInputAdapter"] = function()
--------------------
-- Module: 'telem.lib.input.FluidStorageInputAdapter'
--------------------
local o = require 'telem.lib.ObjectModel'
local t = require 'telem.lib.util'

local InputAdapter      = require 'telem.lib.InputAdapter'
local Metric            = require 'telem.lib.Metric'
local MetricCollection  = require 'telem.lib.MetricCollection'

local FluidStorageInputAdapter = o.class(InputAdapter)
FluidStorageInputAdapter.type = 'FluidStorageInputAdapter'

function FluidStorageInputAdapter:constructor (peripheralName)
    self:super('constructor')

    -- TODO this will be a configurable feature later
    self.prefix = 'storage:'

    self:addComponentByPeripheralID(peripheralName)
end

function FluidStorageInputAdapter:read ()
    local source, fluidStorage = next(self.components)
    local tanks = fluidStorage.tanks()

    local tempMetrics = {}

    for _,v in pairs(tanks) do
        if v then
            local prefixkey = self.prefix .. v.name
            tempMetrics[prefixkey] = (tempMetrics[prefixkey] or 0) + v.amount / 1000
        end
    end

    local metrics = MetricCollection()

    for k,v in pairs(tempMetrics) do
        if v then metrics:insert(Metric({ name = k, value = v, unit = 'B', source = source })) end
    end

    return metrics
end

return FluidStorageInputAdapter
end,

["telem.lib.input.HelloWorldInputAdapter"] = function()
--------------------
-- Module: 'telem.lib.input.HelloWorldInputAdapter'
--------------------
local o = require 'telem.lib.ObjectModel'
local t = require 'telem.lib.util'

local InputAdapter      = require 'telem.lib.InputAdapter'
local Metric            = require 'telem.lib.Metric'
local MetricCollection  = require 'telem.lib.MetricCollection'

local HelloWorldInputAdapter = o.class(InputAdapter)
HelloWorldInputAdapter.type = 'HelloWorldInputAdapter'

function HelloWorldInputAdapter:constructor (checkval)
    self.checkval = checkval

    self:super('constructor')
end

function HelloWorldInputAdapter:read ()
    return MetricCollection{ hello_world = self.checkval }
end

return HelloWorldInputAdapter
end,

["telem.lib.output.HelloWorldOutputAdapter"] = function()
--------------------
-- Module: 'telem.lib.output.HelloWorldOutputAdapter'
--------------------
local o = require 'telem.lib.ObjectModel'
local t = require 'telem.lib.util'

local OutputAdapter     = require 'telem.lib.OutputAdapter'
local MetricCollection  = require 'telem.lib.MetricCollection'

local HelloWorldOutputAdapter = o.class(OutputAdapter)
HelloWorldOutputAdapter.type = 'HelloWorldOutputAdapter'

function HelloWorldOutputAdapter:constructor ()
    self:super('constructor')
end

function HelloWorldOutputAdapter:write (collection)
    assert(o.instanceof(collection, MetricCollection), 'Collection must be a MetricCollection')

    for k,v in pairs(collection.metrics) do
        print('Hello, ' .. v.name .. ' = ' .. v.value .. '!')
    end
end

return HelloWorldOutputAdapter
end,

["telem.lib.output"] = function()
--------------------
-- Module: 'telem.lib.output'
--------------------
return {
    helloWorld = require 'telem.lib.output.HelloWorldOutputAdapter',

    -- HTTP
    grafana = require 'telem.lib.output.GrafanaOutputAdapter',
}
end,

["telem.lib.output.GrafanaOutputAdapter"] = function()
--------------------
-- Module: 'telem.lib.output.GrafanaOutputAdapter'
--------------------
local o = require 'telem.lib.ObjectModel'
local t = require 'telem.lib.util'

local OutputAdapter     = require 'telem.lib.OutputAdapter'
local MetricCollection  = require 'telem.lib.MetricCollection'

local GrafanaOutputAdapter = o.class(OutputAdapter)
GrafanaOutputAdapter.type = 'GrafanaOutputAdapter'

function GrafanaOutputAdapter:constructor (endpoint, apiKey)
    self:super('constructor')

    self.endpoint = assert(endpoint, 'Endpoint is required')
    self.apiKey = assert(apiKey, 'API key is required')
end

function GrafanaOutputAdapter:write (collection)
    assert(o.instanceof(collection, MetricCollection), 'Collection must be a MetricCollection')

    local outf = {}

    for _,v in pairs(collection.metrics) do
        local unitreal = (v.unit and v.unit ~= '' and ',unit=' .. v.unit) or ''
        local sourcereal = (v.source and v.source ~= '' and ',source=' .. v.source) or ''
        local adapterreal = (v.adapter and v.adapter ~= '' and ',adapter=' .. v.adapter) or ''

        table.insert(outf, v.name .. unitreal .. sourcereal .. adapterreal .. (' metric=%f'):format(v.value))
    end

    -- t.pprint(collection)

    local res = http.post({
        url = self.endpoint,
        body = table.concat(outf, '\n'),
        headers = { Authorization = ('Bearer %s'):format(self.apiKey) }
    })
end

return GrafanaOutputAdapter
end,

["telem.lib.InputAdapter"] = function()
--------------------
-- Module: 'telem.lib.InputAdapter'
--------------------
local o = require 'telem.lib.ObjectModel'
local t = require 'telem.lib.util'

local InputAdapter = o.class()
InputAdapter.type = 'InputAdapter'

function InputAdapter:constructor()
    assert(self.type ~= InputAdapter.type, 'InputAdapter cannot be instantiated')

    self.components = {}
    self.prefix = ''
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
    t.err(self.type .. ' has not implemented read()')
end

return InputAdapter
end,

["telem.lib.OutputAdapter"] = function()
--------------------
-- Module: 'telem.lib.OutputAdapter'
--------------------
local o = require 'telem.lib.ObjectModel'
local t = require 'telem.lib.util'

local OutputAdapter = o.class()
OutputAdapter.type = 'OutputAdapter'

function OutputAdapter:constructor()
    assert(self.type ~= OutputAdapter.type, 'OutputAdapter cannot be instantiated')

    self.components = {}
end

function OutputAdapter:addComponentByPeripheralID (id)
    self.components.insert(peripheral.wrap(id))
end

function OutputAdapter:addComponentByPeripheralType (type)
    self.components.insert(peripheral.find(type))
end

function OutputAdapter:write (metrics)
    t.err(self.type .. ' has not implemented write()')
end

return OutputAdapter
end,

----------------------
-- Modules part end --
----------------------
        }
        if files[path] then
            return files[path]
        else
            return origin_seacher(path)
        end
    end
end
---------------------------------------------------------
----------------Auto generated code block----------------
---------------------------------------------------------
local _Telem = {
    util = require 'telem.lib.util',
    input = require 'telem.lib.input',
    output = require 'telem.lib.output',
    backplane = require 'telem.lib.Backplane'
}

-- _Telem.util.log('init')

return _Telem