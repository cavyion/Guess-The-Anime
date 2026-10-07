local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Orbit = require(ReplicatedStorage:WaitForChild("Packages")["@kabuyon"].Orbit)
local ReplicaService = Orbit('ReplicaService')

local ReplicaServerHandler = {}
local Replicas = {}

local function cleanUpPlayer(player)
	Replicas[player.UserId] = nil
end

function ReplicaServerHandler.InsertReplica(player, replica, replicaClass)
	if Replicas[player.UserId] then
		Replicas[player.UserId][replicaClass] = replica
	end
end

function ReplicaServerHandler:GetReplica(player, class)
	return Replicas[player.UserId][class]
end

-- Handle new players joining
Players.PlayerAdded:Connect(function(player)
	Replicas[player.UserId] = {}
end)

-- Handle players already in the game
for _, player in ipairs(Players:GetPlayers()) do
	if not Replicas[player.UserId] then
		Replicas[player.UserId] = {}
	end
end

-- Clean up when players leave
Players.PlayerRemoving:Connect(function(player)
	cleanUpPlayer(player)
end)

return ReplicaServerHandler
