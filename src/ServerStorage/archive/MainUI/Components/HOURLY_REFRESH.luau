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


local function HOURLY_REFRESH(props)
	local hourlyRefresh, setHourlyRefresh = React.useState(props.hourlyRefreshText or 0)

	React.useEffect(function()
		setHourlyRefresh(formatter(props.hourlyRefreshText) or 0)
	end, {props.hourlyRefreshText})
	
	return React.createElement("Frame", {
		BackgroundColor3 = Color3.fromRGB(33, 33, 33),
		BackgroundTransparency = 1,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0, 0.07),
		Size = UDim2.fromScale(1, 0.031),
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),

		Description = React.createElement("TextLabel", {
			FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
			Text = `⏱️ {hourlyRefresh}`,
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
			Text = "Animes resetting in..",
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextScaled = true,
			TextSize = 14,
			TextWrapped = true,
			BackgroundColor3 = Color3.fromRGB(34, 34, 34),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0, 0.566),
			Size = UDim2.fromScale(1, 0.5),
		}),
	})
end

return HOURLY_REFRESH
