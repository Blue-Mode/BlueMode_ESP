-- ==============================================
-- 🔵 BLUE MODE HUB | PART 1/2
-- ✅ STARTUP SCREEN + CORE SYSTEMS + FIXED GUI
-- ✅ MADE BY: BLUE_MODE / DWAYNE KEAN FRANCISCO
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
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local CUSTOM_GUI_BG = "rbxassetid://101782008402770"

-- FIX: Works on ALL executors (Delta, Flux, Celery, etc.)
local GuiContainer = Instance.new("Folder")
GuiContainer.Name = "BLUE_MODE_HUB_ROOT"
GuiContainer.Parent = pcall(function() return CoreGui end) and CoreGui or PlayerGui

local PRIORITY = {
    STARTUP = 9999,
    MAIN = 799,
    BOOMBOX = 798,
    CONSOLE = 797,
    EXIT_CONFIRM = 9999
}

local YOUTUBE_LINK = "https://youtube.com/@blue_mode?si=aCGyj0FnwCMtTP1M"
local SAVE_KEY_VOLUME = "BlueMode_Volume_v22"
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
    Outline.ZIndex = 10
    Outline.Parent = target
    table.insert(GuiElements, Outline)
end

-- EXIT CONFIRM POPUP
local function ShowExitConfirm(OnConfirm)
    local ConfirmUI = Instance.new("ScreenGui")
    ConfirmUI.Name = "BLUE_MODE_EXIT_CONFIRM"
    ConfirmUI.ResetOnSpawn = false
    ConfirmUI.DisplayOrder = PRIORITY.EXIT_CONFIRM
    ConfirmUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ConfirmUI.Parent = GuiContainer

    local Popup = Instance.new("Frame")
    Popup.Size = UDim2.new(0,380,0,220)
    Popup.Position = UDim2.new(0.5,-190,0.5,-110)
    Popup.BackgroundColor3 = Color3.fromRGB(15,15,25)
    Popup.Active = true
    Popup.Visible = true
    Popup.ZIndex = 10
    Popup.Parent = ConfirmUI
    Instance.new("UICorner", Popup).CornerRadius = UDim.new(0,16)

    local PopupBg = Instance.new("ImageLabel")
    PopupBg.Size = UDim2.new(1,0,1,0)
    PopupBg.BackgroundTransparency = 1
    PopupBg.Image = CUSTOM_GUI_BG
    PopupBg.ScaleType = Enum.ScaleType.Stretch
    PopupBg.ZIndex = 1
    PopupBg.Parent = Popup
    AddRainbowGlow(Popup,4)

    local PopupTitle = Instance.new("TextLabel")
    PopupTitle.Size = UDim2.new(1,-20,0,45)
    PopupTitle.Position = UDim2.new(0,10,0,12)
    PopupTitle.BackgroundTransparency = 1
    PopupTitle.Font = Enum.Font.GothamBold
    PopupTitle.TextScaled = true
    PopupTitle.Text = "⚠️ EXIT CONFIRM"
    PopupTitle.TextColor3 = Color3.new(1,1,1)
    PopupTitle.ZIndex = 2
    PopupTitle.Parent = Popup

    local PopupText = Instance.new("TextLabel")
    PopupText.Size = UDim2.new(1,-30,0,40)
    PopupText.Position = UDim2.new(0,15,0,65)
    PopupText.BackgroundTransparency = 1
    PopupText.Font = Enum.Font.Gotham
    PopupText.TextScaled = true
    PopupText.Text = "Close Blue Mode Hub?"
    PopupText.TextColor3 = Color3.fromRGB(230,230,230)
    PopupText.ZIndex = 2
    PopupText.Parent = Popup

    local YesBtn = Instance.new("TextButton")
    YesBtn.Size = UDim2.new(0,140,0,50)
    YesBtn.Position = UDim2.new(0,30,0,140)
    YesBtn.BackgroundColor3 = Color3.fromRGB(220,40,40)
    YesBtn.Font = Enum.Font.GothamBold
    YesBtn.TextScaled = true
    YesBtn.Text = "✅ YES EXIT"
    YesBtn.TextColor3 = Color3.new(1,1,1)
    YesBtn.ZIndex = 3
    YesBtn.Parent = Popup
    Instance.new("UICorner", YesBtn).CornerRadius = UDim.new(0,12)
    AddRainbowGlow(YesBtn,3)

    local NoBtn = Instance.new("TextButton")
    NoBtn.Size = UDim2.new(0,140,0,50)
    NoBtn.Position = UDim2.new(1,-170,0,140)
    NoBtn.BackgroundColor3 = Color3.fromRGB(30,150,220)
    NoBtn.Font = Enum.Font.GothamBold
    NoBtn.TextScaled = true
    NoBtn.Text = "❌ NO STAY"
    NoBtn.TextColor3 = Color3.new(1,1,1)
    NoBtn.ZIndex = 3
    NoBtn.Parent = Popup
    Instance.new("UICorner", NoBtn).CornerRadius = UDim.new(0,12)
    AddRainbowGlow(NoBtn,3)

    YesBtn.MouseButton1Click:Connect(function() ConfirmUI:Destroy() OnConfirm() end)
    NoBtn.MouseButton1Click:Connect(function() ConfirmUI:Destroy() end)
end

-- STARTUP SCREEN (ALWAYS SHOWS NOW)
local StartupUI = Instance.new("ScreenGui")
StartupUI.Name = "BLUE_MODE_HUB_STARTUP"
StartupUI.ResetOnSpawn = false
StartupUI.DisplayOrder = PRIORITY.STARTUP
StartupUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
StartupUI.Parent = GuiContainer

local StartupBox = Instance.new("Frame")
StartupBox.Size = UDim2.new(0, 420, 0, 420)
StartupBox.Position = UDim2.new(0.5, -210, 0.5, -210)
StartupBox.BackgroundColor3 = Color3.fromRGB(10,12,18)
StartupBox.Active = true
StartupBox.Visible = true
StartupBox.ZIndex = 10
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
UpdateList.Text = [[• NO TIME LIMITS / NO COOLDOWNS
• FIXED: FPS / PING / SERVER PING
• ADDED: EXIT CONFIRMATION
• RAINBOW ESP + FRIEND DOT
• Creator: Dwayne Kean / Blue_Mode]]
UpdateList.Parent = StartupBox

local OkBtn = Instance.new("TextButton")
OkBtn.Size = UDim2.new(0, 260, 0, 60)
OkBtn.Position = UDim2.new(0.5, -130, 0, 330)
OkBtn.BackgroundColor3 = Color3.fromRGB(15, 110, 230)
OkBtn.Font = Enum.Font.GothamBold
OkBtn.TextScaled = true
OkBtn.Text = "✓ LOAD MAIN HUB"
OkBtn.TextColor3 = Color3.new(1,1,1)
OkBtn.AutoLocalize = false
OkBtn.ZIndex = 5
OkBtn.Visible = true
OkBtn.Parent = StartupBox
Instance.new("UICorner", OkBtn).CornerRadius = UDim.new(0, 16)
AddRainbowGlow(OkBtn, 3)

local StartupHue = 0
RunService.Heartbeat:Connect(function(dt)
    StartupHue = (StartupHue + dt * 0.3) % 1
    local Col = Color3.fromHSV(StartupHue, 1, 1)
    StartupBorder.Color = Col
    StartupTitle.TextColor3 = Col
end)

print("✅ BLUE MODE HUB STARTUP READY")
-- RUN PART 2 TO FINISH LOADING
-- ==============================================
-- 🔵 BLUE MODE HUB | PART 2/2 (COMPLETE)
-- ✅ MAIN UI + ESP + BOOMBOX + VOLUME + FPS/PING + DRAG + ALL FIXES
-- ✅ CROSS-EXECUTOR: DELTA, FLUX, CELERY, ETC.
-- ==============================================

-- Link Part 1 Startup Button
OkBtn.MouseButton1Click:Connect(function()
    StartupUI:Destroy()
    LoadMainHub()
end)

function LoadMainHub()
    local MusicVolume = LoadData(SAVE_KEY_VOLUME, 500)
    local CurrentSound = nil
    local VolNumTextMain, VolFillMain, VolFillMenu, VolNumMenu, ESPBtn
    local FPSLabel, PingLabel, ServerPingLabel
    local ESP_Enabled = false
    local Buttons_Locked = false
    local Hue = 0
    local FPSCounter = 0
    local LastFPSUpdate = os.clock()
    local FriendsList = {}

    -- GET FRIENDS LIST
    pcall(function()
        for _,v in pairs(LocalPlayer:GetFriends()) do
            FriendsList[v.UserId] = true
        end
    end)

    -- PING / FPS CALCULATORS
    local function GetClientPing()
        local s = os.clock()
        task.wait()
        return math.floor((os.clock() - s) * 1000)
    end

    local function GetServerPing()
        return math.floor(NetworkClient:GetStats().Ping or 0)
    end

    -- CLEANUP OLD ESP
    local function ClearAllESP()
        for _,P in pairs(Players:GetPlayers()) do
            if P and P.Character then pcall(function()
                if P.Character:FindFirstChild("BLUE_Outline") then P.Character.BLUE_Outline:Destroy() end
                if P.Character:FindFirstChild("FriendRainbowDot") then P.Character.FriendRainbowDot:Destroy() end
                if P.Character:FindFirstChild("OwnerCrown") then P.Character.OwnerCrown:Destroy() end
            end) end
        end
        pcall(function()
            for _,D in pairs(workspace:GetDescendants()) do
                if D.Name == "BLUE_Outline" or D.Name == "FriendRainbowDot" or D.Name == "OwnerCrown" then
                    D:Destroy()
                end
            end
        end)
    end

    -- DEATH / RESPAWN FIX
    local function SetupDeathCheck()
        local function CheckCharacter(Char)
            if not Char then return end
            local Hum = Char:WaitForChild("Humanoid", 10)
            if not Hum then return end
            Hum.Died:Connect(function()
                if ESP_Enabled then
                    ESP_Enabled = false
                    if ESPBtn then
                        ESPBtn.Text = "👁️ ESP: OFF"
                        ESPBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
                    end
                    ClearAllESP()
                end
            end)
        end
        CheckCharacter(LocalPlayer.Character)
        LocalPlayer.CharacterAdded:Connect(CheckCharacter)
    end

    -- VOLUME CONTROL
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

    -- SOUND HANDLERS
    local function FormatSoundID(input)
        return "rbxassetid://"..tostring(input):gsub("%D","")
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
    local function StopSound()
        pcall(function() if CurrentSound then CurrentSound:Destroy() end end)
        CurrentSound = nil
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
        BoomUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        BoomUI.Parent = GuiContainer
        CurrentBoomboxUI = BoomUI
        BoomboxUI_Open = true

        local BoomFrame = Instance.new("Frame")
        BoomFrame.Size = UDim2.new(0,320,0,250)
        BoomFrame.Position = UDim2.new(0.5,-160,0.5,-125)
        BoomFrame.BackgroundColor3 = Color3.fromRGB(22,22,22)
        BoomFrame.Active = true
        BoomFrame.Draggable = true
        BoomFrame.Visible = true
        BoomFrame.Parent = BoomUI
        Instance.new("UICorner", BoomFrame).CornerRadius = UDim.new(0,12)

        local BoomGuiBg = Instance.new("ImageLabel")
        BoomGuiBg.Size = UDim2.new(1, 0, 1, 0)
        BoomGuiBg.Position = UDim2.new(0, 0, 0, 0)
        BoomGuiBg.BackgroundTransparency = 1
        BoomGuiBg.Image = CUSTOM_GUI_BG
        BoomGuiBg.ScaleType = Enum.ScaleType.Stretch
        BoomGuiBg.ZIndex = 1
        BoomGuiBg.Parent = BoomFrame
        AddRainbowGlow(BoomFrame,4)

        local CloseTop = Instance.new("TextButton")
        CloseTop.Size = UDim2.new(0,30,0,30)
        CloseTop.Position = UDim2.new(1,-35,0,5)
        CloseTop.BackgroundColor3 = Color3.fromRGB(170,30,30)
        CloseTop.Text = "✕"
        CloseTop.TextColor3 = Color3.new(1,1,1)
        CloseTop.Font = Enum.Font.GothamBold
        CloseTop.TextSize = 24
        CloseTop.ZIndex = 3
        CloseTop.Parent = BoomFrame
        CloseTop.MouseButton1Click:Connect(function() ToggleBoomboxMenu() end)

        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1,-70,0,40)
        Title.Position = UDim2.new(0,12,0,8)
        Title.BackgroundTransparency = 1
        Title.Text = "🎵 BOOMBOX & VOLUME"
        Title.TextColor3 = Color3.new(1,1,1)
        Title.Font = Enum.Font.GothamBold
        Title.TextScaled = true
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.ZIndex = 2
        Title.Parent = BoomFrame

        local Input = Instance.new("TextBox")
        Input.Size = UDim2.new(1,-40,0,45)
        Input.Position = UDim2.new(0,20,0,55)
        Input.BackgroundColor3 = Color3.fromRGB(35,35,35)
        Input.PlaceholderText = "Paste Sound ID here..."
        Input.Text = ""
        Input.TextColor3 = Color3.new(1,1,1)
        Input.Font = Enum.Font.Gotham
        Input.TextSize = 14
        Input.ZIndex = 2
        Input.Parent = BoomFrame
        Instance.new("UICorner", Input).CornerRadius = UDim.new(0,10)

        local PlayBtn = Instance.new("TextButton")
        PlayBtn.Size = UDim2.new(0,130,0,40)
        PlayBtn.Position = UDim2.new(0,20,0,110)
        PlayBtn.BackgroundColor3 = Color3.fromRGB(20,140,60)
        PlayBtn.Text = "▶ PLAY"
        PlayBtn.TextColor3 = Color3.new(1,1,1)
        PlayBtn.Font = Enum.Font.GothamBold
        PlayBtn.TextScaled = true
        PlayBtn.ZIndex = 3
        PlayBtn.Parent = BoomFrame
        Instance.new("UICorner", PlayBtn).CornerRadius = UDim.new(0,10)

        local StopBtn = Instance.new("TextButton")
        StopBtn.Size = UDim2.new(0,130,0,40)
        StopBtn.Position = UDim2.new(1,-150,0,110)
        StopBtn.BackgroundColor3 = Color3.fromRGB(170,30,30)
        StopBtn.Text = "⏹ STOP"
        StopBtn.TextColor3 = Color3.new(1,1,1)
        StopBtn.Font = Enum.Font.GothamBold
        StopBtn.TextScaled = true
        StopBtn.ZIndex = 3
        StopBtn.Parent = BoomFrame
        Instance.new("UICorner", StopBtn).CornerRadius = UDim.new(0,10)

        -- VOLUME SLIDER MENU
        local VolSliderBg = Instance.new("Frame")
        VolSliderBg.Size = UDim2.new(1,-40,0,25)
        VolSliderBg.Position = UDim2.new(0,20,0,165)
        VolSliderBg.BackgroundColor3 = Color3.fromRGB(45,45,45)
        VolSliderBg.ZIndex = 2
        VolSliderBg.Parent = BoomFrame
        Instance.new("UICorner", VolSliderBg).CornerRadius = UDim.new(0,8)

        VolFillMenu = Instance.new("Frame")
        VolFillMenu.Size = UDim2.new(MusicVolume/VOLUME_MAX,0,1,0)
        VolFillMenu.BackgroundColor3 = Color3.fromRGB(0,170,255)
        VolFillMenu.ZIndex = 3
        VolFillMenu.Parent = VolSliderBg
        Instance.new("UICorner", VolFillMenu).CornerRadius = UDim.new(0,8)

        VolNumMenu = Instance.new("TextLabel")
        VolNumMenu.Size = UDim2.new(1,0,1,0)
        VolNumMenu.BackgroundTransparency = 1
        VolNumMenu.Text = tostring(MusicVolume)
        VolNumMenu.TextColor3 = Color3.new(1,1,1)
        VolNumMenu.Font = Enum.Font.GothamBold
        VolNumMenu.TextSize = 12
        VolNumMenu.ZIndex = 4
        VolNumMenu.Parent = VolSliderBg

        -- SLIDER DRAG
        local DragVol = false
        VolSliderBg.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then DragVol = true end end)
        UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then DragVol = false end end)
        UserInputService.InputChanged:Connect(function(i)
            if DragVol and i.UserInputType == Enum.UserInputType.MouseMovement then
                local P = VolSliderBg.AbsolutePosition
                local S = VolSliderBg.AbsoluteSize.X
                local X = math.clamp(i.Position.X - P.X, 0, S)
                UpdateVolume((X/S)*VOLUME_MAX)
            end
        end)

        PlayBtn.MouseButton1Click:Connect(function() if Input.Text ~= "" then PlaySound(Input.Text) end end)
        StopBtn.MouseButton1Click:Connect(StopSound)
    end

    -- MAIN HUB UI
    local MainUI = Instance.new("ScreenGui")
    MainUI.Name = "BLUE_MODE_HUB_MAIN"
    MainUI.ResetOnSpawn = false
    MainUI.DisplayOrder = PRIORITY.MAIN
    MainUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    MainUI.Parent = GuiContainer

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 340, 0, 480)
    MainFrame.Position = UDim2.new(0.02,0,0.5,-240)
    MainFrame.BackgroundColor3 = Color3.fromRGB(12,14,20)
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Visible = true
    MainFrame.Parent = MainUI
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 16)

    local MainBg = Instance.new("ImageLabel")
    MainBg.Size = UDim2.new(1,0,1,0)
    MainBg.BackgroundTransparency = 1
    MainBg.Image = CUSTOM_GUI_BG
    MainBg.ScaleType = Enum.ScaleType.Stretch
    MainBg.ZIndex = 1
    MainBg.Parent = MainFrame
    AddRainbowGlow(MainFrame, 5)

    -- HEADER
    local Header = Instance.new("TextLabel")
    Header.Size = UDim2.new(1,-20,0,50)
    Header.Position = UDim2.new(0,10,0,10)
    Header.BackgroundTransparency = 1
    Header.Font = Enum.Font.GothamBlack
    Header.TextScaled = true
    Header.Text = "🔵 BLUE MODE HUB"
    Header.TextColor3 = Color3.fromRGB(0,190,255)
    Header.ZIndex = 2
    Header.Parent = MainFrame

    -- STATS ROW
    local StatsFrame = Instance.new("Frame")
    StatsFrame.Size = UDim2.new(1,-20,0,35)
    StatsFrame.Position = UDim2.new(0,10,0,70)
    StatsFrame.BackgroundColor3 = Color3.fromRGB(25,25,35)
    StatsFrame.ZIndex = 2
    StatsFrame.Parent = MainFrame
    Instance.new("UICorner", StatsFrame).CornerRadius = UDim.new(0,10)

    FPSLabel = Instance.new("TextLabel")
    FPSLabel.Size = UDim2.new(0.33,0,1,0)
    FPSLabel.BackgroundTransparency = 1
    FPSLabel.Text = "FPS: 0"
    FPSLabel.TextColor3 = Color3.fromRGB(80,220,120)
    FPSLabel.Font = Enum.Font.GothamBold
    FPSLabel.TextScaled = true
    FPSLabel.ZIndex = 3
    FPSLabel.Parent = StatsFrame

    PingLabel = Instance.new("TextLabel")
    PingLabel.Size = UDim2.new(0.34,0,1,0)
    PingLabel.Position = UDim2.new(0.33,0,0,0)
    PingLabel.BackgroundTransparency = 1
    PingLabel.Text = "PING: 0ms"
    PingLabel.TextColor3 = Color3.fromRGB(255,180,80)
    PingLabel.Font = Enum.Font.GothamBold
    PingLabel.TextScaled = true
    PingLabel.ZIndex = 3
    PingLabel.Parent = StatsFrame

    ServerPingLabel = Instance.new("TextLabel")
    ServerPingLabel.Size = UDim2.new(0.33,0,1,0)
    ServerPingLabel.Position = UDim2.new(0.67,0,0,0)
    ServerPingLabel.BackgroundTransparency = 1
    ServerPingLabel.Text = "SERV: 0ms"
    ServerPingLabel.TextColor3 = Color3.fromRGB(255,80,80)
    ServerPingLabel.Font = Enum.Font.GothamBold
    ServerPingLabel.TextScaled = true
    ServerPingLabel.ZIndex = 3
    ServerPingLabel.Parent = StatsFrame

    -- MAIN BUTTONS
    ESPBtn = Instance.new("TextButton")
    ESPBtn.Size = UDim2.new(1,-30,0,50)
    ESPBtn.Position = UDim2.new(0,15,0,120)
    ESPBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    ESPBtn.Font = Enum.Font.GothamBold
    ESPBtn.TextScaled = true
    ESPBtn.Text = "👁️ ESP: OFF"
    ESPBtn.TextColor3 = Color3.new(1,1,1)
    ESPBtn.ZIndex = 3
    ESPBtn.Parent = MainFrame
    Instance.new("UICorner", ESPBtn).CornerRadius = UDim.new(0,12)

    local BoomBtn = Instance.new("TextButton")
    BoomBtn.Size = UDim2.new(1,-30,0,50)
    BoomBtn.Position = UDim2.new(0,15,0,180)
    BoomBtn.BackgroundColor3 = Color3.fromRGB(20,110,180)
    BoomBtn.Font = Enum.Font.GothamBold
    BoomBtn.TextScaled = true
    BoomBtn.Text = "🎵 OPEN BOOMBOX"
    BoomBtn.TextColor3 = Color3.new(1,1,1)
    BoomBtn.ZIndex = 3
    BoomBtn.Parent = MainFrame
    Instance.new("UICorner", BoomBtn).CornerRadius = UDim.new(0,12)

    -- MAIN VOLUME SLIDER
    local VolLabel = Instance.new("TextLabel")
    VolLabel.Size = UDim2.new(1,-30,0,30)
    VolLabel.Position = UDim2.new(0,15,0,250)
    VolLabel.BackgroundTransparency = 1
    VolLabel.Text = "🔊 VOLUME: "..tostring(MusicVolume)
    VolLabel.TextColor3 = Color3.new(1,1,1)
    VolLabel.Font = Enum.Font.GothamBold
    VolLabel.TextScaled = true
    VolLabel.TextXAlignment = Enum.TextXAlignment.Left
    VolLabel.ZIndex = 2
    VolLabel.Parent = MainFrame

    local VolSliderBgMain = Instance.new("Frame")
    VolSliderBgMain.Size = UDim2.new(1,-30,0,25)
    VolSliderBgMain.Position = UDim2.new(0,15,0,285)
    VolSliderBgMain.BackgroundColor3 = Color3.fromRGB(45,45,45)
    VolSliderBgMain.ZIndex = 2
    VolSliderBgMain.Parent = MainFrame
    Instance.new("UICorner", VolSliderBgMain).CornerRadius = UDim.new(0,8)

    VolFillMain = Instance.new("Frame")
    VolFillMain.Size = UDim2.new(MusicVolume/VOLUME_MAX,0,1,0)
    VolFillMain.BackgroundColor3 = Color3.fromRGB(0,170,255)
    VolFillMain.ZIndex = 3
    VolFillMain.Parent = VolSliderBgMain
    Instance.new("UICorner", VolFillMain).CornerRadius = UDim.new(0,8)

    VolNumTextMain = Instance.new("TextLabel")
    VolNumTextMain.Size = UDim2.new(1,0,1,0)
    VolNumTextMain.BackgroundTransparency = 1
    VolNumTextMain.Text = tostring(MusicVolume)
    VolNumTextMain.TextColor3 = Color3.new(1,1,1)
    VolNumTextMain.Font = Enum.Font.GothamBold
    VolNumTextMain.TextSize = 12
    VolNumTextMain.ZIndex = 4
    VolNumTextMain.Parent = VolSliderBgMain

    local DragVolMain = false
    VolSliderBgMain.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then DragVolMain = true end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then DragVolMain = false end end)
    UserInputService.InputChanged:Connect(function(i)
        if DragVolMain and i.UserInputType == Enum.UserInputType.MouseMovement then
            local P = VolSliderBgMain.AbsolutePosition
            local S = VolSliderBgMain.AbsoluteSize.X
            local X = math.clamp(i.Position.X - P.X, 0, S)
            UpdateVolume((X/S)*VOLUME_MAX)
        end
    end)

    -- EXIT BUTTON
    local ExitBtn = Instance.new("TextButton")
    ExitBtn.Size = UDim2.new(1,-30,0,50)
    ExitBtn.Position = UDim2.new(0,15,0,410)
    ExitBtn.BackgroundColor3 = Color3.fromRGB(190,30,30)
    ExitBtn.Font = Enum.Font.GothamBold
    ExitBtn.TextScaled = true
    ExitBtn.Text = "❌ EXIT HUB"
    ExitBtn.TextColor3 = Color3.new(1,1,1)
    ExitBtn.ZIndex = 3
    ExitBtn.Parent = MainFrame
    Instance.new("UICorner", ExitBtn).CornerRadius = UDim.new(0,12)

    -- TOGGLE FUNCTIONS
    BoomBtn.MouseButton1Click:Connect(ToggleBoomboxMenu)
    ExitBtn.MouseButton1Click:Connect(function()
        ShowExitConfirm(function()
            ClearAllESP()
            StopSound()
            getgenv().BlueMode_Loaded = false
            GuiContainer:Destroy()
        end)
    end)

    -- ESP SYSTEM
    local function AddESP(Char, Player)
        if not Char or not Player or Char == LocalPlayer.Character then return end
        local Hum = Char:FindFirstChild("Humanoid")
        if not Hum then return end

        -- COLOR RULES
        local OutlineColor = Color3.fromRGB(255,80,80) -- RED: ENEMY
        if FriendsList[Player.UserId] then OutlineColor = Color3.fromRGB(80,255,120) end -- GREEN: FRIEND
        if Player.Name == "Dwaynekean015" then OutlineColor = Color3.fromRGB(255,215,0) end -- GOLD: OWNER

        -- OUTLINE
        local Outline = Instance.new("Highlights")
        Outline.Name = "BLUE_Outline"
        Outline.FillTransparency = 0.6
        Outline.OutlineTransparency = 0
        Outline.FillColor = OutlineColor
        Outline.OutlineColor = OutlineColor
        Outline.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        Outline.Adornee = Char
        Outline.Parent = Char

        -- FRIEND RAINBOW DOT
        if FriendsList[Player.UserId] then
            local Dot = Instance.new("BillboardGui")
            Dot.Name = "FriendRainbowDot"
            Dot.Size = UDim2.new(0,12,0,12)
            Dot.StudsOffset = Vector3.new(0,3,0)
            Dot.AlwaysOnTop = true
            Dot.Parent = Char.Head
            local Circle = Instance.new("Frame")
            Circle.Size = UDim2.new(1,0,1,0)
            Circle.BackgroundColor3 = Color3.new(1,1,1)
            Instance.new("UICorner", Circle).CornerRadius = UDim.new(1,0)
            AddRainbowGlow(Circle,2)
            Circle.Parent = Dot
        end

        -- OWNER GOLD CROWN
        if Player.Name == "Dwaynekean015" then
            local Crown = Instance.new("BillboardGui")
            Crown.Name = "OwnerCrown"
            Crown.Size = UDim2.new(0,24,0,24)
            Crown.StudsOffset = Vector3.new(0,2.5,0)
            Crown.AlwaysOnTop = true
            Crown.Parent = Char.Head
            local CrownImg = Instance.new("ImageLabel")
            CrownImg.Size = UDim2.new(1,0,1,0)
            CrownImg.BackgroundTransparency = 1
            CrownImg.Image = "rbxassetid://140229004"
            CrownImg.ImageColor3 = Color3.fromRGB(255,215,0)
            CrownImg.Parent = Crown
        end
    end

    ESPBtn.MouseButton1Click:Connect(function()
        if Buttons_Locked then return end
        Buttons_Locked = true
        ESP_Enabled = not ESP_Enabled
        if ESP_Enabled then
            ESPBtn.Text = "👁️ ESP: ON"
            ESPBtn.BackgroundColor3 = Color3.fromRGB(20,140,60)
            for _,P in pairs(Players:GetPlayers()) do
                if P ~= LocalPlayer and P.Character then task.spawn(AddESP, P.Character, P) end
            end
            Players.PlayerAdded:Connect(function(P)
                P.CharacterAdded:Connect(function(C) task.wait(0.1); if ESP_Enabled then AddESP(C,P) end end)
            end)
        else
            ESPBtn.Text = "👁️ ESP: OFF"
            ESPBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
            ClearAllESP()
        end
        task.wait(0.1)
        Buttons_Locked = false
    end)

    -- MAIN LOOP: RAINBOW + FPS/PING UPDATE
    RunService.Heartbeat:Connect(function(dt)
        Hue = (Hue + dt * 0.4) % 1
        local Col = Color3.fromHSV(Hue, 1, 1)
        if MainFrame:FindFirstChildOfClass("UIStroke") then
            MainFrame:FindFirstChildOfClass("UIStroke").Color = Col
        end

        -- FPS COUNT
        FPSCounter += 1
        if os.clock() - LastFPSUpdate >= 1 then
            FPSLabel.Text = "FPS: "..tostring(FPSCounter)
            FPSCounter = 0
            LastFPSUpdate = os.clock()
        end

        -- PING
        PingLabel.Text = "PING: "..tostring(GetClientPing()).."ms"
        ServerPingLabel.Text = "SERV: "..tostring(GetServerPing()).."ms"
    end)

    SetupDeathCheck()
    print("✅ BLUE MODE HUB FULLY LOADED | ALL FEATURES ACTIVE")
end

