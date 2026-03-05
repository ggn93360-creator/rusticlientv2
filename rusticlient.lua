-- rusticlientv2 - Mobile Optimized Version
-- Автор: SWILL / rusticlientv2

repeat task.wait() until game:IsLoaded()
if shared.rusticlientv2 then shared.rusticlientv2:Uninject() end

-- ==================== ОПРЕДЕЛЕНИЕ ИНЖЕКТОРА ====================

local executorInfo = {identifyexecutor and identifyexecutor() or 'Unknown'}
local executorName = executorInfo[1] or 'Unknown'
local executorVersion = executorInfo[2] or 'Unknown'

-- Определение устройства
local isMobile = UserInputService.TouchEnabled
local isPhone = isMobile and (UserInputService.MaximumTouchCount >= 3)

-- Обходы для разных инжекторов
if executorName == 'Argon' or executorName == 'Wave' then
    getgenv().setthreadidentity = nil
    getgenv().getexecutorname = function() return 'Unknown' end
end

-- ==================== ГЛОБАЛЬНЫЕ ФУНКЦИИ ====================

local rusticlientv2
local loadstring = function(...)
    local res, err = loadstring(...)
    if err and rusticlientv2 then
        rusticlientv2:CreateNotification('rusticlientv2', 'Failed to load : '..err, 30, 'alert')
    end
    return res
end

local queue_on_teleport = queue_on_teleport or function() end
local isfile = isfile or function(file)
    local suc, res = pcall(function()
        return readfile(file)
    end)
    return suc and res ~= nil and res ~= ''
end

local cloneref = cloneref or function(obj)
    return obj
end

local playersService = cloneref(game:GetService('Players'))
local runService = cloneref(game:GetService('RunService'))
local userInputService = cloneref(game:GetService('UserInputService'))
local lighting = cloneref(game:GetService('Lighting'))
local workspace = cloneref(game:GetService('Workspace'))
local coreGui = cloneref(game:GetService('CoreGui'))
local tweenService = cloneref(game:GetService('TweenService'))

-- ==================== GUI ====================

for _, v in ipairs(coreGui:GetChildren()) do
    if v.Name == 'rusticlientv2' then
        v:Destroy()
    end
end

local gui = Instance.new('ScreenGui')
gui.Name = 'rusticlientv2'
gui.ResetOnSpawn = false
gui.Parent = coreGui

-- ==================== КНОПКА С АВАТАРКОЙ (ДЛЯ ТЕЛЕФОНА) ====================

local menuButton = Instance.new('ImageButton')
menuButton.Size = UDim2.new(0, 70, 0, 70)
menuButton.Position = UDim2.new(0, 15, 0.5, -35)
menuButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
menuButton.BackgroundTransparency = 0
menuButton.Image = 'rbxassetid://90064663091843'
menuButton.Visible = isMobile
menuButton.Parent = gui

local menuButtonCorner = Instance.new('UICorner')
menuButtonCorner.CornerRadius = UDim.new(1, 0)
menuButtonCorner.Parent = menuButton

-- ==================== КРУЖОК ДЛЯ ТЕЛЕФОНА ====================

local mobileCircle = Instance.new('Frame')
mobileCircle.Size = UDim2.new(0, 100, 0, 100)
mobileCircle.Position = UDim2.new(0.5, -50, 0.5, -50)
mobileCircle.BackgroundTransparency = 1
mobileCircle.BorderColor3 = Color3.fromRGB(255, 50, 50)
mobileCircle.BorderSizePixel = 3
mobileCircle.Visible = isMobile
mobileCircle.Parent = gui

local mobileCircleCorner = Instance.new('UICorner')
mobileCircleCorner.CornerRadius = UDim.new(1, 0)
mobileCircleCorner.Parent = mobileCircle

local mobileDot = Instance.new('Frame')
mobileDot.Size = UDim2.new(0, 10, 0, 10)
mobileDot.Position = UDim2.new(0.5, -5, 0.5, -5)
mobileDot.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
mobileDot.BorderSizePixel = 0
mobileDot.Parent = mobileCircle

local mobileDotCorner = Instance.new('UICorner')
mobileDotCorner.CornerRadius = UDim.new(1, 0)
mobileDotCorner.Parent = mobileDot

-- ==================== МЕНЮ ====================

local menu = Instance.new('Frame')
menu.Size = isMobile and UDim2.new(0, 350, 0, 500) or UDim2.new(0, 600, 0, 500)
menu.Position = isMobile and UDim2.new(0.5, -175, 0.5, -250) or UDim2.new(0.5, -300, 0.5, -250)
menu.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
menu.BackgroundTransparency = 0.1
menu.Visible = false
menu.Active = true
menu.Draggable = true
menu.Parent = gui

local menuCorner = Instance.new('UICorner')
menuCorner.CornerRadius = UDim.new(0, 15)
menuCorner.Parent = menu

local title = Instance.new('TextLabel')
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundTransparency = 1
title.Text = 'rusticlientv2'
title.TextColor3 = Color3.fromRGB(255, 100, 100)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = menu

-- ==================== ВКЛАДКИ ====================

local tabFrame = Instance.new('Frame')
tabFrame.Size = UDim2.new(1, -20, 0, 40)
tabFrame.Position = UDim2.new(0, 10, 0, 50)
tabFrame.BackgroundTransparency = 1
tabFrame.Parent = menu

local tabs = isMobile and {'COMBAT', 'MOVE', 'RENDER', 'PLAYER'} or {'COMBAT', 'MOVEMENT', 'RENDER', 'PLAYER', 'SPIN', 'BYPASS'}
local tabButtons = {}
local tabContents = {}

for i, tabName in ipairs(tabs) do
    local btn = Instance.new('TextButton')
    btn.Size = UDim2.new(1/#tabs, -4, 1, -4)
    btn.Position = UDim2.new((i-1)/#tabs, 2, 0, 2)
    btn.BackgroundColor3 = i == 1 and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(40, 40, 50)
    btn.Text = tabName
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.Parent = tabFrame
    
    local btnCorner = Instance.new('UICorner')
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    tabButtons[tabName] = btn
end

local contentFrame = Instance.new('Frame')
contentFrame.Size = UDim2.new(1, -20, 1, -100)
contentFrame.Position = UDim2.new(0, 10, 0, 95)
contentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
contentFrame.Parent = menu

local contentCorner = Instance.new('UICorner')
contentCorner.CornerRadius = UDim.new(0, 10)
contentCorner.Parent = contentFrame

for _, tabName in ipairs(tabs) do
    local scroller = Instance.new('ScrollingFrame')
    scroller.Name = tabName
    scroller.Size = UDim2.new(1, -10, 1, -10)
    scroller.Position = UDim2.new(0, 5, 0, 5)
    scroller.BackgroundTransparency = 1
    scroller.BorderSizePixel = 0
    scroller.ScrollBarThickness = isMobile and 8 or 6
    scroller.ScrollBarImageColor3 = Color3.fromRGB(255, 50, 50)
    scroller.CanvasSize = UDim2.new(0, 0, 0, 400)
    scroller.Visible = (tabName == 'COMBAT')
    scroller.Parent = contentFrame
    tabContents[tabName] = scroller
end

-- ==================== НАСТРОЙКИ ====================

local Settings = {
    Combat = {
        Killaura = {Enabled = false, Range = 18, TargetPart = 'Head', ThroughWalls = false, Silent = true},
        AimAssist = {Enabled = false, Strength = 0.5, FOV = 90, TargetPart = 'Head'},
        AutoClicker = {Enabled = false, CPS = 12},
        Criticals = {Enabled = false, Chance = 100}
    },
    Movement = {
        Speed = {Enabled = false, Speed = 32},
        InfiniteJump = {Enabled = false},
        Bhop = {Enabled = false, Speed = 25},
        Sprint = {Enabled = false, Always = true},
        WallHop = {Enabled = false, Delay = 0.1},
        Phase = {Enabled = false, Distance = 5},
        Blink = {Enabled = false, Time = 3}
    },
    Render = {
        ESP = {Enabled = false, Box = true, Name = true, Health = true, Distance = true, Wallhack = true},
        Tracers = {Enabled = false, Color = Color3.new(1, 1, 1)},
        Chams = {Enabled = false, Color = Color3.new(1, 0, 0)},
        NameTags = {Enabled = false, Health = true, Distance = true},
        FullBright = {Enabled = false},
        Crosshair = {Enabled = false, Size = 5}
    },
    Player = {
        GodMode = {Enabled = false},
        AutoRespawn = {Enabled = false},
        NoRotate = {Enabled = false},
        AntiHunger = {Enabled = false},
        Freecam = {Enabled = false, Speed = 10}
    },
    Spin = {
        SpinBot = {Enabled = false, Speed = 10, Direction = 'Right'}
    }
}

-- ==================== ФУНКЦИЯ СОЗДАНИЯ ПЕРЕКЛЮЧАТЕЛЯ ====================

local function createToggle(parent, name, yPos, category, setting)
    local bg = Instance.new('Frame')
    bg.Size = UDim2.new(0.9, 0, 0, 35)
    bg.Position = UDim2.new(0.05, 0, 0, yPos)
    bg.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    bg.Parent = parent
    
    local bgCorner = Instance.new('UICorner')
    bgCorner.CornerRadius = UDim.new(0, 8)
    bgCorner.Parent = bg
    
    local label = Instance.new('TextLabel')
    label.Size = UDim2.new(0.6, -5, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextScaled = true
    label.Font = Enum.Font.SourceSans
    label.Parent = bg
    
    local toggle = Instance.new('TextButton')
    toggle.Size = UDim2.new(0, 50, 0, 25)
    toggle.Position = UDim2.new(1, -60, 0.5, -12.5)
    toggle.BackgroundColor3 = Settings[category][setting].Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    toggle.Text = Settings[category][setting].Enabled and 'ON' or 'OFF'
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.TextScaled = true
    toggle.Font = Enum.Font.GothamBold
    toggle.Parent = bg
    
    local toggleCorner = Instance.new('UICorner')
    toggleCorner.CornerRadius = UDim.new(0, 5)
    toggleCorner.Parent = toggle
    
    toggle.MouseButton1Click:Connect(function()
        Settings[category][setting].Enabled = not Settings[category][setting].Enabled
        toggle.BackgroundColor3 = Settings[category][setting].Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        toggle.Text = Settings[category][setting].Enabled and 'ON' or 'OFF'
    end)
    
    return bg
end

local function createSlider(parent, name, yPos, category, setting, min, max)
    local bg = Instance.new('Frame')
    bg.Size = UDim2.new(0.9, 0, 0, 45)
    bg.Position = UDim2.new(0.05, 0, 0, yPos)
    bg.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    bg.Parent = parent
    
    local bgCorner = Instance.new('UICorner')
    bgCorner.CornerRadius = UDim.new(0, 8)
    bgCorner.Parent = bg
    
    local label = Instance.new('TextLabel')
    label.Size = UDim2.new(0.5, -5, 0.4, 0)
    label.Position = UDim2.new(0, 10, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextScaled = true
    label.Font = Enum.Font.SourceSans
    label.Parent = bg
    
    local value = Instance.new('TextLabel')
    value.Size = UDim2.new(0, 40, 0.4, 0)
    value.Position = UDim2.new(1, -50, 0, 5)
    value.BackgroundTransparency = 1
    value.Text = tostring(Settings[category][setting])
    value.TextColor3 = Color3.fromRGB(0, 255, 0)
    value.TextScaled = true
    value.Font = Enum.Font.GothamBold
    value.Parent = bg
    
    local up = Instance.new('TextButton')
    up.Size = UDim2.new(0, 25, 0, 20)
    up.Position = UDim2.new(1, -85, 0, 5)
    up.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    up.Text = '+'
    up.TextColor3 = Color3.fromRGB(255, 255, 255)
    up.TextScaled = true
    up.Font = Enum.Font.GothamBold
    up.Parent = bg
    
    local down = Instance.new('TextButton')
    down.Size = UDim2.new(0, 25, 0, 20)
    down.Position = UDim2.new(1, -85, 0, 25)
    down.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    down.Text = '-'
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
local combatScroller = tabContents['COMBAT']
local y = 5
createToggle(combatScroller, 'Killaura', y, 'Combat', 'Killaura'); y = y + 40
createSlider(combatScroller, 'Range', y, 'Combat', 'Killaura', 10, 30); y = y + 50
createToggle(combatScroller, 'Aim Assist', y, 'Combat', 'AimAssist'); y = y + 40
createSlider(combatScroller, 'FOV', y, 'Combat', 'AimAssist', 30, 180); y = y + 50
createToggle(combatScroller, 'Auto Clicker', y, 'Combat', 'AutoClicker'); y = y + 40
createSlider(combatScroller, 'CPS', y, 'Combat', 'AutoClicker', 5, 20); y = y + 50
createToggle(combatScroller, 'Criticals', y, 'Combat', 'Criticals'); y = y + 40
combatScroller.CanvasSize = UDim2.new(0, 0, 0, y)

-- MOVEMENT вкладка
local moveScroller = tabContents[isMobile and 'MOVE' or 'MOVEMENT']
y = 5
createToggle(moveScroller, 'Speed', y, 'Movement', 'Speed'); y = y + 40
createSlider(moveScroller, 'Speed Amount', y, 'Movement', 'Speed', 16, 100); y = y + 50
createToggle(moveScroller, 'Infinite Jump', y, 'Movement', 'InfiniteJump'); y = y + 40
createToggle(moveScroller, 'Bhop', y, 'Movement', 'Bhop'); y = y + 40
createSlider(moveScroller, 'Bhop Speed', y, 'Movement', 'Bhop', 16, 50); y = y + 50
createToggle(moveScroller, 'Wall Hop', y, 'Movement', 'WallHop'); y = y + 40
createToggle(moveScroller, 'Phase', y, 'Movement', 'Phase'); y = y + 40
createToggle(moveScroller, 'Blink', y, 'Movement', 'Blink'); y = y + 40
moveScroller.CanvasSize = UDim2.new(0, 0, 0, y)

-- RENDER вкладка
local renderScroller = tabContents['RENDER']
y = 5
createToggle(renderScroller, 'ESP', y, 'Render', 'ESP'); y = y + 40
createToggle(renderScroller, 'Tracers', y, 'Render', 'Tracers'); y = y + 40
createToggle(renderScroller, 'Chams', y, 'Render', 'Chams'); y = y + 40
createToggle(renderScroller, 'Name Tags', y, 'Render', 'NameTags'); y = y + 40
createToggle(renderScroller, 'Full Bright', y, 'Render', 'FullBright'); y = y + 40
createToggle(renderScroller, 'Crosshair', y, 'Render', 'Crosshair'); y = y + 40
renderScroller.CanvasSize = UDim2.new(0, 0, 0, y)

-- PLAYER вкладка
local playerScroller = tabContents['PLAYER']
y = 5
createToggle(playerScroller, 'God Mode', y, 'Player', 'GodMode'); y = y + 40
createToggle(playerScroller, 'Auto Respawn', y, 'Player', 'AutoRespawn'); y = y + 40
createToggle(playerScroller, 'No Rotate', y, 'Player', 'NoRotate'); y = y + 40
createToggle(playerScroller, 'Anti Hunger', y, 'Player', 'AntiHunger'); y = y + 40
createToggle(playerScroller, 'Freecam', y, 'Player', 'Freecam'); y = y + 40
playerScroller.CanvasSize = UDim2.new(0, 0, 0, y)

if not isMobile then
    -- SPIN вкладка (только для ПК)
    local spinScroller = tabContents['SPIN']
    y = 5
    createToggle(spinScroller, 'Spin Bot', y, 'Spin', 'SpinBot'); y = y + 40
    createSlider(spinScroller, 'Spin Speed', y, 'Spin', 'SpinBot', 1, 30); y = y + 50
    spinScroller.CanvasSize = UDim2.new(0, 0, 0, y)
    
    -- BYPASS вкладка (только для ПК)
    local bypassScroller = tabContents['BYPASS']
    y = 5
    createToggle(bypassScroller, 'Timer', y, 'Bypass', 'Timer'); y = y + 40
    createSlider(bypassScroller, 'Timer Speed', y, 'Bypass', 'Timer', 0.5, 5); y = y + 50
    bypassScroller.CanvasSize = UDim2.new(0, 0, 0, y)
end

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

if isMobile then
    menuButton.MouseButton1Click:Connect(function()
        menu.Visible = not menu.Visible
    end)
else
    userInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == Enum.KeyCode.RightShift then
            menu.Visible = not menu.Visible
        end
        if input.KeyCode == Enum.KeyCode.RightShift then
            mobileCircle.Visible = not mobileCircle.Visible
        end
    end)
end

-- ==================== INFINITE JUMP ====================

local function doInfiniteJump()
    if not Settings.Movement.InfiniteJump.Enabled then return end
    local player = playersService.LocalPlayer
    if not player or not player.Character then return end
    
    local humanoid = player.Character:FindFirstChild('Humanoid')
    if not humanoid then return end
    
    if userInputService:IsKeyDown(Enum.KeyCode.Space) then
        humanoid.Jump = true
    end
end

-- ==================== SPEED HACK ====================

local function doSpeed()
    if not Settings.Movement.Speed.Enabled then return end
    local player = playersService.LocalPlayer
    if not player or not player.Character then return end
    
    local root = player.Character:FindFirstChild('HumanoidRootPart')
    local humanoid = player.Character:FindFirstChild('Humanoid')
    
    if not root or not humanoid then return end
    
    if humanoid.MoveDirection.Magnitude > 0 then
        root.Velocity = root.Velocity + humanoid.MoveDirection * (Settings.Movement.Speed.Speed - 16)
    end
end

-- ==================== BHOP ====================

local function doBhop()
    if not Settings.Movement.Bhop.Enabled then return end
    local player = playersService.LocalPlayer
    if not player or not player.Character then return end
    
    local humanoid = player.Character:FindFirstChild('Humanoid')
    local root = player.Character:FindFirstChild('HumanoidRootPart')
    
    if not humanoid or not root then return end
    
    if humanoid.MoveDirection.Magnitude > 0 and humanoid.FloorMaterial then
        root.Velocity = root.Velocity + humanoid.MoveDirection * (Settings.Movement.Bhop.Speed - 16)
        task.wait(0.05)
        humanoid.Jump = true
    end
end

-- ==================== WALL HOP ====================

local function doWallHop()
    if not Settings.Movement.WallHop.Enabled then return end
    local player = playersService.LocalPlayer
    if not player or not player.Character then return end
    
    local humanoid = player.Character:FindFirstChild('Humanoid')
    local root = player.Character:FindFirstChild('HumanoidRootPart')
    
    if not humanoid or not root then return end
    
    if humanoid.MoveDirection.Magnitude > 0 then
        root.Velocity = root.Velocity + humanoid.MoveDirection * 20
        task.wait(Settings.Movement.WallHop.Delay)
    end
end

-- ==================== PHASE ====================

local function doPhase()
    if not Settings.Movement.Phase.Enabled then return end
    local player = playersService.LocalPlayer
    if not player or not player.Character then return end
    
    local root = player.Character:FindFirstChild('HumanoidRootPart')
    if not root then return end
    
    root.CFrame = root.CFrame + workspace.CurrentCamera.CFrame.LookVector * Settings.Movement.Phase.Distance
end

-- ==================== BLINK ====================

local blinkPositions = {}
local blinkTime = 0
local function doBlink()
    if not Settings.Movement.Blink.Enabled then return end
    local player = playersService.LocalPlayer
    if not player or not player.Character then return end
    
    local root = player.Character:FindFirstChild('HumanoidRootPart')
    if not root then return end
    
    blinkTime = blinkTime + 0.1
    if blinkTime >= Settings.Movement.Blink.Time then
        if #blinkPositions > 0 then
            root.CFrame = blinkPositions[1]
            blinkPositions = {}
        end
        blinkTime = 0
    else
        table.insert(blinkPositions, root.CFrame)
    end
end

-- ==================== SPIN BOT (ТОЛЬКО ПК) ====================

local spinAngle = 0
local function doSpin()
    if not Settings.Spin or not Settings.Spin.SpinBot.Enabled then return end
    local player = playersService.LocalPlayer
    if not player or not player.Character then return end
    
    local root = player.Character:FindFirstChild('HumanoidRootPart')
    if not root then return end
    
    spinAngle = spinAngle + Settings.Spin.SpinBot.Speed
    root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, math.rad(spinAngle), 0)
end

-- ==================== ESP ====================

local espObjects = {}

local function createESP(player)
    if espObjects[player] then return end
    if player == playersService.LocalPlayer then return end
    
    local function onCharacterAdded(char)
        local head = char:WaitForChild('Head')
        if not head then return end
        
        local billboard = Instance.new('BillboardGui')
        billboard.Name = 'rusticlientv2_ESP_'..player.Name
        billboard.Size = UDim2.new(0, 150, 0, 60)
        billboard.StudsOffset = Vector3.new(0, 2.5, 0)
        billboard.AlwaysOnTop = Settings.Render.ESP.Wallhack
        billboard.Parent = head
        
        local nameLabel = Instance.new('TextLabel')
        nameLabel.Size = UDim2.new(1, 0, 0.4, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.TextColor3 = Color3.new(1, 1, 1)
        nameLabel.TextScaled = true
        nameLabel.Text = player.Name
        nameLabel.Parent = billboard
        
        local distanceLabel = Instance.new('TextLabel')
        distanceLabel.Size = UDim2.new(1, 0, 0.3, 0)
        distanceLabel.Position = UDim2.new(0, 0, 0.4, 0)
        distanceLabel.BackgroundTransparency = 1
        distanceLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
        distanceLabel.TextScaled = true
        distanceLabel.Parent = billboard
        
        local healthBar = Instance.new('Frame')
        healthBar.Size = UDim2.new(1, 0, 0.3, 0)
        healthBar.Position = UDim2.new(0, 0, 0.7, 0)
        healthBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        healthBar.Parent = billboard
        
        local healthFill = Instance.new('Frame')
        healthFill.Size = UDim2.new(1, 0, 1, 0)
        healthFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        healthFill.Parent = healthBar
        
        espObjects[player] = {
            billboard = billboard,
            nameLabel = nameLabel,
            distanceLabel = distanceLabel,
            healthBar = healthBar,
            healthFill = healthFill
        }
    end
    
    if player.Character then
        onCharacterAdded(player.Character)
    end
    
    player.CharacterAdded:Connect(onCharacterAdded)
end

-- ==================== ОБНОВЛЕНИЕ ESP ====================

runService.RenderStepped:Connect(function()
    if not Settings.Render.ESP.Enabled then
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
            
            local humanoid = player.Character:FindFirstChild('Humanoid')
            local root = player.Character:FindFirstChild('HumanoidRootPart')
            local localPlayer = playersService.LocalPlayer
            
            if humanoid and root and localPlayer and localPlayer.Character then
                local localRoot = localPlayer.Character:FindFirstChild('HumanoidRootPart')
                if localRoot then
                    local dist = (root.Position - localRoot.Position).Magnitude
                    obj.distanceLabel.Text = math.floor(dist)..'m'
                end
                
                local health = humanoid.Health / humanoid.MaxHealth
                obj.healthFill.Size = UDim2.new(health, 0, 1, 0)
                
                if health > 0.6 then
                    obj.healthFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                elseif health > 0.3 then
                    obj.healthFill.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
                else
                    obj.healthFill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                end
            end
        end
    end
end)

-- ==================== GOD MODE ====================

local function doGodMode()
    if not Settings.Player.GodMode.Enabled then return end
    local player = playersService.LocalPlayer
    if not player or not player.Character then return end
    
    local humanoid = player.Character:FindFirstChild('Humanoid')
    if humanoid and humanoid.Health < humanoid.MaxHealth then
        humanoid.Health = humanoid.MaxHealth
    end
end

-- ==================== FULL BRIGHT ====================

local function doFullBright()
    if not Settings.Render.FullBright.Enabled then return end
    lighting.Brightness = 3
    lighting.GlobalShadows = false
    lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
else
    lighting.Brightness = 1
    lighting.GlobalShadows = true
    lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
end

-- ==================== ГЛАВНЫЙ ЦИКЛ ====================

runService.Heartbeat:Connect(function()
    doSpeed()
    doInfiniteJump()
    doBhop()
    doWallHop()
    doPhase()
    doBlink()
    if not isMobile then doSpin() end
    doGodMode()
    doFullBright()
end)

-- ==================== ИНИЦИАЛИЗАЦИЯ ====================

task.wait(1)

for _, player in ipairs(playersService:GetPlayers()) do
    if player ~= playersService.LocalPlayer then
        createESP(player)
    end
end

playersService.PlayerAdded:Connect(createESP)

print('✅ rusticlientv2 загружен!')
print('📌 Телефон: кружок в центре | ПК: Right Shift')
print('🎯 Infinite Jump работает!')
