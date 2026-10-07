
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local maxDistance = 20

local Orbit = require(game:GetService("ReplicatedStorage").Packages["@kabuyon"].Orbit) 
local Maid = Orbit("Maid")
local maid = Maid.new()
local packets = require(ReplicatedStorage.packets)
local PlayerUIController = require(script.Parent:WaitForChild("PlayerUIController"))

local PlayerCharacterController = {}

function PlayerCharacterController.Initialize()
	maid:GiveTask(game:GetService("RunService").RenderStepped:Connect(PlayerCharacterController.UpdatePlayerTransparency))
end

function PlayerCharacterController.UpdatePlayerTransparency()
	local players = Players:GetPlayers()

	for _, player in ipairs(players) do
		if player ~= LocalPlayer then
			local character = player.Character
			if character then
				local rootPart = character:FindFirstChild("HumanoidRootPart")
				if rootPart then
					local distance = (HumanoidRootPart.Position - rootPart.Position).magnitude
					local transparency = math.clamp((maxDistance - distance) / maxDistance, 0, 1)

					for _, part in ipairs(character:GetDescendants()) do
						if part:IsA("BasePart") then
							part.LocalTransparencyModifier = transparency
						end
					end
				end
			end
		end
	end
end

local function onCharacterAdded(character)
	local player = game:GetService("Players").LocalPlayer -- This is how you could get the player here
	PlayerUIController.LoadRoact()

	local humanoid = character:WaitForChild("Humanoid", 5)
	if not humanoid then
		return
	end

	humanoid.Died:Connect(function()
		packets.PlayerReady.send({
			IsReady = true
		})
	end)
end

game:GetService("Players").LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
do
	local alreadyExistingCharacter = game:GetService("Players").LocalPlayer.Character
	if alreadyExistingCharacter then
		onCharacterAdded(alreadyExistingCharacter)
	end
end

function PlayerCharacterController.Cleanup()
	maid:DoCleaning()
	maid:Destroy()
end

PlayerCharacterController.Initialize()

return PlayerCharacterController