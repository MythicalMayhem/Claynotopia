--!strict

local sacred = require(game.ReplicatedStorage.Modules.SACRED)
local types = require(game.ReplicatedStorage.Modules.typing)
local bossModule = require(game.ServerScriptService.bosses)
local playerModule = require(game.ServerScriptService.playerData)

local bossRemote = game.ReplicatedStorage.Remotes.boss

for i, box: types.ui_trigger_boss in ipairs(workspace.uiParts:WaitForChild("bosses"):GetChildren()) do
	local prox: types.ui_trigger_boss & { Parent: Attachment } = box.Attachment.ProximityPrompt
	prox.Triggered:Connect(function(player)
		if bossModule[box.Name].occupant then
			return
		end
		-- if bossModule[box.Name].minimumPower > playerModule:computePower(player.UserId) then print('minimum power') return end
		bossModule[box.Name].occupant = player.UserId
		local character: types.player_character = player.Character
		character.PrimaryPart.Anchored = true
		task.wait(0.1)
		local size = character:GetExtentsSize()
		playerModule.connections[player.UserId].activity = { family = "boss", name = box.Name }
		character:PivotTo(prox.Parent.WorldCFrame * CFrame.new(0, size.Y / 2, 0))
		bossRemote:FireClient(player, "init")
	end)
end

bossRemote.OnServerEvent:Connect(function(player, datatype)
	if not playerModule.connections[player.UserId].activity then
		player.Character.PrimaryPart.Anchored = false
		return
	end
	if bossModule[playerModule.connections[player.UserId].activity.name].occupant ~= player.UserId then
		return
	end
	if datatype == "click" then
		bossModule:click(player.UserId)
	end
	if datatype == "init" then
		bossModule:init(player.UserId)
	end
end)

for i, name in workspace.bosses:GetChildren() do
	if true then break end

	local humanoid = Instance.new("Humanoid")
	local animator: Animator = humanoid.Animator

	local animInstance = Instance.new("Animation")
	animInstance.AnimationId = "rbxassetid://" .. tostring(sacred.animations.bossfights[name])
	animInstance.Parent = animator
	bossModule.pink.track = animator:LoadAnimation(animInstance)
	bossModule.pink.track.Priority = Enum.AnimationPriority.Action4
end
