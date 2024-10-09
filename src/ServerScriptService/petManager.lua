--!strict
local players  = game:GetService('Players')

local animateRemote = game.ReplicatedStorage.Remotes.animatePet
local attachPet2plr = game.ReplicatedStorage.Remotes.attachPet
local playerDataManager = require(game.ServerScriptService.playerData)
local petConfig = require(game.ReplicatedStorage.Modules.pets.PetAnimator)
local petm = {}

function createModel(name:string)
	local temppl8 = game.ServerStorage.dinos._template:Clone()
	local pet:Model = game.ServerStorage.dinos[name]:Clone()
	temppl8.Name = name
	local cf = temppl8.PrimaryPart.petweld.WorldCFrame
	pet:PivotTo(cf)
	temppl8.HumanoidRootPart.WeldConstraint.Part0 = temppl8.PrimaryPart
	temppl8.HumanoidRootPart.WeldConstraint.Part1 = pet.PrimaryPart
	pet.Parent = temppl8
	temppl8:SetAttribute('type',pet:GetAttribute('type'))
	pet.PrimaryPart.Anchored = true
	return temppl8
end
function petm:AttachPetToPlayer(whichPet:string,uid:number)
	local backpack = playerDataManager.connections[uid].backpack
	if not table.find(backpack,whichPet) then return end -- so important sanity check
	playerDataManager.connections[uid].selected = whichPet
	local pet:Model = createModel(whichPet)
	if petm[uid] then pcall(function() petm[uid].instance:Destroy()end) end
	pet.Parent = workspace.pets
	petm[uid] = {instance = pet, animations = {
									tracks = petConfig:LoadAnimation(pet:FindFirstChildOfClass('Model'),uid),
									playing = nil,
									waitUntil = false,
									lastState = 'idle',
									debounce = tick()
								}}
	pet:PivotTo(players:GetPlayerByUserId(uid).Character:GetPivot()*CFrame.new(2,1,2)) 
	animateRemote:FireClient(players:GetPlayerByUserId(uid),pet.Name,petm[uid].animations )
	attachPet2plr:FireClient(players:GetPlayerByUserId(uid),pet,'self')
	return pet
end

function petm:DetachPet(uid)
	if petm[uid] then petm[uid].instance:Destroy()end
	if players:GetPlayerByUserId(uid) then
		attachPet2plr:FireClient(players:GetPlayerByUserId(uid),nil,'detach')
	end
end

function petm:PlayerToPet(player)
	repeat task.wait() until player.Character
	local char = player.Character
	local name =petm[player.UserId].instance.Name
	local newModel = createModel(name)
	player.Character = newModel
	newModel:PivotTo(char:GetPivot()) 
	char:Destroy()
	pcall(function() petm[player.UserId].instance:Destroy() end)
	petm[player.UserId] = nil 
	newModel.Parent = workspace
	attachPet2plr:FireClient(player,newModel.Name,'pet')
	animateRemote:FireClient(player,name,
		{
			tracks = petConfig:LoadAnimation(newModel:FindFirstChildOfClass('Model'),player.UserId),
			playing = nil,
			waitUntil = false,
			lastState = 'idle',		
			debounce = tick()
		})
end



return petm