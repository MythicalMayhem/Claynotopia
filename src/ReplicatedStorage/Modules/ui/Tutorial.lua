--!strict
local module = {}
local run = game:GetService('RunService')

local player = game.Players.LocalPlayer
local character repeat task.wait() character = player.Character until character
local Controls = require(player.PlayerScripts.PlayerModule):GetControls()
local mouse = player:GetMouse()

module.beam = {}
module.beam.from = script.beam.from:Clone()
module.beam.to = script.beam.to:Clone()
module.beam.from.Beam.Attachment0 = module.beam.from
module.beam.from.Beam.Attachment1 = module.beam.to
module.beam.from.Parent = character.PrimaryPart
function module:beamTo(parent:any) module.beam.to.Parent = parent end


module.textThread = nil
module.stages = {
	welcome = {
		'Hello There !',
		'Welcome to CLAYNOTOPIA !!',
		'First let\'s head to the gym' 
	},
	gotoboss = {
		'Wow you became quite strong',
		'Time to put ur efforts into something',
		'Go test your skills at the local boss',
		'Good luck !!!'
	},
	bosswon= {
		"THAT WAS INSANE !!!!!",
		'Must be cool owning cash',
		'Go spend it !'
	},
	clayopened = {
		'Cool friend you got there',
		'Take care of eachother',
		'Have fun !',
		'Oh and grab your new gym buddy to the gym next time ;)',
		'Cya ! have fun <3'
	}
}

local skipConn = nil
function generateThread(txt:string,textLabel:TextLabel,cb)
	textLabel.Text = ''
	local k = 1 
	local deb = tick() 
	return run.Stepped:Connect(function() 
		if k>string.len(txt) then
			if module.textThread then module.textThread:Disconnect() end 		
			if skipConn then skipConn:Disconnect() end
			mouse.Button1Down:Once(cb)
			return
		end
		if tick() - deb >0.1 then
			textLabel.Text = string.sub(txt,1,k)
			deb = tick()
			k = k + 1		
		end		
	end)	


end

local current = 1
function nextPage(stage,gui:typeof(game.StarterGui.Tutorial),cb:() -> nil)
	current = current + 1 
	if current > #module.stages[stage] then
		gui.Enabled = false
		Controls:Enable() 
		cb()
		return
	end

	module.textThread = generateThread(module.stages[stage][current],
		gui.Frame.TextLabel,function() nextPage(stage,gui,cb) end)
	
	task.wait(0.5)
	skipConn = mouse.Button1Down:Once(function()
		local k = current
		if skipConn then skipConn:Disconnect() end
		if module.textThread then module.textThread:Disconnect() end
		gui.Frame.TextLabel.Text = module.stages[stage][k]	
		mouse.Button1Down:Once(function() nextPage(stage,gui,cb) end)
	end)

end


function module:init(gui:ScreenGui,stage:string,cb)
	current = 0
	Controls:Disable() 
	gui.Enabled = true
	nextPage(stage,gui,cb)
end


return module
