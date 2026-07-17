-- ==============================================
-- ESP Script | ADDED MUSIC VOLUME CONTROL
-- made by BLUE_MODE
-- UNLOCK CODE: Blue_Mode192823
-- ==============================================

if getgenv().BlueMode_Loaded then return end
getgenv().BlueMode_Loaded = true

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- ⚙️ SETTINGS
local USAGE_LIMIT = 12 * 3600
local COOLDOWN = 12 * 3600
local UNLOCK_CODE = "Blue_Mode192823"
local YOUTUBE_LINK = "https://youtube.com/@blue_mode?si=aCGyj0FnwCMtTP1M"
local SAVE_KEY_USED = "BlueMode_UsedTime_v2"
local SAVE_KEY_COOLDOWN = "BlueMode_CooldownEnd_v2"

-- 🛡️ PERMANENT SAVE SYSTEM
local function SaveData(key, value)
    pcall(function() writefile(key..".txt", tostring(value)) end)
end

local function LoadData(key, default)
    local val = nil
    pcall(function() val = readfile(key..".txt") end)
    return tonumber(val) or default
end

-- 🧹 CLEAR ONLY ESP
local function ClearESP()
    for _, Plr in pairs(Players:GetPlayers()) do
        if Plr and Plr.Character then
            pcall(function() if Plr.Character:FindFirstChild("BLUE_Outline") then Plr.Character.BLUE_Outline:Destroy() end end)
            pcall(function() if Plr.Character:FindFirstChild("FriendRainbowDot") then Plr.Character.FriendRainbowDot:Destroy() end end)
        end
    end
end

-- 🚫 COOLDOWN CHECK
local NowTime = os.time()
local CooldownEnd = LoadData(SAVE_KEY_COOLDOWN, 0)
if NowTime < CooldownEnd then
    print("⏳ COOLDOWN ACTIVE! Wait "..math.floor((CooldownEnd-NowTime)/60).." minutes")
    return
end

-- ⏳ LOAD SAVED TIME
local UsedTime = LoadData(SAVE_KEY_USED, 0)
local LastCheck = os.time()

-- 🎵 BOOMBOX + VOLUME SYSTEM
local CurrentSound = nil
local MusicVolume = LoadData("BlueMode_Volume", 0.5) -- Load saved volume, default 50%

local function UpdateVolume(newVol)
    MusicVolume = math.clamp(newVol, 0, 1)
    SaveData("BlueMode_Volume", MusicVolume)
    if CurrentSound then CurrentSound.Volume = MusicVolume end
    VolNumText.Text = math.floor(MusicVolume * 100).."%"
end

local function FormatSoundId(input)
    local num = tostring(input):gsub("[^%d]", "")
    return "rbxassetid://"..num
end

local function LoadBoombox(boomboxId)
    pcall(function() if CurrentSound then CurrentSound:Destroy() end end)
    CurrentSound = Instance.new("Sound")
    CurrentSound.Name = "BLUE_BOOMBOX"
    CurrentSound.SoundId = FormatSoundId(boomboxId)
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
    BoomUI.DisplayOrder = 10000
    BoomUI.Parent = CoreGui

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 300, 0, 220)
    Frame.Position = UDim2.new(0.5, -150, 0.5, -110)
    Frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
    Frame.BorderSizePixel = 2
    Frame.BorderColor3 = Color3.fromRGB(0,180,255)
    Frame.Parent = BoomUI
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0,10)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1,0,0,35)
    Title.Position = UDim2.new(0,0,0,5)
    Title.BackgroundTransparency = 1
    Title.Text = "🎵 BOOMBOX & VOLUME"
    Title.Font = Enum.Font.GothamBold
    Title.TextColor3 = Color3.new(1,1,1)
    Title.TextScaled = true
    Title.Parent = Frame

    local Input = Instance.new("TextBox")
    Input.Size = UDim2.new(1,-30,0,40)
    Input.Position = UDim2.new(0,15,0,45)
    Input.BackgroundColor3 = Color3.fromRGB(40,40,40)
    Input.PlaceholderText = "Paste Sound ID here..."
    Input.TextColor3 = Color3.new(1,1,1)
    Input.Font = Enum.Font.Gotham
    Input.TextScaled = true
    Input.ClearTextOnFocus = true
    Input.Parent = Frame
    Instance.new("UICorner", Input).CornerRadius = UDim.new(0,8)

    -- VOLUME SLIDER IN MENU
    local VolLabel = Instance.new("TextLabel")
    VolLabel.Size = UDim2.new(0,100,0,25)
    VolLabel.Position = UDim2.new(0,15,0,95)
    VolLabel.BackgroundTransparency = 1
    VolLabel.Text = "🔊 VOLUME:"
    VolLabel.TextColor3 = Color3.new(1,1,1)
    VolLabel.Font = Enum.Font.GothamBold
    VolLabel.TextScaled = true
    VolLabel.TextXAlignment = Enum.TextXAlignment.Left
    VolLabel.Parent = Frame

    local VolNum = Instance.new("TextLabel")
    VolNum.Size = UDim2.new(0,50,0,25)
    VolNum.Position = UDim2.new(1,-65,0,95)
    VolNum.BackgroundTransparency = 1
    VolNum.Text = math.floor(MusicVolume*100).."%"
    VolNum.TextColor3 = Color3.new(1,1,1)
    VolNum.Font = Enum.Font.GothamBold
    VolNum.TextScaled = true
    VolNum.TextXAlignment = Enum.TextXAlignment.Right
    VolNum.Parent = Frame

    local VolBG = Instance.new("Frame")
    VolBG.Size = UDim2.new(1,-30,0,20)
    VolBG.Position = UDim2.new(0,15,0,120)
    VolBG.BackgroundColor3 = Color3.fromRGB(50,50,50)
    VolBG.Parent = Frame
    Instance.new("UICorner", VolBG).CornerRadius = UDim.new(0,10)

    local VolFill = Instance.new("Frame")
    VolFill.Size = UDim2.new(MusicVolume,0,1,0)
    VolFill.BackgroundColor3 = Color3.fromRGB(0,180,255)
    VolFill.Parent = VolBG
    Instance.new("UICorner", VolFill).CornerRadius = UDim.new(0,10)

    local SliderActive = false
    VolBG.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then SliderActive = true end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then SliderActive = false end end)
    UserInputService.InputChanged:Connect(function(i)
        if SliderActive and i.UserInputType == Enum.UserInputType.MouseMovement then
            local pos = math.clamp((i.Position.X - VolBG.AbsolutePosition.X) / VolBG.AbsoluteSize.X, 0, 1)
            VolFill.Size = UDim2.new(pos,0,1,0)
            VolNum.Text = math.floor(pos*100).."%"
            UpdateVolume(pos)
        end
    end)

    local PlayBtn = Instance.new("TextButton")
    PlayBtn.Size = UDim2.new(0,120,0,35)
    PlayBtn.Position = UDim2.new(0,15,0,160)
    PlayBtn.BackgroundColor3 = Color3.fromRGB(30,130,220)
    PlayBtn.Text = "▶ PLAY"
    PlayBtn.TextColor3 = Color3.new(1,1,1)
    PlayBtn.Font = Enum.Font.GothamBold
    PlayBtn.TextScaled = true
    PlayBtn.Parent = Frame
    Instance.new("UICorner", PlayBtn).CornerRadius = UDim.new(0,6)

    local StopBtn = Instance.new("TextButton")
    StopBtn.Size = UDim2.new(0,120,0,35)
    StopBtn.Position = UDim2.new(0,165,0,160)
    StopBtn.BackgroundColor3 = Color3.fromRGB(180,40,40)
    StopBtn.Text = "⏹ STOP"
    StopBtn.TextColor3 = Color3.new(1,1,1)
    StopBtn.Font = Enum.Font.GothamBold
    StopBtn.TextScaled = true
    StopBtn.Parent = Frame
    Instance.new("UICorner", StopBtn).CornerRadius = UDim.new(0,6)

    PlayBtn.MouseButton1Click:Connect(function() if Input.Text ~= "" then LoadBoombox(Input.Text) end BoomUI:Destroy() end)
    StopBtn.MouseButton1Click:Connect(function() if CurrentSound then pcall(function() CurrentSound:Stop() CurrentSound:Destroy() end) end BoomUI:Destroy() end)
end

-- 🎮 MAIN UI
local UI = Instance.new("ScreenGui")
UI.Name = "BLUE_MODE_ESP"
UI.ResetOnSpawn = false
UI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
UI.Parent = CoreGui

local MAIN_SIZE = UDim2.new(0, 570, 0, 105)
local MIN_SIZE = UDim2.new(0, 50, 0, 50)
local Main = Instance.new("Frame")
Main.Size = MAIN_SIZE
Main.Position = UDim2.new(0, 20, 0.5, -52)
Main.BackgroundColor3 = Color3.fromRGB(25,25,25)
Main.BorderSizePixel = 2
Main.BorderColor3 = Color3.fromRGB(0,180,255)
Main.Active = true
Main.ClipsDescendants = false
Main.Parent = UI
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,8)

local DragBar = Instance.new("Frame")
DragBar.Size = UDim2.new(1, -25, 0, 22)
DragBar.BackgroundColor3 = Color3.fromRGB(60,140,220)
DragBar.Active = true
DragBar.Parent = Main

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

-- BUTTONS ROW 1
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

local DelBtn = Instance.new("TextButton")
DelBtn.Size = UDim2.new(0, 90, 0, 30)
DelBtn.Position = UDim2.new(0, 400, 0, 30)
DelBtn.BackgroundColor3 = Color3.fromRGB(140,20,20)
DelBtn.Text = "🗑️ EXIT"
DelBtn.TextColor3 = Color3.new(1,1,1)
DelBtn.Font = Enum.Font.GothamBold
DelBtn.TextScaled = true
DelBtn.Parent = Main
Instance.new("UICorner", DelBtn).CornerRadius = UDim.new(0,6)

-- MAIN VOLUME SLIDER (ON MAIN GUI)
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

local VolNumText = Instance.new("TextLabel")
VolNumText.Size = UDim2.new(0,45,0,25)
VolNumText.Position = UDim2.new(0,85,0,65)
VolNumText.BackgroundTransparency = 1
VolNumText.Text = math.floor(MusicVolume*100).."%"
VolNumText.TextColor3 = Color3.new(1,1,1)
VolNumText.Font = Enum.Font.Gotham
VolNumText.TextScaled = true
VolNumText.TextXAlignment = Enum.TextXAlignment.Right
VolNumText.Parent = Main

local VolBGMain = Instance.new("Frame")
VolBGMain.Size = UDim2.new(0,150,0,18)
VolBGMain.Position = UDim2.new(0,135,0,67)
VolBGMain.BackgroundColor3 = Color3.fromRGB(50,50,50)
VolBGMain.Parent = Main
Instance.new("UICorner", VolBGMain).CornerRadius = UDim.new(0,9)

local VolFillMain = Instance.new("Frame")
VolFillMain.Size = UDim2.new(MusicVolume,0,1,0)
VolFillMain.BackgroundColor3 = Color3.fromRGB(0,180,255)
VolFillMain.Parent = VolBGMain
Instance.new("UICorner", VolFillMain).CornerRadius = UDim.new(0,9)

-- VOLUME SLIDER DRAG
local VolSliderActive = false
VolBGMain.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then VolSliderActive = true end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then VolSliderActive = false end end)
UserInputService.InputChanged:Connect(function(i)
    if VolSliderActive and i.UserInputType == Enum.UserInputType.MouseMovement then
        local pos = math.clamp((i.Position.X - VolBGMain.AbsolutePosition.X) / VolBGMain.AbsoluteSize.X, 0, 1)
        VolFillMain.Size = UDim2.new(pos,0,1,0)
        UpdateVolume(pos)
    end
end)

-- VARIABLES
local ESP_Enabled = false
local Buttons_Locked = false
local Hue = 0
local IsSmall = false

-- 🖱️ DRAG SYSTEM (WORKS WHEN MINIMIZED)
local Drag = {Active=false, SX=0, SY=0, PX=0, PY=0}
local function StartDrag(input)
    if Buttons_Locked then return end
    local valid = input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch
    if not valid then return end
    Drag.Active = true
    Drag.SX = input.Position.X
    Drag.SY = input.Position.Y
    Drag.PX = Main.Position.X.Offset
    Drag.PY = Main.Position.Y.Offset
end
DragBar.InputBegan:Connect(StartDrag)
Main.InputBegan:Connect(StartDrag)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Drag.Active = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if not Drag.Active or Buttons_Locked then return end
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        Main.Position = UDim2.new(0, Drag.PX + (input.Position.X - Drag.SX), 0, Drag.PY + (input.Position.Y - Drag.SY))
    end
end)

-- ✅ BUTTON ACTIONS
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
        DelBtn.Visible = false
        VolLabelMain.Visible = false
        VolNumText.Visible = false
        VolBGMain.Visible = false
        MinBtn.Text = "➕"
    else
        Main.Size = MAIN_SIZE
        DragBar.Visible = true
        ESPBtn.Visible = true
        YtBtn.Visible = true
        BoomBtn.Visible = true
        LockBtn.Visible = true
        DelBtn.Visible = true
        VolLabelMain.Visible = true
        VolNumText.Visible = true
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

-- 🚀 MAIN LOOP
RunService.Heartbeat:Connect(function(delta)
    if not UI or not UI.Parent then return end

    -- ⏳ PERMANENT TIMER
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

    -- RAINBOW EFFECT
    Hue = (Hue + delta) % 1
    Main.BorderColor3 = Color3.fromHSV(Hue, 1, 1)

    if not ESP_Enabled then return end

    -- 👥 ESP + FRIEND DOTS
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

        -- OUTLINE
        local Outline = Char:FindFirstChild("BLUE_Outline")
        if not Outline then
            Outline = Instance.new("Highlight")
            Outline.Name = "BLUE_Outline"
            Outline.FillTransparency = 1
            Outline.OutlineTransparency = 0
            Outline.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            Outline.Adornee = Char
            Outline.Parent = Char
        end
        Outline.OutlineColor = Color3.fromHSV(Hue, 1, 1)

        -- 🟢 FRIEND DOT
        local IsFriend = false
        pcall(function() IsFriend = LocalPlayer:IsFriendsWith(Plr.UserId) end)
        local Head = Char:FindFirstChild("Head")
        local Dot = Char:FindFirstChild("FriendRainbowDot")

        if IsFriend and Head then
            if not Dot then
                Dot = Instance.new("BillboardGui")
                Dot.Name = "FriendRainbowDot"
                Dot.AlwaysOnTop = true
                Dot.Size = UDim2.new(0, 18, 0, 18)
                Dot.StudsOffset = Vector3.new(0, 1.8, 0)
                Dot.Adornee = Head
                local Circle = Instance.new("Frame")
                Circle.Size = UDim2.new(1,0,1,0)
                Circle.BackgroundColor3 = Color3.fromHSV(Hue, 1, 1)
                Instance.new("UICorner", Circle).CornerRadius = UDim.new(1,0)
                Circle.Parent = Dot
                Dot.Parent = Char
            end
        elseif Dot then
            Dot:Destroy()
        end
    end
end)

print("✅ VOLUME CONTROL ADDED! ADJUST ANYTIME!")
