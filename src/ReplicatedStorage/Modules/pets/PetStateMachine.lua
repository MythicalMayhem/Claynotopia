--!strict
local animator = {}
local animatePetRemote = game.ReplicatedStorage.Remotes.animatePet
animatePetRemote.OnClientEvent:Connect(function(name,data) 
	animator[name] = data 
end)
function animator:Init(pet,tracks)end 

function animator:SetState(petName, s)    
	if (animator[petName].lastState~=s) and ((animator[petName].lastState == 'running' or animator[petName].lastState=='idle') 
		or (tick()-(animator[petName].debounce or 0) > 0.3)) then		
		animator[petName].lastState = s
		animator[petName].debounce = tick()
	end
	local t = animator[petName].tracks[animator[petName].lastState]
	if (t==nil ) or  (animator[petName].playing == t) then return end
	if animator[petName].playing then  animatePetRemote:FireServer('stop',animator[petName].playing.name) end
	animatePetRemote:FireServer('play',t.name)
	animator[petName].playing = t


end


return animator
