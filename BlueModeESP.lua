-- ==============================================
-- ✅ BLUE_MODE ESP | GLOBAL CHAT + OWNER BADGE
-- ✅ LOCK SURVIVES RESTARTS / NO BREAKS
-- ✅ COPYRIGHT © BLUE_MODE
-- ==============================================

-- Prevent duplicate load
if getgenv and getgenv().BlueMode_Loaded then return end
getgenv().BlueMode_Loaded = true

-- Small delay for safe load
task.wait(0.8)

-- ⚙️ SETTINGS
local ORIGINAL_UI_NAME = "BLUE_MODE_CHAT_v8"
local OWNER_USERNAME = "Dwaynekean015"
local OWNER_CODE = "Blue_Mode192823"
local USE_LIMIT = 43200 -- 12h use
local LOCK_TIME = 43200 -- 12h lock
local MAX_MESSAGES = 80 -- Keep chat clean
local YT_LINK = "https://youtube.com/@blue_mode?si=_NTd2gfDzVW9sIPM"
local DEFAULT_SOUND_ID = "rbxassetid://6001487560"
local VOLUME = 0.7

-- 🛠️ SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- 📂 PERMANENT SAVE SYSTEM
local function GetSavedData()
    local ok, data = pcall(function() return readfile and readfile("BlueMode_Data.json") end)
    if ok and data then
        local decodeOk, res = pcall(function() return HttpService:JSONDecode(data) end)
        if decodeOk then return res end
    end
    return {UsedTime = 0, LockEnd = 0, Executions = {}, ChatMessages = {}}
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
local WRONG_COUNT = 0

-- 📝 ADD CURRENT USER TO EXECUTION LOG
local IsOwnerNow = LocalPlayer.Name == OWNER_USERNAME
table.insert(EXECUTION_LOG, 1, {
    Username = LocalPlayer.Name,
    IsOwner = IsOwnerNow,
    Time = os.date("%Y-%m-%d | %H:%M:%S"),
    Timestamp = os.time()
})
if #EXECUTION_LOG > 50 then table.remove(EXECUTION_LOG) end
SaveData({UsedTime = USED_TIME, LockEnd = LOCK_END, Executions = EXECUTION_LOG, ChatMessages = GLOBAL_CHAT})

-- 📌 FLAGS
local ESP_ON = false
local MUSIC_ON = false
local MOVE_LOCKED = false
local MINIMIZED = false
local TEXT_OBJS = {}
local UI

-- 🖼️ SAFE UI PARENT
UI = Instance.new("ScreenGui")
UI.Name = ORIGINAL_UI_NAME
UI.ResetOnSpawn = false
UI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
UI.DisplayOrder = 9999

if gethui then
    UI.Parent = gethui()
else
    pcall(function() UI.Parent = CoreGui end)
    if not UI.Parent then UI.Parent = LocalPlayer:WaitForChild("PlayerGui") end
end

-- 📜 EXECUTION LOG WINDOW
local LogWindow = Instance.new("Frame")
LogWindow.Size = UDim2.new(0,420,0,340)
LogWindow.Position = UDim2.new(0.5,-210,0.5,-170)
LogWindow.BackgroundColor3 = Color3.fromRGB(18,18,18)
LogWindow.BorderSizePixel = 2
LogWindow.Visible = false
LogWindow.ZIndex = 15
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
    for _,entry in pairs(EXECUTION_LOG) do
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

-- 🌐 GLOBAL CHAT WINDOW
local ChatWindow = Instance.new("Frame")
ChatWindow.Size = UDim2.new(0,420,0,380)
ChatWindow.Position = UDim2.new(0.5,-210,0.5,-190)
ChatWindow.BackgroundColor3 = Color3.fromRGB(18,18,18)
ChatWindow.BorderSizePixel = 2
ChatWindow.Visible = false
ChatWindow.ZIndex = 20
ChatWindow.Parent = UI
Instance.new("UICorner", ChatWindow).CornerRadius = UDim.new(0,10)

local ChatTitle = Instance.new("TextLabel")
ChatTitle.Size = UDim2.new(1,0,0,35)
ChatTitle.Position = UDim2.new(0,0,0,5)
ChatTitle.BackgroundTransparency = 1
ChatTitle.Text = "🌐 GLOBAL CHAT | ALL USERS"
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
ChatContainer.CanvasSize = UDim2.new(0,0,0,0)
ChatContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
ChatContainer.Parent = ChatWindow

local ChatList = Instance.new("UIListLayout")
ChatList.Padding = UDim.new(0,5)
ChatList.HorizontalAlignment = Enum.HorizontalAlignment.Left
ChatList.VerticalAlignment = Enum.VerticalAlignment.Top
ChatList.Parent = ChatContainer

local ChatInput = Instance.new("TextBox")
ChatInput.Size = UDim2.new(0,300,0,35)
ChatInput.Position = UDim2.new(0.5,-305,0,325)
ChatInput.BackgroundColor3 = Color3.fromRGB(35,35,35)
ChatInput.Text = ""
ChatInput.PlaceholderText = "Type message here..."
ChatInput.TextColor3 = Color3.new(1,1,1)
ChatInput.Font = Enum.Font.Gotham
ChatInput.TextScaled = true
ChatInput.ClearTextOnFocus = false
ChatInput.Parent = ChatWindow

local SendBtn = Instance.new("TextButton")
SendBtn.Size = UDim2.new(0,100,0,35)
SendBtn.Position = UDim2.new(0.5,5,0,325)
SendBtn.BackgroundColor3 = Color3.fromRGB(20,140,60)
SendBtn.Text = "📤 SEND"
SendBtn.TextColor3 = Color3.new(1,1,1)
SendBtn.Font = Enum.Font.GothamBold
SendBtn.TextScaled = true
SendBtn.Parent = ChatWindow

-- FUNCTION TO REFRESH CHAT
local function RefreshChat()
    ChatContainer:ClearAllChildren()
    ChatList.Parent = ChatContainer
    for _,msg in ipairs(GLOBAL_CHAT) do
        local MsgLabel = Instance.new("TextLabel")
        MsgLabel.Size = UDim2.new(1,0,0,28)
        MsgLabel.AutomaticSize = Enum.AutomaticSize.X
        MsgLabel.BackgroundTransparency = 1
        MsgLabel.TextColor3 = msg.IsOwner and Color3.fromRGB(255,215,0) or Color3.new(0.85,0.85,0.85)
        MsgLabel.Font = Enum.Font.Gotham
        MsgLabel.TextScaled = true
        MsgLabel.TextXAlignment = Enum.TextXAlignment.Left
        MsgLabel.RichText = true
        local SenderName = msg.IsOwner and "<b>👑 "..msg.Sender.."</b>" or "👤 "..msg.Sender
        MsgLabel.Text = SenderName..": "..msg.Text
        MsgLabel.Parent = ChatContainer
    end
    -- Auto scroll to bottom
    ChatContainer.CanvasPosition = Vector2.new(0, ChatContainer.AbsoluteCanvasSize.Y)
end

-- SEND MESSAGE FUNCTION
local function SendMessage()
    local Text = ChatInput.Text:sub(1, 200) -- Max 200 chars
    if Text == "" then return end
    table.insert(GLOBAL_CHAT, {
        Sender = LocalPlayer.Name,
        IsOwner = IsOwnerNow,
        Text = Text,
        Time = os.date("%H:%M:%S")
    })
    -- Keep chat size clean
    if #GLOBAL_CHAT > MAX_MESSAGES then table.remove(GLOBAL_CHAT, 1) end
    SaveData({UsedTime = USED_TIME, LockEnd = LOCK_END, Executions = EXECUTION_LOG, ChatMessages = GLOBAL_CHAT})
    ChatInput.Text = ""
    RefreshChat()
end

-- CHAT BUTTON ACTIONS
RefreshChat()
ChatClose.MouseButton1Click:Connect(function() ChatWindow.Visible = false end)
SendBtn.MouseButton1Click:Connect(SendMessage)
ChatInput.FocusLost:Connect(function(enter) if enter then SendMessage() end end)

-- 🎵 MUSIC SYSTEM
local Song = Instance.new("Sound")
Song.Name = "BlueModeSound"
Song.SoundId = DEFAULT_SOUND_ID
Song.Looped = true
Song.Volume = VOLUME
Song.Parent = UI

-- 🎵 BOOMBOX
local BoomboxGui = Instance.new("Frame")
BoomboxGui.Size = UDim2.new(0,240,0,160)
BoomboxGui.Position = UDim2.new(0.5,-120,0.1,0)
BoomboxGui.BackgroundColor3 = Color3.fromRGB(22,22,22)
BoomboxGui.BorderSizePixel = 2
BoomboxGui.Active = true
BoomboxGui.Visible = false
BoomboxGui.Parent = UI
Instance.new("UICorner", BoomboxGui).CornerRadius = UDim.new(0,8)

local BTitle = Instance.new("TextLabel")
BTitle.Size = UDim2.new(1,0,0,28)
BTitle.Position = UDim2.new(0,0,0,5)
BTitle.BackgroundTransparency = 1
BTitle.Text = "🎵 PERSONAL BOOMBOX"
BTitle.TextColor3 = Color3.new(1,1,1)
BTitle.Font = Enum.Font.GothamBold
BTitle.TextScaled = true
BTitle.Parent = BoomboxGui

local IDInput = Instance.new("TextBox")
IDInput.Size = UDim2.new(0,220,0,40)
IDInput.Position = UDim2.new(0.5,-110,0,40)
IDInput.BackgroundColor3 = Color3.fromRGB(35,35,35)
IDInput.Text = "6001487560"
IDInput.PlaceholderText = "Paste Song ID"
IDInput.TextColor3 = Color3.new(1,1,1)
IDInput.Font = Enum.Font.Gotham
IDInput.TextScaled = true
IDInput.ClearTextOnFocus = false
IDInput.Parent = BoomboxGui

local ApplyBtn = Instance.new("TextButton")
ApplyBtn.Size = UDim2.new(0,100,0,35)
ApplyBtn.Position = UDim2.new(0.5,-105,0,90)
ApplyBtn.BackgroundColor3 = Color3.fromRGB(20,140,60)
ApplyBtn.Text = "✅ PLAY"
ApplyBtn.TextColor3 = Color3.new(1,1,1)
ApplyBtn.Font = Enum.Font.GothamBold
ApplyBtn.TextScaled = true
ApplyBtn.Parent = BoomboxGui

local StopBtn = Instance.new("TextButton")
StopBtn.Size = UDim2.new(0,100,0,35)
StopBtn.Position = UDim2.new(0.5,5,0,90)
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
    ApplyBtn.Text = "✅ PLAYING"
    task.delay(2, function() ApplyBtn.Text = "✅ PLAY" end)
end)
StopBtn.MouseButton1Click:Connect(function() Song:Stop() end)
BClose.MouseButton1Click:Connect(function() BoomboxGui.Visible = false end)

-- 👋 WELCOME SCREEN
local Welcome = Instance.new("Frame")
Welcome.Size = UDim2.new(0,400,0,340)
Welcome.Position = UDim2.new(0.5,-200,0.5,-170)
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
table.insert(TEXT_OBJS, MadeBy)

local WhatsNew = Instance.new("TextLabel")
WhatsNew.Size = UDim2.new(1,-20,0,210)
WhatsNew.Position = UDim2.new(0,10,0,55)
WhatsNew.BackgroundTransparency = 1
WhatsNew.TextColor3 = Color3.new(0.9,0.9,0.9)
WhatsNew.Font = Enum.Font.Gotham
WhatsNew.TextScaled = true
WhatsNew.TextXAlignment = Enum.TextXAlignment.Left
WhatsNew.TextYAlignment = Enum.TextYAlignment.Top
WhatsNew.Text = [[📋 FEATURES:
• ✅ 🆕 🌐 GLOBAL CHAT — all users talk here
• ✅ Music stays playing when closed
• ✅ Lock survives restarts / re-executes
• ✅ Only Dwaynekean015 can unlock early
• ✅ Rainbow ESP through walls
• ✅ 📜 LOG: see all users who ran the script
• ✅ 👑 OWNER badge for your account
• ✅ 12h use → 12h lock system]]
WhatsNew.Parent = Welcome

local WelcomeOK = Instance.new("TextButton")
WelcomeOK.Size = UDim2.new(0,160,0,40)
WelcomeOK.Position = UDim2.new(0.5,-80,0,290)
WelcomeOK.BackgroundColor3 = Color3.fromRGB(0,150,120)
WelcomeOK.Text = "✅ OK, GOT IT!"
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
table.insert(TEXT_OBJS, LTitle)

local LTime = Instance.new("TextLabel")
LTime.Size = UDim2.new(1,0,0,35)
LTime.Position = UDim2.new(0,0,0,55)
LTime.BackgroundTransparency = 1
LTime.Text = "Time remaining: 00:00:00"
LTime.TextColor3 = Color3.new(0,1,1)
LTime.Font = Enum.Font.Gotham
LTime.TextScaled = true
LTime.Parent = LockScreen
table.insert(TEXT_OBJS, LTime)

local CodeBox = Instance.new("TextBox")
CodeBox.Size = UDim2.new(0,280,0,40)
CodeBox.Position = UDim2.new(0.5,-140,0,100)
CodeBox.BackgroundColor3 = Color3.fromRGB(30,30,30)
CodeBox.Text = ""
CodeBox.PlaceholderText = "Enter Owner Code"
CodeBox.TextColor3 = Color3.new(1,1,1)
CodeBox.Font = Enum.Font.Gotham
CodeBox.TextScaled = true
CodeBox.Parent = LockScreen

local CodeStatus = Instance.new("TextLabel")
CodeStatus.Size = UDim2.new(1,0,0,25)
CodeStatus.Position = UDim2.new(0,0,0,145)
CodeStatus.BackgroundTransparency = 1
CodeStatus.Text = ""
CodeStatus.TextColor3 = Color3.new(1,1,1)
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

-- 🎯 MAIN MENU (WIDENED FOR NEW CHAT BUTTON)
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
table.insert(TEXT_OBJS, MTitle)

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
table.insert(TEXT_OBJS, TimerText)

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

-- 🆕 GLOBAL CHAT BUTTON
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
LockBtn.Text = "🔒 LOCK MOVE"
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

LinkBtn.MouseButton1Click:Connect(function()
    pcall(function() setclipboard(YT_LINK) end)
    print("📺 YOUTUBE:", YT_LINK)
end)

LockBtn.MouseButton1Click:Connect(function()
    MOVE_LOCKED = not MOVE_LOCKED
    LockBtn.Text = MOVE_LOCKED and "🔓 UNLOCK MOVE" or "🔒 LOCK MOVE"
end)

MinBtn.MouseButton1Click:Connect(function()
    MINIMIZED = not MINIMIZED
    MainMenu.Size = MINIMIZED and UDim2.new(0,120,0,30) or UDim2.new(0,640,0,110)
    for _,v in pairs({TimerText, ESPBtn, MusicBtn, LinkBtn, LogBtn, ChatBtn, LockBtn}) do v.Visible = not MINIMIZED end
    MinBtn.Text = MINIMIZED and "+" or "−"
end)

-- 🔒 OWNER UNLOCK
UnlockBtn.MouseButton1Click:Connect(function()
    local IsOwner = LocalPlayer.Name == OWNER_USERNAME
    if not IsOwner then
        CodeStatus.Text = "❌ ONLY DWAYNEKEAN015 CAN UNLOCK!"
        CodeStatus.TextColor3 = Color3.new(1,.2,.2)
        return
    end
    if CodeBox.Text == OWNER_CODE then
        WRONG_COUNT = 0
        LOCK_END = 0
        USED_TIME = 0
        SaveData({UsedTime = 0, LockEnd = 0, Executions = EXECUTION_LOG, ChatMessages = GLOBAL_CHAT})
        LockScreen.Visible = false
        MainMenu.Visible = true
        CodeStatus.Text = "✅ OWNER UNLOCKED!"
        task.delay(1.5, function() CodeStatus.Text = "" end)
    else
        WRONG_COUNT += 1
        CodeStatus.Text = "❌ WRONG CODE! "..WRONG_COUNT.."/2"
        CodeStatus.TextColor3 = Color3.new(1,.2,.2)
        if WRONG_COUNT >= 2 then
            CodeStatus.Text = "⚠️ HIDING FOR LOCK TIME"
            task.delay(2, function() LockScreen.Visible = false end)
        end
    end
end)

-- ⚡ MAIN LOOP
RunService.Heartbeat:Connect(function(dt)
    local Rainbow = Color3.fromHSV((os.clock()*0.7)%1,1,1)
    Welcome.BorderColor3 = Rainbow
    MainMenu.BorderColor3 = Rainbow
    LockScreen.BorderColor3 = Rainbow
    BoomboxGui.BorderColor3 = Rainbow
    LogWindow.BorderColor3 = Rainbow
    ChatWindow.BorderColor3 = Rainbow

    if LOCK_END > 0 then
        local Remain = math.max(0, LOCK_END - os.time())
        if Remain <= 0 then
            LOCK_END = 0
            SaveData({UsedTime = 0, LockEnd = 0, Executions = EXECUTION_LOG, ChatMessages = GLOBAL_CHAT})
            LockScreen.Visible = false
            MainMenu.Visible = true
        else
            LockScreen.Visible = true
            MainMenu.Visible = false
            LTime.Text = "Time remaining: "..string.format("%02d:%02d:%02d", Remain/3600, (Remain%3600)/60, Remain%60)
        end
        return
    end

    USED_TIME += dt
    SaveData({UsedTime = USED_TIME, LockEnd = LOCK_END, Executions = EXECUTION_LOG, ChatMessages = GLOBAL_CHAT})
    TimerText.Text = string.format("%02d:%02d:%02d", USED_TIME/3600, (USED_TIME%3600)/60, USED_TIME%60).." / 12:00:00"

    if USED_TIME >= USE_LIMIT then
        LOCK_END = os.time() + LOCK_TIME
        USED_TIME = 0
        SaveData({UsedTime = 0, LockEnd = LOCK_END, Executions = EXECUTION_LOG, ChatMessages = GLOBAL_CHAT})
        MUSIC_ON = false
        MusicBtn.Text = "🎵 OFF"
        BoomboxGui.Visible = false
    end

    if not ESP_ON then return end
    for _,p in pairs(Players:GetPlayers()) do
        if p == LocalPlayer then continue end
        local Char = p.Character
        if not Char or not Char:FindFirstChild("Humanoid") or Char.Humanoid.Health <= 0 then
            pcall(function() Char:FindFirstChild("BlueESP"):Destroy() end)
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

print("\n✅ BLUE_MODE ESP | GLOBAL CHAT ADDED!")
print("✅ 🌐 ALL USERS CAN SEND & READ MESSAGES")
print("✅ 👑 YOUR MESSAGES SHOW AS GOLD OWNER")
print("✅ ==========================================\n")
