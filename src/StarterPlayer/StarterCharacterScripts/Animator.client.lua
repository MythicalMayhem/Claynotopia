--!strict

local run = game:GetService('RunService')

local localplrModule = require(game.ReplicatedStorage.Modules.LocalPlayer)
local sacred = require(game.ReplicatedStorage.Modules.SACRED)
local types = require(game.ReplicatedStorage.Modules.typing)

local animEv = game.ReplicatedStorage.Bindables.animate

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local camera = workspace.CurrentCamera
camera.CameraType = Enum.CameraType.Custom

local char:types.player_character repeat char = player.Character until char and task.wait()
local humanoid:Humanoid = char:WaitForChild('Humanoid')
local animator:typeof(game.StarterPlayer.StarterCharacter.Humanoid.Animator) = humanoid:WaitForChild('Animator')


function loadTracks(animationid:number, name)
	local animInstance = Instance.new('Animation')
	animInstance.AnimationId = "rbxassetid://"..tostring(animationid)
	animInstance.Name = name
	animInstance.Parent = animator
	local t  = animator:LoadAnimation(animInstance) 
	t.Priority = Enum.AnimationPriority.Action4		
	return t
end
local gymtracks:{[string]:AnimationTrack} = {}
for name,animationId in pairs(sacred.animations.gym) do 
	gymtracks[name] = loadTracks(animationId,name) 
	
end

local cps = 1
local debounce = tick()
local currentlyPlaying:AnimationTrack | nil = nil
local persistence = 0.01
gymtracks['back']:GetMarkerReachedSignal('start'):Connect(function()
	if cps > 2 then
		if currentlyPlaying then	 currentlyPlaying:AdjustSpeed(2) end
		game.ReplicatedStorage.Remotes.animatePet:FireServer('play','back') 
	end
end)
run.Stepped:Connect(function()	
	if not localplrModule.info.activity then  for name,track in pairs(gymtracks) do track:Stop() end return end
	if localplrModule.info.activity.family == 'gym' then
		if ( localplrModule.info.activity.name == 'stamina' and (gymtracks['stamina'].IsPlaying == false) 
			and (gymtracks['staminaWithoutPet'].IsPlaying == false) ) or (localplrModule.info.activity.name~='stamina' 
			and gymtracks[localplrModule.info.activity.name].IsPlaying == false)then
			for name,track in pairs(gymtracks) do track:Stop(0.5) end 
			if localplrModule.info.activity.name == 'stamina' and localplrModule.info.selected == '' then
				gymtracks['staminaWithoutPet']:Play(0.5)
				gymtracks['staminaWithoutPet'].Looped = true 
				currentlyPlaying = gymtracks['staminaWithoutPet']
			else
				gymtracks[localplrModule.info.activity.name]:Play(0.5)
				gymtracks[localplrModule.info.activity.name].Looped = true
				currentlyPlaying = gymtracks[localplrModule.info.activity.name]
			end
		end
	else
		for name,track in pairs(gymtracks) do track:Stop() end
		currentlyPlaying = nil
	end  
	if currentlyPlaying then
		currentlyPlaying:AdjustSpeed(math.clamp(currentlyPlaying.Speed - persistence,0.3,10)  )
		currentlyPlaying.Looped = true
	end

end)

mouse.Button1Down:Connect(function() 
	cps = 1/(tick()-debounce) 
	if currentlyPlaying then
		currentlyPlaying:AdjustSpeed(1 + cps/10)
	end
	debounce = tick() 
end)

local bosstracks:{[string]:AnimationTrack} = {}
for name,animationId in pairs(sacred.animations.boss) do bosstracks[name] = loadTracks(animationId,name) end
bosstracks['init'].Looped = false
bosstracks['init']:AdjustSpeed(0.001)
animEv.Event:Connect(function(data)
	if data.family == 'boss' then 
		for name,track in pairs(bosstracks) do track:Stop(0.5) end
		bosstracks[data.child]:Play(0.25)
		bosstracks['init']:AdjustSpeed(0.001)
		if data.child=='win' then game.ReplicatedStorage.Bindables._tutBossWon:Fire() end
	end
end)