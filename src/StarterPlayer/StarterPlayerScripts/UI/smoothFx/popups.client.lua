--!strict

local popup			= require(game.ReplicatedStorage.Modules.ui.popUps)
local reqdata = game.ReplicatedStorage.Remotes.requestData
local miscUi  = game.ReplicatedStorage.Remotes.miscUi


miscUi.OnClientEvent:Connect(function(data)
	if data.family == 'popup' then
		reqdata:FireServer('playerData')  
		popup:create(  data.child,data.amount)
	end
end)