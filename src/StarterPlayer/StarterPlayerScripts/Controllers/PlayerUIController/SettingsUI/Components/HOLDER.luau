local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Orbit = require(ReplicatedStorage.Packages["@kabuyon"].Orbit)

local Players = game:GetService("Players")
local player = game.Players.LocalPlayer

local React = Orbit('React')
local ReactRoblox = Orbit('ReactRoblox')
local Resonate = Orbit('Resonate')

local ReplicaHandler = require(script.Parent.Parent.Parent.Parent.ReplicaHandler)

local PlayerProfileReplica =  ReplicaHandler:GetReplica('PlayerProfileReplica')

local function SETTING_ITEM(props)
	return React.createElement("Frame", {
		BackgroundColor3 = Color3.fromRGB(34, 34, 34),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.35, 0.0956),
		Size = UDim2.fromScale(0.299, 0.307),
	}, {
		UICorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0.125, 0),
		}),

		SettingName = React.createElement("TextLabel", {
			FontFace = Font.new(
				"rbxasset://fonts/families/GothamSSm.json",
				Enum.FontWeight.Bold,
				Enum.FontStyle.Normal
			),
			Text = props.SETTING_NAME,
			TextColor3 = Color3.fromRGB(233, 233, 233),
			TextScaled = true,
			TextSize = 14,
			TextWrapped = true,
			TextYAlignment = Enum.TextYAlignment.Bottom,
			BackgroundColor3 = Color3.fromRGB(55, 55, 55),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.0931, 0.0959),
			Size = UDim2.fromScale(0.803, 0.319),
		}),

		Toggle = React.createElement("TextButton", {
			FontFace = Font.new(
				"rbxasset://fonts/families/GothamSSm.json",
				Enum.FontWeight.Bold,
				Enum.FontStyle.Normal
			),
			Text = 'Toggle', -- props.SETTING_INFO
			TextColor3 = Color3.fromRGB(233, 233, 233),
			TextScaled = true,
			TextSize = 14,
			TextWrapped = true,
			BackgroundColor3 = Color3.fromRGB(85, 170, 127),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.0931, 0.544),
			Size = UDim2.fromScale(0.803, 0.318),
			[React.Event.Activated] = props.ActivatedEvent
		}, {
			UICorner2 = React.createElement("UICorner", {
				CornerRadius = UDim.new(0.125, 0),
			}),

			UIPadding = React.createElement("UIPadding", {
				PaddingBottom = UDim.new(0.05, 0),
				PaddingLeft = UDim.new(0.05, 0),
				PaddingRight = UDim.new(0.05, 0),
				PaddingTop = UDim.new(0.05, 0),
			}),
		}),

		UIStroke = React.createElement("UIStroke", {
			Color = Color3.fromRGB(85, 170, 127),
			Thickness = 1.5,
			Transparency = 0.25,
		}),

		UIAspectRatioConstraint = React.createElement("UIAspectRatioConstraint", {
			AspectRatio = 1.62,
		}),
	})
end

local SETTING_CONTAINERS = {}

for i,v in (PlayerProfileReplica.Data.SETTINGS) do
	if i == 'SFX' then
		SETTING_CONTAINERS[i] = React.createElement(SETTING_ITEM, {
			key = i,
			SETTING_INFO = tostring(v),
			SETTING_NAME = i,
			ActivatedEvent = function()
				if game.Players.LocalPlayer:WaitForChild("ClientSettings").SFX_BOOL then
					game.Players.LocalPlayer.ClientSettings.SFX_BOOL.Value = not game.Players.LocalPlayer.ClientSettings.SFX_BOOL.Value
				end
			end,
		})
	else
		SETTING_CONTAINERS[i] = React.createElement(SETTING_ITEM, {
			key = i,
			SETTING_INFO = tostring(v),
			SETTING_NAME = i
		})
	end
	

end

local function HOLDER()
	return React.createElement("Frame", {
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 0.35,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.269, 0.289),
		Size = UDim2.fromScale(0.463, 0.568),
	}, {
		UICorner = React.createElement("UICorner"),

		UIStroke = React.createElement("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = Color3.fromRGB(64, 64, 64),
			Thickness = 3,
			Transparency = 0.85,
		}),

		SettingsScroll = React.createElement("ScrollingFrame", {
			CanvasSize = UDim2.fromScale(0, 4),
			ScrollBarImageColor3 = Color3.fromRGB(0, 85, 127),
			ScrollBarThickness = 6,
			Active = true,
			BackgroundColor3 = Color3.fromRGB(11, 11, 11),
			BackgroundTransparency = 0.25,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.0204, 0.0283),
			Size = UDim2.fromScale(0.954, 0.939),
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				Padding = UDim.new(0.025, 0),
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Wraps = true

			}),

			UIPadding = React.createElement("UIPadding", {
				PaddingBottom = UDim.new(0.025, 0),
				PaddingLeft = UDim.new(0.025, 0),
				PaddingRight = UDim.new(0.025, 0),
				PaddingTop = UDim.new(0.025, 0),
			}),
			React.createElement(React.Fragment, nil, SETTING_CONTAINERS)

		}),
	})
end

return HOLDER