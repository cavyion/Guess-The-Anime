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

local function fetchUserInfo()
	local userId = game.Players.LocalPlayer.UserId
	return {
		userId = userId,
		username = game.Players.LocalPlayer.Name,
	}
end

local function getPlaceUpdatedDate()
	if game.PlaceId <= 0 then
		return "Unpublished"
	end

	local success, asset = pcall(function()
		return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
	end)
	if not success or type(asset) ~= "table" or type(asset.Updated) ~= "string" then
		return "Unavailable"
	end

	local year, month, day = asset.Updated:match("(%d+)%-(%d+)%-(%d+)")
	if not year then
		return "Unavailable"
	end

	return string.format("%04d-%02d-%02d", tonumber(year), tonumber(month), tonumber(day))
end

local formattedDate = getPlaceUpdatedDate()

local function INFO(props)
	local serverRegion = game.JobId:match("%[(%a+)%]") or "Unknown"
	local servername, setServername = React.useState(props.SERVER_NAME_TEXT or "Loading...")
	local playerName, setPlayerName = React.useState(fetchUserInfo().username)
	local userID, setUserId = React.useState(fetchUserInfo().userId)
	local serverAge, setServerAge = React.useState(formatTime(workspace.DistributedGameTime - startTime))
	local placeVersion = game.PlaceId > 0 and tostring(game.PlaceVersion) or "Studio"
	local versionInfo = `{formattedDate} | CV-{placeVersion}`
	local gameVersion, setGameVersion = React.useState(versionInfo)
	
	React.useEffect(function()
		setServername(props.SERVER_NAME_TEXT or "Loading...")
		setPlayerName(fetchUserInfo().username)
		setUserId(fetchUserInfo().userId)
		
		local running = true
		local function update()
			while running do
				setServerAge(formatTime(workspace.DistributedGameTime - startTime))
				wait(1)
			end
		end
		local thread = coroutine.create(update)
		coroutine.resume(thread)
		
	end, {props.SERVER_NAME_TEXT})
	
	return React.createElement("Frame", {
		BackgroundColor3 = Color3.fromRGB(33, 33, 33),
		BackgroundTransparency = 1,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.025, 0.81),
		Size = UDim2.fromOffset(797, 126),
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),

		PLAYERINFO = React.createElement("Frame", {
			BackgroundColor3 = Color3.fromRGB(33, 33, 33),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0, 0.357),
			Size = UDim2.fromScale(1, 0.25),
		}, {
			TITLE = React.createElement("TextLabel", {
				FontFace = Font.new(
					"rbxassetid://11702779517",
					Enum.FontWeight.Bold,
					Enum.FontStyle.Normal
				),
				Text = playerName,
				TextColor3 = Color3.fromRGB(233, 233, 233),
				TextScaled = true,
				TextSize = 14,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = UDim2.fromScale(-0.0138, 0.254),
				Size = UDim2.fromScale(1, 0.5),
			}),

			UIListLayout1 = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
			}),

			DESCRIPTION = React.createElement("TextLabel", {
				FontFace = Font.new("rbxassetid://11702779517"),
				Text = userID,
				TextColor3 = Color3.fromRGB(233, 233, 233),
				TextScaled = true,
				TextSize = 14,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				LayoutOrder = 1,
				Size = UDim2.fromScale(1, 0.5),
			}),
		}),

		SERVERAGE = React.createElement("Frame", {
			BackgroundColor3 = Color3.fromRGB(33, 33, 33),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			LayoutOrder = 2,
			Position = UDim2.fromScale(0, 0.857),
			Size = UDim2.fromScale(1, 0.25),
		}, {
			TITLE1 = React.createElement("TextLabel", {
				FontFace = Font.new(
					"rbxassetid://11702779517",
					Enum.FontWeight.Bold,
					Enum.FontStyle.Normal
				),
				Text = "Server Age",
				TextColor3 = Color3.fromRGB(233, 233, 233),
				TextScaled = true,
				TextSize = 14,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Size = UDim2.fromScale(1, 0.5),
			}),

			UIListLayout2 = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
			}),

			DESCRIPTION1 = React.createElement("TextLabel", {
				FontFace = Font.new("rbxassetid://11702779517"),
				Text = serverAge,
				TextColor3 = Color3.fromRGB(233, 233, 233),
				TextScaled = true,
				TextSize = 14,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				LayoutOrder = 1,
				Position = UDim2.fromScale(0, 0.5),
				Size = UDim2.fromScale(1, 0.5),
			}),
		}),

		GAMEVERSION = React.createElement("Frame", {
			BackgroundColor3 = Color3.fromRGB(33, 33, 33),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			LayoutOrder = 3,
			Position = UDim2.fromScale(0, 1.11),
			Size = UDim2.fromScale(1, 0.25),
		}, {
			TITLE2 = React.createElement("TextLabel", {
				FontFace = Font.new(
					"rbxassetid://11702779517",
					Enum.FontWeight.Bold,
					Enum.FontStyle.Normal
				),
				Text = "Game Version",
				TextColor3 = Color3.fromRGB(233, 233, 233),
				TextScaled = true,
				TextSize = 14,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Size = UDim2.fromScale(1, 0.5),
			}),

			UIListLayout3 = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
			}),

			DESCRIPTION2 = React.createElement("TextLabel", {
				FontFace = Font.new("rbxassetid://11702779517"),
				Text = gameVersion,
				TextColor3 = Color3.fromRGB(233, 233, 233),
				TextScaled = true,
				TextSize = 14,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				LayoutOrder = 1,
				Size = UDim2.fromScale(1, 0.5),
			}),
		}),

		SERVERINFO = React.createElement("Frame", {
			BackgroundColor3 = Color3.fromRGB(33, 33, 33),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			LayoutOrder = 1,
			Position = UDim2.fromScale(0, 0.607),
			Size = UDim2.fromScale(1, 0.25),
		}, {
			TITLE3 = React.createElement("TextLabel", {
				FontFace = Font.new(
					"rbxassetid://11702779517",
					Enum.FontWeight.Bold,
					Enum.FontStyle.Normal
				),
				Text = "Server",
				TextColor3 = Color3.fromRGB(233, 233, 233),
				TextScaled = true,
				TextSize = 14,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Size = UDim2.fromScale(1, 0.5),
			}),

			UIListLayout4 = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
			}),

			DESCRIPTION3 = React.createElement("TextLabel", {
				FontFace = Font.new("rbxassetid://11702779517"),
				Text = `{servername} @ {serverRegion}`,
				TextColor3 = Color3.fromRGB(233, 233, 233),
				TextScaled = true,
				TextSize = 14,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				LayoutOrder = 1,
				Size = UDim2.fromScale(1, 0.5),
			}),
		}),
	})
end

return INFO
