--!strict
local animator = {}
local animatePetRemote = game.ReplicatedStorage.Remotes.animatePet
local PetAnimator = require(game.ReplicatedStorage.Modules.pets.PetAnimator)
function animator:Init(uid,name,data) 
	if not animator[uid] then
		animator[uid] = {}
	end
	animator[uid][name] = data 
end

function animator:SetState(uid ,petName, s)    
	local p = animator[uid][petName] 
	if (p.lastState~=s) and ((p.lastState == 'running' or p.lastState=='idle') 
		or (tick()-(p.debounce or 0) > 0.3)) then		
		p.lastState = s
		p.debounce = tick()
	end
	local t = p.tracks[p.lastState]
	if (t==nil ) or  (p.playing == t) then return end
	if p.playing then  PetAnimator:Stop(uid,p.playing.name) end
	PetAnimator:Play(uid, t.name)
	p.playing = t
end


return animator
