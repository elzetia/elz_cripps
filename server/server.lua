local VORPcore = {}
local playerCartEntities = {}

TriggerEvent('getCore', function(core)
    VORPcore = core
end)

-- Ouvrir le menu
RegisterNetEvent('elz_cripps:OpenCrippsMenu', function()
    local _source = source
    local Character = VORPcore.getUser(_source).getUsedCharacter
    local identifier = Character.identifier
    local charid = Character.charIdentifier

    --MySQL.Async.fetchAll('SELECT * FROM player_horses WHERE identifier = ? AND charid = ?', { identifier, charid },
    --function(horses)
    TriggerClientEvent('elz_cripps:OpenCrippsMenu', _source)
    --end)
end)

--------------- DELIVERY ---------------------
