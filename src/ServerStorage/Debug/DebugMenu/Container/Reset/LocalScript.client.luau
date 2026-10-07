local button = script.Parent -- Assuming the script is a child of the button

button.MouseButton1Click:Connect(function()
	local player = game.Players.LocalPlayer
	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")

	if humanoid then
		humanoid.Health = 0
	end
end)
