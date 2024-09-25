local QBCore = exports['qb-core']:GetCoreObject()

local zonePeds = {}

local function CreateBlips()
    for storeType, storeData in pairs(Config.Stores) do
        if storeData.blip.showBlip then
            for _, location in ipairs(storeData.locations) do
                local blip = AddBlipForCoord(location.coords.x, location.coords.y, location.coords.z)
                SetBlipSprite(blip, storeData.blip.sprite)
                SetBlipDisplay(blip, 4)
                SetBlipScale(blip, storeData.blip.scale)
                SetBlipColour(blip, storeData.blip.color)
                SetBlipAsShortRange(blip, true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString(storeData.label)
                EndTextCommandSetBlipName(blip)
            end
        end
    end
end

local function GetNearbyPlayers(maxDistance)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local players = QBCore.Functions.GetPlayers()
    local nearbyPlayers = {}
    local playerData = QBCore.Functions.GetPlayerData()
    table.insert(nearbyPlayers, {
        playerId = GetPlayerServerId(PlayerId()),
        name = playerData.charinfo.firstname .. " " .. playerData.charinfo.lastname .. " (You)",
        distance = 0
    })
    for _, playerId in ipairs(players) do
        local targetPed = GetPlayerPed(GetPlayerFromServerId(playerId))
        if targetPed ~= playerPed and DoesEntityExist(targetPed) then
            local targetCoords = GetEntityCoords(targetPed)
            local distance = #(playerCoords - targetCoords)
            if distance <= maxDistance then
                local targetPlayer = QBCore.Functions.GetPlayerData(playerId)
                if targetPlayer and targetPlayer.charinfo then
                    table.insert(nearbyPlayers, {
                        playerId = playerId,
                        name = targetPlayer.charinfo.firstname .. " " .. targetPlayer.charinfo.lastname,
                        distance = math.floor(distance)
                    })
                end
            end
        end
    end
    return nearbyPlayers
end

local function OpenPurchaseMenu(zone)
    local greetings = {"Hey there!", "Hello!", "Welcome!", "How can I help you today?"}
    local randomGreeting = greetings[math.random(#greetings)]
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local closestPed = nil
    local closestDistance = 1000
    for _, ped in ipairs(zonePeds) do
        local pedCoords = GetEntityCoords(ped)
        local distance = #(playerCoords - pedCoords)
        if distance < closestDistance then
            closestPed = ped
            closestDistance = distance
        end
    end
    if closestPed then
        PlayPedAmbientSpeechNative(closestPed, "GENERIC_HI", "SPEECH_PARAMS_FORCE_NORMAL_CLEAR")
        TaskPlayAnim(closestPed, "mp_common", "givetake1_a", 8.0, 1.0, -1, 48, 0, 0, 0, 0)
    end
    local menuItems = {
        {
            header = zone.label,
            isMenuHeader = true
        },
        {
            header = randomGreeting,
            txt = "Let me know what you'd like to purchase.",
            isMenuHeader = true
        }
    }

    for _, item in pairs(zone.items) do
        local itemData = QBCore.Shared.Items[item.name]
        if itemData then
            menuItems[#menuItems+1] = {
                header = itemData.label,
                txt = "Price: $" .. item.price,
                params = {
                    event = "vk-storespurchaseItem",
                    args = {
                        item = item.name,
                        price = item.price,
                        label = itemData.label
                    }
                },
                icon = "nui://qb-inventory/html/images/" .. item.name .. ".png"
            }
        end
    end
    exports['qb-menu']:openMenu(menuItems)
end

local function SpawnZonePed(zone)
    if zone.ped then
        RequestModel(GetHashKey(zone.ped.model))
        while not HasModelLoaded(GetHashKey(zone.ped.model)) do
            Wait(1)
        end

        local ped = CreatePed(4, GetHashKey(zone.ped.model), zone.coords.x, zone.coords.y, zone.coords.z - 1.0, zone.coords.w, false, true)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)

        if zone.ped.scenario then
            TaskStartScenarioInPlace(ped, zone.ped.scenario, 0, true)
        end

        return ped
    end
    return nil
end

local function AddInteractionZone(storeType, location, storeData)
    local ped = SpawnZonePed(location)
    local options = {
        {
            type = "client",
            event = "vk-storesopenPurchaseMenu",
            icon = "fas fa-shopping-cart",
            label = "Purchase Items",
            storeData = storeData,
            canInteract = function(entity, distance, data)
                local playerData = QBCore.Functions.GetPlayerData()
                if location.job and playerData.job.name ~= location.job then
                    return false
                end
                if location.gang and playerData.gang.name ~= location.gang then
                    return false
                end
                return true
            end
        },
    }
    if ped then
        exports['qb-target']:AddTargetEntity(ped, {
            options = options,
            distance = Config.InteractionDistance
        })
        return ped
    else
        exports['qb-target']:AddCircleZone(storeType .. "_" .. #zonePeds, location.coords, 0.5, {
            name = storeType .. "_" .. #zonePeds,
            debugPoly = false,
        }, {
            options = options,
            distance = Config.InteractionDistance
        })
    end
    return nil
end

-- Main Thread
CreateThread(function()
    for storeType, storeData in pairs(Config.Stores) do
        for _, location in ipairs(storeData.locations) do
            local ped = AddInteractionZone(storeType, location, storeData)
            if ped then
                table.insert(zonePeds, ped)
            end
        end
    end
    CreateBlips()
end)

-- Event Handlers
RegisterNetEvent('vk-storesopenPurchaseMenu', function(data)
    OpenPurchaseMenu(data.storeData)
end)

RegisterNetEvent('vk-storespurchaseItem', function(data)
    local dialog = exports['qb-input']:ShowInput({
        header = "Purchase " .. data.label,
        submitText = "Confirm",
        inputs = {
            {
                text = "Amount to purchase",
                name = "amount",
                type = "number",
                isRequired = true,
                default = 1,
            },
        },
    })

    if dialog and dialog.amount and tonumber(dialog.amount) > 0 then
        local amount = tonumber(dialog.amount)
        local totalPrice = data.price * amount

        exports['qb-menu']:openMenu({
            {
                header = "Choose Payment Method",
                isMenuHeader = true
            },
            {
                header = "Cash",
                txt = "Pay $" .. totalPrice .. " with cash",
                params = {
                    event = "vk-storeschooseRecipient",
                    args = {
                        item = data.item,
                        price = data.price,
                        amount = amount,
                        paymentMethod = "cash"
                    }
                },
                icon = "fas fa-money-bill"
            },
            {
                header = "Bank",
                txt = "Pay $" .. totalPrice .. " from bank",
                params = {
                    event = "vk-storeschooseRecipient",
                    args = {
                        item = data.item,
                        price = data.price,
                        amount = amount,
                        paymentMethod = "bank"
                    }
                },
                icon = "fas fa-credit-card"
            }
        })
    end
end)

RegisterNetEvent('vk-storeschooseRecipient', function(data)
    local nearbyPlayers = GetNearbyPlayers(Config.MaxDistance)
    
    if #nearbyPlayers == 0 then
        QBCore.Functions.Notify("No players nearby!", "error")
        return
    end

    local menuItems = {
        {
            header = "Choose Recipient",
            isMenuHeader = true
        }
    }

    for _, player in ipairs(nearbyPlayers) do
        menuItems[#menuItems+1] = {
            header = player.name,
            txt = player.distance == 0 and "Yourself" or ("Distance: " .. player.distance .. " units"),
            params = {
                event = "vk-storesconfirmPurchase",
                args = {
                    item = data.item,
                    price = data.price,
                    amount = data.amount,
                    paymentMethod = data.paymentMethod,
                    recipientId = player.playerId
                }
            },
            icon = "fas fa-user"
        }
    end

    exports['qb-menu']:openMenu(menuItems)
end)

RegisterNetEvent('vk-storesconfirmPurchase', function(data)
    TriggerServerEvent('vk-storesserver:purchaseItem', data.item, data.price, data.amount, data.paymentMethod, data.recipientId)
end)

RegisterNetEvent('vk-storesclient:purchaseResponse', function(success, message)
    if success then
        QBCore.Functions.Notify(message, "success")
    else
        QBCore.Functions.Notify(message, "error")
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    for _, ped in ipairs(zonePeds) do
        DeletePed(ped)
    end
end)