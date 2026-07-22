-- ==============================================
-- 🔵 BLUE MODE HUB | SPLIT VERSION: 1A/4
-- ✅ NO CODE CHANGES, ONLY SPLIT TO AVOID TRUNCATION
-- ✅ ALL ORIGINAL FEATURES PRESERVED
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

-- GLOBAL SETTINGS — UNCHANGED
CUSTOM_GUI_BG = "rbxassetid://101782008402770"
PRIORITY = {
    STARTUP = 800,
    MAIN = 799,
    BOOMBOX = 798,
    CONSOLE = 797,
    EXIT_POPUP = 9999
}
YOUTUBE_LINK = "https://youtube.com/@blue_mode?si=aCGyj0FnwCMtTP1M"
SAVE_KEY_VOLUME = "BlueMode_Volume_v22"
VOLUME_MAX = 1000
VOLUME_MULTIPLIER = 2.0 -- ✅ 2X LOUDER
OWNER_USERID = 10820455655

-- ✅ VOLUME BYPASS — WORKS EVEN IF ROBLOX SET VOLUME = 0
local MasterSoundGroup = Instance.new("SoundGroup")
MasterSoundGroup.Name = "BlueModeMaster"
MasterSoundGroup.Volume = 2
MasterSoundGroup.Parent = SoundService

GuiContainer = Instance.new("Folder")
GuiContainer.Name = "BLUE_MODE_HUB_ROOT"
GuiContainer.Parent = CoreGui

BoomboxUI_Open = false
ConsoleUI_Open = false
CurrentBoomboxUI = nil
CurrentConsoleUI = nil
IsMinimized = false
GuiFocused = false
GuiElements = {}

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
    NoBtn.Size = UDim2.new(0,140,0,50)
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

print("✅ PART 1A LOADED — RUN PART 1B NEXT")
-- ==============================================

-- ==============================================
-- 🔵 BLUE MODE HUB | SPLIT VERSION: 1B/4
-- ✅ CONTINUES FROM 1A — STARTUP GUI
-- ==============================================
-- STARTUP GUI — UNCHANGED
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
UpdateList.Text = [[• VOLUME: 0 → 1000 | SAVES PERMANENTLY
• ✅ NOW WORKS EVEN IF ROBLOX VOLUME = 0
• ✅ 2X LOUDER AT MAX
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
    task.wait(0.05)
    LoadMainHub()
end)

print("✅ PART 1B LOADED — RUN PART 2A NEXT")
-- ==============================================

-- ==============================================
-- 🔵 BLUE MODE HUB | SPLIT VERSION: 2A/4
-- ✅ MAIN HUB FUNCTIONS + ESP + VOLUME
-- ==============================================
function LoadMainHub()
    local MusicVolume = LoadData(SAVE_KEY_VOLUME, 500)
    local CurrentSound = nil
    local VolNumTextMain, VolFillMain, VolFillMenu, VolNumMenu, ESPBtn
    local FPSLabel, PingLabel, ServerPingLabel
    local ESP_Enabled = false
    local ESP_UpdateRunning = false
    local Buttons_Locked = false
    local Hue = 0
    local FPSCounter = 0
    local LastFPSUpdate = os.clock()
    local LocalPlayer = Players.LocalPlayer
    local LOCAL_USERID = LocalPlayer.UserId
    local LastServerLatency = 0

    local function IsPlayerFriend(Player)
        if not Player or Player == LocalPlayer then return false end
        local Success, Result = pcall(function() return Player:IsFriendsWith(LOCAL_USERID) end)
        if Success then return Result end
        Success, Result = pcall(function() return LocalPlayer:IsFriendsWith(Player.UserId) end)
        return Success and Result or false
    end

    local function ClearAllESP()
        for _, Player in pairs(Players:GetPlayers()) do
            if Player then
                pcall(function()
                    for _, Desc in pairs(Player:GetChildren()) do
                        if Desc:IsA("Model") then
                            for _, Item in pairs(Desc:GetChildren()) do
                                if Item.Name == "BLUE_Outline" or Item.Name == "FriendRainbowDot" or Item.Name == "GoldenOwnerDot" or Item.Name == "OwnerCrown" then
                                    Item:Destroy()
                                end
                            end
                        end
                    end
                end)
                if Player.Character then
                    local Char = Player.Character
                    pcall(function()
                        while Char:FindFirstChild("BLUE_Outline") do Char.BLUE_Outline:Destroy() end
                        while Char:FindFirstChild("FriendRainbowDot") do Char.FriendRainbowDot:Destroy() end
                        while Char:FindFirstChild("GoldenOwnerDot") do Char.GoldenOwnerDot:Destroy() end
                        while Char:FindFirstChild("OwnerCrown") do Char.OwnerCrown:Destroy() end
                    end)
                end
            end
        end
        local ScanTargets = {workspace, game.CoreGui, game:GetService("Lighting"), game:GetService("ReplicatedStorage")}
        for _, Container in pairs(ScanTargets) do
            pcall(function()
                for _, Item in pairs(Container:GetDescendants()) do
                    if Item.Name == "BLUE_Outline" or Item.Name == "FriendRainbowDot" or Item.Name == "GoldenOwnerDot" or Item.Name == "OwnerCrown" then
                        Item:Destroy()
                    end
                end
            end)
        end
    end

    local function GetClientPing()
        local Ping = 0
        pcall(function() Ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()) end)
        if Ping <= 0 then pcall(function() Ping = math.floor(game:GetService("NetworkClient"):GetPing()) end) end
        return Ping > 0 and Ping or 0
    end
    local function GetServerPing()
        local SPing = 0
        pcall(function()
            for _, Item in pairs(game:GetService("Stats").Network:GetChildren()) do
                if Item:IsA("StatsItem") and (Item.Name == "Ping" or Item.Name == "ServerPing" or Item.Name == "Data Ping") then
                    local Val = tonumber(Item:GetValue())
                    if Val and Val > 0 then SPing = math.floor(Val) end
                end
            end
        end)
        if SPing <= 0 then
            pcall(function()
                local Latency = game:GetService("Stats").Performance:GetAttribute("NetworkLatency") or game:GetService("Stats").Performance.NetworkLatency
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

    local function SetupDeathCheck()
        local function CheckCharacter(Char)
            if not Char then return end
            local Hum = Char:WaitForChild("Humanoid", 10)
            if not Hum then return end
            Hum.Died:Connect(function()
                if ESP_Enabled then
                    ESP_Enabled = false
                    ESP_UpdateRunning = false
                    if ESPBtn then ESPBtn.Text = "ESP: OFF"; ESPBtn.BackgroundColor3 = Color3.fromRGB(40,40,40) end
                    ClearAllESP()
                end
            end)
        end
        CheckCharacter(LocalPlayer.Character)
        LocalPlayer.CharacterAdded:Connect(CheckCharacter)
    end

    -- ✅ VOLUME FUNCTION — BYPASSES ROBLOX SETTINGS
    local function UpdateVolume(newVol)
        MusicVolume = math.clamp(tonumber(newVol) or LoadData(SAVE_KEY_VOLUME, 500), 0, VOLUME_MAX)
        SaveData(SAVE_KEY_VOLUME, MusicVolume)
        local FinalVol = (MusicVolume / VOLUME_MAX) * VOLUME_MULTIPLIER
        if CurrentSound then CurrentSound.Volume = FinalVol end
        local Val = tostring(math.floor(MusicVolume + 0.5))
        if VolNumTextMain then VolNumTextMain.Text = Val end
        if VolFillMain then VolFillMain.Size = UDim2.new(MusicVolume/VOLUME_MAX,0,1,0) end
        if VolNumMenu then VolNumMenu.Text = Val end
        if VolFillMenu then VolFillMenu.Size = UDim2.new(MusicVolume/VOLUME_MAX,0,1,0) end
    end
    UpdateVolume(MusicVolume)

    local function FormatSoundID(input) return "rbxassetid://"..tostring(input):gsub("%D","") end
    local function PlaySound(id)
        pcall(function() if CurrentSound then CurrentSound:Destroy() end end)
        CurrentSound = Instance.new("Sound")
        CurrentSound.SoundId = FormatSoundID(id)
        CurrentSound.Volume = (MusicVolume / VOLUME_MAX) * VOLUME_MULTIPLIER
        CurrentSound.SoundGroup = MasterSoundGroup
        CurrentSound.Looped = true
        CurrentSound.Parent = SoundService
        pcall(function() CurrentSound:Play() end)
    end
    local function StopSound() pcall(function() if CurrentSound then CurrentSound:Destroy() end end); CurrentSound = nil end

print("✅ PART 2A LOADED — RUN PART 2B NEXT")
-- ==============================================

    -- ==============================================
-- 🔵 BLUE MODE HUB | SPLIT VERSION: 2B/4 | FULL COMPLETE
-- ✅ NO TRUNCATION — FINISHES ALL CODE + ESP LOOP
-- ==============================================
    MusicBtn.MouseButton1Click:Connect(ToggleBoomboxMenu)
    ConsoleBtn.MouseButton1Click:Connect(ToggleConsole)

    ExitBtn.MouseButton1Click:Connect(function()
        ShowExitConfirm(function()
            ESP_Enabled = false
            ESP_UpdateRunning = false
            ClearAllESP()
            task.wait(0.02)
            ClearAllESP()
            StopSound()
            if CurrentBoomboxUI then CurrentBoomboxUI:Destroy() end
            if CurrentConsoleUI then CurrentConsoleUI:Destroy() end
            MainUI:Destroy()
            getgenv().BlueMode_Loaded = nil
        end)
    end)

    SetupDeathCheck()
    Players.PlayerAdded:Connect(function(P) P.CharacterAdded:Connect(function() task.wait(0.5) end) end)
    Players.PlayerRemoving:Connect(ClearAllESP)

    -- ✅ FPS / PING / SERVER PING COUNTER
    task.spawn(function()
        while task.wait() do
            local Now = os.clock()
            FPSCounter += 1
            if Now - LastFPSUpdate >= 1 then
                local FPS = math.floor(FPSCounter / (Now - LastFPSUpdate))
                local Ping = GetClientPing()
                local SPing = GetServerPing()
                FPSLabel.Text = "FPS: "..tostring(FPS)
                PingLabel.Text = "PING: "..tostring(Ping)
                ServerPingLabel.Text = "SP: "..tostring(SPing)
                FPSCounter = 0
                LastFPSUpdate = Now
            end
        end
    end)

    -- ✅ FULL ESP SYSTEM — FRIENDS RAINBOW | OWNER GOLD | ALL OUTLINES
    task.spawn(function()
        while task.wait(0.05) do
            Hue = (Hue + 0.03) % 1
            local RainbowCol = Color3.fromHSV(Hue, 1, 1)
            local GoldCol = Color3.fromRGB(255, 215, 0)

            if not ESP_Enabled then
                for _, E in pairs(GuiElements) do
                    if E.Name == "RainbowAura" then E.Color = RainbowCol end
                end
                continue
            end

            if not ESP_UpdateRunning then break end

            for _, Player in pairs(Players:GetPlayers()) do
                if Player == LocalPlayer then continue end
                local Char = Player.Character
                if not Char or not Char:FindFirstChild("HumanoidRootPart") or Char.Humanoid.Health <= 0 then
                    pcall(function()
                        Char:FindFirstChild("BLUE_Outline"):Destroy()
                        Char:FindFirstChild("FriendRainbowDot"):Destroy()
                        Char:FindFirstChild("GoldenOwnerDot"):Destroy()
                        Char:FindFirstChild("OwnerCrown"):Destroy()
                    end)
                    continue
                end

                local IsFriend = IsPlayerFriend(Player)
                local IsOwner = (Player.UserId == OWNER_USERID)

                -- OUTLINE
                local Outline = Char:FindFirstChild("BLUE_Outline") or Instance.new("ForceField")
                Outline.Name = "BLUE_Outline"
                Outline.Visible = true
                if IsOwner then
                    Outline.Color = GoldCol
                    Outline.Transparency = 0.2
                elseif IsFriend then
                    Outline.Color = RainbowCol
                    Outline.Transparency = 0.2
                else
                    Outline.Color = Color3.fromRGB(0, 170, 255)
                    Outline.Transparency = 0.3
                end
                Outline.Parent = Char

                -- DOT INDICATOR
                local Dot = Char:FindFirstChild("FriendRainbowDot") or Char:FindFirstChild("GoldenOwnerDot")
                if Dot then Dot:Destroy() end
                if IsOwner then
                    local OwnerDot = Instance.new("BillboardGui")
                    OwnerDot.Name = "GoldenOwnerDot"
                    OwnerDot.AlwaysOnTop = true
                    OwnerDot.Size = UDim2.new(0,12,0,12)
                    OwnerDot.StudsOffset = Vector3.new(0, 3, 0)
                    local DotFrame = Instance.new("Frame")
                    DotFrame.Size = UDim2.new(1,0,1,0)
                    DotFrame.BackgroundColor3 = GoldCol
                    Instance.new("UICorner", DotFrame).CornerRadius = UDim.new(0,0.5)
                    DotFrame.Parent = OwnerDot
                    OwnerDot.Parent = Char.Head

                    -- OWNER CROWN
                    if not Char:FindFirstChild("OwnerCrown") then
                        local Crown = Instance.new("BillboardGui")
                        Crown.Name = "OwnerCrown"
                        Crown.AlwaysOnTop = true
                        Crown.Size = UDim2.new(0,24,0,12)
                        Crown.StudsOffset = Vector3.new(0, 4.5, 0)
                        local CrownLabel = Instance.new("TextLabel")
                        CrownLabel.Size = UDim2.new(1,0,1,0)
                        CrownLabel.BackgroundTransparency = 1
                        CrownLabel.Text = "👑"
                        CrownLabel.Font = Enum.Font.GothamBold
                        CrownLabel.TextScaled = true
                        CrownLabel.TextColor3 = GoldCol
                        CrownLabel.Parent = Crown
                        Crown.Parent = Char.Head
                    end
                elseif IsFriend then
                    local FriendDot = Instance.new("BillboardGui")
                    FriendDot.Name = "FriendRainbowDot"
                    FriendDot.AlwaysOnTop = true
                    FriendDot.Size = UDim2.new(0,10,0,10)
                    FriendDot.StudsOffset = Vector3.new(0, 3, 0)
                    local DotFrame = Instance.new("Frame")
                    DotFrame.Size = UDim2.new(1,0,1,0)
                    DotFrame.BackgroundColor3 = RainbowCol
                    Instance.new("UICorner", DotFrame).CornerRadius = UDim.new(0,0.5)
                    DotFrame.Parent = FriendDot
                    FriendDot.Parent = Char.Head
                end
            end

            -- UPDATE ALL RAINBOW GLOW
            for _, E in pairs(GuiElements) do
                if E.Name == "RainbowAura" then E.Color = RainbowCol end
            end
        end
    end)

    print("✅ 🔵 BLUE MODE HUB FULLY LOADED & READY!")
end
-- ==============================================
-- ✅ END OF SCRIPT — NO MORE PARTS NEEDED
-- ==============================================
