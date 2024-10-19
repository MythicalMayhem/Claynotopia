--!strict
local tws = game:GetService('TweenService')
local sacred = require(game.ReplicatedStorage.Modules.SACRED)
local module = { }
local connections: {[number]:{
	instance:typeof (game.ServerStorage.dinos.tyson) ,
	tracks:{[string]:{track:AnimationTrack,	waitUntil:boolean, name:string} },
	waitUntil:boolean,
	state:string
}} = {}

local stateRegister:{[number]:{registredTick:number,registredState:string,level:number}} = {}

local allEmotions = sacred.assets.emotions
local emotionMap :{[string]:{string}} = {
	idle = { allEmotions.yawning,allEmotions.yawning,allEmotions.nerd },
	run  = {allEmotions.hot,allEmotions.astonished,allEmotions.weary},
	walk = {allEmotions.anxious,allEmotions.mewing},
	jump = {allEmotions.angry},
	
	back = {allEmotions.angry},
	stamina = {allEmotions.angry},
	chest = {allEmotions.angry},
	arms = {allEmotions.angry},
	legs = {allEmotions.angry},

}


module.connections = connections
module.stateRegister = stateRegister
module.anims =  sacred.PetAnimations
function module:LoadAnimation (pet:typeof (game.ServerStorage.dinos.tyson),userid:number) 
	local animator:Animator = pet.Humanoid.Animator
	local tracks = {} 
	for i,v in (module.anims[pet.Name] or {idle = 0, run = 0, walk = 0, jump = 0}) do
		local anim = Instance.new('Animation')
		anim.AnimationId = 'rbxassetid://'..tostring(v)
		anim.Parent = animator
		anim.Name = i
		tracks[i] = {track = animator:LoadAnimation(anim),waitUntil = false,name = i}
		if i =='jump' or i=='back' then tracks[i].waitUntil = true 		tracks[i].track.Looped = false tracks[i].track.Priority = Enum.AnimationPriority.Action4 
		else  tracks[i].track.Looped = true   end
		tracks[i].track.Priority = Enum.AnimationPriority.Action 
	end	 
 
	module.connections[userid] = {
		state = 'idle',
		tracks=tracks,
		waitUntil = false,
		instance = pet,
	}
	module.stateRegister[userid] = {
		state = 'idle',
		registredTick  = 0,
		registredState = "idle",
		level = 0
	}
	module:Play(userid,"idle")
	return tracks

end

function module:Play(userid:number,name:string)  
	local p = module.connections[userid]
	local t = p.tracks[name]
	p.state = name
	t.track:Play( )
	if p.waitUntil then return end 
	if t.waitUntil then 
		t.track.Looped = false
		p.waitUntil = true
		task.wait(p.tracks[name].track.Length)
		p.waitUntil = false
		module:Play(userid,'idle')
	end
end

function module:Place(userid:number,cframe:CFrame)
	module.connections[userid].instance.Parent.PrimaryPart.CFrame = cframe 
 
end

function module:Stop(userid:number,name:string)
	for i,v in pairs(module.connections[userid].tracks) do v.track:Stop(0) end
	module:Play(userid,'idle')
end

function module:TriggetEmotion(userid:number)
	local emotion  = module.stateRegister[userid].registredState
	local level    = module.stateRegister[userid].level
	local instance = module.connections[userid].instance
	instance.PrimaryPart.emotion.BillboardGui.ImageLabel.Image = emotionMap[emotion][(level % #(emotionMap[emotion] or emotionMap.idle)) + 1] 
	task.wait(3)
	if instance then instance.PrimaryPart.emotion.BillboardGui.ImageLabel.Image = "" end
end

function module:CleanUp(userid:number)
	pcall(function()module.connections[userid].instance:Destroy()end)
	module.connections[userid] = nil
	module.stateRegister[userid] = nil
end

return module