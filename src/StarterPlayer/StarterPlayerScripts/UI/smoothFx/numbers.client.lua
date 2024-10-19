--!strict

local tws = game:GetService('TweenService')
local player = game.Players.LocalPlayer
local ances = player.PlayerGui:WaitForChild('ScreenGui')

for _,img:ObjectValue in pairs(ances.currencies:GetChildren()) do 
	local	value= img.TextLabel.value
	value:GetPropertyChangedSignal('Value'):Connect(function()
		local info = TweenInfo.new(1,Enum.EasingStyle.Exponential,Enum.EasingDirection.Out)
		local tw = tws:Create(value.DisplayedValue,info,{Value = value.Value })
		tw:Play() 
	end)

	value.DisplayedValue:GetPropertyChangedSignal('Value'):Connect(function() img.TextLabel.Text = tostring(math.round(value.DisplayedValue.Value*10)/10) end)
end
 