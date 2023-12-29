-- TODO write my own pretty_print
local pretty = require 'cc.pretty' or { pretty_print = print }

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

local function shortnum(n)
    if n >= 10^11 then
        return string.format("%i G", n / 10^9)
    elseif n >= 10^10 then
        return string.format("%.1fG", n / 10^9)
    elseif n >= 10^9 then
        return string.format("%.2fG", n / 10^9)
    elseif n >= 10^8 then
        return string.format("%i M", n / 10^6)
    elseif n >= 10^7 then
        return string.format("%.1fM", n / 10^6)
    elseif n >= 10^6 then
        return string.format("%.2fM", n / 10^6)
    elseif n >= 10^5 then
        return string.format("%i k", n / 10^3)
    elseif n >= 10^4 then
        return string.format("%.1fk", n / 10^3)
    elseif n >= 10^3 then
        return string.format("%.2fk", n / 10^3)
    elseif n >= 10^2 then
        return string.format("%.1f", n)
    elseif n >= 10^1 then
        return string.format("%.2f", n)
    else
        return string.format("%.3f", n)
    end
end

-- based on https://rosettacode.org/wiki/Suffixation_of_decimal_numbers#Python
local function shortnum2(num, digits, base)
    if not base then base = 10 end

    local suffixes = {'', 'k', 'M', 'G', 'T', 'P', 'E', 'Z', 'Y', 'X', 'W', 'V', 'U', 'googol'}

    local exponent_distance = 10
    if base == 2 then
        exponent_distance = 10
    else
        exponent_distance = 3
    end

    num = string.gsub(num, ',', '')
    local num_sign = string.sub(num, 1, 1) == '+' or string.sub(num, 1, 1) == '-' and string.sub(num, 1, 1) or ''

    num = math.abs(tonumber(num))

    local suffix_index = 0
    if base == 10 and num >= 1e100 then
        suffix_index = 13
        num = num / 1e100
    elseif num > 1 then
        local magnitude = math.floor(math.log(num, base))
        suffix_index = math.min(math.floor(magnitude / exponent_distance), 12)
        num = num / (base ^ (exponent_distance * suffix_index))
    end

    local num_str = ''
    if digits then
        num_str = string.format('%.' .. digits .. 'f', num)
    else
        num_str = string.format('%.3f', num):gsub('0+$', ''):gsub('%.$', '')
    end

    return num_sign .. num_str .. suffixes[suffix_index + 1] .. (base == 2 and 'i' or '')
end

local function constrainAppend (data, value, width)
    local removed = 0

    table.insert(data, value)

    while #data > width do
        table.remove(data, 1)
        removed = removed + 1
    end

    return removed
end

return {
    log = log,
    err = err,
    pprint = pprint,
    skpairs = skpairs,
    sleep = os.sleep or tsleep,
    shortnum = shortnum,
    shortnum2 = shortnum2,
    constrainAppend = constrainAppend,
}