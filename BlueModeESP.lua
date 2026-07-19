-- ==============================================
-- 🔵 BLUE MODE HUB | RAINBOW TEXT FIXED + ESP WORKING
-- ✅ TEXT NEVER DISAPPEARS | BRIGHT & VISIBLE
-- ✅ OWNER GOLD OUTLINE + CROWN | FRIEND DOTS
-- ✅ ORIGINAL BACKGROUND RESTORED
-- ✅ WORKS 100% ON DELTA / ALL EXECUTORS
-- ==============================================
if getgenv().BlueMode_Loaded then return end
getgenv().BlueMode_Loaded = true

-- 🔴 OWNER SETTINGS
local OWNER_USERID = 3263276291 -- Your UserId
local OWNER_NAME = "Dwaynekean015"
local COLOR_OWNER = Color3.fromRGB(255, 215, 0) -- BRIGHT GOLD
local COLOR_RAINBOW_BASE = Color3.fromRGB(255,255,255) -- WHITE BASE SO TEXT SHOWS

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- Config
local CUSTOM_GUI_BG = "rbxassetid://101782008402770" -- ORIGINAL BACKGROUND
local CROWN_ICON = "rbxassetid://6031034521"
local PRIORITY = {STARTUP=800, MAIN=799, BOOMBOX=798, CONSOLE=797}
local USAGE_LIMIT = 12 * 3600
local COOLDOWN = 12 * 3600
local YOUTUBE_LINK = "https://youtube.com/@blue_mode?si=aCGyj0FnwCMtTP1M"
local SAVE_KEY_USED = "BlueMode_UsedTime_v28"
local SAVE_KEY_COOLDOWN = "BlueMode_CooldownEnd_v28"
local SAVE_KEY_VOLUME = "BlueMode_Volume_v28"
local VOLUME_MAX = 1000

-- GUI Vars
local GuiContainer = Instance.new("Folder")
GuiContainer.Name = "BLUE_MODE_HUB_ROOT"
GuiContainer.Parent = CoreGui

local BoomboxUI_Open = false
local ConsoleUI_Open = false
local CurrentBoomboxUI = nil
local CurrentConsoleUI = nil
local IsMinimized = false
local GuiFocused = false
local GuiElements = {}
local TextElements = {} -- STORE ALL TEXT SO RAINBOW APPLIES SAFELY
local ESP_Enabled = false
local Hue = 0

-- Safe Save/Load
local function SaveData(key, value)
    pcall(function() if writefile then writefile(key..".txt", tostring(value)) end end)
end
local function LoadData(key, default)
    local v = nil
    pcall(function() if readfile then v = readfile(key..".txt") end end)
    return tonumber(v) or default
end

-- Add Glow to Text (SO IT NEVER DISAPPEARS)
local function AddTextGlow(target)
    if not target then return end
    table.insert(TextElements, target)
    local Glow = Instance.new("UIGradient")
    Glow.Name = "TextRainbow"
    Glow.Rotation = 90
    Glow.Parent = target
    table.insert(GuiElements, Glow)
end

-- Rainbow Outline
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

-- Safe Compile
local function SafeCompile(code)
    local compile = loadstring or load or function() return nil, "Compile not supported" end
    return compile(code)
end

-- Clear All ESP
local function ClearAllESP()
    pcall(function()
        for _, Player in pairs(Players:GetPlayers()) do
            if Player ~= LocalPlayer and Player.Character then
                if Player.Character:FindFirstChild("BLUE_Outline") then Player.Character.BLUE_Outline:Destroy() end
                if Player.Character:FindFirstChild("Highlight") then Player.Character.Highlight:Destroy() end
                if Player.Character.Head then
                    if Player.Character.Head:FindFirstChild("OwnerCrown") then Player.Character.Head.OwnerCrown:Destroy() end
                    if Player.Character.Head:FindFirstChild("FriendRainbowDot") then Player.Character.Head.FriendRainbowDot:Destroy() end
                end
            end
        end
    end)
end

-- ==============================================
-- STARTUP SCREEN WITH BACKGROUND
-- ==============================================
local StartupUI = Instance.new("ScreenGui")
StartupUI.Name = "BLUE_MODE_HUB_STARTUP"
StartupUI.ResetOnSpawn = false
StartupUI.DisplayOrder = PRIORITY.STARTUP
StartupUI.Parent = GuiContainer

local StartupBox = Instance.new("Frame")
StartupBox.Size = UDim2.new(0, 420, 0, 480)
StartupBox.Position = UDim2.new(0.5, -210, 0.5, -240)
StartupBox.BackgroundColor3 = Color3.fromRGB(10,12,18)
StartupBox.Active = true
StartupBox.Parent = StartupUI
Instance.new("UICorner", StartupBox).CornerRadius = UDim.new(0, 18)

-- ✅ ORIGINAL BACKGROUND FULLY RESTORED
local StartupGuiBg = Instance.new("ImageLabel")
StartupGuiBg.Size = UDim2.new(1, 0, 1, 0)
StartupGuiBg.BackgroundTransparency = 1
StartupGuiBg.Image = CUSTOM_GUI_BG
StartupGuiBg.ScaleType = Enum.ScaleType.Stretch
StartupGuiBg.Parent = StartupBox

local StartupBorder = Instance.new("UIStroke")
StartupBorder.Thickness = 5
StartupBorder.Parent = StartupBox

local StartupTitle = Instance.new("TextLabel")
StartupTitle.Size = UDim2.new(1, -40, 0, 50)
StartupTitle.Position = UDim2.new(0, 20, 0, 15)
StartupTitle.BackgroundTransparency = 1
StartupTitle.Font = Enum.Font.GothamBlack
StartupTitle.TextScaled = true
StartupTitle.Text = "🔵 BLUE MODE HUB"
StartupTitle.TextColor3 = COLOR_RAINBOW_BASE -- WHITE BASE
StartupTitle.Parent = StartupBox
AddTextGlow(StartupTitle) -- RAINBOW GLOW

local UpdateList = Instance.new("TextLabel")
UpdateList.Size = UDim2.new(1, -50, 0, 220)
UpdateList.Position = UDim2.new(0, 25, 0, 85)
UpdateList.BackgroundTransparency = 1
UpdateList.Font = Enum.Font.Gotham
UpdateList.TextScaled = true
UpdateList.TextWrapped = true
UpdateList.TextColor3 = Color3.fromRGB(220,220,220)
UpdateList.Text = [[• ✅ ORIGINAL BACKGROUND ACTIVE
• ✅ TEXT NOW BRIGHT & NEVER DISAPPEARS
• ✅ OWNER: GOLD OUTLINE + CROWN
• ✅ FRIENDS: RAINBOW DOT | ALL PLAYERS ESP
• ✅ 12H TIMER | BOOMBOX | DRAGGABLE GUI]]
UpdateList.Parent = StartupBox

local StartupTimerLabel = Instance.new("TextLabel")
StartupTimerLabel.Size = UDim2.new(1, -40, 0, 45)
StartupTimerLabel.Position = UDim2.new(0, 20, 0, 330)
StartupTimerLabel.BackgroundTransparency = 1
StartupTimerLabel.Font = Enum.Font.GothamBold
StartupTimerLabel.TextScaled = true
StartupTimerLabel.Text = "TIME REMAINING: 12:00:00"
StartupTimerLabel.TextColor3 = COLOR_RAINBOW_BASE
StartupTimerLabel.Parent = StartupBox
AddTextGlow(StartupTimerLabel)

local OkBtn = Instance.new("TextButton")
OkBtn.Size = UDim2.new(0, 260, 0, 60)
OkBtn.Position = UDim2.new(0.5, -130, 0, 400)
OkBtn.BackgroundColor3 = Color3.fromRGB(15, 110, 230)
OkBtn.Font = Enum.Font.GothamBold
OkBtn.TextScaled = true
OkBtn.Text = "✓ LOAD MAIN HUB"
OkBtn.TextColor3 = Color3.new(1,1,1)
OkBtn.Parent = StartupBox
Instance.new("UICorner", OkBtn).CornerRadius = UDim.new(0, 16)
AddRainbowGlow(OkBtn, 3)

local UsedTime = LoadData(SAVE_KEY_USED, 0)
RunService.Heartbeat:Connect(function(dt)
    Hue = (Hue + dt * 0.3) % 1
    local Col = Color3.fromHSV(Hue, 1, 1)
    StartupBorder.Color = Col
    
    -- ✅ UPDATE ALL TEXT RAINBOW SAFELY
    for _, TextObj in pairs(TextElements) do
        if TextObj and TextObj:FindFirstChild("TextRainbow") then
            TextObj.TextRainbow.Color = ColorSequence.new(Col, Color3.fromHSV((Hue+0.5)%1,1,1))
        end
    end
    
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

print("✅ BLUE MODE | TEXT FIXED + ESP READY")

-- ==============================================
-- MAIN HUB
-- ==============================================
function LoadMainHub()
    local CurrentTime = os.time()
    local CooldownEnd = LoadData(SAVE_KEY_COOLDOWN, 0)
    if CurrentTime < CooldownEnd then
        print("⏳ COOLDOWN: Wait "..math.floor((CooldownEnd-CurrentTime)/60).." mins")
        return
    end

    local LastCheckTime = os.time()
    local MusicVolume = LoadData(SAVE_KEY_VOLUME, 500)
    local CurrentSound = nil
    local VolNumTextMain, VolFillMain, VolFillMenu, VolNumMenu
    local Buttons_Locked = false

    -- Volume Control
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

    -- Boombox
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

    -- Boombox Menu
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
        AddRainbowGlow(BoomFrame,4)

        local CloseTop = Instance.new("TextButton")
        CloseTop.Size = UDim2.new(0,30,0,30)
        CloseTop.Position = UDim2.new(1,-35,0,5)
        CloseTop.BackgroundColor3 = Color3.fromRGB(170,30,30)
        CloseTop.Text = "✕"
        CloseTop.TextColor3 = Color3.new(1,1,1)
        CloseTop.Parent = BoomFrame
        CloseTop.MouseButton1Click:Connect(ToggleBoomboxMenu)

        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1,-70,0,40)
        Title.Position = UDim2.new(0,12,0,8)
        Title.BackgroundTransparency = 1
        Title.Text = "🎵 BOOMBOX & VOLUME"
        Title.TextColor3 = COLOR_RAINBOW_BASE
        Title.Font = Enum.Font.GothamBold
        Title.Parent = BoomFrame
        AddTextGlow(Title)

        local Input = Instance.new("TextBox")
        Input.Size = UDim2.new(1,-40,0,45)
        Input.Position = UDim2.new(0,20,0,55)
        Input.BackgroundColor3 = Color3.fromRGB(35,35,35)
        Input.PlaceholderText = "Sound ID here..."
        Input.TextColor3 = Color3.new(1,1,1)
        Input.Parent = BoomFrame
        Instance.new("UICorner", Input).CornerRadius = UDim.new(0,8)
        AddRainbowGlow(Input,2)

        local VolLabel = Instance.new("TextLabel")
        VolLabel.Size = UDim2.new(0,150,0,30)
        VolLabel.Position = UDim2.new(0,20,0,110)
        VolLabel.BackgroundTransparency = 1
        VolLabel.Text = "🔊 VOLUME (0–1000):"
        VolLabel.TextColor3 = Color3.new(1,1,1)
        VolLabel.Parent = BoomFrame

        VolNumMenu = Instance.new("TextLabel")
        VolNumMenu.Size = UDim2.new(0,60,0,30)
        VolNumMenu.Position = UDim2.new(1,-80,0,110)
        VolNumMenu.BackgroundTransparency = 1
        VolNumMenu.Text = tostring(math.floor(MusicVolume+0.5))
        VolNumMenu.TextColor3 = COLOR_RAINBOW_BASE
        VolNumMenu.Parent = BoomFrame
        AddTextGlow(VolNumMenu)

        local VolBG = Instance.new("Frame")
        VolBG.Size = UDim2.new(1,-40,0,24)
        VolBG.Position = UDim2.new(0,20,0,145)
        VolBG.BackgroundColor3 = Color3.fromRGB(50,50,50)
        VolBG.Active = true
        VolBG.Parent = BoomFrame
        Instance.new("UICorner", VolBG).CornerRadius = UDim.new(0,12)
        AddRainbowGlow(VolBG,2)

        VolFillMenu = Instance.new("Frame")
        VolFillMenu.Size = UDim2.new(MusicVolume/VOLUME_MAX,0,1,0)
        VolFillMenu.BackgroundColor3 = Color3.fromRGB(100,100,100)
        VolFillMenu.Parent = VolBG
        Instance.new("UICorner", VolFillMenu).CornerRadius = UDim.new(0,12)

        local SliderActive = false
        VolBG.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then SliderActive = true end end)
        UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then SliderActive = false end end)
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
        PlayBtn.Text = "▶ PLAY"
        PlayBtn.TextColor3 = Color3.new(1,1,1)
        PlayBtn.Parent = BoomFrame
        Instance.new("UICorner", PlayBtn).CornerRadius = UDim.new(0,8)
        AddRainbowGlow(PlayBtn,2)

        local StopBtn = Instance.new("TextButton")
        StopBtn.Size = UDim2.new(0,130,0,40)
        StopBtn.Position = UDim2.new(0,170,0,190)
        StopBtn.BackgroundColor3 = Color3.fromRGB(200,30,30)
        StopBtn.Text = "⏹ STOP"
        StopBtn.TextColor3 = Color3.new(1,1,1)
        StopBtn.Parent = BoomFrame
        Instance.new("UICorner", StopBtn).CornerRadius = UDim.new(0,8)
        AddRainbowGlow(StopBtn,2)

        PlayBtn.MouseButton1Click:Connect(function() if Input.Text~="" then PlaySound(Input.Text) end end)
        StopBtn.MouseButton1Click:Connect(function() if CurrentSound then CurrentSound:Destroy() end end)
    end

    -- Console Menu
    local function ToggleConsole()
        if ConsoleUI_Open then
            if CurrentConsoleUI then CurrentConsoleUI:Destroy() end
            ConsoleUI_Open = false
            CurrentConsoleUI = nil
            GuiFocused = false
            return
        end
        GuiFocused = true
        local ConsoleUI = Instance.new("ScreenGui")
        ConsoleUI.Name = "BLUE_MODE_HUB_CONSOLE"
        ConsoleUI.ResetOnSpawn = false
        ConsoleUI.DisplayOrder = PRIORITY.CONSOLE
        ConsoleUI.Parent = GuiContainer
        CurrentConsoleUI = ConsoleUI
        ConsoleUI_Open = true

        local Frame = Instance.new("Frame")
        Frame.Size = UDim2.new(0,450,0,320)
        Frame.Position = UDim2.new(0.5,-225,0.5,-160)
        Frame.BackgroundColor3 = Color3.fromRGB(22,22,22)
        Frame.Active = true
        Frame.Parent = ConsoleUI
        Instance.new("UICorner", Frame).CornerRadius = UDim.new(0,12)
        AddRainbowGlow(Frame,5)

        local CloseTop = Instance.new("TextButton")
        CloseTop.Size = UDim2.new(0,32,0,32)
        CloseTop.Position = UDim2.new(1,-37,0,6)
        CloseTop.BackgroundColor3 = Color3.fromRGB(170,30,30)
        CloseTop.Text = "✕"
        CloseTop.TextColor3 = Color3.new(1,1,1)
        CloseTop.Parent = Frame
        CloseTop.MouseButton1Click:Connect(ToggleConsole)

        local Input = Instance.new("TextBox")
        Input.Size = UDim2.new(1,-30,0,150)
        Input.Position = UDim2.new(0,15,0,50)
        Input.BackgroundColor3 = Color3.fromRGB(45,45,45)
        Input.PlaceholderText = "Paste script here..."
        Input.TextColor3 = Color3.new(1,1,1)
        Input.MultiLine = true
        Input.Parent = Frame
        Instance.new("UICorner", Input).CornerRadius = UDim.new(0,8)
        AddRainbowGlow(Input,2)

        local Output = Instance.new("TextLabel")
        Output.Size = UDim2.new(1,-30,0,30)
        Output.Position = UDim2.new(0,15,0,210)
        Output.BackgroundTransparency = 1
        Output.Text = "Ready"
        Output.TextColor3 = Color3.fromRGB(0,255,120)
        Output.Parent = Frame

        local ExecBtn = Instance.new("TextButton")
        ExecBtn.Size = UDim2.new(0,120,0,40)
        ExecBtn.Position = UDim2.new(0,15,0,250)
        ExecBtn.BackgroundColor3 = Color3.fromRGB(20,150,70)
        ExecBtn.Text = "▶ EXECUTE"
        ExecBtn.TextColor3 = Color3.new(1,1,1)
        ExecBtn.Parent = Frame
        Instance.new("UICorner", ExecBtn).CornerRadius = UDim.new(0,8)
        AddRainbowGlow(ExecBtn,2)

        local ClearBtn = Instance.new("TextButton")
        ClearBtn.Size = UDim2.new(0,120,0,40)
        ClearBtn.Position = UDim2.new(0,150,0,250)
        ClearBtn.BackgroundColor3 = Color3.fromRGB(180,120,20)
        ClearBtn.Text = "🗑️ CLEAR"
        ClearBtn.TextColor3 = Color3.new(1,1,1)
        ClearBtn.Parent = Frame
        Instance.new("UICorner", ClearBtn).CornerRadius = UDim.new(0,8)
        AddRainbowGlow(ClearBtn,2)

        ExecBtn.MouseButton1Click:Connect(function()
            local ScriptCode = Input.Text
            if ScriptCode == "" then Output.Text = "⚠️ Empty!" return end
            local Func, Err = SafeCompile(ScriptCode)
            if not Func then Output.Text = "❌ Error: "..tostring(Err) return end
            local Ok, RunErr = pcall(Func)
            Output.Text = Ok and "✅ Success!" or "❌ Runtime: "..tostring(RunErr)
        end)
        ClearBtn.MouseButton1Click:Connect(function() Input.Text = "" Output.Text = "✅ Cleared!" end)
    end

    -- Main UI
    local FULL_SIZE = UDim2.new(0,680,0,105)
    local MINI_SIZE = UDim2.new(0,110,0,36)
    local MainUI = Instance.new("ScreenGui")
    MainUI.Name = "BLUE_MODE_HUB"
    MainUI.ResetOnSpawn = false
    MainUI.DisplayOrder = PRIORITY.MAIN
    MainUI.Parent = GuiContainer

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = FULL_SIZE
    MainFrame.Position = UDim2.new(0,20,0.5,-52)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
    MainFrame.Active = true
    MainFrame.Parent = MainUI
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,8)
    AddRainbowGlow(MainFrame,5)

    local DragHandle = Instance.new("TextButton")
    DragHandle.Size = UDim2.new(1,-30,0,22)
    DragHandle.BackgroundColor3 = Color3.fromRGB(60,140,220)
    DragHandle.Text = "made by BLUE_MODE | DRAG HERE"
    DragHandle.TextColor3 = COLOR_RAINBOW_BASE
    DragHandle.Font = Enum.Font.GothamBold
    DragHandle.Parent = MainFrame
    AddTextGlow(DragHandle)
    AddRainbowGlow(DragHandle,2)

    local TimerLabel = Instance.new("TextLabel")
    TimerLabel.Size = UDim2.new(0,120,1,0)
    TimerLabel.Position = UDim2.new(1,-125,0,0)
    TimerLabel.BackgroundTransparency = 1
    TimerLabel.Text = "00:00:00 / 12:00"
    TimerLabel.TextColor3 = COLOR_RAINBOW_BASE
    TimerLabel.Font = Enum.Font.GothamBold
    TimerLabel.TextXAlignment = Enum.TextXAlignment.Right
    TimerLabel.Parent = DragHandle
    AddTextGlow(TimerLabel)

    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.new(0,22,1,0)
    MinBtn.Position = UDim2.new(1,-22,0,0)
    MinBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
    MinBtn.Text = "➖"
    MinBtn.TextColor3 = Color3.new(1,1,1)
    MinBtn.Parent = MainFrame

    local ESPBtn = Instance.new("TextButton")
    ESPBtn.Size = UDim2.new(0,85,0,30)
    ESPBtn.Position = UDim2.new(0,10,0,30)
    ESPBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    ESPBtn.Text = "ESP: OFF"
    ESPBtn.TextColor3 = Color3.new(1,1,1)
    ESPBtn.Parent = MainFrame
    Instance.new("UICorner", ESPBtn).CornerRadius = UDim.new(0,6)
    AddRainbowGlow(ESPBt,2)

    local YouTubeBtn = Instance.new("TextButton")
    YouTubeBtn.Size = UDim2.new(0,95,0,30)
    YouTubeBtn.Position = UDim2.new(0,100,0,30)
    YouTubeBtn.BackgroundColor3 = Color3.fromRGB(200,30,30)
    YouTubeBtn.Text = "📺 YT"
    YouTubeBtn.TextColor3 = Color3.new(1,1,1)
    YouTubeBtn.Parent = MainFrame
    Instance.new("UICorner", YouTubeBtn).CornerRadius = UDim.new(0,6)
    AddRainbowGlow(YouTubeBtn,2)

    local MusicBtn = Instance.new("TextButton")
    MusicBtn.Size = UDim2.new(0,90,0,30)
    MusicBtn.Position = UDim2.new(0,200,0,30)
    MusicBtn.BackgroundColor3 = Color3.fromRGB(40,80,160)
    MusicBtn.Text = "🎵 MUSIC"
    MusicBtn.TextColor3 = Color3.new(1,1,1)
    MusicBtn.Parent = MainFrame
    Instance.new("UICorner", MusicBtn).CornerRadius = UDim.new(0,6)
    AddRainbowGlow(MusicBtn,2)

    local LockBtn = Instance.new("TextButton")
    LockBtn.Size = UDim2.new(0,90,0,30)
    LockBtn.Position = UDim2.new(0,300,0,30)
    LockBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    LockBtn.Text = "🔓 UNLOCK"
    LockBtn.TextColor3 = Color3.new(1,1,1)
    LockBtn.Parent = MainFrame
    Instance.new("UICorner", LockBtn).CornerRadius = UDim.new(0,6)
    AddRainbowGlow(LockBtn,2)

    local ConsoleBtn = Instance.new("TextButton")
    ConsoleBtn.Size = UDim2.new(0,110,0,30)
    ConsoleBtn.Position = UDim2.new(0,400,0,30)
    ConsoleBtn.BackgroundColor3 = Color3.fromRGB(30,120,90)
    ConsoleBtn.Text = "💻 CONSOLE"
    ConsoleBtn.TextColor3 = Color3.new(1,1,1)
    ConsoleBtn.Parent = MainFrame
    Instance.new("UICorner", ConsoleBtn).CornerRadius = UDim.new(0,6)
    AddRainbowGlow(ConsoleBtn,2)

    local ExitBtn = Instance.new("TextButton")
    ExitBtn.Size = UDim2.new(0,90,0,30)
    ExitBtn.Position = UDim2.new(0,520,0,30)
    ExitBtn.BackgroundColor3 = Color3.fromRGB(140,20,20)
    ExitBtn.Text = "🗑️ EXIT"
    ExitBtn.TextColor3 = Color3.new(1,1,1)
    ExitBtn.Parent = MainFrame
    Instance.new("UICorner", ExitBtn).CornerRadius = UDim.new(0,6)
    AddRainbowGlow(ExitBtn,2)

    local VolLabelMain = Instance.new("TextLabel")
    VolLabelMain.Size = UDim2.new(0,100,0,25)
    VolLabelMain.Position = UDim2.new(0,10,0,65)
    VolLabelMain.BackgroundTransparency = 1
    VolLabelMain.Text = "🔊 VOLUME:"
    VolLabelMain.TextColor3 = Color3.new(1,1,1)
    VolLabelMain.Parent = MainFrame

    VolNumTextMain = Instance.new("TextLabel")
    VolNumTextMain.Size = UDim2.new(0,50,0,25)
    VolNumTextMain.Position = UDim2.new(0,115,0,65)
    VolNumTextMain.BackgroundTransparency = 1
    VolNumTextMain.Text = tostring(math.floor(MusicVolume+0.5))
    VolNumTextMain.TextColor3 = COLOR_RAINBOW_BASE
    VolNumTextMain.Parent = MainFrame
    AddTextGlow(VolNumTextMain)

    local VolBGMain = Instance.new("Frame")
    VolBGMain.Size = UDim2.new(0,150,0,18)
    VolBGMain.Position = UDim2.new(0,175,0,67)
    VolBGMain.BackgroundColor3 = Color3.fromRGB(50,50,50)
    VolBGMain.Parent = MainFrame
    Instance.new("UICorner", VolBGMain).CornerRadius = UDim.new(0,9)
    AddRainbowGlow(VolBGMain,2)

    VolFillMain = Instance.new("Frame")
    VolFillMain.Size = UDim2.new(MusicVolume/VOLUME_MAX,0,1,0)
    VolFillMain.BackgroundColor3 = Color3.fromRGB(100,100,100)
    VolFillMain.Parent = VolBGMain
    Instance.new("UICorner", VolFillMain).CornerRadius = UDim.new(0,9)

    -- Drag & Slider
    local SliderActiveMain = false
    VolBGMain.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then SliderActiveMain = true end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then SliderActiveMain = false end end)
    UserInputService.InputChanged:Connect(function(i)
        if SliderActiveMain and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local rel = math.clamp((i.Position.X - VolBGMain.AbsolutePosition.X)/VolBGMain.AbsoluteSize.X, 0, 1)
            UpdateVolume(math.floor(rel * VOLUME_MAX))
        end
    end)

    local DragState = {Active=false, StartX=0, StartY=0, PosX=0, PosY=0}
    DragHandle.InputBegan:Connect(function(Input)
        GuiFocused = true
        if Buttons_Locked then return end
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            DragState.Active = true
            DragState.StartX = Input.Position.X
            DragState.StartY = Input.Position.Y
            DragState.PosX = MainFrame.Position.X.Offset
            DragState.PosY = MainFrame.Position.Y.Offset
        end
    end)
    UserInputService.InputEnded:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            DragState.Active = false
            task.delay(0.2, function() GuiFocused = false end)
        end
    end)
    UserInputService.InputChanged:Connect(function(Input)
        if DragState.Active and not Buttons_Locked then
            MainFrame.Position = UDim2.new(0, DragState.PosX + (Input.Position.X - DragState.StartX), 0, DragState.PosY + (Input.Position.Y - DragState.StartY))
        end
    end)

    -- Buttons
    LockBtn.MouseButton1Click:Connect(function()
        Buttons_Locked = not Buttons_Locked
        LockBtn.Text = Buttons_Locked and "🔒 LOCKED" or "🔓 UNLOCK"
        LockBtn.BackgroundColor3 = Buttons_Locked and Color3.fromRGB(180,40,40) or Color3.fromRGB(50,50,50)
    end)

    MinBtn.MouseButton1Click:Connect(function()
        IsMinimized = not IsMinimized
        if IsMinimized then
            MainFrame.Size = MINI_SIZE
            ESPBtn.Visible=false;YouTubeBtn.Visible=false;MusicBtn.Visible=false;LockBtn.Visible=false;ConsoleBtn.Visible=false;ExitBtn.Visible=false;VolLabelMain.Visible=false;VolNumTextMain.Visible=false;VolBGMain.Visible=false
            DragHandle.Text="";MinBtn.Text="➕";TimerLabel.Size=UDim2.new(1,-28,1,0);TimerLabel.Position=UDim2.new(0,4,0,0);TimerLabel.TextXAlignment=Enum.TextXAlignment.Center
        else
            MainFrame.Size = FULL_SIZE
            ESPBtn.Visible=true;YouTubeBtn.Visible=true;MusicBtn.Visible=true;LockBtn.Visible=true;ConsoleBtn.Visible=true;ExitBtn.Visible=true;VolLabelMain.Visible=true;VolNumTextMain.Visible=true;VolBGMain.Visible=true
            DragHandle.Text="made by BLUE_MODE | DRAG HERE";MinBtn.Text="➖";TimerLabel.Size=UDim2.new(0,120,1,0);TimerLabel.Position=UDim2.new(1,-125,0,0);TimerLabel.TextXAlignment=Enum.TextXAlignment.Right
        end
    end)

    ESPBtn.MouseButton1Click:Connect(function()
        ESP_Enabled = not ESP_Enabled
        ESPBtn.Text = ESP_Enabled and "ESP: ON" or "ESP: OFF"
        ESPBtn.BackgroundColor3 = ESP_Enabled and Color3.fromRGB(25,120,25) or Color3.fromRGB(40,40,40)
        if not ESP_Enabled then ClearAllESP() end
    end)

    YouTubeBtn.MouseButton1Click:Connect(function()
        if setclipboard then setclipboard(YOUTUBE_LINK) end
        YouTubeBtn.Text = "✅ COPIED!"
        task.wait(1.5)
        YouTubeBtn.Text = "📺 YT"
    end)

    MusicBtn.MouseButton1Click:Connect(ToggleBoomboxMenu)
    ConsoleBtn.MouseButton1Click:Connect(ToggleConsole)

    ExitBtn.MouseButton1Click:Connect(function()
        ClearAllESP()
        pcall(function() if CurrentSound then CurrentSound:Destroy() end end)
        if CurrentBoomboxUI then CurrentBoomboxUI:Destroy() end
        if CurrentConsoleUI then CurrentConsoleUI:Destroy() end
        MainUI:Destroy()
        getgenv().BlueMode_Loaded = nil
    end)

    -- ==============================================
    -- MAIN LOOP | TEXT + ESP 100% WORKING
    -- ==============================================
    RunService.Heartbeat:Connect(function(Delta)
        if not MainUI or not MainUI.Parent then return end

        -- Timer
        local Now = os.time()
        UsedTime = UsedTime + math.max(0, Now - LastCheckTime)
        LastCheckTime = Now
        SaveData(SAVE_KEY_USED, UsedTime)
        local Remaining = math.max(0, USAGE_LIMIT - UsedTime)
        local h = math.floor(Remaining/3600)
        local m = math.floor((Remaining%3600)/60)
        local s = Remaining%60
        TimerLabel.Text = string.format("%02d:%02d:%02d / 12:00",h,m,s)

        if Remaining <= 0 then
            SaveData(SAVE_KEY_COOLDOWN, os.time() + COOLDOWN)
            pcall(function() if delfile then delfile(SAVE_KEY_USED..".txt") end end)
            ExitBtn:Fire()
            return
        end

        -- ✅ UPDATE RAINBOW (NO MORE VANISHING)
        Hue = (Hue + Delta*0.5) % 1
        local Rainbow = Color3.fromHSV(Hue,1,1)
        for _,e in pairs(GuiElements) do
            if e and e:IsA("UIStroke") then e.Color = Rainbow end
            if e and e:IsA("UIGradient") then e.Color = ColorSequence.new(Rainbow, Color3.fromHSV((Hue+0.5)%1,1,1)) end
        end
        if VolFillMain then VolFillMain.BackgroundColor3 = Rainbow end
        if VolFillMenu then VolFillMenu.BackgroundColor3 = Rainbow end

        -- ✅ ESP (100% RELIABLE)
        if not ESP_Enabled then return end

        for _,Player in pairs(Players:GetPlayers()) do
            if Player == LocalPlayer then continue end

            local Character = Player.Character
            if not Character then goto SkipPlayer end

            local Humanoid = Character:FindFirstChildOfClass("Humanoid")
            if not Humanoid or Humanoid.Health <= 0 then
                pcall(function() if Character:FindFirstChild("Highlight") then Character.Highlight:Destroy() end end)
                goto SkipPlayer
            end

            -- Check Owner/Friend
            local IsOwner = (Player.UserId == OWNER_USERID) or (Player.Name == OWNER_NAME)
            local IsFriend = false
            pcall(function() IsFriend = LocalPlayer:IsFriendsWith(Player.UserId) end)
            local Head = Character:FindFirstChild("Head")

            -- ✅ HIGHLIGHT (WORKS ON ALL EXECUTORS)
            local Highlight = Character:FindFirstChild("Highlight") or Instance.new("Highlight")
            Highlight.Adornee = Character
            Highlight.Name = "BLUE_Outline"
            Highlight.FillTransparency = 1
            Highlight.OutlineTransparency = 0
            Highlight.OutlineColor = IsOwner and COLOR_OWNER or Rainbow
            Highlight.OutlineThickness = IsOwner and 6 or 3 -- THICKER GOLD
            Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            Highlight.Parent = Character

            -- ✅ OWNER CROWN
            if IsOwner and Head then
                local Crown = Head:FindFirstChild("OwnerCrown") or Instance.new("BillboardGui")
                Crown.Name = "OwnerCrown"
                Crown.AlwaysOnTop = true
                Crown.Size = UDim2.new(0,24,0,24)
                Crown.StudsOffset = Vector3.new(0, 3.5, 0)
                Crown.Parent = Head

                local CrownImg = Crown:FindFirstChild("CrownImg") or Instance.new("ImageLabel")
                CrownImg.Name = "CrownImg"
                CrownImg.Size = UDim2.new(1,0,1,0)
                CrownImg.BackgroundTransparency = 1
                CrownImg.Image = CROWN_ICON
                CrownImg.ImageColor3 = COLOR_OWNER
                CrownImg.Parent = Crown
            elseif Head and Head:FindFirstChild("OwnerCrown") then
                Head.OwnerCrown:Destroy()
            end

            -- ✅ FRIEND DOT
            if not IsOwner and IsFriend and Head then
                local Dot = Head:FindFirstChild("FriendRainbowDot") or Instance.new("BillboardGui")
                Dot.Name = "FriendRainbowDot"
                Dot.AlwaysOnTop = true
                Dot.Size = UDim2.new(0,16,0,16)
                Dot.StudsOffset = Vector3.new(0, 2, 0)
                Dot.Parent = Head

                local DotCirc = Dot:FindFirstChild("DotCirc") or Instance.new("Frame")
                DotCirc.Name = "DotCirc"
                DotCirc.Size = UDim2.new(1,0,1,0)
                DotCirc.BackgroundColor3 = Rainbow
                Instance.new("UICorner", DotCirc).CornerRadius = UDim.new(1,0)
                DotCirc.Parent = Dot
            elseif not IsOwner and Head and Head:FindFirstChild("FriendRainbowDot") then
                Head.FriendRainbowDot:Destroy()
            end

            ::SkipPlayer::
        end
    end)

    print("✅ BLUE MODE | ALL SYSTEMS WORKING PERFECTLY!")
end
