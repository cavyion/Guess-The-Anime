local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ByteNet = require(ReplicatedStorage.Packages["@ffrostfall"].ByteNet)

return ByteNet.defineNamespace("messaging", function()
	return {
		myPacket = ByteNet.definePacket({
			-- This value field is very important!
			value = ByteNet.struct({
				message = ByteNet.string,
			})
		}),
		OpenDoor = ByteNet.definePacket({
			value = ByteNet.struct({
				activate = ByteNet.bool,
				plr = ByteNet.int32
			}),
		}),
		PlayerReady = ByteNet.definePacket({
			value = ByteNet.struct({
				IsReady = ByteNet.bool
			})
		}),
		Conjure = ByteNet.definePacket({
			value = ByteNet.struct({
				Task = ByteNet.string,
				Companion = ByteNet.string
			})
		}),
		Spin = ByteNet.definePacket({
			value = ByteNet.struct({
				Task = ByteNet.nothing,
			})
		}),
		SpinResult = ByteNet.definePacket({
			value = ByteNet.struct({
				Companion = ByteNet.string,
				Duplicate = ByteNet.int32
			})
		})
	}
end)