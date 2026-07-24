-- Telem Vendor Loader by cyberbit
-- MIT License
-- Version 0.10.0
-- Submodules are copyright of their respective authors. For licensing, see https://github.com/cyberbit/telem/blob/main/LICENSE

if package.path:find('telem/vendor') == nil then package.path = package.path .. ';telem/vendor/?;telem/vendor/?.lua;telem/vendor/?/init.lua' end

-- create a lazy vendor mapping to load modules when indexed
local function lazyVendor (map)
    return setmetatable({}, {
        __index = function (t, k)
            local entry = map[k]

            -- soft fail for unknown modules
            if not entry then return nil end

            -- load the module, or map submodules recursively
            local value = type(entry) == 'string' and require(entry) or lazyVendor(entry)

            t[k] = value

            return value
        end
    })
end

-- TODO there are better ways to organize this now that it is a virtual mapping
return lazyVendor({
    ccryptolib = {
        random = 'ccryptolib.random',
    },
    ecnet2 = 'ecnet2',
    lualzw = 'lualzw',
    plotter = 'plotter',
    fluent = 'fluent-entrypoint',
    luz = {
        decompress = 'luz.decompress',
    },
})