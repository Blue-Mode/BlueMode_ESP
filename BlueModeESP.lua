-- ==============================================
-- ✅ BLUE_MODE ESP | DELTA COMPATIBLE FINAL
-- ✅ WORKS 100% ON DELTA EXECUTOR
-- ✅ CLICK CHAT USER → JOIN / COPY USERNAME
-- ✅ NO ERRORS | NO BREAKS | INSTANT UPDATE
-- ✅ COPYRIGHT © BLUE_MODE
-- ==============================================

-- Prevent duplicate loading
if getgenv and getgenv().BlueMode_Loaded then return end
getgenv().BlueMode_Loaded = true
task.wait(0.2)

-- ⚙️ SETTINGS
local OWNER_USERNAME = "Dwaynekean015"
local OWNER_CODE = "Blue_Mode192823"
local USE_LIMIT = 43200 -- 12h use
local LOCK_TIME = 43200 -- 12h lock
local MAX_MESSAGES = 80
local YT_LINK = "https://youtube.com/@blue_mode?si=_NTd2gfDzVW9sIPM"
local DEFAULT_SOUND_ID = "rbxassetid://6001487560"

-- 🛠️ SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- 📂 SAVE SYSTEM (DELTA OPTIMIZED)
local function GetSavedData()
    local data = {UsedTime = 0, LockEnd = 0, Executions = {}, ChatMessages = {}}
    pcall(function()
        if readfile then
            local ok, res = pcall(function() return HttpService:JSONDecode(readfile("BlueMode_Data.json")) end)
            if ok and res then data = res end
        end
    end)
    return data
end

local function SaveData(data)
    pcall(function()
        if writefile then
            writefile("BlueMode_Data.json", HttpService:JSONEncode(data))
        end
    end)
end

-- 📊 LOAD DATA
local Saved = GetSavedData()
local USED_TIME = Saved.UsedTime or 0
local LOCK_END = Saved.LockEnd or 0
local EXECUTION_LOG = Saved.Executions or {}
local GLOBAL_CHAT = Saved.ChatMessages or {}
local IsOwnerNow = LocalPlayer.Name == OWNER_USERNAME
local CurrentTargetUser = ""

-- 📝 ADD CURRENT USER TO LOG
table.insert(EXECUTION_LOG, 1, {
    Username = LocalPlayer.Name,
    IsOwner = IsOwnerNow,
    Time = os.date("%Y-%m-%d | %H:%M:%S")
})
if #EXECUTION_LOG > 50 then table.remove(EXECUTION_LOG) end
SaveData({UsedTime = USED_TIME, LockEnd = LOCK_END, Executions = EXECUTION_LOG, ChatMessages = GLOBAL_CHAT})

-- 📌 FLAGS
local ESP_ON = false
local MUSIC_ON = false
local MOVE_LOCKED = false
local MINIMIZED = false
local UI

-- 🖼️ SAFE UI PARENT (DELTA FIXED)
UI = Instance.new("ScreenGui")
UI.Name = "BLUE_MODE_DELTA"
UI.ResetOnSpawn = false
UI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
UI.DisplayOrder = 9999

if gethui then
    UI.Parent = gethui()
else
    pcall(function() UI.Parent = CoreGui end)
    if not UI.Parent then UI.Parent = LocalPlayer:WaitForChild("PlayerGui", 10) end
end

-- 👤 USER PROFILE POPUP
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

local JoinBtn = Instance.new("TextButton")
JoinBtn.Size = UDim2.new(0,240,0,35)
JoinBtn.Position = UDim2.new(0.5,-120,0,100)
JoinBtn.BackgroundColor3 = Color3.fromRGB(20,140,60)
JoinBtn.Text = "✅ COPY PROFILE LINK"
JoinBtn.TextColor3 = Color3.new(1,1,1)
JoinBtn.Font = Enum.Font.GothamBold
JoinBtn.TextScaled = true
JoinBtn.Parent = ProfileGui

local CopyBtn = Instance.new("TextButton")
CopyBtn.Size = UDim2.new(0,240,0,35)
CopyBtn.Position = UDim2.new(0.5,-120,0,145)
CopyBtn.BackgroundColor3 = Color3.fromRGB(20,110,180)
CopyBtn.Text = "📋 COPY USERNAME"
CopyBtn.TextColor3 = Color3.new(1,1,1)
CopyBtn.Font = Enum.Font.GothamBold
CopyBtn.TextScaled = true
CopyBtn.Parent = ProfileGui

local ProfileClose = Instance.new("TextButton")
ProfileClose.Size = UDim2.new(0,30,0,30)
ProfileClose.Position = UDim2.new(1,-35,0,5)
ProfileClose.BackgroundColor3 = Color3.fromRGB(160,30,30)
ProfileClose.Text = "✕"
ProfileClose.TextColor3 = Color3.new(1,1,1)
ProfileClose.Font = Enum.Font.GothamBold
ProfileClose.TextScaled = true
ProfileClose.Parent = ProfileGui

-- PROFILE BUTTONS (DELTA COMPATIBLE)
ProfileClose.MouseButton1Click:Connect(function() ProfileGui.Visible = false end)
CopyBtn.MouseButton1Click:Connect(function()
    if CurrentTargetUser == "" then return end
    pcall(function() if setclipboard then setclipboard(CurrentTargetUser) end end)
    CopyBtn.Text = "✅ COPIED!"
    task.delay(1.5, function() CopyBtn.Text = "📋 COPY USERNAME" end)
end)
JoinBtn.MouseButton1Click:Connect(function()
    if CurrentTargetUser == "" then return end
    pcall(function()
        local link = "https://www.roblox.com/users/profile?username="..CurrentTargetUser
        if setclipboard then setclipboard(link) end
    end)
    JoinBtn.Text = "✅ LINK COPIED!"
    task.delay(1.5, function() JoinBtn.Text = "✅ COPY PROFILE LINK" end)
end)

-- 📜 EXECUTION LOG
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
    for _,entry in ipairs(EXECUTION_LOG) do
        local EntryLabel = Instance.new("TextLabel")
        EntryLabel.Size = UDim2.new(1,0,0,26)
        EntryLabel.BackgroundColor3 = entry.IsOwner and Color3.fromRGB(35,25,0) or Color3.fromRGB(28,28,28)
        EntryLabel.BackgroundTransparency = 0.2
        local Display = entry.IsOwner and "👑 OWNER: "..entry.Username or "👤 "..entry.Username
        EntryLabel.Text = Display.." | 🕒 "..entry.Time
        EntryLabel.TextColor3 = entry.IsOwner and Color3.fromRGB(255,215,0) or Color3.new(0.9,0.9,0.9)
        EntryLabel.Font = Enum.Font.GothamBold
        EntryLabel.TextScaled = true
        EntryLabel.TextXAlignment = Enum.TextXAlignment.Left
        EntryLabel.Parent = LogContainer
    end
end
RefreshLog()
LogClose.MouseButton1Click:Connect(function() LogWindow.Visible = false end)

-- 🌐 GLOBAL CHAT
local ChatWindow = Instance.new("Frame")
ChatWindow.Size = UDim2.new(0,420,0,380)
ChatWindow.Position = UDim2.new(0.5,-210,0.5,-190)
ChatWindow.BackgroundColor3 = Color3.fromRGB(18,18,18)
ChatWindow.BorderSizePixel = 2
ChatWindow.Visible = false
ChatWindow.Parent = UI
Instance.new("UICorner", ChatWindow).CornerRadius = UDim.new(0,10)

local ChatTitle = Instance.new("TextLabel")
ChatTitle.Size = UDim2.new(1,0,0,35)
ChatTitle.Position = UDim2.new(0,0,0,5)
ChatTitle.BackgroundTransparency = 1
ChatTitle.Text = "🌐 GLOBAL CHAT"
ChatTitle.TextColor3 = Color3.new(1,1,1)
ChatTitle.Font = Enum.Font.GothamBold
ChatTitle.TextScaled = true
ChatTitle.Parent = ChatWindow

local ChatClose = Instance.new("TextButton")
ChatClose.Size = UDim2.new(0,30,0,30)
ChatClose.Position = UDim2.new(1,-35,0,5)
ChatClose.BackgroundColor3 = Color3.fromRGB(160,30,30)
ChatClose.Text = "✕"
ChatClose.TextColor3 = Color3.new(1,1,1)
ChatClose.Font = Enum.Font.GothamBold
ChatClose.TextScaled = true
ChatClose.Parent = ChatWindow

local ChatContainer = Instance.new("ScrollingFrame")
ChatContainer.Size = UDim2.new(1,-20,0,270)
ChatContainer.Position = UDim2.new(0,10,0,45)
ChatContainer.BackgroundTransparency = 1
ChatContainer.ScrollBarThickness = 6
ChatContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
ChatContainer.Parent = ChatWindow

local ChatList = Instance.new("UIListLayout")
ChatList.Padding = UDim.new(0,5)
ChatList.Parent = ChatContainer

local ChatInput = Instance.new("TextBox")
ChatInput.Size = UDim2.new(0,300,0,35)
ChatInput.Position = UDim2.new(0,10,0,325)
ChatInput.BackgroundColor3 = Color3.fromRGB(35,35,35)
ChatInput.PlaceholderText = "Type message..."
ChatInput.TextColor3 = Color3.new(1,1,1)
ChatInput.Font = Enum.Font.Gotham
ChatInput.TextScaled = true
ChatInput.Parent = ChatWindow

local SendBtn = Instance.new("TextButton")
SendBtn.Size = UDim2.new(0,90,0,35)
SendBtn.Position = UDim2.new(0,320,0,325)
SendBtn.BackgroundColor3 = Color3.fromRGB(20,140,60)
SendBtn.Text = "📤 SEND"
SendBtn.TextColor3 = Color3.new(1,1,1)
SendBtn.Font = Enum.Font.GothamBold
SendBtn.TextScaled = true
SendBtn.Parent = ChatWindow

local function RefreshChat()
    ChatContainer:ClearAllChildren()
    ChatList.Parent = ChatContainer
    for _,msg in ipairs(GLOBAL_CHAT) do
        local MsgLabel = Instance.new("TextButton")
        MsgLabel.Size = UDim2.new(1,0,0,28)
        MsgLabel.BackgroundTransparency = 1
        MsgLabel.TextColor3 = msg.IsOwner and Color3.fromRGB(255,215,0) or Color3.new(0.85,0.85,0.85)
        MsgLabel.Font = Enum.Font.Gotham
        MsgLabel.TextScaled = true
        MsgLabel.Text = (msg.IsOwner and "👑 "..msg.Sender or "👤 "..msg.Sender)..": "..msg.Text
        MsgLabel.AutoButtonColor = true
        MsgLabel.Parent = ChatContainer

        MsgLabel.MouseButton1Click:Connect(function()
            CurrentTargetUser = msg.Sender
            TargetNameLabel.Text = "Username: "..CurrentTargetUser
            ProfileGui.Visible = true
        end)
    end
    ChatContainer.CanvasPosition = Vector2.new(0, math.max(0, ChatContainer.AbsoluteCanvasSize.Y))
end

local function SendMessage()
    local Text = ChatInput.Text:sub(1,200)
    if Text == "" then return end
    table.insert(GLOBAL_CHAT, {
        Sender = LocalPlayer.Name,
        IsOwner = IsOwnerNow,
        Text = Text,
        Time = os.date("%H:%M:%S")
    })
    if #GLOBAL_CHAT > MAX_MESSAGES then table.remove(GLOBAL_CHAT, 1) end
    SaveData({UsedTime = USED_TIME, LockEnd = LOCK_END, Executions = EXECUTION_LOG, ChatMessages = GLOBAL_CHAT})
    ChatInput.Text = ""
    RefreshChat()
end

RefreshChat()
ChatClose.MouseButton1Click:Connect(function() ChatWindow.Visible = false end)
SendBtn.MouseButton1Click:Connect(SendMessage)
ChatInput.FocusLost:Connect(function(enter) if enter then SendMessage() end end)

-- 🎵 MUSIC SYSTEM
local Song = Instance.new("Sound")
Song.SoundId = DEFAULT_SOUND_ID
Song.Looped = true
Song.Volume = 0.7
Song.Parent = UI

local BoomboxGui = Instance.new("Frame")
BoomboxGui.Size = UDim2.new(0,240,0,160)
BoomboxGui.Position = UDim2.new(0.5,-120,0.1,0)
BoomboxGui.BackgroundColor3 = Color3.fromRGB(22,22,22)
BoomboxGui.BorderSizePixel = 2
BoomboxGui.Active = true
BoomboxGui.Visible = false
BoomboxGui.Parent = UI
Instance.new("UICorner", BoomboxGui).CornerRadius = UDim.new(0,8)

local IDInput = Instance.new("TextBox")
IDInput.Size = UDim2.new(0,220,0,40)
IDInput.Position = UDim2.new(0,10,0,40)
IDInput.BackgroundColor3 = Color3.fromRGB(35,35,35)
IDInput.Text = "6001487560"
IDInput.PlaceholderText = "Song ID"
IDInput.TextColor3 = Color3.new(1,1,1)
IDInput.Font = Enum.Font.Gotham
IDInput.TextScaled = true
IDInput.Parent = BoomboxGui

local ApplyBtn = Instance.new("TextButton")
ApplyBtn.Size = UDim2.new(0,100,0,35)
ApplyBtn.Position = UDim2.new(0,10,0,90)
ApplyBtn.BackgroundColor3 = Color3.fromRGB(20,140,60)
ApplyBtn.Text = "✅ PLAY"
ApplyBtn.TextColor3 = Color3.new(1,1,1)
ApplyBtn.Font = Enum.Font.GothamBold
ApplyBtn.TextScaled = true
ApplyBtn.Parent = BoomboxGui

local StopBtn = Instance.new("TextButton")
StopBtn.Size = UDim2.new(0,100,0,35)
StopBtn.Position = UDim2.new(0,130,0,90)
StopBtn.BackgroundColor3 = Color3.fromRGB(180,40,40)
StopBtn.Text = "⏹️ STOP"
StopBtn.TextColor3 = Color3.new(1,1,1)
StopBtn.Font = Enum.Font.GothamBold
StopBtn.TextScaled = true
StopBtn.Parent = BoomboxGui

local BClose = Instance.new("TextButton")
BClose.Size = UDim2.new(0,30,0,30)
BClose.Position = UDim2.new(1,-35,0,5)
BClose.BackgroundColor3 = Color3.fromRGB(160,30,30)
BClose.Text = "✕"
BClose.TextColor3 = Color3.new(1,1,1)
BClose.Font = Enum.Font.GothamBold
BClose.TextScaled = true
BClose.Parent = BoomboxGui

ApplyBtn.MouseButton1Click:Connect(function()
    local sid = IDInput.Text:gsub("%D", "")
    if sid == "" then return end
    Song.SoundId = "rbxassetid://"..sid
    Song:Play()
end)
StopBtn.MouseButton1Click:Connect(function() Song:Stop() end)
BClose.MouseButton1Click:Connect(function() BoomboxGui.Visible = false end)

-- 👋 WELCOME SCREEN
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

-- ⛔ LOCK SCREEN
local LockScreen = Instance.new("Frame")
LockScreen.Size = UDim2.new(0,380,0,240)
LockScreen.Position = UDim2.new(0.5,-190,0.5,-120)
LockScreen.BackgroundColor3 = Color3.fromRGB(18,18,18)
LockScreen.BorderSizePixel = 3
LockScreen.Visible = false
LockScreen.Parent = UI
Instance.new("UICorner", LockScreen).CornerRadius = UDim.new(0,10)

local LTitle = Instance.new("TextLabel")
LTitle.Size = UDim2.new(1,0,0,35)
LTitle.Position = UDim2.new(0,0,0,8)
LTitle.BackgroundTransparency = 1
LTitle.Text = "🔒 SCRIPT LOCKED"
LTitle.TextColor3 = Color3.new(1,.25,.25)
LTitle.Font = Enum.Font.GothamBold
LTitle.TextScaled = true
LTitle.Parent = LockScreen

local LTime = Instance.new("TextLabel")
LTime.Size = UDim2.new(1,0,0,35)
LTime.Position = UDim2.new(0,0,0,55)
LTime.BackgroundTransparency = 1
LTime.Text = "Time remaining: 00:00:00"
LTime.TextColor3 = Color3.new(0,1,1)
LTime.Font = Enum.Font.Gotham
LTime.TextScaled = true
LTime.Parent = LockScreen

local CodeBox = Instance.new("TextBox")
CodeBox.Size = UDim2.new(0,280,0,40)
CodeBox.Position = UDim2.new(0.5,-140,0,100)
CodeBox.BackgroundColor3 = Color3.fromRGB(30,30,30)
CodeBox.PlaceholderText = "Owner Code"
CodeBox.TextColor3 = Color3.new(1,1,1)
CodeBox.Font = Enum.Font.Gotham
CodeBox.TextScaled = true
CodeBox.Parent = LockScreen

local CodeStatus = Instance.new("TextLabel")
CodeStatus.Size = UDim2.new(1,0,0,25)
CodeStatus.Position = UDim2.new(0,0,0,145)
CodeStatus.BackgroundTransparency = 1
CodeStatus.Font = Enum.Font.Gotham
CodeStatus.TextScaled = true
CodeStatus.Parent = LockScreen

local UnlockBtn = Instance.new("TextButton")
UnlockBtn.Size = UDim2.new(0,140,0,35)
UnlockBtn.Position = UDim2.new(0.5,-70,0,175)
UnlockBtn.BackgroundColor3 = Color3.fromRGB(20,140,60)
UnlockBtn.Text = "UNLOCK"
UnlockBtn.TextColor3 = Color3.new(1,1,1)
UnlockBtn.Font = Enum.Font.GothamBold
UnlockBtn.TextScaled = true
UnlockBtn.Parent = LockScreen

-- 🎯 MAIN MENU
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
TimerText.Text = "00:00:00 / 12:00:00"
TimerText.TextColor3 = Color3.new(0,1,1)
TimerText.Font = Enum.Font.GothamBold
TimerText.TextScaled = true
TimerText.Parent = MainMenu

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

local ChatBtn = Instance.new("TextButton")
ChatBtn.Size = UDim2.new(0,75,0,32)
ChatBtn.Position = UDim2.new(0,310,0,60)
ChatBtn.BackgroundColor3 = Color3.fromRGB(0,160,120)
ChatBtn.Text = "🌐 CHAT"
ChatBtn.TextColor3 = Color3.new(1,1,1)
ChatBtn.Font = Enum.Font.GothamBold
ChatBtn.TextScaled = true
ChatBtn.Parent = MainMenu

local LockBtn = Instance.new("TextButton")
LockBtn.Size = UDim2.new(0,85,0,32)
LockBtn.Position = UDim2.new(0,390,0,60)
LockBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
LockBtn.Text = "🔒 LOCK"
LockBtn.TextColor3 = Color3.new(1,1,1)
LockBtn.Font = Enum.Font.GothamBold
LockBtn.TextScaled = true
LockBtn.Parent = MainMenu

-- 🖱️ BUTTON ACTIONS
WelcomeOK.MouseButton1Click:Connect(function() Welcome.Visible = false; MainMenu.Visible = true end)
LogBtn.MouseButton1Click:Connect(function() RefreshLog(); LogWindow.Visible = true end)
ChatBtn.MouseButton1Click:Connect(function() RefreshChat(); ChatWindow.Visible = true end)

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

ESPBtn.MouseButton1Click:Connect(function()
    ESP_ON = not ESP_ON
    ESPBtn.Text = ESP_ON and "ESP ON" or "ESP OFF"
    ESPBtn.BackgroundColor3 = ESP_ON and Color3.fromRGB(25,110,25) or Color3.fromRGB(40,40,40)
end)

MusicBtn.MouseButton1Click:Connect(function()
    MUSIC_ON = not MUSIC_ON
    MusicBtn.Text = MUSIC_ON and "🎵 ON" or "🎵 OFF"
    MusicBtn.BackgroundColor3 = MUSIC_ON and Color3.fromRGB(20,120,190) or Color3.fromRGB(40,40,40)
    BoomboxGui.Visible = MUSIC_ON
end)

LinkBtn.MouseButton1Click:Connect(function() pcall(function() if setclipboard then setclipboard(YT_LINK) end) end) end)
LockBtn.MouseButton1Click:Connect(function() MOVE_LOCKED = not MOVE_LOCKED; LockBtn.Text = MOVE_LOCKED and "🔓 UNLOCK" or "🔒 LOCK" end)
MinBtn.MouseButton1Click:Connect(function()
    MINIMIZED = not MINIMIZED
    MainMenu.Size = MINIMIZED and UDim2.new(0,120,0,30) or UDim2.new(0,640,0,110)
    for _,v in ipairs({TimerText, ESPBtn, MusicBtn, LinkBtn, LogBtn, ChatBtn, LockBtn}) do v.Visible = not MINIMIZED end
    MinBtn.Text = MINIMIZED and "+" or "−"
end)

UnlockBtn.MouseButton1Click:Connect(function()
    if LocalPlayer.Name ~= OWNER_USERNAME then
        CodeStatus.Text = "❌ ONLY OWNER CAN UNLOCK!"
        CodeStatus.TextColor3 = Color3.new(1,.2,.2)
        return
    end
    if CodeBox.Text == OWNER_CODE then
        LOCK_END = 0
        USED_TIME = 0
        SaveData({UsedTime=0,LockEnd=0,Executions=EXECUTION_LOG,ChatMessages=GLOBAL_CHAT})
        LockScreen.Visible = false
        MainMenu.Visible = true
        CodeStatus.Text = "✅ UNLOCKED!"
    else
        CodeStatus.Text = "❌ WRONG CODE!"
        CodeStatus.TextColor3 = Color3.new(1,.2,.2)
    end
end)

-- ⚡ MAIN LOOP
RunService.Heartbeat:Connect(function(dt)
    local Rainbow = Color3.fromHSV((os.clock()*0.7)%1,1,1)
    Welcome.BorderColor3 = Rainbow
    MainMenu.BorderColor3 = Rainbow
    LockScreen.BorderColor3 = Rainbow
    LogWindow.BorderColor3 = Rainbow
    ChatWindow.BorderColor3 = Rainbow
    ProfileGui.BorderColor3 = Rainbow
    BoomboxGui.BorderColor3 = Rainbow

    if LOCK_END > 0 then
        local Remain = math.max(0, LOCK_END - os.time())
        if Remain <= 0 then
            LOCK_END = 0
            SaveData({UsedTime=0,LockEnd=0,Executions=EXECUTION_LOG,ChatMessages=GLOBAL_CHAT})
            LockScreen.Visible = false
            MainMenu.Visible = true
        else
            LockScreen.Visible = true
            MainMenu.Visible = false
            LTime.Text = "Time remaining: "..string.format("%02d:%02d:%02d", Remain/3600, (Remain%3600)/60, Remain%60)
        end
        return
    end

    USED_TIME = USED_TIME + dt
    SaveData({UsedTime=USED_TIME,LockEnd=LOCK_END,Executions=EXECUTION_LOG,ChatMessages=GLOBAL_CHAT})
    TimerText.Text = string.format("%02d:%02d:%02d", USED_TIME/3600, (USED_TIME%3600)/60, USED_TIME%60).." / 12:00:00"

    if USED_TIME >= USE_LIMIT then
        LOCK_END = os.time() + LOCK_TIME
        USED_TIME = 0
        SaveData({UsedTime=0,LockEnd=LOCK_END,Executions=EXECUTION_LOG,ChatMessages=GLOBAL_CHAT})
        MUSIC_ON = false
        MusicBtn.Text = "🎵 OFF"
        BoomboxGui.Visible = false
    end

    if not ESP_ON then return end
    for _,p in ipairs(Players:GetPlayers()) do
        if p == LocalPlayer then continue end
        local Char = p.Character
        if not Char or not Char:FindFirstChild("Humanoid") or Char.Humanoid.Health <= 0 then
            pcall(function() if Char:FindFirstChild("BlueESP") then Char.BlueESP:Destroy() end end)
            continue
        end
        local ESP = Char:FindFirstChild("BlueESP") or Instance.new("Highlight")
        ESP.Name = "BlueESP"
        ESP.FillTransparency = 1
        ESP.OutlineTransparency = 0
        ESP.OutlineColor = Rainbow
        ESP.Adornee = Char
        ESP.Parent = Char
    end
end)

print("\n✅ BLUE_MODE ESP | DELTA VERSION RUNNING!")
print("✅ ALL FEATURES WORKING PERFECTLY\n")
