--!nonstrict

local run = game:GetService('RunService')
local players = game:GetService('Players')

local petManager = require(script.Parent.petManager)
local PetAnimator = require(game.ReplicatedStorage.Modules.pets.PetAnimator)

local animateRemote = game.ReplicatedStorage.Remotes.animatePet

players.PlayerRemoving:Connect(function(player)petManager:DetachPet(player.UserId)end)
game.Workspace:WaitForChild('prox').ProximityPrompt.TriggerEnded:Connect(function(player) petManager:PlayerToPet(player) end)

animateRemote.OnServerEvent:Connect(function(player,whatToDo,AnimationOrPosition) 

	if 		 whatToDo =='play'  then PetAnimator:Play (player.UserId, AnimationOrPosition) 
	elseif whatToDo =='stop'  then PetAnimator:Stop (player.UserId, AnimationOrPosition)
	elseif whatToDo =='place' then PetAnimator:Place(player.UserId, AnimationOrPosition) end
	
end)


run.Stepped:Connect(function()
	local t = tick()
	for userid,connection in pairs(PetAnimator.connections) do		
		local reg = PetAnimator.stateRegister[userid]
		if reg.registredState ~= connection.state then
			reg.registredState = connection.state
			reg.level = 1
			reg.registredTick = t
		elseif t - reg.registredTick > 4*reg.level  then
			reg.level += 1
			reg.registredTick = t
			PetAnimator:TriggetEmotion(userid)
		end
	end
end)
