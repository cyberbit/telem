local fn = require 'telem.vendor'.fluent.fn

local base = require 'telem.lib.input.advancedPeripherals.BaseAdvancedPeripheralsInputAdapter'

local PlayerDetectorInputAdapter = base.mintAdapter('PlayerDetectorInputAdapter')

function PlayerDetectorInputAdapter:beforeRegister (peripheralName, categories, playerName)
    self.prefix = 'applayer:'

    self.queries = {
        basic = {
            online_player_count = fn():call('getOnlinePlayers'):count(),
        },
    }

    -- getPlayersInRange
    -- getPlayersInCoords
    -- getPlayersInCubic
    -- isPlayerInRange
    -- isPlayerInCoords
    -- isPlayerInCubic
    -- isPlayersInRange
    -- isPlayersInCoords
    -- isPlayersInCubic

    -- TODO improve this
    if playerName then
        local playerPos = fn():call('getPlayerPos', playerName)

        self.queries.player = self.queries.player or {}

        self.queries.player.player_eye_height   = playerPos:get('eyeHeight'):with('unit', 'm')
        self.queries.player.player_pitch        = playerPos:get('pitch'):with('unit', '°')
        self.queries.player.player_yaw          = playerPos:get('yaw'):with('unit', '°')
        self.queries.player.player_health       = playerPos:get('health')
        self.queries.player.player_air_supply   = playerPos:get('airSupply')

        -- TODO there is a typo fix pending release, so for now there will be a fallback to the typo
        self.queries.player.player_max_health   = playerPos:transform(function (v)
            return v.maxHealth or v.maxHeatlh
        end)

        -- dimension
        -- respawnPosition
        -- respawnDimension
        -- respawnAngle
        -- x
        -- y
        -- z
    end
end

return PlayerDetectorInputAdapter