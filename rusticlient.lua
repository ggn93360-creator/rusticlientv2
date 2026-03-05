-- rusticlient v12.0 - РАБОЧЕЕ красивое меню
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

-- ==================== ОПРЕДЕЛЕНИЕ УСТРОЙСТВА ====================

local isMobile = UserInputService.TouchEnabled
local injectorType = "UNKNOWN"

if identifyexecutor then
    injectorType = identifyexecutor()
end

-- ==================== ОЧИСТКА СТАРЫХ ГУИ ====================

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
menuButton.Visible = true
menuButton.Parent = gui

-- Делаем кнопку круглой
local menuButtonCorner = Instance.new("UICorner")
menuButtonCorner.CornerRadius = UDim.new(1, 0)
menuButtonCorner.Parent = menuButton

-- ==================== КРАСИВОЕ МЕНЮ ====================

local menu = Instance.new("Frame")
menu.Size = UDim2.new(0, 450, 0, 650)
menu.Position = UDim2.new(0.5, -225, 0.5, -325)
menu.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
menu.BackgroundTransparency = 0.1
menu.Visible = false
menu.Active = true
menu.Draggable = true
menu.Parent = gui

-- Скругленные углы меню
local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0, 15)
menuCorner.Parent = menu

-- Заголовок
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 45)
title.BackgroundTransparency = 1
title.Text = "RUSTICLIENT v12.0"
title.TextColor3 = Color3.fromRGB(255, 100, 100)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = menu

-- Инфо об инжекторе
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, -20, 0, 25)
infoLabel.Position = UDim2.new(0, 10, 0, 45)
infoLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
infoLabel.BackgroundTransparency = 0.3
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

local tabs = {"ESP", "AIM", "MOVE", "PLAYER", "RENDER", "SPIN"}
local tabButtons = {}
local tabContents = {}

for i, tabName in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1/6, -5, 1, -5)
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

-- КОНТЕЙНЕР ДЛЯ КОНТЕНТА
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -20, 1, -130)
contentFrame.Position = UDim2.new(0, 10, 0, 120)
contentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
contentFrame.BackgroundTransparency = 0.2
contentFrame.Parent = menu

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 10)
contentCorner.Parent = contentFrame

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
    
    -- Player
    godMode = false,
    noFallDamage = false,
    infiniteJump = false,
    noClip = false,
    noJumpCooldown = false,
    
    -- Render
    removeGrass = false,
    removeFoliage = false,
    removeTrees = false,
    removeClouds = false,
    removeFog = false,
    potatoGraphics = false,
    fullBright = false,
    chineseHat = false,
    jumpTrail = false,
    
    -- Spin
    spinBot = false,
    spinSpeed = 10
}

-- ==================== ФУНКЦИЯ СОЗДАНИЯ ПЕРЕКЛЮЧАТЕЛЯ ====================

local function createToggle(parent, name, yPos, setting)
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(0.9, 0, 0, 35)
    bg.Position = UDim2.new(0.05, 0, 0, yPos)
    bg.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    bg.BorderSizePixel = 0
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
    toggle.BackgroundColor3 = settings[setting] and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    toggle.Text = settings[setting] and "ON" or "OFF"
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.TextScaled = true
    toggle.Font = Enum.Font.GothamBold
    toggle.Parent = bg
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 5)
    toggleCorner.Parent = toggle
    
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
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 40, 0.4, 0)
    valueLabel.Position = UDim2.new(1, -50, 0, 5)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(settings[setting]) .. suffix
    valueLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    valueLabel.TextScaled = true
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.Parent = bg
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(0.8, 0, 0, 8)
    sliderBg.Position = UDim2.new(0.1, 0, 0, 30)
    sliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = bg
    
    local sliderBgCorner = Instance.new("UICorner")
    sliderBgCorner.CornerRadius = UDim.new(0, 4)
    sliderBgCorner.Parent = sliderBg
    
    local slider = Instance.new("Frame")
    slider.Size = UDim2.new((settings[setting] - min) / (max - min), 0, 1, 0)
    slider.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    slider.BorderSizePixel = 0
    slider.Parent = sliderBg
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 4)
    sliderCorner.Parent = slider
    
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

-- ESP вкладка
local espScroller = tabContents["ESP"]
local y = 5
createToggle(espScroller, "ESP", y, "esp"); y = y + 40
createToggle(espScroller, "Names", y, "names"); y = y + 40
createToggle(espScroller, "Distance", y, "distance"); y = y + 40
createToggle(espScroller, "Health", y, "health"); y = y + 40
createToggle(espScroller, "Wallhack", y, "wallhack"); y = y + 40
espScroller.CanvasSize = UDim2.new(0, 0, 0, y + 20)

-- AIM вкладка
local aimScroller = tabContents["AIM"]
y = 5
createToggle(aimScroller, "Aimbot", y, "aimbot"); y = y + 40
createSlider(aimScroller, "FOV", y, 50, 500, "aimFOV", "px"); y = y + 55
createSlider(aimScroller, "Smooth", y, 1, 20, "aimSmooth", ""); y = y + 55
createToggle(aimScroller, "Team Check", y, "aimTeamCheck"); y = y + 40
createToggle(aimScroller, "Wall Check", y, "aimWallCheck"); y = y + 40
aimScroller.CanvasSize = UDim2.new(0, 0, 0, y + 20)

-- MOVE вкладка
local moveScroller = tabContents["MOVE"]
y = 5
createToggle(moveScroller, "Speed", y, "speed"); y = y + 40
createSlider(moveScroller, "Speed Amount", y, 16, 100, "speedAmount", ""); y = y + 55
moveScroller.CanvasSize = UDim2.new(0, 0, 0, y + 20)

-- PLAYER вкладка
local playerScroller = tabContents["PLAYER"]
y = 5
createToggle(playerScroller, "God Mode", y, "godMode"); y = y + 40
createToggle(playerScroller, "No Fall", y, "noFallDamage"); y = y + 40
createToggle(playerScroller, "No Jump CD", y, "noJumpCooldown"); y = y + 40
createToggle(playerScroller, "Infinite Jump", y, "infiniteJump"); y = y + 40
createToggle(playerScroller, "No Clip", y, "noClip"); y = y + 40
playerScroller.CanvasSize = UDim2.new(0, 0, 0, y + 20)

-- RENDER вкладка
local renderScroller = tabContents["RENDER"]
y = 5
createToggle(renderScroller, "Remove Grass", y, "removeGrass"); y = y + 40
createToggle(renderScroller, "Remove Foliage", y, "removeFoliage"); y = y + 40
createToggle(renderScroller, "Remove Trees", y, "removeTrees"); y = y + 40
createToggle(renderScroller, "Remove Clouds", y, "removeClouds"); y = y + 40
createToggle(renderScroller, "Remove Fog", y, "removeFog"); y = y + 40
createToggle(renderScroller, "Potato Graphics", y, "potatoGraphics"); y = y + 40
createToggle(renderScroller, "Full Bright", y, "fullBright"); y = y + 40
createToggle(renderScroller, "Chinese Hat", y, "chineseHat"); y = y + 40
createToggle(renderScroller, "Jump Trail", y, "jumpTrail"); y = y + 40
renderScroller.CanvasSize = UDim2.new(0, 0, 0, y + 20)

-- SPIN вкладка
local spinScroller = tabContents["SPIN"]
y = 5
createToggle(spinScroller, "Spin Bot", y, "spinBot"); y = y + 40
createSlider(spinScroller, "Spin Speed", y, 1, 30, "spinSpeed", ""); y = y + 55
spinScroller.CanvasSize = UDim2.new(0, 0, 0, y + 20)

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

-- ==================== ESP ====================

local espObjects = {}

local function createESP(player)
    if espObjects[player] then return end
    if player == LocalPlayer then return end
    
    local function onCharacterAdded(char)
        local head = char:WaitForChild("Head", 5)
        local humanoid = char:WaitForChild("Humanoid", 5)
        local root = char:WaitForChild("HumanoidRootPart", 5)
        
        if not head or not humanoid or not root then return end
        
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESP_"..player.Name
        billboard.Size = UDim2.new(0, 200, 0, 60)
        billboard.StudsOffset = Vector3.new(0, 2.5, 0)
        billboard.AlwaysOnTop = settings.wallhack
        billboard.Parent = head
        
        local text = Instance.new("TextLabel")
        text.Size = UDim2.new(1, 0, 1, 0)
        text.BackgroundTransparency = 1
        text.TextScaled = true
        text.TextColor3 = Color3.new(1, 1, 1)
        text.Font = Enum.Font.SourceSansBold
        text.Parent = billboard
        
        if not espObjects[player] then
            espObjects[player] = {}
        end
        
        table.insert(espObjects[player], {
            billboard = billboard,
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
            if obj.billboard then
                obj.billboard:Destroy()
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
                if obj.billboard then
                    obj.billboard.Enabled = false
                end
            end
        end
        return
    end
    
    for player, objects in pairs(espObjects) do
        for _, obj in ipairs(objects) do
            if obj.billboard and obj.humanoid and obj.root then
                obj.billboard.Enabled = true
                obj.billboard.AlwaysOnTop = settings.wallhack
                
                local myChar = LocalPlayer.Character
                if not myChar then 
                    obj.text.Text = player.Name
                    return 
                end
                
                local myRoot = myChar:FindFirstChild("HumanoidRootPart")
                if not myRoot then 
                    obj.text.Text = player.Name
                    return 
                end
                
                local myPos = myRoot.Position
                local enemyPos = obj.root.Position
                local distance = (myPos - enemyPos).Magnitude
                local hp = math.floor(obj.humanoid.Health)
                
                local textParts = {}
                if settings.names then table.insert(textParts, player.Name) end
                if settings.distance then table.insert(textParts, math.floor(distance).."m") end
                if settings.health then table.insert(textParts, "HP:"..hp) end
                
                obj.text.Text = table.concat(textParts, " | ")
                
                if settings.health then
                    local healthPercent = obj.humanoid.Health / obj.humanoid.MaxHealth
                    if healthPercent > 0.6 then
                        obj.text.TextColor3 = Color3.fromRGB(0, 255, 0)
                    elseif healthPercent > 0.3 then
                        obj.text.TextColor3 = Color3.fromRGB(255, 255, 0)
                    else
                        obj.text.TextColor3 = Color3.fromRGB(255, 0, 0)
                    end
                end
            end
        end
    end
end)

-- ==================== SPEED ====================

local function doSpeed()
    if not settings.speed or not LocalPlayer.Character then return end
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    if not humanoid then return end
    local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
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

-- ==================== GOD MODE ====================

local function doGodMode()
    if not settings.godMode or not LocalPlayer.Character then return end
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    if humanoid.Health < humanoid.MaxHealth then
        humanoid.Health = humanoid.MaxHealth
    end
end

-- ==================== NO FALL ====================

local function doNoFall()
    if not settings.noFallDamage or not LocalPlayer.Character then return end
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    if humanoid:GetState() == Enum.HumanoidStateType.Freefall then
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root and root.Velocity.Y < -50 then
            root.Velocity = Vector3.new(root.Velocity.X, -10, root.Velocity.Z)
        end
    end
end

-- ==================== NO JUMP COOLDOWN ====================

local function doNoJumpCD()
    if not settings.noJumpCooldown or not LocalPlayer.Character then return end
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        if humanoid.FloorMaterial then
            humanoid.Jump = true
        end
    end
end

-- ==================== INFINITE JUMP ====================

local function doInfiniteJump()
    if not settings.infiniteJump or not LocalPlayer.Character then return end
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
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

-- ==================== SPIN BOT ====================

local spinAngle = 0
local function doSpin()
    if not settings.spinBot or not LocalPlayer.Character then return end
    local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    spinAngle = spinAngle + settings.spinSpeed
    root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, math.rad(spinAngle), 0)
end

-- ==================== RENDER ФУНКЦИИ ====================

local hat = nil
local trailParts = {}

local function updateRender()
    -- Китайская шляпа
    if settings.chineseHat and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") then
        if not hat then
            hat = Instance.new("Part")
            hat.Name = "ChineseHat"
            hat.Size = Vector3.new(3, 0.5, 3)
            hat.Shape = Enum.PartType.Cylinder
            hat.BrickColor = BrickColor.Red()
            hat.Material = Enum.Material.Neon
            hat.CanCollide = false
            hat.Anchored = false
            hat.Parent = LocalPlayer.Character
            
            local weld = Instance.new("Weld")
            weld.Part0 = LocalPlayer.Character.Head
            weld.Part1 = hat
            weld.C0 = CFrame.new(0, 0.5, 0)
            weld.Parent = hat
        end
    elseif hat then
        hat:Destroy()
        hat = nil
    end
    
    -- Jump Trail
    if settings.jumpTrail and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid and humanoid.Jump and not humanoid.FloorMaterial then
            local part = Instance.new("Part")
            part.Size = Vector3.new(1, 1, 1)
            part.Shape = Enum.PartType.Ball
            part.BrickColor = BrickColor.Red()
            part.Material = Enum.Material.Neon
            part.CanCollide = false
            part.Anchored = true
            part.Position = LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(0, 2, 0)
            part.Parent = workspace
            
            table.insert(trailParts, part)
            
            if #trailParts > 10 then
                trailParts[1]:Destroy()
                table.remove(trailParts, 1)
            end
        end
    end
end

-- ==================== ГЛАВНЫЙ ЦИКЛ ====================

RunService.Heartbeat:Connect(function()
    doSpeed()
    doGodMode()
    doNoFall()
    doNoJumpCD()
    doInfiniteJump()
    doNoClip()
    doSpin()
    updateRender()
end)

-- ==================== ОТКРЫТИЕ МЕНЮ ====================

menuButton.MouseButton1Click:Connect(function()
    menu.Visible = not menu.Visible
end)

-- ==================== ИНИЦИАЛИЗАЦИЯ ====================

task.wait(2)

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        createESP(player)
    end
end

Players.PlayerAdded:Connect(function(player)
    createESP(player)
end)

Players.PlayerRemoving:Connect(removeESP)

StarterGui:SetCore("SendNotification", {
    Title = "rusticlient v12.0",
    Text = "Красивое меню загружено!",
    Duration = 3
})

print("✅ rusticlient v12.0 загружен!")
print("🎨 Новая аватарка: 90064663091843")
