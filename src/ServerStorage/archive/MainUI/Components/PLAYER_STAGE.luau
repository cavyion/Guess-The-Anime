local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Orbit = require(ReplicatedStorage.Packages["@kabuyon"].Orbit)

local React = Orbit('React')
local ReactRoblox = Orbit('ReactRoblox') -- Assuming Roact is used instead of ReactRoblox for rendering

local Player = game.Players.LocalPlayer
local leaderstats = Player:WaitForChild("leaderstats")
local CURRENT_STAGE = leaderstats:WaitForChild("Stage")

local function StageLabel()
	local stage, setStage = React.useState("1") -- Default stage value

	-- Effect to listen for changes in leaderstats.Stage
	React.useEffect(function()
		local function updateStage(newStage)
			setStage(tostring(newStage))
		end

		-- Initially set the stage
		updateStage(CURRENT_STAGE.Value)

		-- Connect a listener to update stage on changes
		local connection = CURRENT_STAGE.Changed:Connect(function(newStage)
			updateStage(newStage)
		end)

		-- Cleanup function
		return function()
			connection:Disconnect() -- Disconnect listener when unmounting or no longer needed
		end
	end )-- Empty dependency array means this effect runs only once on mount

	return React.createElement("TextLabel", {
		FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),		
		Text = "Stage " .. stage .. "/101",
		TextColor3 = Color3.fromRGB(233, 233, 233),
		TextScaled = true,
		TextSize = 14,
		TextWrapped = true,
		BackgroundColor3 = Color3.fromRGB(33, 33, 33),
		BackgroundTransparency = 1,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 0.05, 0),
		Size = UDim2.fromScale(1, 0.0278),
	}, {
		UICorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(1, 0),
		}),

		UIPadding = React.createElement("UIPadding", {
			PaddingBottom = UDim.new(0.4, 0),
		}),
	})
end

return StageLabel
