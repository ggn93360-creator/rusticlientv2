-- rusticlient v3.0 - ESP + Speed + Jump + No Fall + No Jump Cooldown + God Mode
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
menu.Size = UDim2.new(0, 380, 0, 600)
menu.Position = UDim2.new(0.5, -190, 0.5, -300)
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
title.Text = "rusticlient v3.0"
title.TextColor3 = Color3.fromRGB(255, 100, 100)
title.TextScaled = true
title.Font = Enum.Font.SourceSansBold
title.Parent = menu

-- Инфо
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, 0, 0, 25)
infoLabel.Position = UDim2.new(0, 0, 0, 40)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "Device: " .. (isMobile and "Mobile" or "PC") .. " | " .. injectorType
infoLabel.TextColor3 = Color3.fromRGB(150, 150, 255)
infoLabel.TextScaled = true
infoLabel.Font = Enum.Font.SourceSans
infoLabel.Parent = menu

-- ВКЛАДКИ
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, -20, 0, 30)
tabFrame.Position = UDim2.new(0, 10, 0, 70)
tabFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
tabFrame.BorderSizePixel = 0
tabFrame.Parent = menu

local tabButtons = {}
local tabContents = {}
local tabs = {"ESP", "AIMBOT", "MOVEMENT", "PLAYER", "SETTINGS"}

for i, tabName in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.2, -2, 1, -4)
    btn.Position = UDim2.new((i-1)*0.2, 2, 0, 2)
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
contentFrame.Size = UDim2.new(1, -20, 1, -140)
contentFrame.Position = UDim2.new(0, 10, 0, 105)
contentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
contentFrame.BorderSizePixel = 0
contentFrame.Parent = menu

-- СКОЛЛЕРЫ ДЛЯ КАЖДОЙ ВКЛАДКИ
for _, tabName in ipairs(tabs) do
    local scroller = Instance.new("ScrollingFrame")
    scroller.Name = tabName .. "Scroller"
    scroller.Size = UDim2.new(1, -10, 1, -10)
    scroller.Position = UDim2.new(0, 5, 0, 5)
    scroller.BackgroundTransparency = 1
    scroller.BorderSizePixel = 0
    scroller.ScrollBarThickness = 6
    scroller.ScrollBarImageColor3 = Color3.fromRGB(255, 50, 50)
    scroller.CanvasSize = UDim2.new(0, 0, 0, 500)
    scroller.Visible = (tabName == "ESP")
    scroller.Parent = contentFrame
    tabContents[tabName] = scroller
end

-- ==================== НАСТРОЙКИ ====================

local settings = {
    -- ESP
    esp = false,
    boxes = false,
    names = false,
    health = false,
    wallhack = false,
    
    -- Aimbot
    aimbot = false,
    aimFOV = 200,
    aimSmooth = 5,
    aimTeamCheck = false,
    aimWallCheck = true,
    aimTargetPart = "Head",
    aimTargetType = "Closest",
    
    -- Movement
    speed = false,
    speedAmount = 32,
    jump = false,
    jumpPower = 50,
    
    -- Player (НОВЫЕ ФУНКЦИИ)
    noFallDamage = false,
    noJumpCooldown = false,
    godMode = false,
    infiniteJump = false,
    noClip = false,
    
    -- Settings
    menuKey = Enum.KeyCode.RightShift
}

-- ==================== ФУНКЦИИ СОЗДАНИЯ ЭЛЕМЕНТОВ ====================

local function createToggle(parent, name, yPos, setting, callback)
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
        if callback then callback(settings[setting]) end
    end)
    
    return bg
end

local function createSlider(parent, name, yPos, min, max, setting, suffix, callback)
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
        if callback then callback(settings[setting]) end
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

local function createDropdown(parent, name, yPos, options, setting, callback)
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
    
    local currentValue = settings[setting]
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 80, 0, 30)
    button.Position = UDim2.new(1, -90, 0.5, -15)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    button.Text = tostring(currentValue)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextScaled = true
    button.Font = Enum.Font.SourceSansBold
    button.Parent = bg
    
    local menuOpen = false
    local optionsFrame
    
    button.MouseButton1Click:Connect(function()
        menuOpen = not menuOpen
        if menuOpen then
            if optionsFrame then optionsFrame:Destroy() end
            optionsFrame = Instance.new("Frame")
            optionsFrame.Size = UDim2.new(0, 80, 0, #options * 25)
            optionsFrame.Position = UDim2.new(1, -90, 1, 0)
            optionsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            optionsFrame.BorderSizePixel = 1
            optionsFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
            optionsFrame.Parent = bg
            
            for i, option in ipairs(options) do
                local optBtn = Instance.new("TextButton")
                optBtn.Size = UDim2.new(1, 0, 0, 25)
                optBtn.Position = UDim2.new(0, 0, 0, (i-1)*25)
                optBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
                optBtn.Text = option
                optBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                optBtn.TextScaled = true
                optBtn.Font = Enum.Font.SourceSans
                optBtn.Parent = optionsFrame
                
                optBtn.MouseButton1Click:Connect(function()
                    settings[setting] = option
                    button.Text = option
                    optionsFrame:Destroy()
                    menuOpen = false
                    if callback then callback(option) end
                end)
            end
        else
            if optionsFrame then optionsFrame:Destroy() end
        end
    end)
    
    return bg
end

-- ==================== ЗАПОЛНЯЕМ ВКЛАДКИ ====================

-- ESP вкладка
local espScroller = tabContents["ESP"]
local y = 5
createToggle(espScroller, "ESP Enabled", y, "esp"); y = y + 40
createToggle(espScroller, "3D Boxes", y, "boxes"); y = y + 40
createToggle(espScroller, "Name Tags", y, "names"); y = y + 40
createToggle(espScroller, "Health Bars", y, "health"); y = y + 40
createToggle(espScroller, "Wallhack", y, "wallhack"); y = y + 40
espScroller.CanvasSize = UDim2.new(0, 0, 0, y + 20)

-- AIMBOT вкладка
local aimScroller = tabContents["AIMBOT"]
y = 5
createToggle(aimScroller, "Aimbot Enabled", y, "aimbot"); y = y + 40
createSlider(aimScroller, "Aim FOV", y, 50, 500, "aimFOV", "px"); y = y + 55
createSlider(aimScroller, "Smoothness", y, 1, 20, "aimSmooth", ""); y = y + 55
createToggle(aimScroller, "Team Check", y, "aimTeamCheck"); y = y + 40
createToggle(aimScroller, "Wall Check", y, "aimWallCheck"); y = y + 40
createDropdown(aimScroller, "Target Part", y, {"Head", "HumanoidRootPart", "Torso"}, "aimTargetPart"); y = y + 50
createDropdown(aimScroller, "Target Type", y, {"Closest", "Lowest HP", "Highest HP", "Lowest Dist"}, "aimTargetType"); y = y + 50
aimScroller.CanvasSize = UDim2.new(0, 0, 0, y + 20)

-- MOVEMENT вкладка
local moveScroller = tabContents["MOVEMENT"]
y = 5
createToggle(moveScroller, "Speed Hack", y, "speed"); y = y + 40
createSlider(moveScroller, "Speed Amount", y, 16, 100, "speedAmount", ""); y = y + 55
createToggle(moveScroller, "High Jump", y, "jump"); y = y + 40
createSlider(moveScroller, "Jump Power", y, 30, 200, "jumpPower", ""); y = y + 55
moveScroller.CanvasSize = UDim2.new(0, 0, 0, y + 20)

-- PLAYER вкладка (НОВЫЕ ФУНКЦИИ)
local playerScroller = tabContents["PLAYER"]
y = 5
createToggle(playerScroller, "No Fall Damage", y, "noFallDamage"); y = y + 40
createToggle(playerScroller, "No Jump Cooldown", y, "noJumpCooldown"); y = y + 40
createToggle(playerScroller, "God Mode", y, "godMode"); y = y + 40
createToggle(playerScroller, "Infinite Jump", y, "infiniteJump"); y = y + 40
createToggle(playerScroller, "No Clip", y, "noClip"); y = y + 40
playerScroller.CanvasSize = UDim2.new(0, 0, 0, y + 20)

-- SETTINGS вкладка
local settingsScroller = tabContents["SETTINGS"]
y = 5
createToggle(settingsScroller, "Menu Key: Right Shift", y, "menuKey", function() end); y = y + 40
settingsScroller.CanvasSize = UDim2.new(0, 0, 0, y + 20)

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

-- ==================== AIMBOT ====================

local function getTeam(player)
    if not player or not player.Character then return nil end
    local team = player.Team
    return team and team.Name or "NoTeam"
end

local function getTargetPart(player)
    if not player or not player.Character then return nil end
    if settings.aimTargetPart == "Head" then
        return player.Character:FindFirstChild("Head")
    elseif settings.aimTargetPart == "HumanoidRootPart" then
        return player.Character:FindFirstChild("HumanoidRootPart")
    elseif settings.aimTargetPart == "Torso" then
        return player.Character:FindFirstChild("Torso")
    end
    return player.Character:FindFirstChild("HumanoidRootPart")
end

local function isVisible(player, part)
    if not part then return false end
    if not settings.aimWallCheck then return true end
    local ray = Ray.new(Camera.CFrame.Position, (part.Position - Camera.CFrame.Position).Unit * 1000)
    local hit, pos = workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character, player.Character})
    return hit == nil or hit:IsDescendantOf(player.Character)
end

local function getClosestPlayer()
    local closest = nil
    local closestDist = settings.aimFOV
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    local players = {}
    
    -- Собираем всех игроков
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
            local humanoid = player.Character.Humanoid
            if humanoid and humanoid.Health > 0 then
                -- Team check
                if settings.aimTeamCheck and player.Team == LocalPlayer.Team then
                    continue
                end
                
                local targetPart = getTargetPart(player)
                if targetPart then
                    -- Visible check
                    if settings.aimWallCheck and not isVisible(player, targetPart) then
                        continue
                    end
                    
                    local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                    if onScreen then
                        local dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                        if dist < closestDist then
                            table.insert(players, {
                                player = player,
                                part = targetPart,
                                dist = dist,
                                health = humanoid.Health
                            })
                        end
                    end
                end
            end
        end
    end
    
    -- Выбираем цель по типу
    if #players == 0 then return nil end
    
    if settings.aimTargetType == "Closest" or settings.aimTargetType == "Lowest Dist" then
        table.sort(players, function(a, b) return a.dist < b.dist end)
        return players[1].player, players[1].part
    elseif settings.aimTargetType == "Lowest HP" then
        table.sort(players, function(a, b) return a.health < b.health end)
        return players[1].player, players[1].part
    elseif settings.aimTargetType == "Highest HP" then
        table.sort(players, function(a, b) return a.health > b.health end)
        return players[1].player, players[1].part
    end
    
    return nil
end

-- Aimbot
RunService.RenderStepped:Connect(function()
    if settings.aimbot then
        local targetPlayer, targetPart = getClosestPlayer()
        if targetPlayer and targetPart then
            local targetCFrame = CFrame.new(Camera.CFrame.Position, targetPart.Position)
            Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, 1 / settings.aimSmooth)
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
    
    if humanoid.Jump and not humanoid.FloorMaterial then
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            root.Velocity = Vector3.new(root.Velocity.X, settings.jumpPower, root.Velocity.Z)
        end
    end
end

-- ==================== NO FALL DAMAGE ====================

local function doNoFallDamage()
    if not settings.noFallDamage or not LocalPlayer.Character then return end
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    -- Сбрасываем скорость падения при приземлении
    if humanoid.FloorMaterial then
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            root.Velocity = Vector3.new(root.Velocity.X, 0, root.Velocity.Z)
        end
    end
end

-- ==================== NO JUMP COOLDOWN ====================

local function doNoJumpCooldown()
    if not settings.noJumpCooldown or not LocalPlayer.Character then return end
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    -- Убираем задержку между прыжками
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        if humanoid.FloorMaterial then
            humanoid.Jump = true
        end
    end
end

-- ==================== GOD MODE ====================

local function doGodMode()
    if not settings.godMode or not LocalPlayer.Character then return end
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    -- Бесконечное здоровье
    humanoid.Health = humanoid.MaxHealth
end

-- ==================== INFINITE JUMP ====================

local function doInfiniteJump()
    if not settings.infiniteJump or not LocalPlayer.Character then return end
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    -- Можно прыгать в воздухе
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        humanoid.Jump = true
    end
end

-- ==================== NO CLIP ====================

local function doNoClip()
    if not settings.noClip or not LocalPlayer.Character then return end
    
    for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end

-- ==================== ГЛАВНЫЙ ЦИКЛ ====================

RunService.Heartbeat:Connect(function()
    doSpeed()
    doJump()
    doNoFallDamage()
    doNoJumpCooldown()
    doGodMode()
    doInfiniteJump()
    doNoClip()
end)

-- ==================== ОТКРЫТИЕ МЕНЮ ====================

if isMobile then
    menuButton.MouseButton1Click:Connect(function()
        menu.Visible = not menu.Visible
    end)
else
    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == settings.menuKey then
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
    player.CharacterAdded:Connect(function()
        task.wait(1.5)
        if settings.esp then
            createESP(player)
        end
    end)
end)

Players.PlayerRemoving:Connect(removeESP)

StarterGui:SetCore("SendNotification", {
    Title = "rusticlient v3.0",
    Text = "Загружен! ПК: Правый Shift | Телефон: кнопка",
    Duration = 5
})

print("✅ rusticlient v3.0 загружен!")
print("📌 Новые функции: No Fall, No Jump CD, God Mode, Inf Jump, No Clip!")
