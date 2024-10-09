--!strict

local prxservice = game:GetService('ProximityPromptService')
local run = game:GetService('RunService')


local windowTweens = require(game.ReplicatedStorage.Modules.ui.windowTweens)
local tutorialGen = require(game.ReplicatedStorage.Modules.ui.Tutorial)
local localCopy = require(game.ReplicatedStorage.Modules.LocalPlayer)

 
local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local mouse = player:GetMouse()

local character repeat character = player.Character task.wait() until character
local blur = camera:WaitForChild('Blur') blur.Enabled = false
local mainGui = script.Parent.Parent.ScreenGui
mainGui.main.Visible = false
mainGui.currencies.cash.Visible = false
mainGui.currencies.power.Visible = false

local punchingBag = workspace.gym.equipment.bag:WaitForChild("one") 
local leglift     = workspace.gym.equipment.leglift:WaitForChild("one") 
local treadmill	  = workspace.gym.equipment.treadmill:WaitForChild("one") 
 

function EnableProximities(name)
	local gymProxes = game.Workspace.gym.equipment:GetDescendants()
	for i,v in pairs(gymProxes) do
		if v:IsA('ProximityPrompt') then
			if name then
				if v:FindFirstAncestor(name) then v.Enabled = true  
				else v.Enabled = false end 
			else
				v.Enabled = true 
			end
		end
	end
end

EnableProximities('_none')
-- WATCH OUT FOR NAMES RECHECK HEIARCHY
task.wait(1.75)
prxservice.PromptTriggered:Connect(function() tutorialGen:beamTo(nil)  mainGui.currencies.power.Visible = true end)
tutorialGen:init(script.Parent,'welcome',function() tutorialGen:beamTo(punchingBag.main) EnableProximities('bag') end)
repeat task.wait(0.1) until localCopy.info.power >= 250
windowTweens:hideWindow('training','Training')
tutorialGen:beamTo(leglift.main.beam)
EnableProximities('leglift')
repeat task.wait(0.1) until localCopy.info.power >= 500
windowTweens:hideWindow('training','Training')
tutorialGen:beamTo(treadmill.main.beam)
EnableProximities('treadmill')
repeat task.wait(0.1) until localCopy.info.power >= 1000
windowTweens:hideWindow('training','Training')
tutorialGen:init(script.Parent,'gotoboss',function() tutorialGen:beamTo(workspace.Dinos.pink.PrimaryPart)end)
EnableProximities(nil)
game.ReplicatedStorage.Bindables._tutBossWon.Event:Connect(function()
	mainGui.currencies.cash.Visible = true
	task.wait(1.5)
	tutorialGen:init(script.Parent,'bosswon',function() 
		tutorialGen:beamTo(workspace.Clays.pink.PrimaryPart)
	end)
end)
 