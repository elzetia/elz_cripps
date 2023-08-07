VORPcore = {}

TriggerEvent('getCore', function(core)
  VORPcore = core
end)

--------- Checks if you exist in the DB, and if you do not it adds you to the DB aswell ----------------
RegisterServerEvent('elz_cripps:DBCheck')
AddEventHandler('elz_cripps:DBCheck', function()
  local _source = source
  local Character = VORPcore.getUser(_source).getUsedCharacter
  local param = { ['charidentifier'] = Character.charIdentifier, ['identifier'] = Character.identifier }
  --------The if you exist in db code was pulled from vorp_banking and modified ----------------
  exports.oxmysql:execute(
    "SELECT identifier, charid FROM merchant WHERE identifier = @Playeridentifier AND charid = @CharIdentifier",
    { ["@Playeridentifier"] = Character.identifier, ["CharIdentifier"] = Character.charIdentifier }, function(result)
      if result[1] then
        --Player already exists do nothing
      else
        exports.oxmysql:execute("INSERT INTO merchant ( `charid`,`identifier` ) VALUES ( @charidentifier,@identifier )",
          param)
      end
    end)
  Wait(200)
  local merchantLVL = false
  repeat
    local ran = false
    exports.oxmysql:execute("SELECT merchant_lvl FROM merchant WHERE charid=@charidentifier AND identifier=@identifier",
      param, function(result)
        if result[1].merchant_lvl then
          merchantLVL = true
          TriggerClientEvent('elz_cripps:ClientLevelCatch', _source, result[1].merchant_lvl)
        end
        ran = true
      end)
    while true do
      Wait(10)
      if ran then break end
    end
  until merchantLVL
end)

RegisterServerEvent('elz_cripps:GetGoods')
AddEventHandler('elz_cripps:GetGoods', function()
  local _source = source
  local Character = VORPcore.getUser(_source).getUsedCharacter
  local param = { ['charidentifier'] = Character.charIdentifier, ['identifier'] = Character.identifier }
  local Goods = false
  repeat
    local ran = false
    exports.oxmysql:execute(
      "SELECT goods_progress, materials_progress, product_progress FROM merchant WHERE charid=@charidentifier AND identifier=@identifier",
      param, function(result)
        if result[1].goods_progress then
          if result[1].goods_progress then
            Goods = true
            TriggerClientEvent('elz_cripps:ReceiveGoodProgress', _source, result[1].goods_progress,
              result[1].materials_progress, result[1].product_progress)
          end
        end
        ran = true
      end)
    while true do
      Wait(10)
      if ran then break end
    end
  until Goods
end)

-- Server-side event to update Goods
RegisterServerEvent('elz_cripps:UpdateGoodProgress')
AddEventHandler('elz_cripps:UpdateGoodProgress', function(goods, materials, production)
  local _source = source
  local Character = VORPcore.getUser(_source).getUsedCharacter
  local param = { ['charidentifier'] = Character.charIdentifier, ['identifier'] = Character.identifier }

  -- Mettre à jour la valeur de goods_progress dans la base de données
  exports.oxmysql:execute(
    "UPDATE merchant SET goods_progress=@goods, materials_progress=@materials, product_progress=@production WHERE charid=@charidentifier AND identifier=@identifier",
    {
      ['goods'] = goods,
      ['materials'] = materials,
      ['production'] = production,
      ['charidentifier'] = Character.charIdentifier,
      ['identifier'] = Character.identifier
    }, function(affectedRows)
    end)
end)


-- Server-side event to update merchant at the end off delivery
RegisterServerEvent('elz_cripps:UpdateMerchant')
AddEventHandler('elz_cripps:UpdateMerchant', function()
  local _source = source
  local Character = VORPcore.getUser(_source).getUsedCharacter
  local param = { ['charidentifier'] = Character.charIdentifier, ['identifier'] = Character.identifier }

  -- Mettre à jour la valeur de goods_progress dans la base de données
  exports.oxmysql:execute(
    "UPDATE merchant SET goods_progress=@goods, deliveries_completed=deliveries_completed + 1, merchant_xp = merchant_xp + 100 WHERE charid=@charid AND identifier=@identifier",
    {
      ['goods'] = 0,
      ['charid'] = Character.charIdentifier,
      ['identifier'] = Character.identifier
    },
    function(affectedRows)
      -- Callback code here
    end)
end)

-- Server-side event to update Goods
RegisterServerEvent('elz_cripps:FillProducts')
AddEventHandler('elz_cripps:FillProducts', function(order)
  local _source = source
  local Character = VORPcore.getUser(_source).getUsedCharacter
  local param = { ['charidentifier'] = Character.charIdentifier, ['identifier'] = Character.identifier }
  if order then
    if Character.money >= 20 then
      Character.removeCurrency(0, 20)
      VORPcore.NotifyRightTip(_source, "moneyremoved", 4000)
      exports.oxmysql:execute(
        "UPDATE merchant SET product_progress=25 WHERE charid=@charidentifier AND identifier=@identifier",
        { ['charidentifier'] = Character.charIdentifier, ['identifier'] = Character.identifier }, function(affectedRows)
        end)
    end
  else
    exports.oxmysql:execute(
      "UPDATE merchant SET product_progress=25 WHERE charid=@charidentifier AND identifier=@identifier",
      { ['charidentifier'] = Character.charIdentifier, ['identifier'] = Character.identifier }, function(affectedRows)
      end)
  end
end)
