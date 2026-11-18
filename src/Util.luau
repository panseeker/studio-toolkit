--[[
	Shared helpers for tools. Use these instead of writing your own loops,
	so every tool treats the selection the same way.
]]

export type Tool = {
	-- Shown on the button. Keep it short, e.g. "Anchor All".
	name: string,
	-- One sentence shown under the name.
	description: string,
	-- Does the work. Return a short message for the status bar.
	-- Call error("message", 0) to show a problem; your changes are then undone.
	run: (selection: { Instance }) -> string?,
}

local Util = {}

-- Every BasePart in the selection, including parts inside selected models and folders.
-- Each part appears only once.
function Util.getParts(selection: { Instance }): { BasePart }
	local seen: { [BasePart]: boolean } = {}
	local parts: { BasePart } = {}

	local function add(instance: Instance)
		if instance:IsA("BasePart") and not seen[instance] then
			seen[instance] = true
			table.insert(parts, instance)
		end
	end

	for _, item in selection do
		add(item)
		for _, descendant in item:GetDescendants() do
			add(descendant)
		end
	end

	return parts
end

-- Selected parts and models that can be moved or rotated as a whole (with GetPivot / PivotTo).
function Util.getMovables(selection: { Instance }): { PVInstance }
	local movables: { PVInstance } = {}

	for _, item in selection do
		if item ~= workspace and (item:IsA("BasePart") or item:IsA("Model")) then
			table.insert(movables, item)
		end
	end

	return movables
end

-- Util.plural(1, "part") -> "1 part", Util.plural(3, "part") -> "3 parts"
function Util.plural(count: number, word: string): string
	return `{count} {word}{if count == 1 then "" else "s"}`
end

return Util
