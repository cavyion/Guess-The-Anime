local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local PhysicsService = game:GetService("PhysicsService")
local packets = require(ReplicatedStorage:WaitForChild("packets"))

local Orbit = require(ReplicatedStorage.Packages["@kabuyon"].Orbit)
local Maid = Orbit("Maid")

local PlayerHandler = {}
local maids = {}

local PLAYER_COLLISION_GROUP = "Players"

-- Ensure the collision group exists and set its properties
local function setupCollisionGroups()
	if not pcall(function() PhysicsService:RegisterCollisionGroup(PLAYER_COLLISION_GROUP) end) then
		-- Collision group already exists, ensure properties are correct
		PhysicsService:CollisionGroupSetCollidable(PLAYER_COLLISION_GROUP, PLAYER_COLLISION_GROUP, false)
	else
		PhysicsService:CollisionGroupSetCollidable(PLAYER_COLLISION_GROUP, PLAYER_COLLISION_GROUP, false)
	end
end

-- Assign all character parts to the "Players" collision group
local function assignToCollisionGroup(character)
	for _, part in ipairs(character:GetDescendants()) do
		if part:IsA("BasePart") then
			part.CollisionGroup = PLAYER_COLLISION_GROUP
		end
	end
end

function PlayerHandler.handlePlayer(Player)
	if game:GetService("Chat"):CanUserChatAsync(Player.UserId) == false then
		Player:Kick(Player.Name.." is not allowed to chat because of their account settings, return when your mommy allows you :)")
	end
	
	local ClientAudio = Instance.new('Folder')
	local Music = Instance.new('Sound')
	local SFX_folder = Instance.new('Folder')
	ClientAudio.Parent = Player
	
	ClientAudio.Name = 'ClientAudio'
	Music.Name = "Music"	
	Music.Parent = ClientAudio
	SFX_folder.Name = 'SFX'
	SFX_folder.Parent = ClientAudio
	
	
	
	local maid = Maid.new()
	maids[Player.UserId] = maid

	local function onCharacterAdded(character)
		assignToCollisionGroup(character)
		character.Parent = workspace:WaitForChild('Live').Players
		for i,v in character:WaitForChild("HumanoidRootPart"):GetDescendants() do
			if v:IsA("Sound") then
				v:Destroy()
			end
		end
	end

	if Player.Character then
		onCharacterAdded(Player.Character)
	end
	


	maid:GiveTask(Player.CharacterAdded:Connect(onCharacterAdded))
end

function PlayerHandler.playerLeft(Player)
	if maids[Player.UserId] then
		maids[Player.UserId]:DoCleaning()
		maids[Player.UserId] = nil
	end
end

packets.PlayerReady.listen(function(data, player)
	if data.IsReady then
		player:LoadCharacter()
	end
end)

Players.PlayerAdded:Connect(PlayerHandler.handlePlayer)
Players.PlayerRemoving:Connect(PlayerHandler.playerLeft)

-- Setup collision groups on script initialization
setupCollisionGroups()

-- For players already in the game when the script runs
for _, player in ipairs(Players:GetPlayers()) do
	task.spawn(PlayerHandler.handlePlayer, player)
end

return PlayerHandler
