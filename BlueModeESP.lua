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
-- 🔵 BLUE MODE HUB | FULL PART 2/2 | OWNER PRIORITY FIXED
-- ✅ Owner ESP ALWAYS ON TOP | Visible Fill | All Features
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
    local IsMinimized = false

    -- ✅ FIXED PING DETECTION
    local function GetClientPing()
        local Ping = 0
        pcall(function() Ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
        if Ping <= 0 then pcall(function() Ping = math.floor(NetworkClient:GetPing()) end) end
        return Ping > 0 and Ping or 0
    end

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

    -- ✅ COMPLETE ESP CLEANUP
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

    -- ✅ FINAL ESP: OWNER ALWAYS PRIORITY & ON TOP
    local function ApplyESP(player)
        if not player or not player.Character then return end

        -- 🔴 OWNER CHECK FIRST: RUNS BEFORE ALL OTHER ESP
        if player.Name == "Blue_Mode" or player.Name == "Dwayne Kean Francisco" then
            -- Remove any other ESP that might overlap on owner
            pcall(function()
                if player.Character:FindFirstChild("BLUE_Outline") then player.Character.BLUE_Outline:Destroy() end
                if player.Character:FindFirstChild("FriendRainbowDot") then player.Character.FriendRainbowDot:Destroy() end
            end)

            -- Gold Outline: HIGHEST DEPTH so it draws above everything
            local outline = Instance.new("Highlight")
            outline.Name = "OwnerOutline"
            outline.FillTransparency = 0.6 -- Visible gold fill
            outline.OutlineTransparency = 0
            outline.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- ✅ FORCE ON TOP
            outline.Adornee = player.Character
            outline.ZIndex = 100 -- ✅ HIGHEST LAYER PRIORITY
            outline.Parent = player.Character

            task.spawn(function()
                while outline.Parent and ESP_Enabled do
                    outline.FillColor = Color3.fromRGB(255, 215, 0) -- Gold Fill
                    outline.OutlineColor = Color3.fromRGB(255, 215, 0) -- Gold Outline
                    task.wait(0.1)
                end
            end)

            -- Gold Crown: ALWAYS ON TOP
            local crown = Instance.new("BillboardGui")
            crown.Name = "OwnerCrown"
            crown.Size = UDim2.new(0, 50, 0, 50) -- Slightly bigger for visibility
            crown.StudsOffset = Vector3.new(0, 4, 0) -- Higher above head
            crown.AlwaysOnTop = true
            crown.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            crown.DisplayOrder = 999 -- ✅ CROWN DRAWS LAST
            crown.Adornee = player.Character:FindFirstChild("Head")
            crown.Parent = player.Character

            local CrownText = Instance.new("TextLabel", crown)
            CrownText.Size = UDim2.new(1, 0, 1, 0)
            CrownText.BackgroundTransparency = 1
            CrownText.Text = "👑 OWNER"
            CrownText.TextColor3 = Color3.fromRGB(255, 215, 0)
            CrownText.TextScaled = true
            CrownText.Font = Enum.Font.GothamBold
            CrownText.TextStrokeTransparency = 0 -- ✅ Black outline so it stands out
            CrownText.TextStrokeColor3 = Color3.new(0,0,0)
            return -- STOP: No friend dot/rainbow ever added to owner
        end

        -- 🌈 FRIENDS & OTHERS: LOWER PRIORITY
        local outline = Instance.new("Highlight")
        outline.Name = "BLUE_Outline"
        outline.FillTransparency = 0.6 -- Visible rainbow fill
        outline.OutlineTransparency = 0
        outline.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        outline.Adornee = player.Character
        outline.ZIndex = 50 -- ✅ LOWER THAN OWNER
        outline.Parent = player.Character

        task.spawn(function()
            while outline.Parent and ESP_Enabled do
                local RainbowColor = Color3.fromHSV(tick() % 5 / 5, 1, 1)
                outline.FillColor = RainbowColor
                outline.OutlineColor = RainbowColor
                task.wait(0.1)
            end
        end)

        -- 🟠 FRIENDS ONLY: Rainbow Dot
        if player:IsFriendsWith(LocalPlayer.UserId) then
            local dot = Instance.new("BillboardGui")
            dot.Name = "FriendRainbowDot"
            dot.Size = UDim2.new(0, 12, 0, 12)
            dot.StudsOffset = Vector3.new(1.8, 1.2, 0)
            dot.AlwaysOnTop = true
            dot.DisplayOrder = 50 -- ✅ LOWER THAN OWNER CROWN
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
        LocalPlayer.CharacterAdded:Connect(function(Char)
            Char:WaitForChild("Humanoid").Died:Connect(function()
                if ESP_Enabled then ClearAllESP() end
            end)
        end)
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
    local BoomboxUI_Open, CurrentBoomboxUI = false, nil
    local function ToggleBoomboxMenu()
        if BoomboxUI_Open then
            if CurrentBoomboxUI then CurrentBoomboxUI:Destroy() end
            BoomboxUI_Open = false
            CurrentBoomboxUI = nil
            return
        end
        GuiFocused = true
        BoomboxUI_Open = true

        local BoomUI = Instance.new("ScreenGui")
        BoomUI.Name = "BLUE_MODE_BOOMBOX"
        BoomUI.ResetOnSpawn = false
        BoomUI.DisplayOrder = PRIORITY.BOOMBOX
        BoomUI.Parent = GuiContainer
        CurrentBoomboxUI = BoomUI

        local Frame = Instance.new("Frame")
        Frame.Size = UDim2.new(0,320,0,250)
        Frame.Position = UDim2.new(0.5,-160,0.5,-125)
        Frame.BackgroundColor3 = Color3.fromRGB(22,22,22)
        Frame.Active = true
        Frame.Draggable = true
        Frame.Parent = BoomUI
        Instance.new("UICorner", Frame).CornerRadius = UDim.new(0,12)
        AddRainbowGlow(Frame,4)

        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1,-20,0,40)
        Title.Position = UDim2.new(0,10,0,8)
        Title.BackgroundTransparency = 1
        Title.Font = Enum.Font.GothamBold
        Title.TextScaled = true
        Title.Text = "🎵 BOOMBOX"
        Title.TextColor3 = Color3.new(1,1,1)
        Title.Parent = Frame

        local Input = Instance.new("TextBox")
        Input.Size = UDim2.new(1,-40,0,45)
        Input.Position = UDim2.new(0,20,0,55)
        Input.BackgroundColor3 = Color3.fromRGB(35,35,35)
        Input.PlaceholderText = "Paste Sound ID / Asset ID"
        Input.Text = ""
        Input.TextColor3 = Color3.new(1,1,1)
        Input.Parent = Frame
        Instance.new("UICorner", Input).CornerRadius = UDim.new(0,8)

        local VolLabel = Instance.new("TextLabel")
        VolLabel.Size = UDim2.new(0,100,0,25)
        VolLabel.Position = UDim2.new(0,20,0,110)
        VolLabel.BackgroundTransparency = 1
        VolLabel.Text = "VOLUME:"
        VolLabel.TextColor3 = Color3.new(1,1,1)
        VolLabel.Parent = Frame

        VolNumMenu = Instance.new("TextLabel")
        VolNumMenu.Size = UDim2.new(0,50,0,25)
        VolNumMenu.Position = UDim2.new(1,-70,0,110)
        VolNumMenu.BackgroundTransparency = 1
        VolNumMenu.Text = tostring(MusicVolume)
        VolNumMenu.TextColor3 = Color3.new(1,1,1)
        VolNumMenu.Parent = Frame

        local VolBG = Instance.new("Frame")
        VolBG.Size = UDim2.new(1,-40,0,24)
        VolBG.Position = UDim2.new(0,20,0,145)
        VolBG.BackgroundColor3 = Color3.fromRGB(50,50,50)
        VolBG.Parent = Frame
        Instance.new("UICorner", VolBG).CornerRadius = UDim.new(0,12)

        VolFillMenu = Instance.new("Frame")
        VolFillMenu.Size = UDim2.new(MusicVolume/VOLUME_MAX,0,1,0)
        VolFillMenu.BackgroundColor3 = Color3.fromRGB(100,100,255)
        VolFillMenu.Parent = VolBG
        Instance.new("UICorner", VolFillMenu).CornerRadius = UDim.new(0,12)

        local PlayBtn = Instance.new("TextButton")
        PlayBtn.Size = UDim2.new(0,130,0,40)
        PlayBtn.Position = UDim2.new(0,20,0,185)
        PlayBtn.BackgroundColor3 = Color3.fromRGB(25,140,255)
        PlayBtn.Text = "▶ PLAY"
        PlayBtn.TextColor3 = Color3.new(1,1,1)
        PlayBtn.Parent = Frame
        Instance.new("UICorner", PlayBtn).CornerRadius = UDim.new(0,8)

        local StopBtn = Instance.new("TextButton")
        StopBtn.Size = UDim2.new(0,130,0,40)
        StopBtn.Position = UDim2.new(1,-150,0,185)
        StopBtn.BackgroundColor3 = Color3.fromRGB(200,30,30)
        StopBtn.Text = "⏹ STOP"
        StopBtn.TextColor3 = Color3.new(1,1,1)
        StopBtn.Parent = Frame
        Instance.new("UICorner", StopBtn).CornerRadius = UDim.new(0,8)

        Input.FocusLost:Connect(function(enter) if enter then PlaySound(Input.Text) end end)
        PlayBtn.MouseButton1Click:Connect(function() if Input.Text ~= "" then PlaySound(Input.Text) end end)
        StopBtn.MouseButton1Click:Connect(StopSound)
        VolBG.InputBegan:Connect(function()
            local Conn
            Conn = UserInputService.InputChanged:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement then
                    local Rel = Input.Position.X - VolBG.AbsolutePosition.X
                    UpdateVolume(math.floor(math.clamp(Rel / VolBG.AbsoluteSize.X, 0, 1) * VOLUME_MAX))
                end
            end)
            UserInputService.InputEnded:Connect(function(Inp)
                if Inp.UserInputType == Enum.UserInputType.MouseButton1 then Conn:Disconnect() end
            end)
        end)
    end

    -- ✅ CONSOLE MENU
    local ConsoleUI_Open, CurrentConsoleUI = false, nil
    local function ToggleConsoleMenu()
        if ConsoleUI_Open then
            if CurrentConsoleUI then CurrentConsoleUI:Destroy() end
            ConsoleUI_Open = false
            CurrentConsoleUI = nil
            return
        end
        GuiFocused = true
        ConsoleUI_Open = true

        local ConsoleUI = Instance.new("ScreenGui")
        ConsoleUI.Name = "BLUE_MODE_CONSOLE"
        ConsoleUI.ResetOnSpawn = false
        ConsoleUI.DisplayOrder = PRIORITY.CONSOLE
        ConsoleUI.Parent = GuiContainer
        CurrentConsoleUI = ConsoleUI

        local Frame = Instance.new("Frame")
        Frame.Size = UDim2.new(0,450,0,320)
        Frame.Position = UDim2.new(0.5,-225,0.5,-160)
        Frame.BackgroundColor3 = Color3.fromRGB(22,22,22)
        Frame.Active = true
        Frame.Draggable = true
        Frame.Parent = ConsoleUI
        Instance.new("UICorner", Frame).CornerRadius = UDim.new(0,12)
        AddRainbowGlow(Frame,5)

        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1,-50,0,35)
        Title.Position = UDim2.new(0,15,0,6)
        Title.BackgroundTransparency = 1
        Title.Text = "💻 SCRIPT CONSOLE"
        Title.TextColor3 = Color3.new(1,1,1)
        Title.Font = Enum.Font.GothamBold
        Title.Parent = Frame

        local Output = Instance.new("TextLabel")
        Output.Size = UDim2.new(1,-30,0,130)
        Output.Position = UDim2.new(0,15,0,45)
        Output.BackgroundColor3 = Color3.fromRGB(10,10,10)
        Output.Font = Enum.Font.Code
        Output.TextWrapped = true
        Output.Text = "Paste your Lua code below..."
        Output.TextColor3 = Color3.fromRGB(0,255,120)
        Output.Parent = Frame
        Instance.new("UICorner", Output).CornerRadius = UDim.new(0,8)

        local Input = Instance.new("TextBox")
        Input.Size = UDim2.new(1,-30,0,95)
        Input.Position = UDim2.new(0,15,0,185)
        Input.BackgroundColor3 = Color3.fromRGB(35,35,35)
        Input.Font = Enum.Font.Code
        Input.MultiLine = true
        Input.PlaceholderText = "Paste Lua code here..."
        Input.TextColor3 = Color3.new(1,1,1)
        Input.Parent = Frame
        Instance.new("UICorner", Input).CornerRadius = UDim.new(0,8)

        local RunBtn = Instance.new("TextButton")
        RunBtn.Size = UDim2.new(0,120,0,40)
        RunBtn.Position = UDim2.new(0,15,0,255)
        RunBtn.BackgroundColor3 = Color3.fromRGB(20,150,70)
        RunBtn.Text = "▶ EXECUTE"
        RunBtn.TextColor3 = Color3.new(1,1,1)
        RunBtn.Parent = Frame
        Instance.new("UICorner", RunBtn).CornerRadius = UDim.new(0,8)

        local ClearBtn = Instance.new("TextButton")
        ClearBtn.Size = UDim2.new(0,120,0,40)
        ClearBtn.Position = UDim2.new(1,-135,0,255)
        ClearBtn.BackgroundColor3 = Color3.fromRGB(180,120,20)
        ClearBtn.Text = "🗑 CLEAR"
        ClearBtn.TextColor3 = Color3.new(1,1,1)
        ClearBtn.Parent = Frame
        Instance.new("UICorner", ClearBtn).CornerRadius = UDim.new(0,8)

        local function RunCode()
            if Input.Text == "" then Output.Text = "⚠️ No code provided!" return end
            local Success, Err = pcall(loadstring(Input.Text))
            if Success then Output.Text = "✅ Executed successfully!\n> "..Input.Text:sub(1,100)
            else Output.Text = "❌ ERROR:\n"..tostring(Err) end
        end
        RunBtn.MouseButton1Click:Connect(RunCode)
        Input.FocusLost:Connect(function(enter) if enter then RunCode() end end)
        ClearBtn.MouseButton1Click:Connect(function() Input.Text = "" Output.Text = "Cleared. Ready for new code." end)
    end

    -- ✅ MAIN HUB GUI
    local MainUI = Instance.new("ScreenGui")
    MainUI.Name = "BLUE_MODE_HUB_MAIN"
    MainUI.ResetOnSpawn = false
    MainUI.DisplayOrder = PRIORITY.MAIN
    MainUI.Parent = GuiContainer

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0,680,0,105)
    MainFrame.Position = UDim2.new(0,20,0.5,-52)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = MainUI
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,8)
    AddRainbowGlow(MainFrame,5)

    local InfoLabel = Instance.new("TextLabel")
    InfoLabel.Size = UDim2.new(0,180,1,-16)
    InfoLabel.Position = UDim2.new(0,8,0,8)
    InfoLabel.BackgroundTransparency = 1
    InfoLabel.Font = Enum.Font.Gotham
    InfoLabel.TextScaled = true
    InfoLabel.TextColor3 = Color3.new(1,1,1)
    InfoLabel.TextXAlignment = Enum.TextXAlignment.Left
    InfoLabel.Parent = MainFrame

    local VolLabel = Instance.new("TextLabel")
    VolLabel.Size = UDim2.new(0,100,0,25)
    VolLabel.Position = UDim2.new(0,200,0,10)
    VolLabel.BackgroundTransparency = 1
    VolLabel.Text = "VOLUME:"
    VolLabel.TextColor3 = Color3.new(1,1,1)
    VolLabel.Parent = MainFrame

    VolNumTextMain = Instance.new("TextLabel")
    VolNumTextMain.Size = UDim2.new(0,50,0,25)
    VolNumTextMain.Position = UDim2.new(0,290,0,10)
    VolNumTextMain.BackgroundTransparency = 1
    VolNumTextMain.Text = tostring(MusicVolume)
    VolNumTextMain.TextColor3 = Color3.new(1,1,1)
    VolNumTextMain.Parent = MainFrame

    local VolBG = Instance.new("Frame")
    VolBG.Size = UDim2.new(0,150,0,18)
    VolBG.Position = UDim2.new(0,200,0,45)
    VolBG.BackgroundColor3 = Color3.fromRGB(50,50,50)
    VolBG.Parent = MainFrame
    Instance.new("UICorner", VolBG).CornerRadius = UDim.new(0,9)

    VolFillMain = Instance.new("Frame")
    VolFillMain.Size = UDim2.new(MusicVolume/VOLUME_MAX,0,1,0)
    VolFillMain.BackgroundColor3 = Color3.fromRGB(100,100,255)
    VolFillMain.Parent = VolBG
    Instance.new("UICorner", VolFillMain).CornerRadius = UDim.new(0,9)

    ESPBtn = Instance.new("TextButton")
    ESPBtn.Size = UDim2.new(0,85,0,30)
    ESPBtn.Position = UDim2.new(0,370,0,10)
    ESPBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    ESPBtn.Text = "ESP: OFF"
    ESPBtn.TextColor3 = Color3.new(1,1,1)
    ESPBtn.Font = Enum.Font.GothamBold
    ESPBtn.TextScaled = true
    ESPBtn.Parent = MainFrame
    Instance.new("UICorner", ESPBtn).CornerRadius = UDim.new(0,6)
    AddRainbowGlow(ESPBt,2)

    local MusicBtn = Instance.new("TextButton")
    MusicBtn.Size = UDim2.new(0,90,0,30)
    MusicBtn.Position = UDim2.new(0,465,0,10)
    MusicBtn.BackgroundColor3 = Color3.fromRGB(40,80,160)
    MusicBtn.Text = "🎵 MUSIC"
    MusicBtn.TextColor3 = Color3.new(1,1,1)
    MusicBtn.Font = Enum.Font.GothamBold
    MusicBtn.TextScaled = true
    MusicBtn.Parent = MainFrame
    Instance.new("UICorner", MusicBtn).CornerRadius = UDim.new(0,6)
    AddRainbowGlow(MusicBtn,2)

    local ConsoleBtn = Instance.new("TextButton")
    ConsoleBtn.Size = UDim2.new(0,90,0,30)
    ConsoleBtn.Position = UDim2.new(0,560,0,10)
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
    ExitBtn.Position = UDim2.new(0,560,0,45)
    ExitBtn.BackgroundColor3 = Color3.fromRGB(140,20,20)
    ExitBtn.Text = "❌ EXIT"
    ExitBtn.TextColor3 = Color3.new(1,1,1)
    ExitBtn.Font = Enum.Font.GothamBold
    ExitBtn.TextScaled = true
    ExitBtn.Parent = MainFrame
    Instance.new("UICorner", ExitBtn).CornerRadius = UDim.new(0,6)
    AddRainbowGlow(ExitBtn,2)

    -- ✅ UPDATED ESP TOGGLE
    ESPBtn.MouseButton1Click:Connect(function()
        ESP_Enabled = not ESP_Enabled
        if ESP_Enabled then
            ESPBtn.Text = "ESP: ON"
            ESPBtn.BackgroundColor3 = Color3.fromRGB(25, 140, 255)
            ClearAllESP() -- Clean first
            for _,plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer then
                    ApplyESP(plr)
                end
            end
            Players.PlayerAdded:Connect(function(plr)
                plr.CharacterAdded:Connect(function() task.wait(0.5) ApplyESP(plr) end)
            end)
        else
            ESPBtn.Text = "ESP: OFF"
            ESPBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
            ClearAllESP()
        end
    end)

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

    -- ✅ FPS/PING UPDATE LOOP
    task.spawn(function()
        while task.wait() do
            local Now = os.clock()
            if Now - LastFPSUpdate >= 1 then
                InfoLabel.Text = string.format("🔵 BLUE MODE HUB\n📊 FPS: %d\n📶 PING: %dms\n🌐 SERVER: %dms", FPSCounter, GetClientPing(), GetServerPing())
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
    end)

    print("✅ BLUE MODE HUB | OWNER PRIORITY ESP FULLY LOADED")
end
