--!strict

local sacred 		= require(game.ReplicatedStorage.Modules.SACRED)
local windowTweens 	= require(game.ReplicatedStorage.Modules.ui.windowTweens)
local claymakerCutscene = require(game.ReplicatedStorage.Modules.ux.claymakerCutscene)

local player = game.Players.LocalPlayer
local mouse	 = player:GetMouse() 
local character repeat task.wait() character = player.Character until character 

local data = game.ReplicatedStorage.Remotes.requestData
local purchase = game.ReplicatedStorage.Remotes.purchase
  
local ances = player.PlayerGui:WaitForChild('ScreenGui')
local claymakerFrame = ances.claymaker 
windowTweens:addWindow('default',claymakerFrame,function() windowTweens:blur(false) end)
windowTweens:addWindow('reward',ances.Reward)

local claymakerProx= workspace.uiParts:WaitForChild('claymaker'):GetDescendants()

local origin = nil
for i,prox in pairs(claymakerProx) do
	if prox:IsA('ProximityPrompt') then
		prox.Triggered:Connect(function()
			windowTweens:showWindow('default','claymaker')
			origin = prox.Parent.Name
		end)
	end
end

local hidden = true
claymakerFrame.ImageLabel.one.MouseButton1Up:Connect(function() 
	purchase:FireServer({ family = 'claymaker',origin=origin}) 
end)
purchase.OnClientEvent:Connect(function(data)
	if data.family=="claymakereward" then
		claymakerCutscene:play(data.origin,function()		
			hidden = false
			local frame:typeof(script:FindFirstAncestorOfClass('ScreenGui').Reward)= windowTweens:showWindow('reward','Reward',true)
			frame.ImageLabel.Image 	= sacred.assets.dinos[data.child.name]
			frame.TextLabel.Text 	= data.child.name
			mouse.Button1Down:Once(function() windowTweens:hideWindow('reward','Reward',true) hidden = true end)
			task.wait(3)
			windowTweens:hideWindow('reward','Reward',true) 
			hidden  = true

		end) 
	end
end)

local rings = {
	workspace:WaitForChild('Clays'):WaitForChild("pink"):WaitForChild('Model'):WaitForChild('circle'),
	workspace:WaitForChild('Clays'):WaitForChild("blue"):WaitForChild('Model'):WaitForChild('circle'),
	workspace:WaitForChild('Clays'):WaitForChild("green"):WaitForChild('Model'):WaitForChild('circle')
}
function checkRegion(part)
	local params = OverlapParams.new()
	params.FilterType =Enum.RaycastFilterType.Include
	params.FilterDescendantsInstances = { character }
	local res = workspace:GetPartsInPart(part,params) 
	return #res > 0 
end
rings[1].Transparency = 1
rings[2].Transparency = 1
rings[3].Transparency = 1 
local current = 0
while task.wait(0.25) do
	if not hidden then continue	end
	if checkRegion(rings[1].Part) then
		rings[1].Transparency = 0
		rings[2].Transparency = 1
		rings[3].Transparency = 1
		origin = rings[1].Parent.Parent.Name
		windowTweens:showWindow('default','claymaker')
		current = 1
	elseif checkRegion(rings[2].Part) then
		rings[1].Transparency = 1
		rings[2].Transparency = 0
		rings[3].Transparency = 1
		origin = rings[2].Parent.Parent.Name
		windowTweens:showWindow('default','claymaker')
		current = 2
	elseif checkRegion(rings[3].Part) then
		rings[1].Transparency = 1
		rings[2].Transparency = 1
		rings[3].Transparency = 0
		origin = rings[3].Parent.Parent.Name
		windowTweens:showWindow('default','claymaker')
		current = 3
	else
		current = (current + 1) % 3 +1
		rings[(current + 2) % 3 + 1].Transparency = 0
		rings[(current + 1) % 3 + 1].Transparency = 0
		rings[current].Transparency = 1
		windowTweens:hideWindow('default','claymaker')
	end
end