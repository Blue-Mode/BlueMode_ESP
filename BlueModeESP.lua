-- ==============================================
-- 🔵 BLUE MODE HUB | FINAL FIXED VERSION
-- ✅ OK BUTTON NO LONGER DISAPPEARS
-- ✅ DELTA EXECUTOR COMPATIBLE
-- ✅ NO TYPOS, NO CRASHES
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
    STARTUP = 800, MAIN = 799, BOOMBOX = 798, CONSOLE = 797, COMMAND = 796
}

local USAGE_LIMIT = 12 * 3600
local YOUTUBE_LINK = "https://youtube.com/@blue_mode?si=aCGyj0FnwCMtTP1M"
local SAVE_KEY_USED = "BlueMode_UsedTime_v21"
local SAVE_KEY_COOLDOWN = "BlueMode_CooldownEnd_v21"
local SAVE_KEY_VOLUME = "BlueMode_Volume_v21"
local VOLUME_MAX = 1000

local BoomboxUI_Open, ConsoleUI_Open, CommandUI_Open = false, false, false
local CurrentBoomboxUI, CurrentConsoleUI, CurrentCommandUI = nil, nil, nil
local IsMinimized, GuiFocused = false, false
local GuiElements = {}
local ESP_Enabled, Buttons_Locked = false, false
local Hue = 0

-- ✅ SAFE DATA FUNCTIONS
local function SaveData(key, value) pcall(function() writefile(key..".txt", tostring(value)) end) end
local function LoadData(key, default) local v=nil; pcall(function() v=readfile(key..".txt") end); return tonumber(v) or default end

-- ✅ RAINBOW GLOW
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

-- ✅ DECLARE FIRST SO NO CRASH
local LoadMainHub

-- ==============================================
-- 🚀 STARTUP SCREEN
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

local StartupGuiBg = Instance.new("ImageLabel")
StartupGuiBg.Size = UDim2.new(1,0,1,0)
StartupGuiBg.BackgroundTransparency = 1
StartupGuiBg.Image = CUSTOM_GUI_BG
StartupGuiBg.ScaleType = Enum.ScaleType.Stretch
StartupGuiBg.Parent = StartupBox

local StartupBorder = Instance.new("UIStroke")
StartupBorder.Thickness = 5
StartupBorder.Parent = StartupBox

local StartupTitle = Instance.new("TextLabel")
StartupTitle.Size = UDim2.new(1,-40,0,50)
StartupTitle.Position = UDim2.new(0,20,0,15)
StartupTitle.BackgroundTransparency = 1
StartupTitle.Font = Enum.Font.GothamBlack
StartupTitle.TextScaled = true
StartupTitle.Text = "🔵 BLUE MODE HUB"
StartupTitle.Parent = StartupBox

local UpdateList = Instance.new("TextLabel")
UpdateList.Size = UDim2.new(1,-50,0,180)
UpdateList.Position = UDim2.new(0,25,0,115)
UpdateList.BackgroundTransparency = 1
UpdateList.Font = Enum.Font.Gotham
UpdateList.TextScaled = true
UpdateList.TextWrapped = true
UpdateList.Text = [[• OK BUTTON NOW WORKS PERFECTLY
• NO MORE INSTANT DISAPPEARING
• FRIEND RAINBOW DOT + OWNER CROWN
• FPS / PING DISPLAY ADDED
• BOOMBOX VOLUME 0-1000]]
UpdateList.Parent = StartupBox

local StartupTimerLabel = Instance.new("TextLabel")
StartupTimerLabel.Size = UDim2.new(1,-40,0,45)
StartupTimerLabel.Position = UDim2.new(0,20,0,310)
StartupTimerLabel.BackgroundTransparency = 1
StartupTimerLabel.Font = Enum.Font.GothamBold
StartupTimerLabel.TextScaled = true
StartupTimerLabel.Text = "TIME REMAINING: 12:00:00"
StartupTimerLabel.Parent = StartupBox

local OkBtn = Instance.new("TextButton")
OkBtn.Size = UDim2.new(0,260,0,60)
OkBtn.Position = UDim2.new(0.5,-130,0,385)
OkBtn.BackgroundColor3 = Color3.fromRGB(15,110,230)
OkBtn.Font = Enum.Font.GothamBold
OkBtn.TextScaled = true
OkBtn.Text = "✓ OK / OPEN MAIN HUB"
OkBtn.TextColor3 = Color3.new(1,1,1)
OkBtn.Parent = StartupBox
Instance.new("UICorner", OkBtn).CornerRadius = UDim.new(0,16)
AddRainbowGlow(OkBtn, 3)

local UsedTime = LoadData(SAVE_KEY_USED, 0)
RunService.Heartbeat:Connect(function(dt)
    Hue = (Hue + dt * 0.3) % 1
    local Col = Color3.fromHSV(Hue,1,1)
    StartupBorder.Color = Col
    StartupTitle.TextColor3 = Col
    local Rem = math.max(0, USAGE_LIMIT - UsedTime)
    StartupTimerLabel.Text = string.format("TIME REMAINING: %02d:%02d:%02d", Rem/3600, (Rem%3600)/60, Rem%60)
end)

-- ✅ FIXED OK BUTTON — NO CRASH
OkBtn.MouseButton1Click:Connect(function()
    pcall(function() StartupUI:Destroy() end)
    task.wait(0.1) -- Small delay prevents executor crash
    LoadMainHub()
end)

print("✅ STARTUP LOADED — CLICK OK TO OPEN HUB")

-- ==============================================
-- 📦 MAIN HUB LOAD FUNCTION
-- ==============================================
LoadMainHub = function()
    local CurrentTime = os.time()
    local CooldownEnd = LoadData(SAVE_KEY_COOLDOWN, 0)
    if CurrentTime < CooldownEnd then print("⏳ Cooldown active!") return end

    local MusicVolume = LoadData(SAVE_KEY_VOLUME, 500)
    local CurrentSound = nil
    local VolNumTextMain, VolFillMain, VolFillMenu, VolNumMenu, ESPBtn, CommandBtn
    local LocalChar = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

    -- ✅ CLEANUP OLD ESP
    local function ClearAllESP()
        for _,P in pairs(Players:GetPlayers()) do
            if P and P.Character then
                pcall(function()
                    P.Character:FindFirstChild("BLUE_Outline"):Destroy()
                    P.Character:FindFirstChild("FriendRainbowDot"):Destroy()
                    P.Character:FindFirstChild("OwnerCrown"):Destroy()
                end)
            end
        end
    end

    -- ✅ VOLUME CONTROL
    local function UpdateVolume(newVol)
        MusicVolume = math.clamp(tonumber(newVol) or 500, 0, VOLUME_MAX)
        SaveData(SAVE_KEY_VOLUME, MusicVolume)
        if CurrentSound then CurrentSound.Volume = MusicVolume/VOLUME_MAX end
        local Val = tostring(math.floor(MusicVolume+0.5))
        if VolNumTextMain then VolNumTextMain.Text = Val end
        if VolFillMain then VolFillMain.Size = UDim2.new(MusicVolume/VOLUME_MAX,0,1,0) end
        if VolNumMenu then VolNumMenu.Text = Val end
        if VolFillMenu then VolFillMenu.Size = UDim2.new(MusicVolume/VOLUME_MAX,0,1,0) end
    end

    -- ✅ BOOMBOX MENU
    local function ToggleBoomboxMenu()
        if BoomboxUI_Open then
            if CurrentBoomboxUI then CurrentBoomboxUI:Destroy() end
            BoomboxUI_Open = false
            return
        end
        GuiFocused = true
        local BoomUI = Instance.new("ScreenGui")
        BoomUI.Name = "BLUE_MODE_BOOMBOX"
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

        local CloseBtn = Instance.new("TextButton")
        CloseBtn.Size = UDim2.new(0,30,0,30)
        CloseBtn.Position = UDim2.new(1,-35,0,5)
        CloseBtn.BackgroundColor3 = Color3.fromRGB(170,30,30)
        CloseBtn.Text = "✕"
        CloseBtn.TextColor3 = Color3.new(1,1,1)
        CloseBtn.Font = Enum.Font.GothamBold
        CloseBtn.Parent = BoomFrame
        CloseBtn.MouseButton1Click:Connect(function() ToggleBoomboxMenu() end)

        local Input = Instance.new("TextBox")
        Input.Size = UDim2.new(1,-40,0,45)
        Input.Position = UDim2.new(0,20,0,55)
        Input.BackgroundColor3 = Color3.fromRGB(35,35,35)
        Input.PlaceholderText = "Paste Sound ID..."
        Input.TextColor3 = Color3.new(1,1,1)
        Input.Parent = BoomFrame
        Instance.new("UICorner", Input).CornerRadius = UDim.new(0,8)

        VolNumMenu = Instance.new("TextLabel")
        VolNumMenu.Size = UDim2.new(0,60,0,30)
        VolNumMenu.Position = UDim2.new(1,-80,0,110)
        VolNumMenu.BackgroundTransparency = 1
        VolNumMenu.Text = tostring(math.floor(MusicVolume+0.5))
        VolNumMenu.TextColor3 = Color3.new(1,1,1)
        VolNumMenu.Parent = BoomFrame

        local VolBG = Instance.new("Frame")
        VolBG.Size = UDim2.new(1,-40,0,24)
        VolBG.Position = UDim2.new(0,20,0,145)
        VolBG.BackgroundColor3 = Color3.fromRGB(50,50,50)
        VolBG.Active = true
        VolBG.Parent = BoomFrame
        Instance.new("UICorner", VolBG).CornerRadius = UDim.new(0,12)

        VolFillMenu = Instance.new("Frame")
        VolFillMenu.Size = UDim2.new(MusicVolume/VOLUME_MAX,0,1,0)
        VolFillMenu.BackgroundColor3 = Color3.fromRGB(100,100,100)
        VolFillMenu.Parent = VolBG
        Instance.new("UICorner", VolFillMenu).CornerRadius = UDim.new(0,12)

        local PlayBtn = Instance.new("TextButton")
        PlayBtn.Size = UDim2.new(0,130,0,40)
        PlayBtn.Position = UDim2.new(0,20,0,190)
        PlayBtn.BackgroundColor3 = Color3.fromRGB(25,140,255)
        PlayBtn.Text = "▶ PLAY"
        PlayBtn.TextColor3 = Color3.new(1,1,1)
        PlayBtn.Font = Enum.Font.GothamBold
        PlayBtn.Parent = BoomFrame
        Instance.new("UICorner", PlayBtn).CornerRadius = UDim.new(0,8)

        local StopBtn = Instance.new("TextButton")
        StopBtn.Size = UDim2.new(0,130,0,40)
        StopBtn.Position = UDim2.new(0,170,0,190)
        StopBtn.BackgroundColor3 = Color3.fromRGB(200,30,30)
        StopBtn.Text = "⏹ STOP"
        StopBtn.TextColor3 = Color3.new(1,1,1)
        StopBtn.Font = Enum.Font.GothamBold
        StopBtn.Parent = BoomFrame
        Instance.new("UICorner", StopBtn).CornerRadius = UDim.new(0,8)

        PlayBtn.MouseButton1Click:Connect(function()
            if Input.Text ~= "" then
                pcall(function() if CurrentSound then CurrentSound:Destroy() end end)
                CurrentSound = Instance.new("Sound")
                CurrentSound.SoundId = "rbxassetid://"..Input.Text:gsub("%D","")
                CurrentSound.Volume = MusicVolume/VOLUME_MAX
                CurrentSound.Looped = true
                CurrentSound.Parent = SoundService
                CurrentSound:Play()
            end
        end)
        StopBtn.MouseButton1Click:Connect(function() pcall(function() CurrentSound:Destroy() end) end)
    end

    -- ✅ CONSOLE MENU
    local function ToggleConsole()
        if ConsoleUI_Open then if CurrentConsoleUI then CurrentConsoleUI:Destroy() end; ConsoleUI_Open=false; return end
        GuiFocused = true
        local ConUI = Instance.new("ScreenGui")
        ConUI.Name = "BLUE_MODE_CONSOLE"
        ConUI.ResetOnSpawn = false
        ConUI.DisplayOrder = PRIORITY.CONSOLE
        ConUI.Parent = GuiContainer
        CurrentConsoleUI = ConUI; ConsoleUI_Open=true

        local ConFrame = Instance.new("Frame")
        ConFrame.Size = UDim2.new(0,450,0,320)
        ConFrame.Position = UDim2.new(0.5,-225,0.5,-160)
        ConFrame.BackgroundColor3 = Color3.fromRGB(22,22,22)
        ConFrame.Active = true
        ConFrame.Parent = ConUI
        Instance.new("UICorner", ConFrame).CornerRadius = UDim.new(0,12)
        AddRainbowGlow(ConFrame,5)

        local CloseBtn = Instance.new("TextButton")
        CloseBtn.Size = UDim2.new(0,32,0,32)
        CloseBtn.Position = UDim2.new(1,-37,0,6)
        CloseBtn.BackgroundColor3 = Color3.fromRGB(170,30,30)
        CloseBtn.Text = "✕"
        CloseBtn.Parent = ConFrame
        CloseBtn.MouseButton1Click:Connect(function() ToggleConsole() end)

        local Input = Instance.new("TextBox")
        Input.Size = UDim2.new(1,-30,0,130)
        Input.Position = UDim2.new(0,15,0,95)
        Input.BackgroundColor3 = Color3.fromRGB(45,45,45)
        Input.PlaceholderText = "Paste script here..."
        Input.TextColor3 = Color3.new(1,1,1)
        Input.MultiLine = true
        Input.Parent = ConFrame
        Instance.new("UICorner", Input).CornerRadius = UDim.new(0,8)

        local ExecBtn = Instance.new("TextButton")
        ExecBtn.Size = UDim2.new(0,120,0,40)
        ExecBtn.Position = UDim2.new(0,15,0,240)
        ExecBtn.BackgroundColor3 = Color3.fromRGB(20,150,70)
        ExecBtn.Text = "▶ EXECUTE"
        ExecBtn.TextColor3 = Color3.new(1,1,1)
        ExecBtn.Parent = ConFrame
        Instance.new("UICorner", ExecBtn).CornerRadius = UDim.new(0,8)

        ExecBtn.MouseButton1Click:Connect(function()
            local Code = Input.Text
            if Code == "" then return end
            local Compile = loadstring or load
            if not Compile then return end
            local Func, Err = Compile(Code)
            if Func then pcall(Func) end
        end)
    end

    -- ✅ COMMAND MENU
    local function ToggleCommandMenu()
        if CommandUI_Open then if CurrentCommandUI then CurrentCommandUI:Destroy() end; CommandUI_Open=false; return end
        GuiFocused = true
        local CmdUI = Instance.new("ScreenGui")
        CmdUI.Name = "BLUE_MODE_COMMAND"
        CmdUI.ResetOnSpawn = false
        CmdUI.DisplayOrder = PRIORITY.COMMAND
        CmdUI.Parent = GuiContainer
        CurrentCommandUI = CmdUI; CommandUI_Open=true

        local CmdFrame = Instance.new("Frame")
        CmdFrame.Size = UDim2.new(0,320,0,250)
        CmdFrame.Position = UDim2.new(0.5,-160,0.5,-125)
        CmdFrame.BackgroundColor3 = Color3.fromRGB(22,22,22)
        CmdFrame.Active = true
        CmdFrame.Parent = CmdUI
        Instance.new("UICorner", CmdFrame).CornerRadius = UDim.new(0,12)
        AddRainbowGlow(CmdFrame,4)

        local CloseBtn = Instance.new("TextButton")
        CloseBtn.Size = UDim2.new(0,30,0,30)
        CloseBtn.Position = UDim2.new(1,-35,0,5)
        CloseBtn.BackgroundColor3 = Color3.fromRGB(170,30,30)
        CloseBtn.Text = "✕"
        CloseBtn.Parent = CmdFrame
        CloseBtn.MouseButton1Click:Connect(function() ToggleCommandMenu() end)

        local RunBtn = Instance.new("TextButton")
        RunBtn.Size = UDim2.new(0,130,0,40)
        RunBtn.Position = UDim2.new(0,20,0,160)
        RunBtn.BackgroundColor3 = Color3.fromRGB(25,140,255)
        RunBtn.Text = "▶ RUN INFINITE YIELD"
        RunBtn.TextColor3 = Color3.new(1,1,1)
        RunBtn.Font = Enum.Font.GothamBold
        RunBtn.Parent = CmdFrame
        Instance.new("UICorner", RunBtn).CornerRadius = UDim.new(0,8)

        RunBtn.MouseButton1Click:Connect(function()
            pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/ic3w0lf22/Infinite-Yield/main/Infinite%20Yield.lua"))()
            end)
        end)
    end

    -- ✅ MAIN HUB UI
    local MainUI = Instance.new("ScreenGui")
    MainUI.Name = "BLUE_MODE_HUB"
    MainUI.ResetOnSpawn = false
    MainUI.DisplayOrder = PRIORITY.MAIN
    MainUI.Parent = GuiContainer

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0,680,0,105)
    MainFrame.Position = UDim2.new(0,20,0.5,-52)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
    MainFrame.Active = true
    MainFrame.Parent = MainUI
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,8)
    AddRainbowGlow(MainFrame,5)

    local DragHandle = Instance.new("TextButton")
    DragHandle.Size = UDim2.new(1,-30,0,22)
    DragHandle.BackgroundColor3 = Color3.fromRGB(60,140,220)
    DragHandle.Text = "🔵 BLUE MODE HUB | DRAG HERE"
    DragHandle.TextColor3 = Color3.new(1,1,1)
    DragHandle.Font = Enum.Font.GothamBold
    DragHandle.TextScaled = true
    DragHandle.Parent = MainFrame

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

    -- ✅ FIXED TYPO: ESPBt → ESPBtn
    ESPBtn = Instance.new("TextButton")
    ESPBtn.Size = UDim2.new(0,85,0,30)
    ESPBtn.Position = UDim2.new(0,10,0,30)
    ESPBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    ESPBtn.Text = "ESP: OFF"
    ESPBtn.TextColor3 = Color3.new(1,1,1)
    ESPBtn.Font = Enum.Font.GothamBold
    ESPBtn.Parent = MainFrame
    Instance.new("UICorner", ESPBtn).CornerRadius = UDim.new(0,6)
    AddRainbowGlow(ESPBtn,2) -- ✅ NO MORE TYPO CRASH!

    local YouTubeBtn = Instance.new("TextButton")
    YouTubeBtn.Size = UDim2.new(0,95,0,30)
    YouTubeBtn.Position = UDim2.new(0,100,0,30)
    YouTubeBtn.BackgroundColor3 = Color3.fromRGB(200,30,30)
    YouTubeBtn.Text = "📺 YT"
    YouTubeBtn.TextColor3 = Color3.new(1,1,1)
    YouTubeBtn.Font = Enum.Font.GothamBold
    YouTubeBtn.Parent = MainFrame
    Instance.new("UICorner", YouTubeBtn).CornerRadius = UDim.new(0,6)

    local MusicBtn = Instance.new("TextButton")
    MusicBtn.Size = UDim2.new(0,90,0,30)
    MusicBtn.Position = UDim2.new(0,200,0,30)
    MusicBtn.BackgroundColor3 = Color3.fromRGB(40,80,160)
    MusicBtn.Text = "🎵 MUSIC"
    MusicBtn.TextColor3 = Color3.new(1,1,1)
    MusicBtn.Font = Enum.Font.GothamBold
    MusicBtn.Parent = MainFrame
    Instance.new("UICorner", MusicBtn).CornerRadius = UDim.new(0,6)

    local LockBtn = Instance.new("TextButton")
    LockBtn.Size = UDim2.new(0,90,0,30)
    LockBtn.Position = UDim2.new(0,300,0,30)
    LockBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    LockBtn.Text = "🔓 UNLOCK"
    LockBtn.TextColor3 = Color3.new(1,1,1)
    LockBtn.Font = Enum.Font.GothamBold
    LockBtn.Parent = MainFrame
    Instance.new("UICorner", LockBtn).CornerRadius = UDim.new(0,6)

    local ConsoleBtn = Instance.new("TextButton")
    ConsoleBtn.Size = UDim2.new(0,110,0,30)
    ConsoleBtn.Position = UDim2.new(0,400,0,30)
    ConsoleBtn.BackgroundColor3 = Color3.fromRGB(30,120,90)
    ConsoleBtn.Text = "💻 CONSOLE"
    ConsoleBtn.TextColor3 = Color3.new(1,1,1)
    ConsoleBtn.Font = Enum.Font.GothamBold
    ConsoleBtn.Parent = MainFrame
    Instance.new("UICorner", ConsoleBtn).CornerRadius = UDim.new(0,6)

    CommandBtn = Instance.new("TextButton")
    CommandBtn.Size = UDim2.new(0,110,0,30)
    CommandBtn.Position = UDim2.new(0,10,0,75)
    CommandBtn.BackgroundColor3 = Color3.fromRGB(120,80,30)
    CommandBtn.Text = "⚡ COMMAND"
    CommandBtn.TextColor3 = Color3.new(1,1,1)
    CommandBtn.Font = Enum.Font.GothamBold
    CommandBtn.Parent = MainFrame
    Instance.new("UICorner", CommandBtn).CornerRadius = UDim.new(0,6)

    local ExitBtn = Instance.new("TextButton")
    ExitBtn.Size = UDim2.new(0,90,0,30)
    ExitBtn.Position = UDim2.new(0,520,0,30)
    ExitBtn.BackgroundColor3 = Color3.fromRGB(140,20,20)
    ExitBtn.Text = "🗑️ EXIT"
    ExitBtn.TextColor3 = Color3.new(1,1,1)
    ExitBtn.Font = Enum.Font.GothamBold
    ExitBtn.Parent = MainFrame
    Instance.new("UICorner", ExitBtn).CornerRadius = UDim.new(0,6)

    VolNumTextMain = Instance.new("TextLabel")
    VolNumTextMain.Size = UDim2.new(0,50,0,25)
    VolNumTextMain.Position = UDim2.new(0,115,0,65)
    VolNumTextMain.BackgroundTransparency = 1
    VolNumTextMain.Text = tostring(math.floor(MusicVolume+0.5))
    VolNumTextMain.TextColor3 = Color3.new(1,1,1)
    VolNumTextMain.Parent = MainFrame

    local VolBGMain = Instance.new("Frame")
    VolBGMain.Size = UDim2.new(0,150,0,18)
    VolBGMain.Position = UDim2.new(0,175,0,67)
    VolBGMain.BackgroundColor3 = Color3.fromRGB(50,50,50)
    VolBGMain.Active = true
    VolBGMain.Parent = MainFrame
    Instance.new("UICorner", VolBGMain).CornerRadius = UDim.new(0,9)

    VolFillMain = Instance.new("Frame")
    VolFillMain.Size = UDim2.new(MusicVolume/VOLUME_MAX,0,1,0)
    VolFillMain.BackgroundColor3 = Color3.fromRGB(100,100,100)
    VolFillMain.Parent = VolBGMain
    Instance.new("UICorner", VolFillMain).CornerRadius = UDim.new(0,9)

    -- ✅ DRAG SYSTEM
    local DragState = {Active=false, StartX=0, StartY=0, PosX=0, PosY=0}
    DragHandle.InputBegan:Connect(function(Input)
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

    -- ✅ BUTTON CLICKS
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

    MusicBtn.MouseButton1Click:Connect(function() ToggleBoomboxMenu() end)
    LockBtn.MouseButton1Click:Connect(function()
        Buttons_Locked = not Buttons_Locked
        LockBtn.Text = Buttons_Locked and "🔒 LOCKED" or "🔓 UNLOCK"
        LockBtn.BackgroundColor3 = Buttons_Locked and Color3.fromRGB(180,40,40) or Color3.fromRGB(50,50,50)
    end)
    ConsoleBtn.MouseButton1Click:Connect(function() ToggleConsole() end)
    CommandBtn.MouseButton1Click:Connect(function() ToggleCommandMenu() end)

    ExitBtn.MouseButton1Click:Connect(function()
        pcall(function() if CurrentSound then CurrentSound:Destroy() end end)
        pcall(function() GuiContainer:Destroy() end)
        getgenv().BlueMode_Loaded = false
    end)

    -- ✅ FULL ESP SYSTEM
    local function IsFriend(Player)
        return Player:IsFriendsWith(LocalPlayer.UserId) or Player.Name == LocalPlayer.Name
    end

    local function GetPlayerColor(Player)
        if Player.Name == "Blue_Mode" or Player.Name == "Dwaynekean015" then
            return Color3.fromRGB(255, 215, 0) -- GOLD
        elseif IsFriend(Player) then
            return Color3.fromRGB(0, 255, 100) -- GREEN
        else
            return Color3.fromRGB(255, 50, 50) -- RED
        end
    end

    local function AddESPForPlayer(Player)
        task.spawn(function()
            if not Player or not Player.Character then return end
            local Char = Player.Character
            local Hum = Char:WaitForChild("Humanoid", 15)
            if not Hum then return end

            pcall(function() Char.BLUE_Outline:Destroy() end)
            local Outline = Instance.new("Highlight")
            Outline.Name = "BLUE_Outline"
            Outline.FillTransparency = 0.5
            Outline.OutlineTransparency = 0
            Outline.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            Outline.FillColor = GetPlayerColor(Player)
            Outline.OutlineColor = GetPlayerColor(Player)
            Outline.Adornee = Char
            Outline.Parent = Char

            -- OWNER CROWN
            if Player.Name == "Blue_Mode" or Player.Name == "Dwaynekean015" then
                pcall(function() Char.OwnerCrown:Destroy() end)
                local Crown = Instance.new("BillboardGui")
                Crown.Name = "OwnerCrown"
                Crown.Size = UDim2.new(0,30,0,30)
                Crown.StudsOffset = Vector3.new(0,3,0)
                Crown.AlwaysOnTop = true
                local Img = Instance.new("ImageLabel")
                Img.Size = UDim2.new(1,0,1,0)
                Img.BackgroundTransparency = 1
                Img.Image = "rbxassetid://10342133"
                Img.ImageColor3 = Color3.fromRGB(255,215,0)
                Img.Parent = Crown
                Crown.Adornee = Char.Head
                Crown.Parent = Char
            end

            -- FRIEND RAINBOW DOT
            if IsFriend(Player) and Player.Name ~= LocalPlayer.Name then
                pcall(function() Char.FriendRainbowDot:Destroy() end)
                local Dot = Instance.new("BillboardGui")
                Dot.Name = "FriendRainbowDot"
                Dot.Size = UDim2.new(0,12,0,12)
                Dot.StudsOffset = Vector3.new(0,2.2,0)
                Dot.AlwaysOnTop = true
                local DotFrame = Instance.new("Frame")
                DotFrame.Size = UDim2.new(1,0,1,0)
                DotFrame.BackgroundColor3 = Color3.new(1,1,1)
                Instance.new("UICorner", DotFrame).CornerRadius = UDim.new(1,0)
                DotFrame.Parent = Dot
                Dot.Adornee = Char.Head
                Dot.Parent = Char
            end
        end)
    end

    -- ✅ FPS / PING DISPLAY
    local StatsUI = Instance.new("ScreenGui")
    StatsUI.Name = "BLUE_MODE_STATS"
    StatsUI.ResetOnSpawn = false
    StatsUI.DisplayOrder = 900
    StatsUI.Parent = GuiContainer

    local StatsFrame = Instance.new("Frame")
    StatsFrame.Size = UDim2.new(0,160,0,65)
    StatsFrame.Position = UDim2.new(1,-175,0,15)
    StatsFrame.BackgroundColor3 = Color3.fromRGB(15,15,15)
    StatsFrame.BackgroundTransparency = 0.2
    Instance.new("UICorner", StatsFrame).CornerRadius = UDim.new(0,10)
    AddRainbowGlow(StatsFrame,2)
    StatsFrame.Parent = StatsUI

    local FPSLabel = Instance.new("TextLabel")
    FPSLabel.Size = UDim2.new(1,-20,0,28)
    FPSLabel.Position = UDim2.new(0,10,0,5)
    FPSLabel.BackgroundTransparency = 1
    FPSLabel.Font = Enum.Font.GothamBold
    FPSLabel.TextScaled = true
    FPSLabel.Text = "FPS: 0"
    FPSLabel.TextColor3 = Color3.fromRGB(80,255,120)
    FPSLabel.TextXAlignment = Enum.TextXAlignment.Left
    FPSLabel.Parent = StatsFrame

    local PingLabel = Instance.new("TextLabel")
    PingLabel.Size = UDim2.new(1,-20,0,28)
    PingLabel.Position = UDim2.new(0,10,0,32)
    PingLabel.BackgroundTransparency = 1
    PingLabel.Font = Enum.Font.GothamBold
    PingLabel.TextScaled = true
    PingLabel.Text = "PING: 0ms"
    PingLabel.TextColor3 = Color3.fromRGB(255,200,50)
    PingLabel.TextXAlignment = Enum.TextXAlignment.Left
    PingLabel.Parent = StatsFrame

    -- ✅ MAIN LOOP
    local LastFPS = 0
    RunService.Heartbeat:Connect(function(dt)
        Hue = (Hue + dt * 0.25) % 1
        local Rainbow = Color3.fromHSV(Hue,1,1)
        for _,v in pairs(GuiElements) do if v:IsA("UIStroke") then v.Color = Rainbow end end

        UsedTime += dt
        SaveData(SAVE_KEY_USED, UsedTime)
        local Rem = math.max(0, USAGE_LIMIT - UsedTime)
        TimerLabel.Text = string.format("%02d:%02d:%02d / 12:00", Rem/3600, (Rem%3600)/60, Rem%60)

        LastFPS += 1
        task.delay(1, function() FPSLabel.Text = "FPS: "..LastFPS; LastFPS=0 end)
        pcall(function() PingLabel.Text = "PING: "..math.floor(NetworkClient:GetPing()).."ms" end)

        if ESP_Enabled then
            for _,P in pairs(Players:GetPlayers()) do
                if P ~= LocalPlayer and P.Character then
                    if not P.Character:FindFirstChild("BLUE_Outline") then
                        AddESPForPlayer(P)
                    else
                        P.Character.BLUE_Outline.FillColor = GetPlayerColor(P)
                        P.Character.BLUE_Outline.OutlineColor = GetPlayerColor(P)
                    end
                end
            end
        end
    end)

    Players.PlayerAdded:Connect(function(P) P.CharacterAdded:Connect(function() task.wait(0.5); if ESP_Enabled then AddESPForPlayer(P) end end) end)
    Players.PlayerRemoving:Connect(function(P) pcall(function() P.Character:FindFirstChild("BLUE_Outline"):Destroy() end) end)

    print("✅ BLUE MODE HUB LOADED SUCCESSFULLY!")
end
