--!strict
local tws = game:GetService('TweenService')
local players = game:GetService('Players')
local types = require(game.ReplicatedStorage.Modules.typing)
local playerModule 	= require(game.ServerScriptService.playerData)
local bossRemote 	= game.ReplicatedStorage.Remotes.boss

local bosses = {
	pinkguy = {
		instance = workspace:WaitForChild('bosses'):WaitForChild('pink'),
		originalPos = workspace:WaitForChild('bosses'):WaitForChild('pink'):GetPivot(),
		minimumPower = 1000,
		occupant = nil,
		health = 50, 	-- if this reaches 100 the player loses
		regen = 5,	-- amount to add every update 
		resistence = 0, -- amount to ignore from player's strength
		speed = 2.5,	-- how many updates per second
		thread = nil,	-- updating function
		
	}
}

function weldBossToHrp(hrp:types.player_character,boss:types.boss_model)
	local weldcs = Instance.new('WeldConstraint')
	weldcs.Parent = hrp.Parent.Torso
	weldcs.Part0 = hrp .Parent.Torso
	local twe = tws:Create(boss.PrimaryPart,TweenInfo.new(1),{CFrame = CFrame.new(hrp.Position + Vector3.new(0,2,0))})
	twe:Play()
	local twe0 = tws:Create(boss.PrimaryPart.motor,TweenInfo.new(0.5),{C0 = CFrame.new(-0.312,8.5,-0.167)*CFrame.Angles(0,0,math.rad(-120))})
	twe0:Play()
	twe.Completed:Once(function()
		weldcs.Part1 = boss.PrimaryPart
		boss.PrimaryPart.Anchored = false 
	end)

	return weldcs
end

function bosses:init( playerid:number)
	local name = playerModule.connections[playerid].activity.name
	bosses[name].health = 50
	bosses[name].occupant = playerid
	playerModule.connections[playerid].activity = { family = 'boss', name = name} 
	local character repeat character = game.Players:GetPlayerByUserId(playerid).Character until character
	local weldc = weldBossToHrp(character.PrimaryPart,bosses[name].instance)
	bosses[name].thread = task.spawn(function()
		while bosses[name].occupant   and task.wait(1/bosses[name].speed) do	
			if bosses[name].health < 1   then playerModule:BossWin(playerid)  break end
			if bosses[name].health > 99  then playerModule:BossLost(playerid) break end
			bosses[name].health = math.clamp(bosses[name].health+ bosses[name].regen,0,100)
			bossRemote:FireClient(game.Players:GetPlayerByUserId(playerid),'bossData',bosses[name])
			local twe0 = tws:Create(bosses[name].instance.PrimaryPart.motor,TweenInfo.new(1/bosses[name].speed ),{C0 = CFrame.new(-0.312,8.5 - bosses[name].health/65,-0.167)*CFrame.Angles(0,0,math.rad(-110))})
			twe0:Play()
		end 
		bosses[name].occupant = nil		
		bosses[name].thread   = nil
		bosses[name].health   = 50
		bosses[name].instance.PrimaryPart.motor.C0 = CFrame.new(-0.312,14.1,-0.167) 
		bosses[name].instance.PrimaryPart.Anchored =  true
		playerModule.connections[playerid].activity = nil
		task.wait(2)
		if weldc then weldc:Destroy() end
		bosses[name].instance:PivotTo(bosses[name].originalPos)
	end)
end

function bosses:click( playerid:number)
	
	local bossName = playerModule.connections[playerid].activity.name
	local playerData:types.client_player_data = playerModule:GetData(playerid)
	local boss 	 = bosses[bossName]
	if boss.thread then
		if boss.occupant ~= playerid then return end
		bosses[bossName].health -= math.clamp(playerData.power/100 - boss.resistence, 0, boss.health)
		bossRemote:FireClient(game.Players:GetPlayerByUserId(playerid),'bossData',boss)
	else
		bossRemote:FireClient(game.Players:GetPlayerByUserId(playerid),'init' )
		bosses:init (playerid)
		bosses:click(playerid)
	end
end

return bosses
