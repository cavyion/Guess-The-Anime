local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Orbit = require(ReplicatedStorage.Packages["@kabuyon"].Orbit)

local React = Orbit('React')
local ReactRoblox = Orbit('ReactRoblox')

local TFMv2 = Orbit("TFMv2")

local function formatter(x)
	return tostring(TFMv2.FormatStr({
		hr = math.floor(x / 3600),
		min = math.floor((x % 3600) / 60),
		sec = x % 60,
	}, '%02h:%02m:%02S'))
end

local function REFRESH(props)
	local hourlyRefresh, setHourlyRefresh = React.useState(props.HOURLY_REFRESH_TEXT or 0)

	React.useEffect(function()
		setHourlyRefresh(formatter(props.HOURLY_REFRESH_TEXT) or 0)
	end, {props.HOURLY_REFRESH_TEXT})
	
	return React.createElement("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(33, 33, 33),
		BackgroundTransparency = 1,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.5, 0.1),
		Size = UDim2.fromOffset(554, 31),
	}, {
		DESCRIPTION = React.createElement("TextLabel", {
			FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
			Text = `⏱️ {hourlyRefresh}`,
			TextColor3 = Color3.fromRGB(233, 233, 233),
			TextScaled = true,
			TextSize = 14,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Right,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			LayoutOrder = 1,
			Position = UDim2.fromScale(0, 0.5),
			Size = UDim2.fromScale(1, 0.4),
		}),

		UIListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),

		TITLE = React.createElement("TextLabel", {
			FontFace = Font.new(
				"rbxasset://fonts/families/GothamSSm.json",
				Enum.FontWeight.Bold,
				Enum.FontStyle.Normal
			),
			Text = "Animes refresh in:",
			TextColor3 = Color3.fromRGB(233, 233, 233),
			TextScaled = true,
			TextSize = 14,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Right,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 0.6),
		}),
	})
end

return REFRESH