--!nonstrict

local run = game:GetService("RunService")
local players = game:GetService("Players")

local animateRem:RemoteEvent = game.ReplicatedStorage.Remotes.animatePet
local PetStateMachine = require(game.ReplicatedStorage.Modules.pets.PetStateMachine)
local playerManager = require(game.ServerScriptService.playerData)
local PetAnimator = require(game.ReplicatedStorage.Modules.pets.PetAnimator)
local petManager = require(script.Parent.petManager)
local path = require(game.ReplicatedStorage.Modules.pets.PetPath)
 
players.PlayerRemoving:Connect(function(player)
	petManager:DetachPet(player.UserId)
end)
game.Workspace:WaitForChild("prox").ProximityPrompt.TriggerEnded:Connect(function(player)
	petManager:PlayerToPet(player)
end)

animateRem.OnServerEvent:Connect(function(player)
	PetAnimator:Play(player.UserId, 'back')
end)

run.Stepped:Connect(function()
	local t = tick()
	for userid, connection in pairs(PetAnimator.connections) do
		local activity = playerManager.connections[userid].activity
		local char = players:GetPlayerByUserId(userid).Character
		local petState = path:place(activity, char.PrimaryPart, connection.instance.Parent) or "idle"
		PetStateMachine:SetState(userid, connection.instance.Name, petState)
		
		local reg = PetAnimator.stateRegister[userid]
		if reg.registredState ~= connection.state then
			reg.registredState = connection.state
			reg.level = 1
			reg.registredTick = t
		elseif t - reg.registredTick > 4 * reg.level then
			reg.level += 1
			reg.registredTick = t
			PetAnimator:TriggetEmotion(userid)
		end
		
	end
end)
