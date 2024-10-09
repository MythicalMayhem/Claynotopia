--!strict
local tws = game:GetService('TweenService')
local sacred = require(game.ReplicatedStorage.Modules.SACRED)
local player = game.Players.LocalPlayer

local module = {}
module.isPlaying = false
module.tracks = {}

function init()
	for i,machine in pairs(workspace.Clays:GetChildren()) do
		local humanoid:Humanoid = machine:WaitForChild('Humanoid')
		local animator:Animator = humanoid:WaitForChild('Animator')
		local animation = Instance.new('Animation')
		animation.AnimationId = 'rbxassetid://'..tostring(sacred.claymaker.animations[machine.Name])
		animation.Parent = animator
		module.tracks[machine.Name] = animator:LoadAnimation(animation)
		module.tracks[machine.Name].Priority = Enum.AnimationPriority.Action4
		
	end
end
init()


function module:play(name:string,cb)
	local eggModel = game.ReplicatedStorage.assets.eggs.template:Clone()
	eggModel.Position = workspace.Clays[name].PrimaryPart.EggPosition.WorldCFrame.Position
	
	
	local camera = workspace.CurrentCamera
	local scg = player.PlayerGui.ScreenGui
	player.Character.Parent = nil
	scg.Enabled = false
	camera.Blur.Enabled = false
	local info = TweenInfo.new(2,Enum.EasingStyle.Bounce,Enum.EasingDirection.Out)
	local eggtw = tws:Create(eggModel,info,{ Position = eggModel.Position + Vector3.new(0, 2, 0) })
	local cameratw = tws:Create(camera,TweenInfo.new(0.75),{ CFrame = CFrame.new(workspace.Clays[name].PrimaryPart.Egg.WorldCFrame.Position,eggModel.Position) })
	camera.CameraType = Enum.CameraType.Scriptable
	camera.CFrame = workspace.Clays[name].Part.Camera.WorldCFrame
	module.tracks[name]:Play()
	module.tracks[name]:AdjustSpeed(0.25)	
	module.tracks[name].Ended:Once(function()
		eggModel.Parent = workspace.temp
		eggtw:Play()
		cameratw:Play()
		task.wait(3)
		camera.CameraType = Enum.CameraType.Custom
		scg.Enabled = true
		camera.Blur.Enabled = true
		player.Character.Parent = workspace
		cb()
		task.wait(1)
		eggModel:Destroy()
		eggtw:Destroy()
		cameratw:Destroy()
	end)

end







return module