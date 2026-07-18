-- ==============================================
-- BLUE MODE ESP | DRAG ONLY ON HANDLE + FULL FIXES
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
local YOUTUBE_LINK = "https://youtube.com/@blue_mode"
local SAVE_KEY_VOLUME = "BlueMode_Volume_v13"

-- VARIABLES
local MusicVolume = 0.5
local CurrentSound = nil
local VolNumTextMain, VolFillMain, VolFillMenu, VolNumMenu
local OpenWindows = {}
local ESP_Enabled = false
local Buttons_Locked = false
local IsMinimized = false
local MainLoop = nil
local MainUI = nil
local MainFrame = nil
local DragHandle = nil

-- DATA HELPERS
local function SaveData(key, value) pcall(function() writefile(key..".txt", tostring(value)) end) end
local function LoadData(key, default) local v=nil; pcall(function() v=readfile(key..".txt") end); return tonumber(v) or default end
MusicVolume = LoadData(SAVE_KEY_VOLUME, 0.5)

-- FULL CLEANUP
local function FullCleanup()
    if MainLoop then MainLoop:Disconnect() end
    if CurrentSound then pcall(function() CurrentSound:Stop() CurrentSound:Destroy() end) end
    for _,P in pairs(Players:GetPlayers()) do
        if P and P.Character then
            pcall(function()
                if P.Character:FindFirstChild("BLUE_Outline") then P.Character.BLUE_Outline:Destroy() end
            end)
        end
    end
    for _,gui in pairs(OpenWindows) do if gui then gui:Destroy() end end
    if MainUI then MainUI:Destroy() end
    getgenv().BlueMode_Loaded = nil
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
    return Outline
end

-- VOLUME CONTROL
local function UpdateVolume(newVol)
    MusicVolume = math.clamp(newVol, 0, 1)
    SaveData(SAVE_KEY_VOLUME, MusicVolume)
    if CurrentSound then CurrentSound.Volume = MusicVolume end
    local Pct = math.floor(MusicVolume*100).."%"
    if VolNumTextMain then VolNumTextMain.Text = Pct end
    if VolFillMain then VolFillMain.Size = UDim2.new(MusicVolume,0,1,0) end
    if VolNumMenu then VolNumMenu.Text = Pct end
    if VolFillMenu then VolFillMenu.Size = UDim2.new(MusicVolume,0,1,0) end
end

-- SOUND FUNCTIONS
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

-- ==============================================
-- DRAG SYSTEM: ONLY WORKS ON DRAG HANDLE
-- ==============================================
local DragState = {
    Dragging = false,
    StartX = 0, StartY = 0,
    StartPosX = 0, StartPosY = 0
}

-- Start drag ONLY when clicking the drag handle
local function StartDrag(input)
    if Buttons_Locked then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        DragState.Dragging = true
        DragState.StartX = input.Position.X
        DragState.StartY = input.Position.Y
        DragState.StartPosX = MainFrame.Position.X.Offset
        DragState.StartPosY = MainFrame.Position.Y.Offset
    end
end

-- Update position only while dragging
local function UpdateDrag(input)
    if not DragState.Dragging then return end
    local DeltaX = input.Position.X - DragState.StartX
    local DeltaY = input.Position.Y - DragState.StartY
    MainFrame.Position = UDim2.new(0, DragState.StartPosX + DeltaX, 0, DragState.StartPosY + DeltaY)
end

-- Stop drag when releasing click
local function StopDrag(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        DragState.Dragging = false
    end
end

-- ==============================================
-- MAIN UI BUILD
-- ==============================================
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
MainFrame.ClipsDescendants = false
MainFrame.Parent = MainUI
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,8)
AddRainbowGlow(MainFrame,5)

-- 🎯 DRAG HANDLE: DEDICATED DRAG AREA, NO OVERLAP
DragHandle = Instance.new("TextButton")
DragHandle.Size = UDim2.new(1, -30, 0, 28) -- Leave space for minimize button
DragHandle.Position = UDim2.new(0,0,0,0)
DragHandle.BackgroundColor3 = Color3.fromRGB(60,140,220)
DragHandle.Text = "🔓 DRAG HERE | made by BLUE_MODE"
DragHandle.TextColor3 = Color3.new(1,1,1)
DragHandle.Font = Enum.Font.GothamBold
DragHandle.TextScaled = true
DragHandle.TextXAlignment = Enum.TextXAlignment.Center
DragHandle.AutoLocalize = false
DragHandle.Active = true
DragHandle.Parent = MainFrame
AddRainbowGlow(DragHandle,2)

-- Connect drag ONLY to this handle
DragHandle.InputBegan:Connect(StartDrag)
UserInputService.InputChanged:Connect(UpdateDrag)
UserInputService.InputEnded:Connect(StopDrag)

-- MINIMIZE BUTTON
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0,28,0,28)
MinimizeBtn.Position = UDim2.new(1,-28,0,0)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(160,40,40)
MinimizeBtn.Text = "❌"
MinimizeBtn.TextColor3 = Color3.new(1,1,1)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 20
MinimizeBtn.Parent = MainFrame
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0,6)

-- FUNCTION BUTTONS
local ESPBtn = Instance.new("TextButton")
ESPBtn.Size = UDim2.new(0,85,0,30)
ESPBtn.Position = UDim2.new(0,10,0,35)
ESPBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
ESPBtn.Text = "ESP: OFF"
ESPBtn.TextColor3 = Color3.new(1,1,1)
ESPBtn.Font = Enum.Font.GothamBold
ESPBtn.TextScaled = true
ESPBtn.Parent = MainFrame
Instance.new("UICorner", ESPBtn).CornerRadius = UDim.new(0,6)

local MusicBtn = Instance.new("TextButton")
MusicBtn.Size = UDim2.new(0,90,0,30)
MusicBtn.Position = UDim2.new(0,100,0,35)
MusicBtn.BackgroundColor3 = Color3.fromRGB(40,80,160)
MusicBtn.Text = "🎵 MUSIC"
MusicBtn.TextColor3 = Color3.new(1,1,1)
MusicBtn.Font = Enum.Font.GothamBold
MusicBtn.TextScaled = true
MusicBtn.Parent = MainFrame
Instance.new("UICorner", MusicBtn).CornerRadius = UDim.new(0,6)

local LockBtn = Instance.new("TextButton")
LockBtn.Size = UDim2.new(0,90,0,30)
LockBtn.Position = UDim2.new(0,200,0,35)
LockBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
LockBtn.Text = "🔓 UNLOCKED"
LockBtn.TextColor3 = Color3.new(1,1,1)
LockBtn.Font = Enum.Font.GothamBold
LockBtn.TextScaled = true
LockBtn.Parent = MainFrame
Instance.new("UICorner", LockBtn).CornerRadius = UDim.new(0,6)

local ExitBtn = Instance.new("TextButton")
ExitBtn.Size = UDim2.new(0,90,0,30)
ExitBtn.Position = UDim2.new(0,300,0,35)
ExitBtn.BackgroundColor3 = Color3.fromRGB(140,20,20)
ExitBtn.Text = "🗑️ EXIT"
ExitBtn.TextColor3 = Color3.new(1,1,1)
ExitBtn.Font = Enum.Font.GothamBold
ExitBtn.TextScaled = true
ExitBtn.Parent = MainFrame
Instance.new("UICorner", ExitBtn).CornerRadius = UDim.new(0,6)

-- MAIN VOLUME SLIDER (NO DRAG CONFLICT)
local VolLabelMain = Instance.new("TextLabel")
VolLabelMain.Size = UDim2.new(0,70,0,25)
VolLabelMain.Position = UDim2.new(0,410,0,37)
VolLabelMain.BackgroundTransparency = 1
VolLabelMain.Text = "🔊 VOLUME:"
VolLabelMain.TextColor3 = Color3.new(1,1,1)
VolLabelMain.Font = Enum.Font.Gotham
VolLabelMain.TextScaled = true
VolLabelMain.Parent = MainFrame

VolNumTextMain = Instance.new("TextLabel")
VolNumTextMain.Size = UDim2.new(0,45,0,25)
VolNumTextMain.Position = UDim2.new(0,480,0,37)
VolNumTextMain.BackgroundTransparency = 1
VolNumTextMain.Text = math.floor(MusicVolume*100).."%"
VolNumTextMain.TextColor3 = Color3.new(1,1,1)
VolNumTextMain.Font = Enum.Font.GothamBold
VolNumTextMain.TextScaled = true
VolNumTextMain.Parent = MainFrame

local VolBGMain = Instance.new("Frame")
VolBGMain.Size = UDim2.new(0,150,0,20)
VolBGMain.Position = UDim2.new(0,535,0,38)
VolBGMain.BackgroundColor3 = Color3.fromRGB(50,50,50)
VolBGMain.Parent = MainFrame
Instance.new("UICorner", VolBGMain).CornerRadius = UDim.new(0,10)

VolFillMain = Instance.new("Frame")
VolFillMain.Size = UDim2.new(MusicVolume,0,1,0)
VolFillMain.BackgroundColor3 = Color3.fromRGB(100,200,255)
VolFillMain.Parent = VolBGMain
Instance.new("UICorner", VolFillMain).CornerRadius = UDim.new(0,10)

-- Volume slider logic (works without moving GUI)
local SliderActive = false
VolBGMain.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then SliderActive = true end end)
UserInputService.InputEnded:Connect(function() SliderActive = false end)
UserInputService.InputChanged:Connect(function(i)
    if SliderActive then
        local rel = math.clamp((i.Position.X - VolBGMain.AbsolutePosition.X)/VolBGMain.AbsoluteSize.X, 0, 1)
        UpdateVolume(rel)
    end
end)

-- BUTTON FUNCTIONS
LockBtn.MouseButton1Click:Connect(function()
    Buttons_Locked = not Buttons_Locked
    if Buttons_Locked then
        LockBtn.Text = "🔒 LOCKED"
        DragHandle.Text = "🔒 UNLOCK TO MOVE"
        LockBtn.BackgroundColor3 = Color3.fromRGB(180,40,40)
    else
        LockBtn.Text = "🔓 UNLOCKED"
        DragHandle.Text = "🔓 DRAG HERE | made by BLUE_MODE"
        LockBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    end
end)

MinimizeBtn.MouseButton1Click:Connect(function()
    IsMinimized = not IsMinimized
    if IsMinimized then
        MainFrame.Size = MIN_SIZE
        DragHandle.Visible = false
        ESPBtn.Visible = false
        MusicBtn.Visible = false
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
        LockBtn.Visible = true
        ExitBtn.Visible = true
        VolLabelMain.Visible = true
        VolNumTextMain.Visible = true
        VolBGMain.Visible = true
        MinimizeBtn.Text = "❌"
    end
end)

ExitBtn.MouseButton1Click:Connect(FullCleanup)

ESPBtn.MouseButton1Click:Connect(function()
    ESP_Enabled = not ESP_Enabled
    ESPBtn.Text = ESP_Enabled and "ESP: ON" or "ESP: OFF"
    ESPBtn.BackgroundColor3 = ESP_Enabled and Color3.fromRGB(20,150,70) or Color3.fromRGB(40,40,40)
end)

print("✅ LOADED! Drag only works on the top blue bar. Volume slider works separately!")
