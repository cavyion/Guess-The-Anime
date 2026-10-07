local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Orbit = require(ReplicatedStorage.Packages["@kabuyon"].Orbit)

local React = Orbit('React')
local ReactRoblox = Orbit('ReactRoblox')

local function NOTIFICATIONS()
	return React.createElement("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(128, 128, 128),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Position = UDim2.fromScale(0.542, 0.86),
		Size = UDim2.fromScale(0.9, 0.192),
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			Padding = UDim.new(0.025, 0),
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Bottom,
		}),
	})
end

local function SMALL_NOTIFICATION()
	return React.createElement("Frame", {
		BackgroundColor3 = Color3.fromRGB(34, 34, 34),
		BackgroundTransparency = 0.35,
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.718, 0.864),
		Size = UDim2.fromScale(0.282, 0.136),
	}, {
		Text = React.createElement("TextLabel", {
			FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
			Text = "this is a notification",
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextScaled = true,
			TextSize = 14,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			BackgroundColor3 = Color3.fromRGB(34, 34, 34),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.038, 0),
			Size = UDim2.fromScale(0.94, 1),
		}, {
			UIPadding = React.createElement("UIPadding", {
				PaddingBottom = UDim.new(0.15, 0),
				PaddingLeft = UDim.new(0.05, 0),
				PaddingTop = UDim.new(0.15, 0),
			}),
		}),

		Color = React.createElement("Frame", {
			BackgroundColor3 = Color3.fromRGB(255, 85, 127),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(-0.00255, 0),
			Size = UDim2.fromScale(0.0382, 1),
		}),
	})
end

return NOTIFICATIONS