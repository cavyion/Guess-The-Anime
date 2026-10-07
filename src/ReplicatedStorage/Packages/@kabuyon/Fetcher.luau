local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local Maid = require(ReplicatedStorage.Packages["@Quenty"].Maid)  

local Fetcher = {}
local maid = Maid.new()  

function Fetcher.fetch(moduleName: string)
	local isClient = RunService:IsClient()
	local isServer = RunService:IsServer()

	local moduleInstance = nil

	if isClient then
		moduleInstance = ReplicatedStorage.Assets.Tables:FindFirstChild(moduleName)
	elseif isServer then
		local SERVER = ServerStorage.Assets.Tables
		local CLIENT = ReplicatedStorage.Assets.Tables

		if SERVER:FindFirstChild(moduleName) then
			moduleInstance = SERVER[moduleName]
		elseif CLIENT:FindFirstChild(moduleName) then
			moduleInstance = CLIENT[moduleName]:Clone()
			moduleInstance.Parent = SERVER
		end
	else
		error("Fetcher.fetch should be run on server or client.")
	end

	assert(moduleInstance, "Module not found: " .. moduleName)

	maid:GiveTask(moduleInstance)

	return require(moduleInstance)
end

function Fetcher.cleanup()
	maid:Cleanup()
end

return Fetcher
