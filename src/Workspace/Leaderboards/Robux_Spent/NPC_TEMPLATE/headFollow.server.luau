task.wait(5)

local NPC = script.Parent
local Neck = script.Parent.Head.Neck

function getClosestPlayer()
	local closest_player, closest_distance = nil, 100
	for i, player in pairs(workspace:GetChildren()) do
		if player:FindFirstChild("Humanoid") and player ~= NPC then
			local distance = (NPC.PrimaryPart.Position - player.PrimaryPart.Position).Magnitude
			if distance < closest_distance then
				closest_player = player
				closest_distance = distance
			end
		end
	end
	return closest_player
end

local cframe0 = Neck.C0

while true do
	local player = getClosestPlayer()
	if player then
		local is_in_front = NPC.PrimaryPart.CFrame:ToObjectSpace(player.PrimaryPart.CFrame).Z < 0
		if is_in_front then
			local unit = -(NPC.PrimaryPart.CFrame.p - player.PrimaryPart.Position).unit
			Neck.C0 = cframe0 * CFrame.new(Vector3.new(0, 0, 0), unit) * CFrame.Angles(0, -math.rad(NPC.PrimaryPart.Orientation.Y), 0)
		end
	end
	task.wait()
end