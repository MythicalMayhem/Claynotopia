--!strict
local tws = game:GetService('TweenService')
local sacred = require(game.ReplicatedStorage.Modules.SACRED)
local types = require(game.ReplicatedStorage.Modules.typing)
local auraRemote = game.ReplicatedStorage.Remotes.aura
local player = game.Players.LocalPlayer
function SumXpOfPreviousLevels(currentLevel:number):number
	local sum = 0
	for i,v in pairs(sacred.levels) do
		if i and i > currentLevel then break end
		sum += v
	end
	return sum
end

function getNextMileStone(currlvl:number)	
	local last, nex
	for i,v in ipairs(sacred.milestones) do
		if sacred.milestones[i].onLevel > currlvl then nex = i break
		else last = i end
	end
	return sacred.milestones[last] or {onLevel = 0, rewards = {}},
		sacred.milestones[nex] or {onLevel = 0, rewards = {}}
end


local tweens:{[string]:Tween} = {}
local info = TweenInfo.new(0.2)
function setTween(instance:Instance,goal:{[string]:number|UDim2})
	if tweens[instance.Name] then tweens[instance.Name]:Cancel() tweens[instance.Name]:Destroy() end  
	tweens[instance.Name] = tws:Create(instance,info,goal)
	tweens[instance.Name]:Play()
end
function formatTick(t:number)
	local hours = t//3600
	local minutes = (t % 3600) // 60 
	local seconds = math.round(t%60)
	return tostring(hours)..':'..tostring(minutes)..':'..tostring(seconds)
end

local module = {}
local chestTimerThread:thread | nil = nil
local ances = player.PlayerGui:WaitForChild('ScreenGui')
local textInstances = ances.instances
function module:setData(data:types.client_player_data) 
	 
	local levelProgress = ances.Training.level.ImageLabel.levelprogress 
	local boost 	  = ances.Training.level.boost.TextLabel
	local clayno 	  = ances.Training.milestone.clay
	local milestone = ances.Training.milestone
	local staminaBarRadial = ances.Training.Progress
	local weights = ances.Training.weight
	local tamer = ances.tamer
	local last,nex = getNextMileStone(data.level) 
	milestone.rewards:ClearAllChildren()
	local cl0 = script.mile_stone_list:Clone()
	cl0.Parent = milestone.rewards
	for i,v in pairs(nex.rewards or {}) do
		local cl1 = script.milestone_text_template:Clone()
		cl1.Text = v
		cl1.Parent = milestone.rewards
	end
	milestone.nextMileStone.Text = 'lvl ' .. ( nex.onLevel or '...' )
	if nex.onLevel == 0 then milestone.nextMileStone.Text='...' end
	local milestoneProgress  = math.clamp(((data.level - last.onLevel)/(nex.onLevel-last.onLevel)),0,1)
	
	local progress = 0
	if data.levelProgress >= sacred.levels[#sacred.levels] then
		progress = (data.levelProgress%sacred.levels[#sacred.levels]) / sacred.levels[#sacred.levels]
	else
		local currentlevel = data.level
		local currentxp    = data.levelProgress
		local startxp      = (sacred.levels[currentlevel - 1] or 0) + SumXpOfPreviousLevels(currentlevel)
		local endxp	       = sacred.levels[currentlevel] + startxp
		progress = (currentxp - startxp) / (endxp - startxp)
	end
	for i,v in pairs(textInstances:GetChildren()) do 
		v.Value.value.Value = data[v.Name] + 1  
		v.Value.value.Value = data[v.Name]
	end
	boost.Text = 'x'..tostring(data.multiplier or 1)
	clayno.Image = sacred.assets.dinos[data.selected] or ''
	milestone.bar.level.Text = data.level
	setTween(staminaBarRadial.Percentage,{Value = 100*data.staminaHealth / data.stamina})
	setTween(levelProgress,{Size = UDim2.new(progress,0,1,0)})
	setTween(milestone.bar.milestoneprogress,{Size = UDim2.new(milestoneProgress,0,1,0)})
	if data.activity and data.activity.family=='gym' then
		local otherOrNot = data.activity.name=='stamina' and 'stamina' or 'other'
		for i,v:typeof(weights.fifth) in pairs(weights:GetChildren()) do
			 
			if data[data.activity.name] < sacred.gym.weights[otherOrNot][v.Name].min then
				v.ImageLabel.ImageTransparency = 0.5
				v.lock.Visible = true
			else v.ImageLabel.ImageTransparency = 0 v.lock.Visible = false end
			v.check.Visible = false
		end
		weights[data.activity.weight].check.Visible = true
	end
	for i,v in pairs(tamer.kids:GetChildren()) do
		if data.rank >= #sacred.ranks then break end 
		local max = sacred.tamer[sacred.ranks[data.rank + 1]][v.Name]
		local curr = data.tamer[v.Name]
		if curr >= max then
			v.progress.Visible = false
			v.progressTxt.Text = "Completed"
			v.progressTxt.TextColor = BrickColor.new("Gold")
		else
			v.progress.Visible = true
			v.progressTxt.TextColor = BrickColor.new("White")  
			v.progress.bar.Size = UDim2.new(curr/max,0,0.9,0)
			v.progressTxt.Text = tostring(math.round(curr*10)/10)..'/'..tostring(max)
		end
	end
	
	---- ---- chests
	if chestTimerThread then return end
	local chests = workspace.chests 
	local chestTrigger = workspace.uiParts:WaitForChild('chest')
	local dailyChest   = chests.daily
	local guitxt 	     = dailyChest.TimeUI.Time
	local lastOpened   = data.chests[dailyChest.Name]
	chestTimerThread = task.spawn(function()
		while task.wait(1) do		
			local timeSpent  = tick() - lastOpened
			if timeSpent < 60*60*24 then
				guitxt.Text = formatTick( 60*60*24 - timeSpent)
				chestTrigger[dailyChest.Name].ProximityPrompt.Enabled = false
			else
				guitxt.Text = 'Ready'
				chestTrigger[dailyChest.Name].ProximityPrompt.Enabled = true
				chestTimerThread = nil
				break
			end
		end
	end)
end

function module:setClayMaker(data)
	local images = ances.claymaker.ImageLabel.Frame:GetChildren() 	 
	for i,image:typeof(game.StarterGui.ScreenGui.claymaker.ImageLabel.one) in ipairs(images) do
		image.ImageLabel.Image = sacred.assets.dinos[data[i].name]
	end
end
function module:setAura(data,selected)
	local wrapper = ances.menus.aura.owned.Frame
	wrapper:ClearAllChildren()
	script.aura_grid:Clone().Parent = wrapper
	for i,v in pairs(data) do
		local t = script.aura_template:Clone() 
		t.Name = v
		t.Parent = wrapper
		--t.image
		t.MouseButton1Up:Connect(function()
			auraRemote:FireServer('attach',v) 
		end)
	end
	if game.Workspace:WaitForChild('Aura'):WaitForChild('PrimaryPart').Rig:FindFirstChild('dummy') then
		game.Workspace.Aura.PrimaryPart.Rig.dummy.HumanoidRootPart.RootAttachment:ClearAllChildren()
		game.ReplicatedStorage.assets.auras[selected].Attachment:Clone().Parent = game.Workspace.Aura.PrimaryPart.Rig.dummy.HumanoidRootPart.RootAttachment
	end
end

function module:setBackPack(data,selected)
	local default = 'rbxassetid://84087049486218'
	local bestSlots = ances.menus.backpack.slots.best
	for i,slot:typeof(bestSlots:FindFirstChild()) in ipairs(bestSlots:GetChildren()) do 
		if not  slot:IsA('ImageButton') then continue end
 
		slot.BackgroundTransparency = 0.3
		if i <= #data then
			if data[i]==selected then
				bestSlots.Parent.selected.Image = sacred.assets.dinos[data[i]]
			else
				slot:WaitForChild('occupied').Value = data[i] 
				slot.Image = sacred.assets.dinos[data[i]]

				slot.BackgroundTransparency = 0.555
			end
		else
			slot:WaitForChild('occupied').Value = 'backPackSlot'
--			slot.Image = 'rbxassetid://84087049486218'
			slot.Image = ''
		end
	end
	
	local others = bestSlots.Parent.rest:GetChildren()
	for i,slot:typeof(bestSlots:FindFirstChild()) in ipairs(others) do
		if not  slot:IsA('ImageButton') then continue end
		slot:WaitForChild('occupied').Value = 'backPackSlot'
		slot.Image = 'rbxassetid://84087049486218'		
		slot.BackgroundTransparency = 1
		pcall(function()
			slot.backpackslotstroke:Destroy()
			slot.backpackslotcorner:Destroy()
		end)
	end
	for i =  #bestSlots:GetChildren(), #data do
		local slot =		others[i - #bestSlots:GetChildren() + 1 ] 
		slot:WaitForChild('occupied').Value = data[i] 
		slot.Image = sacred.assets.dinos[data[i]]
		local cl0 = script.backpackslotstroke:Clone()
		local cl1 = script.backpackslotcorner:Clone()
		cl0.Parent = slot
		cl1.Parent = slot
		slot.BackgroundTransparency = 0.555
	end
end

function module:setBoss(data)
	local green = ances.bossFight.green
	local red 	= ances.bossFight.red
	local fullWidth  = red.Size.Width.Scale
	local fullHeight = red.Size.Height.Scale
	setTween(green,{Size = UDim2.new(fullWidth - fullWidth*data.health/100,0,fullHeight,0)})
end

return module
