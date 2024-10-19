--!strict

local sacred = require(game.ReplicatedStorage.Modules.SACRED)
local windowTweens = require(game.ReplicatedStorage.Modules.ui.windowTweens)
local shopUiBindable = game.ReplicatedStorage.Bindables.shopUi
local purchaseRem = game.ReplicatedStorage.Remotes.purchase

local player = game.Players.LocalPlayer
local ances = player.PlayerGui:WaitForChild("ScreenGui")
local gymShop = ances.gymShop

local skinbtn: ImageButton = gymShop.ImageLabel.skinButton
local skinFrame: Frame = gymShop.ImageLabel.skin

local foodbtn: ImageButton = gymShop.ImageLabel.foodButton
local foodFrame: Frame = gymShop.ImageLabel.food

local gymStoreProx = workspace.uiParts:WaitForChild("gymShop"):WaitForChild("ProximityPrompt")

gymStoreProx.Triggered:Connect(function()
	windowTweens:showWindow("default", "gymShop")
end)
windowTweens:addWindow("default", gymShop)
shopUiBindable.Event:Connect(function(shopName)
	windowTweens:showWindow("default", shopName)
end)
foodbtn.MouseButton1Up:Connect(function()
	foodFrame.Visible = true
	skinFrame.Visible = false
end)
skinbtn.MouseButton1Up:Connect(function()
	skinFrame.Visible = true
	foodFrame.Visible = false
end)

for i, button in skinFrame:GetChildren() do
	if button:IsA("ImageButton") then
		button.MouseButton1Up:Connect(function()
			button.Parent.preview:FindFirstChildOfClass("ImageLabel").Image = button.Image
			button.Parent.preview:FindFirstChildOfClass("ImageLabel").Name = button.Name
			button.Parent.preview.TextLabel.Text = "10$"
		end)
	end
end

skinFrame.preview.ImageButton.MouseButton1Up:Connect(function()
	purchaseRem:FireServer({ family = "food", child = skinFrame.preview:FindFirstChildOfClass("ImageLabel").Name })
end)
foodFrame.preview.ImageButton.MouseButton1Up:Connect(function() 
	purchaseRem:FireServer({ family = "food", child = foodFrame.preview:FindFirstChildOfClass("ImageLabel").Name })
end)
for i, button in foodFrame:GetChildren() do
	if button:IsA("ImageButton") then
		button.MouseButton1Up:Connect(function()
			button.Parent.preview:FindFirstChildOfClass("ImageLabel").Image = button.Image
			button.Parent.preview:FindFirstChildOfClass("ImageLabel").Name = button.Name
			button.Parent.preview.TextLabel.Text = sacred.food[button.Name] or "free"
		end)
	end
end
