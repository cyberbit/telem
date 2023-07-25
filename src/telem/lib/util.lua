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