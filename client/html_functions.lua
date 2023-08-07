function CreateMenuItem(label, value, description, image, state, isDisabled)
    local menuItem = {
        label = CreateMenuItemLabel(image, label, state),
        value = value,
        desc = CreateMenuItemDesc(value, description),
        disabled = isDisabled or false
    }
    return menuItem
end

function CreateMenuItemDesc(current, description)
    local imgPath =
    "<img style='max-height:80px;max-width:80px;margin-left: 10px;' src='nui://elz_cripps/html/images/%s.png'>"               -- Image sélectionnée dans la description
    local imgPathfade =
    "<img style='max-height:80px;max-width:80px;margin-left: 10px; opacity: 0.5;' src='nui://elz_cripps/html/images/%s.png'>" -- Image non-sélectionnée dans la description
    local imgDivider =
    "<img style='margin-top: 10px;margin-bottom: 10px;' src='nui://elz_cripps/html/images/%s.png'>"                           -- La barre de séparation du menu
    local img1, img2, img3

    if current == 'materials' then
        img1 = imgPath:format('butcher_table_raw_materials')
        img2 = imgPathfade:format('butcher_table_production')
        img3 = imgPathfade:format('butcher_table_goods')
    elseif current == 'production' then
        img1 = imgPathfade:format('butcher_table_raw_materials')
        img2 = imgPath:format('butcher_table_production')
        img3 = imgPathfade:format('butcher_table_goods')
    else
        img1 = imgPathfade:format('butcher_table_raw_materials')
        img2 = imgPathfade:format('butcher_table_production')
        img3 = imgPath:format('butcher_table_goods')
    end

    local descriptionHTML =
        [[ <br><div style="display: flex; align-items: center;justify-content: center;">]] ..
        img1 ..
        [[ <div style="margin: 5px;">+</div>]] ..
        img2 ..
        [[ <div style="margin: 5px;">=</div> ]] ..
        img3 ..
        [[ </div><br><br><div style="font-family: 'rdr';color: lightgrey;">]] .. description .. [[ </div><br>]]


    if current == 'production' then
        descriptionHTML = descriptionHTML ..
            [[ <br> ]] ..
            imgDivider:format('divider_line') ..
            [[ <div style="vertical-align:middle"><span style='font-size: 24px;font-family: "crock", crock, serif;'> ]] ..
            _U('orderSupplies') ..
            [[ </span><span style='color: gray;font-size: xx-large;font-family: "crock", crock, serif;'> $20<sup style=" vertical-align:text-top;font-size: 0.7em;"> 00</sup> </span> </div>]] ..
            imgDivider:format('divider_line')
    end

    return descriptionHTML
end

function CreateMenuItemLabel(image, label, state)
    local labelHTML =
        '<div style="height:5vh;!important; display: flex; align-items: center; flex-direction: row;">' ..
        '<img class="item-image" src="nui://elz_cripps/html/images/' ..
        image .. '.png" style="margin-right: 15px;"></img>' ..
        '<div style="display: flex;flex-direction: column;justify-content: center;align-items: flex-start;">' ..
        label ..
        '<br>' ..
        state ..
        '</div></div>'

    return labelHTML
end
