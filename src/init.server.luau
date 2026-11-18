--[[
	Studio Toolkit - entry point.

	Loads every tool in the Tools folder, shows them in a dock widget and runs
	the clicked tool on the current selection with undo support.

	You don't need to touch this file to add a tool. See CONTRIBUTING.md.
]]

local ChangeHistoryService = game:GetService("ChangeHistoryService")
local Selection = game:GetService("Selection")

local Ui = require(script.Ui)
local Util = require(script.Util)

local PREFIX = "[Studio Toolkit]"

local function loadTools(): { Util.Tool }
	local tools = {}

	for _, module in script.Tools:GetChildren() do
		if not module:IsA("ModuleScript") then
			continue
		end

		local ok, result = pcall(require, module)
		if not ok then
			warn(`{PREFIX} Failed to load tool "{module.Name}": {result}`)
			continue
		end

		if type(result) ~= "table" or type(result.name) ~= "string" or type(result.run) ~= "function" then
			warn(`{PREFIX} Tool "{module.Name}" must return a table with name, description and run.`)
			continue
		end

		table.insert(tools, result)
	end

	table.sort(tools, function(a, b)
		return a.name < b.name
	end)

	return tools
end

-- Runs a tool as a single undo step. If the tool errors, its changes are reverted.
local function runTool(tool: Util.Tool): (boolean, string)
	local recording = ChangeHistoryService:TryBeginRecording(tool.name)
	local ok, result = pcall(tool.run, Selection:Get())

	if recording then
		ChangeHistoryService:FinishRecording(
			recording,
			if ok then Enum.FinishRecordingOperation.Commit else Enum.FinishRecordingOperation.Cancel
		)
	end

	if ok then
		return true, if type(result) == "string" then result else `{tool.name}: done.`
	end
	return false, tostring(result)
end

local toolbar = plugin:CreateToolbar("Studio Toolkit")
local button = toolbar:CreateButton("Toolkit", "Open Studio Toolkit", "")
button.ClickableWhenViewportHidden = true

local widget = plugin:CreateDockWidgetPluginGui(
	"StudioToolkit",
	DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Right, false, false, 280, 420, 220, 200)
)
widget.Name = "StudioToolkit"
widget.Title = "Studio Toolkit"

button.Click:Connect(function()
	widget.Enabled = not widget.Enabled
end)

widget:GetPropertyChangedSignal("Enabled"):Connect(function()
	button:SetActive(widget.Enabled)
end)

Ui.mount(widget, loadTools(), runTool)
