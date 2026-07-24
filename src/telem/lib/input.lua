local function requireInput(target) return require ('telem.lib.input.' .. target) end

local export = {
    helloWorld                  = requireInput('HelloWorldInputAdapter'),
    custom                      = requireInput('CustomInputAdapter'),

    -- storage
    itemStorage                 = requireInput('ItemStorageInputAdapter'),
    fluidStorage                = requireInput('FluidStorageInputAdapter'),

    -- communication
    secureModem                 = requireInput('SecureModemInputAdapter'),
}

-- aliases that will be deprecated in the future
-- TODO figure out if a module should be allowed to add exports at this level
-- export.refinedStorage              = export.advancedPeripherals.rsBridge
-- export.meStorage                   = export.advancedPeripherals.meBridge

return export