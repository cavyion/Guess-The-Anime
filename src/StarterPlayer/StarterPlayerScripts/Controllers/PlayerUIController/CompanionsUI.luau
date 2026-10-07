local ReplicatedStorage = game:GetService('ReplicatedStorage')
local Players = game:GetService('Players')
local player = game.Players.LocalPlayer
local Orbit = require(ReplicatedStorage.Packages['@kabuyon'].Orbit)

local React = Orbit('React')
local ReactRoblox = Orbit('ReactRoblox')
local ReplicaController = Orbit('ReplicaController')
local Icon = Orbit('Icon')

local CompanionsUI = {}
local COMPONENTS_FOLDER = script:WaitForChild("Components")

local UNSUMMON = require(COMPONENTS_FOLDER.UNSUMMON)
local COMPANIONSICON = require(COMPONENTS_FOLDER.COMPANIONSICON)
local HOLDER = require(COMPONENTS_FOLDER.HOLDER)
local MONEY = require(COMPONENTS_FOLDER.MONEY)
local SPINHOLDER = require(COMPONENTS_FOLDER.SPINHOLDER)
local TOPBAR = require(COMPONENTS_FOLDER.TOPBAR)
local TSUNOVIUM = require(COMPONENTS_FOLDER.TSUNOVIUM)

local function App()
	local ReplicaHandler = require(script.Parent.Parent:WaitForChild("ReplicaHandler"))
	
	local money, setMoney = React.useState('UNKNOWN')
	local tsunovium, setTsunovium = React.useState('UNKNOWN')

	React.useEffect(function()
		local PlayerProfileReplica = ReplicaHandler:GetReplica('PlayerProfileReplica')

		setMoney(PlayerProfileReplica.Data.CURRENCY.MONEY)
		setTsunovium(PlayerProfileReplica.Data.CURRENCY.TSUNOVIUM)
		
		PlayerProfileReplica:ListenToChange({'CURRENCY', 'MONEY'}, function(NewValue)
			setMoney(NewValue)
		end)
		
		PlayerProfileReplica:ListenToChange({'CURRENCY', 'TSUNOVIUM'}, function(NewValue)
			setTsunovium(NewValue)
		end)
		
	end, {})

	return React.createElement("Frame", {
		key = "Container",
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
	}, {
		React.createElement(COMPANIONSICON, {
			key = "SETTINGSICON",
		}),
		React.createElement(HOLDER, {
			key = "HOLDER",
		}),
		React.createElement(TOPBAR, {
			key = "TOPBAR",
		}),
		React.createElement(UNSUMMON, {
			key = "UNSUMMON",
		}),
		React.createElement(TSUNOVIUM, {
			key = "TSUNOVIUM",
			TSUNOVIUM_TEXT = tsunovium
		}),
		React.createElement(MONEY, {
			key = "MONEY",
			MONEY_TEXT = money
		}),
		React.createElement(SPINHOLDER, {
			key = "SPINHOLDER",
		}),
	})

end

function CompanionsUI.Initialize()
	local CompanionsIcon = Icon.getIcon('Companions')

	local handle = Instance.new("ScreenGui")
	handle.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
	handle.IgnoreGuiInset = true
	handle.Name = "COMPANIONS"
	handle.Enabled = false	

	local root = ReactRoblox.createRoot(handle)
	root:render(React.createElement(App))	

	CompanionsIcon:bindToggleItem(handle)
end

return CompanionsUI