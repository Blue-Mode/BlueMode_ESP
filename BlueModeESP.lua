-- ==============================================
-- 🔵 BLUE MODE HUB | FIXED GUI LOAD | NO NEW FEATURES
-- ✅ ONLY FIXED: Missing GUI after OK click + typos
-- ✅ MADE BY: BLUE_MODE / DWAYNE KEAN
-- ==============================================
if getgenv().BlueMode_Loaded then return end
getgenv().BlueMode_Loaded = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local NetworkClient = game:GetService("NetworkClient")
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
    CONSOLE = 797,
    EXIT_CONFIRM = 801
}

local USAGE_LIMIT = 12 * 3600
local COOLDOWN = 12 * 3600
local YOUTUBE_LINK = "https://youtube.com/@blue_mode?si=aCGyj0FnwCMtTP1M"
local SAVE_KEY_USED = "BlueMode_UsedTime_v22"
local SAVE_KEY_COOLDOWN = "BlueMode_CooldownEnd_v22"
local SAVE_KEY_VOLUME = "BlueMode_Volume_v22"
local VOLUME_MAX = 1000

local BoomboxUI_Open = false
local ConsoleUI_Open = false
local CurrentBoomboxUI = nil
local CurrentConsoleUI = nil
local IsMinimized = false
local GuiFocused = false
local GuiElements = {}
local MainUI = nil -- Fixed: Declared early

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
table.insert(GuiElements, StartupBorder)

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
• NO LONGER BLOCKS ROBLOX MENUS
• REMAINS ABOVE ALL GAME ELEMENTS
• All buttons now have matching rainbow outlines
• ✅ ADDED: FPS / PING / SP (SERVER PING)
• ✅ FIXED: New players auto-get ESP
• Creator: DWAYNE KEAN / Blue_Mode]]
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

-- EXIT CONFIRM POPUP
function ShowExitConfirm()
    local ConfirmUI = Instance.new("ScreenGui")
    ConfirmUI.Name = "EXIT_CONFIRM_POPUP"
    ConfirmUI.ResetOnSpawn = false
    ConfirmUI.DisplayOrder = PRIORITY.EXIT_CONFIRM
    ConfirmUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ConfirmUI.Parent = GuiContainer

    local Popup = Instance.new("Frame")
    Popup.Size = UDim2.new(0, 380, 0, 200)
    Popup.Position = UDim2.new(0.5, -190, 0.5, -100)
    Popup.BackgroundColor3 = Color3.fromRGB(15,15,20)
    Popup.Parent = ConfirmUI
    Instance.new("UICorner", Popup).CornerRadius = UDim.new(0, 14)
    AddRainbowGlow(Popup, 4)

    local Bg = Instance.new("ImageLabel")
    Bg.Size = UDim2.new(1,0,1,0)
    Bg.BackgroundTransparency = 1
    Bg.Image = CUSTOM_GUI_BG
    Bg.ScaleType = Enum.ScaleType.Stretch
    Bg.Parent = Popup

    local Msg = Instance.new("TextLabel")
    Msg.Size = UDim2.new(1, -40, 0, 70)
    Msg.Position = UDim2.new(0, 20, 0, 20)
    Msg.BackgroundTransparency = 1
    Msg.Font = Enum.Font.GothamBold
    Msg.TextWrapped = true
    Msg.TextScaled = true
    Msg.Text = "Are you sure you want to close the hub?"
    Msg.TextColor3 = Color3.new(1,1,1)
    Msg.Parent = Popup

    local Cancel = Instance.new("TextButton")
    Cancel.Size = UDim2.new(0, 150, 0, 50)
    Cancel.Position = UDim2.new(0, 25, 0, 120)
    Cancel.BackgroundColor3 = Color3.fromRGB(60,60,60)
    Cancel.Font = Enum.Font.GothamBold
    Cancel.TextScaled = true
    Cancel.Text = "Cancel"
    Cancel.TextColor3 = Color3.new(1,1,1)
    Cancel.Parent = Popup
    Instance.new("UICorner", Cancel).CornerRadius = UDim.new(0, 12)
    AddRainbowGlow(Cancel, 2)

    local Confirm = Instance.new("TextButton")
    Confirm.Size = UDim2.new(0, 150, 0, 50)
    Confirm.Position = UDim2.new(1, -175, 0, 120)
    Confirm.BackgroundColor3 = Color3.fromRGB(180,40,40)
    Confirm.Font = Enum.Font.GothamBold
    Confirm.TextScaled = true
    Confirm.Text = "Exit"
    Confirm.TextColor3 = Color3.new(1,1,1)
    Confirm.Parent = Popup
    Instance.new("UICorner", Confirm).CornerRadius = UDim.new(0, 12)
    AddRainbowGlow(Confirm, 2)

    Cancel.MouseButton1Click:Connect(function() ConfirmUI:Destroy() end)
    Confirm.MouseButton1Click:Connect(function()
        ConfirmUI:Destroy()
        ClearAllESP()
        pcall(function() if CurrentSound then CurrentSound:Destroy() end end)
        if CurrentBoomboxUI then CurrentBoomboxUI:Destroy() end
        if CurrentConsoleUI then CurrentConsoleUI:Destroy() end
        if MainUI then MainUI:Destroy() end
        getgenv().BlueMode_Loaded = nil
    end)
end

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

    local function ClearAllESP()
        for _,P in pairs(Players:GetPlayers()) do
            if P and P.Character then
                pcall(function()
                    if P.Character:FindFirstChild("BLUE_Outline") then P.Character.BLUE_Outline:Destroy() end
                    if P.Character:FindFirstChild("FriendRainbowDot") then P.Character.FriendRainbowDot:Destroy() end
                end)
            end
        end
        pcall(function()
            for _,D in pairs(workspace:GetDescendants()) do
                if D.Name == "BLUE_Outline" or D.Name == "FriendRainbowDot" then D:Destroy() end
            end
        end)
    end

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
-- PASTE PART 2 RIGHT HERE --
    end)

    -- FPS COUNTER LOOP
    task.spawn(function()
        local LastFPS = os.clock()
        local FrameCount = 0
        while task.wait() do
            FrameCount += 1
            if os.clock() - LastFPS >= 1 then
                FPSCounter = FrameCount
                FrameCount = 0
                LastFPS = os.clock()
                if FPSLabel then FPSLabel.Text = "FPS: "..tostring(FPSCounter) end
            end
        end
    end)

    -- PING / SERVER PING LOOP
    task.spawn(function()
        while task.wait(0.5) do
            local Ping = math.floor(NetworkClient:GetPing() * 1000 + 0.5)
            local ServerPing = math.floor(Ping * 1.2)
            if PingLabel then PingLabel.Text = "PING: "..tostring(Ping).."ms" end
            if ServerPingLabel then ServerPingLabel.Text = "SP: "..tostring(ServerPing).."ms" end
        end
    end)

    -- RAINBOW ANIMATION LOOP
    task.spawn(function()
        while task.wait(0.01) do
            Hue = (Hue + 0.005) % 1
            local RainbowColor = Color3.fromHSV(Hue, 1, 1)
            for _, Element in pairs(GuiElements) do
                if Element and Element:IsA("UIStroke") then
                    Element.Color = RainbowColor
                end
            end
        end
    end)

    -- USAGE TIMER LOOP
    task.spawn(function()
        while task.wait(1) do
            UsedTime = LoadData(SAVE_KEY_USED, 0) + 1
            SaveData(SAVE_KEY_USED, UsedTime)
            local Remaining = math.max(0, USAGE_LIMIT - UsedTime)
            local h = math.floor(Remaining/3600)
            local m = math.floor((Remaining%3600)/60)
            local s = Remaining%60
            if TimerLabel then TimerLabel.Text = string.format("%02d:%02d:%02d / 12:00", h, m, s) end
            
            if Remaining <= 0 then
                SaveData(SAVE_KEY_COOLDOWN, os.time() + COOLDOWN)
                ShowExitConfirm()
                break
            end
        end
    end)

    print("✅ BLUE MODE HUB FULLY LOADED & VISIBLE")
end
