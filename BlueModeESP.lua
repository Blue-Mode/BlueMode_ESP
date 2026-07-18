-- ==============================================
-- BLUE MODE ESP | RAINBOW OUTLINE + RAINBOW TEXT
-- ✅ Startup GUI full rainbow border
-- ✅ Made by DwayneKeanTFrancisco / Blue_Mode
-- ==============================================
if getgenv().BlueMode_Loaded then return end
getgenv().BlueMode_Loaded = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 10) or game:GetService("CoreGui")

-- SETTINGS
local USAGE_LIMIT = 12 * 3600
local COOLDOWN = 12 * 3600
local YOUTUBE_LINK = "https://youtube.com/@blue_mode?si=aCGyj0FnwCMtTP1M"
local SAVE_KEY_USED = "BlueMode_UsedTime_v19"
local SAVE_KEY_COOLDOWN = "BlueMode_CooldownEnd_v19"
local SAVE_KEY_VOLUME = "BlueMode_Volume_v19"

-- TOGGLE STATES
local BoomboxUI_Open = false
local ConsoleUI_Open = false
local CurrentBoomboxUI = nil
local CurrentConsoleUI = nil
local IsMinimized = false
local GuiFocused = false
local MainUI_Loaded = false
local RainbowBorders = {}
local RainbowText = {}

-- DATA HELPERS
local function SaveData(key, value) pcall(function() writefile(key..".txt", tostring(value)) end) end
local function LoadData(key, default) local v=nil; pcall(function() v=readfile(key..".txt") end); return tonumber(v) or default end

-- FULL CLEANUP
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

-- COOLDOWN CHECK
local CurrentTime = os.time()
local CooldownEnd = LoadData(SAVE_KEY_COOLDOWN, 0)
if CurrentTime < CooldownEnd then
    print("⏳ COOLDOWN ACTIVE! Wait "..math.floor((CooldownEnd-CurrentTime)/60).." mins")
    return
end

-- VARIABLES
local UsedTime = LoadData(SAVE_KEY_USED, 0)
local LastCheckTime = os.time()
local MusicVolume = LoadData(SAVE_KEY_VOLUME, 0.5)
local CurrentSound = nil
local VolNumTextMain, VolFillMain, VolFillMenu, VolNumMenu
local ESP_Enabled = false
local Buttons_Locked = false
local Hue = 0
local ESPBtn = nil

-- DEATH CHECK
local function SetupDeathCheck()
    local function CheckCharacter(Char)
        if not Char then return end
        local Hum = Char:WaitForChild("Humanoid", 10)
        if not Hum then return end
        Hum.Died:Connect(function()
            if ESP_Enabled then
                ESP_Enabled = false
                if ESPBtn then ESPBtn.Text = "ESP: OFF" end
                ClearAllESP()
            end
        end)
    end
    CheckCharacter(LocalPlayer.Character)
    LocalPlayer.CharacterAdded:Connect(CheckCharacter)
end

-- ✅ ADD RAINBOW OUTLINE TO ANY GUI
local function AddRainbowBorder(target, thickness)
    if not target then return end
    local Outline = Instance.new("UIStroke")
    Outline.Name = "RainbowBorder"
    Outline.Thickness = thickness or 4
    Outline.Transparency = 0
    Outline.LineJoinMode = Enum.LineJoinMode.Round
    Outline.Parent = target
    table.insert(RainbowBorders, Outline)
end

-- ✅ MAKE ANY TEXT RAINBOW
local function AddRainbowText(target)
    if not target then return end
    table.insert(RainbowText, target)
end

-- ✅ GLOBAL RAINBOW ANIMATION (RUNS ALL THE TIME)
RunService.Heartbeat:Connect(function(dt)
    Hue = (Hue + dt * 0.25) % 1
    local Color = Color3.fromHSV(Hue, 1, 1)
    
    -- Update all outlines
    for _,v in pairs(RainbowBorders) do v.Color = Color end
    -- Update all text
    for _,v in pairs(RainbowText) do
        if v and v:IsA("TextLabel") or v:IsA("TextButton") or v:IsA("TextBox") then
            v.TextColor3 = Color
        end
    end
end)

-- ==============================================
-- ✅ STARTUP SCREEN WITH RAINBOW OUTLINE
-- ==============================================
local function ShowStartupScreen()
    local StartupUI = Instance.new("ScreenGui")
    StartupUI.Name = "BLUE_STARTUP"
    StartupUI.ResetOnSpawn = false
    StartupUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    StartupUI.Parent = PlayerGui

    -- MAIN STARTUP FRAME WITH RAINBOW OUTLINE
    local StartupFrame = Instance.new("Frame")
    StartupFrame.Size = UDim2.new(0,420,0,520)
    StartupFrame.Position = UDim2.new(0.5,-210,0.5,-260)
    StartupFrame.BackgroundColor3 = Color3.fromRGB(18,18,18)
    StartupFrame.Active = true
    StartupFrame.Parent = StartupUI
    Instance.new("UICorner", StartupFrame).CornerRadius = UDim.new(0,16)
    AddRainbowBorder(StartupFrame, 7) -- ✅ THICK RAINBOW BORDER

    -- TITLE
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1,-40,0,50)
    Title.Position = UDim2.new(0,20,0,15)
    Title.BackgroundTransparency = 1
    Title.Text = "🔵 BLUE MODE ESP"
    Title.Font = Enum.Font.GothamBold
    Title.TextScaled = true
    Title.Parent = StartupFrame
    AddRainbowText(Title)

    -- FEATURE LIST HEADER
    local ListHeader = Instance.new("TextLabel")
    ListHeader.Size = UDim2.new(1,-40,0,35)
    ListHeader.Position = UDim2.new(0,20,0,75)
    ListHeader.BackgroundTransparency = 1
    ListHeader.Text = "📋 FEATURE LIST:"
    ListHeader.Font = Enum.Font.GothamBold
    ListHeader.TextScaled = true
    ListHeader.TextXAlignment = Enum.TextXAlignment.Left
    ListHeader.Parent = StartupFrame
    AddRainbowText(ListHeader)

    -- FEATURES
    local Features = Instance.new("TextLabel")
    Features.Size = UDim2.new(1,-40,0,220)
    Features.Position = UDim2.new(0,20,0,115)
    Features.BackgroundTransparency = 1
    Features.Text = [[• ESP / FRIEND DOT
• CONSOLE
• MADE BY: DWAYNEKEANTFRANCISCO
• MADE BY: BLUE_MODE
• DELETE BUTTON
• MUSIC]]
    Features.Font = Enum.Font.Gotham
    Features.TextScaled = true
    Features.TextXAlignment = Enum.TextXAlignment.Left
    Features.TextLineHeight = 1.6
    Features.Parent = StartupFrame
    AddRainbowText(Features)

    -- LOAD SCRIPT BUTTON
    local LoadBtn = Instance.new("TextButton")
    LoadBtn.Size = UDim2.new(0,280,0,55)
    LoadBtn.Position = UDim2.new(0.5,-140,0,360)
    LoadBtn.BackgroundColor3 = Color3.fromRGB(25,25,25)
    LoadBtn.Text = "▶ LOAD SCRIPT"
    LoadBtn.Font = Enum.Font.GothamBold
    LoadBtn.TextScaled = true
    LoadBtn.Parent = StartupFrame
    Instance.new("UICorner", LoadBtn).CornerRadius = UDim.new(0,12)
    AddRainbowBorder(LoadBtn, 3) -- ✅ BUTTON RAINBOW BORDER
    AddRainbowText(LoadBtn)

    -- DELETE / EXIT BUTTON
    local DeleteBtn = Instance.new("TextButton")
    DeleteBtn.Size = UDim2.new(0,280,0,45)
    DeleteBtn.Position = UDim2.new(0.5,-140,0,430)
    DeleteBtn.BackgroundColor3 = Color3.fromRGB(25,25,25)
    DeleteBtn.Text = "🗑️ DELETE / EXIT"
    DeleteBtn.Font = Enum.Font.GothamBold
    DeleteBtn.TextScaled = true
    DeleteBtn.Parent = StartupFrame
    Instance.new("UICorner", DeleteBtn).CornerRadius = UDim.new(0,12)
    AddRainbowBorder(DeleteBtn, 3) -- ✅ BUTTON RAINBOW BORDER
    AddRainbowText(DeleteBtn)

    -- BUTTON ACTIONS
    LoadBtn.MouseButton1Click:Connect(function()
        StartupUI:Destroy()
        MainUI_Loaded = true
        LoadMainUI()
    end)

    DeleteBtn.MouseButton1Click:Connect(function()
        ClearAllESP()
        pcall(function() if CurrentSound then CurrentSound:Destroy() end end)
        StartupUI:Destroy()
        getgenv().BlueMode_Loaded = nil
        print("✅ Exited & deleted Blue Mode ESP")
    end)
end

-- ==============================================
-- MAIN UI LOAD
-- ==============================================
function LoadMainUI()
    local FULL_SIZE = UDim2.new(0,680,0,105)
    local MINI_SIZE = UDim2.new(0,110,0,36)
    
    local MainUI = Instance.new("ScreenGui")
    MainUI.Name = "BLUE_MAIN"
    MainUI.ResetOnSpawn = false
    MainUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    MainUI.Parent = PlayerGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = FULL_SIZE
    MainFrame.Position = UDim2.new(0,20,0.5,-52)
    MainFrame.BackgroundColor3 = Color3.fromRGB(22,22,22)
    MainFrame.Active = true
    MainFrame.ClipsDescendants = false
    MainFrame.Parent = MainUI
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,8)
    AddRainbowBorder(MainFrame, 5) -- ✅ MAIN GUI RAINBOW BORDER

    -- DRAG BAR
    local DragBar = Instance.new("TextButton")
    DragBar.Size = UDim2.new(1,-30,0,22)
    DragBar.Position = UDim2.new(0,0,0,0)
    DragBar.BackgroundColor3 = Color3.fromRGB(30,30,30)
    DragBar.Text = "made by BLUE_MODE | DRAG HERE"
    DragBar.Font = Enum.Font.GothamBold
    DragBar.TextScaled = true
    DragBar.Parent = MainFrame
    AddRainbowText(DragBar)

    -- TIMER
    local Timer = Instance.new("TextLabel")
    Timer.Size = UDim2.new(0,120,1,0)
    Timer.Position = UDim2.new(1,-125,0,0)
    Timer.BackgroundTransparency = 1
    Timer.Text = "00:00:00 / 12:00"
    Timer.Font = Enum.Font.GothamBold
    Timer.TextScaled = true
    Timer.TextXAlignment = Enum.TextXAlignment.Right
    Timer.Parent = MainFrame
    AddRainbowText(Timer)

    -- MINIMIZE
    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.new(0,22,1,0)
    MinBtn.Position = UDim2.new(1,-22,0,0)
    MinBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    MinBtn.Text = "➖"
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.TextScaled = true
    MinBtn.Parent = MainFrame
    AddRainbowText(MinBtn)

    -- ESP BUTTON
    ESPBtn = Instance.new("TextButton")
    ESPBtn.Size = UDim2.new(0,85,0,30)
    ESPBtn.Position = UDim2.new(0,10,0,30)
    ESPBtn.BackgroundColor3 = Color3.fromRGB(35,35,35)
    ESPBtn.Text = "ESP: OFF"
    ESPBtn.Font = Enum.Font.GothamBold
    ESPBtn.TextScaled = true
    ESPBtn.Parent = MainFrame
    Instance.new("UICorner", ESPBtn).CornerRadius = UDim.new(0,6)
    AddRainbowBorder(ESPBtn, 2)
    AddRainbowText(ESPBtn)

    -- YOUTUBE BUTTON
    local YtBtn = Instance.new("TextButton")
    YtBtn.Size = UDim2.new(0,95,0,30)
    YtBtn.Position = UDim2.new(0,100,0,30)
    YtBtn.BackgroundColor3 = Color3.fromRGB(35,35,35)
    YtBtn.Text = "📺 YT"
    YtBtn.Font = Enum.Font.GothamBold
    YtBtn.TextScaled = true
    YtBtn.Parent = MainFrame
    Instance.new("UICorner", YtBtn).CornerRadius = UDim.new(0,6)
    AddRainbowBorder(YtBtn, 2)
    AddRainbowText(YtBtn)

    -- MUSIC BUTTON
    local MusicBtn = Instance.new("TextButton")
    MusicBtn.Size = UDim2.new(0,90,0,30)
    MusicBtn.Position = UDim2.new(0,200,0,30)
    MusicBtn.BackgroundColor3 = Color3.fromRGB(35,35,35)
    MusicBtn.Text = "🎵 MUSIC"
    MusicBtn.Font = Enum.Font.GothamBold
    MusicBtn.TextScaled = true
    MusicBtn.Parent = MainFrame
    Instance.new("UICorner", MusicBtn).CornerRadius = UDim.new(0,6)
    AddRainbowBorder(MusicBtn, 2)
    AddRainbowText(MusicBtn)

    -- LOCK BUTTON
    local LockBtn = Instance.new("TextButton")
    LockBtn.Size = UDim2.new(0,90,0,30)
    LockBtn.Position = UDim2.new(0,300,0,30)
    LockBtn.BackgroundColor3 = Color3.fromRGB(35,35,35)
    LockBtn.Text = "🔓 UNLOCKED"
    LockBtn.Font = Enum.Font.GothamBold
    LockBtn.TextScaled = true
    LockBtn.Parent = MainFrame
    Instance.new("UICorner", LockBtn).CornerRadius = UDim.new(0,6)
    AddRainbowBorder(LockBtn, 2)
    AddRainbowText(LockBtn)

    -- CONSOLE BUTTON
    local ConsoleBtn = Instance.new("TextButton")
    ConsoleBtn.Size = UDim2.new(0,110,0,30)
    ConsoleBtn.Position = UDim2.new(0,400,0,30)
    ConsoleBtn.BackgroundColor3 = Color3.fromRGB(35,35,35)
    ConsoleBtn.Text = "💻 CONSOLE"
    ConsoleBtn.Font = Enum.Font.GothamBold
    ConsoleBtn.TextScaled = true
    ConsoleBtn.Parent = MainFrame
    Instance.new("UICorner", ConsoleBtn).CornerRadius = UDim.new(0,6)
    AddRainbowBorder(ConsoleBtn, 2)
    AddRainbowText(ConsoleBtn)

    -- DELETE BUTTON
    local DelBtn = Instance.new("TextButton")
    DelBtn.Size = UDim2.new(0,90,0,30)
    DelBtn.Position = UDim2.new(0,520,0,30)
    DelBtn.BackgroundColor3 = Color3.fromRGB(35,35,35)
    DelBtn.Text = "🗑️ DELETE"
    DelBtn.Font = Enum.Font.GothamBold
    DelBtn.TextScaled = true
    DelBtn.Parent = MainFrame
    Instance.new("UICorner", DelBtn).CornerRadius = UDim.new(0,6)
    AddRainbowBorder(DelBtn, 2)
    AddRainbowText(DelBtn)

    print("✅ MAIN UI LOADED SUCCESSFULLY")
end

-- START EVERYTHING
ShowStartupScreen()
SetupDeathCheck()
