local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Orbit = require(ReplicatedStorage.Packages["@kabuyon"].Orbit)

local Players = game:GetService("Players")
local player = game.Players.LocalPlayer

local React = Orbit('React')
local ReactRoblox = Orbit('ReactRoblox')
local Resonate = Orbit('Resonate')

local AUDIO = require(ReplicatedStorage.Assets.Audio.Audio)
local CONTROLLERS_FOLDER = game.Players.LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild('Controllers')
local MUSIC_CONTROLLER = require(CONTROLLERS_FOLDER.MusicController)
local MUSIC_INSTANCE = player:WaitForChild('ClientAudio'):WaitForChild('Music')


local SONG_ITEM_DEBOUNCE = tick()

local function formatTime(seconds)
	local minutes = math.floor(seconds / 60)
	local remainingSeconds = math.floor(seconds % 60)
	return string.format("%02d:%02d", minutes, remainingSeconds)
end

-- UI OBJECTS

local function SONG_ITEM(props)
	local SONG_INFO = props.SONG_INFO

	return React.createElement("Frame", {
		BackgroundColor3 = Color3.fromRGB(34, 34, 34),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = UDim2.fromScale(-2.37e-08, 0.123),
		Size = UDim2.fromScale(0.222, 0.0205),
	}, {
		SONGIMAGE = React.createElement("ImageLabel", {
			Image = SONG_INFO.Image,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.025, 0.067),
			Size = UDim2.fromScale(0.208, 0.867),
		}, {
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0.125, 0),
			}),
		}),

		UICorner1 = React.createElement("UICorner", {
			CornerRadius = UDim.new(0.125, 0),
		}),

		SONGNAME = React.createElement("TextLabel", {
			FontFace = Font.new(
				"rbxasset://fonts/families/GothamSSm.json",
				Enum.FontWeight.Bold,
				Enum.FontStyle.Normal
			),
			Text = props.SONG_NAME,
			TextColor3 = Color3.fromRGB(233, 233, 233),
			TextScaled = true,
			TextSize = 14,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Bottom,
			BackgroundColor3 = Color3.fromRGB(55, 55, 55),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.277, 0.0543),
			Size = UDim2.fromOffset(134, 12),
		}),

		ARTISTNAME = React.createElement("TextLabel", {
			FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
			Text = SONG_INFO.Artist,
			TextColor3 = Color3.fromRGB(233, 233, 233),
			TextScaled = true,
			TextSize = 14,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			BackgroundColor3 = Color3.fromRGB(55, 55, 55),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.277, 0.348),
			Size = UDim2.fromOffset(134, 12),
		}),

		PLAYBUTTON = React.createElement("TextButton", {
			FontFace = Font.new(
				"rbxasset://fonts/families/GothamSSm.json",
				Enum.FontWeight.Bold,
				Enum.FontStyle.Normal
			),
			Text = "PLAY",
			TextColor3 = Color3.fromRGB(233, 233, 233),
			TextScaled = true,
			TextSize = 14,
			TextWrapped = true,
			BackgroundColor3 = Color3.fromRGB(85, 170, 127),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.741, 0.6),
			Size = UDim2.fromScale(0.213, 0.281),
			[React.Event.Activated] = function()
				if tick() - SONG_ITEM_DEBOUNCE >= 5 then
					SONG_ITEM_DEBOUNCE = tick()
					print(props.SONG_NAME)
					MUSIC_CONTROLLER:PlayMusic(AUDIO.Music[props.SONG_NAME])
				else
					Resonate:PlaySound('error')
				end
			end,
		}, {
			UICorner2 = React.createElement("UICorner", {
				CornerRadius = UDim.new(0.5, 0),
			}),

			UIPadding = React.createElement("UIPadding", {
				PaddingBottom = UDim.new(0.05, 0),
				PaddingLeft = UDim.new(0.05, 0),
				PaddingRight = UDim.new(0.05, 0),
				PaddingTop = UDim.new(0.05, 0),
			}),
		}),
	})
end

local MUSIC_CONTAINERS = {}	

for i,v in AUDIO.Music do

	MUSIC_CONTAINERS[i] = React.createElement(SONG_ITEM, {
		key = i,
		SONG_INFO = v,
		SONG_NAME = i
	})
end

local function Holder()
	local currentTime, setCurrentTime = React.useState("00:00")
	local endTime, setEndTime = React.useState('00:00')
	
	local songName, setSongName = React.useState('None')
	local artistName, setArtistName = React.useState('None')
	local songImage, setSongImage = React.useState('None')

	React.useEffect(function()
		local function updateTimes()
			setCurrentTime(formatTime(MUSIC_INSTANCE.TimePosition))
			setEndTime(formatTime(MUSIC_INSTANCE.TimeLength))
		end
		
		setSongName(MUSIC_CONTROLLER:GetTrackInfo().Name)
		setArtistName(MUSIC_CONTROLLER:GetTrackInfo().Artist)
		setSongImage(MUSIC_CONTROLLER:GetTrackInfo().Image)

		-- Initial update
		updateTimes()

		-- Update every second using a task
		local updateTask = nil
		updateTask = task.spawn(function()
			while true do
				updateTimes()
				task.wait(1)
			end
		end)

		-- Cleanup
		return function()
			if updateTask then
				updateTask:Cancel()
			end
		end
	end, {}) -- Empty dependency array since we're not depending on props or state changes
	
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

		MUSICSCROLLINGFRAME = React.createElement("ScrollingFrame", {
			CanvasSize = UDim2.fromScale(0, 4),
			ScrollBarImageColor3 = Color3.fromRGB(0, 85, 127),
			ScrollBarThickness = 6,
			Active = true,
			BackgroundColor3 = Color3.fromRGB(11, 11, 11),
			BackgroundTransparency = 0.25,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.0222, 0.265),
			Size = UDim2.fromScale(0.954, 0.705),
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				Padding = UDim.new(0.005, 0),
				Wraps = true,
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
			}),

			UIPadding = React.createElement("UIPadding", {
				PaddingBottom = UDim.new(0.005, 0),
				PaddingLeft = UDim.new(0.025, 0),
				PaddingRight = UDim.new(0.025, 0),
				PaddingTop = UDim.new(0.005, 0),
			}),
			
			React.createElement(React.Fragment, nil, MUSIC_CONTAINERS)

			
		}),

		CURRENTLYPLAYING = React.createElement("Frame", {
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 0.25,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.0216, 0.0441),
			Size = UDim2.fromScale(0.955, 0.202),
		}, {
			CONTINUE = React.createElement("TextButton", {
				FontFace = Font.new(
					"rbxasset://fonts/families/GothamSSm.json",
					Enum.FontWeight.Bold,
					Enum.FontStyle.Normal
				),
				Text = "STOP/START",
				TextColor3 = Color3.fromRGB(233, 233, 233),
				TextScaled = true,
				TextSize = 14,
				TextWrapped = true,
				BackgroundColor3 = Color3.fromRGB(85, 170, 127),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = UDim2.fromScale(0.43, 0.582),
				Size = UDim2.fromScale(0.142, 0.13),
				[React.Event.Activated] = function()
					MUSIC_CONTROLLER:Toggle()
				end,
			}, {
				UIPadding1 = React.createElement("UIPadding", {
					PaddingBottom = UDim.new(0.025, 0),
					PaddingLeft = UDim.new(0.025, 0),
					PaddingRight = UDim.new(0.025, 0),
					PaddingTop = UDim.new(0.025, 0),
				}),

				UICorner4 = React.createElement("UICorner", {
					CornerRadius = UDim.new(1, 0),
				}),
			}),

			SongImage = React.createElement("ImageLabel", {
				Image = songImage,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = UDim2.fromScale(0.0249, 0.0765),
				Size = UDim2.fromScale(0.103, 0.831),
			}, {
				UICorner1 = React.createElement("UICorner", {
					CornerRadius = UDim.new(0.125, 0),
				}),
			}),

			SONGNAME = React.createElement("TextLabel", {
				FontFace = Font.new(
					"rbxasset://fonts/families/GothamSSm.json",
					Enum.FontWeight.Bold,
					Enum.FontStyle.Normal
				),
				Text = songName,
				TextColor3 = Color3.fromRGB(233, 233, 233),
				TextScaled = true,
				TextSize = 14,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Bottom,
				BackgroundColor3 = Color3.fromRGB(55, 55, 55),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = UDim2.fromScale(0.15, 0.0765),
				Size = UDim2.fromOffset(247, 13),
			}),

			LOADINGHOLDER = React.createElement("Frame", {
				BackgroundColor3 = Color3.fromRGB(34, 34, 34),
				BackgroundTransparency = 0.55,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = UDim2.fromScale(0.15, 0.798),
				Size = UDim2.fromScale(0.74, 0.109),
			}, {
				UICorner2 = React.createElement("UICorner", {
					CornerRadius = UDim.new(1, 0),
				}),

				PROGRESS = React.createElement("Frame", {
					BackgroundColor3 = Color3.fromRGB(233, 233, 233),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Size = UDim2.fromScale(MUSIC_INSTANCE.TimePosition / MUSIC_INSTANCE.TimeLength, 1),
				}, {
					UICorner3 = React.createElement("UICorner", {
						CornerRadius = UDim.new(1, 0),
					}),
				}),
			}),

			ARTISTNAME = React.createElement("TextLabel", {
				FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
				Text = artistName,
				TextColor3 = Color3.fromRGB(233, 233, 233),
				TextScaled = true,
				TextSize = 14,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				BackgroundColor3 = Color3.fromRGB(55, 55, 55),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = UDim2.fromScale(0.15, 0.223),
				Size = UDim2.fromOffset(247, 13),
			}),

			SONGSTART = React.createElement("TextLabel", {
				FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
				Text = currentTime,
				TextColor3 = Color3.fromRGB(233, 233, 233),
				TextScaled = true,
				TextSize = 14,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				BackgroundColor3 = Color3.fromRGB(55, 55, 55),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = UDim2.fromScale(0.15, 0.591),
				Size = UDim2.fromScale(0.563, 0.12),
			}),

			SONGEND = React.createElement("TextLabel", {
				FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
				Text = endTime,
				TextColor3 = Color3.fromRGB(233, 233, 233),
				TextScaled = true,
				TextSize = 14,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Right,
				TextYAlignment = Enum.TextYAlignment.Top,
				BackgroundColor3 = Color3.fromRGB(55, 55, 55),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = UDim2.fromScale(0.15, 0.591),
				Size = UDim2.fromScale(0.744, 0.12),
			}),
		}),
	})
end

return Holder