local player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Orbit = require(ReplicatedStorage.Packages["@kabuyon"].Orbit)
local Fetcher = Orbit("Fetcher")
local packets = require(ReplicatedStorage.packets)

local PlayerInteractionController = {}

local Halls = workspace:WaitForChild("Halls")

packets.OpenDoor.listen(function(data)
	local player = game.Players:GetPlayerByUserId(data.plr)
	if not player then
		return
	end

	local leaderstats = player.leaderstats
	local CurrentStage = leaderstats.Stage
		
	if data.activate == true then
		local HallName = "Hall" .. CurrentStage.Value
		local HallData = Halls[HallName]
		if HallData then
			local Door = HallData.Door
			local ImageSurface = HallData.ImageSurface
			local ImageHolder = ImageSurface.AnimeHolder
			
			Door.Transparency = 1
			Door.CanCollide = false
			ImageSurface.Transparency = 1
			ImageSurface.CanCollide = false
			ImageHolder.Enabled = false

			task.delay(4, function()
				Door.Transparency = 0
				Door.CanCollide = true
				ImageSurface.Transparency = 0
				ImageSurface.CanCollide = true
				ImageHolder.Enabled = true
			end)
		end
	end
	
end)

return PlayerInteractionController