I'll create a comprehensive Roblox script with all the features you requested. This will be a sophisticated custom menu with ESP, visual effects, and various player enhancements.

```lua
-- Roblox Custom Menu Script with ESP and Features
-- Created for educational purposes

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local TextService = game:GetService("TextService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- Configuration
local Config = {
    ESP = {
        Enabled = true,
        ShowDistance = true,
        ShowHP = true,
        ShowItems = true,
        MaxDistance = 500,
        Color = Color3.new(0, 1, 0)
    },
    Visuals = {
        FOVCircle = {
            Enabled = true,
            Radius = 90,
            Color = Color3.new(1, 1, 1),
            Transparency = 0.5
        },
        Particles = {
            Enabled = true,
            Type = "snowflakes", -- snowflakes, hearts, dollars
            Density = 50
        },
        Jumpscare = {
            Enabled = false,
            Radius = 30,
            Color = Color3.new(1, 0, 0)
        }
    },
    Movement = {
        BunnyHop = false,
        WalkSpeed = 16,
        JumpPower = 50
    },
    Camera = {
        SideView = false,
        Offset = 10
    }
}

-- Main GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CustomMenu"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Menu Frame
local MenuFrame = Instance.new("Frame")
MenuFrame.Name = "MainMenu"
MenuFrame.Parent = ScreenGui
MenuFrame.Size = UDim2.new(0, 400, 0, 600)
MenuFrame.Position = UDim2.new(0.5, -200, 0.5, -300)
MenuFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
MenuFrame.BackgroundTransparency = 0.3
MenuFrame.BorderSizePixel = 0
MenuFrame.Active = true
MenuFrame.Draggable = true

-- Decorative Crossed Swords
local Sword1 = Instance.new("ImageLabel")
Sword1.Name = "Sword1"
Sword1.Parent = MenuFrame
Sword1.Size = UDim2.new(0, 100, 0, 150)
Sword1.Position = UDim2.new(0, 150, 0, 20)
Sword1.BackgroundTransparency = 1
Sword1.Image = "rbxassetid://1492475961" -- Sword image
Sword1.Rotation = -30

local Sword2 = Instance.new("ImageLabel")
Sword2.Name = "Sword2"
Sword2.Parent = MenuFrame
Sword2.Size = UDim2.new(0, 100, 0, 150)
Sword2.Position = UDim2.new(0, 150, 0, 20)
Sword2.BackgroundTransparency = 1
Sword2.Image = "rbxassetid://1492475961" -- Sword image
Sword2.Rotation = 30

-- Settings Icon
local SettingsButton = Instance.new("TextButton")
SettingsButton.Name = "SettingsButton"
SettingsButton.Parent = MenuFrame
SettingsButton.Size = UDim2.new(0, 40, 0, 40)
SettingsButton.Position = UDim2.new(1, -50, 0, 10)
SettingsButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
SettingsButton.BorderSizePixel = 0
SettingsButton.Font = Enum.Font.SourceSansBold
SettingsButton.Text = "⚙"
SettingsButton.TextSize = 20
SettingsButton.TextColor3 = Color3.new(1, 1, 1)

-- Menu Sections
local function createSection(name, y)
    local Section = Instance.new("Frame")
    Section.Name = name
    Section.Parent = MenuFrame
    Section.Size = UDim2.new(0, 360, 0, 80)
    Section.Position = UDim2.new(0, 20, 0, y)
    Section.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
    Section.BackgroundTransparency = 0.5
    Section.BorderSizePixel = 0
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Parent = Section
    Title.Size = UDim2.new(0, 360, 0, 25)
    Title.Position = UDim2.new(0, 0, 0, 0)
    Title.BackgroundColor3 = Color3.new(0, 0, 0)
    Title.BackgroundTransparency = 0.7
    Title.BorderSizePixel = 0
    Title.Font = Enum.Font.SourceSansBold
    Title.Text = name
    Title.TextSize = 16
    Title.TextColor3 = Color3.new(1, 1, 1)
    
    return Section
end

-- Create menu sections
local ESPSection = createSection("ESP Settings", 180)
local VisualSection = createSection("Visual Settings", 270)
local MovementSection = createSection("Movement Settings", 360)
local ConfigSection = createSection("Config", 450)

-- ESP Toggles
local function createToggle(parent, name, y, callback)
    local Toggle = Instance.new("TextButton")
    Toggle.Name = name
    Toggle.Parent = parent
    Toggle.Size = UDim2.new(0, 100, 0, 25)
    Toggle.Position = UDim2.new(0, 10, 0, y)
    Toggle.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    Toggle.BorderSizePixel = 0
    Toggle.Font = Enum.Font.SourceSans
    Toggle.Text = name
    Toggle.TextSize = 14
    Toggle.TextColor3 = Color3.new(1, 1, 1)
    
    Toggle.MouseButton1Click:Connect(function()
        callback()
        Toggle.BackgroundColor3 = Toggle.BackgroundColor3 == Color3.new(0.3, 0.3, 0.3) and Color3.new(0, 1, 0) or Color3.new(0.3, 0.3, 0.3)
    end)
    
    return Toggle
end

-- FOV Slider
local function createSlider(parent, name, y, min, max, default, callback)
    local Slider = Instance.new("Frame")
    Slider.Name = name
    Slider.Parent = parent
    Slider.Size = UDim2.new(0, 200, 0, 20)
    Slider.Position = UDim2.new(0, 10, 0, y)
    Slider.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    Slider.BorderSizePixel = 0
    
    local SliderBar = Instance.new("Frame")
    SliderBar.Name = "Bar"
    SliderBar.Parent = Slider
    SliderBar.Size = UDim2.new(0, 10, 0, 20)
    SliderBar.Position = UDim2.new((default - min) / (max - min), -5, 0, 0)
    SliderBar.BackgroundColor3 = Color3.new(0, 1, 0)
    SliderBar.BorderSizePixel = 0
    
    local Label = Instance.new("TextLabel")
    Label.Name = "Label"
    Label.Parent = Slider
    Label.Size = UDim2.new(0, 200, 0, 20)
    Label.Position = UDim2.new(0, 0, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.SourceSans
    Label.Text = name .. ": " .. default
    Label.TextSize = 12
    Label.TextColor3 = Color3.new(1, 1, 1)
    
    local dragging = false
    
    SliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local relativeX = input.Position.X - Slider.AbsolutePosition.X
            local percentage = math.clamp(relativeX / Slider.AbsoluteSize.X, 0, 1)
            local value = min + (max - min) * percentage
            
            SliderBar.Position = UDim2.new(percentage, -5, 0, 0)
            Label.Text = name .. ": " .. math.floor(value)
            callback(value)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    return Slider
end

-- Initialize ESP toggles
createToggle
