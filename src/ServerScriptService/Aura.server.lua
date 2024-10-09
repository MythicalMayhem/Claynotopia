--!strict
local sacred = require(game.ReplicatedStorage.Modules.SACRED)
local playerManager = require(game.ServerScriptService.playerData)
local gameInfo = require(game.ServerScriptService.gameData)

local requestRem = game.ReplicatedStorage.Remotes.requestData
local auraRemote = game.ReplicatedStorage.Remotes.aura

auraRemote.OnServerEvent:Connect(function(player,what,which)
	if what=='attach' then
		if  table.find(playerManager[player.UserId].auras,which)==nil then return end
		local att:Attachment = player.Character.HumanoidRootPart.RootAttachment
		local clo = game.ReplicatedStorage.assets.auras[which].Attachment:Clone()
		att:ClearAllChildren()
		clo.Parent = att clo.CFrame *= CFrame.new(0,0.5,1)
		playerManager[player.UserId].equipped = which
		playerManager:sendUpdate(player.UserId)
		
	elseif what == 'roll' then 
	end
end)
 
 