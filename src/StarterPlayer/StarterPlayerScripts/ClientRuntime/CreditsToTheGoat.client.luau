--[[
print message

	@Tsunova's "Guess That Anime!"
	Last Updated: 0000/00/00
	Version: game.PlaceVersion
	
	Info:
		VersionNumber:
		vXXX.YYY.ZZZ
			x - Major ( Alpha, Beta, 1 )
			y - Minor ( game.PlaceVersion )
			z - Bug Fix ( Minor-100 )
	when y moves up, z fixes go to 0
	v1.1.5 -> v1.2.0
	
	Unicodes:
	U+2800
]]
--		// Services
local MS = 					game:GetService("MarketplaceService")
--		// Info
local plr = 						game.Players.LocalPlayer
local currentversion = game.PlaceId > 0 and tostring(game.PlaceVersion) or "Studio"
local isoDate = game.PlaceId > 0 and "unavailable" or "unpublished"

if game.PlaceId > 0 then
	local success, info = pcall(function()
		return MS:GetProductInfo(game.PlaceId)
	end)
	if success and type(info) == "table" and type(info.Updated) == "string" then
		local dateSuccess, formattedDate = pcall(function()
			return DateTime.fromIsoDate(info.Updated):FormatLocalTime("LLL", "ja-jp")
		end)
		if dateSuccess then
			isoDate = string.gsub(formattedDate, "%s+", "")
		end
	end
end
--		// Print
print("\n\n",plr.Name.."/"..script.Parent.Name.."/Credits.lua/\n\n","·⠀⠀game: Guess That Anime\n\n", "·⠀⠀creator: @kabuyon\n\n", "·⠀⠀bugs: twitter.com/@cavyion\n\n", "·⠀⠀link: roblox.com/games/8410558107\n\n", "·⠀⠀version: "..currentversion,"\n\n","·⠀⠀updated:"..isoDate,"\n\n".. "updates not guaranteed due to lack of interest.")
script:Destroy()
