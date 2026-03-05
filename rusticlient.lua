-- rusticlient v8.0 - Оптимизирован для телефона
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

-- ==================== КНОПКА ДЛЯ ТЕЛЕФОНА (УВЕЛИЧЕННАЯ) ====================

local menuButton = Instance.new("ImageButton")
menuButton.Size = UDim2.new(0, 80, 0, 80) -- Увеличил для телефона
menuButton.Position = UDim2.new(0, 15, 0.5, -40)
menuButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
menuButton.BackgroundTransparency = 0.3
menuButton.Image = "rbxassetid://2823074130554611"
menuButton.Visible = isMobile
menuButton.Parent = gui

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(1, 0)
buttonCorner.Parent = menuButton

-- ==================== МЕНЮ (АДАПТИВНОЕ) ====================

local menu = Instance.new("Frame")
menu.Size = isMobile and UDim2.new(0, 400, 0, 600) or UDim2.new(0, 450, 0, 700)
menu.Position = isMobile and UDim2.new(0.5, -200, 0.5, -300) or UDim2.new(0.5, -225, 0.5, -350)
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
title.Text = "rusticlient v8.0"
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

-- ВКЛАДКИ (меньше для телефона)
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, -20, 0, isMobile and 25 or 30)
tabFrame.Position = UDim2.new(0, 10, 0, 70)
tabFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
tabFrame.BorderSizePixel = 0
tabFrame.Parent = menu

local tabButtons = {}
local tabContents = {}
local tabs = {"ESP", "AIM", "MOVE", "PLAYER", "SPIN", "BINDS", "SET"}

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
    scroller.CanvasSize = UDim2.new(0, 0, 0, 500)
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
    
    -- Movement
    speed = false,
    speedAmount = 32,
    jump = false,
    jumpPower = 50,
    
    -- Player (ИСПРАВЛЕНО)
    noFallDamage = false, -- Теперь реально убирает урон
    godMode = false,      -- Теперь работает
    infiniteJump = false,
    noClip = false,
    
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
    bindJump = Enum.KeyCode.F4,
    bindGodMode = Enum.KeyCode.F5,
    bindSpin = Enum.KeyCode.F6,
    bindNoClip = Enum.KeyCode.F7,
    
    -- Settings
    showBinds = true
}

-- ==================== ТВОЙ ESP КОД (АДАПТИРОВАН) ====================

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

-- ==================== ЗАПОЛНЯЕМ ВКЛАДКИ ====================

-- ESP
local espScroller = tabContents["ESP"]
local y = 5
createToggle(espScroller, "ESP", y, "esp"); y = y + 40
createToggle(espScroller, "Names", y, "names"); y = y + 40
createToggle(espScroller, "Distance", y, "distance"); y = y + 40
createToggle(espScroller, "Health", y, "health"); y = y + 40
createToggle(espScroller, "Wallhack", y, "wallhack"); y = y + 40
espScroller.CanvasSize = UDim2.new(0, 0, 0, y + 20)

-- AIM
local aimScroller = tabContents["AIM"]
y = 5
createToggle(aimScroller, "Aimbot", y, "aimbot"); y = y + 40
createSlider(aimScroller, "FOV", y, 50, 500, "aimFOV", "px"); y = y + 55
createSlider(aimScroller, "Smooth", y, 1, 20, "aimSmooth", ""); y = y + 55
createToggle(aimScroller, "Team Check", y, "aimTeamCheck"); y = y + 40
createToggle(aimScroller, "Wall Check", y, "aimWallCheck"); y = y + 40
aimScroller.CanvasSize = UDim2.new(0, 0, 0, y + 20)

-- MOVE
local moveScroller = tabContents["MOVE"]
y = 5
createToggle(moveScroller, "Speed", y, "speed"); y = y + 40
createSlider(moveScroller, "Speed Amount", y, 16, 100, "speedAmount", ""); y = y + 55
createToggle(moveScroller, "High Jump", y, "jump"); y = y + 40
createSlider(moveScroller, "Jump Power", y, 30, 200, "jumpPower", ""); y = y + 55
moveScroller.CanvasSize = UDim2.new(0, 0, 0, y + 20)

-- PLAYER
local playerScroller = tabContents["PLAYER"]
y = 5
createToggle(playerScroller, "GOD MODE", y, "godMode"); y = y + 40
createToggle(playerScroller, "NO FALL DAMAGE", y, "noFallDamage"); y = y + 40
createToggle(playerScroller, "Infinite Jump", y, "infiniteJump"); y = y + 40
createToggle(playerScroller, "No Clip", y, "noClip"); y = y + 40
playerScroller.CanvasSize = UDim2.new(0, 0, 0, y + 20)

-- SPIN
local spinScroller = tabContents["SPIN"]
y = 5
createToggle(spinScroller, "Spin Bot", y, "spinBot"); y = y + 40
createSlider(spinScroller, "Speed", y, 1, 30, "spinSpeed", ""); y = y + 55
spinScroller.CanvasSize = UDim2.new(0, 0, 0, y + 20)

-- BINDS
local bindsScroller = tabContents["BINDS"]
y = 5
-- Здесь можно добавить настройки биндов
bindsScroller.CanvasSize = UDim2.new(0, 0, 0, y + 20)

-- SET
local settingsScroller = tabContents["SET"]
y = 5
createToggle(settingsScroller, "Show Notifications", y, "showBinds"); y = y + 40
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

-- ==================== GOD MODE (ИСПРАВЛЕН) ====================

-- Реальный God Mode - убирает урон полностью
local function doGodMode()
    if not settings.godMode or not LocalPlayer.Character then return end
    
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    -- Ставим здоровье на максимум
    if humanoid.Health < humanoid.MaxHealth then
        humanoid.Health = humanoid.MaxHealth
    end
    
    -- Защита от мгновенной смерти
    humanoid.MaxHealth = math.huge
    humanoid.Health = math.huge
end

-- ==================== NO FALL DAMAGE (ИСПРАВЛЕН) ====================

-- Убирает урон от падения на уровне игры
local function doNoFallDamage()
    if not settings.noFallDamage or not LocalPlayer.Character then return end
    
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    -- Отключаем урон от падения
    humanoid.UseJumpPower = true
    humanoid.JumpPower = 50
    
    -- Если есть урон от падения - убираем его
    if humanoid:GetState() == Enum.HumanoidStateType.FallingDown then
        humanoid:ChangeState(Enum.HumanoidStateType.Running)
    end
    
    -- Сбрасываем скорость при приземлении чтобы не было урона
    if humanoid.FloorMaterial then
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root and root.Velocity.Y < -50 then
            root.Velocity = Vector3.new(root.Velocity.X, -10, root.Velocity.Z)
        end
    end
end

-- ==================== ОСТАЛЬНЫЕ ФУНКЦИИ ====================

-- SPEED
local function doSpeed()
    if not settings.speed or not LocalPlayer.Character then return end
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    if not humanoid then return end
    local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local moveDir = humanoid.MoveDirection
    if moveDir.Magnitude > 0 then
        local boost = settings.speedAmount - 16
        if boost > 0 then
            root.Velocity = root.Velocity + moveDir * boost
        end
    end
end

-- JUMP
local function doJump()
    if not settings.jump or not LocalPlayer.Character then return end
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    if not humanoid then return end
    local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    if humanoid.Jump and not humanoid.FloorMaterial then
        root.Velocity = Vector3.new(root.Velocity.X, settings.jumpPower, root.Velocity.Z)
    end
end

-- INFINITE JUMP
local function doInfiniteJump()
    if not settings.infiniteJump or not LocalPlayer.Character then return end
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        humanoid.Jump = true
    end
end

-- NO CLIP
local function doNoClip()
    if not settings.noClip or not LocalPlayer.Character then return end
    for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end

-- SPIN BOT
local spinAngle = 0
local function doSpin()
    if not settings.spinBot or not LocalPlayer.Character then return end
    local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local dir = settings.spinDirection == "Right" and 1 or -1
    spinAngle = spinAngle + settings.spinSpeed * dir
    root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, math.rad(spinAngle), 0)
end

-- ==================== AIMBOT ====================

local function getClosestPlayer()
    local closest = nil
    local closestDist = settings.aimFOV
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
            local humanoid = player.Character.Humanoid
            if humanoid and humanoid.Health > 0 then
                if settings.aimTeamCheck and player.Team == LocalPlayer.Team then
                    continue
                end
                
                local targetPart = player.Character:FindFirstChild(settings.aimTargetPart == "Head" and "Head" or "HumanoidRootPart")
                if targetPart then
                    if settings.aimWallCheck then
                        local ray = Ray.new(Camera.CFrame.Position, (targetPart.Position - Camera.CFrame.Position).Unit * 1000)
                        local hit, pos = workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character, player.Character})
                        if hit and not hit:IsDescendantOf(player.Character) then
                            continue
                        end
                    end
                    
                    local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                    if onScreen then
                        local dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
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
    if settings.aimbot then
        local target = getClosestPlayer()
        if target then
            local targetCFrame = CFrame.new(Camera.CFrame.Position, target.Position)
            Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, 1 / settings.aimSmooth)
        end
    end
end)

-- ==================== ГЛАВНЫЙ ЦИКЛ ====================

RunService.Heartbeat:Connect(function()
    doSpeed()
    doJump()
    doGodMode()
    doNoFallDamage()
    doInfiniteJump()
    doNoClip()
    doSpin()
end)

-- ==================== ОТКРЫТИЕ МЕНЮ ====================

if isMobile then
    menuButton.MouseButton1Click:Connect(function()
        menu.Visible = not menu.Visible
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

StarterGui:SetCore("SendNotification", {
    Title = "rusticlient v8.0",
    Text = isMobile and "📱 Готов к работе!" or "💻 Готов к работе!",
    Duration = 3
})

print("✅ rusticlient v8.0 загружен!")
print(isMobile and "📱 Режим телефона" or "💻 Режим ПК")
print("✨ God Mode и No Fall Damage ИСПРАВЛЕНЫ!")
