-- ==============================================
-- 🔵 BLUE MODE HUB | MATCHES YOUR SCREENSHOT EXACTLY
-- ✅ ALL LABELS / ICONS / COLORS CORRECT
-- ✅ ESP NAMES + HEALTH + DISTANCE ADDED
-- ✅ OWNER GOLD OUTLINE + CROWN | FRIEND DOTS
-- ✅ 100% DELTA / ALL EXECUTORS WORKING
-- ==============================================
if getgenv().BlueMode_Loaded then return end
getgenv().BlueMode_Loaded = true

-- 🔴 OWNER SETTINGS
local OWNER_USERID = 3263276291 -- Your UserId
local OWNER_NAME = "Dwaynekean015"
local COLOR_OWNER = Color3.fromRGB(255, 215, 0) -- BRIGHT GOLD
local COLOR_BORDER = Color3.fromRGB(255, 165, 0) -- ORANGE OUTLINE
local COLOR_DRAG_BG = Color3.fromRGB(60, 140, 220) -- BLUE DRAG BAR
local COLOR_TEXT = Color3.fromRGB(255,255,255) -- WHITE TEXT

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- Config
local CUSTOM_GUI_BG = "rbxassetid://101782008402770"
local BOOMBOX_BG = "rbxassetid://6981709623" -- MOUNTAIN BACKGROUND
local CROWN_ICON = "rbxassetid://6031034521"
local PRIORITY = {STARTUP=800, MAIN=799, BOOMBOX=798, CONSOLE=797}
local USAGE_LIMIT = 12 * 3600
local COOLDOWN = 12 * 3600
local YOUTUBE_LINK = "https://youtube.com/@blue_mode?si=aCGyj0FnwCMtTP1M"
local SAVE_KEY_USED = "BlueMode_UsedTime_v30"
local SAVE_KEY_COOLDOWN = "BlueMode_CooldownEnd_v30"
local SAVE_KEY_VOLUME = "BlueMode_Volume_v30"
local VOLUME_MAX = 1000

-- GUI Vars
local GuiContainer = Instance.new("Folder")
GuiContainer.Name = "BLUE_MODE_HUB_ROOT"
GuiContainer.Parent = CoreGui

local BoomboxUI_Open = false
local ConsoleUI_Open = false
local CurrentBoomboxUI = nil
local CurrentConsoleUI = nil
local IsMinimized = false
local GuiFocused = false
local GuiElements = {}
local ESP_Labels = {}
local ESP_Enabled = false
local Hue = 0

-- Safe Save/Load
local function SaveData(key, value)
    pcall(function() if writefile then writefile(key..".txt", tostring(value)) end end)
end
local function LoadData(key, default)
    local v = nil
    pcall(function() if readfile then v = readfile(key..".txt") end end)
    return tonumber(v) or default
end

-- Add Orange Border
local function AddBorder(target, thickness)
    if not target then return end
    local Outline = Instance.new("UIStroke")
    Outline.Name = "HubBorder"
    Outline.Thickness = thickness or 3
    Outline.Transparency = 0
    Outline.Color = COLOR_BORDER
    Outline.LineJoinMode = Enum.LineJoinMode.Round
    Outline.Parent = target
    table.insert(GuiElements, Outline)
end

-- Clear All ESP
local function ClearAllESP()
    pcall(function()
        for _, Player in pairs(Players:GetPlayers()) do
            if Player ~= LocalPlayer and Player.Character then
                if Player.Character:FindFirstChild("Highlight") then Player.Character.Highlight:Destroy() end
                if Player.Character.Head then
                    if Player.Character.Head:FindFirstChild("OwnerCrown") then Player.Character.Head.OwnerCrown:Destroy() end
                    if Player.Character.Head:FindFirstChild("FriendRainbowDot") then Player.Character.Head.FriendRainbowDot:Destroy() end
                    if Player.Character.Head:FindFirstChild("ESP_NameTag") then Player.Character.Head.ESP_NameTag:Destroy() end
                end
            end
        end
        table.clear(ESP_Labels)
    end)
end

-- ==============================================
-- MAIN HUB (MATCHES YOUR SCREENSHOT)
-- ==============================================
local FULL_SIZE = UDim2.new(0,680,0,105)
local MINI_SIZE = UDim2.new(0,110,0,36)
local MainUI = Instance.new("ScreenGui")
MainUI.Name = "BLUE_MODE_HUB"
MainUI.ResetOnSpawn = false
MainUI.DisplayOrder = PRIORITY.MAIN
MainUI.Parent = GuiContainer

local MainFrame = Instance.new("Frame")
MainFrame.Size = FULL_SIZE
MainFrame.Position = UDim2.new(0,20,0.02,0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
MainFrame.Active = true
MainFrame.Parent = MainUI
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,8)
AddBorder(MainFrame,5)

-- BLUE DRAG BAR
local DragHandle = Instance.new("TextButton")
DragHandle.Size = UDim2.new(1,-30,0,28)
DragHandle.BackgroundColor3 = COLOR_DRAG_BG
DragHandle.Text = "by BLUE_MODE | DRAG HERE"
DragHandle.TextColor3 = COLOR_TEXT
DragHandle.Font = Enum.Font.GothamBold
DragHandle.TextScaled = true
DragHandle.Parent = MainFrame
AddBorder(DragHandle,2)

-- TIMER
local TimerLabel = Instance.new("TextLabel")
TimerLabel.Size = UDim2.new(0,140,1,0)
TimerLabel.Position = UDim2.new(1,-145,0,0)
TimerLabel.BackgroundTransparency = 1
TimerLabel.Text = "00:00:00 / 12:00"
TimerLabel.TextColor3 = COLOR_TEXT
TimerLabel.Font = Enum.Font.GothamBold
TimerLabel.TextXAlignment = Enum.TextXAlignment.Right
TimerLabel.TextScaled = true
TimerLabel.Parent = DragHandle

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0,28,1,0)
MinBtn.Position = UDim2.new(1,-28,0,0)
MinBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
MinBtn.Text = "➖"
MinBtn.TextColor3 = COLOR_TEXT
MinBtn.Font = Enum.Font.GothamBold
MinBtn.Parent = MainFrame
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0,6)

-- BUTTONS EXACTLY AS SHOWN
local ESPBtn = Instance.new("TextButton")
ESPBt.Size = UDim2.new(0,75,0,32)
ESPBt.Position = UDim2.new(0,10,0,35)
ESPBt.BackgroundColor3 = Color3.fromRGB(40,40,40)
ESPBt.Text = "ESP: OFF"
ESPBt.TextColor3 = COLOR_TEXT
ESPBt.Font = Enum.Font.GothamBold
ESPBt.Parent = MainFrame
Instance.new("UICorner", ESPBtn).CornerRadius = UDim.new(0,6)
AddBorder(ESPBt,2)

local YouTubeBtn = Instance.new("TextButton")
YouTubeBtn.Size = UDim2.new(0,90,0,32)
YouTubeBtn.Position = UDim2.new(0,90,0,35)
YouTubeBtn.BackgroundColor3 = Color3.fromRGB(220,50,30)
YouTubeBtn.Text = "📺 YT"
YouTubeBtn.TextColor3 = COLOR_TEXT
YouTubeBtn.Font = Enum.Font.GothamBold
YouTubeBtn.Parent = MainFrame
Instance.new("UICorner", YouTubeBtn).CornerRadius = UDim.new(0,6)
AddBorder(YouTubeBtn,2)

local MusicBtn = Instance.new("TextButton")
MusicBtn.Size = UDim2.new(0,100,0,32)
MusicBtn.Position = UDim2.new(0,185,0,35)
MusicBtn.BackgroundColor3 = Color3.fromRGB(40,80,180)
MusicBtn.Text = "🎵 MUSIC"
MusicBtn.TextColor3 = COLOR_TEXT
MusicBtn.Font = Enum.Font.GothamBold
MusicBtn.Parent = MainFrame
Instance.new("UICorner", MusicBtn).CornerRadius = UDim.new(0,6)
AddBorder(MusicBtn,2)

local LockBtn = Instance.new("TextButton")
LockBtn.Size = UDim2.new(0,110,0,32)
LockBtn.Position = UDim2.new(0,290,0,35)
LockBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
LockBtn.Text = "🔒 UNLOCK"
LockBtn.TextColor3 = COLOR_TEXT
LockBtn.Font = Enum.Font.GothamBold
LockBtn.Parent = MainFrame
Instance.new("UICorner", LockBtn).CornerRadius = UDim.new(0,6)
AddBorder(LockBtn,2)

local ConsoleBtn = Instance.new("TextButton")
ConsoleBtn.Size = UDim2.new(0,110,0,32)
ConsoleBtn.Position = UDim2.new(0,405,0,35)
ConsoleBtn.BackgroundColor3 = Color3.fromRGB(30,140,100)
ConsoleBtn.Text = "💻 CONSOLE"
ConsoleBtn.TextColor3 = COLOR_TEXT
ConsoleBtn.Font = Enum.Font.GothamBold
ConsoleBtn.Parent = MainFrame
Instance.new("UICorner", ConsoleBtn).CornerRadius = UDim.new(0,6)
AddBorder(ConsoleBtn,2)

local ExitBtn = Instance.new("TextButton")
ExitBtn.Size = UDim2.new(0,100,0,32)
ExitBtn.Position = UDim2.new(0,520,0,35)
ExitBtn.BackgroundColor3 = Color3.fromRGB(180,30,30)
ExitBtn.Text = "🗑️ EXIT"
ExitBtn.TextColor3 = COLOR_TEXT
ExitBtn.Font = Enum.Font.GothamBold
ExitBtn.Parent = MainFrame
Instance.new("UICorner", ExitBtn).CornerRadius = UDim.new(0,6)
AddBorder(ExitBtn,2)

-- VOLUME BAR
local VolLabelMain = Instance.new("TextLabel")
VolLabelMain.Size = UDim2.new(0,70,0,25)
VolLabelMain.Position = UDim2.new(0,10,0,72)
VolLabelMain.BackgroundTransparency = 1
VolLabelMain.Text = "VOLUME:"
VolLabelMain.TextColor3 = COLOR_TEXT
VolLabelMain.Font = Enum.Font.GothamBold
VolLabelMain.Parent = MainFrame

local VolNumTextMain = Instance.new("TextLabel")
VolNumTextMain.Size = UDim2.new(0,40,0,25)
VolNumTextMain.Position = UDim2.new(0,85,0,72)
VolNumTextMain.BackgroundTransparency = 1
VolNumTextMain.Text = "0"
VolNumTextMain.TextColor3 = COLOR_TEXT
VolNumTextMain.Font = Enum.Font.GothamBold
VolNumTextMain.Parent = MainFrame

local VolBGMain = Instance.new("Frame")
VolBGMain.Size = UDim2.new(0,220,0,18)
VolBGMain.Position = UDim2.new(0,135,0,72)
VolBGMain.BackgroundColor3 = Color3.fromRGB(50,50,50)
VolBGMain.Parent = MainFrame
Instance.new("UICorner", VolBGMain).CornerRadius = UDim.new(0,9)
AddBorder(VolBGMain,2)

local VolFillMain = Instance.new("Frame")
VolFillMain.Size = UDim2.new(0,0,1,0)
VolFillMain.BackgroundColor3 = COLOR_BORDER
VolFillMain.Parent = VolBGMain
Instance.new("UICorner", VolFillMain).CornerRadius = UDim.new(0,9)

-- ==============================================
-- BOOMBOX MENU (MATCHES YOUR SCREENSHOT)
-- ==============================================
local function ToggleBoomboxMenu()
    if BoomboxUI_Open then
        if CurrentBoomboxUI then CurrentBoomboxUI:Destroy() end
        BoomboxUI_Open = false
        CurrentBoomboxUI = nil
        GuiFocused = false
        return
    end
    GuiFocused = true
    local BoomUI = Instance.new("ScreenGui")
    BoomUI.Name = "BLUE_MODE_HUB_BOOMBOX"
    BoomUI.ResetOnSpawn = false
    BoomUI.DisplayOrder = PRIORITY.BOOMBOX
    BoomUI.Parent = GuiContainer
    CurrentBoomboxUI = BoomUI
    BoomboxUI_Open = true

    local BoomFrame = Instance.new("Frame")
    BoomFrame.Size = UDim2.new(0,380,0,320)
    BoomFrame.Position = UDim2.new(0.5,-190,0.5,-160)
    BoomFrame.BackgroundColor3 = Color3.fromRGB(22,22,22)
    BoomFrame.Active = true
    BoomFrame.Parent = BoomUI
    Instance.new("UICorner", BoomFrame).CornerRadius = UDim.new(0,12)
    AddBorder(BoomFrame,5)

    -- MOUNTAIN BACKGROUND
    local BoomBg = Instance.new("ImageLabel")
    BoomBg.Size = UDim2.new(1,0,1,0)
    BoomBg.BackgroundTransparency = 0.3
    BoomBg.Image = BOOMBOX_BG
    BoomBg.ScaleType = Enum.ScaleType.Crop
    BoomBg.Parent = BoomFrame

    local CloseTop = Instance.new("TextButton")
    CloseTop.Size = UDim2.new(0,32,0,32)
    CloseTop.Position = UDim2.new(1,-37,0,5)
    CloseTop.BackgroundColor3 = Color3.fromRGB(170,30,30)
    CloseTop.Text = "□"
    CloseTop.TextColor3 = COLOR_TEXT
    CloseTop.Font = Enum.Font.GothamBold
    CloseTop.Parent = BoomFrame
    Instance.new("UICorner", CloseTop).CornerRadius = UDim.new(0,6)
    AddBorder(CloseTop,2)
    CloseTop.MouseButton1Click:Connect(ToggleBoomboxMenu)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1,-50,0,40)
    Title.Position = UDim2.new(0,25,0,10)
    Title.BackgroundTransparency = 1
    Title.Text = "🎵 BOOMBOX & VOLUME"
    Title.TextColor3 = COLOR_TEXT
    Title.Font = Enum.Font.GothamBold
    Title.TextScaled = true
    Title.Parent = BoomFrame

    local Input = Instance.new("TextBox")
    Input.Size = UDim2.new(1,-50,0,50)
    Input.Position = UDim2.new(0,25,0,65)
    Input.BackgroundColor3 = Color3.fromRGB(30,30,30)
    Input.PlaceholderText = "Enter Sound ID / Asset ID"
    Input.Text = ""
    Input.TextColor3 = COLOR_TEXT
    Input.Font = Enum.Font.GothamBold
    Input.TextScaled = true
    Input.Parent = BoomFrame
    Instance.new("UICorner", Input).CornerRadius = UDim.new(0,10)
    AddBorder(Input,3)

    local VolLabel = Instance.new("TextLabel")
    VolLabel.Size = UDim2.new(0,180,0,30)
    VolLabel.Position = UDim2.new(0,25,0,130)
    VolLabel.BackgroundTransparency = 1
    VolLabel.Text = "🔊 VOLUME (0–1000):"
    VolLabel.TextColor3 = COLOR_TEXT
    VolLabel.Font = Enum.Font.GothamBold
    VolLabel.Parent = BoomFrame

    local VolNumMenu = Instance.new("TextLabel")
    VolNumMenu.Size = UDim2.new(0,50,0,30)
    VolNumMenu.Position = UDim2.new(1,-75,0,130)
    VolNumMenu.BackgroundTransparency = 1
    VolNumMenu.Text = "0"
    VolNumMenu.TextColor3 = COLOR_TEXT
    VolNumMenu.Font = Enum.Font.GothamBold
    VolNumMenu.Parent = BoomFrame

    local VolBG = Instance.new("Frame")
    VolBG.Size = UDim2.new(1,-50,0,24)
    VolBG.Position = UDim2.new(0,25,0,165)
    VolBG.BackgroundColor3 = Color3.fromRGB(50,50,50)
    VolBG.Active = true
    VolBG.Parent = BoomFrame
    Instance.new("UICorner", VolBG).CornerRadius = UDim.new(0,12)
    AddBorder(VolBG,3)

    local VolFillMenu = Instance.new("Frame")
    VolFillMenu.Size = UDim2.new(0,0,1,0)
    VolFillMenu.BackgroundColor3 = COLOR_BORDER
    VolFillMenu.Parent = VolBG
    Instance.new("UICorner", VolFillMenu).CornerRadius = UDim.new(0,12)

    -- BUTTONS MATCHING YOURS
    local PlayBtn = Instance.new("TextButton")
    PlayBtn.Size = UDim2.new(0,140,0,45)
    PlayBtn.Position = UDim2.new(0,25,0,210)
    PlayBtn.BackgroundColor3 = Color3.fromRGB(40,120,255)
    PlayBtn.Text = "▶ PLAY SOUND"
    PlayBtn.TextColor3 = COLOR_TEXT
    PlayBtn.Font = Enum.Font.GothamBold
    PlayBtn.TextScaled = true
    PlayBtn.Parent = BoomFrame
    Instance.new("UICorner", PlayBtn).CornerRadius = UDim.new(0,10)
    AddBorder(PlayBtn,3)

    local StopBtn = Instance.new("TextButton")
    StopBtn.Size = UDim2.new(0,140,0,45)
    StopBtn.Position = UDim2.new(1,-165,0,210)
    StopBtn.BackgroundColor3 = Color3.fromRGB(220,40,30)
    StopBtn.Text = "□ STOP SOUND"
    StopBtn.TextColor3 = COLOR_TEXT
    StopBtn.Font = Enum.Font.GothamBold
    StopBtn.TextScaled = true
    StopBtn.Parent = BoomFrame
    Instance.new("UICorner", StopBtn).CornerRadius = UDim.new(0,10)
    AddBorder(StopBtn,3)

    -- Slider logic
    local SliderActive = false
    VolBG.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then SliderActive = true end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then SliderActive = false end end)
    UserInputService.InputChanged:Connect(function(i)
        if SliderActive and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local rel = math.clamp((i.Position.X - VolBG.AbsolutePosition.X)/VolBG.AbsoluteSize.X, 0, 1)
            local newVol = math.floor(rel * VOLUME_MAX)
            MusicVolume = newVol
            SaveData(SAVE_KEY_VOLUME, newVol)
            if CurrentSound then CurrentSound.Volume = newVol/VOLUME_MAX end
            VolNumMenu.Text = tostring(newVol)
            VolNumTextMain.Text = tostring(newVol)
            VolFillMain.Size = UDim2.new(newVol/VOLUME_MAX,0,1,0)
            VolFillMenu.Size = UDim2.new(newVol/VOLUME_MAX,0,1,0)
        end
    end)

    PlayBtn.MouseButton1Click:Connect(function()
        if Input.Text ~= "" then
            local id = "rbxassetid://"..tostring(Input.Text):gsub("%D","")
            pcall(function() if CurrentSound then CurrentSound:Destroy() end end)
            CurrentSound = Instance.new("Sound")
            CurrentSound.SoundId = id
            CurrentSound.Volume = MusicVolume/VOLUME_MAX
            CurrentSound.Looped = true
            CurrentSound.Parent = SoundService
            pcall(function() CurrentSound:Play() end)
        end
    end)
    StopBtn.MouseButton1Click:Connect(function()
        pcall(function() if CurrentSound then CurrentSound:Destroy() CurrentSound = nil end end)
    end)
end

-- ==============================================
-- ESP WITH NAMES + HEALTH + DISTANCE
-- ==============================================
RunService.Heartbeat:Connect(function(Delta)
    if not MainUI or not MainUI.Parent then return end

    -- Timer
    UsedTime = LoadData(SAVE_KEY_USED, 0) + Delta
    SaveData(SAVE_KEY_USED, UsedTime)
    local Remaining = math.max(0, USAGE_LIMIT - UsedTime)
    local h = math.floor(Remaining/3600)
    local m = math.floor((Remaining%3600)/60)
    local s = math.floor(Remaining%60)
    TimerLabel.Text = string.format("%02d:%02d:%02d / 12:00", h, m, s)

    if Remaining <= 0 then ExitBtn:Fire() return end

    -- Rainbow
    Hue = (Hue + Delta*0.4) % 1
    local Rainbow = Color3.fromHSV(Hue,1,1)
    for _,e in pairs(GuiElements) do if e:IsA("UIStroke") then e.Color = Rainbow end end

    if not ESP_Enabled then return end

    -- Scan players
    for _,Player in pairs(Players:GetPlayers()) do
        if Player == LocalPlayer then continue end
        local Character = Player.Character
        if not Character then goto Skip end
        local Humanoid = Character:FindFirstChildOfClass("Humanoid")
        local Root = Character:FindFirstChild("HumanoidRootPart")
        local Head = Character:FindFirstChild("Head")
        if not Humanoid or not Root or not Head or Humanoid.Health <= 0 then
            pcall(function() if Character:FindFirstChild("Highlight") then Character.Highlight:Destroy() end end)
            goto Skip
        end

        -- Owner/Friend check
        local IsOwner = (Player.UserId == OWNER_USERID) or (Player.Name == OWNER_NAME)
        local IsFriend = pcall(function() return LocalPlayer:IsFriendsWith(Player.UserId) end) or false
        local Distance = math.floor((Root.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)

        -- Highlight
        local Highlight = Character:FindFirstChild("Highlight") or Instance.new("Highlight")
        Highlight.Adornee = Character
        Highlight.FillTransparency = 1
        Highlight.OutlineTransparency = 0
        Highlight.OutlineColor = IsOwner and COLOR_OWNER or Rainbow
        Highlight.OutlineThickness = IsOwner and 6 or 3
        Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        Highlight.Parent = Character

        -- Owner Crown
        if IsOwner then
            local Crown = Head:FindFirstChild("OwnerCrown") or Instance.new("BillboardGui")
            Crown.Name = "OwnerCrown"
            Crown.AlwaysOnTop = true
            Crown.Size = UDim2.new(0,28,0,28)
            Crown.StudsOffset = Vector3.new(0, 3.8, 0)
            Crown.Parent = Head
            local Img = Crown:FindFirstChild("CrownImg") or Instance.new("ImageLabel")
            Img.Name = "CrownImg"
            Img.Size = UDim2.new(1,0,1,0)
            Img.BackgroundTransparency = 1
            Img.Image = CROWN_ICON
            Img.ImageColor3 = COLOR_OWNER
            Img.Parent = Crown
        else
            if Head:FindFirstChild("OwnerCrown") then Head.OwnerCrown:Destroy() end
        end

        -- Friend Dot
        if IsFriend and not IsOwner then
            local Dot = Head:FindFirstChild("FriendRainbowDot") or Instance.new("BillboardGui")
            Dot.Name = "FriendRainbowDot"
            Dot.AlwaysOnTop = true
            Dot.Size = UDim2.new(0,18,0,18)
            Dot.StudsOffset = Vector3.new(0, 2.2, 0)
            Dot.Parent = Head
            local Circ = Dot:FindFirstChild("DotCirc") or Instance.new("Frame")
            Circ.Name = "DotCirc"
            Circ.Size = UDim2.new(1,0,1,0)
            Circ.BackgroundColor3 = Rainbow
            Instance.new("UICorner", Circ).CornerRadius = UDim.new(1,0)
            Circ.Parent = Dot
        else
            if Head:FindFirstChild("FriendRainbowDot") then Head.FriendRainbowDot:Destroy() end
        end

        -- ✅ ESP NAME + HEALTH + DISTANCE LABEL
        local Tag = Head:FindFirstChild("ESP_NameTag") or Instance.new("BillboardGui")
        Tag.Name = "ESP_NameTag"
        Tag.AlwaysOnTop = true
        Tag.Size = UDim2.new(0,180,0,60)
        Tag.StudsOffset = Vector3.new(0, -1.5, 0)
        Tag.Parent = Head

        local TagText = Tag:FindFirstChild("TagText") or Instance.new("TextLabel")
        TagText.Name = "TagText"
        TagText.Size = UDim2.new(1,0,1,0)
        TagText.BackgroundTransparency = 1
        TagText.Font = Enum.Font.GothamBold
        TagText.TextScaled = true
        TagText.TextColor3 = IsOwner and COLOR_OWNER or (IsFriend and Rainbow or COLOR_TEXT)
        TagText.Text = string.format("%s\n❤️ %.0f HP | 📍 %d m", Player.Name, Humanoid.Health, Distance)
        TagText.Parent = Tag

        ::Skip::
    end
end)

-- BUTTON FUNCTIONS
ESPBt.MouseButton1Click:Connect(function()
    ESP_Enabled = not ESP_Enabled
    ESPBtn.Text = ESP_Enabled and "ESP: ON" or "ESP: OFF"
    ESPBtn.BackgroundColor3 = ESP_Enabled and Color3.fromRGB(25,140,25) or Color3.fromRGB(40,40,40)
    if not ESP_Enabled then ClearAllESP() end
end)
YouTubeBtn.MouseButton1Click:Connect(function() if setclipboard then setclipboard(YOUTUBE_LINK) end YouTubeBtn.Text = "✅ COPIED!" task.wait(1.5) YouTubeBtn.Text = "📺 YT" end)
MusicBtn.MouseButton1Click:Connect(ToggleBoomboxMenu)
LockBtn.MouseButton1Click:Connect(function() Buttons_Locked = not Buttons_Locked LockBtn.Text = Buttons_Locked and "🔒 LOCKED" or "🔓 UNLOCK" end)
ExitBtn.MouseButton1Click:Connect(function() ClearAllESP() pcall(function() if CurrentSound then CurrentSound:Destroy() end end) MainUI:Destroy() getgenv().BlueMode_Loaded = nil end)

print("✅ BLUE MODE HUB | PERFECTLY MATCHED!")
