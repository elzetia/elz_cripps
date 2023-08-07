local VORPcore = {}

TriggerEvent("getCore", function(core)
    VORPcore = core
end)


-- Variable to store the destination coordinates
local endPoint = { x = -615.29, y = -9.6, z = 86.65 }

-- List to store enemy characters (peds) created during the mission
local enemyPeds = {}
-- Variable to store the player's group
local playerGroup
-- Variable to store the NPC's group
local npcGroup
-- Boolean to check if the mission is currently active
local inMission = false
-- Variable to store the destination blip (a marker on the map)
local destinationBlip
-- Variable to store the current vehicle to delete it on resource stop : Just in case
local tempVehicule = nil

-- Function to start the mission
function StartMission()
    DoScreenFadeOut(500)
    Citizen.Wait(500)
    local instanceNumber = PlayerId() -- any number
    VORPcore.instancePlayers(tonumber(GetPlayerServerId(PlayerId())) + instanceNumber)
    Citizen.Wait(500)
    DoScreenFadeIn(500)

    -- Trigger a notification at the top of the screen with the mission title
    TriggerEvent('vorp:ShowTopNotification', "~o~Mission de Ravitaillement",
        "Vous avez lancé une mission de ravitaillement", 2000)

    local missionIndex = math.random(#Config.supply) -- Select a random mission
    local mission = Config.supply[missionIndex]      -- Retrieve the mission details

    -- Provide the player with a waypoint to the start point
    local wagonCoords = mission.wagon
    SetGps(wagonCoords.x, wagonCoords.y, wagonCoords.z)

    -- Get the model hash key for the wagon
    local model = joaat('cart05')
    -- Request the game load the model
    RequestModel(model)

    -- Loop until the model has loaded
    while not HasModelLoaded(model) do
        Citizen.Wait(0)
    end

    -- Create a wagon at the specified location
    local cart = CreateVehicle(model, wagonCoords.x, wagonCoords.y, wagonCoords.z, mission.h, true, false, false)
    -- Sets the entity to be a mission entity (won't be cleaned up by the game, etc.)
    SetEntityAsMissionEntity(cart, true, true)
    -- Set the heading of the wagon
    SetEntityHeading(cart, mission.h)
    -- Ensure the wagon is correctly placed on the ground
    SetVehicleOnGroundProperly(cart)
    -- Wait for 1 second
    Citizen.Wait(1000)
    tempVehicule = cart

    -- Add a blip for the wagon on the map
    local blip = BlipAddForEntity(joaat("BLIP_STYLE_OBJECTIVE"), cart)
    SetBlipSprite(blip, 1012165077, 1)
    SetBlipScale(blip, 1.0)
    SetBlipName(blip, 'Chariot de ravitaillement')
    BlipAddModifier(blip, joaat(Config.BlipColors.WHITE))

    -- Add enemy NPCs at each spawn coordinate
    for i, spawnCoords in ipairs(mission.npc) do
        AddNPCHostile('G_M_M_UniBanditos_01', spawnCoords)
    end
    Citizen.Wait(1000)
    -- Add blips for each enemy NPC
    for _, ped in ipairs(enemyPeds) do
        local npcBlip = BlipAddForEntity(joaat("BLIP_STYLE_OBJECTIVE"), ped)
        SetBlipSprite(npcBlip, 692310, 1)
        BlipAddModifier(npcBlip, joaat(Config.BlipColors.DARK_RED))
    end

    -- Set inMission to true indicating that the mission is now active
    inMission = true
    -- Create a thread to check player's actions and handle the cart pickup
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)

            local playerPed = PlayerPedId()
            local currentVehicle = GetVehiclePedIsIn(playerPed, false)

            CheckPlayerActions(playerPed, cart)

            if currentVehicle == cart then
                PickupWagon(cart)
                return
            end
        end
    end)

    -- Create a thread to monitor the status of the mission and handle mission failure
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            if inMission then
                if not DoesEntityExist(cart) or GetVehicleBodyHealth(cart) == 0 or not GetPedInDraftHarness(cart, 0) then
                    EndMissionFailure(cart)
                    return
                end
            else
                return
            end
        end
    end)
end

-- Function to initiate the transport of the wagon
function PickupWagon(vehicle)
    -- Remove the current GPS route
    RemoveGps()
    -- Set a new GPS route to the end point
    SetGps(endPoint.x, endPoint.y, endPoint.z)
    -- Create a blip at the destination
    destinationBlip = Citizen.InvokeNative(0x45f13b7e0a15c880, -1282792512, endPoint.x, endPoint.y, endPoint.z, 20.0)
    -- Set the blip's sprite
    SetBlipSprite(destinationBlip, joaat('blip_objective'), 1)

    -- Create a thread that checks if the vehicle is close to the end point
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)

            local vehicleCoords = GetEntityCoords(vehicle)

            if Vdist(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z, endPoint.x, endPoint.y, endPoint.z) < 20.0 then
                EndMission(vehicle)
                return
            end
        end
    end)
end

-- Function to end the mission successfully
function EndMission(vehicle)
    -- Trigger a success notification
    TriggerEvent('vorp:ShowTopNotification', "~o~Mission terminée !", "Vous avez ammené le chariot chez Cripps", 2000)
    -- Delete the vehicle entity
    DeleteEntity(vehicle)
    -- Mark mission as inactive
    inMission = false
    -- Delete all enemy peds
    for _, ped in ipairs(enemyPeds) do
        DeletePed(ped)
    end
    -- Remove the destination blip if it exists
    if destinationBlip ~= nil then
        RemoveBlip(destinationBlip)
    end
    RemoveGps()
    -- Clear the enemyPeds list
    enemyPeds = {}
    VORPcore.instancePlayers(0)
    -- Trigger a server event to fill products
    TriggerServerEvent('elz_cripps:FillProducts')
end

-- Function to end the mission due to failure
function EndMissionFailure(vehicle)
    -- Trigger a failure notification
    TriggerEvent('vorp:ShowTopNotification', "~e~Mission échouée !", "Le chariot a été détruit", 2000)
    -- Mark mission as inactive
    inMission = false
    -- Wait for 5 seconds
    Citizen.Wait(5000)
    -- Delete the vehicle entity
    DeleteEntity(vehicle)
    -- Delete all enemy peds
    for _, ped in ipairs(enemyPeds) do
        DeletePed(ped)
    end
    -- Remove the destination blip if it exists
    if destinationBlip ~= nil then
        RemoveBlip(destinationBlip)
    end
    RemoveGps()
    -- Clear the enemyPeds list
    enemyPeds = {}
    VORPcore.instancePlayers(0)
end

-- Register the command "startmission" that starts the mission when entered
RegisterCommand("startmission", function(source, args)
    StartMission()
end, false)

-- Function to create a hostile NPC
function AddNPCHostile(modelHash, coords)
    -- Request the NPC model
    LoadModel(modelHash)
    -- Create the NPC ped at the specified location
    local npc = CreatePed(modelHash, coords.x, coords.y, coords.z, coords.h, 0, true, true)
    -- Ensure the NPC is correctly placed on the ground
    PlaceEntityOnGroundProperly(npc)
    -- Give the NPC a random outfit
    SetRandomOutfitVariation(npc, true)
    -- Set the NPC's relationship group
    SetPedRelationshipGroupHash(npc, joaat('bandits'))

    -- Get the relationship groups for the player and the NPC
    playerGroup = GetPedRelationshipGroupHash(PlayerPedId())
    npcGroup = GetPedRelationshipGroupHash(npc)

    -- Set the relationship between the groups (5 is for enemies)
    SetRelationshipBetweenGroups(5, playerGroup, npcGroup)
    SetRelationshipBetweenGroups(5, npcGroup, playerGroup)

    -- Set the NPC as a mission entity (won't be cleaned up by the game, etc.)
    SetEntityAsMissionEntity(npc, true, true)
    -- Ensure the NPC won't flee
    Citizen.InvokeNative(0x740CB4F3F602C9F4, npc, true);

    -- Add the NPC to the list of enemy peds
    table.insert(enemyPeds, npc)
    -- Unload the NPC model
    SetModelAsNoLongerNeeded(modelHash)
end

-- Function to create a hostile NPC
function AddNPCHostile(modelHash, coords, missionOwner)
    -- Request the NPC model
    LoadModel(modelHash)
    -- Create the NPC ped at the specified location
    local npc = CreatePed(modelHash, coords.x, coords.y, coords.z, coords.h, 0, true, true)

    -- Ensure the NPC is correctly placed on the ground
    PlaceEntityOnGroundProperly(npc)
    -- Give the NPC a random outfit
    SetRandomOutfitVariation(npc, true)
    -- Set the NPC's relationship group
    SetPedRelationshipGroupHash(npc, joaat('bandits'))

    -- Get the relationship groups for the player and the NPC
    playerGroup = GetPedRelationshipGroupHash(PlayerPedId())
    npcGroup = GetPedRelationshipGroupHash(npc)

    -- Set the relationship between the groups (5 is for enemies)
    SetRelationshipBetweenGroups(5, playerGroup, npcGroup)
    SetRelationshipBetweenGroups(5, npcGroup, playerGroup)

    -- Set the NPC as a mission entity (won't be cleaned up by the game, etc.)
    SetEntityAsMissionEntity(npc, true, true)
    -- Ensure the NPC won't flee
    Citizen.InvokeNative(0x740CB4F3F602C9F4, npc, true);

    -- Add the NPC to the list of enemy peds
    table.insert(enemyPeds, npc)
    -- Unload the NPC model
    SetModelAsNoLongerNeeded(modelHash)
end

-- Function to check player actions
function CheckPlayerActions(playerPed, vehicle)
    -- If the player is in the specified vehicle, instruct the enemy peds to attack the player
    if IsPedInVehicle(playerPed, vehicle, false) then
        for _, ped in ipairs(enemyPeds) do
            TaskCombatPed(ped, PlayerPedId(), 0, 16)
        end
    else
        for _, ped in ipairs(enemyPeds) do
            -- If the player is aiming at the ped or in melee range, make all peds attack the player
            if IsPlayerFreeAimingAtEntity(PlayerId(), ped) or (IsPedInMeleeCombat(playerPed) and IsEntityAtEntity(ped, playerPed, 2.0, 2.0, 2.0, false, true, 0)) then
                for _, attacker in ipairs(enemyPeds) do
                    -- Get coordinates of the attacker and playerPed
                    local attackerCoord = GetEntityCoords(attacker)
                    local playerPedCoord = GetEntityCoords(playerPed)

                    -- Check if the line of sight is clear between the attacker and player, and if the attacker is facing the player
                    if IsPedFacingPed(attacker, playerPed, 90.0) then
                        TaskCombatPed(attacker, PlayerPedId(), 0, 16)
                    end
                end
                break -- if one ped is provoked, no need to check others, so break the loop
            end
        end
    end
end

-- Event handler for when the resource stops
AddEventHandler('onResourceStop', function(resourceName)
    -- If the current resource is not the one that's stopping, return
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    -- Remove the GPS route
    RemoveGps()
    -- Delete all enemy peds
    for _, ped in ipairs(enemyPeds) do
        DeletePed(ped)
    end
    if DoesEntityExist(tempVehicule) then
        DeleteVehicle(tempVehicule)
    end

    -- Remove the destination blip if it exists
    if destinationBlip ~= nil then
        RemoveBlip(destinationBlip)
    end
    VORPcore.instancePlayers(0)
end)
