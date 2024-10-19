local module = {}
module.lookAt = nil
module.conn = nil
module.subj = nil
function createDummyPart(pos: Vector3)
	local p = Instance.new("Part")
	p.Position = pos
	p.CanCollide = false
	p.CanQuery = false
	p.CanTouch = false
  p.Anchored  =true
  p.Transparency = 1
	p.Parent = workspace
	return p
end

function module:Set(pos: Vector3)
	module:Unset()
  local camera = workspace.CurrentCamera
  module.lookAt = createDummyPart(pos)
  module.subj = camera.CameraSubject
  camera.CameraType = Enum.CameraType.Watch
  camera.CameraSubject = module.lookAt
end

function module:Unset()
  local camera = workspace.CurrentCamera
  camera.CameraType = Enum.CameraType.Custom 
  camera.CameraSubject = module.subj
	if module.conn   then module.conn:Disconnect() end
	if module.lookAt then module.lookAt:Destroy()  end
end

return module
