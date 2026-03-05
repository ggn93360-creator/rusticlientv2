-- rusticlient v20.0 - Полностью рабочая версия
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
menu.Size = UDim2.new(0, 500, 0, 650)
menu.Position = UDim2.new(0.5, -250, 0.5, -325)
menu.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
menu.BackgroundTransparency = 0.1
menu.Visible = false
menu.Active = true
menu.Draggable = true
menu.Parent = gui

local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0, 15)
menuCorner.Parent = menu

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 45)
title.BackgroundTransparency = 1
title.Text = "RUSTICLIENT v20.0"
title.TextColor3 = Color3.fromRGB(255, 100, 100)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = menu

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

-- ==================== СНЕЖИНКИ (ДЛЯ ВСЕХ) ====================

local snowEmitter = Instance.new("Frame")
snowEmitter.Size = UDim2.new(1, 0, 1, 0)
snowEmitter.BackgroundTransparency = 1
snowEmitter.Parent = menu

local snowflakes = {}
local snowCount = isMobile and 8 or 15

for i = 1, snowCount do
    local snow = Instance.new("TextLabel")
    snow.Size = UDim2.new(0, isMobile and 10 or 12, 0, isMobile and 10 or 12)
    snow.Position = UDim2.new(math.random(), 0, math.random(), 0)
    snow.BackgroundTransparency = 1
    snow.Text = "❄️"
    snow.TextColor3 = Color3.fromRGB(255, 255, 255)
    snow.TextScaled = true
    snow.Parent = snowEmitter
    table.insert(snowflakes, {obj = snow, speed = math.random(2, 5) / 100})
end

spawn(function()
    while menu.Parent do
        wait(0.05)
        for _, flake in ipairs(snowflakes) do
            local pos = flake.obj.Position
            local y = pos.Y.Scale + flake.speed
            if y > 1 then
                y = 0
                flake.obj.Position = UDim2.new(math.random(), 0, 0, 0)
            else
                flake.obj.Position = UDim2.new(pos.X.Scale, 0, y, 0)
            end
        end
    end
end)

-- ==================== ВКЛАДКИ ====================

local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, -20, 0, 40)
tabFrame.Position = UDim2.new(0, 10, 0, 75)
tabFrame.BackgroundTransparency = 1
tabFrame.Parent = menu

local tabs = {"AIMBOT", "VISUALS", "MOVEMENT", "PLAYER", "RENDER", "CONFIGS"}
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
    scroller.Visible = (tabName == "AIMBOT")
    scroller.Parent = contentFrame
    tabContents[tabName] = scroller
end

-- ==================== НАСТРОЙКИ ====================

local Settings = {
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
    Visuals = {
        Enabled = false,
        Box = true,
        Name = true,
        Health = true,
        Distance = true,
        Tracer = false,
        Wallhack = true,
        BoxColor = Color3.new(1, 0, 0),
        NameColor = Color3.new(1, 1, 1)
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
        GodMode = false,
        ChineseHat = false,
        JumpTrail = false
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

-- ==================== ESP ====================

local espObjects = {}

local function createESP(player)
    if espObjects[player] then return end
    if player == LocalPlayer then return end
    
    local function onCharacterAdded(char)
        local head = char:WaitForChild("Head", 5)
        if not head then return end
        
        local billboard = Instance.new("BillboardGui")
        billboard.Size = UDim2.new(0, 200, 0, 70)
        billboard.StudsOffset = Vector3.new(0, 2, 0)
        billboard.AlwaysOnTop = Settings.Visuals.Wallhack
        billboard.Parent = head
        
        -- Name
        local nameTag = Instance.new("TextLabel")
        nameTag.Size = UDim2.new(1, 0, 0, 20)
        nameTag.Position = UDim2.new(0, 0, 0, -20)
        nameTag.BackgroundTransparency = 0.5
        nameTag.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        nameTag.Text = player.Name
        nameTag.TextColor3 = Settings.Visuals.NameColor
        nameTag.TextScaled = true
        nameTag.Font = Enum.Font.SourceSansBold
        nameTag.Parent = billboard
        
        -- Box
        local box = Instance.new("Frame")
        box.Size = UDim2.new(1, 0, 1, 0)
        box.BackgroundTransparency = 1
        box.BorderColor3 = Settings.Visuals.BoxColor
        box.BorderSizePixel = 2
        box.Parent = billboard
        
        -- Health
        local healthBg = Instance.new("Frame")
        healthBg.Size = UDim2.new(1, 0, 0, 5)
        healthBg.Position = UDim2.new(0, 0, 1, 5)
        healthBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        healthBg.Parent = billboard
        
        local healthBar = Instance.new("Frame")
        healthBar.Size = UDim2.new(1, 0, 1, 0)
        healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        healthBar.Parent = healthBg
        
        -- Distance
        local distTag = Instance.new("TextLabel")
        distTag.Size = UDim2.new(1, 0, 0, 15)
        distTag.Position = UDim2.new(0, 0, 1, 12)
        distTag.BackgroundTransparency = 0.5
        distTag.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        distTag.Text = "0m"
        distTag.TextColor3 = Color3.fromRGB(255, 255, 255)
        distTag.TextScaled = true
        distTag.Font = Enum.Font.SourceSans
        distTag.Parent = billboard
        
        espObjects[player] = {
            billboard = billboard,
            nameTag = nameTag,
            box = box,
            healthBg = healthBg,
            healthBar = healthBar,
            distTag = distTag,
            char = char
        }
    end
    
    if player.Character then
        onCharacterAdded(player.Character)
    end
    
    player.CharacterAdded:Connect(onCharacterAdded)
end

-- Обновление ESP
RunService.RenderStepped:Connect(function()
    if not Settings.Visuals.Enabled then
        for player, obj in pairs(espObjects) do
            if obj.billboard then
                obj.billboard.Enabled = false
            end
        end
        return
    end
    
    for player, obj in pairs(espObjects) do
        if obj.billboard and obj.char then
            obj.billboard.Enabled = true
            obj.billboard.AlwaysOnTop = Settings.Visuals.Wallhack
            obj.nameTag.Visible = Settings.Visuals.Name
            obj.nameTag.TextColor3 = Settings.Visuals.NameColor
            obj.box.Visible = Settings.Visuals.Box
            obj.box.BorderColor3 = Settings.Visuals.BoxColor
            obj.healthBg.Visible = Settings.Visuals.Health
            obj.distTag.Visible = Settings.Visuals.Distance
            
            local humanoid = obj.char:FindFirstChild("Humanoid")
            local root = obj.char:FindFirstChild("HumanoidRootPart")
            
            if humanoid and obj.healthBar then
                local healthPercent = humanoid.Health / humanoid.MaxHealth
                obj.healthBar.Size = UDim2.new(healthPercent, 0, 1, 0)
                obj.healthBar.BackgroundColor3 = Color3.new(1 - healthPercent, healthPercent, 0)
            end
            
            if root and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local myRoot = LocalPlayer.Character.HumanoidRootPart
                local dist = (root.Position - myRoot.Position).Magnitude
                obj.distTag.Text = math.floor(dist) .. "m"
            end
        end
    end
end)

-- ==================== КИТАЙСКАЯ ШЛЯПА (ТВОЙ КОД) ====================

local hat = nil

RunService.RenderStepped:Connect(function()
    if Settings.Player.ChineseHat then
        local char = LocalPlayer.Character
        if not char then return end
        
        local head = char:FindFirstChild("Head")
        if not head then return end
        
        if not hat then
            hat = Instance.new("Part")
            hat.Name = "RusticHat"
            hat.Shape = Enum.PartType.Cylinder
            hat.Size = Vector3.new(6, 0.4, 6)
            hat.Color = Color3.fromRGB(255, 170, 0)
            hat.Material = Enum.Material.Neon
            hat.CanCollide = false
            hat.Anchored = true
            hat.Parent = workspace
        end
        
        hat.CFrame = head.CFrame * CFrame.new(0, 0.8, 0) * CFrame.Angles(0, 0, math.rad(90))
    else
        if hat then
            hat:Destroy()
            hat = nil
        end
    end
end)

-- ==================== ДЖАМП ТРЕЙЛ (ТВОЙ КОД) ====================

local jumpCircle = nil

RunService.RenderStepped:Connect(function()
    if not Settings.Player.JumpTrail then
        if jumpCircle then
            jumpCircle:Destroy()
            jumpCircle = nil
        end
        return
    end

    local char = LocalPlayer.Character
    if not char then return end

    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    if not jumpCircle then
        jumpCircle = Instance.new("Part")
        jumpCircle.Shape = Enum.PartType.Cylinder
        jumpCircle.Size = Vector3.new(6, 0.1, 6)
        jumpCircle.Material = Enum.Material.Neon
        jumpCircle.Color = Color3.fromRGB(255, 50, 50)
        jumpCircle.CanCollide = false
        jumpCircle.Anchored = true
        jumpCircle.Parent = workspace

        local text = Instance.new("BillboardGui")
        text.Size = UDim2.new(0, 200, 0, 50)
        text.AlwaysOnTop = true
        text.Parent = jumpCircle

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = "rusticlient"
        label.TextScaled = true
        label.TextColor3 = Color3.fromRGB(255, 50, 50)
        label.Font = Enum.Font.GothamBold
        label.Parent = text
    end

    jumpCircle.CFrame = root.CFrame * CFrame.new(0, -3, 0) * CFrame.Angles(0, 0, math.rad(90))
end)

-- ==================== ДВИЖЕНИЕ ====================

local function doSpeed()
    if not Settings.Movement.Speed or not LocalPlayer.Character then return end
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if humanoid and root and humanoid.MoveDirection.Magnitude > 0 then
        root.Velocity = root.Velocity + humanoid.MoveDirection * (Settings.Movement.SpeedAmount - 16)
    end
end

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

local function doNoJumpCD()
    if not Settings.Movement.NoJumpCD or not LocalPlayer.Character then return end
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid and UserInputService:IsKeyDown(Enum.KeyCode.Space) and humanoid.FloorMaterial then
        humanoid.Jump = true
    end
end

local function doInfiniteJump()
    if not Settings.Movement.InfiniteJump or not LocalPlayer.Character then return end
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        humanoid.Jump = true
    end
end

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

-- AIMBOT вкладка
local aimScroller = tabContents["AIMBOT"]
local y = 5
createToggle(aimScroller, "Aimbot", y, "Aimbot", "Enabled"); y = y + 40
createSlider(aimScroller, "FOV", y, "Aimbot", "FOV", 50, 500, ""); y = y + 50
createSlider(aimScroller, "Smooth", y, "Aimbot", "Smooth", 1, 20, ""); y = y + 50
createToggle(aimScroller, "Auto Fire", y, "Aimbot", "AutoFire"); y = y + 40
createToggle(aimScroller, "Team Check", y, "Aimbot", "TeamCheck"); y = y + 40
createToggle(aimScroller, "Show FOV", y, "Aimbot", "ShowFOV"); y = y + 40
aimScroller.CanvasSize = UDim2.new(0, 0, 0, y)

-- VISUALS вкладка
local visScroller = tabContents["VISUALS"]
y = 5
createToggle(visScroller, "ESP", y, "Visuals", "Enabled"); y = y + 40
createToggle(visScroller, "Box", y, "Visuals", "Box"); y = y + 40
createToggle(visScroller, "Name", y, "Visuals", "Name"); y = y + 40
createToggle(visScroller, "Health", y, "Visuals", "Health"); y = y + 40
createToggle(visScroller, "Distance", y, "Visuals", "Distance"); y = y + 40
createToggle(visScroller, "Tracer", y, "Visuals", "Tracer"); y = y + 40
createToggle(visScroller, "Wallhack", y, "Visuals", "Wallhack"); y = y + 40
visScroller.CanvasSize = UDim2.new(0, 0, 0, y)

-- MOVEMENT вкладка
local moveScroller = tabContents["MOVEMENT"]
y = 5
createToggle(moveScroller, "Speed", y, "Movement", "Speed"); y = y + 40
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
createToggle(playerScroller, "Chinese Hat", y, "Player", "ChineseHat
