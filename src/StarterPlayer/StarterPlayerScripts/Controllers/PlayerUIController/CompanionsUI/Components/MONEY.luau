local Players = game:GetService("Players")
local Player = game.Players.LocalPlayer

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Orbit = require(ReplicatedStorage.Packages["@kabuyon"].Orbit)

local React = Orbit('React')
local ReactRoblox = Orbit('ReactRoblox')

local function MONEY(props)
	
	local money, setMoney = React.useState(props.MONEY_TEXT or 'Loading')


	React.useEffect(function()
		setMoney(props.MONEY_TEXT)
	end, {props})
	
	
	return React.createElement("TextLabel", {
		FontFace = Font.new(
			"rbxasset://fonts/families/GothamSSm.json",
			Enum.FontWeight.Bold,
			Enum.FontStyle.Normal
		),
		Text = money.." 💵",
		TextColor3 = Color3.fromRGB(233, 233, 233),
		TextScaled = true,
		TextSize = 14,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 0.35,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.729, 0.245),
		Size = UDim2.fromScale(0.139, 0.0298),
	}, {
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

		UICorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(1, 0),
		}),
	})	
	
end

return MONEY