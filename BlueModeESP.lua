-- ==============================================
-- BLUE_MODE | FRIENDS RAINBOW DOTS + CLEAN ESP
-- ✅ ESP OFF = ALL OUTLINES/DOTS REMOVED
-- ✅ ESP ON = RAINBOW DOT ONLY ON FRIENDS
-- ✅ Custom Music ID Input + Delete Confirm
-- ✅ Minimize stays + Green/Red status
-- ==============================================

if BlueModeLoaded then return end
BlueModeLoaded = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local MAX_SECONDS = 12 * 3600
local YT_LINK = "https://youtube.com/@blue_mode?si=_NTd2gfDzVW9sIPM"
local UsedTime = 0
local MusicOn = false
local MusicSound = nil
local MOVE_LOCKED = false
local ESP_ON = false

-- ==============================================
-- BASE GUI
-- ==============================================
local UI = Instance.new("ScreenGui")
UI.Name = "BLUE_MODE"
UI.ResetOnSpawn = false
UI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
UI.Parent = PlayerGui

-- ==============================================
-- 🎵 MUSIC ID POPUP
-- ==============================================
local MusicPopup = Instance.new("Frame")
MusicPopup.Size = UDim2.new(0,320,0,180)
MusicPopup.Position = UDim2.new(0.5,-160,0.5,-90)
MusicPopup.BackgroundColor3 = Color3.fromRGB(30,30,30)
MusicPopup.Visible = false
MusicPopup.Parent = UI
Instance.new("UICorner", MusicPopup).CornerRadius = UDim.new(0,8)

local MusicTitle = Instance.new("TextLabel")
MusicTitle.Size = UDim2.new(1,-20,0,40)
MusicTitle.Position = UDim2.new(0,10,0,10)
MusicTitle.BackgroundTransparency = 1
MusicTitle.Text = "🎵 ENTER SOUND ID"
MusicTitle.Font = Enum.Font.GothamBold
MusicTitle.TextScaled = true
MusicTitle.TextColor3 = Color3.new(1,1,1)
MusicTitle.Parent = MusicPopup

local IDInput = Instance.new("TextBox")
IDInput.Size = UDim2.new(1,-30,0,45)
IDInput.Position = UDim2.new(0,15,0,55)
IDInput.BackgroundColor3 = Color3.fromRGB(45,45,45)
IDInput.Text = "rbxassetid://"
IDInput.Font = Enum.Font.Gotham
IDInput.TextScaled = true
IDInput.TextColor3 = Color3.new(1,1,1)
IDInput.ClearTextOnFocus = false
IDInput.Parent = MusicPopup
Instance.new("UICorner", IDInput).CornerRadius = UDim.new(0,6)

local PlayBtn = Instance.new("TextButton")
PlayBtn.Size = UDim2.new(0,120,0,40)
PlayBtn.Position = UDim2.new(0,15,0,115)
PlayBtn.BackgroundColor3 = Color3.fromRGB(40,150,60)
PlayBtn.Text = "▶ PLAY"
PlayBtn.TextColor3 = Color3.new(1,1,1)
PlayBtn.Font = Enum.Font.GothamBold
PlayBtn.TextScaled = true
PlayBtn.Parent = MusicPopup
Instance.new("UICorner", PlayBtn).CornerRadius = UDim.new(0,6)

local CloseMusicBtn = Instance.new("TextButton")
CloseMusicBtn.Size = UDim2.new(0,120,0,40)
CloseMusicBtn.Position = UDim2.new(1,-135,0,115)
CloseMusicBtn.BackgroundColor3 = Color3.fromRGB(170,40,40)
CloseMusicBtn.Text = "✕ CLOSE"
CloseMusicBtn.TextColor3 = Color3.new(1,1,1)
CloseMusicBtn.Font = Enum.Font.GothamBold
CloseMusicBtn.TextScaled = true
CloseMusicBtn.Parent = MusicPopup
Instance.new("UICorner", CloseMusicBtn).CornerRadius = UDim.new(0,6)

-- ==============================================
-- DELETE CONFIRM
-- ==============================================
local ConfirmFrame = Instance.new("Frame")
ConfirmFrame.Size = UDim2.new(0,300,0,150)
ConfirmFrame.Position = UDim2.new(0.5,-150,0.5,-75)
ConfirmFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
ConfirmFrame.Visible = false
ConfirmFrame.Parent = UI
Instance.new("UICorner", ConfirmFrame).CornerRadius = UDim.new(0,8)

local ConfirmText = Instance.new("TextLabel")
ConfirmText.Size = UDim2.new(1,-20,0,50)
ConfirmText.Position = UDim2.new(0,10,0,10)
ConfirmText.BackgroundTransparency = 1
ConfirmText.Text = "Are you sure?"
ConfirmText.Font = Enum.Font.GothamBold
ConfirmText.TextScaled = true
ConfirmText.TextColor3 = Color3.new(1,1,1)
ConfirmText.Parent = ConfirmFrame

local YesBtn = Instance.new("TextButton")
YesBtn.Size = UDim2.new(0,120,0,40)
YesBtn.Position = UDim2.new(0,15,0,90)
YesBtn.BackgroundColor3 = Color3.fromRGB(40,150,60)
YesBtn.Text = "YES"
YesBtn.TextColor3 = Color3.new(1,1,1)
YesBtn.Font = Enum.Font.GothamBold
YesBtn.TextScaled = true
YesBtn.Parent = ConfirmFrame
Instance.new("UICorner", YesBtn).CornerRadius = UDim.new(0,6)

local NoBtn = Instance.new("TextButton")
NoBtn.Size = UDim2.new(0,120,0,40)
NoBtn.Position = UDim2.new(1,-135,0,90)
NoBtn.BackgroundColor3 = Color3.fromRGB(170,40,40)
NoBtn.Text = "NO"
NoBtn.TextColor3 = Color3.new(1,1,1)
NoBtn.Font = Enum.Font.GothamBold
NoBtn.TextScaled = true
NoBtn.Parent = ConfirmFrame
Instance.new("UICorner", NoBtn).CornerRadius = UDim.new(0,6)

-- ==============================================
-- WELCOME SCREEN
-- ==============================================
local Welcome = Instance.new("Frame")
Welcome.Size = UDim2.new(0,380,0,300)
Welcome.Position = UDim2.new(0.5,-190,0.5,-150)
Welcome.BackgroundColor3 = Color3.fromRGB(22,22,22)
Welcome.Visible = true
Welcome.Parent = UI
Instance.new("UICorner", Welcome).CornerRadius = UDim.new(0,10)

local MadeBy = Instance.new("TextLabel")
MadeBy.Size = UDim2.new(1,0,0,45)
MadeBy.Position = UDim2.new(0,0,0,15)
MadeBy.BackgroundTransparency = 1
MadeBy.Text = "✨ MADE BY BLUE_MODE ✨"
MadeBy.Font = Enum.Font.GothamBold
MadeBy.TextScaled = true
MadeBy.TextColor3 = Color3.new(0,0.6,1)
MadeBy.Parent = Welcome

local StartBtn = Instance.new("TextButton")
StartBtn.Size = UDim2.new(0,240,0,50)
StartBtn.Position = UDim2.new(0.5,-120,0,220)
StartBtn.BackgroundColor3 = Color3.fromRGB(0,110,200)
StartBtn.Text = "START USING"
StartBtn.TextColor3 = Color3.new(1,1,1)
StartBtn.Font = Enum.Font.GothamBold
StartBtn.TextScaled = true
StartBtn.Parent = Welcome
Instance.new("UICorner", StartBtn).CornerRadius = UDim.new(0,10)

-- ==============================================
-- MAIN MENU
-- ==============================================
local MainMenu = Instance.new("Frame")
MainMenu.Size = UDim2.new(0,480,0,85)
MainMenu.Position = UDim2.new(0,10,0.05,0)
MainMenu.BackgroundColor3 = Color3.fromRGB(20,20,20)
MainMenu.Active = true
MainMenu.Draggable = true
MainMenu.Visible = false
MainMenu.Parent = UI
Instance.new("UICorner", MainMenu).CornerRadius = UDim.new(0,6)

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1,0,0,28)
TitleBar.BackgroundColor3 = Color3.fromRGB(30,110,190)
TitleBar.Parent = MainMenu

local MenuTitle = Instance.new("TextLabel")
MenuTitle.Size = UDim2.new(1,-55,1,0)
MenuTitle.Position = UDim2.new(0,8,0,0)
MenuTitle.BackgroundTransparency = 1
MenuTitle.Text = "BLUE_MODE ESP"
MenuTitle.Font = Enum.Font.GothamBold
MenuTitle.TextColor3 = Color3.new(1,1,1)
MenuTitle.TextScaled = true
MenuTitle.Parent = TitleBar

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0,22,0,22)
MinBtn.Position = UDim2.new(1,-47,0,3)
MinBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
MinBtn.Text = "−"
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextScaled = true
MinBtn.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0,22,0,22)
CloseBtn.Position = UDim2.new(1,-25,0,3)
CloseBtn.BackgroundColor3 = Color3.fromRGB(180,30,30)
CloseBtn.Text = "✕"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextScaled = true
CloseBtn.Parent = TitleBar

local TimerText = Instance.new("TextLabel")
TimerText.Size = UDim2.new(1,-15,0,22)
TimerText.Position = UDim2.new(0,8,0,30)
TimerText.BackgroundTransparency = 1
TimerText.Font = Enum.Font.GothamBold
TimerText.TextColor3 = Color3.new(1,1,1)
TimerText.TextScaled = true
TimerText.Parent = MainMenu

-- BUTTONS
local ESPBtn = Instance.new("TextButton")
ESPBtn.Size = UDim2.new(0,65,0,26)
ESPBtn.Position = UDim2.new(0,8,0,58)
ESPBtn.BackgroundColor3 = Color3.fromRGB(170,40,40) -- RED = OFF
ESPBtn.Text = "ESP OFF"
ESPBtn.Font = Enum.Font.GothamBold
ESPBtn.TextScaled = true
ESPBtn.Parent = MainMenu

local MusicBtn = Instance.new("TextButton")
MusicBtn.Size = UDim2.new(0,50,0,26)
MusicBtn.Position = UDim2.new(0,80,0,58)
MusicBtn.BackgroundColor3 = Color3.fromRGB(170,40,40) -- RED = OFF
MusicBtn.Text = "🎵 OFF"
MusicBtn.Font = Enum.Font.GothamBold
MusicBtn.TextScaled = true
MusicBtn.Parent = MainMenu

local YTBtn = Instance.new("TextButton")
YTBtn.Size = UDim2.new(0,50,0,26)
YTBtn.Position = UDim2.new(0,135,0,58)
YTBtn.BackgroundColor3 = Color3.fromRGB(20,110,180)
YTBtn.Text = "📺 YT"
YTBtn.Font = Enum.Font.GothamBold
YTBtn.TextScaled = true
YTBtn.Parent = MainMenu

local LockBtn = Instance.new("TextButton")
LockBtn.Size = UDim2.new(0,65,0,26)
LockBtn.Position = UDim2.new(0,190,0,58)
LockBtn.BackgroundColor3 = Color3.fromRGB(40,150,60) -- GREEN = UNLOCKED
LockBtn.Text = "UNLOCK"
LockBtn.Font = Enum.Font.GothamBold
LockBtn.TextScaled = true
LockBtn.Parent = MainMenu

local DelBtn = Instance.new("TextButton")
DelBtn.Size = UDim2.new(0,50,0,26)
DelBtn.Position = UDim2.new(0,260,0,58)
DelBtn.BackgroundColor3 = Color3.fromRGB(180,30,30)
DelBtn.Text = "🗑 DEL"
DelBtn.Font = Enum.Font.GothamBold
DelBtn.TextScaled = true
DelBtn.Parent = MainMenu

-- ==============================================
-- MINIMIZE BAR
-- ==============================================
local MinBar = Instance.new("Frame")
MinBar.Size = UDim2.new(0,170,0,28)
MinBar.Position = MainMenu.Position
MinBar.BackgroundColor3 = Color3.fromRGB(30,110,190)
MinBar.Active = true
MinBar.Draggable = true
MinBar.Visible = false
MinBar.Parent = UI
Instance.new("UICorner", MinBar).CornerRadius = UDim.new(0,6)

local BarTimer = Instance.new("TextLabel")
BarTimer.Size = UDim2.new(1,-32,1,0)
BarTimer.Position = UDim2.new(0,5,0,0)
BarTimer.BackgroundTransparency = 1
BarTimer.Font = Enum.Font.GothamBold
BarTimer.TextColor3 = Color3.new(1,1,1)
BarTimer.TextScaled = true
BarTimer.TextXAlignment = Enum.TextXAlignment.Left
BarTimer.Parent = MinBar

local RestoreBtn = Instance.new("TextButton")
RestoreBtn.Size = UDim2.new(0,28,0,24)
RestoreBtn.Position = UDim2.new(1,-30,0,2)
RestoreBtn.BackgroundTransparency = 1
RestoreBtn.Text = "+"
RestoreBtn.Font = Enum.Font.GothamBold
RestoreBtn.TextColor3 = Color3.new(1,1,1)
RestoreBtn.TextScaled = true
RestoreBtn.Parent = MinBar

-- ==============================================
-- ✅ FULL CLEANUP: REMOVE ALL HIGHLIGHTS/DOTS
-- ==============================================
local function RemoveAllESP()
    for _, Player in pairs(Players:GetPlayers()) do
        if Player.Character then
            -- Delete ALL highlights
            for _, v in pairs(Player.Character:GetChildren()) do
                if v:IsA("Highlight") or v.Name == "FriendDot" then
                    v:Destroy()
                end
            end
        end
    end
end

-- ==============================================
-- BUTTON FUNCTIONS
-- ==============================================
StartBtn.MouseButton1Click:Connect(function()
    Welcome.Visible = false
    MainMenu.Visible = true
end)
StartBtn.TouchTap:Connect(function()
    Welcome.Visible = false
    MainMenu.Visible = true
end)

MinBtn.MouseButton1Click:Connect(function()
    MainMenu.Visible = false
    MinBar.Visible = true
    MinBar.Position = MainMenu.Position
end)
RestoreBtn.MouseButton1Click:Connect(function()
    MinBar.Visible = false
    MainMenu.Visible = true
end)

-- MUSIC BUTTON
MusicBtn.MouseButton1Click:Connect(function()
    if not MusicOn then
        MusicPopup.Visible = true
    else
        MusicOn = false
        MusicBtn.BackgroundColor3 = Color3.fromRGB(170,40,40)
        MusicBtn.Text = "🎵 OFF"
        if MusicSound then MusicSound:Stop() end
    end
end)

PlayBtn.MouseButton1Click:Connect(function()
    local InputID = IDInput.Text
    if InputID == "" or InputID == "rbxassetid://" then return end
    if MusicSound then MusicSound:Destroy() end
    MusicSound = Instance.new("Sound")
    MusicSound.SoundId = InputID
    MusicSound.Looped = true
    MusicSound.Volume = 0.3
    MusicSound.Parent = UI
    MusicSound:Play()
    MusicOn = true
    MusicBtn.BackgroundColor3 = Color3.fromRGB(40,150,60)
    MusicBtn.Text = "🎵 ON"
    MusicPopup.Visible = false
end)
PlayBtn.TouchTap:Connect(function() PlayBtn:Fire("MouseButton1Click") end)

CloseMusicBtn.MouseButton1Click:Connect(function()
    MusicPopup.Visible = false
end)

-- ESP BUTTON
ESPBtn.MouseButton1Click:Connect(function()
    ESP_ON = not ESP_ON
    if ESP_ON then
        ESPBtn.BackgroundColor3 = Color3.fromRGB(40,150,60)
        ESPBtn.Text = "ESP ON"
    else
        ESPBtn.BackgroundColor3 = Color3.fromRGB(170,40,40)
        ESPBtn.Text = "ESP OFF"
        RemoveAllESP() -- ✅ REMOVE EVERYTHING WHEN OFF
    end
end)

LockBtn.MouseButton1Click:Connect(function()
    MOVE_LOCKED = not MOVE_LOCKED
    if MOVE_LOCKED then
        LockBtn.BackgroundColor3 = Color3.fromRGB(170,40,40)
        LockBtn.Text = "LOCKED"
        MainMenu.Draggable = false
        MinBar.Draggable = false
    else
        LockBtn.BackgroundColor3 = Color3.fromRGB(40,150,60)
        LockBtn.Text = "UNLOCK"
        MainMenu.Draggable = true
        MinBar.Draggable = true
    end
end)

DelBtn.MouseButton1Click:Connect(function()
    ConfirmFrame.Visible = true
end)
NoBtn.MouseButton1Click:Connect(function()
    ConfirmFrame.Visible = false
end)
YesBtn.MouseButton1Click:Connect(function()
    ConfirmFrame.Visible = false
    RemoveAllESP()
    if MusicSound then MusicSound:Destroy() end
    UI:Destroy()
end)

YTBtn.MouseButton1Click:Connect(function()
    pcall(function() if setclipboard then setclipboard(YT_LINK) end end)
end)

CloseBtn.MouseButton1Click:Connect(function()
    MainMenu.Visible = false
end)

-- ==============================================
-- MAIN LOOP: FRIENDS RAINBOW DOTS
-- ==============================================
RunService.Heartbeat:Connect(function(dt)
    -- Timer
    UsedTime = UsedTime + dt
    local h = math.floor(UsedTime/3600)
    local m = math.floor((UsedTime%3600)/60)
    local s = math.floor(UsedTime%60)
    local TimeStr = string.format("%02d:%02d:%02d",h,m,s)
    TimerText.Text = TimeStr.." / 12:00:00"
    BarTimer.Text = TimeStr

    -- Time up cleanup
    if UsedTime >= MAX_SECONDS then
        MainMenu.Visible = false
        MinBar.Visible = false
        Welcome.Visible = false
        ConfirmFrame.Visible = false
        RemoveAllESP()
        if MusicSound then MusicSound:Stop() end
        return
    end

    -- Rainbow color
    local Hue = (os.clock() * 0.3) % 1
    local Col = Color3.fromHSV(Hue,1,1)
    TitleBar.BackgroundColor3 = Col
    MinBar.BackgroundColor3 = Col
    MadeBy.TextColor3 = Col
    MenuTitle.TextColor3 = Col

    -- ✅ ONLY RUN WHEN ESP IS EXPLICITLY ON
    if ESP_ON then
        for _, Player in pairs(Players:GetPlayers()) do
            if Player == LocalPlayer then continue end
            if not Player.Character then continue end
            local Humanoid = Player.Character:FindFirstChild("Humanoid")
            if not Humanoid then continue end

            -- Check if FRIEND
            local IsFriend = false
            pcall(function() IsFriend = LocalPlayer:IsFriendsWith(Player.UserId) end)

            -- Remove old if not friend anymore
            if not IsFriend then
                if Player.Character:FindFirstChildOfClass("Highlight") then
                    Player.Character:FindFirstChildOfClass("Highlight"):Destroy()
                end
                if Player.Character:FindFirstChild("FriendDot") then
                    Player.Character.FriendDot:Destroy()
                end
                continue
            end

            -- ✅ ADD RAINBOW HIGHLIGHT ONLY TO FRIENDS
            local Highlight = Player.Character:FindFirstChildOfClass("Highlight") or Instance.new("Highlight")
            Highlight.Name = "FriendHighlight"
            Highlight.FillTransparency = 1
            Highlight.OutlineTransparency = 0
            Highlight.OutlineColor = Col
            Highlight.Adornee = Player.Character
            Highlight.Parent = Player.Character
        end
    end
end)
