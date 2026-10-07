local Players = game:GetService("Players")
local Player = game.Players.LocalPlayer

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Orbit = require(ReplicatedStorage.Packages["@kabuyon"].Orbit)

local React = Orbit('React')
local ReactRoblox = Orbit('ReactRoblox')
local ReplicaController = Orbit('ReplicaController')
local ReplicaHandler = require(Player:WaitForChild('PlayerScripts').Controllers.ReplicaHandler)

local TFMv2 = Orbit("TFMv2")

local function formatter(x)
	return
		tostring(TFMv2.FormatStr({
		min = math.floor(x / 60),
		sec = x % 60,
	}, '%02m:%02S'))
end

local function SKIPS(props)
	
	local skips, setSkips = React.useState(0 or props.skipText)
	local freeSkipsIn, setFreeSkipsIn = React.useState(300 or props.freeSkipInText)
	
	React.useEffect(function()
		setSkips(props.skipText or 'Loading')
		setFreeSkipsIn(formatter(props.freeSkipInText) or 'Loading')
	end, {props.freeSkipInText})

	return React.createElement("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(34, 34, 34),
		BackgroundTransparency = 1,
		Position = UDim2.fromScale(0.895, 0.557),
		Size = UDim2.fromScale(0.178, 0.0507),
	}, {
		MoreSkips = React.createElement("TextButton", {
			FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json"),
			Text = "+",
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextScaled = true,
			TextSize = 14,
			TextWrapped = true,
			AutoButtonColor = false,
			BackgroundColor3 = Color3.fromRGB(85, 85, 127),
			BackgroundTransparency = 0.35,
			Size = UDim2.fromScale(0.177, 1),
		}, {
			UIPadding = React.createElement("UIPadding", {
				PaddingBottom = UDim.new(0.1, 0),
			}),

			UIStroke = React.createElement("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Color3.fromRGB(0, 170, 127),
				Thickness = 3,
				Transparency = 0.85,
			}),

			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0.125, 0),
			}),
		}),

		SkipsText = React.createElement("TextButton", {
			FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json"),
			Text = string.format("%s ⏩", skips),
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextScaled = true,
			TextSize = 14,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			AutoButtonColor = false,
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 0.30,
			Position = UDim2.fromScale(0.206, 0),
			Size = UDim2.fromScale(0.791, 1),
		}, {
			UIPadding1 = React.createElement("UIPadding", {
				PaddingBottom = UDim.new(0.05, 0),
				PaddingLeft = UDim.new(0.05, 0),
				PaddingRight = UDim.new(0.05, 0),
				PaddingTop = UDim.new(0.05, 0),
			}),

			UIStroke1 = React.createElement("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Color3.fromRGB(64, 64, 64),
				Thickness = 3,
				Transparency = 0.85,
			}),

			FreeSkipIn = React.createElement("TextLabel", {
				FontFace = Font.new(
					"rbxasset://fonts/families/GothamSSm.json",
					Enum.FontWeight.Regular,
					Enum.FontStyle.Italic
				),
				Text = string.format("⏱️ %s", freeSkipsIn),
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextScaled = true,
				TextSize = 14,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Right,
				TextYAlignment = Enum.TextYAlignment.Bottom,
				BackgroundColor3 = Color3.fromRGB(34, 34, 34),
				BackgroundTransparency = 1,
				Position = UDim2.fromScale(0.526, 0.579),
				Size = UDim2.fromScale(0.492, 0.323),
			}),

			UICorner1 = React.createElement("UICorner", {
				CornerRadius = UDim.new(0.125, 0),
			}),
		}),
	})
end

return SKIPS
