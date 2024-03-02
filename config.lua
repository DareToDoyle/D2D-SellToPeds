D2D = {}

D2D.Debug = false -- Print debugging statements in server/client console.

D2D.Framework = 'ESX' -- ESX | OTHER : I am only adding a "framework check" because I personally use ESX.Math.GroupDigits() to add commas to the menu, you can replace this with your frameworks relevant function (client.lua - 103)

D2D.PoliceNeeded = true -- Require police to be online to sell to the ped

D2D.PoliceJobName = 'police'

D2D.PoliceAmount = 2

D2D.Peds = {
    ["Pawnshop"] = {
        settings = {
            money = "black_money" -- money | bank | black_money
        },
        blip = {
            enabled = true,
            colour = 5,         -- https://docs.fivem.net/docs/game-references/blips/
            sprite = 674,
            scale = 1.0,
            name = "Pawnshop"
        },
        ped = {
            model = "a_m_m_hasjew_01", --https://docs.fivem.net/docs/game-references/ped-models/
            scenario = "WORLD_HUMAN_HANG_OUT_STREET_CLUBHOUSE" -- https://wiki.rage.mp/index.php?title=Scenarios
        },
        coords = {
            { x = 2684.7449, y = 3515.3157, z = 52.3038, h = 84.9249 },
        },
        items = {
            ["lamp"] = 150,
            ["wd40"] = 200,
            ["manual"] = 650,
            ["diary"] = 1500,
            ["phone"] = 1000,
            ["tetriz"] = 3000,
            ["greenbat"] = 3500,
            ["skullring"] = 5000,
            ["goldenrooster"] = 6500,
            ["bitcoin"] = 12500,
            ["gpu"] = 15000
        }
    },
    ["Drugs"] = {
        settings = {
            money = "black_money" -- money | bank | black_money
        },
        blip = {
            enabled = true,
            colour = 50,
            sprite = 51,
            scale = 1.0,
            name = "Dealer"
        },
        ped = {
            model = "g_m_y_ballaeast_01",
            scenario = "WORLD_HUMAN_STAND_MOBILE"
        },
        coords = {
            { x = 83.6032, y = -1973.6638, z = 19.9299, h = 323.4721 },
        },
        items = {
            ["weed"] = 750,
            ["oxy"] = 1200,
            ["package"] = 120,
            ["stim_sj6"] = 350,
            ["stim_adrenaline"] = 350,
            ["stim_etgc"] = 350,
            ["stim_morphine"] = 350,
            ["stim_l1"] = 350,
            ["stim_obdolbos"] = 350,
        }
    }
}

function Debug(statement)
    if D2D.Debug then
        print(statement)
    end
end
