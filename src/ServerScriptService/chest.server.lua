--!strict
local chests = workspace.uiParts:WaitForChild('chest')
local playerData = require(game.ServerScriptService.playerData)
local requestData = game.ReplicatedStorage.Remotes.requestData
local miscUi = game.ReplicatedStorage.Remotes.miscUi

local daily = chests.daily  
daily.ProximityPrompt.Triggered:Connect(function(player)
	if tick() - playerData.connections[player.UserId].chests['daily'] > 60*60*24 then
		playerData.connections[player.UserId].power += 100
		playerData.connections[player.UserId].chests['daily'] = tick()
		miscUi:FireClient(player, {family = 'popup', child = 'power', amount = 100})
	end
end)

 
 

