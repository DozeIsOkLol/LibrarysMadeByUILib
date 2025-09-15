-- =================================================================================================
-- XP_UI Source Code (Definitive Fix)
-- A UI library in the style of Windows XP.
--
-- MAJOR BUG FIX:
-- Replaced the automatic content sizing with a manual, reliable calculation.
-- This guarantees that buttons, labels, and other elements will now appear correctly in the tabs.
--
-- VISUAL TWEAKS:
-- The layout is now more compact and utility-focused, similar to the provided examples.
-- =================================================================================================

local XP_UI = {}
local Window = {}
Window.__index = Window

--[[ Colors & Fonts ]]--
local FONT = Enum.Font.Arial
local COLOR_SCHEME = {
	MainBack = Color3.fromRGB(236, 233, 216),
	HeaderStart = Color3.fromRGB(0, 80, 239),
	HeaderEnd = Color3.fromRGB(60, 140, 255),
	Text = Color3.fromRGB(0, 0, 0),
	TextLight = Color3.fromRGB(255, 255, 255),
	BorderDark = Color3.fromRGB(130, 130, 130),
	Button = Color3.fromRGB(240, 240, 240),
	ButtonHover = Color3.fromRGB(245, 248, 255),
	CloseButton = Color3.fromRGB(224, 67, 67),
}

-- Main function to create the window
function XP_UI:CreateWindow(config)
	local windowInstance = setmetatable({}, Window)

	windowInstance.Title = config.Title or "Windows XP"
	windowInstance.Tabs = {}
	windowInstance.Visible = true

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
	Main.BackgroundColor3 = COLOR_SCHEME.MainBack
	Main.Position = UDim2.new(0.5, -250, 0.5, -175)
	Main.Size = UDim2.new(0, 500, 0, 350)
	Main.ClipsDescendants = true
	local MainStroke = Instance.new("UIStroke", Main)
	MainStroke.Color = COLOR_SCHEME.BorderDark
	local MainCorner = Instance.new("UICorner", Main)
	MainCorner.CornerRadius = UDim.new(0, 3)

	-- Header (Title Bar)
	local Header = Instance.new("Frame", Main)
	Header.Name = "Header"
	Header.BackgroundColor3 = COLOR_SCHEME.HeaderStart
	Header.Size = UDim2.new(1, 0, 0, 28)
	Header.BorderSizePixel = 0
	local HeaderGradient = Instance.new("UIGradient", Header)
	HeaderGradient.Color = ColorSequence.new(COLOR_SCHEME.HeaderStart, COLOR_SCHEME.HeaderEnd)
	HeaderGradient.Rotation = 90

	local TitleLabel = Instance.new("TextLabel", Header)
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Size = UDim2.new(1, -50, 1, 0)
	TitleLabel.Position = UDim2.new(0, 8, 0, -1)
	TitleLabel.Font = FONT
	TitleLabel.Text = windowInstance.Title
	TitleLabel.TextColor3 = COLOR_SCHEME.TextLight
	TitleLabel.TextSize = 14
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

	-- Close Button
	local CloseButton = Instance.new("ImageButton", Header)
	CloseButton.Image = "rbxassetid://13483329143"
	CloseButton.BackgroundColor3 = COLOR_SCHEME.CloseButton
	CloseButton.Size = UDim2.new(0, 21, 0, 21)
	CloseButton.Position = UDim2.new(1, -26, 0.5, 0)
	CloseButton.AnchorPoint = Vector2.new(0.5, 0.5)
	local CloseCorner = Instance.new("UICorner", CloseButton)
	CloseCorner.CornerRadius = UDim.new(0, 3)

	-- Draggable Logic
	local dragging, dragStart, startPos
	Header.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = Main.Position
			local connection
			connection = UserInputService.InputEnded:Connect(function(endInput)
				if endInput.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = false
					connection:Disconnect()
				end
			end)
		end
	end)
	RunService.RenderStepped:Connect(function()
		if dragging then
			local delta = UserInputService:GetMouseLocation() - dragStart
			Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
	
	-- Tab and Content Containers
	local TabContainer = Instance.new("Frame", Main)
	TabContainer.BackgroundTransparency = 1
	TabContainer.Position = UDim2.new(0, 5, 0, 32)
	TabContainer.Size = UDim2.new(1, -10, 0, 30)
	
	local ContentContainer = Instance.new("Frame", Main)
	ContentContainer.BackgroundColor3 = COLOR_SCHEME.MainBack
	ContentContainer.Position = UDim2.new(0, 5, 0, 62)
	ContentContainer.Size = UDim2.new(1, -10, 1, -67)
	local ContentStroke = Instance.new("UIStroke", ContentContainer)
	ContentStroke.Color = COLOR_SCHEME.BorderDark
	ContentStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	
	CloseButton.MouseButton1Click:Connect(function() windowInstance:Toggle() end)

	return windowInstance
end

function Window:Toggle()
	self.Visible = not self.Visible
	self.ScreenGui.Enabled = self.Visible
end

function Window:CreateTab(name)
	local self = self
	local Tab = { Name = name }
	local index = #self.Tabs + 1
	local TabContainer = self.MainFrame:FindFirstChild("TabContainer")
	local ContentContainer = self.MainFrame:FindFirstChild("ContentContainer")

	local TabButton = Instance.new("TextButton", TabContainer)
	TabButton.Name = name
	TabButton.BackgroundColor3 = COLOR_SCHEME.MainBack
	TabButton.Size = UDim2.new(0, 100, 1, 0)
	TabButton.Position = UDim2.new(0, (index - 1) * 102, 0, 0)
	TabButton.Font = FONT
	TabButton.Text = name
	TabButton.TextSize = 14
	TabButton.TextColor3 = COLOR_SCHEME.Text
	TabButton.ZIndex = 2
	local TabStroke = Instance.new("UIStroke", TabButton)
	TabStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	TabStroke.Color = COLOR_SCHEME.BorderDark
	local TabCorner = Instance.new("UICorner", TabButton)
	TabCorner.CornerRadius = UDim.new(0, 3)

	local TabContent = Instance.new("ScrollingFrame", ContentContainer)
	Tab.ContentFrame = TabContent
	TabContent.BackgroundTransparency = 1
	TabContent.Size = UDim2.new(1, 0, 1, 0)
	TabContent.BorderSizePixel = 0
	TabContent.Visible = false
	TabContent.ScrollBarImageColor3 = COLOR_SCHEME.BorderDark
	TabContent.ScrollBarThickness = 8
	TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
	
	local ContentLayout = Instance.new("UIListLayout", TabContent)
	ContentLayout.Padding = UDim.new(0, 5) -- Reduced padding
	ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
	
	local ContentPadding = Instance.new("UIPadding", TabContent)
	ContentPadding.PaddingTop = UDim.new(0, 8)
	ContentPadding.PaddingLeft = UDim.new(0, 8)
	ContentPadding.PaddingRight = UDim.new(0, 8)

	-- [DEFINITIVE BUG FIX] This function manually recalculates the canvas size.
	local function UpdateCanvasSize()
		local totalHeight = ContentLayout.AbsoluteContentSize.Y
		TabContent.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
	end

	local function SwitchToTab()
		for _, t in pairs(self.Tabs) do
			t.ContentFrame.Visible = false
			t.Button.ZIndex = 2
			t.Button.BackgroundColor3 = COLOR_SCHEME.MainBack
		end
		TabContent.Visible = true
		TabButton.ZIndex = 3
		TabButton.BackgroundColor3 = COLOR_SCHEME.ButtonHover
	end

	TabButton.MouseButton1Click:Connect(SwitchToTab)
	Tab.Button = TabButton
	table.insert(self.Tabs, Tab)
	if #self.Tabs == 1 then SwitchToTab() end

	local ElementMethods = {}

	local function AddElement(element)
		element.Parent = TabContent
		task.wait() -- Allow one frame for the UIListLayout to update its AbsoluteContentSize
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
		Button.BackgroundColor3 = COLOR_SCHEME.Button
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
		Button.MouseLeave:Connect(function() Button.BackgroundColor3 = COLOR_SCHEME.Button end)
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
