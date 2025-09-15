-- =================================================================================================
-- XP_UI Source Code (Refactored for Stability)
-- A UI library in the style of Windows XP.
-- =================================================================================================

local XP_UI = {}
local Window = {}
Window.__index = Window

-- Main function to create the window (acts as a constructor)
function XP_UI:CreateWindow(config)
	local windowInstance = setmetatable({}, Window)

	-- Configuration and State
	windowInstance.Title = config.Title or "Windows XP"
	windowInstance.Tabs = {}
	windowInstance.Visible = true

	-- Services
	local UserInputService = game:GetService("UserInputService")

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
	Main.BackgroundColor3 = Color3.fromRGB(236, 233, 216)
	Main.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Main.BorderSizePixel = 1
	Main.Position = UDim2.new(0.5, -250, 0.5, -175)
	Main.Size = UDim2.new(0, 500, 0, 350)
	Main.ClipsDescendants = true

	-- Header (Title Bar)
	local Header = Instance.new("Frame", Main)
	Header.Name = "Header"
	Header.BackgroundColor3 = Color3.fromRGB(0, 80, 239)
	Header.Size = UDim2.new(1, 0, 0, 28)
	Header.BorderSizePixel = 0

	local HeaderGradient = Instance.new("UIGradient", Header)
	HeaderGradient.Color = ColorSequence.new(Color3.fromRGB(0, 80, 239), Color3.fromRGB(60, 140, 255))
	HeaderGradient.Rotation = 90

	local TitleLabel = Instance.new("TextLabel", Header)
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Size = UDim2.new(1, -50, 1, 0)
	TitleLabel.Position = UDim2.new(0, 5, 0, -2)
	TitleLabel.Font = Enum.Font.Arial
	TitleLabel.Text = windowInstance.Title
	TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TitleLabel.TextSize = 14
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

	-- Close Button
	local CloseButton = Instance.new("TextButton", Header)
	CloseButton.BackgroundColor3 = Color3.fromRGB(224, 67, 67)
	CloseButton.Size = UDim2.new(0, 20, 0, 20)
	CloseButton.Position = UDim2.new(1, -25, 0.5, 0)
	CloseButton.AnchorPoint = Vector2.new(0.5, 0.5)
	CloseButton.Font = Enum.Font.ArialBold
	CloseButton.Text = "X"
	CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	CloseButton.TextSize = 14
	CloseButton.BorderSizePixel = 1
	CloseButton.BorderColor3 = Color3.fromRGB(0,0,0)

	-- Draggable Logic
	local dragging, dragStart, startPos
	Header.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 and input.UserInputState == Enum.UserInputState.Begin then
			dragging = true
			dragStart = input.Position
			startPos = Main.Position
			
			local clear
			clear = UserInputService.InputEnded:Connect(function(endInput)
				if endInput.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = false
					clear:Disconnect()
				end
			end)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
	
	-- Tab and Content Containers
	local TabContainer = Instance.new("Frame", Main)
	TabContainer.BackgroundColor3 = Color3.fromRGB(236, 233, 216)
	TabContainer.BorderSizePixel = 0
	TabContainer.Position = UDim2.new(0, 10, 0, 38)
	TabContainer.Size = UDim2.new(1, -20, 0, 25)

	local ContentContainer = Instance.new("Frame", Main)
	ContentContainer.BackgroundColor3 = Color3.fromRGB(236, 233, 216)
	ContentContainer.Position = UDim2.new(0, 5, 0, 70)
	ContentContainer.Size = UDim2.new(1, -10, 1, -75)
	ContentContainer.BorderColor3 = Color3.fromRGB(128, 128, 128)
	
	-- Connect close button to the toggle function
	CloseButton.MouseButton1Click:Connect(function()
		windowInstance:Toggle()
	end)

	return windowInstance
end

-- Toggle visibility function
function Window:Toggle()
	self.Visible = not self.Visible
	self.ScreenGui.Enabled = self.Visible
end

function Window:CreateTab(name)
	local self = self -- Explicitly refer to the window instance
	local Tab = { Name = name }
	local index = #self.Tabs + 1

	local TabButton = Instance.new("TextButton", self.MainFrame:FindFirstChild("TabContainer"))
	TabButton.Name = name
	TabButton.BackgroundColor3 = Color3.fromRGB(236, 233, 216)
	TabButton.Size = UDim2.new(0, 100, 1, 0)
	TabButton.Position = UDim2.new(0, (index - 1) * 105, 0, 0)
	TabButton.Font = Enum.Font.Arial
	TabButton.Text = name
	TabButton.TextSize = 14
	TabButton.TextColor3 = Color3.fromRGB(0, 0, 0)
	TabButton.ZIndex = 2
	TabButton.BorderSizePixel = 1
	TabButton.BorderColor3 = Color3.fromRGB(128, 128, 128)

	local TabContent = Instance.new("ScrollingFrame", self.MainFrame:FindFirstChild("ContentContainer"))
	Tab.ContentFrame = TabContent
	TabContent.BackgroundTransparency = 1
	TabContent.Size = UDim2.new(1, 0, 1, 0)
	TabContent.Visible = false
	TabContent.ScrollBarThickness = 6
	TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
	
	local ContentLayout = Instance.new("UIListLayout", TabContent)
	ContentLayout.Padding = UDim.new(0, 8)
	ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
	
	local ContentPadding = Instance.new("UIPadding", TabContent)
	ContentPadding.PaddingTop = UDim.new(0, 10)
	ContentPadding.PaddingLeft = UDim.new(0, 10)
	ContentPadding.PaddingRight = UDim.new(0, 10)

	local function SwitchToTab()
		for _, t in pairs(self.Tabs) do
			t.ContentFrame.Visible = false
			t.Button.BackgroundColor3 = Color3.fromRGB(236, 233, 216)
			t.Button.ZIndex = 2
		end
		TabContent.Visible = true
		TabButton.BackgroundColor3 = Color3.fromRGB(245, 245, 245) -- Selected tab color
		TabButton.ZIndex = 3
	end

	TabButton.MouseButton1Click:Connect(SwitchToTab)
	Tab.Button = TabButton
	table.insert(self.Tabs, Tab)
	if #self.Tabs == 1 then
		SwitchToTab()
	end

	local ElementMethods = {}

	function ElementMethods:AddLabel(text)
		local Label = Instance.new("TextLabel", TabContent)
		Label.BackgroundTransparency = 1
		Label.Size = UDim2.new(1, -20, 0, 20)
		Label.Font = Enum.Font.Arial
		Label.Text = text
		Label.TextColor3 = Color3.fromRGB(0, 0, 0)
		Label.TextSize = 14
		Label.TextXAlignment = Enum.TextXAlignment.Left
		return self
	end

	function ElementMethods:AddButton(btnConfig)
		local Button = Instance.new("TextButton", TabContent)
		Button.BackgroundColor3 = Color3.fromRGB(236, 233, 216)
		Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Button.Size = UDim2.new(0, 120, 0, 28)
		Button.Font = Enum.Font.Arial
		Button.Text = btnConfig.Name or "Button"
		Button.TextColor3 = Color3.fromRGB(0, 0, 0)
		Button.TextSize = 14
		Button.MouseButton1Click:Connect(function()
			pcall(btnConfig.Callback)
		end)
		return self
	end

	function ElementMethods:AddToggle(toggleConfig)
		local toggled = false
		local Frame = Instance.new("Frame", TabContent)
		Frame.BackgroundTransparency = 1
		Frame.Size = UDim2.new(1, -20, 0, 25)

		local Checkbox = Instance.new("Frame", Frame)
		Checkbox.Size = UDim2.new(0, 13, 0, 13)
		Checkbox.Position = UDim2.new(0, 0, 0.5, 0)
		Checkbox.AnchorPoint = Vector2.new(0, 0.5)
		Checkbox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Checkbox.BorderColor3 = Color3.fromRGB(0, 0, 0)

		local CheckMark = Instance.new("TextLabel", Checkbox)
		CheckMark.Size = UDim2.new(1, 0, 1, 0)
		CheckMark.Font = Enum.Font.Arial
		CheckMark.Text = "✔"
		CheckMark.TextScaled = true
		CheckMark.TextColor3 = Color3.fromRGB(0, 0, 0)
		CheckMark.BackgroundTransparency = 1
		CheckMark.Visible = false

		local Label = Instance.new("TextLabel", Frame)
		Label.BackgroundTransparency = 1
		Label.Size = UDim2.new(1, -20, 1, 0)
		Label.Position = UDim2.new(0, 20, 0, 0)
		Label.Font = Enum.Font.Arial
		Label.Text = toggleConfig.Name or "Toggle"
		Label.TextColor3 = Color3.fromRGB(0, 0, 0)
		Label.TextSize = 14
		Label.TextXAlignment = Enum.TextXAlignment.Left

		local Button = Instance.new("TextButton", Frame)
		Button.BackgroundTransparency = 1
		Button.Size = UDim2.new(1, 0, 1, 0)
		Button.Text = ""
		Button.MouseButton1Click:Connect(function()
			toggled = not toggled
			CheckMark.Visible = toggled
			pcall(toggleConfig.Callback, toggled)
		end)
		return self
	end
	
	return ElementMethods
end

return XP_UI
