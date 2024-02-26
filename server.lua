local ESX = exports["es_extended"]:getSharedObject()

local peds = {}
local pedCounter = 0

function CleanUpPeds()
    for ped, pedData in pairs(peds) do
        if DoesEntityExist(ped) then
            DeleteEntity(ped)
            peds[ped] = nil
            Debug("Ped " .. pedData.type .. " with ID " .. pedData.counter .. " has been deleted.")
        else
            Debug("Ped " .. pedData.type .. " with ID " .. pedData.counter .. " does not exist.")
        end
    end
    peds = {}
end

Citizen.CreateThread(
    function()
        for pedType, data in pairs(D2D.Peds) do
            if data.settings.spawn == "All" then
                for _, coord in ipairs(data.coords) do
                    SpawnPedAtCoordinate(pedType, data.ped.model, coord, data.ped.scenario, data.blip)
                end
            elseif data.settings.spawn == "Random" then
                local randomCoord = data.coords[math.random(1, #data.coords)]
                SpawnPedAtCoordinate(pedType, data.ped.model, randomCoord, data.ped.scenario, data.blip)
			else
			Debug("You have put an incorrect spawn settings in the config.lua")
            end
        end
    end
)

function SpawnPedAtCoordinate(pedType, pedModel, coord, scenario, blip)
    local modelhash = GetHashKey(pedModel)

    local ped = CreatePed(26, modelhash, coord.x, coord.y, coord.z, coord.h, true, true)

    while not DoesEntityExist(ped) do
        Wait(50)
    end

    pedCounter = pedCounter + 1

    local nID = NetworkGetNetworkIdFromEntity(ped)

    SetEntityDistanceCullingRadius(ped, 25000.0) -- Depreciated native (use at own risk), if you know of a replacement please let me know!

    peds[ped] = {type = pedType, counter = pedCounter, nID = nID, scenario = scenario, blip = blip}

    Debug("Ped " .. pedType .. " with ID " .. pedCounter .. " has spawned and added to the peds table.")
end

AddEventHandler(
    "onResourceStop",
    function(resourceName)
        if resourceName == "D2D-PedUtil" then
            CleanUpPeds()
        end
    end
)

function SendPedsToClient(playerId)
    Citizen.Wait(5000)
    TriggerClientEvent("D2D-PedUtils:sendPeds", playerId, peds)
end

RegisterServerEvent("D2D-PedUtils:requestPeds")
AddEventHandler(
    "D2D-PedUtils:requestPeds",
    function()
        local playerId = source
        SendPedsToClient(playerId)
    end
)

RegisterServerEvent("D2D-PedUtils:sellItems")
AddEventHandler(
    "D2D-PedUtils:sellItems",
    function(itemsSell, menuType)
        local playerId = source
        local xPlayer = ESX.GetPlayerFromId(playerId)
        if xPlayer then
            local totalPrice = 0
            for _, itemData in ipairs(itemsSell) do
                local itemName = itemData.name
                local itemCount = itemData.count
                exports.ox_inventory:RemoveItem(playerId, itemName, itemCount)
                local itemPrice = D2D.Peds[menuType].items[itemName]
                totalPrice = totalPrice + (itemPrice * itemCount)
            end
			Debug("Player " .. source .. " just received £" .. totalPrice .. " from selling at the " .. menuType .. ".")
            exports.ox_inventory:AddItem(playerId, D2D.Peds[menuType].settings.money, totalPrice)
        else
            Debug("Player not found.")
        end
    end
)
