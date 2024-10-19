--!strict

local data = game.ReplicatedStorage.Remotes.requestData
local setter = require(script.Parent.setData)
local localplrModule = require(game.ReplicatedStorage.Modules.LocalPlayer)

data:FireServer('claymaker')
data.OnClientEvent:Connect(function(datatype,data)
	if datatype=='playerData' then  localplrModule.info = data setter:setData(data) setter:setAura(data.auras,data.equipped) setter:setBackPack(data.backpack,data.selected) return end 
	if datatype=='claymaker'  then  setter:setClayMaker(data) return end 
end)