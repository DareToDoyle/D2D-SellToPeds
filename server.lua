local ESX = exports["es_extended"]:getSharedObject()

RegisterServerEvent("D2D-PedUtils:sellItems")
AddEventHandler(
    "D2D-PedUtils:sellItems",
    function(itemsSell, menuType)
        local playerId = source
        local xPlayer = ESX.GetPlayerFromId(playerId)

        if xPlayer then
            if D2D.PoliceNeeded then
                local onlinePoliceCount = CountOnlinePolice()
                local requiredPoliceCount = D2D.PoliceAmount

                if onlinePoliceCount < requiredPoliceCount then
                    TriggerClientEvent('esx:showNotification', source, 'I aint looking to buy right now..', 'error', 3000)
                    return
                end
            end
            TriggerClientEvent('esx:showNotification', source, 'Let me just count your money..', 'info', 3000)
            TriggerClientEvent('D2D-PedUtils:anim', source)
            Citizen.Wait(15000)
            local totalPrice = 0
            for _, itemData in ipairs(itemsSell) do
                local itemName = itemData.name
                local itemCount = itemData.count
                exports.ox_inventory:RemoveItem(playerId, itemName, itemCount)
                local itemPrice = D2D.Peds[menuType].items[itemName]
                totalPrice = totalPrice + (itemPrice * itemCount)
            end
            TriggerClientEvent('esx:showNotification', playerId, 'Enjoy it, you might need to go wash it..', 'info', 3000)
            Debug("Player " .. playerId .. " just received £" .. totalPrice .. " from selling at the " .. menuType .. ".")
            exports.ox_inventory:AddItem(playerId, D2D.Peds[menuType].settings.money, totalPrice)
        else
            Debug("Player not found.")
        end
    end
)

function CountOnlinePolice()
    local onlinePoliceCount = 0
    for _, player in ipairs(GetPlayers()) do
        local xPlayer = ESX.GetPlayerFromId(player)
        if xPlayer and xPlayer.job.name == D2D.PoliceJobName then
            onlinePoliceCount = onlinePoliceCount + 1
        end
    end
    return onlinePoliceCount
end
