--!strict
local camera = workspace.CurrentCamera
local tws = game:GetService('TweenService')
local sacred = require(game.ReplicatedStorage.Modules.SACRED)

local pop = {
	assets = sacred.assets.icons
}

 
local current:Frame | nil = nil
local currentAmount = 0
local originalPos = UDim.new()
local t = tick()
function pop:create(what:string,howMuch:number)
	currentAmount = currentAmount + howMuch 
	currentAmount = math.ceil(currentAmount*100)/100
	if current then
		current.TextLabel.Text = '+'..tostring(currentAmount)
		current:TweenPosition(originalPos + UDim2.new(math.random(-10,10)/500,0,math.random(-10,10)/500,0),Enum.EasingDirection.Out,Enum.EasingStyle.Sine,0.2)
	else		
		local assetid = pop.assets[what]
		if not assetid then return end
	
		local template = script.template:Clone()
		local player = game.Players.LocalPlayer
		local popupFrame = player.PlayerGui.ScreenGui.popUps 
		originalPos = template.Position
		template.ImageLabel.Image = assetid
		template.Parent = popupFrame
		template.Size = UDim2.new(0,0,0,0)
		template.AnchorPoint = Vector2.new(0.5,0.5)
		template.TextLabel.Text = '+'..tostring(currentAmount)
		template:TweenSize(UDim2.new(0.1,0,0.1,0),Enum.EasingDirection.Out,Enum.EasingStyle.Linear,0.1,nil,function()
			while tick() - t < 0.9 do task.wait() end
			current=nil currentAmount=0
			template:TweenPosition(UDim2.new(0,0,-1.5,0),Enum.EasingDirection.Out,Enum.EasingStyle.Sine,1 ,nil,function()  template:Destroy()  end)end) 
		current = template
	end
	t = tick() 
end

function pop:under(label:TextLabel,amount:number)
	local show = tws:Create(label,TweenInfo.new(1),{Position = UDim2.new(0,0,-1,0)})
	show:Play()
	show.Completed:Once(function()
		local hide = tws:Create(label,TweenInfo.new(1),{Position = UDim2.new(0,0,3,0)})
		hide:Play()
	end)
end

return pop