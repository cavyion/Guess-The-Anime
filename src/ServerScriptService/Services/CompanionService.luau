
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")
local PhysicsService = game:GetService("PhysicsService")
local packets = require(ReplicatedStorage:WaitForChild("packets"))

local Orbit = require(ReplicatedStorage.Packages["@kabuyon"].Orbit)
local Maid = Orbit("Maid")
local Resonate = Orbit('Resonate')

local Live = workspace:WaitForChild("Live")

local packets = require(ReplicatedStorage.packets)


local CompanionService = {}
local debounceTimes = {}
local maids = {}

local SHARED_ASSETS_FOLDER = ReplicatedStorage:WaitForChild("Assets")
local ANIMATIONS_FOLDER = SHARED_ASSETS_FOLDER:WaitForChild("Animations")

local SERVER_ASSETS_FOLDER = ServerStorage:WaitForChild("Assets")
local COMPANIONS_FOLDER = SERVER_ASSETS_FOLDER:WaitForChild("Companions")

local COMPANIONS_INFO = require(SHARED_ASSETS_FOLDER:WaitForChild("Companions").Companions)

local DataManager = require(script.Parent.DataManager)


--[[

	We must handle companion 'Spins'
	We must handle whether or not a player has a specific companion
	We must handle when a player calls to Summon
	We must handle whether or not player already has a companion summoned
	We must save whether or not the player had a Companion Active
	We must handle when a player dies or leaves or joins
	W

]]

local Items = {}

for i,v in pairs(COMPANIONS_INFO) do
	table.insert(Items, {v.Name, v.Chance})
end

local multiplier = 1

for _, item in pairs(Items) do --Essentially edits the multiplier so that even the smallest decimal will become whole
	local function zeros(amount)
		local total = "1"
		for i = 1, amount do
			total = total.. "0"
		end
		return total
	end
	local split = string.split(tostring(item[2]), ".")
	if split[2] ~= nil then
		if tonumber(zeros(string.len(split[2]))) > multiplier then
			multiplier = tonumber(zeros(string.len(split[2])))
		end
	end
end

for _, item in pairs(Items) do
	item[2] = item[2] * multiplier
end

local TotalWeight = 0

for _,ItemData in pairs(Items) do
	TotalWeight = TotalWeight + ItemData[2]
end

local function chooseRandomItem()
	local Chance = math.random(1,TotalWeight)
	local Counter = 0
	for _,ItemData in pairs(Items) do
		Counter = Counter + ItemData[2]
		if Chance <= Counter then
			return ItemData[1]
		end
	end
end

function CompanionService.Initialize(player)
	if maids[player.UserId] then
		warn('Reinitializing CompanionService for player: '..player.UserId)
		maids[player.UserId] = {
			CompanionFolder = nil,
			Companion = nil
		}
	end
	
	local CFolderMaid = Maid.new()
	local CompanionMaid = Maid.new()
	
	maids[player.UserId] = {
		CompanionFolderMaid = CFolderMaid,
		CompanionMaid = CompanionMaid
	}
	
	debounceTimes[player.UserId] = {Conjure = tick(), Spin = tick()}
	
	local PlayerCompanionFolder = Instance.new('Folder')
	PlayerCompanionFolder.Name = player.UserId
	PlayerCompanionFolder.Parent = Live.Companions
	
	maids[player.UserId].CompanionFolderMaid:GiveTask(PlayerCompanionFolder)
	
end

function CompanionService:Spin(player)
	local _profile = DataManager:GetPlayerProfile(player)
	local PlayerProfile = _profile.Profile
	local PlayerDataReplica = _profile.Replica
		
	if player and tick() - debounceTimes[player.UserId].Spin > .05 then
		if PlayerProfile.Data.CURRENCY.TSUNOVIUM < 1 then
			debounceTimes[player.UserId].Spin = tick()
			return
		else
			PlayerProfile.Data.CURRENCY.TSUNOVIUM -= 1
			PlayerDataReplica:SetValue({'CURRENCY', 'TSUNOVIUM'}, PlayerProfile.Data.CURRENCY.TSUNOVIUM)

			Resonate:PlaySound('', player)	
			debounceTimes[player.UserId].Spin = tick()
			
			local COMPANION_TO_GET = chooseRandomItem()
			if not table.find(PlayerProfile.Data.INVENTORY.COMPANIONS, COMPANION_TO_GET) then
				table.insert(PlayerProfile.Data.INVENTORY.COMPANIONS, COMPANION_TO_GET)
				PlayerDataReplica:SetValue({'INVENTORY', 'COMPANIONS'}, PlayerProfile.Data.INVENTORY.COMPANIONS)
				packets.SpinResult.sendTo({
					Companion = COMPANION_TO_GET,
					Duplicate = 0
				}, player)
				
			else
				packets.SpinResult.sendTo({
					Companion = COMPANION_TO_GET,
					Duplicate = 25
				}, player)
				
				PlayerProfile.Data.CURRENCY.MONEY += 25
				PlayerDataReplica:SetValue({'CURRENCY', 'MONEY'}, PlayerProfile.Data.CURRENCY.MONEY)
			end
			
			
			
			
			
		end
	else
		Resonate:PlaySound('error', player)		
	end
end

function CompanionService:Conjure(player, Task, Companion)	
	if player and tick() - debounceTimes[player.UserId].Conjure > 2  then
		local Character = player.Character or player.CharacterAdded:Wait()
		
		local _profile = DataManager:GetPlayerProfile(player)
		local PlayerProfile = _profile.Profile
		local PlayerDataReplica = _profile.Replica

		if table.find(PlayerProfile.Data.INVENTORY.COMPANIONS, Companion) or (Task == "Dismiss" and Companion == '') then

			if Live.Companions:FindFirstChild(player.UserId, true) then
				if Task == "Summon" then
					if COMPANIONS_INFO[Companion].Sounds then
						Resonate:PlaySound(COMPANIONS_INFO[Companion].Sounds.SummonSound, player)
					end
					maids[player.UserId].CompanionMaid:DoCleaning()

					if COMPANIONS_FOLDER:FindFirstChild(Companion, true) then
						local CompanionModel = COMPANIONS_FOLDER[Companion]:Clone()
						CompanionModel.Parent = Live.Companions[player.UserId]
						CompanionModel:PivotTo(player.Character.HumanoidRootPart.CFrame)

						maids[player.UserId].CompanionMaid:GiveTask(CompanionModel)
						pcall(function()
							while CompanionModel.Humanoid and player.Character do
								task.wait()

								if not CompanionModel:FindFirstChild('Humanoid', true) then
									break
								else
									CompanionModel.Humanoid:MoveTo(Character.HumanoidRootPart.Position + Vector3.new(0, 0, -5))
									if (Character.HumanoidRootPart.Position - CompanionModel.HumanoidRootPart.Position).Magnitude > 25 then
										CompanionModel:SetPrimaryPartCFrame(CFrame.new(Character.HumanoidRootPart.Position))
									end
								end
							end
						end)
						
					debounceTimes[player.UserId].Conjure = tick()

					end

				elseif Task == "Dismiss" then
					maids[player.UserId].CompanionMaid:DoCleaning()


				else
					return
				end	
			end
			
		end
		
	else
		Resonate:PlaySound('error', player)
	end
	
end

packets.Conjure.listen(function(data, player)
	if player and player.Character then
		local Task = data.Task
		local Companion = data.Companion
		
		CompanionService:Conjure(player, Task, Companion)
	else
		return
	end
end)

packets.Spin.listen(function(data, player)
	if player and player.Character then
		CompanionService:Spin(player)
	end
end)

function CompanionService.playerLeft(player)
	if maids[player.UserId] then
		for i,v in maids[player.UserId] do
			print(v)
			v = nil
		end
	maids[player.UserId] = nil
	end
end


--	GLOBAL
--	GLOBAL BEWARE

Players.PlayerAdded:Connect(CompanionService.Initialize)
Players.PlayerRemoving:Connect(CompanionService.playerLeft)

for _, player in ipairs(Players:GetPlayers()) do
	task.spawn(CompanionService.Initialize, player)
end

function CompanionService:Cleanup()
	for _, maid in pairs(maids) do
		maid:DoCleaning()
	end
	maids = {} -- Clear the maids table after cleaning
end

local CollectionService = game:GetService("CollectionService")

local COMPANION_COLLISION_GROUP = "Companions"
local PLAYER_COLLISION_GROUP = "Players"
local DOOR_COLLISION_GROUP = "Doors"

function CompanionService:PhysicsService()
	
	PhysicsService:RegisterCollisionGroup(DOOR_COLLISION_GROUP)

	if not pcall(function() PhysicsService:RegisterCollisionGroup(COMPANION_COLLISION_GROUP) end) then
		-- Collision group already exists, ensure properties are correct
		PhysicsService:CollisionGroupSetCollidable(COMPANION_COLLISION_GROUP, COMPANION_COLLISION_GROUP, false)
		PhysicsService:CollisionGroupSetCollidable(COMPANION_COLLISION_GROUP, PLAYER_COLLISION_GROUP, false)
		
		
		PhysicsService:CollisionGroupSetCollidable(COMPANION_COLLISION_GROUP, DOOR_COLLISION_GROUP, false)

	else
		PhysicsService:CollisionGroupSetCollidable(COMPANION_COLLISION_GROUP, COMPANION_COLLISION_GROUP, false)
		PhysicsService:CollisionGroupSetCollidable(COMPANION_COLLISION_GROUP, PLAYER_COLLISION_GROUP, false)
		
		PhysicsService:CollisionGroupSetCollidable(COMPANION_COLLISION_GROUP, DOOR_COLLISION_GROUP, false)

	end
	
	for i,v in COMPANIONS_FOLDER:GetDescendants() do
		if v:IsA("BasePart") then
			v.CollisionGroup = COMPANION_COLLISION_GROUP
		end
	end

	for _, part in pairs(CollectionService:GetTagged("Door")) do
		part.CollisionGroup = DOOR_COLLISION_GROUP
		part.Parent.ImageSurface.CollisionGroup = DOOR_COLLISION_GROUP
	end
	
end

CompanionService:PhysicsService()

return CompanionService










--[[

-		Excavious' CompanionsHandler, 2022
-		Handles Companion Events
]]
--		Services


--[[
local RS =			game:GetService("ReplicatedStorage")
local SS =			game:GetService("ServerScriptService")
local TS = 			game:GetService("TextService")
local ChatService = require(SS:WaitForChild("ChatServiceRunner").ChatService)

local ServerStorage = 		game:GetService("ServerStorage")
local PS = 			game:GetService("PhysicsService")
local MS = 			game:GetService("MarketplaceService")
local Load = 			require(RS:WaitForChild("Nevermore").Nevermore)
--		Modules
local DataStore2 = 		Load("DataStore2")
local Network = 					Load("Network")
local Maid	=						Load("Maid")
local SoundRemote = 			RS:WaitForChild("EventsPlus").SoundRemote
--		Data
local Tables =					SS:WaitForChild("Tables")
local Companions = 			require(Tables.CompanionsTable)
local DataTable = 				require(Tables.DataTable)
local PlayerTable = 			require(Tables.PlayerTables)

local Assets = 						ServerStorage:WaitForChild("Assets")
local Animations = 					Assets.Animations
local CompanionAnimations = 	Animations:WaitForChild("CompanionAnimations")
--		Tables
local Debounces = 				PlayerTable["Debounces"] -- Debounces[userid].X = bool or tick() whereas X equals a debounce(Summon)
local IsCompanionActive =	PlayerTable["IsCompanionActive"]
--		cooldowns
local summonCooldown = 2.5
local spinCooldown = 2.5
--		server
local Contents = SS:WaitForChild("Contents")
local SpinRobuxEvent = Contents:WaitForChild("SpinRobux")
--
local types = {"S", "A", "B", "C"}
local CompanionRarity = {
	["S"] = {Color = Color3.fromRGB(85,85,255), Priority = 1},
	["A"] = {Color = Color3.fromRGB(0, 255, 127), Priority = 2},
	["B"] = {Color = Color3.fromRGB(170, 170, 127), Priority = 3},
	["C"] = {Color = Color3.fromRGB(226, 226, 226), Priority = 4,},
}
--
local maid = Maid.new()
--		Functions
local function parentCompanion(client, _companionToSummon)
	local _Character = client.Character or client.CharacterAdded:Wait()

	if IsCompanionActive[client.UserId] == false then
		IsCompanionActive[client.UserId] = true
		Network:FireClient(client, "CompanionUI", "Icon", "Icon")

		local Folder = Instance.new("Folder")
		Folder.Name = client.UserId.."s Companion"

		local Clone = ServerStorage:FindFirstChild(tostring(_companionToSummon), true):Clone()
		Clone:SetPrimaryPartCFrame(_Character.HumanoidRootPart.CFrame*CFrame.new(0,0,-5))
		Clone.Parent = Folder

		local CloneAnimation = function()
			if CompanionAnimations:FindFirstChild(_companionToSummon, true) ~= nil then
				return CompanionAnimations[_companionToSummon]
			else
				return CompanionAnimations.Default
			end
		end

		local AnimationClone = CloneAnimation():Clone()
		AnimationClone.Parent = Clone
		Folder.Parent = workspace

		maid[client.UserId.."Companion"]= Folder
		maid[client.UserId.."Movement"]= (pcall(function()
			while Folder do
				task.wait()
				Clone.Humanoid:MoveTo(_Character.HumanoidRootPart.Position + Vector3.new(0,0,-5))
				if (_Character.HumanoidRootPart.Position - Clone.HumanoidRootPart.Position).Magnitude > 25 then
					Clone:SetPrimaryPartCFrame(CFrame.new(_Character.HumanoidRootPart.Position));
				end
			end
		end))

	elseif IsCompanionActive[client.UserId] == true then
		maid[client.UserId.."Companion"] = nil
		maid[client.UserId.."Movement"] = nil
		Network:FireClient(client, "CompanionUI", "Icon", "Icon")

		local Folder = Instance.new("Folder")
		Folder.Name = client.UserId.."s Companion"

		local Clone = ServerStorage:FindFirstChild(tostring(_companionToSummon), true):Clone()
		Clone:SetPrimaryPartCFrame(_Character.HumanoidRootPart.CFrame*CFrame.new(0,0,-5))
		Clone.Parent = Folder

		local CloneAnimation = function()
			if CompanionAnimations:FindFirstChild(_companionToSummon, true) ~= nil then
				return CompanionAnimations[_companionToSummon]
			else
				return CompanionAnimations.Default
			end
		end

		local AnimationClone = CloneAnimation():Clone()
		AnimationClone.Parent = Clone

		Folder.Parent = workspace
		maid[client.UserId.."Companion"] = Folder
		maid[client.UserId.."Movement"] = (pcall(function()
			while Folder do
				task.wait()
				Clone.Humanoid:MoveTo(_Character.HumanoidRootPart.Position + Vector3.new(0,0,-5))
				if (_Character.HumanoidRootPart.Position - Clone.HumanoidRootPart.Position).Magnitude > 25 then
					Clone:SetPrimaryPartCFrame(CFrame.new(_Character.HumanoidRootPart.Position));
				end
			end
		end))

	end

end
--
local Items = {}
local function SendSystemMessageToAllSpeakers(msg, channel)
	for i,v in pairs(game.Players:GetChildren()) do
		ChatService:GetSpeaker(v.Name):SendSystemMessage(msg, channel)
	end

end
for i,v in pairs(Companions) do
	table.insert(Items, {v.Name, v.Chance})
end

local multiplier = 1

for _, item in pairs(Items) do --Essentially edits the multiplier so that even the smallest decimal will become whole
	local function zeros(amount)
		local total = "1"
		for i = 1, amount do
			total = total.. "0"
		end
		return total
	end
	local split = string.split(tostring(item[2]), ".")
	if split[2] ~= nil then
		if tonumber(zeros(string.len(split[2]))) > multiplier then
			multiplier = tonumber(zeros(string.len(split[2])))
		end
	end
end

for _, item in pairs(Items) do
	item[2] = item[2] * multiplier
end

local TotalWeight = 0

for _,ItemData in pairs(Items) do
	TotalWeight = TotalWeight + ItemData[2]
end

local function chooseRandomItem()
	local Chance = math.random(1,TotalWeight)
	local Counter = 0
	for _,ItemData in pairs(Items) do
		Counter = Counter + ItemData[2]
		if Chance <= Counter then
			return ItemData[1]
		end
	end
end
--
local function makeAnnouncement(companionTXT,plrWhom)
	--local filteredTextResult = TS:FilterStringAsync(companionTXT,plrWhom.UserId)
	SendSystemMessageToAllSpeakers("[COMPANIONS] "..plrWhom.Name.." got "..companionTXT, "All")
end
--		Network
Network:BindEvents({
	CompanionSummon = function(client, companionToSummon) -- find if the player already has a companion active
		local OwnedCompanions = DataStore2("Companions", client)
		if tick() - Debounces[client.UserId].Summon >= summonCooldown then
			Debounces[client.UserId].Summon = tick()
			if table.find(OwnedCompanions:Get(), companionToSummon) then
				SoundRemote:FireClient(client, "Notification")
				parentCompanion(client, companionToSummon)
			else
				SoundRemote:FireClient(client, "Error")
			end
		end
	end,
	Spin = function(client) -- Fragile
		local plrCompanion = 				chooseRandomItem()
		local OwnedCompanions =			DataStore2("Companions", client)
		local OwnedCompanionsTable = DataTable.Companions[client.UserId]
		local SpinsStore = 					DataStore2("Spins", client)
		local MoneyStore = 				DataStore2("Money", client)

		local function FillTable()
			for i,v in pairs(OwnedCompanions:Get()) do
				if not table.find(OwnedCompanionsTable, v) then
					table.insert(OwnedCompanionsTable, v)
				end
			end
		end
		FillTable()

		if tick() - Debounces[client.UserId].Spin >= spinCooldown and SpinsStore:Get() >= 1 then
			makeAnnouncement(plrCompanion,client)

			Debounces[client.UserId].Spin = tick()
			SpinsStore:Increment(-1)
			if table.find(OwnedCompanions:Get(), tostring(plrCompanion)) then
				MoneyStore:Increment(25)
				SoundRemote:FireClient(client, "Notification")
				Network:FireClient(client, "CompanionUI", plrCompanion, "CompanionReceived", true)
			else
				unpack(OwnedCompanionsTable)
				table.insert(OwnedCompanionsTable, 1, plrCompanion)
				OwnedCompanions:Set(OwnedCompanionsTable)
				SoundRemote:FireClient(client, "Coin")
				Network:FireClient(client, "CompanionUI", plrCompanion, "CompanionReceived", false)
			end
		elseif tick() - Debounces[client.UserId].Spin >= spinCooldown and MoneyStore:Get() >= 35 and SpinsStore:Get() < 1 then
			makeAnnouncement(plrCompanion,client)

			Debounces[client.UserId].Spin = tick()
			MoneyStore:Increment(-35)
			if table.find(OwnedCompanions:Get(), tostring(plrCompanion)) then
				MoneyStore:Increment(25)
				SoundRemote:FireClient(client, "Notification")
				Network:FireClient(client, "CompanionUI", plrCompanion, "CompanionReceived", true)
			else
				unpack(OwnedCompanionsTable)
				table.insert(OwnedCompanionsTable, 1, plrCompanion)
				OwnedCompanions:Set(OwnedCompanionsTable)
				SoundRemote:FireClient(client, "Coin")
				Network:FireClient(client, "CompanionUI", plrCompanion, "CompanionReceived", false)
			end
		elseif tick() - Debounces[client.UserId].Spin >= spinCooldown and SpinsStore:Get() < 1 and MoneyStore:Get() < 35 then

			Debounces[client.UserId].Spin = tick()
			MS:PromptProductPurchase(client, 1234561838)
		elseif tick() - Debounces[client.UserId].Spin < spinCooldown then
			SoundRemote:FireClient(client, "Error")
		end

	end,

})

SpinRobuxEvent.Event:Connect(function(client)

	local OwnedCompanions =			DataStore2("Companions", client)
	local OwnedCompanionsTable = DataTable.Companions[client.UserId]
	local SpinsStore = 					DataStore2("Spins", client)
	local MoneyStore = 				DataStore2("Money", client)
	local plrCompanion = 				chooseRandomItem()
	makeAnnouncement(plrCompanion,client)

	if table.find(OwnedCompanions:Get(), tostring(plrCompanion)) then
		MoneyStore:Increment(25)
		SoundRemote:FireClient(client, "Notification")
		Network:FireClient(client, "CompanionUI", plrCompanion, "CompanionReceived", true)
	else
		unpack(OwnedCompanionsTable)
		table.insert(OwnedCompanionsTable, 1, plrCompanion)
		OwnedCompanions:Set(OwnedCompanionsTable)
		Network:FireClient(client, "CompanionUI", plrCompanion, "CompanionReceived", false)
	end

end)

--		Remove Player's Companion & Adds all Companions to UI

local timeOut = tick()
Load("PlayerConnect")(
	function(JoiningPlayer) -- Add Companions to UI
		repeat task.wait() until JoiningPlayer.Character or JoiningPlayer.CharacterAdded:Wait() or tick() - timeOut >= 30
		IsCompanionActive[JoiningPlayer.UserId] = false

		for i,v in pairs(Companions) do
			Network:FireClient(JoiningPlayer, "LoadCompanions", v.Name, v.Image, CompanionRarity[v.Tier].Color, CompanionRarity[v.Tier].Priority)
		end
	end,
	function(LeavingPlayer) -- Remove Player Companions (if summoned)
		if IsCompanionActive[LeavingPlayer.UserId] then
			maid[LeavingPlayer.UserId.."CompanionMovement "] = nil
			maid[LeavingPlayer.UserId.."Companion"] = nil
		end

	end)

]]