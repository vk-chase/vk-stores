local QBCore = exports['qb-core']:GetCoreObject()
local webhookUrl = "https://discord.com/api/webhooks/1288514661494423572/VO414T8vr-b5ebFDbUwDl9NHUbjQLy66Az-gyRrp-DHxwJLSlsalLXqfM4wuXuRfTzHw" -- Replace with your actual webhook URL

local function SendDiscordWebhook(player, recipient, item, amount, price)
    local playerName = player.PlayerData.charinfo.firstname .. " " .. player.PlayerData.charinfo.lastname
    local recipientName = recipient.PlayerData.charinfo.firstname .. " " .. recipient.PlayerData.charinfo.lastname

    local message = string.format("**Purchase Log**\n" ..
        "Buyer: %s\n" ..
        "Recipient: %s\n" ..
        "Item: %s\n" ..
        "Amount: %d\n" ..
        "Total Price: $%d",
        playerName,
        recipientName,
        QBCore.Shared.Items[item].label, amount, price * amount
    )

    PerformHttpRequest(webhookUrl, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
end

local function SendResponse(src, success, message)
    if type(message) ~= "string" then
        message = "An unknown error occurred"
    end
    TriggerClientEvent('vk-storesclient:purchaseResponse', src, success, message)
end

RegisterNetEvent('vk-storesserver:purchaseItem', function(item, price, amount, paymentMethod, recipientId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local totalPrice = price * amount

    if not Player then
        SendResponse(src, false, "Error: Player not found.")
        return
    end

    if not QBCore.Shared.Items[item] then
        SendResponse(src, false, "Error: Invalid item.")
        return
    end

    local canAfford = false
    if paymentMethod == "cash" then
        canAfford = Player.PlayerData.money.cash >= totalPrice
    elseif paymentMethod == "bank" then
        canAfford = Player.PlayerData.money.bank >= totalPrice
    else
        SendResponse(src, false, "Invalid payment method.")
        return
    end

    if not canAfford then
        SendResponse(src, false, "You don't have enough money to make this purchase.")
        return
    end

    local Recipient = QBCore.Functions.GetPlayer(tonumber(recipientId))
    if not Recipient then
        SendResponse(src, false, "Recipient not found. Purchase cancelled.")
        return
    end

    -- Check distance between buyer and recipient (skip if buying for self)
    if src ~= recipientId then
        local buyerCoords = GetEntityCoords(GetPlayerPed(src))
        local recipientCoords = GetEntityCoords(GetPlayerPed(recipientId))
        local distance = #(buyerCoords - recipientCoords)
        
        if distance > 15.0 then
            SendResponse(src, false, "The recipient is too far away.")
            return
        end
    end

    local info = {}
    local addItem = Recipient.Functions.AddItem(item, amount, false, info)
    if addItem then
        Player.Functions.RemoveMoney(paymentMethod, totalPrice)
        if src == recipientId then
            SendResponse(src, true, "You purchased " .. amount .. " " .. QBCore.Shared.Items[item].label .. "(s) for yourself.")
        else
            SendResponse(src, true, "You purchased " .. amount .. " " .. QBCore.Shared.Items[item].label .. "(s) for " .. Recipient.PlayerData.charinfo.firstname .. " " .. Recipient.PlayerData.charinfo.lastname .. ".")
            SendResponse(recipientId, true, Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname .. " bought you " .. amount .. " " .. QBCore.Shared.Items[item].label .. "(s).")
        end
        TriggerClientEvent('qb-inventory:client:ItemBox', recipientId, QBCore.Shared.Items[item], "add", amount)

        -- Send Discord webhook
        SendDiscordWebhook(Player, Recipient, item, amount, price)
    else
        SendResponse(src, false, "Failed to add item to inventory. Purchase cancelled.")
    end
end)
