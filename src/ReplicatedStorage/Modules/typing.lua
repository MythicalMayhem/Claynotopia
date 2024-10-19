--!strict
local module = {}
export type pet_model = typeof(script._template)

export type player_character = typeof(game.StarterPlayer.StarterCharacter)
export type boss_model = typeof(game.Workspace.bosses.pink)
export type ui_trigger_boss = typeof(game.Workspace.uiParts.bosses.pinkguy)
export type ui_trigger_normal = typeof(game.Workspace.uiParts.gymShop)
export type gym_equipment_model = typeof(game.Workspace.gym.equipment.bag.four)
export type client_player_data = {	 
	activity : {family:string,child:string?,name:string?,amount:string?,weight:string?}?,
	food : {string},
	chest 		: number,
	stamina		: number,
	legs		: number,
	arms 	: number, 
	back 	: number, 
	cash  : number, 
	level : number,
	levelProgress : number,
	chests : {vip:number, daily:number, group:number },
	multiplier : number,
	clicks : {number},
	selected : string,
	backpack : {string},
	muscles : {
		abs   : {mass : number}, 
		back  : {mass : number}, 
		torso : {mass : number}, 
		chest : {mass : number},
		lefthamstring : {mass : number}, 
		leftshoulder  : {mass : number}, 
		leftforearm : {mass : number}, 
		lefttricep  : {mass : number}, 
		leftchest  : {mass : number}, 
		leftbicep  : {mass : number}, 
		leftcalve  : {mass : number},
		leftneck   : {mass : number}, 
		leftquad   : {mass : number}, 
		rightquad  : {mass : number},  
		rightneck  : {mass : number}, 
		rightchest : {mass : number}, 
		rightcalve : {mass : number},
		rightbicep : {mass : number}, 
		righttricep : {mass : number}, 
		rightforearm : {mass : number}, 
		rightshoulder : {mass : number}, 
		righthamstring : {mass : number}, 
	},
	auras : {string},
	equipped : string,
	rank :number,
	tamer : {
		legs		:   number, 
		chest		:   number,
		arms		:   number, 
		stamina		:   number,
		back	:   number,
	},
	staminaHealth : number,
	staminaHealthDebounce : number,
	communicationDebounce:number,
	threads : {	RBXScriptConnection}

}
return module
