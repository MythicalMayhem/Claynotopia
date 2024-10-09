--!strict
local players = game:GetService('Players')
local playersManager = require(game:GetService('ServerScriptService').playerData)

players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		playersManager:GetData(player.UserId)
		playersManager:setUpMuscles(player.UserId)
	end)
end)
 
  
 
 