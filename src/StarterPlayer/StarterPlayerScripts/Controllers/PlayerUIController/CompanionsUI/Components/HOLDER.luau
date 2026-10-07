local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Orbit = require(ReplicatedStorage.Packages["@kabuyon"].Orbit)

local Players = game:GetService("Players")
local player = game.Players.LocalPlayer

local React = Orbit('React')
local ReactRoblox = Orbit('ReactRoblox')
local Resonate = Orbit('Resonate')

local ReplicaHandler = require(script.Parent.Parent.Parent.Parent.ReplicaHandler)
local PlayerProfileReplica = ReplicaHandler:GetReplica('PlayerProfileReplica')
local packets = require((ReplicatedStorage.packets))

local COMPANION_ITEMS = {}

local CompanionsInfo = require(ReplicatedStorage:WaitForChild("Assets").Companions.Companions)

local function COMPANION_ITEM(props)
	local COMPANION = props.COMPANION
	local COMPANION_IMAGE = "0"
	if CompanionsInfo[COMPANION] then
		COMPANION_IMAGE = CompanionsInfo[COMPANION].Image
	end

	return React.createElement("Frame", {
		BackgroundColor3 = Color3.fromRGB(34, 34, 34),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = UDim2.fromScale(-2.19e-08, 0.0733),
		Size = UDim2.fromScale(0.266, 0.405),
	}, {
		UICorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0.125, 0),
		}),

		CompanionName = React.createElement("TextLabel", {
			FontFace = Font.new(
				"rbxasset://fonts/families/GothamSSm.json",
				Enum.FontWeight.Bold,
				Enum.FontStyle.Normal
			),
			Text = COMPANION,
			TextColor3 = Color3.fromRGB(233, 233, 233),
			TextScaled = true,
			TextSize = 14,
			TextWrapped = true,
			TextYAlignment = Enum.TextYAlignment.Bottom,
			BackgroundColor3 = Color3.fromRGB(55, 55, 55),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.102, 0.0397),
			Size = UDim2.fromScale(0.803, 0.179),
		}),

		Toggle = React.createElement("TextButton", {
			FontFace = Font.new(
				"rbxasset://fonts/families/GothamSSm.json",
				Enum.FontWeight.Bold,
				Enum.FontStyle.Normal
			),
			Text = "CONJURE",
			TextColor3 = Color3.fromRGB(233, 233, 233),
			TextScaled = true,
			TextSize = 14,
			TextWrapped = true,
			BackgroundColor3 = Color3.fromRGB(85, 170, 127),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.0931, 0.803),
			Size = UDim2.fromScale(0.803, 0.138),
			[React.Event.Activated] = function()
				packets.Conjure.send({
					Task = 'Summon',
					Companion = COMPANION
				})
			end,
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
			AspectRatio = 0.818,
		}),

		CompanionImage = React.createElement("ImageLabel", {
			Image = COMPANION_IMAGE,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.197, 0.258),
			Size = UDim2.fromScale(0.59, 0.554),
		}, {
			UIAspectRatioConstraint1 = React.createElement("UIAspectRatioConstraint"),
		}),
	})
end


local function HOLDER()

	local COMPANION_ITEMS_LIST, setCOMPANION_ITEMS = React.useState(COMPANION_ITEMS or {})
	
	
	
	local function updateCompanionItems()
		local newCompanionItems = {}

		for i,v in PlayerProfileReplica.Data.INVENTORY.COMPANIONS do
			if CompanionsInfo[v] then
				newCompanionItems[i] = React.createElement(COMPANION_ITEM, {
					key = i,
					COMPANION = v
				})
			end
			
		end
		
		COMPANION_ITEMS = newCompanionItems
		setCOMPANION_ITEMS(newCompanionItems)
	end
	
	React.useEffect(function()
		updateCompanionItems()
	end, {PlayerProfileReplica.Data.INVENTORY.COMPANIONS})  

	return React.createElement("Frame", {
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 0.35,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.132, 0.285),
		Size = UDim2.fromScale(0.463, 0.568),
	}, {
		UICorner = React.createElement("UICorner"),

		UIStroke = React.createElement("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = Color3.fromRGB(64, 64, 64),
			Thickness = 3,
			Transparency = 0.85,
		}),

		CompanionsScroll = React.createElement("ScrollingFrame", {
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
				Wraps = true,
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
			}),

			UIPadding = React.createElement("UIPadding", {
				PaddingBottom = UDim.new(0.025, 0),
				PaddingLeft = UDim.new(0.025, 0),
				PaddingRight = UDim.new(0.025, 0),
				PaddingTop = UDim.new(0.025, 0),
			}),
			React.createElement(React.Fragment, nil, table.unpack(COMPANION_ITEMS_LIST))

		}),
	})
end

return HOLDER