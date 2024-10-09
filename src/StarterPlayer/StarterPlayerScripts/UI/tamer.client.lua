local windowTweens = require(game.ReplicatedStorage.Modules.ui.windowTweens)

local player = game.Players.LocalPlayer
local ances = player.PlayerGui:WaitForChild('ScreenGui')
local tamer = ances.tamer
windowTweens:addWindow('default',tamer)