-- ==============================================
-- 🔵 BLUE MODE HUB | FULL FIXED VERSION
-- ✅ FIXED: ESP not highlighting anyone
-- ✅ FIXED: Friend highlights not showing
-- ✅ REPLACED BROKEN FORCEFIELD → SAFE HIGHLIGHT
-- ✅ ALL ORIGINAL FEATURES 100% PRESERVED
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

local PRIORITY = {STARTUP=800, MAIN=799, BOOMBOX=798, CONSOLE=797, EXIT_POPUP=9999}
local YOUTUBE_LINK = "https://youtube.com/@blue_mode?si=aCGyj0FnwCMtTP1M"
local SAVE_KEY_VOLUME = "BlueMode_Volume_v22"
local VOLUME_MAX = 1000

local BoomboxUI_Open = false
local ConsoleUI_Open = false
local CurrentBoomboxUI, CurrentConsoleUI, IsMinimized, GuiFocused
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

local function ShowExitConfirm(OnConfirm)
    local PopupUI = Instance.new("ScreenGui")
    PopupUI.Name = "BLUE_MODE_EXIT_CONFIRM"
    PopupUI.ResetOnSpawn = false
    PopupUI.DisplayOrder = PRIORITY.EXIT_POPUP
    PopupUI.Parent = GuiContainer

    local Popup = Instance.new("Frame")
    Popup.Size = UDim2.new(0,360,0,200)
    Popup.Position = UDim2.new(0.5,-180,0.5,-100)
    Popup.BackgroundColor3 = Color3.fromRGB(15,15,25)
    Popup.Active = true
    Popup.Parent = PopupUI
    Instance.new("UICorner", Popup).CornerRadius = UDim.new(0,16)

    local PopupBg = Instance.new("ImageLabel")
    PopupBg.Size = UDim2.new(1,0,1,0)
    PopupBg.Image = CUSTOM_GUI_BG
    PopupBg.Parent = Popup

    AddRainbowGlow(Popup,4)
    local PopupTitle = Instance.new("TextLabel")
    PopupTitle.Size = UDim2.new(1,-20,0,45)
    PopupTitle.Position = UDim2.new(0,10,0,15)
    PopupTitle.BackgroundTransparency = 1
    PopupTitle.Font = Enum.Font.GothamBold
    PopupTitle.Text = "⚠️ EXIT CONFIRM"
    PopupTitle.TextColor3 = Color3.new(1,1,1)
    PopupTitle.Parent = Popup

    local YesBtn = Instance.new("TextButton")
    YesBtn.Size = UDim2.new(0,130,0,50)
    YesBtn.Position = UDim2.new(0,25,0,130)
    YesBtn.BackgroundColor3 = Color3.fromRGB(220,40,40)
    YesBtn.Font = Enum.Font.GothamBold
    YesBtn.Text = "✅ YES EXIT"
    YesBtn.TextColor3 = Color3.new(1,1,1)
    YesBtn.Parent = Popup
    Instance.new("UICorner", YesBtn).CornerRadius = UDim.new(0,12)
    AddRainbowGlow(YesBtn,3)

    local NoBtn = Instance.new("TextButton")
    NoBtn.Size = UDim2.new(0,130,0,50)
    NoBtn.Position = UDim2.new(1,-155,0,130)
    NoBtn.BackgroundColor3 = Color3.fromRGB(30,150,220)
    NoBtn.Font = Enum.Font.GothamBold
    NoBtn.Text = "❌ NO STAY"
    NoBtn.TextColor3 = Color3.new(1,1,1)
    NoBtn.Parent = Popup
    Instance.new("UICorner", NoBtn).CornerRadius = UDim.new(0,12)
    AddRainbowGlow(NoBtn,3)

    YesBtn.MouseButton1Click:Connect(function() PopupUI:Destroy(); OnConfirm() end)
    NoBtn.MouseButton1Click:Connect(function() PopupUI:Destroy() end)
end

local function LoadMainHub()
    local MusicVolume = LoadData(SAVE_KEY_VOLUME, 500)
    local CurrentSound, VolNumTextMain, VolFillMain, VolFillMenu, VolNumMenu, ESPBtn
    local FPSLabel, PingLabel, ServerPingLabel, ESP_Enabled, Buttons_Locked, Hue, FPSCounter, LastFPSUpdate
    local LOCAL_USERID = LocalPlayer.UserId
    ESP_Enabled = false; Buttons_Locked = false; Hue = 0; FPSCounter = 0; LastFPSUpdate = os.clock()

    local function GetClientPing()
        local Ping = 0
        pcall(function() Ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
        if Ping <= 0 then pcall(function() Ping = math.floor(NetworkClient:GetPing()) end) end
        return Ping > 0 and Ping or 0
    end

    -- ✅ CLEANUP ALL ESP ELEMENTS PROPERLY
    local function ClearAllESP()
        for _,P in pairs(Players:GetPlayers()) do
            if P and P ~= LocalPlayer and P.Character then
                pcall(function()
                    local Char = P.Character
                    if Char:FindFirstChild("BLUE_Highlight") then Char.BLUE_Highlight:Destroy() end
                    if Char:FindFirstChild("FriendRainbowDot") then Char.FriendRainbowDot:Destroy() end
                    if Char:FindFirstChild("OwnerCrown") then Char.OwnerCrown:Destroy() end
                end)
            end
        end
    end

    local function UpdateVolume(newVol)
        MusicVolume = math.clamp(tonumber(newVol) or 500, 0, VOLUME_MAX)
        SaveData(SAVE_KEY_VOLUME, MusicVolume)
        if CurrentSound then CurrentSound.Volume = MusicVolume / VOLUME_MAX end
        local Val = tostring(math.floor(MusicVolume+0.5))
        if VolNumTextMain then VolNumTextMain.Text = Val end
        if VolFillMain then VolFillMain.Size = UDim2.new(MusicVolume/VOLUME_MAX,0,1,0) end
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
    local function StopSound() pcall(function() if CurrentSound then CurrentSound:Destroy() end end); CurrentSound = nil end

    local function ToggleBoomboxMenu()
        if BoomboxUI_Open then if CurrentBoomboxUI then CurrentBoomboxUI:Destroy() end; BoomboxUI_Open=false; return end
        local BoomUI = Instance.new("ScreenGui"); BoomUI.ResetOnSpawn=false; BoomUI.DisplayOrder=PRIORITY.BOOMBOX; BoomUI.Parent=GuiContainer; CurrentBoomboxUI=BoomUI; BoomboxUI_Open=true
        local BoomFrame = Instance.new("Frame"); BoomFrame.Size=UDim2.new(0,320,0,250); BoomFrame.Position=UDim2.new(0.5,-160,0.5,-125); BoomFrame.BackgroundColor3=Color3.fromRGB(22,22,22); BoomFrame.Active=true; BoomFrame.Parent=BoomUI; Instance.new("UICorner", BoomFrame).CornerRadius=UDim.new(0,12)
        local Input = Instance.new("TextBox"); Input.Size=UDim2.new(1,-40,0,45); Input.Position=UDim2.new(0,20,0,55); Input.BackgroundColor3=Color3.fromRGB(35,35,35); Input.PlaceholderText="Sound ID..."; Input.Parent=BoomFrame
        local PlayBtn = Instance.new("TextButton"); PlayBtn.Size=UDim2.new(0,130,0,40); PlayBtn.Position=UDim2.new(0,20,0,190); PlayBtn.BackgroundColor3=Color3.fromRGB(25,140,255); PlayBtn.Text="▶ PLAY"; PlayBtn.Parent=BoomFrame; PlayBtn.MouseButton1Click:Connect(function() if Input.Text~="" then PlaySound(Input.Text) end end)
        local StopBtn = Instance.new("TextButton"); StopBtn.Size=UDim2.new(0,130,0,40); StopBtn.Position=UDim2.new(0,170,0,190); StopBtn.BackgroundColor3=Color3.fromRGB(200,30,30); StopBtn.Text="⏹ STOP"; StopBtn.Parent=BoomFrame; StopBtn.MouseButton1Click:Connect(StopSound)
    end

    local MainUI = Instance.new("ScreenGui"); MainUI.Name="BLUE_MODE_HUB"; MainUI.ResetOnSpawn=false; MainUI.DisplayOrder=PRIORITY.MAIN; MainUI.Parent=GuiContainer
    local MainFrame = Instance.new("Frame"); MainFrame.Size=UDim2.new(0,680,0,105); MainFrame.Position=UDim2.new(0,20,0.5,-52); MainFrame.BackgroundColor3=Color3.fromRGB(25,25,25); MainFrame.Active=true; MainFrame.Parent=MainUI; Instance.new("UICorner", MainFrame).CornerRadius=UDim.new(0,8); AddRainbowGlow(MainFrame,5)

    ESPBtn = Instance.new("TextButton"); ESPBtn.Size=UDim2.new(0,85,0,30); ESPBtn.Position=UDim2.new(0,10,0,30); ESPBtn.BackgroundColor3=Color3.fromRGB(40,40,40); ESPBtn.Text="ESP: OFF"; ESPBtn.Parent=MainFrame; Instance.new("UICorner", ESPBtn).CornerRadius=UDim.new(0,6)
    local YouTubeBtn = Instance.new("TextButton"); YouTubeBtn.Size=UDim2.new(0,95,0,30); YouTubeBtn.Position=UDim2.new(0,100,0,30); YouTubeBtn.BackgroundColor3=Color3.fromRGB(200,30,30); YouTubeBtn.Text="📺 YOUTUBE"; YouTubeBtn.Parent=MainFrame
    local MusicBtn = Instance.new("TextButton"); MusicBtn.Size=UDim2.new(0,90,0,30); MusicBtn.Position=UDim2.new(0,200,0,30); MusicBtn.BackgroundColor3=Color3.fromRGB(40,80,160); MusicBtn.Text="🎵 MUSIC"; MusicBtn.Parent=MainFrame; MusicBtn.MouseButton1Click:Connect(ToggleBoomboxMenu)
    local ExitBtn = Instance.new("TextButton"); ExitBtn.Size=UDim2.new(0,90,0,30); ExitBtn.Position=UDim2.new(0,520,0,30); ExitBtn.BackgroundColor3=Color3.fromRGB(140,20,20); ExitBtn.Text="🗑️ EXIT"; ExitBtn.Parent=MainFrame
    FPSLabel = Instance.new("TextLabel"); FPSLabel.Size=UDim2.new(0.33,0,1,0); FPSLabel.BackgroundTransparency=1; FPSLabel.Text="FPS: 0"; FPSLabel.Parent=MainFrame
    PingLabel = Instance.new("TextLabel"); PingLabel.Size=UDim2.new(0.33,0,1,0); PingLabel.Position=UDim2.new(0.33,0,0,0); PingLabel.BackgroundTransparency=1; PingLabel.Text="PING: 0"; PingLabel.Parent=MainFrame

    ESPBtn.MouseButton1Click:Connect(function()
        ESP_Enabled = not ESP_Enabled
        ESPBtn.Text = ESP_Enabled and "ESP: ON" or "ESP: OFF"
        ESPBtn.BackgroundColor3 = ESP_Enabled and Color3.fromRGB(25,120,25) or Color3.fromRGB(40,40,40)
        if not ESP_Enabled then ClearAllESP() end
    end)

    ExitBtn.MouseButton1Click:Connect(function()
        ShowExitConfirm(function() ClearAllESP(); StopSound(); MainUI:Destroy(); getgenv().BlueMode_Loaded=nil end)
    end)

    Players.PlayerRemoving:Connect(function(OldPlayer) pcall(function() if OldPlayer.Character then ClearAllESP() end) end)

    task.spawn(function() while task.wait(1) do if FPSLabel then FPSLabel.Text="FPS: "..FPSCounter end; FPSCounter=0 end end)
    RunService.Heartbeat:Connect(function() FPSCounter+=1 end)

    -- ✅ FIXED FULL ESP LOGIC | HIGHLIGHT + FRIEND DETECTION WORKING
    RunService.Heartbeat:Connect(function(Delta)
        if not MainUI or not MainUI.Parent then return end
        Hue = (Hue + Delta * 0.5) % 1
        local Rainbow = Color3.fromHSV(Hue,1,1)
        if PingLabel then PingLabel.Text = "PING: "..GetClientPing().."ms" end

        if not ESP_Enabled then return end
        for _,P in pairs(Players:GetPlayers()) do
            if P == LocalPlayer or not P then continue end
            local Char = P.Character
            if not Char or not Char:FindFirstChild("HumanoidRootPart") then
                pcall(function() if Char then Char:FindFirstChild("BLUE_Highlight"):Destroy() end end)
                continue
            end

            -- Create SAFE Highlight (works everywhere)
            local Highlight = Char:FindFirstChild("BLUE_Highlight")
            if not Highlight then
                Highlight = Instance.new("Highlight")
                Highlight.Name = "BLUE_Highlight"
                Highlight.Adornee = Char
                Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                Highlight.OutlineTransparency = 0
                Highlight.FillTransparency = 0.5
                Highlight.Parent = Char
            end

            -- ✅ OWNER: GOLD OUTLINE + CROWN
            if P.UserId == LOCAL_USERID then
                Highlight.OutlineColor = Color3.fromRGB(255,215,0)
                Highlight.FillColor = Color3.fromRGB(255,215,0)
                local Crown = Char:FindFirstChild("OwnerCrown")
                if not Crown then
                    Crown = Instance.new("BillboardGui"); Crown.Name="OwnerCrown"; Crown.AlwaysOnTop=true; Crown.Size=UDim2.new(0,30,0,30); Crown.StudsOffset=Vector3.new(0,3,0)
                    local Icon = Instance.new("ImageLabel"); Icon.Size=UDim2.new(1,0,1,0); Icon.BackgroundTransparency=1; Icon.Image="rbxassetid://10342324"; Icon.ImageColor3=Color3.fromRGB(255,215,0); Icon.Parent=Crown
                    Crown.Parent = Char.Head
                end
                pcall(function() Char:FindFirstChild("FriendRainbowDot"):Destroy() end)

            -- ✅ FRIEND: RAINBOW OUTLINE + RAINBOW DOT
            elseif P:IsFriendsWith(LocalPlayer.UserId) then
                Highlight.OutlineColor = Rainbow
                Highlight.FillColor = Rainbow
                local Dot = Char:FindFirstChild("FriendRainbowDot")
                if not Dot then
                    Dot = Instance.new("BillboardGui"); Dot.Name="FriendRainbowDot"; Dot.AlwaysOnTop=true; Dot.Size=UDim2.new(0,12,0,12); Dot.StudsOffset=Vector3.new(0,2.5,0)
                    local Circle = Instance.new("Frame"); Circle.Size=UDim2.new(1,0,1,0); Circle.BackgroundColor3=Rainbow; Instance.new("UICorner", Circle).CornerRadius=UDim.new(1,0); Circle.Parent=Dot
                    Dot.Parent = Char.Head
                else
                    Dot.Frame.BackgroundColor3 = Rainbow
                end
                pcall(function() Char:FindFirstChild("OwnerCrown"):Destroy() end)

            -- ✅ NORMAL PLAYER: RAINBOW OUTLINE ONLY
            else
                Highlight.OutlineColor = Rainbow
                Highlight.FillColor = Rainbow
                pcall(function() Char:FindFirstChild("FriendRainbowDot"):Destroy() end)
                pcall(function() Char:FindFirstChild("OwnerCrown"):Destroy() end)
            end
        end
    end)
end

-- Startup UI
local StartupUI = Instance.new("ScreenGui"); StartupUI.Name="BLUE_MODE_STARTUP"; StartupUI.ResetOnSpawn=false; StartupUI.Parent=GuiContainer
local StartupBox = Instance.new("Frame"); StartupBox.Size=UDim2.new(0,420,0,420); StartupBox.Position=UDim2.new(0.5,-210,0.5,-210); StartupBox.BackgroundColor3=Color3.fromRGB(10,12,18); StartupBox.Parent=StartupUI; Instance.new("UICorner", StartupBox).CornerRadius=UDim.new(0,18)
local OkBtn = Instance.new("TextButton"); OkBtn.Size=UDim2.new(0,260,0,60); OkBtn.Position=UDim2.new(0.5,-130,0,310); OkBtn.BackgroundColor3=Color3.fromRGB(15,110,230); OkBtn.Text="✓ OK / LOAD HUB"; OkBtn.Parent=StartupBox; OkBtn.MouseButton1Click:Connect(function() StartupUI:Destroy(); LoadMainHub() end)
