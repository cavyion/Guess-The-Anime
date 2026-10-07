local ChatService = game:GetService("Chat")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local RunService = game:GetService("RunService")

local Orbit = require(ReplicatedStorage.Packages["@kabuyon"].Orbit)
local Fetcher = Orbit("Fetcher")
local Maid = Orbit("Maid")
local Tween = Orbit('Tween')
local maid = Maid.new()
local ReplicaService = Orbit('ReplicaService')
local packets = require(ReplicatedStorage:WaitForChild("packets"))
local AnswerService = require(script.AnswerService)
local DataManager = require(script.Parent.DataManager)
local Resonate = Orbit('Resonate')

local Halls = workspace:WaitForChild("Halls")
local MAP_FOLDER = workspace:WaitForChild("Map")
local END_MARKER = MAP_FOLDER:WaitForChild('END_MARKER')
local HALLS_END = #Halls:GetChildren()

local Animes = Fetcher.fetch("Animes")

local PlayerInteractionService = {}

local PlayerAlreadyAnswered = {}

local KeyTable = {}
local KeyTable_FILLED = false

local function fillKeyTable()
	for i,v in Animes do
		if not table.find(KeyTable, i) then
			table.insert(KeyTable, i)
		end
	end
	
end

local ServerAnswers = {}
local AlreadyChosen = {}

-- local resetInterval = 1 * 60 * 60
local resetInterval = 1*60*60


function PlayerInteractionService.ResetHalls()
	if not KeyTable_FILLED then
		fillKeyTable()
		KeyTable_FILLED = true
	end

	local timeout = 10  -- seconds
	local startTime = os.time()

	repeat
		task.wait()
		if os.time() - startTime > timeout then
			warn("Timeout waiting for KeyTable to be filled.")
			return
		end
	until KeyTable_FILLED or #KeyTable >= 150

	ServerAnswers = {}
	AlreadyChosen = {}

	local possibleAnswers = KeyTable

	if #possibleAnswers == 0 then
		warn("KeyTable is empty. Unable to reset halls.")
		return
	end

	local Halls = game.Workspace:WaitForChild("Halls")

	-- Collect easy answers and general answers
	local easyAnswers = {}
	local generalAnswers = {}
	for _, answer in ipairs(possibleAnswers) do
		if Animes[answer] and Animes[answer].Difficulty == 'Easy' then
			table.insert(easyAnswers, answer)
		else
			table.insert(generalAnswers, answer)
		end
	end

	-- Ensure we have enough easy answers for the first 30 halls
	local first30Answers = {}
	local easyCount = math.min(#easyAnswers, 30)
	for i = 1, easyCount do
		local index = math.random(1, #easyAnswers)
		table.insert(first30Answers, easyAnswers[index])
		table.remove(easyAnswers, index)
	end

	-- Fill the rest with general answers if available
	while #first30Answers < HALLS_END and #generalAnswers > 0 do
		local index = math.random(1, #generalAnswers)
		local answer = generalAnswers[index]
		table.insert(first30Answers, answer)
		table.remove(generalAnswers, index)
	end

	-- Randomly fill remaining halls with any answers
	while #first30Answers < #possibleAnswers do
		local index = math.random(1, #possibleAnswers)
		local answer = possibleAnswers[index]
		if not AlreadyChosen[answer] then
			table.insert(first30Answers, answer)
			AlreadyChosen[answer] = true
		end
	end

	-- Assign answers to halls up to HALLS_END
	for hallIndex = 1, HALLS_END do
		local chosenAnswer = first30Answers[hallIndex]
		local hallName = "Hall" .. hallIndex
		ServerAnswers[hallName] = Animes[chosenAnswer]
		local hall = Halls:FindFirstChild(hallName)
		if hall then
			hall.ImageSurface.AnimeHolder.AnimeImage.Image = "rbxassetid://"..ServerAnswers[hallName].Images[1]
			hall.HintFrame.SurfaceHolder.SurfaceGui.HintText.Text = ServerAnswers[hallName].Hints[1]
			AlreadyChosen[chosenAnswer] = true
		else
			warn("Hall " .. hallName .. " not found.")
		end
	end
	print('[PlayerInteractionService] | ANIMES REFRESHED')

end

local SERVER_RESET_REPLICA_TOKEN = ReplicaService.NewClassToken('HourlyRefreshReplica')
local ServerResetReplica = ReplicaService.NewReplica({
	ClassToken = SERVER_RESET_REPLICA_TOKEN,
	Data = {RefreshIn = 3600},
	Replication = "All",
})
local function scheduleNextReset()
	local nextResetTime = resetInterval
	local resetMaid = Maid.new() -- Create a new Maid for the reset task

	resetMaid:GiveTask(task.spawn(function()
		while nextResetTime > 0 do
			task.wait(1) -- Wait for 1 second
			nextResetTime = nextResetTime - 1 -- Decrement nextResetTime by 1 second
			ServerResetReplica:SetValue({'RefreshIn'}, nextResetTime)
		end

		-- Reset time reached
		PlayerInteractionService.ResetHalls()
		scheduleNextReset() -- Schedule the next reset
	end))

	maid:GiveTask(resetMaid) -- Add the resetMaid to the main Maid
end

function PlayerInteractionService.startHallReset()
	PlayerInteractionService.ResetHalls()
	scheduleNextReset()
end

local function IS_QUALIFIED_FOR_X2(player)
	if player:IsInGroup(5817780) or player.MembershipType == Enum.MembershipType.Premium then
		return true
	else
		return false
	end
end

function PlayerInteractionService.InitializeGame(Player)
	PlayerAlreadyAnswered[Player.UserId] = {}

	local leaderstats = Player:WaitForChild("leaderstats")
	local CURRENT_STAGE = leaderstats:WaitForChild("Stage")

	local function openDoor()
		packets.OpenDoor.sendTo({
			activate = true,
			plr = Player.UserId
		}, Player)
	end
	
	local _profile = DataManager:GetPlayerProfile(Player)
	local PlayerProfile = _profile.Profile
	local PlayerDataReplica = _profile.Replica
	
	local playerMaid = Maid.new() -- Create a Maid for the player
	playerMaid:GiveTask(Player.Chatted:Connect(function(PlayerAnswer)
		local HallName = "Hall" .. CURRENT_STAGE.Value
		local AlreadyAnswered = PlayerAlreadyAnswered[Player.UserId]
		
		if string.len(PlayerAnswer) >= 3 then
			if AnswerService.checkAnswer(PlayerAnswer, ServerAnswers[HallName].Answers) == true then
				if not table.find(AlreadyAnswered, HallName) then
					table.insert(AlreadyAnswered, HallName)
					openDoor()
					if IS_QUALIFIED_FOR_X2(Player) then
						PlayerProfile.Data.CURRENCY.MONEY = PlayerProfile.Data.CURRENCY.MONEY + 2
					else
						PlayerProfile.Data.CURRENCY.MONEY = PlayerProfile.Data.CURRENCY.MONEY + 1
					end
					
					PlayerDataReplica:SetValue({"CURRENCY", "MONEY"}, PlayerProfile.Data.CURRENCY.MONEY)
					Resonate:PlaySound('coin', Player)
					if CURRENT_STAGE.Value >= HALLS_END then
						PlayerInteractionService.PlayerFinished(Player)
					end
				else
					openDoor()
				end
			else
				print(PlayerAnswer, "is not an answer")
			end
		end
		
	end))
	
	maid[Player.UserId] = playerMaid -- Store the player's Maid in the main Maid
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

function PlayerInteractionService.PlayerFinished(Player)
	local _profile = DataManager:GetPlayerProfile(Player)
	local PlayerProfile = _profile.Profile
	local PlayerDataReplica = _profile.Replica
	if IS_QUALIFIED_FOR_X2(Player) then
		PlayerProfile.Data.CURRENCY.TSUNOVIUM = PlayerProfile.Data.CURRENCY.TSUNOVIUM + 2
	else
		PlayerProfile.Data.CURRENCY.TSUNOVIUM = PlayerProfile.Data.CURRENCY.TSUNOVIUM + 1
	end

	PlayerProfile.Data.STATS.FINISHES = PlayerProfile.Data.STATS.FINISHES + 1
	
	PlayerDataReplica:SetValue({'CURRENCY', 'TSUNOVIUM'}, PlayerProfile.Data.CURRENCY.TSUNOVIUM)
	PlayerDataReplica:SetValue({'STATS', 'FINISHES'}, PlayerProfile.Data.STATS.FINISHES)
	PlayerAlreadyAnswered[Player.UserId] = {}

	local leaderstats = Player:WaitForChild("leaderstats")
	local CURRENT_STAGE = leaderstats.Stage
	local readonlyFinishes = leaderstats.Finishes
	readonlyFinishes.Value = readonlyFinishes.Value + 1
	
	CURRENT_STAGE.Value = 1
	local character = Player.Character
	if not character or character.Parent == nil then
		character = Player.CharacterAdded:Wait()
	end
	local END_POSITION = Vector3.new(END_MARKER.Position.X, END_MARKER.Position.Y, END_MARKER.Position.Z)
	Tween(character:WaitForChild('HumanoidRootPart'), END_POSITION, .5, Enum.EasingStyle.Sine, Enum.EasingDirection.In):Play()
	CHECK_FOR_BADGE(Player)
	task.wait(.5)
	if Player then
		CURRENT_STAGE.Value = 1
	end
	
end

function PlayerInteractionService.PlayerLeft(Player)
	if maid[Player.UserId] then
		maid[Player.UserId]:DoCleaning() -- Clean up all tasks for the player
		maid[Player.UserId] = nil
	end
end

Players.PlayerAdded:Connect(PlayerInteractionService.InitializeGame)
Players.PlayerRemoving:Connect(PlayerInteractionService.PlayerLeft)
PlayerInteractionService.startHallReset()

for _, player in ipairs(Players:GetPlayers()) do
	task.spawn(PlayerInteractionService.InitializeGame, player)
end

return PlayerInteractionService
