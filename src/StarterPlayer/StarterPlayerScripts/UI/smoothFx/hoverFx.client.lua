--!strict

local tws = game:GetService('TweenService')

local windowTweens 	= require(game.ReplicatedStorage.Modules.ui.windowTweens)
local popup			= require(game.ReplicatedStorage.Modules.ui.popUps)
local sacred 		= require(game.ReplicatedStorage.Modules.SACRED)

local reqdata = game.ReplicatedStorage.Remotes.requestData
local miscUi  = game.ReplicatedStorage.Remotes.miscUi

local instances:{[string]:{size:UDim2, z:number, tween:Tween?,animateTo:number }} = {}
task.wait(1)

-- ==========================
-- HOVER Size animations 
local player = game.Players.LocalPlayer
local ances = player.PlayerGui:WaitForChild('ScreenGui')

local hoverExceptions = {'backPackSlot'} 
local animduration = 0.1
function createTween(instance,to:UDim2)
	local goal = { Size = UDim2.new(to.X.Scale ,0,to.Y.Scale,0) }
	if instance:FindFirstChild('forwardTweenTo') then 
		instance = instance:FindFirstChild('forwardTweenTo').Value 
		goal = { Size = UDim2.new(to.X.Scale ,0,to.Y.Scale,0) }
	end 
	return tws:Create(instance, TweenInfo.new(animduration), goal)
end

function GetInstanceByFullName(fullName)
	local segments = fullName:split(".")
	local current = game

	for _,location in pairs(segments) do
		current = current[location]
	end

	return current
end


function hover(instanceFullName:string?)
	for fullname, _ in pairs(instances) do
		if fullname==instanceFullName then continue end
		local button:ImageButton = GetInstanceByFullName(fullname)
		local size = instances[fullname].size
		button.ZIndex = instances[fullname].z
		
		local k = instances[fullname]
		if k.tween  then k.tween:Cancel() k.tween:Destroy() k.tween=nil end
		k.tween = createTween(button,size):Play()
	end 
	if instanceFullName  then
		local size = instances[instanceFullName].size
		local animateTo = instances[instanceFullName].animateTo
		local button:ImageButton & {occupied:StringValue} = GetInstanceByFullName(instanceFullName)
		if table.find(hoverExceptions,button.Name) or (button:FindFirstChild('occupied') and table.find(hoverExceptions,button.occupied.Value)) then return end
		local k = instances[instanceFullName]
		if k.tween  then k.tween:Cancel() k.tween:Destroy() k.tween=nil end
		k.tween = createTween(button, size + UDim2.new(animateTo,0,animateTo,0)):Play()
		button.ZIndex = instances[instanceFullName].z * 2
	end
end

local currentlyHovering:string? = nil
function init(parent:Frame)
	local kids = parent:GetDescendants() 
	if parent:FindFirstChild('_hide') then table.insert(kids, parent:FindFirstChild('_hide')) end
	for name,button:Instance & ImageButton in pairs(kids) do
		if button:IsA('ImageButton') then
			if button:FindFirstChild('forwardTweenTo') then
				instances[button:GetFullName()] = { size = button:FindFirstChild('forwardTweenTo').Value.Size, z = button.ZIndex,animateTo = 0.3 }
			else
				instances[button:GetFullName()] = { size = button.Size, z = button.ZIndex,animateTo = 0.015 }
			end
			button.MouseEnter:Connect(function()
				currentlyHovering = button:GetFullName()
				hover(button:GetFullName())
			end)  
			button.MouseLeave:Connect(function()
				if button:GetFullName()	== currentlyHovering then hover(nil) currentlyHovering = nil end
			end)
		end
	end	
end 

init(ances.menus.dailyRewards) init(ances.menus.backpack) init(ances.menus.store) init(ances.menus.vip)
init(ances.claymaker) init(ances.Training) init(ances.gymShop) init(ances.main)
 


