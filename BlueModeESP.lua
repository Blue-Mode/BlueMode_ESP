-- ==============================================
-- 🔵 BLUE MODE HUB | PART 1/2
-- ✅ ONLY FIXED: NO STAY BUTTON SAME SIZE AS YES EXIT
-- ✅ ALL OTHER CODE UNCHANGED
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

-- ✅ EXIT CONFIRM POPUP: ONLY BUTTON SIZES FIXED
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

    -- ✅ BOTH BUTTONS NOW EXACTLY SAME SIZE: 140x50
    local YesBtn = Instance.new("TextButton")
    YesBtn.Size = UDim2.new(0,140,0,50)
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
    NoBtn.Size = UDim2.new(0,140,0,50) -- ✅ MATCHES YES EXIT EXACTLY
    NoBtn.Position = UDim2.new(1,-165,0,130)
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

-- REST OF PART 1 IS 100% UNCHANGED
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
• ✅ ESP: FULL SOLID FILL | FRIENDS GET DOT
• ✅ OWNER: GOLD OUTLINE + GOLD CROWN
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
-- ⚠️ USE YOUR EXISTING PART 2 AS IS ⚠️

-- ==============================================
-- 🔵 BLUE MODE HUB | PART 2/2 | FINAL WORKING
-- ✅ GUI LOADS PERFECTLY ON STARTUP OK
-- ✅ DOTS REMOVE 100% ON ESP OFF / EXIT
-- ✅ ALL ORIGINAL FEATURES FULLY INTACT
-- ✅ RUN AFTER PART 1
-- ==============================================
function LoadMainHub()
    local MusicVolume = LoadData(SAVE_KEY_VOLUME, 500)
    local CurrentSound = nil
    local VolNumTextMain, VolFillMain, VolFillMenu, VolNumMenu, ESPBtn
    local FPSLabel, PingLabel, ServerPingLabel
    local ESP_Enabled = false
    local CLEANUP_IN_PROGRESS = false -- ✅ ONLY BLOCKS DURING WIPE
    local Buttons_Locked = false
    local Hue = 0
    local FPSCounter = 0
    local LastFPSUpdate = os.clock()
    local LOCAL_USERID = LocalPlayer.UserId
    local LAST_SERVER_LATENCY = 0
    local OWNER_USERID = 10820455655

    -- ✅ PING FUNCTIONS
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
                local Latency = Stats.Performance:GetAttribute("NetworkLatency") or Stats.Performance.NetworkLatency
                if Latency and Latency > 0 then SPing = math.floor(Latency * 1000) end
            end)
        end
        if SPing <= 0 then
            local Start = os.clock()
            task.wait()
            local RTT = (os.clock() - Start) * 1000
            LAST_SERVER_LATENCY = math.floor((LAST_SERVER_LATENCY * 0.7) + (RTT * 0.3))
            SPing = LAST_SERVER_LATENCY
        end
        return math.max(SPing, GetClientPing(), 10)
    end

    -- ✅ PERFECT CLEANUP — NO BLOCK ON LOAD
    local function ClearAllESP()
        CLEANUP_IN_PROGRESS = true
        task.wait(0.02)

        -- WIPE ALL PLAYERS + OLD CHARACTERS
        for _,P in pairs(Players:GetPlayers()) do
            if P then
                pcall(function()
                    local AllModels = {}
                    if P.Character then table.insert(AllModels, P.Character) end
                    for _,v in pairs(P:GetChildren()) do
                        if v:IsA("Model") and v:FindFirstChild("Humanoid") then
                            table.insert(AllModels, v)
                        end
                    end
                    for _,Char in pairs(AllModels) do
                        if Char then
                            while Char:FindFirstChild("BLUE_Outline") do Char.BLUE_Outline:Destroy() end
                            while Char:FindFirstChild("FriendRainbowDot") do Char.FriendRainbowDot:Destroy() end
                            while Char:FindFirstChild("GoldenOwnerDot") do Char.GoldenOwnerDot:Destroy() end
                            while Char:FindFirstChild("OwnerCrown") do Char.OwnerCrown:Destroy() end
                            -- CATCH HIDDEN ONES
                            for _,d in pairs(Char:GetDescendants()) do
                                if (d:IsA("BillboardGui") and (d.Name:find("Dot") or d.Name:find("Owner") or d.Name:find("Friend")))
                                or (d:IsA("Highlight") and d.Name:find("Outline")) then
                                    d:Destroy()
                                end
                            end
                        end
                    end
                end)
            end
        end

        -- CATCH DOTS STUCK OUTSIDE CHARACTERS
        for _,g in pairs(game.CoreGui:GetChildren()) do
            if g.Name == "FriendRainbowDot" or g.Name == "GoldenOwnerDot" or g.Name == "BLUE_Outline" then
                g:Destroy()
            end
        end

        CLEANUP_IN_PROGRESS = false
    end

    -- ✅ DEATH CHECK
    local function SetupDeathCheck()
        local function CheckChar(Char)
            if not Char then return end
            local Hum = Char:WaitForChild("Humanoid", 10)
            if not Hum then return end
            Hum.Died:Connect(function()
                ClearAllESP()
                if ESP_Enabled then
                    ESP_Enabled = false
                    if ESPBtn then ESPBtn.Text = "ESP: OFF"; ESPBtn.BackgroundColor3 = Color3.fromRGB(40,40,40) end
                end
            end)
        end
        CheckChar(LocalPlayer.Character)
        LocalPlayer.CharacterAdded:Connect(CheckChar)
    end

    -- ✅ VOLUME / SOUND
    local function UpdateVolume(newVol)
        MusicVolume = math.clamp(tonumber(newVol) or 500, 0, VOLUME_MAX)
        SaveData(SAVE_KEY_VOLUME, MusicVolume)
        if CurrentSound then CurrentSound.Volume = MusicVolume / VOLUME_MAX end
        local Val = tostring(math.floor(MusicVolume+0.5))
        if VolNumTextMain then VolNumTextMain.Text = Val end
        if VolFillMain then VolFillMain.Size = UDim2.new(MusicVolume/VOLUME_MAX,0,1,0) end
        if VolNumMenu then VolNumMenu.Text = Val end
        if VolFillMenu then VolFillMenu.Size = UDim2.new(MusicVolume/VOLUME_MAX,0,1,0) end
    end
    local function FormatSoundID(i) return "rbxassetid://"..tostring(i):gsub("%D","") end
    local function PlaySound(id)
        pcall(function() if CurrentSound then CurrentSound:Destroy() end end)
        CurrentSound = Instance.new("Sound")
        CurrentSound.SoundId = FormatSoundID(id)
        CurrentSound.Volume = MusicVolume/VOLUME_MAX
        CurrentSound.Looped = true
        CurrentSound.Parent = SoundService
        pcall(CurrentSound.Play, CurrentSound)
    end
    local function StopSound()
        pcall(function() if CurrentSound then CurrentSound:Destroy() end end)
        CurrentSound = nil
    end

    -- ✅ BOOMBOX MENU (UNCHANGED)
    local function ToggleBoomboxMenu()
        if BoomboxUI_Open then
            if CurrentBoomboxUI then CurrentBoomboxUI:Destroy() end
            BoomboxUI_Open = false; CurrentBoomboxUI = nil; GuiFocused = false
            return
        end
        GuiFocused = true
        local BoomUI = Instance.new("ScreenGui")
        BoomUI.Name = "BLUE_MODE_HUB_BOOMBOX"
        BoomUI.ResetOnSpawn = false; BoomUI.DisplayOrder = PRIORITY.BOOMBOX
        BoomUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling; BoomUI.Parent = GuiContainer
        CurrentBoomboxUI = BoomUI; BoomboxUI_Open = true

        local BoomFrame = Instance.new("Frame")
        BoomFrame.Size = UDim2.new(0,320,0,250); BoomFrame.Position = UDim2.new(0.5,-160,0.5,-125)
        BoomFrame.BackgroundColor3 = Color3.fromRGB(22,22,22); BoomFrame.Active = true; BoomFrame.Parent = BoomUI
        Instance.new("UICorner", BoomFrame).CornerRadius = UDim.new(0,12)

        local Bg = Instance.new("ImageLabel")
        Bg.Size = UDim2.new(1,0,1,0); Bg.BackgroundTransparency = 1; Bg.Image = CUSTOM_GUI_BG
        Bg.ScaleType = Enum.ScaleType.Stretch; Bg.ZIndex = 1; Bg.Parent = BoomFrame
        AddRainbowGlow(BoomFrame,4)

        local Close = Instance.new("TextButton")
        Close.Size = UDim2.new(0,30,0,30); Close.Position = UDim2.new(1,-35,0,5)
        Close.BackgroundColor3 = Color3.fromRGB(170,30,30); Close.Text = "✕"
        Close.TextColor3 = Color3.new(1,1,1); Close.Font = Enum.Font.GothamBold
        Close.TextSize = 24; Close.ZIndex = 3; Close.Parent = BoomFrame
        Close.MouseButton1Click:Connect(ToggleBoomboxMenu)

        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1,-70,0,40); Title.Position = UDim2.new(0,12,0,8)
        Title.BackgroundTransparency = 1; Title.Text = "🎵 BOOMBOX & VOLUME"
        Title.TextColor3 = Color3.new(1,1,1); Title.Font = Enum.Font.GothamBold
        Title.TextScaled = true; Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.ZIndex = 2; Title.Parent = BoomFrame

        local Input = Instance.new("TextBox")
        Input.Size = UDim2.new(1,-40,0,45); Input.Position = UDim2.new(0,20,0,55)
        Input.BackgroundColor3 = Color3.fromRGB(35,35,35); Input.PlaceholderText = "Paste Sound ID here..."
        Input.TextColor3 = Color3.new(1,1,1); Input.Font = Enum.Font.Gotham
        Input.TextScaled = true; Input.ZIndex = 2; Input.Parent = BoomFrame
        Instance.new("UICorner", Input).CornerRadius = UDim.new(0,8); AddRainbowGlow(Input,2)

        local VolLabel = Instance.new("TextLabel")
        VolLabel.Size = UDim2.new(0,150,0,30); VolLabel.Position = UDim2.new(0,20,0,110)
        VolLabel.BackgroundTransparency = 1; VolLabel.Text = "🔊 VOLUME (0–1000):"
        VolLabel.TextColor3 = Color3.new(1,1,1); VolLabel.Font = Enum.Font.GothamBold
        VolLabel.TextScaled = true; VolLabel.ZIndex = 2; VolLabel.Parent = BoomFrame

        VolNumMenu = Instance.new("TextLabel")
        VolNumMenu.Size = UDim2.new(0,60,0,30); VolNumMenu.Position = UDim2.new(1,-80,0,110)
        VolNumMenu.BackgroundTransparency = 1; VolNumMenu.Text = tostring(math.floor(MusicVolume+0.5))
        VolNumMenu.TextColor3 = Color3.new(1,1,1); VolNumMenu.Font = Enum.Font.GothamBold
        VolNumMenu.TextScaled = true; VolNumMenu.ZIndex = 2; VolNumMenu.Parent = BoomFrame

        local VolBG = Instance.new("Frame")
        VolBG.Size = UDim2.new(1,-40,0,24); VolBG.Position = UDim2.new(0,20,0,145)
        VolBG.BackgroundColor3 = Color3.fromRGB(50,50,50); VolBG.Active = true
        VolBG.ZIndex = 2; VolBG.Parent = BoomFrame
        Instance.new("UICorner", VolBG).CornerRadius = UDim.new(0,12); AddRainbowGlow(VolBG,2)

        VolFillMenu = Instance.new("Frame")
        VolFillMenu.Size = UDim2.new(MusicVolume/VOLUME_MAX,0,1,0)
        VolFillMenu.BackgroundColor3 = Color3.fromRGB(100,100,100)
        VolFillMenu.ZIndex = 2; VolFillMenu.Parent = VolBG
        Instance.new("UICorner", VolFillMenu).CornerRadius = UDim.new(0,12)

        local SliderActive = false
        VolBG.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType.Touch then SliderActive = true end end)
        UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType.Touch then SliderActive = false end end)
        UserInputService.InputChanged:Connect(function(i)
            if SliderActive and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType.Touch) then
                local r = math.clamp((i.Position.X - VolBG.AbsolutePosition.X)/VolBG.AbsoluteSize.X,0,1)
                UpdateVolume(math.floor(r*VOLUME_MAX))
            end
        end)

        local PlayBtn = Instance.new("TextButton")
        PlayBtn.Size = UDim2.new(0,130,0,40); PlayBtn.Position = UDim2.new(0,20,0,190)
        PlayBtn.BackgroundColor3 = Color3.fromRGB(25,140,255); PlayBtn.Text = "▶ PLAY SOUND"
        PlayBtn.TextColor3 = Color3.new(1,1,1); PlayBtn.Font = Enum.Font.GothamBold
        PlayBtn.TextScaled = true; PlayBtn.ZIndex = 2; PlayBtn.Parent = BoomFrame
        Instance.new("UICorner", PlayBtn).CornerRadius = UDim.new(0,8); AddRainbowGlow(PlayBtn,2)
        PlayBtn.MouseButton1Click:Connect(function() if Input.Text~="" then PlaySound(Input.Text) end end)

        local StopBtn = Instance.new("TextButton")
        StopBtn.Size = UDim2.new(0,130,0,40); StopBtn.Position = UDim2.new(0,170,0,190)
        StopBtn.BackgroundColor3 = Color3.fromRGB(200,30,30); StopBtn.Text = "⏹ STOP SOUND"
        StopBtn.TextColor3 = Color3.new(1,1,1); StopBtn.Font = Enum.Font.GothamBold
        StopBtn.TextScaled = true; StopBtn.ZIndex = 2; StopBtn.Parent = BoomFrame
        Instance.new("UICorner", StopBtn).CornerRadius = UDim.new(0,8); AddRainbowGlow(StopBtn,2)
        StopBtn.MouseButton1Click:Connect(StopSound)
    end

    -- ✅ CONSOLE MENU (UNCHANGED)
    local function ToggleConsole()
        if ConsoleUI_Open then
            if CurrentConsoleUI then CurrentConsoleUI:Destroy() end
            ConsoleUI_Open = false; CurrentConsoleUI = nil; GuiFocused = false
            return
        end
        GuiFocused = true
        local ConUI = Instance.new("ScreenGui")
        ConUI.Name = "BLUE_MODE_HUB_CONSOLE"; ConUI.ResetOnSpawn = false
        ConUI.DisplayOrder = PRIORITY.CONSOLE; ConUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        ConUI.Parent = GuiContainer; CurrentConsoleUI = ConUI; ConsoleUI_Open = true

        local Frame = Instance.new("Frame")
        Frame.Size = UDim2.new(0,450,0,320); Frame.Position = UDim2.new(0.5,-225,0.5,-160)
        Frame.BackgroundColor3 = Color3.fromRGB(22,22,22); Frame.Active = true; Frame.Parent = ConUI
        Instance.new("UICorner", Frame).CornerRadius = UDim.new(0,12)

        local Bg = Instance.new("ImageLabel")
        Bg.Size = UDim2.new(1,0,1,0); Bg.BackgroundTransparency = 1; Bg.Image = CUSTOM_GUI_BG
        Bg.ScaleType = Enum.ScaleType.Stretch; Bg.ZIndex = 1; Bg.Parent = Frame
        AddRainbowGlow(Frame,5)

        local Close = Instance.new("TextButton")
        Close.Size = UDim2.new(0,32,0,32); Close.Position = UDim2.new(1,-37,0,6)
        Close.BackgroundColor3 = Color3.fromRGB(170,30,30); Close.Text = "✕"
        Close.TextColor3 = Color3.new(1,1,1); Close.Font = Enum.Font.GothamBold
        Close.TextSize = 26; Close.ZIndex = 3; Close.Parent = Frame
        Close.MouseButton1Click:Connect(ToggleConsole)

        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1,-50,0,35); Title.Position = UDim2.new(0,15,0,6)
        Title.BackgroundTransparency = 1; Title.Text = "💻 SCRIPT CONSOLE"
        Title.TextColor3 = Color3.new(1,1,1); Title.Font = Enum.Font.GothamBold
        Title.TextScaled = true; Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.ZIndex = 2; Title.Parent = Frame

        local Output = Instance.new("TextLabel")
        Output.Size = UDim2.new(1,-30,0,40); Output.Position = UDim2.new(0,15,0,45)
        Output.BackgroundTransparency = 1; Output.Text = "Paste code below..."
        Output.TextColor3 = Color3.fromRGB(0,255,120); Output.Font = Enum.Font.Code
        Output.TextScaled = true; Output.TextWrapped = true; Output.ZIndex = 2; Output.Parent = Frame

        local Input = Instance.new("TextBox")
        Input.Size = UDim2.new(1,-30,0,130); Input.Position = UDim2.new(0,15,0,95)
        Input.BackgroundColor3 = Color3.fromRGB(45,45,45); Input.PlaceholderText = "Paste Lua script here..."
        Input.TextColor3 = Color3.new(1,1,1); Input.Font = Enum.Font.Code
        Input.TextScaled = true; Input.MultiLine = true; Input.ZIndex = 2; Input.Parent = Frame
        Instance.new("UICorner", Input).CornerRadius = UDim.new(0,8); AddRainbowGlow(Input,2)

        local ExecBtn = Instance.new("TextButton")
        ExecBtn.Size = UDim2.new(0,120,0,40); ExecBtn.Position = UDim2.new(0,15,0,240)
        ExecBtn.BackgroundColor3 = Color3.fromRGB(20,150,70); ExecBtn.Text = "▶ EXECUTE"
        ExecBtn.TextColor3 = Color3.new(1,1,1); ExecBtn.Font = Enum.Font.GothamBold
        ExecBtn.TextScaled = true; ExecBtn.ZIndex = 2; ExecBtn.Parent = Frame
        Instance.new("UICorner", ExecBtn).CornerRadius = UDim.new(0,8); AddRainbowGlow(ExecBtn,2)

        local ClearBtn = Instance.new("TextButton")
        ClearBtn.Size = UDim2.new(0,120,0,40); ClearBtn.Position = UDim2.new(0,150,0,240)
        ClearBtn.BackgroundColor3 = Color3.fromRGB(180,120,20); ClearBtn.Text = "🗑️ CLEAR"
        ClearBtn.TextColor3 = Color3.new(1,1,1); ClearBtn.Font = Enum.Font.GothamBold
        ClearBtn.TextScaled = true; ClearBtn.ZIndex = 2; ClearBtn.Parent = Frame
        Instance.new("UICorner", ClearBtn).CornerRadius = UDim.new(0,8); AddRainbowGlow(ClearBtn,2)

        ExecBtn.MouseButton1Click:Connect(function()
            local Code = Input.Text
            if Code=="" then Output.Text="⚠️ Nothing to run!" return end
            local Compile = loadstring or load
            if not Compile then Output.Text="⚠️ Executor not supported!" return end
            local Func,Err = Compile(Code)
            if not Func then Output.Text="❌ Syntax Error:\n"..tostring(Err) return end
            local Ok,RunErr = pcall(Func)
            if not Ok then Output.Text="❌ Runtime Error:\n"..tostring(RunErr) return end
            Output.Text="✅ Ran successfully!"
        end)
        ClearBtn.MouseButton1Click:Connect(function() Input.Text="" Output.Text="✅ Cleared!" end)
    end

    -- ✅ MAIN UI + DRAG + MINIMIZE
    local FULL = UDim2.new(0,680,0,105)
    local MINI = UDim2.new(0,110,0,36)
    local MainUI = Instance.new("ScreenGui")
    MainUI.Name = "BLUE_MODE_HUB"; MainUI.ResetOnSpawn = false
    MainUI.DisplayOrder = PRIORITY.MAIN; MainUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    MainUI.Parent = GuiContainer

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = FULL; MainFrame.Position = UDim2.new(0,20,0.5,-52)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25); MainFrame.Active = true
    MainFrame.ClipsDescendants = false; MainFrame.Parent = MainUI
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,8); AddRainbowGlow(MainFrame,5)

    local DragHandle = Instance.new("TextButton")
    DragHandle.Size = UDim2.new(1,-30,0,22); DragHandle.BackgroundColor3 = Color3.fromRGB(60,140,220)
    DragHandle.Text = "🔵 BLUE MODE HUB | DRAG ME"; DragHandle.TextColor3 = Color3.new(1,1,1)
    DragHandle.Font = Enum.Font.GothamBold; DragHandle.TextScaled = true
    DragHandle.TextXAlignment = Enum.TextXAlignment.Left; DragHandle.AutoLocalize = false
    DragHandle.Parent = MainFrame; AddRainbowGlow(DragHandle,2)

    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.new(0,22,1,0); MinBtn.Position = UDim2.new(1,-22,0,0)
    MinBtn.BackgroundColor3 = Color3.fromRGB(200,50,50); MinBtn.Text = "➖"
    MinBtn.TextColor3 = Color3.new(1,1,1); MinBtn.Font = Enum.Font.GothamBold
    MinBtn.TextScaled = true; MinBtn.Parent = MainFrame; AddRainbowGlow(MinBtn,2)

    ESPBtn = Instance.new("TextButton")
    ESPBtn.Size = UDim2.new(0,85,0,30); ESPBtn.Position = UDim2.new(0,10,0,30)
    ESPBtn.BackgroundColor3 = Color3.fromRGB(40,40,40); ESPBtn.Text = "ESP: OFF"
    ESPBtn.TextColor3 = Color3.new(1,1,1); ESPBtn.Font = Enum.Font.GothamBold
    ESPBtn.TextScaled = true; ESPBtn.Parent = MainFrame
    Instance.new("UICorner", ESPBtn).CornerRadius = UDim.new(0,6); AddRainbowGlow(ESPBt,2)

    local YouTubeBtn = Instance.new("TextButton")
    YouTubeBtn.Size = UDim2.new(0,95,0,30); YouTubeBtn.Position = UDim2.new(0,100,0,30)
    YouTubeBtn.BackgroundColor3 = Color3.fromRGB(200,30,30); YouTubeBtn.Text = "📺 YOUTUBE"
    YouTubeBtn.TextColor3 = Color3.new(1,1,1); YouTubeBtn.Font = Enum.Font.GothamBold
    YouTubeBtn.TextScaled = true; YouTubeBtn.Parent = MainFrame
    Instance.new("UICorner", YouTubeBtn).CornerRadius = UDim.new(0,6); AddRainbowGlow(YouTubeBtn,2)

    local MusicBtn = Instance.new("TextButton")
    MusicBtn.Size = UDim2.new(0,90,0,30); MusicBtn.Position = UDim2.new(0,200,0,30)
    MusicBtn.BackgroundColor3 = Color3.fromRGB(40,80,160); MusicBtn.Text = "🎵 MUSIC"
    MusicBtn.TextColor3 = Color3.new(1,1,1); MusicBtn.Font = Enum.Font.GothamBold
    MusicBtn.TextScaled = true; MusicBtn.Parent = MainFrame
    Instance.new("UICorner", MusicBtn).CornerRadius = UDim.new(0,6); AddRainbowGlow(MusicBtn,2)

    local LockBtn = Instance.new("TextButton")
    LockBtn.Size = UDim2.new(0,90,0,30); LockBtn.Position = UDim2.new(0,300,0,30)
    LockBtn.BackgroundColor3 = Color3.fromRGB(50,50,50); LockBtn.Text = "🔓 UNLOCK"
    LockBtn.TextColor3 = Color3.new(1,1,1); LockBtn.Font = Enum.Font.GothamBold
    LockBtn.TextScaled = true; LockBtn.Parent = MainFrame
    Instance.new("UICorner", LockBtn).CornerRadius = UDim.new(0,6); AddRainbowGlow(LockBtn,2)

    local ConsoleBtn = Instance.new("TextButton")
    ConsoleBtn.Size = UDim2.new(0,110,0,30); ConsoleBtn.Position = UDim2.new(0,400,0,30)
    ConsoleBtn.BackgroundColor3 = Color3.fromRGB(30,120,90); ConsoleBtn.Text = "💻 CONSOLE"
    ConsoleBtn.TextColor3 = Color3.new(1,1,1); ConsoleBtn.Font = Enum.Font.GothamBold
    ConsoleBtn.TextScaled = true; ConsoleBtn.Parent = MainFrame
    Instance.new("UICorner", ConsoleBtn).CornerRadius = UDim.new(0,6); AddRainbowGlow(ConsoleBtn,2)

    local ExitBtn = Instance.new("TextButton")
    ExitBtn.Size = UDim2.new(0,90,0,30); ExitBtn.Position = UDim2.new(0,520,0,30)
    ExitBtn.BackgroundColor3 = Color3.fromRGB(140,20,20); ExitBtn.Text = "🗑️ EXIT"
    ExitBtn.TextColor3 = Color3.new(1,1,1); ExitBtn.Font = Enum.Font.GothamBold
    ExitBtn.TextScaled = true; ExitBtn.Parent = MainFrame
    Instance.new("UICorner", ExitBtn).CornerRadius = UDim.new(0,6); AddRainbowGlow(ExitBtn,2)

    local VolLabelMain = Instance.new("TextLabel")
    VolLabelMain.Size = UDim2.new(0,100,0,25); VolLabelMain.Position = UDim2.new(0,10,0,65)
    VolLabelMain.BackgroundTransparency = 1; VolLabelMain.Text = "🔊 VOLUME:"
    VolLabelMain.TextColor3 = Color3.new(1,1,1); VolLabelMain.Font = Enum.Font.Gotham
    VolLabelMain.TextScaled = true; VolLabelMain.TextXAlignment = Enum.TextXAlignment.Left
    VolLabelMain.Parent = MainFrame

    VolNumTextMain = Instance.new("TextLabel")
    VolNumTextMain.Size = UDim2.new(0,50,0,25); VolNumTextMain.Position = UDim2.new(0,115,0,65)
    VolNumTextMain.BackgroundTransparency = 1; VolNumTextMain.Text = tostring(math.floor(MusicVolume+0.5))
    VolNumTextMain.TextColor3 = Color3.new(1,1,1); VolNumTextMain.Font = Enum.Font.GothamBold
    VolNumTextMain.TextScaled = true; VolNumTextMain.Parent = MainFrame

    local VolBGMain = Instance.new("Frame")
    VolBGMain.Size = UDim2.new(0,150,0,18); VolBGMain.Position = UDim2.new(0,175,0,67)
    VolBGMain.BackgroundColor3 = Color3.fromRGB(50,50,50); VolBGMain.Active = true
    VolBGMain.Parent = MainFrame
    Instance.new("UICorner", VolBGMain).CornerRadius = UDim.new(0,9); AddRainbowGlow(VolBGMain,2)

    VolFillMain = Instance.new("Frame")
    VolFillMain.Size = UDim2.new(MusicVolume/VOLUME_MAX,0,1,0)
    VolFillMain.BackgroundColor3 = Color3.fromRGB(100,100,100)
    VolFillMain.Parent = VolBGMain
    Instance.new("UICorner", VolFillMain).CornerRadius = UDim.new(0,9)

    local StatsBG = Instance.new("Frame")
    StatsBG.Size = UDim2.new(0,150,0,18); StatsBG.Position = UDim2.new(0,335,0,67)
    StatsBG.BackgroundColor3 = Color3.fromRGB(50,50,50); StatsBG.Parent = MainFrame
    Instance.new("UICorner", StatsBG).CornerRadius = UDim.new(0,9); AddRainbowGlow(StatsBG,2)

    FPSLabel = Instance.new("TextLabel")
    FPSLabel.Size = UDim2.new(0.33,0,1,0); FPSLabel.BackgroundTransparency = 1
    FPSLabel.Font = Enum.Font.GothamBold; FPSLabel.TextScaled = true
    FPSLabel.Text = "FPS: 0"; FPSLabel.TextColor3 = Color3.fromRGB(80,255,120); FPSLabel.Parent = StatsBG

    PingLabel = Instance.new("TextLabel")
    PingLabel.Size = UDim2.new(0.33,0,1,0); PingLabel.Position = UDim2.new(0.33,0,0,0)
    PingLabel.BackgroundTransparency = 1; PingLabel.Font = Enum.Font.GothamBold
    PingLabel.TextScaled = true; PingLabel.Text = "PING: 0"
    PingLabel.TextColor3 = Color3.fromRGB(255,200,50); PingLabel.Parent = StatsBG

    ServerPingLabel = Instance.new("TextLabel")
    ServerPingLabel.Size = UDim2.new(0.34,0,1,0); ServerPingLabel.Position = UDim2.new(0.66,0,0,0)
    ServerPingLabel.BackgroundTransparency = 1; ServerPingLabel.Font = Enum.Font.GothamBold
    ServerPingLabel.TextScaled = true; ServerPingLabel.Text = "SP: 0"
    ServerPingLabel.TextColor3 = Color3.fromRGB(255,100,100); ServerPingLabel.Parent = StatsBG

    -- ✅ DRAG / SLIDER LOGIC
    local SliderActive = false
    VolBGMain.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType.Touch then SliderActive = true end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType.Touch then SliderActive = false end end)
    UserInputService.InputChanged:Connect(function(i)
        if SliderActive and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType.Touch) then
            local r = math.clamp((i.Position.X - VolBGMain.AbsolutePosition.X)/VolBGMain.AbsoluteSize.X,0,1)
            UpdateVolume(math.floor(r*VOLUME_MAX))
        end
    end)

    local Drag = {Active=false,X=0,Y=0,OX=0,OY=0}
    DragHandle.InputBegan:Connect(function(i)
        GuiFocused = true
        if Buttons_Locked then return end
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType.Touch then
            Drag.Active = true; Drag.X = i.Position.X; Drag.Y = i.Position.Y
            Drag.OX = MainFrame.Position.X.Offset; Drag.OY = MainFrame.Position.Y.Offset
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType.Touch then
            Drag.Active = false; task.delay(0.2,function() GuiFocused=false end)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if Drag.Active and not Buttons_Locked then
            MainFrame.Position = UDim2.new(0,Drag.OX + (i.Position.X - Drag.X),0,Drag.OY + (i.Position.Y - Drag.Y))
        end
    end)

    -- ✅ BUTTONS
    LockBtn.MouseButton1Click:Connect(function()
        Buttons_Locked = not Buttons_Locked
        LockBtn.Text = Buttons_Locked and "🔒 LOCKED" or "🔓 UNLOCK"
        LockBtn.BackgroundColor3 = Buttons_Locked and Color3.fromRGB(180,40,40) or Color3.fromRGB(50,50,50)
    end)

    MinBtn.MouseButton1Click:Connect(function()
        IsMinimized = not IsMinimized
        if IsMinimized then
            MainFrame.Size = MINI; ESPBtn.Visible=false; YouTubeBtn.Visible=false
            MusicBtn.Visible=false; LockBtn.Visible=false; ConsoleBtn.Visible=false
            ExitBtn.Visible=false; VolLabelMain.Visible=false; VolNumTextMain.Visible=false
            VolBGMain.Visible=false; StatsBG.Visible=false; DragHandle.Text="BLUE MODE"; MinBtn.Text="➕"
        else
            MainFrame.Size = FULL; ESPBtn.Visible=true; YouTubeBtn.Visible=true
            MusicBtn.Visible=true; LockBtn.Visible=true; ConsoleBtn.Visible=true
            ExitBtn.Visible=true; VolLabelMain.Visible=true; VolNumTextMain.Visible=true
            VolBGMain.Visible=true; StatsBG.Visible=true
            DragHandle.Text="🔵 BLUE MODE HUB | DRAG ME"; MinBtn.Text="➖"
        end
    end)

    ESPBtn.MouseButton1Click:Connect(function()
        ESP_Enabled = not ESP_Enabled
        ESPBtn.Text = ESP_Enabled and "ESP: ON" or "ESP: OFF"
        ESPBtn.BackgroundColor3 = ESP_Enabled and Color3.fromRGB(25,120,25) or Color3.fromRGB(40,40,40)
        if not ESP_Enabled then ClearAllESP() end
    end)

    YouTubeBtn.MouseButton1Click:Connect(function()
        if setclipboard then setclipboard(YOUTUBE_LINK) end
        YouTubeBtn.Text = "✅ COPIED!"; task.wait(1.5); YouTubeBtn.Text = "📺 YOUTUBE"
    end)

    MusicBtn.MouseButton1Click:Connect(ToggleBoomboxMenu)
    ConsoleBtn.MouseButton1Click:Connect(ToggleConsole)

    ExitBtn.MouseButton1Click:Connect(function()
        ShowExitConfirm(function()
            ESP_Enabled = false; ClearAllESP(); StopSound()
            if CurrentBoomboxUI then CurrentBoomboxUI:Destroy() end
            if CurrentConsoleUI then CurrentConsoleUI:Destroy() end
            MainUI:Destroy(); getgenv().BlueMode_Loaded = nil
        end)
    end)

    SetupDeathCheck()

    Players.PlayerAdded:Connect(function(P) P.CharacterAdded:Connect(function() task.wait(0.15) end) end)
    Players.PlayerRemoving:Connect(ClearAllESP)

    -- ✅ FPS COUNTER
    task.spawn(function()
        while task.wait() do
            local Now = os.clock()
            if Now-LastFPSUpdate >=1 then
                if FPSLabel then FPSLabel.Text = "FPS: "..FPSCounter end
                FPSCounter=0; LastFPSUpdate=Now
            end
            FPSCounter+=1
        end
    end)

    -- ✅ MAIN ESP LOOP — NO MORE BLOCK ON LOAD
    RunService.Heartbeat:Connect(function(Delta)
        -- ONLY SKIP IF CLEANING OR DISABLED — NOT ON STARTUP
        if CLEANUP_IN_PROGRESS or not ESP_Enabled then return end

        Hue = (Hue + Delta*0.5) %1
        local Rainbow = Color3.fromHSV(Hue,1,1)
        local Golden = Color3.fromRGB(255,215,0)
        for _,e in pairs(GuiElements) do e.Color = Rainbow end
        if VolFillMain then VolFillMain.BackgroundColor3 = Rainbow end
        if VolFillMenu then VolFillMenu.BackgroundColor3 = Rainbow end

        if PingLabel then PingLabel.Text = "PING: "..GetClientPing().."ms" end
        if ServerPingLabel then ServerPingLabel.Text = "SP: "..GetServerPing().."ms" end

        for _,P in pairs(Players:GetPlayers()) do
            if P==LocalPlayer or not P then continue end
            local Char = P.Character; if not Char then continue end
            local Hum = Char:FindFirstChild("Humanoid")
            if not Hum or Hum.Health<=0 then
                pcall(function()
                    while Char:FindFirstChild("BLUE_Outline") do Char.BLUE_Outline:Destroy() end
                    while Char:FindFirstChild("FriendRainbowDot") do Char.FriendRainbowDot:Destroy() end
                    while Char:FindFirstChild("GoldenOwnerDot") do Char.GoldenOwnerDot:Destroy() end
                end)
                continue
            end

            -- RAINBOW OUTLINE
            if not Char:FindFirstChild("BLUE_Outline") then
                local Out = Instance.new("Highlight")
                Out.Name = "BLUE_Outline"; Out.FillTransparency=0; Out.OutlineTransparency=0
                Out.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop; Out.Adornee=Char; Out.Parent=Char
            end
            Char.BLUE_Outline.FillColor = Rainbow
            Char.BLUE_Outline.OutlineColor = Rainbow

            local IsFriend = false; pcall(function() IsFriend = P:IsFriendsWith(LOCAL_USERID) end)
            local IsOwner = (P.UserId == OWNER_USERID)

            if IsOwner and IsFriend then
                while Char:FindFirstChild("OwnerCrown") do Char.OwnerCrown:Destroy() end
                if not Char:FindFirstChild("FriendRainbowDot") then
                    local Dot = Instance.new("BillboardGui")
                    Dot.Name = "FriendRainbowDot"; Dot.Size = UDim2.new(0,15,0,15)
                    Dot.StudsOffset = Vector3.new(1.5,1,0); Dot.AlwaysOnTop = true
                    local Fr = Instance.new("Frame")
                    Fr.Size = UDim2.new(1,0,1,0); Fr.BackgroundColor3 = Rainbow
                    Instance.new("UICorner",Fr).CornerRadius=UDim.new(1,0); Fr.Parent=Dot; Dot.Parent=Char.Head
                else
                    Char.FriendRainbowDot.Frame.BackgroundColor3 = Rainbow
                end
                if not Char:FindFirstChild("GoldenOwnerDot") then
                    local G = Instance.new("BillboardGui")
                    G.Name = "GoldenOwnerDot"; G.Size = UDim2.new(0,12,0,12)
                    G.StudsOffset = Vector3.new(0,3,0); G.AlwaysOnTop = true
                    local Fr = Instance.new("Frame")
                    Fr.Size = UDim2.new(1,0,1,0); Fr.BackgroundColor3 = Golden
                    Instance.new("UICorner",Fr).CornerRadius=UDim.new(1,0); Fr.Parent=G; G.Parent=Char.Head
                end
            elseif IsOwner then
                while Char:FindFirstChild("FriendRainbowDot") do Char.FriendRainbowDot:Destroy() end
                while Char:FindFirstChild("OwnerCrown") do Char.OwnerCrown:Destroy() end
                if not Char:FindFirstChild("GoldenOwnerDot") then
                    local G = Instance.new("BillboardGui")
                    G.Name = "GoldenOwnerDot"; G.Size = UDim2.new(0,12,0,12)
                    G.StudsOffset = Vector3.new(0,2.5,0); G.AlwaysOnTop = true
                    local Fr = Instance.new("Frame")
                    Fr.Size = UDim2.new(1,0,1,0); Fr.BackgroundColor3 = Golden
                    Instance.new("UICorner",Fr).CornerRadius=UDim.new(1,0); Fr.Parent=G; G.Parent=Char.Head
                end
            elseif IsFriend then
                while Char:FindFirstChild("GoldenOwnerDot") do Char.GoldenOwnerDot:Destroy() end
                while Char:FindFirstChild("OwnerCrown") do Char.OwnerCrown:Destroy() end
                if not Char:FindFirstChild("FriendRainbowDot") then
                    local Dot = Instance.new("BillboardGui")
                    Dot.Name = "FriendRainbowDot"; Dot.Size = UDim2.new(0,15,0,15)
                    Dot.StudsOffset = Vector3.new(1.5,1,0); Dot.AlwaysOnTop = true
                    local Fr = Instance.new("Frame")
                    Fr.Size = UDim2.new(1,0,1,0); Fr.BackgroundColor3 = Rainbow
                    Instance.new("UICorner",Fr).CornerRadius=UDim.new(1,0); Fr.Parent=Dot; Dot.Parent=Char.Head
                else
                    Char.FriendRainbowDot.Frame.BackgroundColor3 = Rainbow
                end
            else
                while Char:FindFirstChild("FriendRainbowDot") do Char.FriendRainbowDot:Destroy() end
                while Char:FindFirstChild("GoldenOwnerDot") do Char.GoldenOwnerDot:Destroy() end
                while Char:FindFirstChild("OwnerCrown") do Char.OwnerCrown:Destroy() end
            end
        end
    end)
end
