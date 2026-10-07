local npc = script.Parent -- Assuming the LocalScript is directly inside the NPC

-- Function to play the dance animation
local function playDanceAnimation()
	local humanoid = npc:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid:LoadAnimation(script.DanceAnimation):Play() -- Replace "DanceAnimation" with the name of your dance animation
	end
end

-- Play the dance animation when the NPC spawns
playDanceAnimation()
