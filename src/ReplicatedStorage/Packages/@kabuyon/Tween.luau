local TweenService = game:GetService("TweenService")

return function(object, goal, totalTime, easingStyle, easingDirection)
	local Info = TweenInfo.new(
		totalTime,
		easingStyle,
		easingDirection
	)
	return TweenService:Create(object, Info, {Position = goal})
end