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

 

function tweens:addWindow(group:string?,instance:Frame,off:(()->nil)?,on:(()->nil)?,blurBackground:boolean?)
	if not self.windows[group] then self.windows[group]= {} end
	local originalPosition  = Instance.new('Vector3Value')
	originalPosition.Value	= Vector3.new(instance.Position.X.Scale,instance.Position.Y.Scale,0)
	originalPosition.Name 	= 'initialPosition'
	originalPosition.Parent	= instance

	local isVisible  = Instance.new('BoolValue')
	isVisible.Value  = false	
	isVisible.Parent = instance
	isVisible.Name 	 = 'isVisible'

	instance.Position = UDim2.new(originalPosition.Value.X,0,originalPosition.Value.Y  ,self.HiddenOffset)
	instance.Visible  = true
	local tweeninfo   = TweenInfo.new(0.3)
	local showGoal    = { Position = UDim2.new(originalPosition.Value.X, 0, originalPosition.Value.Y ,0) } 
	local hideGoal 	  = { Position = UDim2.new(originalPosition.Value.X, 0, originalPosition.Value.Y  ,1000) }
	local showTween   = tws:Create(instance, tweeninfo, showGoal)
	local hideTween   = tws:Create(instance, tweeninfo, hideGoal)
	local closeBtn = instance:FindFirstChild('_hide')
	if closeBtn then closeBtn.MouseButton1Click:Connect(function()  self:hideWindow(group,instance.Name) end) end
	showTween.Completed:Connect(function() isVisible.Value = true self.windows[group][instance.Name].onOpen() end)
	hideTween.Completed:Connect(function() isVisible.Value = false self.windows[group][instance.Name].onClose() end)
	self.windows[group][instance.Name] = {
		instance = instance,
		show = showTween,
		hide = hideTween,
		visible = isVisible,
		blurBackground = (function() if blurBackground==false then return false else return true end end)(),
		onOpen  =  on  or function() end,
		onClose =  off or function() end,
	}
end



function tweens:toggle(group:string,name:string,dontHideOtherWindows:boolean?)
	print(self,group,name)
	local window = self.windows[group][name]
	if (window.show.PlaybackState == Enum.PlaybackState.Playing) 
		or (window.hide.PlaybackState == Enum.PlaybackState.Playing) then
		return
	end
	if window.visible.Value then
		window.hide:Play() 
		self:ToggleAllProximityPrompts(true)
 
		self:blur(false)
	else
		window.show:Play() 
		self:ToggleAllProximityPrompts(false)
		if dontHideOtherWindows==true then
			return end
		for i,v in pairs(self.windows[group]) do if i==name then continue end self.windows[group][i].hide:Play() end
		self:blur(window.blurBackground)
 
	end
end


function tweens:hideAllWindows(group:string?) 
	self.windowsOnCloseOnce = function()end
	for i,v in pairs(self.windows[group]) do
		task.spawn(function() self:hideWindow(group,i,true) end) 	
	end  
end

function tweens:hideWindow(group,name,dontHideOtherWindows)
	local window = self.windows[group][name]
	if window.visible.Value  then print('closing',group,name,window) self:toggle(group,name,dontHideOtherWindows)  end 
	return window.instance
end

function tweens:showWindow(group,name,dontHideOtherWindows:boolean?)
	local window = self.windows[group][name]
	if not window.visible.Value then self:toggle(group,name,dontHideOtherWindows)  end
	return window.instance
end

local blurinstance = Instance.new('BlurEffect') 
blurinstance.Size = 0
blurinstance.Parent = camera
local blur = tws:Create(blurinstance,TweenInfo.new(0.2),{Size = 30})
local unblur = tws:Create(blurinstance,TweenInfo.new(0.2),{Size = 0})

function tweens:blur(state) 	
	if state  then unblur:Cancel() blur:Play() return end
	blur:Cancel() unblur:Play()	
end
function tweens:freezePlayer(state)
	--	if state  then return Controls:Disable() end
	--	Controls:Enable()
end
 
return tweens
