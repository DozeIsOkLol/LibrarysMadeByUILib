-- =================================================================================================
-- XP_UI Source Code (Corrected)
-- A UI library in the style of Windows XP.
-- Font changed from Tahoma to Arial to prevent errors.
-- =================================================================================================

local XP_UI = {}
local UI_Window = {}

-- Main function to create the window
function XP_UI:CreateWindow(config)
    -- Services
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")

    -- Configuration
    UI_Window.Title = config.Title or "Windows XP"
    UI_Window.Tabs = {}
    UI_Window.Visible = true

    -- Main ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    UI_Window.ScreenGui = ScreenGui
    ScreenGui.Name = "XP_UI_Window"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = game:GetService("CoreGui")

    -- Main Frame
    local Main = Instance.new("Frame")
    Main.Name = "MainFrame"
    Main.Parent = ScreenGui
    Main.BackgroundColor3 = Color3.fromRGB(236, 233, 216)
    Main.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Main.BorderSizePixel = 1
    Main.Position = UDim2.new(0.5, -250, 0.5, -175)
    Main.Size = UDim2.new(0, 500, 0, 350)

    -- Header (Title Bar)
    local Header = Instance.new("Frame", Main)
    Header.Name = "Header"
    Header.BackgroundColor3 = Color3.fromRGB(0, 80, 239)
    Header.Size = UDim2.new(1, 0, 0, 28)
    Header.BorderSizePixel = 0

    local HeaderGradient = Instance.new("UIGradient", Header)
    HeaderGradient.Color = ColorSequence.new(
        Color3.fromRGB(0, 80, 239),
        Color3.fromRGB(60, 140, 255)
    )
    HeaderGradient.Rotation = 90

    local TitleLabel = Instance.new("TextLabel", Header)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Size = UDim2.new(1, -50, 1, 0)
    TitleLabel.Position = UDim2.new(0, 5, 0, -2)
    TitleLabel.Font = Enum.Font.Arial -- Corrected Font
    TitleLabel.Text = UI_Window.Title
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 14
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- Draggable Logic
    local dragging, dragStart, startPos
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
        end
    end)
    Header.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
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

    local WindowMethods = {}

    function WindowMethods:CreateTab(name)
        local Tab = { Name = name }
        local index = #UI_Window.Tabs + 1

        local TabButton = Instance.new("TextButton", TabContainer)
        TabButton.Name = name
        TabButton.BackgroundColor3 = Color3.fromRGB(236, 233, 216)
        TabButton.Size = UDim2.new(0, 100, 1, 0)
        TabButton.Position = UDim2.new(0, (index - 1) * 105, 0, 0)
        TabButton.Font = Enum.Font.Arial -- Corrected Font
        TabButton.Text = name
        TabButton.TextSize = 14
        TabButton.TextColor3 = Color3.fromRGB(0, 0, 0)
        TabButton.ZIndex = 2
        TabButton.BorderSizePixel = 1
        TabButton.BorderColor3 = Color3.fromRGB(128, 128, 128)

        local TabContent = Instance.new("ScrollingFrame", ContentContainer)
        Tab.ContentFrame = TabContent
        TabContent.BackgroundTransparency = 1
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.Visible = false
        TabContent.ScrollBarThickness = 6
        TabContent.CanvasSize = UDim2.new(0,0,0,0)
        
        local ContentLayout = Instance.new("UIListLayout", TabContent)
        ContentLayout.Padding = UDim.new(0, 8)
        ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        
        local ContentPadding = Instance.new("UIPadding", TabContent)
        ContentPadding.PaddingTop = UDim.new(0, 10)
        ContentPadding.PaddingLeft = UDim.new(0, 10)
        ContentPadding.PaddingRight = UDim.new(0, 10)

        local function SwitchToTab()
            for _, t in pairs(UI_Window.Tabs) do
                t.ContentFrame.Visible = false
                t.Button.BackgroundColor3 = Color3.fromRGB(236, 233, 216)
                t.Button.ZIndex = 2
            end
            TabContent.Visible = true
            TabButton.BackgroundColor3 = Color3.fromRGB(236, 233, 216) -- Selected tab color
            TabButton.ZIndex = 3
        end

        TabButton.MouseButton1Click:Connect(SwitchToTab)
        Tab.Button = TabButton
        table.insert(UI_Window.Tabs, Tab)
        if #UI_Window.Tabs == 1 then
            SwitchToTab()
        end

        local ElementMethods = {}

        -- AddLabel
        function ElementMethods:AddLabel(text)
            local Label = Instance.new("TextLabel", TabContent)
            Label.BackgroundTransparency = 1
            Label.Size = UDim2.new(1, 0, 0, 20)
            Label.Font = Enum.Font.Arial -- Corrected Font
            Label.Text = text
            Label.TextColor3 = Color3.fromRGB(0, 0, 0)
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
            return {}
        end

        -- AddButton
        function ElementMethods:AddButton(btnConfig)
            local Button = Instance.new("TextButton", TabContent)
            Button.BackgroundColor3 = Color3.fromRGB(236, 233, 216)
            Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Button.Size = UDim2.new(0, 120, 0, 28)
            Button.Font = Enum.Font.Arial -- Corrected Font
            Button.Text = btnConfig.Name or "Button"
            Button.TextColor3 = Color3.fromRGB(0, 0, 0)
            Button.TextSize = 14
            Button.MouseButton1Click:Connect(function()
                pcall(btnConfig.Callback)
            end)
            return {}
        end

        -- AddToggle
        function ElementMethods:AddToggle(toggleConfig)
            local toggled = false
            local Frame = Instance.new("Frame", TabContent)
            Frame.BackgroundTransparency = 1
            Frame.Size = UDim2.new(1, 0, 0, 25)

            local Checkbox = Instance.new("Frame", Frame)
            Checkbox.Size = UDim2.new(0, 13, 0, 13)
            Checkbox.Position = UDim2.new(0, 0, 0.5, 0)
            Checkbox.AnchorPoint = Vector2.new(0, 0.5)
            Checkbox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Checkbox.BorderColor3 = Color3.fromRGB(0, 0, 0)

            local CheckMark = Instance.new("TextLabel", Checkbox)
            CheckMark.Size = UDim2.new(1, 0, 1, 0)
            CheckMark.Font = Enum.Font.Arial -- Corrected Font
            CheckMark.Text = "✔"
            CheckMark.TextScaled = true
            CheckMark.TextColor3 = Color3.fromRGB(0, 0, 0)
            CheckMark.BackgroundTransparency = 1
            CheckMark.Visible = false

            local Label = Instance.new("TextLabel", Frame)
            Label.BackgroundTransparency = 1
            Label.Size = UDim2.new(1, -20, 1, 0)
            Label.Position = UDim2.new(0, 20, 0, 0)
            Label.Font = Enum.Font.Arial -- Corrected Font
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
            return {}
        end
        
        return ElementMethods
    end

    -- Toggle visibility function
    function XP_UI:Toggle()
        UI_Window.Visible = not UI_Window.Visible
        UI_Window.ScreenGui.Enabled = UI_Window.Visible
    end

    return WindowMethods
end

return XP_UI
