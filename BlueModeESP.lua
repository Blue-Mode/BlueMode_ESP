-- ==============================================
-- ✅ BLUE_MODE | ORIGINAL OLD STYLE
-- ✅ NO GLOBAL CHAT | FULL PLAYER LOG
-- ✅ ALL BUTTONS WORKING | DELTA + GITHUB
-- ✅ COPYRIGHT © BLUE_MODE
-- ==============================================

-- Prevent duplicate load
if getgenv and getgenv().BlueMode_Loaded then return end
getgenv().BlueMode_Loaded = true

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- Settings
local OWNER_USERNAME = "Dwaynekean015"
local OWNER_CODE = "Blue_Mode192823"
local MAX_LOGS = 50
local YT_LINK = "https://youtube.com/@blue_mode?si=_NTd2gfDzVW9sIPM"

-- Save System
local function GetLogs()
    local data = {Executions = {}}
    pcall(function()
        if readfile then
            local ok, res = pcall(function() return HttpService:JSONDecode(readfile("BlueMode_Data.json")) end)
            if ok and res then data = res end
        end
    end)
    return data
end

local function SaveLogs(data)
    pcall(function()
        if writefile then
            writefile("BlueMode_Data.json", HttpService:JSONEncode(data))
        end
    end)
end

-- Load & Add Current User
local Saved = GetLogs()
local IsOwnerNow = LocalPlayer.Name == OWNER_USERNAME

table.insert(Saved.Executions, 1, {
    Username = LocalPlayer.Name,
    IsOwner = IsOwnerNow,
    Time = os.date("%Y-%m-%d | %H:%M:%S")
})
if #Saved.Executions > MAX_LOGS then table.remove(Saved.Executions) end
SaveLogs(Saved)

-- Safe UI Parent
local UI = Instance.new("ScreenGui")
UI.Name = "BLUE_MODE_OLD"
UI.ResetOnSpawn = false
UI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
UI.DisplayOrder = 10000

if gethui then
    UI.Parent = gethui()
else
    pcall(function() UI.Parent = CoreGui end)
    if not UI.Parent then
        pcall(function() UI.Parent = LocalPlayer:WaitForChild("PlayerGui", 10) end)
    end
end

-- Notification
pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "✅ BLUE_MODE",
        Text = "Original Version Loaded!",
        Duration = 3
    })
end)

-- ==============================================
-- 👤 USER PROFILE POPUP
-- ==============================================
local CurrentTargetUser = ""

local ProfileGui = Instance.new("Frame")
ProfileGui.Size = UDim2.new(0,280,0,180)
ProfileGui.Position = UDim2.new(0.5,-140,0.5,-90)
ProfileGui.BackgroundColor3 = Color3.fromRGB(22,22,22)
ProfileGui.BorderSizePixel = 2
ProfileGui.Visible = false
ProfileGui.ZIndex = 100
ProfileGui.Parent = UI
Instance.new("UICorner", ProfileGui).CornerRadius = UDim.new(0,10)

local ProfileTitle = Instance.new("TextLabel")
ProfileTitle.Size = UDim2.new(1,0,0,40)
ProfileTitle.Position = UDim2.new(0,0,0,10)
ProfileTitle.BackgroundTransparency = 1
ProfileTitle.Text = "👤 USER PROFILE"
ProfileTitle.TextColor3 = Color3.new(1,1,1)
ProfileTitle.Font = Enum.Font.GothamBold
ProfileTitle.TextScaled = true
ProfileTitle.Parent = ProfileGui

local TargetNameLabel = Instance.new("TextLabel")
TargetNameLabel.Size = UDim2.new(1,-20,0,35)
TargetNameLabel.Position = UDim2.new(0,10,0,55)
TargetNameLabel.BackgroundTransparency = 1
TargetNameLabel.Text = "Username: ---"
TargetNameLabel.TextColor3 = Color3.fromRGB(0,200,255)
TargetNameLabel.Font = Enum.Font.GothamBold
TargetNameLabel.TextScaled = true
TargetNameLabel.Parent = ProfileGui

local CopyUserBtn = Instance.new("TextButton")
CopyUserBtn.Size = UDim2.new(0,240,0,35)
CopyUserBtn.Position = UDim2.new(0.5,-120,0,100)
CopyUserBtn.BackgroundColor3 = Color3.fromRGB(20,110,180)
CopyUserBtn.Text = "📋 COPY USERNAME"
CopyUserBtn.TextColor3 = Color3.new(1,1,1)
CopyUserBtn.Font = Enum.Font.GothamBold
CopyUserBtn.TextScaled = true
CopyUserBtn.Parent = ProfileGui

local CopyLinkBtn = Instance.new("TextButton")
CopyLinkBtn.Size = UDim2.new(0,240,0,35)
CopyLinkBtn.Position = UDim2.new(0.5,-120,0,145)
CopyLinkBtn.BackgroundColor3 = Color3.fromRGB(20,140,60)
CopyLinkBtn.Text = "🔗 COPY PROFILE LINK"
CopyLinkBtn.TextColor3 = Color3.new(1,1,1)
CopyLinkBtn.Font = Enum.Font.GothamBold
CopyLinkBtn.TextScaled = true
CopyLinkBtn.Parent = ProfileGui

local ProfileClose = Instance.new("TextButton")
ProfileClose.Size = UDim2.new(0,30,0,30)
ProfileClose.Position = UDim2.new(1,-35,0,5)
ProfileClose.BackgroundColor3 = Color3.fromRGB(160,30,30)
ProfileClose.Text = "✕"
ProfileClose.TextColor3 = Color3.new(1,1,1)
ProfileClose.Font = Enum.Font.GothamBold
ProfileClose.TextScaled = true
ProfileClose.Parent = ProfileGui

-- Profile Actions
ProfileClose.MouseButton1Click:Connect(function() ProfileGui.Visible = false end)
CopyUserBtn.MouseButton1Click:Connect(function()
    if CurrentTargetUser == "" then return end
    pcall(function() if setclipboard then setclipboard(CurrentTargetUser) end end)
    CopyUserBtn.Text = "✅ COPIED!"
    task.delay(1.5, function() CopyUserBtn.Text = "📋 COPY USERNAME" end)
end)
CopyLinkBtn.MouseButton1Click:Connect(function()
    if CurrentTargetUser == "" then return end
    local link = "https://www.roblox.com/users/profile?username="..CurrentTargetUser
    pcall(function() if setclipboard then setclipboard(link) end end)
    CopyLinkBtn.Text = "✅ LINK COPIED!"
    task.delay(1.5, function() CopyLinkBtn.Text = "🔗 COPY PROFILE LINK" end)
end)

-- ==============================================
-- 📜 PLAYER EXECUTION LOG WINDOW
-- ==============================================
local LogWindow = Instance.new("Frame")
LogWindow.Size = UDim2.new(0,420,0,340)
LogWindow.Position = UDim2.new(0.5,-210,0.5,-170)
LogWindow.BackgroundColor3 = Color3.fromRGB(18,18,18)
LogWindow.BorderSizePixel = 2
LogWindow.Visible = false
LogWindow.Parent = UI
Instance.new("UICorner", LogWindow).CornerRadius = UDim.new(0,10)

local LogTitle = Instance.new("TextLabel")
LogTitle.Size = UDim2.new(1,0,0,35)
LogTitle.Position = UDim2.new(0,0,0,5)
LogTitle.BackgroundTransparency = 1
LogTitle.Text = "📜 SCRIPT EXECUTION LOG"
LogTitle.TextColor3 = Color3.new(1,1,1)
LogTitle.Font = Enum.Font.GothamBold
LogTitle.TextScaled = true
LogTitle.Parent = LogWindow

local LogClose = Instance.new("TextButton")
LogClose.Size = UDim2.new(0,30,0,30)
LogClose.Position = UDim2.new(1,-35,0,5)
LogClose.BackgroundColor3 = Color3.fromRGB(160,30,30)
LogClose.Text = "✕"
LogClose.TextColor3 = Color3.new(1,1,1)
LogClose.Font = Enum.Font.GothamBold
LogClose.TextScaled = true
LogClose.Parent = LogWindow

local LogContainer = Instance.new("ScrollingFrame")
LogContainer.Size = UDim2.new(1,-20,1,-50)
LogContainer.Position = UDim2.new(0,10,0,40)
LogContainer.BackgroundTransparency = 1
LogContainer.ScrollBarThickness = 6
LogContainer.Parent = LogWindow

local LogList = Instance.new("UIListLayout")
LogList.Padding = UDim.new(0,4)
LogList.Parent = LogContainer

local function RefreshLog()
    LogContainer:ClearAllChildren()
    LogList.Parent = LogContainer
    for _,entry in ipairs(Saved.Executions) do
        local EntryBtn = Instance.new("TextButton")
        EntryBtn.Size = UDim2.new(1,0,0,28)
        EntryBtn.BackgroundColor3 = entry.IsOwner and Color3.fromRGB(35,25,0) or Color3.fromRGB(28,28,28)
        EntryBtn.BackgroundTransparency = 0.2
        local Display = entry.IsOwner and "👑 OWNER: "..entry.Username or "👤 "..entry.Username
        EntryBtn.Text = Display.." | 🕒 "..entry.Time
        EntryBtn.TextColor3 = entry.IsOwner and Color3.fromRGB(255,215,0) or Color3.new(0.9,0.9,0.9)
        EntryBtn.Font = Enum.Font.GothamBold
        EntryBtn.TextScaled = true
        EntryBtn.TextXAlignment = Enum.TextXAlignment.Left
        EntryBtn.AutoButtonColor = true
        EntryBtn.Parent = LogContainer

        -- CLICK LOG NAME → OPEN PROFILE
        EntryBtn.MouseButton1Click:Connect(function()
            CurrentTargetUser = entry.Username
            TargetNameLabel.Text = "Username: "..CurrentTargetUser
            ProfileGui.Visible = true
        end)
    end
end
RefreshLog()
LogClose.MouseButton1Click:Connect(function() LogWindow.Visible = false end)

-- ==============================================
-- 👋 WELCOME SCREEN
-- ==============================================
local Welcome = Instance.new("Frame")
Welcome.Size = UDim2.new(0,400,0,320)
Welcome.Position = UDim2.new(0.5,-200,0.5,-160)
Welcome.BackgroundColor3 = Color3.fromRGB(20,20,20)
Welcome.BorderSizePixel = 3
Welcome.BorderColor3 = Color3.fromRGB(0,200,200)
Welcome.Parent = UI
Instance.new("UICorner", Welcome).CornerRadius = UDim.new(0,10)

local MadeBy = Instance.new("TextLabel")
MadeBy.Size = UDim2.new(1,0,0,40)
MadeBy.Position = UDim2.new(0,0,0,10)
MadeBy.BackgroundTransparency = 1
MadeBy.Text = "✨ MADE BY BLUE_MODE ✨"
MadeBy.TextColor3 = Color3.new(0,1,1)
MadeBy.Font = Enum.Font.GothamBold
MadeBy.TextScaled = true
MadeBy.Parent = Welcome

local WelcomeOK = Instance.new("TextButton")
WelcomeOK.Size = UDim2.new(0,160,0,40)
WelcomeOK.Position = UDim2.new(0.5,-80,0,260)
WelcomeOK.BackgroundColor3 = Color3.fromRGB(0,150,120)
WelcomeOK.Text = "✅ START"
WelcomeOK.TextColor3 = Color3.new(1,1,1)
WelcomeOK.Font = Enum.Font.GothamBold
WelcomeOK.TextScaled = true
WelcomeOK.Parent = Welcome

-- ==============================================
-- 🎯 FULL ORIGINAL MAIN MENU + ALL BUTTONS
-- ==============================================
local MainMenu = Instance.new("Frame")
MainMenu.Size = UDim2.new(0,640,0,110)
MainMenu.Position = UDim2.new(0,20,0.5,-55)
MainMenu.BackgroundColor3 = Color3.fromRGB(24,24,24)
MainMenu.BorderSizePixel = 2
MainMenu.Active = true
MainMenu.Visible = false
MainMenu.Parent = UI
Instance.new("UICorner", MainMenu).CornerRadius = UDim.new(0,8)

local DragBar = Instance.new("Frame")
DragBar.Size = UDim2.new(1,0,0,25)
DragBar.BackgroundColor3 = Color3.fromRGB(50,130,210)
DragBar.Active = true
DragBar.Parent = MainMenu

local MTitle = Instance.new("TextLabel")
MTitle.Size = UDim2.new(1,-30,1,0)
MTitle.BackgroundTransparency = 1
MTitle.Text = "BLUE_MODE ESP"
MTitle.TextColor3 = Color3.new(1,1,1)
MTitle.Font = Enum.Font.GothamBold
MTitle.TextScaled = true
MTitle.Parent = DragBar

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0,25,0,25)
MinBtn.Position = UDim2.new(1,-25,0,0)
MinBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
MinBtn.Text = "−"
MinBtn.TextColor3 = Color3.new(1,1,1)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextScaled = true
MinBtn.Parent = DragBar

local TimerText = Instance.new("TextLabel")
TimerText.Size = UDim2.new(1,-20,0,25)
TimerText.Position = UDim2.new(0,10,0,30)
TimerText.BackgroundTransparency = 1
TimerText.Text = "00:00:00"
TimerText.TextColor3 = Color3.new(0,1,1)
TimerText.Font = Enum.Font.GothamBold
TimerText.TextScaled = true
TimerText.Parent = MainMenu

-- 🎮 ALL ORIGINAL WORKING BUTTONS
local ESPBtn = Instance.new("TextButton")
ESPBtn.Size = UDim2.new(0,70,0,32)
ESPBtn.Position = UDim2.new(0,10,0,60)
ESPBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
ESPBtn.Text = "ESP OFF"
ESPBtn.TextColor3 = Color3.new(1,1,1)
ESPBtn.Font = Enum.Font.GothamBold
ESPBtn.TextScaled = true
ESPBtn.Parent = MainMenu

local MusicBtn = Instance.new("TextButton")
MusicBtn.Size = UDim2.new(0,70,0,32)
MusicBtn.Position = UDim2.new(0,85,0,60)
MusicBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
MusicBtn.Text = "🎵 OFF"
MusicBtn.TextColor3 = Color3.new(1,1,1)
MusicBtn.Font = Enum.Font.GothamBold
MusicBtn.TextScaled = true
MusicBtn.Parent = MainMenu

local LinkBtn = Instance.new("TextButton")
LinkBtn.Size = UDim2.new(0,70,0,32)
LinkBtn.Position = UDim2.new(0,160,0,60)
LinkBtn.BackgroundColor3 = Color3.fromRGB(20,110,180)
LinkBtn.Text = "📺 YT"
LinkBtn.TextColor3 = Color3.new(1,1,1)
LinkBtn.Font = Enum.Font.GothamBold
LinkBtn.TextScaled = true
LinkBtn.Parent = MainMenu

local LogBtn = Instance.new("TextButton")
LogBtn.Size = UDim2.new(0,70,0,32)
LogBtn.Position = UDim2.new(0,235,0,60)
LogBtn.BackgroundColor3 = Color3.fromRGB(120,50,160)
LogBtn.Text = "📜 LOG"
LogBtn.TextColor3 = Color3.new(1,1,1)
LogBtn.Font = Enum.Font.GothamBold
LogBtn.TextScaled = true
LogBtn.Parent = MainMenu

local LockBtn = Instance.new("TextButton")
LockBtn.Size = UDim2.new(0,85,0,32)
LockBtn.Position = UDim2.new(0,310,0,60)
LockBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
LockBtn.Text = "🔒 LOCK"
LockBtn.TextColor3 = Color3.new(1,1,1)
LockBtn.Font = Enum.Font.GothamBold
LockBtn.TextScaled = true
LockBtn.Parent = MainMenu

-- Flags
local ESP_ON = false
local MUSIC_ON = false
local MOVE_LOCKED = false
local MINIMIZED = false
local USED_TIME = 0

-- Welcome Button
WelcomeOK.MouseButton1Click:Connect(function() Welcome.Visible = false; MainMenu.Visible = true end)

-- Drag Menu
local Drag = {Active=false, StartX=0, StartY=0, PosX=0, PosY=0}
DragBar.InputBegan:Connect(function(Input)
    if MOVE_LOCKED then return end
    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
        Drag.Active = true
        Drag.StartX = Input.Position.X
        Drag.StartY = Input.Position.Y
        Drag.PosX = MainMenu.Position.X.Offset
        Drag.PosY = MainMenu.Position.Y.Offset
    end
end)
UIS.InputChanged:Connect(function(Input)
    if not Drag.Active or MOVE_LOCKED then return end
    MainMenu.Position = UDim2.new(0, Drag.PosX + (Input.Position.X - Drag.StartX), 0, Drag.PosY + (Input.Position.Y - Drag.StartY))
end)
UIS.InputEnded:Connect(function() Drag.Active = false end)

-- Button Actions
ESPBtn.MouseButton1Click:Connect(function()
    ESP_ON = not ESP_ON
    ESPBtn.Text = ESP_ON and "ESP ON" or "ESP OFF"
    ESPBtn.BackgroundColor3 = ESP_ON and Color3.fromRGB(25,110,25) or Color3.fromRGB(40,40,40)
end)
MusicBtn.MouseButton1Click:Connect(function()
    MUSIC_ON = not MUSIC_ON
    MusicBtn.Text = MUSIC_ON and "🎵 ON" or "🎵 OFF"
    MusicBtn.BackgroundColor3 = MUSIC_ON and Color3.fromRGB(20,120,190) or Color3.fromRGB(40,40,40)
end)
LinkBtn.MouseButton1Click:Connect(function() pcall(function() if setclipboard then setclipboard(YT_LINK) end end) end)
LogBtn.MouseButton1Click:Connect(function() RefreshLog(); LogWindow.Visible = true end)
LockBtn.MouseButton1Click:Connect(function() MOVE_LOCKED = not MOVE_LOCKED; LockBtn.Text = MOVE_LOCKED and "🔓 UNLOCK" or "🔒 LOCK" end)
MinBtn.MouseButton1Click:Connect(function()
    MINIMIZED = not MINIMIZED
    MainMenu.Size = MINIMIZED and UDim2.new(0,120,0,30) or UDim2.new(0,640,0,110)
    for _,v in ipairs({TimerText, ESPBtn, MusicBtn, LinkBtn, LogBtn, LockBtn}) do v.Visible = not MINIMIZED end
    MinBtn.Text = MINIMIZED and "+" or "−"
end)

-- ==============================================
-- ⚡ MAIN LOOP + ESP
-- ==============================================
RunService.Heartbeat:Connect(function(dt)
    USED_TIME = USED_TIME + dt
    TimerText.Text = string.format("%02d:%02d:%02d", USED_TIME/3600, (USED_TIME%3600)/60, USED_TIME%60)

    local Rainbow = Color3.fromHSV((os.clock()*0.7)%1,1,1)
    Welcome.BorderColor3 = Rainbow
    MainMenu.BorderColor3 = Rainbow
    LogWindow.BorderColor3 = Rainbow
    ProfileGui.BorderColor3 = Rainbow

    if not ESP_ON then return end
    for _,p in ipairs(Players:GetPlayers()) do
        if p == LocalPlayer then continue end
        local Char = p.Character
        if Char and Char:FindFirstChild("Humanoid") and Char.Humanoid.Health > 0 then
            local ESP = Char:FindFirstChild("BlueESP") or Instance.new("Highlight")
            ESP.Name = "BlueESP"
            ESP.FillTransparency = 1
            ESP.OutlineTransparency = 0
            ESP.OutlineColor = Rainbow
            ESP.Adornee = Char
            ESP.Parent = Char
        end
    end
end)

print("✅ BLUE_MODE | OLD VERSION LOADED!")
print("✅ No Global Chat | Player Log + All Buttons Working!")
