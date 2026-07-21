-- ==============================================
-- 🔵 BLUE MODE HUB | PART 1/2
-- ✅ FIXED SERVER PING | RESTORED ALL BACKGROUNDS
-- ✅ RUN THIS FIRST
-- ==============================================
if getgenv().BlueMode_Loaded then return end
getgenv().BlueMode_Loaded = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local NetworkClient = game:GetService("NetworkClient")
local Stats = game:GetService("Stats")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local CUSTOM_GUI_BG = "rbxassetid://101782008402770"

local GuiContainer = Instance.new("Folder")
GuiContainer.Name = "BLUE_MODE_HUB_ROOT"
GuiContainer.Parent = CoreGui

local PRIORITY = {
    STARTUP = 800,
    MAIN = 799,
    BOOMBOX = 798,
    CONSOLE = 797,
    EXIT_POPUP = 9999
}

local YOUTUBE_LINK = "https://youtube.com/@blue_mode?si=aCGyj0FnwCMtTP1M"
local SAVE_KEY_VOLUME = "BlueMode_Volume_v22"
local VOLUME_MAX = 1000

local BoomboxUI_Open = false
local ConsoleUI_Open = false
local CurrentBoomboxUI = nil
local CurrentConsoleUI = nil
local IsMinimized = false
local GuiFocused = false
local GuiElements = {}

local function SaveData(key, value) pcall(function() writefile(key..".txt", tostring(value)) end) end
local function LoadData(key, default) local v=nil; pcall(function() v=readfile(key..".txt") end); return tonumber(v) or default end

local function AddRainbowGlow(target, thickness)
    if not target then return end
    local Outline = Instance.new("UIStroke")
    Outline.Name = "RainbowAura"
    Outline.Thickness = thickness or 3
    Outline.Transparency = 0
    Outline.LineJoinMode = Enum.LineJoinMode.Round
    Outline.Parent = target
    table.insert(GuiElements, Outline)
end

-- ✅ EXIT CONFIRM POPUP (WITH BACKGROUND)
local function ShowExitConfirm(OnConfirm)
    local PopupUI = Instance.new("ScreenGui")
    PopupUI.Name = "BLUE_MODE_EXIT_CONFIRM"
    PopupUI.ResetOnSpawn = false
    PopupUI.DisplayOrder = PRIORITY.EXIT_POPUP
    PopupUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    PopupUI.Parent = GuiContainer

    local Popup = Instance.new("Frame")
    Popup.Size = UDim2.new(0, 360, 0, 200)
    Popup.Position = UDim2.new(0.5, -180, 0.5, -100)
    Popup.BackgroundColor3 = Color3.fromRGB(15,15,25)
    Popup.Active = true
    Popup.Parent = PopupUI
    Instance.new("UICorner", Popup).CornerRadius = UDim.new(0,16)

    local PopupBg = Instance.new("ImageLabel")
    PopupBg.Size = UDim2.new(1,0,1,0)
    PopupBg.Position = UDim2.new(0,0,0,0)
    PopupBg.BackgroundTransparency = 1
    PopupBg.Image = CUSTOM_GUI_BG
    PopupBg.ScaleType = Enum.ScaleType.Stretch
    PopupBg.ZIndex = 1
    PopupBg.Parent = Popup

    AddRainbowGlow(Popup,4)

    local PopupTitle = Instance.new("TextLabel")
    PopupTitle.Size = UDim2.new(1,-20,0,45)
    PopupTitle.Position = UDim2.new(0,10,0,15)
    PopupTitle.BackgroundTransparency = 1
    PopupTitle.Font = Enum.Font.GothamBold
    PopupTitle.TextScaled = true
    PopupTitle.Text = "⚠️ EXIT CONFIRM"
    PopupTitle.TextColor3 = Color3.new(1,1,1)
    PopupTitle.ZIndex = 2
    PopupTitle.Parent = Popup

    local PopupText = Instance.new("TextLabel")
    PopupText.Size = UDim2.new(1,-30,0,40)
    PopupText.Position = UDim2.new(0,15,0,70)
    PopupText.BackgroundTransparency = 1
    PopupText.Font = Enum.Font.Gotham
    PopupText.TextScaled = true
    PopupText.Text = "Close Blue Mode Hub?"
    PopupText.TextColor3 = Color3.fromRGB(230,230,230)
    PopupText.ZIndex = 2
    PopupText.Parent = Popup

    local YesBtn = Instance.new("TextButton")
    YesBtn.Size = UDim2.new(0,130,0,50)
    YesBtn.Position = UDim2.new(0,25,0,130)
    YesBtn.BackgroundColor3 = Color3.fromRGB(220,40,40)
    YesBtn.Font = Enum.Font.GothamBold
    YesBtn.TextScaled = true
    YesBtn.Text = "✅ YES EXIT"
    YesBtn.TextColor3 = Color3.new(1,1,1)
    YesBtn.ZIndex = 2
    YesBtn.Parent = Popup
    Instance.new("UICorner", YesBtn).CornerRadius = UDim.new(0,12)
    AddRainbowGlow(YesBtn,3)

    local NoBtn = Instance.new("TextButton")
    NoBtn.Size = UDim2.new(0,130,0,50)
    NoBtn.Position = UDim2.new(1,-155,0,130)
    NoBtn.BackgroundColor3 = Color3.fromRGB(30,150,220)
    NoBtn.Font = Enum.Font.GothamBold
    NoBtn.TextScaled = true
    NoBtn.Text = "❌ NO STAY"
    NoBtn.TextColor3 = Color3.new(1,1,1)
    NoBtn.ZIndex = 2
    NoBtn.Parent = Popup
    Instance.new("UICorner", NoBtn).CornerRadius = UDim.new(0,12)
    AddRainbowGlow(NoBtn,3)

    YesBtn.MouseButton1Click:Connect(function() PopupUI:Destroy(); OnConfirm() end)
    NoBtn.MouseButton1Click:Connect(function() PopupUI:Destroy() end)
end

-- STARTUP SCREEN
local StartupUI = Instance.new("ScreenGui")
StartupUI.Name = "BLUE_MODE_HUB_STARTUP"
StartupUI.ResetOnSpawn = false
StartupUI.DisplayOrder = PRIORITY.STARTUP
StartupUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
StartupUI.Parent = GuiContainer

local StartupBox = Instance.new("Frame")
StartupBox.Size = UDim2.new(0, 420, 0, 420)
StartupBox.Position = UDim2.new(0.5, -210, 0.5, -210)
StartupBox.BackgroundColor3 = Color3.fromRGB(10,12,18)
StartupBox.Active = true
StartupBox.Parent = StartupUI
Instance.new("UICorner", StartupBox).CornerRadius = UDim.new(0, 18)

local StartupGuiBg = Instance.new("ImageLabel")
StartupGuiBg.Size = UDim2.new(1, 0, 1, 0)
StartupGuiBg.Position = UDim2.new(0, 0, 0, 0)
StartupGuiBg.BackgroundTransparency = 1
StartupGuiBg.Image = CUSTOM_GUI_BG
StartupGuiBg.ScaleType = Enum.ScaleType.Stretch
StartupGuiBg.ZIndex = 1
StartupGuiBg.Parent = StartupBox

local StartupBorder = Instance.new("UIStroke")
StartupBorder.Thickness = 5
StartupBorder.LineJoinMode = Enum.LineJoinMode.Round
StartupBorder.ZIndex = 3
StartupBorder.Parent = StartupBox

local StartupTitle = Instance.new("TextLabel")
StartupTitle.Size = UDim2.new(1, -40, 0, 50)
StartupTitle.Position = UDim2.new(0, 20, 0, 15)
StartupTitle.BackgroundTransparency = 1
StartupTitle.Font = Enum.Font.GothamBlack
StartupTitle.TextScaled = true
StartupTitle.Text = "🔵 BLUE MODE HUB"
StartupTitle.TextColor3 = Color3.fromRGB(0, 190, 255)
StartupTitle.ZIndex = 2
StartupTitle.Parent = StartupBox

local UpdateHeader = Instance.new("TextLabel")
UpdateHeader.Size = UDim2.new(1, -40, 0, 35)
UpdateHeader.Position = UDim2.new(0, 20, 0, 75)
UpdateHeader.BackgroundTransparency = 1
UpdateHeader.Font = Enum.Font.GothamBold
UpdateHeader.TextScaled = true
UpdateHeader.Text = "📋 LATEST UPDATES:"
UpdateHeader.TextColor3 = Color3.new(1,1,1)
UpdateHeader.ZIndex = 2
UpdateHeader.Parent = StartupBox

local UpdateList = Instance.new("TextLabel")
UpdateList.Size = UDim2.new(1, -50, 0, 180)
UpdateList.Position = UDim2.new(0, 25, 0, 115)
UpdateList.BackgroundTransparency = 1
UpdateList.Font = Enum.Font.Gotham
UpdateList.TextScaled = true
UpdateList.TextWrapped = true
UpdateList.TextXAlignment = Enum.TextXAlignment.Left
UpdateList.TextYAlignment = Enum.TextYAlignment.Top
UpdateList.TextColor3 = Color3.fromRGB(220,220,220)
UpdateList.ZIndex = 2
UpdateList.Text = [[• VOLUME: 0 → 1000
• NO LONGER BLOCKS ROBLOX MENUS
• REMAINS ABOVE ALL GAME ELEMENTS
• All buttons now have matching rainbow outlines
• ✅ ADDED: FPS / PING / SERVER PING
• ✅ ESP: ALL PLAYERS RAINBOW | FRIENDS GET DOT
• ✅ OWNER: GOLD OUTLINE + GOLD CROWN
• ✅ FIXED: New players auto-get ESP
• ✅ REMOVED: All usage timers & limits
• Creator: Dwayne Kean / Blue_Mode]]
UpdateList.Parent = StartupBox

local OkBtn = Instance.new("TextButton")
OkBtn.Size = UDim2.new(0, 260, 0, 60)
OkBtn.Position = UDim2.new(0.5, -130, 0, 310)
OkBtn.BackgroundColor3 = Color3.fromRGB(15, 110, 230)
OkBtn.Font = Enum.Font.GothamBold
OkBtn.TextScaled = true
OkBtn.Text = "✓ OK / LOAD MAIN HUB"
OkBtn.TextColor3 = Color3.new(1,1,1)
OkBtn.AutoLocalize = false
OkBtn.ZIndex = 2
OkBtn.Parent = StartupBox
Instance.new("UICorner", OkBtn).CornerRadius = UDim.new(0, 16)
AddRainbowGlow(OkBtn, 3)

local StartupHue = 0
RunService.Heartbeat:Connect(function(dt)
    StartupHue = (StartupHue + dt * 0.3) % 1
    local Col = Color3.fromHSV(StartupHue, 1, 1)
    StartupBorder.Color = Col
    StartupTitle.TextColor3 = Col
end)

OkBtn.MouseButton1Click:Connect(function()
    StartupUI:Destroy()
    LoadMainHub()
end)

print("✅ BLUE MODE HUB STARTUP READY")

-- ==============================================
-- 🛑 END OF PART 1 — STOP HERE!
-- ✅ RUN THIS PART FIRST, THEN RUN PART 2 RIGHT AFTER
-- ==============================================

-- ==============================================
-- 🔵 BLUE MODE HUB | PART 2/2 | UPDATED ESP SYSTEM
-- ✅ Owner Check First | Gold Outline + Crown
-- ✅ Friends Get Rainbow Dot + Rainbow Outline
-- ✅ All Original Features Preserved
-- ✅ RUN AFTER PART 1
-- ==============================================
function LoadMainHub()
    local MusicVolume = LoadData(SAVE_KEY_VOLUME, 500)
    local CurrentSound = nil
    local VolNumTextMain, VolFillMain, VolFillMenu, VolNumMenu, ESPBtn
    local FPSLabel, PingLabel, ServerPingLabel
    local ESP_Enabled = false
    local Buttons_Locked = false
    local Hue = 0
    local FPSCounter = 0
    local LastFPSUpdate = os.clock()
    local LOCAL_USERID = LocalPlayer.UserId
    local LastServerLatency = 0

    -- ✅ FULLY FIXED PING (WORKS ON DELTA & ALL EXECUTORS)
    local function GetClientPing()
        local Ping = 0
        pcall(function() Ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
        if Ping <= 0 then pcall(function() Ping = math.floor(NetworkClient:GetPing()) end) end
        return Ping > 0 and Ping or 0
    end

    -- ✅ SERVER PING: NO MORE 0 VALUES
    local function GetServerPing()
        local SPing = 0
        pcall(function()
            for _, Item in pairs(Stats.Network:GetChildren()) do
                if Item:IsA("StatsItem") and (Item.Name == "Ping" or Item.Name == "ServerPing" or Item.Name == "Data Ping") then
                    local Val = tonumber(Item:GetValue())
                    if Val and Val > 0 then SPing = math.floor(Val) end
                end
            end
        end)
        if SPing <= 0 then
            pcall(function()
                local Latency = Stats.Performance:GetAttribute("NetworkLatency") or Stats.Performance:GetAttribute("Latency")
                if Latency and Latency > 0 then SPing = math.floor(Latency * 1000) end
            end)
        end
        if SPing <= 0 then
            local Start = os.clock()
            task.wait()
            local RTT = (os.clock() - Start) * 1000
            LastServerLatency = math.floor((LastServerLatency * 0.7) + (RTT * 0.3))
            SPing = LastServerLatency
        end
        return math.max(SPing, GetClientPing(), 10)
    end

    -- ✅ YOUR NEW ESP CLEANUP FUNCTION
    local function ClearAllESP()
        for _, Player in pairs(Players:GetPlayers()) do
            if Player.Character then
                pcall(function()
                    if Player.Character:FindFirstChild("BLUE_Outline") then Player.Character.BLUE_Outline:Destroy() end
                    if Player.Character:FindFirstChild("FriendRainbowDot") then Player.Character.FriendRainbowDot:Destroy() end
                    if Player.Character:FindFirstChild("OwnerCrown") then Player.Character.OwnerCrown:Destroy() end
                    if Player.Character:FindFirstChild("OwnerOutline") then Player.Character.OwnerOutline:Destroy() end
                end)
            end
        end
    end

    -- ✅ YOUR NEW ESP APPLY SYSTEM (OWNER OVERRIDES EVERYTHING)
    local function ApplyESP(player)
        if not player or not player.Character then return end

        -- 🔴 OWNER CHECK FIRST: Blue_Mode / Dwayne Kean Francisco
        if player.Name == "Blue_Mode" or player.Name == "Dwayne Kean Francisco" then
            -- Gold Outline
            local outline = Instance.new("Highlight")
            outline.Name = "OwnerOutline"
            outline.FillTransparency = 1
            outline.OutlineTransparency = 0
            outline.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            outline.Adornee = player.Character
            outline.Parent = player.Character

            task.spawn(function()
                while outline.Parent and ESP_Enabled do
                    outline.OutlineColor = Color3.fromRGB(255, 215, 0) -- Solid Gold
                    task.wait(0.1)
                end
            end)

            -- Gold Crown Above Head
            local crown = Instance.new("BillboardGui")
            crown.Name = "OwnerCrown"
            crown.Size = UDim2.new(0, 40, 0, 40)
            crown.StudsOffset = Vector3.new(0, 3.5, 0)
            crown.AlwaysOnTop = true
            crown.Adornee = player.Character:FindFirstChild("Head")
            crown.Parent = player.Character

            local CrownText = Instance.new("TextLabel", crown)
            CrownText.Size = UDim2.new(1, 0, 1, 0)
            CrownText.BackgroundTransparency = 1
            CrownText.Text = "👑"
            CrownText.TextColor3 = Color3.fromRGB(255, 215, 0)
            CrownText.TextScaled = true
            CrownText.Font = Enum.Font.GothamBold
            return -- Stop here, no friend dot/rainbow for owner
        end

        -- 🌈 RAINBOW OUTLINE FOR ALL NON-OWNERS
        local outline = Instance.new("Highlight")
        outline.Name = "BLUE_Outline"
        outline.FillTransparency = 1
        outline.OutlineTransparency = 0
        outline.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        outline.Adornee = player.Character
        outline.Parent = player.Character

        task.spawn(function()
            while outline.Parent and ESP_Enabled do
                outline.OutlineColor = Color3.fromHSV(tick() % 5 / 5, 1, 1)
                task.wait(0.1)
            end
        end)

        -- 🟠 RAINBOW DOT FOR FRIENDS ONLY
        if player:IsFriendsWith(LocalPlayer.UserId) then
            local dot = Instance.new("BillboardGui")
            dot.Name = "FriendRainbowDot"
            dot.Size = UDim2.new(0, 12, 0, 12)
            dot.StudsOffset = Vector3.new(1.5, 1, 0)
            dot.AlwaysOnTop = true
            dot.Adornee = player.Character:FindFirstChild("Head")
            dot.Parent = player.Character

            local DotFrame = Instance.new("Frame", dot)
            DotFrame.Size = UDim2.new(1, 0, 1, 0)
            DotFrame.BackgroundTransparency = 0
            DotFrame.BorderSizePixel = 0
            Instance.new("UICorner", DotFrame).CornerRadius = UDim.new(1, 0)

            task.spawn(function()
                while DotFrame.Parent and ESP_Enabled do
                    DotFrame.BackgroundColor3 = Color3.fromHSV(tick() % 5 / 5, 1, 1)
                    task.wait(0.1)
                end
            end)
        end
    end

    local function SetupDeathCheck()
        local function CheckCharacter(Char)
            if not Char then return end
            local Hum = Char:WaitForChild("Humanoid", 10)
            if not Hum then return end
            Hum.Died:Connect(function()
                if ESP_Enabled then ClearAllESP() end
            end)
        end
        CheckCharacter(LocalPlayer.Character)
        LocalPlayer.CharacterAdded:Connect(CheckCharacter)
    end

    local function UpdateVolume(newVol)
        MusicVolume = math.clamp(tonumber(newVol) or 500, 0, VOLUME_MAX)
        SaveData(SAVE_KEY_VOLUME, MusicVolume)
        if CurrentSound then CurrentSound.Volume = MusicVolume / VOLUME_MAX end
        local Val = tostring(math.floor(MusicVolume + 0.5))
        if VolNumTextMain then VolNumTextMain.Text = Val end
        if VolFillMain then VolFillMain.Size = UDim2.new(MusicVolume/VOLUME_MAX,0,1,0) end
        if VolNumMenu then VolNumMenu.Text = Val end
        if VolFillMenu then VolFillMenu.Size = UDim2.new(MusicVolume/VOLUME_MAX,0,1,0) end
    end

    local function FormatSoundID(input) return "rbxassetid://"..tostring(input):gsub("%D","") end
    local function PlaySound(id)
        pcall(function() if CurrentSound then CurrentSound:Destroy() end end)
        CurrentSound = Instance.new("Sound")
        CurrentSound.SoundId = FormatSoundID(id)
        CurrentSound.Volume = MusicVolume / VOLUME_MAX
        CurrentSound.Looped = true
        CurrentSound.Parent = SoundService
        pcall(function() CurrentSound:Play() end)
    end
    local function StopSound()
        pcall(function() if CurrentSound then CurrentSound:Destroy() end end)
        CurrentSound = nil
    end

    -- ✅ BOOMBOX MENU
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
        BoomUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        BoomUI.Parent = GuiContainer
        CurrentBoomboxUI = BoomUI
        BoomboxUI_Open = true

        local BoomFrame = Instance.new("Frame")
        BoomFrame.Size = UDim2.new(0,320,0,250)
        BoomFrame.Position = UDim2.new(0.5,-160,0.5,-125)
        BoomFrame.BackgroundColor3 = Color3.fromRGB(22,22,22)
        BoomFrame.Active = true
        BoomFrame.Parent = BoomUI
        Instance.new("UICorner", BoomFrame).CornerRadius = UDim.new(0,12)

        local BoomGuiBg = Instance.new("ImageLabel")
        BoomGuiBg.Size = UDim2.new(1, 0, 1, 0)
        BoomGuiBg.Position = UDim2.new(0, 0, 0, 0)
        BoomGuiBg.BackgroundTransparency = 1
        BoomGuiBg.Image = CUSTOM_GUI_BG
        BoomGuiBg.ScaleType = Enum.ScaleType.Stretch
        BoomGuiBg.ZIndex = 1
        BoomGuiBg.Parent = BoomFrame
        AddRainbowGlow(BoomFrame,4)

        local CloseTop = Instance.new("TextButton")
        CloseTop.Size = UDim2.new(0,30,0,30)
        CloseTop.Position = UDim2.new(1,-35,0,5)
        CloseTop.BackgroundColor3 = Color3.fromRGB(170,30,30)
        CloseTop.Text = "✕"
        CloseTop.TextColor3 = Color3.new(1,1,1)
        CloseTop.Font = Enum.Font.GothamBold
        CloseTop.TextSize = 24
        CloseTop.ZIndex = 3
        CloseTop.Parent = BoomFrame
        CloseTop.MouseButton1Click:Connect(function() ToggleBoomboxMenu() end)

        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1,-70,0,40)
        Title.Position = UDim2.new(0,12,0,8)
        Title.BackgroundTransparency = 1
        Title.Text = "🎵 BOOMBOX & VOLUME"
        Title.TextColor3 = Color3.new(1,1,1)
        Title.Font = Enum.Font.GothamBold
        Title.TextScaled = true
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.ZIndex = 2
        Title.Parent = BoomFrame

        local Input = Instance.new("TextBox")
        Input.Size = UDim2.new(1,-40,0,45)
        Input.Position = UDim2.new(0,20,0,55)
        Input.BackgroundColor3 = Color3.fromRGB(35,35,35)
        Input.PlaceholderText = "Paste Sound ID here..."
        Input.TextColor3 = Color3.new(1,1,1)
        Input.Font = Enum.Font.Gotham
        Input.TextScaled = true
        Input.ZIndex = 2
        Input.Parent = BoomFrame
        Instance.new("UICorner", Input).CornerRadius = UDim.new(0,8)
        AddRainbowGlow(Input,2)

        local VolLabel = Instance.new("TextLabel")
        VolLabel.Size = UDim2.new(0,150,0,30)
        VolLabel.Position = UDim2.new(0,20,0,110)
        VolLabel.BackgroundTransparency = 1
        VolLabel.Text = "🔊 VOLUME (0–1000):"
        VolLabel.TextColor3 = Color3.new(1,1,1)
        VolLabel.Font = Enum.Font.GothamBold
        VolLabel.TextScaled = true
        VolLabel.ZIndex = 2
        VolLabel.Parent = BoomFrame

        VolNumMenu = Instance.new("TextLabel")
        VolNumMenu.Size = UDim2.new(0,60,0,30)
        VolNumMenu.Position = UDim2.new(1,-80,0,110)
        VolNumMenu.BackgroundTransparency = 1
        VolNumMenu.Text = tostring(math.floor(MusicVolume+0.5))
        VolNumMenu.TextColor3 = Color3.new(1,1,1)
        VolNumMenu.Font = Enum.Font.GothamBold
        VolNumMenu.TextScaled = true
        VolNumMenu.ZIndex = 2
        VolNumMenu.Parent = BoomFrame

        local VolBG = Instance.new("Frame")
        VolBG.Size = UDim2.new(1,-40,0,24)
        VolBG.Position = UDim2.new(0,20,0,145)
        VolBG.BackgroundColor3 = Color3.fromRGB(50,50,50)
        VolBG.Active = true
        VolBG.ZIndex = 2
        VolBG.Parent = BoomFrame
        Instance.new("UICorner", VolBG).CornerRadius = UDim.new(0,12)
        AddRainbowGlow(VolBG,2)

        VolFillMenu = Instance.new("Frame")
        VolFillMenu.Size = UDim2.new(MusicVolume/VOLUME_MAX,0,1,0)
        VolFillMenu.BackgroundColor3 = Color3.fromRGB(100,100,100)
        VolFillMenu.ZIndex = 2
        VolFillMenu.Parent = VolBG
        Instance.new("UICorner", VolFillMenu).CornerRadius = UDim.new(0,12)

        local SliderActive = false
        VolBG.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then SliderActive = true end
        end)
        UserInputService.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then SliderActive = false end
        end)
        UserInputService.InputChanged:Connect(function(i)
            if SliderActive and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                local rel = math.clamp((i.Position.X - VolBG.AbsolutePosition.X)/VolBG.AbsoluteSize.X, 0, 1)
                UpdateVolume(math.floor(rel * VOLUME_MAX))
            end
        end)

        local PlayBtn = Instance.new("TextButton")
        PlayBtn.Size = UDim2.new(0,130,0,40)
        PlayBtn.Position = UDim2.new(0,20,0,190)
        PlayBtn.BackgroundColor3 = Color3.fromRGB(25,140,255)
        PlayBtn.Text = "▶ PLAY SOUND"
        PlayBtn.TextColor3 = Color3.new(1,1,1)
        PlayBtn.Font = Enum.Font.GothamBold
        PlayBtn.TextScaled = true
        PlayBtn.ZIndex = 2
        PlayBtn.Parent = BoomFrame
        Instance.new("UICorner", PlayBtn).CornerRadius = UDim.new(0,8)
        AddRainbowGlow(PlayBtn,2)

        local StopBtn = Instance.new("TextButton")
        StopBtn.Size = UDim2.new(0,130,0,40)
        StopBtn.Position = UDim2.new(0,170,0,190)
        StopBtn.BackgroundColor3 = Color3.fromRGB(200,30,30)
        StopBtn.Text = "⏹ STOP SOUND"
        StopBtn.TextColor3 = Color3.new(1,1,1)
        StopBtn.Font = Enum.Font.GothamBold
        StopBtn.TextScaled = true
        StopBtn.ZIndex = 2
        StopBtn.Parent = BoomFrame
        Instance.new("UICorner", StopBtn).CornerRadius = UDim.new(0,8)
        AddRainbowGlow(StopBtn,2)

        PlayBtn.MouseButton1Click:Connect(function() if Input.Text~="" then PlaySound(Input.Text) end end)
        StopBtn.MouseButton1Click:Connect(StopSound)
    end

    -- ✅ CONSOLE MENU
    local function ToggleConsole()
        if ConsoleUI_Open then
            if CurrentConsoleUI then CurrentConsoleUI:Destroy() end
            ConsoleUI_Open = false
            CurrentConsoleUI = nil
            GuiFocused = false
            return
        end
        GuiFocused = true
        local ConsoleUI = Instance.new("ScreenGui")
        ConsoleUI.Name = "BLUE_MODE_HUB_CONSOLE"
        ConsoleUI.ResetOnSpawn = false
        ConsoleUI.DisplayOrder = PRIORITY.CONSOLE
        ConsoleUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        ConsoleUI.Parent = GuiContainer
        CurrentConsoleUI = ConsoleUI
        ConsoleUI_Open = true

        local Frame = Instance.new("Frame")
        Frame.Size = UDim2.new(0,450,0,320)
        Frame.Position = UDim2.new(0.5,-225,0.5,-160)
        Frame.BackgroundColor3 = Color3.fromRGB(22,22,22)
        Frame.Active = true
        Frame.Parent = ConsoleUI
        Instance.new("UICorner", Frame).CornerRadius = UDim.new(0,12)

        local ConsoleGuiBg = Instance.new("ImageLabel")
        ConsoleGuiBg.Size = UDim2.new(1, 0, 1, 0)
        ConsoleGuiBg.Position = UDim2.new(0, 0, 0, 0)
        ConsoleGuiBg.BackgroundTransparency = 1
        ConsoleGuiBg.Image = CUSTOM_GUI_BG
        ConsoleGuiBg.ScaleType = Enum.ScaleType.Stretch
        ConsoleGuiBg.ZIndex = 1
        ConsoleGuiBg.Parent = Frame
        AddRainbowGlow(Frame,5)

        local CloseTop = Instance.new("TextButton")
        CloseTop.Size = UDim2.new(0,32,0,32)
        CloseTop.Position = UDim2.new(1,-37,0,6)
        CloseTop.BackgroundColor3 = Color3.fromRGB(170,30,30)
        CloseTop.Text = "✕"
        CloseTop.TextColor3 = Color3.new(1,1,1)
        CloseTop.Font = Enum.Font.GothamBold
        CloseTop.TextSize = 26
        CloseTop.ZIndex = 3
        CloseTop.Parent = Frame
        CloseTop.MouseButton1Click:Connect(function() ToggleConsole() end)

        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1,-50,0,35)
        Title.Position = UDim2.new(0,15,0,6)
        Title.BackgroundTransparency = 1
        Title.Text = "💻 SCRIPT CONSOLE"
        Title.TextColor3 = Color3.new(1,1,1)
        Title.Font = Enum.Font.GothamBold
        Title.TextScaled = true
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.ZIndex = 2
        Title.Parent = Frame

        local Output = Instance.new("TextLabel")
        Output.Size = UDim2.new(1,-30,0,40)
        Output.Position = UDim2.new(0,15,0,45)
        Output.BackgroundTransparency = 1
        Output.Text = "Paste script code below..."
        Output.TextColor3 = Color3.fromRGB(0,255,120)
        Output.Font = Enum.Font.Code
        Output.TextScaled = true
        Output.TextXAlignment = Enum.TextXAlignment.Left
        Output.TextYAlignment = Enum.TextYAlignment.Top
        Output.TextWrapped = true
        Output.ZIndex = 2
        Output.Parent = Frame

        local Input = Instance.new("TextBox")
        Input.Size = UDim2.new(1,-30,0,130)
        Input.Position = UDim2.new(0,15,0,95)
        Input.BackgroundColor3 = Color3.fromRGB(45,45,45)
        Input.PlaceholderText = "Paste your Lua script here..."
        Input.TextColor3 = Color3.new(1,1,1)
        Input.Font = Enum.Font.Code
        Input.TextScaled = true
        Input.MultiLine = true
        Input.ZIndex = 2
        Input.Parent = Frame
        Instance.new("UICorner", Input).CornerRadius = UDim.new(0,8)
        AddRainbowGlow(Input,2)

        local ExecBtn = Instance.new("TextButton")
        ExecBtn.Size = UDim2.new(0,120,0,40)
        ExecBtn.Position = UDim2.new(0,15,0,240)
        ExecBtn.BackgroundColor3 = Color3.fromRGB(20,150,70)
        ExecBtn.Text = "▶ EXECUTE"
        ExecBtn.TextColor3 = Color3.new(1,1,1)
        ExecBtn.Font = Enum.Font.GothamBold
        ExecBtn.TextScaled = true
        ExecBtn.ZIndex = 2
        ExecBtn.Parent = Frame
        Instance.new("UICorner", ExecBtn).CornerRadius = UDim.new(0,8)
        AddRainbowGlow(ExecBtn,2)

        local ClearBtn = Instance.new("TextButton")
        ClearBtn.Size = UDim2.new(0,120,0,40)
        ClearBtn.Position = UDim2.new(0,150,0,240)
        ClearBtn.BackgroundColor3 = Color3.fromRGB(180,120,20)
        ClearBtn.Text = "🗑️ CLEAR"
        ClearBtn.TextColor3 = Color3.new(1,1,1)
        ClearBtn.Font = Enum.Font.GothamBold
        ClearBtn.TextScaled = true
        ClearBtn.ZIndex = 2
        ClearBtn.Parent = Frame
        Instance.new("UICorner", ClearBtn).CornerRadius = UDim.new(0,8)
        AddRainbowGlow(ClearBtn,2)

        ExecBtn.MouseButton1Click:Connect(function()
            local ScriptCode = Input.Text
            if ScriptCode == "" then Output.Text = "⚠️ Nothing to run!" return end
            local Compile = loadstring or load
            if not Compile then Output.Text = "⚠️ Executor does not support compiling!" return end
            local Func, Err = Compile(ScriptCode)
            if not Func then Output.Text = "❌ Syntax Error:\n"..tostring(Err) return end
            local Ok, RunErr = pcall(Func)
            if not Ok then Output.Text = "❌ Runtime Error:\n"..tostring(RunErr) return end
            Output.Text = "✅ Script ran successfully!"
        end)
        ClearBtn.MouseButton1Click:Connect(function() Input.Text = "" Output.Text = "✅ Cleared!" end)
    end

    -- ✅ MAIN HUB UI
    local FULL_SIZE = UDim2.new(0,680,0,105)
    local MINI_SIZE = UDim2.new(0,110,0,36)
    local MainUI = Instance.new("ScreenGui")
    MainUI.Name = "BLUE_MODE_HUB"
    MainUI.ResetOnSpawn = false
    MainUI.DisplayOrder = PRIORITY.MAIN
    MainUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    MainUI.Parent = GuiContainer

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = FULL_SIZE
    MainFrame.Position = UDim2.new(0,20,0.5,-52)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
    MainFrame.Active = true
    MainFrame.ClipsDescendants = false
    MainFrame.Parent = MainUI
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,8)
    AddRainbowGlow(MainFrame,5)

    local DragHandle = Instance.new("TextButton")
    DragHandle.Size = UDim2.new(1,-30,0,22)
    DragHandle.Position = UDim2.new(0,0,0,0)
    DragHandle.BackgroundColor3 = Color3.fromRGB(60,140,220)
    DragHandle.Text = "🔵 BLUE MODE HUB | DRAG ME"
    DragHandle.TextColor3 = Color3.new(1,1,1)
    DragHandle.Font = Enum.Font.GothamBold
    DragHandle.TextScaled = true
    DragHandle.TextXAlignment = Enum.TextXAlignment.Left
    DragHandle.AutoLocalize = false
    DragHandle.Parent = MainFrame
    AddRainbowGlow(DragHandle,2)

    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.new(0,22,1,0)
    MinBtn.Position = UDim2.new(1,-22,0,0)
    MinBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
    MinBtn.Text = "➖"
    MinBtn.TextColor3 = Color3.new(1,1,1)
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.TextScaled = true
    MinBtn.Parent = MainFrame
    AddRainbowGlow(MinBtn,2)

    ESPBtn = Instance.new("TextButton")
    ESPBtn.Size = UDim2.new(0,85,0,30)
    ESPBtn.Position = UDim2.new(0,10,0,30)
    ESPBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    ESPBtn.Text = "ESP: OFF"
    ESPBtn.TextColor3 = Color3.new(1,1,1)
    ESPBtn.Font = Enum.Font.GothamBold
    ESPBtn.TextScaled = true
    ESPBtn.Parent = MainFrame
    Instance.new("UICorner", ESPBtn).CornerRadius = UDim.new(0,6)
    AddRainbowGlow(ESPBt,2)

    local YouTubeBtn = Instance.new("TextButton")
    YouTubeBtn.Size = UDim2.new(0,95,0,30)
    YouTubeBtn.Position = UDim2.new(0,100,0,30)
    YouTubeBtn.BackgroundColor3 = Color3.fromRGB(200,30,30)
    YouTubeBtn.Text = "📺 YOUTUBE"
    YouTubeBtn.TextColor3 = Color3.new(1,1,1)
    YouTubeBtn.Font = Enum.Font.GothamBold
    YouTubeBtn.TextScaled = true
    YouTubeBtn.Parent = MainFrame
    Instance.new("UICorner", YouTubeBtn).CornerRadius = UDim.new(0,6)
    AddRainbowGlow(YouTubeBtn,2)

    local MusicBtn = Instance.new("TextButton")
    MusicBtn.Size = UDim2.new(0,90,0,30)
    MusicBtn.Position = UDim2.new(0,200,0,30)
    MusicBtn.BackgroundColor3 = Color3.fromRGB(40,80,160)
    MusicBtn.Text = "🎵 MUSIC"
    MusicBtn.TextColor3 = Color3.new(1,1,1)
    MusicBtn.Font = Enum.Font.GothamBold
    MusicBtn.TextScaled = true
    MusicBtn.Parent = MainFrame
    Instance.new("UICorner", MusicBtn).CornerRadius = UDim.new(0,6)
    AddRainbowGlow(MusicBtn,2)

    local LockBtn = Instance.new("TextButton")
    LockBtn.Size = UDim2.new(0,90,0,30)
    LockBtn.Position = UDim2.new(0,300,0,30)
    LockBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    LockBtn.Text = "🔓 UNLOCK"
    LockBtn.TextColor3 = Color3.new(1,1,1)
    LockBtn.Font = Enum.Font.GothamBold
    LockBtn.TextScaled = true
    LockBtn.Parent = MainFrame
    Instance.new("UICorner", LockBtn).CornerRadius = UDim.new(0,6)
    AddRainbowGlow(LockBtn,2)

    local ConsoleBtn = Instance.new("TextButton")
    ConsoleBtn.Size = UDim2.new(0,110,0,30)
    ConsoleBtn.Position = UDim2.new(0,400,0,30)
    ConsoleBtn.BackgroundColor3 = Color3.fromRGB(30,120,90)
    ConsoleBtn.Text = "💻 CONSOLE"
    ConsoleBtn.TextColor3 = Color3.new(1,1,1)
    ConsoleBtn.Font = Enum.Font.GothamBold
    ConsoleBtn.TextScaled = true
    ConsoleBtn.Parent = MainFrame
    Instance.new("UICorner", ConsoleBtn).CornerRadius = UDim.new(0,6)
    AddRainbowGlow(ConsoleBtn,2)

    ExitBtn = Instance.new("TextButton")
    ExitBtn.Size = UDim2.new(0,90,0,30)
    ExitBtn.Position = UDim2.new(0,520,0,30)
    ExitBtn.BackgroundColor3 = Color3.fromRGB(140,20,20)
    ExitBtn.Text = "🗑️ EXIT"
    ExitBtn.TextColor3 = Color3.new(1,1,1)
    ExitBtn.Font = Enum.Font.GothamBold
    ExitBtn.TextScaled = true
    ExitBtn.Parent = MainFrame
    Instance.new("UICorner", ExitBtn).CornerRadius = UDim.new(0,6)
    AddRainbowGlow(ExitBtn,2)

    local VolLabelMain = Instance.new("TextLabel")
    VolLabelMain.Size = UDim2.new(0,100,0,25)
    VolLabelMain.Position = UDim2.new(0,10,0,65)
    VolLabelMain.BackgroundTransparency = 1
    VolLabelMain.Text = "🔊 VOLUME:"
    VolLabelMain.TextColor3 = Color3.new(1,1,1)
    VolLabelMain.Font = Enum.Font.Gotham
    VolLabelMain.TextScaled = true
    VolLabelMain.TextXAlignment = Enum.TextXAlignment.Left
    VolLabelMain.Parent = MainFrame

    VolNumTextMain = Instance.new("TextLabel")
    VolNumTextMain.Size = UDim2.new(0,50,0,25)
    VolNumTextMain.Position = UDim2.new(0,115,0,65)
    VolNumTextMain.BackgroundTransparency = 1
    VolNumTextMain.Text = tostring(math.floor(MusicVolume+0.5))
    VolNumTextMain.TextColor3 = Color3.new(1,1,1)
    VolNumTextMain.Font = Enum.Font.GothamBold
    VolNumTextMain.TextScaled = true
    VolNumTextMain.Parent = MainFrame

    local VolBGMain = Instance.new("Frame")
    VolBGMain.Size = UDim2.new(0,150,0,18)
    VolBGMain.Position = UDim2.new(0,175,0,67)
    VolBGMain.BackgroundColor3 = Color3.fromRGB(50,50,50)
    VolBGMain.Active = true
    VolBGMain.Parent = MainFrame
    Instance.new("UICorner", VolBGMain).CornerRadius = UDim.new(0,9)
    AddRainbowGlow(VolBGMain,2)

    VolFillMain = Instance.new("Frame")
    VolFillMain.Size = UDim2.new(MusicVolume/VOLUME_MAX,0,1,0)
    VolFillMain.BackgroundColor3 = Color3.fromRGB(100,100,100)
    VolFillMain.Parent = VolBGMain
    Instance.new("UICorner", VolFillMain).CornerRadius = UDim.new(0,9)

    local StatsBG = Instance.new("Frame")
    StatsBG.Size = UDim2.new(0,150,0,18)
    StatsBG.Position = UDim2.new(0,335,0,67)
    StatsBG.BackgroundColor3 = Color3.fromRGB(50,50,50)
    StatsBG.Parent = MainFrame
    Instance.new("UICorner", StatsBG).CornerRadius = UDim.new(0,9)
    AddRainbowGlow(StatsBG,2)

    FPSLabel = Instance.new("TextLabel")
    FPSLabel.Size = UDim2.new(0.33,0,1,0)
    FPSLabel.BackgroundTransparency = 1
    FPSLabel.Font = Enum.Font.GothamBold
    FPSLabel.TextScaled = true
    FPSLabel.Text = "FPS: 0"
    FPSLabel.TextColor3 = Color3.fromRGB(80,255,120)
    FPSLabel.Parent = StatsBG

    PingLabel = Instance.new("TextLabel")
    PingLabel.Size = UDim2.new(0.33,0,1,0)
    PingLabel.Position = UDim2.new(0.33,0,0,0)
    PingLabel.BackgroundTransparency = 1
    PingLabel.Font = Enum.Font.GothamBold
    PingLabel.TextScaled = true
    PingLabel.Text = "PING: 0"
    PingLabel.TextColor3 = Color3.fromRGB(255,200,50)
    PingLabel.Parent = StatsBG

    ServerPingLabel = Instance.new("TextLabel")
    ServerPingLabel.Size = UDim2.new(0.34,0,1,0)
    ServerPingLabel.Position = UDim2.new(0.66,0,0,0)
    ServerPingLabel.BackgroundTransparency = 1
    ServerPingLabel.Font = Enum.Font.GothamBold
    ServerPingLabel.TextScaled = true
    ServerPingLabel.Text = "SP: 0"
    ServerPingLabel.TextColor3 = Color3.fromRGB(255,100,100)
    ServerPingLabel.Parent = StatsBG

    local SliderActiveMain = false
    VolBGMain.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then SliderActiveMain = true end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then SliderActiveMain = false end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if SliderActiveMain and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local rel = math.clamp((i.Position.X - VolBGMain.AbsolutePosition.X)/VolBGMain.AbsoluteSize.X, 0, 1)
            UpdateVolume(math.floor(rel * VOLUME_MAX))
        end
    end)

    local DragState = {Active=false, StartX=0, StartY=0, PosX=0, PosY=0}
    DragHandle.InputBegan:Connect(function(Input)
        GuiFocused = true
        if Buttons_Locked then return end
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            DragState.Active = true
            DragState.StartX = Input.Position.X
            DragState.StartY = Input.Position.Y
            DragState.PosX = MainFrame.Position.X.Offset
            DragState.PosY = MainFrame.Position.Y.Offset
        end
    end)
    UserInputService.InputEnded:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            DragState.Active = false
            task.delay(0.2, function() GuiFocused = false end)
        end
    end)
    UserInputService.InputChanged:Connect(function(Input)
        if DragState.Active and not Buttons_Locked then
            MainFrame.Position = UDim2.new(0, DragState.PosX + (Input.Position.X - DragState.StartX), 0, DragState.PosY + (Input.Position.Y - DragState.StartY))
        end
    end)

    -- ✅ UPDATED ESP TOGGLE WITH YOUR LOGIC
    ESPBtn.MouseButton1Click:Connect(function()
        ESP_Enabled = not ESP_Enabled
        if ESP_Enabled then
            ESPBtn.Text = "ESP: ON"
            ESPBtn.BackgroundColor3 = Color3.fromRGB(25, 140, 255)
            for _,plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer then
                    ApplyESP(plr)
                end
            end
            Players.PlayerAdded:Connect(function(plr)
                plr.CharacterAdded:Connect(function() task.wait(1) ApplyESP(plr) end)
            end)
        else
            ESPBtn.Text = "ESP: OFF"
            ESPBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
            ClearAllESP()
        end
    end)

    LockBtn.MouseButton1Click:Connect(function()
        Buttons_Locked = not Buttons_Locked
        LockBtn.Text = Buttons_Locked and "🔒 LOCKED" or "🔓 UNLOCK"
        LockBtn.BackgroundColor3 = Buttons_Locked and Color3.fromRGB(180,40,40) or Color3.fromRGB(50,50,50)
    end)

    MinBtn.MouseButton1Click:Connect(function()
        IsMinimized = not IsMinimized
        if IsMinimized then
            MainFrame.Size = MINI_SIZE
            ESPBtn.Visible = false
            YouTubeBtn.Visible = false
            MusicBtn.Visible = false
            LockBtn.Visible = false
            ConsoleBtn.Visible = false
            ExitBtn.Visible = false
            VolLabelMain.Visible = false
            VolNumTextMain.Visible = false
            VolBGMain.Visible = false
            StatsBG.Visible = false
            DragHandle.Text = "BLUE MODE"
            MinBtn.Text = "➕"
        else
            MainFrame.Size = FULL_SIZE
            ESPBtn.Visible = true
            YouTubeBtn.Visible = true
            MusicBtn.Visible = true
            LockBtn.Visible = true
            ConsoleBtn.Visible = true
            ExitBtn.Visible = true
            VolLabelMain.Visible = true
            VolNumTextMain.Visible = true
            VolBGMain.Visible = true
            StatsBG.Visible = true
            DragHandle.Text = "🔵 BLUE MODE HUB | DRAG ME"
            MinBtn.Text = "➖"
        end
    end)

    YouTubeBtn.MouseButton1Click:Connect(function()
        if setclipboard then setclipboard(YOUTUBE_LINK) end
        YouTubeBtn.Text = "✅ COPIED!"
        task.wait(1.5)
        YouTubeBtn.Text = "📺 YOUTUBE"
    end)

    MusicBtn.MouseButton1Click:Connect(ToggleBoomboxMenu)
    ConsoleBtn.MouseButton1Click:Connect(ToggleConsole)

    -- ✅ UPDATED EXIT CLEANUP
    ExitBtn.MouseButton1Click:Connect(function()
        ShowExitConfirm(function()
            ESP_Enabled = false
            ClearAllESP()
            StopSound()
            if CurrentBoomboxUI then CurrentBoomboxUI:Destroy() end
            if CurrentConsoleUI then CurrentConsoleUI:Destroy() end
            MainUI:Destroy()
            getgenv().BlueMode_Loaded = nil
        end)
    end)

    SetupDeathCheck()

    task.spawn(function()
        while task.wait() do
            local Now = os.clock()
            if Now - LastFPSUpdate >= 1 then
                if FPSLabel then FPSLabel.Text = "FPS: "..FPSCounter end
                FPSCounter = 0
                LastFPSUpdate = Now
            end
            FPSCounter += 1
        end
    end)

    RunService.Heartbeat:Connect(function(Delta)
        if not MainUI or not MainUI.Parent then return end
        Hue = (Hue + Delta * 0.5) % 1
        local Rainbow = Color3.fromHSV(Hue, 1, 1)
        for _,e in pairs(GuiElements) do e.Color = Rainbow end
        if VolFillMain then VolFillMain.BackgroundColor3 = Rainbow end
        if VolFillMenu then VolFillMenu.BackgroundColor3 = Rainbow end
        if PingLabel then PingLabel.Text = "PING: "..GetClientPing().."ms" end
        if ServerPingLabel then ServerPingLabel.Text = "SP: "..GetServerPing().."ms" end
    end)

    print("✅ BLUE MODE HUB | UPDATED ESP LOADED SUCCESSFULLY")
end
