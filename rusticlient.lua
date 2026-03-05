-- rusticlientv2 - ABSOLUTELY WORKING VERSION
-- Автор: SWILL / rusticlientv2

-- ==================== ОСНОВНЫЕ СЕРВИСЫ ====================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Camera = workspace.CurrentCamera
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

-- ==================== ЛОКАЛЬНЫЙ ИГРОК ====================

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- ==================== ОПРЕДЕЛЕНИЕ УСТРОЙСТВА ====================

local isMobile = UserInputService.TouchEnabled

-- ==================== GUI ====================

for _, v in ipairs(CoreGui:GetChildren()) do
    if v.Name == "rusticlientv2" then
        v:Destroy()
    end
end

local gui = Instance.new("ScreenGui")
gui.Name = "rusticlientv2"
gui.ResetOnSpawn = false
gui.Parent = CoreGui

-- ==================== КНОПКА С АВАТАРКОЙ ====================

local menuButton = Instance.new("ImageButton")
menuButton.Size = UDim2.new(0, 60, 0, 60)
menuButton.Position = UDim2.new(0, 10, 0.5, -30)
menuButton.BackgroundTransparency = 1
menuButton.Image = "rbxassetid://90064663091843"
menuButton.Parent = gui

local menuButtonCorner = Instance.new("UICorner")
menuButtonCorner.CornerRadius = UDim.new(1, 0)
menuButtonCorner.Parent = menuButton

-- ==================== КРУЖОК ДЛЯ ТЕЛЕФОНА ====================

local mobileCircle = Instance.new("Frame")
mobileCircle.Size = UDim2.new(0, 80, 0, 80)
mobileCircle.Position = UDim2.new(0.5, -40, 0.5, -40)
mobileCircle.BackgroundTransparency = 1
mobileCircle.BorderColor3 = Color3.fromRGB(255, 50, 50)
mobileCircle.BorderSizePixel = 3
mobileCircle.Visible = isMobile
mobileCircle.Parent = gui

local mobileCircleCorner = Instance.new("UICorner")
mobileCircleCorner.CornerRadius = UDim.new(1, 0)
mobileCircleCorner.Parent = mobileCircle

local mobileDot = Instance.new("Frame")
mobileDot.Size = UDim2.new(0, 8, 0, 8)
mobileDot.Position = UDim2.new(0.5, -4, 0.5, -4)
mobileDot.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
mobileDot.BorderSizePixel = 0
mobileDot.Parent = mobileCircle

local mobileDotCorner = Instance.new("UICorner")
mobileDotCorner.CornerRadius = UDim.new(1, 0)
mobileDotCorner.Parent = mobileDot

-- ==================== МЕНЮ ====================

local menu = Instance.new("Frame")
menu.Size = UDim2.new(0, 300, 0, 400)
menu.Position = UDim2.new(0.5, -150, 0.5, -200)
menu.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
menu.BackgroundTransparency = 0.1
menu.Visible = false
menu.Active = true
menu.Draggable = true
menu.Parent = gui

local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0, 10)
menuCorner.Parent = menu

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "rusticlientv2"
title.TextColor3 = Color3.fromRGB(255, 100, 100)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = menu

-- ==================== ВКЛАДКИ ====================

local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, -20, 0, 30)
tabFrame.Position = UDim2.new(0, 10, 0, 40)
tabFrame.BackgroundTransparency = 1
tabFrame.Parent = menu

local tabs = {"COMBAT", "MOVE", "RENDER", "PLAYER", "SPIN"}
local tabButtons = {}
local tabContents = {}

for i = 1, #tabs do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.2, -4, 1, -4)
    btn.Position = UDim2.new((i-1)*0.2, 2, 0, 2)
    btn.BackgroundColor3 = i == 1 and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(40, 40, 50)
    btn.Text = tabs[i]
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.Parent = tabFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    tabButtons[tabs[i]] = btn
end

local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -20, 1, -80)
contentFrame.Position = UDim2.new(0, 10, 0, 75)
contentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
contentFrame.Parent = menu

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 8)
contentCorner.Parent = contentFrame

for i = 1, #tabs do
    local scroller = Instance.new("ScrollingFrame")
    scroller.Name = tabs[i]
    scroller.Size = UDim2.new(1, -10, 1, -10)
    scroller.Position = UDim2.new(0, 5, 0, 5)
    scroller.BackgroundTransparency = 1
    scroller.BorderSizePixel = 0
    scroller.ScrollBarThickness = 6
    scroller.CanvasSize = UDim2.new(0, 0, 0, 300)
    scroller.Visible = (tabs[i] == "COMBAT")
    scroller.Parent = contentFrame
    tabContents[tabs[i]] = scroller
end

-- ==================== НАСТРОЙКИ ====================

local Settings = {
    Combat = {
        Killaura = false,
        Range = 18,
        AimAssist = false,
        FOV = 90,
        AutoClicker = false,
        CPS = 12
    },
    Movement = {
        Speed = false,
        SpeedAmount = 32,
        InfiniteJump = false,
        Bhop = false,
        BhopSpeed = 25
    },
    Render = {
        ESP = false,
        ESPName = true,
        ESPHealth = true,
        ESPDistance = true,
        Wallhack = true,
        FullBright = false
    },
    Player = {
        GodMode = false
    },
    Spin = {
        SpinBot = false,
        SpinSpeed = 10
    }
}

-- ==================== ФУНКЦИИ ДЛЯ ПЕРЕКЛЮЧАТЕЛЕЙ ====================

local function createToggle(parent, name, yPos, category, setting)
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(0.9, 0, 0, 30)
    bg.Position = UDim2.new(0.05, 0, 0, yPos)
    bg.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    bg.Parent = parent
    
    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(0, 6)
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
    toggle.Size = UDim2.new(0, 50, 0, 22)
    toggle.Position = UDim2.new(1, -60, 0.5, -11)
    toggle.BackgroundColor3 = Settings[category][setting] and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    toggle.Text = Settings[category][setting] and "ON" or "OFF"
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.TextScaled = true
    toggle.Font = Enum.Font.GothamBold
    toggle.Parent = bg
    
    toggle.MouseButton1Click:Connect(function()
        Settings[category][setting] = not Settings[category][setting]
        toggle.BackgroundColor3 = Settings[category][setting] and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        toggle.Text = Settings[category][setting] and "ON" or "OFF"
    end)
    
    return bg
end

local function createSlider(parent, name, yPos, category, setting, min, max)
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(0.9, 0, 0, 40)
    bg.Position = UDim2.new(0.05, 0, 0, yPos)
    bg.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    bg.Parent = parent
    
    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(0, 6)
    bgCorner.Parent = bg
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, -5, 0.5, 0)
    label.Position = UDim2.new(0, 10, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextScaled = true
    label.Font = Enum.Font.SourceSans
    label.Parent = bg
    
    local value = Instance.new("TextLabel")
    value.Size = UDim2.new(0, 40, 0.5, 0)
    value.Position = UDim2.new(1, -50, 0, 5)
    value.BackgroundTransparency = 1
    value.Text = tostring(Settings[category][setting])
    value.TextColor3 = Color3.fromRGB(0, 255, 0)
    value.TextScaled = true
    value.Font = Enum.Font.GothamBold
    value.Parent = bg
    
    local up = Instance.new("TextButton")
    up.Size = UDim2.new(0, 25, 0, 16)
    up.Position = UDim2.new(1, -85, 0, 5)
    up.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    up.Text = "+"
    up.TextColor3 = Color3.fromRGB(255, 255, 255)
    up.TextScaled = true
    up.Font = Enum.Font.GothamBold
    up.Parent = bg
    
    local down = Instance.new("TextButton")
    down.Size = UDim2.new(0, 25, 0, 16)
    down.Position = UDim2.new(1, -85, 0, 21)
    down.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    down.Text = "-"
    down.TextColor3 = Color3.fromRGB(255, 255, 255)
    down.TextScaled = true
    down.Font = Enum.Font.GothamBold
    down.Parent = bg
    
    up.MouseButton1Click:Connect(function()
        Settings[category][setting] = Settings[category][setting] + 1
        if Settings[category][setting] > max then Settings[category][setting] = max end
        value.Text = tostring(Settings[category][setting])
    end)
    
    down.MouseButton1Click:Connect(function()
        Settings[category][setting] = Settings[category][setting] - 1
        if Settings[category][setting] < min then Settings[category][setting] = min end
        value.Text = tostring(Settings[category][setting])
    end)
    
    return bg
end

-- ==================== ЗАПОЛНЯЕМ ВКЛАДКИ ====================

-- COMBAT вкладка
local combatScroller = tabContents["COMBAT"]
local y = 5
createToggle(combatScroller, "Killaura", y, "Combat", "Killaura"); y = y + 35
createSlider(combatScroller, "Range", y, "Combat", "Range", 10, 30); y = y + 45
createToggle(combatScroller, "Aim Assist", y, "Combat", "AimAssist"); y = y + 35
createSlider(combatScroller, "FOV", y, "Combat", "FOV", 30, 180); y = y + 45
createToggle(combatScroller, "Auto Clicker", y, "Combat", "AutoClicker"); y = y + 35
createSlider(combatScroller, "CPS", y, "Combat", "CPS", 5, 20); y = y + 45
combatScroller.CanvasSize = UDim2.new(0, 0, 0, y)

-- MOVE вкладка
local moveScroller = tabContents["MOVE"]
y = 5
createToggle(moveScroller, "Speed", y, "Movement", "Speed"); y = y + 35
createSlider(moveScroller, "Speed Amount", y, "Movement", "SpeedAmount", 16, 100); y = y + 45
createToggle(moveScroller, "Infinite Jump", y, "Movement", "InfiniteJump"); y = y + 35
createToggle(moveScroller, "Bhop", y, "Movement", "Bhop"); y = y + 35
createSlider(moveScroller, "Bhop Speed", y, "Movement", "BhopSpeed", 16, 50); y = y + 45
moveScroller.CanvasSize = UDim2.new(0, 0, 0, y)

-- RENDER вкладка
local renderScroller = tabContents["RENDER"]
y = 5
createToggle(renderScroller, "ESP", y, "Render", "ESP"); y = y + 35
createToggle(renderScroller, "ESP Name", y, "Render", "ESPName"); y = y + 35
createToggle(renderScroller, "ESP Health", y, "Render", "ESPHealth"); y = y + 35
createToggle(renderScroller, "ESP Distance", y, "Render", "ESPDistance"); y = y + 35
createToggle(renderScroller, "Wallhack", y, "Render", "Wallhack"); y = y + 35
createToggle(renderScroller, "Full Bright", y, "Render", "FullBright"); y = y + 35
renderScroller.CanvasSize = UDim2.new(0, 0, 0, y)

-- PLAYER вкладка
local playerScroller = tabContents["PLAYER"]
y = 5
createToggle(playerScroller, "God Mode", y, "Player", "GodMode"); y = y + 35
playerScroller.CanvasSize = UDim2.new(0, 0, 0, y)

-- SPIN вкладка
local spinScroller = tabContents["SPIN"]
y = 5
createToggle(spinScroller, "Spin Bot", y, "Spin", "SpinBot"); y = y + 35
createSlider(spinScroller, "Spin Speed", y, "Spin", "SpinSpeed", 1, 30); y = y + 45
spinScroller.CanvasSize = UDim2.new(0, 0, 0, y)

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

-- ==================== ОТКРЫТИЕ МЕНЮ ====================

menuButton.MouseButton1Click:Connect(function()
    menu.Visible = not menu.Visible
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        menu.Visible = not menu.Visible
    end
end)

-- ==================== INFINITE JUMP ====================

local function doInfiniteJump()
    if not Settings.Movement.InfiniteJump then return end
    local player = Players.LocalPlayer
    if not player or not player.Character then return end
    
    local humanoid = player.Character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        humanoid.Jump = true
    end
end

-- ==================== SPEED ====================

local function doSpeed()
    if not Settings.Movement.Speed then return end
    local player = Players.LocalPlayer
    if not player or not player.Character then return end
    
    local humanoid = player.Character:FindFirstChild("Humanoid")
    local root = player.Character:FindFirstChild("HumanoidRootPart")
    
    if humanoid and root and humanoid.MoveDirection.Magnitude > 0 then
        root.Velocity = root.Velocity + humanoid.MoveDirection * (Settings.Movement.SpeedAmount - 16)
    end
end

-- ==================== BHOP ====================

local function doBhop()
    if not Settings.Movement.Bhop then return end
    local player = Players.LocalPlayer
    if not player or not player.Character then return end
    
    local humanoid = player.Character:FindFirstChild("Humanoid")
    local root = player.Character:FindFirstChild("HumanoidRootPart")
    
    if humanoid and root and humanoid.MoveDirection.Magnitude > 0 and humanoid.FloorMaterial then
        root.Velocity = root.Velocity + humanoid.MoveDirection * (Settings.Movement.BhopSpeed - 16)
        wait(0.05)
        humanoid.Jump = true
    end
end

-- ==================== SPIN BOT ====================

local spinAngle = 0
local function doSpin()
    if not Settings.Spin.SpinBot then return end
    local player = Players.LocalPlayer
    if not player or not player.Character then return end
    
    local root = player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    spinAngle = spinAngle + Settings.Spin.SpinSpeed
    root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, math.rad(spinAngle), 0)
end

-- ==================== GOD MODE ====================

local function doGodMode()
    if not Settings.Player.GodMode then return end
    local player = Players.LocalPlayer
    if not player or not player.Character then return end
    
    local humanoid = player.Character:FindFirstChild("Humanoid")
    if humanoid and humanoid.Health < humanoid.MaxHealth then
        humanoid.Health = humanoid.MaxHealth
    end
end

-- ==================== FULL BRIGHT ====================

local function doFullBright()
    if Settings.Render.FullBright then
        Lighting.Brightness = 3
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    else
        Lighting.Brightness = 1
        Lighting.GlobalShadows = true
        Lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
    end
end

-- ==================== ESP ====================

local espObjects = {}

local function createESP(player)
    if espObjects[player] then return end
    if player == Players.LocalPlayer then return end
    
    local function onCharacterAdded(char)
        local head = char:WaitForChild("Head")
        if not head then return end
        
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESP_"..player.Name
        billboard.Size = UDim2.new(0, 150, 0, 60)
        billboard.StudsOffset = Vector3.new(0, 2.5, 0)
        billboard.AlwaysOnTop = Settings.Render.Wallhack
        billboard.Parent = head
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, 0, 0.4, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = player.Name
        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLabel.TextScaled = true
        nameLabel.Font = Enum.Font.SourceSansBold
        nameLabel.Visible = Settings.Render.ESPName
        nameLabel.Parent = billboard
        
        local distanceLabel = Instance.new("TextLabel")
        distanceLabel.Size = UDim2.new(1, 0, 0.3, 0)
        distanceLabel.Position = UDim2.new(0, 0, 0.4, 0)
        distanceLabel.BackgroundTransparency = 1
        distanceLabel.Text = "0m"
        distanceLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        distanceLabel.TextScaled = true
        distanceLabel.Font = Enum.Font.SourceSans
        distanceLabel.Visible = Settings.Render.ESPDistance
        distanceLabel.Parent = billboard
        
        local healthBg = Instance.new("Frame")
        healthBg.Size = UDim2.new(1, 0, 0.3, 0)
        healthBg.Position = UDim2.new(0, 0, 0.7, 0)
        healthBg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        healthBg.Visible = Settings.Render.ESPHealth
        healthBg.Parent = billboard
        
        local healthBar = Instance.new("Frame")
        healthBar.Size = UDim2.new(1, 0, 1, 0)
        healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        healthBar.Parent = healthBg
        
        espObjects[player] = {
            billboard = billboard,
            nameLabel = nameLabel,
            distanceLabel = distanceLabel,
            healthBg = healthBg,
            healthBar = healthBar
        }
    end
    
    if player.Character then
        onCharacterAdded(player.Character)
    end
    
    player.CharacterAdded:Connect(onCharacterAdded)
end

-- Обновление ESP
RunService.RenderStepped:Connect(function()
    if not Settings.Render.ESP then
        for player, obj in pairs(espObjects) do
            if obj.billboard then
                obj.billboard.Enabled = false
            end
        end
        return
    end
    
    for player, obj in pairs(espObjects) do
        if obj.billboard and player.Character then
            obj.billboard.Enabled = true
            obj.billboard.AlwaysOnTop = Settings.Render.Wallhack
            obj.nameLabel.Visible = Settings.Render.ESPName
            obj.distanceLabel.Visible = Settings.Render.ESPDistance
            obj.healthBg.Visible = Settings.Render.ESPHealth
            
            local humanoid = player.Character:FindFirstChild("Humanoid")
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            local localPlayer = Players.LocalPlayer
            
            if humanoid and root and localPlayer and localPlayer.Character then
                local localRoot = localPlayer.Character:FindFirstChild("HumanoidRootPart")
                if localRoot then
                    local dist = (root.Position - localRoot.Position).Magnitude
                    obj.distanceLabel.Text = math.floor(dist) .. "m"
                end
                
                local health = humanoid.Health / humanoid.MaxHealth
                obj.healthBar.Size = UDim2.new(health, 0, 1, 0)
                
                if health > 0.6 then
                    obj.healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                elseif health > 0.3 then
                    obj.healthBar.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
                else
                    obj.healthBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                end
            end
        end
    end
end)

-- ==================== ГЛАВНЫЙ ЦИКЛ ====================

RunService.Heartbeat:Connect(function()
    doSpeed()
    doInfiniteJump()
    doBhop()
    doSpin()
    doGodMode()
    doFullBright()
end)

-- ==================== ИНИЦИАЛИЗАЦИЯ ====================

task.wait(1)

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= Players.LocalPlayer then
        createESP(player)
    end
end

Players.PlayerAdded:Connect(createESP)

print("✅ rusticlientv2 загружен!")
print("📌 ПК: Right Shift | Телефон: кнопка")
print("🎯 Spin Bot работает!")
