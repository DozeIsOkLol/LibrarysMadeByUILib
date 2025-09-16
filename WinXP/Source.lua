-- =================================================================================================
-- XP_UI Source Code (Version 2.6 - Readability & Syntax Fix)
--
-- CRITICAL FIX:
-- - The entire script has been reformatted to be clean and readable.
-- - This process has fixed a subtle syntax error that caused `loadstring()` to fail,
--   which resulted in the "attempt to call a nil value" error.
-- - The library now loads and functions correctly.
-- =================================================================================================

local XP_UI = {}
local Window = {}
Window.__index = Window

--[[ Colors & Fonts ]]--
local FONT = Enum.Font.Arial
local FONT_SIZE = 12
local COLOR_SCHEME = {
	MainBack = Color3.fromRGB(236, 233, 216),
	ContentBack = Color3.fromRGB(255, 255, 255),
	HeaderStart = Color3.fromRGB(0, 80, 239),
	HeaderEnd = Color3.fromRGB(60, 140, 255),
	Text = Color3.fromRGB(0, 0, 0),
	TextLight = Color3.fromRGB(255, 255, 255),
	BorderDark = Color3.fromRGB(130, 130, 130),
	ToolbarBack = Color3.fromRGB(239, 238, 234),
	ButtonHover = Color3.fromRGB(182, 208, 250),
	CloseRed = Color3.fromRGB(224, 67, 67)
}

-- Main function to create the window
function XP_UI:CreateWindow(config)
	local windowInstance = setmetatable({}, Window)

	-- State Management
	windowInstance.Title = config.Title or "My Application"
	windowInstance.MenuTabs = {}
	windowInstance.Visible = true
	windowInstance.IsMaximized = false
	windowInstance.IsMinimized = false
	windowInstance.OriginalProperties = {}

	-- Services
	local UserInputService = game:GetService("UserInputService")
	local RunService = game:GetService("RunService")

	-- Main ScreenGui
	local ScreenGui = Instance.new("ScreenGui")
	windowInstance.ScreenGui = ScreenGui
	ScreenGui.Name = "XP_UI_Window"
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
	ScreenGui.ResetOnSpawn = false
	ScreenGui.Parent = game:GetService("CoreGui")

	-- Main Frame
	local Main = Instance.new("Frame")
	windowInstance.MainFrame = Main
	Main.Name = "MainFrame"
	Main.Parent = ScreenGui
	Main.BackgroundColor3 = COLOR_SCHEME.HeaderStart
	Main.Position = UDim2.new(0.5, -300, 0.5, -200)
	Main.Size = UDim2.new(0, 600, 0, 400)
	Main.BorderSizePixel = 0
	Main.ClipsDescendants = true
	
	local InnerFrame = Instance.new("Frame", Main)
	InnerFrame.Size = UDim2.new(1, -2, 1, -2)
	InnerFrame.Position = UDim2.new(0, 1, 0, 1)
	InnerFrame.BackgroundColor3 = COLOR_SCHEME.MainBack
	InnerFrame.BorderSizePixel = 0

	-- Header (Title Bar)
	local Header = Instance.new("Frame", InnerFrame)
	Header.Name = "Header"
	Header.BackgroundColor3 = COLOR_SCHEME.HeaderStart
	Header.Size = UDim2.new(1, 0, 0, 28)
	Header.BorderSizePixel = 0
	
	local HeaderGradient = Instance.new("UIGradient", Header)
	HeaderGradient.Color = ColorSequence.new(COLOR_SCHEME.HeaderStart, COLOR_SCHEME.HeaderEnd)
	HeaderGradient.Rotation = 90
	
	local TitleIcon = Instance.new("ImageLabel", Header)
	TitleIcon.Image = "rbxassetid://13483329133"
	TitleIcon.BackgroundTransparency = 1
	TitleIcon.Position = UDim2.new(0, 5, 0.5, 0)
	TitleIcon.Size = UDim2.new(0, 16, 0, 16)
	TitleIcon.AnchorPoint = Vector2.new(0, 0.5)
	TitleIcon.ZIndex = 2
	
	local TitleLabel = Instance.new("TextLabel", Header)
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Size = UDim2.new(1, -100, 1, 0)
	TitleLabel.Position = UDim2.new(0, 25, 0, -1)
	TitleLabel.Font = FONT
	TitleLabel.Text = windowInstance.Title
	TitleLabel.TextColor3 = COLOR_SCHEME.TextLight
	TitleLabel.TextSize = FONT_SIZE
	TitleLabel.ZIndex = 2
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

	-- Control Buttons
	local function CreateControlButton(name, text, position)
		local Button = Instance.new("TextButton", Header)
		Button.Name = name
		Button.Size = UDim2.new(0, 22, 0, 21)
		Button.Position = UDim2.new(1, position, 0.5, 0)
		Button.AnchorPoint = Vector2.new(0.5, 0.5)
		Button.Font = Enum.Font.ArialBold
		Button.Text = text
		Button.TextSize = 14
		Button.TextColor3 = COLOR_SCHEME.TextLight
		Button.AutoButtonColor = false
		Button.ZIndex = 3
		local corner = Instance.new("UICorner", Button)
		corner.CornerRadius = UDim.new(0, 3)
		return Button
	end
	
	local CloseButton = CreateControlButton("Close", "X", -26)
	CloseButton.BackgroundColor3 = COLOR_SCHEME.CloseRed
	
	local MaximizeButton = CreateControlButton("Maximize", "□", -49)
	MaximizeButton.BackgroundColor3 = COLOR_SCHEME.HeaderEnd
	MaximizeButton.TextSize = 18
	
	local MinimizeButton = CreateControlButton("Minimize", "_", -72)
	MinimizeButton.BackgroundColor3 = COLOR_SCHEME.HeaderEnd

	-- Menu Bar
	local MenuBar = Instance.new("Frame", InnerFrame)
	windowInstance.MenuBar = MenuBar
	MenuBar.Name = "MenuBar"
	MenuBar.BackgroundColor3 = COLOR_SCHEME.ToolbarBack
	MenuBar.Position = UDim2.new(0, 0, 0, 28)
	MenuBar.Size = UDim2.new(1, 0, 0, 22)
	MenuBar.BorderSizePixel = 0
	
	local MenuLayout = Instance.new("UIListLayout", MenuBar)
	MenuLayout.FillDirection = Enum.FillDirection.Horizontal
	MenuLayout.Padding = UDim.new(0, 4)
	
	local MenuPadding = Instance.new("UIPadding", MenuBar)
	MenuPadding.PaddingLeft = UDim.new(0, 4)
	
	-- Static Toolbar
	local Toolbar = Instance.new("Frame", InnerFrame)
	Toolbar.Name = "Toolbar"
	Toolbar.BackgroundColor3 = COLOR_SCHEME.ToolbarBack
	Toolbar.Position = UDim2.new(0, 0, 0, 50)
	Toolbar.Size = UDim2.new(1, 0, 0, 34)
	Toolbar.BorderSizePixel = 0
	
	local TopBorder = Instance.new("Frame", Toolbar)
	TopBorder.BackgroundColor3 = Color3.fromRGB(196,196,196)
	TopBorder.BorderSizePixel = 0
	TopBorder.Size = UDim2.new(1, 0, 0, 1)
	
	local BottomBorder = Instance.new("Frame", Toolbar)
	BottomBorder.BackgroundColor3 = Color3.fromRGB(196,196,196)
	BottomBorder.BorderSizePixel = 0
	BottomBorder.Size = UDim2.new(1, 0, 0, 1)
	BottomBorder.Position = UDim2.new(0,0,1, -1)
	
	local BackIcon = Instance.new("ImageLabel", Toolbar); BackIcon.Image = "rbxassetid://13483329088"; BackIcon.BackgroundTransparency = 1; BackIcon.Position = UDim2.new(0, 8, 0.5, 0); BackIcon.Size = UDim2.new(0, 28, 0, 24); BackIcon.AnchorPoint = Vector2.new(0, 0.5)
	local SearchIcon = Instance.new("ImageLabel", Toolbar); SearchIcon.Image = "rbxassetid://13483329199"; SearchIcon.BackgroundTransparency = 1; SearchIcon.Position = UDim2.new(0, 90, 0.5, 0); SearchIcon.Size = UDim2.new(0, 28, 0, 24); SearchIcon.AnchorPoint = Vector2.new(0, 0.5)
	local FoldersIcon = Instance.new("ImageLabel", Toolbar); FoldersIcon.Image = "rbxassetid://13483329149"; FoldersIcon.BackgroundTransparency = 1; FoldersIcon.Position = UDim2.new(0, 125, 0.5, 0); FoldersIcon.Size = UDim2.new(0, 28, 0, 24); FoldersIcon.AnchorPoint = Vector2.new(0, 0.5)
	
	-- Static Address Bar
	local AddressBar = Instance.new("Frame", InnerFrame)
	AddressBar.Name = "AddressBar"
	AddressBar.BackgroundColor3 = COLOR_SCHEME.ToolbarBack
	AddressBar.Position = UDim2.new(0, 0, 0, 84)
	AddressBar.Size = UDim2.new(1, 0, 0, 24)
	AddressBar.BorderSizePixel = 0
	
	local AddressLabel = Instance.new("TextLabel", AddressBar)
	AddressLabel.Text = "Address"
	AddressLabel.Font = FONT
	AddressLabel.TextSize = FONT_SIZE
	AddressLabel.BackgroundTransparency=1
	AddressLabel.Size=UDim2.new(0,50,1,0)
	AddressLabel.Position = UDim2.new(0,8,0,0)
	AddressLabel.TextColor3 = Color3.fromRGB(100,100,100)
	
	local AddressInput = Instance.new("Frame", AddressBar)
	AddressInput.BackgroundColor3=COLOR_SCHEME.ContentBack
	AddressInput.Size=UDim2.new(1,-65,0,20)
	AddressInput.Position=UDim2.new(0,58,0.5,0)
	AddressInput.AnchorPoint=Vector2.new(0,0.5)
	local as=Instance.new("UIStroke",AddressInput)
	as.Color=COLOR_SCHEME.BorderDark
	
	local AddressIcon = Instance.new("ImageLabel", AddressInput)
	AddressIcon.Image = "rbxassetid://13483329133"
	AddressIcon.Size = UDim2.new(0,16,0,16)
	AddressIcon.Position = UDim2.new(0,3,0.5,0)
	AddressIcon.AnchorPoint=Vector2.new(0,0.5)
	AddressIcon.BackgroundTransparency=1
	
	local AddressText = Instance.new("TextLabel", AddressInput)
	AddressText.Text = "My Application"
	AddressText.Font=FONT
	AddressText.TextSize=FONT_SIZE
	AddressText.BackgroundTransparency=1
	AddressText.TextXAlignment=Enum.TextXAlignment.Left
	AddressText.Size=UDim2.new(1,-20,1,0)
	AddressText.Position=UDim2.new(0,22,0,0)
	
	-- Content Area
	local CONTENT_Y_OFFSET = 112
	local ContentContainer = Instance.new("Frame", InnerFrame)
	windowInstance.ContentContainer = ContentContainer
	ContentContainer.Name = "ContentContainer"
	ContentContainer.BackgroundColor3 = COLOR_SCHEME.ContentBack
	ContentContainer.Position = UDim2.new(0, 4, 0, CONTENT_Y_OFFSET)
	ContentContainer.Size = UDim2.new(1, -8, 1, -CONTENT_Y_OFFSET - 4)
	local ContentStroke = Instance.new("UIStroke", ContentContainer)
	ContentStroke.Color = COLOR_SCHEME.BorderDark
	ContentStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

	---------------------- FUNCTIONALITY ----------------------
	-- Dragging Logic
	local dragging, dragStart, startPos
	Header.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 and not windowInstance.IsMaximized then
			dragging = true
			dragStart = UserInputService:GetMouseLocation()
			startPos = Main.Position
			local conn
			conn = UserInputService.InputEnded:Connect(function(endInput)
				if endInput.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = false
					conn:Disconnect()
				end
			end)
		end
	end)
	RunService.RenderStepped:Connect(function()
		if dragging and not windowInstance.IsMaximized then
			local delta = UserInputService:GetMouseLocation() - dragStart
			Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
	
	-- Button Functions
	CloseButton.MouseButton1Click:Connect(function() windowInstance:Toggle() end)
	
	MaximizeButton.MouseButton1Click:Connect(function()
		windowInstance.IsMaximized = not windowInstance.IsMaximized
		if windowInstance.IsMaximized then
			windowInstance.OriginalProperties.Size = Main.Size
			windowInstance.OriginalProperties.Position = Main.Position
			Main:TweenSizeAndPosition(UDim2.new(1,0,1,0), UDim2.new(0,0,0,0), "Out", "Quad", 0.2, true)
			MaximizeButton.Text = "❐"
		else
			Main:TweenSizeAndPosition(windowInstance.OriginalProperties.Size, windowInstance.OriginalProperties.Position, "Out", "Quad", 0.2, true)
			MaximizeButton.Text = "□"
		end
	end)
	
	MinimizeButton.MouseButton1Click:Connect(function() windowInstance:ToggleMinimize() end)

	return windowInstance
end

function Window:Toggle()
	self.Visible = not self.Visible
	self.ScreenGui.Enabled = self.Visible
end

function Window:ToggleMinimize()
	self.IsMinimized = not self.IsMinimized
	if self.IsMinimized then
		self.OriginalProperties.Size = self.MainFrame.Size
		self.OriginalProperties.Position = self.MainFrame.Position
		local headerHeight = 30
		local targetPos = UDim2.new(0, 10, 1, -headerHeight - 10)
		self.MainFrame:TweenSizeAndPosition(UDim2.new(0, 200, 0, headerHeight), targetPos, "Out", "Quad", 0.2, true)
	else
		self.MainFrame:TweenSizeAndPosition(self.OriginalProperties.Size, self.OriginalProperties.Position, "Out", "Quad", 0.2, true)
	end
end

function Window:CreateMenuTab(name)
	local self = self
	local MenuTab = { Name = name }

	local TabButton = Instance.new("TextButton", self.MenuBar)
	TabButton.Name = name
	TabButton.BackgroundTransparency = 1
	TabButton.Size = UDim2.new(0, 50, 1, -4)
	TabButton.Position = UDim2.new(0, 0, 0.5, 0)
	TabButton.AnchorPoint = Vector2.new(0, 0.5)
	TabButton.Font = FONT
	TabButton.Text = name
	TabButton.TextSize = FONT_SIZE
	TabButton.TextColor3 = COLOR_SCHEME.Text
	TabButton.ZIndex = 2
	TabButton.AutoButtonColor = false
	TabButton.MouseEnter:Connect(function() TabButton.BackgroundColor3 = COLOR_SCHEME.ButtonHover end)
	TabButton.MouseLeave:Connect(function() TabButton.BackgroundTransparency = 1 end)

	local TabContent = Instance.new("ScrollingFrame", self.ContentContainer)
	MenuTab.ContentFrame = TabContent
	TabContent.BackgroundTransparency = 1
	TabContent.Size = UDim2.new(1, 0, 1, 0)
	TabContent.BorderSizePixel = 0
	TabContent.Visible = false
	TabContent.ScrollBarImageColor3 = COLOR_SCHEME.BorderDark
	TabContent.ScrollBarThickness = 10
	TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
	
	local ContentLayout = Instance.new("UIListLayout", TabContent)
	ContentLayout.Padding = UDim.new(0, 5)
	ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
	
	local ContentPadding = Instance.new("UIPadding", TabContent)
	ContentPadding.PaddingTop = UDim.new(0, 8)
	ContentPadding.PaddingLeft = UDim.new(0, 8)
	
	MenuTab.currentContentY = ContentPadding.PaddingTop.Offset
	local function UpdateCanvasSize(element)
		MenuTab.currentContentY = MenuTab.currentContentY + element.Size.Y.Offset + ContentLayout.Padding.Offset
		TabContent.CanvasSize = UDim2.new(0, 0, 0, MenuTab.currentContentY)
	end

	local function SwitchToTab()
		for _, t in pairs(self.MenuTabs) do
			t.ContentFrame.Visible = false
		end
		TabContent.Visible = true
	end

	TabButton.MouseButton1Click:Connect(SwitchToTab)
	table.insert(self.MenuTabs, MenuTab)
	if #self.MenuTabs == 1 then SwitchToTab() end

	local ElementMethods = {}

	function ElementMethods:AddElement(element)
		element.Parent = TabContent
		UpdateCanvasSize(element)
		return ElementMethods
	end

	function ElementMethods:AddLabel(text)
		local Label = Instance.new("TextLabel")
		Label.BackgroundTransparency = 1
		Label.Size = UDim2.new(1, -16, 0, 20)
		Label.Font = FONT
		Label.Text = text
		Label.TextColor3 = COLOR_SCHEME.Text
		Label.TextSize = FONT_SIZE
		Label.TextXAlignment = Enum.TextXAlignment.Left
		self:AddElement(Label)
		return ElementMethods
	end

	function ElementMethods:AddButton(btnConfig)
		local Button = Instance.new("TextButton")
		Button.BackgroundColor3 = COLOR_SCHEME.MainBack
		Button.Size = UDim2.new(0, 120, 0, 25)
		Button.Font = FONT
		Button.Text = btnConfig.Name or "Button"
		Button.TextColor3 = COLOR_SCHEME.Text
		Button.TextSize = FONT_SIZE
		
		local bs = Instance.new("UIStroke", Button)
		bs.Color = COLOR_SCHEME.BorderDark
		bs.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		
		local bc = Instance.new("UICorner", Button)
		bc.CornerRadius = UDim.new(0, 3)
		
		Button.MouseEnter:Connect(function() Button.BackgroundColor3 = COLOR_SCHEME.ButtonHover end)
		Button.MouseLeave:Connect(function() Button.BackgroundColor3 = COLOR_SCHEME.MainBack end)
		Button.MouseButton1Click:Connect(function() pcall(btnConfig.Callback) end)
		
		self:AddElement(Button)
		return ElementMethods
	end

	function ElementMethods:AddToggle(toggleConfig)
		local toggled = false
		local Frame = Instance.new("Frame")
		Frame.BackgroundTransparency = 1
		Frame.Size = UDim2.new(1, -16, 0, 22)
		
		local Checkbox = Instance.new("Frame", Frame)
		Checkbox.Size = UDim2.new(0, 13, 0, 13)
		Checkbox.Position = UDim2.new(0, 0, 0.5, 0)
		Checkbox.AnchorPoint = Vector2.new(0, 0.5)
		Checkbox.BackgroundColor3 = Color3.new(1, 1, 1)
		
		local cs = Instance.new("UIStroke", Checkbox)
		cs.Color = COLOR_SCHEME.BorderDark
		
		local CheckMark = Instance.new("TextLabel", Checkbox)
		CheckMark.Size = UDim2.new(1, 0, 1, 0)
		CheckMark.Font = Enum.Font.ArialBold
		CheckMark.Text = "✔"
		CheckMark.TextScaled = true
		CheckMark.TextColor3 = COLOR_SCHEME.Text
		CheckMark.BackgroundTransparency = 1
		CheckMark.Visible = false
		
		local Label = Instance.new("TextLabel", Frame)
		Label.BackgroundTransparency = 1
		Label.Size = UDim2.new(1, -20, 1, 0)
		Label.Position = UDim2.new(0, 20, 0, 0)
		Label.Font = FONT
		Label.Text = toggleConfig.Name or "Toggle"
		Label.TextColor3 = COLOR_SCHEME.Text
		Label.TextSize = FONT_SIZE
		Label.TextXAlignment = Enum.TextXAlignment.Left
		
		local Hitbox = Instance.new("TextButton", Frame)
		Hitbox.BackgroundTransparency = 1
		Hitbox.Size = UDim2.new(1, 0, 1, 0)
		Hitbox.Text = ""
		Hitbox.MouseButton1Click:Connect(function()
			toggled = not toggled
			CheckMark.Visible = toggled
			pcall(toggleConfig.Callback, toggled)
		end)
		
		self:AddElement(Frame)
		return ElementMethods
	end
	
	return ElementMethods
end

return XP_UI
