local Util = require(script.Parent.Parent.Util)

local tool: Util.Tool = {
	name = "Anchor All",
	description = "Anchors every part in the selection, including parts inside models.",

	run = function(selection)
		local parts = Util.getParts(selection)
		if #parts == 0 then
			error("Select at least one part or model.", 0)
		end

		for _, part in parts do
			part.Anchored = true
		end

		return `Anchored {Util.plural(#parts, "part")}.`
	end,
}

return tool
