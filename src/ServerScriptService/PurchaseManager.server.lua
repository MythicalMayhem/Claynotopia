--!strict
local requestRem = game.ReplicatedStorage.Remotes.requestData
local purchaseRem = game.ReplicatedStorage.Remotes.purchase
local gameData  = require(game.ServerScriptService.gameData)
local playerModule = require(game.ServerScriptService.playerData)

purchaseRem.OnServerEvent:Connect(function(player,reqData)
	if reqData.family == 'claymaker' then			
		local shopItems = gameData.claymaker.items
		local luck = math.random(1,100)
		local candidate = nil
		for i,item in pairs(shopItems) do
			if not candidate then  candidate=item continue end
			if luck < item.chance then
				if item.chance<candidate.chance then
					candidate = item
				elseif item.chance==candidate.chance then
					local k = math.random(1,2)
					local l = {item, candidate}
					candidate = l[k]
				end
			end
		end
		print(reqData.origin)
		playerModule:AddPetToBackPack(player.UserId,candidate.name)
		purchaseRem:FireClient(player, {family = 'claymakereward', child = candidate ,origin = reqData.origin})
		requestRem:FireClient(player,'playerData',playerModule:GetData(player.UserId))
	end
end)
 