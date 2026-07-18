-- ==============================================
-- BLUE MODE ESP | ULTRA TINY MINIMIZED CUBE
-- ✅ Smallest Clean Size | Timer + + Only
-- ✅ No Blocking | Rainbow Timer
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
local SAVE_KEY_USED = "BlueMode_UsedTime_v16"
local SAVE_KEY_COOLDOWN = "BlueMode_CooldownEnd_v16"
local SAVE_KEY_VOLUME = "BlueMode_Volume_v16"

-- DATA HELPERS
local function SaveData(key, value) pcall(function() writefile(key..".txt", tostring(value)) end) end
local function LoadData(key, default) local v=nil; pcall(function() v=readfile(key..".txt") end); return tonumber(v) or default end

-- CLEANUP ESP
local function ClearAllESP()
    for _,P in pairs(Players:GetPlayers()) do
        if P and P.Character then
            pcall(function()
                if P.Character:FindFirstChild("BLUE_Outline") then P.Character.BLUE_Outline:Destroy() end
                if P.Character:FindFirstChild("FriendRainbowDot") then P.Character.FriendRainbowDot:Destroy() end
            end)
        end
    end
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
local IsMinimized = false

-- AUTO OFF ESP WHEN YOU DIE
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
                print("⚠️ YOU DIED! ESP TURNED OFF AUTOMATICALLY")
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
    return Outline
end

-- ERROR POPUP
local function ShowErrorPopup(Message)
    local Popup = Instance.new("ScreenGui")
    Popup.Name = "BLUE_ERROR_POPUP"
    Popup.ResetOnSpawn = false
    Popup.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    Popup.Parent = PlayerGui

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 400, 0, 200)
    Frame.Position = UDim2.new(0.5, -200, 0.5, -100)
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
    ErrorText.TextYAlignment = Enum.TextYAlignment.Top
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
    MusicVolume = math.clamp(newVol, 0, 1)
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
local function OpenBoomboxMenu()
    local BoomUI = Instance.new("ScreenGui")
    BoomUI.Name = "BLUE_BOOMBOX_MENU"
    BoomUI.ResetOnSpawn = false
    BoomUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    BoomUI.Parent = PlayerGui

    local BoomFrame = Instance.new("Frame")
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
    VolNumMenu.Text = math.floor(MusicVolume*100+0.5).."%"
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
    VolBG.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then SliderActive = true end end)
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
    PlayBtn.MouseButton1Click:Connect(function() if Input.Text~="" then PlaySound(Input.Text) end end)
    StopBtn.MouseButton1Click:Connect(function() if CurrentSound then CurrentSound:Destroy() end end)
    CloseTop.MouseButton1Click:Connect(CloseMenu)
end

-- CONSOLE
local function OpenConsole()
    local ConsoleUI = Instance.new("ScreenGui")
    ConsoleUI.Name = "BLUE_CONSOLE"
    ConsoleUI.ResetOnSpawn = false
    ConsoleUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ConsoleUI.Parent = PlayerGui

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0,450,0,320)
    Frame.Position = UDim2.new(0.5,-225,0.5,-160)
    Frame.BackgroundColor3 = Color3.fromRGB(22,22,22)
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

    local function CloseConsole() ConsoleUI:Destroy() end

    ExecBtn.MouseButton1Click:Connect(function()
        local ScriptCode = Input.Text
        if ScriptCode == "" then Output.Text = "⚠️ Nothing to run!" return end
        local Compile = loadstring or load
        if not Compile then ShowErrorPopup("Executor does not support compiling.") return end
        local Func, Err = Compile(ScriptCode)
        if not Func then ShowErrorPopup("Syntax Error:\n"..tostring(Err)) return end
        local Ok, RunErr = pcall(Func)
        if not Ok then ShowErrorPopup("Runtime Error:\n"..tostring(RunErr)) return end
        Output.Text = "✅ Script ran successfully!"
    end)

    ClearBtn.MouseButton1Click:Connect(function() Input.Text = "" Output.Text = "✅ Cleared!" end)
    CloseTop.MouseButton1Click:Connect(CloseConsole)
end

-- MAIN UI SIZES
local FULL_SIZE = UDim2.new(0,680,0,105)
local MINI_SIZE = UDim2.new(0,110,0,36) -- ✅ ULTRA TINY CUBE
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

-- DRAG BAR + TIMER ON RIGHT (NO BLOCKING)
local DragHandle = Instance.new("TextButton")
DragHandle.Size = UDim2.new(1,-25,0,22)
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
TimerLabel.Size = UDim2.new(0,130,1,0)
TimerLabel.Position = UDim2.new(1,-135,0,0)
TimerLabel.BackgroundTransparency = 1
TimerLabel.Text = "00:00:00 / 12:00"
TimerLabel.TextColor3 = Color3.new(1,1,1)
TimerLabel.Font = Enum.Font.GothamBold
TimerLabel.TextScaled = true
TimerLabel.TextXAlignment = Enum.TextXAlignment.Right
TimerLabel.Parent = DragHandle

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0,22,1,0) -- ✅ SMALL + BUTTON
MinBtn.Position = UDim2.new(1,-22,0,0)
MinBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
MinBtn.Text = "➖"
MinBtn.TextColor3 = Color3.new(1,1,1)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextScaled = true
MinBtn.Parent = MainFrame
AddRainbowGlow(MinBtn,2)

-- BUTTONS
local ESPBtn = Instance.new("TextButton")
ESPBtn.Size = UDim2.new(0,85,0,30)
ESPBtn.Position = UDim2.new(0,10,0,30)
ESPBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
ESPBtn.Text = "ESP: OFF"
ESPBtn.TextColor3 = Color3.new(1,1,1)
ESPBtn.Font = Enum.Font.GothamBold
ESPBtn.TextScaled = true
ESPBtn.Parent = MainFrame
Instance.new("UICorner", ESPBtn).CornerRadius = UDim.new(0,6)
AddRainbowGlow(ESPBtn,2)

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

-- VOLUME SLIDER
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
VolBGMain.Parent = MainFrame
Instance.new("UICorner", VolBGMain).CornerRadius = UDim.new(0,9)
AddRainbowGlow(VolBGMain,2)

VolFillMain = Instance.new("Frame")
VolFillMain.Size = UDim2.new(MusicVolume,0,1,0)
VolFillMain.BackgroundColor3 = Color3.fromRGB(100,100,100)
VolFillMain.Parent = VolBGMain
Instance.new("UICorner", VolFillMain).CornerRadius = UDim.new(0,9)

local SliderActiveMain = false
VolBGMain.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then SliderActiveMain = true end end)
UserInputService.InputEnded:Connect(function() SliderActiveMain = false end)
UserInputService.InputChanged:Connect(function(i)
    if SliderActiveMain then
        local rel = math.clamp((i.Position.X - VolBGMain.AbsolutePosition.X)/VolBGMain.AbsoluteSize.X,0,1)
        VolFillMain.Size = UDim2.new(rel,0,1,0)
        UpdateVolume(rel)
    end
end)

-- DRAG SYSTEM
local DragState = {Active=false, StartX=0, StartY=0, PosX=0, PosY=0}
DragHandle.InputBegan:Connect(function(Input)
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
    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then DragState.Active = false end
end)
UserInputService.InputChanged:Connect(function(Input)
    if DragState.Active and not Buttons_Locked then
        MainFrame.Position = UDim2.new(0, DragState.PosX + (Input.Position.X - DragState.StartX), 0, DragState.PosY + (Input.Position.Y - DragState.StartY))
    end
end)

-- LOCK/UNLOCK
LockBtn.MouseButton1Click:Connect(function()
    Buttons_Locked = not Buttons_Locked
    if Buttons_Locked then
        LockBtn.Text = "🔒 LOCKED"
        LockBtn.BackgroundColor3 = Color3.fromRGB(180,40,40)
    else
        LockBtn.Text = "🔓 UNLOCK"
        LockBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    end
end)

-- ✅ MINIMIZE: ULTRA CLEAN TINY CUBE
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
        DragHandle.Text = "" -- NO NAME TEXT
        MinBtn.Text = "➕" -- SMALL PLUS
        TimerLabel.Size = UDim2.new(1,-28,1,0)
        TimerLabel.Position = UDim2.new(0,4,0,0)
        TimerLabel.TextXAlignment = Enum.TextXAlignment.Center
        TimerLabel.TextScaled = false
        TimerLabel.TextSize = 12 -- ✅ VERY SMALL TIMER FONT
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
        TimerLabel.Size = UDim2.new(0,130,1,0)
        TimerLabel.Position = UDim2.new(1,-135,0,0)
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

MusicBtn.MouseButton1Click:Connect(OpenBoomboxMenu)
ConsoleBtn.MouseButton1Click:Connect(OpenConsole)

-- EXIT
ExitBtn.MouseButton1Click:Connect(function()
    ClearAllESP()
    pcall(function() if CurrentSound then CurrentSound:Destroy() end end)
    MainUI:Destroy()
    getgenv().BlueMode_Loaded = nil
end)

-- START DEATH CHECK
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

    -- RAINBOW FOR ALL ELEMENTS INCLUDING TIMER
    Hue = (Hue + Delta*0.5) % 1
    local Rainbow = Color3.fromHSV(Hue,1,1)
    for _,e in pairs(GuiElements) do e.Color = Rainbow end
    if VolFillMain then VolFillMain.BackgroundColor3 = Rainbow end
    if VolFillMenu then VolFillMenu.BackgroundColor3 = Rainbow end
    TimerLabel.TextColor3 = Rainbow

    -- ESP
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

        -- OUTLINE
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

print("✅ READY: Ultra Tiny Cube | Timer + + Only | Clear View")
