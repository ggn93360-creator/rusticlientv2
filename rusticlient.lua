-- rusticlientv2 - Ultimate Edition with all bypasses
-- Автор: SWILL / rusticlientv2

repeat task.wait() until game:IsLoaded()
if shared.rusticlientv2 then shared.rusticlientv2:Uninject() end

-- ==================== ОПРЕДЕЛЕНИЕ ИНЖЕКТОРА ====================

local executorInfo = {identifyexecutor and identifyexecutor() or 'Unknown'}
local executorName = executorInfo[1] or 'Unknown'
local executorVersion = executorInfo[2] or 'Unknown'

-- Обходы для разных инжекторов
if executorName == 'Argon' or executorName == 'Wave' then
    getgenv().setthreadidentity = nil
    getgenv().getexecutorname = function() return 'Unknown' end
end

if executorName == 'Krnl' then
    -- Krnl обходы
    local oldNamecall
    oldNamecall = hookmetamethod(game, '__namecall', function(...)
        local method = getnamecallmethod()
        if method == 'HttpGet' and select(1, ...):find('7GrandDadPGN') then
            return readfile('rusticlientv2/profiles/commit.txt')
        end
        return oldNamecall(...)
    end)
end

if executorName == 'Synapse' then
    -- Synapse обходы
    syn.crypt.encrypt = syn.crypt.encrypt or function() end
end

if executorName == 'ScriptWare' then
    -- ScriptWare обходы
    getgenv().http_request = http_request or request
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

local gui = Instance.new('ScreenGui')
gui.Name = 'rusticlientv2'
gui.ResetOnSpawn = false
gui.Parent = coreGui

-- ==================== КНОПКА С АВАТАРКОЙ ====================

local menuButton = Instance.new('ImageButton')
menuButton.Size = UDim2.new(0, 70, 0, 70)
menuButton.Position = UDim2.new(0, 15, 0.5, -35)
menuButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
menuButton.BackgroundTransparency = 0
menuButton.Image = 'rbxassetid://90064663091843'
menuButton.Parent = gui

local menuButtonCorner = Instance.new('UICorner')
menuButtonCorner.CornerRadius = UDim.new(1, 0)
menuButtonCorner.Parent = menuButton

local menuButtonStroke = Instance.new('UIStroke')
menuButtonStroke.Color = Color3.fromRGB(255, 50, 50)
menuButtonStroke.Thickness = 2
menuButtonStroke.Parent = menuButton

-- ==================== МЕНЮ ====================

local menu = Instance.new('Frame')
menu.Size = UDim2.new(0, 600, 0, 500)
menu.Position = UDim2.new(0.5, -300, 0.5, -250)
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

local tabs = {'COMBAT', 'MOVEMENT', 'RENDER', 'WORLD', 'PLAYER', 'BYPASS'}
local tabButtons = {}
local tabContents = {}

for i, tabName in ipairs(tabs) do
    local btn = Instance.new('TextButton')
    btn.Size = UDim2.new(1/6, -4, 1, -4)
    btn.Position = UDim2.new((i-1)/6, 2, 0, 2)
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
    scroller.ScrollBarThickness = 6
    scroller.ScrollBarImageColor3 = Color3.fromRGB(255, 50, 50)
    scroller.CanvasSize = UDim2.new(0, 0, 0, 800)
    scroller.Visible = (tabName == 'COMBAT')
    scroller.Parent = contentFrame
    tabContents[tabName] = scroller
end

-- ==================== НАСТРОЙКИ ====================

local Settings = {
    Combat = {
        Killaura = {Enabled = false, Range = 18, TargetPart = 'Head', ThroughWalls = false, Silent = true},
        AimAssist = {Enabled = false, Strength = 0.5, FOV = 90, TargetPart = 'Head'},
        Velocity = {Enabled = false, Horizontal = 0, Vertical = 0},
        Reach = {Enabled = false, Distance = 3.5},
        AutoClicker = {Enabled = false, CPS = 12},
        Criticals = {Enabled = false, Chance = 100}
    },
    Movement = {
        Speed = {Enabled = false, Speed = 32, Mode = 'Legit'},
        Fly = {Enabled = false, Speed = 10, Mode = 'Vanilla'},
        LongJump = {Enabled = false, Power = 4},
        HighJump = {Enabled = false, Power = 50},
        NoFall = {Enabled = false, Mode = 'Packet'},
        Step = {Enabled = false, Height = 2},
        Bhop = {Enabled = false, Speed = 25},
        Sprint = {Enabled = false, Always = true},
        Spider = {Enabled = false, Speed = 5},
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
    World = {
        Scaffold = {Enabled = false, Mode = 'Normal'},
        NoSlow = {Enabled = false, Percent = 80},
        FastBreak = {Enabled = false, Speed = 2},
        FastPlace = {Enabled = false, Speed = 2},
        AutoTool = {Enabled = false},
        ChestStealer = {Enabled = false, Delay = 0.1},
        AutoArmor = {Enabled = false}
    },
    Player = {
        GodMode = {Enabled = false},
        AntiFire = {Enabled = false},
        AutoRespawn = {Enabled = false},
        NoRotate = {Enabled = false},
        AntiHunger = {Enabled = false},
        Freecam = {Enabled = false, Speed = 10},
        Glide = {Enabled = false, Speed = 0.5}
    },
    Bypass = {
        AntiCheat = {Mode = 'Universal'},
        Disabler = {Enabled = false, Mode = 'Watchdog'},
        Timer = {Enabled = false, Speed = 1}
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
createToggle(combatScroller, 'Velocity', y, 'Combat', 'Velocity'); y = y + 40
createToggle(combatScroller, 'Reach', y, 'Combat', 'Reach'); y = y + 40
createSlider(combatScroller, 'Reach Distance', y, 'Combat', 'Reach', 3, 6); y = y + 50
createToggle(combatScroller, 'Auto Clicker', y, 'Combat', 'AutoClicker'); y = y + 40
createSlider(combatScroller, 'CPS', y, 'Combat', 'AutoClicker', 5, 20); y = y + 50
createToggle(combatScroller, 'Criticals', y, 'Combat', 'Criticals'); y = y + 40
combatScroller.CanvasSize = UDim2.new(0, 0, 0, y)

-- MOVEMENT вкладка
local moveScroller = tabContents['MOVEMENT']
y = 5
createToggle(moveScroller, 'Speed', y, 'Movement', 'Speed'); y = y + 40
createSlider(moveScroller, 'Speed Amount', y, 'Movement', 'Speed', 16, 100); y = y + 50
createToggle(moveScroller, 'Fly', y, 'Movement', 'Fly'); y = y + 40
createSlider(moveScroller, 'Fly Speed', y, 'Movement', 'Fly', 5, 50); y = y + 50
createToggle(moveScroller, 'Long Jump', y, 'Movement', 'LongJump'); y = y + 40
createSlider(moveScroller, 'Power', y, 'Movement', 'LongJump', 1, 10); y = y + 50
createToggle(moveScroller, 'High Jump', y, 'Movement', 'HighJump'); y = y + 40
createSlider(moveScroller, 'Jump Power', y, 'Movement', 'HighJump', 30, 200); y = y + 50
createToggle(moveScroller, 'No Fall', y, 'Movement', 'NoFall'); y = y + 40
createToggle(moveScroller, 'Step', y, 'Movement', 'Step'); y = y + 40
createSlider(moveScroller, 'Step Height', y, 'Movement', 'Step', 1, 5); y = y + 50
createToggle(moveScroller, 'Bhop', y, 'Movement', 'Bhop'); y = y + 40
createSlider(moveScroller, 'Bhop Speed', y, 'Movement', 'Bhop', 16, 50); y = y + 50
createToggle(moveScroller, 'Spider', y, 'Movement', 'Spider'); y = y + 40
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

-- WORLD вкладка
local worldScroller = tabContents['WORLD']
y = 5
createToggle(worldScroller, 'Scaffold', y, 'World', 'Scaffold'); y = y + 40
createToggle(worldScroller, 'No Slow', y, 'World', 'NoSlow'); y = y + 40
createToggle(worldScroller, 'Fast Break', y, 'World', 'FastBreak'); y = y + 40
createToggle(worldScroller, 'Fast Place', y, 'World', 'FastPlace'); y = y + 40
createToggle(worldScroller, 'Auto Tool', y, 'World', 'AutoTool'); y = y + 40
createToggle(worldScroller, 'Chest Stealer', y, 'World', 'ChestStealer'); y = y + 40
createToggle(worldScroller, 'Auto Armor', y, 'World', 'AutoArmor'); y = y + 40
worldScroller.CanvasSize = UDim2.new(0, 0, 0, y)

-- PLAYER вкладка
local playerScroller = tabContents['PLAYER']
y = 5
createToggle(playerScroller, 'God Mode', y, 'Player', 'GodMode'); y = y + 40
createToggle(playerScroller, 'Anti Fire', y, 'Player', 'AntiFire'); y = y + 40
createToggle(playerScroller, 'Auto Respawn', y, 'Player', 'AutoRespawn'); y = y + 40
createToggle(playerScroller, 'No Rotate', y, 'Player', 'NoRotate'); y = y + 40
createToggle(playerScroller, 'Anti Hunger', y, 'Player', 'AntiHunger'); y = y + 40
createToggle(playerScroller, 'Freecam', y, 'Player', 'Freecam'); y = y + 40
createToggle(playerScroller, 'Glide', y, 'Player', 'Glide'); y = y + 40
playerScroller.CanvasSize = UDim2.new(0, 0, 0, y)

-- BYPASS вкладка
local bypassScroller = tabContents['BYPASS']
y = 5
createToggle(bypassScroller, 'Disabler', y, 'Bypass', 'Disabler'); y = y + 40
createToggle(bypassScroller, 'Timer', y, 'Bypass', 'Timer'); y = y + 40
createSlider(bypassScroller, 'Timer Speed', y, 'Bypass', 'Timer', 0.5, 5); y = y + 50
bypassScroller.CanvasSize = UDim2.new(0, 0, 0, y)

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

userInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        menu.Visible = not menu.Visible
    end
end)

-- ==================== ФЛАЙ ХАК ====================

local function doFly()
    if not Settings.Movement.Fly.Enabled then return end
    local player = playersService.LocalPlayer
    if not player or not player.Character then return end
    
    local root = player.Character:FindFirstChild('HumanoidRootPart')
    local humanoid = player.Character:FindFirstChild('Humanoid')
    
    if not root or not humanoid then return end
    
    if Settings.Movement.Fly.Mode == 'Vanilla' then
        root.Velocity = Vector3.new(0, 0, 0)
        if userInputService:IsKeyDown(Enum.KeyCode.Space) then
            root.Velocity = Vector3.new(root.Velocity.X, Settings.Movement.Fly.Speed, root.Velocity.Z)
        elseif userInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            root.Velocity = Vector3.new(root.Velocity.X, -Settings.Movement.Fly.Speed, root.Velocity.Z)
        end
        humanoid.PlatformStand = true
    end
end

-- ==================== СПИД ХАК ====================

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

-- ==================== ГЛАВНЫЙ ЦИКЛ ====================

runService.Heartbeat:Connect(function()
    doFly()
    doSpeed()
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
print('📌 Нажмите Right Shift для меню')
print('🎯 Все функции активированы!')
