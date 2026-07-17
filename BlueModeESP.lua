-- ==============================================
-- ESP Script | FULL CLEANUP ON DELETE + OFF
-- made by BLUE_MODE
-- YouTube: https://youtube.com/@blue_mode?si=aCGyj0FnwCMtTP1M
-- UNLOCK CODE: Blue_Mode192823
-- ==============================================

if getgenv().BlueModeESP_Loaded then return end
getgenv().BlueModeESP_Loaded = true

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- ⚙️ TIME SETTINGS
local USAGE_LIMIT = 12 * 3600
local COOLDOWN = 12 * 3600
local UNLOCK_CODE = "Blue_Mode192823"
local UsedTime = 0

-- Settings
local ESP_Enabled = false
local Buttons_Locked = false
local RAINBOW_SPEED = 1
local YOUTUBE_LINK = "https://youtube.com/@blue_mode?si=aCGyj0FnwCMtTP1M"
local MAIN_SIZE = UDim2.new(0, 420, 0, 80)
local MAIN_POS = UDim2.new(0, 20, 0.5, 0)
local SQUARE_SIZE = UDim2.new(0, 50, 0, 50)
local IsSmall = false

-- 🧹 100% FULL CLEANUP — REMOVES EVERYTHING FROM ALL PLAYERS
local function ClearAllESP()
    -- Clean ALL players
    for _, Plr in pairs(Players:GetPlayers()) do
        if Plr.Character then
            local Char = Plr.Character
            -- Destroy outline
            if Char:FindFirstChild("BLUE_MODE_Outline") then Char.BLUE_MODE_Outline:Destroy() end
            -- Destroy dot + all related children
            for _, Desc in pairs(Char:GetDescendants()) do
                if Desc.Name == "FriendRainbowDot" or Desc.Name == "DotCircle" or Desc.Name == "BLUE_MODE_Outline" then
                    Desc:Destroy()
                end
            end
        end
    end
    -- Extra scan for any hidden leftovers
    for _, Gui in pairs(CoreGui:GetChildren()) do
        if Gui.Name == "FriendRainbowDot" or Gui.Name == "BLUE_MODE_Outline" then Gui:Destroy() end
    end
end

-- 💾 SAVE / LOAD COOLDOWN
local function GetCooldownEnd()
    return tonumber(getsetting and getsetting("BlueMode_CooldownEnd")) or 0
end

local function SaveCooldownEnd(timestamp)
    pcall(function() if setsetting then setsetting("BlueMode_CooldownEnd", tostring(timestamp)) end end)
end

-- ⏳ COOLDOWN LOCK GUI
local function ShowCooldownScreen(EndTime)
    local CooldownUI = Instance.new("ScreenGui")
    CooldownUI.Name = "BLUE_MODE_COOLDOWN"
    CooldownUI.ResetOnSpawn = false
    CooldownUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    CooldownUI.DisplayOrder = 9999
    CooldownUI.Parent = CoreGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 360, 0, 250)
    MainFrame.Position = UDim2.new(0.5, -180, 0.5, -125)
    MainFrame.BackgroundColor3 = Color3.fromRGB(22,22,22)
    MainFrame.BorderSizePixel = 2
    MainFrame.BorderColor3 = Color3.fromRGB(0,180,255)
    MainFrame.Parent = CooldownUI
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,12)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 45)
    Title.Position = UDim2.new(0,0,0,15)
    Title.BackgroundTransparency = 1
    Title.Text = "⏳ COOLDOWN ACTIVE"
    Title.Font = Enum.Font.GothamBold
    Title.TextColor3 = Color3.fromRGB(255,200,0)
    Title.TextScaled = true
    Title.Parent = MainFrame

    local TimeDisplay = Instance.new("TextLabel")
    TimeDisplay.Size = UDim2.new(1, -20, 0, 60)
    TimeDisplay.Position = UDim2.new(0,10,0,60)
    TimeDisplay.BackgroundTransparency = 1
    TimeDisplay.Text = "Calculating time..."
    TimeDisplay.Font = Enum.Font.GothamSemibold
    TimeDisplay.TextColor3 = Color3.new(1,1,1)
    TimeDisplay.TextScaled = true
    TimeDisplay.TextWrapped = true
    TimeDisplay.Parent = MainFrame

    local CodeBox = Instance.new("TextBox")
    CodeBox.Size = UDim2.new(1, -30, 0, 45)
    CodeBox.Position = UDim2.new(0,15,0,130)
    CodeBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
    CodeBox.Text = "Enter Unlock Code"
    CodeBox.Font = Enum.Font.Gotham
    CodeBox.TextColor3 = Color3.new(1,1,1)
    CodeBox.TextScaled = true
    CodeBox.ClearTextOnFocus = true
    CodeBox.Parent = MainFrame
    Instance.new("UICorner", CodeBox).CornerRadius = UDim.new(0,8)

    local UnlockBtn = Instance.new("TextButton")
    UnlockBtn.Size = UDim2.new(0,140,0,38)
    UnlockBtn.Position = UDim2.new(0,15,0,185)
    UnlockBtn.BackgroundColor3 = Color3.fromRGB(30,130,220)
    UnlockBtn.Text = "🔓 UNLOCK"
    UnlockBtn.TextColor3 = Color3.new(1,1,1)
    UnlockBtn.Font = Enum.Font.GothamBold
    UnlockBtn.TextScaled = true
    UnlockBtn.Parent = MainFrame
    Instance.new("UICorner", UnlockBtn).CornerRadius = UDim.new(0,6)

    local OkBtn = Instance.new("TextButton")
    OkBtn.Size = UDim2.new(0,140,0,38)
    OkBtn.Position = UDim2.new(1,-155,0,185)
    OkBtn.BackgroundColor3 = Color3.fromRGB(30,150,70)
    OkBtn.Text = "✅ OK"
    OkBtn.TextColor3 = Color3.new(1,1,1)
    OkBtn.Font = Enum.Font.GothamBold
    OkBtn.TextScaled = true
    OkBtn.Visible = false
    OkBtn.Parent = MainFrame
    Instance.new("UICorner", OkBtn).CornerRadius = UDim.new(0,6)

    local UpdateLoop
    UpdateLoop = RunService.Heartbeat:Connect(function()
        local Remaining = EndTime - os.time()
        if Remaining <= 0 then
            TimeDisplay.Text = "✅ Cooldown Complete!\nRestart script to use."
            UnlockBtn.Visible = false
            OkBtn.Visible = true
            UpdateLoop:Disconnect()
            return
        end
        local h = math.floor(Remaining/3600)
        local m = math.floor((Remaining%3600)/60)
        local s = math.floor(Remaining%60)
        TimeDisplay.Text = string.format("Please wait:\n%02d Hours : %02d Mins : %02d Secs", h, m, s)
    end)

    UnlockBtn.MouseButton1Click:Connect(function()
        if CodeBox.Text == UNLOCK_CODE then
            SaveCooldownEnd(0)
            CooldownUI:Destroy()
        else
            CodeBox.Text = "❌ WRONG CODE!"
            task.wait(1.5)
            CodeBox.Text = ""
        end
    end)

    OkBtn.MouseButton1Click:Connect(function() CooldownUI:Destroy() end)
end

-- 🚫 COOLDOWN CHECK
local NowTime = os.time()
local CooldownEnd = GetCooldownEnd()
if NowTime < CooldownEnd then
    ShowCooldownScreen(CooldownEnd)
    return
end

-- 🎮 MAIN UI
local UI = Instance.new("ScreenGui")
UI.Name = "BLUE_MODE_ESP"
UI.ResetOnSpawn = false
UI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
UI.DisplayOrder = 999
UI.Parent = CoreGui

-- Startup Text
local StartupText = Instance.new("TextLabel")
StartupText.Size = UDim2.new(0, 300, 0, 50)
StartupText.Position = UDim2.new(0.5, -150, 0.3, 0)
StartupText.BackgroundTransparency = 1
StartupText.Text = "✨ MADE BY BLUE_MODE ✨"
StartupText.TextColor3 = Color3.fromRGB(0, 255, 255)
StartupText.Font = Enum.Font.GothamBold
StartupText.TextScaled = true
StartupText.Parent = UI
task.delay(1.2, function() StartupText:Destroy() end)

-- Main Bar
local MainBar = Instance.new("Frame")
MainBar.Size = MAIN_SIZE
MainBar.Position = MAIN_POS
MainBar.BackgroundColor3 = Color3.fromRGB(25,25,25)
MainBar.BorderSizePixel = 2
MainBar.BorderColor3 = Color3.fromRGB(70,70,70)
MainBar.Active = true
MainBar.ClipsDescendants = false
MainBar.Parent = UI

-- Drag Handle
local DragBar = Instance.new("Frame")
DragBar.Size = UDim2.new(1, -25, 0, 22)
DragBar.Position = UDim2.new(0, 0, 0, 0)
DragBar.BackgroundColor3 = Color3.fromRGB(60, 140, 220)
DragBar.Active = true
DragBar.Parent = MainBar

-- Title + Timer
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -110, 1, 0)
Title.Position = UDim2.new(0, 0, 0, 0)
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

-- Resize Button
local ResizeBtn = Instance.new("TextButton")
ResizeBtn.Size = UDim2.new(0, 22, 1, 0)
ResizeBtn.Position = UDim2.new(1, -22, 0, 0)
ResizeBtn.BackgroundColor3 = Color3.fromRGB(160, 40, 40)
ResizeBtn.Text = "❌"
ResizeBtn.TextColor3 = Color3.new(1,1,1)
ResizeBtn.Font = Enum.Font.GothamBold
ResizeBtn.TextScaled = true
ResizeBtn.Parent = MainBar

-- ESP Button
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 90, 0, 30)
ToggleBtn.Position = UDim2.new(0, 10, 0, 32)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
ToggleBtn.Text = "ESP: OFF"
ToggleBtn.TextColor3 = Color3.new(1,1,1)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextScaled = true
ToggleBtn.Parent = MainBar

-- YouTube Button
local YtBtn = Instance.new("TextButton")
YtBtn.Size = UDim2.new(0, 100, 0, 30)
YtBtn.Position = UDim2.new(0, 105, 0, 32)
YtBtn.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
YtBtn.Text = "📺 YOUTUBE"
YtBtn.TextColor3 = Color3.new(1,1,1)
YtBtn.Font = Enum.Font.GothamBold
YtBtn.TextScaled = true
YtBtn.Parent = MainBar

-- Delete Button
local DeleteBtn = Instance.new("TextButton")
DeleteBtn.Size = UDim2.new(0, 90, 0, 30)
DeleteBtn.Position = UDim2.new(0, 210, 0, 32)
DeleteBtn.BackgroundColor3 = Color3.fromRGB(140, 20, 20)
DeleteBtn.Text = "🗑️ DELETE"
DeleteBtn.TextColor3 = Color3.new(1,1,1)
DeleteBtn.Font = Enum.Font.GothamBold
DeleteBtn.TextScaled = true
DeleteBtn.Parent = MainBar

-- Lock Slider
local SliderBG = Instance.new("Frame")
SliderBG.Size = UDim2.new(0, 70, 0, 26)
SliderBG.Position = UDim2.new(0, 310, 0, 32)
SliderBG.BackgroundColor3 = Color3.fromRGB(50,50,50)
SliderBG.Parent = MainBar

local SliderKnob = Instance.new("TextButton")
SliderKnob.Size = UDim2.new(0, 32, 1, 0)
SliderKnob.Position = UDim2.new(0, 0, 0, 0)
SliderKnob.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
SliderKnob.Text = "🔓"
SliderKnob.TextColor3 = Color3.new(0,0,0)
SliderKnob.Font = Enum.Font.GothamBold
SliderKnob.TextScaled = true
SliderKnob.ZIndex = 100
SliderKnob.Parent = SliderBG

-- 🔒 LOCK / UNLOCK
local function SetLockState(locked)
    Buttons_Locked = locked
    if locked then
        TweenService:Create(SliderKnob, TweenInfo.new(0.15), {Position = UDim2.new(0, 38, 0, 0)}):Play()
        SliderKnob.Text = "🔒"
        SliderKnob.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
        DragBar.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
        Title.Text = "🔒 LOCKED"
    else
        TweenService:Create(SliderKnob, TweenInfo.new(0.15), {Position = UDim2.new(0, 0, 0, 0)}):Play()
        SliderKnob.Text = "🔓"
        SliderKnob.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
        DragBar.BackgroundColor3 = Color3.fromRGB(60, 140, 220)
        Title.Text = "made by BLUE_MODE | DRAG HERE"
    end
end

-- 🖱️ DRAG SYSTEM (WORKS MINIMIZED OR NOT!)
local Drag = {Active = false, StartX = 0, StartY = 0, StartPosX = 0, StartPosY = 0}

local function StartDrag(Input)
    if Buttons_Locked then return end
    local IsMouse = Input.UserInputType == Enum.UserInputType.MouseButton1
    local IsTouch = Input.UserInputType == Enum.UserInputType.Touch
    if not IsMouse and not IsTouch then return end
    Drag.Active = true
    Drag.StartX = Input.Position.X
    Drag.StartY = Input.Position.Y
    Drag.StartPosX = MainBar.Position.X.Offset
    Drag.StartPosY = MainBar.Position.Y.Offset
end

DragBar.InputBegan:Connect(StartDrag)
MainBar.InputBegan:Connect(function(Input) if IsSmall then StartDrag(Input) end end)

UserInputService.InputEnded:Connect(function(Input)
    local IsMouse = Input.UserInputType == Enum.UserInputType.MouseButton1
    local IsTouch = Input.UserInputType == Enum.UserInputType.Touch
    if IsMouse or IsTouch then Drag.Active = false end
end)

UserInputService.InputChanged:Connect(function(Input)
    if not Drag.Active or Buttons_Locked then return end
    local IsMove = Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch
    if not IsMove then return end
    MainBar.Position = UDim2.new(0, Drag.StartPosX + (Input.Position.X - Drag.StartX), 0, Drag.StartPosY + (Input.Position.Y - Drag.StartY))
end)

-- Slider Control
local SliderActive = false
SliderKnob.InputBegan:Connect(function(Input)
    local IsMouse = Input.UserInputType == Enum.UserInputType.MouseButton1
    local IsTouch = Input.UserInputType == Enum.UserInputType.Touch
    if IsMouse or IsTouch then SliderActive = true; Drag.Active = false end
end)

UserInputService.InputChanged:Connect(function(Input)
    if not SliderActive then return end
    local IsMove = Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch
    if not IsMove then return end
    SliderKnob.Position = UDim2.new(0, math.clamp(Input.Position.X - SliderBG.AbsolutePosition.X - 16, 0, 38), 0, 0)
end)

UserInputService.InputEnded:Connect(function()
    if not SliderActive then return end
    SliderActive = false
    SetLockState(SliderKnob.Position.X.Offset >= 20)
end)

-- 🟥 MINIMIZE / RESTORE
ResizeBtn.MouseButton1Click:Connect(function()
    IsSmall = not IsSmall
    if IsSmall then
        MainBar.Size = SQUARE_SIZE
        DragBar.Visible = false
        ToggleBtn.Visible = false
        YtBtn.Visible = false
        DeleteBtn.Visible = false
        SliderBG.Visible = false
        ResizeBtn.Text = "➕"
    else
        MainBar.Size = MAIN_SIZE
        DragBar.Visible = true
        ToggleBtn.Visible = true
        YtBtn.Visible = true
        DeleteBtn.Visible = true
        SliderBG.Visible = true
        ResizeBtn.Text = "❌"
    end
end)

-- ✅ ESP TOGGLE: FULL CLEANUP
ToggleBtn.MouseButton1Click:Connect(function()
    ESP_Enabled = not ESP_Enabled
    ToggleBtn.Text = ESP_Enabled and "ESP: ON" or "ESP: OFF"
    ToggleBtn.BackgroundColor3 = ESP_Enabled and Color3.fromRGB(25, 110, 25) or Color3.fromRGB(40,40,40)
    if not ESP_Enabled then
        ClearAllESP()
        task.wait(0.05)
        ClearAllESP()
    end
end)

YtBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(YOUTUBE_LINK)
        YtBtn.Text = "✅ COPIED!"
        task.wait(1.5)
        YtBtn.Text = "📺 YOUTUBE"
    end
end)

-- ✅ DELETE BUTTON: CLEANS EVERYONE + FULL UNLOAD
DeleteBtn.MouseButton1Click:Connect(function()
    ESP_Enabled = false
    ClearAllESP() -- CLEAN ALL PLAYERS FIRST
    task.wait(0.05)
    ClearAllESP() -- DOUBLE CLEAN TO BE 100% SURE
    UI:Destroy()
    getgenv().BlueModeESP_Loaded = nil
end)

-- Outline System
local function SetOutline(char, enable)
    if not char then return end
    local Out = char:FindFirstChild("BLUE_MODE_Outline")
    if enable and not Out then
        Out = Instance.new("Highlight")
        Out.Name = "BLUE_MODE_Outline"
        Out.FillTransparency = 1
        Out.OutlineTransparency = 0
        Out.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        Out.Adornee = char
        Out.Parent = char
    elseif not enable and Out then Out:Destroy() end
end

-- MAIN LOOP
local Hue = 0
RunService.RenderStepped:Connect(function(deltaTime)
    if not UI or not UI.Parent then return end

    -- Timer
    UsedTime += deltaTime
    local h = math.floor(UsedTime/3600)
    local m = math.floor((UsedTime%3600)/60)
    local s = math.floor(UsedTime%60)
    TimerLabel.Text = string.format("%02d:%02d:%02d / 12:00:00", h, m, s)

    -- Timeout
    if UsedTime >= USAGE_LIMIT then
        SaveCooldownEnd(os.time() + COOLDOWN)
        DeleteBtn:Fire()
        return
    end

    -- Rainbow
    Hue = (Hue + deltaTime * RAINBOW_SPEED) % 1
    local RainbowColor = Color3.fromHSV(Hue, 1, 1)
    MainBar.BorderColor3 = RainbowColor

    -- ⚡ STOP ALL WORK WHEN ESP IS OFF
    if not ESP_Enabled then return end

    for _, Player in pairs(Players:GetPlayers()) do
        if Player == LocalPlayer then continue end
        local Character = Player.Character
        if not Character then continue end
        local Humanoid = Character:FindFirstChildOfClass("Humanoid")
        if not Humanoid or Humanoid.Health <= 0 then
            SetOutline(Character, false)
            local Dot = Character:FindFirstChild("FriendRainbowDot")
            if Dot then Dot:Destroy() end
            continue
        end

        -- Player Outline
        SetOutline(Character, true)
        local Outline = Character:FindFirstChild("BLUE_MODE_Outline")
        if Outline then Outline.OutlineColor = RainbowColor end

        -- Friend Rainbow Dot on Head
        local IsFriend = false
        pcall(function() IsFriend = LocalPlayer:IsFriendsWith(Player.UserId) end)
        local Head = Character:FindFirstChild("Head")
        if IsFriend and Head then
            local Dot = Head:FindFirstChild("FriendRainbowDot") or Instance.new("BillboardGui", Head)
            Dot.Name = "FriendRainbowDot"
            Dot.AlwaysOnTop = true
            Dot.Size = UDim2.new(0, 18, 0, 18)
            Dot.StudsOffset = Vector3.new(0, 1.8, 0)
            Dot.Adornee = Head

            local DotCircle = Dot:FindFirstChild("DotCircle") or Instance.new("Frame", Dot)
            DotCircle.Name = "DotCircle"
            DotCircle.Size = UDim2.new(1,0,1,0)
            DotCircle.BackgroundColor3 = RainbowColor
            Instance.new("UICorner", DotCircle).CornerRadius = UDim.new(1,0)
        else
            local Dot = Character:FindFirstChild("FriendRainbowDot")
            if Dot then Dot:Destroy() end
        end
    end
end)

Players.PlayerAdded:Connect(function(Player)
    Player.CharacterAdded:Connect(function()
        task.wait(0.1)
        if ESP_Enabled and Player.Character then SetOutline(Player.Character, true) end
    end)
end)
