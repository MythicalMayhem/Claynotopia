--!strict

local windowTweens = require(game.ReplicatedStorage.Modules.ui.windowTweens)
local shopUiBindable = game.ReplicatedStorage.Bindables.shopUi

local player = game.Players.LocalPlayer
local ances = player.PlayerGui:WaitForChild('ScreenGui')
local gymShop = ances.gymShop

local skinbtn:ImageButton = gymShop.ImageLabel.skinButton
local skinFrame:Frame = gymShop.ImageLabel.skin

local foodbtn:ImageButton = gymShop.ImageLabel.foodButton
local foodFrame:Frame = gymShop.ImageLabel.food

 

 

local gymStoreProx = workspace.uiParts:WaitForChild("gymShop"):WaitForChild('ProximityPrompt')
gymStoreProx.Triggered:Connect(function() windowTweens:showWindow('default','gymShop') end)

windowTweens:addWindow('default',gymShop)
shopUiBindable.Event:Connect(function(shopName)
	windowTweens:showWindow('default',shopName)	 
end)

foodbtn.MouseButton1Up:Connect(function()
	foodFrame.Visible = true
	skinFrame.Visible = false
end)

skinbtn.MouseButton1Up:Connect(function()
	skinFrame.Visible = true
	foodFrame.Visible = false
end)

for i,button  in skinFrame:GetChildren() do 
	if button:IsA('ImageButton') then 
		button.MouseButton1Up:Connect(function()
			button.Parent.preview.Image = button.Image
		end)
	end
end
for i,button in foodFrame:GetChildren() do
	if   button:IsA('ImageButton') then  
	 button.MouseButton1Up:Connect(function()
	 	button.Parent.preview.Image = button.Image
	 end)
	end
end
