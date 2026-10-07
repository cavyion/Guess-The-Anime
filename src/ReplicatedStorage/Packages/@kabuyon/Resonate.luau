local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Orbit = require(ReplicatedStorage.Packages["@kabuyon"].Orbit)
local Maid = Orbit("Maid")
local Audio = require(ReplicatedStorage:WaitForChild("Assets").Audio.Audio)

local Resonate = {}

-- We must find if the player has SFX enabled

function Resonate:PlaySound(soundName, player)
	if RunService:IsServer() then		
		if not player then
			return
		end
		
		local playerSFXFolder = player:WaitForChild("ClientAudio").SFX
		local PlayerMusicInstance = player:WaitForChild('ClientAudio').Music
		
		local ClientSettings = player:WaitForChild('ClientSettings')
		local SFX_BOOL = ClientSettings:WaitForChild('SFX_BOOL')
		
		if SFX_BOOL.Value == false then
			return
		end
		
		local soundData = Audio.SFX[soundName]
		if not soundData then
			warn("Sound ID not found for " .. soundName)
			return
		end
		
		local soundInstance = Instance.new("Sound")
		
		soundInstance.SoundId = soundData.SoundId
		soundInstance.Volume = soundData.Volume or 1
		soundInstance.Parent = playerSFXFolder
		soundInstance.TimePosition = 0
		soundInstance:Play()

		local maid = Maid.new()
		maid:GiveTask(soundInstance)

		
		soundInstance.Ended:Connect(function()
			task.wait(soundInstance.TimeLength)
			maid:DoCleaning()
		end)
		
	elseif RunService:IsClient() then
		player = game.Players.LocalPlayer
		if not player then
			return
		end
		
		local playerSFXFolder = player:WaitForChild("ClientAudio").SFX
		local PlayerMusicInstance = player:WaitForChild('ClientAudio').Music
		
		local ClientSettings = player:WaitForChild('ClientSettings')
		local SFX_BOOL = ClientSettings:WaitForChild('SFX_BOOL')

		if SFX_BOOL.Value == false then
			return
		end
		
		local soundData = Audio.SFX[soundName]
		if not soundData then
			warn("Sound ID not found for " .. soundName)
			return
		end

		local soundInstance = Instance.new("Sound")
		
		soundInstance.SoundId = soundData.SoundId
		soundInstance.Volume = soundData.Volume or 1
		soundInstance.Parent = playerSFXFolder
		soundInstance.TimePosition = 0
		soundInstance:Play()

		-- Clean up the sound instance using Maid
		local maid = Maid.new()
		maid:GiveTask(soundInstance)
		
		soundInstance.Ended:Connect(function()
			task.wait(soundInstance.TimeLength)
			maid:DoCleaning()
		end)
		
	end
end

return Resonate
