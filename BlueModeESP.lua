-- ==============================================
-- BLUE MODE ESP | ALL DRAGGABLE + SEPARATE LOCKS
-- ✅ Main / Boombox / Console: Each Drag + Own Lock
-- ✅ Slider No Move Player | Friend Dots Fixed
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
local SAVE_KEY_USED = "BlueMode_UsedTime_v22"
local SAVE_KEY_COOLDOWN = "BlueMode_CooldownEnd_v22"
local SAVE_KEY_VOLUME = "BlueMode_Volume_v22"

-- DATA HELPERS
local function SaveData(key, value) pcall(function() writefile(key..".txt", tostring(value)) end) end
local function LoadData(key, default) local v=nil; pcall(function() v=readfile(key..".txt") end); return tonumber(v) or default end

-- CLEAR ALL ESP
local function ClearAllESP()
    for _,P in pairs(Players:GetPlayers()) do
        if P and P.Character then
            pcall(function()
                local Char = P.Character
                for _,Obj in pairs(Char:GetChildren()) do
                    if Obj.Name == "BLUE_Outline" or Obj.Name == "Highlight" then Obj:Destroy() end
                end
                for _,Obj in pairs(Char:GetChildren()) do
                    if Obj.Name == "FriendRainbowDot" or Obj:IsA("BillboardGui") then Obj:Destroy() end
                end
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

-- GLOBALS
local UsedTime = LoadData(SAVE_KEY_USED, 0)
local LastCheckTime = os.time()
local MusicVolume = LoadData(SAVE_KEY_VOLUME, 0.5)
local CurrentSound = nil
local VolNumTextMain, VolFillMain, VolFillMenu, VolNumMenu
local GuiElements = {}
local ESP_Enabled = false
local Hue = 0
local IsMinimized = false

-- AUTO CLEAR ON DEATH
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

-- ✅ REUSABLE DRAG + LOCK SYSTEM FOR ANY WINDOW
local function MakeDraggable(Frame, DragBar, LockBtnRef)
    local State = {Locked=false, Active=false, StartX=0, StartY=0, PosX=0, PosY=0}
    LockBtnRef.MouseButton1Click:Connect(function()
        State.Locked = not State.Locked
        if State.Locked then
            LockBtnRef.Text = "🔒"
            LockBtnRef.BackgroundColor3 = Color3.fromRGB(180,40,40)
        else
            LockBtnRef.Text = "🔓"
            LockBtnRef.BackgroundColor3 = Color3.fromRGB(50,50,50)
        end
    end)
    DragBar.InputBegan:Connect(function(Input)
        if State.Locked then return end
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            State.Active = true
            State.StartX = Input.Position.X
            State.StartY = Input.Position.Y
            State.PosX = Frame.Position.X.Offset
            State.PosY = Frame.Position.Y.Offset
        end
    end)
    UserInputService.InputEnded:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then State.Active = false end
    end)
    UserInputService.InputChanged:Connect(function(Input)
        if State.Active and not State.Locked then
            Frame.Position = UDim2.new(0, State.PosX + (Input.Position.X - State.StartX), 0, State.PosY + (Input.Position.Y - State.StartY))
        end
    end)
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
    ErrorText.TextColor3 = Color3.fromRGB(1,1,1)
    ErrorText.Font = Enum.Font.Gotham
    ErrorText.TextScaled = true
    ErrorText.TextWrapped = true
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
    local Pct = math.floor(MusicVolume*100+0.5).."%"
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

-- BOOMBOX MENU (DRAGGABLE + OWN LOCK)
local CurrentBoomboxUI = nil
local function ToggleBoomboxMenu()
    if CurrentBoomboxUI then CurrentBoomboxUI:Destroy(); CurrentBoomboxUI=nil; return end
    local BoomUI = Instance.new("ScreenGui")
    BoomUI.Name = "BLUE_BOOMBOX_MENU"
    BoomUI.ResetOnSpawn = false
    BoomUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    BoomUI.Parent = PlayerGui
    CurrentBoomboxUI = BoomUI
    local BoomFrame = Instance.new("Frame")
    BoomFrame.Size = UDim2.new(0,320,0,265)
    BoomFrame.Position = UDim2.new(0.5,-160,0.5,-132)
    BoomFrame.BackgroundColor3 = Color3.fromRGB(22,22,22)
    BoomFrame.Parent = BoomUI
    Instance.new("UICorner", BoomFrame).CornerRadius = UDim.new(0,12)
    AddRainbowGlow(BoomFrame,4)
    -- Drag Bar + Lock (PER WINDOW)
    local DragBar = Instance.new("TextButton")
    DragBar.Size = UDim2.new(1,-60,0,28)
    DragBar.Position = UDim2.new(0,5,0,5)
    DragBar.BackgroundColor3 = Color3.fromRGB(60,140,220)
    DragBar.Active = true
    DragBar.Text = "🎵 BOOMBOX | DRAG HERE"
    DragBar.TextColor3 = Color3.new(1,1,1)
    DragBar.Font = Enum.Font.GothamBold
    DragBar.TextScaled = true
    DragBar.TextXAlignment = Enum.TextXAlignment.Left
    DragBar.Parent = BoomFrame
    AddRainbowGlow(DragBar,2)
    local LockBtn = Instance.new("TextButton")
    LockBtn.Size = UDim2.new(0,28,0,28)
    LockBtn.Position = UDim2.new(1,-58,0,5)
    LockBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    LockBtn.Text = "🔓"
    LockBtn.TextColor3 = Color3.new(1,1,1)
    LockBtn.Font = Enum.Font.GothamBold
    LockBtn.TextScaled = true
    LockBtn.Parent = BoomFrame
    Instance.new("UICorner", LockBtn).CornerRadius = UDim.new(0,6)
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0,28,0,28)
    CloseBtn.Position = UDim2.new(1,-30,0,5)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(170,30,30)
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.new(1,1,1)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextScaled = true
    CloseBtn.Parent = BoomFrame
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0,6)
    CloseBtn.MouseButton1Click:Connect(function() ToggleBoomboxMenu() end)
    MakeDraggable(BoomFrame, DragBar, LockBtn)
    -- Rest of Boombox Content
    local Input = Instance.new("TextBox")
    Input.Size = UDim2.new(1,-40,0,45)
    Input.Position = UDim2.new(0,20,0,40)
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
    VolLabel.Position = UDim2.new(0,20,0,95)
    VolLabel.BackgroundTransparency = 1
    VolLabel.Text = "🔊 VOLUME LEVEL:"
    VolLabel.TextColor3 = Color3.new(1,1,1)
    VolLabel.Font = Enum.Font.GothamBold
    VolLabel.TextScaled = true
    VolLabel.Parent = BoomFrame
    VolNumMenu = Instance.new("TextLabel")
    VolNumMenu.Size = UDim2.new(0,80,0,30)
    VolNumMenu.Position = UDim2.new(1,-100,0,95)
    VolNumMenu.BackgroundTransparency = 1
    VolNumMenu.Text = math.floor(MusicVolume*100+0.5).."%"
    VolNumMenu.TextColor3 = Color3.new(1,1,1)
    VolNumMenu.Font = Enum.Font.GothamBold
    VolNumMenu.TextScaled = true
    VolNumMenu.Parent = BoomFrame
    local VolBG = Instance.new("Frame")
    VolBG.Size = UDim2.new(1,-40,0,24)
    VolBG.Position = UDim2.new(0,20,0,130)
    VolBG.BackgroundColor3 = Color3.fromRGB(50,50,50)
    VolBG.Parent = BoomFrame
    Instance.new("UICorner", VolBG).CornerRadius = UDim.new(0,12)
    AddRainbowGlow(VolBG,2)
    VolFillMenu = Instance.new("Frame")
    VolFillMenu.Size = UDim2.new(MusicVolume,0,1,0)
    VolFillMenu.BackgroundColor3 = Color3.fromRGB(100,100,100)
    VolFillMenu.Parent = VolBG
    Instance.new("UICorner", VolFillMenu).CornerRadius = UDim.new(0,12)
    -- Fixed Slider
    local SliderActive = false
    VolBG.InputBegan:Connect(function(i) if (i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch) then SliderActive=true; i:CaptureFocus() end end)
    UserInputService.InputEnded:Connect(function(i) if (i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch) then SliderActive=false end end)
    UserInputService.InputChanged:Connect(function(i,gpe)
        if SliderActive and not gpe and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
            local rel = math.clamp((i.Position.X-VolBG.AbsolutePosition.X)/VolBG.AbsoluteSize.X,0,1)
            UpdateVolume(rel); i:ProcessEvent(false)
        end
    end)
    local PlayBtn = Instance.new("TextButton")
    PlayBtn.Size = UDim2.new(0,130,0,40)
    PlayBtn.Position = UDim2.new(0,20,0,175)
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
    StopBtn.Position = UDim2.new(0,170,0,175)
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

-- CONSOLE MENU (DRAGGABLE + OWN LOCK)
local CurrentConsoleUI = nil
local function ToggleConsole()
    if CurrentConsoleUI then CurrentConsoleUI:Destroy(); CurrentConsoleUI=nil; return end
    local ConsoleUI = Instance.new("ScreenGui")
    ConsoleUI.Name = "BLUE_CONSOLE"
    ConsoleUI.ResetOnSpawn = false
    ConsoleUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ConsoleUI.Parent = PlayerGui
    CurrentConsoleUI = ConsoleUI
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0,450,0,340)
    Frame.Position = UDim2.new(0.5,-225,0.5,-170)
    Frame.BackgroundColor3 = Color3.fromRGB(22,22,22)
    Frame.Parent = ConsoleUI
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0,12)
    AddRainbowGlow(Frame,5)
    -- Drag Bar + Lock (PER WINDOW)
    local DragBar = Instance.new("TextButton")
    DragBar.Size = UDim2.new(1,-60,0,28)
    DragBar.Position = UDim2.new(0,5,0,5)
    DragBar.BackgroundColor3 = Color3.fromRGB(60,140,220)
    DragBar.Active = true
    DragBar.Text = "💻 CONSOLE | DRAG HERE"
    DragBar.TextColor3 = Color3.new(1,1,1)
    DragBar.Font = Enum.Font.GothamBold
    DragBar.TextScaled = true
    DragBar.TextXAlignment = Enum.TextXAlignment.Left
    DragBar.Parent = Frame
    AddRainbowGlow(DragBar,2)
    local LockBtn = Instance.new("TextButton")
    LockBtn.Size = UDim2.new(0,28,0,28)
    LockBtn.Position = UDim2.new(1,-58,0,5)
    LockBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    LockBtn.Text = "🔓"
    LockBtn.TextColor3 = Color3.new(1,1,1)
    LockBtn.Font = Enum.Font.GothamBold
    LockBtn.TextScaled = true
    LockBtn.Parent = Frame
    Instance.new("UICorner", LockBtn).CornerRadius = UDim.new(0,6)
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0,28,0,28)
    CloseBtn.Position = UDim2.new(1,-30,0,5)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(170,30,30)
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.new(1,1,1)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextScaled = true
    CloseBtn.Parent = Frame
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0,6)
    CloseBtn.MouseButton1Click:Connect(function() ToggleConsole() end)
    MakeDraggable(Frame, DragBar, LockBtn)
    -- Console Content
    local Output = Instance.new("TextLabel")
    Output.Size = UDim2.new(1,-30,0,40)
    Output.Position = UDim2.new(0,15,0,40)
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
    Input.Position = UDim2.new(0,15,0,85)
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
    ExecBtn.Position = UDim2.new(0,15,0,230)
    ExecBtn.BackgroundColor3 = Color3.fromRGB(20,150,70)
    ExecBtn.Text = "▶ EXECUTE"
    ExecBtn.TextColor3 = Color3.new(1,1,1)
    ExecBtn.Font = Enum.Font.GothamBold
    ExecBtn.TextScaled = true
    ExecBtn.Parent = Frame
    Instance.new("UICorner", ExecBtn).CornerRadius = UDim.new(0,8)
    local ClearBtn = Instance.new("TextButton")
    ClearBtn.Size = UDim2.new(0,120,0,40)
    ClearBtn.Position = UDim2.new(0,150,0,230)
    ClearBtn.BackgroundColor3 = Color3.fromRGB(180,120,20)
    ClearBtn.Text = "🗑️ CLEAR"
    ClearBtn.TextColor3 = Color3.new(1,1,1)
    ClearBtn.Font = Enum.Font.GothamBold
    ClearBtn.TextScaled = true
    ClearBtn.Parent = Frame
    Instance.new("UICorner", ClearBtn).CornerRadius = UDim.new(0,8)
    ExecBtn.MouseButton1Click:Connect(function()
        local Code = Input.Text; if Code=="" then Output.Text="⚠️ Nothing to run!" return end
        local Compile = loadstring or load; if not Compile then ShowErrorPopup("Executor missing loadstring"); return end
        local F,E = Compile(Code); if not F then ShowErrorPopup("Syntax Error:\n"..tostring(E)); return end
        local Ok,Re = pcall(F); if not Ok then ShowErrorPopup("Runtime Error:\n"..tostring(Re)); return end
        Output.Text = "✅ Executed successfully!"
    end)
    ClearBtn.MouseButton1Click:Connect(function() Input.Text=""; Output.Text="✅ Cleared!" end)
end

-- MAIN UI
local FULL_SIZE = UDim2.new(0,680,0,120)
local MINI_SIZE = UDim2.new(0,110,0,36)
local MainUI = Instance.new("ScreenGui")
MainUI.Name = "BLUE_MODE_ESP"
MainUI.ResetOnSpawn = false
MainUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
MainUI.Parent = PlayerGui
local MainFrame = Instance.new("Frame")
MainFrame.Size = FULL_SIZE
MainFrame.Position = UDim2.new(0,20,0.5,-60)
MainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
MainFrame.Active = true
MainFrame.ClipsDescendants = false
MainFrame.Parent = MainUI
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,8)
AddRainbowGlow(MainFrame,5)
-- Main Drag Bar + Own Lock
local MainDragBar = Instance.new("TextButton")
MainDragBar.Size = UDim2.new(1,-90,0,28)
MainDragBar.Position = UDim2.new(0,5,0,5)
MainDragBar.BackgroundColor3 = Color3.fromRGB(60,140,220)
MainDragBar.Active = true
MainDragBar.Text = "made by BLUE_MODE | DRAG HERE"
MainDragBar.TextColor3 = Color3.new(1,1,1)
MainDragBar.Font = Enum.Font.GothamBold
MainDragBar.TextScaled = true
MainDragBar.TextXAlignment = Enum.TextXAlignment.Left
MainDragBar.Parent = MainFrame
AddRainbowGlow(MainDragBar,2)
local MainLockBtn = Instance.new("TextButton")
MainLockBtn.Size = UDim2.new(0,28,0,28)
MainLockBtn.Position = UDim2.new(1,-88,0,5)
MainLockBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
MainLockBtn.Text = "🔓"
MainLockBtn.TextColor3 = Color3.new(1,1,1)
MainLockBtn.Font = Enum.Font.GothamBold
MainLockBtn.TextScaled = true
MainLockBtn.Parent = MainFrame
Instance.new("UICorner", MainLockBtn).CornerRadius = UDim.new(0,6)
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0,28,0,28)
MinBtn.Position = UDim2.new(1,-57,0,5)
MinBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
MinBtn.Text = "➖"
MinBtn.TextColor3 = Color3.new(1,1,1)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextScaled = true
MinBtn.Parent = MainFrame
AddRainbowGlow(MinBtn,2)
MakeDraggable(MainFrame, MainDragBar, MainLockBtn)
-- Timer
local TimerLabel = Instance.new("TextLabel")
TimerLabel.Size = UDim2.new(0,120,1,0)
TimerLabel.Position = UDim2.new(1,-210,0,0)
TimerLabel.BackgroundTransparency = 1
TimerLabel.Text = "00:00:00 / 12:00"
TimerLabel.TextColor3 = Color3.new(1,1,1)
TimerLabel.Font = Enum.Font.GothamBold
TimerLabel.TextScaled = true
TimerLabel.TextXAlignment = Enum.TextXAlignment.Right
TimerLabel.Parent = MainDragBar
-- Buttons
local ESPBtn = Instance.new("TextButton")
ESPBtn.Size = UDim2.new(0,85,0,30)
ESPBtn.Position = UDim2.new(0,10,0,38)
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
YouTubeBtn.Position = UDim2.new(0,100,0,38)
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
MusicBtn.Position = UDim2.new(0,200,0,38)
MusicBtn.BackgroundColor3 = Color3.fromRGB(40,80,160)
MusicBtn.Text = "🎵 MUSIC"
MusicBtn.TextColor3 = Color3.new(1,1,1)
MusicBtn.Font = Enum.Font.GothamBold
MusicBtn.TextScaled = true
MusicBtn.Parent = MainFrame
Instance.new("UICorner", MusicBtn).CornerRadius = UDim.new(0,6)
AddRainbowGlow(MusicBtn,2)
local ConsoleBtn = Instance.new("TextButton")
ConsoleBtn.Size = UDim2.new(0,110,0,30)
ConsoleBtn.Position = UDim2.new(0,300,0,38)
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
ExitBtn.Position = UDim2.new(0,420,0,38)
ExitBtn.BackgroundColor3 = Color3.fromRGB(140,20,20)
ExitBtn.Text = "🗑️ EXIT"
ExitBtn.TextColor3 = Color3.new(1,1,1)
ExitBtn.Font = Enum.Font.GothamBold
ExitBtn.TextScaled = true
ExitBtn.Parent = MainFrame
Instance.new("UICorner", ExitBtn).CornerRadius = UDim.new(0,6)
AddRainbowGlow(ExitBtn,2)
-- Main Volume Slider (Fixed)
local VolLabelMain = Instance.new("TextLabel")
VolLabelMain.Size = UDim2.new(0,70,0,25)
VolLabelMain.Position = UDim2.new(0,10,0,72)
VolLabelMain.BackgroundTransparency = 1
VolLabelMain.Text = "🔊 VOL:"
VolLabelMain.TextColor3 = Color3.new(1,1,1)
VolLabelMain.Font = Enum.Font.Gotham
VolLabelMain.TextScaled = true
VolLabelMain.Parent = MainFrame
VolNumTextMain = Instance.new("TextLabel")
VolNumTextMain.Size = UDim2.new(0,45,0,25)
VolNumTextMain.Position = UDim2.new(0,85,0,72)
VolNumTextMain.BackgroundTransparency = 1
VolNumTextMain.Text = math.floor(MusicVolume*100+0.5).."%"
VolNumTextMain.TextColor3 = Color3.new(1,1,1)
VolNumTextMain.Font = Enum.Font.GothamBold
VolNumTextMain.TextScaled = true
VolNumTextMain.Parent = MainFrame
local VolBGMain = Instance.new("Frame")
VolBGMain.Size = UDim2.new(0,150,0,18)
VolBGMain.Position = UDim2.new(0,135,0,74)
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
VolBGMain.InputBegan:Connect(function(i) if (i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch) then SliderActiveMain=true; i:CaptureFocus() end end)
UserInputService.InputEnded:Connect(function(i) if (i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch) then SliderActiveMain=false end end)
UserInputService.InputChanged:Connect(function(i,gpe)
    if SliderActiveMain and not gpe and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
        local rel = math.clamp((i.Position.X-VolBGMain.AbsolutePosition.X)/VolBGMain.AbsoluteSize.X,0,1)
        VolFillMain.Size = UDim2.new(rel,0,1,0); UpdateVolume(rel); i:ProcessEvent(false)
    end
end)
-- Minimize
MinBtn.MouseButton1Click:Connect(function()
    IsMinimized = not IsMinimized
    if IsMinimized then
        MainFrame.Size = MINI_SIZE
        ESPBtn.Visible=false; YouTubeBtn.Visible=false; MusicBtn.Visible=false; ConsoleBtn.Visible=false; ExitBtn.Visible=false
        VolLabelMain.Visible=false; VolNumTextMain.Visible=false; VolBGMain.Visible=false; MainDragBar.Text=""
        MainLockBtn.Visible=false; TimerLabel.Visible=false; MinBtn.Text="➕"
    else
        MainFrame.Size = FULL_SIZE
        ESPBtn.Visible=true; YouTubeBtn.Visible=true; MusicBtn.Visible=true; ConsoleBtn.Visible=true; ExitBtn.Visible=true
        VolLabelMain.Visible=true; VolNumTextMain.Visible=true; VolBGMain.Visible=true; MainDragBar.Text="made by BLUE_MODE | DRAG HERE"
        MainLockBtn.Visible=true; TimerLabel.Visible=true; MinBtn.Text="➖"
    end
end)
-- Button Actions
ESPBtn.MouseButton1Click:Connect(function()
    ESP_Enabled = not ESP_Enabled
    ESPBtn.Text = ESP_Enabled and "ESP: ON" or "ESP: OFF"
    ESPBtn.BackgroundColor3 = ESP_Enabled and Color3.fromRGB(25,120,25) or Color3.fromRGB(40,40,40)
    if not ESP_Enabled then ClearAllESP() end
end)
YouTubeBtn.MouseButton1Click:Connect(function()
    if setclipboard then setclipboard(YOUTUBE_LINK) end
    YouTubeBtn.Text = "✅ COPIED!"
    task.wait(1.5); YouTubeBtn.Text = "📺 YT"
end)
MusicBtn.MouseButton1Click:Connect(ToggleBoomboxMenu)
ConsoleBtn.MouseButton1Click:Connect(ToggleConsole)
ExitBtn.MouseButton1Click:Connect(function()
    ClearAllESP(); pcall(function() if CurrentSound then CurrentSound:Destroy() end end)
    if CurrentBoomboxUI then CurrentBoomboxUI:Destroy() end
    if CurrentConsoleUI then CurrentConsoleUI:Destroy() end
    MainUI:Destroy(); getgenv().BlueMode_Loaded = nil
end)

SetupDeathCheck()

-- MAIN LOOP
RunService.Heartbeat:Connect(function(Delta)
    if not MainUI or not MainUI.Parent then return end
    -- Timer
    local Now = os.time(); UsedTime = UsedTime + math.max(0, Now - LastCheckTime); LastCheckTime = Now
    SaveData(SAVE_KEY_USED, UsedTime); local Rem = math.max(0, USAGE_LIMIT - UsedTime)
    local h,m,s = math.floor(Rem/3600), math.floor((Rem%3600)/60), Rem%60
    TimerLabel.Text = string.format("%02d:%02d:%02d / 12:00",h,m,s)
    if Rem <=0 then SaveData(SAVE_KEY_COOLDOWN, os.time()+COOLDOWN); pcall(function() delfile(SAVE_KEY_USED..".txt") end); ExitBtn:Fire(); return end
    -- Rainbow
    Hue = (Hue + Delta*0.5) %1; local Rainbow = Color3.fromHSV(Hue,1,1)
    for _,e in pairs(GuiElements) do e.Color = Rainbow end
    if VolFillMain then VolFillMain.BackgroundColor3 = Rainbow end
    if VolFillMenu then VolFillMenu.BackgroundColor3 = Rainbow end
    TimerLabel.TextColor3 = Rainbow
    -- ESP
    if not ESP_Enabled then return end
    for _,P in pairs(Players:GetPlayers()) do
        if P==LocalPlayer then continue end; local Char = P.Character
        if not Char then pcall(function() if Char then Char:FindFirstChild("BLUE_Outline"):Destroy(); Char:FindFirstChild("FriendRainbowDot"):Destroy() end end); continue end
        local Hum = Char:FindFirstChildOfClass("Humanoid")
        if not Hum or Hum.Health<=0 then pcall(function() Char:FindFirstChild("BLUE_Outline"):Destroy(); Char:FindFirstChild("FriendRainbowDot"):Destroy() end); continue end
        -- Outline
        local Outline = Char:FindFirstChild("BLUE_Outline") or Instance.new("Highlight",Char)
        Outline.Name = "BLUE_Outline"; Outline.FillTransparency=1; Outline.OutlineTransparency=0
        Outline.OutlineColor=Rainbow; Outline.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
        -- Friend Dot
        local IsFriend = false; pcall(function() IsFriend = LocalPlayer:IsFriendsWith(P.UserId) end)
        local Head = Char:FindFirstChild("Head"); local Dot = Char:FindFirstChild("FriendRainbowDot")
        if IsFriend and Head then
            if not Dot then
                Dot = Instance.new("BillboardGui",Head); Dot.Name="FriendRainbowDot"; Dot.AlwaysOnTop=true
                Dot.Size=UDim2.new(0,16,0,16); Dot.StudsOffset=Vector3.new(0,2,0)
                local Circ = Instance.new("Frame",Dot); Circ.Name="DotCircle"; Circ.Size=UDim2.new(1,0,1,0)
                Circ.BackgroundColor3=Rainbow; Circ.AnchorPoint=Vector2.new(0.5,0.5); Circ.Position=UDim2.new(0.5,0,0.5,0.5)
                Instance.new("UICorner",Circ).CornerRadius=UDim.new(1,0)
            else if Dot:FindFirstChild("DotCircle") then Dot.DotCircle.BackgroundColor3=Rainbow end end
        elseif Dot then Dot:Destroy() end
    end
end)

print("✅ ALL SET: Every Window Draggable + Own Lock/Unlock | All Features Kept")
