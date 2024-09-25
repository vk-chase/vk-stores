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
Config.Stores = {
    ["247supermarket"] = {
        label = "24/7 Supermarket",
        blip = {
            sprite = 52,
            color = 2,
            scale = 0.6,
            showBlip = true
        },
        locations = {
            {
                coords = vector4(24.47, -1347.47, 29.5, 271.66),
                ped = {
                    model = "mp_m_shopkeep_01",
                    scenario = "WORLD_HUMAN_STAND_MOBILE"
                },
                job = "police", -- Optional: Restrict access to specific job
                gang = "ballas" -- Optional: Restrict access to specific gang
            },
        },
        items = {
            { name = "water_bottle", price = 2 },
            { name = "sandwich", price = 3 },
        }
    },
}
