ESX = exports["es_extended"]:getSharedObject()

local clientPeds = {}

local isPedDeleted = true

function createBlip(blipData, coords, dataID)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, blipData.sprite)
    SetBlipScale(blip, blipData.scale)
    SetBlipColour(blip, blipData.colour)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(blipData.name)
    EndTextCommandSetBlipName(blip)
    SetBlipAsShortRange(blip, true)
    return blip
end

function handlePedData(data)
    local modelhash = GetHashKey(data.ped.model)
    RequestModel(modelhash)

    while not HasModelLoaded(modelhash) do
        Citizen.Wait(50)
    end

    if isPedDeleted then
        local ped = CreatePed(26, modelhash, data.coords.x, data.coords.y, data.coords.z, data.coords.h, false, true)
        SetModelAsNoLongerNeeded(modelhash)
        TaskStartScenarioInPlace(ped, data.scenario, 0, true)
        SetEntityInvincible(ped, true)
        FreezeEntityPosition(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        local options = createOptions(data)
        exports.ox_target:addLocalEntity(ped, options)
        isPedDeleted = false
    end
    SetModelAsNoLongerNeeded(modelhash)
end


for pedType, pedData in pairs(D2D.Peds) do

    for _, coordData in ipairs(pedData.coords) do

        local point = lib.points.new({
            coords = vec3(coordData.x, coordData.y, coordData.z),
            distance = 30.0,

            onEnter = function(self)
                if isPedDeleted then
                    handlePedData({
                        type = pedType,
                        ped = pedData.ped,
                        scenario = pedData.ped.scenario,
                        coords = coordData
                    })
                end
            end
        })

        local blipData = pedData.blip

        local blip = createBlip(blipData, vec3(coordData.x, coordData.y, coordData.z), 0)
    end
end


function createOptions(data)
    local options = {
        {
            name = "ped-" .. data.type,
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
                        if totalWorth <= 0 then
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

RegisterNetEvent("D2D-PedUtils:anim")
AddEventHandler(
    "D2D-PedUtils:anim",
    function(peds)
        lib.progressCircle({
            duration = 15000,
            position = 'bottom',
            useWhileDead = false,
            canCancel = false,
            disable = {
                car = true,
                move = true,
                mouse = true,
            },
            scenario = "WORLD_HUMAN_STAND_IMPATIENT_FACILITY",
        })
    end)

