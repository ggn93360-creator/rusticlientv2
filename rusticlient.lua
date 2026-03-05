-- rusticlient v24.0 - Полностью рабочая версия
-- Автор: SWILL / rusticlient

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local StarterGui = game:GetService("StarterGui")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")

-- ==================== ОПРЕДЕЛЕНИЕ УСТРОЙСТВА ====================

local isMobile = UserInputService.TouchEnabled
local injectorType = "UNKNOWN"

if identifyexecutor then
    injectorType = identifyexecutor()
end

-- ==================== КОНФИГИ ====================

local configFolder = "rusticlient_configs"

if not isfolder(configFolder) then
    makefolder(configFolder)
end

-- ==================== GUI ====================

for _, v in ipairs(CoreGui:GetChildren()) do
    if v.Name == "rusticlient" then
        v:Destroy()
    end
end

local gui = Instance.new("ScreenGui")
gui.Name = "rusticlient"
gui.ResetOnSpawn = false
gui.Parent = CoreGui

-- ==================== КНОПКА С АВАТАРКОЙ ====================

local menuButton = Instance.new("ImageButton")
menuButton.Size = UDim2.new(0, 70, 0, 70)
menuButton.Position = UDim2.new(0, 15, 0.5, -35)
menuButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
menuButton.BackgroundTransparency = 0
menuButton.Image = "rbxassetid://90064663091843"
menuButton.Visible = isMobile
menuButton.Parent = gui

local menuButtonCorner = Instance.new("UICorner")
menuButtonCorner.CornerRadius = UDim.new(1, 0)
menuButtonCorner.Parent = menuButton

local menuButtonStroke = Instance.new("UIStroke")
menuButtonStroke.Color = Color3.fromRGB(255, 50, 50)
menuButtonStroke.Thickness = 2
menuButtonStroke.Parent = menuButton

-- ==================== МЕНЮ ====================

local menu = Instance.new("Frame")
menu.Size = UDim2.new(0, 500, 0, 600)
menu.Position = UDim2.new(0.5, -250, 0.5, -300)
menu.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
menu.BackgroundTransparency = 0.1
menu.Visible = false
menu.Active = true
menu.Draggable = true
menu.Parent = gui

local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0, 15)
menuCorner.Parent = menu

-- Заголовок
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 45)
title.BackgroundTransparency = 1
title.Text = "RUSTICLIENT v24.0"
title.TextColor3 = Color3.fromRGB(255, 100, 100)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = menu

-- Инфо
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, -20, 0, 25)
infoLabel.Position = UDim2.new(0, 10, 0, 45)
infoLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
infoLabel.Text = "Device: " .. (isMobile and "📱 Mobile" or "💻 PC") .. " | " .. injectorType
infoLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
infoLabel.TextScaled = true
infoLabel.Font = Enum.Font.SourceSans
infoLabel.Parent = menu

local infoCorner = Instance.new("UICorner")
infoCorner.CornerRadius = UDim.new(0, 8)
infoCorner.Parent = infoLabel

-- ==================== ВКЛАДКИ ====================

local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, -20, 0, 40)
tabFrame.Position = UDim2.new(0, 10, 0, 75)
tabFrame.BackgroundTransparency = 1
tabFrame.Parent = menu

local tabs = {"ESP", "AIMBOT", "MOVEMENT", "PLAYER", "RENDER", "CONFIGS"}
local tabButtons = {}
local tabContents = {}

for i, tabName in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1/6, -4, 1, -4)
    btn.Position = UDim2.new((i-1)/6, 2, 0, 2)
    btn.BackgroundColor3 = i == 1 and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(40, 40, 50)
    btn.Text = tabName
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.Parent = tabFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    tabButtons[tabName] = btn
end

local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -20, 1, -130)
contentFrame.Position = UDim2.new(0, 10, 0, 120)
contentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
contentFrame.Parent = menu

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 10)
contentCorner.Parent = contentFrame

for _, tabName in ipairs(tabs) do
    local scroller = Instance.new("ScrollingFrame")
    scroller.Name = tabName
    scroller.Size = UDim2.new(1, -10, 1, -10)
    scroller.Position = UDim2.new(0, 5, 0, 5)
    scroller.BackgroundTransparency = 1
    scroller.BorderSizePixel = 0
    scroller.ScrollBarThickness = 6
    scroller.ScrollBarImageColor3 = Color3.fromRGB(255, 50, 50)
    scroller.CanvasSize = UDim2.new(0, 0, 0, 600)
    scroller.Visible = (tabName == "ESP")
    scroller.Parent = contentFrame
    tabContents[tabName] = scroller
end

-- ==================== НАСТРОЙКИ ====================

local Settings = {
    ESP = {
        Enabled = false,
        Box = true,
        Name = true,
        Health = true,
        Distance = true,
        Wallhack = true,
        BoxColor = Color3.new(1, 0, 0),
        NameColor = Color3.new(1, 1, 1)
    },
    Aimbot = {
        Enabled = false,
        FOV = 200,
        Smooth = 5,
        AutoFire = false,
        TeamCheck = true,
        ShowFOV = true,
        TargetPart = "Head",
        FOVColor = Color3.new(1, 0, 0)
    },
    Movement = {
        Speed = false,
        SpeedAmount = 32,
        NoFall = false,
        NoJumpCD = false,
        InfiniteJump = false,
        NoClip = false
    },
    Player = {
        GodMode = false
    },
    Render = {
        RemoveGrass = false,
        RemoveFog = false,
        FullBright = false,
        PotatoGraphics = false
    }
}

-- ==================== ФУНКЦИИ ДЛЯ ПЕРЕКЛЮЧАТЕЛЕЙ ====================

local function createToggle(parent, name, yPos, category, setting)
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(0.9, 0, 0, 35)
    bg.Position = UDim2.new(0.05, 0, 0, yPos)
    bg.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    bg.Parent = parent
    
    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(0, 8)
    bgCorner.Parent = bg
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, -5, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextScaled = true
    label.Font = Enum.Font.SourceSans
    label.Parent = bg
    
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 50, 0, 25)
    toggle.Position = UDim2.new(1, -60, 0.5, -12.5)
    toggle.BackgroundColor3 = Settings[category][setting] and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    toggle.Text = Settings[category][setting] and "ON" or "OFF"
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.TextScaled = true
    toggle.Font = Enum.Font.GothamBold
    toggle.Parent = bg
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 5)
    toggleCorner.Parent = toggle
    
    toggle.MouseButton1Click:Connect(function()
        Settings[category][setting] = not Settings[category][setting]
        toggle.BackgroundColor3 = Settings[category][setting] and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        toggle.Text = Settings[category][setting] and "ON" or "OFF"
        
        if category == "Render" then
            applyRender()
        end
    end)
    
    return bg
end

local function createSlider(parent, name, yPos, category, setting, min, max, suffix)
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(0.9, 0, 0, 45)
    bg.Position = UDim2.new(0.05, 0, 0, yPos)
    bg.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    bg.Parent = parent
    
    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(0, 8)
    bgCorner.Parent = bg
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, -5, 0.4, 0)
    label.Position = UDim2.new(0, 10, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextScaled = true
    label.Font = Enum.Font.SourceSans
    label.Parent = bg
    
    local value = Instance.new("TextLabel")
    value.Size = UDim2.new(0, 50, 0.4, 0)
    value.Position = UDim2.new(1, -60, 0, 5)
    value.BackgroundTransparency = 1
    value.Text = tostring(Settings[category][setting]) .. (suffix or "")
    value.TextColor3 = Color3.fromRGB(0, 255, 0)
    value.TextScaled = true
    value.Font = Enum.Font.GothamBold
    value.Parent = bg
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(0.7, 0, 0, 8)
    sliderBg.Position = UDim2.new(0.15, 0, 0, 28)
    sliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    sliderBg.Parent = bg
    
    local sliderBgCorner = Instance.new("UICorner")
    sliderBgCorner.CornerRadius = UDim.new(0, 4)
    sliderBgCorner.Parent = sliderBg
    
    local slider = Instance.new("Frame")
    slider.Size = UDim2.new((Settings[category][setting] - min) / (max - min), 0, 1, 0)
    slider.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    slider.Parent = sliderBg
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 4)
    sliderCorner.Parent = slider
    
    local dragging = false
    
    local function updateSlider(input)
        if not sliderBg.AbsoluteSize.X then return end
        local pos = math.clamp(input.Position.X - sliderBg.AbsolutePosition.X, 0, sliderBg.AbsoluteSize.X)
        local percent = pos / sliderBg.AbsoluteSize.X
        Settings[category][setting] = min + (max - min) * percent
        slider.Size = UDim2.new(percent, 0, 1, 0)
        value.Text = math.floor(Settings[category][setting]) .. (suffix or "")
    end
    
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateSlider(input)
        end
    end)
    
    sliderBg.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)
    
    return bg
end

-- ==================== ESP (ТВОЙ КОД) ====================

local espObjects = {}

local function createESP(player)
    if espObjects[player] then return end
    if player == LocalPlayer then return end
    
    local function onCharacterAdded(char)
        local head = char:WaitForChild("Head")
        local humanoid = char:WaitForChild("Humanoid")
        
        if not head or not humanoid then return end
        
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESP_"..player.Name
        billboard.Size = UDim2.new(0, 150, 0, 60)
        billboard.StudsOffset = Vector3.new(0, 2.5, 0)
        billboard.AlwaysOnTop = Settings.ESP.Wallhack
        billboard.Parent = head
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, 0, 0.4, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.TextColor3 = Settings.ESP.NameColor
        nameLabel.TextScaled = true
        nameLabel.Text = player.Name
        nameLabel.Parent = billboard
        
        local distanceLabel = Instance.new("TextLabel")
        distanceLabel.Size = UDim2.new(1, 0, 0.3, 0)
        distanceLabel.Position = UDim2.new(0, 0, 0.4, 0)
        distanceLabel.BackgroundTransparency = 1
        distanceLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
        distanceLabel.TextScaled = true
        distanceLabel.Parent = billboard
        
        local hpBarBG = Instance.new("Frame")
        hpBarBG.Size = UDim2.new(1, 0, 0.3, 0)
        hpBarBG.Position = UDim2.new(0, 0, 0.7, 0)
        hpBarBG.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        hpBarBG.Parent = billboard
        
        local hpBar = Instance.new("Frame")
        hpBar.Size = UDim2.new(1, 0, 1, 0)
        hpBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        hpBar.Parent = hpBarBG
        
        espObjects[player] = {
            billboard = billboard,
            nameLabel = nameLabel,
            distanceLabel = distanceLabel,
            hpBarBG = hpBarBG,
            hpBar = hpBar,
            char = char,
            humanoid = humanoid
        }
    end
    
    if player.Character then
        onCharacterAdded(player.Character)
    end
    
    player.CharacterAdded:Connect(onCharacterAdded)
end

-- Обновление ESP
RunService.RenderStepped:Connect(function()
    if not Settings.ESP.Enabled then
        for player, obj in pairs(espObjects) do
            if obj.billboard then
                obj.billboard.Enabled = false
            end
        end
        return
    end
    
    for player, obj in pairs(espObjects) do
        if obj.billboard and obj.char and obj.humanoid then
            obj.billboard.Enabled = true
            obj.billboard.AlwaysOnTop = Settings.ESP.Wallhack
            obj.nameLabel.Visible = Settings.ESP.Name
            obj.nameLabel.TextColor3 = Settings.ESP.NameColor
            obj.distanceLabel.Visible = Settings.ESP.Distance
            obj.hpBarBG.Visible = Settings.ESP.Health
            
            local charLocal = LocalPlayer.Character
            if charLocal then
                local rootLocal = charLocal:FindFirstChild("HumanoidRootPart")
                local rootTarget = obj.char:FindFirstChild("HumanoidRootPart")
                
                if rootLocal and rootTarget then
                    local dist = (rootLocal.Position - rootTarget.Position).Magnitude
                    obj.distanceLabel.Text = "Distance: " .. math.floor(dist)
                end
            end
            
            local hp = obj.humanoid.Health / obj.humanoid.MaxHealth
            obj.hpBar.Size = UDim2.new(hp, 0, 1, 0)
            
            -- Цвет полоски здоровья
            if hp > 0.6 then
                obj.hpBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            elseif hp > 0.3 then
                obj.hpBar.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
            else
                obj.hpBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            end
        end
    end
end)

-- ==================== AIMBOT FOV КРУГ ====================

local fovCircle = Instance.new("Frame")
fovCircle.Size = UDim2.new(0, Settings.Aimbot.FOV * 2, 0, Settings.Aimbot.FOV * 2)
fovCircle.Position = UDim2.new(0.5, -Settings.Aimbot.FOV, 0.5, -Settings.Aimbot.FOV)
fovCircle.BackgroundTransparency = 1
fovCircle.BorderColor3 = Settings.Aimbot.FOVColor
fovCircle.BorderSizePixel = 2
fovCircle.Visible = Settings.Aimbot.ShowFOV
fovCircle.Parent = gui

local fovCircleCorner = Instance.new("UICorner")
fovCircleCorner.CornerRadius = UDim.new(1, 0)
fovCircleCorner.Parent = fovCircle

-- ==================== AIMBOT ====================

local function getTargetPart(player)
    if not player.Character then return nil end
    if Settings.Aimbot.TargetPart == "Head" then
        return player.Character:FindFirstChild("Head")
    else
        return player.Character:FindFirstChild("HumanoidRootPart")
    end
end

local function getClosestPlayer()
    local closest = nil
    local closestPart = nil
    local closestDist = Settings.Aimbot.FOV
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
            local humanoid = player.Character.Humanoid
            if humanoid and humanoid.Health > 0 then
                if Settings.Aimbot.TeamCheck and player.Team == LocalPlayer.Team then
                    continue
                end
                
                local targetPart = getTargetPart(player)
                if targetPart then
                    local pos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                    if onScreen then
                        local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                        if dist < closestDist then
                            closestDist = dist
                            closest = targetPart
                        end
                    end
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    -- Обновление FOV круга
    fovCircle.Visible = Settings.Aimbot.ShowFOV
    fovCircle.Size = UDim2.new(0, Settings.Aimbot.FOV * 2, 0, Settings.Aimbot.FOV * 2)
    fovCircle.Position = UDim2.new(0.5, -Settings.Aimbot.FOV, 0.5, -Settings.Aimbot.FOV)
    fovCircle.BorderColor3 = Settings.Aimbot.FOVColor
    
    -- Aimbot
    if Settings.Aimbot.Enabled then
        local target = getClosestPlayer()
        if target then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, target.Position), 1 / Settings.Aimbot.Smooth)
            
            if Settings.Aimbot.AutoFire then
                mouse1press()
                wait(0.01)
                mouse1release()
            end
        end
    end
end)

-- ==================== SPEED HACK (ТОЛЬКО ПО ЗАЖАТИЮ CTRL) ====================

local speedActive = false

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.LeftControl then
        speedActive = true
    end
end)

UserInputService.InputEnded:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.LeftControl then
        speedActive = false
    end
end)

local function doSpeed()
    if not Settings.Movement.Speed or not speedActive or not LocalPlayer.Character then return end
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if humanoid and root and humanoid.MoveDirection.Magnitude > 0 then
        root.Velocity = root.Velocity + humanoid.MoveDirection * (Settings.Movement.SpeedAmount - 16)
    end
end

-- ==================== NO FALL ====================

local function doNoFall()
    if not Settings.Movement.NoFall or not LocalPlayer.Character then return end
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if humanoid and root and humanoid:GetState() == Enum.HumanoidStateType.Freefall then
        if root.Velocity.Y < -50 then
            root.Velocity = Vector3.new(root.Velocity.X, -10, root.Velocity.Z)
        end
    end
end

-- ==================== NO JUMP CD ====================

local function doNoJumpCD()
    if not Settings.Movement.NoJumpCD or not LocalPlayer.Character then return end
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid and UserInputService:IsKeyDown(Enum.KeyCode.Space) and humanoid.FloorMaterial then
        humanoid.Jump = true
    end
end

-- ==================== INFINITE JUMP ====================

local function doInfiniteJump()
    if not Settings.Movement.InfiniteJump or not LocalPlayer.Character then return end
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        humanoid.Jump = true
    end
end

-- ==================== NO CLIP ====================

local function doNoClip()
    if not Settings.Movement.NoClip or not LocalPlayer.Character then return end
    for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end

-- ==================== GOD MODE ====================

local function doGodMode()
    if not Settings.Player.GodMode or not LocalPlayer.Character then return end
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid and humanoid.Health < humanoid.MaxHealth then
        humanoid.Health = humanoid.MaxHealth
    end
end

-- ==================== RENDER ====================

local function applyRender()
    -- Remove Grass
    if Settings.Render.RemoveGrass then
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("Terrain") then
                obj:Clear()
            end
        end
    end
    
    -- Remove Fog
    if Settings.Render.RemoveFog then
        Lighting.FogEnd = 100000
    else
        Lighting.FogEnd = 80
    end
    
    -- Full Bright
    if Settings.Render.FullBright then
        Lighting.Brightness = 3
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    else
        Lighting.Brightness = 1
        Lighting.GlobalShadows = true
        Lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
    end
    
    -- Potato Graphics
    if Settings.Render.PotatoGraphics then
        Lighting.GlobalShadows = false
        Lighting.Ambient = Color3.new(0.8, 0.8, 0.8)
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                obj.Material = Enum.Material.Plastic
                obj.Reflectance = 0
                obj.CastShadow = false
            end
        end
    end
end

-- ==================== ЗАПОЛНЯЕМ ВКЛАДКИ ====================

-- ESP вкладка
local espScroller = tabContents["ESP"]
local y = 5
createToggle(espScroller, "ESP", y, "ESP", "Enabled"); y = y + 40
createToggle(espScroller, "Box", y, "ESP", "Box"); y = y + 40
createToggle(espScroller, "Name", y, "ESP", "Name"); y = y + 40
createToggle(espScroller, "Health", y, "ESP", "Health"); y = y + 40
createToggle(espScroller, "Distance", y, "ESP", "Distance"); y = y + 40
createToggle(espScroller, "Wallhack", y, "ESP", "Wallhack"); y = y + 40
espScroller.CanvasSize = UDim2.new(0, 0, 0, y)

-- AIMBOT вкладка
local aimScroller = tabContents["AIMBOT"]
y = 5
createToggle(aimScroller, "Aimbot", y, "Aimbot", "Enabled"); y = y + 40
createSlider(aimScroller, "FOV", y, "Aimbot", "FOV", 50, 500, ""); y = y + 50
createSlider(aimScroller, "Smooth", y, "Aimbot", "Smooth", 1, 20, ""); y = y + 50
createToggle(aimScroller, "Auto Fire", y, "Aimbot", "AutoFire"); y = y + 40
createToggle(aimScroller, "Team Check", y, "Aimbot", "TeamCheck"); y = y + 40
createToggle(aimScroller, "Show FOV", y, "Aimbot", "ShowFOV"); y = y + 40
aimScroller.CanvasSize = UDim2.new(0, 0, 0, y)

-- MOVEMENT вкладка
local moveScroller = tabContents["MOVEMENT"]
y = 5
createToggle(moveScroller, "Speed (Hold CTRL)", y, "Movement", "Speed"); y = y + 40
createSlider(moveScroller, "Speed Amount", y, "Movement", "SpeedAmount", 16, 100, ""); y = y + 50
createToggle(moveScroller, "No Fall", y, "Movement", "NoFall"); y = y + 40
createToggle(moveScroller, "No Jump CD", y, "Movement", "NoJumpCD"); y = y + 40
createToggle(moveScroller, "Infinite Jump", y, "Movement", "InfiniteJump"); y = y + 40
createToggle(moveScroller, "No Clip", y, "Movement", "NoClip"); y = y + 40
moveScroller.CanvasSize = UDim2.new(0, 0, 0, y)

-- PLAYER вкладка
local playerScroller = tabContents["PLAYER"]
y = 5
createToggle(playerScroller, "God Mode", y, "Player", "GodMode"); y = y + 40
playerScroller.CanvasSize = UDim2.new(0, 0, 0, y)

-- RENDER вкладка
local renderScroller = tabContents["RENDER"]
y = 5
createToggle(renderScroller, "Remove Grass", y, "Render", "RemoveGrass"); y = y + 40
createToggle(renderScroller, "Remove Fog", y, "Render", "RemoveFog"); y = y + 40
createToggle(renderScroller, "Full Bright", y, "Render", "FullBright"); y = y + 40
createToggle(renderScroller, "Potato Graphics", y, "Render", "PotatoGraphics"); y = y + 40
renderScroller.CanvasSize = UDim2.new(0, 0, 0, y)

-- CONFIGS вкладка
local configScroller = tabContents["CONFIGS"]
y = 5

local configName = Instance.new("TextBox")
configName.Size = UDim2.new(0.8, 0, 0, 35)
configName.Position = UDim2.new(0.1, 0, 0, y)
configName.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
configName.TextColor3 = Color3.fromRGB(255, 255, 255)
configName.PlaceholderText = "Config name"
configName.Text = ""
configName.TextScaled = true
configName.Font = Enum.Font.SourceSans
configName.Parent = configScroller
y = y + 40

local saveBtn = Instance.new("TextButton")
saveBtn.Size = UDim2.new(0.35, 0, 0, 35)
saveBtn.Position = UDim2.new(0.1, 0, 0, y)
saveBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
saveBtn.Text = "Save"
saveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
saveBtn.TextScaled = true
saveBtn.Font = Enum.Font.GothamBold
saveBtn.Parent = configScroller

local saveCorner = Instance.new("UICorner")
saveCorner.CornerRadius = UDim.new(0, 8)
saveCorner.Parent = saveBtn

local loadBtn = Instance.new("TextButton")
loadBtn.Size = UDim2.new(0.35, 0, 0, 35)
loadBtn.Position = UDim2.new(0.55, 0, 0, y)
loadBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
loadBtn.Text = "Load"
loadBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
loadBtn.TextScaled = true
loadBtn.Font = Enum.Font.GothamBold
loadBtn.Parent = configScroller

local loadCorner = Instance.new("UICorner")
loadCorner.CornerRadius = UDim.new(0, 8)
loadCorner.Parent = loadBtn

y = y + 45

local configsList = Instance.new("TextLabel")
configsList.Size = UDim2.new(0.8, 0, 0, 100)
configsList.Position = UDim2.new(0.1, 0, 0, y)
configsList.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
configsList.Text = "Available configs:\n"
configsList.TextColor3 = Color3.fromRGB(200, 200, 255)
configsList.TextScaled = true
configsList.Font = Enum.Font.SourceSans
configsList.Parent = configScroller

local listCorner = Instance.new("UICorner")
listCorner.CornerRadius = UDim.new(0, 8)
listCorner.Parent = configsList

y = y + 110

local function updateConfigsList()
    local files = listfiles(configFolder)
    local list = "Available configs:\n"
    for _, file in ipairs(files) do
        if file:match("%.json$") then
            list = list .. file:gsub(configFolder .. "/", ""):gsub("%.json$", "") .. "\n"
        end
    end
    configsList.Text = list
end

updateConfigsList()

saveBtn.MouseButton1Click:Connect(function()
    local name = configName.Text
    if name and name ~= "" then
        local data = HttpService:JSONEncode(Settings)
        writefile(configFolder .. "/" .. name .. ".json", data)
        updateConfigsList()
        StarterGui:SetCore("SendNotification", {
            Title = "Config Saved",
            Text = "Saved as: " .. name,
            Duration = 2
        })
    end
end)

loadBtn.MouseButton1Click:Connect(function()
    local name = configName.Text
    if name and name ~= "" then
        local file = configFolder .. "/" .. name .. ".json"
        if isfile(file) then
            local data = readfile(file)
            local newSettings = HttpService:JSONDecode(data)
            for cat, sets in pairs(newSettings) do
                if Settings[cat] then
                    for key, val in pairs(sets) do
                        Settings[cat][key] = val
                    end
                end
            end
            StarterGui:SetCore("SendNotification", {
                Title = "Config Loaded",
                Text = "Loaded: " .. name,
                Duration = 2
            })
        end
    end
end)

configScroller.CanvasSize = UDim2.new(0, 0, 0, y)

-- ==================== ПЕРЕКЛЮЧЕНИЕ ВКЛАДОК ====================

for i, tabName in ipairs(tabs) do
    tabButtons[tabName].MouseButton1Click:Connect(function()
        for _, btn in pairs(tabButtons) do
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        end
        tabButtons[tabName].BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        
        for _, scroller in pairs(tabContents) do
            scroller.Visible = false
        end
        tabContents[tabName].Visible = true
    end)
end

-- ==================== ГЛАВНЫЙ ЦИКЛ ====================

RunService.Heartbeat:Connect(function()
    doSpeed()
    doNoFall()
    doNoJumpCD()
    doInfiniteJump()
    doNoClip()
    doGodMode()
    applyRender()
end)

-- ==================== ОТКРЫТИЕ МЕНЮ ====================

if isMobile then
    menuButton.MouseButton1Click:Connect(function()
        menu.Visible = not menu.Visible
    end)
else
    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == Enum.KeyCode.RightShift then
            menu.Visible = not menu.Visible
        end
    end)
end

-- ==================== ИНИЦИАЛИЗАЦИЯ ====================

task.wait(1)

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        createESP(player)
    end
end

Players.PlayerAdded:Connect(createESP)

StarterGui:SetCore("SendNotification", {
    Title = "rusticlient v24.0",
    Text = "Working version - No extra stuff!",
    Duration = 3
})

print("✅ rusticlient v24.0 загружен!")
print("📌 ESP - РАБОТАЕТ!")
print("📌 Speed - РАБОТАЕТ (зажми CTRL)!")
print("📌 Aimbot - РАБОТАЕТ!")
print("📌 Конфиги - РАБОТАЮТ!")
