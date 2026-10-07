local ReplicatedStorage = game:GetService('ReplicatedStorage')
local Players = game:GetService('Players')
local player = game.Players.LocalPlayer
local Orbit = require(ReplicatedStorage.Packages['@kabuyon'].Orbit)

local React = Orbit('React')
local ReactRoblox = Orbit('ReactRoblox')
local ReplicaController = Orbit('ReplicaController')
local Icon = Orbit('Icon')

local SettingsUI = {}
local COMPONENTS_FOLDER = script:WaitForChild("Components")

local SETTINGSICON = require(COMPONENTS_FOLDER:WaitForChild('SETTINGSICON'))
local HOLDER = require(COMPONENTS_FOLDER:WaitForChild("HOLDER"))
local TOPBAR = require(COMPONENTS_FOLDER:WaitForChild('TOPBAR'))

local function App()
	return React.createElement("Frame", {
		key = "Container",
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
	}, {
		React.createElement(SETTINGSICON, {
			key = "SETTINGSICON",
		}),
		React.createElement(HOLDER, {
			key = "HOLDER",
		}),
		React.createElement(TOPBAR, {
			key = "TOPBAR",
		}),
	})

end

function SettingsUI.Initialize()
	local SettingsIcon = Icon.getIcon('Settings')
	
	local handle = Instance.new("ScreenGui")
	handle.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
	handle.IgnoreGuiInset = true
	handle.Name = "SETTINGS"
	handle.Enabled = false	
	
	local root = ReactRoblox.createRoot(handle)
	root:render(React.createElement(App))	

	SettingsIcon:bindToggleItem(handle)
	
end

return SettingsUI