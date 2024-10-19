--!strict

local uis = game:GetService('UserInputService')


local dataSetter   = require(script.Parent.setData)
local windowTweens = require(game.ReplicatedStorage.Modules.ui.windowTweens)
local localplrModule = require(game.ReplicatedStorage.Modules.LocalPlayer)
local popup	= require(game.ReplicatedStorage.Modules.ui.popUps)
local cameraMod = require(game.ReplicatedStorage.Modules.ui.camera)

local reqdata = game.ReplicatedStorage.Remotes.requestData

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()

local character = player.Character
local humanoid:Humanoid = character:WaitForChild('Humanoid')

local ances = player.PlayerGui:WaitForChild('ScreenGui')
local training = ances.Training
local staminaBar = ances.staminaBar

local clickConnection = nil
local gymRem = game.ReplicatedStorage.Remotes.gym
windowTweens:addWindow('default',staminaBar) 
windowTweens:addWindow('training',training,function() 
	gymRem:FireServer('QUIT') 
	cameraMod:Unset()
	if clickConnection then clickConnection:Disconnect()end 
end,
function()
	windowTweens:showWindow('default','staminaBar',true)
	cameraMod:Set(character.PrimaryPart.CFrame.Position + Vector3.new(0,3.2,0))
end,false)

local lastClick = tick()
local conn:RBXScriptConnection = nil

gymRem.OnClientEvent:Connect(function(eventType,data)
	if eventType=='attach' then
		if conn then conn:Disconnect() end
		conn = uis.InputEnded:Connect(function(inp,p)
			if p then return end
			if inp.KeyCode==Enum.KeyCode.Space then
				windowTweens:hideWindow('training',training.Name)
			end
		end)
		windowTweens:showWindow('training','Training')
		windowTweens:freezePlayer(true)
		clickConnection = mouse.Button1Down:Connect(function()
			local t = tick()
			if t - lastClick > 0.1 then
				gymRem:FireServer('CLICK')
				lastClick = t
			end 
		end)
		return
	end
end)

for i,v in pairs(ances.Training.weight:GetDescendants()) do
	if not v:IsA('ImageButton') then continue end
	v.MouseButton1Down:Connect(function()
		gymRem:FireServer('CHANGE',v.Name)
	end)
end

