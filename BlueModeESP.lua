-- ==============================================
-- 🔵 BLUE MODE HUB | STARTUP + FULL ESP GUI
-- ✅ TEXT FITS | BUTTONS VISIBLE | NO MISSING CODE
-- ✅ YOUR ORIGINAL ESP SCRIPT INCLUDED
-- ✅ MADE BY: BLUE_MODE / DWAYNE KEAN FRANCISCO
-- ==============================================
if getgenv().BlueModeHub_Loaded then return end
getgenv().BlueModeHub_Loaded = true

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local LocalPlayer = Players.LocalPlayer

-- ✅ FORCE PARENT TO COREGUI (ALWAYS VISIBLE)
local GuiParent = game:GetService("CoreGui")

-- ==============================================
-- ✅ RAINBOW SYSTEM
-- ==============================================
local RainbowElements = {}
local Hue = 0

local function AddOutline(obj, thick)
    if not obj then return end
    local s = Instance.new("UIStroke")
    s.Thickness = thick or 8
    s.Transparency = 0
    s.Color = Color3.fromRGB(0, 140, 255)
    s.LineJoinMode = Enum.LineJoinMode.Round
    s.Parent = obj
    table.insert(RainbowElements, s)
end

local function MakeText(obj, displayText)
    if not obj then return end
    obj.BackgroundTransparency = 1
    obj.Font = Enum.Font.GothamBold
    obj.TextScaled = true
    obj.TextSize = 26
    obj.AutoLocalize = false
    obj.TextWrapped = true
    obj.TextLineHeight = 1.5 -- ✅ FITS TEXT PERFECTLY
    obj.ClipsDescendants = false
    obj.Visible = true
    obj.TextColor3 = Color3.fromRGB(0, 180, 255)
    obj.Text = displayText
    table.insert(RainbowElements, obj)
end

RunService.Heartbeat:Connect(function(dt)
    Hue = (Hue + dt * 0.25) % 1
    local col = Color3.fromHSV(Hue, 1, 1)
    for _,e in pairs(RainbowElements) do
        if e:IsA("UIStroke") then e.Color = col end
        if e:IsA("TextLabel") or e:IsA("TextButton") then e.TextColor3 = col end
    end
end)

-- ==============================================
-- ✅ STARTUP SCREEN (TEXT FITS + BUTTONS VISIBLE)
-- ==============================================
local StartupUI = Instance.new("ScreenGui")
StartupUI.Name = "BLUE_MODE_STARTUP"
StartupUI.ResetOnSpawn = false
StartupUI.DisplayOrder = 9999
StartupUI.Parent = GuiParent

-- MAIN BOX (BIG ENOUGH FOR ALL TEXT)
local MainBox = Instance.new("Frame")
MainBox.Size = UDim2.new(0, 450, 0, 580) -- ✅ EXTRA SPACE FOR TEXT
MainBox.Position = UDim2.new(0.5, -225, 0.5, -290)
MainBox.BackgroundColor3 = Color3.new(0, 0, 0)
MainBox.Active = true
MainBox.ClipsDescendants = false
MainBox.Parent = StartupUI
Instance.new("UICorner", MainBox).CornerRadius = UDim.new(0, 20)
AddOutline(MainBox, 8)

-- TITLE
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 0, 50)
Title.Position = UDim2.new(0, 20, 0, 15)
Title.TextXAlignment = Enum.TextXAlignment.Center
Title.Parent = MainBox
MakeText(Title, "🔵 BLUE MODE HUB")

-- FEATURE LIST
local FeatureHeader = Instance.new("TextLabel")
FeatureHeader.Size = UDim2.new(1, -40, 0, 40)
FeatureHeader.Position = UDim2.new(0, 20, 0, 75)
FeatureHeader.TextXAlignment = Enum.TextXAlignment.Left
FeatureHeader.Parent = MainBox
MakeText(FeatureHeader, "📋 FEATURE LIST:")

local FeatureList = Instance.new("TextLabel")
FeatureList.Size = UDim2.new(1, -60, 0, 170)
FeatureList.Position = UDim2.new(0, 30, 0, 120)
FeatureList.TextXAlignment = Enum.TextXAlignment.Left
FeatureList.TextYAlignment = Enum.TextYAlignment.Top
FeatureList.Parent = MainBox
MakeText(FeatureList, [[• RAINBOW OUTLINES FOR PLAYERS
• FRIEND-ONLY RAINBOW DOTS
• IN-GAME SCRIPT CONSOLE
• MUSIC PLAYER + VOLUME SLIDER
• DRAGGABLE + MINIMIZABLE UI
• 12 HOUR USAGE TIMER
• MADE BY: BLUE_MODE]])

-- UPDATE LIST
local UpdateHeader = Instance.new("TextLabel")
UpdateHeader.Size = UDim2.new(1, -40, 0, 40)
UpdateHeader.Position = UDim2.new(0, 20, 0, 305)
UpdateHeader.TextXAlignment = Enum.TextXAlignment.Left
UpdateHeader.Parent = MainBox
MakeText(UpdateHeader, "🔄 UPDATE LIST:")

local UpdateList = Instance.new("TextLabel")
UpdateList.Size = UDim2.new(1, -60, 0, 70)
UpdateList.Position = UDim2.new(0, 30, 0, 350)
UpdateList.TextXAlignment = Enum.TextXAlignment.Left
UpdateList.TextYAlignment = Enum.TextYAlignment.Top
UpdateList.Parent = MainBox
MakeText(UpdateList, [[• Fixed text overflow issue
• Added clear START/EXIT buttons
• Fixed ESP GUI not loading
• Optimized for Delta/Pydroid3]])

-- ✅ START BUTTON (LOADS YOUR FULL ESP GUI)
local StartBtn = Instance.new("TextButton")
StartBtn.Size = UDim2.new(0, 360, 0, 60)
StartBtn.Position = UDim2.new(0.5, -180, 0, 440)
StartBtn.BackgroundColor3 = Color3.fromRGB(25, 120, 255)
StartBtn.AutoLocalize = false
StartBtn.Parent = MainBox
Instance.new("UICorner", StartBtn).CornerRadius = UDim.new(0, 15)
MakeText(StartBtn, "▶ START / OPEN ESP HUB")
AddOutline(StartBtn, 5)

-- EXIT BUTTON
local ExitBtn = Instance.new("TextButton")
ExitBtn.Size = UDim2.new(0, 360, 0, 50)
ExitBtn.Position = UDim2.new(0.5, -180, 0, 510)
ExitBtn.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
ExitBtn.AutoLocalize = false
ExitBtn.Parent = MainBox
Instance.new("UICorner", ExitBtn).CornerRadius = UDim.new(0, 15)
MakeText(ExitBtn, "🗑️ DELETE / EXIT HUB")
AddOutline(ExitBtn, 5)

-- ==============================================
-- ✅ YOUR EXACT FULL ESP SCRIPT (LOADS ON START)
-- ==============================================
local function LoadFullESPHub()
    local PlayerGui = GuiParent

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

    -- DATA HELPERS
    local function SaveData(key, value) pcall(function() writefile(key..".txt", tostring(value)) end) end
    local function LoadData(key, default) local v=nil; pcall(function() v=readfile(key..".txt") end); return tonumber(v) or default end

    -- FULL CLEANUP FUNCTION
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
    local GuiElements = {}
    local ESP_Enabled = false
    local Buttons_Locked = false
    local Hue = 0
    local ESPBtn = nil -- ✅ FIXED UNDEFINED VARIABLE

    -- DEATH CHECK
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

    -- RAINBOW GLOW
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

    -- ERROR POPUP
    local function ShowErrorPopup(Message)
        local Popup = Instance.new("ScreenGui")
        Popup.Name = "BLUE_ERROR_POPUP"
        Popup.ResetOnSpawn = false
        Popup.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        Popup.Parent = PlayerGui
        local Frame = Instance.new("Frame")
        Frame.Size = UDim2.new(0,400,0,200)
        Frame.Position = UDim2.new(0.5,-200,0.5,-100)
        Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
        Frame.Parent = Popup
        Instance.new("UICorner", Frame).CornerRadius = UDim.new(0,12)
        AddRainbowGlow(Frame,4)
        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1,-40,0,35)
        Title.Position = UDim2.new(0,10,0,10)
        Title.BackgroundTransparency = 1
        Title.Text = "⚠️ SCRIPT ERROR"
        Title.TextColor3 = Color3.fromRGB(255,80,80)
        Title.Font = Enum.Font.GothamBold
        Title.TextScaled = true
        Title.Parent = Frame
        local ErrorText = Instance.new("TextLabel")
        ErrorText.Size = UDim2.new(1,-30,1,-90)
        ErrorText.Position = UDim2.new(0,15,0,50)
        ErrorText.BackgroundTransparency = 1
        ErrorText.Text = Message
        ErrorText.TextColor3 = Color3.new(1,1,1)
        ErrorText.Font = Enum.Font.Gotham
        ErrorText.TextScaled = true
        ErrorText.TextWrapped = true
        ErrorText.TextXAlignment = Enum.TextXAlignment.Left
        ErrorText.Parent = Frame
        local CloseBtn = Instance.new("TextButton")
        CloseBtn.Size = UDim2.new(0,160,0,40)
        CloseBtn.Position = UDim2.new(0.5,-80,1,-55)
        CloseBtn.BackgroundColor3 = Color3.fromRGB(180,40,40)
        CloseBtn.Text = "✕ CLOSE"
        CloseBtn.TextColor3 = Color3.new(1,1,1)
        CloseBtn.Font = Enum.Font.GothamBold
        CloseBtn.TextScaled = true
        CloseBtn.Parent = Frame
        Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0,8)
        CloseBtn.MouseButton1Click:Connect(function() Popup:Destroy() end)
    end

    -- VOLUME CONTROL
    local function UpdateVolume(newVol)
        MusicVolume = math.clamp(tonumber(newVol) or 0.5, 0, 1)
        SaveData(SAVE_KEY_VOLUME, MusicVolume)
        if CurrentSound then CurrentSound.Volume = MusicVolume end
        local Pct = math.floor(MusicVolume * 100 + 0.5).."%"
        if VolNumTextMain then VolNumTextMain.Text = Pct end
        if VolFillMain then VolFillMain.Size = UDim2.new(MusicVolume,0,1,0) end
        if VolNumMenu then VolNumMenu.Text = Pct end
        if VolFillMenu then VolFillMenu.Size = UDim2.new(MusicVolume,0,1,0) end
    end

    -- SOUND SYSTEM
    local function FormatSoundID(input) return "rbxassetid://"..tostring(input):gsub("%D","") end
    local function PlaySound(id)
        pcall(function() if CurrentSound then CurrentSound:Destroy() end end)
        CurrentSound = Instance.new("Sound")
        CurrentSound.Name = "BLUE_BOOMBOX"
        CurrentSound.SoundId = FormatSoundID(id)
        CurrentSound.Volume = MusicVolume
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
        BoomUI.Name = "BLUE_BOOMBOX_MENU"
        BoomUI.ResetOnSpawn = false
        BoomUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        BoomUI.Parent = PlayerGui
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
        CloseTop.Font = Enum.Font.GothamBold
        CloseTop.TextSize = 24
        CloseTop.Parent = BoomFrame
        CloseTop.MouseButton1Click:Connect(function() ToggleBoomboxMenu() end)

        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1,-40,0,40)
        Title.Position = UDim2.new(0,15,0,8)
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
        Input.TextScaled = true
        Input.Parent = BoomFrame
        Instance.new("UICorner", Input).CornerRadius = UDim.new(0,8)
        AddRainbowGlow(Input,2)

        local VolLabel = Instance.new("TextLabel")
        VolLabel.Size = UDim2.new(0,120,0,30)
        VolLabel.Position = UDim2.new(0,20,0,110)
        VolLabel.BackgroundTransparency = 1
        VolLabel.Text = "🔊 VOLUME LEVEL:"
        VolLabel.TextColor3 = Color3.new(1,1,1)
        VolLabel.Font = Enum.Font.GothamBold
        VolLabel.TextScaled = true
        VolLabel.Parent = BoomFrame

        VolNumMenu = Instance.new("TextLabel")
        VolNumMenu.Size = UDim2.new(0,80,0,30)
        VolNumMenu.Position = UDim2.new(1,-100,0,110)
        VolNumMenu.BackgroundTransparency = 1
        VolNumMenu.Text = math.floor(MusicVolume*100+0.5).."%"
        VolNumMenu.TextColor3 = Color3.new(1,1,1)
        VolNumMenu.Font = Enum.Font.GothamBold
        VolNumMenu.TextScaled = true
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
        VolFillMenu.Size = UDim2.new(MusicVolume,0,1,0)
        VolFillMenu.BackgroundColor3 = Color3.fromRGB(100,100,100)
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
                UpdateVolume(rel)
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
        ConsoleUI.Name = "BLUE_CONSOLE"
        ConsoleUI.ResetOnSpawn = false
        ConsoleUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        ConsoleUI.Parent = PlayerGui
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
        CloseTop.TextSize = 26
        CloseTop.Parent = Frame
        CloseTop.MouseButton1Click:Connect(function() ToggleConsole() end)

        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1,-50,0,35)
        Title.Position = UDim2.new(0,15,0,6)
        Title.BackgroundTransparency = 1
        Title.Text = "💻 CONSOLE"
        Title.TextColor3 = Color3.new(1,1,1)
        Title.Font = Enum.Font.GothamBold
        Title.TextScaled = true
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.Parent = Frame

        local Output = Instance.new("TextLabel")
        Output.Size = UDim2.new(1,-30,0,40)
        Output.Position = UDim2.new(0,15,0,45)
        Output.BackgroundTransparency = 1
        Output.Text = "Paste script code below..."
        Output.TextColor3 = Color3.fromRGB(0,255,120)
        Output.Font = Enum.Font.Code
        Output.TextScaled = true
        Output.TextXAlignment = Enum.TextXAlignment.Left
        Output.TextWrapped = true
        Instance.new("UICorner", Output).CornerRadius = UDim.new(0,8)
        Output.Parent = Frame

        local Input = Instance.new("TextBox")
        Input.Size = UDim2.new(1,-30,0,130)
        Input.Position = UDim2.new(0,15,0,95)
        Input.BackgroundColor3 = Color3.fromRGB(45,45,45)
        Input.PlaceholderText = "Paste your script here..."
        Input.TextColor3 = Color3.new(1,1,1)
        Input.Font = Enum.Font.Code
        Input.TextScaled = true
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
        ExecBtn.TextScaled = true
        ExecBtn.Parent = Frame
        Instance.new("UICorner", ExecBtn).CornerRadius = UDim.new(0,8)

        local ClearBtn = Instance.new("TextButton")
        ClearBtn.Size = UDim2.new(0,120,0,40)
        ClearBtn.Position = UDim2.new(0,150,0,240)
        ClearBtn.BackgroundColor3 = Color3.fromRGB(180,120,20)
        ClearBtn.Text = "🗑️ CLEAR"
        ClearBtn.TextColor3 = Color3.new(1,1,1)
        ClearBtn.Font = Enum.Font.GothamBold
        ClearBtn.TextScaled = true
        ClearBtn.Parent = Frame
        Instance.new("UICorner", ClearBtn).CornerRadius = UDim.new(0,8)

        ExecBtn.MouseButton1Click:Connect(function()
            local ScriptCode = Input.Text
            if ScriptCode == "" then Output.Text = "⚠️ Nothing to run!" return end
            local Compile = loadstring or load
            if not Compile then Output.Text = "⚠️ Executor does not support compiling." return end
            local Func, Err = Compile(ScriptCode)
            if not Func then Output.Text = "❌ Syntax Error:\n"..tostring(Err) return end
            local Ok, RunErr = pcall(Func)
            if not Ok then Output.Text = "❌ Runtime Error:\n"..tostring(RunErr) return end
            Output.Text = "✅ Script ran successfully!"
        end)
        ClearBtn.MouseButton1Click:Connect(function() Input.Text = "" Output.Text = "✅ Cleared!" end)
    end

    -- MAIN UI
    local FULL_SIZE = UDim2.new(0,680,0,105)
    local MINI_SIZE = UDim2.new(0,110,0,36)
    local MainUI = Instance.new("ScreenGui")
    MainUI.Name = "BLUE_MODE_ESP"
    MainUI.ResetOnSpawn = false
    MainUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    MainUI.Parent = PlayerGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = FULL_SIZE
    MainFrame.Position = UDim2.new(0,20,0.5,-52)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
    MainFrame.Active = true
    MainFrame.ClipsDescendants = false
    MainFrame.Parent = MainUI
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,8)
    AddRainbowGlow(MainFrame,5)

    -- DRAG BAR + TIMER
    local DragHandle = Instance.new("TextButton")
    DragHandle.Size = UDim2.new(1,-30,0,22)
    DragHandle.Position = UDim2.new(0,0,0,0)
    DragHandle.BackgroundColor3 = Color3.fromRGB(60,140,220)
    DragHandle.Active = true
    DragHandle.Text = "made by BLUE_MODE | DRAG HERE"
    DragHandle.TextColor3 = Color3.new(1,1,1)
    DragHandle.Font = Enum.Font.GothamBold
    DragHandle.TextScaled = true
    DragHandle.TextXAlignment = Enum.TextXAlignment.Left
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
    MinBtn.TextScaled = true
    MinBtn.Parent = MainFrame
    AddRainbowGlow(MinBtn,2)

    -- BUTTONS
    ESPBtn = Instance.new("TextButton") -- ✅ FIXED NAME
    ESPBtn.Size = UDim2.new(0,85,0,30)
    ESPBtn.Position = UDim2.new(0,10,0,30)
    ESPBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    ESPBtn.Text = "ESP: OFF"
    ESPBtn.TextColor3 = Color3.new(1,1,1)
    ESPBtn.Font = Enum.Font.GothamBold
    ESPBtn.TextScaled = true
    ESPBtn.Parent = MainFrame
    Instance.new("UICorner", ESPBtn).CornerRadius = UDim.new(0,6)
    AddRainbowGlow(ESPBn,2)

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

    -- MAIN VOLUME SLIDER
    local VolLabelMain = Instance.new("TextLabel")
    VolLabelMain.Size = UDim2.new(0,70,0,25)
    VolLabelMain.Position = UDim2.new(0,10,0,65)
    VolLabelMain.BackgroundTransparency = 1
    VolLabelMain.Text = "🔊 VOL:"
    VolLabelMain.TextColor3 = Color3.new(1,1,1)
    VolLabelMain.Font = Enum.Font.Gotham
    VolLabelMain.TextScaled = true
    VolLabelMain.Parent = MainFrame

    VolNumTextMain = Instance.new("TextLabel")
    VolNumTextMain.Size = UDim2.new(0,45,0,25)
    VolNumTextMain.Position = UDim2.new(0,85,0,65)
    VolNumTextMain.BackgroundTransparency = 1
    VolNumTextMain.Text = math.floor(MusicVolume*100+0.5).."%"
    VolNumTextMain.TextColor3 = Color3.new(1,1,1)
    VolNumTextMain.Font = Enum.Font.GothamBold
    VolNumTextMain.TextScaled = true
    VolNumTextMain.Parent = MainFrame

    local VolBGMain = Instance.new("Frame")
    VolBGMain.Size = UDim2.new(0,150,0,18)
    VolBGMain.Position = UDim2.new(0,135,0,67)
    VolBGMain.BackgroundColor3 = Color3.fromRGB(50,50,50)
    VolBGMain.Active = true
    VolBGMain.Parent = MainFrame
    Instance.new("UICorner", VolBGMain).CornerRadius = UDim.new(0,9)
    AddRainbowGlow(VolBGMain,2)

    VolFillMain = Instance.new("Frame")
    VolFillMain.Size = UDim2.new(MusicVolume,0,1,0)
    VolFillMain.BackgroundColor3 = Color3.fromRGB(100,100,100)
    VolFillMain.Parent = VolBGMain
    Instance.new("UICorner", VolFillMain).CornerRadius = UDim.new(0,9)

    local SliderActiveMain = false
    VolBGMain.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then SliderActiveMain = true end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then SliderActiveMain = false end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if SliderActiveMain and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local rel = math.clamp((i.Position.X - VolBGMain.AbsolutePosition.X)/VolBGMain.AbsoluteSize.X, 0, 1)
            UpdateVolume(rel)
        end
    end)

    -- DRAG + TOUCH BLOCK
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

    UserInputService.InputBegan:Connect(function(Input, GameProcessed)
        if GameProcessed then return end
        if GuiFocused and Input.UserInputType == Enum.UserInputType.Touch then
            return Enum.ContextActionResult.Sink
        end
    end)

    -- LOCK/UNLOCK
    LockBtn.MouseButton1Click:Connect(function()
        Buttons_Locked = not Buttons_Locked
        LockBtn.Text = Buttons_Locked and "🔒 LOCKED" or "🔓 UNLOCK"
        LockBtn.BackgroundColor3 = Buttons_Locked and Color3.fromRGB(180,40,40) or Color3.fromRGB(50,50,50)
    end)

    -- MINIMIZE
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
            DragHandle.Text = ""
            MinBtn.Text = "➕"
            TimerLabel.Size = UDim2.new(1,-28,1,0)
            TimerLabel.Position = UDim2.new(0,4,0,0)
            TimerLabel.TextXAlignment = Enum.TextXAlignment.Center
            TimerLabel.TextScaled = false
            TimerLabel.TextSize = 12
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
            DragHandle.Text = "made by BLUE_MODE | DRAG HERE"
            MinBtn.Text = "➖"
            TimerLabel.Size = UDim2.new(0,120,1,0)
            TimerLabel.Position = UDim2.new(1,-125,0,0)
            TimerLabel.TextXAlignment = Enum.TextXAlignment.Right
            TimerLabel.TextScaled = true
            TimerLabel.TextSize = nil
        end
    end)

    -- ESP TOGGLE
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

    -- EXIT SCRIPT
    ExitBtn.MouseButton1Click:Connect(function()
        ClearAllESP()
        pcall(function() if CurrentSound then CurrentSound:Destroy() end end)
        if CurrentBoomboxUI then CurrentBoomboxUI:Destroy() end
        if CurrentConsoleUI then CurrentConsoleUI:Destroy() end
        MainUI:Destroy()
        getgenv().BlueMode_Loaded = nil
    end)

    SetupDeathCheck()

    -- MAIN LOOP
    RunService.Heartbeat:Connect(function(Delta)
        if not MainUI or not MainUI.Parent then return end

        -- TIMER
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
            pcall(function() delfile(SAVE_KEY_USED..".txt") end)
            ExitBtn:Fire()
            return
        end

        -- RAINBOW ANIMATION
        Hue = (Hue + Delta*0.5) % 1
        local Rainbow = Color3.fromHSV(Hue,1,1)
        for _,e in pairs(GuiElements) do e.Color = Rainbow end
        if VolFillMain then VolFillMain.BackgroundColor3 = Rainbow end
        if VolFillMenu then VolFillMenu.BackgroundColor3 = Rainbow end
        TimerLabel.TextColor3 = Rainbow

        -- ESP RENDER
        if not ESP_Enabled then return end
        for _,P in pairs(Players:GetPlayers()) do
            if P == LocalPlayer then continue end
            local Char = P.Character
            if not Char then
                pcall(function()
                    if Char and Char:FindFirstChild("BLUE_Outline") then Char.BLUE_Outline:Destroy() end
                    if Char and Char:FindFirstChild("FriendRainbowDot") then Char.FriendRainbowDot:Destroy() end
                end)
                continue
            end
            local Hum = Char:FindFirstChildOfClass("Humanoid")
            if not Hum or Hum.Health <= 0 then
                pcall(function()
                    if Char:FindFirstChild("BLUE_Outline") then Char.BLUE_Outline:Destroy() end
                    if Char:FindFirstChild("FriendRainbowDot") then Char.FriendRainbowDot:Destroy() end
                end)
                continue
            end

            -- RAINBOW OUTLINE
            local Outline = Char:FindFirstChild("BLUE_Outline") or Instance.new("Highlight",Char)
            Outline.Name = "BLUE_Outline"
            Outline.FillTransparency = 1
            Outline.OutlineTransparency = 0
            Outline.OutlineColor = Rainbow
            Outline.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

            -- FRIEND DOT
            local IsFriend = false
            pcall(function() IsFriend = LocalPlayer:IsFriendsWith(P.UserId) end)
            local Head = Char:FindFirstChild("Head")
            local Dot = Char:FindFirstChild("FriendRainbowDot")
            if IsFriend and Head then
                if not Dot then
                    Dot = Instance.new("BillboardGui",Head)
                    Dot.Name = "FriendRainbowDot"
                    Dot.AlwaysOnTop = true
                    Dot.Size = UDim2.new(0,16,0,16)
                    Dot.StudsOffset = Vector3.new(0,2,0)
                    local Circ = Instance.new("Frame",Dot)
                    Circ.Size = UDim2.new(1,0,1,0)
                    Circ.BackgroundColor3 = Rainbow
                    Instance.new("UICorner",Circ).CornerRadius = UDim.new(1,0)
                else
                    Dot.Frame.BackgroundColor3 = Rainbow
                end
            elseif Dot then
                Dot:Destroy()
            end
        end
    end)

    print("✅ FULL BLUE MODE ESP LOADED SUCCESSFULLY")
end

-- ✅ BUTTON ACTIONS
StartBtn.MouseButton1Click:Connect(function()
    StartupUI:Destroy()
    LoadFullESPHub()
end)

ExitBtn.MouseButton1Click:Connect(function()
    StartupUI:Destroy()
    getgenv().BlueModeHub_Loaded = nil
end)

print("✅ STARTUP SCREEN READY — CLICK START TO USE!")
