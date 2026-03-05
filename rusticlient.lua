-- rusticlient - ESP + Speed + High Jump
-- Автор: SWILL / rusticlient

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local StarterGui = game:GetService("StarterGui")

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

-- ==================== КНОПКА ДЛЯ ТЕЛЕФОНА ====================

local menuButton = Instance.new("ImageButton")
menuButton.Size = UDim2.new(0, 60, 0, 60)
menuButton.Position = UDim2.new(0, 10, 0.5, -30)
menuButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
menuButton.BackgroundTransparency = 0.3
menuButton.Image = "rbxassetid://2823074130554611"
menuButton.Visible = isMobile
menuButton.Parent = gui

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(1, 0)
buttonCorner.Parent = menuButton

-- ==================== МЕНЮ ====================

local menu = Instance.new("Frame")
menu.Size = UDim2.new(0, 300, 0, 450)
menu.Position = UDim2.new(0.5, -150, 0.5, -225)
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
title.Text = "rusticlient v1.0"
title.TextColor3 = Color3.fromRGB(255, 100, 100)
title.TextScaled = true
title.Font = Enum.Font.SourceSansBold
title.Parent = menu

-- Инфо
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, 0, 0, 25)
infoLabel.Position = UDim2.new(0, 0, 0, 40)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "Device: " .. (isMobile and "Mobile" or "PC")
infoLabel.TextColor3 = Color3.fromRGB(150, 150, 255)
infoLabel.TextScaled = true
infoLabel.Font = Enum.Font.SourceSans
infoLabel.Parent = menu

-- СКОЛЛЕР
local scroller = Instance.new("ScrollingFrame")
scroller.Size = UDim2.new(1, -20, 1, -80)
scroller.Position = UDim2.new(0, 10, 0, 70)
scroller.BackgroundTransparency = 1
scroller.BorderSizePixel = 0
scroller.ScrollBarThickness = 6
scroller.ScrollBarImageColor3 = Color3.fromRGB(255, 0, 0)
scroller.CanvasSize = UDim2.new(0, 0, 0, 400)
scroller.Parent = menu

-- ==================== НАСТРОЙКИ ====================

local settings = {
    esp = false,
    boxes = false,
    names = false,
    health = false,
    wallhack = false,
    speed = false,
    speedAmount = 32,
    jump = false,
    jumpPower = 50,
    aimbot = false,
    aimFOV = 200
}

-- Функция создания переключателя
local function createToggle(name, yPos, setting)
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(0.9, 0, 0, 35)
    bg.Position = UDim2.new(0.05, 0, 0, yPos)
    bg.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    bg.BorderSizePixel = 0
    bg.Parent = scroller
    
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
    end)
    
    return bg
end

-- Функция создания слайдера
local function createSlider(name, yPos, min, max, setting, suffix)
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(0.9, 0, 0, 50)
    bg.Position = UDim2.new(0.05, 0, 0, yPos)
    bg.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    bg.BorderSizePixel = 0
    bg.Parent = scroller
    
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

-- Создаем элементы
local y = 5
createToggle("ESP Enabled", y, "esp"); y = y + 40
createToggle("3D Boxes", y, "boxes"); y = y + 40
createToggle("Name Tags", y, "names"); y = y + 40
createToggle("Health Bars", y, "health"); y = y + 40
createToggle("Wallhack", y, "wallhack"); y = y + 40
createToggle("Speed Hack", y, "speed"); y = y + 40
createSlider("Speed Amount", y, 16, 100, "speedAmount", ""); y = y + 55
createToggle("High Jump", y, "jump"); y = y + 40
createSlider("Jump Power", y, 30, 200, "jumpPower", ""); y = y + 55
createToggle("Aimbot", y, "aimbot"); y = y + 40
createSlider("Aim FOV", y, 50, 500, "aimFOV", ""); y = y + 55

scroller.CanvasSize = UDim2.new(0, 0, 0, y + 20)

-- ==================== КРУЖОК АИМА ====================

local aimCircle = Instance.new("Frame")
aimCircle.Size = UDim2.new(0, settings.aimFOV, 0, settings.aimFOV)
aimCircle.Position = UDim2.new(0.5, -settings.aimFOV/2, 0.5, -settings.aimFOV/2)
aimCircle.BackgroundTransparency = 1
aimCircle.BorderColor3 = Color3.fromRGB(255, 255, 255)
aimCircle.BorderSizePixel = 2
aimCircle.Visible = false
aimCircle.Parent = gui

local circleCorner = Instance.new("UICorner")
circleCorner.CornerRadius = UDim.new(1, 0)
circleCorner.Parent = aimCircle

-- ==================== ESP ====================

local espObjects = {}

local function createESP(player)
    if espObjects[player] then return end
    if not player.Character then return end
    
    local head = player.Character:FindFirstChild("Head")
    if not head then return end
    
    local esp = {}
    
    -- Billboard
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 100, 0, 100)
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.AlwaysOnTop = settings.wallhack
    billboard.Adornee = head
    billboard.Parent = gui
    
    -- Box
    local box = Instance.new("Frame")
    box.Size = UDim2.new(1, 0, 1, 0)
    box.BackgroundTransparency = 1
    box.BorderColor3 = Color3.fromRGB(255, 0, 0)
    box.BorderSizePixel = 2
    box.Visible = false
    box.Parent = billboard
    
    -- Name
    local nameTag = Instance.new("TextLabel")
    nameTag.Size = UDim2.new(1, 0, 0, 20)
    nameTag.Position = UDim2.new(0, 0, 0, -20)
    nameTag.BackgroundTransparency = 0.5
    nameTag.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    nameTag.Text = player.Name
    nameTag.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameTag.TextSize = 14
    nameTag.Font = Enum.Font.SourceSansBold
    nameTag.Visible = false
    nameTag.Parent = billboard
    
    -- Health bar background
    local healthBg = Instance.new("Frame")
    healthBg.Size = UDim2.new(1, 0, 0, 4)
    healthBg.Position = UDim2.new(0, 0, 1, 2)
    healthBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    healthBg.BorderSizePixel = 0
    healthBg.Visible = false
    healthBg.Parent = billboard
    
    -- Health bar
    local healthBar = Instance.new("Frame")
    healthBar.Size = UDim2.new(1, 0, 1, 0)
    healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    healthBar.BorderSizePixel = 0
    healthBar.Parent = healthBg
    
    -- Health text
    local healthText = Instance.new("TextLabel")
    healthText.Size = UDim2.new(1, 0, 0, 14)
    healthText.Position = UDim2.new(0, 0, 1, 8)
    healthText.BackgroundTransparency = 0.5
    healthText.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    healthText.Text = "100/100 HP"
    healthText.TextColor3 = Color3.fromRGB(255, 255, 255)
    healthText.TextSize = 10
    healthText.Font = Enum.Font.SourceSans
    healthText.Visible = false
    healthText.Parent = billboard
    
    esp.billboard = billboard
    esp.box = box
    esp.nameTag = nameTag
    esp.healthBg = healthBg
    esp.healthBar = healthBar
    esp.healthText = healthText
    espObjects[player] = esp
end

-- Удаление ESP
local function removeESP(player)
    if espObjects[player] and espObjects[player].billboard then
        espObjects[player].billboard:Destroy()
        espObjects[player] = nil
    end
end

-- Обновление ESP
RunService.RenderStepped:Connect(function()
    -- Обновление кружка
    aimCircle.Visible = settings.aimbot
    aimCircle.Size = UDim2.new(0, settings.aimFOV, 0, settings.aimFOV)
    aimCircle.Position = UDim2.new(0.5, -settings.aimFOV/2, 0.5, -settings.aimFOV/2)
    
    -- ESP
    if settings.esp then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
                local humanoid = player.Character.Humanoid
                if humanoid and humanoid.Health > 0 then
                    if not espObjects[player] then
                        createESP(player)
                    end
                    
                    local esp = espObjects[player]
                    if esp and esp.billboard then
                        -- Обновляем видимость
                        esp.billboard.AlwaysOnTop = settings.wallhack
                        esp.box.Visible = settings.boxes
                        esp.nameTag.Visible = settings.names
                        esp.healthBg.Visible = settings.health
                        esp.healthText.Visible = settings.health
                        
                        -- Обновляем здоровье
                        local healthPercent = humanoid.Health / humanoid.MaxHealth
                        if esp.box then
                            esp.box.BorderColor3 = Color3.new(1 - healthPercent, healthPercent, 0)
                        end
                        if esp.healthBar then
                            esp.healthBar.Size = UDim2.new(healthPercent, 0, 1, 0)
                            esp.healthBar.BackgroundColor3 = Color3.new(1 - healthPercent, healthPercent, 0)
                        end
                        if esp.healthText then
                            esp.healthText.Text = math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth) .. " HP"
                        end
                    end
                else
                    removeESP(player)
                end
            else
                removeESP(player)
            end
        end
    else
        for player, _ in pairs(espObjects) do
            removeESP(player)
        end
    end
end)

-- ==================== SPEED HACK ====================

local function doSpeed()
    if not settings.speed or not LocalPlayer.Character then return end
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root and humanoid.MoveDirection.Magnitude > 0 then
        root.Velocity = root.Velocity + humanoid.MoveDirection * (settings.speedAmount - 16)
    end
end

-- ==================== HIGH JUMP ====================

local function doJump()
    if not settings.jump or not LocalPlayer.Character then return end
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    -- Проверяем, прыгает ли игрок
    if humanoid.Jump and not humanoid.FloorMaterial then
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            root.Velocity = Vector3.new(root.Velocity.X, settings.jumpPower, root.Velocity.Z)
        end
    end
end

-- ==================== ГЛАВНЫЙ ЦИКЛ ====================

RunService.Heartbeat:Connect(function()
    doSpeed()
    doJump()
end)

-- ==================== AIMBOT ====================

local function getClosestPlayer()
    local closest = nil
    local closestDist = settings.aimFOV
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local root = player.Character.HumanoidRootPart
            if root then
                local screenPos, onScreen = Camera:WorldToViewportPoint(root.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                        closest = player
                    end
                end
            end
        end
    end
    
    return closest
end

RunService.RenderStepped:Connect(function()
    if settings.aimbot then
        local target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local root = target.Character.HumanoidRootPart
            if root then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, root.Position)
            end
        end
    end
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

-- Даем время на загрузку
task.wait(2)

-- Создаем ESP для существующих игроков
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        task.spawn(function()
            createESP(player)
        end)
    end
end

-- Обработка новых игроков
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(1.5)
        if settings.esp then
            createESP(player)
        end
    end)
end)

Players.PlayerRemoving:Connect(removeESP)

-- Уведомление о загрузке
StarterGui:SetCore("SendNotification", {
    Title = "rusticlient v1.0",
    Text = "Загружен! ПК: Правый Shift | Телефон: кнопка",
    Duration = 5
})

print("✅ rusticlient v1.0 загружен!")
print("📌 Автор: SWILL / rusticlient")
