-- Define the whitelist with UserIds
local whitelist = {
	79749410, -- Replace with the UserId of whitelisted players
	100909428, -- Add more UserIds as needed
}

-- Function to check if a player's UserId is whitelisted
local function isWhitelisted(player)
	for _, userId in ipairs(whitelist) do
		if player.UserId == userId then
			return true
		end
	end
	return false
end

-- Event triggered when a player joins
game.Players.PlayerAdded:Connect(function(player)
	-- Wait briefly to ensure the player fully loads
	task.wait(1)
	-- If the player is not whitelisted, kick them
	if not isWhitelisted(player) then
		player:Kick("You are not whitelisted to join this game.")
	end
end)

-- For players already in the game when the script runs
for _, player in ipairs(game.Players:GetPlayers()) do
	task.wait(1) -- Optional: Small delay to avoid overloading
	if not isWhitelisted(player) then
		player:Kick("You are not whitelisted to join this game.")
	end
end
