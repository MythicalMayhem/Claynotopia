--!strict
local types = require(game.ReplicatedStorage.Modules.typing)

local info:types.client_player_data  = {
	activity = nil,
	rank=1,
	chest = 0 ,
	stamina = 0 ,
	legs = 0 ,
	arms = 0 ,
	back = 0 ,
	cash = 0 ,
	level = 0,
	levelProgress = 0,

	chests = {vip=tick() , daily=tick() , group=tick() },
	multiplier = 1,
	clicks = {},

	selected = '',
	backpack = { },

	muscles = {
		abs   = {mass = 0}, 
		back  = {mass = 0}, 
		torso = {mass = 0}, 
		chest = {mass = 0},
		lefthamstring = {mass = 0}, 
		leftshoulder  = {mass = 0}, 
		leftforearm = {mass = 0}, 
		lefttricep  = {mass = 0}, 
		leftchest  = {mass = 0}, 
		leftbicep  = {mass = 0}, 
		leftcalve  = {mass = 0},
		leftneck   = {mass = 0}, 
		leftquad   = {mass = 0}, 
		rightquad  = {mass = 0},  
		rightneck  = {mass = 0}, 
		rightchest = {mass = 0}, 
		rightcalve = {mass = 0},
		rightbicep = {mass = 0}, 
		righttricep = {mass = 0}, 
		rightforearm = {mass = 0}, 
		rightshoulder = {mass = 0}, 
		righthamstring = {mass = 0}, 
	},
	tamer = {
		chest = 0, 
		stamina = 0,
		legs = 0, 
		arms = 0,
		back = 0,
	},
	staminaHealth = 100,
	staminaHealthDebounce = tick(),
	communicationDebounce = tick(),
	auras = {},
	equipped = '',

	threads = { }
}

 

return {
	info = info 
}
