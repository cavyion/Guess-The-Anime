local MusicController = {}
local Players = game:GetService("Players")
local Audio = require(game.ReplicatedStorage:WaitForChild("Assets").Audio.Audio) 

MusicController.CurrentTrackName = ""

local SoundProperties = {
	"ChannelCount",
	"IsLoaded",
	"IsPaused",
	"IsPlaying",
	"Looped",
	"PlayOnRemove",
	"PlaybackLoudness",
	"PlaybackSpeed",
	"Playing",
	"RollOffMaxDistance",
	"RollOffMinDistance",
	"RollOffMode",
	"SoundGroup",
	"SoundId",
	"TimeLength",
	"TimePosition",
	"Volume"
}

function MusicController:PickRandomMusic()
	local musicTracks = Audio.Music
	local keys = {}

	for key in pairs(musicTracks) do
		table.insert(keys, key)
	end

	local randomKey = keys[math.random(#keys)]
	self.CurrentTrackName = randomKey 
	return musicTracks[randomKey]
end

function MusicController:PlayMusic(musicTrack)
	if musicTrack then
		local player = Players.LocalPlayer
		local sound = player:WaitForChild("ClientAudio"):WaitForChild("Music")

		local soundProperties = musicTrack.SoundInstanceValues
		for _, propertyName in ipairs(SoundProperties) do
			if soundProperties[propertyName] ~= nil then
				sound[propertyName] = soundProperties[propertyName]
			else
				--warn(propertyName .. " property not found in SoundInstanceValues.")
			end
		end

		sound:Play()
	else
		warn("No music track provided.")
	end
end

function MusicController:GetCurrentTrackName()
	return self.CurrentTrackName
end

function MusicController:Toggle()
	local player = Players.LocalPlayer
	local sound = player:FindFirstChild("ClientAudio") and player.ClientAudio:FindFirstChild("Music")

	if sound and sound:IsA("Sound") then
		sound.Playing = not sound.Playing
	else
		warn("Music sound object not found or invalid.")
	end
end

function MusicController:GetTrackInfo()
	local currentTrackName = self.CurrentTrackName
	if currentTrackName then
		local musicTrack = Audio.Music[currentTrackName]
		if musicTrack then
			local trackInfo = {
				Name = currentTrackName,
				Artist = musicTrack.Artist,
				Album = musicTrack.Album,
				Image = musicTrack.Image,
				SoundProperties = musicTrack.SoundInstanceValues
			}
			return trackInfo
		else
			warn("Music track not found in Audio.Music table.")
		end
	else
		warn("No current track name set.")
	end
	return nil
end

local randomTrack = MusicController:PickRandomMusic()
if randomTrack then
	MusicController:PlayMusic(randomTrack)
else
	warn("Failed to pick or play random music track.")
end

return MusicController
