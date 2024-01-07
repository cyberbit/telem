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
    self.context = ctx

    return self
end

-- return first metric matching name@adapter
function MetricCollection:find (filter)
    local split = {}

    for sv in (filter .. '@'):gmatch('([^@]*)@') do
        table.insert(split, sv)
    end

    local name = split[1]
    local adapter = split[2]

    local nameish = name ~= nil and #name > 0
    local adapterish = adapter ~= nil and #adapter > 0

    for _,v in pairs(self.metrics) do
        if (not nameish or v.name == name) and (not adapterish or v.adapter == adapter) then
            return v
        end
    end

    return nil
end

function MetricCollection.pack (self)
    local packedMetrics = {}
    local adapterLookup = {}
    local sourceLookup = {}
    local unitLookup = {}
    local nameLookup = {
        -- first name token
        {},

        -- second name token
        {}
    }

    for _,v in ipairs(self.metrics) do
        local packed = v:pack()

        -- create name tokens
        local nameTokens = {}

        for token in (packed.n .. ':'):gmatch('([^:]*):') do
            table.insert(nameTokens, token)
        end

        local t1 = nameTokens[1]
        local t2 = nameTokens[2]
        local t3 = nameTokens[3]

        if #nameTokens > 2 then
            t3 = table.concat(nameTokens, ':', 3)
        end

        local n1, n2, nn

        if t3 then
            n1, n2, nn = t1, t2, t3
        elseif t2 then
            n1, n2, nn = t1, nil, t2
        elseif t1 then
            n1, n2, nn = nil, nil, t1
        end

        -- pull LUT
        local ln1 = n1 and t.indexOf(nameLookup[1], n1)
        local ln2 = n2 and t.indexOf(nameLookup[2], n2)
        local la = t.indexOf(adapterLookup, packed.a)
        local ls = t.indexOf(sourceLookup, packed.s)
        local lu = t.indexOf(unitLookup, packed.u)

        -- register missing LUT
        if ln1 and ln1 < 0 then
            table.insert(nameLookup[1], n1)

            ln1 = #nameLookup[1]
        end
        if ln2 and ln2 < 0 then
            table.insert(nameLookup[2], n2)

            ln2 = #nameLookup[2]
        end
        if la < 0 then
            table.insert(adapterLookup, packed.a)

            la = #adapterLookup
        end
        if ls < 0 then
            table.insert(sourceLookup, packed.s)

            ls = #sourceLookup
        end
        if lu < 0 then
            table.insert(unitLookup, packed.u)

            lu = #unitLookup
        end

        local ln
        if ln1 or ln2 then
            ln = {ln1, ln2}
        end

        table.insert(packedMetrics, {
            ln = ln,
            n = nn,
            v = packed.v,
            la = la,
            ls = ls,
            lu = lu
        })
    end

    return {
        c = self.context,
        ln = nameLookup,
        la = adapterLookup,
        ls = sourceLookup,
        lu = unitLookup,
        m = packedMetrics
    }
end

function MetricCollection.unpack (data)
    local undata = data

    local nameLookup = undata.ln
    local adapterLookup = undata.la
    local sourceLookup = undata.ls
    local unitLookup = undata.lu

    local collection = MetricCollection()

    for _, v in ipairs(undata.m) do
        local nPrefix = ''

        if v.ln then
            for lni, lnv in ipairs(v.ln) do
                nPrefix = nPrefix .. nameLookup[lni][lnv] .. ':'
            end
        end

        local tempMetric = Metric{
            name = nPrefix .. v.n,
            value = v.v,
            adapter = v.la and adapterLookup[v.la],
            source = v.ls and sourceLookup[v.ls],
            unit = v.lu and unitLookup[v.lu]
        }

        collection:insert(tempMetric)
    end

    collection:setContext(undata.c)

    return collection
end

return MetricCollection