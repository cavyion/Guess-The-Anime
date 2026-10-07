--local ReplicatedStorage = game:GetService("ReplicatedStorage")
--local Players = game:GetService("Players")
--local LocalPlayer = Players.LocalPlayer
--local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
--local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
--local maxDistance = 20

--local Orbit = require(game:GetService("ReplicatedStorage").Packages["@kabuyon"].Orbit) 
--local Maid = Orbit("Maid")

--local maid = Maid.new()
--local packets = require(ReplicatedStorage.packets)
--local PlayerUIController = require(script.Parent:WaitForChild("PlayerUIController"))

local button = script.Parent

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local packets = require((ReplicatedStorage.packets))

button.MouseButton1Click:Connect(function()
	packets.Spin.send({})
end)
