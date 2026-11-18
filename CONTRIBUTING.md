# Contributing to Studio Toolkit

Thanks for helping! This guide assumes you have never contributed to an open-source project before.
If something here is unclear, open an issue and ask; that's a useful contribution too.

## How a tool works

Every tool is one file in [`src/Tools/`](src/Tools). The plugin finds it automatically, so you don't need to register it anywhere.

A tool is a table with three things:

```lua
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
```

- **`name`**: the short title on the button.
- **`description`**: one sentence explaining what it does.
- **`run(selection)`**: does the work. `selection` is the list of things selected in Studio.
  - Return a short message, and it shows in the status bar.
  - Call `error("message", 0)` if something is wrong. The message shows in red and your changes are undone.
  - You don't need to handle undo. The whole tool becomes one Ctrl+Z step automatically.

Helpers in [`src/Util.luau`](src/Util.luau):

| Helper | Gives you |
|---|---|
| `Util.getParts(selection)` | Every part in the selection, including parts inside models and folders. |
| `Util.getMovables(selection)` | Selected parts and models, for moving or rotating with `GetPivot` / `PivotTo`. |
| `Util.plural(3, "part")` | `"3 parts"` |

## Step by step: adding a tool

### 1. Pick an issue
Find an issue labeled **good first issue** or **new tool** and leave a comment like "I'd like to work on this",
so two people don't build the same thing. You can also suggest your own tool by opening a new issue.

### 2. Fork the repository
Click **Fork** at the top right of this page. You now have your own copy of the project.

### 3. Add your file
The easiest way needs only your browser:

1. In **your fork**, open the `src/Tools` folder.
2. Click **Add file → Create new file**.
3. Name it after your tool, without spaces, like `SnapToGround.luau`.
4. Paste the contents of [`templates/MyTool.luau`](templates/MyTool.luau) and fill it in.
5. Click **Commit changes**.

If you prefer working locally, clone your fork with Git and edit in any editor.

### 4. Test it in Studio
Please test before you send it. Pick one of these:

**Option A, with Rojo (recommended):**
1. Install [Rokit](https://github.com/rojo-rbx/rokit) or [Aftman](https://github.com/LPGhatguy/aftman), then run `rokit install` (or `aftman install`) in the project folder.
2. Run `rojo build --plugin StudioToolkit.rbxm`. This puts the plugin straight into your Studio plugins folder.
3. Restart Studio and try your tool.

**Option B, without installing anything:**
1. In Studio, insert a **Script** into `ServerStorage` and name it `StudioToolkit`. Paste in `src/init.server.luau`.
2. Inside that Script, add two **ModuleScripts** named `Ui` and `Util`, and paste in `src/Ui.luau` and `src/Util.luau`.
3. Inside that Script, add a **Folder** named `Tools`. Inside it, add one ModuleScript per file in `src/Tools/`, including yours.
4. Right-click the `StudioToolkit` Script and choose **Save as Local Plugin**.

Check that:
- the tool does what it says,
- **Ctrl+Z** undoes it in one step,
- it shows a clear message when nothing (or the wrong thing) is selected.

### 5. Open a pull request
1. Go to your fork on GitHub. You'll see a **Contribute → Open pull request** button.
2. Write what your change does. If it finishes an issue, write `Closes #12` (with the real number).
3. Click **Create pull request**.

An automatic check builds the plugin. If it fails, click **Details** to see why.
A maintainer will review your change and may ask for small fixes. That's normal and nothing to worry about.

## Style

- Tabs for indentation.
- Tool files are named in `PascalCase`, like `SnapToGround.luau`.
- Keep a tool focused: one tool does one thing.
- User-facing text is in English.

## Not just code

These help a lot too:
- Report a bug or confusing behavior.
- Improve this guide or the README.
- Add a screenshot or GIF of a tool in action.
