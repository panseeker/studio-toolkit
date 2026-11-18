local Util = require(script.Parent.Parent.Util)

local random = Random.new()

local tool: Util.Tool = {
	name = "Randomize Rotation",
	description = "Spins each selected part or model to a random angle around the world Y axis. Great for trees and rocks.",

	run = function(selection)
		local items = Util.getMovables(selection)
		if #items == 0 then
			error("Select at least one part or model.", 0)
		end

		for _, item in items do
			local pivot = item:GetPivot()
			local spin = CFrame.Angles(0, random:NextNumber(0, 2 * math.pi), 0)
			item:PivotTo(CFrame.new(pivot.Position) * spin * pivot.Rotation)
		end

		return `Rotated {Util.plural(#items, "object")}.`
	end,
}

return tool
