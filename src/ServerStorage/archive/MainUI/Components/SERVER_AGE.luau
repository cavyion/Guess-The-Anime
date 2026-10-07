local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Orbit = require(ReplicatedStorage.Packages["@kabuyon"].Orbit)

local React = Orbit('React')
local ReactRoblox = Orbit('ReactRoblox')

local startTime = workspace.DistributedGameTime  -- Use DistributedGameTime as server start time

local function formatTime(seconds)
	local days = math.floor(seconds / 86400)
	seconds = seconds % 86400
	local hours = math.floor(seconds / 3600)
	seconds = seconds % 3600
	local minutes = math.floor(seconds / 60)
	seconds = seconds % 60
	return string.format("%dd %02dh %02dm %02ds", days, hours, minutes, seconds)
end

local function SERVER_AGE()
	local serverAge, setServerAge = React.useState(formatTime(workspace.DistributedGameTime - startTime))

	-- Update server age every second
	React.useEffect(function()
		local running = true
		local function update()
			while running do
				setServerAge(formatTime(workspace.DistributedGameTime - startTime))
				wait(1)
			end
		end
		local thread = coroutine.create(update)
		coroutine.resume(thread)

		return function()
			running = false
		end
	end, {})  -- Empty dependency array means this effect runs only once on mount

	return React.createElement("Frame", {
		BackgroundColor3 = Color3.fromRGB(33, 33, 33),
		BackgroundTransparency = 1,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.00419, 0.921),
		Size = UDim2.fromScale(0.9, 0.034),
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),

		Description = React.createElement("TextLabel", {
			FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
			Text = serverAge,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextScaled = true,
			TextSize = 14,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			BackgroundColor3 = Color3.fromRGB(34, 34, 34),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 1,
			Position = UDim2.fromScale(1.2, -2.52),
			Size = UDim2.fromScale(1, 0.5),
		}),

		Title = React.createElement("TextLabel", {
			FontFace = Font.new(
				"rbxasset://fonts/families/GothamSSm.json",
				Enum.FontWeight.Bold,
				Enum.FontStyle.Normal
			),
			Text = "Server Age",
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextScaled = true,
			TextSize = 14,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			BackgroundColor3 = Color3.fromRGB(34, 34, 34),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Position = UDim2.fromScale(-0.434, -4.67),
			Size = UDim2.fromScale(1, 0.5),
		}),
	})
end

return SERVER_AGE
