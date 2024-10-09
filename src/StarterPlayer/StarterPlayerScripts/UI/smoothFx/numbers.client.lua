--!strict

local tws = game:GetService('TweenService')
local player = game.Players.LocalPlayer
local ances = player.PlayerGui:WaitForChild('ScreenGui')
local textInstances = ances.instances
local deb = tick()
for _,textinstance:ObjectValue in pairs(textInstances:GetChildren()) do 
	local	value= textinstance.Value.value
	value:GetPropertyChangedSignal('Value'):Connect(function()
		local info = TweenInfo.new(1,Enum.EasingStyle.Exponential,Enum.EasingDirection.Out)
		local tw = tws:Create(value.DisplayedValue,info,{Value = value.Value })
		tw:Play()
		
		textinstance.Value.under.Text = ''
 
	end)
	value.DisplayedValue:GetPropertyChangedSignal('Value'):Connect(function()
		textinstance.Value.Text = tostring(math.round(value.DisplayedValue.Value*10)/10)
	end)
end

--[[
local textInstances:{typeof(ances.currencies.resistence.TextLabel)} = {
	ances.currencies.resistence.TextLabel,
	ances.currencies.perception.TextLabel,
	ances.currencies.agility.TextLabel,
	ances.currencies.stamina.TextLabel,
	ances.currencies.power.TextLabel,
	ances.currencies.cash.TextLabel,
}
]]
--miscUi:FireClient(player, {family = 'popUp', kid = 'power', amount = 100})