local Players = game:GetService("Players")
local Player = game.Players.LocalPlayer

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Orbit = require(ReplicatedStorage.Packages["@kabuyon"].Orbit)

local React = Orbit('React')
local ReactRoblox = Orbit('ReactRoblox')

local packets = require((ReplicatedStorage.packets))
local CompanionsInfo = require(ReplicatedStorage:WaitForChild("Assets").Companions.Companions)

local function SPINHOLDER(props)
	
	local x = ""
	local y = ""
	local z = ""
	local a = ""
	
	local RESULT_COMPANION, setRESULT_COMPANION = React.useState(x or "loading")
	local RESULT_DUPLICATE, setRESULT_DUPLICATE  = React.useState(y or "loading")
	local RESULT_TEXT, setRESULT_TEXT = React.useState(z or "")
	local RESULT_IMAGE, setRESULT_IMAGE = React.useState(a or "")	
	
	packets.SpinResult.listen(function(data)

		x = tostring(data.Companion)
		y = tostring(data.Duplicate)	

		if data.Duplicate > 0 then
			z = tostring("You got: " .. x .. "<br/>(Duplicate + " .. y .. " 💵)")
		else
			z = tostring("You got: ".. x)
		end
		if CompanionsInfo[data.Companion] then
			a = CompanionsInfo[data.Companion].Image
		end
		
		setRESULT_COMPANION(x)
		setRESULT_DUPLICATE(y)
		setRESULT_TEXT(z)
		setRESULT_IMAGE(a)	
	end)
	
	return React.createElement("Frame", {
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 0.35,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.608, 0.285),
		Size = UDim2.fromScale(0.26, 0.568),
	}, {
		UICorner = React.createElement("UICorner"),

		UIStroke = React.createElement("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = Color3.fromRGB(64, 64, 64),
			Thickness = 3,
			Transparency = 0.85,
		}),

		SPINAREA = React.createElement("Frame", {
			BackgroundColor3 = Color3.fromRGB(11, 11, 11),
			BackgroundTransparency = 0.25,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.0613, 0.0283),
			Size = UDim2.fromScale(0.874, 0.939),
		}, {
			UICorner1 = React.createElement("UICorner"),

			UIStroke1 = React.createElement("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Color3.fromRGB(64, 64, 64),
				Thickness = 3,
				Transparency = 0.85,
			}),

			SPIN = React.createElement("TextButton", {
				FontFace = Font.new(
					"rbxasset://fonts/families/GothamSSm.json",
					Enum.FontWeight.Bold,
					Enum.FontStyle.Normal
				),
				RichText = true,
				Text = "SPIN (1✨)",
				TextColor3 = Color3.fromRGB(233, 233, 233),
				TextScaled = true,
				TextSize = 14,
				TextWrapped = true,
				BackgroundColor3 = Color3.fromRGB(85, 170, 127),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = UDim2.fromScale(0.205, 0.478),
				Size = UDim2.fromScale(0.59, 0.0925),
				[React.Event.Activated] = function()
					packets.Spin.send({})
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

			SpinCompanionImage = React.createElement("ImageLabel", {
				Image = RESULT_IMAGE,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = UDim2.fromScale(0.232, 0.119),
				Size = UDim2.fromScale(0.59, 0.326),
			}, {
				UIAspectRatioConstraint = React.createElement("UIAspectRatioConstraint"),

				UICorner2 = React.createElement("UICorner", {
					CornerRadius = UDim.new(0.125, 0),
				}),

				UIStroke2 = React.createElement("UIStroke", {
					Color = Color3.fromRGB(0, 85, 127),
					Thickness = 3,
					Transparency = 0.25,
				}),
			}),

			Result = React.createElement("TextLabel", {
				FontFace = Font.new(
					"rbxasset://fonts/families/GothamSSm.json",
					Enum.FontWeight.Bold,
					Enum.FontStyle.Normal
				),
				RichText = true,
				Text = RESULT_TEXT,
				TextColor3 = Color3.fromRGB(233, 233, 233),
				TextScaled = true,
				TextSize = 14,
				TextWrapped = true,
				TextYAlignment = Enum.TextYAlignment.Bottom,
				BackgroundColor3 = Color3.fromRGB(55, 55, 55),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = UDim2.fromScale(0.0983, 0.586),
				Size = UDim2.fromScale(0.803, 0.0843),
			}),
		}),
	})
end

return SPINHOLDER
