--!strict
local miscUi = game.ReplicatedStorage.Remotes.miscUi
local dataRem = game.ReplicatedStorage.Remotes.requestData
local requestRem = game.ReplicatedStorage.Remotes.requestData
 
local connections  = require(script.Parent.petManager)
local playerData   = require(game.ServerScriptService.playerData) 
local sacred = require(game.ReplicatedStorage.Modules.SACRED)
local types = require(game.ReplicatedStorage.Modules.typing)
local activity = { }
activity.connections = { }

function computeReward(userid:number,BaseAmount:number) -- BaseAmount = How Much the activity gives
 
	local petWeight = 10
	if playerData.connections[userid].activity.name == 'stamina' then  
		petWeight = sacred.gym.weights.stamina[playerData.connections[userid].activity.weight].reward
	else  petWeight = sacred.gym.weights.other[playerData.connections[userid].activity.weight].reward end 

	local ClickMultiPlier = playerData.connections[userid].multiplier -- x1 to x2.2 
	return  (petWeight*0.1 ) * ClickMultiPlier * BaseAmount*(1 + (playerData.connections[userid].rank - 1)*0.2 )
end

function computeStaminaLoss(userid:number) 
	local petWeight  = sacred.gym.weights.other[playerData.connections[userid].activity.weight].cost
	return petWeight 
end

local jp = 0
function activity:attachPlayerToEquipment(player:Player,model:typeof(game.Workspace.gym.equipment.bag)) 
	playerData.connections[player.UserId].activity = { family = 'gym', name = model.Parent.Name, state='unset', weight="first"} 
	activity.connections[player.UserId] = { 
		prox = model.main.prox.ProximityPrompt,
		click = {
			lastClick = tick(),
			activity=model.Parent.Name,
			onclick = function()
				local p = playerData.connections[player.UserId] 
				if not p.activity then return end
				local staminaLoss = computeStaminaLoss(player.UserId) 
				if staminaLoss > p.staminaHealth then return end
				if tick() - p.clicks[#p.clicks] < 1  then return end 
				p.staminaHealth = math.clamp(p.staminaHealth - staminaLoss,0,p.stamina)
				playerData:updateCPS(player.UserId)
				playerData:advanceXp(player.UserId,sacred.gym.rewards[model.Parent.Name].xp)
 
				local stat = sacred.gym.rewards[model.Parent.Name]
				local _amt = 100*computeReward(player.UserId,stat.amount)

				
				playerData.connections[player.UserId][model.Parent.Name] += _amt
				playerData:updateTamer(player.UserId,_amt) 
				playerData:updateMuscle(player.UserId,model.Parent.Name,_amt)
				  
				miscUi:FireClient(player, {family = 'popup', child = model.Parent.Name, amount = _amt})
			end
		}
	}
 
	local characterPosition = model.main.player.WorldCFrame
	local pet:types.pet_model = connections[player.UserId]
	local character:types.player_character = player.Character
	local humanoid:Humanoid= character.Humanoid 
	
	local cf,size = character:GetBoundingBox()
	jp = humanoid.JumpPower
	humanoid.JumpPower = 0
	dataRem:FireClient(player,'playerData', playerData:GetData(player.UserId))
	character.PrimaryPart.Anchored = true 
	character.HumanoidRootPart.CFrame  = characterPosition 
end

function activity:changeWeight(uid:number,weight:string):nil
	local p = playerData.connections[uid]
	if not p.activity then return end
	if not table.find({'first', 'second', 'third', 'fourth', 'fifth', 'sixth'} ,weight) then error('weight idiot') end 
	if p.activity.name=='stamina' then
		if p.stamina >= sacred.gym.weights.stamina[weight].min then
			p.activity.weight = weight
			playerData:sendUpdate(uid)
		end
	else
		if p[p.activity.name] >= sacred.gym.weights.other[weight].min then
			p.activity.weight = weight
			playerData:sendUpdate(uid)
		end
	end
	return nil
end

function activity:detach(player:Player)
	local character:types.player_character = player.Character 
	character.PrimaryPart.Anchored = false
	local humanoid:Humanoid= character.Humanoid
	humanoid.JumpPower = jp
	playerData.connections[player.UserId].activity = nil
	activity.connections[player.UserId].prox.Enabled = true
	activity.connections[player.UserId] = nil
	dataRem:FireClient(player,'playerData', playerData:GetData(player.UserId))
end

function activity:click(player:Player)
	local clickInfos = activity.connections[player.UserId].click
	local t = tick()
	if t - clickInfos.lastClick > 0.2 then
		activity.connections[player.UserId].click.onclick() 
	end
end

return activity