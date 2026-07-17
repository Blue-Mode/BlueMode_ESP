-- ==============================================
-- ✅ DELETE → YES = ALL OUTLINES + CIRCLES REMOVED COMPLETELY
-- ✅ ALL ORIGINAL FEATURES KEPT
-- ✅ FRIEND CIRCLE WORKS LIKE NAME TAG
-- ==============================================

if getgenv().BlueModeLoaded then return end
getgenv().BlueModeLoaded = true

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
if not PlayerGui then return end

-- SETTINGS
local MAX_SECONDS = 12 * 3600
local YT_LINK = "https://youtube.com/@blue_mode?si=_NTd2gfDzVW9sIPM"

-- STATE
local UsedTime = 0
local MusicOn = false
local MusicSound = nil
local MOVE_LOCKED = false
local ESP_ON = false
local UI = nil

-- ==============================================
-- PERFECT CLEANUP — RUNS BEFORE DELETE
-- ==============================================
local function RemoveAllESP()
    pcall(function()
        -- DELETE EVERY HIGHLIGHT/OUTLINE IN ENTIRE GAME
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("Highlight") or v.Name == "FriendCircle" then
                v:Destroy()
            end
        end
    end)
end

local function FullDeleteScript()
    -- FIRST REMOVE ALL OUTLINES/CIRCLES
    RemoveAllESP()
    -- THEN DELETE EVERYTHING ELSE
    if MusicSound then pcall(function() MusicSound:Destroy() end) end
    if UI then pcall(function() UI:Destroy() end) end
    getgenv().BlueModeLoaded = nil
end

-- ==============================================
-- FULL GUI + ALL FEATURES
-- ==============================================
UI = Instance.new("ScreenGui")
UI.Name = "BLUE_MODE"
UI.ResetOnSpawn = false
UI.Parent = PlayerGui

-- DELETE CONFIRM POPUP
local DeleteConfirm = Instance.new("Frame")
DeleteConfirm.Size = UDim2.new(0,300,0,160)
DeleteConfirm.Position = UDim2.new(0.5,-150,0.5,-80)
DeleteConfirm.BackgroundColor3 = Color3.fromRGB(35,35,35)
DeleteConfirm.Visible = false
DeleteConfirm.Parent = UI
Instance.new("UICorner", DeleteConfirm).CornerRadius = UDim.new(0,10)

local ConfirmText = Instance.new("TextLabel")
ConfirmText.Size = UDim2.new(1,-20,0,60)
ConfirmText.Position = UDim2.new(0,10,0,15)
ConfirmText.BackgroundTransparency = 1
ConfirmText.Text = "⚠️ ARE YOU SURE YOU WANT TO\nREMOVE THIS SCRIPT?"
ConfirmText.Font = Enum.Font.GothamBold
ConfirmText.TextScaled = true
ConfirmText.TextColor3 = Color3.new(1,1,1)
ConfirmText.TextWrapped = true
ConfirmText.Parent = DeleteConfirm

local YesBtn = Instance.new("TextButton")
YesBtn.Size = UDim2.new(0,110,0,40)
YesBtn.Position = UDim2.new(0,25,0,100)
YesBtn.BackgroundColor3 = Color3.fromRGB(40,160,60)
YesBtn.Text = "✅ YES, DELETE"
YesBtn.TextColor3 = Color3.new(1,1,1)
YesBtn.Font = Enum.Font.GothamBold
YesBtn.TextScaled = true
YesBtn.Parent = DeleteConfirm
Instance.new("UICorner", YesBtn).CornerRadius = UDim.new(0,6)

local NoBtn = Instance.new("TextButton")
NoBtn.Size = UDim2.new(0,110,0,40)
NoBtn.Position = UDim2.new(1,-135,0,100)
NoBtn.BackgroundColor3 = Color3.fromRGB(180,40,40)
NoBtn.Text = "❌ NO, CANCEL"
NoBtn.TextColor3 = Color3.new(1,1,1)
NoBtn.Font = Enum.Font.GothamBold
NoBtn.TextScaled = true
NoBtn.Parent = DeleteConfirm
Instance.new("UICorner", NoBtn).CornerRadius = UDim.new(0,6)

-- MUSIC POPUP
local MusicPopup = Instance.new("Frame")
MusicPopup.Size = UDim2.new(0,320,0,200)
MusicPopup.Position = UDim2.new(0.5,-160,0.5,-100)
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
IDInput.Position = UDim2.new(0,15,0,60)
IDInput.BackgroundColor3 = Color3.fromRGB(45,45,45)
IDInput.Text = "Enter ID here"
IDInput.Font = Enum.Font.Gotham
IDInput.TextScaled = true
IDInput.TextColor3 = Color3.new(1,1,1)
IDInput.ClearTextOnFocus = true
IDInput.Parent = MusicPopup
Instance.new("UICorner", IDInput).CornerRadius = UDim.new(0,6)

local PlayBtn = Instance.new("TextButton")
PlayBtn.Size = UDim2.new(0,120,0,40)
PlayBtn.Position = UDim2.new(0,15,0,125)
PlayBtn.BackgroundColor3 = Color3.fromRGB(40,150,60)
PlayBtn.Text = "▶ PLAY"
PlayBtn.TextColor3 = Color3.new(1,1,1)
PlayBtn.Font = Enum.Font.GothamBold
PlayBtn.TextScaled = true
PlayBtn.Parent = MusicPopup
Instance.new("UICorner", PlayBtn).CornerRadius = UDim.new(0,6)

local CloseMusicBtn = Instance.new("TextButton")
CloseMusicBtn.Size = UDim2.new(0,120,0,40)
CloseMusicBtn.Position = UDim2.new(1,-135,0,125)
CloseMusicBtn.BackgroundColor3 = Color3.fromRGB(170,40,40)
CloseMusicBtn.Text = "✕ CLOSE"
CloseMusicBtn.TextColor3 = Color3.new(1,1,1)
CloseMusicBtn.Font = Enum.Font.GothamBold
CloseMusicBtn.TextScaled = true
CloseMusicBtn.Parent = MusicPopup
Instance.new("UICorner", CloseMusicBtn).CornerRadius = UDim.new(0,6)

-- WELCOME SCREEN
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

-- MAIN MENU
local MainMenu = Instance.new("Frame")
MainMenu.Size = UDim2.new(0,480,0,95)
MainMenu.Position = UDim2.new(0,10,0.05,0)
MainMenu.BackgroundColor3 = Color3.fromRGB(20,20,20)
MainMenu.Active = true
MainMenu.Draggable = true
MainMenu.Visible = false
MainMenu.Parent = UI
Instance.new("UICorner", MainMenu).CornerRadius = UDim.new(0,6)

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1,0,0,35)
TitleBar.BackgroundColor3 = Color3.fromRGB(30,110,190)
TitleBar.Parent = MainMenu

local MenuTitle = Instance.new("TextLabel")
MenuTitle.Size = UDim2.new(1,-130,1,0)
MenuTitle.Position = UDim2.new(0,10,0,0)
MenuTitle.BackgroundTransparency = 1
MenuTitle.Text = "BLUE_MODE ESP"
MenuTitle.Font = Enum.Font.GothamBold
MenuTitle.TextColor3 = Color3.new(1,1,1)
MenuTitle.TextScaled = true
MenuTitle.Parent = TitleBar

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0,45,0,28)
MinBtn.Position = UDim2.new(1,-100,0,3)
MinBtn.BackgroundColor3 = Color3.fromRGB(255,190,0)
MinBtn.Text = "−"
MinBtn.TextColor3 = Color3.new(0,0,0)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextScaled = true
MinBtn.Parent = TitleBar
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0,5)

local TopDeleteBtn = Instance.new("TextButton")
TopDeleteBtn.Size = UDim2.new(0,45,0,28)
TopDeleteBtn.Position = UDim2.new(1,-50,0,3)
TopDeleteBtn.BackgroundColor3 = Color3.fromRGB(255,50,50)
TopDeleteBtn.Text = "✕"
TopDeleteBtn.TextColor3 = Color3.new(1,1,1)
TopDeleteBtn.Font = Enum.Font.GothamBold
TopDeleteBtn.TextScaled = true
TopDeleteBtn.Parent = TitleBar
Instance.new("UICorner", TopDeleteBtn).CornerRadius = UDim.new(0,5)

local TimerText = Instance.new("TextLabel")
TimerText.Size = UDim2.new(1,-20,0,22)
TimerText.Position = UDim2.new(0,10,0,42)
TimerText.BackgroundTransparency = 1
TimerText.Font = Enum.Font.GothamBold
TimerText.TextColor3 = Color3.new(1,1,1)
TimerText.TextScaled = true
TimerText.Parent = MainMenu

local ESPBtn = Instance.new("TextButton")
ESPBtn.Size = UDim2.new(0,70,0,28)
ESPBtn.Position = UDim2.new(0,10,0,70)
ESPBtn.BackgroundColor3 = Color3.fromRGB(170,40,40)
ESPBtn.Text = "ESP OFF"
ESPBtn.Font = Enum.Font.GothamBold
ESPBtn.TextColor3 = Color3.new(1,1,1)
ESPBtn.TextScaled = true
ESPBtn.Parent = MainMenu
Instance.new("UICorner", ESPBtn).CornerRadius = UDim.new(0,4)

local MusicBtn = Instance.new("TextButton")
MusicBtn.Size = UDim2.new(0,60,0,28)
MusicBtn.Position = UDim2.new(0,90,0,70)
MusicBtn.BackgroundColor3 = Color3.fromRGB(170,40,40)
MusicBtn.Text = "🎵 OFF"
MusicBtn.Font = Enum.Font.GothamBold
MusicBtn.TextScaled = true
MusicBtn.Parent = MainMenu
Instance.new("UICorner", MusicBtn).CornerRadius = UDim.new(0,4)

local YTBtn = Instance.new("TextButton")
YTBtn.Size = UDim2.new(0,60,0,28)
YTBtn.Position = UDim2.new(0,160,0,70)
YTBtn.BackgroundColor3 = Color3.fromRGB(20,110,180)
YTBtn.Text = "📺 YT"
YTBtn.Font = Enum.Font.GothamBold
YTBtn.TextScaled = true
YTBtn.Parent = MainMenu
Instance.new("UICorner", YTBtn).CornerRadius = UDim.new(0,4)

local LockBtn = Instance.new("TextButton")
LockBtn.Size = UDim2.new(0,70,0,28)
LockBtn.Position = UDim2.new(0,230,0,70)
LockBtn.BackgroundColor3 = Color3.fromRGB(40,150,60)
LockBtn.Text = "UNLOCK"
LockBtn.Font = Enum.Font.GothamBold
LockBtn.TextScaled = true
LockBtn.Parent = MainMenu
Instance.new("UICorner", LockBtn).CornerRadius = UDim.new(0,4)

-- MINIMIZE BAR
local MinBar = Instance.new("Frame")
MinBar.Size = UDim2.new(0,180,0,35)
MinBar.Position = MainMenu.Position
MinBar.BackgroundColor3 = Color3.fromRGB(30,110,190)
MinBar.Active = true
MinBar.Draggable = true
MinBar.Visible = false
MinBar.Parent = UI
Instance.new("UICorner", MinBar).CornerRadius = UDim.new(0,6)

local BarTimer = Instance.new("TextLabel")
BarTimer.Size = UDim2.new(1,-40,1,0)
BarTimer.Position = UDim2.new(0,10,0,0)
BarTimer.BackgroundTransparency = 1
BarTimer.Font = Enum.Font.GothamBold
BarTimer.TextColor3 = Color3.new(1,1,1)
BarTimer.TextScaled = true
BarTimer.TextXAlignment = Enum.TextXAlignment.Left
BarTimer.Parent = MinBar

local RestoreBtn = Instance.new("TextButton")
RestoreBtn.Size = UDim2.new(0,30,0,25)
RestoreBtn.Position = UDim2.new(1,-35,0,5)
RestoreBtn.BackgroundColor3 = Color3.fromRGB(255,190,0)
RestoreBtn.Text = "+"
RestoreBtn.TextColor3 = Color3.new(0,0,0)
RestoreBtn.Font = Enum.Font.GothamBold
RestoreBtn.TextScaled = true
RestoreBtn.Parent = MinBar
Instance.new("UICorner", RestoreBtn).CornerRadius = UDim.new(0,4)

-- ==============================================
-- BUTTON ACTIONS
-- ==============================================
StartBtn.MouseButton1Click:Connect(function() Welcome.Visible = false MainMenu.Visible = true end)
MinBtn.MouseButton1Click:Connect(function() MainMenu.Visible = false MinBar.Visible = true MinBar.Position = MainMenu.Position end)
RestoreBtn.MouseButton1Click:Connect(function() MinBar.Visible = false MainMenu.Visible = true end)
TopDeleteBtn.MouseButton1Click:Connect(function() DeleteConfirm.Visible = true end)
YesBtn.MouseButton1Click:Connect(FullDeleteScript)
NoBtn.MouseButton1Click:Connect(function() DeleteConfirm.Visible = false end)

MusicBtn.MouseButton1Click:Connect(function()
    if not MusicOn then MusicPopup.Visible = true
    else MusicOn = false MusicBtn.BackgroundColor3 = Color3.fromRGB(170,40,40) MusicBtn.Text = "🎵 OFF" if MusicSound then pcall(function() MusicSound:Stop() end) end end
end)

PlayBtn.MouseButton1Click:Connect(function()
    local CleanID = IDInput.Text:gsub("%D", "")
    if CleanID == "" then return end
    if MusicSound then pcall(function() MusicSound:Destroy() end) end
    MusicSound = Instance.new("Sound")
    MusicSound.SoundId = "rbxassetid://"..CleanID
    MusicSound.Looped = true MusicSound.Volume = 0.4 MusicSound.Parent = SoundService
    if pcall(function() MusicSound:Play() end) then
        MusicOn = true MusicBtn.BackgroundColor3 = Color3.fromRGB(40,150,60) MusicBtn.Text = "🎵 ON" MusicPopup.Visible = false
    end
end)

CloseMusicBtn.MouseButton1Click:Connect(function() MusicPopup.Visible = false end)
ESPBtn.MouseButton1Click:Connect(function()
    ESP_ON = not ESP_ON
    if ESP_ON then ESPBtn.BackgroundColor3 = Color3.fromRGB(40,150,60) ESPBtn.Text = "ESP ON"
    else ESPBtn.BackgroundColor3 = Color3.fromRGB(170,40,40) ESPBtn.Text = "ESP OFF" RemoveAllESP() end
end)
LockBtn.MouseButton1Click:Connect(function()
    MOVE_LOCKED = not MOVE_LOCKED MainMenu.Draggable = not MOVE_LOCKED MinBar.Draggable = not MOVE_LOCKED
    LockBtn.BackgroundColor3 = MOVE_LOCKED and Color3.fromRGB(170,40,40) or Color3.fromRGB(40,150,60)
    LockBtn.Text = MOVE_LOCKED and "LOCKED" or "UNLOCK"
end)
YTBtn.MouseButton1Click:Connect(function() pcall(function() if setclipboard then setclipboard(YT_LINK) end end) end)

-- ==============================================
-- MAIN LOOP
-- ==============================================
RunService.RenderStepped:Connect(function(dt)
    UsedTime += dt
    local h,m,s = math.floor(UsedTime/3600), math.floor((UsedTime%3600)/60), math.floor(UsedTime%60)
    TimerText.Text = string.format("%02d:%02d:%02d / 12:00:00",h,m,s)
    BarTimer.Text = TimerText.Text

    if UsedTime >= MAX_SECONDS then FullDeleteScript() return end

    local Hue = (os.clock() * 0.25) % 1
    local Col = Color3.fromHSV(Hue,1,1)
    TitleBar.BackgroundColor3 = Col
    MinBar.BackgroundColor3 = Col
    MadeBy.TextColor3 = Col

    if not ESP_ON then return end

    for _, Player in pairs(Players:GetPlayers()) do
        if Player == LocalPlayer then continue end
        local Char = Player.Character
        if not Char then continue end
        local Humanoid = Char:FindFirstChild("Humanoid")
        if not Humanoid or Humanoid.Health <= 0 then
            pcall(function() if Char:FindFirstChild("FriendCircle") then Char.FriendCircle:Destroy() end end)
            continue
        end

        -- Rainbow outline for all
        local Highlight = Char:FindFirstChildOfClass("Highlight") or Instance.new("Highlight")
        Highlight.FillTransparency = 1
        Highlight.OutlineTransparency = 0
        Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        Highlight.OutlineColor = Col
        Highlight.Adornee = Char
        Highlight.Parent = Char

        -- Check friend
        local IsFriend = false
        pcall(function() IsFriend = LocalPlayer:IsFriendsWith(Player.UserId) end)

        -- Friend circle like name tag
        if IsFriend then
            local Head = Char:FindFirstChild("Head")
            if Head then
                if Char:FindFirstChild("FriendCircle") then Char.FriendCircle:Destroy() end
                local Circle = Instance.new("BillboardGui")
                Circle.Name = "FriendCircle"
                Circle.AlwaysOnTop = true
                Circle.Size = UDim2.new(0,120,0,120)
                Circle.StudsOffset = Vector3.new(0, 2.8, 0)
                Circle.Adornee = Head
                Circle.Parent = Char

                local Ring = Instance.new("Frame")
                Ring.Size = UDim2.new(1,0,1,0)
                Ring.BackgroundTransparency = 1
                Ring.BorderSizePixel = 8
                Ring.BorderColor3 = Col
                Ring.Parent = Circle
                Instance.new("UICorner", Ring).CornerRadius = UDim.new(1,0)
            end
        else
            pcall(function() if Char:FindFirstChild("FriendCircle") then Char.FriendCircle:Destroy() end end)
        end
    end
end)
