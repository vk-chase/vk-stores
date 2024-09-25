Config = {
    MaxDistance = 30.0, -- Max distance to show nearby players (default: 30.0)
    InteractionDistance = 2.0, -- Distance to interact with the store (default: 2.0)
    Stores = {
        generalstore = {
            label = "General Store", -- Label for the store (default: "General Store") both blip and menu header.
            blip = {
                sprite = 59,
                color = 3,
                scale = 0.8,
                showBlip = true,
            },
            items = {
                {name = "coffee", price = 30},
                -- Add items here
            },
            locations = {
                {
                    coords = vector4(24.5, -1346.19, 29.5, 266.78),
                    ped = {
                        model = "s_f_y_shop_mid",
                        scenario = "WORLD_HUMAN_STAND_MOBILE",
                    }
                    -- you can lock each ped to a gang or job here.
            -- Example:
                    -- job = "police", 
                    -- gang = "ballas",
                },
                {
                    coords = vector4(-3039.91, 584.26, 7.91, 16.79),
                    ped = {
                        model = "mp_m_shopkeep_01",
                        scenario = "WORLD_HUMAN_STAND_IMPATIENT",
                    }
                },
                {
                    coords = vector4(-3243.27, 1000.1, 12.83, 358.73),
                    ped = {
                        model = "s_f_y_shop_low",
                        scenario = "WORLD_HUMAN_STAND_MOBILE",
                    }
                },
                {
                    coords = vector4(1728.28, 6416.03, 35.04, 242.45),
                    ped = {
                        model = "s_m_y_shop_mask",
                        scenario = "WORLD_HUMAN_CLIPBOARD",
                    }
                },
                {
                    coords = vector4(1697.96, 4923.04, 42.06, 326.61),
                    ped = {
                        model = "a_m_y_business_02",
                        scenario = "WORLD_HUMAN_STAND_IMPATIENT",
                    }
                },
                {
                    coords = vector4(1959.6, 3740.93, 32.34, 296.84),
                    ped = {
                        model = "s_f_y_shop_mid",
                        scenario = "WORLD_HUMAN_STAND_MOBILE",
                    }
                },
                {
                    coords = vector4(549.16, 2670.35, 42.16, 92.53),
                    ped = {
                        model = "mp_m_shopkeep_01",
                        scenario = "WORLD_HUMAN_CLIPBOARD",
                    }
                },
                {
                    coords = vector4(2677.41, 3279.8, 55.24, 334.16),
                    ped = {
                        model = "s_f_y_shop_low",
                        scenario = "WORLD_HUMAN_STAND_IMPATIENT",
                    }
                },
                {
                    coords = vector4(2556.19, 380.89, 108.62, 355.58),
                    ped = {
                        model = "a_m_y_business_02",
                        scenario = "WORLD_HUMAN_STAND_MOBILE",
                    }
                },
                {
                    coords = vector4(372.82, 327.3, 103.57, 255.46),
                    ped = {
                        model = "s_m_y_shop_mask",
                        scenario = "WORLD_HUMAN_CLIPBOARD",
                    }
                },
                {
                    coords = vector4(161.21, 6642.32, 31.61, 223.57),
                    ped = {
                        model = "s_f_y_shop_mid",
                        scenario = "WORLD_HUMAN_STAND_IMPATIENT",
                    }
                },
                -- LTD Gasolines below
                {
                    coords = vector4(-47.52, -1758.94, 29.42, 47.83),
                    ped = {
                        model = "s_f_y_shop_mid",
                        scenario = "WORLD_HUMAN_STAND_IMPATIENT",
                    }
                },
                {
                    coords = vector4(-705.98, -914.9, 19.22, 93.07),
                    ped = {
                        model = "s_f_y_shop_mid",
                        scenario = "WORLD_HUMAN_STAND_IMPATIENT",
                    }
                },
            }
        },

        -- Add more store types here
    }
}
