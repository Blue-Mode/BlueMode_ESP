-- ==============================================
-- BLUE MODE ESP | VERSION: 1.6 | GITHUB RELEASE
-- ACCESS CODE: Blue_Mode192823
-- WRONG CODE = DISABLED FOR 12 HOURS
-- COMPATIBLE: ALL EXECUTORS (Delta, Pydroid3, Arceus, etc.)
-- ==============================================

if getgenv().BlueMode_Loaded then return end
getgenv().BlueMode_Loaded = true

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- PARENT SETTING (MAXIMUM EXECUTOR COMPATIBILITY)
local PlayerGui = CoreGui

-- FALLBACKS
local task_wait = task and task.wait or wait
local make_instance = Instance.new

-- CONFIGURATION
local CONFIG = {
    ACCESS_CODE = "Blue_Mode192823",
    USAGE_DURATION = 12 * 3600, -- 12 HOURS
    LOCKOUT_DURATION = 12 * 3600, -- 12 HOUR LOCKOUT
    YOUTUBE_LINK = "https://youtube.com/@blue_mode?si=aCGyj0FnwCMtTP1M",
    SAVE_KEY_USED = "BlueMode_UsedTime_v16",
    SAVE_KEY_LOCKOUT = "BlueMode_Lockout_v16",
    SAVE_KEY_VOLUME = "BlueMode_Volume_v16"
}

-- DATA HELPERS
local function SaveData(key, value)
    pcall(function() if writefile then writefile(key..".txt", tostring(value)) end end)
end
local function LoadData(key, default)
    local val = nil
    pcall(function() if readfile then val = readfile(key..".txt") end end)
    return tonumber(val) or default
end

-- FULL CLEANUP
local MainLoop, CurrentSound
local function FullCleanup()
    if MainLoop then MainLoop:Disconnect() end
    pcall(function() if CurrentSound then CurrentSound:Destroy() end end)
    for _, Player in pairs(Players:GetPlayers()) do
        if Player and Player.Character then pcall(function()
            if Player.Character:FindFirstChild("BLUE_Outline") then Player.Character.BLUE_Outline:Destroy() end
            if Player.Character:FindFirstChild("FriendRainbowDot") then Player.Character.FriendRainbowDot:Destroy() end
        end) end
    end
    for _, Gui in pairs(PlayerGui:GetChildren()) do if Gui.Name:sub(1,5) == "BLUE_" then Gui:Destroy() end end
    getgenv().BlueMode_Loaded = nil
end

-- CODE PROMPT
local function ShowCodePrompt()
    local PromptUI = make_instance("ScreenGui")
    PromptUI.Name = "BLUE_CODE_PROMPT"
    PromptUI.ResetOnSpawn = false
    PromptUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    PromptUI.DisplayOrder = 999999
    PromptUI.Parent = PlayerGui

    local PromptFrame = make_instance("Frame")
    PromptFrame.Size = UDim2.new(0, 350, 0, 220)
    PromptFrame.Position = UDim2.new(0.5, -175, 0.5, -110)
    PromptFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
    PromptFrame.Parent = PromptUI
    make_instance("UICorner", PromptFrame).CornerRadius = UDim.new(0,12)

    local Title = make_instance("TextLabel")
    Title.Size = UDim2.new(1, -20, 0, 40)
    Title.Position = UDim2.new(0,10,0,10)
    Title.BackgroundTransparency = 1
    Title.Text = "⏳ TIME EXPIRED | ENTER CODE"
    Title.TextColor3 = Color3.fromRGB(255,80,80)
    Title.Font = Enum.Font.GothamBold
    Title.TextScaled = true
    Title.Parent = PromptFrame

    local CodeInput = make_instance("TextBox")
    CodeInput.Size = UDim2.new(1, -40, 0, 45)
    CodeInput.Position = UDim2.new(0,20,0,60)
    CodeInput.BackgroundColor3 = Color3.fromRGB(35,35,35)
    CodeInput.PlaceholderText = "Enter access code..."
    CodeInput.TextColor3 = Color3.new(1,1,1)
    CodeInput.Font = Enum.Font.Gotham
    CodeInput.TextScaled = true
    CodeInput.Password = true
    CodeInput.Parent = PromptFrame
    make_instance("UICorner", CodeInput).CornerRadius = UDim.new(0,8)

    local Status = make_instance("TextLabel")
    Status.Size = UDim2.new(1, -20, 0, 25)
    Status.Position = UDim2.new(0,10,0,115)
    Status.BackgroundTransparency = 1
    Status.Text = ""
    Status.TextColor3 = Color3.new(1,1,1)
    Status.Font = Enum.Font.Gotham
    Status.TextScaled = true
    Status.Parent = PromptFrame

    local SubmitBtn = make_instance("TextButton")
    SubmitBtn.Size = UDim2.new(0,140,0,40)
    SubmitBtn.Position = UDim2.new(0,35,0,150)
    SubmitBtn.BackgroundColor3 = Color3.fromRGB(30,140,210)
    SubmitBtn.Text = "✅ SUBMIT CODE"
    SubmitBtn.TextColor3 = Color3.new(1,1,1)
    SubmitBtn.Font = Enum.Font.GothamBold
    SubmitBtn.TextScaled = true
    SubmitBtn.Parent = PromptFrame
    make_instance("UICorner", SubmitBtn).CornerRadius = UDim.new(0,8)

    local ExitBtn = make_instance("TextButton")
    ExitBtn.Size = UDim2.new(0,140,0,40)
    ExitBtn.Position = UDim2.new(0,175,0,150)
    ExitBtn.BackgroundColor3 = Color3.fromRGB(160,30,30)
    ExitBtn.Text = "❌ EXIT"
    ExitBtn.TextColor3 = Color3.new(1,1,1)
    ExitBtn.Font = Enum.Font.GothamBold
    ExitBtn.TextScaled = true
    ExitBtn.Parent = PromptFrame
    make_instance("UICorner", ExitBtn).CornerRadius = UDim.new(0,8)

    local Valid = false
    SubmitBtn.MouseButton1Click:Connect(function()
        if CodeInput.Text == CONFIG.ACCESS_CODE then
            Status.Text = "✅ CORRECT CODE! LOADING..."
            Status.TextColor3 = Color3.fromRGB(0,255,100)
            Valid = true
            SaveData(CONFIG.SAVE_KEY_USED, 0)
            SaveData(CONFIG.SAVE_KEY_LOCKOUT, 0)
            task_wait(1.5)
            PromptUI:Destroy()
        else
            Status.Text = "❌ WRONG CODE! DISABLED 12H"
            Status.TextColor3 = Color3.fromRGB(255,50,50)
            SaveData(CONFIG.SAVE_KEY_LOCKOUT, os.time() + CONFIG.LOCKOUT_DURATION)
            task_wait(2)
            PromptUI:Destroy()
            FullCleanup()
        end
    end)

    ExitBtn.MouseButton1Click:Connect(function()
        PromptUI:Destroy()
        FullCleanup()
    end)

    repeat task_wait(0.1) until not PromptUI.Parent or Valid
    return Valid
end

-- LOCKOUT CHECK
local CurrentTime = os.time()
local LockoutEnd = LoadData(CONFIG.SAVE_KEY_LOCKOUT, 0)
if CurrentTime < LockoutEnd then
    print(string.format("[BlueMode] LOCKED: Returns in %dh %dm",
        math.floor((LockoutEnd-CurrentTime)/3600),
        math.floor(((LockoutEnd-CurrentTime)%3600)/60)))
    return
end

-- USAGE TIMER CHECK
local UsedTime = LoadData(CONFIG.SAVE_KEY_USED, 0)
if UsedTime >= CONFIG.USAGE_DURATION then
    if not ShowCodePrompt() then return end
    UsedTime = 0
end

-- GLOBAL VARIABLES
local LastCheck = os.time()
local MusicVol = LoadData(CONFIG.SAVE_KEY_VOLUME, 0.5)
local VolNumMain, VolFillMain, VolNumMenu, VolFillMenu, TimerLabel
local GuiElements = {}
local ESP_Active = false
local Locked = false
local Hue = 0
local Minimized = false
local MainUI, MainFrame

-- RAINBOW EFFECT
local function AddRainbow(target, thickness)
    if not target then return end
    local Stroke = make_instance("UIStroke")
    Stroke.Name = "RainbowAura"
    Stroke.Thickness = thickness or 3
    Stroke.Transparency = 0
    Stroke.LineJoinMode = Enum.LineJoinMode.Round
    Stroke.Parent = target
    table.insert(GuiElements, Stroke)
end

-- VOLUME CONTROL
local function UpdateVol(new)
    MusicVol = math.clamp(new, 0, 1)
    SaveData(CONFIG.SAVE_KEY_VOLUME, MusicVol)
    if CurrentSound then CurrentSound.Volume = MusicVol end
    local Percent = math.floor(MusicVol*100+0.5).."%"
    if VolNumMain then VolNumMain.Text = Percent end
    if VolFillMain then VolFillMain.Size = UDim2.new(MusicVol,0,1,0) end
    if VolNumMenu then VolNumMenu.Text = Percent end
    if VolFillMenu then VolFillMenu.Size = UDim2.new(MusicVol,0,1,0) end
end

-- SOUND PLAYER
local function PlaySound(id)
    pcall(function() if CurrentSound then CurrentSound:Destroy() end end)
    CurrentSound = make_instance("Sound")
    CurrentSound.SoundId = "rbxassetid://"..tostring(id):gsub("%D","")
    CurrentSound.Volume = MusicVol
    CurrentSound.Looped = true
    CurrentSound.Parent = SoundService
    pcall(function() CurrentSound:Play() end)
end

-- BOOMBOX MENU
local function OpenBoombox()
    local BoomUI = make_instance("ScreenGui")
    BoomUI.Name = "BLUE_BOOMBOX"
    BoomUI.ResetOnSpawn = false
    BoomUI.DisplayOrder = 999998
    BoomUI.Parent = PlayerGui

    local Frame = make_instance("Frame")
    Frame.Size = UDim2.new(0,320,0,250)
    Frame.Position = UDim2.new(0.5,-160,0.5,-125)
    Frame.BackgroundColor3 = Color3.fromRGB(22,22,22)
    Frame.Parent = BoomUI
    make_instance("UICorner", Frame).CornerRadius = UDim.new(0,12)
    AddRainbow(Frame,4)

    local Close = make_instance("TextButton")
    Close.Size = UDim2.new(0,30,0,30)
    Close.Position = UDim2.new(1,-35,0,5)
    Close.BackgroundColor3 = Color3.fromRGB(170,30,30)
    Close.Text = "✕"
    Close.TextColor3 = Color3.new(1,1,1)
    Close.Font = Enum.Font.GothamBold
    Close.TextSize = 24
    Close.Parent = Frame

    local Title = make_instance("TextLabel")
    Title.Size = UDim2.new(1,-40,0,40)
    Title.Position = UDim2.new(0,15,0,8)
    Title.BackgroundTransparency = 1
    Title.Text = "🎵 BOOMBOX"
    Title.TextColor3 = Color3.new(1,1,1)
    Title.Font = Enum.Font.GothamBold
    Title.TextScaled = true
    Title.Parent = Frame

    local Input = make_instance("TextBox")
    Input.Size = UDim2.new(1,-40,0,45)
    Input.Position = UDim2.new(0,20,0,55)
    Input.BackgroundColor3 = Color3.fromRGB(35,35,35)
    Input.PlaceholderText = "Sound ID..."
    Input.TextColor3 = Color3.new(1,1,1)
    Input.Font = Enum.Font.Gotham
    Input.TextScaled = true
    Input.Parent = Frame
    make_instance("UICorner", Input).CornerRadius = UDim.new(0,8)
    AddRainbow(Input,2)

    VolNumMenu = make_instance("TextLabel")
    VolNumMenu.Size = UDim2.new(0,80,0,30)
    VolNumMenu.Position = UDim2.new(1,-100,0,110)
    VolNumMenu.BackgroundTransparency = 1
    VolNumMenu.Text = math.floor(MusicVol*100+0.5).."%"
    VolNumMenu.TextColor3 = Color3.new(1,1,1)
    VolNumMenu.Font = Enum.Font.GothamBold
    VolNumMenu.TextScaled = true
    VolNumMenu.Parent = Frame

    local VolBG = make_instance("Frame")
    VolBG.Size = UDim2.new(1,-40,0,24)
    VolBG.Position = UDim2.new(0,20,0,145)
    VolBG.BackgroundColor3 = Color3.fromRGB(50,50,50)
    VolBG.Parent = Frame
    make_instance("UICorner", VolBG).CornerRadius = UDim.new(0,12)
    AddRainbow(VolBG,2)

    VolFillMenu = make_instance("Frame")
    VolFillMenu.Size = UDim2.new(MusicVol,0,1,0)
    VolFillMenu.BackgroundColor3 = Color3.fromRGB(60,140,220)
    VolFillMenu.Parent = VolBG
    make_instance("UICorner", VolFillMenu).CornerRadius = UDim.new(0,12)

    local SliderActive = false
    VolBG.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then SliderActive = true end end)
    UserInputService.InputEnded:Connect(function() SliderActive = false end)
    UserInputService.InputChanged:Connect(function(i)
        if SliderActive then UpdateVol(math.clamp((i.Position.X - VolBG.AbsolutePosition.X)/VolBG.AbsoluteSize.X, 0, 1)) end
    end)

    local Play = make_instance("TextButton")
    Play.Size = UDim2.new(0,130,0,40)
    Play.Position = UDim2.new(0,20,0,190)
    Play.BackgroundColor3 = Color3.fromRGB(25,140,255)
    Play.Text = "▶ PLAY"
    Play.TextColor3 = Color3.new(1,1,1)
    Play.Font = Enum.Font.GothamBold
    Play.TextScaled = true
    Play.Parent = Frame
    make_instance("UICorner", Play).CornerRadius = UDim.new(0,8)
    AddRainbow(Play,2)

    local Stop = make_instance("TextButton")
    Stop.Size = UDim2.new(0,130,0,40)
    Stop.Position = UDim2.new(0,170,0,190)
    Stop.BackgroundColor3 = Color3.fromRGB(200,30,30)
    Stop.Text = "⏹ STOP"
    Stop.TextColor3 = Color3.new(1,1,1)
    Stop.Font = Enum.Font.GothamBold
    Stop.TextScaled = true
    Stop.Parent = Frame
    make_instance("UICorner", Stop).CornerRadius = UDim.new(0,8)
    AddRainbow(Stop,2)

    Play.MouseButton1Click:Connect(function() if Input.Text ~= "" then PlaySound(Input.Text) end end)
    Stop.MouseButton1Click:Connect(function() pcall(function() if CurrentSound then CurrentSound:Destroy() end) end)
    Close.MouseButton1Click:Connect(function() BoomUI:Destroy() end)
end

-- SCRIPT CONSOLE
local function OpenConsole()
    local ConUI = make_instance("ScreenGui")
    ConUI.Name = "BLUE_CONSOLE"
    ConUI.ResetOnSpawn = false
    ConUI.DisplayOrder = 999997
    ConUI.Parent = PlayerGui

    local Frame = make_instance("Frame")
    Frame.Size = UDim2.new(0,450,0,320)
    Frame.Position = UDim2.new(0.5,-225,0.5,-160)
    Frame.BackgroundColor3 = Color3.fromRGB(22,22,22)
    Frame.Parent = ConUI
    make_instance("UICorner", Frame).CornerRadius = UDim.new(0,12)
    AddRainbow(Frame,5)

    local Close = make_instance("TextButton")
    Close.Size = UDim2.new(0,32,0,32)
    Close.Position = UDim2.new(1,-37,0,6)
    Close.BackgroundColor3 = Color3.fromRGB(170,30,30)
    Close.Text = "✕"
    Close.TextColor3 = Color3.new(1,1,1)
    Close.Font = Enum.Font.GothamBold
    Close.TextSize = 26
    Close.Parent = Frame

    local Title = make_instance("TextLabel")
    Title.Size = UDim2.new(1,-50,0,35)
    Title.Position = UDim2.new(0,15,0,6)
    Title.BackgroundTransparency = 1
    Title.Text = "💻 CONSOLE"
    Title.TextColor3 = Color3.new(1,1,1)
    Title.Font = Enum.Font.GothamBold
    Title.TextScaled = true
    Title.Parent = Frame

    local Output = make_instance("TextLabel")
    Output.Size = UDim2.new(1,-30,0,50)
    Output.Position = UDim2.new(0,15,0,45)
    Output.BackgroundColor3 = Color3.fromRGB(35,35,35)
    Output.Text = "Paste code here"
    Output.TextColor3 = Color3.fromRGB(0,255,120)
    Output.Font = Enum.Font.Code
    Output.TextScaled = true
    Output.Parent = Frame
    make_instance("UICorner", Output).CornerRadius = UDim.new(0,8)

    local Input = make_instance("TextBox")
    Input.Size = UDim2.new(1,-30,0,120)
    Input.Position = UDim2.new(0,15,0,105)
    Input.BackgroundColor3 = Color3.fromRGB(45,45,45)
    Input.PlaceholderText = "Script code..."
    Input.TextColor3 = Color3.new(1,1,1)
    Input.Font = Enum.Font.Code
    Input.TextScaled = true
    Input.MultiLine = true
    Input.Parent = Frame
    make_instance("UICorner", Input).CornerRadius = UDim.new(0,8)
    AddRainbow(Input,2)

    local Exec = make_instance("TextButton")
    Exec.Size = UDim2.new(0,120,0,40)
    Exec.Position = UDim2.new(0,15,0,240)
    Exec.BackgroundColor3 = Color3.fromRGB(20,150,70)
    Exec.Text = "▶ RUN"
    Exec.TextColor3 = Color3.new(1,1,1)
    Exec.Font = Enum.Font.GothamBold
    Exec.TextScaled = true
    Exec.Parent = Frame
    make_instance("UICorner", Exec).CornerRadius = UDim.new(0,8)

    local Clear = make_instance("TextButton")
    Clear.Size = UDim2.new(0,120,0,40)
    Clear.Position = UDim2.new(0,150,0,240)
    Clear.BackgroundColor3 = Color3.fromRGB(180,120,20)
    Clear.Text = "🗑️ CLEAR"
    Clear.TextColor3 = Color3.new(1,1,1)
    Clear.Font = Enum.Font.GothamBold
    Clear.TextScaled = true
    Clear.Parent = Frame
    make_instance("UICorner", Clear).CornerRadius = UDim.new(0,8)

    Exec.MouseButton1Click:Connect(function()
        if Input.Text == "" then Output.Text = "⚠️ Empty input!" return end
        local Compile = loadstring or load
        local Func, Err = Compile(Input.Text)
        if not Func then Output.Text = "❌ ERROR: "..tostring(Err) return end
        local Ok, RunErr = pcall(Func)
        Output.Text = Ok and "✅ EXECUTED" or "❌ ERROR: "..tostring(RunErr)
    end)
    Clear.MouseButton1Click:Connect(function() Input.Text = "" Output.Text = "✅ CLEARED" end)
    Close.MouseButton1Click:Connect(function() ConUI:Destroy() end)
end

-- MAIN UI CREATION
print("[BlueMode] Loading Interface...")
MainUI = make_instance("ScreenGui")
MainUI.Name = "BLUE_MODE_ESP"
MainUI.ResetOnSpawn = false
MainUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
MainUI.DisplayOrder = 999999
MainUI.Parent = PlayerGui

local FULL = UDim2.new(0,680,0,105)
local MIN = UDim2.new(0,50,0,50)
MainFrame = make_instance("Frame")
MainFrame.Size = FULL
MainFrame.Position = UDim2.new(0,20,0.5,-52)
MainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
MainFrame.Active = true
MainFrame.ClipsDescendants = false
MainFrame.Parent = MainUI
make_instance("UICorner", MainFrame).CornerRadius = UDim.new(0,8)
AddRainbow(MainFrame,5)

local DragBar = make_instance("TextButton")
DragBar.Size = UDim2.new(1,-25,0,22)
DragBar.BackgroundColor3 = Color3.fromRGB(60,140,220)
DragBar.Active = true
DragBar.Text = "made by BLUE_MODE | DRAG HERE"
DragBar.TextColor3 = Color3.new(1,1,1)
DragBar.Font = Enum.Font.GothamBold
DragBar.TextScaled = true
DragBar.TextXAlignment = Enum.TextXAlignment.Left
DragBar.Parent = MainFrame
AddRainbow(DragBar,2)

TimerLabel = make_instance("TextLabel")
TimerLabel.Size = UDim2.new(0,100,1,0)
TimerLabel.Position = UDim2.new(1,-105,0,0)
TimerLabel.BackgroundTransparency = 1
TimerLabel.Text = string.format("%02d:%02d:%02d / 12:00:00",
    math.floor(UsedTime/3600), math.floor((UsedTime%3600)/60), math.floor(UsedTime%60))
TimerLabel.TextColor3 = Color3.new(1,1,1)
TimerLabel.Font = Enum.Font.GothamBold
TimerLabel.TextScaled = true
TimerLabel.TextXAlignment = Enum.TextXAlignment.Right
TimerLabel.Parent = DragBar

local MinBtn = make_instance("TextButton")
MinBtn.Size = UDim2.new(0,22,1,0)
MinBtn.Position = UDim2.new(1,-22,0,0)
MinBtn.BackgroundColor3 = Color3.fromRGB(160,40,40)
MinBtn.Text = "❌"
MinBtn.TextColor3 = Color3.new(1,1,1)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextScaled = true
MinBtn.Parent = MainFrame
AddRainbow(MinBtn,2)

local ESPBtn = make_instance("TextButton")
ESPBtn.Size = UDim2.new(0,85,0,30)
ESPBtn.Position = UDim2.new(0,10,0,30)
ESPBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
ESPBtn.Text = "ESP: OFF"
ESPBtn.TextColor3 = Color3.new(1,1,1)
ESPBtn.Font = Enum.Font.GothamBold
ESPBtn.TextScaled = true
ESPBtn.Parent = MainFrame
make_instance("UICorner", ESPBtn).CornerRadius = UDim.new(0,6)
AddRainbow(ESPBtn,2)

local YtBtn = make_instance("TextButton")
YtBtn.Size = UDim2.new(0,95,0,30)
YtBtn.Position = UDim2.new(0,100,0,30)
YtBtn.BackgroundColor3 = Color3.fromRGB(200,30,30)
YtBtn.Text = "📺 YOUTUBE"
YtBtn.TextColor3 = Color3.new(1,1,1)
YtBtn.Font = Enum.Font.GothamBold
YtBtn.TextScaled = true
YtBtn.Parent = MainFrame
make_instance("UICorner", YtBtn).CornerRadius = UDim.new(0,6)
AddRainbow(YtBtn,2)

local MusicBtn = make_instance("TextButton")
MusicBtn.Size = UDim2.new(0,90,0,30)
MusicBtn.Position = UDim2.new(0,200,0,30)
MusicBtn.BackgroundColor3 = Color3.fromRGB(40,80,160)
MusicBtn.Text = "🎵 MUSIC"
MusicBtn.TextColor3 = Color3.new(1,1,1)
MusicBtn.Font = Enum.Font.GothamBold
MusicBtn.TextScaled = true
MusicBtn.Parent = MainFrame
make_instance("UICorner", MusicBtn).CornerRadius = UDim.new(0,6)
AddRainbow(MusicBtn,2)

local LockBtn = make_instance("TextButton")
LockBtn.Size = UDim2.new(0,90,0,30)
LockBtn.Position = UDim2.new(0,300,0,30)
LockBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
LockBtn.Text = "🔓 UNLOCKED"
LockBtn.TextColor3 = Color3.new(1,1,1)
LockBtn.Font = Enum.Font.GothamBold
LockBtn.TextScaled = true
LockBtn.Parent = MainFrame
make_instance("UICorner", LockBtn).CornerRadius = UDim.new(0,6)
AddRainbow(LockBtn,2)

local ConBtn = make_instance("TextButton")
ConBtn.Size = UDim2.new(0,110,0,30)
ConBtn.Position = UDim2.new(0,400,0,30)
ConBtn.BackgroundColor3 = Color3.fromRGB(30,120,90)
ConBtn.Text = "💻 CONSOLE"
ConBtn.TextColor3 = Color3.new(1,1,1)
ConBtn.Font = Enum.Font.GothamBold
ConBtn.TextScaled = true
ConBtn.Parent = MainFrame
make_instance("UICorner", ConBtn).CornerRadius = UDim.new(0,6)
AddRainbow(ConBtn,2)

local ExitBtn = make_instance("TextButton")
ExitBtn.Size = UDim2.new(0,90,0,30)
ExitBtn.Position = UDim2.new(0,520,0,30)
ExitBtn.BackgroundColor3 = Color3.fromRGB(140,20,20)
ExitBtn.Text = "🗑️ EXIT"
ExitBtn.TextColor3 = Color3.new(1,1,1)
ExitBtn.Font = Enum.Font.GothamBold
ExitBtn.TextScaled = true
ExitBtn.Parent = MainFrame
make_instance("UICorner", ExitBtn).CornerRadius = UDim.new(0,6)
AddRainbow(ExitBtn,2)

local VolLabel = make_instance("TextLabel")
VolLabel.Size = UDim2.new(0,70,0,25)
VolLabel.Position = UDim2.new(0,10,0,65)
VolLabel.BackgroundTransparency = 1
VolLabel.Text = "🔊 VOLUME:"
VolLabel.TextColor3 = Color3.new(1,1,1)
VolLabel.Font = Enum.Font.Gotham
VolLabel.TextScaled = true
VolLabel.Parent = MainFrame

VolNumMain = make_instance("TextLabel")
VolNumMain.Size = UDim2.new(0,45,0,25)
VolNumMain.Position = UDim2.new(0,85,0,65)
VolNumMain.BackgroundTransparency = 1
VolNumMain.Text = math.floor(MusicVol*100+0.5).."%"
VolNumMain.TextColor3 = Color3.new(1,1,1)
VolNumMain.Font = Enum.Font.GothamBold
VolNumMain.TextScaled = true
VolNumMain.Parent = MainFrame

local VolBGMain = make_instance("Frame")
VolBGMain.Size = UDim2.new(0,150,0,18)
VolBGMain.Position = UDim2.new(0,135,0,67)
VolBGMain.BackgroundColor3 = Color3.fromRGB(50,50,50)
VolBGMain.Parent = MainFrame
make_instance("UICorner", VolBGMain).CornerRadius = UDim.new(0,9)
AddRainbow(VolBGMain,2)

VolFillMain = make_instance("Frame")
VolFillMain.Size = UDim2.new(MusicVol,0,1,0)
VolFillMain.BackgroundColor3 = Color3.fromRGB(60,140,220)
VolFillMain.Parent = VolBGMain
make_instance("UICorner", VolFillMain).CornerRadius = UDim.new(0,9)

local SliderActive = false
VolBGMain.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then SliderActive = true end end)
UserInputService.InputEnded:Connect(function() SliderActive = false end)
UserInputService.InputChanged:Connect(function(i)
    if SliderActive then UpdateVol(math.clamp((i.Position.X - VolBGMain.AbsolutePosition.X)/VolBGMain.AbsoluteSize.X, 0, 1)) end
end)

-- DRAG SYSTEM
local DragState = {Active=false, X=0, Y=0, PosX=0, PosY=0}
MainFrame.InputBegan:Connect(function(Input)
    if Locked then return end
    if not Minimized and Input ~= DragBar then return end
    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
        DragState.Active = true
        DragState.X = Input.Position.X
        DragState.Y = Input.Position.Y
        DragState.PosX = MainFrame.Position.X.Offset
        DragState.PosY = MainFrame.Position.Y.Offset
    end
end)
UserInputService.InputEnded:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then DragState.Active = false end
end)
UserInputService.InputChanged:Connect(function(Input)
    if DragState.Active and not Locked then
        MainFrame.Position = UDim2.new(0, DragState.PosX + (Input.Position.X - DragState.X), 0, DragState.PosY + (Input.Position.Y - DragState.Y))
    end
end)

-- BUTTON ACTIONS
LockBtn.MouseButton1Click:Connect(function()
    Locked = not Locked
    LockBtn.Text = Locked and "🔒 LOCKED" or "🔓 UNLOCKED"
    LockBtn.BackgroundColor3 = Locked and Color3.fromRGB(180,40,40) or Color3.fromRGB(50,50,50)
end)

MinBtn.MouseButton1Click:Connect(function()
    Minimized = not Minimized
    if Minimized then
        MainFrame.Size = MIN
        DragBar.Visible = false
        ESPBtn.Visible = false
        YtBtn.Visible = false
        MusicBtn.Visible = false
        LockBtn.Visible = false
        ConBtn.Visible = false
        ExitBtn.Visible = false
        VolLabel.Visible = false
        VolNumMain.Visible = false
        VolBGMain.Visible = false
        MinBtn.Text = "➕"
    else
        MainFrame.Size = FULL
        DragBar.Visible = true
        ESPBtn.Visible = true
        YtBtn.Visible = true
        MusicBtn.Visible = true
        LockBtn.Visible = true
        ConBtn.Visible = true
        ExitBtn.Visible = true
        VolLabel.Visible = true
        VolNumMain.Visible = true
        VolBGMain.Visible = true
        MinBtn.Text = "❌"
    end
end)

ESPBtn.MouseButton1Click:Connect(function()
    ESP_Active = not ESP_Active
    ESPBtn.Text = ESP_Active and "ESP: ON" or "ESP: OFF"
    ESPBtn.BackgroundColor3 = ESP_Active and Color3.fromRGB(25,120,25) or Color3.fromRGB(40,40,40)
    if not ESP_Active then
        for _,P in pairs(Players:GetPlayers()) do if P.Character then pcall(function()
            if P.Character:FindFirstChild("BLUE_Outline") then P.Character.BLUE_Outline:Destroy() end
            if P.Character:FindFirstChild("FriendRainbowDot") then P.Character.FriendRainbowDot:Destroy() end
        end) end end
    end
end)

YtBtn.MouseButton1Click:Connect(function()
    pcall(function() if setclipboard then setclipboard(CONFIG.YOUTUBE_LINK) end end)
    YtBtn.Text = "✅ COPIED!"
    task_wait(1.5)
    YtBtn.Text = "📺 YOUTUBE"
end)

MusicBtn.MouseButton1Click:Connect(OpenBoombox)
ConBtn.MouseButton1Click:Connect(OpenConsole)
ExitBtn.MouseButton1Click:Connect(FullCleanup)

-- MAIN LOOP
MainLoop = RunService.Heartbeat:Connect(function(Delta)
    if not MainUI or not MainUI.Parent then return end

    local Now = os.time()
    UsedTime = UsedTime + math.max(0, Now - LastCheck)
    LastCheck = Now
    SaveData(CONFIG.SAVE_KEY_USED, UsedTime)
    TimerLabel.Text = string.format("%02d:%02d:%02d / 12:00:00",
        math.floor(UsedTime/3600), math.floor((UsedTime%3600)/60), math.floor(UsedTime%60))

    if UsedTime >= CONFIG.USAGE_DURATION then
        if not ShowCodePrompt() then return end
        UsedTime = 0
    end

    Hue = (Hue + Delta*0.5) % 1
    local Rainbow = Color3.fromHSV(Hue, 1, 1)
    for _, E in pairs(GuiElements) do E.Color = Rainbow end
    if VolFillMain then VolFillMain.BackgroundColor3 = Rainbow end
    if VolFillMenu then VolFillMenu.BackgroundColor3 = Rainbow end

    if not ESP_Active then return end
    for _, Player in pairs(Players:GetPlayers()) do
        if Player == LocalPlayer then continue end
        local Char = Player.Character
        if not Char then goto continue end
        local Hum = Char:FindFirstChildOfClass("Humanoid")
        if not Hum or Hum.Health <= 0 then pcall(function()
            if Char:FindFirstChild("BLUE_Outline") then Char.BLUE_Outline:Destroy() end
            if Char:FindFirstChild("FriendRainbowDot") then Char.FriendRainbowDot:Destroy() end
        end) goto continue end

        local Outline = Char:FindFirstChild("BLUE_Outline") or make_instance("Highlight", Char)
        Outline.Name = "BLUE_Outline"
        Outline.FillTransparency = 1
        Outline.OutlineTransparency = 0
        Outline.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        Outline.OutlineColor = Rainbow

        local IsFriend = false
        pcall(function() IsFriend = LocalPlayer:IsFriendsWith(Player.UserId) end)
        local Head = Char:FindFirstChild("Head")
        local Dot = Char:FindFirstChild("FriendRainbowDot")
        if IsFriend and Head then
            if not Dot then
                Dot = make_instance("BillboardGui", Head)
                Dot.Name = "FriendRainbowDot"
                Dot.AlwaysOnTop = true
                Dot.Size = UDim2.new(0,18,0,18)
                Dot.StudsOffset = Vector3.new(0,1.8,0)
                local Circle = make_instance("Frame", Dot)
                Circle.Size = UDim2.new(1,0,1,0)
                Circle.BackgroundColor3 = Rainbow
                make_instance("UICorner", Circle).CornerRadius = UDim.new(1,0)
            else Dot.Frame.BackgroundColor3 = Rainbow end
        elseif Dot then Dot:Destroy() end
        ::continue::
    end
end)

print("[BlueMode] ✅ FULLY LOADED | CODE: Blue_Mode192823")
print("[BlueMode] ✅ GITHUB VERSION READY")
