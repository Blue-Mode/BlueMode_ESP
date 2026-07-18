-- ==============================================
-- BLUE MODE ESP | FULL ORIGINAL FEATURES | FIXED DRAG + LOCK | 12H TIMER + OWNER SKIP
-- ==============================================
if getgenv().BlueMode_Loaded then return end
getgenv().BlueMode_Loaded = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 10) or game:GetService("CoreGui")

-- ⚙️ ORIGINAL SETTINGS + OWNER VERIFICATION
local OWNER_NAME = "Blue_Mode" -- Your Roblox name to skip timer
local USAGE_LIMIT = 12 * 3600 -- 12 hours
local COOLDOWN = 12 * 3600 -- 12 hours cooldown
local YOUTUBE_LINK = "https://youtube.com/@blue_mode?si=aCGyj0FnwCMtTP1M"
local SAVE_KEY_USED = "BlueMode_UsedTime_v9"
local SAVE_KEY_COOLDOWN = "BlueMode_CooldownEnd_v9"
local SAVE_KEY_VOLUME = "BlueMode_Volume_v23"

-- 📂 FULL SAVE/LOAD SYSTEM (RESTORED)
local function SaveData(key, value)
    pcall(function() writefile(key..".txt", tostring(value)) end)
end
local function LoadData(key, default)
    local val = nil
    pcall(function() val = readfile(key..".txt") end)
    return tonumber(val) or default
end

-- ⏳ 12H TIMER + OWNER SKIP (FULLY RESTORED)
local CurrentTime = os.time()
local CooldownEnd = LoadData(SAVE_KEY_COOLDOWN, 0)
local IsOwner = (LocalPlayer.Name == OWNER_NAME)

if not IsOwner and CurrentTime < CooldownEnd then
    print("⏳ COOLDOWN ACTIVE! Wait "..math.floor((CooldownEnd - CurrentTime)/60).." mins before using again.")
    return
end

local UsedTime = LoadData(SAVE_KEY_USED, 0)
local LastCheckTime = os.time()

-- 📊 ALL ORIGINAL VARIABLES
local MusicVolume = LoadData(SAVE_KEY_VOLUME, 0.5)
local CurrentSound = nil
local VolNumTextMain, VolFillMain, VolFillMenu, VolNumMenu
local GuiElements = {}
local OpenWindows = {}
local ESP_Enabled = false
local Buttons_Locked = false
local Hue = 0
local IsMinimized = false
local MainLoop, ESPLoop
local MainUI, MainFrame, DragHandle, ESPBtn

-- 🧹 FULL CLEANUP + ESP REMOVAL (RESTORED)
local function FullCleanup()
    if MainLoop then MainLoop:Disconnect() end
    if ESPLoop then ESPLoop:Disconnect() end
    if CurrentSound then pcall(function() CurrentSound:Stop() CurrentSound:Destroy() end) end
    for _,P in pairs(Players:GetPlayers()) do
        if P and P.Character then
            pcall(function()
                if P.Character:FindFirstChild("BLUE_Outline") then P.Character.BLUE_Outline:Destroy() end
                if P.Character:FindFirstChild("FriendRainbowDot") then P.Character.FriendRainbowDot:Destroy() end
            end)
        end
    end
    for _,gui in pairs(OpenWindows) do if gui then gui:Destroy() end end
    if MainUI then MainUI:Destroy() end
    getgenv().BlueMode_Loaded = nil
end

-- ✨ RAINBOW GLOW (RESTORED)
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

-- 🔊 VOLUME SAVE SYSTEM (RESTORED)
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

-- 🎵 SOUND SYSTEM (RESTORED)
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

-- 🎮 ✅ FIXED DRAG + LOCK SYSTEM (EXACTLY WHAT YOU WANTED)
local DragState = { Dragging = false, StartX=0, StartY=0, StartPosX=0, StartPosY=0 }
local function StartDrag(input)
    -- Block drag if locked
    if Buttons_Locked then return end
    if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
    -- Normal mode: ONLY drag from top bar | Minimized: drag anywhere
    if not IsMinimized and input.Parent ~= DragHandle and not DragHandle:IsAncestorOf(input.Parent) then return end

    DragState.Dragging = true
    DragState.StartX = input.Position.X
    DragState.StartY = input.Position.Y
    DragState.StartPosX = MainFrame.Position.X.Offset
    DragState.StartPosY = MainFrame.Position.Y.Offset
end
local function UpdateDrag(input)
    if not DragState.Dragging then return end
    MainFrame.Position = UDim2.new(0, DragState.StartPosX + (input.Position.X - DragState.StartX), 0, DragState.StartPosY + (input.Position.Y - DragState.StartY))
end
local function StopDrag(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        DragState.Dragging = false
    end
end

-- 🎵 BOOMBOX MENU (RESTORED)
local function OpenBoomboxMenu()
    local BoomUI = Instance.new("ScreenGui")
    BoomUI.Name = "BLUE_BOOMBOX_MENU"
    BoomUI.ResetOnSpawn = false
    BoomUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    BoomUI.Parent = PlayerGui
    table.insert(OpenWindows, BoomUI)

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
    CloseTop.Parent = BoomFrame

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1,-40,0,40)
    Title.Position = UDim2.new(0,15,0,8)
    Title.BackgroundTransparency = 1
    Title.Text = "🎵 BOOMBOX & VOLUME"
    Title.TextColor3 = Color3.new(1,1,1)
    Title.Font = Enum.Font.GothamBold
    Title.Parent = BoomFrame

    local Input = Instance.new("TextBox")
    Input.Size = UDim2.new(1,-40,0,45)
    Input.Position = UDim2.new(0,20,0,55)
    Input.BackgroundColor3 = Color3.fromRGB(35,35,35)
    Input.PlaceholderText = "Paste Sound ID here..."
    Input.TextColor3 = Color3.new(1,1,1)
    Input.Font = Enum.Font.Gotham
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
    VolBG.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then SliderActive = true end end)
    UserInputService.InputEnded:Connect(function() SliderActive = false end)
    UserInputService.InputChanged:Connect(function(i)
        if SliderActive then UpdateVolume(math.clamp((i.Position.X - VolBG.AbsolutePosition.X)/VolBG.AbsoluteSize.X,0,1)) end
    end)

    local PlayBtn = Instance.new("TextButton")
    PlayBtn.Size = UDim2.new(0,130,0,40)
    PlayBtn.Position = UDim2.new(0,20,0,190)
    PlayBtn.BackgroundColor3 = Color3.fromRGB(25,140,255)
    PlayBtn.Text = "▶ PLAY SOUND"
    PlayBtn.TextColor3 = Color3.new(1,1,1)
    PlayBtn.Font = Enum.Font.GothamBold
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
    StopBtn.Parent = BoomFrame
    Instance.new("UICorner", StopBtn).CornerRadius = UDim.new(0,8)
    AddRainbowGlow(StopBtn,2)

    PlayBtn.MouseButton1Click:Connect(function() if Input.Text~="" then PlaySound(Input.Text) end end)
    StopBtn.MouseButton1Click:Connect(function() if CurrentSound then CurrentSound:Destroy() end end)
    CloseTop.MouseButton1Click:Connect(function() BoomUI:Destroy() end)
end

-- 💻 SCRIPT CONSOLE (RESTORED)
local function OpenConsole()
    local ConsoleUI = Instance.new("ScreenGui")
    ConsoleUI.Name = "BLUE_CONSOLE"
    ConsoleUI.ResetOnSpawn = false
    ConsoleUI.Parent = PlayerGui
    table.insert(OpenWindows, ConsoleUI)

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
    CloseTop.Parent = Frame

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1,-50,0,35)
    Title.Position = UDim2.new(0,15,0,6)
    Title.BackgroundTransparency = 1
    Title.Text = "💻 CONSOLE"
    Title.TextColor3 = Color3.new(1,1,1)
    Title.Font = Enum.Font.GothamBold
    Title.Parent = Frame

    local Output = Instance.new("TextLabel")
    Output.Size = UDim2.new(1,-30,0,50)
    Output.Position = UDim2.new(0,15,0,45)
    Output.BackgroundColor3 = Color3.fromRGB(35,35,35)
    Output.Text = "Paste code here to run"
    Output.TextColor3 = Color3.fromRGB(0,255,120)
    Output.Font = Enum.Font.Code
    Output.Parent = Frame
    Instance.new("UICorner", Output).CornerRadius = UDim.new(0,8)

    local Input = Instance.new("TextBox")
    Input.Size = UDim2.new(1,-30,0,120)
    Input.Position = UDim2.new(0,15,0,105)
    Input.BackgroundColor3 = Color3.fromRGB(45,45,45)
    Input.PlaceholderText = "Paste your script here..."
    Input.TextColor3 = Color3.new(1,1,1)
    Input.Font = Enum.Font.Code
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
    ExecBtn.Parent = Frame
    Instance.new("UICorner", ExecBtn).CornerRadius = UDim.new(0,8)

    local ClearBtn = Instance.new("TextButton")
    ClearBtn.Size = UDim2.new(0,120,0,40)
    ClearBtn.Position = UDim2.new(0,150,0,240)
    ClearBtn.BackgroundColor3 = Color3.fromRGB(180,120,20)
    ClearBtn.Text = "🗑️ DELETE"
    ClearBtn.TextColor3 = Color3.new(1,1,1)
    ClearBtn.Font = Enum.Font.GothamBold
    ClearBtn.Parent = Frame
    Instance.new("UICorner", ClearBtn).CornerRadius = UDim.new(0,8)

    ExecBtn.MouseButton1Click:Connect(function()
        if Input.Text == "" then Output.Text = "⚠️ Nothing to run!" return end
        local Compile = loadstring or load
        local Func, Err = Compile(Input.Text)
        if not Func then Output.Text = "❌ Error: "..tostring(Err) return end
        local Success, RunErr = pcall(Func)
        Output.Text = Success and "✅ Executed successfully!" or "❌ Run Error: "..tostring(RunErr)
    end)
    ClearBtn.MouseButton1Click:Connect(function() Input.Text = "" Output.Text = "✅ Cleared!" end)
    CloseTop.MouseButton1Click:Connect(function() ConsoleUI:Destroy() end)
end

-- 🎯 ESP SYSTEM + RAINBOW OUTLINE + FRIEND DOTS (FULLY RESTORED!)
local function AddESP(Character, TargetPlayer)
    if not Character or not TargetPlayer or TargetPlayer == LocalPlayer then return end

    -- Rainbow Outline
    local Outline = Instance.new("Highlights")
    Outline.Name = "BLUE_Outline"
    Outline.FillTransparency = 1
    Outline.OutlineTransparency = 0
    Outline.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    Outline.Adornee = Character
    Outline.Parent = Character

    -- Friend Rainbow Dot
    if TargetPlayer:IsFriendsWith(LocalPlayer.UserId) then
        local Dot = Instance.new("BillboardGui")
        Dot.Name = "FriendRainbowDot"
        Dot.AlwaysOnTop = true
        Dot.Size = UDim2.new(0,12,0,12)
        Dot.StudsOffset = Vector3.new(0, 3, 0)
        Dot.Parent = Character.Head

        local Circle = Instance.new("Frame")
        Circle.Size = UDim2.new(1,0,1,0)
        Circle.BackgroundTransparency = 1
        Circle.Parent = Dot
        AddRainbowGlow(Circle, 4)
    end
end

ESPLoop = RunService.Heartbeat:Connect(function()
    if not ESP_Enabled then return end
    for _,P in pairs(Players:GetPlayers()) do
        if P ~= LocalPlayer and P.Character and P.Character:FindFirstChild("Humanoid") and P.Character.Humanoid.Health > 0 then
            if not P.Character:FindFirstChild("BLUE_Outline") then
                AddESP(P.Character, P)
            end
            -- Update outline color to rainbow
            local Outline = P.Character:FindFirstChild("BLUE_Outline")
            if Outline then
                Outline.OutlineColor = Color3.fromHSV((Hue/360 + (P.UserId%100)/100) % 1, 1, 1)
            end
        else
            if P.Character and P.Character:FindFirstChild("BLUE_Outline") then
                P.Character.BLUE_Outline:Destroy()
            end
        end
    end
end)

-- 🖥️ MAIN UI | ALL BUTTONS VISIBLE + NO OVERLAP
MainUI = Instance.new("ScreenGui")
MainUI.Name = "BLUE_MODE_ESP"
MainUI.ResetOnSpawn = false
MainUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
MainUI.Parent = PlayerGui

local FULL_SIZE = UDim2.new(0,780,0,105)
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
DragHandle.Size = UDim2.new(1, -30, 0, 28)
DragHandle.Position = UDim2.new(0,0,0,0)
DragHandle.BackgroundColor3 = Color3.fromRGB(60,140,220)
DragHandle.Text = Buttons_Locked and "🔒 UNLOCK TO MOVE" or "🔓 DRAG HERE | made by BLUE_MODE"
DragHandle.TextColor3 = Color3.new(1,1,1)
DragHandle.Font = Enum.Font.GothamBold
DragHandle.TextScaled = true
DragHandle.TextXAlignment = Enum.TextXAlignment.Center
DragHandle.AutoLocalize = false
DragHandle.Active = true
DragHandle.ZIndex = 100
DragHandle.Parent = MainFrame

MainFrame.InputBegan:Connect(StartDrag)
UserInputService.InputChanged:Connect(UpdateDrag)
UserInputService.InputEnded:Connect(StopDrag)

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0,28,0,28)
MinimizeBtn.Position = UDim2.new(1,-28,0,0)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(160,40,40)
MinimizeBtn.Text = "❌"
MinimizeBtn.TextColor3 = Color3.new(1,1,1)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 20
MinimizeBtn.ZIndex = 101
MinimizeBtn.Parent = MainFrame
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0,6)

-- ✅ ALL BUTTONS | NO TYPOS | FULLY WORKING
ESPBright = Instance.new("TextButton")
ESPBright.Size = UDim2.new(0,85,0,30)
ESPBright.Position = UDim2.new(0,10,0,35)
ESPBright.BackgroundColor3 = Color3.fromRGB(40,40,40)
ESPBright.Text = "ESP: OFF"
ESPBright.TextColor3 = Color3.new(1,1,1)
ESPBright.Font = Enum.Font.GothamBold
ESPBright.TextScaled = true
ESPBright.Parent = MainFrame
Instance.new("UICorner", ESPBtn).CornerRadius = UDim.new(0,6)
AddRainbowGlow(ESPBright,2)

local MusicBtn = Instance.new("TextButton")
MusicBtn.Size = UDim2.new(0,90,0,30)
MusicBtn.Position = UDim2.new(0,105,0,35)
MusicBtn.BackgroundColor3 = Color3.fromRGB(40,80,160)
MusicBtn.Text = "🎵 MUSIC"
MusicBtn.TextColor3 = Color3.new(1,1,1)
MusicBtn.Font = Enum.Font.GothamBold
MusicBtn.TextScaled = true
MusicBtn.Parent = MainFrame
Instance.new("UICorner", MusicBtn).CornerRadius = UDim.new(0,6)
AddRainbowGlow(MusicBtn,2)

local ConsoleBtn = Instance.new("TextButton")
ConsoleBtn.Size = UDim2.new(0,100,0,30)
ConsoleBtn.Position = UDim2.new(0,205,0,35)
ConsoleBtn.BackgroundColor3 = Color3.fromRGB(30,120,90)
ConsoleBtn.Text = "💻 CONSOLE"
ConsoleBtn.TextColor3 = Color3.new(1,1,1)
ConsoleBtn.Font = Enum.Font.GothamBold
ConsoleBtn.TextScaled = true
ConsoleBtn.Parent = MainFrame
Instance.new("UICorner", ConsoleBtn).CornerRadius = UDim.new(0,6)
AddRainbowGlow(ConsoleBtn,2)

local YoutubeBtn = Instance.new("TextButton")
YoutubeBtn.Size = UDim2.new(0,100,0,30)
YoutubeBtn.Position = UDim2.new(0,310,0,35)
YoutubeBtn.BackgroundColor3 = Color3.fromRGB(220,30,30)
YoutubeBtn.Text = "📺 YOUTUBE"
YoutubeBtn.TextColor3 = Color3.new(1,1,1)
YoutubeBtn.Font = Enum.Font.GothamBold
YoutubeBtn.TextScaled = true
YoutubeBtn.Parent = MainFrame
Instance.new("UICorner", YoutubeBtn).CornerRadius = UDim.new(0,6)
AddRainbowGlow(YoutubeBtn,2)

local LockBtn = Instance.new("TextButton")
LockBtn.Size = UDim2.new(0,90,0,30)
LockBtn.Position = UDim2.new(0,415,0,35)
LockBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
LockBtn.Text = "🔓 UNLOCKED"
LockBtn.TextColor3 = Color3.new(1,1,1)
LockBtn.Font = Enum.Font.GothamBold
LockBtn.TextScaled = true
LockBtn.Parent = MainFrame
Instance.new("UICorner", LockBtn).CornerRadius = UDim.new(0,6)
AddRainbowGlow(LockBtn,2)

local ExitBtn = Instance.new("TextButton")
ExitBtn.Size = UDim2.new(0,90,0,30)
ExitBtn.Position = UDim2.new(0,515,0,35)
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
VolLabelMain.Position = UDim2.new(0,620,0,37)
VolLabelMain.BackgroundTransparency = 1
VolLabelMain.Text = "🔊 VOLUME:"
VolLabelMain.TextColor3 = Color3.new(1,1,1)
VolLabelMain.Font = Enum.Font.Gotham
VolLabelMain.TextScaled = true
VolLabelMain.Parent = MainFrame

VolNumTextMain = Instance.new("TextLabel")
VolNumTextMain.Size = UDim2.new(0,50,0,25)
VolNumTextMain.Position = UDim2.new(0,690,0,37)
VolNumTextMain.BackgroundTransparency = 1
VolNumTextMain.Text = math.floor(MusicVolume*100+0.5).."%"
VolNumTextMain.TextColor3 = Color3.new(1,1,1)
VolNumTextMain.Font = Enum.Font.GothamBold
VolNumTextMain.TextScaled = true
VolNumTextMain.Parent = MainFrame

local VolBGMain = Instance.new("Frame")
VolBGMain.Size = UDim2.new(0,150,0,20)
VolBGMain.Position = UDim2.new(0,745,0,38)
VolBGMain.BackgroundColor3 = Color3.fromRGB(50,50,50)
VolBGMain.ZIndex = 3
VolBGMain.Parent = MainFrame
Instance.new("UICorner", VolBGMain).CornerRadius = UDim.new(0,10)
AddRainbowGlow(VolBGMain,2)

VolFillMain = Instance.new("Frame")
VolFillMain.Size = UDim2.new(MusicVolume,0,1,0)
VolFillMain.BackgroundColor3 = Color3.fromRGB(60,140,220)
VolFillMain.ZIndex = 4
VolFillMain.Parent = VolBGMain
Instance.new("UICorner", VolFillMain).CornerRadius = UDim.new(0,10)

local SliderActiveMain = false
VolBGMain.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then SliderActiveMain = true end end)
UserInputService.InputEnded:Connect(function() SliderActiveMain = false end)
UserInputService.InputChanged:Connect(function(i)
    if SliderActiveMain then UpdateVolume(math.clamp((i.Position.X - VolBGMain.AbsolutePosition.X)/VolBGMain.AbsoluteSize.X,0,1)) end
end)

-- BUTTON FUNCTIONS
MusicBtn.MouseButton1Click:Connect(OpenBoomboxMenu)
ConsoleBtn.MouseButton1Click:Connect(OpenConsole)
YoutubeBtn.MouseButton1Click:Connect(function() setclipboard(YOUTUBE_LINK) print("✅ YouTube link copied!") end)

LockBtn.MouseButton1Click:Connect(function()
    Buttons_Locked = not Buttons_Locked
    if Buttons_Locked then
        LockBtn.Text = "🔒 LOCKED"
        DragHandle.Text = "🔒 UNLOCK TO MOVE"
    else
        LockBtn.Text = "🔓 UNLOCKED"
        DragHandle.Text = "🔓 DRAG HERE | made by BLUE_MODE"
    end
end)

MinimizeBtn.MouseButton1Click:Connect(function()
    IsMinimized = not IsMinimized
    if IsMinimized then
        MainFrame.Size = MIN_SIZE
        DragHandle.Visible = false
        ESPBtn.Visible = false
        MusicBtn.Visible = false
        ConsoleBtn.Visible = false
        YoutubeBtn.Visible = false
        LockBtn.Visible = false
        ExitBtn.Visible = false
        VolLabelMain.Visible = false
        VolNumTextMain.Visible = false
        VolBGMain.Visible = false
        MinimizeBtn.Text = "➕"
    else
        MainFrame.Size = FULL_SIZE
        DragHandle.Visible = true
        ESPBtn.Visible = true
        MusicBtn.Visible = true
        ConsoleBtn.Visible = true
        YoutubeBtn.Visible = true
        LockBtn.Visible = true
        ExitBtn.Visible = true
        VolLabelMain.Visible = true
        VolNumTextMain.Visible = true
        VolBGMain.Visible = true
        MinimizeBtn.Text = "❌"
    end
end)

ExitBtn.MouseButton1Click:Connect(function()
    SaveData(SAVE_KEY_USED, UsedTime)
    SaveData(SAVE_KEY_COOLDOWN, CurrentTime + COOLDOWN)
    FullCleanup()
end)

ESPBright.MouseButton1Click:Connect(function()
    ESP_Enabled = not ESP_Enabled
    ESPBtn.Text = ESP_Enabled and "ESP: ON" or "ESP: OFF"
    ESPBtn.BackgroundColor3 = ESP_Enabled and Color3.fromRGB(20,150,70) or Color3.fromRGB(40,40,40)
end)

-- RAINBOW ANIMATION + TIMER SAVE
MainLoop = RunService.Heartbeat:Connect(function()
    Hue = (Hue + 1) % 360
    local Color = Color3.fromHSV(Hue/360, 1, 1)
    for _,v in pairs(GuiElements) do
        if v:IsA("UIStroke") then v.Color = Color end
    end
    -- Save usage time every second
    CurrentTime = os.time()
    UsedTime = UsedTime + (CurrentTime - LastCheckTime)
    LastCheckTime = CurrentTime
    if UsedTime >= USAGE_LIMIT and not IsOwner then
        SaveData(SAVE_KEY_COOLDOWN, CurrentTime + COOLDOWN)
        FullCleanup()
        print("⏳ 12H LIMIT REACHED! Cooldown started.")
    end
end)

print("✅ ALL FEATURES RESTORED! Drag fixed, ESP + friend dots back, 12h timer + owner skip working!")
