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

#### This script is not not intended to be cloned and is therefore not standalone, it requires the actual GUI object structure that would be the child to the script object wich is not provided.

---

All module scripts are imported with the `require(src)` method:

`gui = require(workspace["ETB:DialogsModule2"])`

### To display a Text response box:


The popDialog_TextEntry method returns a string value equal to the text entered into the box when the window is closed.

`local input = gui.popDialog_TextEntry("Gimme", "Enter a name for the new cat:", gui.Colors.Yellow, "Mittens")`

### To display a confirmation box:

The popDialog_YesNo method returns an integer value either 1, 0, or -99, 1 for yes, 0 for no, -99 for window close.

`local choice = gui.popDialog_YesNo("Check", "Are you sure you want to name the cat Mittens?", gui.Colors.Red)`

### To display a Progress bar box:

We need to create a reference variable in LUA. To do so, we can create a table and use the value
inside the table as the reference variable because LUA treats tables as reference objects.

```
local float = {0.0}
gui.popDialog_Progress("Loading", "Spawning cat Mittens...", gui.Colors.Blue, float)
```

The progress bar automatically updates based on the value of the reference table value `table[1]` from 0.00 to 1.00.

`float[1] = 0.67`

To conclude progress, simply set the value to 1.0 and the progress bar box will close:

`float[1] = 1`

