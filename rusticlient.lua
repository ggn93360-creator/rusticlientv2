-- rusticlient v13.0 - Полная версия со всеми фиксами
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

-- ==================== ОПРЕДЕЛЕНИЕ УСТРОЙСТВА ====================

local isMobile = UserInputService.TouchEnabled
local injectorType = "UNKNOWN"

if identifyexecutor then
    injectorType = identifyexecutor()
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

-- ==================== КРУГЛАЯ КНОПКА С КАРТИНКОЙ ====================

local menuButton = Instance.new("ImageButton")
menuButton.Size = UDim2.new(0, 70, 0, 70)
menuButton.Position = UDim2.new(0, 15, 0.5, -35)
menuButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
menuButton.BackgroundTransparency = 0
menuButton.Image = "rbxassetid://90064663091843"
menuButton.Visible = true
menuButton.Parent = gui

-- Делаем кнопку идеально круглой
local menuButtonCorner = Instance.new("UICorner")
menuButtonCorner.CornerRadius = UDim.new(1, 0)
menuButtonCorner.Parent = menuButton

-- Добавляем обводку для красоты
local menuButtonStroke = Instance.new("UIStroke")
menuButtonStroke.Color = Color3.fromRGB(255, 50, 50)
menuButtonStroke.Thickness = 2
menuButtonStroke.Parent = menuButton

-- ==================== ПРОЗРАЧНОЕ МЕНЮ ====================

local menu = Instance.new("Frame")
menu.Size = UDim2.new(0, 500, 0, 700)
menu.Position = UDim2.new(0.5, -250, 0.5, -350)
menu.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
menu.BackgroundTransparency = 0.15  -- Прозрачность
menu.Visible = false
menu.Active = true
menu.Draggable = true
menu.Parent = gui

local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0, 20)
menuCorner.Parent = menu

-- Стеклянный эффект
local menuGlass = Instance.new("Frame")
menuGlass.Size = UDim2.new(1, 0, 1, 0)
menuGlass.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
menuGlass.BackgroundTransparency = 0.95
menuGlass.BorderSizePixel = 0
menuGlass.Parent = menu

-- Заголовок
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundTransparency = 1
title.Text = "RUSTICLIENT v13.0"
title.TextColor3 = Color3.fromRGB(255, 100, 100)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = menu

-- Инфо
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, -20, 0, 25)
infoLabel.Position = UDim2.new(0, 10, 0, 50)
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

-- ==================== СНЕЖИНКИ В МЕНЮ (ТОЛЬКО ДЛЯ ПК) ====================

if not isMobile then
    local snowEmitter = Instance.new("Frame")
    snowEmitter.Size = UDim2.new(1, 0, 1, 0)
    snowEmitter.BackgroundTransparency = 1
    snowEmitter.Parent = menu
    
    local snowflakes = {}
    local snowCount = 15
    
    for i = 1, snowCount do
        local snow = Instance.new("TextLabel")
        snow.Size = UDim2.new(0, 15, 0, 15)
        snow.Position = UDim2.new(math.random(), 0, math.random(), 0)
        snow.BackgroundTransparency = 1
        snow.Text = "❄️"
        snow.TextColor3 = Color3.fromRGB(255, 255, 255)
        snow.TextScaled = true
        snow.Parent = snowEmitter
        table.insert(snowflakes, {obj = snow, speed = math.random(20, 50) / 100})
    end
    
    spawn(function()
        while menu.Parent do
            wait(0.05)
            for _, flake in ipairs(snowflakes) do
                local pos = flake.obj.Position
                local y = pos.Y.Scale + flake.speed / 1000
                if y > 1 then
                    y = 0
                    flake.obj.Position = UDim2.new(math.random(), 0, 0, 0)
                else
                    flake.obj.Position = UDim2.new(pos.X.Scale, 0, y, 0)
                end
            end
        end
    end)
end

-- ==================== ВКЛАДКИ ====================

local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, -20, 0, 40)
tabFrame.Position = UDim2.new(0, 10, 0, 80)
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
contentFrame.Size = UDim2.new(1, -20, 1, -140)
contentFrame.Position = UDim2.new(0, 10, 0, 125)
contentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
contentFrame.BackgroundTransparency = 0.2
contentFrame.Parent = menu

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 10)
contentCorner.Parent = contentFrame

-- СКОЛЛЕРЫ
for _, tabName in ipairs(tabs) do
    local scroller = Instance.new("ScrollingFrame")
    scroller.Name = tabName .. "Scroller"
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
    noRecoil = false,
    noSpread = false,
    
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
    removeEffects = false,
    removeBlur = false,
    removeTransparency = false,
    potatoGraphics = false,
    fullBright = false,
    chineseHat = false,
    jumpTrail = false,
    
    -- Spin
    spinBot = false,
    spinSpeed = 10
}

-- ==================== ФУНКЦИИ СОЗДАНИЯ ЭЛЕМЕНТОВ ====================

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
        
        -- Применяем изменения рендера
        if setting:find("remove") or setting == "potatoGraphics" or setting == "fullBright" then
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
createToggle(aimScroller, "No Recoil", y, "noRecoil"); y = y + 40
createToggle(aimScroller, "No Spread", y, "noSpread"); y = y + 40
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
createToggle(renderScroller, "Remove Effects", y, "removeEffects"); y = y + 40
createToggle(renderScroller, "Remove Blur", y, "removeBlur"); y = y + 40
createToggle(renderScroller, "Remove Transparency", y, "removeTransparency"); y = y + 40
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
                if settings.health then table.insert(textParts, "❤️"..hp) end
                
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

-- ==================== КИТАЙСКАЯ ШЛЯПА (ИСПРАВЛЕННАЯ) ====================

local hat = nil
local function updateChineseHat()
    if settings.chineseHat and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") then
        if not hat then
            -- Создаём шляпу как аксессуар
            local accessory = Instance.new("Accessory")
            accessory.Name = "ChineseHat"
            
            local handle = Instance.new("Part")
            handle.Name = "Handle"
            handle.Size = Vector3.new(2, 0.5, 2)
            handle.Anchored = false
            handle.CanCollide = false
            handle.Material = Enum.Material.SmoothPlastic
            handle.Color = Color3.fromRGB(200, 100, 50)
            handle.Parent = accessory
            
            -- Создаём круглый купол (конус)
            local mesh = Instance.new("SpecialMesh")
            mesh.MeshType = Enum.MeshType.Cylinder
            mesh.Scale = Vector3.new(3, 1, 3)
            mesh.Parent = handle
            
            -- Добавляем помпон сверху
            local topPart = Instance.new("Part")
            topPart.Size = Vector3.new(0.5, 0.5, 0.5)
            topPart.Anchored = false
            topPart.CanCollide = false
            topPart.Material = Enum.Material.Neon
            topPart.Color = Color3.fromRGB(255, 0, 0)
            topPart.Parent = accessory
            
            -- Соединяем всё
            handle:BreakJoints()
            topPart:BreakJoints()
            
            local weld = Instance.new("Weld")
            weld.Part0 = handle
            weld.Part1 = topPart
            weld.C0 = CFrame.new(0, 0.5, 0)
            weld.Parent = handle
            
            -- Прикрепляем к голове
            accessory.Parent = LocalPlayer.Character
            LocalPlayer.Character:WaitForChild("Humanoid"):AddAccessory(accessory)
            
            hat = accessory
        end
    elseif hat then
        hat:Destroy()
        hat = nil
    end
end

-- ==================== ДЖАМП ТРЕЙЛ (С КРУГАМИ) ====================

local trailParts = {}
local function createJumpCircle()
    if not LocalPlayer.Character then return end
    local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    if not root or not humanoid then return end
    
    local circle = Instance.new("Part")
    circle.Size = Vector3.new(5, 0.1, 5)
    circle.Anchored = true
    circle.CanCollide = false
    circle.Material = Enum.Material.Neon
    circle.Color = Color3.fromRGB(0, 150, 255)
    circle.CFrame = CFrame.new(root.Position.X, root.Position.Y - humanoid.HipHeight, root.Position.Z)
    circle.Parent = Workspace
    
    table.insert(trailParts, circle)
    
    -- Анимация исчезновения
    spawn(function()
        local alpha = 0
        while alpha < 1 and circle.Parent do
            alpha = alpha + 0.03
            circle.Transparency = alpha
            wait(0.03)
        end
        if circle.Parent then
            circle:Destroy()
        end
        for i, v in ipairs(trailParts) do
            if v == circle then
                table.remove(trailParts, i)
                break
            end
        end
    end)
end

-- ==================== RENDER ФУНКЦИИ ====================

local function applyRenderSettings()
    -- Remove Grass
    if settings.removeGrass then
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("Terrain") then
                obj:Clear()
            end
        end
    end
    
    -- Remove Effects
    if settings.removeEffects then
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
                obj.Enabled = false
            end
        end
    end
    
    -- Remove Fog
    if settings.removeFog then
        Lighting.FogStart = 100000
        Lighting.FogEnd = 100000
    else
        Lighting.FogStart = 0
        Lighting.FogEnd = 80
        Lighting.FogColor = Color3.fromRGB(100, 100, 100)
    end
    
    -- Remove Blur
    if settings.removeBlur then
        for _, effect in pairs(Lighting:GetChildren()) do
            if effect:IsA("BlurEffect") then
                effect.Enabled = false
            end
        end
    end
    
    -- Remove Transparency
    if settings.removeTransparency then
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Transparency > 0 then
                obj.Transparency = 0
            end
        end
    end
    
    -- Potato Graphics
    if settings.potatoGraphics then
        Lighting.GlobalShadows = false
        Lighting.Ambient = Color3.new(0.8, 0.8, 0.8)
        Lighting.OutdoorAmbient = Color3.new(0.7, 0.7, 0.7)
        
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                obj.Material = Enum.Material.Plastic
                obj.Reflectance = 0
                obj.CastShadow = false
            end
        end
    else
        Lighting.GlobalShadows = true
    end
    
    -- Full Bright
    if settings.fullBright then
        Lighting.Brightness = 3
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    else
        Lighting.Brightness = 1
    end
end

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

-- ==================== NO RECOIL / NO SPREAD ====================

local function doNoRecoil()
    if not settings.noRecoil or not LocalPlayer.Character then return end
    -- Этот код нужно адаптировать под конкретную игру
    -- В общем случае для оружия:
    for _, tool in ipairs(LocalPlayer.Character:GetChildren()) do
        if tool:IsA("Tool") then
            -- Здесь можно отключать отдачу
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

-- ==================== ГЛАВНЫЙ ЦИКЛ ====================

RunService.Heartbeat:Connect(function()
    doSpeed()
    doGodMode()
    doNoFall()
    doNoJumpCD()
    doInfiniteJump()
    doNoClip()
    doNoRecoil()
    doSpin()
    updateChineseHat()
end)

-- ==================== ДЖАМП ТРЕЙЛ ТРИГГЕР ====================

local function onJump(active)
    if active and settings.jumpTrail then
        createJumpCircle()
    end
end

-- Ждём персонажа
LocalPlayer.CharacterAdded:Connect(function(char)
    local humanoid = char:WaitForChild("Humanoid")
    humanoid.Jumping:Connect(onJump)
end)

if LocalPlayer.Character then
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.Jumping:Connect(onJump)
    end
end

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

-- Применяем начальные настройки рендера
applyRenderSettings()

StarterGui:SetCore("SendNotification", {
    Title = "rusticlient v13.0",
    Text = "Полная версия с фиксами!",
    Duration = 3
})

print("✅ rusticlient v13.0 загружен!")
print("🎨 Китайская шляпа исправлена!")
print("❄️ Снежинки в меню (только ПК)")
