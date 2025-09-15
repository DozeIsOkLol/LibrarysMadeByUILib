-- =================================================================================================
-- XP_UI Source Code (Version 2.0 - "My Computer" Overhaul)
-- A UI library meticulously styled to replicate the Windows XP window.
--
-- Features:
-- - Authentic layout with Header, Menu Bar, Toolbar, and Content Area.
-- - Functional Minimize, Maximize, and Close buttons.
-- - Menu Bar ("File", "Edit", etc.) now acts as the tab selector.
-- =================================================================================================

local XP_UI = {}
local Window = {}
Window.__index = Window

--[[ Colors & Fonts ]]--
local FONT = Enum.Font.Arial
local COLOR_SCHEME = {
	MainBack = Color3.fromRGB(236, 233, 216),
	ContentBack = Color3.fromRGB(255, 255, 255),
	HeaderStart = Color3.fromRGB(0, 80, 239),
	HeaderEnd = Color3.fromRGB(60, 140, 255),
	Text = Color3.fromRGB(0, 0, 0),
	TextLight = Color3.fromRGB(255, 255, 255),
	BorderDark = Color3.fromRGB(130, 130, 130),
	BorderHighlight = Color3.fromRGB(212, 208, 200),
	ButtonHover = Color3.fromRGB(182, 208, 250),
}

-- Main function to create the window
function XP_UI:CreateWindow(config)
	local windowInstance = setmetatable({}, Window)

	-- State Management
	windowInstance.Title = config.Title or "My Computer"
	windowInstance.MenuTabs = {}
	windowInstance.Visible = true
	windowInstance.IsMaximized = false
	windowInstance.IsMinimized = false
	windowInstance.OriginalProperties = {}

	-- Services
	local UserInputService = game:GetService("UserInputService")
	local TweenService = game:GetService("TweenService")
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
	TitleIcon.Image = "rbxassetid://13483329133" -- My Computer Icon
	TitleIcon.BackgroundTransparency = 1
	TitleIcon.Position = UDim2.new(0, 5, 0.5, 0)
	TitleIcon.Size = UDim2.new(0, 16, 0, 16)
	TitleIcon.AnchorPoint = Vector2.new(0, 0.5)

	local TitleLabel = Instance.new("TextLabel", Header)
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Size = UDim2.new(1, -100, 1, 0)
	TitleLabel.Position = UDim2.new(0, 25, 0, -1)
	TitleLabel.Font = FONT
	TitleLabel.Text = windowInstance.Title
	TitleLabel.TextColor3 = COLOR_SCHEME.TextLight
	TitleLabel.TextSize = 14
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

	-- Control Buttons
	local CloseButton = Instance.new("ImageButton", Header)
	CloseButton.Name = "Close"
	CloseButton.Image = "rbxassetid://13483329143"
	CloseButton.Size = UDim2.new(0, 21, 0, 21)
	CloseButton.Position = UDim2.new(1, -26, 0.5, 0)
	CloseButton.AnchorPoint = Vector2.new(0.5, 0.5)

	local MaximizeButton = Instance.new("ImageButton", Header)
	MaximizeButton.Name = "Maximize"
	MaximizeButton.Image = "rbxassetid://13483329168"
	MaximizeButton.Size = UDim2.new(0, 21, 0, 21)
	MaximizeButton.Position = UDim2.new(1, -48, 0.5, 0)
	MaximizeButton.AnchorPoint = Vector2.new(0.5, 0.5)
	
	local MinimizeButton = Instance.new("ImageButton", Header)
	MinimizeButton.Name = "Minimize"
	MinimizeButton.Image = "rbxassetid://13483329177"
	MinimizeButton.Size = UDim2.new(0, 21, 0, 21)
	MinimizeButton.Position = UDim2.new(1, -70, 0.5, 0)
	MinimizeButton.AnchorPoint = Vector2.new(0.5, 0.5)

	-- Menu Bar (New Tab Container)
	local MenuBar = Instance.new("Frame", InnerFrame)
	MenuBar.Name = "MenuBar"
	MenuBar.BackgroundColor3 = COLOR_SCHEME.BorderHighlight
	MenuBar.Position = UDim2.new(0, 0, 0, 28)
	MenuBar.Size = UDim2.new(1, 0, 0, 24)
	MenuBar.BorderSizePixel = 0
	local MenuLayout = Instance.new("UIListLayout", MenuBar)
	MenuLayout.FillDirection = Enum.FillDirection.Horizontal
	MenuLayout.Padding = UDim.new(0, 4)
	local MenuPadding = Instance.new("UIPadding", MenuBar)
	MenuPadding.PaddingLeft = UDim.new(0, 4)
	
	-- Static Toolbar (for appearance)
	local Toolbar = Instance.new("Frame", InnerFrame)
	Toolbar.Name = "Toolbar"
	Toolbar.BackgroundColor3 = COLOR_SCHEME.BorderHighlight
	Toolbar.Position = UDim2.new(0, 0, 0, 52)
	Toolbar.Size = UDim2.new(1, 0, 0, 40)
	Toolbar.BorderSizePixel = 0
	local TopBorder = Instance.new("Frame", Toolbar)
	TopBorder.BackgroundColor3 = COLOR_SCHEME.BorderDark
	TopBorder.BorderSizePixel = 0
	TopBorder.Size = UDim2.new(1, 0, 0, 1)

	-- Content Area
	local ContentContainer = Instance.new("Frame", InnerFrame)
	windowInstance.ContentContainer = ContentContainer
	ContentContainer.Name = "ContentContainer"
	ContentContainer.BackgroundColor3 = COLOR_SCHEME.ContentBack
	ContentContainer.Position = UDim2.new(0, 4, 0, 96)
	ContentContainer.Size = UDim2.new(1, -8, 1, -100)
	local ContentStroke = Instance.new("UIStroke", ContentContainer)
	ContentStroke.Color = COLOR_SCHEME.BorderDark
	ContentStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

	---------------------- FUNCTIONALITY ----------------------
	-- Draggable Logic
	local dragging, dragStart, startPos
	Header.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 and not windowInstance.IsMaximized then
			dragging = true
			dragStart = input.Position
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
			MaximizeButton.Image = "rbxassetid://13483329188" -- Restore Icon
		else
			Main:TweenSizeAndPosition(windowInstance.OriginalProperties.Size, windowInstance.OriginalProperties.Position, "Out", "Quad", 0.2, true)
			MaximizeButton.Image = "rbxassetid://13483329168" -- Maximize Icon
		end
	end)
	
	MinimizeButton.MouseButton1Click:Connect(function()
		windowInstance:ToggleMinimize()
	end)

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

	local TabButton = Instance.new("TextButton", self.MainFrame:FindFirstChild("InnerFrame"):FindFirstChild("MenuBar"))
	TabButton.Name = name
	TabButton.BackgroundTransparency = 1
	TabButton.Size = UDim2.new(0, 50, 1, -4)
	TabButton.Position = UDim2.new(0, 0, 0.5, 0)
	TabButton.AnchorPoint = Vector2.new(0, 0.5)
	TabButton.Font = FONT
	TabButton.Text = name
	TabButton.TextSize = 14
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
	
	local function UpdateCanvasSize()
		task.wait()
		local totalHeight = ContentLayout.AbsoluteContentSize.Y + ContentPadding.PaddingTop.Offset
		TabContent.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
	end

	local function SwitchToTab()
		for _, t in pairs(self.MenuTabs) do
			t.ContentFrame.Visible = false
		end
		TabContent.Visible = true
	end

	TabButton.MouseButton1Click:Connect(SwitchToTab)
	MenuTab.Button = TabButton
	table.insert(self.MenuTabs, MenuTab)
	if #self.MenuTabs == 1 then SwitchToTab() end

	local ElementMethods = {}

	local function AddElement(element)
		element.Parent = TabContent
		UpdateCanvasSize()
	end

	function ElementMethods:AddLabel(text)
		local Label = Instance.new("TextLabel")
		Label.BackgroundTransparency = 1
		Label.Size = UDim2.new(1, -16, 0, 20)
		Label.Font = FONT
		Label.Text = text
		Label.TextColor3 = COLOR_SCHEME.Text
		Label.TextSize = 14
		Label.TextXAlignment = Enum.TextXAlignment.Left
		AddElement(Label)
		return ElementMethods
	end

	function ElementMethods:AddButton(btnConfig)
		local Button = Instance.new("TextButton")
		Button.BackgroundColor3 = COLOR_SCHEME.MainBack
		Button.Size = UDim2.new(0, 120, 0, 25)
		Button.Font = FONT
		Button.Text = btnConfig.Name or "Button"
		Button.TextColor3 = COLOR_SCHEME.Text
		Button.TextSize = 14
		local ButtonStroke = Instance.new("UIStroke", Button)
		ButtonStroke.Color = COLOR_SCHEME.BorderDark
		ButtonStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		local ButtonCorner = Instance.new("UICorner", Button)
		ButtonCorner.CornerRadius = UDim.new(0, 3)
		Button.MouseEnter:Connect(function() Button.BackgroundColor3 = COLOR_SCHEME.ButtonHover end)
		Button.MouseLeave:Connect(function() Button.BackgroundColor3 = COLOR_SCHEME.MainBack end)
		Button.MouseButton1Click:Connect(function() pcall(btnConfig.Callback) end)
		AddElement(Button)
		return ElementMethods
	end

	function ElementMethods:AddToggle(toggleConfig)
		local toggled = false
		local Frame = Instance.new("Frame")
		Frame.BackgroundTransparency = 1
		Frame.Size = UDim2.new(1, -16, 0, 22)

		local Checkbox = Instance.new("ImageLabel", Frame)
		Checkbox.Image = "rbxassetid://13483329158"
		Checkbox.Size = UDim2.new(0, 13, 0, 13)
		Checkbox.Position = UDim2.new(0, 0, 0.5, 0)
		Checkbox.AnchorPoint = Vector2.new(0, 0.5)
		Checkbox.BackgroundTransparency = 1

		local CheckMark = Instance.new("ImageLabel", Checkbox)
		CheckMark.Image = "rbxassetid://13483329124"
		CheckMark.Size = UDim2.new(1, 0, 1, 0)
		CheckMark.BackgroundTransparency = 1
		CheckMark.Visible = false

		local Label = Instance.new("TextLabel", Frame)
		Label.BackgroundTransparency = 1
		Label.Size = UDim2.new(1, -20, 1, 0)
		Label.Position = UDim2.new(0, 20, 0, 0)
		Label.Font = FONT
		Label.Text = toggleConfig.Name or "Toggle"
		Label.TextColor3 = COLOR_SCHEME.Text
		Label.TextSize = 14
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
		AddElement(Frame)
		return ElementMethods
	end
	
	return ElementMethods
end

return XP_UI
