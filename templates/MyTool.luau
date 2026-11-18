-- Copy this file to src/Tools/YourToolName.luau and fill it in.
-- See CONTRIBUTING.md for the full guide.

local Util = require(script.Parent.Parent.Util)

local tool: Util.Tool = {
	-- Short name shown on the button.
	name = "My Tool",

	-- One sentence that explains what the tool does.
	description = "Does something useful with the selected parts.",

	-- `selection` is the list of things the user has selected in Studio.
	run = function(selection)
		-- Util.getParts gives you every part, including parts inside models.
		-- Use Util.getMovables instead if you want to move or rotate whole models.
		local parts = Util.getParts(selection)
		if #parts == 0 then
			-- error(message, 0) shows the message in red and undoes your changes.
			error("Select at least one part or model.", 0)
		end

		for _, part in parts do
			-- Change the part here, e.g. part.Transparency = 0.5
		end

		-- This text appears in the status bar at the bottom of the widget.
		return `Changed {Util.plural(#parts, "part")}.`
	end,
}

return tool
