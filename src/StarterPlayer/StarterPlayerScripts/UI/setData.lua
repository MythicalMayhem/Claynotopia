--!strict
local tws = game:GetService("TweenService")
local sacred = require(game.ReplicatedStorage.Modules.SACRED)
local types = require(game.ReplicatedStorage.Modules.typing)
local auraRemote = game.ReplicatedStorage.Remotes.aura
local player = game.Players.LocalPlayer

local clones = game.ReplicatedStorage:WaitForChild("assets"):WaitForChild("ui")

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

function getNextMileStone(currlvl: number)
	local last, nex
	for i, v in ipairs(sacred.milestones) do
		if sacred.milestones[i].onLevel > currlvl then
			nex = i
			break
		else
			last = i
		end
	end
	return sacred.milestones[last] or { onLevel = 0, rewards = {} },
		sacred.milestones[nex] or { onLevel = 0, rewards = {} }
end

local tweens: { [string]: Tween } = {}
local info = TweenInfo.new(0.2)
function setTween(instance: Instance, goal: { [string]: number | UDim2 })
	if tweens[instance.Name] then
		tweens[instance.Name]:Cancel()
		tweens[instance.Name]:Destroy()
	end
	tweens[instance.Name] = tws:Create(instance, info, goal)
	tweens[instance.Name]:Play()
end
function formatTick(t: number)
	local hours = t // 3600
	local minutes = (t % 3600) // 60
	local seconds = math.round(t % 60)
	return tostring(hours) .. ":" .. tostring(minutes) .. ":" .. tostring(seconds)
end

local module = {}
local chestTimerThread: thread | nil = nil
local ances = player.PlayerGui:WaitForChild("ScreenGui")

function module:setData(data: types.client_player_data)
	local staminaBarRadial = ances.staminaBar
	local weights = ances.Training.weight
	local tamer = ances.menus.tamer

	for i, img in pairs(ances.currencies:GetChildren()) do
		img.TextLabel.value.Value = data[img.Name] + 1
		img.TextLabel.value.Value = data[img.Name]
	end

	setTween(staminaBarRadial.Percentage, { Value = 100 * data.staminaHealth / data.stamina })
	if data.activity and data.activity.family == "gym" then
		local otherOrNot = data.activity.name == "stamina" and "stamina" or "other"
		for i, v: typeof(weights.fifth) in pairs(weights:GetChildren()) do
			v.min.Text = tostring(sacred.gym.weights[otherOrNot][v.Name].min)
			v.icon.Image = sacred.assets.icons[data.activity.name]
			if data[data.activity.name] < sacred.gym.weights[otherOrNot][v.Name].min then
				v.min.TextColor = BrickColor.new("Really red")
				v.ImageLabel.ImageTransparency = 0.5
				v.lock.Visible = true
			else
				v.min.TextColor = BrickColor.new("Lime green")
				v.ImageLabel.ImageTransparency = 0
				v.lock.Visible = false
			end
			v.check.Visible = false
		end
		weights[data.activity.weight].check.Visible = true
	end

	for i, v in pairs(tamer.kids:GetChildren()) do
		if data.rank >= #sacred.ranks then
			break
		end
		local max = sacred.tamer[sacred.ranks[data.rank + 1]][v.Name]
		local curr = data.tamer[v.Name]
		tamer.rank.Text = sacred.ranks[data.rank]:gsub("^%l", string.upper)
		tamer.from.Text = "x" .. tostring((data.rank - 1) * 20) .. "%"
		tamer.to.Text = "x" .. tostring(data.rank * 20) .. "%"

		if curr >= max then
			v.progress.Visible = false
			v.progressTxt.Text = "Completed"
			v.progressTxt.TextColor = BrickColor.new("Gold")
		else
			v.progress.Visible = true
			v.progressTxt.TextColor = BrickColor.new("White")
			v.progress.bar.Size = UDim2.new(curr / max, 0, 0.9, 0)
			v.progressTxt.Text = tostring(math.round(curr * 10) / 10) .. "/" .. tostring(max)
		end
	end
	player.Backpack:ClearAllChildren()
	for _, name in pairs(data.food) do
		local part   = game.ReplicatedStorage.assets.food[name]:Clone()
		part.Parent = 		player.Backpack 
	end
	---- ---- chests
	if chestTimerThread then
		return
	end
	local chests = workspace.chests
	local chestTrigger = workspace.uiParts:WaitForChild("chest")
	local dailyChest = chests.daily
	local guitxt = dailyChest.TimeUI.Time
	local lastOpened = data.chests[dailyChest.Name]
	chestTimerThread = task.spawn(function()
		while task.wait(1) do
			local timeSpent = tick() - lastOpened
			if timeSpent < 60 * 60 * 24 then
				guitxt.Text = formatTick(60 * 60 * 24 - timeSpent)
				chestTrigger[dailyChest.Name].ProximityPrompt.Enabled = false
			else
				guitxt.Text = "Ready"
				chestTrigger[dailyChest.Name].ProximityPrompt.Enabled = true
				chestTimerThread = nil
				break
			end
		end
	end)
end

function module:setClayMaker(data)
	local green = ances.claymaker.green.ImageLabel.Frame
	local pink = ances.claymaker.pink.ImageLabel.Frame
	local blue = ances.claymaker.blue.ImageLabel.Frame
	for i, image in ipairs(green:GetChildren()) do
		image.ImageLabel.Image = sacred.assets.dinos[data.green[i]] or ""
	end
	for i, image in ipairs(blue:GetChildren()) do
		image.ImageLabel.Image = sacred.assets.dinos[data.blue[i]] or ""
	end
	for i, image in ipairs(pink:GetChildren()) do
		image.ImageLabel.Image = sacred.assets.dinos[data.pink[i]] or ""
	end
end
function module:setAura(data, selected)
	local wrapper = ances.menus.aura.owned.Frame
	wrapper:ClearAllChildren()
	clones.aura_grid:Clone().Parent = wrapper
	for i, v in pairs(data) do
		local t = clones.aura_template:Clone()
		t.Name = v
		t.Parent = wrapper
		t.ImageLabel.Image = sacred.assets.auras[v]
		t.MouseButton1Up:Connect(function() auraRemote:FireServer("attach", v) end)
	end
	if game.Workspace:WaitForChild("Aura"):WaitForChild("PrimaryPart").Rig:FindFirstChild("dummy") then
		game.Workspace.Aura.PrimaryPart.Rig.dummy.HumanoidRootPart.RootAttachment:ClearAllChildren()
		print(selected)
		game.ReplicatedStorage.assets.auras[selected].Attachment:Clone().Parent =
			game.Workspace.Aura.PrimaryPart.Rig.dummy.HumanoidRootPart.RootAttachment
	end
end

function module:setBackPack(data, selected)
	local default = "rbxassetid://84087049486218"
	local bestSlots = ances.menus.backpack.slots.best

	for i, slot: typeof(bestSlots:FindFirstChild()) in ipairs(bestSlots:GetChildren()) do
		if not slot:IsA("ImageButton") then
			continue
		end
		slot.BackgroundTransparency = 0.3
		if i <= #data then
			if data[i] == selected then
				bestSlots.Parent.selected.Image = sacred.assets.dinos[data[i]]
			else
				slot:WaitForChild("occupied").Value = data[i]
				slot.Image = sacred.assets.dinos[data[i]]
				slot.BackgroundTransparency = 0.555
			end
		else
			slot:WaitForChild("occupied").Value = "backPackSlot"
			--			slot.Image = 'rbxassetid://84087049486218'
			slot.Image = ""
		end
	end

	local others = bestSlots.Parent.rest:GetChildren()
	for i, slot: typeof(bestSlots:FindFirstChild()) in ipairs(others) do
		if not slot:IsA("ImageButton") then
			continue
		end
		slot:WaitForChild("occupied").Value = "backPackSlot"
		slot.Image = "rbxassetid://84087049486218"
		slot.BackgroundTransparency = 1
		pcall(function()
			slot.backpackslotstroke:Destroy()
			slot.backpackslotcorner:Destroy()
		end)
	end
	for i = #bestSlots:GetChildren(), #data do
		local slot = others[i - #bestSlots:GetChildren() + 1]
		slot:WaitForChild("occupied").Value = data[i]
		slot.Image = sacred.assets.dinos[data[i]]
		clones.backpackslotstroke:Clone().Parent = slot
		clones.backpackslotcorner:Clone().Parent = slot
		slot.BackgroundTransparency = 0.555
	end
end

function module:setBoss(data)
	local green = ances.bossFight.green
	local red = ances.bossFight.red
	local fullWidth = red.Size.Width.Scale
	local fullHeight = red.Size.Height.Scale
	setTween(green, { Size = UDim2.new(fullWidth - fullWidth * data.health / 100, 0, fullHeight, 0) })
end

return module
