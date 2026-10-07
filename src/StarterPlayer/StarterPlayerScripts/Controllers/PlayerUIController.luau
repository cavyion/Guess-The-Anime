local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")
local GuiService = game:GetService('GuiService')

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Orbit = require(ReplicatedStorage.Packages["@kabuyon"].Orbit)
local Assets = ReplicatedStorage:WaitForChild("Assets")
local UI = Assets:WaitForChild("UI")

local Icon = Orbit("Icon")
local React = Orbit('React')
local ReactRoblox = Orbit("ReactRoblox")
local ReplicaHandler = require(script.Parent:WaitForChild("ReplicaHandler"))

local PlayerUIController = {}

local function detectDeviceType()
	
	if UserInputService.MouseEnabled or UserInputService.KeyboardEnabled then
		return "Desktop"
	elseif UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
		local screenSize = workspace.CurrentCamera.ViewportSize
		if screenSize.Y > 960 then
			return "Tablet"
		else
			return "Phone"
		end
	elseif UserInputService.GamepadEnabled or GuiService:IsTenFootInterface() then
		return "Console"
	else
		return "Unknown"
	end
end

local deviceType = detectDeviceType()

function PlayerUIController.Initialize()
	Icon.new()
		:setLabel("🛒")
		:setName('Shop')
		:setCaption('Shop')
	Icon.new()
		:setLabel("✨")
		:setName('Companions')
		:setCaption('Companions')
	Icon.new()
		:setLabel("⚙️")
		:setName('Settings')
		:setCaption('Settings')
		:setEnabled(false)
	Icon.new()
		:setLabel("🎵")
		:setName('Music')
		:setCaption('Music')
		:setEnabled(false)
	Icon.new()
		:setLabel("📷")
		:setName('Hide UI')
		:setCaption('Hide UI')
end

function PlayerUIController.LoadRoact()
		
	if deviceType == "Phone" then
		require(script.MainUI).Initialize(.750)
	elseif deviceType == "Desktop" then
		require(script.MainUI).Initialize(0.9618)
	elseif deviceType == "Tablet" then
		require(script.MainUI).Initialize(0.9618)
	elseif deviceType == "Console" then
		require(script.MainUI).Initialize(1)
	elseif deviceType == "Unknown" then
		require(script.MainUI).Initialize(1)
	end
	
	require(script.ShopUI).Initialize()
	require(script.CompanionsUI).Initialize()
	require(script.MusicUI).Initialize()	
	require(script.SettingsUI).Initialize()
end

PlayerUIController.Initialize()

return PlayerUIController