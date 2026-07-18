-- ==============================================
-- BLUE MODE ESP | ACCESS CODE: Blue_Mode192823
-- WRONG CODE = DISABLED FOR 12 HOURS
-- ==============================================
if getgenv().BlueMode_Loaded then return end
getgenv().BlueMode_Loaded = true

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 10) or game:GetService("CoreGui")

-- FALLBACK FOR ALL EXECUTORS
local task_wait = task and task.wait or wait

-- SETTINGS
local CORRECT_CODE = "Blue_Mode192823" -- SAME CODE FOR EVERYONE
local USAGE_LIMIT = 12 * 3600 -- 12 HOURS RUNTIME
local COOLDOWN = 12 * 3600 -- 12 HOUR LOCKOUT ON WRONG CODE
local YOUTUBE_LINK = "https://youtube.com/@blue_mode?si=aCGyj0FnwCMtTP1M"
local SAVE_KEY_USED = "BlueMode_UsedTime_v14"
local SAVE_KEY_COOLDOWN = "BlueMode_CooldownEnd_v14"
local SAVE_KEY_VOLUME = "BlueMode_Volume_v14"

-- DATA HELPERS
local function SaveData(key, value)
    pcall(function() if writefile then writefile(key..".txt", tostring(value)) end end)
end
local function LoadData(key, default)
    local v = nil
    pcall(function() if readfile then v = readfile(key..".txt") end end)
    return tonumber(v) or default
end

-- FULL CLEANUP FUNCTION
local MainLoop, CurrentSound
local function FullCleanup()
    if MainLoop then MainLoop:Disconnect() end
    pcall(function() if CurrentSound then CurrentSound:Destroy() end end)
    for _,P in pairs(Players:GetPlayers()) do
        if P and P.Character then pcall(function()
            if P.Character:FindFirstChild("BLUE_Outline") then P.Character.BLUE_Outline:Destroy() end
            if P.Character:FindFirstChild("FriendRainbowDot") then P.Character.FriendRainbowDot:Destroy() end
        end) end
    end
    for _,Gui in pairs(PlayerGui:GetChildren()) do if Gui.Name:find("BLUE_") then Gui:Destroy() end end
    getgenv().BlueMode_Loaded = nil
end

-- PASSWORD PROMPT (APPEARS ON TIMEOUT)
local function ShowPasswordPrompt()
    local PromptUI = Instance.new("ScreenGui")
    PromptUI.Name = "BLUE_CODE_PROMPT"
    PromptUI.ResetOnSpawn = false
    PromptUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    PromptUI.Parent = PlayerGui

    local PromptFrame = Instance.new("Frame")
    PromptFrame.Size = UDim2.new(0,350,0,220)
    PromptFrame.Position = UDim2.new(0.5,-175,0.5,-110)
    PromptFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
    PromptFrame.Parent = PromptUI
    Instance.new("UICorner", PromptFrame).CornerRadius = UDim.new(0,12)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1,-20,0,40)
    Title.Position = UDim2.new(0,10,0,10)
    Title.BackgroundTransparency = 1
    Title.Text = "⏳ TIME EXPIRED | ENTER CODE"
    Title.TextColor3 = Color3.fromRGB(255,80,80)
    Title.Font = Enum.Font.GothamBold
    Title.TextScaled = true
    Title.Parent = PromptFrame

    local CodeInput = Instance.new("TextBox")
    CodeInput.Size = UDim2.new(1,-40,0,45)
    CodeInput.Position = UDim2.new(0,20,0,60)
    CodeInput.BackgroundColor3 = Color3.fromRGB(35,35,35)
    CodeInput.PlaceholderText = "Enter access code..."
    CodeInput.TextColor3 = Color3.new(1,1,1)
    CodeInput.Font = Enum.Font.Gotham
    CodeInput.TextScaled = true
    CodeInput.Password = true
    CodeInput.Parent = PromptFrame
    Instance.new("UICorner", CodeInput).CornerRadius = UDim.new(0,8)

    local StatusText = Instance.new("TextLabel")
    StatusText.Size = UDim2.new(1,-20,0,25)
    StatusText.Position = UDim2.new(0,10,0,115)
    StatusText.BackgroundTransparency = 1
    StatusText.Text = ""
    StatusText.TextColor3 = Color3.new(1,1,1)
    StatusText.Font = Enum.Font.Gotham
    StatusText.TextScaled = true
    StatusText.Parent = PromptFrame

    local SubmitBtn = Instance.new("TextButton")
    SubmitBtn.Size = UDim2.new(0,140,0,40)
    SubmitBtn.Position = UDim2.new(0,35,0,150)
    SubmitBtn.BackgroundColor3 = Color3.fromRGB(30,140,210)
    SubmitBtn.Text = "✅ SUBMIT CODE"
    SubmitBtn.TextColor3 = Color3.new(1,1,1)
    SubmitBtn.Font = Enum.Font.GothamBold
    SubmitBtn.TextScaled = true
    SubmitBtn.Parent = PromptFrame
    Instance.new("UICorner", SubmitBtn).CornerRadius = UDim.new(0,8)

    local ExitBtn = Instance.new("TextButton")
    ExitBtn.Size = UDim2.new(0,140,0,40)
    ExitBtn.Position = UDim2.new(0,175,0,150)
    ExitBtn.BackgroundColor3 = Color3.fromRGB(160,30,30)
    ExitBtn.Text = "❌ EXIT"
    ExitBtn.TextColor3 = Color3.new(1,1,1)
    ExitBtn.Font = Enum.Font.GothamBold
    ExitBtn.TextScaled = true
    ExitBtn.Parent = PromptFrame
    Instance.new("UICorner", ExitBtn).CornerRadius = UDim.new(0,8)

    local CodeValid = false
    SubmitBtn.MouseButton1Click:Connect(function()
        if CodeInput.Text == CORRECT_CODE then
            StatusText.Text = "✅ CORRECT CODE! LOADING..."
            StatusText.TextColor3 = Color3.fromRGB(0,255,100)
            CodeValid = true
            SaveData(SAVE_KEY_USED, 0) -- RESET TIMER
            SaveData(SAVE_KEY_COOLDOWN, 0) -- REMOVE LOCKOUT
            task_wait(1.5)
            PromptUI:Destroy()
            return true
        else
            StatusText.Text = "❌ WRONG CODE! DISABLED FOR 12H"
            StatusText.TextColor3 = Color3.fromRGB(255,50,50)
            SaveData(SAVE_KEY_COOLDOWN, os.time() + COOLDOWN) -- LOCK FOR 12H
            task_wait(2)
            PromptUI:Destroy()
            FullCleanup() -- SCRIPT DISAPPEARS COMPLETELY
            return false
        end
    end)

    ExitBtn.MouseButton1Click:Connect(function()
        PromptUI:Destroy()
        FullCleanup()
    end)

    repeat task_wait(0.1) until not PromptUI.Parent or CodeValid
    return CodeValid
end

-- CHECK IF LOCKED OUT
local CurrentTime = os.time()
local CooldownEnd = LoadData(SAVE_KEY_COOLDOWN, 0)
if CurrentTime < CooldownEnd then
    print("⏭️ LOCKED: Returns in "..math.floor((CooldownEnd-CurrentTime)/3600).."h "..math.floor(((CooldownEnd-CurrentTime)%3600)/60).."m")
    return -- SCRIPT DOES NOT LOAD UNTIL TIMEOUT ENDS
end

-- TRIGGER CODE PROMPT WHEN TIME RUNS OUT
local UsedTime = LoadData(SAVE_KEY_USED, 0)
if UsedTime >= USAGE_LIMIT then
    if not ShowPasswordPrompt() then return end
    UsedTime = 0
end

-- REMAINING SCRIPT SETUP
local LastCheckTime = os.time()
local MusicVolume = LoadData(SAVE_KEY_VOLUME, 0.5)
local VolNumTextMain, VolFillMain, VolFillMenu, VolNumMenu, TimerLabel
local GuiElements = {}
local ESP_Enabled = false
local Buttons_Locked = false
local Hue = 0
local IsMinimized = false
local MainUI, MainFrame, DragHandle, ESPBtn

-- RAINBOW GLOW EFFECT
local function AddRainbowGlow(target, thickness)
    if not target then return end
    local Stroke = Instance.new("UIStroke")
    Stroke.Name = "RainbowAura"
    Stroke.Thickness = thickness or 3
    Stroke.Transparency = 0
    Stroke.LineJoinMode = Enum.LineJoinMode.Round
    Stroke.Parent = target
    table.insert(GuiElements, Stroke)
end

-- VOLUME SYSTEM
local function UpdateVolume(newVol)
    MusicVolume = math.clamp(newVol, 0, 1)
    SaveData(SAVE_KEY_VOLUME, MusicVolume)
    if CurrentSound then CurrentSound.Volume = MusicVolume end
    local Percent = math.floor(MusicVolume * 100 + 0.5) .. "%"
    if VolNumTextMain then VolNumTextMain.Text = Percent end
    if VolFillMain then VolFillMain.Size = UDim2.new(MusicVolume, 0, 1, 0) end
    if VolNumMenu then VolNumMenu.Text = Percent end
    if VolFillMenu then VolFillMenu.Size = UDim2.new(MusicVolume, 0, 1, 0) end
end

-- SOUND PLAYER
local function FormatSoundID(input) return "rbxassetid://"..tostring(input):gsub("%D", "") end
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

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0,30,0,30)
    CloseBtn.Position = UDim2.new(1,-35,0,5)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(170,30,30)
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.new(1,1,1)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 24
    CloseBtn.Parent = BoomFrame

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
    VolFillMenu.BackgroundColor3 = Color3.fromRGB(60,140,220)
    VolFillMenu.Parent = VolBG
    Instance.new("UICorner", VolFillMenu).CornerRadius = UDim.new(0,12)

    local SliderActive = false
    VolBG.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then SliderActive = true end end)
    UserInputService.InputEnded:Connect(function() SliderActive = false end)
    UserInputService.InputChanged:Connect(function(i)
        if SliderActive then UpdateVolume(math.clamp((i.Position.X - VolBG.AbsolutePosition.X)/VolBG.AbsoluteSize.X, 0, 1)) end
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

    PlayBtn.MouseButton1Click:Connect(function() if Input.Text ~= "" then PlaySound(Input.Text) end end)
    StopBtn.MouseButton1Click:Connect(function() pcall(function() if CurrentSound then CurrentSound:Destroy() end) end)
    CloseBtn.MouseButton1Click:Connect(function() BoomUI:Destroy() end)
end

-- SCRIPT CONSOLE
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

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0,32,0,32)
    CloseBtn.Position = UDim2.new(1,-37,0,6)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(170,30,30)
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.new(1,1,1)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 26
    CloseBtn.Parent = Frame

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1,-50,0,35)
    Title.Position = UDim2.new(0,15,0,6)
    Title.BackgroundTransparency = 1
    Title.Text = "💻 CONSOLE"
    Title.TextColor3 = Color3.new(1,1,1)
    Title.Font = Enum.Font.GothamBold
    Title.TextScaled = true
    Title.Parent = Frame

    local Output = Instance.new("TextLabel")
    Output.Size = UDim2.new(1,-30,0,50)
    Output.Position = UDim2.new(0,15,0,45)
    Output.BackgroundColor3 = Color3.fromRGB(35,35,35)
    Output.Text = "Paste code here to run"
    Output.TextColor3 = Color3.fromRGB(0,255,120)
    Output.Font = Enum.Font.Code
    Output.TextScaled = true
    Output.Parent = Frame
    Instance.new("UICorner", Output).CornerRadius = UDim.new(0,8)

    local Input = Instance.new("TextBox")
    Input.Size = UDim2.new(1,-30,0,120)
    Input.Position = UDim2.new(0,15,0,105)
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
    ClearBtn.Text = "🗑️ DELETE"
    ClearBtn.TextColor3 = Color3.new(1,1,1)
    ClearBtn.Font = Enum.Font.GothamBold
    ClearBtn.TextScaled = true
    ClearBtn.Parent = Frame
    Instance.new("UICorner", ClearBtn).CornerRadius = UDim.new(0,8)

    ExecBtn.MouseButton1Click:Connect(function()
        if Input.Text == "" then Output.Text = "⚠️ Nothing to run!" return end
        local Compile = loadstring or load
        local Func, Err = Compile(Input.Text)
        if not Func then Output.Text = "❌ Syntax Error: "..tostring(Err) return end
        local Success, RunErr = pcall(Func)
        Output.Text = Success and "✅ Executed successfully!" or "❌ Run Error: "..tostring(RunErr)
    end)
    ClearBtn.MouseButton1Click:Connect(function() Input.Text = "" Output.Text = "✅ Cleared!" end)
    CloseBtn.MouseButton1Click:Connect(function() ConsoleUI:Destroy() end)
end

-- MAIN UI
MainUI = Instance.new("ScreenGui")
MainUI.Name = "BLUE_MODE_ESP"
MainUI.ResetOnSpawn = false
MainUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
MainUI.Parent = PlayerGui

local FULL_SIZE = UDim2.new(0,680,0,105)
local MIN_SIZE = UDim2.new(0,50,0,50)
MainFrame = Instance.new("Frame")
MainFrame.Size = FULL_SIZE
MainFrame.Position = UDim2.new(0,20,0.5,-52)
MainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
MainFrame.Active = true
MainFrame.ClipsDescendants = false
MainFrame.Parent = MainUI
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,8)
AddRainbowGlow(MainFrame,5)

DragHandle = Instance.new("TextButton")
DragHandle.Size = UDim2.new(1,-25,0,22)
DragHandle.BackgroundColor3 = Color3.fromRGB(60,140,220)
DragHandle.Active = true
DragHandle.Text = "made by BLUE_MODE | DRAG HERE"
DragHandle.TextColor3 = Color3.new(1,1,1)
DragHandle.Font = Enum.Font.GothamBold
DragHandle.TextScaled = true
DragHandle.TextXAlignment = Enum.TextXAlignment.Left
DragHandle.Parent = MainFrame
AddRainbowGlow(DragHandle,2)

TimerLabel = Instance.new("TextLabel")
TimerLabel.Size = UDim2.new(0,100,1,0)
TimerLabel.Position = UDim2.new(1,-105,0,0)
TimerLabel.BackgroundTransparency = 1
TimerLabel.Text = string.format("%02d:%02d:%02d / 12:00:00",math.floor(UsedTime/3600),math.floor((UsedTime%3600)/60),math.floor(UsedTime%60))
TimerLabel.TextColor3 = Color3.new(1,1,1)
TimerLabel.Font = Enum.Font.GothamBold
TimerLabel.TextScaled = true
TimerLabel.TextXAlignment = Enum.TextXAlignment.Right
TimerLabel.Parent = DragHandle

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0,22,1,0)
MinimizeBtn.Position = UDim2.new(1,-22,0,0)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(160,40,40)
MinimizeBtn.Text = "❌"
MinimizeBtn.TextColor3 = Color3.new(1,1,1)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextScaled = true
MinimizeBtn.Parent = MainFrame
AddRainbowGlow(MinimizeBtn,2)

ESPBright = Instance.new("TextButton")
ESPBright.Size = UDim2.new(0,85,0,30)
ESPBright.Position = UDim2.new(0,10,0,30)
ESPBright.BackgroundColor3 = Color3.fromRGB(40,40,40)
ESPBright.Text = "ESP: OFF"
ESPBright.TextColor3 = Color3.new(1,1,1)
ESPBright.Font = Enum.Font.GothamBold
ESPBright.TextScaled = true
ESPBright.Parent = MainFrame
Instance.new("UICorner", ESPBright).CornerRadius = UDim.new(0,6)
AddRainbowGlow(ESPBright,2)
ESPBtn = ESPBright

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
LockBtn.Text = "🔓 UNLOCKED"
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

local VolLabelMain = Instance.new("TextLabel")
VolLabelMain.Size = UDim2.new(0,70,0,25)
VolLabelMain.Position = UDim2.new(0,10,0,65)
VolLabelMain.BackgroundTransparency = 1
VolLabelMain.Text = "🔊 VOLUME:"
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
VolFillMain.BackgroundColor3 = Color3.fromRGB(60,140,220)
VolFillMain.Parent = VolBGMain
Instance.new("UICorner", VolFillMain).CornerRadius = UDim.new(0,9)

local SliderActiveMain = false
VolBGMain.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then SliderActiveMain = true end end)
UserInputService.InputEnded:Connect(function() SliderActiveMain = false end)
UserInputService.InputChanged:Connect(function(i)
    if SliderActiveMain then UpdateVolume(math.clamp((i.Position.X - VolBGMain.AbsolutePosition.X)/VolBGMain.AbsoluteSize.X, 0, 1)) end
end)

local DragState = {Active = false, StartX = 0, StartY = 0, StartPosX = 0, StartPosY = 0}
MainFrame.InputBegan:Connect(function(Input)
    if Buttons_Locked then return end
    if not IsMinimized and Input ~= DragHandle then return end
    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
        DragState.Active = true
        DragState.StartX = Input.Position.X
        DragState.StartY = Input.Position.Y
        DragState.StartPosX = MainFrame.Position.X.Offset
        DragState.StartPosY = MainFrame.Position.Y.Offset
    end
end)
UserInputService.InputEnded:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then DragState.Active = false end
end)
UserInputService.InputChanged:Connect(function(Input)
    if DragState.Active and not Buttons_Locked then
        MainFrame.Position = UDim2.new(0, DragState.StartPosX + (Input.Position.X - DragState.StartX), 0, DragState.StartPosY + (Input.Position.Y - DragState.StartY))
    end
end)

LockBtn.MouseButton1Click:Connect(function()
    Buttons_Locked = not Buttons_Locked
    LockBtn.Text = Buttons_Locked and "🔒 LOCKED" or "🔓 UNLOCKED"
    LockBtn.BackgroundColor3 = Buttons_Locked and Color3.fromRGB(180,40,40) or Color3.fromRGB(50,50,50)
end)

MinimizeBtn.MouseButton1Click:Connect(function()
    IsMinimized = not IsMinimized
    if IsMinimized then
        MainFrame.Size = MIN_SIZE
        DragHandle.Visible = false
        ESPBtn.Visible = false
        YouTubeBtn.Visible = false
        MusicBtn.Visible = false
        LockBtn.Visible = false
        ConsoleBtn.Visible = false
        ExitBtn.Visible = false
        VolLabelMain.Visible = false
        VolNumTextMain.Visible = false
        VolBGMain.Visible = false
        MinimizeBtn.Text = "➕"
    else
        MainFrame.Size = FULL_SIZE
        DragHandle.Visible = true
        ESPBtn.Visible = true
        YouTubeBtn.Visible = true
        MusicBtn.Visible = true
        LockBtn.Visible = true
        ConsoleBtn.Visible = true
        ExitBtn.Visible = true
        VolLabelMain.Visible = true
        VolNumTextMain.Visible = true
        VolBGMain.Visible = true
        MinimizeBtn.Text = "❌"
    end
end)

ESPBright.MouseButton1Click:Connect(function()
    ESP_Enabled = not ESP_Enabled
    ESPBtn.Text = ESP_Enabled and "ESP: ON" or "ESP: OFF"
    ESPBtn.BackgroundColor3 = ESP_Enabled and Color3.fromRGB(25,120,25) or Color3.fromRGB(40,40,40)
    if not ESP_Enabled then
        for _,P in pairs(Players:GetPlayers()) do if P.Character then pcall(function()
            if P.Character:FindFirstChild("BLUE_Outline") then P.Character.BLUE_Outline:Destroy() end
            if P.Character:FindFirstChild("FriendRainbowDot") then P.Character.FriendRainbowDot:Destroy() end
        end) end end
    end
end)

YouTubeBtn.MouseButton1Click:Connect(function()
    pcall(function() if setclipboard then setclipboard(YOUTUBE_LINK) end end)
    YouTubeBtn.Text = "✅ COPIED!"
    task_wait(1.5)
    YouTubeBtn.Text = "📺 YOUTUBE"
end)

MusicBtn.MouseButton1Click:Connect(OpenBoomboxMenu)
ConsoleBtn.MouseButton1Click:Connect(OpenConsole)
ExitBtn.MouseButton1Click:Connect(FullCleanup)

-- MAIN LOOP
MainLoop = RunService.Heartbeat:Connect(function(Delta)
    if not MainUI or not MainUI.Parent then return end

    local Now = os.time()
    UsedTime = UsedTime + math.max(0, Now - LastCheckTime)
    LastCheckTime = Now
    SaveData(SAVE_KEY_USED, UsedTime)
    local h = math.floor(UsedTime/3600)
    local m = math.floor((UsedTime%3600)/60)
    local s = math.floor(UsedTime%60)
    TimerLabel.Text = string.format("%02d:%02d:%02d / 12:00:00",h,m,s)

    -- AUTO PROMPT WHEN TIME RUNS OUT
    if UsedTime >= USAGE_LIMIT then
        if not ShowPasswordPrompt() then return end
        UsedTime = 0
    end

    -- RAINBOW ANIMATION
    Hue = (Hue + Delta*0.5) % 1
    local Rainbow = Color3.fromHSV(Hue, 1, 1)
    for _,e in pairs(GuiElements) do e.Color = Rainbow end
    if VolFillMain then VolFillMain.BackgroundColor3 = Rainbow end
    if VolFillMenu then VolFillMenu.BackgroundColor3 = Rainbow end

    -- ESP SYSTEM
    if not ESP_Enabled then return end
    for _,P in pairs(Players:GetPlayers()) do
        if P == LocalPlayer then continue end
        local Char = P.Character
        if not Char then goto continue end
        local Hum = Char:FindFirstChildOfClass("Humanoid")
        if not Hum or Hum.Health <= 0 then pcall(function()
            if Char:FindFirstChild("BLUE_Outline") then Char.BLUE_Outline:Destroy() end
            if Char:FindFirstChild("FriendRainbowDot") then Char.FriendRainbowDot:Destroy() end
        end) goto continue end

        local Outline = Char:FindFirstChild("BLUE_Outline") or Instance.new("Highlight", Char)
        Outline.Name = "BLUE_Outline"
        Outline.FillTransparency = 1
        Outline.OutlineTransparency = 0
        Outline.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        Outline.OutlineColor = Rainbow

        local IsFriend = false
        pcall(function() IsFriend = LocalPlayer:IsFriendsWith(P.UserId) end)
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
                Circle.BackgroundColor3 = Rainbow
                Instance.new("UICorner", Circle).CornerRadius = UDim.new(1,0)
            else Dot.Frame.BackgroundColor3 = Rainbow end
        elseif Dot then Dot:Destroy() end
        ::continue::
    end
end)

print("✅ BLUE MODE ESP | LOADED | CODE: Blue_Mode192823")
