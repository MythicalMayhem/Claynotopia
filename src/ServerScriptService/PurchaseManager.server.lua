--!strict
local requestRem = game.ReplicatedStorage.Remotes.requestData
local purchaseRem = game.ReplicatedStorage.Remotes.purchase
local gameData  = require(game.ServerScriptService.gameData)
local playerModule = require(game.ServerScriptService.playerData)
local sacred = require(game.ReplicatedStorage.Modules.SACRED)

purchaseRem.OnServerEvent:Connect(function(player,reqData)
	if reqData.family == 'claymaker' then			
		print(reqData)
		local shopItems = gameData.claymaker[reqData.origin]
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
		playerModule:AddPetToBackPack(player.UserId,candidate.name)
		purchaseRem:FireClient(player, {family = 'claymakereward', child = candidate ,origin = reqData.origin})
		requestRem:FireClient(player,'playerData',playerModule:GetData(player.UserId))
	elseif reqData.family == "food" then
		local price = sacred.food[reqData.child]
		local p = playerModule.connections[player.UserId]
		if price > p.cash then return end
		p.cash -= price 
		playerModule:sendUpdate(player.UserId)
		table.insert(p.food,reqData.child)
	end

end)
 