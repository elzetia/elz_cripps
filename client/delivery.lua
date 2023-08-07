-- Variables globales
local isDeliveryInProgress = false
local deliveryZoneRadius
local destinationBlip = nil
local destination = nil
local destinationlabel = nil
local isNotificationDisplayed = false
local cart = nil
local cratesList = {}

function IsCartInDeliveryZone(cart)
    local cartCoords = GetEntityCoords(cart)
    local distance = Vdist(cartCoords, destination)

    return distance <= deliveryZoneRadius
end

RegisterNetEvent('elz_cripps:createDeliveryCart')
AddEventHandler('elz_cripps:createDeliveryCart', function()
    DoScreenFadeOut(500)
    Citizen.Wait(500)

    local modelHash = joaat(Config.camp.cart.model)
    local cartPos = Config.camp.cart.pos
    local crateData = Config.camp.cart.crateData

    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        Citizen.Wait(0)
    end

    -- Creates the delivery cart at position Config.camp.cart
    cart = CreateVehicle(modelHash, cartPos.x, cartPos.y, cartPos.z, cartPos.h, true, false)
    SetEntityAsMissionEntity(cart, true, true)
    SetEntityHeading(cart, cartPos.h)
    SetVehicleOnGroundProperly(cart)
    NetworkRegisterEntityAsNetworked(cart)
    TaskWarpPedIntoVehicle(PlayerPedId(), cart, -1)

    -- Create each crate on the cart
    for i=1, #crateData do
        local modelHash = joaat(crateData[i].model)
        RequestModel(modelHash)
        while not HasModelLoaded(modelHash) do
            Citizen.Wait(0)
        end
    
        local cartCoords = GetEntityCoords(cart)
        local crate = CreateObject(modelHash, cartCoords.x, cartCoords.y, cartCoords.z, true, false, true)
        NetworkRegisterEntityAsNetworked(crate)
        AttachEntityToEntity(crate, cart, 0, crateData[i].offset.x, crateData[i].offset.y, crateData[i].offset.z, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
        cratesList[i] = crate
    end
    
    -- Fade-out effect
    Citizen.Wait(500)
    DoScreenFadeIn(500)

    -- Selects a random destination
    destination = GetRandomLocation()
    isDeliveryInProgress = true
    AddBlipRadius(destination)
    SetGps(destination.x, destination.y, destination.z)
    StartDeliveryMission(cart)
end)


function AddBlipRadius(destination)
    destinationBlip = BlipAddForRadius(1664425300, destination.x, destination.y, destination.z, deliveryZoneRadius)
    BlipAddStyle(destinationBlip, joaat('BLIP_STYLE_AREA'))
    SetBlipSprite(destinationBlip, joaat('blip_objective'), 1)
end

Citizen.CreateThread(function()
     while true do
        Citizen.Wait(1000)
        
        if isDeliveryInProgress and DoesEntityExist(cart) then

            if IsCartInDeliveryZone(cart) then
                DoScreenFadeOut(500)
                Citizen.Wait(500)
                TriggerServerEvent('elz_cripps:UpdateMerchant')
                isDeliveryInProgress = false
                isNotificationDisplayed = false
                RemoveBlip(destinationBlip)
                RemoveGps()
                DeleteCartAndCrates()
                Citizen.Wait(500)
                DoScreenFadeIn(500)
                TriggerEvent('vorp:TipBottom', 'Livraison effectuée avec succès.', 2500)
            else
                if not isNotificationDisplayed then
                    DisplayDeliveryNotification()
                    isNotificationDisplayed = true  -- Marquer la notification comme déjà affichée pour cette livraison
                end
            end
        end
    end
end)

function DisplayDeliveryNotification()
    local text = _U('deliveryMessage') .. destinationlabel
    local duration = 900000 -- set mission timer duration (900000 = 15 minutes)
    TriggerEvent('vorp:TipBottom', text, duration)
end

function GetRandomLocation()
    local locations = Config.camp.cart.deliveryLocation.near
    local keys = {}
    for key, _ in pairs(locations) do
        table.insert(keys, key)
    end

    local randomIndex = math.random(1, #keys)
    local randomKey = keys[randomIndex]
    local randomLocation = locations[randomKey]
    deliveryZoneRadius = randomLocation.radius
    destinationlabel = randomLocation.label
    return randomLocation.destination
end

function SetGps(x, y, z)
    local pl = GetEntityCoords(PlayerPedId())
    StartGpsMultiRoute(joaat('COLOR_YELLOW'), false, true)
    AddPointToGpsMultiRoute(pl.x, pl.y, pl.z)
    AddPointToGpsMultiRoute(x, y, z)
    SetGpsMultiRouteRender(true)
end

function RemoveGps()
    ClearGpsMultiRoute()
end

function DeleteCartAndCrates()
    -- Boucle sur chaque caisse et la supprime
    for i=1, #cratesList do
        local crate = cratesList[i]
        if DoesEntityExist(crate) then
            DeleteEntity(crate)
        end
    end

    -- Maintenant, supprime le véhicule
    if DoesEntityExist(cart) then
        DeleteEntity(cart)
    end
end

function StartDeliveryMission(cartEntity)
    TriggerServerEvent('elz_cripps:startDeliveryMission', cartEntity)
end



AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    RemoveGps()
    if destinationBlip ~= nil then
        RemoveBlip(destinationBlip)
    end
    TriggerEvent('vorp:TipBottom', 'Reset Notification', 100)
    if cart ~= nil then
        DeleteCartAndCrates()
    end
end)
