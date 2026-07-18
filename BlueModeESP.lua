-- ==============================================
-- BLUE MODE ESP | FINAL VERSION
-- ✅ Startup Screen + Feature List + Load Button + Main GUI
-- ✅ Full Rainbow Outline + Rainbow Text
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

-- STATES
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

-- ✅ RAINBOW SYSTEM
local function AddRainbowBorder(target, thickness)
    if not target then return end
    local Outline = Instance.new("UIStroke")
    Outline.Name = "RainbowBorder"
    Outline.Thickness = thickness or 5
    Outline.Transparency = 0
    Outline.LineJoinMode = Enum.LineJoinMode.Round
    Outline.Parent = target
    table.insert(RainbowBorders, Outline)
end
local function AddRainbowText(target)
    if not target then return end
    table.insert(RainbowText, target)
end

-- GLOBAL RAINBOW ANIMATION
RunService.Heartbeat:Connect(function(dt)
    Hue = (Hue + dt * 0.25) % 1
    local Color = Color3.fromHSV(Hue, 1, 1)
    for _,v in pairs(RainbowBorders) do v.Color = Color end
    for _,v in pairs(RainbowText) do
        if v and (v:IsA("TextLabel") or v:IsA("TextButton") or v:IsA("TextBox")) then
            v.TextColor3 = Color
        end
    end
end)

-- ==============================================
-- ✅ STARTUP SCREEN (EXACTLY AS YOU WANTED)
-- ==============================================
local function ShowStartupScreen()
    local StartupUI = Instance.new("ScreenGui")
    StartupUI.Name = "BLUE_STARTUP"
    StartupUI.ResetOnSpawn = false
    StartupUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    StartupUI.Parent = PlayerGui

    -- MAIN FRAME
    local StartupFrame = Instance.new("Frame")
    StartupFrame.Size = UDim2.new(0,520,0,620)
    StartupFrame.Position = UDim2.new(0.5,-260,0.5,-310)
    StartupFrame.BackgroundColor3 = Color3.fromRGB(15,15,15)
    StartupFrame.Active = true
    StartupFrame.Parent = StartupUI
    Instance.new("UICorner", StartupFrame).CornerRadius = UDim.new(0,18)
    AddRainbowBorder(StartupFrame, 7) -- ✅ THICK RAINBOW OUTLINE

    -- YOUR BLUE MODE LOGO
    local Logo = Instance.new("ImageLabel")
    Logo.Size = UDim2.new(0,60,0,60)
    Logo.Position = UDim2.new(0.5,-30,0,10)
    Logo.BackgroundTransparency = 1
    Logo.Image = "file:///storage/emulated/0/Delta/Internals/Assets/logo.png" -- ✅ YOUR CUSTOM LOGO
    Logo.Parent = StartupFrame

    -- TITLE
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1,-40,0,55)
    Title.Position = UDim2.new(0,20,0,75)
    Title.BackgroundTransparency = 1
    Title.Text = "🔵 BLUE MODE ESP"
    Title.Font = Enum.Font.GothamBold
    Title.TextScaled = true
    Title.TextXAlignment = Enum.TextXAlignment.Center
    Title.Parent = StartupFrame
    AddRainbowText(Title)

    -- FEATURE LIST HEADER
    local ListHeader = Instance.new("TextLabel")
    ListHeader.Size = UDim2.new(1,-40,0,40)
    ListHeader.Position = UDim2.new(0,20,0,140)
    ListHeader.BackgroundTransparency = 1
    ListHeader.Text = "📋 FEATURE LIST:"
    ListHeader.Font = Enum.Font.GothamBold
    ListHeader.TextScaled = true
    ListHeader.TextXAlignment = Enum.TextXAlignment.Left
    ListHeader.Parent = StartupFrame
    AddRainbowText(ListHeader)

    -- ✅ EXACT FEATURE LIST YOU REQUESTED
    local Features = Instance.new("TextLabel")
    Features.Size = UDim2.new(1,-40,0,280)
    Features.Position = UDim2.new(0,20,0,190)
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
    Features.TextLineHeight = 1.8
    Features.Parent = StartupFrame
    AddRainbowText(Features)

    -- ✅ STARTUP / LOAD MAIN GUI BUTTON
    local LoadBtn = Instance.new("TextButton")
    LoadBtn.Size = UDim2.new(0,340,0,60)
    LoadBtn.Position = UDim2.new(0.5,-170,0,490)
    LoadBtn.BackgroundColor3 = Color3.fromRGB(25,25,25)
    LoadBtn.Text = "▶ LOAD MAIN SCRIPT"
    LoadBtn.Font = Enum.Font.GothamBold
    LoadBtn.TextScaled = true
    LoadBtn.Parent = StartupFrame
    Instance.new("UICorner", LoadBtn).CornerRadius = UDim.new(0,14)
    AddRainbowBorder(LoadBtn, 3)
    AddRainbowText(LoadBtn)

    -- ✅ DELETE / EXIT BUTTON
    local DeleteBtn = Instance.new("TextButton")
    DeleteBtn.Size = UDim2.new(0,340,0,50)
    DeleteBtn.Position = UDim2.new(0.5,-170,0,560)
    DeleteBtn.BackgroundColor3 = Color3.fromRGB(25,25,25)
    DeleteBtn.Text = "🗑️ DELETE / EXIT SCRIPT"
    DeleteBtn.Font = Enum.Font.GothamBold
    DeleteBtn.TextScaled = true
    DeleteBtn.Parent = StartupFrame
    Instance.new("UICorner", DeleteBtn).CornerRadius = UDim.new(0,14)
    AddRainbowBorder(DeleteBtn, 3)
    AddRainbowText(DeleteBtn)

    -- BUTTON ACTIONS
    LoadBtn.MouseButton1Click:Connect(function()
        StartupUI:Destroy()
        MainUI_Loaded = true
        LoadMainUI() -- ✅ OPENS YOUR MAIN ESP GUI
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
-- MAIN ESP GUI (LOADS AFTER CLICKING LOAD)
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
    AddRainbowBorder(MainFrame, 5)

    -- DRAG BAR + TIMER
    local DragBar = Instance.new("TextButton")
    DragBar.Size = UDim2.new(1,-30,0,22)
    DragBar.Position = UDim2.new(0,0,0,0)
    DragBar.BackgroundColor3 = Color3.fromRGB(30,30,30)
    DragBar.Text = "made by BLUE_MODE | DRAG HERE"
    DragBar.Font = Enum.Font.GothamBold
    DragBar.TextScaled = true
    DragBar.Parent = MainFrame
    AddRainbowText(DragBar)

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

    -- MINIMIZE BUTTON
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
    AddRainbowBorder(ESPBn, 2)
    AddRainbowText(ESPBn)

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

    print("✅ MAIN ESP GUI LOADED!")
end

-- RUN EVERYTHING
ShowStartupScreen()
SetupDeathCheck()
