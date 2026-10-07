local Players = game:GetService("Players")
local Player = game.Players.LocalPlayer

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Orbit = require(ReplicatedStorage.Packages["@kabuyon"].Orbit)

local React = Orbit('React')
local ReactRoblox = Orbit('ReactRoblox')

local function MONEY(props)
	local money, setMoney = React.useState(props.moneyText or 'Loading')
	
	React.useEffect(function()
		setMoney(props.moneyText or 'Loading')
	end, {props.moneyText})
	
	return React.createElement("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(34, 34, 34),
		BackgroundTransparency = 1,
		Position = UDim2.fromScale(0.895, 0.499),
		Size = UDim2.fromScale(0.178, 0.0507),
	}, {
		Money = React.createElement("TextButton", {
			FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json"),
			Text = string.format("%s 💵", money),
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextScaled = true,
			TextSize = 14,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			AutoButtonColor = false,
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 0.30,
			Size = UDim2.fromScale(0.791, 1),
		}, {
			UIStroke = React.createElement("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Color3.fromRGB(64, 64, 64),
				Thickness = 3,
				Transparency = 0.85,
			}),

			UIPadding = React.createElement("UIPadding", {
				PaddingBottom = UDim.new(0.05, 0),
				PaddingLeft = UDim.new(0.05, 0),
				PaddingRight = UDim.new(0.05, 0),
				PaddingTop = UDim.new(0.05, 0),
			}),

			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0.125, 0),
			}),
		}),

		MoreMoney = React.createElement("TextButton", {
			FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json"),
			Text = "+",
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextScaled = true,
			TextSize = 14,
			TextWrapped = true,
			AutoButtonColor = false,
			BackgroundColor3 = Color3.fromRGB(85, 170, 127),
			BackgroundTransparency = 0.35,
			Position = UDim2.fromScale(0.823, 0),
			Size = UDim2.fromScale(0.177, 1),
		}, {
			UIPadding1 = React.createElement("UIPadding", {
				PaddingBottom = UDim.new(0.1, 0),
			}),

			UIStroke1 = React.createElement("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Color3.fromRGB(0, 170, 127),
				Thickness = 3,
				Transparency = 0.85,
			}),

			UICorner1 = React.createElement("UICorner", {
				CornerRadius = UDim.new(0.125, 0),
			}),
		}),
	})
end

return MONEY
