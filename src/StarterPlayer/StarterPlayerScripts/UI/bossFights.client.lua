--!strict

local setter = require(script.Parent.setData)
local windowTweens = require(game.ReplicatedStorage.Modules.ui.windowTweens)
local bossRemote = game.ReplicatedStorage.Remotes.boss

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
 
local ances = player.PlayerGui:WaitForChild('ScreenGui')
local bossfightUi = ances.bossFight

windowTweens:addWindow('boss',bossfightUi,nil,nil,false)


 

local mouseConn:RBXScriptConnection = nil
bossRemote.OnClientEvent:Connect(function(datatype:string,data:{})
	if datatype=='init' then
		game.ReplicatedStorage.Bindables.animate:Fire({family="boss",child=datatype})

		windowTweens:freezePlayer(true) 
		windowTweens:showWindow('boss',bossfightUi.Name) 
		mouseConn = mouse.Button1Down:Connect(function() bossRemote:FireServer('click') end)
		return
	end
	if datatype=='bossData' then
		windowTweens:freezePlayer(false) 
		setter:setBoss(data) 
		return
	end	
	if datatype=='win' or datatype=='lost' then
		if mouseConn then mouseConn:Disconnect() end
		windowTweens:hideAllWindows('boss') 
		task.wait(0.175)
		setter:setBoss({health = 50})
		game.ReplicatedStorage.Bindables.animate:Fire({family="boss",child=datatype})
	end
end)