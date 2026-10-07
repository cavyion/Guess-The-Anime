local Players = game:GetService("Players")
local Player = game.Players.LocalPlayer

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Orbit = require(ReplicatedStorage.Packages["@kabuyon"].Orbit)

local React = Orbit('React')
local ReactRoblox = Orbit('ReactRoblox')

local packets = require((ReplicatedStorage.packets))

local function UNSUMMON()
	return React.createElement("TextButton", {
		FontFace = Font.new(
			"rbxasset://fonts/families/GothamSSm.json",
			Enum.FontWeight.Bold,
			Enum.FontStyle.Normal
		),
		Text = "UNSUMMON",
		TextColor3 = Color3.fromRGB(233, 233, 233),
		TextScaled = true,
		TextSize = 14,
		TextWrapped = true,
		BackgroundColor3 = Color3.fromRGB(170, 0, 0),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.485, 0.246),
		Size = UDim2.fromScale(0.11, 0.029),
		[React.Event.Activated] = function()
			packets.Conjure.send({
				Task = 'Dismiss',
				Companion = ''
			})		
		end,
	}, {
		UICorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(1, 0),
		}),

		UIPadding = React.createElement("UIPadding", {
			PaddingBottom = UDim.new(0.05, 0),
			PaddingLeft = UDim.new(0.05, 0),
			PaddingRight = UDim.new(0.05, 0),
			PaddingTop = UDim.new(0.05, 0),
		}),

		UIStroke = React.createElement("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = Color3.fromRGB(64, 64, 64),
			Thickness = 3,
			Transparency = 0.85,
		}),
	})
end

return UNSUMMON