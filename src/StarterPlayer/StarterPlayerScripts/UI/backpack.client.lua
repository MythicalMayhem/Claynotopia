--!strict

local uis = game:GetService('UserInputService')
local requestRem = game.ReplicatedStorage.Remotes.requestData
local windowTweens = require(game.ReplicatedStorage.Modules.ui.windowTweens)

local player = game.Players.LocalPlayer
local ances = player.PlayerGui:WaitForChild('ScreenGui')
local backpack =  ances:WaitForChild('menus'):WaitForChild('backpack')
windowTweens:addWindow('default', backpack)


local slots = backpack:WaitForChild('slots')
for i,button:typeof(slots.best:FindFirstChildOfClass('ImageButton')) in ipairs(slots:GetDescendants()) do
	if button:IsA('ImageButton') and button.Name ~= 'selected' then
		if not button:FindFirstChild('occupied') then local occ = Instance.new('StringValue') occ.Name = 'occupied' occ.Parent = button end
		button.MouseButton1Up:Connect(function()
			requestRem:FireServer('attach',button.occupied.Value)
		end)
	end
end

requestRem:FireServer('playerData')
