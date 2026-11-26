local Util = require(script.Parent.Parent.Util)

local tool: Util.Tool = {
	name = "Copy Look",
	description = "Copies color, material and transparency from the first selected part to the others.",

	run = function(selection)
		local source = selection[1]
		if not source or not source:IsA("BasePart") then
			error("First select the part to copy the look from.", 0)
		end

		local count = 0
		for _, part in Util.getParts(selection) do
			if part ~= source then
				part.Color = source.Color
				part.Material = source.Material
				part.MaterialVariant = source.MaterialVariant
				part.Transparency = source.Transparency
				count += 1
			end
		end

		if count == 0 then
			error("Select at least 2 parts.", 0)
		end

		return `Copied the look of {source.Name} to {Util.plural(count, "part")}.`
	end,
}

return tool
