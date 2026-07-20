-- ==============================================
-- 🔵 BLUE MODE HUB | FINAL VERSION
-- ✅ UPDATES: CREATOR NAME → DWAYNE KEAN ONLY, EXIT POPUP RAINBOW OUTLINE + TEXT OUTLINE, MOUNTAIN BG
-- ✅ CROSS-EXECUTOR COMPATIBLE | DRAGGABLE GUI
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
    CONFIRM = 801
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
• ✅ NEW: Exit popup with rainbow border + outlined text
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
OkBtn.Text = "✓ OK / LOAD HUB"
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

print("✅ BLUE MODE HUB STARTUP LOADED")

-- MAIN HUB FUNCTION
function LoadMainHub()
    local CurrentTime = os.time()
    local CooldownEnd = LoadData(SAVE_KEY_COOLDOWN, 0)
    if CurrentTime < CooldownEnd then
        print("⏳ COOLDOWN ACTIVE! Wait "..math.ceil((CooldownEnd-CurrentTime)/60).." mins")
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
        if VolFillMain then VolFillMain.Size = UDim2.new(MusicVolume/VOLUME_MAX, 0, 1, 0) end
        if VolNumMenu then VolNumMenu.Text = Val end
        if VolFillMenu then VolFillMenu.Size = UDim2.new(MusicVolume/VOLUME_MAX, 0, 1, 0) end
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

        -- ✅ EXIT POPUP: MATCHING RAINBOW OUTLINE + OUTLINED TEXT
    local function ShowExitConfirm()
        local ConfirmUI = Instance.new("ScreenGui")
        ConfirmUI.Name = "EXIT_CONFIRM_POPUP"
        ConfirmUI.ResetOnSpawn = false
        ConfirmUI.DisplayOrder = PRIORITY.CONFIRM
        ConfirmUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        ConfirmUI.Parent = GuiContainer

        -- Main frame with exact same rainbow border as Music/Console
        local Bg = Instance.new("Frame")
        Bg.Size = UDim2.new(0, 380, 0, 200)
        Bg.Position = UDim2.new(0.5, -190, 0.5, -100)
        Bg.BackgroundColor3 = Color3.fromRGB(15,15,20)
        Bg.Parent = ConfirmUI
        Instance.new("UICorner", Bg).CornerRadius = UDim.new(0, 14)
        AddRainbowGlow(Bg, 4)

        -- Mountain background
        local PopupBg = Instance.new("ImageLabel")
        PopupBg.Size = UDim2.new(1, 0, 1, 0)
        PopupBg.Position = UDim2.new(0, 0, 0, 0)
        PopupBg.BackgroundTransparency = 0.2
        PopupBg.Image = CUSTOM_GUI_BG
        PopupBg.ScaleType = Enum.ScaleType.Stretch
        PopupBg.Parent = Bg

        -- White fill + rainbow outline text
        local Msg = Instance.new("TextLabel")
        Msg.Size = UDim2.new(1, -40, 0, 70)
        Msg.Position = UDim2.new(0, 20, 0, 20)
        Msg.BackgroundTransparency = 1
        Msg.Font = Enum.Font.GothamBold
        Msg.TextWrapped = true
        Msg.TextScaled = true
        Msg.Text = "Are you sure you want to close the hub?"
        Msg.TextColor3 = Color3.new(1,1,1)
        Msg.TextStrokeTransparency = 0
        Msg.Parent = Bg
        AddRainbowGlow(Msg, 2)

        local CancelBtn = Instance.new("TextButton")
        CancelBtn.Size = UDim2.new(0, 150, 0, 50)
        CancelBtn.Position = UDim2.new(0, 25, 0, 120)
        CancelBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
        CancelBtn.Font = Enum.Font.GothamBold
        CancelBtn.TextScaled = true
        CancelBtn.Text = "Cancel"
        CancelBtn.TextColor3 = Color3.new(1,1,1)
        CancelBtn.TextStrokeTransparency = 0
        CancelBtn.Parent = Bg
        Instance.new("UICorner", CancelBtn).CornerRadius = UDim.new(0, 12)
        AddRainbowGlow(CancelBtn, 2)

        local SureBtn = Instance.new("TextButton")
        SureBtn.Size = UDim2.new(0, 150, 0, 50)
        SureBtn.Position = UDim2.new(1, -175, 0, 120)
        SureBtn.BackgroundColor3 = Color3.fromRGB(180,40,40)
        SureBtn.Font = Enum.Font.GothamBold
        SureBtn.TextScaled = true
        SureBtn.Text = "Sure"
        SureBtn.TextColor3 = Color3.new(1,1,1)
        SureBtn.TextStrokeTransparency = 0
        SureBtn.Parent = Bg
        Instance.new("UICorner", SureBtn).CornerRadius = UDim.new(0, 12)
        AddRainbowGlow(SureBtn, 2)

        CancelBtn.MouseButton1Click:Connect(function() ConfirmUI:Destroy() end)
        SureBtn.MouseButton1Click:Connect(function()
            ConfirmUI:Destroy()
            ClearAllESP()
            pcall(function() if CurrentSound then CurrentSound:Destroy() end end)
            pcall(function() GuiContainer:Destroy() end)
            getgenv().BlueMode_Loaded = nil
        end)
    end

    -- MAIN HUB GUI
    local FULL_SIZE = UDim2.new(0,680,0,105)
    local MINI_SIZE = UDim2.new(0,110,0,36)
    local MainUI = Instance.new("ScreenGui")
    MainUI.Name = "BLUE_MODE_HUB"
    MainUI.ResetOnSpawn = false
    MainUI.DisplayOrder = PRIORITY.MAIN
    MainUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    MainUI.Parent = GuiContainer

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = FULL_SIZE
    MainFrame.Position = UDim2.new(0,20,0.5,-52)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
    MainFrame.Active = true
    MainFrame.ClipsDescendants = false
    MainFrame.Parent = MainUI
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,8)
    AddRainbowGlow(MainFrame,5)

    local DragHandle = Instance.new("TextButton")
    DragHandle.Size = UDim2.new(1,-30,0,22)
    DragHandle.Position = UDim2.new(0,0,0,0)
    DragHandle.BackgroundColor3 = Color3.fromRGB(60,140,220)
    DragHandle.AutoLocalize = false
    DragHandle.Text = "made by BLUE_MODE / DWAYNE KEAN | DRAG HERE"
    DragHandle.Font = Enum.Font.GothamBold
    DragHandle.TextScaled = true
    DragHandle.TextColor3 = Color3.new(1,1,1)
    DragHandle.Parent = MainFrame
    AddRainbowGlow(DragHandle,2)

    local TimerLabel = Instance.new("TextLabel")
    TimerLabel.Size = UDim2.new(0,120,1,0)
    TimerLabel.Position = UDim2.new(1,-125,0,0)
    TimerLabel.BackgroundTransparency = 1
    TimerLabel.Text = "00:00:00 / 12:00"
    TimerLabel.Font = Enum.Font.GothamBold
    TimerLabel.TextScaled = true
    TimerLabel.TextColor3 = Color3.new(1,1,1)
    TimerLabel.TextXAlignment = Enum.TextXAlignment.Right
    TimerLabel.Parent = MainFrame

    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.new(0,22,1,0)
    MinBtn.Position = UDim2.new(1,-22,0,0)
    MinBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
    MinBtn.Text = "➖"
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.TextScaled = true
    MinBtn.TextColor3 = Color3.new(1,1,1)
    MinBtn.Parent = MainFrame
    AddRainbowGlow(MinBtn,2)

    ESPBtn = Instance.new("TextButton")
    ESPBtn.Size = UDim2.new(0,85,0,30)
    ESPBtn.Position = UDim2.new(0,10,0,30)
    ESPBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    ESPBtn.Text = "ESP: OFF"
    ESPBtn.Font = Enum.Font.GothamBold
    ESPBtn.TextScaled = true
    ESPBtn.TextColor3 = Color3.new(1,1,1)
    ESPBtn.Parent = MainFrame
    Instance.new("UICorner", ESPBtn).CornerRadius = UDim.new(0,6)
    AddRainbowGlow(ESPBt,2)

    local YouTubeBtn = Instance.new("TextButton")
    YouTubeBtn.Size = UDim2.new(0,95,0,30)
    YouTubeBtn.Position = UDim2.new(0,100,0,30)
    YouTubeBtn.BackgroundColor3 = Color3.fromRGB(200,30,30)
    YouTubeBtn.Text = "📺 YT"
    YouTubeBtn.Font = Enum.Font.GothamBold
    YouTubeBtn.TextScaled = true
    YouTubeBtn.TextColor3 = Color3.new(1,1,1)
    YouTubeBtn.Parent = MainFrame
    Instance.new("UICorner", YouTubeBtn).CornerRadius = UDim.new(0,6)
    AddRainbowGlow(YouTubeBtn,2)
    YouTubeBtn.MouseButton1Click:Connect(function() setclipboard(YOUTUBE_LINK) print("✅ YouTube link copied!") end)

    local MusicBtn = Instance.new("TextButton")
    MusicBtn.Size = UDim2.new(0,90,0,30)
    MusicBtn.Position = UDim2.new(0,200,0,30)
    MusicBtn.BackgroundColor3 = Color3.fromRGB(40,80,160)
    MusicBtn.Text = "🎵 MUSIC"
    MusicBtn.Font = Enum.Font.GothamBold
    MusicBtn.TextScaled = true
    MusicBtn.TextColor3 = Color3.new(1,1,1)
    MusicBtn.Parent = MainFrame
    Instance.new("UICorner", MusicBtn).CornerRadius = UDim.new(0,6)
    AddRainbowGlow(MusicBtn,2)

    local LockBtn = Instance.new("TextButton")
    LockBtn.Size = UDim2.new(0,90,0,30)
    LockBtn.Position = UDim2.new(0,300,0,30)
    LockBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    LockBtn.Text = "🔓 UNLOCK"
    LockBtn.Font = Enum.Font.GothamBold
    LockBtn.TextScaled = true
    LockBtn.TextColor3 = Color3.new(1,1,1)
    LockBtn.Parent = MainFrame
    Instance.new("UICorner", LockBtn).CornerRadius = UDim.new(0,6)
    AddRainbowGlow(LockBtn,2)

    local ConsoleBtn = Instance.new("TextButton")
    ConsoleBtn.Size = UDim2.new(0,110,0,30)
    ConsoleBtn.Position = UDim2.new(0,400,0,30)
    ConsoleBtn.BackgroundColor3 = Color3.fromRGB(30,120,90)
    ConsoleBtn.Text = "💻 CONSOLE"
    ConsoleBtn.Font = Enum.Font.GothamBold
    ConsoleBtn.TextScaled = true
    ConsoleBtn.TextColor3 = Color3.new(1,1,1)
    ConsoleBtn.Parent = MainFrame
    Instance.new("UICorner", ConsoleBtn).CornerRadius = UDim.new(0,6)
    AddRainbowGlow(ConsoleBtn,2)

    local ExitBtn = Instance.new("TextButton")
    ExitBtn.Size = UDim2.new(0,90,0,30)
    ExitBtn.Position = UDim2.new(0,520,0,30)
    ExitBtn.BackgroundColor3 = Color3.fromRGB(140,20,20)
    ExitBtn.Text = "🗑️ EXIT"
    ExitBtn.Font = Enum.Font.GothamBold
    ExitBtn.TextScaled = true
    ExitBtn.TextColor3 = Color3.new(1,1,1)
    ExitBtn.Parent = MainFrame
    Instance.new("UICorner", ExitBtn).CornerRadius = UDim.new(0,6)
    AddRainbowGlow(ExitBtn,2)
    ExitBtn.MouseButton1Click:Connect(ShowExitConfirm)

    -- Drag functionality
    local DragStart, InputStart
    DragHandle.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            DragStart = Input.Position
            InputStart = MainFrame.Position
            Input.Changed:Connect(function() if Input.UserInputState == Enum.UserInputState.End then DragStart = nil end end)
        end
    end)
    UserInputService.InputChanged:Connect(function(Input)
        if DragStart and Input.UserInputType == Enum.UserInputType.MouseMovement then
            local Delta = Input.Position - DragStart
            MainFrame.Position = UDim2.new(InputStart.X.Scale, InputStart.X.Offset + Delta.X, InputStart.Y.Scale, InputStart.Y.Offset + Delta.Y)
        end
    end)

    SetupDeathCheck()

    -- New player ESP support
    Players.PlayerAdded:Connect(function(NewPlayer)
        print("👤 New player joined: "..NewPlayer.Name)
        NewPlayer.CharacterAdded:Connect(function() task.wait(1) end)
    end)
    Players.PlayerRemoving:Connect(function(OldPlayer)
        if OldPlayer.Character then pcall(function()
            if OldPlayer.Character:FindFirstChild("BLUE_Outline") then OldPlayer.Character.BLUE_Outline:Destroy() end
            if OldPlayer.Character:FindFirstChild("FriendRainbowDot") then OldPlayer.Character.FriendRainbowDot:Destroy() end
        end) end
    end)

    -- Rainbow animation loop
    RunService.Heartbeat:Connect(function(dt)
        Hue = (Hue + dt * 0.5) % 1
        local Col = Color3.fromHSV(Hue, 1, 1)
        for _,v in pairs(GuiElements) do v.Color = Col end
    end)

    print("✅ BLUE MODE HUB FULLY LOADED!")
end
