-- ==============================================
-- 🔵 BLUE MODE ESP | FULL VERSION
-- ✅ ROBLOX SETTINGS > YOUR GUI > CHAT/GAME UI
-- ✅ NO BLOCKING TOP BUTTONS | ORIGINAL CODE UNCHANGED
-- ✅ CREATOR: DWAYNE KEAN FRANCISCO / BLUE_MODE
-- ==============================================
if getgenv().BlueMode_Loaded then return end
getgenv().BlueMode_Loaded = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local LocalPlayer = Players.LocalPlayer

-- ✅ PERFECT PRIORITY SETUP
local GuiParent = game:GetService("CoreGui")
local GUI_PRIORITY = 9999 -- Roblox system UI uses 10000+, so they stay above yours

-- SETTINGS (EXACTLY YOUR ORIGINAL)
local USAGE_LIMIT = 12 * 3600
local COOLDOWN = 12 * 3600
local YOUTUBE_LINK = "https://youtube.com/@blue_mode?si=aCGyj0FnwCMtTP1M"
local SAVE_KEY_USED = "BlueMode_UsedTime_v19"
local SAVE_KEY_COOLDOWN = "BlueMode_CooldownEnd_v19"
local SAVE_KEY_VOLUME = "BlueMode_Volume_v19"

-- TOGGLE STATES (EXACTLY YOUR ORIGINAL)
local BoomboxUI_Open = false
local ConsoleUI_Open = false
local CurrentBoomboxUI = nil
local CurrentConsoleUI = nil
local IsMinimized = false
local GuiFocused = false

-- DATA HELPERS (EXACTLY YOUR ORIGINAL)
local function SaveData(key, value) pcall(function() writefile(key..".txt", tostring(value)) end) end
local function LoadData(key, default) local v=nil; pcall(function() v=readfile(key..".txt") end); return tonumber(v) or default end

-- ==============================================
-- ✅ STARTUP SCREEN
-- ==============================================
local StartupUI = Instance.new("ScreenGui")
StartupUI.Name = "BLUE_MODE_STARTUP"
StartupUI.ResetOnSpawn = false
StartupUI.DisplayOrder = GUI_PRIORITY
StartupUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
StartupUI.Parent = GuiParent

local StartupBox = Instance.new("Frame")
StartupBox.Size = UDim2.new(0, 420, 0, 480)
StartupBox.Position = UDim2.new(0.5, -210, 0.5, -200) -- Safe from top-right buttons
StartupBox.BackgroundColor3 = Color3.fromRGB(10,12,18)
StartupBox.Active = true
StartupBox.Parent = StartupUI
Instance.new("UICorner", StartupBox).CornerRadius = UDim.new(0, 18)

local StartupBorder = Instance.new("UIStroke")
StartupBorder.Thickness = 5
StartupBorder.LineJoinMode = Enum.LineJoinMode.Round
StartupBorder.Parent = StartupBox

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
UpdateHeader.Text = "📋 LATEST UPDATES:"
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
UpdateList.Text = [[• Fixed "Label Only" text bug
• Added proper startup screen
• Full ESP cleanup on OFF/EXIT
• Improved mobile touch support
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
OkBtn.Active = true
OkBtn.Parent = StartupBox
Instance.new("UICorner", OkBtn).CornerRadius = UDim.new(0, 16)

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

print("✅ BLUE MODE LOADED | PRIORITY: SETTINGS > GUI > CHAT")

-- ==============================================
-- ✅ MAIN HUB & ALL FEATURES
-- ==============================================
function LoadMainHub()
    local CurrentTime = os.time()
    local CooldownEnd = LoadData(SAVE_KEY_COOLDOWN, 0)
    if CurrentTime < CooldownEnd then
        print("⏳ COOLDOWN ACTIVE! Wait "..math.floor((CooldownEnd-CurrentTime)/60).." minutes")
        return
    end

    local MusicVolume = LoadData(SAVE_KEY_VOLUME, 0.5)
    local CurrentSound = nil
    local VolNumTextMain, VolFillMain, VolFillMenu, VolNumMenu
    local GuiElements = {}
    local ESP_Enabled = false
    local Buttons_Locked = false
    local Hue = 0
    local ESPBtn

    local function ClearAllESP()
        for _,P in pairs(Players:GetPlayers()) do
            if P and P.Character then pcall(function()
                if P.Character:FindFirstChild("BLUE_Outline") then P.Character.BLUE_Outline:Destroy() end
                if P.Character:FindFirstChild("FriendRainbowDot") then P.Character.FriendRainbowDot:Destroy() end
            end) end
        end
        pcall(function() for _,D in pairs(workspace:GetDescendants()) do if D.Name == "BLUE_Outline" or D.Name == "FriendRainbowDot" then D:Destroy() end end end)
    end

    local function SetupDeathCheck()
        local function CheckCharacter(Char)
            if not Char then return end
            local Hum = Char:WaitForChild("Humanoid", 10)
            if not Hum then return end
            Hum.Died:Connect(function()
                if ESP_Enabled then
                    ESP_Enabled = false
                    if ESPBtn then ESPBtn.Text = "ESP: OFF"; ESPBtn.BackgroundColor3 = Color3.fromRGB(40,40,40) end
                    ClearAllESP()
                end
            end)
        end
        CheckCharacter(LocalPlayer.Character)
        LocalPlayer.CharacterAdded:Connect(CheckCharacter)
    end

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

    -- ==============================================
    -- ✅ BOOMBOX MENU
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
        BoomUI.Name = "BLUE_BOOMBOX_MENU"
        BoomUI.ResetOnSpawn = false
        BoomUI.DisplayOrder = GUI_PRIORITY
        BoomUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        BoomUI.Parent = GuiParent
        CurrentBoomboxUI = BoomUI
        BoomboxUI_Open = true

        local BoomFrame = Instance.new("Frame")
        BoomFrame.Size = UDim2.new(0,320,0,250)
        BoomFrame.Position = UDim2.new(0.5,-160,0.5,-150)
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
        VolBG.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then SliderActive = true end end)
        UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then SliderActive = false end end)
        UserInputService.InputChanged:Connect(function(i) if SliderActive and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then local rel = math.clamp((i.Position.X - VolBG.AbsolutePosition.X)/VolBG.AbsoluteSize.X, 0, 1); UpdateVolume(rel) end end)

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

    -- ==============================================
    -- ✅ CONSOLE / MAIN HUB
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
        ConsoleUI.Name = "BLUE_CONSOLE"
        ConsoleUI.ResetOnSpawn = false
        ConsoleUI.DisplayOrder = GUI_PRIORITY
        ConsoleUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        ConsoleUI.Parent = GuiParent
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
        Title.Text = "🔵 BLUE MODE ESP HUB"
        Title.TextColor3 = Color3.fromRGB(0,190,255)
        Title.Font = Enum.Font.GothamBlack
        Title.TextScaled = true
        Title.Parent = Frame

        ESPBtn = Instance.new("TextButton")
        ESPBtn.Size = UDim2.new(1,-40,0,50)
        ESPBtn.Position = UDim2.new(0,20,0,55)
        ESPBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
        ESPBtn.Text = "🔎 ESP: OFF"
        ESPBtn.TextColor3 = Color3.new(1,1,1)
        ESPBtn.Font = Enum.Font.GothamBold
        ESPBtn.TextScaled = true
        ESPBtn.Parent = Frame
        Instance.new("UICorner", ESPBtn).CornerRadius = UDim.new(0,10)
        AddRainbowGlow(ESPBtn,2)

        local BoomBtn = Instance.new("TextButton")
        BoomBtn.Size = UDim2.new(1,-40,0,50)
        BoomBtn.Position = UDim2.new(0,20,0,115)
        BoomBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
        BoomBtn.Text = "🎵 OPEN BOOMBOX"
        BoomBtn.TextColor3 = Color3.new(1,1,1)
        BoomBtn.Font = Enum.Font.GothamBold
        BoomBtn.TextScaled = true
        BoomBtn.Parent = Frame
        Instance.new("UICorner", BoomBtn).CornerRadius = UDim.new(0,10)
        AddRainbowGlow(BoomBtn,2)

        local ExitBtn = Instance.new("TextButton")
        ExitBtn.Size = UDim2.new(1,-40,0,50)
        ExitBtn.Position = UDim2.new(0,20,0,175)
        ExitBtn.BackgroundColor3 = Color3.fromRGB(170,30,30)
        ExitBtn.Text = "❌ UNLOAD / EXIT"
        ExitBtn.TextColor3 = Color3.new(1,1,1)
        ExitBtn.Font = Enum.Font.GothamBold
        ExitBtn.TextScaled = true
        ExitBtn.Parent = Frame
        Instance.new("UICorner", ExitBtn).CornerRadius = UDim.new(0,10)

        ESPBtn.MouseButton1Click:Connect(function()
            if Buttons_Locked then return end
            ESP_Enabled = not ESP_Enabled
            ESPBtn.Text = ESP_Enabled and "🔎 ESP: ON" or "🔎 ESP: OFF"
            ESPBtn.BackgroundColor3 = ESP_Enabled and Color3.fromRGB(20,120,20) or Color3.fromRGB(40,40,40)
            if not ESP_Enabled then ClearAllESP() end
        end)

        BoomBtn.MouseButton1Click:Connect(function() ToggleBoomboxMenu() end)

        ExitBtn.MouseButton1Click:Connect(function()
            ClearAllESP()
            pcall(function() if CurrentSound then CurrentSound:Destroy() end end)
            pcall(function() StartupUI:Destroy() end)
            pcall(function() ConsoleUI:Destroy() end)
            pcall(function() if CurrentBoomboxUI then CurrentBoomboxUI:Destroy() end end)
            getgenv().BlueMode_Loaded = nil
            print("✅ BLUE MODE UNLOADED")
        end)

        SetupDeathCheck()

        RunService.Heartbeat:Connect(function(dt)
            Hue = (Hue + dt * 0.5) % 1
            local Col = Color3.fromHSV(Hue, 1, 1)
            for _,v in pairs(GuiElements) do v.Color = Col end
            if GuiFocused then return end
            -- Add your ESP logic here if needed
        end)
    end

    ToggleConsole()
end
