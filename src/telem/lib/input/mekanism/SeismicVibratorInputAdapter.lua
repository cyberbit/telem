local fn = require 'telem.vendor'.fluent.fn

local base      = require 'telem.lib.input.mekanism.BaseMekanismInputAdapter'
local Metric    = require 'telem.lib.Metric'

local SeismicVibratorInputAdapter = base.mintAdapter('SeismicVibratorInputAdapter')

function SeismicVibratorInputAdapter:beforeRegister ()
    self.prefix = 'mekseismic:'

    local _, component = next(self.components)
    local supportsStorage = type(component.getColumnAt) == 'function'

    self.queries = {
        basic = {
            energy_filled_percentage    = fn():call('getEnergyFilledPercentage'),
        },
        energy = {
            energy                      = fn():call('getEnergy'):joulesToFE():energy(),
            max_energy                  = fn():call('getMaxEnergy'):joulesToFE():energy(),
            energy_needed               = fn():call('getEnergyNeeded'):joulesToFE():energy(),
        },
    }

    -- Mekanism 10.3+ only
    if supportsStorage then
        self.storageQueries = {
            fn()
                :transform(function (v)
                    local columns = {}
            
                    local queueChunks, chunkSize = {}, 16
                    local chunkIdx = 1
            
                    for x = 0, 15 do
                        for z = 0, 15 do
                            queueChunks[chunkIdx] = queueChunks[chunkIdx] or {}
            
                            table.insert(queueChunks[chunkIdx], function ()
                                columns['c' .. x .. ',' .. z] = v.getColumnAt(x, z) or false
                            end)
            
                            if #queueChunks[chunkIdx] >= chunkSize then
                                chunkIdx = chunkIdx + 1
                            end
                        end
                    end
            
                    for _, chunk in ipairs(queueChunks) do
                        parallel.waitForAll(table.unpack(chunk))
                    end
            
                    return columns
                end)
                :flatten()
                :pluck('block')
                :reject(function (_, v)
                    return v == 'minecraft:air' or v == 'minecraft:void_air'
                end)
                :mapValues(function (v)
                    return { name = v, value = 1 }
                end)
                :sum('value', 'name')
                :map(function (k, v) return Metric{ name = k, value = v, unit = 'item' } end)
                :values()
        }
    end
    
    -- TODO does not support comparator
    -- self:withGenericMachineQueries()

    -- getDirection
    -- getRedstoneMode
end

return SeismicVibratorInputAdapter