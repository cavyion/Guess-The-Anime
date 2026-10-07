local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")

local Orbit = require(ReplicatedStorage.Packages["@kabuyon"].Orbit)
local ReplicaService = Orbit('ReplicaService')
local SERVICES_FOLDER = ServerScriptService:WaitForChild("Services")
local IS_SERVER_READY = ReplicatedStorage:WaitForChild("IS_SERVER_READY")

local maxRetries = 2 

local function loadService(serviceName, retryCount)
	retryCount = retryCount or 0
	local success, errorMsg = pcall(function()
		require(SERVICES_FOLDER[serviceName])
	end)
	if not success then
		warn("Failed to load service: " .. serviceName .. ". Error: " .. errorMsg)
		if retryCount < maxRetries then
			task.wait(2)  -- Wait before retrying
			return loadService(serviceName, retryCount + 1)
		else
			game:Shutdown("Server shutdown due to failed initialization.")
			error("Server shutdown due to failed initialization.")
		end
	end
	return success
end

local function initializeServer()
	local services = {
		"ReplicaServerHandler",
		"DataManager",
		"MarketMaster",
		"MapService",
		"PlayerInteractionService",
		"PlayerHandler",
		"ServerHandler",
		"LeaderboardService",
		"CompanionService"
	}

	local allServicesLoaded = true
	for _, serviceName in ipairs(services) do
		task.wait()
		if not loadService(serviceName) then
			allServicesLoaded = false
		end
	end

	if allServicesLoaded then
		IS_SERVER_READY.Value = true
		print("[Runtime] | Server successfully initialized.")
	else
		warn("Server initialization failed. Not all services were loaded successfully.")
		-- Shutdown the game if services did not load after retries
		for _, player in ipairs(Players:GetPlayers()) do
			player:Kick("Server initialization failed. Please try again later.")
		end
		game:Shutdown("Server shutdown due to failed initialization.")
		error("Server shutdown due to failed initialization.")
	end
end


initializeServer()
require(SERVICES_FOLDER.LeaderboardService).Start()
