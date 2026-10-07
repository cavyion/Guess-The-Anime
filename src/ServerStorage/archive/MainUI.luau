local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Orbit = require(ReplicatedStorage.Packages["@kabuyon"].Orbit)

local React = Orbit('React')
local ReactRoblox = Orbit('ReactRoblox')
local ReplicaController = Orbit('ReplicaController')
local Icon = Orbit("Icon")

local MainUI = {}
local COMPONENTS_FOLDER = script:WaitForChild("Components")

local AUDIO_TABLES = require(ReplicatedStorage:WaitForChild("Assets").Audio.Audio)
local MUSIC_INSTANCE = Players.LocalPlayer:WaitForChild('ClientAudio'):WaitForChild('Music')
local MUSIC_CONTROLLER = require(Players.LocalPlayer:WaitForChild("PlayerScripts").Controllers.MusicController) 

-- Import the components that require servername
local GAME_VERSION = require(COMPONENTS_FOLDER:WaitForChild("GAME_VERSION"))
local MONEY = require(COMPONENTS_FOLDER:WaitForChild("MONEY"))
local NOTIFICATIONS = require(COMPONENTS_FOLDER:WaitForChild("NOTIFICATIONS"))
local PLAYER_STAGE = require(COMPONENTS_FOLDER:WaitForChild("PLAYER_STAGE"))
local SERVER_AGE = require(COMPONENTS_FOLDER:WaitForChild("SERVER_AGE"))
local USER_INFO = require(COMPONENTS_FOLDER:WaitForChild("USER_INFO"))
local SERVER_INFO = require(COMPONENTS_FOLDER:WaitForChild("SERVER_INFO"))
local TSUNOVIUM = require(COMPONENTS_FOLDER:WaitForChild('TSUNOVIUM'))
local SKIPS = require(COMPONENTS_FOLDER:WaitForChild("SKIPS"))
local HOURLY_REFRESH = require(COMPONENTS_FOLDER:WaitForChild("HOURLY_REFRESH"))
local MUSIC = require(COMPONENTS_FOLDER:WaitForChild('MUSIC'))
-- Define your main application component
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
	}, {
		React.createElement(GAME_VERSION, {
			key = "GAME_VERSION",
			-- No need to pass servername here
		}),
		React.createElement(MONEY, {
			key = "MONEY",
			moneyText = money
			-- No need to pass servername here
		}),
		React.createElement(NOTIFICATIONS, {
			key = "NOTIFICATIONS",
			-- No need to pass servername here
		}),
		React.createElement(PLAYER_STAGE, {
			key = "PLAYER_STAGE",
			-- No need to pass servername here
		}),
		React.createElement(SERVER_AGE, {
			key = "SERVER_AGE",
			-- No need to pass servername here
		}),
		React.createElement(USER_INFO, {
			key = "USER_INFO",
			-- No need to pass servername here
		}),
		React.createElement(SERVER_INFO, {
			key = "SERVER_INFO",
			servername = servername, -- Pass dynamically fetched servername here
		}),
		React.createElement(TSUNOVIUM,{
			key = 'TSUNOVIUM',
			tsunoviumText = tsunovium
		}),
		React.createElement(SKIPS,{
			key = 'SKIPS',
			freeSkipInText = freeSkip,
			skipText = skip
		}),
		React.createElement(HOURLY_REFRESH, {
			key = 'HOURLY_REFRESH',
			hourlyRefreshText = hourlyRefresh
		}),
		React.createElement(MUSIC, {
			key = 'MUSIC',
			SONG_NAME_TEXT = tostring(songName),
			ARTIST_NAME_TEXT = tostring(artistName)
		})
	})
end

-- Initialize the main UI
function MainUI.Initialize()
	local HideUI_ICON = Icon.getIcon('Hide UI')

	local handle = Instance.new("ScreenGui")
	handle.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
	handle.IgnoreGuiInset = true
	handle.Name = "MAIN_UI"
	
	local root = ReactRoblox.createRoot(handle)
	root:render(React.createElement(App))
	HideUI_ICON:bindEvent("selected", function()
		handle.Enabled = false
	end):bindEvent('deselected', function()
		handle.Enabled = true
	end)
	
end

return MainUI