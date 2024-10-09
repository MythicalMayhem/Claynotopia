--!strict

local windowTweens = require(game.ReplicatedStorage.Modules.ui.windowTweens)
local gymStoreProx = workspace.uiParts:WaitForChild("gymShop"):WaitForChild('ProximityPrompt')
local claymakerProx= workspace.uiParts:WaitForChild('claymaker'):GetDescendants()

gymStoreProx.Triggered:Connect(function() windowTweens:showWindow('default','gymShop') end)
--for i,prox in pairs(claymakerProx) do
--if prox:IsA('ProximityPrompt') then
--	prox.Triggered:Connect(function()
--		windowTweens:showWindow('default','claymaker')
--	end)
--end
--end