# Roblox-DialogsGUIModule

A ModuleScript for Roblox that allows for the quick and easy
creation of simple GUI dialog boxes.

There are currently 3 types of boxes that can be displayed.

Text response boxes:

![Text response](http://i.imgur.com/Bs4xsSL.png)

Confirmation boxes:

![Confirmation](http://i.imgur.com/yZbtsm7.png)

and Progress bar boxes:

![Progress](http://i.imgur.com/ugoWQ9B.png)


# Usage

#### This script is not standalone, it requires the actual GUI object structure that would be the child to the script object, which is not provided.

---

All module scripts are imported with the `require(src)` method:

`gui = require(workspace["ETB:DialogsModule2"])`

### To create a Text response box:

Set a local variable equal to the method `gui.popDialog_TextEntry(windowName, promptText, color, defaultText)`

The method returns a string value equal to the text entered into the box when the window is closed.

`local response = gui.popDialog_TextEntry("Enter name", "Enter name:", gui.Colors.Yellow, "Mittens"])`

### To create a confirmation box:

Set a local variable equal to the method `gui.popDialog_YesNo(windowName, "promptText", color)`

`local choice = gui.popDialog_YesNo("Check", "Are you sure: Mittens?", gui.Colors.Red)`

The method returns an integer value either 1, 0, or -99, 1 for yes, 0 for no, -99 for window close.

### To create a Progress bar box:

We need to create a reference variable in LUA. To do so, we can create a table and use the value
inside the table as the reference variable because LUA treats tables as reference objects.

Then call the method `gui.popDialog_Progress(windowName, description, color, table)`

```
local float = {0.0}
gui.popDialog_Progress("Loading", "Spawning cat Mittens...", gui.Colors.Blue, float)
```

The progress bar automatically updates based on the value of the reference table value `table[1]` from 0.00 to 1.00.

`float[1] = 0.67`

To conclude progress, simply set the value to 1.0 and the progress bar box will close:

`float[1] = 1`

