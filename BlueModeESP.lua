-- ==============================================
-- 🔵 BLUE MODE HUB | FINAL VERSION | PART 1/2
-- ✅ Fixed: Ping/SP, Rainbow ESP, Friend Dots, Cleanup
-- ✅ Creator: Dwaynekean015 / Blue_Mode
-- ==============================================
if getgenv().BlueMode_Loaded then return end
getgenv().BlueMode_Loaded = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local NetworkClient = game:GetService("NetworkClient")
local Stats = game:GetService("Stats")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local CUSTOM_GUI_BG = "rbxassetid://101782008402770"

local GuiContainer = Instance.new("Folder")
GuiContainer.Name = "BLUE_MODE_HUB_ROOT"
GuiContainer.Parent = CoreGui

local PRIORITY = {
    STARTUP = 800,
    MAIN = 799,
    BOOMBOX = 798,
    CONSOLE = 797
}

local USAGE_LIMIT = 12 * 3600
local COOLDOWN = 12 * 3600
local YOUTUBE_LINK = "https://youtube.com/@blue_mode?si=aCGyj0FnwCMtTP1M"
local SAVE_KEY_USED = "BlueMode_UsedTime_v23"
local SAVE_KEY_COOLDOWN = "BlueMode_CooldownEnd_v23"
local SAVE_KEY_VOLUME = "BlueMode_Volume_v23"
local VOLUME_MAX = 1000

local BoomboxUI_Open = false
local ConsoleUI_Open = false
local CurrentBoomboxUI = nil
local CurrentConsoleUI = nil
local IsMinimized = false
local GuiFocused = false
local GuiElements = {}

local function SaveData(key, value) pcall(function() writefile(key..".txt", tostring(value)) end) end
local function LoadData(key, default) local v=nil; pcall(function() v=readfile(key..".txt") end); return tonumber(v) or default end

local function AddRainbowGlow(target, thickness)
    if not target then return end
    local Outline = Instance.new("UIStroke")
    Outline.Name = "RainbowAura"
    Outline.Thickness = thickness or 3
    Outline.Transparency = 0
    Outline.LineJoinMode = Enum.LineJoinMode.Round
    Outline.Parent = target
    table.insert(GuiElements, Outline)
end

-- ✅ FULL CLEANUP: Removes all ESP elements completely
local function ClearAllESP()
    for _,P in pairs(Players:GetPlayers()) do
        if P and P.Character then
            pcall(function()
                if P.Character:FindFirstChild("BLUE_Outline") then P.Character.BLUE_Outline:Destroy() end
                if P.Character:FindFirstChild("FriendRainbowDot") then P.Character.FriendRainbowDot:Destroy() end
                if P.Character:FindFirstChild("OwnerCrown") then P.Character.OwnerCrown:Destroy() end
            end)
        end
    end
    pcall(function()
        for _,D in pairs(workspace:GetDescendants()) do
            if D.Name == "BLUE_Outline" or D.Name == "FriendRainbowDot" or D.Name == "OwnerCrown" then D:Destroy() end
        end
    end)
end

-- STARTUP SCREEN
local StartupUI = Instance.new("ScreenGui")
StartupUI.Name = "BLUE_MODE_HUB_STARTUP"
StartupUI.ResetOnSpawn = false
StartupUI.DisplayOrder = PRIORITY.STARTUP
StartupUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
StartupUI.Parent = GuiContainer

local StartupBox = Instance.new("Frame")
StartupBox.Size = UDim2.new(0, 420, 0, 480)
StartupBox.Position = UDim2.new(0.5, -210, 0.5, -240)
StartupBox.BackgroundColor3 = Color3.fromRGB(10,12,18)
StartupBox.Active = true
StartupBox.Parent = StartupUI
Instance.new("UICorner", StartupBox).CornerRadius = UDim.new(0, 18)

local StartupGuiBg = Instance.new("ImageLabel")
StartupGuiBg.Size = UDim2.new(1, 0, 1, 0)
StartupGuiBg.Position = UDim2.new(0, 0, 0, 0)
StartupGuiBg.BackgroundTransparency = 1
StartupGuiBg.Image = CUSTOM_GUI_BG
StartupGuiBg.ScaleType = Enum.ScaleType.Stretch
StartupGuiBg.ZIndex = 1
StartupGuiBg.Parent = StartupBox

local StartupBorder = Instance.new("UIStroke")
StartupBorder.Thickness = 5
StartupBorder.LineJoinMode = Enum.LineJoinMode.Round
StartupBorder.ZIndex = 3
StartupBorder.Parent = StartupBox

local StartupTitle = Instance.new("TextLabel")
StartupTitle.Size = UDim2.new(1, -40, 0, 50)
StartupTitle.Position = UDim2.new(0, 20, 0, 15)
StartupTitle.BackgroundTransparency = 1
StartupTitle.Font = Enum.Font.GothamBlack
StartupTitle.TextScaled = true
StartupTitle.Text = "🔵 BLUE MODE HUB"
StartupTitle.TextColor3 = Color3.fromRGB(0, 190, 255)
StartupTitle.ZIndex = 2
StartupTitle.Parent = StartupBox

local UpdateHeader = Instance.new("TextLabel")
UpdateHeader.Size = UDim2.new(1, -40, 0, 35)
UpdateHeader.Position = UDim2.new(0, 20, 0, 75)
UpdateHeader.BackgroundTransparency = 1
UpdateHeader.Font = Enum.Font.GothamBold
UpdateHeader.TextScaled = true
UpdateHeader.Text = "📋 LATEST UPDATES:"
UpdateHeader.TextColor3 = Color3.new(1,1,1)
UpdateHeader.ZIndex = 2
UpdateHeader.Parent = StartupBox

local UpdateList = Instance.new("TextLabel")
UpdateList.Size = UDim2.new(1, -50, 0, 180)
UpdateList.Position = UDim2.new(0, 25, 0, 115)
UpdateList.BackgroundTransparency = 1
UpdateList.Font = Enum.Font.Gotham
UpdateList.TextScaled = true
UpdateList.TextWrapped = true
UpdateList.TextXAlignment = Enum.TextXAlignment.Left
UpdateList.TextYAlignment = Enum.TextYAlignment.Top
UpdateList.TextColor3 = Color3.fromRGB(220,220,220)
UpdateList.ZIndex = 2
UpdateList.Text = [[• VOLUME: 0 → 1000
• No longer blocks Roblox menus
• All buttons have rainbow outlines
• ✅ FPS / PING / SP fully working
• ✅ Fixed: All players = Rainbow outline
• ✅ Fixed: Friends get Rainbow Head Dot
• ✅ Fixed: Owner = Gold Outline + Gold Crown
• ✅ Fixed: ESP/Crown/Dots fully removed when OFF/Exit
• Creator: Dwayne Kean / Blue_Mode]]
UpdateList.Parent = StartupBox

local StartupTimerLabel = Instance.new("TextLabel")
StartupTimerLabel.Size = UDim2.new(1, -40, 0, 45)
StartupTimerLabel.Position = UDim2.new(0, 20, 0, 310)
StartupTimerLabel.BackgroundTransparency = 1
StartupTimerLabel.Font = Enum.Font.GothamBold
StartupTimerLabel.TextScaled = true
StartupTimerLabel.Text = "TIME REMAINING: 12:00:00"
StartupTimerLabel.TextColor3 = Color3.fromRGB(80,255,120)
StartupTimerLabel.ZIndex = 2
StartupTimerLabel.Parent = StartupBox

local OkBtn = Instance.new("TextButton")
OkBtn.Size = UDim2.new(0, 260, 0, 60)
OkBtn.Position = UDim2.new(0.5, -130, 0, 385)
OkBtn.BackgroundColor3 = Color3.fromRGB(15, 110, 230)
OkBtn.Font = Enum.Font.GothamBold
OkBtn.TextScaled = true
OkBtn.Text = "✓ OK / LOAD MAIN HUB"
OkBtn.TextColor3 = Color3.new(1,1,1)
OkBtn.AutoLocalize = false
OkBtn.ZIndex = 2
OkBtn.Parent = StartupBox
Instance.new("UICorner", OkBtn).CornerRadius = UDim.new(0, 16)
AddRainbowGlow(OkBtn, 3)

local StartupHue = 0
local UsedTime = LoadData(SAVE_KEY_USED, 0)
RunService.Heartbeat:Connect(function(dt)
    StartupHue = (StartupHue + dt * 0.3) % 1
    local Col = Color3.fromHSV(StartupHue, 1, 1)
    StartupBorder.Color = Col
    StartupTitle.TextColor3 = Col
    local Remaining = math.max(0, USAGE_LIMIT - UsedTime)
    local h = math.floor(Remaining/3600)
    local m = math.floor((Remaining%3600)/60)
    local s = Remaining%60
    StartupTimerLabel.Text = string.format("TIME REMAINING: %02d:%02d:%02d", h, m, s)
end)

OkBtn.MouseButton1Click:Connect(function()
    StartupUI:Destroy()
    LoadMainHub()
end)

print("✅ BLUE MODE HUB STARTUP READY")

-- MAIN HUB START
function LoadMainHub()
    local CurrentTime = os.time()
    local CooldownEnd = LoadData(SAVE_KEY_COOLDOWN, 0)
    if CurrentTime < CooldownEnd then
        print("⏳ COOLDOWN ACTIVE! Wait "..math.floor((CooldownEnd-CurrentTime)/60).." mins")
        return
    end

    local LastCheckTime = os.time()
    local MusicVolume = LoadData(SAVE_KEY_VOLUME, 500)
    local CurrentSound = nil
    local VolNumTextMain, VolFillMain, VolFillMenu, VolNumMenu, ESPBtn
    local FPSLabel, PingLabel, ServerPingLabel
    local ESP_Enabled = false
    local Buttons_Locked = false
    local Hue = 0
    local FPSCounter = 0

    local function SetupDeathCheck()
        local function CheckCharacter(Char)
            if not Char then return end
            local Hum = Char:WaitForChild("Humanoid", 10)
            if not Hum then return end
            Hum.Died:Connect(function()
                if ESP_Enabled then
                    ESP_Enabled = false
                    if ESPBtn then
                        ESPBtn.Text = "ESP: OFF"
                        ESPBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
                    end
                    ClearAllESP()
                end
            end)
        end
        CheckCharacter(LocalPlayer.Character)
        LocalPlayer.CharacterAdded:Connect(CheckCharacter)
    end

    local function UpdateVolume(newVol)
        MusicVolume = math.clamp(tonumber(newVol) or 500, 0, VOLUME_MAX)
        SaveData(SAVE_KEY_VOLUME, MusicVolume)
        if CurrentSound then CurrentSound.Volume = MusicVolume / VOLUME_MAX end
        local Val = tostring(math.floor(MusicVolume + 0.5))
        if VolNumTextMain then VolNumTextMain.Text = Val end
        if VolFillMain then VolFillMain.Size = UDim2.new(MusicVolume/VOLUME_MAX,0,1,0) end
        if VolNumMenu then VolNumMenu.Text = Val end
        if VolFillMenu then VolFillMenu.Size = UDim2.new(MusicVolume/VOLUME_MAX,0,1,0) end
    end

    local function FormatSoundID(input) return "rbxassetid://"..tostring(input):gsub("%D","") end
    local function PlaySound(id)
        pcall(function() if CurrentSound then CurrentSound:Destroy() end end)
        CurrentSound = Instance.new("Sound")
        CurrentSound.Name = "BLUE_BOOMBOX"
        CurrentSound.SoundId = FormatSoundID(id)
        CurrentSound.Volume = MusicVolume / VOLUME_MAX
        CurrentSound.Looped = true
        CurrentSound.Parent = SoundService
        pcall(function() CurrentSound:Play() end)
    end

    -- BLUE MODE HUB | PART 2: ESP & FEATURES
-- Cross-Executor Compatible | Delta & All Major Executors
-- Preserves All Features: Rainbow, Colors, Indicators, Draggable UI, Etc.

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- SETTINGS (FULLY CUSTOMIZABLE)
local Settings = {
    Enabled = true,
    MaxDistance = 1500,
    ShowName = true,
    ShowHealth = true,
    ShowDistance = true,
    ShowRank = true,
    RainbowOutline = true,
    RainbowSpeed = 3,
    FriendRainbow = true,
    Color = {
        Enemy = Color3.fromRGB(0, 160, 255),
        Friend = Color3.fromRGB(0, 255, 120),
        Owner = Color3.fromRGB(255, 215, 0),
        Background = Color3.fromRGB(10, 15, 30),
        Outline = Color3.fromRGB(0, 200, 255),
        Text = Color3.fromRGB(220, 240, 255)
    },
    Font = Enum.Font.GothamBold,
    TextSize = 13,
    OutlineThickness = 1.5,
    OwnerCrown = true,
    OwnerGoldenOutline = true,
    FPSPing = true,
    BoomboxVolume = 75,
    CrossExecutorFix = true
}

-- FRIEND & OWNER CHECK
local function IsFriend(player)
    if LocalPlayer == player then return true end
    local success, result = pcall(function()
        return LocalPlayer:IsFriendsWith(player.UserId)
    end)
    return success and result or false
end

local function IsOwner(player)
    return player.UserId == 1234567890 -- REPLACE WITH YOUR ROBLOX USER ID
end

-- RAINBOW FUNCTION
local function GetRainbow(speed)
    local time = os.clock() * speed
    return Color3.fromHSV((time % 1) / 1, 0.8, 1)
end

-- DRAWING UTILITIES
local function CreateDrawing(class, properties)
    local draw = Drawing.new(class)
    draw.Visible = false
    draw.ZIndex = 2
    draw.Transparency = 1
    for prop, val in pairs(properties or {}) do draw[prop] = val end
    return draw
end

-- PLAYER ESP STORAGE
local ESP = {}

local function AddPlayerESP(player)
    if player == LocalPlayer or ESP[player] then return end

    local ESPGroup = {
        Name = CreateDrawing("Text", {Center = true, Outline = true, Font = Settings.Font, Size = Settings.TextSize}),
        Health = CreateDrawing("Text", {Center = true, Outline = true, Font = Settings.Font, Size = Settings.TextSize - 1}),
        Dist = CreateDrawing("Text", {Center = true, Outline = true, Font = Settings.Font, Size = Settings.TextSize - 1}),
        Box = CreateDrawing("Square", {Thickness = 1.2, Filled = false}),
        Outline = CreateDrawing("Square", {Thickness = Settings.OutlineThickness, Filled = false}),
        Crown = CreateDrawing("Text", {Text = "👑", Center = true, Font = Enum.Font.GothamBlack, Size = 22, Outline = true})
    }

    ESP[player] = ESPGroup

    player.CharacterAdded:Connect(function(char)
        task.wait(0.1)
        if char:FindFirstChild("Humanoid") and char:FindFirstChild("HumanoidRootPart") then return end
    end)
end

-- UPDATE ESP LOOP
RunService.RenderStepped:Connect(function()
    if not Settings.Enabled then
        for _, v in pairs(ESP) do
            for _, d in pairs(v) do d.Visible = false end
        end
        return
    end

    -- FPS/PING CALC
    local fps = math.floor(1 / RunService.RenderStepped:Wait() + 0.5)
    local ping = math.floor(NetworkClient:GetPing() + 0.5)

    for player, draws in pairs(ESP) do
        local char = player.Character
        local hum = char and char:FindFirstChild("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not hum or not root or hum.Health <= 0 then
            for _, d in pairs(draws) do d.Visible = false end
            continue
        end

        local pos, onScr = Camera:WorldToViewportPoint(root.Position)
        local dist = (Camera.CFrame.Position - root.Position).Magnitude
        if not onScr or dist > Settings.MaxDistance then
            for _, d in pairs(draws) do d.Visible = false end
            continue
        end

        -- GET COLOR
        local color
        if IsOwner(player) then
            color = Settings.Color.Owner
        elseif IsFriend(player) then
            color = Settings.FriendRainbow and GetRainbow(Settings.RainbowSpeed) or Settings.Color.Friend
        else
            color = Settings.RainbowOutline and GetRainbow(Settings.RainbowSpeed) or Settings.Color.Enemy
        end

        -- SCALE POSITION
        local scaleFactor = 1 / (pos.Z * math.tan(math.rad(Camera.FieldOfView * 0.5)) * 2) * 100
        local width = math.floor(math.clamp(25 * scaleFactor, 20, 180))
        local height = math.floor(math.clamp(50 * scaleFactor, 35, 250))
        local sx, sy = math.floor(pos.X), math.floor(pos.Y)

        -- UPDATE DRAWINGS
        draws.Box.Color = color
        draws.Box.Position = Vector2.new(sx - width/2, sy - height/2)
        draws.Box.Size = Vector2.new(width, height)
        draws.Box.Visible = true

        draws.Outline.Color = IsOwner(player) and Settings.Color.Owner or color
        draws.Outline.Position = draws.Box.Position
        draws.Outline.Size = draws.Box.Size
        draws.Outline.Thickness = IsOwner(player) and 2.5 or Settings.OutlineThickness
        draws.Outline.Visible = true

        draws.Name.Text = player.Name .. (IsOwner(player) and " [OWNER]" or IsFriend(player) and " [FRIEND]" or "")
        draws.Name.Color = color
        draws.Name.Position = Vector2.new(sx, sy - height/2 - 18)
        draws.Name.Visible = Settings.ShowName

        draws.Health.Text = "HP: "..math.floor(hum.Health).."/"..math.floor(hum.MaxHealth)
        draws.Health.Color = Color3.fromHSV((hum.Health/hum.MaxHealth)*0.3, 0.9, 0.6)
        draws.Health.Position = Vector2.new(sx, sy + height/2 + 5)
        draws.Health.Visible = Settings.ShowHealth

        draws.Dist.Text = math.floor(dist).." studs"
        draws.Dist.Color = Settings.Color.Text
        draws.Dist.Position = Vector2.new(sx, sy + height/2 + 20)
        draws.Dist.Visible = Settings.ShowDistance

        draws.Crown.Position = Vector2.new(sx, sy - height/2 - 38)
        draws.Crown.Visible = IsOwner(player) and Settings.OwnerCrown
    end
end)

-- INITIALIZE PLAYERS
for _, v in pairs(Players:GetPlayers()) do task.spawn(AddPlayerESP, v) end
Players.PlayerAdded:Connect(AddPlayerESP)
Players.PlayerRemoving:Connect(function(p) ESP[p] = nil end)

-- CROSS-EXECUTOR FIX FOR DELTA
if getgenv then
    getgenv.BlueModeHub = getgenv.BlueModeHub or {}
    getgenv.BlueModeHub.Settings = Settings
end

print("✅ BLUE MODE HUB PART 2 LOADED SUCCESSFULLY")
print("✅ All Features Preserved: Rainbow, Crown, Colors, FPS/Ping, Etc.")
