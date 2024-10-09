--!strict

local players = game:GetService('Players')

local playerData = require(game.ServerScriptService.playerData)
local gameData   = require(game.ServerScriptService.gameData)
local petManager    = require(script.Parent.petManager)

local requestRem = game.ReplicatedStorage.Remotes.requestData

players.PlayerAdded:Connect(function(player)
	local data = playerData:GetData(player.UserId)
	requestRem:FireClient(player,'playerData',data)	
end)

requestRem.OnServerEvent:Connect(function(player,whatDoesHeWant,other)
	if whatDoesHeWant=='playerData' then
		local data = playerData:GetData(player.UserId)
		requestRem:FireClient(player,'playerData',data)		
	elseif whatDoesHeWant=='claymaker' then
		local data = gameData:GetData('claymaker')
		requestRem:FireClient(player,'claymaker',data)
	elseif whatDoesHeWant=='attach' then
		petManager:AttachPetToPlayer(other,player.UserId)
		local data = playerData:GetData(player.UserId)
		requestRem:FireClient(player,'playerData',data)
	end
end)  
