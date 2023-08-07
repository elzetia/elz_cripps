function UiPromptHasStandardModeCompleted(...)
    return Citizen.InvokeNative(0xC92AC953F0A982AE, ...)
end

function UiPromptHasHoldModeCompleted(...)
    return Citizen.InvokeNative(0xE0F65F0640EF0617, ...)
end

function PlaceEntityOnGroundProperly(...)
    return Citizen.InvokeNative(0x9587913B9E772D29, ...)
end

function SetRandomOutfitVariation(...)
    return Citizen.InvokeNative(0x283978A15512B2FE, ...)
end

function BlipAddForCoords(...)
    return Citizen.InvokeNative(0x554D9D53F696D002, ...)
end

function BlipAddForRadius(...)
    return Citizen.InvokeNative(0x45F13B7E0A15C880, ...)
end

function BlipAddStyle(...)
    return Citizen.InvokeNative(0xBD62D98799A3DAF0, ...)
end

function CreatePedInsideVehicle(...)
    return Citizen.InvokeNative(0x7DD959874C1FD534, ...)
end

function TaskVehicleDriveToCoord(...)
    return Citizen.InvokeNative(0xE2A2AA2F659D77A7, ...)
end

-- BLIP
function SetBlipName(...)
    return Citizen.InvokeNative(0x9CB1A1623062F402, ...)
end

function BlipAddModifier(...)
    return Citizen.InvokeNative(0x662D364ABF16DE2F, ...)
end

function BlipRemoveModifier(...)
    return Citizen.InvokeNative(0xB059D7BD3D78C16F, ...)
end

function SetBlipSprite(...)
    return Citizen.InvokeNative(0x74F74D3207ED525C, ...)
end

function SetBlipScale(...)
    return Citizen.InvokeNative(0xD38744167B2FA257, ...)
end

-- BLIP ENTITY
function BlipAddForEntity(...)
    return Citizen.InvokeNative(0x23F74C2FDA6E7C61, ...)
end

function GetBlipFromEntity(...)
    return Citizen.InvokeNative(0x6D2C41A8BD6D6FD0, ...)
end

function IsThisModelAHorse(...)
    return Citizen.InvokeNative(0x772A1969F649E902, ...)
end

function GetPedInDraftHarness(...)
    return Citizen.InvokeNative(0xA8BA0BAE0173457B, ...)
end

function DoesEntityHaveBlip(...)
    return Citizen.InvokeNative(0x9FA00E2FC134A9D0, ...)
end

function NetworkSetEntityOnlyExistsForParticipants(...)
    return Citizen.InvokeNative(0xF1CA12B18AEF5298, ...)
end

-- Event handler for when the resource start
AddEventHandler('onResourceStart', function(resourceName)
    -- If the current resource is not the one that's stopping, return
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    Citizen.InvokeNative(0x4CC5F2FC1332577F, 1058184710) -- retire les cartes de skill en haut à droite
end)