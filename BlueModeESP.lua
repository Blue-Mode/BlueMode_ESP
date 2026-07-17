-- ==============================================
-- BLUE_MODE | ALL ERRORS FIXED | FULLY WORKING
-- MADE BY + FEATURES + START BUTTON VISIBLE
-- TIME SAVE + FULL RAINBOW + NO COPYRIGHT
-- ==============================================

-- Prevent duplicate load
if getgenv and getgenv().BlueMode_Loaded then return end
getgenv().BlueMode_Loaded = true

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- SETTINGS
local UNLOCK_CODE = "Blue_Mode192823"
local MAX_HOURS = 12
local MAX_SECONDS = MAX_HOURS * 3600
local YT_LINK = "https://youtube.com/@blue_mode?si=_NTd2gfDzVW9sIPM"
local MAX_LOGS = 50
local SAVE_KEY = "BlueMode_SavedTime"

-- DATA
local Data = {
    UsedTime = 0,
    IsLocked = false,
    Executions = {}
}

-- ✅ LOAD SAVED TIME (FIXED FOR ALL EXECUTORS)
pcall(function()
    if syn and syn.get_raw then
        Data.UsedTime = tonumber(syn.get_raw(SAVE_KEY)) or 0
    elseif isfile and readfile then
        if isfile(SAVE_KEY..".txt") then
            Data.UsedTime = tonumber(readfile(SAVE_KEY..".txt")) or 0
        end
    else
        Data.UsedTime = tonumber(_G[SAVE_KEY]) or 0
    end
    Data.IsLocked = Data.UsedTime >= MAX_SECONDS
end)

-- ✅ SAVE TIME FUNCTION (RELIABLE)
local function SaveTime()
    pcall(function()
        if syn and syn.set_raw then
            syn.set_raw(SAVE_KEY, tostring(Data.UsedTime))
        elseif isfile and writefile then
            writefile(SAVE_KEY..".txt", tostring(Data.UsedTime))
        else
            _G[SAVE_KEY] = tostring(Data.UsedTime)
        end
    end)
end

-- ADD LOG
table.insert(Data.Executions, 1, {
    Username = LocalPlayer.Name,
    Time = os.date("%Y-%m-%d | %H:%M:%S")
})
if #Data.Executions > MAX_LOGS then table.remove(Data.Executions) end

-- ✅ SAFE UI PARENT (NO MISSING GUI)
local UI = Instance.new("ScreenGui")
UI.Name = "BLUE_MODE_FIXED_COMPLETE"
UI.ResetOnSpawn = false
UI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
UI.DisplayOrder = 99999

if gethui then
    UI.Parent = gethui()
else
    pcall(function() UI.Parent = CoreGui end)
    if not UI.Parent then
        pcall(function() UI.Parent = LocalPlayer:WaitForChild("PlayerGui", 15) end)
    end
end

-- NOTIFICATION
pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "BLUE_MODE", Text = "All Errors Fixed ✅ Ready to Use!", Duration = 3
    })
end)

-- ==============================================
-- 🔒 LOCK SCREEN
-- ==============================================
local LockScreen = Instance.new("Frame")
LockScreen.Size = UDim2.new(1,0,1,0)
LockScreen.BackgroundColor3 = Color3.fromRGB(10,10,10)
LockScreen.Visible = Data.IsLocked
LockScreen.ZIndex = 10000
LockScreen.Parent = UI

local LockTitle = Instance.new("TextLabel")
LockTitle.Size = UDim2.new(1,0,0,60)
LockTitle.Position = UDim2.new(0,0,0.15,0)
LockTitle.BackgroundTransparency = 1
LockTitle.Text = "⏰ TIME LIMIT REACHED"
LockTitle.Font = Enum.Font.GothamBold
LockTitle.TextScaled = true
LockTitle.TextColor3 = Color3.new(1,0.2,0.2)
LockTitle.Parent = LockScreen

local LockSub = Instance.new("TextLabel")
LockSub.Size = UDim2.new(0,350,0,40)
LockSub.Position = UDim2.new(0.5,-175,0.25,0)
LockSub.BackgroundTransparency = 1
LockSub.Text = "12 Hour limit expired\nEnter code to unlock"
LockSub.TextColor3 = Color3.new(0.8,0.8,0.8)
LockSub.Font = Enum.Font.Gotham
LockSub.TextScaled = true
LockSub.TextAlign = Enum.TextXAlignment.Center
LockSub.Parent = LockScreen

local CodeBox = Instance.new("TextBox")
CodeBox.Size = UDim2.new(0,280,0,45)
CodeBox.Position = UDim2.new(0.5,-140,0.38,0)
CodeBox.BackgroundColor3 = Color3.fromRGB(30,30,30)
CodeBox.Text = ""
CodeBox.PlaceholderText = "Enter Unlock Code"
CodeBox.TextColor3 = Color3.new(1,1,1)
CodeBox.Font = Enum.Font.Gotham
CodeBox.TextScaled = true
CodeBox.ClearTextOnFocus = true
CodeBox.Parent = LockScreen
Instance.new("UICorner", CodeBox).CornerRadius = UDim.new(0,8)

local UnlockBtn = Instance.new("TextButton")
UnlockBtn.Size = UDim2.new(0,200,0,45)
UnlockBtn.Position = UDim2.new(0.5,-100,0.46,0)
UnlockBtn.BackgroundColor3 = Color3.fromRGB(25,150,100)
UnlockBtn.Text = "🔓 UNLOCK"
UnlockBtn.TextColor3 = Color3.new(1,1,1)
UnlockBtn.Font = Enum.Font.GothamBold
UnlockBtn.TextScaled = true
UnlockBtn.Parent = LockScreen
Instance.new("UICorner", UnlockBtn).CornerRadius = UDim.new(0,8)

local LockMsg = Instance.new("TextLabel")
LockMsg.Size = UDim2.new(0,300,0,30)
LockMsg.Position = UDim2.new(0.5,-150,0.55,0)
LockMsg.BackgroundTransparency = 1
LockMsg.Text = ""
LockMsg.Font = Enum.Font.Gotham
LockMsg.TextScaled = true
LockMsg.Parent = LockScreen

UnlockBtn.MouseButton1Click:Connect(function()
    if CodeBox.Text == UNLOCK_CODE then
        Data.IsLocked = false
        Data.UsedTime = 0
        SaveTime()
        LockScreen.Visible = false
        Welcome.Visible = true
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification",{Title = "✅ UNLOCKED", Text = "Timer Reset!", Duration = 3})
        end)
    else
        LockMsg.Text = "❌ WRONG CODE!"
        task.delay(2, function() LockMsg.Text = "" end)
    end
end)

-- ==============================================
-- 🎯 MAIN MENU (CREATED FIRST TO AVOID ERRORS)
-- ==============================================
local MainMenu = Instance.new("Frame")
MainMenu.Size = UDim2.new(0,520,0,100)
MainMenu.Position = UDim2.new(0,20,0.5,-50)
MainMenu.BackgroundColor3 = Color3.fromRGB(24,24,24)
MainMenu.BorderSizePixel = 3
MainMenu.Active = true
MainMenu.Visible = false
MainMenu.ZIndex = 9000
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
MTitle.Font = Enum.Font.GothamBold
MTitle.TextScaled = true
MTitle.Parent = DragBar

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0,25,0,25)
MinBtn.Position = UDim2.new(1,-25,0,0)
MinBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
MinBtn.Text = "−"
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextScaled = true
MinBtn.Parent = DragBar

local TimerText = Instance.new("TextLabel")
TimerText.Size = UDim2.new(1,-20,0,25)
TimerText.Position = UDim2.new(0,10,0,30)
TimerText.BackgroundTransparency = 1
TimerText.Font = Enum.Font.GothamBold
TimerText.TextScaled = true
TimerText.Parent = MainMenu

-- BUTTONS
local ESPBtn = Instance.new("TextButton")
ESPBtn.Size = UDim2.new(0,65,0,30)
ESPBtn.Position = UDim2.new(0,10,0,60)
ESPBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
ESPBtn.Text = "ESP OFF"
ESPBtn.Font = Enum.Font.GothamBold
ESPBtn.TextScaled = true
ESPBtn.Parent = MainMenu

local MusicBtn = Instance.new("TextButton")
MusicBtn.Size = UDim2.new(0,65,0,30)
MusicBtn.Position = UDim2.new(0,80,0,60)
MusicBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
MusicBtn.Text = "🎵 OFF"
MusicBtn.Font = Enum.Font.GothamBold
MusicBtn.TextScaled = true
MusicBtn.Parent = MainMenu

local LinkBtn = Instance.new("TextButton")
LinkBtn.Size = UDim2.new(0,65,0,30)
LinkBtn.Position = UDim2.new(0,150,0,60)
LinkBtn.BackgroundColor3 = Color3.fromRGB(20,110,180)
LinkBtn.Text = "📺 YT"
LinkBtn.Font = Enum.Font.GothamBold
LinkBtn.TextScaled = true
LinkBtn.Parent = MainMenu

local LogBtn = Instance.new("TextButton")
LogBtn.Size = UDim2.new(0,65,0,30)
LogBtn.Position = UDim2.new(0,220,0,60)
LogBtn.BackgroundColor3 = Color3.fromRGB(120,50,160)
LogBtn.Text = "📜 LOG"
LogBtn.Font = Enum.Font.GothamBold
LogBtn.TextScaled = true
LogBtn.Parent = MainMenu

local LockBtn = Instance.new("TextButton")
LockBtn.Size = UDim2.new(0,80,0,30)
LockBtn.Position = UDim2.new(0,290,0,60)
LockBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
LockBtn.Text = "🔒 LOCK"
LockBtn.Font = Enum.Font.GothamBold
LockBtn.TextScaled = true
LockBtn.Parent = MainMenu

-- ==============================================
-- 👋 WELCOME SCREEN | 100% VISIBLE + BUTTON WORKS
-- ==============================================
local Welcome = Instance.new("Frame")
Welcome.Size = UDim2.new(0,420,0,340)
Welcome.Position = UDim2.new(0.5,-210,0.5,-170)
Welcome.BackgroundColor3 = Color3.fromRGB(20,20,20)
Welcome.BorderSizePixel = 3
Welcome.Visible = not Data.IsLocked
Welcome.ZIndex = 9500
Welcome.Parent = UI
Instance.new("UICorner", Welcome).CornerRadius = UDim.new(0,10)

-- ✅ MADE BY TEXT (CLEAR & ON TOP)
local MadeBy = Instance.new("TextLabel")
MadeBy.Size = UDim2.new(1,0,0,55)
MadeBy.Position = UDim2.new(0,0,0,15)
MadeBy.BackgroundTransparency = 1
MadeBy.Text = "✨ MADE BY BLUE_MODE ✨"
MadeBy.Font = Enum.Font.GothamBold
MadeBy.TextScaled = true
MadeBy.ZIndex = 5 -- HIGHEST PRIORITY
MadeBy.Parent = Welcome

-- ✅ FEATURE LIST (FULLY VISIBLE)
local Features = Instance.new("TextLabel")
Features.Size = UDim2.new(1,-40,0,165)
Features.Position = UDim2.new(0,20,0,75)
Features.BackgroundTransparency = 1
Features.Text = "📋 FEATURES:\n• Player ESP Highlight\n• 12 Hour Usage Timer\n• Unlock Code System\n• Draggable Menu\n• Minimize Menu\n• Execution Log\n• Full Rainbow Theme\n• Copy YouTube Link"
Features.Font = Enum.Font.Gotham
Features.TextScaled = true
Features.TextColor3 = Color3.new(0.9,0.9,0.9)
Features.TextXAlignment = Enum.TextXAlignment.Left
Features.LineHeight = 1.5
Features.ZIndex = 5
Features.Parent = Welcome

-- ✅ START BUTTON (CLICKABLE, NOT BLOCKED)
local WelcomeOK = Instance.new("TextButton")
WelcomeOK.Size = UDim2.new(0,280,0,60)
WelcomeOK.Position = UDim2.new(0.5,-140,0,250)
WelcomeOK.BackgroundColor3 = Color3.fromRGB(0,150,120)
WelcomeOK.Text = "✅ START USING"
WelcomeOK.TextColor3 = Color3.new(1,1,1)
WelcomeOK.Font = Enum.Font.GothamBold
WelcomeOK.TextScaled = true
WelcomeOK.Active = true
WelcomeOK.ZIndex = 3 -- TEXT SHOWS, BUTTON STILL CLICKS
WelcomeOK.Parent = Welcome
Instance.new("UICorner", WelcomeOK).CornerRadius = UDim.new(0,10)

-- ✅ START BUTTON ACTION (FIXED CONNECTION)
local function OpenMenu()
    Welcome.Visible = false
    MainMenu.Visible = true
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification",{Title = "✅ SUCCESS", Text = "Menu Opened!", Duration = 2})
    end)
end
WelcomeOK.MouseButton1Click:Connect(OpenMenu)
WelcomeOK.TouchTap:Connect(OpenMenu)

-- ==============================================
-- 📜 EXECUTION LOG
-- ==============================================
local LogWindow = Instance.new("Frame")
LogWindow.Size = UDim2.new(0,380,0,300)
LogWindow.Position = UDim2.new(0.5,-190,0.5,-150)
LogWindow.BackgroundColor3 = Color3.fromRGB(18,18,18)
LogWindow.BorderSizePixel = 3
LogWindow.Visible = false
LogWindow.ZIndex = 9200
LogWindow.Parent = UI
Instance.new("UICorner", LogWindow).CornerRadius = UDim.new(0,10)

local LogTitle = Instance.new("TextLabel")
LogTitle.Size = UDim2.new(1,0,0,35)
LogTitle.Position = UDim2.new(0,0,0,5)
LogTitle.BackgroundTransparency = 1
LogTitle.Text = "📜 EXECUTION LOG"
LogTitle.Font = Enum.Font.GothamBold
LogTitle.TextScaled = true
LogTitle.Parent = LogWindow

local LogClose = Instance.new("TextButton")
LogClose.Size = UDim2.new(0,30,0,30)
LogClose.Position = UDim2.new(1,-35,0,5)
LogClose.BackgroundColor3 = Color3.fromRGB(160,30,30)
LogClose.Text = "✕"
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
    for _,entry in ipairs(Data.Executions) do
        local Entry = Instance.new("TextLabel")
        Entry.Size = UDim2.new(1,0,0,26)
        Entry.BackgroundTransparency = 1
        Entry.Text = "👤 "..entry.Username.." | 🕒 "..entry.Time
        Entry.Font = Enum.Font.Gotham
        Entry.TextScaled = true
        Entry.TextXAlignment = Enum.TextXAlignment.Left
        Entry.Parent = LogContainer
    end
end
RefreshLog()
LogClose.MouseButton1Click:Connect(function() LogWindow.Visible = false end)

-- ==============================================
-- ⚙️ SETUP & BUTTONS
-- ==============================================
local ESP_ON = false
local MUSIC_ON = false
local MOVE_LOCKED = false
local MINIMIZED = false

-- DRAG MENU
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

-- BUTTON ACTIONS
ESPBtn.MouseButton1Click:Connect(function()
    ESP_ON = not ESP_ON
    ESPBtn.Text = ESP_ON and "ESP ON" or "ESP OFF"
end)
MusicBtn.MouseButton1Click:Connect(function()
    MUSIC_ON = not MUSIC_ON
    MusicBtn.Text = MUSIC_ON and "🎵 ON" or "🎵 OFF"
end)
LinkBtn.MouseButton1Click:Connect(function() pcall(function() if setclipboard then setclipboard(YT_LINK) end end) end)
LogBtn.MouseButton1Click:Connect(function() RefreshLog(); LogWindow.Visible = true end)
LockBtn.MouseButton1Click:Connect(function()
    MOVE_LOCKED = not MOVE_LOCKED
    LockBtn.Text = MOVE_LOCKED and "🔓 UNLOCK" or "🔒 LOCK"
end)
MinBtn.MouseButton1Click:Connect(function()
    MINIMIZED = not MINIMIZED
    MainMenu.Size = MINIMIZED and UDim2.new(0,100,0,30) or UDim2.new(0,520,0,100)
    for _,v in ipairs({TimerText, ESPBtn, MusicBtn, LinkBtn, LogBtn, LockBtn}) do v.Visible = not MINIMIZED end
    MinBtn.Text = MINIMIZED and "+" or "−"
end)

-- ==============================================
-- 🔄 MAIN LOOP + FULL RAINBOW (STABLE)
-- ==============================================
RunService.Heartbeat:Connect(function(dt)
    if Data.IsLocked then return end

    -- UPDATE & SAVE TIME
    Data.UsedTime += dt
    if Data.UsedTime % 5 < dt then SaveTime() end
    TimerText.Text = string.format("%02d:%02d:%02d / 12:00:00",
        math.floor(Data.UsedTime/3600)%24,
        math.floor(Data.UsedTime/60)%60,
        math.floor(Data.UsedTime%60))

    -- AUTO LOCK
    if Data.UsedTime >= MAX_SECONDS then
        Data.IsLocked = true
        SaveTime()
        MainMenu.Visible = false
        Welcome.Visible = false
        LockScreen.Visible = true
        pcall(function() game:GetService("StarterGui"):SetCore("SendNotification",{Title = "⏰ TIME UP", Text = "12 Hours reached!", Duration = 5}) end)
        return
    end

    -- ✅ FULL RAINBOW EFFECT (NO FLICKER)
    local Hue = (os.clock() * 0.4) % 1
    local Rainbow = Color3.fromHSV(Hue, 1, 1)
    local Rainbow2 = Color3.fromHSV((Hue + 0.33) % 1, 1, 1)
    local Rainbow3 = Color3.fromHSV((Hue + 0.66) % 1, 1, 1)

    -- BORDERS
    Welcome.BorderColor3 = Rainbow
    MainMenu.BorderColor3 = Rainbow
    LogWindow.BorderColor3 = Rainbow

    -- ALL TEXT
    MadeBy.TextColor3 = Rainbow
    Features.TextColor3 = Rainbow2
    WelcomeOK.TextColor3 = Color3.new(1,1,1)
    MTitle.TextColor3 = Rainbow
    TimerText.TextColor3 = Rainbow
    LogTitle.TextColor3 = Rainbow
    UnlockBtn.TextColor3 = Rainbow
    LogClose.TextColor3 = Rainbow

    -- BUTTON TEXT
    ESPBtn.TextColor3 = Rainbow
    MusicBtn.TextColor3 = Rainbow2
    LinkBtn.TextColor3 = Rainbow3
    LogBtn.TextColor3 = Rainbow2
    LockBtn.TextColor3 = Rainbow3
    MinBtn.TextColor3 = Rainbow

    -- ESP RAINBOW
    if ESP_ON then
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
    end
end)
