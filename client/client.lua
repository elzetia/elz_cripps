local VORPcore = {}
InMenu = false

local Group = GetRandomIntInRange(0, 0xffffff)
local OpenPrompt


TriggerEvent('getCore', function(core)
    VORPcore = core
end)


CreateThread(function()
    Open()

    while true do
        Wait(0)
        local player = PlayerPedId()
        local coords = GetEntityCoords(player)
        local dead = IsEntityDead(player)
        local camp = Config.camp

        if not dead then
            if not camp.Blip and camp.blipOn then
                AddBlip()
            end

            local pcoords = vector3(coords.x, coords.y, coords.z)
            local scoords = vector3(camp.npc.x, camp.npc.y, camp.npc.z)
            local sDistance = #(pcoords - scoords)

            if sDistance <= camp.nDistance then
                if not camp.NPC and camp.npcOn then
                    AddNPC()
                end
            else
                if camp.NPC then
                    DeleteEntity(camp.NPC)
                    camp.NPC = nil
                end
            end

            if (sDistance <= camp.sDistance) then
                if (InMenu == false) then
                    local campOpen = CreateVarString(10, 'LITERAL_STRING', camp.promptName)
                    PromptSetActiveGroupThisFrame(Group, campOpen)

                    if UiPromptHasStandardModeCompleted(OpenPrompt) then
                        DisplayRadar(false)
                        TriggerServerEvent('elz_cripps:OpenCrippsMenu')
                        TriggerServerEvent('elz_cripps:DBCheck')
                    end
                end
            end
        end
    end
end)


-- Blips
function AddBlip()
    local camp = Config.camp
    camp.Blip = N_0x554d9d53f696d002(1664425300, camp.npc.x, camp.npc.y, camp.npc.z) -- BlipAddForCoords
    SetBlipSprite(camp.Blip, camp.blipSprite, 1)
    SetBlipScale(camp.Blip, 0.2)
    SetBlipName(camp.Blip, camp.blipName)
end

-- NPCs
function AddNPC()
    local camp = Config.camp
    LoadModel(camp.npcModel)
    local npc = CreatePed(camp.npcModel, camp.npc.x, camp.npc.y, camp.npc.z, camp.npc.h, 0, true, true)
    PlaceEntityOnGroundProperly(npc)
    SetRandomOutfitVariation(npc, true)
    SetEntityCanBeDamaged(npc, false)
    SetEntityInvincible(npc, true)
    Wait(500)
    FreezeEntityPosition(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)
    Config.camp.NPC = npc
end

function LoadModel(npcModel)
    local model = joaat(npcModel)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(10)
    end
end

RegisterNetEvent('elz_cripps:ClientLevelCatch')
AddEventHandler('elz_cripps:ClientLevelCatch', function(merchantLVL)
    print("Le level marchand du joueur est : " .. merchantLVL)
end)

function Open()
    local str = _U('openPrompt')
    OpenPrompt = PromptRegisterBegin()
    PromptSetControlAction(OpenPrompt, Config.keys.open)
    str = CreateVarString(10, 'LITERAL_STRING', str)
    PromptSetText(OpenPrompt, str)
    PromptSetEnabled(OpenPrompt, 1)
    PromptSetVisible(OpenPrompt, 1)
    PromptSetStandardMode(OpenPrompt, 1)
    PromptSetGroup(OpenPrompt, Group)
    PromptRegisterEnd(OpenPrompt)
end

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    local player = PlayerPedId()
    FreezePlayer(false)
    ClearPedTasksImmediately(player)
    InMenu = false

    if Config.camp.Blip then
        RemoveBlip(Config.camp.Blip)
    end
    if Config.camp.NPC then
        DeleteEntity(Config.camp.NPC)
        Config.camp.NPC = nil
    end
end)


-- Créer une commande client pour "/cougar"
RegisterCommand("animal", function(source, args, rawCommand)
    if #args == 1 then
        local outfitCount = tonumber(args[1]) -- Convertir l'argument en un nombre entier
        if outfitCount ~= nil and outfitCount > 0 then
            -- Obtenir les coordonnées actuelles du joueur
            local playerPos = GetEntityCoords(PlayerPedId())
            local playerHeading = GetEntityHeading(PlayerPedId())

            -- Calculer la distance d'écartement entre les animaux
            local spacingDistance = 3.0
            local spawnDistance = 15.0

            for i = 1, outfitCount do
                -- Calculer les nouvelles coordonnées en fonction de la direction du joueur et de l'écartement
                local spawnX = playerPos.x + (spawnDistance * math.sin(playerHeading * math.pi / 180))
                local spawnY = playerPos.y + (spawnDistance * math.cos(playerHeading * math.pi / 180))

                LoadModel('a_c_armadillo_01')
                local animal = CreatePed(joaat('a_c_armadillo_01'), spawnX, spawnY, playerPos.z, 0.0, 1, true, true)
                FreezeEntityPosition(animal, true)
                PlaceEntityOnGroundProperly(animal)
                Citizen.InvokeNative(0x77FF8D35EEC6BBC4, animal, i - 1, 0)

                -- Décaler la position pour le prochain animal
                spawnDistance = spawnDistance + spacingDistance
                local variant = Citizen.InvokeNative(0x98082246107A6ACF, animal, 0x5F46BA8E)
                local variant2 = Citizen.InvokeNative(0x98082246107A6ACF, animal, 0x2EF3D9E9)
            end
        else
            TriggerEvent("chatMessage", "SYSTEM", { 255, 0, 0 }, "Erreur : Argument invalide")
        end
    else
        -- Utilisation incorrecte de la commande
        TriggerEvent("chatMessage", "SYSTEM", { 255, 0, 0 }, "Utilisation : /cougar <nombre de variations d'outfit>")
    end
end, false)
