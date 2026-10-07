local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Orbit = require(ReplicatedStorage.Packages["@kabuyon"].Orbit)

local React = Orbit('React')
local ReactRoblox = Orbit('ReactRoblox')

local function NOTIFICATION()
	return React.createElement("Frame", {
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 0.35,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0, 0.649),
		Size = UDim2.fromScale(1, 0.351),
	}, {
		TITLE = React.createElement("TextLabel", {
			FontFace = Font.new(
				"rbxassetid://11702779517",
				Enum.FontWeight.Bold,
				Enum.FontStyle.Normal
			),
			Text = "NOTIFICATION",
			TextColor3 = Color3.fromRGB(233, 233, 233),
			TextScaled = true,
			TextSize = 14,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.188, 0.1),
			Size = UDim2.fromScale(0.717, 0.165),
		}),

		DESCRIPTION = React.createElement("TextLabel", {
			FontFace = Font.new("rbxassetid://11702779517"),
			Text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam finibus imperdiet ex, in faucibus metus auctor sit amet. Mauris augue elit, laoreet et ipsum nec, rhoncus tincidunt metus",
			TextColor3 = Color3.fromRGB(233, 233, 233),
			TextScaled = true,
			TextSize = 14,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.188, 0.285),
			Size = UDim2.fromScale(0.717, 0.589),
		}),

		UICorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(1, 0),
		}),

		IMAGE = React.createElement("ImageLabel", {
			Image = "rbxasset://textures/ui/GuiImagePlaceholder.png",
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.042, 0.1),
			Size = UDim2.fromScale(0.241, 0.774),
		}, {
			UIAspectRatioConstraint = React.createElement("UIAspectRatioConstraint"),

			UICorner1 = React.createElement("UICorner", {
				CornerRadius = UDim.new(1, 0),
			}),
		}),

		UIStroke = React.createElement("UIStroke", {
			Color = Color3.fromRGB(85, 170, 127),
			Thickness = 2,
			Transparency = 0.35,
		}),
	})
end

local function NOTIFICATIONS()
	return React.createElement("Frame", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Position = UDim2.fromScale(0.709, 0.754),
		Size = UDim2.fromOffset(431, 181),
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			Padding = UDim.new(0.05, 0),
			Wraps = true,
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Bottom,
		}),

		UIPadding = React.createElement("UIPadding", {
			PaddingBottom = UDim.new(0.005, 0),
			PaddingLeft = UDim.new(0.005, 0),
			PaddingRight = UDim.new(0.005, 0),
			PaddingTop = UDim.new(0.005, 0),
		}),
	})
end

return NOTIFICATIONS