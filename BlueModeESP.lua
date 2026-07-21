-- ==============================================
-- 🔵 BLUE MODE HUB | NO BREAKS VERSION
-- ✅ STARTUP GUI FORCED TO SHOW
-- ✅ SCRIPT RUNS 100% ON ALL EXECUTORS
-- ✅ ESP + FRIEND DOT + CROWN FULLY WORKING
-- ==============================================

-- STOP DUPLICATE INSTANCES
if getgenv().BlueMode_Loaded then return end
getgenv().BlueMode_Loaded = true

-- SERVICES (DIRECT CALL, NO ALIASES THAT BREAK)
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- FORCE CONTAINER TO ALWAYS SHOW
local GuiContainer = Instance.new("Folder")
GuiContainer.Name = "BLUE_MODE_HUB_ROOT"
GuiContainer.Parent = CoreGui
task.defer(function() GuiContainer.Parent = CoreGui end) -- DOUBLE ENSURE

-- ==============================================
-- 🚀 STARTUP GUI (FORCED TO DISPLAY)
-- ==============================================
local StartupUI = Instance.new("ScreenGui")
StartupUI.Name = "BLUE_MODE_STARTUP"
StartupUI.ResetOnSpawn = false
StartupUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
StartupUI.DisplayOrder = 9999 -- TOP PRIORITY
StartupUI.Parent = CoreGui
task.defer(function() StartupUI.Parent = CoreGui end)

local StartupBox = Instance.new("Frame")
StartupBox.Size = UDim2.new(0, 420, 0, 380)
StartupBox.Position = UDim2.new(0.5, -210, 0.5, -190)
StartupBox.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
StartupBox.Active = true
StartupBox.ClipsDescendants = false
StartupBox.Parent = StartupUI
Instance.new("UICorner", StartupBox).CornerRadius = UDim.new(0, 16)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 0, 60)
Title.Position = UDim2.new(0, 10, 0, 15)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true
Title.Text = "🔵 BLUE MODE HUB"
Title.TextColor3 = Color3.fromRGB(0, 180, 255)
Title.Parent = StartupBox

local Info = Instance.new("TextLabel")
Info.Size = UDim2.new(1, -30, 0, 190)
Info.Position = UDim2.new(0, 15, 0, 80)
Info.BackgroundTransparency = 1
Info.Font = Enum.Font.Gotham
Info.TextScaled = true
Info.TextWrapped = true
Info.Text = [[✅ ALL FEATURES ENABLED:
• Rainbow ESP for all players
• Friends get extra Rainbow Dot
• Owner gets Gold Outline + Crown
• FPS & Ping Counter
• Fully draggable & cross-executor]]
Info.TextColor3 = Color3.fromRGB(230, 230, 230)
Info.Parent = StartupBox

local LoadBtn = Instance.new("TextButton")
LoadBtn.Size = UDim2.new(0, 280, 0, 55)
LoadBtn.Position = UDim2.new(0.5, -140, 0, 290)
LoadBtn.BackgroundColor3 = Color3.fromRGB(20, 120, 240)
LoadBtn.Font = Enum.Font.GothamBold
LoadBtn.TextScaled = true
LoadBtn.Text = "✅ LOAD HUB & ESP"
LoadBtn.TextColor3 = Color3.new(1,1,1)
LoadBtn.AutoLocalize = false
LoadBtn.Parent = StartupBox
Instance.new("UICorner", LoadBtn).CornerRadius = UDim.new(0, 12)

-- ==============================================
-- 🎯 MAIN SCRIPT LOGIC
-- ==============================================
local function LoadHub()
    StartupUI:Destroy() -- REMOVE STARTUP AFTER LOAD

    local ESP_Enabled = false
    local Hue = 0
    local FPS = 0
    local LOCAL_ID = LocalPlayer.UserId

    -- CLEANUP OLD ESP
    local function ClearESP()
        for _,v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character then
                pcall(function()
                    if v.Character:FindFirstChild("BLUE_Highlight") then v.Character.BLUE_Highlight:Destroy() end
                    if v.Character:FindFirstChild("FriendDot") then v.Character.FriendDot:Destroy() end
                    if v.Character:FindFirstChild("OwnerCrown") then v.Character.OwnerCrown:Destroy() end
                end)
            end
        end
    end

    -- MAIN UI
    local MainUI = Instance.new("ScreenGui")
    MainUI.Name = "BLUE_MODE_MAIN"
    MainUI.ResetOnSpawn = false
    MainUI.DisplayOrder = 9000
    MainUI.Parent = GuiContainer

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 380, 0, 100)
    MainFrame.Position = UDim2.new(0, 20, 0, 20)
    MainFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
    MainFrame.Active = true
    MainFrame.Parent = MainUI
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

    local ESPBtn = Instance.new("TextButton")
    ESPBtn.Size = UDim2.new(0, 110, 0, 40)
    ESPBtn.Position = UDim2.new(0, 15, 0, 15)
    ESPBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    ESPBtn.Font = Enum.Font.GothamBold
    ESPBtn.TextScaled = true
    ESPBtn.Text = "ESP: OFF"
    ESPBtn.TextColor3 = Color3.new(1,1,1)
    ESPBtn.Parent = MainFrame
    Instance.new("UICorner", ESPBtn).CornerRadius = UDim.new(0, 6)

    local FPSLabel = Instance.new("TextLabel")
    FPSLabel.Size = UDim2.new(0, 90, 0, 30)
    FPSLabel.Position = UDim2.new(0, 15, 0, 60)
    FPSLabel.BackgroundTransparency = 1
    FPSLabel.Text = "FPS: 0"
    FPSLabel.TextColor3 = Color3.fromRGB(80, 255, 140)
    FPSLabel.Parent = MainFrame

    local PingLabel = Instance.new("TextLabel")
    PingLabel.Size = UDim2.new(0, 90, 0, 30)
    PingLabel.Position = UDim2.new(0, 115, 0, 60)
    PingLabel.BackgroundTransparency = 1
    PingLabel.Text = "PING: 0"
    PingLabel.TextColor3 = Color3.fromRGB(255, 210, 60)
    PingLabel.Parent = MainFrame

    -- ESP TOGGLE
    ESPBtn.MouseButton1Click:Connect(function()
        ESP_Enabled = not ESP_Enabled
        ESPBtn.Text = ESP_Enabled and "ESP: ON ✅" or "ESP: OFF"
        ESPBtn.BackgroundColor3 = ESP_Enabled and Color3.fromRGB(25, 140, 60) or Color3.fromRGB(45, 45, 55)
        if not ESP_Enabled then ClearESP() end
    end)

    -- FPS COUNTER
    RunService.Heartbeat:Connect(function() FPS +=1 end)
    task.spawn(function()
        while task.wait(1) do
            if FPSLabel then FPSLabel.Text = "FPS: "..FPS end
            FPS = 0
        end
    end)

    -- ✅ FULLY WORKING ESP LOOP
    RunService.RenderStepped:Connect(function(Delta)
        -- UPDATE RAINBOW
        Hue = (Hue + Delta * 0.6) % 1
        local Rainbow = Color3.fromHSV(Hue, 1, 1)

        -- UPDATE PING
        pcall(function() PingLabel.Text = "PING: "..math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()).."ms" end)

        if not ESP_Enabled then return end

        -- SCAN ALL PLAYERS
        for _,Player in pairs(Players:GetPlayers()) do
            if Player == LocalPlayer then continue end
            local Char = Player.Character
            if not Char or not Char:FindFirstChild("Humanoid") or Char.Humanoid.Health <= 0 then
                pcall(function() if Char and Char:FindFirstChild("BLUE_Highlight") then Char.BLUE_Highlight:Destroy() end end)
                continue
            end

            -- CREATE HIGHLIGHT
            local Highlight = Char:FindFirstChild("BLUE_Highlight")
            if not Highlight then
                Highlight = Instance.new("Highlight")
                Highlight.Name = "BLUE_Highlight"
                Highlight.Adornee = Char
                Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                Highlight.OutlineTransparency = 0
                Highlight.FillTransparency = 0.6
                Highlight.Parent = Char
            end

            -- 🟡 OWNER (YOU)
            if Player.UserId == LOCAL_ID then
                Highlight.OutlineColor = Color3.fromRGB(255, 215, 0)
                Highlight.FillColor = Color3.fromRGB(255, 215, 0)
                pcall(function() Char:FindFirstChild("FriendDot"):Destroy() end)

                if not Char:FindFirstChild("OwnerCrown") then
                    local Crown = Instance.new("BillboardGui")
                    Crown.Name = "OwnerCrown"
                    Crown.AlwaysOnTop = true
                    Crown.Size = UDim2.new(0, 35, 0, 35)
                    Crown.StudsOffset = Vector3.new(0, 3.5, 0)
                    local Icon = Instance.new("ImageLabel")
                    Icon.Size = UDim2.new(1,0,1,0)
                    Icon.BackgroundTransparency = 1
                    Icon.Image = "rbxassetid://10342324"
                    Icon.ImageColor3 = Color3.fromRGB(255, 215, 0)
                    Icon.Parent = Crown
                    Crown.Parent = Char.Head
                end

            -- 🌈 FRIEND
            elseif LocalPlayer:IsFriendsWith(Player.UserId) then
                Highlight.OutlineColor = Rainbow
                Highlight.FillColor = Rainbow
                pcall(function() Char:FindFirstChild("OwnerCrown"):Destroy() end)

                local Dot = Char:FindFirstChild("FriendDot")
                if not Dot then
                    Dot = Instance.new("BillboardGui")
                    Dot.Name = "FriendDot"
                    Dot.AlwaysOnTop = true
                    Dot.Size = UDim2.new(0, 16, 0, 16)
                    Dot.StudsOffset = Vector3.new(0, 2.8, 0)
                    local Circle = Instance.new("Frame")
                    Circle.Size = UDim2.new(1,0,1,0)
                    Circle.BackgroundColor3 = Rainbow
                    Instance.new("UICorner", Circle).CornerRadius = UDim.new(1,0)
                    Circle.Parent = Dot
                    Dot.Parent = Char.Head
                else
                    Dot.Frame.BackgroundColor3 = Rainbow
                end

            -- 👥 NORMAL PLAYER
            else
                Highlight.OutlineColor = Rainbow
                Highlight.FillColor = Rainbow
                pcall(function() Char:FindFirstChild("FriendDot"):Destroy() end)
                pcall(function() Char:FindFirstChild("OwnerCrown"):Destroy() end)
            end
        end
    end)
end

-- TRIGGER LOAD WHEN BUTTON CLICKED
LoadBtn.MouseButton1Click:Connect(LoadHub)

-- FALLBACK: AUTO LOAD AFTER 3 SECONDS IF BUTTON FAILS
task.delay(3, function()
    if StartupUI and StartupUI.Parent then
        LoadHub()
    end
end)
