--	MAIN UI
--	CREATED BY KABUYON
--	FOR GUESS THE ANIME
--
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local Orbit = require(ReplicatedStorage.Packages["@kabuyon"].Orbit)

local React = Orbit('React')
local ReactRoblox = Orbit('ReactRoblox')
local ReplicaController = Orbit('ReplicaController')
local Icon = Orbit("Icon")

local MainUI = {}

local AUDIO_TABLES = require(ReplicatedStorage:WaitForChild("Assets").Audio.Audio)
local MUSIC_INSTANCE = Players.LocalPlayer:WaitForChild('ClientAudio'):WaitForChild('Music')
local MUSIC_CONTROLLER = require(Players.LocalPlayer:WaitForChild("PlayerScripts").Controllers.MusicController) 

local COMPONENTS_FOLDER = script:WaitForChild("Components")

local CURRENCIES = require(COMPONENTS_FOLDER:WaitForChild("CURRENCIES"))
local INFO = require(COMPONENTS_FOLDER:WaitForChild("INFO"))
--local MUSIC =require(COMPONENTS_FOLDER:WaitForChild('MUSIC'))
local NOTIFICATIONS = require(COMPONENTS_FOLDER:WaitForChild('NOTIFICATIONS'))
local REFRESH = require(COMPONENTS_FOLDER:WaitForChild('REFRESH'))
local STAGE = require(COMPONENTS_FOLDER:WaitForChild('STAGE'))

local UI_SCALE = 1

local function App()

	local ReplicaHandler = require(script.Parent.Parent:WaitForChild("ReplicaHandler"))
	local servername, setServername = React.useState("Loading...")  -- Default message while fetching servername asynchronously
	local money, setMoney = React.useState('UNKNOWN')
	local freeSkip, setfreeSkipIn = React.useState(300)
	local skip, setSkips = React.useState('UNKNOWN')
	local tsunovium, setTsunovium = React.useState('UNKNOWN')
	local hourlyRefresh, setHourlyRefresh = React.useState(2*60*60)
	local songName, setSongName = React.useState('N/A')
	local artistName, setArtistName = React.useState('N/A')

	React.useEffect(function()
		local TrackInfo = MUSIC_CONTROLLER:GetTrackInfo()
		local PlayerProfileReplica = ReplicaHandler:GetReplica('PlayerProfileReplica')
		local ServerNameReplica = ReplicaHandler:GetReplica('ServerNameReplica')
		local FreeSkipReplica = ReplicaHandler:GetReplica("FreeSkipReplica")
		local HourlyRefreshReplica = ReplicaHandler:GetReplica("HourlyRefreshReplica")

		setServername(ServerNameReplica.Data.servername)
		setMoney(PlayerProfileReplica.Data.CURRENCY.MONEY)
		setSkips(PlayerProfileReplica.Data.CURRENCY.SKIPS)
		setTsunovium(PlayerProfileReplica.Data.CURRENCY.TSUNOVIUM)
		setSongName(TrackInfo.Name)
		setArtistName(TrackInfo.Artist)

		ServerNameReplica:ListenToChange({'servername'}, function(NewValue)
			setServername(NewValue)
		end)
		PlayerProfileReplica:ListenToChange({'CURRENCY', 'MONEY'}, function(NewValue)
			setMoney(NewValue)
		end)
		PlayerProfileReplica:ListenToChange({'CURRENCY', 'SKIPS'}, function(NewValue)
			setSkips(NewValue)
		end)
		PlayerProfileReplica:ListenToChange({'CURRENCY', 'TSUNOVIUM'}, function(NewValue)
			setTsunovium(NewValue)
		end)
		FreeSkipReplica:ListenToChange({'FreeSkipIn'}, function(NewValue)
			setfreeSkipIn(NewValue)
		end)
		HourlyRefreshReplica:ListenToChange({'RefreshIn'}, function(NewValue)
			setHourlyRefresh(NewValue)
		end)

		MUSIC_INSTANCE.Changed:Connect(function()
			setSongName(TrackInfo.Name)
			setArtistName(TrackInfo.Artist)
		end)

	end, {})

	
	return React.createElement("Frame", {
		key = "Container",
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5)
	}, {
		React.createElement(CURRENCIES, {
			key = 'CURRENCIES',
			TSUNOVIUM_TEXT = tsunovium,
			MONEY_TEXT = money,
			SKIP_TEXT = skip,
			FREE_SKIP_IN_TEXT = freeSkip
		}),
		React.createElement(NOTIFICATIONS, {
			key = "NOTIFICATIONS",
		}),
		React.createElement(STAGE, {
			key = "PLAYER_STAGE",
		}),
		React.createElement(REFRESH, {
			key = 'HOURLY_REFRESH',
			HOURLY_REFRESH_TEXT = hourlyRefresh
		}),
		--React.createElement(MUSIC, {
		--	key = 'MUSIC',
		--	ARTIST_NAME_TEXT = artistName,
		--	SONG_NAME_TEXT = songName
		--}),
		React.createElement(INFO, {
			key = 'INFO',
			SERVER_NAME_TEXT = servername
		}),
		UIScale = React.createElement("UIScale", {
			key = "UIScale",
			Scale = UI_SCALE
		})
	})
	
	
	
end

function MainUI.Initialize(scale)
	local HideUI_ICON = Icon.getIcon('Hide UI')

	local handle = Instance.new("ScreenGui")
	handle.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
	handle.IgnoreGuiInset = true
	handle.Name = "MAIN_UI"
	handle.ScreenInsets = Enum.ScreenInsets.None
	
	local root = ReactRoblox.createRoot(handle)
	root:render(React.createElement(App))
	HideUI_ICON:bindEvent("selected", function()
		handle.Enabled = false
	end):bindEvent('deselected', function()
		handle.Enabled = true
	end)
	
	UI_SCALE = scale or 1
end


return MainUI
