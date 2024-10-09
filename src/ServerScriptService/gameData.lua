--!strict
local gameInfo = {
	claymaker = {
		items = {
			{ name = 'orange', chance = 50 },
			{ name = 'dactly', chance = 20 },
			{ name = 'tyson' , chance = 20 },
			{ name = 'yasmin', chance = 10 },
			{ name = 'buzz'	 , chance = 10 },
		}
	},
	aura = {
		items = {
			{ name = 'dbzred', chance = 50 },
			{ name = 'dbzyellow', chance = 20 },
			{ name = 'whitestar', chance = 10 },
			{ name = 'tyson' , chance = 20 },
			{ name = 'buzz'	 , chance = 10 },
		}
	}
} 

function gameInfo:GetData(data)
	if gameInfo[data] then
		return table.clone(gameInfo[data])
	end
	return {}
end

return gameInfo
