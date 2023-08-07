InitialCall = false

-- Fonction pour mettre à jour la variable Goods après avoir reçu la réponse du serveur
function UpdateGoods(good, material, production)
    Goods = good
    Materials = material
    Production = production
    InitialCall = true
end

-- Écoute l'événement pour recevoir la mise à jour de Goods
RegisterNetEvent('elz_cripps:ReceiveGoodProgress')
AddEventHandler('elz_cripps:ReceiveGoodProgress', UpdateGoods)

-- Thread to continuously update the group coordinates on the server
Citizen.CreateThread(function()
    while true do
        --Citizen.Wait(1000 * 120)
        Citizen.Wait(1000 * 30)
        if InitialCall then
            if Goods < 100 then
                if Materials >= 2 then
                    if Production >= 1 then
                        Goods += 1
                        Production -= 1
                        Materials -= 2
                        TriggerServerEvent('elz_cripps:UpdateGoodProgress', Goods, Materials,
                            Production)
                    end
                end
            end
        end
    end
end)


-- Command to invite a player to Cripps' delivery group
RegisterCommand('cripps', function(source, args)
    local goods = tonumber(args[1])
    local materials = tonumber(args[2])
    local product = tonumber(args[3])
    if goods and materials and product then
        -- Trigger the server-side event to handle the invitation
        TriggerServerEvent('elz_cripps:UpdateGoodProgress', goods, materials, product)
        Goods = goods
        Materials = materials
        Production = product
    end
end, false)

RegisterNetEvent("vorp:SelectedCharacter")
AddEventHandler("vorp:SelectedCharacter", function()
    TriggerServerEvent('elz_cripps:GetGoods')
end)
