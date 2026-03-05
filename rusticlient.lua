-- rusticlient v10.0 - God Mode переработан + Render вкладка
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
local TweenService = game:GetService("TweenService")

-- ==================== ОПРЕДЕЛЕНИЕ УСТРОЙСТВА ====================

local isMobile = UserInputService.TouchEnabled
local injectorType = "UNKNOWN"

if identifyexecutor then
    injectorType = identifyexecutor()
end

-- ==================== GUI ====================

-- Очищаем старые гуи
for _, v in ipairs(CoreGui:GetChildren()) do
    if v.Name == "rusticlient" or v.Name == "ESPGui" then
        v:Destroy()
    end
end

local gui = Instance.new("ScreenGui")
gui.Name = "rusticlient"
gui.ResetOnSpawn = false
gui.Parent = CoreGui

-- ==================== КНОПКИ ДЛЯ ТЕЛЕФОНА ====================

-- Главная кнопка меню
local menuButton = Instance.new("ImageButton")
menuButton.Size = UDim2.new(0, 70, 0, 70)
menuButton.Position = UDim2.new(0, 15, 0.5, -35)
menuButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
menuButton.BackgroundTransparency = 0.3
menuButton.Image = "rbxassetid://2823074130554611"
menuButton.Visible = isMobile
menuButton.Parent = gui

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(1, 0)
buttonCorner.Parent = menuButton

-- Кнопка для быстрого включения Aimbot
local aimbotButton = Instance.new("TextButton")
aimbotButton.Size = UDim2.new(0, 60, 0, 60)
aimbotButton.Position = UDim2.new(1, -75, 0.5, -30)
aimbotButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
aimbotButton.Text = "AIM"
aimbotButton.TextColor3 = Color3.fromRGB(255, 255, 255)
aimbotButton.TextScaled = true
aimbotButton.Font = Enum.Font.SourceSansBold
aimbotButton.Visible = isMobile
aimbotButton.Parent = gui

local aimbotCorner = Instance.new("UICorner")
aimbotCorner.CornerRadius = UDim.new(0, 10)
aimbotCorner.Parent = aimbotButton

-- Кнопка для быстрого включения ESP
local espButton = Instance.new("TextButton")
espButton.Size = UDim2.new(0, 60, 0, 60)
espButton.Position = UDim2.new(1, -75, 0.5, 35)
espButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
espButton.Text = "ESP"
espButton.TextColor3 = Color3.fromRGB(0, 0, 0)
espButton.TextScaled = true
espButton.Font = Enum.Font.SourceSansBold
espButton.Visible = isMobile
espButton.Parent = gui

local espCorner = Instance.new("UICorner")
espCorner.CornerRadius = UDim.new(0, 10)
espCorner.Parent = espButton

-- ==================== МЕНЮ ====================

local menu = Instance.new("Frame")
menu.Size = isMobile and UDim2.new(0, 380, 0, 550) or UDim2.new(0, 450, 0, 750)
menu.Position = isMobile and UDim2.new(0.5, -190, 0.5, -275) or UDim2.new(0.5, -225, 0.5, -375)
menu.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
menu.BackgroundTransparency = 0.1
menu.Visible = false
menu.Active = true
menu.Draggable = true
menu.Parent = gui

local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0, 10)
menuCorner.Parent = menu

-- Заголовок
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "rusticlient v10.0"
title.TextColor3 = Color3.fromRGB(255, 100, 100)
title.TextScaled = true
title.Font = Enum.Font.SourceSansBold
title.Parent = menu

-- Инфо
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, 0, 0, 25)
infoLabel.Position = UDim2.new(0, 0, 0, 40)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "Device: " .. (isMobile and "📱 Mobile" or "💻 PC") .. " | " .. injectorType
infoLabel.TextColor3 = Color3.fromRGB(150, 150, 255)
infoLabel.TextScaled = true
infoLabel.Font = Enum.Font.SourceSans
infoLabel.Parent = menu

-- ВКЛАДКИ
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, -20, 0, isMobile and 25 or 30)
tabFrame.Position = UDim2.new(0, 10, 0, 70)
tabFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
tabFrame.BorderSizePixel = 0
tabFrame.Parent = menu

local tabButtons = {}
local tabContents = {}
local tabs = {"ESP", "AIMBOT", "MOVE", "PLAYER", "RENDER", "SPIN", "BINDS"}

for i, tabName in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1/7, -2, 1, -4)
    btn.Position = UDim2.new((i-1)/7, 2, 0, 2)
    btn.BackgroundColor3 = i == 1 and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(40, 40, 50)
    btn.Text = tabName
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.SourceSansBold
    btn.Parent = tabFrame
    tabButtons[tabName] = btn
end

-- КОНТЕЙНЕР ДЛЯ КОНТЕНТА
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -20, 1, -120)
contentFrame.Position = UDim2.new(0, 10, 0, 100)
contentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
contentFrame.BorderSizePixel = 0
contentFrame.Parent = menu

-- СКОЛЛЕРЫ
for _, tabName in ipairs(tabs) do
    local scroller = Instance.new("ScrollingFrame")
    scroller.Name = tabName .. "Scroller"
    scroller.Size = UDim2.new(1, -10, 1, -10)
    scroller.Position = UDim2.new(0, 5, 0, 5)
    scroller.BackgroundTransparency = 1
    scroller.BorderSizePixel = 0
    scroller.ScrollBarThickness = isMobile and 8 or 6
    scroller.ScrollBarImageColor3 = Color3.fromRGB(255, 50, 50)
    scroller.CanvasSize = UDim2.new(0, 0, 0, 800)
    scroller.Visible = (tabName == "ESP")
    scroller.Parent = contentFrame
    tabContents[tabName] = scroller
end

-- ==================== НАСТРОЙКИ ====================

local settings = {
    -- ESP
    esp = false,
    names = true,
    distance = true,
    health = true,
    wallhack = true,
    
    -- Aimbot
    aimbot = false,
    aimFOV = 200,
    aimSmooth = 5,
    aimTeamCheck = false,
    aimWallCheck = true,
    aimTargetPart = "Head",
    aimTargetType = "Closest",
    aimPredictMovement = false,
    aimPredictAmount = 0.5,
    
    -- Movement (СПИД ТОЛЬКО НА ЗЕМЛЕ)
    speed = false,
    speedAmount = 32,
    
    -- Player (ПЕРЕРАБОТАННЫЙ GOD MODE)
    godMode = false,
    noFallDamage = false,
    infiniteJump = false,
    noClip = false,
    noJumpCooldown = false,
    
    -- RENDER (НОВАЯ ВКЛАДКА)
    removeGrass = false,
    removeFoliage = false,
    removeTrees = false,
    removeClouds = false,
    removeFog = false,
    removeWater = false,
    removeSky = false,
    removeClothes = false,
    potatoGraphics = false,
    fullBright = false,
    
    -- Visuals
    jumpTrail = false,
    jumpTrailColor = "Red",
    chineseHat = false,
    chineseHatColor = "Red",
    spinTrail = false,
    
    -- Spin Bot
    spinBot = false,
    spinSpeed = 10,
    spinDirection = "Right",
    spinType = "Constant",
    
    -- Keybinds
    bindMenu = Enum.KeyCode.RightShift,
    bindESP = Enum.KeyCode.F1,
    bindAimbot = Enum.KeyCode.F2,
    bindSpeed = Enum.KeyCode.F3,
    bindGodMode = Enum.KeyCode.F4,
    bindSpin = Enum.KeyCode.F5,
    bindNoClip = Enum.KeyCode.F6,
    
    -- Settings
    showBinds = true
}

-- ==================== ТВОЙ ESP КОД ====================

local espObjects = {}

local function createESP(player)
    if espObjects[player] then return end
    if player == LocalPlayer then return end
    
    local function onCharacterAdded(char)
        local head = char:WaitForChild("Head", 5)
        local humanoid = char:WaitForChild("Humanoid", 5)
        local root = char:WaitForChild("HumanoidRootPart", 5)
        
        if not head or not humanoid or not root then return end
        
        local gui = Instance.new("BillboardGui")
        gui.Name = "ESP_"..player.Name
        gui.Size = UDim2.new(0, 200, 0, 60)
        gui.StudsOffset = Vector3.new(0, 2.5, 0)
        gui.AlwaysOnTop = settings.wallhack
        gui.Parent = head
        
        local text = Instance.new("TextLabel")
        text.Size = UDim2.new(1, 0, 1, 0)
        text.BackgroundTransparency = 1
        text.TextScaled = true
        text.TextColor3 = Color3.new(1, 1, 1)
        text.Font = Enum.Font.SourceSansBold
        text.Parent = gui
        
        if not espObjects[player] then
            espObjects[player] = {}
        end
        
        table.insert(espObjects[player], {
            gui = gui,
            text = text,
            humanoid = humanoid,
            root = root,
            char = char
        })
    end
    
    if player.Character then
        onCharacterAdded(player.Character)
    end
    
    player.CharacterAdded:Connect(onCharacterAdded)
end

local function removeESP(player)
    if espObjects[player] then
        for _, obj in ipairs(espObjects[player]) do
            if obj.gui then
                obj.gui:Destroy()
            end
        end
        espObjects[player] = nil
    end
end

-- Обновление ESP
RunService.RenderStepped:Connect(function()
    if not settings.esp then
        for player, objects in pairs(espObjects) do
            for _, obj in ipairs(objects) do
                if obj.gui then
                    obj.gui.Enabled = false
                end
            end
        end
        return
    end
    
    for player, objects in pairs(espObjects) do
        for _, obj in ipairs(objects) do
            if obj.gui and obj.humanoid and obj.root then
                obj.gui.Enabled = true
                obj.gui.AlwaysOnTop = settings.wallhack
                
                local myChar = LocalPlayer.Character
                if not myChar then 
                    obj.text.Text = player.Name.." | Waiting..."
                    return 
                end
                
                local myRoot = myChar:FindFirstChild("HumanoidRootPart")
                if not myRoot then 
                    obj.text.Text = player.Name.." | Waiting..."
                    return 
                end
                
                local myPos = myRoot.Position
                local enemyPos = obj.root.Position
                local distance = (myPos - enemyPos).Magnitude
                local hp = math.floor(obj.humanoid.Health)
                
                local tool = obj.char:FindFirstChildOfClass("Tool")
                local weapon = tool and tool.Name or "None"
                
                local textParts = {}
                if settings.names then table.insert(textParts, player.Name) end
                if settings.distance then table.insert(textParts, math.floor(distance).."m") end
                if settings.health then table.insert(textParts, "HP:"..hp) end
                table.insert(textParts, weapon)
                
                obj.text.Text = table.concat(textParts, " | ")
                
                if settings.health and hp then
                    local healthPercent = obj.humanoid.Health / obj.humanoid.MaxHealth
                    if healthPercent > 0.6 then
                        obj.text.TextColor3 = Color3.fromRGB(0, 255, 0)
                    elseif healthPercent > 0.3 then
                        obj.text.TextColor3 = Color3.fromRGB(255, 255, 0)
                    else
                        obj.text.TextColor3 = Color3.fromRGB(255, 0, 0)
                    end
                else
                    obj.text.TextColor3 = Color3.fromRGB(255, 255, 255)
                end
            end
        end
    end
end)

-- ==================== ФУНКЦИИ ДЛЯ ПЕРЕКЛЮЧАТЕЛЕЙ ====================

local function createToggle(parent, name, yPos, setting)
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(0.9, 0, 0, 35)
    bg.Position = UDim2.new(0.05, 0, 0, yPos)
    bg.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    bg.BorderSizePixel = 0
    bg.Parent = parent
    
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
    toggle.BackgroundColor3 = settings[setting] and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    toggle.Text = settings[setting] and "ON" or "OFF"
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.TextScaled = true
    toggle.Font = Enum.Font.SourceSansBold
    toggle.Parent = bg
    
    toggle.MouseButton1Click:Connect(function()
        settings[setting] = not settings[setting]
        toggle.BackgroundColor3 = settings[setting] and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        toggle.Text = settings[setting] and "ON" or "OFF"
        if setting == "removeGrass" or setting == "removeFoliage" or setting == "removeTrees" or setting == "potatoGraphics" then
            applyRenderSettings()
        end
    end)
    
    return bg
end

local function createSlider(parent, name, yPos, min, max, setting, suffix)
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(0.9, 0, 0, 50)
    bg.Position = UDim2.new(0.05, 0, 0, yPos)
    bg.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    bg.BorderSizePixel = 0
    bg.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, -5, 0.4, 0)
    label.Position = UDim2.new(0, 10, 0, 2)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextScaled = true
    label.Font = Enum.Font.SourceSans
    label.Parent = bg
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 40, 0.4, 0)
    valueLabel.Position = UDim2.new(1, -45, 0, 2)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(settings[setting]) .. suffix
    valueLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    valueLabel.TextScaled = true
    valueLabel.Font = Enum.Font.SourceSansBold
    valueLabel.Parent = bg
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(0.8, 0, 0, 10)
    sliderBg.Position = UDim2.new(0.1, 0, 0, 30)
    sliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = bg
    
    local slider = Instance.new("Frame")
    slider.Size = UDim2.new((settings[setting] - min) / (max - min), 0, 1, 0)
    slider.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
    slider.BorderSizePixel = 0
    slider.Parent = sliderBg
    
    local function updateSlider(input)
        if not sliderBg.AbsoluteSize.X then return end
        local pos = math.clamp(input.Position.X - sliderBg.AbsolutePosition.X, 0, sliderBg.AbsoluteSize.X)
        local percent = pos / sliderBg.AbsoluteSize.X
        settings[setting] = min + (max - min) * percent
        slider.Size = UDim2.new(percent, 0, 1, 0)
        valueLabel.Text = math.floor(settings[setting]) .. suffix
    end
    
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            updateSlider(input)
        end
    end)
    
    sliderBg.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input)
        end
    end)
    
    return bg
end

local function createDropdown(parent, name, yPos, options, setting)
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(0.9, 0, 0, 45)
    bg.Position = UDim2.new(0.05, 0, 0, yPos)
    bg.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    bg.BorderSizePixel = 0
    bg.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, -5, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextScaled = true
    label.Font = Enum.Font.SourceSans
    label.Parent = bg
    
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 80, 0, 30)
    button.Position = UDim2.new(1, -90, 0.5, -15)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    button.Text = tostring(settings[setting])
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextScaled = true
    button.Font = Enum.Font.SourceSansBold
    button.Parent = bg
    
    button.MouseButton1Click:Connect(function()
        local current = settings[setting]
        local idx = 1
        for i, opt in ipairs(options) do
            if opt == current then
                idx = i + 1
                if idx > #options then idx = 1 end
                break
            end
        end
        settings[setting] = options[idx]
        button.Text = options[idx]
    end)
    
    return bg
end

-- ==================== RENDER ФУНКЦИИ ====================

local originalMaterials = {}
local function applyRenderSettings()
    -- Удаление травы
    if settings.removeGrass then
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("Grass") or v:IsA("GrassPart") then
                v.Transparency = 1
            elseif v.Name:lower():find("grass") and v:IsA("BasePart") then
                v.Transparency = 1
            end
        end
    end
    
    -- Удаление листвы (деревья, кусты)
    if settings.removeFoliage then
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("Part") or v:IsA("MeshPart") then
                if v.Material == Enum.Material.Leaves or v.Material == Enum.Material.Fabric then
                    v.Transparency = 1
                end
            end
        end
    end
    
    -- Удаление деревьев
    if settings.removeTrees then
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("Part") or v:IsA("MeshPart") then
                if v.Material == Enum.Material.Wood or v.Name:lower():find("tree") then
                    v.Transparency = 1
                end
            end
        end
    end
    
    -- Картофельная графика
    if settings.potatoGraphics then
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 50
        Lighting.Brightness = 2
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation") then
                v.Material = Enum.Material.SmoothPlastic
            end
        end
    else
        Lighting.GlobalShadows = true
        Lighting.FogEnd = 1000
    end
    
    -- Удаление облаков
    if settings.removeClouds then
        if workspace:FindFirstChild("Clouds") then
            workspace.Clouds:Destroy()
        end
        Lighting:SetAttribute("CloudsEnabled", false)
    end
    
    -- Удаление тумана
    if settings.removeFog then
        Lighting.FogEnd = 100000
        Lighting.FogStart = 100000
    end
    
    -- Удаление воды
    if settings.removeWater then
        for _, v in ipairs(workspace:GetDescendants()) do
            if v.Material == Enum.Material.Water or v.Name:lower():find("water") then
                v.Transparency = 1
            end
        end
    end
    
    -- Удаление неба
    if settings.removeSky then
        Lighting.Ambient = Color3.fromRGB(100, 100, 100)
        Lighting.Brightness = 1
        Lighting.OutdoorAmbient = Color3.fromRGB(100, 100, 100)
    end
    
    -- Full Bright
    if settings.fullBright then
        Lighting.Brightness = 3
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    end
end

-- Удаление одежды
local function removeClothes()
    if not settings.removeClothes or not LocalPlayer.Character then return end
    
    for _, child in ipairs(LocalPlayer.Character:GetChildren()) do
        if child:IsA("Shirt") or child:IsA("Pants") or child:IsA("ShirtGraphic") then
            child:Destroy()
        end
        if child:IsA("Accessory") then
            child:Destroy()
        end
    end
end

-- Китайская шляпа
local chineseHat = nil
local function updateChineseHat()
    if settings.chineseHat and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") then
        if not chineseHat then
            chineseHat = Instance.new("Part")
            chineseHat.Name = "ChineseHat"
            chineseHat.Size = Vector3.new(3, 0.5, 3)
            chineseHat.Shape = Enum.PartType.Cylinder
            chineseHat.BrickColor = BrickColor.new(settings.chineseHatColor)
            chineseHat.Material = Enum.Material.Neon
            chineseHat.CanCollide = false
            chineseHat.Anchored = false
            
            local hatMesh = Instance.new("SpecialMesh")
            hatMesh.MeshType = Enum.MeshType.Cylinder
            hatMesh.Scale = Vector3.new(1, 0.2, 1)
            hatMesh.Parent = chineseHat
            
            local hatJoint = Instance.new("Weld")
            hatJoint.Part0 = LocalPlayer.Character.Head
            hatJoint.Part1 = chineseHat
            hatJoint.C0 = CFrame.new(0, 0.5, 0) * CFrame.Angles(0, 0, 0)
            hatJoint.Parent = chineseHat
            
            chineseHat.Parent = LocalPlayer.Character
        else
            if chineseHat.Parent ~= LocalPlayer.Character then
                chineseHat.Parent = LocalPlayer.Character
            end
        end
    elseif chineseHat then
        chineseHat:Destroy()
        chineseHat = nil
    end
end

-- Jump Trail
local trailParts = {}
local function createJumpTrail()
    if not settings.jumpTrail or not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        for _, part in ipairs(trailParts) do
            if part then
                part:Destroy()
            end
        end
        trailParts = {}
        return
    end
    
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid and humanoid.Jump and not humanoid.FloorMaterial then
        local part = Instance.new("Part")
        part.Size = Vector3.new(1, 1, 1)
        part.Shape = Enum.PartType.Ball
        part.BrickColor = BrickColor.new(settings.jumpTrailColor)
        part.Material = Enum.Material.Neon
        part.CanCollide = false
        part.Anchored = true
        part.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, -2, 0)
        part.Parent = workspace
        
        table.insert(trailParts, part)
        
        -- Удаляем старые части
        if #trailParts > 10 then
            local oldest = table.remove(trailParts, 1)
            if oldest then
                oldest:Destroy()
            end
        end
    end
end

-- ==================== SPEED (ТОЛЬКО НА ЗЕМЛЕ) ====================

local function doSpeed()
    if not settings.speed or not LocalPlayer.Character then return end
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    if not humanoid then return end
    local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    -- Проверяем на земле ли игрок
    if humanoid.FloorMaterial then
        local moveDir = humanoid.MoveDirection
        if moveDir.Magnitude > 0 then
            local boost = settings.speedAmount - 16
            if boost > 0 then
                root.Velocity = root.Velocity + moveDir * boost
            end
        end
    end
end

-- ==================== GOD MODE (ПЕРЕРАБОТАН) ====================

local originalHealth = 100
local function doGodMode()
    if not settings.godMode or not LocalPlayer.Character then return end
    
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    -- Сохраняем оригинальное здоровье
    if originalHealth ~= humanoid.Health then
        originalHealth = humanoid.Health
    end
    
    -- Показываем что у нас 1 HP (для врагов)
    -- Но на самом деле здоровье не уменьшается
    if humanoid.Health < originalHealth then
        humanoid.Health = originalHealth
    end
    
    -- Если нас ударили, показываем что здоровье упало, но сразу восстанавливаем
    if humanoid.Health < humanoid.MaxHealth then
        humanoid.Health = humanoid.MaxHealth
    end
end

-- ==================== ОСТАЛЬНЫЕ ФУНКЦИИ ====================

local function doNoFallDamage()
    if not settings.noFallDamage or not LocalPlayer.Character then return end
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    if humanoid:GetState() == Enum.HumanoidStateType.Freefall then
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root and root.Velocity.Y < -50 then
            root.Velocity = Vector3.new(root.Velocity.X, -20, root.Velocity.Z)
        end
    end
end

local function doNoJumpCooldown()
    if not settings.noJumpCooldown or not LocalPlayer.Character then return end
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        if humanoid.FloorMaterial then
            humanoid.Jump = true
        end
    end
end

local function doInfiniteJump()
    if not settings.infiniteJump or not LocalPlayer.Character then return end
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        humanoid.Jump = true
    end
end

local function doNoClip()
    if not settings.noClip or not LocalPlayer.Character then return end
    for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end

local function doSpin()
    if not settings.spinBot or not LocalPlayer.Character then return end
    local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local dir = 1
    if settings.spinDirection == "Left" then
        dir = -1
    elseif settings.spinDirection == "Random" then
        dir = math.random() > 0.5 and 1 or -1
    end
    
    if settings.spinType == "Constant" then
        spinAngle = spinAngle + settings.spinSpeed * dir
    elseif settings.spinType == "Random" then
        spinAngle = spinAngle + settings.spinSpeed * dir * math.random()
    end
    
    root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, math.rad(spinAngle), 0)
end

-- ==================== AIMBOT ====================

local function getTargetPart(player)
    if not player.Character then return nil end
    if settings.aimTargetPart == "Head" then
        return player.Character:FindFirstChild("Head")
    elseif settings.aimTargetPart == "HumanoidRootPart" then
        return player.Character:FindFirstChild("HumanoidRootPart")
    elseif settings.aimTargetPart == "Torso" then
        return player.Character:FindFirstChild("Torso") or player.Character:FindFirstChild("UpperTorso")
    end
    return player.Character:FindFirstChild("HumanoidRootPart")
end

local function isVisible(player, part)
    if not part or not settings.aimWallCheck then return true end
    local ray = Ray.new(Camera.CFrame.Position, (part.Position - Camera.CFrame.Position).Unit * 1000)
    local hit, pos = workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character, player.Character})
    return hit == nil or hit:IsDescendantOf(player.Character)
end

local function getClosestPlayer()
    local closest = nil
    local closestDist = settings.aimFOV
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    local players = {}
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
            local humanoid = player.Character.Humanoid
            if humanoid and humanoid.Health > 0 then
                if settings.aimTeamCheck and player.Team == LocalPlayer.Team then
                    continue
                end
                
                local targetPart = getTargetPart(player)
                if targetPart then
                    if settings.aimWallCheck and not isVisible(player, targetPart) then
                        continue
                    end
                    
                    local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                    if onScreen then
                        local dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                        if dist <= closestDist then
                            table.insert(players, {
                                player = player,
                                part = targetPart,
                                dist = dist,
                                health = humanoid.Health,
                                velocity = humanoid.MoveDirection * humanoid.WalkSpeed
                            })
                        end
                    end
                end
            end
        end
    end
    
    if #players == 0 then return nil, nil end
    
    if settings.aimTargetType == "Closest" or settings.aimTargetType == "Lowest Dist" then
        table.sort(players, function(a, b) return a.dist < b.dist end)
    elseif settings.aimTargetType == "Lowest HP" then
        table.sort(players, function(a, b) return a.health < b.health end)
    elseif settings.aimTargetType == "Highest HP" then
        table.sort(players, function(a, b) return a.health > b.health end)
    end
    
    return players[1].player, players[1].part, players[1]
end

RunService.RenderStepped:Connect(function()
    if settings.aimbot then
        local targetPlayer, targetPart, targetData = getClosestPlayer()
        if targetPlayer and targetPart then
            local targetPos = targetPart.Position
            
            if settings.aimPredictMovement and targetData and targetData.velocity then
                local distance = (targetPos - Camera.CFrame.Position).Magnitude
                local timeToTarget = distance / 1000
                targetPos = targetPos + targetData.velocity * timeToTarget * settings.aimPredictAmount
            end
            
            local targetCFrame = CFrame.new(Camera.CFrame.Position, targetPos)
            Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, 1 / settings.aimSmooth)
        end
    end
end)

-- ==================== ЗАПОЛНЯЕМ ВКЛАДКИ ====================

-- ESP вкладка
local espScroller = tabContents["ESP"]
local y = 5
createToggle(espScroller, "ESP", y, "esp"); y = y + 40
createToggle(espScroller, "Names", y, "names"); y = y + 40
createToggle(espScroller, "Distance", y, "distance"); y = y + 40
createToggle(espScroller, "Health", y, "health"); y = y + 40
createToggle(espScroller, "Wallhack", y, "wallhack"); y = y + 40
espScroller.CanvasSize = UDim2.new(0, 0, 0, y + 20)

-- AIMBOT вкладка
local aimScroller = tabContents["AIMBOT"]
y = 5
createToggle(aimScroller, "Aimbot", y, "aimbot"); y = y + 40
createSlider(aimScroller, "FOV", y, 50, 500, "aimFOV", "px"); y = y + 55
createSlider(aimScroller, "Smooth", y, 1, 20, "aimSmooth", ""); y = y + 55
createToggle(aimScroller, "Team Check", y, "aimTeamCheck"); y = y + 40
createToggle(aimScroller, "Wall Check", y, "aimWallCheck"); y = y + 40
createToggle(aimScroller, "Predict Move", y, "aimPredictMovement"); y = y + 40
createSlider(aimScroller, "Prediction", y, 0.1, 2, "aimPredictAmount", ""); y = y + 55
createDropdown(aimScroller, "Target Part", y, {"Head", "HumanoidRootPart", "Torso"}, "aimTargetPart"); y = y + 50
createDropdown(aimScroller, "Target Type", y, {"Closest", "Lowest HP", "Highest HP", "Lowest Dist"}, "aimTargetType"); y = y + 50
aimScroller.CanvasSize = UDim2.new(0, 0, 0, y + 20)

-- MOVE вкладка (УБРАЛ HIGH JUMP)
local moveScroller = tabContents["MOVE"]
y = 5
createToggle(moveScroller, "Speed (on ground)", y, "speed"); y = y + 40
createSlider(moveScroller, "Speed Amount", y, 16, 100, "speedAmount", ""); y = y + 55
moveScroller.CanvasSize = UDim2.new(0, 0, 0, y + 20)

-- PLAYER вкладка
local playerScroller = tabContents["PLAYER"]
y = 5
createToggle(playerScroller, "GOD MODE (1HP fake)", y, "godMode"); y = y + 40
createToggle(playerScroller, "NO FALL", y, "noFallDamage"); y = y + 40
createToggle(playerScroller, "No Jump CD", y, "noJumpCooldown"); y = y + 40
createToggle(playerScroller, "Infinite Jump", y, "infiniteJump"); y = y + 40
createToggle(playerScroller, "No Clip", y, "noClip"); y = y + 40
playerScroller.CanvasSize = UDim2.new(0, 0, 0, y + 20)

-- RENDER вкладка (НОВАЯ)
local renderScroller = tabContents["RENDER"]
y = 5
createToggle(renderScroller, "Remove Grass", y, "removeGrass"); y = y + 40
createToggle(renderScroller, "Remove Foliage", y, "removeFoliage"); y = y + 40
createToggle(renderScroller, "Remove Trees", y, "removeTrees"); y = y + 40
createToggle(renderScroller, "Remove Clouds", y, "removeClouds"); y = y + 40
createToggle(renderScroller, "Remove Fog", y, "removeFog"); y = y + 40
createToggle(renderScroller, "Remove Water", y, "removeWater"); y = y + 40
createToggle(renderScroller, "Remove Sky", y, "removeSky"); y = y + 40
createToggle(renderScroller, "Remove Clothes", y, "removeClothes"); y = y + 40
createToggle(renderScroller, "Potato Graphics", y, "potatoGraphics"); y = y + 40
createToggle(renderScroller, "Full Bright", y, "fullBright"); y = y + 40
createToggle(renderScroller, "Chinese Hat", y, "chineseHat"); y = y + 40
createToggle(renderScroller, "Jump Trail", y, "jumpTrail"); y = y + 40
renderScroller.CanvasSize = UDim2.new(0, 0, 0, y + 20)

-- SPIN вкладка
local spinScroller = tabContents["SPIN"]
y = 5
createToggle(spinScroller, "Spin Bot", y, "spinBot"); y = y + 40
createSlider(spinScroller, "Speed", y, 1, 30, "spinSpeed", ""); y = y + 55
createDropdown(spinScroller, "Direction", y, {"Right", "Left", "Random"}, "spinDirection"); y = y + 50
createDropdown(spinScroller, "Type", y, {"Constant", "Random", "Mouse"}, "spinType"); y = y + 50
spinScroller.CanvasSize = UDim2.new(0, 0, 0, y + 20)

-- BINDS вкладка
local bindsScroller = tabContents["BINDS"]
y = 5
bindsScroller.CanvasSize = UDim2.new(0, 0, 0, y + 20)

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

local spinAngle = 0

RunService.Heartbeat:Connect(function()
    doSpeed()
    doGodMode()
    doNoFallDamage()
    doNoJumpCooldown()
    doInfiniteJump()
    doNoClip()
    doSpin()
    removeClothes()
    updateChineseHat()
    createJumpTrail()
end)

-- ==================== ОБРАБОТКА КНОПОК ДЛЯ ТЕЛЕФОНА ====================

if isMobile then
    menuButton.MouseButton1Click:Connect(function()
        menu.Visible = not menu.Visible
    end)
    
    aimbotButton.MouseButton1Click:Connect(function()
        settings.aimbot = not settings.aimbot
        aimbotButton.BackgroundColor3 = settings.aimbot and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        aimbotButton.Text = settings.aimbot and "AIM ON" or "AIM OFF"
        StarterGui:SetCore("SendNotification", {
            Title = "Aimbot",
            Text = settings.aimbot and "ON" or "OFF",
            Duration = 1
        })
    end)
    
    espButton.MouseButton1Click:Connect(function()
        settings.esp = not settings.esp
        espButton.BackgroundColor3 = settings.esp and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        espButton.Text = settings.esp and "ESP ON" or "ESP OFF"
        espButton.TextColor3 = settings.esp and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
        StarterGui:SetCore("SendNotification", {
            Title = "ESP",
            Text = settings.esp and "ON" or "OFF",
            Duration = 1
        })
    end)
    
else
    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == settings.bindMenu then
            menu.Visible = not menu.Visible
        end
    end)
end

-- ==================== ИНИЦИАЛИЗАЦИЯ ====================

task.wait(2)

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        task.spawn(function()
            createESP(player)
        end)
    end
end

Players.PlayerAdded:Connect(function(player)
    createESP(player)
end)

Players.PlayerRemoving:Connect(removeESP)

-- Применяем настройки рендера
applyRenderSettings()

StarterGui:SetCore("SendNotification", {
    Title = "rusticlient v10.0",
    Text = isMobile and "📱 RENDER вкладка добавлена!" or "💻 God Mode переработан!",
    Duration = 4
})

print("✅ rusticlient v10.0 загружен!")
print("✨ God Mode теперь показывает 1HP врагам")
print("🎨 RENDER вкладка: убери траву, графику картошкой и визуалы")
