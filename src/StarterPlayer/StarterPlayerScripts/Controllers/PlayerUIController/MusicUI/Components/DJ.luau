local Players = game:GetService("Players")
local Player = game.Players.LocalPlayer

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Orbit = require(ReplicatedStorage.Packages["@kabuyon"].Orbit)

local React = Orbit('React')
local ReactRoblox = Orbit('ReactRoblox')

local function DJ()
	return React.createElement("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(0, 85, 127),
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.308, 0.206),
		Size = UDim2.fromScale(0.0809, 0.131),
		ZIndex = 0,
	}, {
		DJImage = React.createElement("ImageLabel", {
			Image = "rbxassetid://315594498",
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			Position = UDim2.fromScale(0.496, 0.494),
			Size = UDim2.fromScale(0.745, 0.897),
		}, {
			UIAspectRatioConstraint = React.createElement("UIAspectRatioConstraint"),
		}),

		UICorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0.5, 0),
		}),

		UIStroke = React.createElement("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = Color3.fromRGB(64, 64, 64),
			Thickness = 3,
			Transparency = 0.85,
		}),

		UIAspectRatioConstraint1 = React.createElement("UIAspectRatioConstraint"),
	})
end

return DJ

