-- ==============================================
-- BLUE MODE ESP | SHRINK = ESP STAYS ACTIVE
-- ✅ Shrink GUI: ESP DOES NOT STOP / STAYS RUNNING
-- ✅ ESP ONLY STOPS WHEN: ESP OFF BUTTON / EXIT
-- ✅ Timer No Block Drag | Full Rainbow + Cleanup
-- ✅ All Windows Own Lock/Drag
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
local SAVE_KEY_USED = "BlueMode_UsedTime_v29"
local SAVE_KEY_COOLDOWN = "BlueMode_CooldownEnd_v29"
local SAVE_KEY_VOLUME = "BlueMode_Volume_v29"

-- DATA HELPERS
local function SaveData(key, value) pcall(function() writefile(key..".txt", tostring(value)) end) end
local function LoadData(key, default) local v=nil; pcall(function() v=readfile(key..".txt") end); return tonumber(v) or default end

-- ✅ COMPLETE ESP CLEANUP (RUNS ONLY ON ESP OFF / EXIT)
local function ClearAllESP()
    for _,P in pairs(Players:GetPlayers()) do
        if P and P.Character then
            pcall(function()
                local Char = P.Character
                for _,Obj in pairs(Char:GetChildren()) do
                    if Obj.Name == "BLUE_Outline" or Obj.Name == "Highlight" then Obj:Destroy() end
                end
                for _,Obj in pairs(Char:GetChildren()) do
                    if Obj.Name == "FriendRainbowDot" or Obj.Name == "DotCircle" or Obj:IsA("BillboardGui") then Obj:Destroy() end
                end
                local Head = Char:FindFirstChild("Head")
                if Head then
                    for _,Obj in pairs(Head:GetChildren()) do
                        if Obj.Name == "FriendRainbowDot" or Obj.Name == "DotCircle" then Obj:Destroy() end
                    end
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
local ESP_Enabled = false -- ✅ NEVER CHANGED WHEN MINIMIZING
local Hue = 0
local IsMinimized = false
local ESPBtn, MainUI, MainFrame, TimerLabel, MinBtn, ExitBtn
local CurrentBoomboxUI, CurrentConsoleUI

-- AUTO CLEAR ON DEATH
local function SetupDeathCheck()
    local function CheckCharacter(Char)
        if not Char then return end
        local Hum = Char:WaitForChild("Humanoid", 10)
        if not Hum then return end
        Hum.Died:Connect(function()
            if ESP_Enabled then
                ESP_Enabled = false
                ESPBtn.Text = "ESP: OFF"
                ESPBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
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

-- DRAG + LOCK SYSTEM
local function MakeDraggable(Frame, DragBar, LockBtnRef)
    local State = {Locked=false, Active=false, StartX=0, StartY=0, PosX=0, PosY=0}
    LockBtnRef.MouseButton1Click:Connect(function()
        State.Locked = not State.Locked
        LockBtnRef.Text = State.Locked and "🔒" or "🔓"
        LockBtnRef.BackgroundColor3 = State.Locked and Color3.fromRGB(180,40,40) or Color3.fromRGB(50,50,50)
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

-- BOOMBOX MENU
local CurrentBoomboxUI = nil
local function ToggleBoomboxMenu()
    if CurrentBoomboxUI then CurrentBoomboxUI:Destroy(); CurrentBoomboxUI=nil; return end
    CurrentBoomboxUI = Instance.new("ScreenGui")
    CurrentBoomboxUI.Name = "BLUE_BOOMBOX_MENU"
    CurrentBoomboxUI.ResetOnSpawn = false
    CurrentBoomboxUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    CurrentBoomboxUI.Parent = PlayerGui
    local BoomFrame = Instance.new("Frame")
    BoomFrame.Size = UDim2.new(0,320,0,265)
    BoomFrame.Position = UDim2.new(0.5,-160,0.5,-132)
    BoomFrame.BackgroundColor3 = Color3.fromRGB(22,22,22)
    BoomFrame.Parent = CurrentBoomboxUI
    Instance.new("UICorner", BoomFrame).CornerRadius = UDim.new(0,12)
    AddRainbowGlow(BoomFrame,4)
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
    local SliderActive = false
    VolBG.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then SliderActive=true; i:CaptureFocus() end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then SliderActive=false end end)
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

-- CONSOLE MENU
local CurrentConsoleUI = nil
local function ToggleConsole()
    if CurrentConsoleUI then CurrentConsoleUI:Destroy(); CurrentConsoleUI=nil; return end
    CurrentConsoleUI = Instance.new("ScreenGui")
    CurrentConsoleUI.Name = "BLUE_CONSOLE"
    CurrentConsoleUI.ResetOnSpawn = false
    CurrentConsoleUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    CurrentConsoleUI.Parent = PlayerGui
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0,450,0,340)
    Frame.Position = UDim2.new(0.5,-225,0.5,-170)
    Frame.BackgroundColor3 = Color3.fromRGB(22,22,22)
    Frame.Parent = CurrentConsoleUI
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0,12)
    AddRainbowGlow(Frame,5)
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
    local Output = Instance.new("TextLabel")
    Output.Size = UDim2.new(1,-30,0,40)
    Output.Position = UDim2.new(0,15,0,40)
    Output.BackgroundTransparency = 1
    Output.Text = "Paste code below:"
    Output.TextColor3 = Color3.fromRGB(0,255,120)
    Output.Font = Enum.Font.Code
    Output.TextScaled = true
    Output.TextXAlignment = Enum.TextXAlignment.Left
    Output.Parent = Frame
    local Input = Instance.new("TextBox")
    Input.Size = UDim2.new(1,-30,0,150)
    Input.Position = UDim2.new(0,15,0,90)
    Input.BackgroundColor3 = Color3.fromRGB(35,35,35)
    Input.PlaceholderText = "Enter script here..."
    Input.TextColor3 = Color3.new(1,1,1)
    Input.Font = Enum.Font.Code
    Input.TextScaled = true
    Input.MultiLine = true
    Input.Parent = Frame
    Instance.new("UICorner", Input).CornerRadius = UDim.new(0,8)
    AddRainbowGlow(Input,2)
    local RunBtn = Instance.new("TextButton")
    RunBtn.Size = UDim2.new(0,120,0,40)
    RunBtn.Position = UDim2.new(0,15,0,250)
    RunBtn.BackgroundColor3 = Color3.fromRGB(20,150,70)
    RunBtn.Text = "▶ RUN"
    RunBtn.TextColor3 = Color3.new(1,1,1)
    RunBtn.Font = Enum.Font.GothamBold
    RunBtn.TextScaled = true
    RunBtn.Parent = Frame
    Instance.new("UICorner", RunBtn).CornerRadius = UDim.new(0,8)
    AddRainbowGlow(RunBtn,2)
    local ClearBtn = Instance.new("TextButton")
    ClearBtn.Size = UDim2.new(0,120,0,40)
    ClearBtn.Position = UDim2.new(0,155,0,250)
    ClearBtn.BackgroundColor3 = Color3.fromRGB(180,120,20)
    ClearBtn.Text = "🗑️ CLEAR"
    ClearBtn.TextColor3 = Color3.new(1,1,1)
    ClearBtn.Font = Enum.Font.GothamBold
    ClearBtn.TextScaled = true
    ClearBtn.Parent = Frame
    Instance.new("UICorner", ClearBtn).CornerRadius = UDim.new(0,8)
    AddRainbowGlow(ClearBtn,2)
    RunBtn.MouseButton1Click:Connect(function()
        local Code = Input.Text
        if Code == "" then return end
        local Func,Err = loadstring(Code)
        if Func then
            task.spawn(Func)
            Output.Text = "✅ Code executed!"
        else
            Output.Text = "❌ Error: "..Err
        end
    end)
    ClearBtn.MouseButton1Click:Connect(function() Input.Text="" Output.Text="Paste code below:" end)
end

-- ====================== MAIN GUI ======================
local FULL_SIZE = UDim2.new(0,680,0,120)
local MINI_SIZE = UDim2.new(0,240,0,50) -- Larger mini for easy drag

MainUI = Instance.new("ScreenGui")
MainUI.Name = "BLUE_MODE_ESP"
MainUI.ResetOnSpawn = false
MainUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
MainUI.Parent = PlayerGui

MainFrame = Instance.new("Frame")
MainFrame.Size = FULL_SIZE
MainFrame.Position = UDim2.new(0,20,0.5,-60)
MainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
MainFrame.Parent = MainUI
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,8)
AddRainbowGlow(MainFrame,5)

-- DRAG BAR (NO OVERLAP)
local MainDragBar = Instance.new("TextButton")
MainDragBar.Size = UDim2.new(1,-150,0,30)
MainDragBar.Position = UDim2.new(0,5,0,5)
MainDragBar.BackgroundColor3 = Color3.fromRGB(60,140,220)
MainDragBar.Active = true
MainDragBar.Text = "🔵 BLUE MODE ESP | DRAG HERE"
MainDragBar.TextColor3 = Color3.new(1,1,1)
MainDragBar.Font = Enum.Font.GothamBold
MainDragBar.TextScaled = true
MainDragBar.TextXAlignment = Enum.TextXAlignment.Left
MainDragBar.Parent = MainFrame
AddRainbowGlow(MainDragBar,2)

-- TIMER (SEPARATE, NEVER COVERS DRAG)
TimerLabel = Instance.new("TextLabel")
TimerLabel.Size = UDim2.new(0,110,0,30)
TimerLabel.Position = UDim2.new(1,-115,0,5)
TimerLabel.BackgroundTransparency = 1
TimerLabel.Text = "00:00:00 / 12:00"
TimerLabel.TextColor3 = Color3.new(1,1,1)
TimerLabel.Font = Enum.Font.GothamBold
TimerLabel.TextScaled = true
TimerLabel.TextXAlignment = Enum.TextXAlignment.Right
TimerLabel.Parent = MainFrame

-- LOCK BUTTON
local MainLockBtn = Instance.new("TextButton")
MainLockBtn.Size = UDim2.new(0,30,0,30)
MainLockBtn.Position = UDim2.new(1,-145,0,5)
MainLockBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
MainLockBtn.Text = "🔓"
MainLockBtn.TextColor3 = Color3.new(1,1,1)
MainLockBtn.Font = Enum.Font.GothamBold
MainLockBtn.TextScaled = true
MainLockBtn.Parent = MainFrame
Instance.new("UICorner", MainLockBtn).CornerRadius = UDim.new(0,6)

-- MINIMIZE BUTTON
MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0,30,0,30)
MinBtn.Position = UDim2.new(1,-35,0,5)
MinBtn.BackgroundColor3 = Color3.fromRGB(200,120,20)
MinBtn.Text = "➖"
MinBtn.TextColor3 = Color3.new(1,1,1)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextScaled = true
MinBtn.Parent = MainFrame
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0,6)
AddRainbowGlow(MinBtn,2)

MakeDraggable(MainFrame, MainDragBar, MainLockBtn)

-- FULL GUI BUTTONS
ESPBtn = Instance.new("TextButton")
ESPBtn.Size = UDim2.new(0,90,0,32)
ESPBtn.Position = UDim2.new(0,10,0,42)
ESPBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
ESPBtn.Text = "ESP: OFF"
ESPBtn.TextColor3 = Color3.new(1,1,1)
ESPBtn.Font = Enum.Font.GothamBold
ESPBtn.TextScaled = true
ESPBtn.Parent = MainFrame
Instance.new("UICorner", ESPBtn).CornerRadius = UDim.new(0,6)
AddRainbowGlow(ESPBtn,2)

local MusicBtn = Instance.new("TextButton")
MusicBtn.Size = UDim2.new(0,90,0,32)
MusicBtn.Position = UDim2.new(0,105,0,42)
MusicBtn.BackgroundColor3 = Color3.fromRGB(40,80,160)
MusicBtn.Text = "🎵 MUSIC"
MusicBtn.TextColor3 = Color3.new(1,1,1)
MusicBtn.Font = Enum.Font.GothamBold
MusicBtn.TextScaled = true
MusicBtn.Parent = MainFrame
Instance.new("UICorner", MusicBtn).CornerRadius = UDim.new(0,6)
AddRainbowGlow(MusicBtn,2)

local ConsoleBtn = Instance.new("TextButton")
ConsoleBtn.Size = UDim2.new(0,100,0,32)
ConsoleBtn.Position = UDim2.new(0,200,0,42)
ConsoleBtn.BackgroundColor3 = Color3.fromRGB(30,120,80)
ConsoleBtn.Text = "💻 CONSOLE"
ConsoleBtn.TextColor3 = Color3.new(1,1,1)
ConsoleBtn.Font = Enum.Font.GothamBold
ConsoleBtn.TextScaled = true
ConsoleBtn.Parent = MainFrame
Instance.new("UICorner", ConsoleBtn).CornerRadius = UDim.new(0,6)
AddRainbowGlow(ConsoleBtn,2)

ExitBtn = Instance.new("TextButton")
ExitBtn.Size = UDim2.new(0,90,0,32)
ExitBtn.Position = UDim2.new(0,310,0,42)
ExitBtn.BackgroundColor3 = Color3.fromRGB(180,30,30)
ExitBtn.Text = "🚪 EXIT"
ExitBtn.TextColor3 = Color3.new(1,1,1)
ExitBtn.Font = Enum.Font.GothamBold
ExitBtn.TextScaled = true
ExitBtn.Parent = MainFrame
Instance.new("UICorner", ExitBtn).CornerRadius = UDim.new(0,6)
AddRainbowGlow(ExitBtn,2)

-- VOLUME SLIDER
local VolLabel = Instance.new("TextLabel")
VolLabel.Size = UDim2.new(0,70,0,25)
VolLabel.Position = UDim2.new(0,420,0,45)
VolLabel.BackgroundTransparency = 1
VolLabel.Text = "🔊 VOL:"
VolLabel.TextColor3 = Color3.new(1,1,1)
VolLabel.Font = Enum.Font.Gotham
VolLabel.TextScaled = true
VolLabel.Parent = MainFrame

VolNumTextMain = Instance.new("TextLabel")
VolNumTextMain.Size = UDim2.new(0,40,0,25)
VolNumTextMain.Position = UDim2.new(0,490,0,45)
VolNumTextMain.BackgroundTransparency = 1
VolNumTextMain.Text = "50%"
VolNumTextMain.TextColor3 = Color3.new(1,1,1)
VolNumTextMain.Font = Enum.Font.GothamBold
VolNumTextMain.TextScaled = true
VolNumTextMain.Parent = MainFrame

local VolBG = Instance.new("Frame")
VolBG.Size = UDim2.new(0,150,0,20)
VolBG.Position = UDim2.new(0,540,0,47)
VolBG.BackgroundColor3 = Color3.fromRGB(50,50,50)
VolBG.Parent = MainFrame
Instance.new("UICorner", VolBG).CornerRadius = UDim.new(0,10)
AddRainbowGlow(VolBG,2)

VolFillMain = Instance.new("Frame")
VolFillMain.Size = UDim2.new(0.5,0,1,0)
VolFillMain.BackgroundColor3 = Color3.fromRGB(100,100,100)
VolFillMain.Parent = VolBG
Instance.new("UICorner", VolFillMain).CornerRadius = UDim.new(0,10)

local SliderActive = false
VolBG.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then SliderActive=true; i:CaptureFocus() end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then SliderActive=false end end)
UserInputService.InputChanged:Connect(function(i,gpe)
    if SliderActive and not gpe and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
        local rel = math.clamp((i.Position.X-VolBG.AbsolutePosition.X)/VolBG.AbsoluteSize.X,0,1)
        UpdateVolume(rel); i:ProcessEvent(false)
    end
end)

-- ✅ MINIMIZE/EXPAND: ESP NEVER CHANGES!
MinBtn.MouseButton1Click:Connect(function()
    IsMinimized = not IsMinimized
    if IsMinimized then
        MainFrame.Size = MINI_SIZE
        MainDragBar.Size = UDim2.new(1,-80,0,40)
        MainDragBar.Text = "⬚ DRAG | ESP ACTIVE"
        -- Hide extra buttons ONLY
        ESPBtn.Visible = false
        MusicBtn.Visible = false
        ConsoleBtn.Visible = false
        ExitBtn.Visible = false
        VolLabel.Visible = false
        VolNumTextMain.Visible = false
        VolBG.Visible = false
        TimerLabel.Visible = false
        MainLockBtn.Visible = false
        MinBtn.Text = "➕"
    else
        MainFrame.Size = FULL_SIZE
        MainDragBar.Size = UDim2.new(1,-150,0,30)
        MainDragBar.Text = "🔵 BLUE MODE ESP | DRAG HERE"
        -- Show all buttons
        ESPBtn.Visible = true
        MusicBtn.Visible = true
        ConsoleBtn.Visible = true
        ExitBtn.Visible = true
        VolLabel.Visible = true
        VolNumTextMain.Visible = true
        VolBG.Visible = true
        TimerLabel.Visible = true
        MainLockBtn.Visible = true
        MinBtn.Text = "➖"
    end
end)

-- ✅ ESP TOGGLE: TURNS ESP ON/OFF + CLEANS UP
ESPBtn.MouseButton1Click:Connect(function()
    ESP_Enabled = not ESP_Enabled
    if ESP_Enabled then
        ESPBtn.Text = "ESP: ON"
        ESPBtn.BackgroundColor3 = Color3.fromRGB(20,140,20)
    else
        ESPBtn.Text = "ESP: OFF"
        ESPBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
        ClearAllESP() -- ONLY CLEARS HERE, NOT ON MINIMIZE
    end
end)

-- ✅ EXIT: FULLY STOPS ESP + DESTROYS EVERYTHING
ExitBtn.MouseButton1Click:Connect(function()
    ESP_Enabled = false
    ClearAllESP()
    if CurrentBoomboxUI then CurrentBoomboxUI:Destroy() end
    if CurrentConsoleUI then CurrentConsoleUI:Destroy() end
    if CurrentSound then CurrentSound:Destroy() end
    MainUI:Destroy()
    getgenv().BlueMode_Loaded = nil
end)

MusicBtn.MouseButton1Click:Connect(ToggleBoomboxMenu)
ConsoleBtn.MouseButton1Click:Connect(ToggleConsole)

SetupDeathCheck()

-- MAIN LOOP
RunService.Heartbeat:Connect(function(Delta)
    if not MainUI or not MainUI.Parent then return end

    -- Timer
    local Now = os.time()
    UsedTime = UsedTime + math.max(0, Now - LastCheckTime)
    LastCheckTime = Now
    local Rem = math.max(0, USAGE_LIMIT - UsedTime)
    local H = math.floor(Rem/3600)
    local M = math.floor((Rem%3600)/60)
    local S = Rem%60
    TimerLabel.Text = string.format("%02d:%02d:%02d / 12:00",H,M,S)
    if Rem <= 0 then
        ESP_Enabled = false
        ESPBtn.Text = "ESP: OFF"
        ESPBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
        ClearAllESP()
    end

    -- Rainbow
    Hue = (Hue + Delta*0.5) % 1
    local Rainbow = Color3.fromHSV(Hue,1,1)
    for _,v in pairs(GuiElements) do if v then v.Color = Rainbow end end
    TimerLabel.TextColor3 = Rainbow

    -- ✅ ESP RUNS EVEN WHEN GUI IS MINIMIZED!
    if not ESP_Enabled then return end

    -- Update ESP
    for _,P in pairs(Players:GetPlayers()) do
        if P == LocalPlayer then continue end
        local Char = P.Character
        if not Char then continue end
        local Head = Char:FindFirstChild("Head")
        local Hum = Char:FindFirstChild("Humanoid")
        if not Head or not Hum or Hum.Health <= 0 then continue end

        -- Rainbow Outline
        local Outline = Char:FindFirstChild("BLUE_Outline")
        if not Outline then
            Outline = Instance.new("Highlight")
            Outline.Name = "BLUE_Outline"
            Outline.FillTransparency = 1
            Outline.OutlineTransparency = 0
            Outline.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            Outline.Parent = Char
        end
        Outline.OutlineColor = Rainbow

        -- Friend Dot
        if P:IsFriendsWith(LocalPlayer.UserId) then
            local Dot = Head:FindFirstChild("FriendRainbowDot")
            if not Dot then
                Dot = Instance.new("BillboardGui")
                Dot.Name = "FriendRainbowDot"
                Dot.AlwaysOnTop = true
                Dot.Size = UDim2.new(0,20,0,20)
                Dot.StudsOffset = Vector3.new(0,2,0)
                Dot.Parent = Head
                local Circle = Instance.new("Frame")
                Circle.Name = "DotCircle"
                Circle.Size = UDim2.new(1,0,1,0)
                Circle.Position = UDim2.new(0.5,-10,0.5,-10)
                Circle.BackgroundTransparency = 1
                local UICorner = Instance.new("UICorner")
                UICorner.CornerRadius = UDim.new(1,0)
                UICorner.Parent = Circle
                local UIS = Instance.new("UIStroke")
                UIS.Name = "RainbowAura"
                UIS.Thickness = 3
                UIS.Transparency = 0
                UIS.LineJoinMode = Enum.LineJoinMode.Round
                UIS.Parent = Circle
                table.insert(GuiElements, UIS)
                Circle.Parent = Dot
            end
            local Stroke = Dot:FindFirstChild("DotCircle") and Dot.DotCircle:FindFirstChild("RainbowAura")
            if Stroke then Stroke.Color = Rainbow end
        else
            -- Remove dot if no longer friend
            local OldDot = Head:FindFirstChild("FriendRainbowDot")
            if OldDot then OldDot:Destroy() end
        end
    end
end)

print("✅ BLUE MODE ESP LOADED | SHRINK = ESP STAYS RUNNING!")
