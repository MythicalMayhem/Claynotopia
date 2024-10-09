--!strict

local prx = game:GetService('ProximityPromptService')
local run = game:GetService('RunService')
local player = game.Players.LocalPlayer

prx.PromptShown:Connect(function(prompt)
	if prompt:FindFirstAncestor('gym') then
		prompt.Parent.Parent.Parent.carpet.glow.Transparency = 0.5
		prompt.Parent.Parent.Parent.main.ui.BillboardGui.Enabled = true
	end
end)
prx.PromptHidden:Connect(function(prompt)
	if prompt:FindFirstAncestor('gym') then
		prompt.Parent.Parent.Parent.carpet.glow.Transparency = 1 
		prompt.Parent.Parent.Parent.main.ui.BillboardGui.Enabled = false
	end 
end)
