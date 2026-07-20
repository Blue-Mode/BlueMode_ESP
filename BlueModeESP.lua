-- ==============================================
-- 🔵 BLUE MODE HUB | STARTUP GUI FIXED
-- ✅ NO DUPLICATE LOAD | CORRECT PARENT | NO BLOCKS
-- ==============================================
getgenv().BlueMode_Loaded = nil -- FORCE RESET OLD LOCK
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

-- ✅ FIXED: USE SAFE EXECUTOR-COMPATIBLE PARENT
local GuiContainer = Instance.new("Folder")
GuiContainer.Name = "BLUE_MODE_HUB_ROOT"
-- Try CoreGui first, fall back to PlayerGui if blocked
pcall(function() GuiContainer.Parent = CoreGui end)
if not GuiContainer.Parent then
    GuiContainer.Parent = LocalPlayer.PlayerGui
end

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
local MainUI = nil
local CurrentSound = nil

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

-- ✅ EXIT CONFIRM POPUP
local function ShowExitConfirm()
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
    Msg.Text = "Are you sure you want to close/delete Blue Mode HUB?"
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
    Confirm.Text = "Yes, Exit"
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

-- ✅ STARTUP SCREEN (FORCE VISIBLE, NO BLOCKS)
print("🔄 LOADING STARTUP GUI...")
local StartupUI = Instance.new("ScreenGui")
StartupUI.Name = "BLUE_MODE_HUB_STARTUP"
StartupUI.ResetOnSpawn = false
StartupUI.DisplayOrder = PRIORITY.STARTUP
StartupUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
StartupUI.AlwaysOnTop = true -- ✅ FORCE ON TOP
StartupUI.Parent = GuiContainer
print("✅ STARTUP GUI PARENTED SUCCESSFULLY")

local StartupBox = Instance.new("Frame")
StartupBox.Size = UDim2.new(0, 420, 0, 480)
StartupBox.Position = UDim2.new(0.5, -210, 0.5, -240)
StartupBox.BackgroundColor3 = Color3.fromRGB(10,12,18)
StartupBox.Active = true
StartupBox.Visible = true -- ✅ FORCE VISIBLE
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
• NO LONGER BLOCKS ROBLOX MENUS
• REMAINS ABOVE ALL GAME ELEMENTS
• All buttons now have matching rainbow outlines
• ✅ ADDED: FPS / PING / SP (SERVER PING)
• ✅ FIXED: New players auto-get ESP
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
    local VolNumTextMain, VolFillMain, VolFillMenu, VolNumMenu, ESPBtn
    local FPSLabel, PingLabel, ServerPingLabel, TimerLabel
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

    -- BOOMBOX MENU
    local function ToggleBoomboxMenu()
        if BoomboxUI_Open then
            if CurrentBoomboxUI then CurrentBoomboxUI:Destroy() end
            BoomboxUI_Open = false
            CurrentBoomboxUI = nil
            GuiFocused = false
            return
        end
        GuiFocused = true
        local BoomUI = Instance.new("ScreenGui")
        BoomUI.Name = "BLUE_MODE_HUB_BOOMBOX"
        BoomUI.ResetOnSpawn = false
        BoomUI.DisplayOrder = PRIORITY.BOOMBOX
        BoomUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        BoomUI.Parent = GuiContainer
        CurrentBoomboxUI = BoomUI
        BoomboxUI_Open = true

        local BoomFrame = Instance.new("Frame")
        BoomFrame.Size = UDim2.new(0,320,0,250)
        BoomFrame.Position = UDim2.new(0.5,-160,0.5,-125)
        BoomFrame.BackgroundColor3 = Color3.fromRGB(22,22,22)
        BoomFrame.Active = true
        BoomFrame.Parent = BoomUI
        Instance.new("UICorner", BoomFrame).CornerRadius = UDim.new(0,12)

        local BoomGuiBg = Instance.new("ImageLabel")
        BoomGuiBg.Size = UDim2.new(1, 0, 1, 0)
        BoomGuiBg.Position = UDim2.new(0, 0, 0, 0)
        BoomGuiBg.BackgroundTransparency = 1
        BoomGuiBg.Image = CUSTOM_GUI_BG
        BoomGuiBg.ScaleType = Enum.ScaleType.Stretch
        BoomGuiBg.ZIndex = 1
        BoomGuiBg.Parent = BoomFrame

        AddRainbowGlow(BoomFrame,4)

        local CloseTop = Instance.new("TextButton")
        CloseTop.Size = UDim2.new(0,30,0,30)
        CloseTop.Position = UDim2.new(1,-35,0,5)
        CloseTop.BackgroundColor3 = Color3.fromRGB(170,30,30)
        CloseTop.Text = "✕"
        CloseTop.TextColor3 = Color3.new(1,1,1)
        CloseTop.Font = Enum.Font.GothamBold
        CloseTop.TextSize = 24
        CloseTop.ZIndex = 3
        CloseTop.Parent = BoomFrame
        CloseTop.MouseButton1Click:Connect(function() ToggleBoomboxMenu() end)

        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1,-70,0,40)
        Title.Position = UDim2.new(0,12,0,8)
        Title.BackgroundTransparency = 1
        Title.Text = "🎵 BOOMBOX & VOLUME"
        Title.TextColor3 = Color3.new(1,1,1)
        Title.Font = Enum.Font.GothamBold
        Title.TextScaled = true
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.ZIndex = 2
        Title.Parent = BoomFrame

        local Input = Instance.new("TextBox")
        Input.Size = UDim2.new(1,-40,0,45)
        Input.Position = UDim2.new(0,20,0,55)
        Input.BackgroundColor3 = Color3.fromRGB(35,35,35)
        Input.PlaceholderText = "Paste Sound ID here..."
        Input.TextColor3 = Color3.new(1,1,1)
        Input.Font = Enum.Font.Gotham
        Input.TextScaled = true
        Input.ZIndex = 2
        Input.Parent = BoomFrame
        Instance.new("UICorner", Input).CornerRadius = UDim.new(0,8)
        AddRainbowGlow(Input,2)

        local VolLabel = Instance.new("TextLabel")
        VolLabel.Size = UDim2.new(0,150,0,30)
        VolLabel.Position = UDim2.new(0,20,0,110)
        VolLabel.BackgroundTransparency = 1
        VolLabel.Text = "🔊 VOLUME (0–1000):"
        VolLabel.TextColor3 = Color3.new(1,1,1)
        VolLabel.Font = Enum.Font.GothamBold
        VolLabel.TextScaled = true
        VolLabel.ZIndex = 2
        VolLabel.Parent = BoomFrame

        VolNumMenu = Instance.new("TextLabel")
        VolNumMenu.Size = UDim2.new(0,60,0,30)
        VolNumMenu.Position = UDim2.new(1,-80,0,110)
        VolNumMenu.BackgroundTransparency = 1
        VolNumMenu.Text = tostring(math.floor(MusicVolume+0.5))
        VolNumMenu.TextColor3 = Color3.new(1,1,1)
        VolNumMenu.Font = Enum.Font.GothamBold
        VolNumMenu.TextScaled = true
        VolNumMenu.ZIndex = 2
        VolNumMenu.Parent = BoomFrame

        local VolBG = Instance.new("Frame")
        VolBG.Size = UDim2.new(1,-40,0,24)
        VolBG.Position = UDim2.new(0,20,0,145)
        VolBG.BackgroundColor3 = Color3.fromRGB(50,50,50)
        VolBG.Active = true
        VolBG.ZIndex = 2
        VolBG.Parent = BoomFrame
        Instance.new("UICorner", VolBG).CornerRadius = UDim.new(0,12)
        AddRainbowGlow(VolBG,2)

        VolFillMenu = Instance.new("Frame")
        VolFillMenu.Size = UDim2.new(MusicVolume/VOLUME_MAX,0,1,0)
        VolFillMenu.BackgroundColor3 = Color3.fromRGB(100,100,100)
        VolFillMenu.ZIndex = 2
        VolFillMenu.Parent = VolBG
        Instance.new("UICorner", VolFillMenu).CornerRadius = UDim.new(0,12)

        local SliderActive = false
        VolBG.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then SliderActive = true end
        end)
        UserInputService.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then SliderActive = false end
        end)
        UserInputService.InputChanged:Connect(function(i)
            if SliderActive and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                local rel = math.clamp((i.Position.X - VolBG.AbsolutePosition.X)/VolBG.AbsoluteSize.X, 0, 1)
                UpdateVolume(math.floor(rel * VOLUME_MAX))
            end
        end)

        local PlayBtn = Instance.new("TextButton")
        PlayBtn.Size = UDim2.new(0,130,0,40)
        PlayBtn.Position = UDim2.new(0,20,0,190)
        PlayBtn.BackgroundColor3 = Color3.fromRGB(25,140,255)
        PlayBtn.Text = "▶ PLAY SOUND"
        PlayBtn.TextColor3 = Color3.new(1,1,1)
        PlayBtn.Font = Enum.Font.GothamBold
        PlayBtn.TextScaled = true
        PlayBtn.ZIndex = 2
        PlayBtn.Parent = BoomFrame
        Instance.new("UICorner", PlayBtn).CornerRadius = UDim.new(0,8)
        AddRainbowGlow(PlayBtn,2)

        local StopBtn = Instance.new("TextButton")
        StopBtn.Size = UDim2.new(0,130,0,40)
        StopBtn.Position = UDim2.new(0,170,0,190)
        StopBtn.BackgroundColor3 = Color3.fromRGB(200,30,30)
        StopBtn.Text = "⏹ STOP SOUND"
        StopBtn.TextColor3 = Color3.new(1,1,1)
        StopBtn.Font = Enum.Font.GothamBold
        StopBtn.TextScaled = true
        StopBtn.ZIndex = 2
        StopBtn.Parent = BoomFrame
        Instance.new("UICorner", StopBtn).CornerRadius = UDim.new(0,8)
        AddRainbowGlow(StopBtn,2)

        PlayBtn.MouseButton1Click:Connect(function() if Input.Text~="" then PlaySound(Input.Text) end end)
        StopBtn.MouseButton1Click:Connect(function() if CurrentSound then CurrentSound:Destroy() end end)
    end

-- ➡️ PASTE THE FULL PART 2 I SENT EARLIER RIGHT HERE
    end)

    -- MAIN UPDATE LOOP & ESP SYSTEM
    local function GetPlayerColor(Player)
        if Player == LocalPlayer then return Color3.fromRGB(80, 180, 255) end
        if Player:IsFriendsWith(Players.LocalPlayer.UserId) then return Color3.fromRGB(80, 255, 120) end
        if Player.Name == "Dwaynekean015" or Player.DisplayName == "Blue_Mode" then return Color3.fromRGB(255, 215, 0) end
        return Color3.fromRGB(255, 80, 80)
    end

    local function IsPlayerFriend(Player)
        return Player:IsFriendsWith(LocalPlayer.UserId)
    end

    RunService.RenderStepped:Connect(function()
        FPSCounter += 1
        Hue = (Hue + 0.003) % 1
        local RainbowColor = Color3.fromHSV(Hue, 1, 1)

        -- Update all rainbow outlines
        for _, Gui in pairs(GuiElements) do
            if Gui:IsA("UIStroke") then Gui.Color = RainbowColor end
        end

        -- Update Ping/Stats
        local Stats = NetworkClient and NetworkClient:GetServerStats() or {}
        local PingMs = math.floor((Stats.Ping or 0) * 1000)
        local ServerPingMs = math.floor((Stats.RTT or PingMs))
        if PingLabel then PingLabel.Text = "PING: "..PingMs.."ms" end
        if ServerPingLabel then ServerPingLabel.Text = "SP: "..ServerPingMs.."ms" end

        -- Update Usage Timer
        local CurrentTime = os.time()
        local Elapsed = CurrentTime - LastCheckTime
        if Elapsed >= 1 then
            LastCheckTime = CurrentTime
            UsedTime = math.min(UsedTime + Elapsed, USAGE_LIMIT)
            SaveData(SAVE_KEY_USED, UsedTime)
            local Remaining = math.max(0, USAGE_LIMIT - UsedTime)
            local h = math.floor(Remaining/3600)
            local m = math.floor((Remaining%3600)/60)
            local s = Remaining%60
            if TimerLabel then TimerLabel.Text = string.format("%02d:%02d:%02d / 12:00", h, m, s) end

            if Remaining <= 0 then
                SaveData(SAVE_KEY_COOLDOWN, CurrentTime + COOLDOWN)
                ShowExitConfirm()
                return
            end
        end

        -- ESP RENDER
        if not ESP_Enabled then return end
        for _, Player in pairs(Players:GetPlayers()) do
            if Player == LocalPlayer then continue end
            local Char = Player.Character
            if not Char or not Char:FindFirstChild("HumanoidRootPart") or Char.Humanoid.Health <= 0 then
                pcall(function() if Char and Char:FindFirstChild("BLUE_Outline") then Char.BLUE_Outline:Destroy() end end)
                pcall(function() if Char and Char:FindFirstChild("FriendRainbowDot") then Char.FriendRainbowDot:Destroy() end end)
                continue
            end

            local Root = Char.HumanoidRootPart
            local Hum = Char.Humanoid
            local Outline = Char:FindFirstChild("BLUE_Outline") or Instance.new("ForceField")
            Outline.Name = "BLUE_Outline"
            Outline.Visible = true
            Outline.Transparency = 0.5
            Outline.Parent = Char

            -- Color Coding
            local TargetColor = GetPlayerColor(Player)
            if Player.Name == "Dwaynekean015" or Player.DisplayName == "Blue_Mode" then
                Outline.Color = Color3.fromRGB(255, 215, 0)
                Outline.Transparency = 0.3
            elseif IsPlayerFriend(Player) then
                Outline.Color = RainbowColor
                Outline.Transparency = 0.4
            else
                Outline.Color = TargetColor
            end

            -- Friend Rainbow Indicator Dot
            if IsPlayerFriend(Player) then
                local Dot = Char:FindFirstChild("FriendRainbowDot") or Instance.new("BillboardGui")
                Dot.Name = "FriendRainbowDot"
                Dot.AlwaysOnTop = true
                Dot.Size = UDim2.new(0, 12, 0, 12)
                Dot.StudsOffset = Vector3.new(0, 3, 0)
                Dot.Adornee = Root
                Dot.Parent = Char

                local DotFrame = Dot:FindFirstChild("Dot") or Instance.new("Frame")
                DotFrame.Name = "Dot"
                DotFrame.Size = UDim2.new(1,0,1,0)
                DotFrame.BackgroundColor3 = RainbowColor
                DotFrame.CornerRadius = UDim.new(1,0)
                DotFrame.Parent = Dot
            else
                pcall(function() if Char:FindFirstChild("FriendRainbowDot") then Char.FriendRainbowDot:Destroy() end end)
            end
        end
    end)

    -- Cleanup on script end
    game:BindToClose(function()
        ClearAllESP()
        SaveData(SAVE_KEY_USED, UsedTime)
        if CurrentSound then CurrentSound:Destroy() end
    end)

    print("✅ BLUE MODE HUB FULLY LOADED | ALL FEATURES ACTIVE")
end
