local player = game.Players.LocalPlayer

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Orbit = require(ReplicatedStorage:WaitForChild('Packages')["@kabuyon"].Orbit)

local ReplicaController = Orbit('ReplicaController')

local ReplicaHandler = {}
local ActiveReplicas = {}

function ReplicaHandler.Init()
	ReplicaController.ReplicaOfClassCreated('ServerNameReplica', function(replica)
		ActiveReplicas['ServerNameReplica'] = replica
	end)

	ReplicaController.ReplicaOfClassCreated("PlayerProfileReplica", function(replica)
		if replica.Tags['Player'] == player then
			ActiveReplicas["PlayerProfileReplica"] = replica
		end
	end)

	ReplicaController.ReplicaOfClassCreated("FreeSkipReplica", function(replica)
		if replica.Tags['Player'] == player then
			ActiveReplicas["FreeSkipReplica"] = replica
		end
	end)
	ReplicaController.ReplicaOfClassCreated('HourlyRefreshReplica', function(replica)
		ActiveReplicas['HourlyRefreshReplica'] = replica
	end)
	
end

ReplicaHandler.Init()

function ReplicaHandler:GetReplica(Replica: string)
	if type(Replica) ~= "string" then
		error("GetReplica requires a string as the Replica argument")
	end
	local replicaValue = ActiveReplicas[Replica]
	if replicaValue then
		return replicaValue
	else
		warn("Replica not found:", Replica)
		return nil
	end
end

ReplicaController.RequestData()
return ReplicaHandler