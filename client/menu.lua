MenuData = {}
VORPcore = {}

local BackPrompt, OrderSupplyPrompt, DeliveryStartPrompt, GiveRawMaterialPrompt, SupplyStartPrompt

local isPlayerFrozen = false

ProductionState = true


TriggerEvent('getCore', function(core)
    VORPcore = core
end)

TriggerEvent('menuapi:getData', function(call)
    MenuData = call
end)


RegisterNetEvent('elz_cripps:OpenCrippsMenu', function()
    MainMenu()
    FreezePlayer(true)
end)


-- Main menu
function MainMenu()
    MenuData.CloseAll()
    Back()
    GiveRawMaterial(true)
    TriggerServerEvent('elz_cripps:GetGoods')

    Wait(100)

    InMenu = true
    local ProductionStateText, materialStateText, goodsText


    -- Production Pause/En cours
    if Production >= 5 then
        ProductionStateText = [[<span style="font-family:'Lato'">]] .. _U('productionStateWork') .. [[</span>]]
    else
        ProductionStateText = [[<span style="font-family:'Lato';color:red;">]] ..
            _U('productionStatePause') .. [[</span>]]
    end

    -- Quantité de Matériaux

    if Materials >= 33 and Materials <= 66 then
        materialStateText = [[<span style="font-family:'Lato'">]] .. _U('materialsQuantityEnough') .. [[</span>]]
    elseif (Materials >= 66) then
        materialStateText = [[<span style="font-family:'Lato'">]] .. _U('materialsQuantityRich') .. [[</span>]]
    else
        materialStateText = [[<span style="font-family:'Lato';color:red;">]] ..
            _U('materialsQuantityPoor') .. [[</span>]]
    end

    -- Quantité de Marchandises
    goodsText = [[<span style="display:inline-block; font-family:'Lato'">]] .. Goods .. [[/100</span>]]

    -- Création des items
    local elements = {
        CreateMenuItem(_U('materials'), 'materials', _U('materialsDesc'), 'butcher_table_raw_materials',
            materialStateText, false),
        CreateMenuItem(_U('production'), 'production', _U('mainDesc'), 'butcher_table_production', ProductionStateText,
            false),
        CreateMenuItem(_U('goods'), 'goods', 'Description of Goods', 'butcher_table_goods', goodsText, false),
    }
    SendNUIMessage({ action = "show" })
    SendNUIMessage({
        action = 'updateProgress',
        materials = tonumber(Materials),       -- Change this to the desired progress
        production = tonumber(Production) * 4, -- Change this to the desired progress
        goods = tonumber(Goods),               -- Change this to the desired progress
    })

    MenuData.Open('default', GetCurrentResourceName(), 'menuapi',
        {
            title = '<span style=color:#999;>' .. _U('titleMenu') .. '</span>',
            subtext = '<span style=color:#C0C0C0;>' .. _U('subtextMenu') .. '</span>',
            align = 'top-left',
            elements = elements,
            itemHeight = "5vh",
            itemDisplay = "flex",
            lastmenu = '',
        },
        function(data, menu)
            if data.current == 'backup' then
                _G[data.trigger]()
            end
        end,
        function(data, menu)
            MenuClose(menu)
        end)
end

function MenuClose(menu)
    menu.close()
    InMenu = false
    FreezePlayer(false)
    DisplayRadar(true)
    DeleteMenuPrompt()
    SendNUIMessage({ action = "hide" })
end

-- Event to manage key presses for prompts
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if DeliveryStartPrompt and UiPromptHasHoldModeCompleted(DeliveryStartPrompt) then
            -- Do something when the ENTER key is held down for the DeliveryStart prompt
            TriggerEvent('elz_cripps:createDeliveryCart')
            local menu = MenuData.GetOpened('default', GetCurrentResourceName(), 'menuapi')
            MenuClose(menu)
        end

        if SupplyStartPrompt and UiPromptHasHoldModeCompleted(SupplyStartPrompt) then
            -- Do something when the ENTER key is held down for the SupplyStart prompt
            local menu = MenuData.GetOpened('default', GetCurrentResourceName(), 'menuapi')
            MenuClose(menu)
            Citizen.Wait(1000)
            RemoveGps()
            StartMission()
        end

        if GiveRawMaterialPrompt and UiPromptHasStandardModeCompleted(GiveRawMaterialPrompt) then
            -- Do something when the ENTER key is pressed for the GiveRawMaterial prompt
        end

        if OrderSupplyPrompt and UiPromptHasStandardModeCompleted(OrderSupplyPrompt) then
            -- Do something when the ORDER key is pressed for the OrderSupply prompt
            TriggerServerEvent('elz_cripps:FillProducts', true)
            local menu = MenuData.GetOpened('default', GetCurrentResourceName(), 'menuapi')
            MenuClose(menu)
        end

        if BackPrompt and UiPromptHasStandardModeCompleted(BackPrompt) then
            -- Do something when the BACK key is pressed for the Back prompt
        end
    end
end)



function CreatePrompt(action, text, enabled, group, visible, hold)
    local prompt = PromptRegisterBegin()
    PromptSetControlAction(prompt, action)
    local str = CreateVarString(10, 'LITERAL_STRING', text)
    PromptSetText(prompt, str)
    PromptSetEnabled(prompt, enabled)
    PromptSetVisible(prompt, visible)
    if hold then
        PromptSetHoldMode(prompt, 2000)
    else
        PromptSetStandardMode(prompt, 1)
    end
    PromptSetGroup(prompt, group)
    PromptRegisterEnd(prompt)
    return prompt
end

-- Raw Materials
function GiveRawMaterial(state)
    if state then
        GiveRawMaterialPrompt = CreatePrompt(Config.keys.enter, _U('giveRawMaterialPrompt'), true, Group, true)
    else
        if GiveRawMaterialPrompt ~= nil then
            PromptDelete(GiveRawMaterialPrompt)
            GiveRawMaterialPrompt = nil
        end
    end
end

-- Production
function SupplyStart(state)
    if state then
        local enabled = tonumber(Production) == 0
        SupplyStartPrompt = CreatePrompt(Config.keys.enter, _U('supplyStartPrompt'), enabled, Group, true, true)
    else
        if SupplyStartPrompt ~= nil then
            PromptDelete(SupplyStartPrompt)
            SupplyStartPrompt = nil
        end
    end
end

function OrderSupply(state)
    if state then
        local enabled = tonumber(Production) == 0
        OrderSupplyPrompt = CreatePrompt(Config.keys.order, _U('orderSuppliesPrompt'), enabled, Group, true)
    else
        if OrderSupplyPrompt ~= nil then
            PromptDelete(OrderSupplyPrompt)
            OrderSupplyPrompt = nil
        end
    end
end

function DeliveryStart(state)
    if state then
        local enabled = tonumber(Goods) == 100
        DeliveryStartPrompt = CreatePrompt(Config.keys.enter, _U('startDeliveryPrompt'), enabled, Group, true, true)
    else
        if DeliveryStartPrompt ~= nil then
            PromptDelete(DeliveryStartPrompt)
            DeliveryStartPrompt = nil
        end
    end
end

function Back()
    BackPrompt = CreatePrompt(Config.keys.back, _U('backPrompt'), true, Group, true)
end

-- Ajouter une fonction pour geler ou dégeler le joueur
function FreezePlayer(state)
    local playerPed = PlayerPedId()

    if state then
        SetEntityInvincible(playerPed, true)
        -- SetEntityCollision(playerPed, false, false)
        FreezeEntityPosition(playerPed, true)
        SetEntityAlpha(PlayerPedId(), 128, false)
        SetEntityVelocity(playerPed, 0.0, 0.0, 0.0)

        isPlayerFrozen = true
    else
        SetEntityInvincible(playerPed, false)
        -- SetEntityCollision(playerPed, true, true)
        FreezeEntityPosition(playerPed, false)
        SetEntityAlpha(PlayerPedId(), 255, false)
        SetEntityVelocity(playerPed, 1.0, 1.0, 1.0)

        isPlayerFrozen = false
    end
end

function DeleteMenuPrompt()
    PromptDelete(GiveRawMaterialPrompt)
    PromptDelete(OrderSupplyPrompt)
    PromptDelete(DeliveryStartPrompt)
    PromptDelete(BackPrompt)
    PromptDelete(SupplyStartPrompt)
end

-- Event to receive MenuData.ItemSelected update
RegisterNetEvent('menuapi:updateSelectedItem')
AddEventHandler('menuapi:updateSelectedItem', function(selectedItem)
    MenuData.ItemSelected = selectedItem
    local value = MenuData.ItemSelected.value
    local isProduction = value == 'production'

    GiveRawMaterial(value == 'materials')
    OrderSupply(isProduction)
    SupplyStart(isProduction)
    DeliveryStart(value == 'goods')
end)



AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    local player = PlayerPedId()
    DeleteMenuPrompt()
    FreezePlayer(false)
    ClearPedTasksImmediately(player)
    InMenu = false
end)

local isContentShown = false
