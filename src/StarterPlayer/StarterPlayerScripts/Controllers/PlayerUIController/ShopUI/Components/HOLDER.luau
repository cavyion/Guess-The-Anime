local player = game.Players.LocalPlayer

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Orbit = require(ReplicatedStorage.Packages["@kabuyon"].Orbit)

local React = Orbit('React')
local ReactRoblox = Orbit('ReactRoblox')

local DeveloperProducts = require(ReplicatedStorage.Assets.Tables.DeveloperProducts)
local MarketplaceService = game:GetService("ServerScriptService")

local function SHOP_ITEM(props)
	
	local nameOf, setnameOf = React.useState(props.nameOfProduct)
	local priceOf, setPriceOf = React.useState(props.priceOfProduct)
	local imageOf, setImageOf = React.useState(props.imageOfProduct)
	local idOf = props.idOf
	local currencyOf = props.currencyOf
	
	return React.createElement("Frame", {
		BackgroundColor3 = Color3.fromRGB(34, 34, 34),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.172, 0.0956),
		Size = UDim2.fromScale(0.282, 0.363),
	}, {
		SettingName = React.createElement("TextLabel", {
			FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
			Text = tostring(nameOf),
			TextColor3 = Color3.fromRGB(233, 233, 233),
			TextScaled = true,
			TextSize = 14,
			TextWrapped = true,
			TextYAlignment = Enum.TextYAlignment.Bottom,
			BackgroundColor3 = Color3.fromRGB(55, 55, 55),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.0931, 0.037),
			Size = UDim2.fromScale(0.803, 0.162),
		}),

		Buy = React.createElement("TextButton", {
			FontFace = Font.new(
				"rbxasset://fonts/families/GothamSSm.json",
				Enum.FontWeight.Bold,
				Enum.FontStyle.Normal
			),
			Text = "BUY ("..priceOf.."R$)",
			TextColor3 = Color3.fromRGB(233, 233, 233),
			TextScaled = true,
			TextSize = 14,
			TextWrapped = true,
			BackgroundColor3 = Color3.fromRGB(0, 85, 127),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.0931, 0.823),
			Size = UDim2.fromScale(0.803, 0.118),
			[React.Event.Activated] = function()
				print(idOf)
				game:GetService("MarketplaceService"):PromptProductPurchase(player, tonumber(idOf))
			end,
		}, {
			UICorner2 = React.createElement("UICorner", {
				CornerRadius = UDim.new(1, 0),
			}),

			UIPadding = React.createElement("UIPadding", {
				PaddingBottom = UDim.new(0.1, 0),
				PaddingLeft = UDim.new(0.1, 0),
				PaddingRight = UDim.new(0.1, 0),
				PaddingTop = UDim.new(0.1, 0),
			}),
		}),

		UIAspectRatioConstraint = React.createElement("UIAspectRatioConstraint", {
			AspectRatio = 0.818,
		}),

		UIGradient = React.createElement("UIGradient", {
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 85, 255)),
			}),
			Rotation = 90,
		}),

		UIStroke = React.createElement("UIStroke", {
			Color = Color3.fromRGB(85, 255, 255),
			Transparency = 0.35,
		}),

		ItemImage = React.createElement("ImageButton", {
			Image = imageOf,
			BackgroundColor3 = Color3.fromRGB(11, 11, 11),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.19, 0.251),
			Size = UDim2.fromScale(0.599, 0.54),
		}, {
			UIAspectRatioConstraint1 = React.createElement("UIAspectRatioConstraint"),

			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(1, 0),
			}),
		}),
	})
end

local PRODUCT_CONTAINERS = {}	

for i,v in DeveloperProducts do
	PRODUCT_CONTAINERS[i] = React.createElement(SHOP_ITEM, {
		key = i,
		idOf = i,
		nameOfProduct = v.Name,
		priceOfProduct = v.Price,
		imageOfProduct = v.Image,
		currencyOf = "Robux"
	})
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

		SHOPSCROLLINGFRAME = React.createElement("ScrollingFrame", {
			ScrollBarImageColor3 = Color3.fromRGB(0, 85, 127),
			Active = true,
			BackgroundColor3 = Color3.fromRGB(11, 11, 11),
			BackgroundTransparency = 0.25,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.0222, 0.0309),
			Size = UDim2.fromScale(0.954, 0.938),
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
			React.createElement(React.Fragment, nil, PRODUCT_CONTAINERS)
			
		}),
	})
end

return HOLDER