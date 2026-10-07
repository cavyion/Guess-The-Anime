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
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(33, 33, 33),
		BackgroundTransparency = 1,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.5, 0.924),
		Size = UDim2.fromOffset(613, 31),
	}, {
		TITLE = React.createElement("TextLabel", {
			FontFace = Font.new(
				"rbxassetid://11702779517",
				Enum.FontWeight.Bold,
				Enum.FontStyle.Normal
			),
			Text = "Music",
			TextColor3 = Color3.fromRGB(233, 233, 233),
			TextScaled = true,
			TextSize = 14,
			TextWrapped = true,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0, -0.000689),
			Size = UDim2.fromScale(1, 0.601),
		}),

		DESCRIPTION = React.createElement("TextLabel", {
			FontFace = Font.new("rbxassetid://11702779517"),
			Text = `{tostring(artistName)} - {tostring(songName)}`,
			TextColor3 = Color3.fromRGB(233, 233, 233),
			TextScaled = true,
			TextSize = 14,
			TextWrapped = true,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(-0.00163, 0.181),
			Size = UDim2.fromScale(1, 0.4),
			LayoutOrder = 1
		}),

		UIListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),
	})
end

return MUSIC