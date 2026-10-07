
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local MarketplaceService = game:GetService("MarketplaceService")
local Orbit = require(ReplicatedStorage:WaitForChild("Packages")["@kabuyon"].Orbit)
local packets = require(ReplicatedStorage:WaitForChild("packets"))

local SERVICES_FOLDER = ServerScriptService:WaitForChild("Services")
local PLAYERINTERACTIONSERVICE = require(SERVICES_FOLDER:WaitForChild("PlayerInteractionService"))
local DataManager = require(SERVICES_FOLDER:WaitForChild('DataManager'))

local Tween = Orbit("Tween")

local HALLS_FOLDER = workspace:WaitForChild("Halls")
local HALLS_END = #HALLS_FOLDER:GetChildren()


local Maid = Orbit('Maid')
local maid = Maid.new()

local MarketMaster = {}
local MAP_FOLDER = workspace:WaitForChild('Map')

local function IS_QUALIFIED_FOR_X2(player)
	if player:IsInGroup(5817780) or player.MembershipType == Enum.MembershipType.Premium then
		return true
	else
		return false
	end
end

local ProductFunctions = {
	[1238603730] = function(player)
		local _profile = DataManager:GetPlayerProfile(player)
		local PlayerProfile = _profile.Profile
		local PlayerDataReplica = _profile.Replica
		
        local leaderstats = player:WaitForChild('leaderstats')
        local CURRENT_STAGE = leaderstats:WaitForChild('Stage')

        local INSTANT_TELEPORT = true

        local NEXT_HALL = nil
        if HALLS_FOLDER and CURRENT_STAGE and CURRENT_STAGE.Value + 1 <= HALLS_END then
            NEXT_HALL = HALLS_FOLDER:FindFirstChild("Hall" .. tostring(CURRENT_STAGE.Value + 1))
        end

        if NEXT_HALL then
            local x, y, z = NEXT_HALL.HallMarker.Position.X, NEXT_HALL.HallMarker.Position.Y, NEXT_HALL.HallMarker.Position.Z
            if INSTANT_TELEPORT then
                packets.OpenDoor.sendTo({
                    activate = true,
                    plr = player.UserId
                }, player)
                Tween(player.Character.HumanoidRootPart, Vector3.new(x, y + 4, z), 1, Enum.EasingStyle.Sine, Enum.EasingDirection.In):Play()
            else
                player.Character.HumanoidRootPart.Position = Vector3.new(x, y + 4, z)
            end
		else
			local END_MARKER = workspace:WaitForChild('Map').END_MARKER
			local x, y, z = END_MARKER.Position.X, END_MARKER.Position.Y, END_MARKER.Position.Z
			
			player.Character.HumanoidRootPart.Position = Vector3.new(x, y+4, z)
			
			player.Character.HumanoidRootPart.Position = Vector3.new(x, y+4, z)
			if IS_QUALIFIED_FOR_X2(player) then
				PlayerProfile.Data.CURRENCY.TSUNOVIUM = PlayerProfile.Data.CURRENCY.TSUNOVIUM + 2
			else
				PlayerProfile.Data.CURRENCY.TSUNOVIUM = PlayerProfile.Data.CURRENCY.TSUNOVIUM + 1
			end			PlayerProfile.Data.STATS.FINISHES = PlayerProfile.Data.STATS.FINISHES + 1
			player.leaderstats.Finishes.Value = PlayerProfile.Data.STATS.FINISHES				
			
			PlayerDataReplica:SetValue({'CURRENCY', 'TSUNOVIUM'}, PlayerProfile.Data.CURRENCY.TSUNOVIUM)
			PlayerDataReplica:SetValue({'STATS', 'FINISHES'}, PlayerProfile.Data.STATS.FINISHES)
			
            warn("NEXT_HALL not found or CURRENT_STAGE.Value + 1 exceeds HALLS_END")
		end
		PlayerProfile.Data.STATS.ROBUX_SPENT = PlayerProfile.Data.STATS.ROBUX_SPENT + 5
		
	end,
	[1231380398] = function(player)
		-- 1 SKIP

		local _profile = DataManager:GetPlayerProfile(player)
		local PlayerProfile = _profile.Profile
		local PlayerDataReplica = _profile.Replica
				
		PlayerProfile.Data.CURRENCY.SKIPS = PlayerProfile.Data.CURRENCY.SKIPS + 1
		PlayerDataReplica:SetValue({'CURRENCY', 'SKIPS'}, PlayerProfile.Data.CURRENCY.SKIPS)
		PlayerProfile.Data.STATS.ROBUX_SPENT = PlayerProfile.Data.STATS.ROBUX_SPENT + 5

	end,
	[1231380951] = function(player)
		-- 5 SKIPS
		local _profile = DataManager:GetPlayerProfile(player)
		local PlayerProfile = _profile.Profile
		local PlayerDataReplica = _profile.Replica

		PlayerProfile.Data.CURRENCY.SKIPS = PlayerProfile.Data.CURRENCY.SKIPS + 5
		PlayerDataReplica:SetValue({'CURRENCY', 'SKIPS'}, PlayerProfile.Data.CURRENCY.SKIPS)
		PlayerProfile.Data.STATS.ROBUX_SPENT = PlayerProfile.Data.STATS.ROBUX_SPENT + 20
	end,
	[1231380975] = function(player)
		-- 10 SKIPS
		local _profile = DataManager:GetPlayerProfile(player)
		local PlayerProfile = _profile.Profile
		local PlayerDataReplica = _profile.Replica

		PlayerProfile.Data.CURRENCY.SKIPS = PlayerProfile.Data.CURRENCY.SKIPS + 10
		PlayerDataReplica:SetValue({'CURRENCY', 'SKIPS'}, PlayerProfile.Data.CURRENCY.SKIPS)
		PlayerProfile.Data.STATS.ROBUX_SPENT = PlayerProfile.Data.STATS.ROBUX_SPENT + 40
	end,
}

local HALLS_FOLDER = workspace:WaitForChild("Halls")

function MarketMaster.handlePurchase(receiptInfo)

	local player = Players:GetPlayerByUserId(receiptInfo.PlayerId)
	if not player then
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end

	local productId = receiptInfo.ProductId
	ProductFunctions[productId](player)
	
	return Enum.ProductPurchaseDecision.PurchaseGranted
end 

function MarketMaster.Cleanup()
	maid:DoCleaning()
end

MarketplaceService.ProcessReceipt = MarketMaster.handlePurchase

return MarketMaster