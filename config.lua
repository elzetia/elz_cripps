Config                            = {}
Config.groupSystem                = true -- elz_groupmaker
Config.defaultlang                = 'fr_lang'

Config.keys                       = {
    open = 0x760A9C6F,  --[G]
    back = 0x8E90C7BB,  -- [back]
    order = 0xFBD7B3E6, -- [Space]
    enter = 0x43DBF61F  -- [Enter]
}

Config.camp                       = {
    CampName = 'Campement de Cripps',                         -- Name of Camp on Menu Header
    promptName = 'JB Cripps',                                 -- Text Below the Prompt Button
    blipOn = true,                                            -- Turns Blip On / Off
    blipName = 'Campement',                                   -- Name of the Blip on the Map
    blipSprite = joaat('blip_teamsters'),
    blipColorWork = 'WHITE',                                  -- Camp working - Default: White - Blip Colors Shown Below
    blipColorPaused = 'RED',                                  -- Camp is paused - Default: Red
    npc = { x = -620.49, y = -26.57, z = 85.58, h = 200.24 }, -- NPC and Shop Blip Position
    nDistance = 100.0,                                        -- Distance from Camp for NPC to Spawn
    sDistance = 2.0,                                          -- Distance from NPC to Show Prompts
    npcOn = true,                                             -- Turns NPCs On / Off
    npcModel = 'cs_mp_cripps',                                -- Sets Model for NPCs

    cart = {
        pos = { x = -628.31, y = -64.32, z = 82.98, h = 3.49 },
        model = 'cart04',
    }
}

Config.camp.cart.crateData        = {
    [1] = { model = 'p_crate06bx', pos = Config.camp.cart.pos, offset = { x = 0, y = 0, z = 1 } },               --  0, 0, 1
    [2] = { model = 'p_cs_pelt_xlarge_bear', pos = Config.camp.cart.pos, offset = { x = 0, y = 0, z = 0.3 } },   --  0, 0, 0.3
    [3] = { model = 'p_cs_pelt_xlarge_elk', pos = Config.camp.cart.pos, offset = { x = 0, y = -0.5, z = 0.3 } }, --  0, -0.5, 0.3
    [4] = { model = 's_miscchest_loot', pos = Config.camp.cart.pos, offset = { x = 0, y = -1.5, z = 0 } },       -- 0, -1.5, 0
    [5] = { model = 'p_crate06bx', pos = Config.camp.cart.pos, offset = { x = 0, y = -0.5, z = 0 } },            -- 0, -0.5, 0
    [6] = { model = 'p_crate06bx', pos = Config.camp.cart.pos, offset = { x = 0, y = -1.0, z = 0 } },            --  0, -1.0, 0
    [7] = { model = 's_veh_lantern_rf', pos = Config.camp.cart.pos, offset = { x = 0.2, y = -1.0, z = 0.8 } }    --  0.2, -1.0, 0.8
}

Config.camp.cart.deliveryLocation = {
    test = { { label = 'Zone de Test', destination = vector3(-622.3, 18.21, 86.88), radius = 20.0 } },
    near = {
        { label = 'Valentine',            destination = vector3(-350.75, 752.29, 116.53),  radius = 20.0 },
        { label = 'Blackwater',           destination = vector3(-746.69, -1283.26, 43.13), radius = 20.0 },
        { label = 'Strawberry',           destination = vector3(-1748.02, -391.9, 156.42), radius = 20.0 },
        { label = 'Heartland Oil Fields', destination = vector3(496.69, 603.28, 110.45),   radius = 20.0 }
    },
    halfway = {
        { label = 'Thieves Landing',           destination = vector3(-1420.11, -2317.86, 43.07), radius = 20.0 },
        { label = 'Rhodes',                    destination = vector3(1304.65, -1282.09, 75.87),  radius = 20.0 },
        { label = 'Lagras',                    destination = vector3(2107.96, -584.27, 41.66),   radius = 20.0 },
        { label = 'Wapiti Indian Reservation', destination = vector3(446.17, 2233.57, 247.75),   radius = 20.0 },
        { label = 'Emerald Ranch',             destination = vector3(1521.88, 418.7, 89.94),     radius = 20.0 },
        { label = 'Ewing Basin',               destination = vector3(-1888.84, 1324.03, 199.65), radius = 20.0 },
    },
    far = {
        { label = 'Ranch Adler', destination = vector3(-567.25, 2714.28, 320.78),  radius = 20.0 },
        { label = 'Saint-Denis', destination = vector3(2810.51, -1337.02, 46.27),  radius = 20.0 },
        { label = 'Armadillo',   destination = vector3(-3694.6, -2619.02, -13.85), radius = 20.0 },
        { label = 'Annesburg',   destination = vector3(2927.91, 1302.46, 44.47),   radius = 20.0 },
        { label = 'Van Horn',    destination = vector3(2993.31, 562.9, 44.46),     radius = 20.0 },
        { label = 'Tumbleweed',  destination = vector3(-5519.02, -2942.42, -2.01), radius = 20.0 },
    }
}



Config.supply = {
    {label = 'Riggs Station', wagon = vector3(-1103.96, -571.87, 82.48),h= 327.14, npc = {
        vector4(-1106.41, -566.61, 86.82, 321.13),
        vector4(-1093.02, -570.11, 84.94, 46.27),
        vector4(-1095.0, -574.41, 82.41, 144.95),
        vector4(-1096.24, -576.03, 82.41, 340.09),
        vector4(-1100.46, -577.07, 82.39, 198.57)
    }},
    {label = 'Flatneck Station', wagon = vector3(-330.87, -377.98, 86.85),h= 116.57, npc = {
        vector4(-345.11, -357.66, 88.1, 200.81),
        vector4(-347.75, -369.37, 87.29, 139.98),
        vector4(-346.43, -371.23, 87.32, 232.28),
        vector4(-337.33, -361.19, 88.08, 11.35),
        vector4(-321.72, -362.86, 88.01, 167.1)


    }},
    {label = 'Wallace Station', wagon = vector3(-1309.21, 371.87, 96.96),h= 55.19, npc = {
        vector4(-1309.48, 378.5, 95.93, 53.36),
        vector4(-1312.71, 391.66, 95.38, 70.51),
        vector4(-1297.63, 390.72, 95.58, 197.82),
        vector4(-1297.1, 418.79, 99.83, 144.19),
        vector4(-1306.42, 394.12, 95.43, 67.38),
        vector4(-1304.41, 389.55, 95.43, 94.23)
    }},
    {label = 'Downes Ranch', wagon = vector3(-848.83, 350.85, 96.61),h= 231.33, npc = {
        vector4(-853.54, 340.55, 96.52, 348.41),
        vector4(-853.52, 344.37, 96.53, 216.14),
        vector4(-815.41, 352.35, 98.09, 165.24),
        vector4(-820.13, 354.32, 98.08, 74.96),
        vector4(-857.7, 333.33, 99.8, 276.14),
        vector4(-864.52, 329.91, 96.33, 181.57)
    }}
}



Config.BlipColors                 = {
    LIGHT_BLUE    = 'BLIP_MODIFIER_MP_COLOR_1',
    DARK_RED      = 'BLIP_MODIFIER_MP_COLOR_2',
    PURPLE        = 'BLIP_MODIFIER_MP_COLOR_3',
    ORANGE        = 'BLIP_MODIFIER_MP_COLOR_4',
    TEAL          = 'BLIP_MODIFIER_MP_COLOR_5',
    LIGHT_YELLOW  = 'BLIP_MODIFIER_MP_COLOR_6',
    PINK          = 'BLIP_MODIFIER_MP_COLOR_7',
    GREEN         = 'BLIP_MODIFIER_MP_COLOR_8',
    DARK_TEAL     = 'BLIP_MODIFIER_MP_COLOR_9',
    RED           = 'BLIP_MODIFIER_MP_COLOR_10',
    LIGHT_GREEN   = 'BLIP_MODIFIER_MP_COLOR_11',
    TEAL2         = 'BLIP_MODIFIER_MP_COLOR_12',
    BLUE          = 'BLIP_MODIFIER_MP_COLOR_13',
    DARK_PUPLE    = 'BLIP_MODIFIER_MP_COLOR_14',
    DARK_PINK     = 'BLIP_MODIFIER_MP_COLOR_15',
    DARK_DARK_RED = 'BLIP_MODIFIER_MP_COLOR_16',
    GRAY          = 'BLIP_MODIFIER_MP_COLOR_17',
    PINKISH       = 'BLIP_MODIFIER_MP_COLOR_18',
    YELLOW_GREEN  = 'BLIP_MODIFIER_MP_COLOR_19',
    DARK_GREEN    = 'BLIP_MODIFIER_MP_COLOR_20',
    BRIGHT_BLUE   = 'BLIP_MODIFIER_MP_COLOR_21',
    BRIGHT_PURPLE = 'BLIP_MODIFIER_MP_COLOR_22',
    YELLOW_ORANGE = 'BLIP_MODIFIER_MP_COLOR_23',
    BLUE2         = 'BLIP_MODIFIER_MP_COLOR_24',
    TEAL3         = 'BLIP_MODIFIER_MP_COLOR_25',
    TAN           = 'BLIP_MODIFIER_MP_COLOR_26',
    OFF_WHITE     = 'BLIP_MODIFIER_MP_COLOR_27',
    LIGHT_YELLOW2 = 'BLIP_MODIFIER_MP_COLOR_28',
    LIGHT_PINK    = 'BLIP_MODIFIER_MP_COLOR_29',
    LIGHT_RED     = 'BLIP_MODIFIER_MP_COLOR_30',
    LIGHT_YELLOW3 = 'BLIP_MODIFIER_MP_COLOR_31',
    WHITE         = 'BLIP_MODIFIER_MP_COLOR_32'
}


-- Config.travelers = {
--     stdenis = {
--         CampName = 'Campement de Cripps', -- Name of Camp on Menu Header
--         promptName = 'JB Cripps', -- Text Below the Prompt Button
--         blipOn = true,-- Turns Blip On / Off
--         blipName = 'Campement', -- Name of the Blip on the Map
--         blipSprite = joaat('blip_teamsters'),
--         blipColorWork = 'WHITE', -- Camp working - Default: White - Blip Colors Shown Below
--         blipColorPaused = 'RED', -- Camp is paused - Default: Red
--         npc = {x = -620.49, y = -26.57, z = 85.58, h= 200.24}, -- NPC and Shop Blip Position
--         nDistance = 100.0, -- Distance from Camp for NPC to Spawn
--         sDistance = 2.0, -- Distance from NPC to Show Prompts
--         npcOn = true, -- Turns NPCs On / Off
--         npcModel = 'cs_mp_cripps', -- Sets Model for NPCs

--         cart = {x = -628.31, y = -64.32, z = 82.98, h= 3.49},
--         cartModel = 'cart04',
--         cartHorse = 'a_c_horse_shire_darkbay',
--         zoneCoords = vector3(-594.41, 22.33, 87.9)
--     },
--     guarma = {
--         CampName = 'Campement de Cripps', -- Name of Camp on Menu Header
--         promptName = 'JB Cripps', -- Text Below the Prompt Button
--         blipOn = true,-- Turns Blip On / Off
--         blipName = 'Campement', -- Name of the Blip on the Map
--         blipSprite = joaat('blip_teamsters'),
--         blipColorWork = 'WHITE', -- Camp working - Default: White - Blip Colors Shown Below
--         blipColorPaused = 'RED', -- Camp is paused - Default: Red
--         npc = {x = -620.49, y = -26.57, z = 85.58, h= 200.24}, -- NPC and Shop Blip Position
--         nDistance = 100.0, -- Distance from Camp for NPC to Spawn
--         sDistance = 2.0, -- Distance from NPC to Show Prompts
--         npcOn = true, -- Turns NPCs On / Off
--         npcModel = 'cs_mp_cripps', -- Sets Model for NPCs

--         cart = {x = -628.31, y = -64.32, z = 82.98, h= 3.49},
--         cartModel = 'cart04',
--         cartHorse = 'a_c_horse_shire_darkbay',
--         zoneCoords = vector3(-594.41, 22.33, 87.9)
--     }
-- }


-- BCC-Portals
-- cripps = {
--     shopName = 'Camp', -- Name of Shop on Menu Header
--     promptName = 'Camp', -- Text Below the Prompt Button
--     blipOn = true, -- Turns Blips On / Off
--     blipName = 'Voyage Rapide', -- Name of the Blip on the Map
--     blipSprite = 784218150, -- Default: 784218150
--     blipColorOpen = 'WHITE', -- Shop Open - Default: White - Blip Colors Shown Below
--     blipColorClosed = 'RED', -- Shop Closed - Deafault: Red - Blip Colors Shown Below
--     blipColorJob = 'YELLOW_ORANGE', -- Shop Job Locked - Default: Yellow - Blip Colors Shown Below
--     npc = {x = -626.90, y = -41.10, z = 83.78, h=0}, -- NPC and Shop Blip Positions
--     player = {x = -628.28, y = -39.71, z = 84.89, h= 332.14}, -- Player Teleport Position
--     nDistance = 100.0, -- Distance from Shop for NPC to Spawn
--     sDistance = 3.0, -- Distance from NPC to Get Menu Prompt
--     npcOn = false, -- Turns NPCs On / Off
--     npcModel = 'NONE', -- Sets Model for NPCs
--     allowedJobs = {}, -- Empty, Everyone Can Use / Insert Job to limit access - ex. 'police'
--     jobGrade = 0, -- Enter Minimum Rank / Job Grade to Access Shop
--     shopHours = false, -- If You Want the Shops to Use Open and Closed Hours
--     shopOpen = 7, -- Shop Open Time / 24 Hour Clock
--     shopClose = 21, -- Shop Close Time / 24 Hour Clock
--     outlets = { -- label is the name used in the body of the menu / DO NOT CHANGE 'location'
--         { label = 'Armadillo',   location = 'armadillo',  }, -- etc.
--     }
-- }
