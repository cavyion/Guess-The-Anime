local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = game.Players.LocalPlayer
local Orbit = require(ReplicatedStorage.Packages["@kabuyon"].Orbit)

local React = Orbit('React')
local ReactRoblox = Orbit('ReactRoblox')
local ReplicaController = Orbit('ReplicaController')
local Icon = Orbit("Icon")

local MusicUI = {}
local COMPONENTS_FOLDER = script:WaitForChild("Components")

local DJ = require(COMPONENTS_FOLDER:WaitForChild("DJ"))
local HOLDER = require(COMPONENTS_FOLDER:WaitForChild("HOLDER"))
local TOPBAR = require(COMPONENTS_FOLDER:WaitForChild("TOPBAR"))
	
local MUSIC_CONTAINERS = {}

local function App()
	return React.createElement("Frame", {
		key = "Container",
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
	}, {
		React.createElement(DJ, {
			key = "DJ",
		}),
		React.createElement(HOLDER, {
			key = "HOLDER",
		}),
		React.createElement(TOPBAR, {
			key = "TOPBAR",
		}),
	})
		
end

-- Initialize the main UI
function MusicUI.Initialize()
	local MusicIcon = Icon.getIcon('Music')

	local handle = Instance.new("ScreenGui")
	handle.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
	handle.IgnoreGuiInset = true
	handle.Name = "MUSIC"
	handle.Enabled = false
	
	local root = ReactRoblox.createRoot(handle)
	root:render(React.createElement(App))	

	MusicIcon:bindToggleItem(handle)
end


return MusicUI