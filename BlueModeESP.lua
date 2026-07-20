-- ==============================================
-- 🔵 BLUE MODE HUB | FINAL FULL VERSION
-- ✅ FULL BODY RAINBOW OUTLINE
-- ✅ FRIEND DOTS & CROWN VISIBLE AT ANY DISTANCE
-- ✅ MAIN GUI VOLUME SLIDER
-- ✅ MINIMIZE HIDES EXTRA BUTTONS
-- ✅ CUSTOM BACKGROUND ON ALL MENUS
-- ✅ FULL RAINBOW ON ALL TEXT & BORDERS
-- ✅ EXIT WITH CONFIRMATION POPUP
-- ✅ CROSS-EXECUTOR / DELTA COMPATIBLE
-- ✅ CREATOR: DWAYNEKEAN015 / BLUE_MODE
-- ==============================================

-- CROSS-EXECUTOR FALLBACKS
getgenv = getgenv or _G
readfile = readfile or function() return nil end
writefile = writefile or function() end
loadstring = loadstring or load
setclipboard = setclipboard or function() end

if getgenv().BlueMode_Loaded then return end
getgenv().BlueMode_Loaded = true

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- ASSETS
local CUSTOM_GUI_BG = "rbxassetid://101782008402770"
local GuiContainer = Instance.new("Folder")
GuiContainer.Name = "BLUE_MODE_HUB_ROOT"
pcall(function() GuiContainer.Parent = CoreGui end)
if not GuiContainer.Parent then GuiContainer.Parent = LocalPlayer.PlayerGui end

-- DISPLAY PRIORITY
local PRIORITY = {
    STARTUP = 800,
    MAIN = 799,
    BOOMBOX = 798,
    CONSOLE = 797,
    EXIT_CONFIRM = 9999
}

-- SETTINGS
local USAGE_LIMIT = 12 * 3600
local YOUTUBE_LINK = "https://youtube.com/@blue_mode?si=aCGyj0FnwCMtTP1M"
local SAVE_KEY_USED = "BlueMode_UsedTime_v22"
local SAVE_KEY_COOLDOWN = "BlueMode_CooldownEnd_v22"
local SAVE_KEY_VOLUME = "BlueMode_Volume_v22"
local VOLUME_MAX = 1000
local OWNER_NAME = "Dwaynekean015"

-- GLOBAL VARIABLES
local BoomboxUI_Open = false
local ConsoleUI_Open = false
local CurrentBoomboxUI = nil
local CurrentConsoleUI = nil
local IsMinimized = false
local GuiFocused = false
local GuiElements = {}
local CurrentSound = nil
local MusicVolume = 500
local Hue = 0

-- DATA FUNCTIONS
local function SaveData(key, value)
    pcall(function() writefile(key..".txt", tostring(value)) end)
end
local function LoadData(key, default)
    local saved = nil
    pcall(function() saved = readfile(key..".txt") end)
    return tonumber(saved) or default
end

-- RAINBOW OUTLINE HELPER
local function AddRainbowGlow(target, thickness)
    if not target then return end
    if target:FindFirstChild("RainbowAura") then target.RainbowAura:Destroy() end
    local Outline = Instance.new("UIStroke")
    Outline.Name = "RainbowAura"
    Outline.Thickness = thickness or 3
    Outline.Transparency = 0
    Outline.LineJoinMode = Enum.LineJoinMode.Round
    Outline.Parent = target
    table.insert(GuiElements, Outline)
    return Outline
end

-- CLEANUP FUNCTIONS
local function ClearAllESP()
    pcall(function()
        for _, Player in pairs(Players:GetPlayers()) do
            if Player and Player.Character then
                for _, Child in pairs(Player.Character:GetChildren()) do
                    if Child.Name == "BLUE_FULLBODY_OUTLINE" 
                    or Child.Name == "FriendRainbowDot" 
                    or Child.Name == "OwnerCrown" then
                        Child:Destroy()
                    end
                end
            end
        end
        for _, Desc in pairs(workspace:GetDescendants()) do
            if Desc.Name == "BLUE_FULLBODY_OUTLINE" 
            or Desc.Name == "FriendRainbowDot" 
            or Desc.Name == "OwnerCrown" then
                Desc:Destroy()
            end
        end
    end)
end

local function FullDeleteHub()
    pcall(function()
        ClearAllESP()
        if CurrentSound then CurrentSound:Destroy() end
        if GuiContainer then GuiContainer:Destroy() end
        getgenv().BlueMode_Loaded = nil
        print("🗑️ BLUE MODE HUB FULLY CLOSED")
    end)
end

-- STARTUP SCREEN
local StartupUI = Instance.new("ScreenGui")
StartupUI.Name = "BLUE_MODE_HUB_STARTUP"
StartupUI.ResetOnSpawn = false
StartupUI.DisplayOrder = PRIORITY.STARTUP
StartupUI.Parent = GuiContainer

local StartupBox = Instance.new("Frame")
StartupBox.Size = UDim2.new(0, 420, 0, 480)
StartupBox.Position = UDim2.new(0.5, -210, 0.5, -240)
StartupBox.BackgroundColor3 = Color3.fromRGB(10, 12, 18)
StartupBox.Active = true
StartupBox.Parent = StartupUI
Instance.new("UICorner", StartupBox).CornerRadius = UDim.new(0, 18)

local StartupBg = Instance.new("ImageLabel")
StartupBg.Size = UDim2.new(1, 0, 1, 0)
StartupBg.BackgroundTransparency = 1
StartupBg.Image = CUSTOM_GUI_BG
StartupBg.ScaleType = Enum.ScaleType.Stretch
StartupBg.ZIndex = 1
StartupBg.Parent = StartupBox

local StartupBorder = AddRainbowGlow(StartupBox, 5)

local StartupTitle = Instance.new("TextLabel")
StartupTitle.Size = UDim2.new(1, -40, 0, 50)
StartupTitle.Position = UDim2.new(0, 20, 0, 15)
StartupTitle.BackgroundTransparency = 1
StartupTitle.Font = Enum.Font.GothamBlack
StartupTitle.TextScaled = true
StartupTitle.Text = "🔵 BLUE MODE HUB"
StartupTitle.ZIndex = 2
StartupTitle.Parent = StartupBox

local FeatureHeader = Instance.new("TextLabel")
FeatureHeader.Size = UDim2.new(1, -40, 0, 35)
FeatureHeader.Position = UDim2.new(0, 20, 0, 75)
FeatureHeader.BackgroundTransparency = 1
FeatureHeader.Font = Enum.Font.GothamBold
FeatureHeader.TextScaled = true
FeatureHeader.Text = "📋 FEATURES & UPDATES:"
FeatureHeader.ZIndex = 2
FeatureHeader.Parent = StartupBox

local FeatureList = Instance.new("TextLabel")
FeatureList.Size = UDim2.new(1, -50, 0, 190)
FeatureList.Position = UDim2.new(0, 25, 0, 115)
FeatureList.BackgroundTransparency = 1
FeatureList.Font = Enum.Font.Gotham
FeatureList.TextScaled = true
FeatureList.TextWrapped = true
FeatureList.TextXAlignment = Enum.TextXAlignment.Left
FeatureList.TextYAlignment = Enum.TextYAlignment.Top
FeatureList.TextColor3 = Color3.fromRGB(220, 220, 220)
FeatureList.ZIndex = 2
FeatureList.Text = [[• FULL BODY RAINBOW OUTLINE FOR ALL PLAYERS
• FRIEND INDICATOR VISIBLE AT ANY DISTANCE
• MAIN GUI VOLUME SLIDER + MUSIC MENU VOLUME
• MINIMIZE HIDES ALL EXTRA BUTTONS
• CUSTOM BACKGROUND ON EVERY MENU
• FULL RAINBOW EFFECTS ON ALL TEXT & BORDERS
• OWNER GOLDEN OUTLINE + CROWN
• EXIT WITH CONFIRMATION POPUP
• DRAGGABLE, LOCKABLE, CROSS-EXECUTOR SUPPORT]]
FeatureList.Parent = StartupBox

local StartupTimer = Instance.new("TextLabel")
StartupTimer.Size = UDim2.new(1, -40, 0, 45)
StartupTimer.Position = UDim2.new(0, 20, 0, 320)
StartupTimer.BackgroundTransparency = 1
StartupTimer.Font = Enum.Font.GothamBold
StartupTimer.TextScaled = true
StartupTimer.Text = "TIME REMAINING: 12:00:00"
StartupTimer.ZIndex = 2
StartupTimer.Parent = StartupBox

local LaunchBtn = Instance.new("TextButton")
LaunchBtn.Size = UDim2.new(0, 280, 0, 60)
LaunchBtn.Position = UDim2.new(0.5, -140, 0, 380)
LaunchBtn.BackgroundColor3 = Color3.fromRGB(15, 110, 230)
LaunchBtn.Font = Enum.Font.GothamBold
LaunchBtn.TextScaled = true
LaunchBtn.Text = "🚀 LAUNCH HUB"
LaunchBtn.TextColor3 = Color3.new(1, 1, 1)
LaunchBtn.ZIndex = 2
LaunchBtn.Parent = StartupBox
Instance.new("UICorner", LaunchBtn).CornerRadius = UDim.new(0, 16)
AddRainbowGlow(LaunchBtn, 4)

-- STARTUP ANIMATION
local StartupHue = 0
local UsedTime = LoadData(SAVE_KEY_USED, 0)
RunService.Heartbeat:Connect(function(dt)
    StartupHue = (StartupHue + dt * 0.3) % 1
    local Col = Color3.fromHSV(StartupHue, 1, 1)
    StartupBorder.Color = Col
    StartupTitle.TextColor3 = Col
    FeatureHeader.TextColor3 = Col
    LaunchBtn.BackgroundColor3 = Color3.fromHSV(StartupHue, 0.8, 0.6)
    local Remaining = math.max(0, USAGE_LIMIT - UsedTime)
    local h = math.floor(Remaining / 3600)
    local m = math.floor((Remaining % 3600) / 60)
    local s = Remaining % 60
    StartupTimer.Text = string.format("TIME REMAINING: %02d:%02d:%02d", h, m, s)
end)

LaunchBtn.MouseButton1Click:Connect(function()
    StartupUI:Destroy()
    LoadMainHub()
end)

print("✅ BLUE MODE HUB PART 1 LOADED SUCCESSFULLY")

-- ==============================================
-- END OF PART 1
-- ==============================================
-- ==============================================
-- 🔵 BLUE MODE HUB | PART 2 / 2
-- ✅ ALL FEATURES INTACT | NO SPELLING ERRORS
-- ==============================================

local VolNumMain, VolFillMain, VolNumMenu, VolFillMenu, ESPBtn, LockBtn
local ESP_Enabled = false
local Buttons_Locked = false
local DragStart, StartPos
local MainButtons = {}

-- VOLUME SYSTEM
local function UpdateVolume(newVol)
    MusicVolume = math.clamp(tonumber(newVol) or 500, 0, VOLUME_MAX)
    SaveData(SAVE_KEY_VOLUME, MusicVolume)
    if CurrentSound then CurrentSound.Volume = MusicVolume / VOLUME_MAX end
    local DisplayVal = tostring(math.floor(MusicVolume + 0.5))
    if VolNumMain then VolNumMain.Text = DisplayVal end
    if VolFillMain then VolFillMain.Size = UDim2.new(MusicVolume / VOLUME_MAX, 0, 1, 0) end
    if VolNumMenu then VolNumMenu.Text = DisplayVal end
    if VolFillMenu then VolFillMenu.Size = UDim2.new(MusicVolume / VOLUME_MAX, 0, 1, 0) end
end

local function FormatSoundID(input)
    return "rbxassetid://" .. tostring(input):gsub("%D", "")
end

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
    BoomUI.Name = "BLUE_MODE_BOOMBOX"
    BoomUI.ResetOnSpawn = false
    BoomUI.DisplayOrder = PRIORITY.BOOMBOX
    BoomUI.Parent = GuiContainer
    CurrentBoomboxUI = BoomUI
    BoomboxUI_Open = true

    local BoomFrame = Instance.new("Frame")
    BoomFrame.Size = UDim2.new(0, 320, 0, 250)
    BoomFrame.Position = UDim2.new(0.5, -160, 0.5, -125)
    BoomFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    BoomFrame.Active = true
    BoomFrame.Parent = BoomUI
    Instance.new("UICorner", BoomFrame).CornerRadius = UDim.new(0, 12)

    local BoomBg = Instance.new("ImageLabel")
    BoomBg.Size = UDim2.new(1, 0, 1, 0)
    BoomBg.BackgroundTransparency = 1
    BoomBg.Image = CUSTOM_GUI_BG
    BoomBg.ScaleType = Enum.ScaleType.Stretch
    BoomBg.ZIndex = 1
    BoomBg.Parent = BoomFrame
    AddRainbowGlow(BoomFrame, 4)

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -35, 0, 5)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(170, 30, 30)
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.new(1, 1, 1)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 24
    CloseBtn.Parent = BoomFrame
    CloseBtn.MouseButton1Click:Connect(ToggleBoomboxMenu)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -70, 0, 40)
    Title.Position = UDim2.new(0, 12, 0, 8)
    Title.BackgroundTransparency = 1
    Title.Text = "🎵 BOOMBOX & VOLUME"
    Title.Font = Enum.Font.GothamBold
    Title.TextScaled = true
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.ZIndex = 2
    Title.Parent = BoomFrame

    local Input = Instance.new("TextBox")
    Input.Size = UDim2.new(1, -40, 0, 45)
    Input.Position = UDim2.new(0, 20, 0, 55)
    Input.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Input.PlaceholderText = "Paste Sound ID here..."
    Input.TextColor3 = Color3.new(1, 1, 1)
    Input.Font = Enum.Font.Gotham
    Input.TextScaled = true
    Input.ZIndex = 2
    Input.Parent = BoomFrame
    Instance.new("UICorner", Input).CornerRadius = UDim.new(0, 8)
    AddRainbowGlow(Input, 2)

    local VolLabel = Instance.new("TextLabel")
    VolLabel.Size = UDim2.new(0, 150, 0, 30)
    VolLabel.Position = UDim2.new(0, 20, 0, 110)
    VolLabel.BackgroundTransparency = 1
    VolLabel.Text = "🔊 VOLUME (0–1000):"
    VolLabel.Font = Enum.Font.GothamBold
    VolLabel.TextScaled = true
    VolLabel.ZIndex = 2
    VolLabel.Parent = BoomFrame

    VolNumMenu = Instance.new("TextLabel")
    VolNumMenu.Size = UDim2.new(0, 60, 0, 30)
    VolNumMenu.Position = UDim2.new(1, -80, 0, 110)
    VolNumMenu.BackgroundTransparency = 1
    VolNumMenu.Text = tostring(math.floor(MusicVolume + 0.5))
    VolNumMenu.Font = Enum.Font.GothamBold
    VolNumMenu.TextScaled = true
    VolNumMenu.ZIndex = 2
    VolNumMenu.Parent = BoomFrame

    local VolBG = Instance.new("Frame")
    VolBG.Size = UDim2.new(1, -40, 0, 24)
    VolBG.Position = UDim2.new(0, 20, 0, 145)
    VolBG.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    VolBG.Active = true
    VolBG.ZIndex = 2
    VolBG.Parent = BoomFrame
    Instance.new("UICorner", VolBG).CornerRadius = UDim.new(0, 12)
    AddRainbowGlow(VolBG, 2)

    VolFillMenu = Instance.new("Frame")
    VolFillMenu.Size = UDim2.new(MusicVolume / VOLUME_MAX, 0, 1, 0)
    VolFillMenu.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    VolFillMenu.ZIndex = 2
    VolFillMenu.Parent = VolBG
    Instance.new("UICorner", VolFillMenu).CornerRadius = UDim.new(0, 12)

    local SliderActive = false
    VolBG.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            SliderActive = true
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            SliderActive = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if SliderActive and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local RelPos = math.clamp((input.Position.X - VolBG.AbsolutePosition.X) / VolBG.AbsoluteSize.X, 0, 1)
            UpdateVolume(math.floor(RelPos * VOLUME_MAX))
        end
    end)

    local PlayBtn = Instance.new("TextButton")
    PlayBtn.Size = UDim2.new(0, 130, 0, 40)
    PlayBtn.Position = UDim2.new(0, 20, 0, 190)
    PlayBtn.BackgroundColor3 = Color3.fromRGB(25, 140, 255)
    PlayBtn.Text = "▶ PLAY SOUND"
    PlayBtn.TextColor3 = Color3.new(1, 1, 1)
    PlayBtn.Font = Enum.Font.GothamBold
    PlayBtn.TextScaled = true
    PlayBtn.ZIndex = 2
    PlayBtn.Parent = BoomFrame
    Instance.new("UICorner", PlayBtn).CornerRadius = UDim.new(0, 8)
    AddRainbowGlow(PlayBtn, 2)

    local StopBtn = Instance.new("TextButton")
    StopBtn.Size = UDim2.new(0, 130, 0, 40)
    StopBtn.Position = UDim2.new(0, 170, 0, 190)
    StopBtn.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
    StopBtn.Text = "⏹ STOP SOUND"
    StopBtn.TextColor3 = Color3.new(1, 1, 1)
    StopBtn.Font = Enum.Font.GothamBold
    StopBtn.TextScaled = true
    StopBtn.ZIndex = 2
    StopBtn.Parent = BoomFrame
    Instance.new("UICorner", StopBtn).CornerRadius = UDim.new(0, 8)
    AddRainbowGlow(StopBtn, 2)

    PlayBtn.MouseButton1Click:Connect(function() if Input.Text ~= "" then PlaySound(Input.Text) end end)
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
    ConsoleUI.Name = "BLUE_MODE_CONSOLE"
    ConsoleUI.ResetOnSpawn = false
    ConsoleUI.DisplayOrder = PRIORITY.CONSOLE
    ConsoleUI.Parent = GuiContainer
    CurrentConsoleUI = ConsoleUI
    ConsoleUI_Open = true

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 450, 0, 320)
    Frame.Position = UDim2.new(0.5, -225, 0.5, -160)
    Frame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    Frame.Active = true
    Frame.Parent = ConsoleUI
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 12)

    local ConsoleBg = Instance.new("ImageLabel")
    ConsoleBg.Size = UDim2.new(1, 0, 1, 0)
    ConsoleBg.BackgroundTransparency = 1
    ConsoleBg.Image = CUSTOM_GUI_BG
    ConsoleBg.ScaleType = Enum.ScaleType.Stretch
    ConsoleBg.ZIndex = 1
    ConsoleBg.Parent = Frame
    AddRainbowGlow(Frame, 5)

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 32, 0, 32)
    CloseBtn.Position = UDim2.new(1, -37, 0, 6)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(170, 30, 30)
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.new(1, 1, 1)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 26
    CloseBtn.Parent = Frame
    CloseBtn.MouseButton1Click:Connect(ToggleConsole)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -50, 0, 35)
    Title.Position = UDim2.new(0, 15, 0, 6)
    Title.BackgroundTransparency = 1
    Title.Text = "💻 CONSOLE"
    Title.Font = Enum.Font.GothamBold
    Title.TextScaled = true
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Frame

    local Output = Instance.new("TextLabel")
    Output.Size = UDim2.new(1, -30, 0, 40)
    Output.Position = UDim2.new(0, 15, 0, 45)
    Output.BackgroundTransparency = 1
    Output.Text = "Paste script code below..."
    Output.TextColor3 = Color3.fromRGB(0, 255, 120)
    Output.Font = Enum.Font.Code
    Output.TextScaled = true
    Output.TextXAlignment = Enum.TextXAlignment.Left
    Output.TextWrapped = true
    Output.Parent = Frame

    local Input = Instance.new("TextBox")
    Input.Size = UDim2.new(1, -30, 0, 130)
    Input.Position = UDim2.new(0, 15, 0, 95)
    Input.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Input.PlaceholderText = "Paste your script here..."
    Input.TextColor3 = Color3.new(1, 1, 1)
    Input.Font = Enum.Font.Code
    Input.TextScaled = true
    Input.MultiLine = true
    Input.Parent = Frame
    Instance.new("UICorner", Input).CornerRadius = UDim.new(0, 8)
    AddRainbowGlow(Input, 2)

    local ExecuteBtn = Instance.new("TextButton")
    ExecuteBtn.Size = UDim2.new(0, 120, 0, 40)
    ExecuteBtn.Position = UDim2.new(0, 15, 0, 240)
    ExecuteBtn.BackgroundColor3 = Color3.fromRGB(20, 150, 70)
    ExecuteBtn.Text = "▶ EXECUTE"
    ExecuteBtn.TextColor3 = Color3.new(1, 1, 1)
    ExecuteBtn.Font = Enum.Font.GothamBold
    ExecuteBtn.TextScaled = true
    ExecuteBtn.Parent = Frame
    Instance.new("UICorner", ExecuteBtn).CornerRadius = UDim.new(0, 8)
    AddRainbowGlow(ExecuteBtn, 2)

    local ClearBtn = Instance.new("TextButton")
    ClearBtn.Size = UDim2.new(0, 120, 0, 40)
    ClearBtn.Position = UDim2.new(0, 150, 0, 240)
    ClearBtn.BackgroundColor3 = Color3.fromRGB(180, 120, 20)
    ClearBtn.Text = "🗑️ CLEAR"
    ClearBtn.TextColor3 = Color3.new(1, 1, 1)
    ClearBtn.Font = Enum.Font.GothamBold
    ClearBtn.TextScaled = true
    ClearBtn.Parent = Frame
    Instance.new("UICorner", ClearBtn).CornerRadius = UDim.new(0, 8)
    AddRainbowGlow(ClearBtn, 2)

    ExecuteBtn.MouseButton1Click:Connect(function()
        local Code = Input.Text
        if Code == "" then Output.Text = "⚠️ Nothing to run!" return end
        local Compile = loadstring or load
        if not Compile then Output.Text = "⚠️ Executor not supported." return end
        local Func, ErrorMsg = Compile(Code)
        if not Func then Output.Text = "❌ Syntax Error:\n"..tostring(ErrorMsg) return end
        local Success, RunError = pcall(Func)
        if not Success then Output.Text = "❌ Runtime Error:\n"..tostring(RunError) return end
        Output.Text = "✅ Script ran successfully!"
    end)
    ClearBtn.MouseButton1Click:Connect(function() Input.Text = "" Output.Text = "✅ Cleared!" end)
end

-- MAIN HUB LOAD
function LoadMainHub()
    local FULL_SIZE = UDim2.new(0, 680, 0, 130)
    local MINI_SIZE = UDim2.new(0, 110, 0, 36)
    local MainUI = Instance.new("ScreenGui")
    MainUI.Name = "BLUE_MODE_HUB"
    MainUI.ResetOnSpawn = false
    MainUI.DisplayOrder = PRIORITY.MAIN
    MainUI.Parent = GuiContainer

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = FULL_SIZE
    MainFrame.Position = UDim2.new(0, 20, 0.5, -65)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainFrame.Active = true
    MainFrame.Parent = MainUI
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
    AddRainbowGlow(MainFrame, 5)

    local MainBg = Instance.new("ImageLabel")
    MainBg.Size = UDim2.new(1, 0, 1, 0)
    MainBg.BackgroundTransparency = 1
    MainBg.Image = CUSTOM_GUI_BG
    MainBg.ScaleType = Enum.ScaleType.Stretch
    MainBg.ZIndex = 0
    MainBg.Parent = MainFrame

    local DragHandle = Instance.new("TextButton")
    DragHandle.Size = UDim2.new(1, -30, 0, 22)
    DragHandle.Position = UDim2.new(0, 0, 0, 0)
    DragHandle.BackgroundColor3 = Color3.fromRGB(60, 140, 220)
    DragHandle.Active = true
    DragHandle.Text = "made by BLUE_MODE | DRAG HERE"
    DragHandle.TextColor3 = Color3.new(1, 1, 1)
    DragHandle.Font = Enum.Font.GothamBold
    DragHandle.TextScaled = true
    DragHandle.TextXAlignment = Enum.TextXAlignment.Left
    DragHandle.Parent = MainFrame
    AddRainbowGlow(DragHandle, 2)

    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.new(0, 22, 1, 0)
    MinBtn.Position = UDim2.new(1, -22, 0, 0)
    MinBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    MinBtn.Text = "➖"
    MinBtn.TextColor3 = Color3.new(1, 1, 1)
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.TextScaled = true
    MinBtn.Parent = MainFrame
    AddRainbowGlow(MinBtn, 2)

    -- BUTTON HELPER
    local function CreateButton(text, pos, color, callback)
        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(0, 90, 0, 30)
        Btn.Position = pos
        Btn.BackgroundColor3 = color
        Btn.Text = text
        Btn.TextColor3 = Color3.new(1, 1, 1)
        Btn.Font = Enum.Font.GothamBold
        Btn.TextScaled = true
        Btn.Parent = MainFrame
        Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
        AddRainbowGlow(Btn, 2)
        Btn.MouseButton1Click:Connect(callback)
        table.insert(MainButtons, Btn)
        return Btn
    end

    -- MAIN BUTTONS
    ESPBtn = CreateButton("ESP: OFF", UDim2.new(0, 10, 0, 30), Color3.fromRGB(40, 40, 40), function()
        ESP_Enabled = not ESP_Enabled
        ESPBtn.Text = ESP_Enabled and "ESP: ON" or "ESP: OFF"
        ESPBtn.BackgroundColor3 = ESP_Enabled and Color3.fromRGB(30, 160, 60) or Color3.fromRGB(40, 40, 40)
        if not ESP_Enabled then ClearAllESP() end
    end)

    CreateButton("📺 YOUTUBE", UDim2.new(0, 105, 0, 30), Color3.fromRGB(200, 30, 30), function()
        pcall(function() setclipboard(YOUTUBE_LINK) end)
    end)

    CreateButton("🎵 MUSIC", UDim2.new(0, 200, 0, 30), Color3.fromRGB(40, 80, 160), ToggleBoomboxMenu)

    LockBtn = CreateButton("🔓 UNLOCK", UDim2.new(0, 295, 0, 30), Color3.fromRGB(50, 50, 50), function()
        Buttons_Locked = not Buttons_Locked
        LockBtn.Text = Buttons_Locked and "🔒 LOCKED" or "🔓 UNLOCK"
        LockBtn.BackgroundColor3 = Buttons_Locked and Color3.fromRGB(80, 30, 30) or Color3.fromRGB(50, 50, 50)
    end)

    CreateButton("💻 CONSOLE", UDim2.new(0, 390, 0, 30), Color3.fromRGB(30, 120, 90), ToggleConsole)

    -- MAIN GUI VOLUME
    local VolLabel = Instance.new("TextLabel")
    VolLabel.Size = UDim2.new(0, 80, 0, 25)
    VolLabel.Position = UDim2.new(0, 490, 0, 32)
    VolLabel.BackgroundTransparency = 1
    VolLabel.Text = "🔊 VOLUME:"
    VolLabel.Font = Enum.Font.GothamBold
    VolLabel.TextScaled = true
    VolLabel.Parent = MainFrame
    table.insert(MainButtons, VolLabel)

    VolNumMain = Instance.new("TextLabel")
    VolNumMain.Size = UDim2.new(0, 45, 0, 25)
    VolNumMain.Position = UDim2.new(0, 575, 0, 32)
    VolNumMain.BackgroundTransparency = 1
    VolNumMain.Text = tostring(MusicVolume)
    VolNumMain.Font = Enum.Font.GothamBold
    VolNumMain.TextScaled = true
    VolNumMain.Parent = MainFrame
    table.insert(MainButtons, VolNumMain)

    local VolBGMain = Instance.new("Frame")
    VolBGMain.Size = UDim2.new(0, 150, 0, 22)
    VolBGMain.Position = UDim2.new(0, 490, 0, 60)
    VolBGMain.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    VolBGMain.Active = true
    VolBGMain.Parent = MainFrame
    Instance.new("UICorner", VolBGMain).CornerRadius = UDim.new(0, 11)
    AddRainbowGlow(VolBGMain, 2)
    table.insert(MainButtons, VolBGMain)

    VolFillMain = Instance.new("Frame")
    VolFillMain.Size = UDim2.new(MusicVolume / VOLUME_MAX, 0, 1, 0)
    VolFillMain.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    VolFillMain.Parent = VolBGMain
    Instance.new("UICorner", VolFillMain).CornerRadius = UDim.new(0, 11)

    local MainSliderActive = false
    VolBGMain.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            MainSliderActive = true
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            MainSliderActive = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if MainSliderActive and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local RelPos = math.clamp((input.Position.X - VolBGMain.AbsolutePosition.X) / VolBGMain.AbsoluteSize.X, 0, 1)
            UpdateVolume(math.floor(RelPos * VOLUME_MAX))
        end
    end)

    -- EXIT BUTTON WITH CONFIRMATION
    local ExitBtn = CreateButton("🗑️ EXIT", UDim2.new(0, 620, 0, 30), Color3.fromRGB(140, 20, 20), function()
        local ConfirmUI = Instance.new("ScreenGui")
        ConfirmUI.Name = "BLUE_MODE_EXIT_CONFIRM"
        ConfirmUI.ResetOnSpawn = false
        ConfirmUI.DisplayOrder = PRIORITY.EXIT_CONFIRM
        ConfirmUI.Parent = GuiContainer

        local ConfirmBox = Instance.new("Frame")
        ConfirmBox.Size = UDim2.new(0, 350, 0, 180)
        ConfirmBox.Position = UDim2.new(0.5, -175, 0.5, -90)
        ConfirmBox.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
        ConfirmBox.Active = true
        ConfirmBox.Parent = ConfirmUI
        Instance.new("UICorner", ConfirmBox).CornerRadius = UDim.new(0, 16)
        AddRainbowGlow(ConfirmBox, 4)

        local ConfirmTitle = Instance.new("TextLabel")
        ConfirmTitle.Size = UDim2.new(1, -40, 0, 50)
        ConfirmTitle.Position = UDim2.new(0, 20, 0, 15)
        ConfirmTitle.BackgroundTransparency = 1
        ConfirmTitle.Font = Enum.Font.GothamBold
        ConfirmTitle.TextScaled = true
        ConfirmTitle.Text = "⚠️ ARE YOU SURE YOU WANT TO EXIT?"
        ConfirmTitle.Parent = ConfirmBox

        local ConfirmSub = Instance.new("TextLabel")
        ConfirmSub.Size = UDim2.new(1, -40, 0, 35)
        ConfirmSub.Position = UDim2.new(0, 20, 0, 70)
        ConfirmSub.BackgroundTransparency = 1
        ConfirmSub.Font = Enum.Font.Gotham
        ConfirmSub.TextScaled = true
        ConfirmSub.Text = "This will close Blue Mode HUB completely"
        ConfirmSub.TextColor3 = Color3.fromRGB(200, 200, 200)
        ConfirmSub.Parent = ConfirmBox

        local YesBtn = Instance.new("TextButton")
        YesBtn.Size = UDim2.new(0, 130, 0, 40)
        YesBtn.Position = UDim2.new(0, 30, 0, 120)
        YesBtn.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
        YesBtn.Text = "✅ YES, EXIT"
        YesBtn.TextColor3 = Color3.new(1, 1, 1)
        YesBtn.Font = Enum.Font.GothamBold
        YesBtn.TextScaled = true
        YesBtn.Parent = ConfirmBox
        Instance.new("UICorner", YesBtn).CornerRadius = UDim.new(0, 10)
        AddRainbowGlow(YesBtn, 2)

        local NoBtn = Instance.new("TextButton")
        NoBtn.Size = UDim2.new(0, 130, 0, 40)
        NoBtn.Position = UDim2.new(1, -160, 0, 120)
        NoBtn.BackgroundColor3 = Color3.fromRGB(30, 120, 70)
        NoBtn.Text = "❌ CANCEL"
        NoBtn.TextColor3 = Color3.new(1, 1, 1)
        NoBtn.Font = Enum.Font.GothamBold
        NoBtn.TextScaled = true
        NoBtn.Parent = ConfirmBox
        Instance.new("UICorner", NoBtn).CornerRadius = UDim.new(0, 10)
        AddRainbowGlow(NoBtn, 2)

        YesBtn.MouseButton1Click:Connect(function() ConfirmUI:Destroy() FullDeleteHub() end)
        NoBtn.MouseButton1Click:Connect(function() ConfirmUI:Destroy() end)
    end)

    -- MINIMIZE LOGIC
    MinBtn.MouseButton1Click:Connect(function()
        IsMinimized = not IsMinimized
        MainFrame.Size = IsMinimized and MINI_SIZE or FULL_SIZE
        MinBtn.Text = IsMinimized and "➕" or "➖"
        for _, Element in pairs(MainButtons) do
            Element.Visible = not IsMinimized
        end
    end)

    -- DRAG LOGIC
    DragHandle.InputBegan:Connect(function(input)
        if Buttons_Locked then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            DragStart = input.Position
            StartPos = MainFrame.Position
            GuiFocused = true
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if Buttons_Locked or not DragStart or (input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch) then return end
        local Delta = input.Position - DragStart
        MainFrame.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            DragStart = nil
            GuiFocused = false
        end
    end)

    -- FULL BODY RAINBOW ESP LOOP
    RunService.Heartbeat:Connect(function(dt)
        Hue = (Hue + dt * 0.25) % 1
        local RainbowCol = Color3.fromHSV(Hue, 1, 1)

        -- UPDATE ALL RAINBOW TEXT
        for _, Element in pairs(GuiElements) do
            if Element.ClassName == "UIStroke" then Element.Color = RainbowCol end
        end
        StartupTitle.TextColor3 = RainbowCol

        if ESP_Enabled then
            for _, Player in pairs(Players:GetPlayers()) do
                if Player ~= LocalPlayer and Player.Character and Player.Character:FindFirstChild("Humanoid") then
                    local Char = Player.Character
                    local Hum = Char.Humanoid
                    if Hum.Health <= 0 then continue end

                    -- FULL BODY OUTLINE
                    if not Char:FindFirstChild("BLUE_FULLBODY_OUTLINE") then
                        local Outline = Instance.new("Highlight")
                        Outline.Name = "BLUE_FULLBODY_OUTLINE"
                        Outline.Adornee = Char
                        Outline.FillTransparency = 1
                        Outline.OutlineTransparency = 0
                        Outline.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        Outline.OutlineColor = RainbowCol
                        Outline.Parent = Char
                    end
                    local Outline = Char.BLUE_FULLBODY_OUTLINE

                    -- OWNER SETTINGS
                    if Player.Name == OWNER_NAME then
                        Outline.OutlineColor = Color3.fromRGB(255, 215, 0)
                        if not Char:FindFirstChild("OwnerCrown") then
                            local Crown = Instance.new("BillboardGui")
                            Crown.Name = "OwnerCrown"
                            Crown.Size = UDim2.new(0, 50, 0, 50)
                            Crown.StudsOffset = Vector3.new(0, 4.5, 0)
                            Crown.AlwaysOnTop = true
                            Crown.NeedsUpdate = false
                            Crown.Parent = Char.Head
                            local Icon = Instance.new("TextLabel")
                            Icon.Size = UDim2.new(1, 0, 1, 0)
                            Icon.BackgroundTransparency = 1
                            Icon.Text = "👑"
                            Icon.TextScaled = true
                            Icon.Font = Enum.Font.GothamBold
                            Icon.Parent = Crown
                        end

                    -- FRIEND SETTINGS
                    elseif Player:IsFriendsWith(LocalPlayer.UserId) then
                        Outline.OutlineColor = RainbowCol
                        if not Char:FindFirstChild("FriendRainbowDot") then
                            local Dot = Instance.new("BillboardGui")
                            Dot.Name = "FriendRainbowDot"
                            Dot.Size = UDim2.new(0, 22, 0, 22)
                            Dot.StudsOffset = Vector3.new(0, 3.2, 0)
                            Dot.AlwaysOnTop = true
                            Dot.NeedsUpdate = false
                            Dot.Parent = Char.Head
                            local Indicator = Instance.new("Frame")
                            Indicator.Size = UDim2.new(1, 0, 1, 0)
                            Indicator.BackgroundColor3 = RainbowCol
                            Indicator.CornerRadius = UDim.new(1, 0)
                            AddRainbowGlow(Indicator, 3)
                            Indicator.Parent = Dot
                        else
                            Char.FriendRainbowDot.Frame.BackgroundColor3 = RainbowCol
                            Char.FriendRainbowDot.Frame.RainbowAura.Color = RainbowCol
                        end

                    -- NORMAL PLAYER
                    else
                        Outline.OutlineColor = RainbowCol
                    end
                end
            end
        end
    end)

    print("✅ BLUE MODE HUB FULLY LOADED SUCCESSFULLY")
end

-- ==============================================
-- END OF FULL SCRIPT
-- ==============================================
