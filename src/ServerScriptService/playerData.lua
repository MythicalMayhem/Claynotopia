--!strict

local tws = game:GetService("TweenService")
local run = game:GetService("RunService")
local players = game:GetService("Players")
local bossRemote = game.ReplicatedStorage.Remotes.boss
local requestRem = game.ReplicatedStorage.Remotes.requestData
local sacred = require(game.ReplicatedStorage.Modules.SACRED)
local types = require(game.ReplicatedStorage.Modules.typing)
local connections: { [number]: types.client_player_data } = {}

local player = {
	connections = connections,
}

function player:GetData(userid)
	if not player.connections[userid] then
		player.connections[userid] = {
			activity = nil,
			stamina = 100,
			legs = 0,
			arms = 0,
			back = 0,
			cash = 0,
			chest = 0,
			rank = 1,
			level = 0,
			levelProgress = 0,
			chests = { vip = tick() - 60 * 60 * 24 + 50, daily = tick() - 60 * 60 * 24 + 15, group = tick() },
			multiplier = 1,
			clicks = { tick(), tick(), tick(), tick(), tick(), tick(), tick(), tick(), tick(), tick() },
			selected = "",
			backpack = {
				"greenraptor",
				"lightblue",
				"yellow",
				"dactyl",
				"dactly",
				"yasmin",
				"buzz",
				"orange",
				"gray",
				"lean",
				"green",
				"tyson",
				"tom",
				"brown",
				"otheryasmin",
				"flea",
				"frog",
				"rot",
			},
			muscles = {
				lefthamstring = { mass = 0 },
				leftshoulder = { mass = 0 },
				leftforearm = { mass = 0 },
				lefttricep = { mass = 0 },
				leftchest = { mass = 0 },
				leftbicep = { mass = 0 },
				leftcalve = { mass = 0 },
				leftneck = { mass = 0 },
				leftquad = { mass = 0 },
				torso = { mass = 0 },
				abs = { mass = 0 },
				back = { mass = 0 },
				chest = { mass = 0 },
				rightquad = { mass = 0 },
				rightneck = { mass = 0 },
				rightchest = { mass = 0 },
				rightcalve = { mass = 0 },
				rightbicep = { mass = 0 },
				righttricep = { mass = 0 },
				rightforearm = { mass = 0 },
				rightshoulder = { mass = 0 },
				righthamstring = { mass = 0 },
			},
			auras = { "dbzorange", "dbzpurple", "dbzred", "dbzlightgreen", "dbzlightblue", "dbzyellow" },

			equipped = "",
			tamer = { legs = 0, chest = 0, arms = 0, stamina = 0, back = 0 },
			staminaHealth = 100,
			staminaHealthDebounce = tick(),
			staminaRegenDebounce = tick(),
			threads = {
				cpschecker = task.spawn(function()
					task.wait(0.555)
					while task.wait(0.2) do
						player.connections[userid].multiplier =
							math.clamp(player.connections[userid].multiplier - 0.1, 1, 2)
					end
				end),
				staminaHealther = run.Stepped:Connect(function()
					local t = tick()
					if t - player.connections[userid].staminaHealthDebounce < 3 then
						return
					end
					if t - player.connections[userid].staminaRegenDebounce > 1 then
						player.connections[userid].staminaHealth = math.min(
							player.connections[userid].stamina,
							player.connections[userid].staminaHealth + (player.connections[userid].stamina * 0.05 + 15)
							--		*task.wait()
						)
						player.connections[userid].staminaRegenDebounce = t
						if player.connections[userid].activity then
							player:sendUpdate(userid)
						end
					end
				end),
			},
		}
	end
	--any ::::::::::: !!!!!!!!!!!!!!!!!!!!
	local clo: any = table.clone(player.connections[userid])
	clo.threads = nil
	return clo
end

function player:ClearAllMuscles(uid: number)
	for i, v in pairs(player.connections[uid].muscles) do
		pcall(function()
			v.instance:Destroy()
		end)
	end
	player.connections[uid].muscles = {
		lefthamstring = { mass = 0 },
		leftshoulder = { mass = 0 },
		leftforearm = { mass = 0 },
		lefttricep = { mass = 0 },
		leftchest = { mass = 0 },
		leftbicep = { mass = 0 },
		leftcalve = { mass = 0 },
		leftneck = { mass = 0 },
		leftquad = { mass = 0 },
		torso = { mass = 0 },
		abs = { mass = 0 },
		back = { mass = 0 },
		chest = { mass = 0 },
		rightquad = { mass = 0 },
		rightneck = { mass = 0 },
		rightchest = { mass = 0 },
		rightcalve = { mass = 0 },
		rightbicep = { mass = 0 },
		righttricep = { mass = 0 },
		rightforearm = { mass = 0 },
		rightshoulder = { mass = 0 },
		righthamstring = { mass = 0 },
	}
end
function player:updateMuscle(uid: number, what: string, amount: number)
	local p = player.connections[uid]
	local info = TweenInfo.new(0.5)
	local newVal = 0
	for i, v in pairs(sacred.gym.rewards[what].muscles) do
		newVal = p.muscles[v].mass + amount
		p.muscles[v].mass = newVal

		local ins = p.muscles[v].instance
		local maxSize = ins.maxSize.Value
		local currentSize = ins.Size
		if maxSize.Magnitude < currentSize.Magnitude then
			continue
		end
		local sizeGoal =
			{ Size = maxSize * (p.tamer[p.activity.name] / sacred.tamer[sacred.ranks[p.rank + 1]][p.activity.name]) }
		local goal0 = { Size = sizeGoal.Size + Vector3.new(0.1, 0.1, 0.1) }
		local tw = tws:Create(ins, info, sizeGoal):Play()
		local tw0 = tws:Create(p.muscles[v].glow.instance, info, goal0):Play()
		local glowing = tws:Create(p.muscles[v].glow.glowAmount, TweenInfo.new(0.25), { Value = 0 })
		glowing:Play()
		glowing.Completed:Once(function()
			local unglowing = tws:Create(p.muscles[v].glow.glowAmount, TweenInfo.new(0.25), { Value = 1 })
			unglowing:Play()
		end)
	end
end

function player:AttachMuscle(uid: number, att: Attachment & { Parent: Part & { Parent: Part } })
	local p = player.connections[uid]

	local weldcs = Instance.new("WeldConstraint")
	local part = game.ServerStorage.muscles[sacred.ranks[math.min(p.rank, #sacred.ranks)]][att.Name]
	part.CanQuery = false
	part.CanTouch = false
	part.CanCollide = false
	part.Massless = true
	part.CFrame = att.WorldCFrame
	weldcs.Part0 = att.Parent
	weldcs.Part1 = part
	att.Parent.Color = part.Color
	att.Parent.BrickColor = part.BrickColor
	att.Parent.Material = part.Material
	att.Parent.MaterialVariant = part.MaterialVariant
	part.Size = Vector3.zero
	weldcs.Parent = att
	part.Parent = att

	local weldcs0 = Instance.new("WeldConstraint")
	local glowPart: MeshPart = part:Clone()
	glowPart.CFrame = att.WorldCFrame
	weldcs0.Part0 = att.Parent
	weldcs0.Part1 = glowPart
	weldcs0.Parent = weldcs
	glowPart.Parent = att
	glowPart.Size = part.Size * 1.1
	glowPart.Transparency = 1
	glowPart.Material = Enum.Material.Neon
	glowPart.Color = Color3.new(1, 1, 1)
	glowPart.MaterialVariant = ""
	local transparencyValue = Instance.new("NumberValue")
	transparencyValue:GetPropertyChangedSignal("Value"):Connect(function()
		glowPart.Transparency = transparencyValue.Value
	end)

	if not p.muscles[att.Name].glow then
		p.muscles[att.Name].glow = {}
	end
	p.muscles[att.Name].glow.glowAmount = transparencyValue
	p.muscles[att.Name].glow.instance = glowPart
	p.muscles[att.Name].instance = part

	local character = players:GetPlayerByUserId(uid).Character
	character.Head.Color = part.Color
	character.Head.BrickColor = part.BrickColor
	character.Head.Material = part.Material
	character.Head.MaterialVariant = part.MaterialVariant
end

function player:setUpMuscles(uid: number)
	local plr = players:GetPlayerByUserId(uid)
	local character = plr.Character
	for i, att: Attachment & { Parent: Part } in pairs(character:GetDescendants()) do
		if att:IsA("Attachment") and table.find(sacred.musclesNames, att.Name) then
			player:AttachMuscle(uid, att)
		end
	end

	character:WaitForChild("Right Leg").BrickColor = BrickColor.new("Black")
	character:WaitForChild("Right Leg").Material = Enum.Material.Metal
	character:WaitForChild("Left Leg").BrickColor = BrickColor.new("Black")
	character:WaitForChild("Left Leg").Material = Enum.Material.Metal
end

function player:RankUp(uid: number)
	local p = player.connections[uid]
	for i, v in pairs(p.tamer) do
		if v < sacred.tamer[sacred.ranks[p.rank + 1]][i] then
			return
		end
	end
	local o = p.rank
	p.rank = math.min(p.rank + 1, #sacred.ranks)
	if o == p.rank then
		return
	end
	player:ClearAllMuscles(uid)
	p.tamer = { back = 0, chest = 0, arms = 0, legs = 0, stamina = 0 }
	player:setUpMuscles(uid)
	player:sendUpdate(uid)
	local prtclz = game.ReplicatedStorage.assets.particles.rank_up_particles:Clone()
	prtclz.Parent = players:GetPlayerByUserId(uid).Character.PrimaryPart
	task.wait(2)
	prtclz:Destroy()
end

function player:updateTamer(uid: number, amount: number)
	local p = player.connections[uid]
	local activity = p.activity.name
	if p.rank >= #sacred.ranks then
		return
	end
	local maxAmt = sacred.tamer[sacred.ranks[p.rank + 1]][activity]
	p.tamer[activity] = math.clamp(p.tamer[activity] + amount, 0, maxAmt)
end

function player:click(uid)
	local p = player.connections[uid]
	local clicks = p.clicks
	local t = tick()
	table.remove(clicks, 1)
	table.insert(clicks, t)
	if p.activity and p.activity.family == "gym" then
		p.staminaHealthDebounce = t
	end
end
function player:sendUpdate(uid: number)
	requestRem:FireClient(players:GetPlayerByUserId(uid), "playerData", player:GetData(uid))
end

function player:updateCPS(uid)
	player:click(uid)
	local clicks = player.connections[uid].clicks
	local sum = 0
	for i = 1, 9 do
		sum += clicks[i + 1] - clicks[i]
	end
	player.connections[uid].multiplier = math.clamp(math.round(90 / sum) / 10, 1, 2.2)
end

function SumXpOfPreviousLevels(currentLevel: number): number
	local sum = 0
	for i, v in pairs(sacred.levels) do
		if i and i > currentLevel then
			break
		end
		sum += v
	end
	return sum
end
function player:advanceXp(userid, amt)
	local p = player.connections[userid]
	p.levelProgress += amt
	local s = SumXpOfPreviousLevels(p.level)
	if p.levelProgress > (sacred.levels[#sacred.levels] + s) then
		p.level = p.levelProgress // (sacred.levels[#sacred.levels] + s) + #sacred.levels
	elseif p.levelProgress >= (sacred.levels[p.level] + s) then
		p.level = p.level + 1
	end
end

function player:computePower(userid)
	local p = player.connections[userid]
	return p.arms + p.back + p.chest + p.legs
end
function player:AddPetToBackPack(userid, petname)
	table.insert(player.connections[userid].backpack, petname)
end
function player:BossWin(playerid, rewardPool: { min: number, max: number })
	bossRemote:FireClient(players:GetPlayerByUserId(playerid), "win")
	local character = players:GetPlayerByUserId(playerid).Character
	local tw =
		tws:Create(character.PrimaryPart, TweenInfo.new(0.2), { CFrame = CFrame.new(character:GetPivot().Position) })
	tw:Play()
	task.wait(1.2)
	character.PrimaryPart.Anchored = false
	player.connections[playerid].cash += math.random(rewardPool.min, rewardPool.max)
	player:sendUpdate(playerid)
end

function player:BossLost(playerid)
	local character = players:GetPlayerByUserId(playerid).Character
	bossRemote:FireClient(game.Players:GetPlayerByUserId(playerid), "lost")
	task.wait(0.2)
	character.PrimaryPart.Anchored = false
	task.wait(0.2)
	character.PrimaryPart:ApplyImpulse(Vector3.new(-1 * 100, 0, -1 * 100))
end

return player
