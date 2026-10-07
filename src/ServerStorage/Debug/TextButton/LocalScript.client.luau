local DebugMenu = script.Parent.Parent.DebugMenu

script.Parent.MouseButton1Click:Connect(function()
	DebugMenu.Visible = not DebugMenu.Visible
end)