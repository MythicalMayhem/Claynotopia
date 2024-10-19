local windowTweens = require(game.ReplicatedStorage.Modules.ui.windowTweens)

local requestRem = game.ReplicatedStorage.Remotes.requestData

local player = game.Players.LocalPlayer

local ances = player.PlayerGui:WaitForChild("ScreenGui")
local tamer = ances.menus.tamer
windowTweens:addWindow("default", tamer)

tamer.rankup.MouseButton1Up:Connect(function()
  requestRem:FireServer("rankup")
end)