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
-- 🔵 BLUE MODE HUB | PART 2/2 | FINAL FIX V3
-- ✅ DOTS REMOVE 100% ON ESP OFF / EXIT
-- ✅ NO MORE REAPPEARING / STUCK DOTS
-- ✅ OWNER ID: 10820455655
-- ==============================================
function LoadMainHub()
    local MusicVolume = LoadData(SAVE_KEY_VOLUME, 500)
    local CurrentSound = nil
    local VolNumTextMain, VolFillMain, VolFillMenu, VolNumMenu, ESPBtn
    local FPSLabel, PingLabel, ServerPingLabel
    local ESP_Enabled = false
    local ESP_BLOCKED = true -- ✅ FULLY BLOCK ESP UNTIL READY
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

    -- ✅ ABSOLUTE FULL CLEANUP — NO LEFTOVERS ANYWHERE
    local function ClearAllESP()
        ESP_BLOCKED = true -- ✅ STOP ESP LOOP COMPLETELY
        task.wait(0.05)

        -- SWEEP EVERY PLAYER + ALL OLD CHARACTERS
        for _,P in pairs(Players:GetPlayers()) do
            if P then
                pcall(function()
                    local Targets = {P.Character}
                    for _, v in pairs(P:GetChildren()) do
                        if v:IsA("Model") and v:FindFirstChild("Humanoid") then
                            table.insert(Targets, v)
                        end
                    end

                    for _, Char in pairs(Targets) do
                        if Char then
                            -- DELETE ALL COPIES FOREVER
                            while Char:FindFirstChild("BLUE_Outline") do Char.BLUE_Outline:Destroy() end
                            while Char:FindFirstChild("FriendRainbowDot") do Char.FriendRainbowDot:Destroy() end
                            while Char:FindFirstChild("GoldenOwnerDot") do Char.GoldenOwnerDot:Destroy() end
                            while Char:FindFirstChild("OwnerCrown") do Char.OwnerCrown:Destroy() end

                            -- CATCH ANY HIDDEN/RENAMED VERSIONS
                            for _, Desc in pairs(Char:GetDescendants()) do
                                if Desc:IsA("BillboardGui") and (Desc.Name:find("Dot") or Desc.Name:find("Owner") or Desc.Name:find("Friend")) then
                                    Desc:Destroy()
                                end
                                if Desc:IsA("Highlight") and Desc.Name:find("Outline") then
                                    Desc:Destroy()
                                end
                            end
                        end
                    end
                end)
            end
        end

        -- ✅ CATCH DOTS STUCK OUTSIDE CHARACTERS
        for _, Gui in pairs(game:GetService("CoreGui"):GetChildren()) do
            if Gui.Name == "FriendRainbowDot" or Gui.Name == "GoldenOwnerDot" or Gui.Name == "BLUE_Outline" then
                Gui:Destroy()
            end
        end

        task.wait(0.05)
        ESP_BLOCKED = false
    end

    local function SetupDeathCheck()
        local function CheckCharacter(Char)
            if not Char then return end
            local Hum = Char:WaitForChild("Humanoid", 10)
            if not Hum then return end
            Hum.Died:Connect(function()
                pcall(function()
                    while Char:FindFirstChild("BLUE_Outline") do Char.BLUE_Outline:Destroy() end
                    while Char:FindFirstChild("FriendRainbowDot") do Char.FriendRainbowDot:Destroy() end
                    while Char:FindFirstChild("GoldenOwnerDot") do Char.GoldenOwnerDot:Destroy() end
                    while Char:FindFirstChild("OwnerCrown") do Char.OwnerCrown:Destroy() end
                end)
                if ESP_Enabled then
                    ESP_Enabled = false
                    if ESPBtn then
                        ESPBtn.Text = "ESP: OFF"
                        ESPBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
                    end
                    ClearAllESP()
                end
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

    -- [REST OF UI/BOOMBOX/CONSOLE CODE IS UNCHANGED — KEEP IT HERE]

    -- ✅ ESP TOGGLE — NOW FULLY BLOCKS BEFORE SWITCHING
    ESPBtn.MouseButton1Click:Connect(function()
        ESP_BLOCKED = true -- ✅ LOCK FIRST
        task.wait(0.02)
        ESP_Enabled = not ESP_Enabled
        ESPBtn.Text = ESP_Enabled and "ESP: ON" or "ESP: OFF"
        ESPBtn.TextColor3 = Color3.new(1,1,1)
        ESPBtn.BackgroundColor3 = ESP_Enabled and Color3.fromRGB(25,120,25) or Color3.fromRGB(40,40,40)
        if not ESP_Enabled then
            ClearAllESP() -- ✅ FULL WIPE
        else
            ESP_BLOCKED = false
        end
    end)

    -- ✅ EXIT BUTTON — FULL WIPE BEFORE DESTROY
    ExitBtn.MouseButton1Click:Connect(function()
        ShowExitConfirm(function()
            ESP_Enabled = false
            ClearAllESP() -- ✅ 100% WIPE ALL DOTS
            StopSound()
            if CurrentBoomboxUI then CurrentBoomboxUI:Destroy() end
            if CurrentConsoleUI then CurrentConsoleUI:Destroy() end
            MainUI:Destroy()
            getgenv().BlueMode_Loaded = nil
        end)
    end)

    SetupDeathCheck()

    Players.PlayerRemoving:Connect(function(OldPlayer)
        ClearAllESP() -- ✅ AUTO WIPE WHEN PLAYER LEAVES
    end)

    -- ✅ MAIN ESP LOOP — NOW FULLY LOCKED WHEN DISABLED
    RunService.Heartbeat:Connect(function(Delta)
        -- ✅ EXIT IMMEDIATELY IF DISABLED OR CLEANING
        if not MainUI or not MainUI.Parent or ESP_BLOCKED or not ESP_Enabled then return end

        Hue = (Hue + Delta * 0.5) % 1
        local Rainbow = Color3.fromHSV(Hue, 1, 1)
        local GoldenYellow = Color3.fromRGB(255, 215, 0)
        for _,e in pairs(GuiElements) do e.Color = Rainbow end
        if VolFillMain then VolFillMain.BackgroundColor3 = Rainbow end
        if VolFillMenu then VolFillMenu.BackgroundColor3 = Rainbow end

        if PingLabel then PingLabel.Text = "PING: "..GetClientPing().."ms" end
        if ServerPingLabel then ServerPingLabel.Text = "SP: "..GetServerPing().."ms" end

        for _,P in pairs(Players:GetPlayers()) do
            if P == LocalPlayer or not P then continue end
            local Char = P.Character
            if not Char then continue end
            local Hum = Char:FindFirstChild("Humanoid")
            if not Hum or Hum.Health <= 0 then
                pcall(function()
                    while Char:FindFirstChild("BLUE_Outline") do Char.BLUE_Outline:Destroy() end
                    while Char:FindFirstChild("FriendRainbowDot") do Char.FriendRainbowDot:Destroy() end
                    while Char:FindFirstChild("GoldenOwnerDot") do Char.GoldenOwnerDot:Destroy() end
                end)
                continue
            end

            -- Rainbow Outline
            if not Char:FindFirstChild("BLUE_Outline") then
                local Outline = Instance.new("Highlight")
                Outline.Name = "BLUE_Outline"
                Outline.FillTransparency = 0
                Outline.OutlineTransparency = 0
                Outline.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                Outline.Adornee = Char
                Outline.Parent = Char
            end
            Char.BLUE_Outline.FillColor = Rainbow
            Char.BLUE_Outline.OutlineColor = Rainbow

            local IsFriend = false
            pcall(function() IsFriend = P:IsFriendsWith(LOCAL_USERID) end)
            local IsOwner = (P.UserId == OWNER_USERID)

            -- Owner + Friend
            if IsOwner and IsFriend then
                while Char:FindFirstChild("OwnerCrown") do Char.OwnerCrown:Destroy() end
                if not Char:FindFirstChild("FriendRainbowDot") then
                    local Dot = Instance.new("BillboardGui")
                    Dot.Name = "FriendRainbowDot"
                    Dot.Size = UDim2.new(0,15,0,15)
                    Dot.StudsOffset = Vector3.new(1.5, 1, 0)
                    Dot.AlwaysOnTop = true
                    local DotFrame = Instance.new("Frame")
                    DotFrame.Size = UDim2.new(1,0,1,0)
                    DotFrame.BackgroundColor3 = Rainbow
                    Instance.new("UICorner", DotFrame).CornerRadius = UDim.new(1,0)
                    DotFrame.Parent = Dot
                    Dot.Parent = Char.Head
                else
                    Char.FriendRainbowDot.Frame.BackgroundColor3 = Rainbow
                end
                if not Char:FindFirstChild("GoldenOwnerDot") then
                    local Golden = Instance.new("BillboardGui")
                    Golden.Name = "GoldenOwnerDot"
                    Golden.Size = UDim2.new(0,12,0,12)
                    Golden.StudsOffset = Vector3.new(0, 3, 0)
                    Golden.AlwaysOnTop = true
                    local GoldenFrame = Instance.new("Frame")
                    GoldenFrame.Size = UDim2.new(1,0,1,0)
                    GoldenFrame.BackgroundColor3 = GoldenYellow
                    Instance.new("UICorner", GoldenFrame).CornerRadius = UDim.new(1,0)
                    GoldenFrame.Parent = Golden
                    Golden.Parent = Char.Head
                end
            -- Owner Only
            elseif IsOwner then
                while Char:FindFirstChild("FriendRainbowDot") do Char.FriendRainbowDot:Destroy() end
                while Char:FindFirstChild("OwnerCrown") do Char.OwnerCrown:Destroy() end
                if not Char:FindFirstChild("GoldenOwnerDot") then
                    local Golden = Instance.new("BillboardGui")
                    Golden.Name = "GoldenOwnerDot"
                    Golden.Size = UDim2.new(0,12,0,12)
                    Golden.StudsOffset = Vector3.new(0, 2.5, 0)
                    Golden.AlwaysOnTop = true
                    local GoldenFrame = Instance.new("Frame")
                    GoldenFrame.Size = UDim2.new(1,0,1,0)
                    GoldenFrame.BackgroundColor3 = GoldenYellow
                    Instance.new("UICorner", GoldenFrame).CornerRadius = UDim.new(1,0)
                    GoldenFrame.Parent = Golden
                    Golden.Parent = Char.Head
                end
            -- Friend Only
            elseif IsFriend then
                while Char:FindFirstChild("GoldenOwnerDot") do Char.GoldenOwnerDot:Destroy() end
                while Char:FindFirstChild("OwnerCrown") do Char.OwnerCrown:Destroy() end
                if not Char:FindFirstChild("FriendRainbowDot") then
                    local Dot = Instance.new("BillboardGui")
                    Dot.Name = "FriendRainbowDot"
                    Dot.Size = UDim2.new(0,15,0,15)
                    Dot.StudsOffset = Vector3.new(1.5, 1, 0)
                    Dot.AlwaysOnTop = true
                    local DotFrame = Instance.new("Frame")
                    DotFrame.Size = UDim2.new(1,0,1,0)
                    DotFrame.BackgroundColor3 = Rainbow
                    Instance.new("UICorner", DotFrame).CornerRadius = UDim.new(1,0)
                    DotFrame.Parent = Dot
                    Dot.Parent = Char.Head
                else
                    Char.FriendRainbowDot.Frame.BackgroundColor3 = Rainbow
                end
            -- Others
            else
                while Char:FindFirstChild("FriendRainbowDot") do Char.FriendRainbowDot:Destroy() end
                while Char:FindFirstChild("GoldenOwnerDot") do Char.GoldenOwnerDot:Destroy() end
                while Char:FindFirstChild("OwnerCrown") do Char.OwnerCrown:Destroy() end
            end
        end
    end)

    ESP_BLOCKED = false -- ✅ UNLOCK AFTER FULLY LOADED
end
