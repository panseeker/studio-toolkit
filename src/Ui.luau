--[[
	Builds the widget: a scrolling list of tool cards and a status bar.
	Colors follow the Studio theme (light or dark).
]]

local Util = require(script.Parent.Util)

local Studio = settings().Studio
local Color = Enum.StudioStyleGuideColor
local Modifier = Enum.StudioStyleGuideModifier

local STATUS_HEIGHT = 36

local Ui = {}

function Ui.mount(widget: DockWidgetPluginGui, tools: { Util.Tool }, onRun: (Util.Tool) -> (boolean, string))
	-- Every themed property is registered here so it can be recolored when the theme changes.
	local themed: { { instance: Instance, property: string, color: Enum.StudioStyleGuideColor } } = {}

	local function theme(instance: Instance, property: string, color: Enum.StudioStyleGuideColor)
		local entry = { instance = instance, property = property, color = color }
		table.insert(themed, entry)
		return entry
	end

	local function applyTheme()
		for _, entry in themed do
			(entry.instance :: any)[entry.property] = Studio.Theme:GetColor(entry.color, Modifier.Default)
		end
	end

	local function pad(parent: Instance, vertical: number, horizontal: number)
		local padding = Instance.new("UIPadding")
		padding.PaddingTop = UDim.new(0, vertical)
		padding.PaddingBottom = UDim.new(0, vertical)
		padding.PaddingLeft = UDim.new(0, horizontal)
		padding.PaddingRight = UDim.new(0, horizontal)
		padding.Parent = parent
	end

	local function label(text: string, font: Enum.Font, size: number, color: Enum.StudioStyleGuideColor): TextLabel
		local textLabel = Instance.new("TextLabel")
		textLabel.BackgroundTransparency = 1
		textLabel.Size = UDim2.fromScale(1, 0)
		textLabel.AutomaticSize = Enum.AutomaticSize.Y
		textLabel.Font = font
		textLabel.TextSize = size
		textLabel.TextWrapped = true
		textLabel.TextXAlignment = Enum.TextXAlignment.Left
		textLabel.Text = text
		theme(textLabel, "TextColor3", color)
		return textLabel
	end

	local root = Instance.new("Frame")
	root.Size = UDim2.fromScale(1, 1)
	root.BorderSizePixel = 0
	theme(root, "BackgroundColor3", Color.MainBackground)

	local list = Instance.new("ScrollingFrame")
	list.Size = UDim2.new(1, 0, 1, -STATUS_HEIGHT)
	list.BackgroundTransparency = 1
	list.BorderSizePixel = 0
	list.ScrollBarThickness = 6
	list.CanvasSize = UDim2.new()
	list.AutomaticCanvasSize = Enum.AutomaticSize.Y
	theme(list, "ScrollBarImageColor3", Color.ScrollBar)
	pad(list, 8, 8)
	list.Parent = root

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 6)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = list

	local status = label("Select something, then click a tool.", Enum.Font.SourceSans, 14, Color.DimmedText)
	status.AutomaticSize = Enum.AutomaticSize.None
	status.Size = UDim2.new(1, 0, 0, STATUS_HEIGHT)
	status.Position = UDim2.new(0, 0, 1, -STATUS_HEIGHT)
	status.BackgroundTransparency = 0
	status.BorderSizePixel = 0
	theme(status, "BackgroundColor3", Color.Titlebar)
	local statusColor = theme(status, "TextColor3", Color.DimmedText)
	pad(status, 4, 10)
	status.Parent = root

	local function setStatus(ok: boolean, message: string)
		status.Text = message
		statusColor.color = if ok then Color.MainText else Color.ErrorText
		applyTheme()
	end

	for index, tool in tools do
		local card = Instance.new("TextButton")
		card.Name = tool.name
		card.Text = ""
		card.AutoButtonColor = true
		card.Size = UDim2.fromScale(1, 0)
		card.AutomaticSize = Enum.AutomaticSize.Y
		card.LayoutOrder = index
		card.BorderSizePixel = 1
		theme(card, "BackgroundColor3", Color.Button)
		theme(card, "BorderColor3", Color.ButtonBorder)
		pad(card, 6, 8)

		local cardLayout = Instance.new("UIListLayout")
		cardLayout.Padding = UDim.new(0, 2)
		cardLayout.SortOrder = Enum.SortOrder.LayoutOrder
		cardLayout.Parent = card

		local title = label(tool.name, Enum.Font.SourceSansBold, 16, Color.ButtonText)
		title.LayoutOrder = 1
		title.Parent = card

		local description = label(tool.description or "", Enum.Font.SourceSans, 14, Color.DimmedText)
		description.LayoutOrder = 2
		description.Parent = card

		card.Activated:Connect(function()
			setStatus(onRun(tool))
		end)

		card.Parent = list
	end

	if #tools == 0 then
		label("No tools found. Check the Output window for errors.", Enum.Font.SourceSans, 14, Color.ErrorText).Parent =
			list
	end

	applyTheme()
	Studio.ThemeChanged:Connect(applyTheme)
	root.Parent = widget
end

return Ui
