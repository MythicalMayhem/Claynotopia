--!strict
local tweens = {}

local tws = game:GetService('TweenService')

local camera = workspace.CurrentCamera
local Controls = require(game.Players.LocalPlayer.PlayerScripts:WaitForChild("PlayerModule")):GetControls() 

function tweens:ToggleAllProximityPrompts(state)
	for i,v in pairs(workspace:GetDescendants()) do
		if v:IsA('ProximityPrompt') then
			v.Enabled = state
		end
	end
end
tweens.HiddenOffset = 1000
tweens.windows = { }	--:{[string]:{[string]:{show:Tween,hide:Tween}}}
tweens.windowsCloseButton = nil or Instance.new('ImageButton')
function closeButton(state:boolean) 
	tweens.windowsCloseButton.Visible = state return state 
end
function tweens:assignWindowsCloseButton(instance:ImageButton)
	tweens.windowsCloseButton = instance
	instance.MouseButton1Up:Connect(function() 
		for groupName,members in pairs(tweens.windows) do
			if groupName =='core' then continue end
			tweens:hideAllWindows(groupName)
		end
	end)
end

function tweens:addWindow(group,instance:Frame,off:(()->nil)?,on:(()->nil)?,blurBackground:boolean?)
	if not tweens.windows[group] then tweens.windows[group]= {} end
	local originalPosition  = Instance.new('Vector3Value')
	originalPosition.Value	= Vector3.new(instance.Position.X.Scale,instance.Position.Y.Scale,0)
	originalPosition.Name 	= 'initialPosition'
	originalPosition.Parent	= instance

	local isVisible  = Instance.new('BoolValue')
	isVisible.Value  = false	
	isVisible.Parent = instance
	isVisible.Name 	 = 'isVisible'

	instance.Position = UDim2.new(originalPosition.Value.X,0,originalPosition.Value.Y  ,tweens.HiddenOffset)
	instance.Visible  = true
	local tweeninfo   = TweenInfo.new(0.3)
	local showGoal    = { Position = UDim2.new(originalPosition.Value.X, 0, originalPosition.Value.Y ,0) } 
	local hideGoal 	  = { Position = UDim2.new(originalPosition.Value.X, 0, originalPosition.Value.Y  ,1000) }
	local showTween   = tws:Create(instance, tweeninfo, showGoal)
	local hideTween   = tws:Create(instance, tweeninfo, hideGoal)

	showTween.Completed:Connect(function() tweens.windows[group][instance.Name].onOpen() isVisible.Value = closeButton(true) end)
	hideTween.Completed:Connect(function() isVisible.Value = false tweens.windows[group][instance.Name].onClose() end)
	tweens.windows[group][instance.Name] = {
		instance = instance,
		show = showTween,
		hide = hideTween,
		visible = isVisible,
		blurBackground =(function() if blurBackground==false then return false else return true end end)(),
		onOpen  =  on  or function() end,
		onClose =  off or function() end,
	}
end



function tweens:toggle(group:string,name:string,dontHideOtherWindows:boolean?)
	local window = tweens.windows[group][name]
	if (window.show.PlaybackState == Enum.PlaybackState.Playing) 
		or (window.hide.PlaybackState == Enum.PlaybackState.Playing) then
		return
	end
	if window.visible.Value then
		window.hide:Play()
		tweens:ToggleAllProximityPrompts(true)
		closeButton(false)
		changeBlur(false)
	else
		window.show:Play()
		tweens:ToggleAllProximityPrompts(false)
		if dontHideOtherWindows==true then
			return end
		for i,v in pairs(tweens.windows[group]) do if i==name then continue end tweens.windows[group][i].hide:Play() end
		changeBlur(window.blurBackground)
		closeButton(true)
	end
end


function tweens:hideAllWindows(group) 
	tweens.windowsOnCloseOnce = function()end
	for i,v in pairs(tweens.windows[group]) do
		task.spawn(function() tweens:hideWindow(group,i,true) end) 	
	end  
end

function tweens:hideWindow(group,name,dontHideOtherWindows)
	local window = tweens.windows[group][name]
	if window.visible.Value  then tweens:toggle(group,name,dontHideOtherWindows)  end 
	return window.instance
end

function tweens:showWindow(group,name,dontHideOtherWindows:boolean?)
	local window = tweens.windows[group][name]
	if not window.visible.Value then tweens:toggle(group,name,dontHideOtherWindows)  end
	return window.instance
end

local blurinstance = Instance.new('BlurEffect') 
blurinstance.Size = 0
blurinstance.Parent = camera
local blur = tws:Create(blurinstance,TweenInfo.new(0.2),{Size = 30})
local unblur = tws:Create(blurinstance,TweenInfo.new(0.2),{Size = 0})

function changeBlur(state)
	if state  then
		unblur:Cancel()
		blur:Play()
		return
	end
	blur:Cancel()
	unblur:Play()	
end
function tweens:blur(state) changeBlur(state) end
function tweens:freezePlayer(state)
	--	if state  then return Controls:Disable() end
	--	Controls:Enable()
end

return tweens
