--!strict
local PetManager    = require(script.Parent.petManager)
local activity  	= require(script.Parent.gymActivity)
local types = require(game.ReplicatedStorage.Modules.typing)
local gymRem = game.ReplicatedStorage.Remotes.gym
local gymEq  = workspace.gym.equipment



--local thingstoload = gymEq:GetDescendants() for _,v in pairs(thingstoload) do  repeat wait() until v  end
 --! URGENT ---??================ CREATE LOADING SCRIPT FOR ALL THOSE
local acts = {}
function setup (kids)
	for name,act:types.gym_equipment_model in pairs(kids) do	
		local prox = act.main.prox.ProximityPrompt
		prox.Triggered:Connect(function(player:Player)
			prox.Enabled = false
			activity:attachPlayerToEquipment(player,act)
			gymRem:FireClient(player,'attach',prox:FindFirstAncestorOfClass('Folder').Name)
		end)
	end
end

setup(gymEq.chest:GetChildren())
setup(gymEq.arms:GetChildren())
setup(gymEq.stamina:GetChildren()) 
setup(gymEq.legs:GetChildren())
setup(gymEq.back:GetChildren())


gymRem.OnServerEvent:Connect(function(player,data,other)
	if data=='QUIT'   then return activity:detach(player) end
	if data=='CLICK'  then return activity:click(player) end
	if data=='CHANGE' then return activity:changeWeight(player.UserId,other) end
end)
 
 