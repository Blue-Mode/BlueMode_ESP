-- ==============================================
-- FIXED VERSION | No Typos + Full Compatibility
-- made by BLUE_MODE
-- ==============================================
if getgenv().BlueMode_Loaded then return end
getgenv().BlueMode_Loaded = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local USAGE_LIMIT = 12 * 3600
local COOLDOWN = 12 * 3600
local YOUTUBE_LINK = "https://youtube.com/@blue_mode?si=aCGyj0FnwCMtTP1M"
local SAVE_KEY_USED = "BlueMode_UsedTime_v2"
local SAVE_KEY_COOLDOWN = "BlueMode_CooldownEnd_v2"
local SAVE_KEY_VOLUME = "BlueMode_Volume_v2"

local function SaveData(key, value) pcall(function() writefile(key..".txt", tostring(value)) end) end
local function LoadData(key, default) local v=nil; pcall(function() v=readfile(key..".txt") end); return tonumber(v) or default end

local function ClearESP()
    for _, Plr in pairs(Players:GetPlayers()) do
        if Plr and Plr.Character then
            pcall(function() if Plr.Character:FindFirstChild("BLUE_Outline") then Plr.Character.BLUE_Outline:Destroy() end end)
            pcall(function() if Plr.Character:FindFirstChild("FriendRainbowDot") then Plr.Character.FriendRainbowDot:Destroy() end end)
        end
    end
end

local NowTime = os.time()
local CooldownEnd = LoadData(SAVE_KEY_COOLDOWN, 0)
if NowTime < CooldownEnd then
    print("⏳ COOLDOWN ACTIVE! Wait "..math.floor((CooldownEnd-NowTime)/60).." minutes")
    return
end

local UsedTime = LoadData(SAVE_KEY_USED, 0)
local LastCheck = os.time()
local MusicVolume = LoadData(SAVE_KEY_VOLUME, 0.5)
local CurrentSound = nil
local VolNumTextMain, VolFillMain, VolFillMenu, VolNumMenu, BoomFrame
local GuiElements = {}

local function AddRainbowGlow(target, thickness)
    local Outline = Instance.new("UIStroke")
    Outline.Name = "RainbowAura"
    Outline.Thickness = thickness or 3
    Outline.Transparency = 0
    Outline.Parent = target
    table.insert(GuiElements, Outline)
    return Outline
end

local function UpdateVolume(newVol)
    MusicVolume = math.clamp(newVol, 0, 1)
    SaveData(SAVE_KEY_VOLUME, MusicVolume)
    if CurrentSound then CurrentSound.Volume = MusicVolume end
    local pct = math.floor(MusicVolume*100).."%"
    if VolNumTextMain then VolNumTextMain.Text = pct end
    if VolFillMain then VolFillMain.Size = UDim2.new(MusicVolume,0,1,0) end
    if VolNumMenu then VolNumMenu.Text = pct end
    if VolFillMenu then VolFillMenu.Size = UDim2.new(MusicVolume,0,1,0) end
end

local function FormatSoundId(input) return "rbxassetid://"..tostring(input):gsub("[^%d]", "") end
local function LoadBoombox(id)
    pcall(function() if CurrentSound then CurrentSound:Destroy() end end)
    CurrentSound = Instance.new("Sound")
    CurrentSound.Name = "BLUE_BOOMBOX"
    CurrentSound.SoundId = FormatSoundId(id)
    CurrentSound.Volume = MusicVolume
    CurrentSound.Looped = true
    CurrentSound.Parent = SoundService
    pcall(function() CurrentSound:Play() end)
end

local function OpenBoomboxMenu()
    local BoomUI = Instance.new("ScreenGui")
    BoomUI.Name = "BLUE_BOOMBOX_MENU"
    BoomUI.ResetOnSpawn = false
    BoomUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    BoomUI.Parent = PlayerGui

    BoomFrame = Instance.new("Frame")
    BoomFrame.Size = UDim2.new(0,320,0,250)
    BoomFrame.Position = UDim2.new(0.5,-160,0.5,-125)
    BoomFrame.BackgroundColor3 = Color3.fromRGB(22,22,22)
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
    VolNumMenu.Text = math.floor(MusicVolume*100).."%"
    VolNumMenu.TextColor3 = Color3.new(1,1,1)
    VolNumMenu.Font = Enum.Font.GothamBold
    VolNumMenu.TextScaled = true
    VolNumMenu.Parent = BoomFrame

    local VolBG = Instance.new("Frame")
    VolBG.Size = UDim2.new(1,-40,0,24)
    VolBG.Position = UDim2.new(0,20,0,145)
    VolBG.BackgroundColor3 = Color3.fromRGB(50,50,50)
    VolBG.Parent = BoomFrame
    Instance.new("UICorner", VolBG).CornerRadius = UDim.new(0,12)
    AddRainbowGlow(VolBG,2)

    VolFillMenu = Instance.new("Frame")
    VolFillMenu.Size = UDim2.new(MusicVolume,0,1,0)
    VolFillMenu.BackgroundColor3 = Color3.fromRGB(100,100,100)
    VolFillMenu.Parent = VolBG
    Instance.new("UICorner", VolFillMenu).CornerRadius = UDim.new(0,12)

    local SliderActive = false
    VolBG.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then SliderActive = true end end)
    UserInputService.InputEnded:Connect(function() SliderActive = false end)
    UserInputService.InputChanged:Connect(function(i)
        if SliderActive then
            local rel = math.clamp((i.Position.X - VolBG.AbsolutePosition.X)/VolBG.AbsoluteSize.X,0,1)
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

    local function CloseMenu() BoomUI:Destroy() end
    PlayBtn.MouseButton1Click:Connect(function() if Input.Text~="" then LoadBoombox(Input.Text) end end)
    StopBtn.MouseButton1Click:Connect(function() if CurrentSound then CurrentSound:Destroy() end end)
    CloseTop.MouseButton1Click:Connect(CloseMenu)
end

local function OpenConsol()
    local ConsolUI = Instance.new("ScreenGui")
    ConsolUI.Name = "BLUE_CONSOL"
    ConsolUI.ResetOnSpawn = false
    ConsolUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ConsolUI.Parent = PlayerGui

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0,450,0,380)
    Frame.Position = UDim2.new(0.5,-225,0.5,-190)
    Frame.BackgroundColor3 = Color3.fromRGB(22,22,22)
    Frame.Parent = ConsolUI
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

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1,-50,0,35)
    Title.Position = UDim2.new(0,15,0,6)
    Title.BackgroundTransparency = 1
    Title.Text = "💻 CONSOL"
    Title.TextColor3 = Color3.new(1,1,1)
    Title.Font = Enum.Font.GothamBold
    Title.TextScaled = true
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Frame

    local Output = Instance.new("TextLabel")
    Output.Size = UDim2.new(1,-30,0,70)
    Output.Position = UDim2.new(0,15,0,45)
    Output.BackgroundColor3 = Color3.fromRGB(35,35,35)
    Output.Text = "System Ready | Paste script or type command"
    Output.TextColor3 = Color3.fromRGB(0,255,120)
    Output.Font = Enum.Font.Code
    Output.TextScaled = true
    Output.TextXAlignment = Enum.TextXAlignment.Left
    Output.TextWrapped = true
    Instance.new("UICorner", Output).CornerRadius = UDim.new(0,8)
    Output.Parent = Frame

    local Input = Instance.new("TextBox")
    Input.Size = UDim2.new(1,-30,0,150)
    Input.Position = UDim2.new(0,15,0,125)
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
    ExecBtn.Position = UDim2.new(0,15,0,290)
    ExecBtn.BackgroundColor3 = Color3.fromRGB(20,150,70)
    ExecBtn.Text = "▶ EXECUTE"
    ExecBtn.TextColor3 = Color3.new(1,1,1)
    ExecBtn.Font = Enum.Font.GothamBold
    ExecBtn.TextScaled = true
    ExecBtn.Parent = Frame
    Instance.new("UICorner", ExecBtn).CornerRadius = UDim.new(0,8)

    local ClearBtn = Instance.new("TextButton")
    ClearBtn.Size = UDim2.new(0,120,0,40)
    ClearBtn.Position = UDim2.new(0,165,0,290)
    ClearBtn.BackgroundColor3 = Color3.fromRGB(180,120,20)
    ClearBtn.Text = "🗑️ CLEAR"
    ClearBtn.TextColor3 = Color3.new(1,1,1)
    ClearBtn.Font = Enum.Font.GothamBold
    ClearBtn.TextScaled = true
    ClearBtn.Parent = Frame
    Instance.new("UICorner", ClearBtn).CornerRadius = UDim.new(0,8)

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0,120,0,40)
    CloseBtn.Position = UDim2.new(0,315,0,290)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(150,30,30)
    CloseBtn.Text = "✕ CLOSE"
    CloseBtn.TextColor3 = Color3.new(1,1,1)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextScaled = true
    CloseBtn.Parent = Frame
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0,8)

    local function CloseConsol() ConsolUI:Destroy() end
    ExecBtn.MouseButton1Click:Connect(function()
        if Input.Text=="" then Output.Text="⚠️ Nothing to run!" return end
        local run = loadstring or load
        if not run then Output.Text="❌ Loadstring not supported" return end
        local ok, err = pcall(run(Input.Text))
        Output.Text = ok and "✅ Script Executed Successfully!" or "❌ Error: "..tostring(err)
    end)
    ClearBtn.MouseButton1Click:Connect(function() Input.Text="" Output.Text="✅ Cleared!" end)
    CloseBtn.MouseButton1Click:Connect(CloseConsol)
    CloseTop.MouseButton1Click:Connect(CloseConsol)
end

local UI = Instance.new("ScreenGui")
UI.Name = "BLUE_MODE_ESP"
UI.ResetOnSpawn = false
UI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
UI.Parent = PlayerGui

local MAIN_SIZE = UDim2.new(0, 680, 0, 105)
local MIN_SIZE = UDim2.new(0, 50, 0, 50)
local Main = Instance.new("Frame")
Main.Size = MAIN_SIZE
Main.Position = UDim2.new(0, 20, 0.5, -52)
Main.BackgroundColor3 = Color3.fromRGB(25,25,25)
Main.Active = true
Main.ClipsDescendants = false
Main.Parent = UI
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,8)
AddRainbowGlow(Main,5)

local DragBar = Instance.new("Frame")
DragBar.Size = UDim2.new(1, -25, 0, 22)
DragBar.BackgroundColor3 = Color3.fromRGB(60,140,220)
DragBar.Active = true
DragBar.Parent = Main
AddRainbowGlow(DragBar,2)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -110, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "made by BLUE_MODE | DRAG HERE"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = DragBar

local TimerLabel = Instance.new("TextLabel")
TimerLabel.Size = UDim2.new(0, 100, 1, 0)
TimerLabel.Position = UDim2.new(1, -105, 0, 0)
TimerLabel.BackgroundTransparency = 1
TimerLabel.Text = "00:00:00 / 12:00:00"
TimerLabel.TextColor3 = Color3.new(1,1,1)
TimerLabel.Font = Enum.Font.GothamBold
TimerLabel.TextScaled = true
TimerLabel.TextXAlignment = Enum.TextXAlignment.Right
TimerLabel.Parent = DragBar

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 22, 1, 0)
MinBtn.Position = UDim2.new(1, -22, 0, 0)
MinBtn.BackgroundColor3 = Color3.fromRGB(160,40,40)
MinBtn.Text = "❌"
MinBtn.TextColor3 = Color3.new(1,1,1)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextScaled = true
MinBtn.Parent = Main
AddRainbowGlow(MinBtn,2)

local ESPBtn = Instance.new("TextButton")
ESPBtn.Size = UDim2.new(0, 85, 0, 30)
ESPBtn.Position = UDim2.new(0, 10, 0, 30)
ESPBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
ESPBtn.Text = "ESP: OFF"
ESPBtn.TextColor3 = Color3.new(1,1,1)
ESPBtn.Font = Enum.Font.GothamBold
ESPBtn.TextScaled = true
ESPBtn.Parent = Main
Instance.new("UICorner", ESPBtn).CornerRadius = UDim.new(0,6)
AddRainbowGlow(ESPBtn,2)

local YtBtn = Instance.new("TextButton")
YtBtn.Size = UDim2.new(0, 95, 0, 30)
YtBtn.Position = UDim2.new(0, 100, 0, 30)
YtBtn.BackgroundColor3 = Color3.fromRGB(200,30,30)
YtBtn.Text = "📺 YOUTUBE"
YtBtn.TextColor3 = Color3.new(1,1,1)
YtBtn.Font = Enum.Font.GothamBold
YtBtn.TextScaled = true
YtBtn.Parent = Main
Instance.new("UICorner", YtBtn).CornerRadius = UDim.new(0,6)
AddRainbowGlow(YtBtn,2)

local BoomBtn = Instance.new("TextButton")
BoomBtn.Size = UDim2.new(0, 90, 0, 30)
BoomBtn.Position = UDim2.new(0, 200, 0, 30)
BoomBtn.BackgroundColor3 = Color3.fromRGB(40,80,160)
BoomBtn.Text = "🎵 MUSIC"
BoomBtn.TextColor3 = Color3.new(1,1,1)
BoomBtn.Font = Enum.Font.GothamBold
BoomBtn.TextScaled = true
BoomBtn.Parent = Main
Instance.new("UICorner", BoomBtn).CornerRadius = UDim.new(0,6)
AddRainbowGlow(BoomBtn,2)

local LockBtn = Instance.new("TextButton")
LockBtn.Size = UDim2.new(0, 90, 0, 30)
LockBtn.Position = UDim2.new(0, 300, 0, 30)
LockBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
LockBtn.Text = "🔓 UNLOCKED"
LockBtn.TextColor3 = Color3.new(1,1,1)
LockBtn.Font = Enum.Font.GothamBold
LockBtn.TextScaled = true
LockBtn.Parent = Main
Instance.new("UICorner", LockBtn).CornerRadius = UDim.new(0,6)
AddRainbowGlow(LockBtn,2)

local ConsolBtn = Instance.new("TextButton")
ConsolBtn.Size = UDim2.new(0, 110, 0, 30)
ConsolBtn.Position = UDim2.new(0, 400, 0, 30)
ConsolBtn.BackgroundColor3 = Color3.fromRGB(30,120,90)
ConsolBtn.Text = "💻 CONSOL"
ConsolBtn.TextColor3 = Color3.new(1,1,1)
ConsolBtn.Font = Enum.Font.GothamBold
ConsolBtn.TextScaled = true
ConsolBtn.Parent = Main
Instance.new("UICorner", ConsolBtn).CornerRadius = UDim.new(0,6)
AddRainbowGlow(ConsolBtn,2)

local DelBtn = Instance.new("TextButton")
DelBtn.Size = UDim2.new(0, 90, 0, 30)
DelBtn.Position = UDim2.new(0, 520, 0, 30)
DelBtn.BackgroundColor3 = Color3.fromRGB(140,20,20)
DelBtn.Text = "🗑️ EXIT"
DelBtn.TextColor3 = Color3.new(1,1,1)
DelBtn.Font = Enum.Font.GothamBold
DelBtn.TextScaled = true
DelBtn.Parent = Main
Instance.new("UICorner", DelBtn).CornerRadius = UDim.new(0,6)
AddRainbowGlow(DelBtn,2)

local VolLabelMain = Instance.new("TextLabel")
VolLabelMain.Size = UDim2.new(0,70,0,25)
VolLabelMain.Position = UDim2.new(0,10,0,65)
VolLabelMain.BackgroundTransparency = 1
VolLabelMain.Text = "🔊 VOLUME:"
VolLabelMain.TextColor3 = Color3.new(1,1,1)
VolLabelMain.Font = Enum.Font.Gotham
VolLabelMain.TextScaled = true
VolLabelMain.TextXAlignment = Enum.TextXAlignment.Left
VolLabelMain.Parent = Main

VolNumTextMain = Instance.new("TextLabel")
VolNumTextMain.Size = UDim2.new(0,45,0,25)
VolNumTextMain.Position = UDim2.new(0,85,0,65)
VolNumTextMain.BackgroundTransparency = 1
VolNumTextMain.Text = math.floor(MusicVolume*100).."%"
VolNumTextMain.TextColor3 = Color3.new(1,1,1)
VolNumTextMain.Font = Enum.Font.GothamBold
VolNumTextMain.TextScaled = true
VolNumTextMain.TextXAlignment = Enum.TextXAlignment.Right
VolNumTextMain.Parent = Main

local VolBGMain = Instance.new("Frame")
VolBGMain.Size = UDim2.new(0,150,0,18)
VolBGMain.Position = UDim2.new(0,135,0,67)
VolBGMain.BackgroundColor3 = Color3.fromRGB(50,50,50)
VolBGMain.Parent = Main
Instance.new("UICorner", VolBGMain).CornerRadius = UDim.new(0,9)
AddRainbowGlow(VolBGMain,2)

VolFillMain = Instance.new("Frame")
VolFillMain.Size = UDim2.new(MusicVolume,0,1,0)
VolFillMain.BackgroundColor3 = Color3.fromRGB(100,100,100)
VolFillMain.Parent = VolBGMain
Instance.new("UICorner", VolFillMain).CornerRadius = UDim.new(0,9)

local VolSliderActive = false
VolBGMain.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then VolSliderActive = true end end)
UserInputService.InputEnded:Connect(function() VolSliderActive = false end)
UserInputService.InputChanged:Connect(function(i)
    if VolSliderActive then
        local rel = math.clamp((i.Position.X - VolBGMain.AbsolutePosition.X)/VolBGMain.AbsoluteSize.X,0,1)
        VolFillMain.Size = UDim2.new(rel,0,1,0)
        UpdateVolume(rel)
    end
end)

local ESP_Enabled = false
local Buttons_Locked = false
local Hue = 0
local IsSmall = false

local Drag = {Active=false, SX=0, SY=0, PX=0, PY=0}
local function StartDrag(input)
    if Buttons_Locked then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Drag.Active = true
        Drag.SX = input.Position.X
        Drag.SY = input.Position.Y
        Drag.PX = Main.Position.X.Offset
        Drag.PY = Main.Position.Y.Offset
    end
end
DragBar.InputBegan:Connect(StartDrag)
Main.InputBegan:Connect(StartDrag)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then Drag.Active = false end end)
UserInputService.InputChanged:Connect(function(i)
    if Drag.Active and not Buttons_Locked and i.UserInputType == Enum.UserInputType.MouseMovement then
        Main.Position = UDim2.new(0, Drag.PX + (i.Position.X - Drag.SX), 0, Drag.PY + (i.Position.Y - Drag.SY))
    end
end)

ESPBtn.MouseButton1Click:Connect(function()
    ESP_Enabled = not ESP_Enabled
    ESPBtn.Text = ESP_Enabled and "ESP: ON" or "ESP: OFF"
    ESPBtn.BackgroundColor3 = ESP_Enabled and Color3.fromRGB(25,120,25) or Color3.fromRGB(40,40,40)
    if not ESP_Enabled then ClearESP() end
end)

YtBtn.MouseButton1Click:Connect(function()
    if setclipboard then setclipboard(YOUTUBE_LINK) end
    YtBtn.Text = "✅ COPIED!"
    task.wait(1.5)
    YtBtn.Text = "📺 YOUTUBE"
end)

BoomBtn.MouseButton1Click:Connect(OpenBoomboxMenu)
ConsolBtn.MouseButton1Click:Connect(OpenConsol)

LockBtn.MouseButton1Click:Connect(function()
    Buttons_Locked = not Buttons_Locked
    LockBtn.Text = Buttons_Locked and "🔒 LOCKED" or "🔓 UNLOCKED"
    LockBtn.BackgroundColor3 = Buttons_Locked and Color3.fromRGB(180,40,40) or Color3.fromRGB(50,50,50)
end)

MinBtn.MouseButton1Click:Connect(function()
    IsSmall = not IsSmall
    if IsSmall then
        Main.Size = MIN_SIZE
        DragBar.Visible = false
        ESPBtn.Visible = false
        YtBtn.Visible = false
        BoomBtn.Visible = false
        LockBtn.Visible = false
        ConsolBtn.Visible = false
        DelBtn.Visible = false
        VolLabelMain.Visible = false
        VolNumTextMain.Visible = false
        VolBGMain.Visible = false
        MinBtn.Text = "➕"
    else
        Main.Size = MAIN_SIZE
        DragBar.Visible = true
        ESPBtn.Visible = true
        YtBtn.Visible = true
        BoomBtn.Visible = true
        LockBtn.Visible = true
        ConsolBtn.Visible = true
        DelBtn.Visible = true
        VolLabelMain.Visible = true
        VolNumTextMain.Visible = true
        VolBGMain.Visible = true
        MinBtn.Text = "❌"
    end
end)

DelBtn.MouseButton1Click:Connect(function()
    ClearESP()
    pcall(function() if CurrentSound then CurrentSound:Destroy() end end)
    UI:Destroy()
    getgenv().BlueMode_Loaded = nil
end)

RunService.Heartbeat:Connect(function(delta)
    if not UI or not UI.Parent then return end

    local Now = os.time()
    UsedTime = UsedTime + math.max(0, Now - LastCheck)
    LastCheck = Now
    SaveData(SAVE_KEY_USED, UsedTime)
    local h = math.floor(UsedTime/3600)
    local m = math.floor((UsedTime%3600)/60)
    local s = math.floor(UsedTime%60)
    TimerLabel.Text = string.format("%02d:%02d:%02d / 12:00:00", h, m, s)

    if UsedTime >= USAGE_LIMIT then
        SaveData(SAVE_KEY_COOLDOWN, os.time() + COOLDOWN)
        pcall(function() delfile(SAVE_KEY_USED..".txt") end)
        DelBtn:Fire()
        return
    end

    Hue = (Hue + delta * 0.5) % 1
    local GlowColor = Color3.fromHSV(Hue, 1, 1)
    for _, s in pairs(GuiElements) do s.Color = GlowColor end
    if VolFillMain then VolFillMain.BackgroundColor3 = GlowColor end
    if VolFillMenu then VolFillMenu.BackgroundColor3 = GlowColor end
    if BoomFrame then BoomFrame.BorderColor3 = GlowColor end

    if not ESP_Enabled then return end
    for _, Plr in pairs(Players:GetPlayers()) do
        if Plr == LocalPlayer then continue end
        local Char = Plr.Character
        if not Char then continue end
        local Hum = Char:FindFirstChildOfClass("Humanoid")
        if not Hum or Hum.Health <= 0 then
            pcall(function() if Char:FindFirstChild("BLUE_Outline") then Char.BLUE_Outline:Destroy() end end)
            pcall(function() if Char:FindFirstChild("FriendRainbowDot") then Char.FriendRainbowDot:Destroy() end end)
            continue
        end
        local Outline = Char:FindFirstChild("BLUE_Outline") or Instance.new("Highlight", Char)
        Outline.Name = "BLUE_Outline"
        Outline.FillTransparency = 1
        Outline.OutlineTransparency = 0
        Outline.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        Outline.Adornee = Char
        Outline.OutlineColor = GlowColor

        local IsFriend = false
        pcall(function() IsFriend = LocalPlayer:IsFriendsWith(Plr.UserId) end)
        local Head = Char:FindFirstChild("Head")
        local Dot = Char:FindFirstChild("FriendRainbowDot")
        if IsFriend and Head then
            if not Dot then
                Dot = Instance.new("BillboardGui", Head)
                Dot.Name = "FriendRainbowDot"
                Dot.AlwaysOnTop = true
                Dot.Size = UDim2.new(0,18,0,18)
                Dot.StudsOffset = Vector3.new(0,1.8,0)
                local Circle = Instance.new("Frame", Dot)
                Circle.Size = UDim2.new(1,0,1,0)
                Circle.BackgroundColor3 = GlowColor
                Instance.new("UICorner", Circle).CornerRadius = UDim.new(1,0)
            else
                Dot.Frame.BackgroundColor3 = GlowColor
            end
        elseif Dot then Dot:Destroy() end
    end
end)

print("✅ BLUE MODE ESP LOADED SUCCESSFULLY!")
