--!strict

local windowTweens = require(game.ReplicatedStorage.Modules.ui.windowTweens)
local player = game.Players.LocalPlayer
local ances = player.PlayerGui:WaitForChild('ScreenGui') 
local camera = workspace.CurrentCamera

windowTweens:addWindow('default',ances.menus.vip)
windowTweens:addWindow('default',ances.menus.codes)
windowTweens:addWindow('default',ances.menus.store)
windowTweens:addWindow('default',ances.menus.dailyRewards)


for i,button:ImageButton in pairs(ances.main:GetChildren()) do
	if button:IsA('ImageButton') then button.MouseButton1Up:Connect(function() windowTweens:toggle('default', button.Name) end) end
end

function on() 
	local model = game.Workspace.Aura
	player.Character.Archivable = true
	local character = player.Character:Clone() 
	player.Character.Archivable = false
	character.HumanoidRootPart.Anchored = true
	character.Name='dummy'
	task.wait(0.1)
	character.HumanoidRootPart.RootAttachment:ClearAllChildren()
	model.PrimaryPart.Rig:ClearAllChildren()
	character:PivotTo(model.PrimaryPart.Rig.WorldCFrame)
	character.Parent = model.PrimaryPart.Rig
	ances.main.Visible = true
	ances.currencies.Visible = true
	camera.CameraType = Enum.CameraType.Scriptable
	camera.CFrame = model.PrimaryPart.Camera.WorldCFrame
end

local selected 
function off()
	ances.main.Visible = true
	ances.currencies.Visible = true
	local model = game.Workspace.Aura
	camera.CameraType = Enum.CameraType.Custom
	pcall(function() model.PrimaryPart:FindFirstAncestorOfClass("Model"):Destroy() end)
end
windowTweens:addWindow('default', ances.menus.aura, off, on, false)

function attachAura(name)
	if selected then selected:Destroy() end
	local model = game.Workspace.Aura.PrimaryPart:FindFirstAncestorOfClass("Model")
	selected = game.ReplicatedStorage.Auras[name]:Clone()
	selected.Parent = model.PrimaryPart
end