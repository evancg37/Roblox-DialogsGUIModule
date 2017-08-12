module = {}

d = script["ETB:Dialogs"]

module.Color_List = {"Red", "Orange", "Yellow", "Green", "Teal", "LightBlue", "Blue", "Purple"}

module.Colors = {
	Red = Color3.new(0.753, 0.176, 0.176), 
	Orange = Color3.new(0.846,0.535, 0),
	Yellow = Color3.new(0.961,0.804, 0.188),
	Green = Color3.new(0.234, 0.776, 0.212),
	Teal = Color3.new(0.247, 0.722, 0.745),
	LightBlue = Color3.new(0.290, 0.737, 0.828),
	Blue = Color3.new(0.071, 0.490, 0.855),
	Purple = Color3.new(0.694, 0.474, 0.69)
}

module.RANDOM_COLOR = -1
module.DEFAULT_COLOR = module.Colors.LightBlue

function module.colorGui(box, primary, secondary) --Takes a "Box" frame object and colors the components according to the color scheme.
	if primary == nil then primary = module.DEFAULT_COLOR end
	if primary == -1 then primary = module.Colors[module.Color_List[math.random(1, #module.Color_List)]] end

	box.Top.BackgroundColor3 = primary
	
	box.Content_Progress.Bar.BorderColor3 = primary
	box.Content_Progress.Bar.Solid.BackgroundColor3 = primary

	box.Content_TextEntry.EntryBar.BorderColor3 = primary
	box.Content_TextEntry.EntryBar.ButtonAccept.BorderColor3 = primary
	box.Content_TextEntry.Entry.BorderColor3 = primary
	
	box.Content_YesNo.ButtonLeft.BorderColor3 = primary
	box.Content_YesNo.ButtonRight.BorderColor3 = primary
end

function module.bindContent_YesNo(content, funcY, funcN) --Takes a content object for a YesNo dialog box and connects the buttons to their functions.
	content.ButtonLeft.MouseButton1Click:connect(funcY)
	content.ButtonRight.MouseButton1Click:connect(funcN)
end

function module.bindButtonsToExit(dialog, destructor, ...) --Takes a dialog and connects all given buttons to the dialog's destructor function.
	local buttons = {...}
	for _, button in pairs(buttons) do
		button.MouseButton1Click:connect(destructor)
	end
end

function module.createDialog_YesNo(title, info, color, funcY, funcN, funcX) --Creates and returns an ETB:Dialogs object for a YesNo dialog box.
	local dialog = d:Clone()
	local dialogDestructor = function() dialog:Destroy() end
	
	local box = dialog.Box
	module.colorGui(box, color)
	box.Top.Title.Text = title	
	
	local content = box.Content_YesNo
	content.Visible = true
	content.Info.Text = info	
	
	if funcY ~= nil and funcN ~= nil then
		module.bindContent_YesNo(content, funcY, funcN) end

	if funcX ~= nil then
		dialog.ButtonExit.MouseButton1Click:connect(funcX) end

	module.bindButtonsToExit(dialog, dialogDestructor, box.ButtonExit)
	
	return dialog
end

function module.createDialog_TextEntry(title, info, color, defaultText, funcA, clearOnExit)
	local dialog = d:Clone()
	local dialogDestructor = function () dialog:Destroy() end
	
	local box = dialog.Box
	module.colorGui(box, color)
	box.Top.Title.Text = title
	
	local content = box.Content_TextEntry
	content.Visible = true
	content.Info.Text = info
	
	if defaultText == nil then defaultText = "" end
	content.Entry.Text = defaultText
	
	if funcA ~= nil then content.EntryBar.ButtonAccept.MouseButton1Click:connect(funcA) end
	module.bindButtonsToExit(dialog, dialogDestructor, box.ButtonExit, content.EntryBar.ButtonAccept)
	
	if clearOnExit then
		module.ButtonExit.MouseButton1Click:connect(function() content.Entry.Text = "" end)
	end
	
	return dialog
end

function module.createDialog_Progress(title, info, color, float) --Float is a reference to a float variable that varies between 0 and 1, 1 being 100% progress.
	local dialog = d:Clone()
	local dialogDestructor = function() dialog:Destroy() end

	module.colorGui(dialog.Box, color)
	dialog.Box.Top.Title.Text = title
	local content = dialog.Box.Content_Progress
	content.Visible = true
	content.Info.Text = info
	
	module.bindButtonsToExit(dialog, dialogDestructor, dialog.Box.ButtonExit)
	
	--Progress bar loop
	spawn(function()
		while float[1] < 1 do
			wait()
			if dialog.Parent ~= nil then
				content.Bar.Solid.Size = UDim2.new(float[1], 0, 1, 0) 
			end
		end
		dialogDestructor()
	end)
	
	return dialog
end

function module.popDialog_YesNo(title, info, color) --Returns a value of 0 or 1 indicating the result of a YesNo dialog box. -99 indicates exit button.
--Synchronous function

	local value = -99

	local dialog = module.createDialog_YesNo(title, info, color, function() value = 1 end, function() value = 0 end)
	dialog.Parent = game.Players.LocalPlayer.PlayerGui
	
	while value == -99 do
		wait()
		if dialog.Parent == nil then break end
	end
	
	dialog:Destroy()
	return value
end

function module.popDialog_TextEntry(title, info, color, defaultText) --Pops up a dialog box for a text entry and returns the text when the window is closed.
	local dialog = module.createDialog_TextEntry(title, info, color, defaultText)
	dialog.Parent = game.Players.LocalPlayer.PlayerGui
	
	local entry = ""
	
	while true do
		if dialog.Parent == nil then break
		else
			entry = dialog.Box.Content_TextEntry.Entry.Text
		end
		wait()
	end
	
	return entry
end

function module.popDialog_Progress(title, info, color, float) --Pops up a dialog box on the player's screen for a progress bar and returns true when the progress bar is filled.
	local dialog = module.createDialog_Progress(title, info, color, float)
	dialog.Parent = game.Players.LocalPlayer.PlayerGui
end

return module
