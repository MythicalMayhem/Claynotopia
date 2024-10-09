--!strict

local uis = game:GetService('UserInputService')


local dataSetter   = require(script.Parent.setData)
local windowTweens = require(game.ReplicatedStorage.Modules.ui.windowTweens)
local popup	= require(game.ReplicatedStorage.Modules.ui.popUps)

local reqdata = game.ReplicatedStorage.Remotes.requestData

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local character = player.Character
local humanoid:Humanoid = character:WaitForChild('Humanoid')

local ances = player.PlayerGui:WaitForChild('ScreenGui')
local training = ances.Training

local clickConnection = nil
local gymRem = game.ReplicatedStorage.Remotes.gym
windowTweens:addWindow('training',training,function()
	camera.CameraType = Enum.CameraType.Custom
	gymRem:FireServer('QUIT') 
	if clickConnection then clickConnection:Disconnect()end 
	windowTweens:freezePlayer(false)
end,nil,false)


local lastClick = tick()
gymRem.OnClientEvent:Connect(function(eventType,data)
	if eventType=='attach' then
		local conn:RBXScriptConnection = nil
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

