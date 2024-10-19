--!strict

-- MissingPartType: "Trans", "Color", "TransAndColor".
-- Direction: "Left", "Middle", Right".
-- StarterPoint: "Up", "Down", "Left", "Right"

local player = game.Players.LocalPlayer
local ances = player.PlayerGui:WaitForChild('ScreenGui') 
local progress = ances.staminaBar
local percentage = progress.Percentage
local F1 = progress.Frame1
local F2 = progress.Frame2




function FramePosChanger(Direction,StarterPoint)
	if Direction == "Vertical" then
		F1.Position = StarterPoint == "Up" and UDim2.fromScale(0,0) or UDim2.fromScale(1,0)
		F2.Position = StarterPoint == "Up" and UDim2.fromScale(1,0) or UDim2.fromScale(0,0)
		F1.AnchorPoint = StarterPoint == "Up" and Vector2.new(0,0) or Vector2.new(1,0)
		F2.AnchorPoint = StarterPoint == "Up" and Vector2.new(1,0) or Vector2.new(0,0)
		F1.Size = UDim2.fromScale(0.5,1)
		F2.Size = UDim2.fromScale(0.5,1)
		F1.ImageLabel.Position = StarterPoint == "Up" and UDim2.fromScale(0,0) or UDim2.fromScale(1,0)
		F2.ImageLabel.Position = StarterPoint == "Up" and UDim2.fromScale(1,0) or UDim2.fromScale(0,0)
		F1.ImageLabel.AnchorPoint = StarterPoint == "Up" and Vector2.new(0,0) or Vector2.new(1,0)
		F2.ImageLabel.AnchorPoint = StarterPoint == "Up" and Vector2.new(1,0) or Vector2.new(0,0)
		F1.ImageLabel.Size = UDim2.fromScale(2,1)
		F2.ImageLabel.Size = UDim2.fromScale(2,1)
	elseif Direction == "Horizontal" then
		F1.Position = StarterPoint == "Right" and UDim2.fromScale(0,0) or UDim2.fromScale(0,1)
		F2.Position = StarterPoint == "Right" and UDim2.fromScale(0,1) or UDim2.fromScale(0,0)
		F1.AnchorPoint = StarterPoint == "Right" and Vector2.new(0,0) or Vector2.new(0,1)
		F2.AnchorPoint = StarterPoint == "Right" and Vector2.new(0,1) or Vector2.new(0,0)
		F1.Size = UDim2.fromScale(1,0.5)
		F2.Size = UDim2.fromScale(1,0.5)
		F1.ImageLabel.Position = StarterPoint == "Right" and UDim2.fromScale(0,0) or UDim2.fromScale(0,1)
		F2.ImageLabel.Position = StarterPoint == "Right" and UDim2.fromScale(0,1) or UDim2.fromScale(0,0)
		F1.ImageLabel.AnchorPoint = StarterPoint == "Right" and Vector2.new(0,0) or Vector2.new(0,1)
		F2.ImageLabel.AnchorPoint = StarterPoint == "Right" and Vector2.new(0,1) or Vector2.new(0,0)
		F1.ImageLabel.Size = UDim2.fromScale(1,2)
		F2.ImageLabel.Size = UDim2.fromScale(1,2)
	end
end

local ImageTrans = 0
local ColorOfMissingPart = Color3.new(0,0,0)
local ColorOfPercentPart = Color3.new(1,1,1)
local ImageColor = Color3.new(1,1,1)
local FlipProgress = false
local ImageId = "129940409951049"
local MissingPartType = "TransAndColor"
local TransOfMissingPart = 0.25
local TransOfPercentPart = 0
local Direction = "Right"
local StarterPoint = "Up"

function Progress(Value:number)
	local EvenX = math.floor(progress.AbsoluteSize.X + 0.5)%2
	local EvenY = math.floor(progress.AbsoluteSize.Y + 0.5)%2
	local PercentNumber = math.clamp(Value * 3.6,0,360)
	local I1 = F1.ImageLabel
	local I2 = F2.ImageLabel
	local G1 = I1.UIGradient
	local G2 = I2.UIGradient
	I1.ImageColor3 = ImageColor
	I2.ImageColor3 = ImageColor
	I1.ImageTransparency = ImageTrans
	I2.ImageTransparency = ImageTrans
	I1.Image = "rbxassetid://" .. ImageId
	I2.Image = "rbxassetid://" .. ImageId
	if StarterPoint == "Up" or StarterPoint == "Down"  then
		FramePosChanger("Vertical",StarterPoint)
		if StarterPoint == "Up" then
			if Direction == "Left" then
				G1.Rotation = math.clamp(PercentNumber,180,360)
				G2.Rotation = math.clamp(PercentNumber,0,180)
			elseif Direction == "Right" then
				G1.Rotation = 180 - math.clamp(PercentNumber,0,180)
				G2.Rotation = - math.clamp(PercentNumber,180,360) + 180
			elseif Direction == "Middle" then
				G1.Rotation = 180 - math.clamp(PercentNumber,0,360)/2
				G2.Rotation = math.clamp(PercentNumber,0,360)/2
			end
		elseif StarterPoint == "Down" then
			if Direction == "Left" then
				G1.Rotation = math.clamp(PercentNumber,180,360) + 180
				G2.Rotation = math.clamp(PercentNumber,0,180) + 180
			elseif Direction == "Right" then
				G1.Rotation = - math.clamp(PercentNumber,0,180)
				G2.Rotation = - math.clamp(PercentNumber,180,360)
			elseif Direction == "Middle" then
				G1.Rotation = - math.clamp(PercentNumber,0,360)/2
				G2.Rotation = math.clamp(PercentNumber,0,360)/2 + 180
			end
		end
	elseif StarterPoint == "Left" or StarterPoint == "Right"  then
		FramePosChanger("Horizontal",StarterPoint)
		if StarterPoint == "Left" then
			if Direction == "Left" then
				G1.Rotation = math.clamp(PercentNumber,180,360) - 90
				G2.Rotation = math.clamp(PercentNumber,0,180) - 90
			elseif Direction == "Right" then
				G1.Rotation = 90 - math.clamp(PercentNumber,0,180)
				G2.Rotation = - math.clamp(PercentNumber,180,360) + 90
			elseif Direction == "Middle" then
				G1.Rotation = 90 - math.clamp(PercentNumber,0,360)/2
				G2.Rotation = math.clamp(PercentNumber,0,360)/2  - 90
			end
		elseif StarterPoint == "Right" then
			if Direction == "Left" then
				G1.Rotation = math.clamp(PercentNumber,180,360) + 90
				G2.Rotation = math.clamp(PercentNumber,0,180) + 90
			elseif Direction == "Right" then
				G1.Rotation = 270 - math.clamp(PercentNumber,0,180)
				G2.Rotation = - math.clamp(PercentNumber,180,360) + 270
			elseif Direction == "Middle" then
				G1.Rotation = 270 - math.clamp(PercentNumber,0,360)/2
				G2.Rotation = math.clamp(PercentNumber,0,360)/2  + 90
			end
		end
	else
		StarterPoint = "Up"
		warn("Unknown Type. Only 4 available: “Up”, “Down”, “Left” and “Right”, changing to “Up”.")
	end
	if MissingPartType == "Color" then
		I1.UIGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,ColorOfPercentPart),ColorSequenceKeypoint.new(0.5,ColorOfPercentPart),ColorSequenceKeypoint.new(0.502,ColorOfMissingPart),ColorSequenceKeypoint.new(1,ColorOfMissingPart)})
		I2.UIGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,ColorOfPercentPart),ColorSequenceKeypoint.new(0.5,ColorOfPercentPart),ColorSequenceKeypoint.new(0.502,ColorOfMissingPart),ColorSequenceKeypoint.new(1,ColorOfMissingPart)})
		I1.UIGradient.Transparency = NumberSequence.new(0)
		I2.UIGradient.Transparency = NumberSequence.new(0)
	elseif MissingPartType == "Trans" then
		I1.UIGradient.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,TransOfPercentPart),NumberSequenceKeypoint.new(0.5,TransOfPercentPart),NumberSequenceKeypoint.new(0.502,TransOfMissingPart),NumberSequenceKeypoint.new(1,TransOfMissingPart)})
		I2.UIGradient.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,TransOfPercentPart),NumberSequenceKeypoint.new(0.5,TransOfPercentPart),NumberSequenceKeypoint.new(0.502,TransOfMissingPart),NumberSequenceKeypoint.new(1,TransOfMissingPart)})
		I1.UIGradient.Color = ColorSequence.new(Color3.new(1,1,1))
		I2.UIGradient.Color = ColorSequence.new(Color3.new(1,1,1))
	elseif MissingPartType == "TransAndColor" then
		I1.UIGradient.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,TransOfPercentPart),NumberSequenceKeypoint.new(0.5,TransOfPercentPart),NumberSequenceKeypoint.new(0.502,TransOfMissingPart),NumberSequenceKeypoint.new(1,TransOfMissingPart)})
		I2.UIGradient.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,TransOfPercentPart),NumberSequenceKeypoint.new(0.5,TransOfPercentPart),NumberSequenceKeypoint.new(0.502,TransOfMissingPart),NumberSequenceKeypoint.new(1,TransOfMissingPart)})
		I1.UIGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,ColorOfPercentPart),ColorSequenceKeypoint.new(0.5,ColorOfPercentPart),ColorSequenceKeypoint.new(0.502,ColorOfMissingPart),ColorSequenceKeypoint.new(1,ColorOfMissingPart)})
		I2.UIGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,ColorOfPercentPart),ColorSequenceKeypoint.new(0.5,ColorOfPercentPart),ColorSequenceKeypoint.new(0.502,ColorOfMissingPart),ColorSequenceKeypoint.new(1,ColorOfMissingPart)})
	else
		MissingPartType = "Trans"
		warn("Unknown Type. Only 3 available: “Trans”, “Color” and “TransAndColor”, changing to “Trans”.")
	end
end

percentage:GetPropertyChangedSignal("Value"):Connect(function()
	Progress(percentage.Value)
	progress.TextLabel.Text = tostring(math.round(percentage.Value*10)/10)..'%'
end)

for Numebr , Property in pairs(script:GetChildren()) do
	Property:GetPropertyChangedSignal("Value"):Connect(function()
		percentage.Value %=100 
		Progress(percentage.Value)
	end)
end

 