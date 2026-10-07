
local Orbit = {}

local RunService = game:GetService("RunService")

local loadedModules = {}
local loadingMutex = {} 

local Maid = require(game.ReplicatedStorage.Packages["@Quenty"].Maid)

local function acquireLock(moduleName)
	while loadingMutex[moduleName] do
		task.wait()  
	end
	loadingMutex[moduleName] = true
end

local function releaseLock(moduleName)
	loadingMutex[moduleName] = nil
end

local function loadModule(moduleName)
	assert(type(moduleName) == "string" and moduleName ~= "", "Invalid module name provided.")

	local module = loadedModules[moduleName]
	if module then
		return module 
	end

	acquireLock(moduleName)

	module = loadedModules[moduleName]
	if module then
		releaseLock(moduleName) 
		return module
	end

	local searchLocations = { game.ReplicatedStorage.Packages }
	if RunService:IsServer() then
		table.insert(searchLocations, 1, game.ServerScriptService)
	end

	for _, location in ipairs(searchLocations) do
		local moduleScript = location:FindFirstChild(moduleName, true) 
		if moduleScript and moduleScript:IsA("ModuleScript") then
			module = require(moduleScript)

			loadedModules[moduleName] = module 
			
			releaseLock(moduleName)

			return module
		end
	end

	releaseLock(moduleName)

	error("ModuleScript '" .. moduleName .. "' not found in search locations or is not a ModuleScript")
end

function Orbit.ClearCache(moduleName)
	loadedModules[moduleName] = nil
end

function Orbit.ClearAllCache()
	for k, _ in pairs(loadedModules) do
		loadedModules[k] = nil
	end
end

setmetatable(Orbit, {
	__call = function(_, moduleName)
		return loadModule(moduleName)
	end
})

Orbit.Maid = Maid

return Orbit
