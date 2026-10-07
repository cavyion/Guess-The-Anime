-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local MarketplaceService = game:GetService("MarketplaceService")
local RunService = game:GetService("RunService")

-- Modules
local Orbit = require(ReplicatedStorage.Packages["@kabuyon"].Orbit)
local Fetcher = Orbit("Fetcher")
local Maid = Orbit("Maid")
local DataManager = require(script.Parent.DataManager)
local Tween = Orbit("Tween")
local packets = require(ReplicatedStorage:WaitForChild("packets"))

-- Constants
local HALLS_FOLDER = workspace:WaitForChild("Halls")
local HALLS_END = #HALLS_FOLDER:GetChildren()

-- Variables
local MapService = {}
local debounceTimes = {} -- Table to keep track of last touch times
local maids = {} -- Table to store Maids for each player and pathObject


function MapService.OnPlayerStepOnPath(player, pathObject)
	-- Get the parent hall of the path object
	local hallName = pathObject.Parent.Parent.Name
	local hallNumber = tonumber(string.match(hallName, "%d+"))

	if hallNumber then
		-- Update the player's current hall
		local leaderstats = player:FindFirstChild("leaderstats")
		if leaderstats then
			local CURRENT_STAGE = leaderstats.Stage
			if CURRENT_STAGE then
				CURRENT_STAGE.Value = hallNumber
			end
		end
	end
end

local BadgeService = game:GetService('BadgeService')
local FINISHES_BADGE = 2125444316
local function CHECK_FOR_BADGE(player)
	if RunService:IsStudio() then
		return
	end

	local _hasBadge = false
	local success, message = pcall(function()
		_hasBadge = BadgeService:UserHasBadgeAsync(player.UserId, FINISHES_BADGE)
	end)
	if not success then
		warn("Error while checking if player has badge: " .. tostring(message))
		return
	end
	if _hasBadge == false then
		BadgeService:AwardBadge(player.UserId, FINISHES_BADGE)
	end
end

function MapService.Initialize(player)
	
	debounceTimes[player.UserId] = {}
	local playerMaid = Maid.new()
	maids[player] = playerMaid
	
	local WATCH_PATHS = coroutine.create(function()
		for _, pathObject in pairs(CollectionService:GetTagged("Path")) do
			local connection
			connection = pathObject.Touched:Connect(function(hit)
				local character = hit.Parent
				if character and Players:GetPlayerFromCharacter(character) == player then
					local currentTime = tick()
					local lastTouchTime = debounceTimes[player.UserId].PATH_DEBOUNCE or 0
					if currentTime - lastTouchTime >= 1 then -- Debounce time of 1 second
						debounceTimes[player.UserId].PATH_DEBOUNCE = currentTime
						-- Perform action
						MapService.OnPlayerStepOnPath(player, pathObject)
					end
				end
			end)
			playerMaid:GiveTask(connection)
		end
	end)
	
	local WATCH_SKIPS = coroutine.create(function()
		for i,v in pairs(HALLS_FOLDER:GetChildren()) do
			local SkipPrompt = v.SkipSurface.SkipPrompt
			SkipPrompt.HoldDuration = .25
			SkipPrompt.MaxActivationDistance = 20
			
			local connection
			connection = SkipPrompt.Triggered:Connect(function(player)
				local currentTime = tick()
				local lastTriggerTime = debounceTimes[player.UserId].SKIP_DEBOUNCE or 0
				if currentTime - lastTriggerTime >= 3 then
					debounceTimes[player.UserId].SKIP_DEBOUNCE = currentTime
					local _profile = DataManager:GetPlayerProfile(player)
					local PlayerProfile = _profile.Profile
					local PlayerDataReplica = _profile.Replica
					
					if PlayerProfile.Data.CURRENCY.SKIPS >= 1 then
						local leaderstats = player:WaitForChild('leaderstats')
						local CURRENT_STAGE = leaderstats:WaitForChild('Stage')
						
						local INSTANT_TELEPORT = true
						local NEXT_HALL = nil
						if HALLS_FOLDER and CURRENT_STAGE and CURRENT_STAGE.Value + 1 <= HALLS_END then
							NEXT_HALL = HALLS_FOLDER:FindFirstChild("Hall" .. tostring(CURRENT_STAGE.Value + 1))
						end

						if NEXT_HALL then
							local x, y, z = NEXT_HALL.HallMarker.Position.X, NEXT_HALL.HallMarker.Position.Y, NEXT_HALL.HallMarker.Position.Z
							if INSTANT_TELEPORT then
								packets.OpenDoor.sendTo({
									activate = true,
									plr = player.UserId
								}, player)
								Tween(player.Character.HumanoidRootPart, Vector3.new(x, y + 4, z), 1, Enum.EasingStyle.Sine, Enum.EasingDirection.In):Play()
							else
								player.Character.HumanoidRootPart.Position = Vector3.new(x, y + 4, z)
							end
						else
							local END_MARKER = workspace:WaitForChild('Map').END_MARKER
							local x, y, z = END_MARKER.Position.X, END_MARKER.Position.Y, END_MARKER.Position.Z

							player.Character.HumanoidRootPart.Position = Vector3.new(x, y+4, z)
							PlayerProfile.Data.CURRENCY.TSUNOVIUM = PlayerProfile.Data.CURRENCY.TSUNOVIUM + 1
							PlayerProfile.Data.STATS.FINISHES = PlayerProfile.Data.STATS.FINISHES + 1
							player.leaderstats.Finishes.Value = player.leaderstats.Finishes.Value + 1

							PlayerDataReplica:SetValue({'CURRENCY', 'TSUNOVIUM'}, PlayerProfile.Data.CURRENCY.TSUNOVIUM)
							PlayerDataReplica:SetValue({'STATS', 'FINISHES'}, PlayerProfile.Data.STATS.FINISHES)
							
							CHECK_FOR_BADGE(player)	
							
							warn("NEXT_HALL not found or CURRENT_STAGE.Value + 1 exceeds HALLS_END")
						end
						PlayerProfile.Data.CURRENCY.SKIPS = PlayerProfile.Data.CURRENCY.SKIPS - 1
						PlayerDataReplica:SetValue({'CURRENCY', 'SKIPS'}, PlayerProfile.Data.CURRENCY.SKIPS)
					else
						MarketplaceService:PromptProductPurchase(player, 1238603730)
					end
				end
			end)
			playerMaid:GiveTask(connection)
		end
	end)
	
	coroutine.resume(WATCH_PATHS)
	coroutine.resume(WATCH_SKIPS)
end

local Images = require(ReplicatedStorage:WaitForChild('Assets').Tables.Images)

function MapService:AddPaintings()
	local MAP_FOLDER = workspace:WaitForChild("Map")
	local DECORATIONS_FOLDER = MAP_FOLDER:WaitForChild("Decorations")

	for _, paintingFrame in ipairs(DECORATIONS_FOLDER:GetChildren()) do
		if paintingFrame.Name == "PaintFrame" then
			local SurfaceHolder = paintingFrame:FindFirstChild("SurfaceHolder")
			if SurfaceHolder then
				local SurfaceGUI = SurfaceHolder:FindFirstChild("SurfaceGui")
				if SurfaceGUI then
					local UserSubmission = SurfaceGUI:FindFirstChild("UserSubmission")

					-- Get a random image from Images table
					local randomIndex = math.random(1, #Images)
					local randomImage = Images[randomIndex]

					-- Assign the random image to the SurfaceGUI
					if UserSubmission then
						UserSubmission.Image = randomImage
					else
						warn("UserSubmission not found in SurfaceGUI of paintingFrame:", paintingFrame.Name)
					end
				else
					warn("SurfaceGui not found in SurfaceHolder of paintingFrame:", paintingFrame.Name)
				end
			else
				warn("SurfaceHolder not found in paintingFrame:", paintingFrame.Name)
			end
		end    
	end
end



Players.PlayerAdded:Connect(MapService.Initialize)
Players.PlayerRemoving:Connect(function(player)
	if maids[player] then
		maids[player]:DoCleaning()
		maids[player] = nil
	end
end)

for _, player in ipairs(Players:GetPlayers()) do
	task.spawn(MapService.Initialize, player)
end

function MapService:Cleanup()
	for _, maid in pairs(maids) do
		maid:DoCleaning()
	end
	maids = {} -- Clear the maids table after cleaning
end

MapService:AddPaintings()

return MapService
