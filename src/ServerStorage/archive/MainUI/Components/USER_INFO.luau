local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Orbit = require(ReplicatedStorage.Packages["@kabuyon"].Orbit)

local React = Orbit('React')
local ReactRoblox = Orbit('ReactRoblox')

local function fetchUserInfo()
	local userId = game.Players.LocalPlayer.UserId
	return {
		userId = userId,
		username = game.Players.LocalPlayer.Name,
	}
end

local function USER_INFO()
	local userInfo = fetchUserInfo()

	return React.createElement("Frame", {
		BackgroundColor3 = Color3.fromRGB(33, 33, 33),
		BackgroundTransparency = 1,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.00428, 0.852),
		Size = UDim2.fromScale(0.9, 0.034),
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),

		Description = React.createElement("TextLabel", {
			FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
			Text = userInfo.userId,
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
			Text = userInfo.username,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextScaled = true,
			TextSize = 14,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			BackgroundColor3 = Color3.fromRGB(34, 34, 34),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.931, -0.5),
			Size = UDim2.fromScale(1, 0.5),
		}),
	})
end

return USER_INFO
