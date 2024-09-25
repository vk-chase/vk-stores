# VK Stores

VK Stores is a customizable store system for FiveM servers using the QBCore framework. It allows server owners to create various types of stores with custom locations, items, and access restrictions.

## Features

- Multiple store types with custom locations
- Customizable item lists and prices
- Job and gang-based access restrictions
- NPC interactions with custom animations and dialogue
- Blip creation for store locations
- Nearby player detection for purchases
- Multiple payment methods (cash and bank)

## Installation

1. Download the `vk-stores` resource.
2. Place it in your server's `resources` folder.
3. Add `ensure vk-stores` to your `server.cfg` file.

## Configuration

### Store Setup

Edit the `config.lua` file to set up your stores:

```lua
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
                -- more store locations here
            }
        },

        -- Add more store types here
    }
}

