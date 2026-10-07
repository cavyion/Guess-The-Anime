local Players = game:GetService('Players')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local ServerScriptService = game:GetService("ServerScriptService")
local DataStoreService = game:GetService("DataStoreService")
local RunService = game:GetService("RunService")

local IS_STUDIO = RunService:IsStudio()
local ROBUX_SPENT_STORE
local FINISHES_STORE
local TIME_SPENT_STORE

if not IS_STUDIO then
	ROBUX_SPENT_STORE = DataStoreService:GetOrderedDataStore('Robux_Spent')
	FINISHES_STORE = DataStoreService:GetOrderedDataStore('Times_Finished')
	TIME_SPENT_STORE = DataStoreService:GetOrderedDataStore('Time_Spent')
else
	print("[DataManager] Studio session: using mock profiles; progress will not persist.")
end

local BadgeService = game:GetService("BadgeService")
local Orbit = require(ReplicatedStorage:WaitForChild("Packages")["@kabuyon"].Orbit)
local DataStore2 = Orbit('DataStore2')
local ProfileService = Orbit('ProfileService')
local ReplicaService = Orbit('ReplicaService')

local leaderstats = Instance.new("Folder")
leaderstats.Name = "leaderstats"
local CURRENT_STAGE = Instance.new("IntValue")
CURRENT_STAGE.Value = 1
CURRENT_STAGE.Name = "Stage"
CURRENT_STAGE.Parent = leaderstats
local FINISHES = Instance.new('IntValue')
FINISHES.Value = 0
FINISHES.Name = "Finishes"
FINISHES.Parent = leaderstats

DataStore2.Combine('Data', 'Money', 'RobuxSpent', 'Time', 'Finishes', 'Skips', 'SkipsTaken', 'OwnedTags', 'Companions', 'Spins', 'Deals')

local PROFILE_SERVICE_TEMPLATE = require(script.PROFILE_SERVICE_TEMPLATE)
local FIRST_TIME_BADGE = 2124900429
local FINISHES_BADGE = 2125444316

local DataManager = {}

local ProfileStore = ProfileService.GetProfileStore(
	"PlayerData",
	PROFILE_SERVICE_TEMPLATE
)

if IS_STUDIO then
	ProfileStore = ProfileStore.Mock
end


local PLAYER_PROFILES = {} -- [player] = {Profile = profile, Replica = replica} REPLICA IS HOW WE SEND THE DATA TO THE CLIENT
local ACTIVE_DATA = {}

local function convertDS2(player, profile)
	local MoneyStore = 				DataStore2("Money",player)
	local RobuxSpentStore =			DataStore2("RobuxSpent",player)
	local TimeStore = 				DataStore2("Time",player)
	local FinishesStore = 			DataStore2("Finishes",player)
	local SkipsStore = 				DataStore2("Skips",player)
	local SkipsTakenStore =	 		DataStore2("SkipsTaken",player)
	local SpinsStore = 				DataStore2("Spins", player)
	--		Player Upgrades / Cosmetics	 DataStores
	local ownedTags = 				{}
	local ownedCompanions = 		{}
	local deals = 					{}
	local OwnedTagsStore = 			DataStore2("OwnedTags", player)
	local OwnedCompanionsStore =	DataStore2("Companions", player)
	local Deals = 					DataStore2("Deals", player)
	
	if profile.Data.IS_CONVERTED == false then
		profile.Data.CURRENCY.MONEY = 		MoneyStore:Get(25)
		profile.Data.CURRENCY.SKIPS = 		SkipsStore:Get(1)
		profile.Data.CURRENCY.TSUNOVIUM = 	SpinsStore:Get(3)

		profile.Data.STATS.ROBUX_SPENT = 	RobuxSpentStore:Get(0)
		profile.Data.STATS.TIME_SPENT = 	TimeStore:Get(0)
		profile.Data.STATS.FINISHES = 		FinishesStore:Get(0)
		profile.Data.STATS.SKIPS_TAKEN = 	SkipsTakenStore:Get(0)

		profile.Data.INVENTORY.COMPANIONS = OwnedCompanionsStore:Get({"Ichistop"})
		profile.Data.IS_CONVERTED = 		true
	else
		return
	end
	
end

local function CHECK_IF_FIRST_TIME(player, profile)
	if IS_STUDIO then
		return
	end

	local _hasBadge = false
	local success, message = pcall(function()
		_hasBadge = BadgeService:UserHasBadgeAsync(player.UserId, FIRST_TIME_BADGE)
	end)
	if not success then
		warn("Error while checking if player has badge: " .. tostring(message))
		return
	end
	if _hasBadge == false then
		BadgeService:AwardBadge(player.UserId, FIRST_TIME_BADGE)
	else
		print('player has played before')
		convertDS2(player, profile)
	end
end

local function IS_QUALIFIED_FOR_X2(player)
	if player:IsInGroup(5817780) or player.MembershipType == Enum.MembershipType.Premium then
		return true
	else
		return false
	end
end

local PLAYER_PROFILE_CLASS_TOKEN = ReplicaService.NewClassToken('PlayerProfileReplica')
local FREE_SKIP_CLASS_TOKEN = ReplicaService.NewClassToken('FreeSkipReplica')

function DataManager.handlePlayer(player)
	local profile = ProfileStore:LoadProfileAsync("Player_"..player.UserId)
	if profile ~= nil then
		profile:AddUserId(player.UserId)
		profile:Reconcile()
		profile:ListenToRelease(function()
			PLAYER_PROFILES[player].Replica:Destroy()
			PLAYER_PROFILES[player] = nil
			player:Kick()
		end)
		if player:IsDescendantOf(Players) == true then
			
			local player_profile_Template = {
				Profile = profile,
				Replica = ReplicaService.NewReplica({
					ClassToken = PLAYER_PROFILE_CLASS_TOKEN,
					Tags = {Player = player},
					Data = profile.Data,
					Replication = "All",
				}),
				_player = player,
			}
			
			PLAYER_PROFILES[player] = player_profile_Template
			ACTIVE_DATA[player] = {}
			CHECK_IF_FIRST_TIME(player, profile)

			local FREE_SKIP_REPLICA = ReplicaService.NewReplica({
				ClassToken = FREE_SKIP_CLASS_TOKEN,
				Tags = {["Player"] = player},
				Data = {FreeSkipIn = 300},
				Replication = "All",
			})		

			local leaderstatsTemp = leaderstats:Clone()
			leaderstatsTemp.Parent = player
			leaderstatsTemp:WaitForChild('Finishes').Value = profile.Data.STATS.FINISHES
			-- Initial setup
			ACTIVE_DATA[player].TimeSpentInSession = os.time()
			ACTIVE_DATA[player].LastSkipsAwardTime = os.time()
			ACTIVE_DATA[player].IsProfileReady = true
						
			local initialCountdown
			if IS_QUALIFIED_FOR_X2(player) then
				initialCountdown = 3*60
			else
				initialCountdown = 6*60
			end
			
			
			local ClientSettings = Instance.new('Folder')
			ClientSettings.Parent = player
			ClientSettings.Name = 'ClientSettings'
			
			local SFX_BOOL = Instance.new('BoolValue')
			SFX_BOOL.Parent = ClientSettings
			SFX_BOOL.Name = 'SFX_BOOL'
			SFX_BOOL.Value = true
			
			
			task.spawn(function()
				local countdown = initialCountdown -- Set the countdown for this player
				while player and player.Parent do
					task.wait(1) -- Wait for 1 second
					countdown -= 1 -- Reduce the countdown by 1
					if FREE_SKIP_REPLICA then
						FREE_SKIP_REPLICA:SetValue({'FreeSkipIn'}, countdown)
					end
					if countdown <= 0 then
						-- Award the skip and reset the countdown
						if ACTIVE_DATA[player] and ACTIVE_DATA[player].LastSkipsAwardTime then
							ACTIVE_DATA[player].LastSkipsAwardTime = os.time() -- Update the award time
						end
						if profile and profile.Data and profile.Data.CURRENCY then
							profile.Data.CURRENCY.SKIPS = (profile.Data.CURRENCY.SKIPS or 0) + 1
							profile.Data.STATS.TIME_SPENT = (profile.Data.STATS.TIME_SPENT or 0) + initialCountdown
							if PLAYER_PROFILES[player] and PLAYER_PROFILES[player].Replica then
								PLAYER_PROFILES[player].Replica:SetValue({'CURRENCY', 'SKIPS'}, profile.Data.CURRENCY.SKIPS)
							end
						end
						countdown = initialCountdown -- Reset the countdown
					end
				end
			end)


		else
			profile:Release()
		end
	else
		player:Kick("your data was intercepted by hackers.")
	end	
end

function DataManager:GetPlayerProfile(player)
	if not PLAYER_PROFILES[player] then
		return
	else
		return PLAYER_PROFILES[player]
		
		-- return Replica and Profile Object
		-- via Profiles[player].Profile or Profiles[player].Replica
	end
end


function DataManager.handleOrdered(player, profile)
	if profile == nil then
		return
	end

	if IS_STUDIO then
		profile:Release()
		return
	end

	local function setAsyncWithRetry(store, userId, value, retryCount)
		retryCount = retryCount or 3 -- Number of retry attempts
		local success, err
		for attempt = 1, retryCount do
			success, err = pcall(function()
				store:SetAsync(userId, value)
			end)
			if success then
				return true
			else
				warn(("Failed to update %s, attempt %d: %s"):format(store.Name, attempt, tostring(err)))
				task.wait(1) -- Wait between retries, adjust as needed
			end
		end
		return false
	end

	-- Example usage with retry logic
	local success1 = setAsyncWithRetry(ROBUX_SPENT_STORE, player.UserId, profile.Data.STATS.ROBUX_SPENT)
	if not success1 then
		warn("Failed to update ROBUX_SPENT_STORE after retries")
	end

	local success2 = setAsyncWithRetry(FINISHES_STORE, player.UserId, profile.Data.STATS.FINISHES)
	if not success2 then
		warn("Failed to update FINISHES_STORE after retries")
	end

	local success3 = setAsyncWithRetry(TIME_SPENT_STORE, player.UserId, profile.Data.STATS.TIME_SPENT)
	if not success3 then
		warn("Failed to update TIME_SPENT_STORE after retries")
	end
	
	if profile then
		profile:Release()
	end
end

function DataManager.playerLeft(player)
	local playerProfile = PLAYER_PROFILES[player]
	if playerProfile then
		DataManager.handleOrdered(player, playerProfile.Profile)
	end
end

-- INCASE PLAYERS HAVE JOINED EARLIER THAN THIS SCRIPT
for _, player in ipairs(Players:GetPlayers()) do
	task.spawn(DataManager.handlePlayer, player)
end

Players.PlayerAdded:Connect(DataManager.handlePlayer)
Players.PlayerRemoving:Connect(DataManager.playerLeft)

game:BindToClose(function()
	for _, player in pairs(PLAYER_PROFILES) do
		player.Profile:Release()
	end
end)

return DataManager
