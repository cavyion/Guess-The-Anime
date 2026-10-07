local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Orbit = require(ReplicatedStorage.Packages["@kabuyon"].Orbit)

local React = Orbit('React')
local ReactRoblox = Orbit('ReactRoblox')
local ReplicaController = Orbit('ReplicaController')
local Icon = Orbit("Icon")

local ShopUI = {}
local COMPONENTS_FOLDER = script:WaitForChild("Components")

local TOPBAR = require(COMPONENTS_FOLDER.TOPBAR)
local SHOPKEEPER = require(COMPONENTS_FOLDER.SHOPKEEPER)
local MONEY = require(COMPONENTS_FOLDER.MONEY)
local TSUNOVIUM = require(COMPONENTS_FOLDER.TSUNOVIUM)
local HOLDER = require(COMPONENTS_FOLDER.HOLDER)

local function App()
	local ReplicaHandler = require(script.Parent.Parent:WaitForChild("ReplicaHandler"))
	
	local money, setMoney = React.useState('n/a')
	local tsunovium, setTsunovium = React.useState('n/a')
	
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
	
	
	return React.createElement('Frame', {
		key = "Container",
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
	}, {
		React.createElement(TOPBAR,{
			key = 'TOPBAR'
		}),
		React.createElement(SHOPKEEPER,{
			key = 'SHOPKEEPER'
		}),
		React.createElement(MONEY,{
			key = 'MONEY',
			MONEY = money
		}),
		React.createElement(TSUNOVIUM,{
			key = 'TSUNOVIUM',
			TSUNOVIUM = tsunovium
		}),
		React.createElement(HOLDER,{
			key = 'HOLDER'
		}),
	})
end

-- Initialize the main UI
function ShopUI.Initialize()
	local ShopIcon = Icon.getIcon('Shop')
	
	
	local handle = Instance.new("ScreenGui")
	handle.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
	handle.IgnoreGuiInset = true
	handle.Name = "SHOP"
	handle.Enabled = false
	local root = ReactRoblox.createRoot(handle)
	root:render(React.createElement(App))	
	
	ShopIcon:bindToggleItem(handle)
	
end


return ShopUI