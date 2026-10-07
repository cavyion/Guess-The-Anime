	--[[

		Why are you here? How do you see this?

	]]
--		Services
local Players =				game:GetService("Players")
local UserInputService = 	game:GetService("UserInputService")
local starterGui = 			game:GetService('StarterGui')
--		Player
local playerGUI = Players.LocalPlayer:WaitForChild("PlayerGui")
--		Remove
local coreCall do
	local MAX_RETRIES = 50
	local StarterGui = game:GetService('StarterGui')
	local RunService = game:GetService('RunService')
	function coreCall(method, ...)
		local result = {}
		for retries = 1, MAX_RETRIES do
			result = {pcall(StarterGui[method], StarterGui, ...)}
			if result[1] then
				break
			end
			RunService.Stepped:Wait()
		end
		return unpack(result)
	end
end
assert(coreCall('SetCore', 'ResetButtonCallback', false))