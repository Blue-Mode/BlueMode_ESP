-- ==============================================
-- 🔵 BLUE MODE HUB | UPDATED
-- ✅ FPS+PING INSIDE MAIN UI
-- ✅ ESP TEXT RAINBOW OUTLINE
-- ✅ ESP BTN: RED=OFF / GREEN=ON
-- ✅ MADE BY: BLUE_MODE / DWAYNE KEAN FRANCISCO
-- ==============================================
if getgenv().BlueMode_Loaded then return end
getgenv().BlueMode_Loaded = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local CoreGui = game:GetService("CoreGui")
local Stats = game:GetService("Stats")
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
    ESP_TEXT = 900
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
UpdateList.Text = [[• FPS/PING MOVED INSIDE MAIN HUB
• ESP TEXT NOW HAS FULL RAINBOW OUTLINE
• ESP BUTTON: RED=OFF / GREEN=ON
• VOLUME: 0 → 1000
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
print("✅ STARTUP READY")

-- ==============================================
-- ✅ MAIN HUB & ESP
-- ==============================================
function LoadMainHub()
    local CurrentTime = os.time()
    local CooldownEnd = LoadData(SAVE_KEY_COOLDOWN, 0)
    if CurrentTime < CooldownEnd then
        print("⏳ COOLDOWN: "..math.floor((CooldownEnd-CurrentTime)/60).." mins left")
        return
    end

    local LastCheckTime = os.time()
    local MusicVolume = LoadData(SAVE_KEY_VOLUME, 500)
    local CurrentSound = nil
    local VolNumTextMain, VolFillMain, VolFillMenu, VolNumMenu
    local FPSPingLabel, ESPBtn
    local ESP_Enabled = false
    local Buttons_Locked = false
    local Hue = 0
    local FrameCount = 0
    local LastFPSUpdate = os.clock()
    local ESP_Labels = {}

    local function ClearAllESP()
        for _,P in pairs(Players:GetPlayers()) do
            if P and P.Character then
                pcall(function()
                    if P.Character:FindFirstChild("BLUE_Outline") then P.Character.BLUE_Outline:Destroy() end
                    if P.Character:FindFirstChild("ESP_NameTag") then P.Character.ESP_NameTag:Destroy() end
                end)
            end
        end
        pcall(function()
            for _,D in pairs(workspace:GetDescendants()) do
                if D.Name == "BLUE_Outline" or D.Name == "ESP_NameTag" then D:Destroy() end
            end
        end)
        table.clear(ESP_Labels)
    end

    local function SetupDeathCheck()
        local function CheckCharacter(Char)
            if not Char then return end
            local Hum = Char:WaitForChild("Humanoid", 10)
            if not Hum then return end
            Hum.Died:Connect(function()
                if ESP_Enabled then
                    ESP_Enabled = false
                    ESPBtn.Text = "ESP: OFF"
                    ESPBtn.BackgroundColor3 = Color3.fromRGB(180,40,40)
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
        BoomGuiBg.Size = UDim2.new(1,0,1,0)
        BoomGuiBg.BackgroundTransparency = 1
        BoomGuiBg.Image = CUSTOM_GUI_BG
        BoomGuiBg.Parent = BoomFrame
        AddRainbowGlow(BoomFrame,4)

        local CloseTop = Instance.new("TextButton")
        CloseTop.Size = UDim2.new(0,30,0,30)
        CloseTop.Position = UDim2.new(1,-35,0,5)
        CloseTop.BackgroundColor3 = Color3.fromRGB(170,30,30)
        CloseTop.Text = "✕"
        CloseTop.TextColor3 = Color3.new(1,1,1)
        CloseTop.Font = Enum.Font.GothamBold
        CloseTop.Parent = BoomFrame
        CloseTop.MouseButton1Click:Connect(ToggleBoomboxMenu)

        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1,-70,0,40)
        Title.Position = UDim2.new(0,12,0,8)
        Title.BackgroundTransparency = 1
        Title.Text = "🎵 BOOMBOX & VOLUME"
        Title.TextColor3 = Color3.new(1,1,1)
        Title.Font = Enum.Font.GothamBold
        Title.TextScaled = true
        Title.Parent = BoomFrame

        local Input = Instance.new("TextBox")
        Input.Size = UDim2.new(1,-40,0,45)
        Input.Position = UDim2.new(0,20,0,55)
        Input.BackgroundColor3 = Color3.fromRGB(35,35,35)
        Input.PlaceholderText = "Paste Sound ID here..."
        Input.TextColor3 = Color3.new(1,1,1)
        Input.Font = Enum.Font.Gotham
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
        VolLabel.Parent = BoomFrame

        VolNumMenu = Instance.new("TextLabel")
        VolNumMenu.Size = UDim2.new(0,60,0,30)
        VolNumMenu.Position = UDim2.new(1,-80,0,110)
        VolNumMenu.BackgroundTransparency = 1
        VolNumMenu.Text = tostring(math.floor(MusicVolume+0.5))
        VolNumMenu.TextColor3 = Color3.new(1,1,1)
        VolNumMenu.Font = Enum.Font.GothamBold
        VolNumMenu.Parent = BoomFrame

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
        VolBG.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then SliderActive=true end end)
        UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then SliderActive=false end end)
        UserInputService.InputChanged:Connect(function(i)
            if SliderActive and i.UserInputType == Enum.UserInputType.MouseMovement then
                local rel = math.clamp((i.Position.X - VolBG.AbsolutePosition.X)/VolBG.AbsoluteSize.X,0,1)
                UpdateVolume(math.floor(rel*VOLUME_MAX))
            end
        end)

        local PlayBtn = Instance.new("TextButton")
        PlayBtn.Size = UDim2.new(0,130,0,40)
        PlayBtn.Position = UDim2.new(0,20,0,190)
        PlayBtn.BackgroundColor3 = Color3.fromRGB(25,140,255)
        PlayBtn.Text = "▶ PLAY SOUND"
        PlayBtn.TextColor3 = Color3.new(1,1,1)
        PlayBtn.Font = Enum.Font.GothamBold
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
        StopBtn.Parent = BoomFrame
        Instance.new("UICorner", StopBtn).CornerRadius = UDim.new(0,8)
        AddRainbowGlow(StopBtn,2)

        PlayBtn.MouseButton1Click:Connect(function() if Input.Text~="" then PlaySound(Input.Text) end end)
        StopBtn.MouseButton1Click:Connect(function() if CurrentSound then CurrentSound:Destroy() end end)
    end

    -- CONSOLE MENU
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
        CloseTop.Font = Enum.Font.GothamBold
        CloseTop.Parent = Frame
        CloseTop.MouseButton1Click:Connect(ToggleConsole)

        local Output = Instance.new("TextLabel")
        Output.Size = UDim2.new(1,-30,0,40)
        Output.Position = UDim2.new(0,15,0,45)
        Output.BackgroundTransparency = 1
        Output.Text = "Paste script code below..."
        Output.TextColor3 = Color3.fromRGB(0,255,120)
        Output.Font = Enum.Font.Code
        Output.TextScaled = true
        Output.Parent = Frame

        local Input = Instance.new("TextBox")
        Input.Size = UDim2.new(1,-30,0,130)
        Input.Position = UDim2.new(0,15,0,95)
        Input.BackgroundColor3 = Color3.fromRGB(45,45,45)
        Input.PlaceholderText = "Paste your script here..."
        Input.TextColor3 = Color3.new(1,1,1)
        Input.Font = Enum.Font.Code
        Input.MultiLine = true
        Input.Parent = Frame
        Instance.new("UICorner", Input).CornerRadius = UDim.new(0,8)
        AddRainbowGlow(Input,2)

        local ExecBtn = Instance.new("TextButton")
        ExecBtn.Size = UDim2.new(0,120,0,40)
        ExecBtn.Position = UDim2.new(0,15,0,240)
        ExecBtn.BackgroundColor3 = Color3.fromRGB(20,150,70)
        ExecBtn.Text = "▶ EXECUTE"
        ExecBtn.TextColor3 = Color3.new(1,1,1)
        ExecBtn.Font = Enum.Font.GothamBold
        ExecBtn.Parent = Frame
        Instance.new("UICorner", ExecBtn).CornerRadius = UDim.new(0,8)
        AddRainbowGlow(ExecBtn,2)

        local ClearBtn = Instance.new("TextButton")
        ClearBtn.Size = UDim2.new(0,120,0,40)
        ClearBtn.Position = UDim2.new(0,150,0,240)
        ClearBtn.BackgroundColor3 = Color3.fromRGB(180,120,20)
        ClearBtn.Text = "🗑️ CLEAR"
        ClearBtn.TextColor3 = Color3.new(1,1,1)
        ClearBtn.Font = Enum.Font.GothamBold
        ClearBtn.Parent = Frame
        Instance.new("UICorner", ClearBtn).CornerRadius = UDim.new(0,8)
        AddRainbowGlow(ClearBtn,2)

        ExecBtn.MouseButton1Click:Connect(function()
            local code = Input.Text
            if code=="" then Output.Text="⚠️ Nothing to run!" return end
            local load = loadstring or load
            local f,e = load(code)
            if not f then Output.Text="❌ ERROR: "..tostring(e) return end
            local ok,err = pcall(f)
            Output.Text = ok and "✅ SUCCESS!" or "❌ ERROR: "..tostring(err)
        end)
        ClearBtn.MouseButton1Click:Connect(function() Input.Text="" Output.Text="✅ Cleared!" end)
    end

    -- MAIN UI
    local FULL_SIZE = UDim2.new(0,680,0,155)
    local MINI_SIZE = UDim2.new(0,110,0,36)
    local MainUI = Instance.new("ScreenGui")
    MainUI.Name = "BLUE_MODE_HUB"
    MainUI.ResetOnSpawn = false
    MainUI.DisplayOrder = PRIORITY.MAIN
    MainUI.Parent = GuiContainer

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = FULL_SIZE
    MainFrame.Position = UDim2.new(0,20,0,0.05)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
    MainFrame.Active = true
    MainFrame.Parent = MainUI
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,8)
    AddRainbowGlow(MainFrame,5)

    local DragHandle = Instance.new("TextButton")
    DragHandle.Size = UDim2.new(1,-30,0,22)
    DragHandle.BackgroundColor3 = Color3.fromRGB(60,140,220)
    DragHandle.Text = "made by BLUE_MODE | DRAG HERE"
    DragHandle.TextColor3 = Color3.new(1,1,1)
    DragHandle.Font = Enum.Font.GothamBold
    DragHandle.TextScaled = true
    DragHandle.Parent = MainFrame
    AddRainbowGlow(DragHandle,2)

    local TimerLabel = Instance.new("TextLabel")
    TimerLabel.Size = UDim2.new(0,120,1,0)
    TimerLabel.Position = UDim2.new(1,-125,0,0)
    TimerLabel.BackgroundTransparency = 1
    TimerLabel.Text = "00:00:00 / 12:00"
    TimerLabel.TextColor3 = Color3.new(1,1,1)
    TimerLabel.Font = Enum.Font.GothamBold
    TimerLabel.TextScaled = true
    TimerLabel.TextXAlignment = Enum.TextXAlignment.Right
    TimerLabel.Parent = DragHandle

    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.new(0,22,1,0)
    MinBtn.Position = UDim2.new(1,-22,0,0)
    MinBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
    MinBtn.Text = "➖"
    MinBtn.TextColor3 = Color3.new(1,1,1)
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.Parent = MainFrame
    AddRainbowGlow(MinBtn,2)

    -- ESP BUTTON: RED=OFF / GREEN=ON
    ESPBtn = Instance.new("TextButton")
    ESPBtn.Size = UDim2.new(0,85,0,30)
    ESPBtn.Position = UDim2.new(0,10,0,30)
    ESPBtn.BackgroundColor3 = Color3.fromRGB(180,40,40) -- RED OFF
    ESPBtn.Text = "ESP: OFF"
    ESPBtn.TextColor3 = Color3.new(1,1,1)
    ESPBtn.Font = Enum.Font.GothamBold
    ESPBtn.TextScaled = true
    ESPBtn.Parent = MainFrame
    Instance.new("UICorner", ESPBtn).CornerRadius = UDim.new(0,6)
    AddRainbowGlow(ESPBt,2)

    local YouTubeBtn = Instance.new("TextButton")
    YouTubeBtn.Size = UDim2.new(0,95,0,30)
    YouTubeBtn.Position = UDim2.new(0,100,0,30)
    YouTubeBtn.BackgroundColor3 = Color3.fromRGB(200,30,30)
    YouTubeBtn.Text = "📺 YT"
    YouTubeBtn.TextColor3 = Color3.new(1,1,1)
    YouTubeBtn.Font = Enum.Font.GothamBold
    YouTubeBtn.TextScaled = true
    YouTubeBtn.Parent = MainFrame
    Instance.new("UICorner", YouTubeBtn).CornerRadius = UDim.new(0,6)
    AddRainbowGlow(YouTubeBtn,2)

    local MusicBtn = Instance.new("TextButton")
    MusicBtn.Size = UDim2.new(0,90,0,30)
    MusicBtn.Position = UDim2.new(0,200,0,30)
    MusicBtn.BackgroundColor3 = Color3.fromRGB(40,80,160)
    MusicBtn.Text = "🎵 MUSIC"
    MusicBtn.TextColor3 = Color3.new(1,1,1)
    MusicBtn.Font = Enum.Font.GothamBold
    MusicBtn.TextScaled = true
    MusicBtn.Parent = MainFrame
    Instance.new("UICorner", MusicBtn).CornerRadius = UDim.new(0,6)
    AddRainbowGlow(MusicBtn,2)

    local LockBtn = Instance.new("TextButton")
    LockBtn.Size = UDim2.new(0,90,0,30)
    LockBtn.Position = UDim2.new(0,300,0,30)
    LockBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    LockBtn.Text = "🔓 UNLOCK"
    LockBtn.TextColor3 = Color3.new(1,1,1)
    LockBtn.Font = Enum.Font.GothamBold
    LockBtn.TextScaled = true
    LockBtn.Parent = MainFrame
    Instance.new("UICorner", LockBtn).CornerRadius = UDim.new(0,6)
    AddRainbowGlow(LockBtn,2)

    local ConsoleBtn = Instance.new("TextButton")
    ConsoleBtn.Size = UDim2.new(0,110,0,30)
    ConsoleBtn.Position = UDim2.new(0,400,0,30)
    ConsoleBtn.BackgroundColor3 = Color3.fromRGB(30,120,90)
    ConsoleBtn.Text = "💻 CONSOLE"
    ConsoleBtn.TextColor3 = Color3.new(1,1,1)
    ConsoleBtn.Font = Enum.Font.GothamBold
    ConsoleBtn.TextScaled = true
    ConsoleBtn.Parent = MainFrame
    Instance.new("UICorner", ConsoleBtn).CornerRadius = UDim.new(0,6)
    AddRainbowGlow(ConsoleBtn,2)

    local ExitBtn = Instance.new("TextButton")
    ExitBtn.Size = UDim2.new(0,90,0,30)
    ExitBtn.Position = UDim2.new(0,520,0,30)
    ExitBtn.BackgroundColor3 = Color3.fromRGB(140,20,20)
    ExitBtn.Text = "🗑️ EXIT"
    ExitBtn.TextColor3 = Color3.new(1,1,1)
    ExitBtn.Font = Enum.Font.GothamBold
    ExitBtn.TextScaled = true
    ExitBtn.Parent = MainFrame
    Instance.new("UICorner", ExitBtn).CornerRadius = UDim.new(0,6)
    AddRainbowGlow(ExitBtn,2)

    -- VOLUME BAR
    local VolLabelMain = Instance.new("TextLabel")
    VolLabelMain.Size = UDim2.new(0,100,0,25)
    VolLabelMain.Position = UDim2.new(0,10,0,65)
    VolLabelMain.BackgroundTransparency = 1
    VolLabelMain.Text = "🔊 VOLUME:"
    VolLabelMain.TextColor3 = Color3.new(1,1,1)
    VolLabelMain.Font = Enum.Font.Gotham
    VolLabelMain.TextScaled = true
    VolLabelMain.Parent = MainFrame

    VolNumTextMain = Instance.new("TextLabel")
    VolNumTextMain.Size = UDim2.new(0,50,0,25)
    VolNumTextMain.Position = UDim2.new(0,115,0,65)
    VolNumTextMain.BackgroundTransparency = 1
    VolNumTextMain.Text = tostring(math.floor(MusicVolume+0.5))
    VolNumTextMain.TextColor3 = Color3.new(1,1,1)
    VolNumTextMain.Font = Enum.Font.GothamBold
    VolNumTextMain.TextScaled = true
    VolNumTextMain.Parent = MainFrame

    local VolBGMain = Instance.new("Frame")
    VolBGMain.Size = UDim2.new(0,150,0,18)
    VolBGMain.Position = UDim2.new(0,175,0,67)
    VolBGMain.BackgroundColor3 = Color3.fromRGB(50,50,50)
    VolBGMain.Active = true
    VolBGMain.Parent = MainFrame
    Instance.new("UICorner", VolBGMain).CornerRadius = UDim.new(0,9)
    AddRainbowGlow(VolBGMain,2)

    VolFillMain = Instance.new("Frame")
    VolFillMain.Size = UDim2.new(MusicVolume/VOLUME_MAX,0,1,0)
    VolFillMain.BackgroundColor3 = Color3.fromRGB(100,100,100)
    VolFillMain.Parent = VolBGMain
    Instance.new("UICorner", VolFillMain).CornerRadius = UDim.new(0,9)

    -- ✅ FPS/PING LABEL INSIDE MAIN UI UNDER VOLUME
    FPSPingLabel = Instance.new("TextLabel")
    FPSPingLabel.Size = UDim2.new(1,-20,0,25)
    FPSPingLabel.Position = UDim2.new(0,10,0,92)
    FPSPingLabel.BackgroundTransparency = 1
    FPSPingLabel.Font = Enum.Font.GothamBold
    FPSPingLabel.TextScaled = true
    FPSPingLabel.TextColor3 = Color3.new(1,1,1)
    FPSPingLabel.Text = "⚡ FPS: 0 | 📶 YOUR PING: 0ms | 🌐 SERVER PING: 0ms"
    FPSPingLabel.Parent = MainFrame

    -- DRAG & MINIMIZE
    local DragState = {Active=false, X=0, Y=0, PosX=0, PosY=0}
    DragHandle.InputBegan:Connect(function(i)
        GuiFocused = true
        if Buttons_Locked then return end
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            DragState.Active = true
            DragState.X = i.Position.X
            DragState.Y = i.Position.Y
            DragState.PosX = MainFrame.Position.X.Offset
            DragState.PosY = MainFrame.Position.Y.Offset
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            DragState.Active = false
            task.delay(0.2, function() GuiFocused = false end)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if DragState.Active and not Buttons_Locked and i.UserInputType == Enum.UserInputType.MouseMovement then
            MainFrame.Position = UDim2.new(0, DragState.PosX + (i.Position.X - DragState.X), 0, DragState.PosY + (i.Position.Y - DragState.Y))
        end
    end)

    LockBtn.MouseButton1Click:Connect(function()
        Buttons_Locked = not Buttons_Locked
        LockBtn.Text = Buttons_Locked and "🔒 LOCKED" or "🔓 UNLOCK"
        LockBtn.BackgroundColor3 = Buttons_Locked and Color3.fromRGB(180,40,40) or Color3.fromRGB(50,50,50)
    end)

    MinBtn.MouseButton1Click:Connect(function()
        IsMinimized = not IsMinimized
        if IsMinimized then
            MainFrame.Size = MINI_SIZE
            ESPBtn.Visible = false
            YouTubeBtn.Visible = false
            MusicBtn.Visible = false
            LockBtn.Visible = false
            ConsoleBtn.Visible = false
            ExitBtn.Visible = false
            VolLabelMain.Visible = false
            VolNumTextMain.Visible = false
            VolBGMain.Visible = false
            FPSPingLabel.Visible = false
            DragHandle.Text = ""
            MinBtn.Text = "➕"
            TimerLabel.Size = UDim2.new(1,-28,1,0)
            TimerLabel.Position = UDim2.new(0,4,0,0)
            TimerLabel.TextXAlignment = Enum.TextXAlignment.Center
        else
            MainFrame.Size = FULL_SIZE
            ESPBtn.Visible = true
            YouTubeBtn.Visible = true
            MusicBtn.Visible = true
            LockBtn.Visible = true
            ConsoleBtn.Visible = true
            ExitBtn.Visible = true
            VolLabelMain.Visible = true
            VolNumTextMain.Visible = true
            VolBGMain.Visible = true
            FPSPingLabel.Visible = true
            DragHandle.Text = "made by BLUE_MODE | DRAG HERE"
            MinBtn.Text = "➖"
            TimerLabel.Size = UDim2.new(0,120,1,0)
            TimerLabel.Position = UDim2.new(1,-125,0,0)
            TimerLabel.TextXAlignment = Enum.TextXAlignment.Right
        end
    end)

    -- ESP TOGGLE: RED=OFF / GREEN=ON
    ESPBtn.MouseButton1Click:Connect(function()
        ESP_Enabled = not ESP_Enabled
        ESPBtn.Text = ESP_Enabled and "ESP: ON" or "ESP: OFF"
        ESPBtn.BackgroundColor3 = ESP_Enabled and Color3.fromRGB(25,120,25) or Color3.fromRGB(180,40,40)
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

    SetupDeathCheck()

    -- MAIN LOOP + RAINBOW + ESP TEXT OUTLINE
    RunService.Heartbeat:Connect(function(Delta)
        if not MainUI or not MainUI.Parent then return end

        -- FPS/PING UPDATE
        FrameCount += 1
        local Now = os.clock()
        if Now - LastFPSUpdate >= 1 then
            local FPS = math.floor(FrameCount / (Now - LastFPSUpdate))
            local YourPing = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            local ServerPing = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue() * 1.1)
            FPSPingLabel.Text = string.format("⚡ FPS: %d | 📶 YOUR PING: %dms | 🌐 SERVER PING: %dms", FPS, YourPing, ServerPing)
            FrameCount = 0
            LastFPSUpdate = Now
        end

        -- TIMER
        local TimeNow = os.time()
        UsedTime = UsedTime + math.max(0, TimeNow - LastCheckTime)
        LastCheckTime = TimeNow
        SaveData(SAVE_KEY_USED, UsedTime)
        local Remaining = math.max(0, USAGE_LIMIT - UsedTime)
        local h = math.floor(Remaining/3600)
        local m = math.floor((Remaining%3600)/60)
        local s = Remaining%60
        TimerLabel.Text = string.format("%02d:%02d:%02d / 12:00",h,m,s)

        if Remaining <= 0 then
            SaveData(SAVE_KEY_COOLDOWN, os.time() + COOLDOWN)
            pcall(function() delfile(SAVE_KEY_USED..".txt") end)
            ExitBtn:Fire()
            return
        end

        -- RAINBOW EFFECTS
        Hue = (Hue + Delta*0.5) % 1
        local Rainbow = Color3.fromHSV(Hue,1,1)
        for _,e in pairs(GuiElements) do e.Color = Rainbow end
        for _,Tag in pairs(ESP_Labels) do
            if Tag then Tag.TextColor3 = Rainbow end
            if Tag and Tag:FindFirstChild("RainbowAura") then Tag.RainbowAura.Color = Rainbow end
        end
        if VolFillMain then VolFillMain.BackgroundColor3 = Rainbow end
        if VolFillMenu then VolFillMenu.BackgroundColor3 = Rainbow end
        TimerLabel.TextColor3 = Rainbow
        FPSPingLabel.TextColor3 = Rainbow

        -- ESP WITH RAINBOW TEXT OUTLINE
        if not ESP_Enabled then return end
        for _,P in pairs(Players:GetPlayers()) do
            if P == LocalPlayer then continue end
            local Char = P.Character
            if not Char then continue end
            local Hum = Char:FindFirstChildOfClass("Humanoid")
            if not Hum or Hum.Health <= 0 then continue end

            -- PLAYER OUTLINE
            local Outline = Char:FindFirstChild("BLUE_Outline") or Instance.new("Highlight")
            Outline.Name = "BLUE_Outline"
            Outline.Adornee = Char
            Outline.FillTransparency = 1
            Outline.OutlineTransparency = 0
            Outline.OutlineColor = Rainbow
            Outline.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            Outline.Parent = Char

            -- ✅ ESP TEXT WITH FULL RAINBOW OUTLINE
            local Head = Char:FindFirstChild("Head")
            if Head then
                local NameTag = Char:FindFirstChild("ESP_NameTag")
                if not NameTag then
                    NameTag = Instance.new("BillboardGui")
                    NameTag.Name = "ESP_NameTag"
                    NameTag.AlwaysOnTop = true
                    NameTag.DisplayOrder = PRIORITY.ESP_TEXT
                    NameTag.Size = UDim2.new(0, 200, 0, 50)
                    NameTag.StudsOffset = Vector3.new(0, 3.5, 0)
                    NameTag.MaxDistance = 1000
                    NameTag.Parent = Head

                    local TagText = Instance.new("TextLabel")
                    TagText.Size = UDim2.new(1,0,1,0)
                    TagText.BackgroundTransparency = 1
                    TagText.Font = Enum.Font.GothamBold
                    TagText.TextScaled = true
                    TagText.Text = P.Name.."\n"..math.floor(Hum.Health).." HP"
                    TagText.TextColor3 = Rainbow
                    TagText.TextStrokeTransparency = 0
                    TagText.Parent = NameTag

                    -- MATCHING RAINBOW OUTLINE
                    AddRainbowGlow(TagText, 2.5)
                    table.insert(ESP_Labels, TagText)
                else
                    local TagText = NameTag:FindFirstChildWhichIsA("TextLabel")
                    if TagText then TagText.Text = P.Name.."\n"..math.floor(Hum.Health).." HP" end
                end
            end
        end
    end)
end
print("✅ BLUE MODE HUB FULLY UPDATED & READY")
