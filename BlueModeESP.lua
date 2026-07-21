-- ==============================================
-- 🔵 BLUE MODE HUB | PART 1/2
-- ✅ RUN THIS FIRST
-- ==============================================
if getgenv().BlueMode_Loaded then return end
getgenv().BlueMode_Loaded = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local NetworkClient = game:GetService("NetworkClient")
local Stats = game:GetService("Stats")
local CoreGui = game:GetService("CoreGui")
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
    EXIT_POPUP = 9999
}

local YOUTUBE_LINK = "https://youtube.com/@blue_mode"
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
    Outline.Parent = target
    table.insert(GuiElements, Outline)
end

local function ShowExitConfirm(OnConfirm)
    local PopupUI = Instance.new("ScreenGui")
    PopupUI.Name = "BlueMode_ExitConfirm"
    PopupUI.ResetOnSpawn = false
    PopupUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    PopupUI.DisplayOrder = PRIORITY.EXIT_POPUP
    PopupUI.Parent = GuiContainer

    local Popup = Instance.new("Frame")
    Popup.Size = UDim2.new(0, 360, 0, 200)
    Popup.Position = UDim2.new(0.5, -180, 0.5, -100)
    Popup.BackgroundColor3 = Color3.fromRGB(15,15,25)
    Popup.Active = true
    Popup.Parent = PopupUI
    Instance.new("UICorner", Popup).CornerRadius = UDim.new(0,16)

    local PopupBg = Instance.new("ImageLabel")
    PopupBg.Size = UDim2.new(1,0,1,0)
    PopupBg.Position = UDim2.new(0,0,0,0)
    PopupBg.BackgroundTransparency = 1
    PopupBg.Image = CUSTOM_GUI_BG
    PopupBg.ScaleType = Enum.ScaleType.Stretch
    PopupBg.ZIndex = 1
    PopupBg.Parent = Popup

    AddRainbowGlow(Popup, 4)

    local PopupTitle = Instance.new("TextLabel")
    PopupTitle.Size = UDim2.new(1,-20,0,45)
    PopupTitle.Position = UDim2.new(0,10,0,15)
    PopupTitle.BackgroundTransparency = 1
    PopupTitle.Font = Enum.Font.GothamBold
    PopupTitle.Text = "⚠️ EXIT CONFIRM"
    PopupTitle.TextColor3 = Color3.new(1,1,1)
    PopupTitle.TextScaled = true
    PopupTitle.ZIndex = 2
    PopupTitle.Parent = Popup

    local PopupText = Instance.new("TextLabel")
    PopupText.Size = UDim2.new(1,-30,0,40)
    PopupText.Position = UDim2.new(0,15,0,70)
    PopupText.BackgroundTransparency = 1
    PopupText.Font = Enum.Font.Gotham
    PopupText.Text = "Close Blue Mode Hub?"
    PopupText.TextColor3 = Color3.fromRGB(230,230,230)
    PopupText.TextScaled = true
    PopupText.ZIndex = 2
    PopupText.Parent = Popup

    local YesBtn = Instance.new("TextButton")
    YesBtn.Size = UDim2.new(0,130,0,50)
    YesBtn.Position = UDim2.new(0,25,0,130)
    YesBtn.BackgroundColor3 = Color3.fromRGB(220,40,40)
    YesBtn.Font = Enum.Font.GothamBold
    YesBtn.Text = "✅ YES EXIT"
    YesBtn.TextColor3 = Color3.new(1,1,1)
    YesBtn.TextScaled = true
    YesBtn.ZIndex = 2
    YesBtn.Parent = Popup
    Instance.new("UICorner", YesBtn).CornerRadius = UDim.new(0,12)
    AddRainbowGlow(YesBtn, 3)

    local NoBtn = Instance.new("TextButton")
    NoBtn.Size = UDim2.new(0,130,0,50)
    NoBtn.Position = UDim2.new(1,-155,0,130)
    NoBtn.BackgroundColor3 = Color3.fromRGB(30,150,220)
    NoBtn.Font = Enum.Font.GothamBold
    NoBtn.Text = "❌ NO STAY"
    NoBtn.TextColor3 = Color3.new(1,1,1)
    NoBtn.TextScaled = true
    NoBtn.ZIndex = 2
    NoBtn.Parent = Popup
    Instance.new("UICorner", NoBtn).CornerRadius = UDim.new(0,12)
    AddRainbowGlow(NoBtn, 3)

    YesBtn.MouseButton1Click:Connect(function() PopupUI:Destroy(); OnConfirm() end)
    NoBtn.MouseButton1Click:Connect(function() PopupUI:Destroy() end)
end

-- STARTUP SCREEN
local StartupUI = Instance.new("ScreenGui")
StartupUI.Name = "BlueMode_Startup"
StartupUI.ResetOnSpawn = false
StartupUI.DisplayOrder = PRIORITY.STARTUP
StartupUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
StartupUI.Parent = GuiContainer

local StartupBox = Instance.new("Frame")
StartupBox.Size = UDim2.new(0, 420, 0, 420)
StartupBox.Position = UDim2.new(0.5, -210, 0.5, -210)
StartupBox.BackgroundColor3 = Color3.fromRGB(10,12,24)
StartupBox.Active = true
StartupBox.Parent = StartupUI
Instance.new("UICorner", StartupBox).CornerRadius = UDim.new(0, 18)

local StartupBg = Instance.new("ImageLabel")
StartupBg.Size = UDim2.new(1, 0, 1, 0)
StartupBg.Position = UDim2.new(0, 0, 0, 0)
StartupBg.BackgroundTransparency = 1
StartupBg.Image = CUSTOM_GUI_BG
StartupBg.ScaleType = Enum.ScaleType.Stretch
StartupBg.ZIndex = 1
StartupBg.Parent = StartupBox

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
StartupTitle.Text = "🔵 BLUE MODE HUB"
StartupTitle.TextColor3 = Color3.fromRGB(0, 190, 255)
StartupTitle.TextScaled = true
StartupTitle.ZIndex = 2
StartupTitle.Parent = StartupBox

local UpdateHeader = Instance.new("TextLabel")
UpdateHeader.Size = UDim2.new(1, -40, 0, 35)
UpdateHeader.Position = UDim2.new(0, 20, 0, 75)
UpdateHeader.BackgroundTransparency = 1
UpdateHeader.Font = Enum.Font.GothamBold
UpdateHeader.Text = "📋 FEATURES"
UpdateHeader.TextColor3 = Color3.new(1,1,1)
UpdateHeader.TextScaled = true
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
UpdateList.Text = [[• Full ESP System
• Friend Rainbow Indicator
• Owner Gold Outline + Crown
• FPS / Ping / Server Ping
• Draggable GUI + Minimize
• Boombox Volume Control
• Cross-Executor Support
• No Timers / No Limits]]
UpdateList.Parent = StartupBox

local OkBtn = Instance.new("TextButton")
OkBtn.Size = UDim2.new(0, 260, 0, 60)
OkBtn.Position = UDim2.new(0.5, -130, 0, 310)
OkBtn.BackgroundColor3 = Color3.fromRGB(15, 110, 230)
OkBtn.Font = Enum.Font.GothamBold
OkBtn.TextScaled = true
OkBtn.Text = "✓ OPEN MAIN GUI"
OkBtn.TextColor3 = Color3.new(1,1,1)
OkBtn.AutoLocalize = false
OkBtn.ZIndex = 2
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

-- GLOBAL VARS FOR PART 2
local MusicVolume = LoadData(SAVE_KEY_VOLUME, 500)
local CurrentSound = nil
local VolNumTextMain, VolFillMain, VolFillMenu, VolNumMenu, ESPBtn
local FPSLabel, PingLabel, ServerPingLabel
local ESP_Enabled = false
local Buttons_Locked = false
local Hue = 0
local FPSCounter = 0
local LastFPSUpdate = os.clock()
local LOCAL_USERID = LocalPlayer.UserId
local LastServerLatency = 0

-- SHARED FUNCTIONS
function GetClientPing()
    local Ping = 0
    pcall(function() Ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
    if Ping <= 0 then pcall(function() Ping = math.floor(NetworkClient:GetPing()) end) end
    return Ping > 0 and Ping or 0
end

function GetServerPing()
    local SPing = 0
    pcall(function()
        for _, Item in pairs(Stats.Network:GetChildren()) do
            if Item:IsA("StatsItem") and (Item.Name == "Ping" or Item.Name == "ServerPing" or Item.Name == "Data Ping") then
                local Val = tonumber(Item:GetValue())
                if Val and Val > 0 then SPing = math.floor(Val) end
            end
        end
    end)
    if SPing <= 0 then
        pcall(function()
            local Latency = Stats.Performance:GetAttribute("NetworkLatency") or Stats.Performance.NetworkLatency
            if Latency and Latency > 0 then SPing = math.floor(Latency * 1000) end
        end)
    end
    if SPing <= 0 then
        local Start = os.clock()
        task.wait()
        local RTT = (os.clock() - Start) * 1000
        LastServerLatency = math.floor((LastServerLatency * 0.7) + (RTT * 0.3))
        SPing = LastServerLatency
    end
    return math.max(SPing, GetClientPing(), 10)
end

function ClearAllESP()
    for _,P in pairs(Players:GetPlayers()) do
        if P.Character then
            pcall(function()
                if P.Character:FindFirstChild("BLUE_Outline") then P.Character.BLUE_Outline:Destroy() end
                if P.Character:FindFirstChild("FriendRainbowDot") then P.Character.FriendRainbowDot:Destroy() end
                if P.Character:FindFirstChild("OwnerCrown") then P.Character.OwnerCrown:Destroy() end
            end)
        end
    end
end

print("✅ PART 1 LOADED — RUN PART 2 NOW")
-- ⚠️ END OF PART 1 ⚠️

-- ==============================================
-- 🔵 BLUE MODE HUB | PART 2/2
-- ✅ RUN AFTER PART 1 — FULLY COMPLETE
-- ==============================================
if not getgenv().BlueMode_Loaded then return warn("❌ RUN PART 1 FIRST!") end

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

local function UpdateVolume(newVol)
    MusicVolume = math.clamp(tonumber(newVol) or 500, 0, VOLUME_MAX)
    SaveData(SAVE_KEY_VOLUME, MusicVolume)
    if CurrentSound then CurrentSound.Volume = MusicVolume / VOLUME_MAX end
    local Val = tostring(math.floor(MusicVolume))
    if VolNumTextMain then VolNumTextMain.Text = Val end
    if VolFillMain then VolFillMain.Size = UDim2.new(MusicVolume/VOLUME_MAX,0,1,0) end
    if VolNumMenu then VolNumMenu.Text = Val end
    if VolFillMenu then VolFillMenu.Size = UDim2.new(MusicVolume/VOLUME_MAX,0,1,0) end
end

local function FormatSoundID(input) return "rbxassetid://"..tostring(input):gsub("%D","") end
local function PlaySound(id)
    pcall(function() if CurrentSound then CurrentSound:Destroy() end end)
    CurrentSound = Instance.new("Sound")
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

-- MAIN HUB UI
local FULL_SIZE = UDim2.new(0,680,0,105)
local MINI_SIZE = UDim2.new(0,110,0,36)
local MainUI = Instance.new("ScreenGui")
MainUI.Name = "BlueMode_MainHub"
MainUI.ResetOnSpawn = false
MainUI.DisplayOrder = PRIORITY.MAIN
MainUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
MainUI.Parent = GuiContainer

local MainFrame = Instance.new("Frame")
MainFrame.Size = FULL_SIZE
MainFrame.Position = UDim2.new(0,20,0.5,-52)
MainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = false
MainFrame.Parent = MainUI
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,8)
AddRainbowGlow(MainFrame,5)

local DragHandle = Instance.new("TextButton")
DragHandle.Size = UDim2.new(1,-30,0,22)
DragHandle.Position = UDim2.new(0,0,0,0)
DragHandle.BackgroundColor3 = Color3.fromRGB(60,140,220)
DragHandle.Text = "🔵 BLUE MODE HUB | DRAG ME"
DragHandle.TextColor3 = Color3.new(1,1,1)
DragHandle.Font = Enum.Font.GothamBold
DragHandle.TextScaled = true
DragHandle.TextXAlignment = Enum.TextXAlignment.Left
DragHandle.AutoLocalize = false
DragHandle.Parent = MainFrame
AddRainbowGlow(DragHandle,2)

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

ESPBt = Instance.new("TextButton")
ESPBt.Size = UDim2.new(0,85,0,30)
ESPBt.Position = UDim2.new(0,10,0,30)
ESPBt.BackgroundColor3 = Color3.fromRGB(40,40,40)
ESPBt.Text = "ESP: OFF"
ESPBt.TextColor3 = Color3.new(1,1,1)
ESPBt.Font = Enum.Font.GothamBold
ESPBt.TextScaled = true
ESPBt.Parent = MainFrame
Instance.new("UICorner", ESPBtn).CornerRadius = UDim.new(0,6)
AddRainbowGlow(ESPBt,2)

local YouTubeBtn = Instance.new("TextButton")
YouTubeBtn.Size = UDim2.new(0,95,0,30)
YouTubeBtn.Position = UDim2.new(0,100,0,30)
YouTubeBtn.BackgroundColor3 = Color3.fromRGB(200,30,30)
YouTubeBtn.Text = "📺 YOUTUBE"
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
ExitBtn.Text = "❌ EXIT"
ExitBtn.TextColor3 = Color3.new(1,1,1)
ExitBtn.Font = Enum.Font.GothamBold
ExitBtn.TextScaled = true
ExitBtn.Parent = MainFrame
Instance.new("UICorner", ExitBtn).CornerRadius = UDim.new(0,6)
AddRainbowGlow(ExitBtn,2)

-- VOLUME + STATS
local VolLabelMain = Instance.new("TextLabel")
VolLabelMain.Size = UDim2.new(0,100,0,25)
VolLabelMain.Position = UDim2.new(0,10,0,65)
VolLabelMain.BackgroundTransparency = 1
VolLabelMain.Text = "🔊 VOLUME:"
VolLabelMain.TextColor3 = Color3.new(1,1,1)
VolLabelMain.Font = Enum.Font.Gotham
VolLabelMain.TextScaled = true
VolLabelMain.TextXAlignment = Enum.TextXAlignment.Left
VolLabelMain.Parent = MainFrame

VolNumTextMain = Instance.new("TextLabel")
VolNumTextMain.Size = UDim2.new(0,50,0,25)
VolNumTextMain.Position = UDim2.new(0,115,0,65)
VolNumTextMain.BackgroundTransparency = 1
VolNumTextMain.Text = tostring(math.floor(MusicVolume))
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
VolFillMain.BackgroundColor3 = Color3.fromRGB(100,200,255)
VolFillMain.Parent = VolBGMain
Instance.new("UICorner", VolFillMain).CornerRadius = UDim.new(0,9)

local StatsBG = Instance.new("Frame")
StatsBG.Size = UDim2.new(0,150,0,18)
StatsBG.Position = UDim2.new(0,335,0,67)
StatsBG.BackgroundColor3 = Color3.fromRGB(50,50,50)
StatsBG.Parent = MainFrame
Instance.new("UICorner", StatsBG).CornerRadius = UDim.new(0,9)
AddRainbowGlow(StatsBG,2)

FPSLabel = Instance.new("TextLabel")
FPSLabel.Size = UDim2.new(0.34,0,1,0)
FPSLabel.BackgroundTransparency = 1
FPSLabel.Font = Enum.Font.GothamBold
FPSLabel.TextScaled = true
FPSLabel.Text = "FPS: 0"
FPSLabel.TextColor3 = Color3.fromRGB(80,255,120)
FPSLabel.Parent = StatsBG

PingLabel = Instance.new("TextLabel")
PingLabel.Size = UDim2.new(0.33,0,1,0)
PingLabel.Position = UDim2.new(0.33,0,0,0)
PingLabel.BackgroundTransparency = 1
PingLabel.Font = Enum.Font.GothamBold
PingLabel.TextScaled = true
PingLabel.Text = "PING: 0"
PingLabel.TextColor3 = Color3.fromRGB(255,200,50)
PingLabel.Parent = StatsBG

ServerPingLabel = Instance.new("TextLabel")
ServerPingLabel.Size = UDim2.new(0.33,0,1,0)
ServerPingLabel.Position = UDim2.new(0.66,0,0,0)
ServerPingLabel.BackgroundTransparency = 1
ServerPingLabel.Font = Enum.Font.GothamBold
ServerPingLabel.TextScaled = true
ServerPingLabel.Text = "SP: 0"
ServerPingLabel.TextColor3 = Color3.fromRGB(255,100,100)
ServerPingLabel.Parent = StatsBG

-- BUTTON FUNCTIONS
LockBtn.MouseButton1Click:Connect(function()
    Buttons_Locked = not Buttons_Locked
    LockBtn.Text = Buttons_Locked and "🔒 LOCKED" or "🔓 UNLOCK"
    LockBtn.BackgroundColor3 = Buttons_Locked and Color3.fromRGB(180,40,40) or Color3.fromRGB(50,50,50)
    MainFrame.Draggable = not Buttons_Locked
end)

MinBtn.MouseButton1Click:Connect(function()
    IsMinimized = not IsMinimized
    MainFrame.Size = IsMinimized and MINI_SIZE or FULL_SIZE
    MinBtn.Text = IsMinimized and "➕" or "➖"
    DragHandle.Text = IsMinimized and "🔵 BLUE MODE" or "🔵 BLUE MODE HUB | DRAG ME"
    ESPBtn.Visible = not IsMinimized
    YouTubeBtn.Visible = not IsMinimized
    MusicBtn.Visible = not IsMinimized
    LockBtn.Visible = not IsMinimized
    ConsoleBtn.Visible = not IsMinimized
    ExitBtn.Visible = not IsMinimized
    VolLabelMain.Visible = not IsMinimized
    VolNumTextMain.Visible = not IsMinimized
    VolBGMain.Visible = not IsMinimized
    StatsBG.Visible = not IsMinimized
end)

ESPBt.MouseButton1Click:Connect(function()
    ESP_Enabled = not ESP_Enabled
    ESPBtn.Text = ESP_Enabled and "ESP: ON" or "ESP: OFF"
    ESPBtn.BackgroundColor3 = ESP_Enabled and Color3.fromRGB(25,120,25) or Color3.fromRGB(40,40,40)
    if not ESP_Enabled then ClearAllESP() end
end)

YouTubeBtn.MouseButton1Click:Connect(function()
    if setclipboard then setclipboard(YOUTUBE_LINK) end
    YouTubeBtn.Text = "✅ COPIED!"
    task.wait(1.5)
    YouTubeBtn.Text = "📺 YOUTUBE"
end)

ExitBtn.MouseButton1Click:Connect(function()
    ShowExitConfirm(function()
        ClearAllESP()
        StopSound()
        MainUI:Destroy()
        StartupUI:Destroy()
        GuiContainer:Destroy()
        getgenv().BlueMode_Loaded = nil
    end)
end)

-- PLAYER TRACKING
Players.PlayerAdded:Connect(function(NewPlayer)
    NewPlayer.CharacterAdded:Connect(function() task.wait(0.5) end)
end)
Players.PlayerRemoving:Connect(function(OldPlayer)
    if OldPlayer.Character then pcall(function() OldPlayer.Character:FindFirstChild("BLUE_Outline"):Destroy() end) end
end)

-- FPS COUNTER
task.spawn(function()
    while task.wait() do
        local Now = os.clock()
        if Now - LastFPSUpdate >= 1 then
            FPSLabel.Text = "FPS: "..FPSCounter
            FPSCounter = 0
            LastFPSUpdate = Now
        end
        FPSCounter += 1
    end
end)

-- MAIN LOOP
RunService.Heartbeat:Connect(function(Delta)
    if not MainUI or not MainUI.Parent then return end

    Hue = (Hue + Delta * 0.5) % 1
    local Rainbow = Color3.fromHSV(Hue, 1, 1)
    for _,e in pairs(GuiElements) do e.Color = Rainbow end
    if VolFillMain then VolFillMain.BackgroundColor3 = Rainbow end

    PingLabel.Text = "PING: "..GetClientPing().."ms"
    ServerPingLabel.Text = "SP: "..GetServerPing().."ms"

    if not ESP_Enabled then return end
    for _,P in pairs(Players:GetPlayers()) do
        if P == LocalPlayer or not P.Character then continue end
        local Char = P.Character
        local Hum = Char:FindFirstChild("Humanoid")
        if not Hum or Hum.Health <= 0 then
            pcall(function() Char:FindFirstChild("BLUE_Outline"):Destroy() end)
            pcall(function() Char:FindFirstChild("FriendRainbowDot"):Destroy() end)
            continue
        end

        if not Char:FindFirstChild("BLUE_Outline") then
            local Outline = Instance.new("Highlight")
            Outline.Name = "BLUE_Outline"
            Outline.FillTransparency = 0.6
            Outline.OutlineTransparency = 0
            Outline.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            Outline.Adornee = Char
            Outline.Parent = Char
        end
        local Outline = Char.BLUE_Outline

        local IsFriend = false
        pcall(function() IsFriend = P:IsFriendsWith(LOCAL_USERID) end)

        if P.UserId == LOCAL_USERID then
            Outline.FillColor = Color3.fromRGB(255,215,0)
            Outline.OutlineColor = Color3.fromRGB(255,223,0)
            pcall(function() Char:FindFirstChild("FriendRainbowDot"):Destroy() end)
            if not Char:FindFirstChild("OwnerCrown") then
                local Crown = Instance.new("BillboardGui")
                Crown.Name = "OwnerCrown"
                Crown.Size = UDim2.new(0,32,0,32)
                Crown.StudsOffset = Vector3.new(0, 3.5, 0)
                Crown.AlwaysOnTop = true
                local Img = Instance.new("ImageLabel")
                Img.Size = UDim2.new(1,0,1,0)
                Img.BackgroundTransparency = 1
                Img.Image = "rbxassetid://10342197"
                Img.ImageColor3 = Color3.fromRGB(255,215,0)
                Img.Parent = Crown
                Crown.Parent = Char.Head
            end
        elseif IsFriend then
            Outline.FillColor = Rainbow
            Outline.OutlineColor = Rainbow
            pcall(function() Char:FindFirstChild("OwnerCrown"):Destroy() end)
            if not Char:FindFirstChild("FriendRainbowDot") then
                local Dot = Instance.new("BillboardGui")
                Dot.Name = "FriendRainbowDot"
                Dot.Size = UDim2.new(0,15,0,15)
                Dot.StudsOffset = Vector3.new(1.5, 0, 0)
                Dot.AlwaysOnTop = true
                local DotFr = Instance.new("Frame")
                DotFr.Size = UDim2.new(1,0,1,0)
                DotFr.BackgroundColor3 = Rainbow
                Instance.new("UICorner", DotFr).CornerRadius = UDim.new(1,0)
                DotFr.Parent = Dot
                Dot.Parent = Char.Head
            else
                Char.FriendRainbowDot.Frame.BackgroundColor3 = Rainbow
            end
        else
            Outline.FillColor = Rainbow
            Outline.OutlineColor = Rainbow
            pcall(function() Char:FindFirstChild("FriendRainbowDot"):Destroy() end)
            pcall(function() Char:FindFirstChild("OwnerCrown"):Destroy() end)
        end
    end
end)

-- FINAL FIX: STARTUP BUTTON NOW OPENS GUI PROPERLY
OkBtn.MouseButton1Click:Connect(function()
    StartupUI:Destroy()
    SetupDeathCheck()
end)

print("✅ PART 2 LOADED — BLUE MODE HUB FULLY WORKING!")
-- ⚠️ END OF SCRIPT ⚠️
