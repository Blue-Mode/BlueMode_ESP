-- ==============================================
-- COPYRIGHT © BLUE_MODE | ALL RIGHTS RESERVED
-- UNAUTHORIZED REBRANDING, MODIFICATION, OR CLAIMING AS OWN IS FORBIDDEN
-- ANTI-COPY / ANTI-REBRAND / ANTI-TAMPER PROTECTION ACTIVE
-- ==============================================

-- Block duplicate running
if getgenv and getgenv().BlueMode_Protected then
    warn("❌ ALREADY RUNNING OR PROTECTED!")
    return
end
getgenv().BlueMode_Protected = true

-- 🚫 BLOCK ALL DUMPING/EXTRACTION
local BLOCK = function() return end
getfenv = BLOCK
getrawmetatable = BLOCK
setrawmetatable = BLOCK
debug.getupvalue = BLOCK
debug.setupvalue = BLOCK
debug.getlocal = BLOCK
debug.setlocal = BLOCK
debug.getregistry = BLOCK
newcclosure = BLOCK
hookfunction = BLOCK
sethiddenproperty = BLOCK
writefile = BLOCK
appendfile = BLOCK
savefile = BLOCK
readfile = BLOCK
delfile = BLOCK
setclipboard = BLOCK
if set_clipboard then set_clipboard = BLOCK end

-- 🚫 ANTI-REBRAND / ANTI-TAMPER CHECK
local ORIGINAL_CHECKS = {
    OwnerName = "Blue_Mode",
    ScriptName = "BLUE_MODE ESP",
    OwnerCode = "Blue_Mode192823",
    YTLink = "https://youtube.com/@blue_mode",
    VerifyKey = "BM_ESP_2026_PROTECTED"
}

local Tampered = false
local function DetectTamper()
    local Source = debug.getinfo(1,'S').source
    if type(Source) == "string" then
        if not Source:find("Blue.Mode") and not Source:find("blue_mode") and not Source:find("BlueMode") then
            Tampered = true
        end
    end
    return Tampered
end

local function ForceCredit()
    local OldNew = Instance.new
    Instance.new = function(Class, Parent)
        local Obj = OldNew(Class, Parent)
        if Class == "TextLabel" or Class == "TextButton" then
            Obj:GetPropertyChangedSignal("Text"):Connect(function()
                if Obj.Text:find("ESP") or Obj.Text:find("Menu") or Obj.Text:find("Script") then
                    if not Obj.Text:find("Blue_Mode") and not Obj.Text:find("BLUE_MODE") then
                        Obj.Text = Obj.Text.."\n⚠️ ORIGINAL BY BLUE_MODE"
                        Obj.TextColor3 = Color3.new(1,0,0)
                    end
                end
            end)
        end
        return Obj
    end
end

-- 🚫 RUN TAMPER CHECK ON START
if DetectTamper() then
    warn("⛔ TAMPERING DETECTED! THIS SCRIPT IS ORIGINALLY BY BLUE_MODE.")
    warn("⛔ REBRANDING OR CLAIMING AS YOUR OWN IS NOT ALLOWED.")
    task.wait(3)
    return
end

-- 🚫 FORCE YOUR CREDIT TO STAY VISIBLE
ForceCredit()

-- ==============================================
-- BLUE_MODE ESP | FULL FEATURED VERSION
-- ==============================================

-- 🛠️ SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- ⚙️ SETTINGS
local USE_LIMIT = 43200 -- 12 HOURS
local LOCK_TIME = 43200 -- 12 HOUR LOCK
local OWNER_CODE = "Blue_Mode192823"
local YT_LINK = "https://youtube.com/@blue_mode?si=_NTd2gfDzVW9sIPM"
local DEFAULT_SOUND_ID = "rbxassetid://6001487560"
local VOLUME = 0.7

-- 📊 VARIABLES
local USED_TIME = 0
local LOCK_END = 0
local WRONG_COUNT = 0
local ESP_ON = false
local MUSIC_ON = false
local MOVE_LOCKED = false -- FALSE = CAN DRAG | TRUE = CANNOT DRAG
local MINIMIZED = false
local SCRIPT_HIDDEN = false
local CONNECTIONS = {}
local TEXT_OBJS = {}

-- 🖼️ SAFE UI PARENT
local UI = Instance.new("ScreenGui")
UI.Name = "BLUE_MODE_FULL_PROTECTED"
UI.ResetOnSpawn = false
UI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
UI.DisplayOrder = 9999

if gethui then
    UI.Parent = gethui()
else
    pcall(function() UI.Parent = CoreGui end)
    if not UI.Parent then UI.Parent = LocalPlayer:WaitForChild("PlayerGui") end
end

-- 🎵 MUSIC SYSTEM
local Song = Instance.new("Sound")
Song.Name = "BlueModeSound"
Song.SoundId = DEFAULT_SOUND_ID
Song.Looped = true
Song.Volume = VOLUME
Song.Parent = UI

-- 🎵 BOOMBOX GUI
local BoomboxGui = Instance.new("Frame")
BoomboxGui.Size = UDim2.new(0,220,0,140)
BoomboxGui.Position = UDim2.new(0.5,-110,0.5,-70)
BoomboxGui.BackgroundColor3 = Color3.fromRGB(22,22,22)
BoomboxGui.BorderSizePixel = 2
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
IDInput.Size = UDim2.new(0,200,0,35)
IDInput.Position = UDim2.new(0.5,-100,0,38)
IDInput.BackgroundColor3 = Color3.fromRGB(35,35,35)
IDInput.Text = DEFAULT_SOUND_ID
IDInput.PlaceholderText = "Paste Sound/Boombox ID"
IDInput.TextColor3 = Color3.new(1,1,1)
IDInput.Font = Enum.Font.Gotham
IDInput.TextScaled = true
IDInput.Parent = BoomboxGui

local ApplyBtn = Instance.new("TextButton")
ApplyBtn.Size = UDim2.new(0,90,0,30)
ApplyBtn.Position = UDim2.new(0.5,-95,0,80)
ApplyBtn.BackgroundColor3 = Color3.fromRGB(20,140,60)
ApplyBtn.Text = "✅ USE ID"
ApplyBtn.TextColor3 = Color3.new(1,1,1)
ApplyBtn.Font = Enum.Font.GothamBold
ApplyBtn.TextScaled = true
ApplyBtn.Parent = BoomboxGui

local BClose = Instance.new("TextButton")
BClose.Size = UDim2.new(0,30,0,30)
BClose.Position = UDim2.new(1,-35,0,5)
BClose.BackgroundColor3 = Color3.fromRGB(160,30,30)
BClose.Text = "✕"
BClose.TextColor3 = Color3.new(1,1,1)
BClose.Font = Enum.Font.GothamBold
BClose.TextScaled = true
BClose.Parent = BoomboxGui

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
table.insert(TEXT_OBJS, MadeBy)

local WhatsNew = Instance.new("TextLabel")
WhatsNew.Size = UDim2.new(1,-20,0,190)
WhatsNew.Position = UDim2.new(0,10,0,55)
WhatsNew.BackgroundTransparency = 1
WhatsNew.TextColor3 = Color3.new(0.9,0.9,0.9)
WhatsNew.Font = Enum.Font.Gotham
WhatsNew.TextScaled = true
WhatsNew.TextXAlignment = Enum.TextXAlignment.Left
WhatsNew.TextYAlignment = Enum.TextYAlignment.Top
WhatsNew.Text = [[📋 WHAT'S NEW:
• ✅ Fixed drag lock logic
• ✅ Added delete button with confirm
• ✅ Fixed music & custom ID
• ✅ 12h use → 12h lock system
• ✅ Owner unlock: Blue_Mode192823
• ✅ 2 wrong codes = hide until unlock
• ✅ Draggable + lock drag
• ✅ Minimize/Maximize menu
• ✅ Rainbow dot only on friends
• ✅ YouTube link copy button
• ✅ Anti-copy / Anti-rebrand protection]]
WhatsNew.Parent = Welcome

local WelcomeOK = Instance.new("TextButton")
WelcomeOK.Size = UDim2.new(0,160,0,40)
WelcomeOK.Position = UDim2.new(0.5,-80,0,260)
WelcomeOK.BackgroundColor3 = Color3.fromRGB(0,150,120)
WelcomeOK.Text = "✅ OK, GOT IT!"
WelcomeOK.TextColor3 = Color3.new(1,1,1)
WelcomeOK.Font = Enum.Font.GothamBold
WelcomeOK.TextScaled = true
WelcomeOK.Parent = Welcome

-- 🗑️ DELETE CONFIRM POPUP
local DeletePopup = Instance.new("Frame")
DeletePopup.Size = UDim2.new(0,320,0,150)
DeletePopup.Position = UDim2.new(0.5,-160,0.5,-75)
DeletePopup.BackgroundColor3 = Color3.fromRGB(22,22,22)
DeletePopup.BorderSizePixel = 3
DeletePopup.BorderColor3 = Color3.fromRGB(220,40,40)
DeletePopup.Visible = false
DeletePopup.ZIndex = 20
DeletePopup.Parent = UI
Instance.new("UICorner", DeletePopup).CornerRadius = UDim.new(0,10)

local DelTitle = Instance.new("TextLabel")
DelTitle.Size = UDim2.new(1,0,0,50)
DelTitle.Position = UDim2.new(0,0,0,10)
DelTitle.BackgroundTransparency = 1
DelTitle.Text = "⚠️ DELETE SCRIPT?"
DelTitle.TextColor3 = Color3.new(1,.3,.3)
DelTitle.Font = Enum.Font.GothamBold
DelTitle.TextScaled = true
DelTitle.Parent = DeletePopup

local DelYes = Instance.new("TextButton")
DelYes.Size = UDim2.new(0,120,0,40)
DelYes.Position = UDim2.new(0.2,-60,0,80)
DelYes.BackgroundColor3 = Color3.fromRGB(180,30,30)
DelYes.Text = "✅ CONFIRM"
DelYes.TextColor3 = Color3.new(1,1,1)
DelYes.Font = Enum.Font.GothamBold
DelYes.TextScaled = true
DelYes.Parent = DeletePopup

local DelNo = Instance.new("TextButton")
DelNo.Size = UDim2.new(0,120,0,40)
DelNo.Position = UDim2.new(0.8,-60,0,80)
DelNo.BackgroundColor3 = Color3.fromRGB(30,140,70)
DelNo.Text = "❌ CANCEL"
DelNo.TextColor3 = Color3.new(1,1,1)
DelNo.Font = Enum.Font.GothamBold
DelNo.TextScaled = true
DelNo.Parent = DeletePopup

-- 📌 HELPER FUNCTIONS
local function FormatTime(s)
    s = math.max(0, math.floor(s))
    return string.format("%02d:%02d:%02d", s/3600, (s%3600)/60, s%60)
end

local function IsFriend(userId)
    local ok, res = pcall(function() return LocalPlayer:IsFriendsWith(userId) end)
    return ok and res
end

local function CopyLink(text)
    pcall(function() setclipboard(text) end)
    pcall(function() if set_clipboard then set_clipboard(text) end end)
end

local function ClearESP()
    for _,p in pairs(Players:GetPlayers()) do
        if p.Character then
            pcall(function() p.Character:FindFirstChild("BlueESP"):Destroy() end)
            pcall(function() p.Character:FindFirstChild("BlueFriendDot"):Destroy() end)
        end
    end
end

local function FullDelete()
    pcall(function() Song:Stop() end)
    ClearESP()
    for _,c in pairs(CONNECTIONS) do pcall(function() c:Disconnect() end) end
    pcall(function() UI:Destroy() end)
    getgenv().BlueMode_Loaded = nil
    getgenv().BlueMode_Protected = nil
end

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

-- 🎯 MAIN MENU
local MainMenu = Instance.new("Frame")
MainMenu.Size = UDim2.new(0,480,0,110)
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

local LockBtn = Instance.new("TextButton")
LockBtn.Size = UDim2.new(0,85,0,32)
LockBtn.Position = UDim2.new(0,235,0,60)
LockBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
LockBtn.Text = "🔒 LOCK MOVE"
LockBtn.TextColor3 = Color3.new(1,1,1)
LockBtn.Font = Enum.Font.GothamBold
LockBtn.TextScaled = true
LockBtn.Parent = MainMenu

local DelBtn = Instance.new("TextButton")
DelBtn.Size = UDim2.new(0,70,0,32)
DelBtn.Position = UDim2.new(0,325,0,60)
DelBtn.BackgroundColor3 = Color3.fromRGB(150,30,30)
DelBtn.Text = "🗑️ DEL"
DelBtn.TextColor3 = Color3.new(1,1,1)
DelBtn.Font = Enum.Font.GothamBold
DelBtn.TextScaled = true
DelBtn.Parent = MainMenu

local CopyNotice = Instance.new("TextLabel")
CopyNotice.Size = UDim2.new(0,120,0,22)
CopyNotice.Position = UDim2.new(0,405,0,65)
CopyNotice.BackgroundColor3 = Color3.fromRGB(0,130,80)
CopyNotice.Text = "✅ COPIED!"
CopyNotice.TextColor3 = Color3.new(1,1,1)
CopyNotice.Font = Enum.Font.Gotham
CopyNotice.TextScaled = true
CopyNotice.Visible = false
CopyNotice.Parent = MainMenu

-- 🖱️ WELCOME OK
WelcomeOK.MouseButton1Click:Connect(function()
    Welcome.Visible = false
    MainMenu.Visible = true
end)

-- 🖱️ DRAG SYSTEM (LOGIC FIXED)
local Drag = {Active=false, StartX=0, StartY=0, StartPosX=0, StartPosY=0}
table.insert(CONNECTIONS, DragBar.InputBegan:Connect(function(Input)
    if MOVE_LOCKED then return end
    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
        Drag.Active = true
        Drag.StartX = Input.Position.X
        Drag.StartY = Input.Position.Y
        Drag.StartPosX = MainMenu.Position.X.Offset
        Drag.StartPosY = MainMenu.Position.Y.Offset
    end
end))
table.insert(CONNECTIONS, UIS.InputChanged:Connect(function(Input)
    if not Drag.Active or MOVE_LOCKED then return end
    MainMenu.Position = UDim2.new(0, Drag.StartPosX + (Input.Position.X - Drag.StartX), 0, Drag.StartPosY + (Input.Position.Y - Drag.StartY))
end))
table.insert(CONNECTIONS, UIS.InputEnded:Connect(function() Drag.Active = false end))

-- 📌 BUTTON FUNCTIONS
ESPBtn.MouseButton1Click:Connect(function()
    ESP_ON = not ESP_ON
    ESPBtn.Text = ESP_ON and "ESP ON" or "ESP OFF"
    ESPBtn.BackgroundColor3 = ESP_ON and Color3.fromRGB(25,110,25) or Color3.fromRGB(40,40,40)
    if not ESP_ON then ClearESP() end
end)

MusicBtn.MouseButton1Click:Connect(function()
    MUSIC_ON = not MUSIC_ON
    MusicBtn.Text = MUSIC_ON and "🎵 ON" or "🎵 OFF"
    MusicBtn.BackgroundColor3 = MUSIC_ON and Color3.fromRGB(20,120,190) or Color3.fromRGB(40,40,40)
    BoomboxGui.Visible = MUSIC_ON
    if MUSIC_ON then pcall(function() Song:Play() end) else pcall(function() Song:Stop() end) end
end)

BClose.MouseButton1Click:Connect(function()
    MUSIC_ON = false
    MusicBtn.Text = "🎵 OFF"
    MusicBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    BoomboxGui.Visible = false
    pcall(function() Song:Stop() end)
end)

ApplyBtn.MouseButton1Click:Connect(function()
    local NewID = IDInput.Text
    if NewID ~= "" then
        Song.SoundId = NewID
        if MUSIC_ON then pcall(function() Song:Play() end) end
    end
end)

LinkBtn.MouseButton1Click:Connect(function()
    CopyLink(YT_LINK)
    CopyNotice.Visible = true
    task.delay(2, function() CopyNotice.Visible = false end)
end)

LockBtn.MouseButton1Click:Connect(function()
    MOVE_LOCKED = not MOVE_LOCKED
    if MOVE_LOCKED then
        LockBtn.Text = "🔓 UNLOCK MOVE"
        LockBtn.BackgroundColor3 = Color3.fromRGB(160,110,20)
    else
        LockBtn.Text = "🔒 LOCK MOVE"
        LockBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
    end
end)

MinBtn.MouseButton1Click:Connect(function()
    MINIMIZED = not MINIMIZED
    if MINIMIZED then
        MainMenu.Size = UDim2.new(0,120,0,30)
        for _,v in pairs({TimerText, ESPBtn, MusicBtn, LinkBtn, LockBtn, DelBtn}) do v.Visible = false end
        MinBtn.Text = "+"
    else
        MainMenu.Size = UDim2.new(0,480,0,110)
        for _,v in pairs({TimerText, ESPBtn, MusicBtn, LinkBtn, LockBtn, DelBtn}) do v.Visible = true end
        MinBtn.Text = "−"
    end
end)

DelBtn.MouseButton1Click:Connect(function()
    DeletePopup.Visible = true
end)
DelNo.MouseButton1Click:Connect(function()
    DeletePopup.Visible = false
end)
DelYes.MouseButton1Click:Connect(function()
    DeletePopup.Visible = false
    FullDelete()
end)

UnlockBtn.MouseButton1Click:Connect(function()
    if CodeBox.Text == OWNER_CODE then
        WRONG_COUNT = 0
        LOCK_END = 0
        LockScreen.Visible = false
        MainMenu.Visible = true
        CodeStatus.Text = "✅ UNLOCKED!"
        task.delay(1.5, function() CodeStatus.Text = "" end)
    else
        WRONG_COUNT += 1
        CodeStatus.Text = "❌ WRONG! "..WRONG_COUNT.."/2"
        CodeStatus.TextColor3 = Color3.new(1,.2,.2)
        if WRONG_COUNT >= 2 then
            CodeStatus.Text = "⚠️ HIDING FOR LOCK TIME"
            task.delay(2, function()
                LockScreen.Visible = false
                SCRIPT_HIDDEN = true
            end)
        end
    end
end)

-- ⚡ MAIN LOOP
table.insert(CONNECTIONS, RunService.Heartbeat:Connect(function(dt)
    local Rainbow = Color3.fromHSV((os.clock()*0.7)%1,1,1)
    Welcome.BorderColor3 = Rainbow
    MainMenu.BorderColor3 = Rainbow
    LockScreen.BorderColor3 = Rainbow
    BoomboxGui.BorderColor3 = Rainbow
    for _,t in pairs(TEXT_OBJS) do t.TextStrokeColor3 = Rainbow end

    if LOCK_END > 0 then
        local Remain = math.max(0, LOCK_END - os.time())
        if Remain <= 0 then
            LOCK_END = 0
            WRONG_COUNT = 0
            SCRIPT_HIDDEN = false
            LockScreen.Visible = false
            MainMenu.Visible = true
        else
            if not SCRIPT_HIDDEN then
                LockScreen.Visible = true
                MainMenu.Visible = false
                LTime.Text = "Time remaining: "..FormatTime(Remain)
            end
        end
        return
    end

    USED_TIME += dt
    TimerText.Text = FormatTime(USED_TIME).." / 12:00:00"
    if USED_TIME >= USE_LIMIT then
        USED_TIME = 0
        LOCK_END = os.time() + LOCK_TIME
        WRONG_COUNT = 0
        ClearESP()
        pcall(function() Song:Stop() end)
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
            pcall(function() Char:FindFirstChild("BlueFriendDot"):Destroy() end)
            continue
        end

        local ESP = Char:FindFirstChild("BlueESP") or Instance.new("Highlight")
        ESP.Name = "BlueESP"
        ESP.FillTransparency = 1
        ESP.OutlineTransparency = 0
        ESP.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        ESP.OutlineColor = Rainbow
        ESP.Adornee = Char
        ESP.Parent = Char

        local Head = Char:FindFirstChild("Head")
        if IsFriend(p.UserId) and Head then
            local Dot = Char:FindFirstChild("BlueFriendDot") or Instance.new("BillboardGui")
            Dot.Name = "BlueFriendDot"
            Dot.AlwaysOnTop = true
            Dot.Size = UDim2.new(0,20,0,20)
            Dot.StudsOffset = Vector3.new(0,3,0)
            Dot.Adornee = Head
            Dot.Parent = Char

            local DotFrame = Dot:FindFirstChild("Dot") or Instance.new("Frame")
            DotFrame.Name = "Dot"
            DotFrame.Size = UDim2.new(1,0,1,0)
            DotFrame.BackgroundColor3 = Rainbow
            DotFrame.BorderSizePixel = 2
            Instance.new("UICorner", DotFrame).CornerRadius = UDim.new(1,0)
            DotFrame.Parent = Dot
        else
            pcall(function() Char:FindFirstChild("BlueFriendDot"):Destroy() end)
        end
    end
end))

-- CLEAN UP SENSITIVE DATA AFTER LOAD
task.defer(function()
    collectgarbage("collect")
end)

print("✅ BLUE_MODE ESP | ORIGINAL BY BLUE_MODE | PROTECTED VERSION LOADED!")
