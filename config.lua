D2D = {}

D2D.Debug = false -- Print debugging statements in server/client console.

D2D.Framework = 'ESX' -- ESX | OTHER : I am only adding a "framework check" because I personally use ESX.Math.GroupDigits() to add commas to the menu, you can replace this with your frameworks relevant function.

D2D.Peds = {
    ["Pawnshop"] = {
	    settings = {
		    spawn = "All", -- All or Random (Random spawns 1 ped from table below)
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
            { x = 81.1592, y = 6643.9668, z = 31.9276, h = 147.3101 },
            { x = 2684.7449, y = 3515.3157, z = 53.3038, h = 84.9249 },
            { x = -1321.2683, y = 303.4568, z = 64.6637, h = 199.9305 },
            { x = -954.3453, y = -2043.9355, z = 9.5100, h = 27.6736 }
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
		    spawn = "All", -- All or Random (Random spawns 1 ped from table below)
			randomPrices = true, -- Prices slightly fluxtuate in value
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
		   { x = 83.6032, y = -1973.6638, z = 20.9299, h = 323.4721 },
		   { x = 938.4260, y = -1729.4460, z = 32.1596, h = 80.9398 },
		   { x = 1969.3264, y = 3809.6953, z = 32.3713, h = 198.0623 },
		   { x = -695.5302, y = 5802.1841, z = 17.3309, h = 67.8181 }
        },
		items = {
		    ["weed"] = 550,
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
