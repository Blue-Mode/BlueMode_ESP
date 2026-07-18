-- ============================================== -- BLUE MODE ESP | FINAL FIXED VERSION -- NO TYPOS | ALL EXECUTORS COMPATIBLE -- ============================================== if getgenv().BlueMode_Loaded then return end getgenv().BlueMode_Loaded = true

-- SERVICES local Players = game:GetService("Players") local RunService = game:GetService("RunService") local UserInputService = game:GetService("UserInputService") local SoundService = game:GetService("SoundService") local HttpService = game:GetService("HttpService") local LocalPlayer = Players.LocalPlayer local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 10) or game:GetService("CoreGui")

-- SETTINGS local USAGE_LIMIT = 12 * 3600 local COOLDOWN = 12 * 3600 local YOUTUBE_LINK = "https://youtube.com/@blue_mode?si=aCGyj0FnwCMtTP1M" local SAVE_KEY_USED = "BlueMode_UsedTime_v3" local SAVE_KEY_COOLDOWN = "BlueMode_CooldownEnd_v3" local SAVE_KEY_VOLUME = "BlueMode_Volume_v3"

-- DATA HELPERS local function SaveData(key, value) pcall(function() writefile(key..".txt", tostring(value)) end) end local function LoadData(key, default) local val = nil pcall(function() val = readfile(key..".txt") end) return tonumber(val) or default end

-- CLEANUP OLD ESP local function ClearESP() for _, Player in pairs(Players:GetPlayers()) do if Player and Player.Character then pcall(function() if Player.Character:FindFirstChild("BLUE_Outline") then Player.Character.BLUE_Outline:Destroy() end if Player.Character:FindFirstChild("FriendRainbowDot") then Player.Character.FriendRainbowDot:Destroy() end end) end end end

-- COOLDOWN CHECK local CurrentTime = os.time() local CooldownEnd = LoadData(SAVE_KEY_COOLDOWN, 0) if CurrentTime < CooldownEnd then print("⏳ COOLDOWN ACTIVE! Wait "..math.floor((CooldownEnd - CurrentTime)/60).." minutes") return end

-- LOAD SAVED VALUES local UsedTime = LoadData(SAVE_KEY_USED, 0) local LastCheckTime = os.time() local MusicVolume = LoadData(SAVE_KEY_VOLUME, 0.5) local CurrentSound = nil local VolNumTextMain, VolFillMain, VolFillMenu, VolNumMenu, BoomFrame local GuiElements = {} local ESP_Enabled = false local Buttons_Locked = false local Hue = 0 local IsMinimized = false

-- RAINBOW GLOW SYSTEM local function AddRainbowGlow(target, thickness) if not target then return end local Outline = Instance.new("UIStroke") Outline.Name = "RainbowAura" Outline.Thickness = thickness or 3 Outline.Transparency = 0 Outline.LineJoinMode = Enum.LineJoinMode.Round Outline.Parent = target table.insert(GuiElements, Outline) return Outline end

-- VOLUME CONTROLS local function UpdateVolume(newVolume) MusicVolume = math.clamp(newVolume, 0, 1) SaveData(SAVE_KEY_VOLUME, MusicVolume) if CurrentSound then CurrentSound.Volume = MusicVolume end local Percent = math.floor(MusicVolume * 100).."%" if VolNumTextMain then VolNumTextMain.Text = Percent end if VolFillMain then VolFillMain.Size = UDim2.new(MusicVolume, 0, 1, 0) end if VolNumMenu then VolNumMenu.Text = Percent end if VolFillMenu then VolFillMenu.Size = UDim2.new(MusicVolume, 0, 1, 0) end end

-- SOUND ID FORMAT local function FormatSoundID(input) return "rbxassetid://"..tostring(input):gsub("%D", "") end

-- BOOMBOX PLAYER local function PlaySound(SoundID) pcall(function() if CurrentSound then CurrentSound:Destroy() end end) CurrentSound = Instance.new("Sound") CurrentSound.Name = "BLUE_BOOMBOX" CurrentSound.SoundId = FormatSoundID(SoundID) CurrentSound.Volume = MusicVolume CurrentSound.Looped = true CurrentSound.Parent = SoundService pcall(function() CurrentSound:Play() end) end

-- BOOMBOX MENU local function OpenBoomboxMenu() local BoomUI = Instance.new("ScreenGui") BoomUI.Name = "BLUE_BOOMBOX_MENU" BoomUI.ResetOnSpawn = false BoomUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling BoomUI.Parent = PlayerGui

BoomFrame = Instance.new("Frame")
BoomFrame.Size = UDim2.new(0, 320, 0, 250)
BoomFrame.Position = UDim2.new(0.5, -160, 0.5, -125)
BoomFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
BoomFrame.ClipsDescendants = false
BoomFrame.Parent = BoomUI
Instance.new("UICorner", BoomFrame).CornerRadius = UDim.new(0, 12)
AddRainbowGlow(BoomFrame, 4)

local CloseBtnTop = Instance.new("TextButton")
CloseBtnTop.Size = UDim2.new(0, 30, 0, 30)
CloseBtnTop.Position = UDim2.new(1, -35, 0, 5)
CloseBtnTop.BackgroundColor3 = Color3.fromRGB(170, 30, 30)
CloseBtnTop.Text = "✕"
CloseBtnTop.TextColor3 = Color3.new(1, 1, 1)
CloseBtnTop.Font = Enum.Font.GothamBold
CloseBtnTop.TextSize = 24
CloseBtnTop.AutoLocalize = false
CloseBtnTop.Parent = BoomFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 0, 40)
Title.Position = UDim2.new(0, 15, 0, 8)
Title.BackgroundTransparency = 1
Title.Text = "🎵 BOOMBOX & VOLUME"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true
Title.AutoLocalize = false
Title.Parent = BoomFrame

local InputBox = Instance.new("TextBox")
InputBox.Size = UDim2.new(1, -40, 0, 45)
InputBox.Position = UDim2.new(0, 20, 0, 55)
InputBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
InputBox.PlaceholderText = "Paste Sound ID here..."
InputBox.TextColor3 = Color3.new(1, 1, 1)
InputBox.Font = Enum.Font.Gotham
InputBox.TextScaled = true
InputBox.AutoLocalize = false
InputBox.Parent = BoomFrame
Instance.new("UICorner", InputBox).CornerRadius = UDim.new(0, 8)
AddRainbowGlow(InputBox, 2)

local VolLabel = Instance.new("TextLabel")
VolLabel.Size = UDim2.new(0, 120, 0, 30)
VolLabel.Position = UDim2.new(0, 20, 0, 110)
VolLabel.BackgroundTransparency = 1
VolLabel.Text = "🔊 VOLUME LEVEL:"
VolLabel.TextColor3 = Color3.new(1, 1, 1)
VolLabel.Font = Enum.Font.GothamBold
VolLabel.TextScaled = true
VolLabel.AutoLocalize = false
VolLabel.Parent = BoomFrame

VolNumMenu = Instance.new("TextLabel")
VolNumMenu.Size = UDim2.new(0, 80, 0, 30)
VolNumMenu.Position = UDim2.new(1, -100, 0, 110)
VolNumMenu.BackgroundTransparency = 1
VolNumMenu.Text = math.floor(MusicVolume * 100).."%"
VolNumMenu.TextColor3 = Color3.new(1, 1, 1)
VolNumMenu.Font = Enum.Font.GothamBold
VolNumMenu.TextScaled = true
VolNumMenu.TextXAlignment = Enum.TextXAlignment.Right
VolNumMenu.AutoLocalize = false
VolNumMenu.Parent = BoomFrame

local VolBG = Instance.new("Frame")
VolBG.Size = UDim2.new(1, -40, 0, 24)
VolBG.Position = UDim2.new(0, 20, 0, 145)
VolBG.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
VolBG.Parent = BoomFrame
Instance.new("UICorner", VolBG).CornerRadius = UDim.new(0, 12)
AddRainbowGlow(VolBG, 2)

VolFillMenu = Instance.new("Frame")
VolFillMenu.Size = UDim2.new(MusicVolume, 0, 1, 0)
VolFillMenu.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
VolFillMenu.Parent = VolBG
Instance.new("UICorner", VolFillMenu).CornerRadius = UDim.new(0, 12)

local SliderActive = false
VolBG.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
        SliderActive = true
    end
end)
UserInputService.InputEnded:Connect(function() SliderActive = false end)
UserInputService.InputChanged:Connect(function(Input)
    if SliderActive and Input.UserInputType == Enum.UserInputType.MouseMovement then
        local Pos = math.clamp((Input.Position.X - VolBG.AbsolutePosition.X) / VolBG.AbsoluteSize.X, 0, 1)
        UpdateVolume(Pos)
    end
end)

local PlayBtn = Instance.new("TextButton")
PlayBtn.Size = UDim2.new(0, 130, 0, 40)
PlayBtn.Position = UDim2.new(0, 20, 0, 190)
PlayBtn.BackgroundColor3 = Color3.fromRGB(25, 140, 255)
PlayBtn.Text = "▶ PLAY SOUND"
PlayBtn.TextColor3 = Color3.new(1, 1, 1)
PlayBtn.Font = Enum.Font.GothamBold
PlayBtn.TextScaled = true
PlayBtn.AutoLocalize = false
PlayBtn.Parent = BoomFrame
Instance.new("UICorner", PlayBtn).CornerRadius = UDim.new(0, 8)
AddRainbowGlow(PlayBtn, 2)

local StopBtn = Instance.new("TextButton")
StopBtn.Size = UDim2.new(0, 130, 0, 40)
StopBtn.Position = UDim2.new(0, 170, 0, 190)
StopBtn.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
StopBtn.Text = "⏹ STOP SOUND"
StopBtn.TextColor3 = Color3.new(1, 1, 1)
StopBtn.Font = Enum.Font.GothamBold
StopBtn.TextScaled = true
StopBtn.AutoLocalize = false
StopBtn.Parent = BoomFrame
Instance.new("UICorner", StopBtn).CornerRadius = UDim.new(0, 8)
AddRainbowGlow(StopBtn, 2)

local function CloseMenu() BoomUI:Destroy() end
PlayBtn.MouseButton1Click:Connect(function()
    if InputBox.Text ~= "" then PlaySound(InputBox.Text) end
end)
StopBtn.MouseButton1Click:Connect(function()
    if CurrentSound then CurrentSound:Destroy() end
end)
CloseBtnTop.MouseButton1Click:Connect(CloseMenu)
end

-- CONSOLE MENU local function OpenConsole() local ConsoleUI = Instance.new("ScreenGui") ConsoleUI.Name = "BLUE_CONSOLE" ConsoleUI.ResetOnSpawn = false ConsoleUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling ConsoleUI.Parent = PlayerGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 450, 0, 380)
Frame.Position = UDim2.new(0.5, -225, 0.5, -190)
Frame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
Frame.ClipsDescendants = false
Frame.Parent = ConsoleUI
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 12)
AddRainbowGlow(Frame, 5)

local CloseBtnTop = Instance.new("TextButton")
CloseBtnTop.Size = UDim2.new(0, 32, 0, 32)
CloseBtnTop.Position = UDim2.new(1, -37, 0, 6)
CloseBtnTop.BackgroundColor3 = Color3.fromRGB(170, 30, 30)
CloseBtnTop.Text = "✕"
CloseBtnTop.TextColor3 = Color3.new(1, 1, 1)
CloseBtnTop.Font = Enum.Font.GothamBold
CloseBtnTop.TextSize = 26
CloseBtnTop.AutoLocalize = false
CloseBtnTop.Parent = Frame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -50, 0, 35)
Title.Position = UDim2.new(0, 15, 0, 6)
Title.BackgroundTransparency = 1
Title.Text = "💻 CONSOLE"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.AutoLocalize = false
Title.Parent = Frame

local Output = Instance.new("TextLabel")
Output.Size = UDim2.new(1, -30, 0, 70)
Output.Position = UDim2.new(0, 15, 0, 45)
Output.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Output.Text = "System Ready | Paste script or type command"
Output.TextColor3 = Color3.fromRGB(0, 255, 120)
Output.Font = Enum.Font.Code
Output.TextScaled = true
Output.TextXAlignment = Enum.TextXAlignment.Left
Output.TextWrapped = true
Output.AutoLocalize = false
Instance.new("UICorner", Output).CornerRadius = UDim.new(0, 8)
Output.Parent = Frame

local InputBox = Instance.new("TextBox")
InputBox.Size = UDim2.new(1, -30, 0, 150)
InputBox.Position = UDim2.new(0, 15, 0, 125)
InputBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
InputBox.PlaceholderText = "Paste your script here..."
InputBox.TextColor3 = Color3.new(1, 1, 1)
InputBox.Font = Enum.Font.Code
InputBox.TextScaled = true
InputBox.MultiLine = true
InputBox.AutoLocalize = false
InputBox.Parent = Frame
Instance.new("UICorner", InputBox).CornerRadius = UDim.new(0, 8)
AddRainbowGlow(InputBox, 2)

local ExecuteBtn = Instance.new("TextButton")
ExecuteBtn.Size = UDim2.new(0, 120, 0, 40)
ExecuteBtn.Position = UDim2.new(0, 15, 0, 290)
ExecuteBtn.BackgroundColor3 = Color3.fromRGB(20, 150, 70)
ExecuteBtn.Text = "▶ EXECUTE"
ExecuteBtn.TextColor3 = Color3.new(1, 1, 1)
ExecuteBtn.Font = Enum.Font.GothamBold
ExecuteBtn.TextScaled = true
ExecuteBtn.AutoLocalize = false
ExecuteBtn.Parent = Frame
Instance.new("UICorner", ExecuteBtn).CornerRadius = UDim.new(0, 8)

local ClearBtn = Instance.new("TextButton")
ClearBtn.Size = UDim2.new(0, 120, 0, 40)
ClearBtn.Position = UDim2.new(0, 165, 0, 290)
ClearBtn.BackgroundColor3 = Color3.fromRGB(180, 120, 20)
ClearBtn.Text = "🗑️ CLEAR"
ClearBtn.TextColor3 = Color3.new(1, 1, 1)
ClearBtn.Font = Enum.Font.GothamBold
ClearBtn.TextScaled = true
ClearBtn.AutoLocalize = false
ClearBtn.Parent = Frame
Instance.new("UICorner", ClearBtn).CornerRadius = UDim.new(0, 8)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 120, 0, 40)
CloseBtn.Position = UDim2.new(0, 315, 0, 290)
CloseBtn.BackgroundColor3 = Color3.fromRGB(150, 30, 30)
CloseBtn.Text = "✕ CLOSE"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextScaled = true
CloseBtn.AutoLocalize = false
CloseBtn.Parent = Frame
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 8)

local function CloseConsole() ConsoleUI:Destroy() end
ExecuteBtn.MouseButton1Click:Connect(function()
    if InputBox.Text == "" then
        Output.Text = "⚠️ Nothing to run!"
        return
    end
    local RunFunc = loadstring or load
    if not RunFunc then
        Output.Text = "❌ Loadstring not supported by executor"
        return
    end
    local Success, ErrorMsg = pcall(RunFunc(InputBox.Text))
    Output.Text = Success and "✅ Script Executed Successfully!" or "❌ Error: "..tostring(ErrorMsg)
end)
ClearBtn.MouseButton1Click:Connect(function()
    InputBox.Text = ""
    Output.Text = "✅ Cleared!"
end)
CloseBtn.MouseButton1Click:Connect(CloseConsole)
CloseBtnTop.MouseButton1Click:Connect(CloseConsole)
end

-- MAIN UI local MainUI = Instance.new("ScreenGui") MainUI.Name = "BLUE_MODE_ESP" MainUI.ResetOnSpawn = false MainUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling MainUI.Parent = PlayerGui

local FULL_SIZE = UDim2.new(0, 680, 0, 105) local MIN_SIZE = UDim2.new(0, 50, 0, 50) local MainFrame = Instance.new("Frame") MainFrame.Size = FULL_SIZE MainFrame.Position = UDim2.new(0, 20, 0.5, -52) MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25) MainFrame.Active = true MainFrame.ClipsDescendants = false MainFrame.Parent = MainUI Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8) AddRainbowGlow(MainFrame, 5)

local DragHandle = Instance.new("Frame") DragHandle.Size = UDim2.new(1, -25, 0, 22) DragHandle.BackgroundColor3 = Color3.fromRGB(60, 140, 220) DragHandle.Active = true DragHandle.Parent = MainFrame AddRainbowGlow(DragHandle, 2)

local Title = Instance.new("TextLabel") Title.Size = UDim2.new(1, -110, 1, 0) Title.BackgroundTransparency = 1 Title.Text = "made by BLUE_MODE | DRAG HERE" Title.TextColor3 = Color3.new(1, 1, 1) Title.Font = Enum.Font.GothamBold Title.TextScaled = true Title.TextXAlignment = Enum.TextXAlignment.Left Title.AutoLocalize = false Title.Parent = DragHandle

local TimerLabel = Instance.new("TextLabel") TimerLabel.Size = UDim2.new(0, 100, 1, 0) TimerLabel.Position = UDim2.new(1, -105, 0, 0) TimerLabel.BackgroundTransparency = 1 TimerLabel.Text = "00:00:00 / 12:00:00" TimerLabel.TextColor3 = Color3.new(1, 1, 1) TimerLabel.Font = Enum.Font.GothamBold TimerLabel.TextScaled = true TimerLabel.TextXAlignment = Enum.TextXAlignment.Right TimerLabel.AutoLocalize = false TimerLabel.Parent = DragHandle

local MinimizeBtn = Instance.new("TextButton") MinimizeBtn.Size = UDim2.new(0, 22, 1, 0) MinimizeBtn.Position = UDim2.new(1, -22, 0, 0) MinimizeBtn.BackgroundColor3 = Color3.fromRGB(160, 40, 40) MinimizeBtn.Text = "❌" MinimizeBtn.TextColor3 = Color3.new(1, 1, 1) MinimizeBtn.Font = Enum.Font.GothamBold MinimizeBtn.TextScaled = true MinimizeBtn.AutoLocalize = false MinimizeBtn.Parent = MainFrame AddRainbowGlow(MinimizeBtn, 2)

-- BUTTONS local ESPBtn = Instance.new("TextButton") ESPBtn.Size = UDim2.new(0, 85, 0, 30) ESPBtn.Position = UDim2.new(0, 10, 0, 30) ESPBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40) ESPBtn.Text = "ESP: OFF" ESPBtn.TextColor3 = Color3.new(1, 1, 1) ESPBtn.Font = Enum.Font.GothamBold ESPBtn.TextScaled = true ESPBtn.AutoLocalize = false ESPBtn.Parent = MainFrame Instance.new("UICorner", ESPBtn).CornerRadius = UDim.new(0, 6) AddRainbowGlow(ESPBtn, 2)

local YouTubeBtn = Instance.new("TextButton") YouTubeBtn.Size = UDim2.new(0, 95, 0, 30) YouTubeBtn.Position = UDim2.new(0, 100, 0, 30) YouTubeBtn.BackgroundColor3 = Color3.fromRGB(200, 30, 30) YouTubeBtn.Text = "📺 YOUTUBE" YouTubeBtn.TextColor3 = Color3.new(1, 1, 1) YouTubeBtn.Font = Enum.Font.GothamBold YouTubeBtn.TextScaled = true YouTubeBtn.AutoLocalize = false YouTubeBtn.Parent = MainFrame Instance.new("UICorner", YouTubeBtn).CornerRadius = UDim.new(0, 6) AddRainbowGlow(YouTubeBtn, 2)

local MusicBtn = Instance.new("TextButton") MusicBtn.Size = UDim2.new(0, 90, 0, 30) MusicBtn.Position = UDim2.new(0, 200, 0, 30) MusicBtn.BackgroundColor3 = Color3.fromRGB(40, 80, 160) MusicBtn.Text = "🎵 MUSIC" MusicBtn.TextColor3 = Color3.new(1, 1, 1) MusicBtn.Font = Enum.Font.GothamBold MusicBtn.TextScaled = true MusicBtn.AutoLocalize = false MusicBtn.Parent = MainFrame Instance.new("UICorner", MusicBtn).CornerRadius = UDim.new(0, 6) AddRainbowGlow(MusicBtn, 2)

local LockBtn = Instance.new("TextButton") LockBtn.Size = UDim2.new(0, 90, 0, 30) LockBtn.Position = UDim2.new(0, 300, 0, 30) LockBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50) LockBtn.Text = "🔓 UNLOCKED" LockBtn.TextColor3 = Color3.new(1, 1, 1) LockBtn.Font = Enum.Font.GothamBold LockBtn.TextScaled = true LockBtn.AutoLocalize = false LockBtn.Parent = MainFrame Instance.new("UICorner", LockBtn).CornerRadius = UDim.new(0, 6) AddRainbowGlow(LockBtn, 2)

local ConsoleBtn = Instance.new("TextButton") ConsoleBtn.Size = UDim2.new(0, 110, 0, 30) ConsoleBtn.Position = UDim2.new(0, 400, 0, 30) ConsoleBtn.BackgroundColor3 = Color3.fromRGB(30, 120, 90) ConsoleBtn.Text = "💻 CONSOLE" ConsoleBtn.TextColor3 = Color3.new(1, 1, 1) ConsoleBtn.Font = Enum.Font.GothamBold ConsoleBtn.TextScaled = true ConsoleBtn.AutoLocalize = false ConsoleBtn.Parent = MainFrame Instance.new("UICorner", ConsoleBtn).CornerRadius = UDim.new(0, 6) AddRainbowGlow(ConsoleBtn, 2)

local ExitBtn = Instance.new("TextButton") ExitBtn.Size = UDim2.new(0, 90, 0, 30) ExitBtn.Position = UDim2.new(0, 520, 0, 30) ExitBtn.BackgroundColor3 = Color3.fromRGB(140, 20, 20) ExitBtn.Text = "🗑️ EXIT" ExitBtn.TextColor3 = Color3.new(1, 1, 1) ExitBtn.Font = Enum.Font.GothamBold ExitBtn.TextScaled = true ExitBtn.AutoLocalize = false ExitBtn.Parent = MainFrame Instance.new("UICorner", ExitBtn).CornerRadius = UDim.new(0, 6) AddRainbowGlow(ExitBtn, 2)

-- MAIN VOLUME SLIDER local VolLabelMain = Instance.new("TextLabel") VolLabelMain.Size = UDim2.new(0, 70, 0, 25) VolLabelMain.Position = UDim2.new(0, 10, 0, 65) VolLabelMain.BackgroundTransparency = 1 VolLabelMain.Text = "🔊 VOLUME:" VolLabelMain.TextColor3 = Color3.new(1, 1, 1) VolLabelMain.Font = Enum.Font.Gotham VolLabelMain.TextScaled = true VolLabelMain.TextXAlignment = Enum.TextXAlignment.Left VolLabelMain.AutoLocalize = false VolLabelMain.Parent = MainFrame

VolNumTextMain = Instance.new("TextLabel") VolNumTextMain.Size = UDim2.new(0, 45, 0, 25) VolNumTextMain.Position = UDim2.new(0, 85, 0, 65) VolNumTextMain.BackgroundTransparency = 1 VolNumTextMain.Text = math.floor(MusicVolume * 100).."%" VolNumTextMain.TextColor3 = Color3.new(1, 1, 1) VolNumTextMain.Font = Enum.Font.GothamBold VolNumTextMain.TextScaled = true VolNumTextMain.TextXAlignment = Enum.TextXAlignment.Right VolNumTextMain.AutoLocalize = false VolNumTextMain.Parent = MainFrame

local VolBGMain = Instance.new("Frame") VolBGMain.Size = UDim2.new(0, 150, 0, 18) VolBGMain.Position = UDim2.new(0, 135, 0, 67) VolBGMain.BackgroundColor3 = Color3.fromRGB(50, 50, 50) VolBGMain.Parent = MainFrame Instance.new("UICorner", VolBGMain).CornerRadius = UDim.new(0, 9) AddRainbowGlow(VolBGMain, 2)

VolFillMain = Instance.new("Frame") VolFillMain.Size = UDim2.new(MusicVolume, 0, 1, 0) VolFillMain.BackgroundColor3 = Color3.fromRGB(100, 100, 100) VolFillMain.Parent = VolBGMain Instance.new("UICorner", VolFillMain).CornerRadius = UDim.new(0, 9)

local SliderActiveMain = false VolBGMain.InputBegan:Connect(function(Input) if Input.UserInputType == Enum.UserInputType.MouseButton1 then SliderActiveMain = true end end) UserInputService.InputEnded:Connect(function() SliderActiveMain = false end) UserInputService.InputChanged:Connect(function(Input) if SliderActiveMain and Input.UserInputType == Enum.UserInputType.MouseMovement then local Pos = math.clamp((Input.Position.X - VolBGMain.AbsolutePosition.X) / VolBGMain.AbsoluteSize.X, 0, 1) VolFillMain.Size = UDim2.new(Pos, 0, 1, 0) UpdateVolume(Pos) end end)

-- DRAG SYSTEM local DragState = {Active = false, StartX = 0, StartY = 0, FrameX = 0, FrameY = 0} local function StartDrag(Input) if Buttons_Locked then return end if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then DragState.Active = true DragState.StartX = Input.Position.X DragState.StartY = Input.Position.Y DragState.FrameX = MainFrame.Position.X.Offset DragState.FrameY = MainFrame.Position.Y.Offset end end DragHandle.InputBegan:Connect(StartDrag) MainFrame.InputBegan:Connect(StartDrag) UserInputService.InputEnded:Connect(function(Input) if Input.UserInputType == Enum.UserInputType.MouseButton1 then DragState.Active = false end end) UserInputService.InputChanged:Connect(function(Input) if DragState.Active and not Buttons_Locked and Input.UserInputType == Enum.UserInputType.MouseMovement then MainFrame.Position = UDim2.new(0, DragState.FrameX + (Input.Position.X - DragState.StartX), 0, DragState.FrameY + (Input.Position.Y - DragState.StartY)) end end)

-- BUTTON FUNCTIONS ESPBtn.MouseButton1Click:Connect(function() ESP_Enabled = not ESP_Enabled ESPBtn.Text = ESP_Enabled and "ESP: ON" or "ESP: OFF" ESPBtn.BackgroundColor3 = ESP_Enabled and Color3.fromRGB(25, 120, 25) or Color3.fromRGB(40, 40, 40) if not ESP_Enabled then ClearESP() end end)

YouTubeBtn.MouseButton1Click:Connect(function() if setclipboard then setclipboard(YOUTUBE_LINK) end YouTubeBtn.Text = "✅ COPIED!" task.wait(1.5) YouTubeBtn.Text = "📺 YOUTUBE" end)

MusicBtn.MouseButton1Click:Connect(OpenBoomboxMenu) ConsoleBtn.MouseButton1Click:Connect(OpenConsole)

LockBtn.MouseButton1Click:Connect(function() Buttons_Locked = not Buttons_Locked LockBtn.Text = Buttons_Locked and "🔒 LOCKED" or "🔓 UNLOCKED" LockBtn.BackgroundColor3 = Buttons_Locked and Color3.fromRGB(180, 40, 40) or Color3.fromRGB(50, 50, 50) end)

MinimizeBtn.MouseButton1Click:Connect(function() IsMinimized = not IsMinimized if IsMinimized then MainFrame.Size = MIN_SIZE DragHandle.Visible = false ESPBtn.Visible = false YouTubeBtn.Visible = false MusicBtn.Visible = false LockBtn.Visible = false ConsoleBtn.Visible = false ExitBtn.Visible = false VolLabelMain.Visible = false VolNumTextMain.Visible = false VolBGMain.Visible = false MinimizeBtn.Text = "➕" else MainFrame.Size = FULL_SIZE DragHandle.Visible = true ESPBtn.Visible = true YouTubeBtn.Visible = true MusicBtn.Visible = true LockBtn.Visible = true ConsoleBtn.Visible = true ExitBtn.Visible = true VolLabelMain.Visible = true VolNumTextMain.Visible = true VolBGMain.Visible = true MinimizeBtn.Text = "❌" end end)

ExitBtn.MouseButton1Click:Connect(function() ClearESP() pcall(function() if CurrentSound then CurrentSound:Destroy() end end) MainUI:Destroy() getgenv().BlueMode_Loaded = nil end)

-- MAIN UPDATE LOOP RunService.Heartbeat:Connect(function(DeltaTime) if not MainUI or not MainUI.Parent then return end

-- USAGE TIMER
local Now = os.time()
UsedTime = UsedTime + math.max(0, Now - LastCheckTime)
LastCheckTime = Now
SaveData(SAVE_KEY_USED, UsedTime)
local Hours = math.floor(UsedTime / 3600)
local Mins = math.floor((UsedTime % 3600) / 60)
local Secs = math.floor(UsedTime % 60)
TimerLabel.Text = string.format("%02d:%02d:%02d / 12:00:00", Hours, Mins, Secs)

-- TIME LIMIT REACHED
if UsedTime >= USAGE_LIMIT then
    SaveData(SAVE_KEY_COOLDOWN, os.time() + COOLDOWN)
    pcall(function() delfile(SAVE_KEY_USED..".txt") end)
    ExitBtn:Fire()
    return
end

-- RAINBOW ANIMATION
Hue = (Hue + DeltaTime * 0.5) % 1
local RainbowColor = Color3.fromHSV(Hue, 1, 1)
for _, Element in pairs(GuiElements) do Element.Color = RainbowColor end
if VolFillMain then VolFillMain.BackgroundColor3 = RainbowColor end
if VolFillMenu then VolFillMenu.BackgroundColor3 = RainbowColor end

-- ESP SYSTEM
if not ESP_Enabled then return end
for _, Player in pairs(Players:GetPlayers()) do
    if Player == LocalPlayer then continue end
    local Character = Player.Character
    if not Character then continue end
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    if not Humanoid or Humanoid.Health <= 0 then
        pcall(function()
            if Character:FindFirstChild("BLUE_Outline") then Character.BLUE_Outline:Destroy() end
            if Character:FindFirstChild("FriendRainbowDot") then Character.FriendRainbowDot:Destroy() end
        end)
        continue
    end

    -- PLAYER HIGHLIGHT
    local Outline = Character:FindFirstChild("BLUE_Outline") or Instance.new("Highlight", Character)
    Outline.Name = "BLUE_Outline"
    Outline.FillTransparency = 1
    Outline.OutlineTransparency = 0
    Outline.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    Outline.Adornee = Character
    Outline.OutlineColor = RainbowColor

    -- FRIEND INDICATOR
    local IsFriend = false
    pcall(function() IsFriend = LocalPlayer:IsFriendsWith(Player.UserId) end)
    local Head = Character:FindFirstChild("Head")
    local FriendDot = Character:FindFirstChild("FriendRainbowDot")
    if IsFriend and Head then
        if not FriendDot then
            FriendDot = Instance.new("BillboardGui", Head)
            FriendDot.Name = "FriendRainbowDot"
            FriendDot.AlwaysOnTop = true
            FriendDot.Size = UDim2.new(0, 18, 0, 18)
            FriendDot.StudsOffset = Vector3.new(0, 1.8, 0)
            local Circle = Instance.new("Frame", FriendDot)
            Circle.Size = UDim2.new(1, 0, 1, 0)
            Circle.BackgroundColor3 = RainbowColor
            Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)
        else
            FriendDot.Frame.BackgroundColor3 = RainbowColor
        end
    elseif FriendDot then
        FriendDot:Destroy()
    end
end
end)

print("✅ BLUE MODE ESP LOADED SUCCESSFULLY!")
