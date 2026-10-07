local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Orbit = require(ReplicatedStorage.Packages["@kabuyon"].Orbit)

local React = Orbit('React')
local ReactRoblox = Orbit('ReactRoblox')

local asset = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
local originalDate = tostring(asset.Updated)
local year, month, day = originalDate:match("(%d+)%-(%d+)%-(%d+)")
local formattedDate = string.format("%04d-%02d-%02d", year, month, day)

local function GAME_VERSION()
	local versionInfo = `{formattedDate} | CV-{game.PlaceVersion}`
	local gameVersion, setGameVersion = React.useState(versionInfo)

	return React.createElement("Frame", {
		BackgroundColor3 = Color3.fromRGB(33, 33, 33),
		BackgroundTransparency = 1,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.00428, 0.955),
		Size = UDim2.fromScale(0.9, 0.034),
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),

		Description = React.createElement("TextLabel", {
			FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
			Text = gameVersion,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextScaled = true,
			TextSize = 14,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
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
			Text = "Game Version",
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextScaled = true,
			TextSize = 14,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			BackgroundColor3 = Color3.fromRGB(34, 34, 34),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0, 2),
			Size = UDim2.fromScale(1, 0.5),
		}),
	})
end

return GAME_VERSION