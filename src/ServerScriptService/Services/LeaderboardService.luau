local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LeaderboardService = {}

local function GetOrderedDataStore(name)
	return DataStoreService:GetOrderedDataStore(name)
end

local function GetOrCreateLeaderboardPlayer(leaderboardFrame, index, template)
	local frame = leaderboardFrame:FindFirstChild("LeaderboardPlayer_" .. index)
	if not frame then
		frame = template:Clone()
		frame.Name = "LeaderboardPlayer_" .. index
		frame.Parent = leaderboardFrame
	end
	return frame
end

local function CleanBoard(leaderboardFrame, dataLength)
	local existingPlayers = {}

	-- Collect existing player frames and preserve UIListLayout/UIPadding
	for _, frame in pairs(leaderboardFrame:GetChildren()) do
		if frame:IsA("UIListLayout") or frame:IsA("UIPadding") then
			-- Preserve UIListLayout and UIPadding
		else
			local index = tonumber(frame.Name:match("LeaderboardPlayer_(%d+)"))
			if index and index <= dataLength then
				existingPlayers[index] = frame
			else
				frame:Destroy()
			end
		end
	end

	-- Reorder existing players and update their names
	for i = 1, dataLength do
		local playerFrame = existingPlayers[i]
		if playerFrame then
			playerFrame.Name = "LeaderboardPlayer_" .. i
		end
	end
end

local function FormatTime(seconds)
	local days = math.floor(seconds / (24 * 3600))
	seconds = seconds % (24 * 3600)
	local hours = math.floor(seconds / 3600)
	seconds = seconds % 3600
	local minutes = math.floor(seconds / 60)
	seconds = seconds % 60
	return string.format("%02dd %02dh %02dm %02ds", days, hours, minutes, seconds)
end

local function UpdateBoard(leaderboardFrame, data, template, minValue, isTimeBased)
	local topPlayerHumanoidDescription = nil
	local topPlayerId = nil
	local topPlayerScore = nil

	for i, v in ipairs(data) do
		local position = i
		local userId = v.key
		local score = v.value

		if score >= minValue then
			local leaderboardPlayer = GetOrCreateLeaderboardPlayer(leaderboardFrame, position, template)

			local success, err = pcall(function()
				leaderboardPlayer.USERNAME.Text = Players:GetNameFromUserIdAsync(userId)
				leaderboardPlayer.USER_IMAGE.Image = Players:GetUserThumbnailAsync(userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
			end)
			if not success then
				warn("Error fetching user data: " .. tostring(err))
			end

			if isTimeBased then
				leaderboardPlayer.STAT.Text = FormatTime(score)
			else
				leaderboardPlayer.STAT.Text = tostring(score)
			end
			leaderboardPlayer.RANK.Text = tostring(position)

			-- If this is the #1 player, load their humanoid description
			if position == 1 then
				local humanoidDescription = Players:GetHumanoidDescriptionFromUserId(userId)
				topPlayerHumanoidDescription = humanoidDescription
				topPlayerId = userId
				topPlayerScore = score
			end
		end
	end

	-- If we have a top player humanoid description, apply it to the NPC template
	if topPlayerHumanoidDescription and topPlayerId and topPlayerScore then
		local npcTemplate = leaderboardFrame.Parent.Parent.Parent.Parent.Parent:FindFirstChild("NPC_TEMPLATE")
		
		if npcTemplate then
			local humanoid = npcTemplate:FindFirstChildOfClass("Humanoid")
			if humanoid then
				humanoid:ApplyDescription(topPlayerHumanoidDescription)
				local topPlayerName = Players:GetNameFromUserIdAsync(topPlayerId)
				
				if not npcTemplate.Head:FindFirstChild('BillboardGui', true) then
					local bgClone = script.BillboardGui:Clone()
					bgClone.Parent = npcTemplate.Head
				end	
				
				
				npcTemplate.Head.BillboardGui.CONTAINER.NAME.Text = topPlayerName
				if isTimeBased then
					npcTemplate.Head.BillboardGui.CONTAINER.STAT.Text = string.format("Top Time: %s", FormatTime(topPlayerScore))
				else
					npcTemplate.Head.BillboardGui.CONTAINER.STAT.Text = string.format("Top Score: %s", tostring(topPlayerScore))
				end
			end
		end
	end
end

local function UpdateLeaderboards(leaderboards, template, minValue)
	for _, leaderboard in ipairs(leaderboards) do
		local dataStore = GetOrderedDataStore(leaderboard.Name)
		local success, message = pcall(function()
			local pages = dataStore:GetSortedAsync(false, 50)
			local data = pages:GetCurrentPage()
			CleanBoard(leaderboard.Frame:FindFirstChild("CONTAINER").LEADERBOARD_SCROLL, #data)
			UpdateBoard(leaderboard.Frame:FindFirstChild("CONTAINER").LEADERBOARD_SCROLL, data, template, minValue, leaderboard.IsTimeBased)
		end)
		if not success then
			print("Failed to update " .. leaderboard.Name .. ": " .. message)
		end
		-- task.wait() -- Ensure sequential updates with a brief pause between each
	end
end

function LeaderboardService.Start()
	if RunService:IsStudio() then
		print("[LeaderboardService] Persistent leaderboards are disabled in Studio.")
		return
	end

	local leaderboards = {}
	for _, board in pairs(workspace.Leaderboards:GetChildren()) do
		if board:IsA("Model") and board:FindFirstChild("LEADERBOARD_PART") then
			table.insert(leaderboards, {Name = board.Name, Frame = board.LEADERBOARD_PART.SurfaceGui.Holder, IsTimeBased = (board.Name == "Time_Spent")})
		end
	end

	local template = script:FindFirstChild("Leaderboard_User")
	local minValue = 0 -- Set minimum value to filter entries

	local refreshInterval = 600 -- Refresh every 600 seconds
	local timerUpdateInterval = 1 -- Update timer every second

	-- Initial leaderboard update
	UpdateLeaderboards(leaderboards, template, minValue)

	while true do
		for elapsedTime = refreshInterval, 0, -timerUpdateInterval do
			-- Update timer display
			local remainingTime = FormatTime(elapsedTime)
			for _, leaderboard in ipairs(leaderboards) do
				local refreshLabel = leaderboard.Frame:FindFirstChild("LEADERBOARD_REFRESH")
				if refreshLabel then
					refreshLabel.Text = "refreshes in " .. remainingTime
				end
			end
			task.wait(timerUpdateInterval)
		end

		-- Refresh the leaderboards
		UpdateLeaderboards(leaderboards, template, minValue)
	end
end

return LeaderboardService
