local Players = game:GetService("Players")
local Player = game.Players.LocalPlayer

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Orbit = require(ReplicatedStorage.Packages["@kabuyon"].Orbit)

local React = Orbit('React')
local ReactRoblox = Orbit('ReactRoblox')
local Icon = Orbit('Icon')

local TFMv2 = Orbit("TFMv2")

local function formatter(x)
	return
		tostring(TFMv2.FormatStr({
			min = math.floor(x / 60),
			sec = x % 60,
		}, '%02m:%02S'))
end

local function CURRENCIES(props)
	local money, setMoney = React.useState(props.MONEY_TEXT or 'Loading')
	local tsunovium, setTsunovium = React.useState(props.TSUNOVIUM_TEXT or 'Loading')
	local skips, setSkips = React.useState(props.SKIP_TEXT or 'Loading')
	local freeSkipIn, setFreeSkipIn = React.useState(props.FREE_SKIP_IN_TEXT or 'Loading')
	
	React.useEffect(function()
		setSkips(props.SKIP_TEXT)
		setMoney(props.MONEY_TEXT)
		setTsunovium(props.TSUNOVIUM_TEXT)
		setFreeSkipIn(formatter(props.FREE_SKIP_IN_TEXT))
	end, {props})
	
	
	local ShopIcon = Icon.getIcon('Shop')	
	
	return React.createElement("Frame", {
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 1,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.799, 0.403),
		Size = UDim2.fromOffset(260, 186),
	}, {
		CURRENCY = React.createElement("Frame", {
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 0.35,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(-0.0346, 0.353),
			Size = UDim2.fromScale(1, 0.294),
		}, {
			AMOUNT = React.createElement("TextLabel", {
				FontFace = Font.new("rbxassetid://11702779517"),
				Text = `{tsunovium} ✨`,
				TextColor3 = Color3.fromRGB(233, 233, 233),
				TextScaled = true,
				TextSize = 14,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = UDim2.fromScale(0.0606, 0.146),
				Size = UDim2.fromScale(0.879, 0.4),
			}),

			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(1, 0),
			}),

			UIStroke = React.createElement("UIStroke", {
				Color = Color3.fromRGB(0, 170, 127),
				Thickness = 2,
				Transparency = 0.15,
			}),

			CURRENCYNAME = React.createElement("TextLabel", {
				FontFace = Font.new("rbxassetid://11702779517"),
				Text = "TSUNOVIUM",
				TextColor3 = Color3.fromRGB(233, 233, 233),
				TextScaled = true,
				TextSize = 14,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = UDim2.fromScale(0.0606, 0.541),
				Size = UDim2.fromScale(0.879, 0.291),
			}),

			BUY = React.createElement("TextButton", {
				FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
				Text = "+",
				TextColor3 = Color3.fromRGB(233, 233, 233),
				TextScaled = true,
				TextSize = 14,
				TextWrapped = true,
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 0.35,
				BorderColor3 = Color3.fromRGB(33, 33, 33),
				BorderSizePixel = 0,
				Position = UDim2.fromScale(0.809, 0.186),
				Size = UDim2.fromScale(0.181, 0.612),
				[React.Event.Activated] = function()
					if ShopIcon.isSelected then
						ShopIcon:deselect() 
					else
						ShopIcon:select()
					end
				end,
				
			}, {
				UIStroke1 = React.createElement("UIStroke", {
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Color = Color3.fromRGB(0, 170, 127),
					Transparency = 0.15,
				}),

				UICorner1 = React.createElement("UICorner", {
					CornerRadius = UDim.new(1, 0),
				}),

				UIAspectRatioConstraint = React.createElement("UIAspectRatioConstraint"),
			}),
		}),

		UIListLayout = React.createElement("UIListLayout", {
			Padding = UDim.new(0.05, 0),
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
		}),

		CURRENCY1 = React.createElement("Frame", {
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 0.35,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(-0.0346, 0.353),
			Size = UDim2.fromScale(1, 0.294),
		}, {
			AMOUNT1 = React.createElement("TextLabel", {
				FontFace = Font.new("rbxassetid://11702779517"),
				Text = `{money} 💵`,
				TextColor3 = Color3.fromRGB(233, 233, 233),
				TextScaled = true,
				TextSize = 14,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = UDim2.fromScale(0.0606, 0.146),
				Size = UDim2.fromScale(0.879, 0.4),
			}),

			UICorner2 = React.createElement("UICorner", {
				CornerRadius = UDim.new(1, 0),
			}),

			UIStroke2 = React.createElement("UIStroke", {
				Color = Color3.fromRGB(0, 170, 127),
				Thickness = 2,
				Transparency = 0.15,
			}),

			CURRENCYNAME1 = React.createElement("TextLabel", {
				FontFace = Font.new("rbxassetid://11702779517"),
				Text = "MONEY",
				TextColor3 = Color3.fromRGB(233, 233, 233),
				TextScaled = true,
				TextSize = 14,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = UDim2.fromScale(0.0606, 0.541),
				Size = UDim2.fromScale(0.879, 0.291),
			}),

			BUY1 = React.createElement("TextButton", {
				FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
				Text = "+",
				TextColor3 = Color3.fromRGB(233, 233, 233),
				TextScaled = true,
				TextSize = 14,
				TextWrapped = true,
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 0.35,
				BorderColor3 = Color3.fromRGB(33, 33, 33),
				BorderSizePixel = 0,
				Position = UDim2.fromScale(0.809, 0.186),
				Size = UDim2.fromScale(0.181, 0.612),
				[React.Event.Activated] = function()
					if ShopIcon.isSelected then
						ShopIcon:deselect() 
					else
						ShopIcon:select()
					end
				end,
			}, {
				UIStroke3 = React.createElement("UIStroke", {
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Color = Color3.fromRGB(0, 170, 127),
					Transparency = 0.15,
				}),

				UICorner3 = React.createElement("UICorner", {
					CornerRadius = UDim.new(1, 0),
				}),

				UIAspectRatioConstraint1 = React.createElement("UIAspectRatioConstraint"),
			}),
		}),

		CURRENCY2 = React.createElement("Frame", {
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 0.35,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(-0.0346, 0.353),
			Size = UDim2.fromScale(1, 0.294),
		}, {
			AMOUNT2 = React.createElement("TextLabel", {
				FontFace = Font.new("rbxassetid://11702779517"),
				Text = `{skips} ⏩`,
				TextColor3 = Color3.fromRGB(233, 233, 233),
				TextScaled = true,
				TextSize = 14,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = UDim2.fromScale(0.0606, 0.146),
				Size = UDim2.fromScale(0.879, 0.4),
			}),

			UICorner4 = React.createElement("UICorner", {
				CornerRadius = UDim.new(1, 0),
			}),

			UIStroke4 = React.createElement("UIStroke", {
				Color = Color3.fromRGB(0, 170, 127),
				Thickness = 2,
				Transparency = 0.15,
			}),

			CURRENCYNAME2 = React.createElement("TextLabel", {
				FontFace = Font.new("rbxassetid://11702779517"),
				Text = `SKIPS | ⏱️ {freeSkipIn}`,
				TextColor3 = Color3.fromRGB(233, 233, 233),
				TextScaled = true,
				TextSize = 14,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = UDim2.fromScale(0.0606, 0.541),
				Size = UDim2.fromScale(0.879, 0.291),
			}),

			BUY2 = React.createElement("TextButton", {
				FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
				Text = "+",
				TextColor3 = Color3.fromRGB(233, 233, 233),
				TextScaled = true,
				TextSize = 14,
				TextWrapped = true,
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 0.35,
				BorderColor3 = Color3.fromRGB(33, 33, 33),
				BorderSizePixel = 0,
				Position = UDim2.fromScale(0.809, 0.186),
				Size = UDim2.fromScale(0.181, 0.612),
				[React.Event.Activated] = function()
					if ShopIcon.isSelected then
						ShopIcon:deselect() 
					else
						ShopIcon:select()
					end
				end,
			}, {
				UIStroke5 = React.createElement("UIStroke", {
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Color = Color3.fromRGB(0, 170, 127),
					Transparency = 0.15,
				}),

				UICorner5 = React.createElement("UICorner", {
					CornerRadius = UDim.new(1, 0),
				}),

				UIAspectRatioConstraint2 = React.createElement("UIAspectRatioConstraint"),
			}),
		}),
	})
end

return CURRENCIES