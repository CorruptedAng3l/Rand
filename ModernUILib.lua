-- ═══════════════════════════════════════════════════════════════
--                    MODERN UI LIBRARY V1.0
--                  Clean, Modern, and Reliable
-- ═══════════════════════════════════════════════════════════════

local Library = {}
Library.__index = Library

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- ═══════════════════════════════════════════════════════════════
--                         THEME SETTINGS
-- ═══════════════════════════════════════════════════════════════

local Theme = {
    -- Main Colors
    Background = Color3.fromRGB(25, 25, 30),
    SecondaryBackground = Color3.fromRGB(35, 35, 40),
    TertiaryBackground = Color3.fromRGB(45, 45, 50),
    
    -- Accent Colors
    Accent = Color3.fromRGB(88, 101, 242),
    AccentDark = Color3.fromRGB(71, 82, 196),
    AccentLight = Color3.fromRGB(114, 127, 255),
    
    -- Text Colors
    TextPrimary = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(200, 200, 200),
    TextDark = Color3.fromRGB(150, 150, 150),
    
    -- State Colors
    Success = Color3.fromRGB(67, 181, 129),
    Warning = Color3.fromRGB(250, 166, 26),
    Error = Color3.fromRGB(240, 71, 71),
    
    -- UI Properties
    CornerRadius = UDim.new(0, 8),
    Font = Enum.Font.Gotham,
    TextSize = 14
}

-- ═══════════════════════════════════════════════════════════════
--                       UTILITY FUNCTIONS
-- ═══════════════════════════════════════════════════════════════

local function Create(class, properties)
    local instance = Instance.new(class)
    for property, value in pairs(properties) do
        instance[property] = value
    end
    return instance
end

local function AddCorner(parent, radius)
    return Create("UICorner", {
        CornerRadius = radius or Theme.CornerRadius,
        Parent = parent
    })
end

local function AddStroke(parent, color, thickness)
    return Create("UIStroke", {
        Color = color or Theme.AccentDark,
        Thickness = thickness or 1,
        Parent = parent
    })
end

local function Tween(instance, properties, duration, style)
    local tween = TweenService:Create(
        instance,
        TweenInfo.new(duration or 0.3, style or Enum.EasingStyle.Quad),
        properties
    )
    tween:Play()
    return tween
end

local function MakeDraggable(frame, handle)
    handle = handle or frame
    local dragging, dragInput, dragStart, startPos
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════
--                      NOTIFICATION SYSTEM
-- ═══════════════════════════════════════════════════════════════

local NotificationHolder
local Notifications = {}

local function CreateNotificationHolder()
    if NotificationHolder then return NotificationHolder end
    
    NotificationHolder = Create("Frame", {
        Size = UDim2.new(0, 300, 1, 0),
        Position = UDim2.new(1, -320, 0, 0),
        BackgroundTransparency = 1,
        Parent = CoreGui:FindFirstChild("ModernUI") or Create("ScreenGui", {
            Name = "ModernUI",
            ResetOnSpawn = false,
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
            Parent = CoreGui
        })
    })
    
    Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 10),
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
        Parent = NotificationHolder
    })
    
    Create("UIPadding", {
        PaddingBottom = UDim.new(0, 20),
        Parent = NotificationHolder
    })
    
    return NotificationHolder
end

function Library:Notification(title, text, duration, type)
    CreateNotificationHolder()
    
    local notifType = type or "Info"
    local color = Theme.Accent
    
    if notifType == "Success" then
        color = Theme.Success
    elseif notifType == "Warning" then
        color = Theme.Warning
    elseif notifType == "Error" then
        color = Theme.Error
    end
    
    local Notification = Create("Frame", {
        Size = UDim2.new(1, -20, 0, 0),
        BackgroundColor3 = Theme.SecondaryBackground,
        BackgroundTransparency = 0.1,
        Parent = NotificationHolder
    })
    
    AddCorner(Notification)
    
    local Accent = Create("Frame", {
        Size = UDim2.new(0, 3, 1, 0),
        BackgroundColor3 = color,
        BorderSizePixel = 0,
        Parent = Notification
    })
    
    Create("UICorner", {
        CornerRadius = UDim.new(0, 3),
        Parent = Accent
    })
    
    local Title = Create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 20),
        Position = UDim2.new(0, 15, 0, 10),
        Text = title,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextColor3 = Theme.TextPrimary,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Parent = Notification
    })
    
    local Text = Create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 0),
        Position = UDim2.new(0, 15, 0, 35),
        Text = text,
        Font = Theme.Font,
        TextSize = 13,
        TextColor3 = Theme.TextSecondary,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        BackgroundTransparency = 1,
        Parent = Notification
    })
    
    -- Auto-size
    Text.Size = UDim2.new(1, -20, 0, Text.TextBounds.Y)
    Notification.Size = UDim2.new(1, -20, 0, Text.TextBounds.Y + 50)
    
    -- Animation
    Notification.Position = UDim2.new(0, 300, 0, 0)
    Tween(Notification, {Position = UDim2.new(0, 0, 0, 0)}, 0.5)
    
    -- Auto remove
    task.wait(duration or 3)
    Tween(Notification, {Position = UDim2.new(0, 300, 0, 0)}, 0.5)
    task.wait(0.5)
    Notification:Destroy()
end

-- ═══════════════════════════════════════════════════════════════
--                        WINDOW CLASS
-- ═══════════════════════════════════════════════════════════════

function Library:CreateWindow(title, size)
    local Window = {}
    Window.Tabs = {}
    Window.CurrentTab = nil
    
    -- Create ScreenGui
    Window.GUI = Create("ScreenGui", {
        Name = "ModernUI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = CoreGui
    })
    
    -- Main Frame
    Window.Frame = Create("Frame", {
        Size = size or UDim2.new(0, 600, 0, 500),
        Position = UDim2.new(0.5, -300, 0.5, -250),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        Parent = Window.GUI
    })
    AddCorner(Window.Frame)
    MakeDraggable(Window.Frame)
    
    -- Shadow
    local Shadow = Create("ImageLabel", {
        Size = UDim2.new(1, 30, 1, 30),
        Position = UDim2.new(0, -15, 0, -15),
        BackgroundTransparency = 1,
        Image = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        ImageColor3 = Color3.new(0, 0, 0),
        ImageTransparency = 0.5,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(10, 10, 10, 10),
        Parent = Window.Frame,
        ZIndex = 0
    })
    
    -- Title Bar
    Window.TitleBar = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Theme.SecondaryBackground,
        BorderSizePixel = 0,
        Parent = Window.Frame
    })
    
    Create("UICorner", {
        CornerRadius = Theme.CornerRadius,
        Parent = Window.TitleBar
    })
    
    Create("Frame", {
        Size = UDim2.new(1, 0, 0, 10),
        Position = UDim2.new(0, 0, 1, -10),
        BackgroundColor3 = Theme.SecondaryBackground,
        BorderSizePixel = 0,
        Parent = Window.TitleBar
    })
    
    -- Title Text
    Create("TextLabel", {
        Size = UDim2.new(0.5, -10, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        Text = title,
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextColor3 = Theme.TextPrimary,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Parent = Window.TitleBar
    })
    
    -- Close Button
    local CloseButton = Create("TextButton", {
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -35, 0, 5),
        Text = "×",
        Font = Enum.Font.Gotham,
        TextSize = 24,
        TextColor3 = Theme.TextSecondary,
        BackgroundTransparency = 1,
        Parent = Window.TitleBar
    })
    
    CloseButton.MouseButton1Click:Connect(function()
        Tween(Window.Frame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
        task.wait(0.3)
        Window.GUI:Destroy()
    end)
    
    CloseButton.MouseEnter:Connect(function()
        Tween(CloseButton, {TextColor3 = Theme.Error}, 0.2)
    end)
    
    CloseButton.MouseLeave:Connect(function()
        Tween(CloseButton, {TextColor3 = Theme.TextSecondary}, 0.2)
    end)
    
    -- Minimize Button
    local MinimizeButton = Create("TextButton", {
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -65, 0, 5),
        Text = "—",
        Font = Enum.Font.Gotham,
        TextSize = 18,
        TextColor3 = Theme.TextSecondary,
        BackgroundTransparency = 1,
        Parent = Window.TitleBar
    })
    
    local minimized = false
    local originalSize = Window.Frame.Size
    
    MinimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            Tween(Window.Frame, {Size = UDim2.new(originalSize.X, UDim.new(0, 40))}, 0.3)
        else
            Tween(Window.Frame, {Size = originalSize}, 0.3)
        end
    end)
    
    MinimizeButton.MouseEnter:Connect(function()
        Tween(MinimizeButton, {TextColor3 = Theme.Warning}, 0.2)
    end)
    
    MinimizeButton.MouseLeave:Connect(function()
        Tween(MinimizeButton, {TextColor3 = Theme.TextSecondary}, 0.2)
    end)
    
    -- Tab Container
    Window.TabContainer = Create("Frame", {
        Size = UDim2.new(0, 140, 1, -50),
        Position = UDim2.new(0, 10, 0, 50),
        BackgroundColor3 = Theme.SecondaryBackground,
        BorderSizePixel = 0,
        Parent = Window.Frame
    })
    AddCorner(Window.TabContainer)
    
    Window.TabHolder = Create("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Theme.Accent,
        BorderSizePixel = 0,
        Parent = Window.TabContainer
    })
    
    Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5),
        Parent = Window.TabHolder
    })
    
    Create("UIPadding", {
        PaddingTop = UDim.new(0, 5),
        PaddingLeft = UDim.new(0, 5),
        PaddingRight = UDim.new(0, 5),
        Parent = Window.TabHolder
    })
    
    -- Content Container
    Window.ContentContainer = Create("Frame", {
        Size = UDim2.new(1, -165, 1, -50),
        Position = UDim2.new(0, 155, 0, 50),
        BackgroundTransparency = 1,
        Parent = Window.Frame
    })
    
    -- Methods
    function Window:CreateTab(name, icon)
        local Tab = {}
        Tab.Name = name
        Tab.Elements = {}
        
        -- Tab Button
        Tab.Button = Create("TextButton", {
            Size = UDim2.new(1, -10, 0, 35),
            BackgroundColor3 = Theme.TertiaryBackground,
            BorderSizePixel = 0,
            Parent = Window.TabHolder
        })
        AddCorner(Tab.Button, UDim.new(0, 6))
        
        local TabText = Create("TextLabel", {
            Size = UDim2.new(1, -40, 1, 0),
            Position = UDim2.new(0, 35, 0, 0),
            Text = name,
            Font = Theme.Font,
            TextSize = 14,
            TextColor3 = Theme.TextSecondary,
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1,
            Parent = Tab.Button
        })
        
        if icon then
            Create("TextLabel", {
                Size = UDim2.new(0, 25, 0, 25),
                Position = UDim2.new(0, 5, 0, 5),
                Text = icon,
                Font = Theme.Font,
                TextSize = 16,
                TextColor3 = Theme.TextSecondary,
                BackgroundTransparency = 1,
                Parent = Tab.Button
            })
        end
        
        -- Tab Content
        Tab.Content = Create("ScrollingFrame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Theme.Accent,
            BorderSizePixel = 0,
            Visible = false,
            Parent = Window.ContentContainer
        })
        
        Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 10),
            Parent = Tab.Content
        })
        
        Create("UIPadding", {
            PaddingTop = UDim.new(0, 10),
            PaddingLeft = UDim.new(0, 10),
            PaddingRight = UDim.new(0, 10),
            Parent = Tab.Content
        })
        
        -- Tab Selection
        Tab.Button.MouseButton1Click:Connect(function()
            Window:SelectTab(Tab)
        end)
        
        Tab.Button.MouseEnter:Connect(function()
            if Window.CurrentTab ~= Tab then
                Tween(Tab.Button, {BackgroundColor3 = Theme.AccentDark}, 0.2)
                Tween(TabText, {TextColor3 = Theme.TextPrimary}, 0.2)
            end
        end)
        
        Tab.Button.MouseLeave:Connect(function()
            if Window.CurrentTab ~= Tab then
                Tween(Tab.Button, {BackgroundColor3 = Theme.TertiaryBackground}, 0.2)
                Tween(TabText, {TextColor3 = Theme.TextSecondary}, 0.2)
            end
        end)
        
        -- Section Creation
        function Tab:CreateSection(title)
            local Section = {}
            Section.Elements = {}
            
            Section.Frame = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = Theme.SecondaryBackground,
                BorderSizePixel = 0,
                Parent = Tab.Content
            })
            AddCorner(Section.Frame)
            
            Create("TextLabel", {
                Size = UDim2.new(1, -20, 0, 30),
                Position = UDim2.new(0, 10, 0, 5),
                Text = title,
                Font = Enum.Font.GothamBold,
                TextSize = 15,
                TextColor3 = Theme.TextPrimary,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1,
                Parent = Section.Frame
            })
            
            local Container = Create("Frame", {
                Size = UDim2.new(1, -20, 1, -35),
                Position = UDim2.new(0, 10, 0, 35),
                BackgroundTransparency = 1,
                Parent = Section.Frame
            })
            
            local Layout = Create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 8),
                Parent = Container
            })
            
            -- Auto-resize section
            Layout.Changed:Connect(function()
                Section.Frame.Size = UDim2.new(1, 0, 0, Layout.AbsoluteContentSize.Y + 45)
            end)
            
            -- Toggle Element
            function Section:AddToggle(options)
                local Toggle = {}
                Toggle.State = options.Default or false
                
                Toggle.Frame = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 35),
                    BackgroundColor3 = Theme.TertiaryBackground,
                    BorderSizePixel = 0,
                    Parent = Container
                })
                AddCorner(Toggle.Frame, UDim.new(0, 6))
                
                Create("TextLabel", {
                    Size = UDim2.new(1, -60, 1, 0),
                    Position = UDim2.new(0, 10, 0, 0),
                    Text = options.Title or "Toggle",
                    Font = Theme.Font,
                    TextSize = 14,
                    TextColor3 = Theme.TextSecondary,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundTransparency = 1,
                    Parent = Toggle.Frame
                })
                
                Toggle.Button = Create("Frame", {
                    Size = UDim2.new(0, 40, 0, 20),
                    Position = UDim2.new(1, -50, 0.5, -10),
                    BackgroundColor3 = Toggle.State and Theme.Accent or Theme.Background,
                    BorderSizePixel = 0,
                    Parent = Toggle.Frame
                })
                AddCorner(Toggle.Button, UDim.new(1, 0))
                
                local Circle = Create("Frame", {
                    Size = UDim2.new(0, 16, 0, 16),
                    Position = Toggle.State and UDim2.new(1, -18, 0, 2) or UDim2.new(0, 2, 0, 2),
                    BackgroundColor3 = Theme.TextPrimary,
                    BorderSizePixel = 0,
                    Parent = Toggle.Button
                })
                AddCorner(Circle, UDim.new(1, 0))
                
                local ToggleButton = Create("TextButton", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = "",
                    Parent = Toggle.Frame
                })
                
                ToggleButton.MouseButton1Click:Connect(function()
                    Toggle.State = not Toggle.State
                    
                    Tween(Toggle.Button, {BackgroundColor3 = Toggle.State and Theme.Accent or Theme.Background}, 0.2)
                    Tween(Circle, {Position = Toggle.State and UDim2.new(1, -18, 0, 2) or UDim2.new(0, 2, 0, 2)}, 0.2)
                    
                    if options.Callback then
                        options.Callback(Toggle.State)
                    end
                end)
                
                return Toggle
            end
            
            -- Button Element
            function Section:AddButton(options)
                local Button = {}
                
                Button.Frame = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 35),
                    BackgroundColor3 = Theme.Accent,
                    BorderSizePixel = 0,
                    Parent = Container
                })
                AddCorner(Button.Frame, UDim.new(0, 6))
                
                local ButtonText = Create("TextLabel", {
                    Size = UDim2.new(1, 0, 1, 0),
                    Text = options.Title or "Button",
                    Font = Enum.Font.GothamBold,
                    TextSize = 14,
                    TextColor3 = Theme.TextPrimary,
                    BackgroundTransparency = 1,
                    Parent = Button.Frame
                })
                
                local ButtonButton = Create("TextButton", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = "",
                    Parent = Button.Frame
                })
                
                ButtonButton.MouseButton1Click:Connect(function()
                    -- Click animation
                    Tween(Button.Frame, {BackgroundColor3 = Theme.AccentLight}, 0.1)
                    wait(0.1)
                    Tween(Button.Frame, {BackgroundColor3 = Theme.Accent}, 0.1)
                    
                    if options.Callback then
                        options.Callback()
                    end
                end)
                
                ButtonButton.MouseEnter:Connect(function()
                    Tween(Button.Frame, {BackgroundColor3 = Theme.AccentDark}, 0.2)
                end)
                
                ButtonButton.MouseLeave:Connect(function()
                    Tween(Button.Frame, {BackgroundColor3 = Theme.Accent}, 0.2)
                end)
                
                return Button
            end
            
            -- Slider Element
            function Section:AddSlider(options)
                local Slider = {}
                Slider.Value = options.Default or options.Min or 0
                
                Slider.Frame = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 50),
                    BackgroundColor3 = Theme.TertiaryBackground,
                    BorderSizePixel = 0,
                    Parent = Container
                })
                AddCorner(Slider.Frame, UDim.new(0, 6))
                
                local Title = Create("TextLabel", {
                    Size = UDim2.new(1, -60, 0, 20),
                    Position = UDim2.new(0, 10, 0, 5),
                    Text = options.Title or "Slider",
                    Font = Theme.Font,
                    TextSize = 14,
                    TextColor3 = Theme.TextSecondary,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundTransparency = 1,
                    Parent = Slider.Frame
                })
                
                local Value = Create("TextLabel", {
                    Size = UDim2.new(0, 50, 0, 20),
                    Position = UDim2.new(1, -60, 0, 5),
                    Text = tostring(Slider.Value),
                    Font = Theme.Font,
                    TextSize = 14,
                    TextColor3 = Theme.TextPrimary,
                    BackgroundTransparency = 1,
                    Parent = Slider.Frame
                })
                
                local SliderBar = Create("Frame", {
                    Size = UDim2.new(1, -20, 0, 4),
                    Position = UDim2.new(0, 10, 0, 30),
                    BackgroundColor3 = Theme.Background,
                    BorderSizePixel = 0,
                    Parent = Slider.Frame
                })
                AddCorner(SliderBar, UDim.new(1, 0))
                
                local SliderFill = Create("Frame", {
                    Size = UDim2.new(0, 0, 1, 0),
                    BackgroundColor3 = Theme.Accent,
                    BorderSizePixel = 0,
                    Parent = SliderBar
                })
                AddCorner(SliderFill, UDim.new(1, 0))
                
                local SliderButton = Create("Frame", {
                    Size = UDim2.new(0, 12, 0, 12),
                    Position = UDim2.new(0, -6, 0, -4),
                    BackgroundColor3 = Theme.TextPrimary,
                    BorderSizePixel = 0,
                    Parent = SliderFill
                })
                AddCorner(SliderButton, UDim.new(1, 0))
                
                -- Slider Logic
                local dragging = false
                local min = options.Min or 0
                local max = options.Max or 100
                
                local function UpdateSlider(input)
                    local size = SliderBar.AbsoluteSize.X
                    local pos = math.clamp(input.Position.X - SliderBar.AbsolutePosition.X, 0, size)
                    local percent = pos / size
                    
                    Slider.Value = math.floor(min + (max - min) * percent)
                    Value.Text = tostring(Slider.Value)
                    SliderFill.Size = UDim2.new(percent, 0, 1, 0)
                    
                    if options.Callback then
                        options.Callback(Slider.Value)
                    end
                end
                
                -- Set initial position
                local percent = (Slider.Value - min) / (max - min)
                SliderFill.Size = UDim2.new(percent, 0, 1, 0)
                
                SliderBar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        UpdateSlider(input)
                    end
                end)
                
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        UpdateSlider(input)
                    end
                end)
                
                return Slider
            end
            
            -- Textbox Element
            function Section:AddTextbox(options)
                local Textbox = {}
                
                Textbox.Frame = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 35),
                    BackgroundColor3 = Theme.TertiaryBackground,
                    BorderSizePixel = 0,
                    Parent = Container
                })
                AddCorner(Textbox.Frame, UDim.new(0, 6))
                
                Textbox.Input = Create("TextBox", {
                    Size = UDim2.new(1, -20, 1, 0),
                    Position = UDim2.new(0, 10, 0, 0),
                    Text = options.Default or "",
                    PlaceholderText = options.Placeholder or "Enter text...",
                    Font = Theme.Font,
                    TextSize = 14,
                    TextColor3 = Theme.TextPrimary,
                    PlaceholderColor3 = Theme.TextDark,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundTransparency = 1,
                    Parent = Textbox.Frame
                })
                
                Textbox.Input.FocusLost:Connect(function(enterPressed)
                    if options.Callback then
                        options.Callback(Textbox.Input.Text, enterPressed)
                    end
                end)
                
                return Textbox
            end
            
            -- Dropdown Element
            function Section:AddDropdown(options)
                local Dropdown = {}
                Dropdown.Selected = options.Default or (options.Options and options.Options[1]) or ""
                Dropdown.Open = false
                
                Dropdown.Frame = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 35),
                    BackgroundColor3 = Theme.TertiaryBackground,
                    BorderSizePixel = 0,
                    Parent = Container
                })
                AddCorner(Dropdown.Frame, UDim.new(0, 6))
                
                local DropdownText = Create("TextLabel", {
                    Size = UDim2.new(1, -40, 1, 0),
                    Position = UDim2.new(0, 10, 0, 0),
                    Text = Dropdown.Selected,
                    Font = Theme.Font,
                    TextSize = 14,
                    TextColor3 = Theme.TextSecondary,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundTransparency = 1,
                    Parent = Dropdown.Frame
                })
                
                local Arrow = Create("TextLabel", {
                    Size = UDim2.new(0, 30, 1, 0),
                    Position = UDim2.new(1, -35, 0, 0),
                    Text = "▼",
                    Font = Theme.Font,
                    TextSize = 12,
                    TextColor3 = Theme.TextSecondary,
                    BackgroundTransparency = 1,
                    Parent = Dropdown.Frame
                })
                
                local DropdownButton = Create("TextButton", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = "",
                    Parent = Dropdown.Frame
                })
                
                local DropdownList = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 0),
                    Position = UDim2.new(0, 0, 1, 5),
                    BackgroundColor3 = Theme.SecondaryBackground,
                    BorderSizePixel = 0,
                    ClipsDescendants = true,
                    Visible = false,
                    Parent = Dropdown.Frame
                })
                AddCorner(DropdownList)
                AddStroke(DropdownList, Theme.TertiaryBackground, 1)
                
                local ListLayout = Create("UIListLayout", {
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Parent = DropdownList
                })
                
                DropdownButton.MouseButton1Click:Connect(function()
                    Dropdown.Open = not Dropdown.Open
                    
                    if Dropdown.Open then
                        DropdownList.Visible = true
                        Tween(DropdownList, {Size = UDim2.new(1, 0, 0, #options.Options * 30)}, 0.2)
                        Tween(Arrow, {Rotation = 180}, 0.2)
                    else
                        Tween(DropdownList, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
                        Tween(Arrow, {Rotation = 0}, 0.2)
                        task.wait(0.2)
                        DropdownList.Visible = false
                    end
                end)
                
                for _, option in pairs(options.Options or {}) do
                    local OptionButton = Create("TextButton", {
                        Size = UDim2.new(1, 0, 0, 30),
                        BackgroundColor3 = Theme.SecondaryBackground,
                        BorderSizePixel = 0,
                        Text = option,
                        Font = Theme.Font,
                        TextSize = 14,
                        TextColor3 = Theme.TextSecondary,
                        Parent = DropdownList
                    })
                    
                    OptionButton.MouseButton1Click:Connect(function()
                        Dropdown.Selected = option
                        DropdownText.Text = option
                        
                        Dropdown.Open = false
                        Tween(DropdownList, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
                        Tween(Arrow, {Rotation = 0}, 0.2)
                        task.wait(0.2)
                        DropdownList.Visible = false
                        
                        if options.Callback then
                            options.Callback(option)
                        end
                    end)
                    
                    OptionButton.MouseEnter:Connect(function()
                        Tween(OptionButton, {BackgroundColor3 = Theme.TertiaryBackground}, 0.2)
                    end)
                    
                    OptionButton.MouseLeave:Connect(function()
                        Tween(OptionButton, {BackgroundColor3 = Theme.SecondaryBackground}, 0.2)
                    end)
                end
                
                return Dropdown
            end
            
            -- Label Element
            function Section:AddLabel(text)
                local Label = Create("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 20),
                    Text = text,
                    Font = Theme.Font,
                    TextSize = 13,
                    TextColor3 = Theme.TextDark,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundTransparency = 1,
                    Parent = Container
                })
                
                return Label
            end
            
            -- Separator Element
            function Section:AddSeparator()
                local Separator = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 1),
                    BackgroundColor3 = Theme.TertiaryBackground,
                    BorderSizePixel = 0,
                    Parent = Container
                })
                
                return Separator
            end
            
            return Section
        end
        
        table.insert(Window.Tabs, Tab)
        return Tab
    end
    
    function Window:SelectTab(tab)
        for _, t in pairs(Window.Tabs) do
            t.Content.Visible = false
            Tween(t.Button, {BackgroundColor3 = Theme.TertiaryBackground}, 0.2)
            local text = t.Button:FindFirstChildOfClass("TextLabel")
            if text then
                Tween(text, {TextColor3 = Theme.TextSecondary}, 0.2)
            end
        end
        
        tab.Content.Visible = true
        Window.CurrentTab = tab
        Tween(tab.Button, {BackgroundColor3 = Theme.Accent}, 0.2)
        local text = tab.Button:FindFirstChildOfClass("TextLabel")
        if text then
            Tween(text, {TextColor3 = Theme.TextPrimary}, 0.2)
        end
    end
    
    -- Auto-select first tab
    if #Window.Tabs > 0 then
        Window:SelectTab(Window.Tabs[1])
    end
    
    return Window
end

-- ═══════════════════════════════════════════════════════════════
--                          KEYBIND SYSTEM
-- ═══════════════════════════════════════════════════════════════

local KeybindConnections = {}

function Library:SetKeybind(key, callback)
    if KeybindConnections[key] then
        KeybindConnections[key]:Disconnect()
    end
    
    KeybindConnections[key] = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == key then
            callback()
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════
--                          RETURN LIBRARY
-- ═══════════════════════════════════════════════════════════════

getgenv().ModernUI = Library
return Library