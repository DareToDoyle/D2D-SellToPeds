ESX = exports["es_extended"]:getSharedObject()

local clientPeds = {}
local blips = {}

Citizen.CreateThread(
    function()
	Citizen.Wait(10000)
	
	while not ESX.IsPlayerLoaded() do
	Citizen.Wait(100)
	end
	
        TriggerServerEvent("D2D-PedUtils:requestPeds")
    end
)

function createBlip(blipData, coords, dataID)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, blipData.sprite)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, blipData.scale)
    SetBlipColour(blip, blipData.colour)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(blipData.name)
    EndTextCommandSetBlipName(blip)

    blips[dataID] = blip

    for dataID, blip in pairs(blips) do
        Debug("Data ID: " .. dataID .. ". Blip ID: " .. blip .. ".")
    end

    return blip
end

function handlePedData(data)
    local pedEntity = NetworkGetEntityFromNetworkId(data.nID)

    while not DoesEntityExist(pedEntity) do
        Citizen.Wait(1000)
    end

    TaskStartScenarioInPlace(pedEntity, data.scenario, 0, true)
    SetEntityInvincible(pedEntity, true)
    FreezeEntityPosition(pedEntity, true)
    SetBlockingOfNonTemporaryEvents(pedEntity, true)

    local blipData = data.blip
    local coords = GetEntityCoords(pedEntity)

    if blipData.enabled then
        createBlip(blipData, coords, data.nID)
    end

    local options = createOptions(data)
    exports.ox_target:addEntity(data.nID, options)
end

function createOptions(data)
    local options = {
        {
            name = "ped-" .. data.nID,
            icon = data.type == "Pawnshop" and "fas fa-money-bill" or "fas fa-joint",
            label = data.type == "Pawnshop" and "Speak to pawner" or "Speak to dealer",
            distance = 2,
            onSelect = function()
                openMenu(data.type)
            end
        }
    }

    return options
end

function openMenu(menuType)
    local options = {}
    local totalWorth = 0
    local itemsToSend = {}

    local itemTable = D2D.Peds[menuType].items

    for itemName, itemPrice in pairs(itemTable) do
        local itemCount = exports.ox_inventory:GetItemCount(itemName, nil, true)

        if itemCount and itemCount > 0 then
            local itemTotalWorth = itemCount * itemPrice
            totalWorth = totalWorth + itemTotalWorth

            local itemData = exports.ox_inventory:Items()[itemName]
            local itemLabel = itemData.label
            
            local formattedItemTotalWorth
            if D2D.Framework == 'ESX' then
                formattedItemTotalWorth = ESX.Math.GroupDigits(itemTotalWorth)
            else
                formattedItemTotalWorth = itemTotalWorth
            end

            local option = {
                title = itemCount .. " x " .. itemLabel .. " - £" .. formattedItemTotalWorth,
                icon = "box"
            }

            table.insert(options, option)

            table.insert(itemsToSend, {name = itemName, count = itemCount})
        else
            Debug("Skipping item", itemName, "as its count is 0 or nil.")
        end
    end

    local formattedTotalWorth = ESX.Math.GroupDigits(totalWorth)

    lib.registerContext(
        {
            id = "shopping_list",
            title = menuType,
            menu = "sell_menu",
            options = options
        }
    )

    lib.registerContext(
        {
            id = "sell_menu",
            title = menuType,
            options = {
                {
                    title = "Total Worth: £" .. formattedTotalWorth,
                    description = "Check out the breakdown.",
                    menu = "shopping_list",
                    icon = "cart-shopping"
                },
                {
                    title = "Sell Items",
                    description = "Sounds like a pretty good deal.",
                    icon = "check",
                    onSelect = function()
                        if totalWorth <= 0 then -- If they dont have any items to sell it wont give them any money!
                            Debug("You don't have any items to sell")
                        else
                            TriggerServerEvent("D2D-PedUtils:sellItems", itemsToSend, menuType)
                        end
                    end
                }
            }
        }
    )

    lib.showContext("sell_menu")
end

RegisterNetEvent("D2D-PedUtils:sendPeds")
AddEventHandler(
    "D2D-PedUtils:sendPeds",
    function(peds)
        clientPeds = peds
        for _, data in pairs(clientPeds) do
            handlePedData(data)
        end
        Debug("Peds received in client: Ox_Target Added.")
    end
)

AddEventHandler(
    "onResourceStop",
    function(resourceName)
        if GetCurrentResourceName() == "D2D-PedUtils" then
            for _, blipId in pairs(blips) do
                RemoveBlip(blipId)
            end
        end
    end
)
