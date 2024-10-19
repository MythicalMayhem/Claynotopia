--!strict
local players = game:GetService("Players")

local playerData = require(game.ServerScriptService.playerData)
local gameData = require(game.ServerScriptService.gameData)
local petManager = require(script.Parent.petManager)

local requestRem = game.ReplicatedStorage.Remotes.requestData

players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		playerData:GetData(player.UserId)
		playerData:setUpMuscles(player.UserId)
	end)
end)

players.PlayerAdded:Connect(function(player)
	local data = playerData:GetData(player.UserId)
	requestRem:FireClient(player, "playerData", data)
end)

requestRem.OnServerEvent:Connect(function(player, whatDoesHeWant, other)
	if whatDoesHeWant == "playerData" then
		playerData:sendUpdate(player.UserId)
	elseif whatDoesHeWant == "claymaker" then
		local data = gameData:GetData("claymaker")
		requestRem:FireClient(player, "claymaker", data)
	elseif whatDoesHeWant == "attach" then
		petManager:AttachPetToPlayer(other, player.UserId)
		playerData:sendUpdate(player.UserId)
	elseif whatDoesHeWant == "rankup" then
		  playerData:RankUp(player.UserId)  playerData:sendUpdate(player.UserId) 
	end
end)

