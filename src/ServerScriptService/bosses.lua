--!strict
local tws = game:GetService('TweenService')
local players = game:GetService('Players')
local types = require(game.ReplicatedStorage.Modules.typing)
local playerModule 	= require(game.ServerScriptService.playerData)
local bossRemote 	= game.ReplicatedStorage.Remotes.boss

local bosses = {
	pink = {
		instance = workspace:WaitForChild('bosses'):WaitForChild('pink'),
		originalPos = workspace:WaitForChild('bosses'):WaitForChild('pink'):GetPivot(),
		rewardPool = {min=2000,max=10000}, minimumPower =  1000000,
		occupant = nil, health = 50, 	 thread = nil,	
		regen = 5, resistence = 0,  speed = 2.5,	 
	},
	guesty = {
		instance = workspace:WaitForChild('bosses'):WaitForChild('guesty'),
		originalPos = workspace:WaitForChild('bosses'):WaitForChild('guesty'):GetPivot(),
		rewardPool = {min=500, max=2000}, minimumPower =  100000,
		occupant = nil, health = 50, 	 thread = nil,	
		regen = 5, resistence = 0,  speed = 2.5,	 
	},
	bavely = {
		instance = workspace:WaitForChild('bosses'):WaitForChild('bavely'),
		originalPos = workspace:WaitForChild('bosses'):WaitForChild('bavely'):GetPivot(),
		rewardPool = {min=100, max=400}, minimumPower =  12000,
		occupant = nil, health = 50, 	 thread = nil,	
		regen = 5, resistence = 0,  speed = 2.5,	 
	},
	green = {
		instance = workspace:WaitForChild('bosses'):WaitForChild('green'),
		originalPos = workspace:WaitForChild('bosses'):WaitForChild('green'):GetPivot(),
		rewardPool = {min=10,max=40}, minimumPower =  400,
		occupant = nil, health = 50, 	 thread = nil,	
		regen = 5, resistence = 0,  speed = 2.5,	 
	},
	
}

function weldBossToHrp(hrp:types.player_character,boss:types.boss_model):WeldConstraint
 
	local twe = tws:Create(boss.PrimaryPart,TweenInfo.new(1),{CFrame = CFrame.new(hrp.Position + Vector3.new(0,2,0))})
	twe:Play()
	local twe0 = tws:Create(boss.PrimaryPart.motor,TweenInfo.new(0.5),{C0 = CFrame.new(-0.312,8.5,-0.167)*CFrame.Angles(0,0,math.rad(-120))})
	twe0:Play()
 

end

function bosses:init( playerid:number)
	local name = playerModule.connections[playerid].activity.name
	local currentBoss = bosses[name]
	currentBoss.health = 50
	currentBoss.occupant = playerid
	playerModule.connections[playerid].activity = { family = 'boss', name = name}
	local character repeat character = game.Players:GetPlayerByUserId(playerid).Character until character
	weldBossToHrp(character.PrimaryPart,currentBoss.instance)
	currentBoss.thread = task.spawn(function()
		while currentBoss.occupant   and task.wait(1/currentBoss.speed) do	
			if currentBoss.health < 1   then playerModule:BossWin(playerid,currentBoss.rewardPool)  break end
			if currentBoss.health > 99  then playerModule:BossLost(playerid)  break end
			currentBoss.health = math.clamp(currentBoss.health+ currentBoss.regen,0,100)
			bossRemote:FireClient(game.Players:GetPlayerByUserId(playerid),'bossData',currentBoss)
			tws:Create(currentBoss.instance.PrimaryPart.motor,TweenInfo.new(1/currentBoss.speed ),
				{C0 = CFrame.new(-0.312,8.5 - currentBoss.health/65,-0.167)*CFrame.Angles(0,0,math.rad(-110))}):Play()
		end 
		currentBoss.occupant = nil currentBoss.thread = nil currentBoss.health   = 50
		currentBoss.instance.PrimaryPart.motor.C0 = CFrame.new(-0.312,14.1,-0.167) 
		currentBoss.instance.PrimaryPart.Anchored =  true
		playerModule.connections[playerid].activity = nil 
		task.wait(0.2)
		currentBoss.instance:PivotTo(currentBoss.originalPos)
	end)
end

function bosses:click( playerid:number)	
	local bossName = playerModule.connections[playerid].activity.name 
	local boss 	 = bosses[bossName]
	if boss.thread then
		if boss.occupant ~= playerid then return end
		-- bosses[bossName].health -= math.clamp(playerModule:computePower(playerid)/100 - boss.resistence, 0, boss.health)
		bosses[bossName].health -= math.clamp(2 - boss.resistence, 0, boss.health)
		bossRemote:FireClient(game.Players:GetPlayerByUserId(playerid),'bossData',boss)
	else
		bossRemote:FireClient(game.Players:GetPlayerByUserId(playerid),'init' )
		bosses:init (playerid)
		bosses:click(playerid)
	end
end

return bosses
