local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local IS_SERVER_READY = ReplicatedStorage:WaitForChild('IS_SERVER_READY')
local ByteNet = require(ReplicatedStorage.Packages["@ffrostfall"].ByteNet)
local packets = require(ReplicatedStorage.packets)
-- Load controllers in a specific order
local Controllers = {}
local controllerNames = {
	"ReplicaHandler",
	"PlayerInteractionController",
	"PlayerUIController",
	'MusicController',
	"PlayerCharacterController",
}

local function loadControllerWithRetry(controllerName)
	local retries = 0
	local maxRetries = 1

	repeat
		task.wait()
		local success, controllerScript = pcall(function()
			return script.Parent.Controllers:WaitForChild(controllerName)
		end)

		if success then
			print(`[{script.Name}] | [{controllerName}] initialized`)
			Controllers[controllerName] = require(controllerScript)
			return true
		else
			retries = retries + 1
			warn("Failed to load controller:", controllerName)

			if retries <= maxRetries then
				warn("Retrying to load controller:", controllerName)
				task.wait(1)
			else
				warn("Max retries reached for controller:", controllerName)
				return false
			end
		end
	until retries > maxRetries
end
local function checkServerReady()
	local maxRetries = 30
	local retries = 0

	while not IS_SERVER_READY.Value and retries < maxRetries do
		task.wait()
		retries = retries + 1
	end

	if IS_SERVER_READY.Value then
		print(`[{script.Name}] | Server is ready, starting game...`)
		packets.PlayerReady.send({
			IsReady = true
		})
		local allControllersLoaded = true
		for _, controllerName in ipairs(controllerNames) do
			if not loadControllerWithRetry(controllerName) then
				allControllersLoaded = false
			end
		end

		if allControllersLoaded then
			print(`[{script.Name}] | All controllers loaded successfully.`)
			local player = Players.LocalPlayer
			if player:FindFirstChild('PlayerGui', true) or player.PlayerGui:FindFirstChild('Loading', true) then
				player.PlayerGui.Loading:Destroy()
			end
			-- Hide loading screen and allow player interaction
		else
			warn("Not all controllers were loaded successfully. Kicking player.")

			-- Kick the player if controllers failed to load
			local player = Players.LocalPlayer
			if player then
				player:Kick("Failed to load required controllers. Please try again later.")
			end
		end
	else
		warn("Server did not become ready in time. Please try again later.")
	end
end

checkServerReady()