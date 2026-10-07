local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Orbit = require(ReplicatedStorage:WaitForChild("Packages")["@kabuyon"].Orbit)
local ReplicaService = Orbit('ReplicaService')
local packets = require(ReplicatedStorage.packets)

local ServerHandler = {}

local adjectives = {
	-- Cosmic Horror
	"Eldritch", "Abyssal", "Cursed", "Phantasmal", "Sinister", "Profane", "Lurking", "Apocalyptic", "Primordial", "Unholy",
	-- Warhammer 40k
	"Grimdark", "Chaotic", "Heretical", "Xenos", "Inquisitorial", "Warp-tainted", "God", "Ecclesiastical", "Necron", "Eldar",
	-- Cute
	"Kawaii", "Sugoi", "Chibi", "Fluffy", "Bubbly", "Lovely", "Adorable", "Sweet", "Cuddly", "Whimsical"
}


local nouns = {
	-- Cosmic Horror
	"Abyss", "Monstrosity", "Horror", "Anomaly", "Phantasm", "Ruin", "Crypt", "Madness", "Cataclysm", "Entity",
	-- Warhammer 40k
	"Space Marine", "Ork", "Inquisitor", "Commissar", "Terminator", "Genestealer", "Hive", "Cultist", "Guardsman", "Craftworld",
	-- Anime
	"Senpai", "Mecha", "Chibi", "Tsundere", "Kirei", "Otaku", "Shōnen", "Fantasy", "Nekomimi", "Noob"
}



function ServerHandler.generateServerName()
	local ServerInitiatedWhen = tick()
	local randomAdjective = adjectives[math.random(1, #adjectives)]
	local randomNoun = nouns[math.random(1, #nouns)]
	return randomAdjective .. " " .. randomNoun
end

local serverName = ServerHandler.generateServerName()

local ServerNameClassToken = ReplicaService.NewClassToken('ServerNameReplica')

function ServerHandler.sendServerNameToPlayer(Player)
	local ServerNameReplica = ReplicaService.NewReplica({
		ClassToken = ServerNameClassToken,
		Data = {servername = "Loading..."},
		Replication = "All",
	})
	ServerNameReplica:SetValue({'servername'}, serverName)
end



Players.PlayerAdded:Connect(ServerHandler.sendServerNameToPlayer)
for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
	task.spawn(ServerHandler.sendServerNameToPlayer, player)
end

return ServerHandler