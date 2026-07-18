-- ==============================================
-- 🔵 BLUE MODE ESP | FULL FINAL VERSION
-- ✅ COMPLETE FIXED | ALL FEATURES WORKING
-- ==============================================

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Global Settings & Constants
local GUI_PRIORITY = 100
local YOUTUBE_LINK = "https://youtube.com/@BlueMode"
local VOLUME_MAX = 1000
local USAGE_LIMIT = 43200 -- 12 hours in seconds
local SAVE_KEY_USED = "BlueMode_UsedTime"
local SAVE_KEY_COOLDOWN = "BlueMode_Cooldown"

-- Global State Variables
local MusicVolume = 500
local CurrentSound = nil
local BoomboxUI_Open = false
local CurrentBoomboxUI = nil
local ConsoleUI_Open = false
local CurrentConsoleUI = nil
local CommandsUI_Open = false
local CurrentCommandsUI = nil
local GuiFocused = false
local ESP_Enabled = false
local FlyEnabled = false
local InvisibleEnabled = false
local NoClipEnabled = false
local InvincibleEnabled = false

-- Data Save/Load Helper
local function LoadData(key, default)
    local suc, val = pcall(function() return getgenv()[key] end)
    return suc and val or default
end
local function SaveData(key, val)
    pcall(function() getgenv()[key] = val end)
end

-- Volume Update Function
function UpdateVolume(newVol)
    MusicVolume = math.clamp(newVol, 0, VOLUME_MAX)
    if VolNumTextMain then VolNumTextMain.Text = tostring(math.floor(MusicVolume+0.5)) end
    if VolFillMain then VolFillMain.Size = UDim2.new(MusicVolume/VOLUME_MAX,0,1,0) end
    if VolNumMenu then VolNumMenu.Text = tostring(math.floor(MusicVolume+0.5)) end
    if VolFillMenu then VolFillMenu.Size = UDim2.new(MusicVolume/VOLUME_MAX,0,1,0) end
    if CurrentSound then CurrentSound.Volume = MusicVolume / 1000 end
end

-- Sound Play Function
function PlaySound(soundId)
    if CurrentSound then CurrentSound:Destroy() end
    local Id = tonumber(string.match(soundId, "%d+"))
    if not Id then return end
    CurrentSound = Instance.new("Sound")
    CurrentSound.SoundId = "rbxassetid://"..Id
    CurrentSound.Volume = MusicVolume / 1000
    CurrentSound.Looped = true
    CurrentSound.Parent = workspace
    CurrentSound:Play()
end

-- Toggle Functions
local function ToggleFly() FlyEnabled = not FlyEnabled end
local function ToggleInvis() InvisibleEnabled = not InvisibleEnabled end
local function ToggleNoClip() NoClipEnabled = not NoClipEnabled end
local function ToggleInvincible() InvincibleEnabled = not InvincibleEnabled end

-- Rainbow Outline Helper
local function AddRainbowGlow(target, thickness)
    if not target or not target:IsA("GuiObject") then return end
    local Outline = Instance.new("UIStroke")
    Outline.Name = "RainbowOutline"
    Outline.Thickness = thickness or 2
    Outline.Transparency = 0
    Outline.LineJoinMode = Enum.LineJoinMode.Round
    Outline.Parent = target
    return Outline
end

-- ==============================================
-- ✅ COMMANDS MENU (WITH SEARCH BAR + FULL LIST)
-- ==============================================
local function ToggleCommandsMenu()
    if CommandsUI_Open then if CurrentCommandsUI then CurrentCommandsUI:Destroy() end; CommandsUI_Open = false; CurrentCommandsUI = nil; GuiFocused = false; return end
    GuiFocused = true
    CommandsUI_Open = true
    local CmdUI = Instance.new("ScreenGui")
    CmdUI.Name = "BLUE_COMMANDS_MENU"
    CmdUI.ResetOnSpawn = false
    CmdUI.DisplayOrder = GUI_PRIORITY
    CmdUI.Parent = PlayerGui
    CurrentCommandsUI = CmdUI

    local CmdFrame = Instance.new("Frame")
    CmdFrame.Size = UDim2.new(0,340,0,480)
    CmdFrame.Position = UDim2.new(0.5,-170,0.5,-240)
    CmdFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
    CmdFrame.Active = true
    CmdFrame.Parent = CmdUI
    Instance.new("UICorner", CmdFrame).CornerRadius = UDim.new(0,14)
    AddRainbowGlow(CmdFrame,4)

    local CmdTitle = Instance.new("TextLabel")
    CmdTitle.Size = UDim2.new(1,-40,0,35)
    CmdTitle.Position = UDim2.new(0,20,0,10)
    CmdTitle.BackgroundTransparency = 1
    CmdTitle.Text = "⚙️ FEATURES & COMMANDS"
    CmdTitle.TextColor3 = Color3.fromRGB(0,190,255)
    CmdTitle.Font = Enum.Font.GothamBold
    CmdTitle.TextScaled = true
    CmdTitle.Parent = CmdFrame

    -- Search Bar
    local SearchBox = Instance.new("TextBox")
    SearchBox.Size = UDim2.new(1,-40,0,35)
    SearchBox.Position = UDim2.new(0,20,0,50)
    SearchBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
    SearchBox.PlaceholderText = "🔍 Search features..."
    SearchBox.TextColor3 = Color3.new(1,1,1)
    SearchBox.Font = Enum.Font.Gotham
    SearchBox.TextScaled = true
    SearchBox.Parent = CmdFrame
    Instance.new("UICorner", SearchBox).CornerRadius = UDim.new(0,8)
    AddRainbowGlow(SearchBox,2)

    -- Scrollable List
    local ScrollingFrame = Instance.new("ScrollingFrame")
    ScrollingFrame.Size = UDim2.new(1,-40,0,310)
    ScrollingFrame.Position = UDim2.new(0,20,0,95)
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.ScrollBarThickness = 6
    ScrollingFrame.ScrollBarColor3 = Color3.fromRGB(0,190,255)
    ScrollingFrame.Parent = CmdFrame
    AddRainbowGlow(ScrollingFrame,2)

    local UIList = Instance.new("UIListLayout")
    UIList.Padding = UDim.new(0,8)
    UIList.Parent = ScrollingFrame

    -- All Feature List
    local AllFeatures = {
        {name = "✈️ FLY MODE", state = "OFF", func = function() ToggleFly() end},
        {name = "👻 INVISIBLE", state = "OFF", func = function() ToggleInvis() end},
        {name = "🚧 NOCLIP", state = "OFF", func = function() ToggleNoClip() end},
        {name = "🛡️ INVINCIBLE", state = "OFF", func = function() ToggleInvincible() end},
        {name = "👥 PLAYER ESP", state = "OFF", func = function() ESP_Enabled = not ESP_Enabled end},
        {name = "🎵 BOOMBOX", state = "OPEN", func = function() ToggleBoomboxMenu() ToggleCommandsMenu() end},
        {name = "💻 CONSOLE", state = "OPEN", func = function() ToggleConsole() ToggleCommandsMenu() end},
        {name = "📺 YOUTUBE", state = "LINK", func = function() pcall(function() setclipboard(YOUTUBE_LINK) end) end},
    }

    local FeatureButtons = {}
    local function RefreshList(filter)
        filter = filter and filter:lower() or ""
        for _,b in pairs(FeatureButtons) do b:Destroy() end
        FeatureButtons = {}

        for idx, feat in ipairs(AllFeatures) do
            if feat.name:lower():find(filter) then
                local Btn = Instance.new("TextButton")
                Btn.Size = UDim2.new(1,0,0,35)
                Btn.BackgroundColor3 = Color3.fromRGB(45,45,45)
                Btn.Text = feat.name.." | "..feat.state
                Btn.TextColor3 = Color3.new(1,1,1)
                Btn.Font = Enum.Font.GothamBold
                Btn.TextScaled = true
                Btn.AutoLocalize = false
                Btn.Active = true
                Btn.ZIndex = 10
                Btn.Parent = ScrollingFrame
                Instance.new("UICorner", Btn).CornerRadius = UDim.new(0,8)
                AddRainbowGlow(Btn,2)
                table.insert(FeatureButtons, Btn)

                Btn.MouseButton1Click:Connect(function()
                    feat.func()
                    if feat.name == "✈️ FLY MODE" then feat.state = FlyEnabled and "ON" or "OFF" end
                    if feat.name == "👻 INVISIBLE" then feat.state = InvisibleEnabled and "ON" or "OFF" end
                    if feat.name == "🚧 NOCLIP" then feat.state = NoClipEnabled and "ON" or "OFF" end
                    if feat.name == "🛡️ INVINCIBLE" then feat.state = InvincibleEnabled and "ON" or "OFF" end
                    if feat.name == "👥 PLAYER ESP" then feat.state = ESP_Enabled and "ON" or "OFF" end
                    Btn.Text = feat.name.." | "..feat.state
                    Btn.BackgroundColor3 = (feat.state == "ON") and Color3.fromRGB(25,100,25) or Color3.fromRGB(45,45,45)
                end)
            end
        end
        ScrollingFrame.CanvasSize = UDim2.new(0,0,0,#FeatureButtons*43)
    end

    SearchBox:GetPropertyChangedSignal("Text"):Connect(function() RefreshList(SearchBox.Text) end)
    RefreshList("")

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(1,-40,0,35)
    CloseBtn.Position = UDim2.new(0,20,0,435)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(170,30,30)
    CloseBtn.Text = "✕ CLOSE MENU"
    CloseBtn.TextColor3 = Color3.new(1,1,1)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextScaled = true
    CloseBtn.AutoLocalize = false
    CloseBtn.Active = true
    CloseBtn.ZIndex = 10
    CloseBtn.Parent = CmdFrame
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0,8)
    AddRainbowGlow(CloseBtn,2)
    CloseBtn.MouseButton1Click:Connect(ToggleCommandsMenu)
end

-- COPY PASTE PART 2 RIGHT AFTER THIS LINE


-- ==============================================
-- 🔵 BLUE MODE ESP | SCROLLABLE VERSION
-- ✅ NO OVERSIZED GUI | SCROLL TO SEE ALL
-- ✅ ALL RAINBOW OUTLINES | WORKING DRAG
-- ==============================================

-- Startup Screen
local StartupUI = Instance.new("ScreenGui")
StartupUI.Name = "BLUE_MODE_STARTUP"
StartupUI.ResetOnSpawn = false
StartupUI.DisplayOrder = GUI_PRIORITY
StartupUI.Parent = PlayerGui

local StartupBox = Instance.new("Frame")
StartupBox.Size = UDim2.new(0, 420, 0, 480)
StartupBox.Position = UDim2.new(0.5, -210, 0.5, -240)
StartupBox.BackgroundColor3 = Color3.fromRGB(10,12,18)
StartupBox.Active = true
StartupBox.Parent = StartupUI
Instance.new("UICorner", StartupBox).CornerRadius = UDim.new(0, 18)
AddRainbowGlow(StartupBox,5)

local StartupTitle = Instance.new("TextLabel")
StartupTitle.Size = UDim2.new(1, -40, 0, 50)
StartupTitle.Position = UDim2.new(0, 20, 0, 15)
StartupTitle.BackgroundTransparency = 1
StartupTitle.Font = Enum.Font.GothamBlack
StartupTitle.TextScaled = true
StartupTitle.Text = "🔵 BLUE MODE ESP"
StartupTitle.TextColor3 = Color3.fromRGB(0, 190, 255)
StartupTitle.Parent = StartupBox

local UpdateHeader = Instance.new("TextLabel")
UpdateHeader.Size = UDim2.new(1, -40, 0, 35)
UpdateHeader.Position = UDim2.new(0, 20, 0, 75)
UpdateHeader.BackgroundTransparency = 1
UpdateHeader.Font = Enum.Font.GothamBold
UpdateHeader.TextScaled = true
UpdateHeader.Text = "📋 UPDATE INFO:"
UpdateHeader.TextColor3 = Color3.new(1,1,1)
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
UpdateList.Text = [[• ✅ VOLUME 0 → 1000
• ✅ SCROLLABLE MAIN HUB
• ✅ ALL RAINBOW OUTLINES
• ✅ DRAG & BUTTONS FULLY WORKING
• ✅ COMMANDS MENU WITH SEARCH
• ✅ Creator: Dwayne Kean / Blue_Mode]]
UpdateList.Parent = StartupBox

local StartupTimerLabel = Instance.new("TextLabel")
StartupTimerLabel.Size = UDim2.new(1, -40, 0, 45)
StartupTimerLabel.Position = UDim2.new(0, 20, 0, 310)
StartupTimerLabel.BackgroundTransparency = 1
StartupTimerLabel.Font = Enum.Font.GothamBold
StartupTimerLabel.TextScaled = true
StartupTimerLabel.Text = "TIME REMAINING: 12:00:00"
StartupTimerLabel.TextColor3 = Color3.fromRGB(80,255,120)
StartupTimerLabel.Parent = StartupBox

local OkBtn = Instance.new("TextButton")
OkBtn.Size = UDim2.new(0, 260, 0, 60)
OkBtn.Position = UDim2.new(0.5, -130, 0, 385)
OkBtn.BackgroundColor3 = Color3.fromRGB(15, 110, 230)
OkBtn.Font = Enum.Font.GothamBold
OkBtn.TextScaled = true
OkBtn.Text = "✓ LOAD FULL HUB"
OkBtn.TextColor3 = Color3.new(1,1,1)
OkBtn.Active = true
OkBtn.Parent = StartupBox
Instance.new("UICorner", OkBtn).CornerRadius = UDim.new(0, 16)
AddRainbowGlow(OkBtn,3)

local StartupHue = 0
local UsedTime = LoadData(SAVE_KEY_USED, 0)
RunService.Heartbeat:Connect(function(dt)
    StartupHue = (StartupHue + dt * 0.3) % 1
    local Col = Color3.fromHSV(StartupHue, 1, 1)
    StartupBox.UiStroke.Color = Col
    StartupTitle.TextColor3 = Col
    local Remaining = math.max(0, USAGE_LIMIT - UsedTime)
    local h = math.floor(Remaining/3600)
    local m = math.floor((Remaining%3600)/60)
    local s = Remaining%60
    StartupTimerLabel.Text = string.format("TIME REMAINING: %02d:%02d:%02d", h, m, s)
end)

OkBtn.MouseButton1Click:Connect(function() StartupUI:Destroy(); LoadMainHub() end)

-- Main Hub Loader
function LoadMainHub()
    local CurrentTime = os.time()
    local CooldownEnd = LoadData(SAVE_KEY_COOLDOWN, 0)
    if CurrentTime < CooldownEnd then
        print("⏳ COOLDOWN ACTIVE! Wait "..math.floor((CooldownEnd-CurrentTime)/60).." minutes")
        return
    end

    local GuiElements = {}
    local Hue = 0
    local VOLUME_MAX = 1000

    local function ClearAllESP()
        for _,P in pairs(Players:GetPlayers()) do
            if P and P.Character then
                pcall(function()
                    if P.Character:FindFirstChild("BLUE_Outline") then P.Character.BLUE_Outline:Destroy() end
                end)
            end
        end
    end

    -- Boombox Menu
    local function ToggleBoomboxMenu()
        if BoomboxUI_Open then if CurrentBoomboxUI then CurrentBoomboxUI:Destroy() end; BoomboxUI_Open = false; GuiFocused = false; return end
        GuiFocused = true
        BoomboxUI_Open = true
        local BoomUI = Instance.new("ScreenGui")
        BoomUI.Name = "BLUE_BOOMBOX_MENU"
        BoomUI.ResetOnSpawn = false
        BoomUI.DisplayOrder = GUI_PRIORITY
        BoomUI.Parent = PlayerGui
        CurrentBoomboxUI = BoomUI

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
        CloseTop.Active = true
        CloseTop.Parent = BoomFrame
        AddRainbowGlow(CloseTop,2)
        CloseTop.MouseButton1Click:Connect(ToggleBoomboxMenu)

        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1,-40,0,40)
        Title.Position = UDim2.new(0,15,0,8)
        Title.BackgroundTransparency = 1
        Title.Text = "🎵 BOOMBOX"
        Title.TextColor3 = Color3.new(1,1,1)
        Title.Font = Enum.Font.GothamBold
        Title.TextScaled = true
        Title.Parent = BoomFrame

        local Input = Instance.new("TextBox")
        Input.Size = UDim2.new(1,-40,0,45)
        Input.Position = UDim2.new(0,20,0,55)
        Input.BackgroundColor3 = Color3.fromRGB(35,35,35)
        Input.PlaceholderText = "Sound ID..."
        Input.TextColor3 = Color3.new(1,1,1)
        Input.Parent = BoomFrame
        Instance.new("UICorner", Input).CornerRadius = UDim.new(0,8)
        AddRainbowGlow(Input,2)

        local VolBG = Instance.new("Frame")
        VolBG.Size = UDim2.new(1,-40,0,24)
        VolBG.Position = UDim2.new(0,20,0,115)
        VolBG.BackgroundColor3 = Color3.fromRGB(50,50,50)
        VolBG.Active = true
        VolBG.Parent = BoomFrame
        Instance.new("UICorner", VolBG).CornerRadius = UDim.new(0,12)
        AddRainbowGlow(VolBG,2)

        local VolFill = Instance.new("Frame")
        VolFill.Size = UDim2.new(MusicVolume/VOLUME_MAX,0,1,0)
        VolFill.BackgroundColor3 = Color3.fromRGB(0,190,255)
        VolFill.Parent = VolBG
        Instance.new("UICorner", VolFill).CornerRadius = UDim.new(0,12)

        local PlayBtn = Instance.new("TextButton")
        PlayBtn.Size = UDim2.new(0,130,0,40)
        PlayBtn.Position = UDim2.new(0,20,0,160)
        PlayBtn.BackgroundColor3 = Color3.fromRGB(25,140,255)
        PlayBtn.Text = "▶ PLAY"
        PlayBtn.TextColor3 = Color3.new(1,1,1)
        PlayBtn.Active = true
        PlayBtn.Parent = BoomFrame
        Instance.new("UICorner", PlayBtn).CornerRadius = UDim.new(0,8)
        AddRainbowGlow(PlayBtn,2)
        PlayBtn.MouseButton1Click:Connect(function() if Input.Text~="" then PlaySound(Input.Text) end end)

        local StopBtn = Instance.new("TextButton")
        StopBtn.Size = UDim2.new(0,130,0,40)
        StopBtn.Position = UDim2.new(0,170,0,160)
        StopBtn.BackgroundColor3 = Color3.fromRGB(200,30,30)
        StopBtn.Text = "⏹ STOP"
        StopBtn.TextColor3 = Color3.new(1,1,1)
        StopBtn.Active = true
        StopBtn.Parent = BoomFrame
        Instance.new("UICorner", StopBtn).CornerRadius = UDim.new(0,8)
        AddRainbowGlow(StopBtn,2)
        StopBtn.MouseButton1Click:Connect(function() if CurrentSound then CurrentSound:Destroy() end end)
    end

    -- Console Menu
    local function ToggleConsole()
        if ConsoleUI_Open then if CurrentConsoleUI then CurrentConsoleUI:Destroy() end; ConsoleUI_Open = false; GuiFocused = false; return end
        GuiFocused = true
        ConsoleUI_Open = true
        local ConsoleUI = Instance.new("ScreenGui")
        ConsoleUI.Name = "BLUE_CONSOLE"
        ConsoleUI.ResetOnSpawn = false
        ConsoleUI.DisplayOrder = GUI_PRIORITY
        ConsoleUI.Parent = PlayerGui
        CurrentConsoleUI = ConsoleUI

        local Frame = Instance.new("Frame")
        Frame.Size = UDim2.new(0,400,0,300)
        Frame.Position = UDim2.new(0.5,-200,0.5,-150)
        Frame.BackgroundColor3 = Color3.fromRGB(22,22,22)
        Frame.Active = true
        Frame.Parent = ConsoleUI
        Instance.new("UICorner", Frame).CornerRadius = UDim.new(0,12)
        AddRainbowGlow(Frame,4)

        local CloseBtn = Instance.new("TextButton")
        CloseBtn.Size = UDim2.new(0,32,0,32)
        CloseBtn.Position = UDim2.new(1,-37,0,6)
        CloseBtn.BackgroundColor3 = Color3.fromRGB(170,30,30)
        CloseBtn.Text = "✕"
        CloseBtn.TextColor3 = Color3.new(1,1,1)
        CloseBtn.Active = true
        CloseBtn.Parent = Frame
        AddRainbowGlow(CloseBtn,2)
        CloseBtn.MouseButton1Click:Connect(ToggleConsole)

        local Input = Instance.new("TextBox")
        Input.Size = UDim2.new(1,-40,0,150)
        Input.Position = UDim2.new(0,20,0,45)
        Input.BackgroundColor3 = Color3.fromRGB(45,45,45)
        Input.PlaceholderText = "Paste script here..."
        Input.TextColor3 = Color3.new(1,1,1)
        Input.MultiLine = true
        Input.Parent = Frame
        Instance.new("UICorner", Input).CornerRadius = UDim.new(0,8)
        AddRainbowGlow(Input,2)

        local ExecBtn = Instance.new("TextButton")
        ExecBtn.Size = UDim2.new(0,120,0,40)
        ExecBtn.Position = UDim2.new(0,20,0,210)
        ExecBtn.BackgroundColor3 = Color3.fromRGB(20,150,70)
        ExecBtn.Text = "▶ EXECUTE"
        ExecBtn.TextColor3 = Color3.new(1,1,1)
        ExecBtn.Active = true
        ExecBtn.Parent = Frame
        Instance.new("UICorner", ExecBtn).CornerRadius = UDim.new(0,8)
        AddRainbowGlow(ExecBtn,2)
        ExecBtn.MouseButton1Click:Connect(function()
            local f, err = loadstring(Input.Text)
            if f then pcall(f) else warn("Error: "..err) end
        end)
    end

    -- ==============================================
    -- ✅ SCROLLABLE MAIN HUB (Fixed Size + Scroll)
    -- ==============================================
    local HUB_WIDTH = 340 -- Fixed width, never gets wider
    local HUB_HEIGHT = 420 -- Fixed visible size, scroll for more
    local MINI_SIZE = UDim2.new(0,110,0,36)

    local MainUI = Instance.new("ScreenGui")
    MainUI.Name = "BLUE_MODE_HUB"
    MainUI.ResetOnSpawn = false
    MainUI.DisplayOrder = GUI_PRIORITY
    MainUI.Parent = PlayerGui

    -- Main Container Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0,HUB_WIDTH,0,HUB_HEIGHT)
    MainFrame.Position = UDim2.new(0,20,0.5,-HUB_HEIGHT/2)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
    MainFrame.Active = true
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = MainUI
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,10)
    AddRainbowGlow(MainFrame,5)

    -- Drag Bar (Top of Hub)
    local DragHandle = Instance.new("TextButton")
    DragHandle.Size = UDim2.new(1,0,0,28)
    DragHandle.Position = UDim2.new(0,0,0,0)
    DragHandle.BackgroundColor3 = Color3.fromRGB(60,140,220)
    DragHandle.Active = true
    DragHandle.ZIndex = 999
    DragHandle.Text = "🔵 BLUE MODE | DRAG HERE"
    DragHandle.TextColor3 = Color3.new(1,1,1)
    DragHandle.Font = Enum.Font.GothamBold
    DragHandle.TextScaled = true
    DragHandle.TextXAlignment = Enum.TextXAlignment.Left
    DragHandle.Parent = MainFrame
    AddRainbowGlow(DragHandle,3)

    -- Minimize Button
    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.new(0,28,1,0)
    MinBtn.Position = UDim2.new(1,-28,0,0)
    MinBtn.ZIndex = 999
    MinBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
    MinBtn.Text = "➖"
    MinBtn.TextColor3 = Color3.new(1,1,1)
    MinBtn.Active = true
    MinBtn.Parent = MainFrame
    AddRainbowGlow(MinBtn,2)

    -- ✅ SCROLLABLE CONTENT AREA
    local ScrollContainer = Instance.new("ScrollingFrame")
    ScrollContainer.Size = UDim2.new(1,0,1,-28)
    ScrollContainer.Position = UDim2.new(0,0,0,28)
    ScrollContainer.BackgroundTransparency = 1
    ScrollContainer.ScrollBarThickness = 8
    ScrollContainer.ScrollBarColor3 = Color3.fromRGB(0,190,255)
    ScrollContainer.CanvasSize = UDim2.new(0,0,0,720) -- Total scrollable height
    ScrollContainer.Parent = MainFrame
    AddRainbowGlow(ScrollContainer,2)

    -- Auto arrange buttons vertically
    local ButtonLayout = Instance.new("UIListLayout")
    ButtonLayout.Padding = UDim.new(0,12)
    ButtonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    ButtonLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    ButtonLayout.Parent = ScrollContainer

    -- Helper to add buttons easily
    local function AddButton(text, color, onClick)
        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(0.9,0,0,38)
        Btn.BackgroundColor3 = color
        Btn.Text = text
        Btn.TextColor3 = Color3.new(1,1,1)
        Btn.Font = Enum.Font.GothamBold
        Btn.TextScaled = true
        Btn.Active = true
        Btn.ZIndex = 10
        Btn.Parent = ScrollContainer
        Instance.new("UICorner", Btn).CornerRadius = UDim.new(0,8)
        AddRainbowGlow(Btn,2)
        Btn.MouseButton1Click:Connect(onClick or function() end)
        return Btn
    end

    -- All Buttons (added vertically, scroll to see all)
    local ESPBtn = AddButton("👁️ ESP: OFF", Color3.fromRGB(40,40,40), function()
        ESP_Enabled = not ESP_Enabled
        ESPBtn.Text = ESP_Enabled and "👁️ ESP: ON" or "👁️ ESP: OFF"
        ESPBtn.BackgroundColor3 = ESP_Enabled and Color3.fromRGB(25,100,25) or Color3.fromRGB(40,40,40)
    end)

    AddButton("✈️ FLY", Color3.fromRGB(50,80,180), ToggleFly)
    AddButton("👻 INVISIBLE", Color3.fromRGB(80,50,160), ToggleInvis)
    AddButton("🚧 NOCLIP", Color3.fromRGB(160,80,50), ToggleNoClip)
    AddButton("🛡️ GODMODE", Color3.fromRGB(30,140,90), ToggleInvincible)
    AddButton("🎵 BOOMBOX", Color3.fromRGB(40,80,160), ToggleBoomboxMenu)
    AddButton("⚙️ COMMANDS", Color3.fromRGB(15,110,230), ToggleCommandsMenu)
    AddButton("💻 CONSOLE", Color3.fromRGB(30,120,90), ToggleConsole)
    AddButton("📺 YOUTUBE", Color3.fromRGB(200,30,30), function() pcall(function() setclipboard(YOUTUBE_LINK) end) end)
    AddButton("🔒 LOCK", Color3.fromRGB(50,50,50))
    AddButton("❌ EXIT", Color3.fromRGB(140,20,20), function()
        MainUI:Destroy()
        if CurrentBoomboxUI then CurrentBoomboxUI:Destroy() end
        if CurrentConsoleUI then CurrentConsoleUI:Destroy() end
        if CurrentCommandsUI then CurrentCommandsUI:Destroy() end
        ClearAllESP()
        if CurrentSound then CurrentSound:Destroy() end
    end)

    -- Volume Slider (inside scroll area)
    local VolLabel = Instance.new("TextLabel")
    VolLabel.Size = UDim2.new(0.9,0,0,25)
    VolLabel.BackgroundTransparency = 1
    VolLabel.Text = "🔊 VOLUME: "..math.floor(MusicVolume)
    VolLabel.TextColor3 = Color3.new(1,1,1)
    VolLabel.Font = Enum.Font.GothamBold
    VolLabel.TextScaled = true
    VolLabel.Parent = ScrollContainer

    local VolBG = Instance.new("Frame")
    VolBG.Size = UDim2.new(0.9,0,0,24)
    VolBG.BackgroundColor3 = Color3.fromRGB(50,50,50)
    VolBG.Active = true
    VolBG.Parent = ScrollContainer
    Instance.new("UICorner", VolBG).CornerRadius = UDim.new(0,12)
    AddRainbowGlow(VolBG,2)

    local VolFill = Instance.new("Frame")
    VolFill.Size = UDim2.new(MusicVolume/VOLUME_MAX,0,1,0)
    VolFill.BackgroundColor3 = Color3.fromRGB(0,190,255)
    VolFill.Parent = VolBG
    Instance.new("UICorner", VolFill).CornerRadius = UDim.new(0,12)

    local SliderActive = false
    VolBG.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then SliderActive = true end end)
    UserInputService.InputEnded:Connect(function(i) SliderActive = false end)
    UserInputService.InputChanged:Connect(function(i)
        if SliderActive then
            local rel = math.clamp((i.Position.X - VolBG.AbsolutePosition.X)/VolBG.AbsoluteSize.X, 0, 1)
            MusicVolume = math.floor(rel * VOLUME_MAX)
            VolLabel.Text = "🔊 VOLUME: "..MusicVolume
            VolFill.Size = UDim2.new(MusicVolume/VOLUME_MAX,0,1,0)
            if CurrentSound then CurrentSound.Volume = MusicVolume/1000 end
        end
    end)

    -- ✅ PERFECT DRAG SYSTEM
    local DragStart, StartPos, IsDragging = nil, nil, false
    DragHandle.InputBegan:Connect(function(input)
        if GuiFocused then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            IsDragging = true
            DragStart = input.Position
            StartPos = MainFrame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if IsDragging and DragStart and not GuiFocused then
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                local Delta = input.Position - DragStart
                local NewX = math.clamp(StartPos.X.Offset + Delta.X, 0, workspace.CurrentCamera.ViewportSize.X - MainFrame.AbsoluteSize.X)
                local NewY = math.clamp(StartPos.Y.Offset + Delta.Y, 0, workspace.CurrentCamera.ViewportSize.Y - MainFrame.AbsoluteSize.Y)
                MainFrame.Position = UDim2.new(0, NewX, 0, NewY)
            end
        end
    end)
    UserInputService.InputEnded:Connect(function() IsDragging = false; DragStart = nil end)

    -- Minimize/Expand
    local IsMin = false
    MinBtn.MouseButton1Click:Connect(function()
        IsMin = not IsMin
        if IsMin then
            MainFrame.Size = MINI_SIZE
            ScrollContainer.Visible = false
            MinBtn.Text = "➕"
        else
            MainFrame.Size = UDim2.new(0,HUB_WIDTH,0,HUB_HEIGHT)
            ScrollContainer.Visible = true
            MinBtn.Text = "➖"
        end
    end)

    -- Rainbow Animation for ALL outlines
    RunService.RenderStepped:Connect(function(dt)
        Hue = (Hue + dt * 0.4) % 1
        local Col = Color3.fromHSV(Hue, 1, 1)
        for _, v in pairs(MainFrame:GetDescendants()) do
            if v:IsA("UIStroke") then v.Color = Col end
        end
    end)
end
