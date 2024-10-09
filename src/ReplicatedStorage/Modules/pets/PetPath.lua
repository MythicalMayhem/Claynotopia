--!strict
local player = game:GetService('Players').LocalPlayer
local localdata = require(game.ReplicatedStorage.Modules.LocalPlayer)
local animateRem = game.ReplicatedStorage.Remotes.animatePet
local types = require(game.ReplicatedStorage.Modules.typing)

local module = {}
module.eps = 5 -- error margin
module.followRadius = 10

local createPart = function(pos)
	local p = Instance.new('Part') p.Position = pos p.BrickColor = BrickColor.new(1,0,0)
	p.CanCollide = false p.CanQuery = false p.CanTouch = false p.Anchored = true
	p.Size = Vector3.new(0.5,0.5,0.5) p.Shape = Enum.PartType.Ball p.Parent = workspace.temp
end

local rc = function(s:string, cf:CFrame,hrp:typeof(game.ReplicatedStorage.Modules.types._template))
	local info = RaycastParams.new()
	info.IgnoreWater = true
	info.FilterType = Enum.RaycastFilterType.Exclude
	info.FilterDescendantsInstances = {hrp:FindFirstAncestorOfClass('Model'),workspace.pets}
	if s=='f' then 
		return workspace:Raycast(cf.Position,cf.LookVector.Unit*module.followRadius,info)	 
	elseif s=='d' then return workspace:Raycast(cf.Position,-cf.UpVector.Unit*20,info) end
	
end

local dist = function(from:Vector3,to:Vector3)
	return (from-to).Magnitude
end


function iscolliding(pet,cf,hrp)
--	local orientation, size = pet :GetBoundingBox()
--	local p = OverlapParams.new()
--	p.FilterType = Enum.RaycastFilterType.Exclude
--	p.FilterDescendantsInstances = {hrp.Parent } 
--	local k = workspace:GetPartBoundsInBox(cf + Vector3.new(0,2,0),size,p)
-- #k > 2	 
	return false
end
 
local connectionDebounce = tick()
function requestPivot(pet:Model,pos:CFrame)
		animateRem:FireServer('place',pos)
	if tick() - connectionDebounce >0.1 then
		connectionDebounce = tick()
	end
end

-- set follow radius to new radius if pet is inside max radius
local pos = nil
function module:place(hrp:Part&{Parent:Model},pet:Model) 
	if not pet.PrimaryPart then warn("waiting for primary part") return end
 
	if localdata.info.activity  and localdata.info.activity.family == 'gym' then
		if  localdata.info.activity.name 		== 'stamina' then requestPivot(pet,hrp.Parent.Torso[pet:GetAttribute('type').."stamina"].WorldCFrame) return 'stamina'
		elseif localdata.info.activity.name == 'chest' then   requestPivot(pet,hrp.Parent['Left Arm'][pet:GetAttribute('type')..'chest'].WorldCFrame) return 'chest'
		elseif localdata.info.activity.name == 'back' then    requestPivot(pet,hrp.Parent.Torso[pet:GetAttribute('type')..'back'].WorldCFrame) return 'idle'--'back'
		elseif localdata.info.activity.name == 'arms' then    requestPivot(pet,hrp.Parent.Torso[pet:GetAttribute('type')..'arms'].WorldCFrame) return 'arms'
		elseif localdata.info.activity.name == 'legs' then    requestPivot(pet,hrp.Parent['Right Leg'][pet:GetAttribute('type')..'legs'].WorldCFrame) return 'legs'
		else return 'idle' end
		
	end
	if not pos then pos =hrp.Parent:GetPivot()*CFrame.new(2,1,2) end 
	requestPivot(pet,pos)
	local S = ''
 
	if dist(hrp.Position*Vector3.new(1,0,1),pet.PrimaryPart.Position*Vector3.new(1,0,1)) < module.followRadius + 0.25   then  return 'idle' end
	
	local cf0:CFrame = CFrame.new(hrp.CFrame.Position)--pet.PrimaryPart.Position 
 	local or0 = hrp.CFrame - cf0.Position
	local candidate = nil 
	local old = 1000

	workspace.temp:ClearAllChildren()
	for i=1, 360/module.eps do
		local cf = cf0*CFrame.Angles(0,math.rad(i*module.eps),0)
		local fwdres = rc('f',cf,hrp)
		local pos = nil
		if  fwdres  then  
			local d1res = rc('d',CFrame.new(fwdres.Position-cf.LookVector.Unit*2),hrp)
			if d1res and dist(hrp.Position,d1res.Position)>5  then pos = (d1res.Position) end

		else
			local d2res = rc('d',CFrame.new(cf.Position+cf.LookVector.Unit*module.followRadius),hrp)
			if d2res  then pos = (d2res.Position) end
		end
		
		if not pos then continue end
		--createPart(pos)
		local k =dist(pet.PrimaryPart.CFrame.Position,pos)
		if k<old and not iscolliding(pet,CFrame.new(pos), hrp)	
		then candidate = pos old=k end
		--if k < 1 then break end
		 
	end
 

	if candidate  then
		pos = pet.PrimaryPart.CFrame:Lerp(CFrame.new(candidate + Vector3.new(0,3,0) ,Vector3.new(hrp.Position.X,pet.PrimaryPart.Position.Y,hrp.Position.Z)+hrp.CFrame.LookVector.Unit*50) ,0.1)
	else return 'idle' end 
	
	local orientation, size = hrp.Parent:GetBoundingBox()  

	local a = candidate.Y - pet.PrimaryPart.Position.Y    
	if hrp.AssemblyLinearVelocity.Magnitude >10  then	return 'run'	end
	--print(dist(hrp.Position,pet.PrimaryPart.Position))
	if dist(hrp.Position*Vector3.new(1,0,1),pet.PrimaryPart.Position*Vector3.new(1,0,1)) < module.followRadius + 2   then
		return 'walk'
	end
	if a > 0 then return 'jump'  
	elseif a < -0.1 then --FREEFALL/LAnded return 'jump'  
	end 
	
	return 'idle'
end
 
 
return module
