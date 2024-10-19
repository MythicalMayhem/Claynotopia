--!strict
local gameInfo = {
	claymaker = {
		green = {
			{ name = "orange", chance = 50 }, { name = "green", chance = 20 }, { name = "dactyl", chance = 20 }, 
			{ name = "flea", chance = 10 }, { name = "gray", chance = 10 },
		},
		blue = {
			{ name = "lean", chance = 50 }, { name = "otheryasmin", chance = 20 }, { name = "dactly", chance = 20 }, 
			{ name = "yellow", chance = 10 }, { name = "brown", chance = 10 },
		},
		pink = {
			{ name = "rot", chance = 50 }, { name = "yasmin", chance = 20 }, { name = "tyson", chance = 20 }, 
			{ name = "lightblue", chance = 10 }, { name = "buzz", chance = 10 },
		},
	},
	aura = {
		items = {
			{ name = "dbzred", chance = 50 },
			{ name = "dbzyellow", chance = 20 },
			{ name = "whitestar", chance = 10 },
			{ name = "tyson", chance = 20 },
			{ name = "buzz", chance = 10 },
		},
	},
}

function gameInfo:GetData(what: string)
	if what == "claymaker" then
		local res = { green = {}, pink = {}, blue = {} }
		for i = 1, 5 do
			table.insert(res.green, gameInfo.claymaker.green[i].name)
			table.insert(res.pink, gameInfo.claymaker.pink[i].name)
			table.insert(res.blue, gameInfo.claymaker.blue[i].name)
		end
		print(res)
		return res
	end

	return {}
end

return gameInfo
