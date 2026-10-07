local Players = game:GetService("Players")
local Player = game.Players.LocalPlayer

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Orbit = require(ReplicatedStorage.Packages["@kabuyon"].Orbit)

local React = Orbit('React')
local ReactRoblox = Orbit('ReactRoblox')

local MUSIC_INSTANCE = Player:WaitForChild('ClientAudio'):WaitForChild('Music')
	
local function MUSIC(props)
	
	local songName, setSongName = React.useState(props.SONG_NAME_TEXT or 'N/A')
	local artistName, setArtistName = React.useState(props.ARTIST_NAME_TEXT or 'N/A')
	
	React.useEffect(function(x)
		setSongName(props.SONG_NAME_TEXT)		
		setArtistName(props.ARTIST_NAME_TEXT)

	end, {props.SONG_NAME_TEXT})
	
	return React.createElement("Frame", {
		BackgroundColor3 = Color3.fromRGB(33, 33, 33),
		BackgroundTransparency = 1,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0, 0.955),
		Size = UDim2.fromScale(1, 0.031),
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Bottom,
		}),

		Description = React.createElement("TextLabel", {
			FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
			Text = `{tostring(artistName)} - {tostring(songName)}`,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextScaled = true,
			TextSize = 14,
			TextWrapped = true,
			BackgroundColor3 = Color3.fromRGB(34, 34, 34),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 1,
			Position = UDim2.fromScale(1.2, -1.32),
			Size = UDim2.fromScale(1, 0.5),
		}),

		Title = React.createElement("TextLabel", {
			FontFace = Font.new(
				"rbxasset://fonts/families/GothamSSm.json",
				Enum.FontWeight.Bold,
				Enum.FontStyle.Normal
			),
			Text = "Music",
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextScaled = true,
			TextSize = 14,
			TextWrapped = true,
			BackgroundColor3 = Color3.fromRGB(34, 34, 34),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.0035, -0.404),
			Size = UDim2.fromScale(1, 0.5),
			LayoutOrder = 1,
		}),
	})
end

return MUSIC