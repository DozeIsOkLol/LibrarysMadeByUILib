-- =================================================================================================
-- XP_UI Example for v2.6
-- =================================================================================================

-- Step 1: Load the Library
local success, library = pcall(function()
	return loadstring(
		game:HttpGet(
			'https://raw.githubusercontent.com/DozeIsOkLol/LibrarysMadeByUILib/main/WinXP/Source.lua'
		)
	)()
end)

-- [NEW] Add a check to make sure the library loaded correctly
if not success or not library then
	warn(
		'XP_UI Error: The library failed to load. The error was: '
			.. tostring(library)
	)
	return -- Stop the script if the library fails
end

local XP_UI = library

-- Step 2: Create the Main Window
local Window = XP_UI:CreateWindow({
	Title = 'My Application',
})

-- Step 3: Create Menu Tabs
local FileTab = Window:CreateMenuTab('File')
local EditTab = Window:CreateMenuTab('Edit')
local ViewTab = Window:CreateMenuTab('View')

----------------------------------------------------
-- "File" Tab Content
----------------------------------------------------
FileTab:AddLabel('This is the File menu.')
FileTab:AddButton({
	Name = 'Save',
	Callback = function()
		print('File -> Save clicked!')
	end,
})
FileTab:AddButton({
	Name = 'Load',
	Callback = function()
		print('File -> Load clicked!')
	end,
})

----------------------------------------------------
-- "Edit" Tab Content
----------------------------------------------------
EditTab:AddLabel('This is the Edit menu.')
EditTab:AddToggle({
	Name = 'Enable Autosave',
	Callback = function(value)
		print('Autosave is now: ' .. tostring(value))
	end,
})

----------------------------------------------------
-- "View" Tab Content
----------------------------------------------------
ViewTab:AddLabel('This is the View menu. No items here yet.')

-- You can add a keybind to toggle the UI's visibility
local UserInputService = game:GetService('UserInputService')
local TOGGLE_KEY = Enum.KeyCode.RightControl

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed and input.KeyCode == TOGGLE_KEY then
		Window:Toggle()
	end
end)
