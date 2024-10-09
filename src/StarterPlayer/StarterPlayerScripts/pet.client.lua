--!strict

local run = game:GetService('RunService')
local uis = game:GetService('UserInputService')
local attachEv = game.ReplicatedStorage.Remotes.attachPet
 
local path 		  = require(game.ReplicatedStorage.Modules.pets.PetPath) 
local PetStateMachine = require(game.ReplicatedStorage.Modules.pets.PetStateMachine)

local player = game.Players.LocalPlayer

local function follow(pet:Model)
	local char = player.Character
	return  run.Stepped:Connect(function()
		local petState = path:place(char.PrimaryPart,pet) or nil  
		PetStateMachine:SetState(pet.Name,petState)
	end)
end

local function character()
	local humanoid:Humanoid = player.Character.Humanoid 
	return humanoid.StateChanged:Connect(function(_,new) 
		if new==Enum.HumanoidStateType.Jumping then
			PetStateMachine:SetState(player.Character.Name,'jump')
		end
	end),
		run.Stepped:Connect(function( )
			local s = tostring(humanoid:GetState())
			local start,End = string.find(s,'HumanoidStateType[\.]')
			local petState = string.lower(string.sub(s,End or 0 + 1 ,string.len(s)))
			if humanoid.MoveDirection.Magnitude==0 then petState = 'idle'  
			elseif player.Character.PrimaryPart.AssemblyLinearVelocity.Magnitude<1 then petState='walk' 
			elseif table.find({'flying','running'},petState) then petState = 'run' end  
			PetStateMachine:SetState(player.Character.Name,petState)
	end) 
end

local conn1,conn2
attachEv.OnClientEvent:Connect(function(pet:Model,state:string)
	--repeat task.wait() until player.Character and pet and pet.PrimaryPart
	if conn1 then conn1:Disconnect() end
	if conn2 then conn2:Disconnect() end
	if state=='self' then conn1 = follow(pet)
	elseif state=='pet' then conn1,conn2 = character() end
end) 