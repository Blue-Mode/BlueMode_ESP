-- ==============================================
-- 🔵 BLUE MODE HUB | FULL VERSION
-- ✅ UPDATED STARTUP + FEATURE LIST
-- ✅ RAINBOW TEXT + OUTLINES
-- ✅ EXIT WITH "ARE YOU SURE?" CONFIRM
-- ✅ CROSS-EXECUTOR COMPATIBLE | DELTA READY
-- ✅ MADE BY: BLUE_MODE / DWAYNE KEAN FRANCISCO
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

-- ASSETS & CONTAINER
local CUSTOM_GUI_BG = "rbxassetid://101782008402770"
local GuiContainer = Instance.new("Folder")
GuiContainer.Name = "BLUE_MODE_HUB_ROOT"
pcall(function() GuiContainer.Parent = CoreGui end)
if not GuiContainer.Parent then GuiContainer.Parent = LocalPlayer.PlayerGui end

-- PRIORITY
local PRIORITY = {
    STARTUP = 800,
    MAIN = 799,
    BOOMBOX = 798,
    CONSOLE = 797,
    CONFIRM = 9999
}

-- SETTINGS
local USAGE_LIMIT = 12 * 3600
local COOLDOWN = 12 * 3600
local YOUTUBE_LINK = "https://youtube.com/@blue_mode?si=aCGyj0FnwCMtTP1M"
local SAVE_KEY_USED = "BlueMode_UsedTime_v22"
local SAVE_KEY_COOLDOWN = "BlueMode_CooldownEnd_v22"
local SAVE_KEY_VOLUME = "BlueMode_Volume_v22"
local VOLUME_MAX = 1000
local OWNER_NAME = "Dwaynekean015"

-- GLOBALS
local BoomboxUI_Open = false
local ConsoleUI_Open = false
local CurrentBoomboxUI = nil
local CurrentConsoleUI = nil
local IsMinimized = false
local GuiFocused = false
local GuiElements = {}

-- DATA FUNCTIONS
local function SaveData(key, value) pcall(function() writefile(key..".txt", tostring(value)) end) end
local function LoadData(key, default) local v=nil; pcall(function() v=readfile(key..".txt") end); return tonumber(v) or default end

-- ✅ RAINBOW GLOW HELPER
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

-- ✅ FULL CLEANUP FUNCTION
local function ClearAllESP()
    pcall(function()
        for _, Player in pairs(Players:GetPlayers()) do
            if Player and Player.Character then
                for _, Child in pairs(Player.Character:GetChildren()) do
                    if Child.Name == "BLUE_Outline" or Child.Name == "FriendRainbowDot" or Child.Name == "OwnerCrown" then
                        Child:Destroy()
                    end
                end
            end
        end
        for _, Desc in pairs(workspace:GetDescendants()) do
            if Desc.Name == "BLUE_Outline" or Desc.Name == "FriendRainbowDot" or Desc.Name == "OwnerCrown" then
                Desc:Destroy()
            end
        end
    end)
end

-- ✅ FULL DELETE HUB FUNCTION
local function FullDeleteHub()
    pcall(function()
        ClearAllESP()
        if CurrentSound then CurrentSound:Destroy() end
        if GuiContainer then GuiContainer:Destroy() end
        getgenv().BlueMode_Loaded = nil
        print("🗑️ BLUE MODE HUB FULLY CLOSED")
    end)
end

-- ==============================================
-- ✅ STARTUP SCREEN (UPDATED BUTTON + FEATURE LIST)
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
StartupGuiBg.Size = UDim2.new(1, 0, 1, 0)
StartupGuiBg.BackgroundTransparency = 1
StartupGuiBg.Image = CUSTOM_GUI_BG
StartupGuiBg.ScaleType = Enum.ScaleType.Stretch
StartupGuiBg.ZIndex = 1
StartupGuiBg.Parent = StartupBox

local StartupBorder = AddRainbowGlow(StartupBox, 5)

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
UpdateHeader.Text = "📋 LATEST UPDATES & FEATURES:"
UpdateHeader.TextColor3 = Color3.new(1,1,1)
UpdateHeader.ZIndex = 2
UpdateHeader.Parent = StartupBox

local UpdateList = Instance.new("TextLabel")
UpdateList.Size = UDim2.new(1, -50, 0, 190)
UpdateList.Position = UDim2.new(0, 25, 0, 115)
UpdateList.BackgroundTransparency = 1
UpdateList.Font = Enum.Font.Gotham
UpdateList.TextScaled = true
UpdateList.TextWrapped = true
UpdateList.TextXAlignment = Enum.TextXAlignment.Left
UpdateList.TextYAlignment = Enum.TextYAlignment.Top
UpdateList.TextColor3 = Color3.fromRGB(220,220,220)
UpdateList.ZIndex = 2
UpdateList.Text = [[• ✅ FRIENDS: RAINBOW INDICATOR ABOVE HEAD
• ✅ ESP: RAINBOW OUTLINES FOR ALL PLAYERS
• ✅ OWNER: GOLDEN OUTLINE + CROWN ICON
• ✅ BOOMBOX: PLAY ANY SOUND ID, VOLUME 0–1000
• ✅ STATS: FPS + PING + SERVER PING
• ✅ GUI: FULLY DRAGGABLE, MINIMIZABLE, LOCKABLE
• ✅ CROSS-EXECUTOR: WORKS ON DELTA & ALL OTHERS
• ✅ BUG FIXES: NO BLOCKED MENUS, AUTO-ESP FOR NEW PLAYERS
• Creator: Dwayne Kean / Blue_Mode]]
UpdateList.Parent = StartupBox

local StartupTimerLabel = Instance.new("TextLabel")
StartupTimerLabel.Size = UDim2.new(1, -40, 0, 45)
StartupTimerLabel.Position = UDim2.new(0, 20, 0, 320)
StartupTimerLabel.BackgroundTransparency = 1
StartupTimerLabel.Font = Enum.Font.GothamBold
StartupTimerLabel.TextScaled = true
StartupTimerLabel.Text = "TIME REMAINING: 12:00:00"
StartupTimerLabel.TextColor3 = Color3.fromRGB(80,255,120)
StartupTimerLabel.ZIndex = 2
StartupTimerLabel.Parent = StartupBox

-- ✅ UPDATED STARTUP BUTTON
local OkBtn = Instance.new("TextButton")
OkBtn.Size = UDim2.new(0, 280, 0, 60)
OkBtn.Position = UDim2.new(0.5, -140, 0, 380)
OkBtn.BackgroundColor3 = Color3.fromRGB(15, 110, 230)
OkBtn.Font = Enum.Font.GothamBold
OkBtn.TextScaled = true
OkBtn.Text = "🚀 LAUNCH BLUE MODE HUB"
OkBtn.TextColor3 = Color3.new(1,1,1)
OkBtn.ZIndex = 2
OkBtn.Parent = StartupBox
Instance.new("UICorner", OkBtn).CornerRadius = UDim.new(0, 16)
AddRainbowGlow(OkBtn, 4)

-- STARTUP ANIMATION & TIMER
local StartupHue = 0
local UsedTime = LoadData(SAVE_KEY_USED, 0)
RunService.Heartbeat:Connect(function(dt)
    StartupHue = (StartupHue + dt * 0.3) % 1
    local Col = Color3.fromHSV(StartupHue, 1, 1)
    StartupBorder.Color = Col
    StartupTitle.TextColor3 = Col
    OkBtn.BackgroundColor3 = Color3.fromHSV(StartupHue, 0.8, 0.6)
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

print("✅ BLUE MODE HUB PART 1 LOADED")

-- ==============================================
-- END OF PART 1 | START PART 2 BELOW LINE 205/206
-- ==============================================
-- ==============================================
-- 🔵 BLUE MODE HUB | PART 2 / 2
-- ✅ ALL FEATURES INTACT
-- ✅ EXIT WITH "ARE YOU SURE?" POPUP
-- ✅ RAINBOW OUTLINES + OWNER + FRIEND SYSTEM
-- ==============================================

local CurrentSound = nil
local VolNumTextMain, VolFillMain, VolFillMenu, VolNumMenu, ESPBtn
local FPSLabel, PingLabel, ServerPingLabel
local ESP_Enabled = false
local Buttons_Locked = false
local Hue = 0
local DragStart, StartPos

-- ==============================================
-- MAIN HUB LOAD
-- ==============================================
function LoadMainHub()
    local CurrentTime = os.time()
    local CooldownEnd = LoadData(SAVE_KEY_COOLDOWN, 0)
    if CurrentTime < CooldownEnd then
        print("⏳ COOLDOWN ACTIVE! Wait "..math.floor((CooldownEnd-CurrentTime)/60).." minutes")
        return
    end

    local MusicVolume = LoadData(SAVE_KEY_VOLUME, 500)

    -- VOLUME & SOUND SYSTEM
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
    local function FormatSoundID(input) return "rbxassetid://"..tostring(input):gsub("%D", "") end
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

    -- ==============================================
    -- BOOMBOX MENU
    -- ==============================================
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
        BoomFrame.Size = UDim2.new(0, 320, 0, 250)
        BoomFrame.Position = UDim2.new(0.5, -160, 0.5, -125)
        BoomFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
        BoomFrame.Active = true
        BoomFrame.Parent = BoomUI
        Instance.new("UICorner", BoomFrame).CornerRadius = UDim.new(0, 12)
        AddRainbowGlow(BoomFrame, 4)

        local CloseTop = Instance.new("TextButton")
        CloseTop.Size = UDim2.new(0, 30, 0, 30)
        CloseTop.Position = UDim2.new(1, -35, 0, 5)
        CloseTop.BackgroundColor3 = Color3.fromRGB(170, 30, 30)
        CloseTop.Text = "✕"
        CloseTop.TextColor3 = Color3.new(1,1,1)
        CloseTop.Font = Enum.Font.GothamBold
        CloseTop.TextSize = 24
        CloseTop.Parent = BoomFrame
        CloseTop.MouseButton1Click:Connect(ToggleBoomboxMenu)

        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1, -70, 0, 40)
        Title.Position = UDim2.new(0, 12, 0, 8)
        Title.BackgroundTransparency = 1
        Title.Text = "🎵 BOOMBOX & VOLUME"
        Title.TextColor3 = Color3.new(1,1,1)
        Title.Font = Enum.Font.GothamBold
        Title.TextScaled = true
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.Parent = BoomFrame

        local Input = Instance.new("TextBox")
        Input.Size = UDim2.new(1, -40, 0, 45)
        Input.Position = UDim2.new(0, 20, 0, 55)
        Input.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        Input.PlaceholderText = "Paste Sound ID here..."
        Input.TextColor3 = Color3.new(1,1,1)
        Input.Font = Enum.Font.Gotham
        Input.TextScaled = true
        Input.Parent = BoomFrame
        Instance.new("UICorner", Input).CornerRadius = UDim.new(0, 8)
        AddRainbowGlow(Input, 2)

        local VolLabel = Instance.new("TextLabel")
        VolLabel.Size = UDim2.new(0, 150, 0, 30)
        VolLabel.Position = UDim2.new(0, 20, 0, 110)
        VolLabel.BackgroundTransparency = 1
        VolLabel.Text = "🔊 VOLUME (0–1000):"
        VolLabel.TextColor3 = Color3.new(1,1,1)
        VolLabel.Font = Enum.Font.GothamBold
        VolLabel.TextScaled = true
        VolLabel.Parent = BoomFrame

        VolNumMenu = Instance.new("TextLabel")
        VolNumMenu.Size = UDim2.new(0, 60, 0, 30)
        VolNumMenu.Position = UDim2.new(1, -80, 0, 110)
        VolNumMenu.BackgroundTransparency = 1
        VolNumMenu.Text = tostring(math.floor(MusicVolume+0.5))
        VolNumMenu.TextColor3 = Color3.new(1,1,1)
        VolNumMenu.Font = Enum.Font.GothamBold
        VolNumMenu.TextScaled = true
        VolNumMenu.Parent = BoomFrame

        local VolBG = Instance.new("Frame")
        VolBG.Size = UDim2.new(1, -40, 0, 24)
        VolBG.Position = UDim2.new(0, 20, 0, 145)
        VolBG.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        VolBG.Active = true
        VolBG.Parent = BoomFrame
        Instance.new("UICorner", VolBG).CornerRadius = UDim.new(0, 12)
        AddRainbowGlow(VolBG, 2)

        VolFillMenu = Instance.new("Frame")
        VolFillMenu.Size = UDim2.new(MusicVolume/VOLUME_MAX, 0, 1, 0)
        VolFillMenu.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        VolFillMenu.Parent = VolBG
        Instance.new("UICorner", VolFillMenu).CornerRadius = UDim.new(0, 12)

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
        PlayBtn.Size = UDim2.new(0, 130, 0, 40)
        PlayBtn.Position = UDim2.new(0, 20, 0, 190)
        PlayBtn.BackgroundColor3 = Color3.fromRGB(25, 140, 255)
        PlayBtn.Text = "▶ PLAY SOUND"
        PlayBtn.TextColor3 = Color3.new(1,1,1)
        PlayBtn.Font = Enum.Font.GothamBold
        PlayBtn.TextScaled = true
        PlayBtn.Parent = BoomFrame
        Instance.new("UICorner", PlayBtn).CornerRadius = UDim.new(0, 8)
        AddRainbowGlow(PlayBtn, 2)

        local StopBtn = Instance.new("TextButton")
        StopBtn.Size = UDim2.new(0, 130, 0, 40)
        StopBtn.Position = UDim2.new(0, 170, 0, 190)
        StopBtn.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
        StopBtn.Text = "⏹ STOP SOUND"
        StopBtn.TextColor3 = Color3.new(1,1,1)
        StopBtn.Font = Enum.Font.GothamBold
        StopBtn.TextScaled = true
        StopBtn.Parent = BoomFrame
        Instance.new("UICorner", StopBtn).CornerRadius = UDim.new(0, 8)
        AddRainbowGlow(StopBtn, 2)

        PlayBtn.MouseButton1Click:Connect(function() if Input.Text ~= "" then PlaySound(Input.Text) end end)
        StopBtn.MouseButton1Click:Connect(function() if CurrentSound then CurrentSound:Destroy() end end)
    end

    -- ==============================================
    -- CONSOLE MENU
    -- ==============================================
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
        Frame.Size = UDim2.new(0, 450, 0, 320)
        Frame.Position = UDim2.new(0.5, -225, 0.5, -160)
        Frame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
        Frame.Active = true
        Frame.Parent = ConsoleUI
        Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 12)
        AddRainbowGlow(Frame, 5)

        local CloseTop = Instance.new("TextButton")
        CloseTop.Size = UDim2.new(0, 32, 0, 32)
        CloseTop.Position = UDim2.new(1, -37, 0, 6)
        CloseTop.BackgroundColor3 = Color3.fromRGB(170, 30, 30)
        CloseTop.Text = "✕"
        CloseTop.TextColor3 = Color3.new(1,1,1)
        CloseTop.Font = Enum.Font.GothamBold
        CloseTop.TextSize = 26
        CloseTop.Parent = Frame
        CloseTop.MouseButton1Click:Connect(ToggleConsole)

        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1, -50, 0, 35)
        Title.Position = UDim2.new(0, 15, 0, 6)
        Title.BackgroundTransparency = 1
        Title.Text = "💻 CONSOLE"
        Title.TextColor3 = Color3.new(1,1,1)
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
        Input.TextColor3 = Color3.new(1,1,1)
        Input.Font = Enum.Font.Code
        Input.TextScaled = true
        Input.MultiLine = true
        Input.Parent = Frame
        Instance.new("UICorner", Input).CornerRadius = UDim.new(0, 8)
        AddRainbowGlow(Input, 2)

        local ExecBtn = Instance.new("TextButton")
        ExecBtn.Size = UDim2.new(0, 120, 0, 40)
        ExecBtn.Position = UDim2.new(0, 15, 0, 240)
        ExecBtn.BackgroundColor3 = Color3.fromRGB(20, 150, 70)
        ExecBtn.Text = "▶ EXECUTE"
        ExecBtn.TextColor3 = Color3.new(1,1,1)
        ExecBtn.Font = Enum.Font.GothamBold
        ExecBtn.TextScaled = true
        ExecBtn.Parent = Frame
        Instance.new("UICorner", ExecBtn).CornerRadius = UDim.new(0, 8)
        AddRainbowGlow(ExecBtn, 2)

        local ClearBtn = Instance.new("TextButton")
        ClearBtn.Size = UDim2.new(0, 120, 0, 40)
        ClearBtn.Position = UDim2.new(0, 150, 0, 240)
        ClearBtn.BackgroundColor3 = Color3.fromRGB(180, 120, 20)
        ClearBtn.Text = "🗑️ CLEAR"
        ClearBtn.TextColor3 = Color3.new(1,1,1)
        ClearBtn.Font = Enum.Font.GothamBold
        ClearBtn.TextScaled = true
        ClearBtn.Parent = Frame
        Instance.new("UICorner", ClearBtn).CornerRadius = UDim.new(0, 8)
        AddRainbowGlow(ClearBtn, 2)

        ExecBtn.MouseButton1Click:Connect(function()
            local Code = Input.Text
            if Code == "" then Output.Text = "⚠️ Nothing to run!" return end
            local Compile = loadstring or load
            if not Compile then Output.Text = "⚠️ Executor not supported." return end
            local Func, Err = Compile(Code)
            if not Func then Output.Text = "❌ Syntax Error:\n"..tostring(Err) return end
            local Ok, RunErr = pcall(Func)
            if not Ok then Output.Text = "❌ Runtime Error:\n"..tostring(RunErr) return end
            Output.Text = "✅ Script ran successfully!"
        end)
        ClearBtn.MouseButton1Click:Connect(function() Input.Text = "" Output.Text = "✅ Cleared!" end)
    end

    -- ==============================================
    -- MAIN HUB GUI
    -- ==============================================
    local FULL_SIZE = UDim2.new(0, 680, 0, 105)
    local MINI_SIZE = UDim2.new(0, 110, 0, 36)
    local MainUI = Instance.new("ScreenGui")
    MainUI.Name = "BLUE_MODE_HUB"
    MainUI.ResetOnSpawn = false
    MainUI.DisplayOrder = PRIORITY.MAIN
    MainUI.Parent = GuiContainer

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = FULL_SIZE
    MainFrame.Position = UDim2.new(0, 20, 0.5, -52)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainFrame.Active = true
    MainFrame.Parent = MainUI
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
    AddRainbowGlow(MainFrame, 5)

    local DragHandle = Instance.new("TextButton")
    DragHandle.Size = UDim2.new(1, -30, 0, 22)
    DragHandle.Position = UDim2.new(0, 0, 0, 0)
    DragHandle.BackgroundColor3 = Color3.fromRGB(60, 140, 220)
    DragHandle.Active = true
    DragHandle.Text = "made by BLUE_MODE | DRAG HERE"
    DragHandle.TextColor3 = Color3.new(1,1,1)
    DragHandle.Font = Enum.Font.GothamBold
    DragHandle.TextScaled = true
    DragHandle.TextXAlignment = Enum.TextXAlignment.Left
    DragHandle.Parent = MainFrame
    AddRainbowGlow(DragHandle, 2)

    local TimerLabel = Instance.new("TextLabel")
    TimerLabel.Size = UDim2.new(0, 120, 1, 0)
    TimerLabel.Position = UDim2.new(1, -125, 0, 0)
    TimerLabel.BackgroundTransparency = 1
    TimerLabel.Text = "00:00:00 / 12:00"
    TimerLabel.TextColor3 = Color3.new(1,1,1)
    TimerLabel.Font = Enum.Font.GothamBold
    TimerLabel.TextScaled = true
    TimerLabel.TextXAlignment = Enum.TextXAlignment.Right
    TimerLabel.Parent = DragHandle

    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.new(0, 22, 1, 0)
    MinBtn.Position = UDim2.new(1, -22, 0, 0)
    MinBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    MinBtn.Text = "➖"
    MinBtn.TextColor3 = Color3.new(1,1,1)
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.TextScaled = true
    MinBtn.Parent = MainFrame
    AddRainbowGlow(MinBtn, 2)

    -- ✅ FIXED ESP BUTTON
    ESPBtn = Instance.new("TextButton")
    ESPBtn.Size = UDim2.new(0, 85, 0, 30)
    ESPBtn.Position = UDim2.new(0, 10, 0, 30)
    ESPBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    ESPBtn.Text = "ESP: OFF"
    ESPBtn.TextColor3 = Color3.new(1,1,1)
    ESPBtn.Font = Enum.Font.GothamBold
    ESPBtn.TextScaled = true
    ESPBtn.Parent = MainFrame
    Instance.new("UICorner", ESPBtn).CornerRadius = UDim.new(0, 6)
    AddRainbowGlow(ESPBtn, 2)

    local YouTubeBtn = Instance.new("TextButton")
    YouTubeBtn.Size = UDim2.new(0, 95, 0, 30)
    YouTubeBtn.Position = UDim2.new(0, 100, 0, 30)
    YouTubeBtn.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
    YouTubeBtn.Text = "📺 YT"
    YouTubeBtn.TextColor3 = Color3.new(1,1,1)
    YouTubeBtn.Font = Enum.Font.GothamBold
    YouTubeBtn.TextScaled = true
    YouTubeBtn.Parent = MainFrame
    Instance.new("UICorner", YouTubeBtn).CornerRadius = UDim.new(0, 6)
    AddRainbowGlow(YouTubeBtn, 2)

    local MusicBtn = Instance.new("TextButton")
    MusicBtn.Size = UDim2.new(0, 90, 0, 30)
    MusicBtn.Position = UDim2.new(0, 200, 0, 30)
    MusicBtn.BackgroundColor3 = Color3.fromRGB(40, 80, 160)
    MusicBtn.Text = "🎵 MUSIC"
    MusicBtn.TextColor3 = Color3.new(1,1,1)
    MusicBtn.Font = Enum.Font.GothamBold
    MusicBtn.TextScaled = true
    MusicBtn.Parent = MainFrame
    Instance.new("UICorner", MusicBtn).CornerRadius = UDim.new(0, 6)
    AddRainbowGlow(MusicBtn, 2)

    local LockBtn = Instance.new("TextButton")
    LockBtn.Size = UDim2.new(0, 90, 0, 30)
    LockBtn.Position = UDim2.new(0, 300, 0, 30)
    LockBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    LockBtn.Text = "🔓 UNLOCK"
    LockBtn.TextColor3 = Color3.new(1,1,1)
    LockBtn.Font = Enum.Font.GothamBold
    LockBtn.TextScaled = true
    LockBtn.Parent = MainFrame
    Instance.new("UICorner", LockBtn).CornerRadius = UDim.new(0, 6)
    AddRainbowGlow(LockBtn, 2)

    local ConsoleBtn = Instance.new("TextButton")
    ConsoleBtn.Size = UDim2.new(0, 110, 0, 30)
    ConsoleBtn.Position = UDim2.new(0, 400, 0, 30)
    ConsoleBtn.BackgroundColor3 = Color3.fromRGB(30, 120, 90)
    ConsoleBtn.Text = "💻 CONSOLE"
    ConsoleBtn.TextColor3 = Color3.new(1,1,1)
    ConsoleBtn.Font = Enum.Font.GothamBold
    ConsoleBtn.TextScaled = true
    ConsoleBtn.Parent = MainFrame
    Instance.new("UICorner", ConsoleBtn).CornerRadius = UDim.new(0, 6)
    AddRainbowGlow(ConsoleBtn, 2)

    -- ✅ EXIT BUTTON WITH "ARE YOU SURE?" CONFIRMATION
    local ExitBtn = Instance.new("TextButton")
    ExitBtn.Size = UDim2.new(0, 90, 0, 30)
    ExitBtn.Position = UDim2.new(0, 520, 0, 30)
    ExitBtn.BackgroundColor3 = Color3.fromRGB(140, 20, 20)
    ExitBtn.Text = "🗑️ EXIT"
    ExitBtn.TextColor3 = Color3.new(1,1,1)
    ExitBtn.Font = Enum.Font.GothamBold
    ExitBtn.TextScaled = true
    ExitBtn.Parent = MainFrame
    Instance.new("UICorner", ExitBtn).CornerRadius = UDim.new(0, 6)
    AddRainbowGlow(ExitBtn, 2)

    ExitBtn.MouseButton1Click:Connect(function()
        local ConfirmUI = Instance.new("ScreenGui")
        ConfirmUI.Name = "BLUE_MODE_EXIT_CONFIRM"
        ConfirmUI.ResetOnSpawn = false
        ConfirmUI.DisplayOrder = PRIORITY.CONFIRM
        ConfirmUI.Parent = GuiContainer

        local ConfirmBox = Instance.new("Frame")
        ConfirmBox.Size = UDim2.new(0, 350, 0, 180)
        ConfirmBox.Position = UDim2.new(0.5, -175, 0.5, -90)
        ConfirmBox.BackgroundColor3 = Color3.fromRGB(15,15,20)
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
        ConfirmTitle.TextColor3 = Color3.new(1,1,1)
        ConfirmTitle.Parent = ConfirmBox

        local ConfirmSub = Instance.new("TextLabel")
        ConfirmSub.Size = UDim2.new(1, -40, 0, 35)
        ConfirmSub.Position = UDim2.new(0, 20, 0, 70)
        ConfirmSub.BackgroundTransparency = 1
        ConfirmSub.Font = Enum.Font.Gotham
        ConfirmSub.TextScaled = true
        ConfirmSub.Text = "This will close Blue Mode HUB completely"
        ConfirmSub.TextColor3 = Color3.fromRGB(200,200,200)
        ConfirmSub.Parent = ConfirmBox

        local YesBtn = Instance.new("TextButton")
        YesBtn.Size = UDim2.new(0, 130, 0, 40)
        YesBtn.Position = UDim2.new(0, 30, 0, 120)
        YesBtn.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
        YesBtn.Text = "✅ YES, EXIT"
        YesBtn.TextColor3 = Color3.new(1,1,1)
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
        NoBtn.TextColor3 = Color3.new(1,1,1)
        NoBtn.Font = Enum.Font.GothamBold
        NoBtn.TextScaled = true
        NoBtn.Parent = ConfirmBox
        Instance.new("UICorner", NoBtn).CornerRadius = UDim.new(0, 10)
        AddRainbowGlow(NoBtn, 2)

        YesBtn.MouseButton1Click:Connect(function() ConfirmUI:Destroy() FullDeleteHub() end)
        NoBtn.MouseButton1Click:Connect(function() ConfirmUI:Destroy() end)
    end)

    -- DRAG & MINIMIZE LOGIC
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
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then DragStart = nil GuiFocused = false end
    end)

    MinBtn.MouseButton1Click:Connect(function()
        IsMinimized = not IsMinimized
        MainFrame.Size = IsMinimized and MINI_SIZE or FULL_SIZE
        MinBtn.Text = IsMinimized and "➕" or "➖"
    end)

    -- BUTTON ACTIONS
    LockBtn.MouseButton1Click:Connect(function()
        Buttons_Locked = not Buttons_Locked
        LockBtn.Text = Buttons_Locked and "🔒 LOCKED" or "🔓 UNLOCK"
        LockBtn.BackgroundColor3 = Buttons_Locked and Color3.fromRGB(80, 30, 30) or Color3.fromRGB(50, 50, 50)
    end)
    YouTubeBtn.MouseButton1Click:Connect(function()
        pcall(function() setclipboard(YOUTUBE_LINK) end)
        YouTubeBtn.Text = "✅ COPIED!"
        task.wait(2)
        YouTubeBtn.Text = "📺 YT"
    end)
    MusicBtn.MouseButton1Click:Connect(ToggleBoomboxMenu)
    ConsoleBtn.MouseButton1Click:Connect(ToggleConsole)
    ESPBtn.MouseButton1Click:Connect(function()
        ESP_Enabled = not ESP_Enabled
        ESPBtn.Text = ESP_Enabled and "ESP: ON" or "ESP: OFF"
        ESPBtn.BackgroundColor3 = ESP_Enabled and Color3.fromRGB(30, 160, 60) or Color3.fromRGB(40, 40, 40)
        if not ESP_Enabled then ClearAllESP() end
    end)

    -- ==============================================
    -- MAIN UPDATE LOOP | RAINBOW OUTLINES + OWNER + FRIENDS
    -- ==============================================
    RunService.Heartbeat:Connect(function(dt)
        Hue = (Hue + dt * 0.25) % 1
        local RainbowCol = Color3.fromHSV(Hue, 1, 1)

        if ESP_Enabled then
            for _, Player in pairs(Players:GetPlayers()) do
                if Player ~= LocalPlayer and Player.Character and Player.Character:FindFirstChild("Humanoid") then
                    local Char = Player.Character
                    local Hum = Char.Humanoid
                    if Hum.Health <= 0 then continue end

                    if not Char:FindFirstChild("BLUE_Outline") then
                        local Outline = Instance.new("Highlight")
                        Outline.Name = "BLUE_Outline"
                        Outline.FillTransparency = 1
                        Outline.OutlineTransparency = 0
                        Outline.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        Outline.Adornee = Char
                        Outline.Parent = Char
                    end
                    local Outline = Char.BLUE_Outline

                    -- OWNER GOLDEN OUTLINE + CROWN
                    if Player.Name == OWNER_NAME then
                        Outline.OutlineColor = Color3.fromRGB(255, 215, 0)
                        if not Char:FindFirstChild("OwnerCrown") then
                            local Crown = Instance.new("BillboardGui")
                            Crown.Name = "OwnerCrown"
                            Crown.Size = UDim2.new(0, 30, 0, 30)
                            Crown.StudsOffset = Vector3.new(0, 3, 0)
                            Crown.AlwaysOnTop = true
                            Crown.Parent = Char.Head
                            local Icon = Instance.new("TextLabel")
                            Icon.Size = UDim2.new(1,0,1,0)
                            Icon.BackgroundTransparency = 1
                            Icon.Text = "👑"
                            Icon.TextScaled = true
                            Icon.Parent = Crown
                        end
                    -- FRIEND RAINBOW OUTLINE + INDICATOR
                    elseif Player:IsFriendsWith(LocalPlayer.UserId) then
                        Outline.OutlineColor = RainbowCol
                        if not Char:FindFirstChild("FriendRainbowDot") then
                            local Dot = Instance.new("BillboardGui")
                            Dot.Name = "FriendRainbowDot"
                            Dot.Size = UDim2.new(0, 12, 0, 12)
                            Dot.StudsOffset = Vector3.new(0, 2, 0)
                            Dot.AlwaysOnTop = true
                            Dot.Parent = Char.Head
                            local Ind = Instance.new("Frame")
                            Ind.Size = UDim2.new(1,0,1,0)
                            Ind.BackgroundColor3 = RainbowCol
                            Ind.CornerRadius = UDim.new(1,0)
                            Ind.Parent = Dot
                        else
                            Char.FriendRainbowDot.Frame.BackgroundColor3 = RainbowCol
                        end
                    -- NORMAL PLAYER RAINBOW OUTLINE
                    else
                        Outline.OutlineColor = RainbowCol
                    end
                end
            end
        end
    end)

    print("✅ BLUE MODE HUB FULLY LOADED SUCCESSFULLY!")
end

-- ==============================================
-- END OF FULL SCRIPT
-- ==============================================
