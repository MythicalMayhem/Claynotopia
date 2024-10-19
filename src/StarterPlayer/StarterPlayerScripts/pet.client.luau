--!strict 
local run = game:GetService('RunService')
local attachEv = game.ReplicatedStorage.Remotes.attachPet
 

local PetStateMachine = require(game.ReplicatedStorage.Modules.pets.PetStateMachine)

local player = game.Players.LocalPlayer

 
local function character()
	local humanoid:Humanoid = player.Character.Humanoid 
	return humanoid.StateChanged:Connect(function(_,new) 
		if new==Enum.HumanoidStateType.Jumping then
			PetStateMachine:SetState(player.Character.Name,'jump')
		end
	end),
		run.Stepped:Connect(function( )
			local s = tostring(humanoid:GetState())
			local _, End = string.find(s,'HumanoidStateType[\\.]') --if this errored, replace double slash with only one 
			local petState = string.lower(string.sub(s,End or 0 + 1 ,string.len(s)))
			if humanoid.MoveDirection.Magnitude==0 then petState = 'idle'  
			elseif player.Character.PrimaryPart.AssemblyLinearVelocity.Magnitude<1 then petState='walk' 
			elseif table.find({'flying','running'},petState) then petState = 'run' 
		end   
		PetStateMachine:SetState(player.Character.Name,petState)
	end) 
end

local conn1,conn2
attachEv.OnClientEvent:Connect(function(pet:Model,state:string)
	if conn1 then conn1:Disconnect() end
	if conn2 then conn2:Disconnect() end
	if state=='self' then --conn1 = follow(pet)
	elseif state=='pet' then conn1,conn2 = character() end
	
end) 