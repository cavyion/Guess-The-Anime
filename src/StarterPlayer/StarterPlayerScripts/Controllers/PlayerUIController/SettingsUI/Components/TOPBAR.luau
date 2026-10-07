local Players = game:GetService("Players")
local Player = game.Players.LocalPlayer

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Orbit = require(ReplicatedStorage.Packages["@kabuyon"].Orbit)

local React = Orbit('React')
local ReactRoblox = Orbit('ReactRoblox')

local function TOPBAR()
	return React.createElement("TextLabel", {
		FontFace = Font.new(
			"rbxasset://fonts/families/GothamSSm.json",
			Enum.FontWeight.Bold,
			Enum.FontStyle.Normal
		),
		Text = "SETTINGS",
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextScaled = true,
		TextSize = 14,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(0, 85, 127),
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.5, 0.26),
		Size = UDim2.fromScale(0.464, 0.0388),
	}, {
		UICorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(1, 0),
		}),

		UIStroke = React.createElement("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = Color3.fromRGB(64, 64, 64),
			Thickness = 3,
			Transparency = 0.85,
		}),

		UIPadding = React.createElement("UIPadding", {
			PaddingBottom = UDim.new(0.025, 0),
			PaddingLeft = UDim.new(0.025, 0),
			PaddingTop = UDim.new(0.025, 0),
		}),
	})
end

return TOPBAR
