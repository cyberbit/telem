local o = require 'telem.lib.ObjectModel'
local InputAdapter = require 'telem.lib.InputAdapter'
local OutputAdapter = require 'telem.lib.OutputAdapter'
local Middleware = require 'telem.lib.BaseMiddleware'
local vendor = require 'telem.vendor'

local moduleApi = {
    ObjectModel = o,
    util = require 'telem.lib.util',
    vendor = vendor,

    Metric = require 'telem.lib.Metric',
    MetricCollection = require 'telem.lib.MetricCollection',

    mintInput = function (name)
        local adapter = o.class(InputAdapter)
        adapter.type = name
    
        return adapter
    end,

    mintOutput = function (name)
        local adapter = o.class(OutputAdapter)
        adapter.type = name
    
        return adapter
    end,

    mintMiddleware = function (name)
        local adapter = o.class(Middleware)
        adapter.type = name
    
        return adapter
    end,
}

moduleApi.require = function (module)
    return require(module)(moduleApi)
end

local loadModule = function (module)
    -- modules can use any dependencies included in the core API (ccryptolib, ecnet2, fluent, lualzw, plotter, etc.)
    
    local path, err = package.searchpath(module, package.path)

    if not path and fs.exists(module) then
        path = module
    end

    if not path then
        error('Module ' .. module .. ' not found: ' .. err)
    end

    -- loading logic borrowed from luz.lua

    local file = assert(io.open(path, "rb"))
    local data = file:read("*a")
    file:close()
    
    local mode = data:sub(1, 5) == "\27LuzQ" and 2 or 1
    local loadable = mode == 2 and vendor.luz.decompress(data) or data

    local loadedModule = assert((pcall(load, "") and load or loadstring)(loadable, "@" .. module, "t", _ENV))()(moduleApi)
end

local autoload = function (telem)
    if package.path:find('telem/modules') == nil then package.path = package.path .. ';telem/modules/?;telem/modules/?.lua;telem/modules/?.luz;telem/modules/?/init.lua' end

    local modules = {}

    if not fs.isDir('telem/modules') then
        fs.makeDir('telem/modules')
    end
    
    local modlist = fs.list('telem/modules')

    for _, mod in ipairs(modlist) do
        local name = fs.isDir('telem/modules/' .. mod) and mod or (mod:match('(.+)%..+'))

        print('autoloading ' .. name)

        modules[name] = loadModule(name)
    end

    -- apply autoloaded modules to telem namespaces
    for modname,mod in pairs(modules) do
        -- TODO error if namespace is already used
        -- if telem.input[modname] or telem.output[modname] or telem.middleware[modname] then
        --     error('Module loading failed, namespace ' .. modname .. ' already exists')
        -- end

        if mod.input and #mod.input then
            telem.input[modname] = {}

            for k,v in pairs(mod.input) do
                telem.input[modname][k] = v
            end
        end

        if mod.output and #mod.output then
            telem.output[modname] = {}

            for k,v in pairs(mod.output) do
                telem.output[modname][k] = v
            end
        end

        if mod.middleware and #mod.middleware then
            telem.middleware[modname] = {}

            for k,v in pairs(mod.middleware) do
                telem.middleware[modname][k] = v
            end
        end
    end

    return modules
end

return {
    load = loadModule,
    autoload = autoload,
    api = moduleApi,
}