-- rusticlient - Улучшенный ESP
-- Автор: SWILL / rusticlient

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- ==================== GUI ====================

local gui = Instance.new("ScreenGui")
gui.Name = "rusticlient_esp"
gui.ResetOnSpawn = false
gui.Parent = CoreGui

-- ==================== ESP ====================

local espObjects = {}

local function createESP(player)
    if espObjects[player] then return end
    if player == LocalPlayer then return end
    if not player.Character then return end
    
    local head = player.Character:WaitForChild("Head")
    if not head then return end
    
    -- BillboardGui (как в твоем коде, но улучшенный)
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_"..player.Name
    billboard.Size = UDim2.new(0, 120, 0, 60)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Adornee = head
    billboard.Parent = gui
    
    -- Рамка вокруг игрока
    local box = Instance.new("Frame")
    box.Name = "Box"
    box.Size = UDim2.new(1, 0, 1, 0)
    box.BackgroundTransparency = 1
    box.BorderColor3 = Color3.fromRGB(255, 0, 0)
    box.BorderSizePixel = 2
    box.Parent = billboard
    
    -- Имя игрока (как в твоем коде, но с обводкой)
    local nameTag = Instance.new("TextLabel")
    nameTag.Name = "Name"
    nameTag.Size = UDim2.new(1, 0, 0, 25)
    nameTag.Position = UDim2.new(0, 0, 0, -25)
    nameTag.BackgroundTransparency = 0.5
    nameTag.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    nameTag.Text = player.Name
    nameTag.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameTag.TextStrokeTransparency = 0.3
    nameTag.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    nameTag.TextScaled = true
    nameTag.Font = Enum.Font.SourceSansBold
    nameTag.Parent = billboard
    
    -- Полоска здоровья
    local healthBarBg = Instance.new("Frame")
    healthBarBg.Name = "HealthBg"
    healthBarBg.Size = UDim2.new(1, 0, 0, 5)
    healthBarBg.Position = UDim2.new(0, 0, 1, 5)
    healthBarBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    healthBarBg.BorderSizePixel = 0
    healthBarBg.Parent = billboard
    
    local healthBar = Instance.new("Frame")
    healthBar.Name = "Health"
    healthBar.Size = UDim2.new(1, 0, 1, 0)
    healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    healthBar.BorderSizePixel = 0
    healthBar.Parent = healthBarBg
    
    -- Текст здоровья
    local healthText = Instance.new("TextLabel")
    healthText.Name = "HealthText"
    healthText.Size = UDim2.new(1, 0, 0, 15)
    healthText.Position = UDim2.new(0, 0, 1, 12)
    healthText.BackgroundTransparency = 0.5
    healthText.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    healthText.Text = "100/100 HP"
    healthText.TextColor3 = Color3.fromRGB(255, 255, 255)
    healthText.TextScaled = true
    healthText.Font = Enum.Font.SourceSans
    healthText.Parent = billboard
    
    -- Дистанция
    local distanceText = Instance.new("TextLabel")
    distanceText.Name = "Distance"
    distanceText.Size = UDim2.new(1, 0, 0, 15)
    distanceText.Position = UDim2.new(0, 0, 1, 30)
    distanceText.BackgroundTransparency = 0.5
    distanceText.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    distanceText.Text = "0m"
    distanceText.TextColor3 = Color3.fromRGB(255, 255, 255)
    distanceText.TextScaled = true
    distanceText.Font = Enum.Font.SourceSans
    distanceText.Parent = billboard
    
    -- Сохраняем объекты
    espObjects[player] = {
        billboard = billboard,
        box = box,
        nameTag = nameTag,
        healthBar = healthBar,
        healthBarBg = healthBarBg,
        healthText = healthText,
        distanceText = distanceText
    }
end

local function removeESP(player)
    if espObjects[player] and espObjects[player].billboard then
        espObjects[player].billboard:Destroy()
        espObjects[player] = nil
    end
end

-- Обновление ESP (здоровье, дистанция, цвет)
RunService.RenderStepped:Connect(function()
    for player, esp in pairs(espObjects) do
        if player and player.Character and player.Character:FindFirstChild("Humanoid") then
            local humanoid = player.Character.Humanoid
            local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
            
            if humanoid and humanoid.Health > 0 and rootPart then
                -- Обновляем здоровье
                local healthPercent = humanoid.Health / humanoid.MaxHealth
                esp.healthBar.Size = UDim2.new(healthPercent, 0, 1, 0)
                
                -- Цвет от здоровья (зеленый -> желтый -> красный)
                if healthPercent > 0.6 then
                    esp.healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                    esp.box.BorderColor3 = Color3.fromRGB(255, 0, 0)
                elseif healthPercent > 0.3 then
                    esp.healthBar.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
                    esp.box.BorderColor3 = Color3.fromRGB(255, 255, 0)
                else
                    esp.healthBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                    esp.box.BorderColor3 = Color3.fromRGB(255, 0, 0)
                end
                
                -- Текст здоровья
                esp.healthText.Text = math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth) .. " HP"
                
                -- Дистанция
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local myRoot = LocalPlayer.Character.HumanoidRootPart
                    local dist = (rootPart.Position - myRoot.Position).Magnitude
                    esp.distanceText.Text = math.floor(dist) .. "m"
                end
            else
                removeESP(player)
            end
        else
            removeESP(player)
        end
    end
end)

-- ==================== ОБРАБОТКА ИГРОКОВ ====================

-- Для уже существующих игроков
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        createESP(player)
    end
end

-- Для новых игроков
Players.PlayerAdded:Connect(function(player)
    if player == LocalPlayer then return end
    
    -- Когда персонаж появляется
    player.CharacterAdded:Connect(function(char)
        -- Ждем немного для загрузки
        task.wait(1)
        createESP(player)
    end)
    
    -- Если персонаж уже есть
    if player.Character then
        task.wait(1)
        createESP(player)
    end
end)

-- Когда игрок уходит
Players.PlayerRemoving:Connect(removeESP)

print("✅ rusticlient ESP загружен!")
print("📌 Показывает: имена, здоровье, дистанцию, цвет от HP")
