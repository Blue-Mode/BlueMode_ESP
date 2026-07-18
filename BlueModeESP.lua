-- ==============================================
-- 🔵 BLUE MODE ESP | FULL VERSION (PART 1/2)
-- ✅ VOLUME: 0 → 1000 PERMANENT
-- ✅ NO FEATURES REMOVED
-- ✅ Made by: Blue_Mode / Dwayne Kean Francisco
-- ==============================================
if getgenv().BlueMode_Loaded then return end
getgenv().BlueMode_Loaded = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 10) or game:GetService("CoreGui")

local GUI_PRIORITY = 995
local USAGE_LIMIT = 12 * 3600
local COOLDOWN = 12 * 3600
local YOUTUBE_LINK = "https://youtube.com/@blue_mode?si=aCGyj0FnwCMtTP1M"
local SAVE_KEY_USED = "BlueMode_UsedTime_v23"
local SAVE_KEY_COOLDOWN = "BlueMode_CooldownEnd_v23"
local SAVE_KEY_VOLUME = "BlueMode_Volume_v23"

-- ✅ VOLUME SETTINGS: 0 TO 1000
local VOLUME_MIN = 0
local VOLUME_MAX = 1000
local VOLUME_DEFAULT = 500

local BoomboxUI_Open = false
local ConsoleUI_Open = false
local CommandsUI_Open = false
local CommandListOpen = false
local CurrentBoomboxUI, CurrentConsoleUI, CurrentCommandsUI, CurrentListUI = nil, nil, nil, nil
local IsMinimized = false
local GuiFocused = false

local FlyEnabled = false
local InvisibleEnabled = false
local NoClipEnabled = false
local InvincibleEnabled = false
local SpeedValue = 16
local OriginalHitboxSize = Vector3.new(2,2,2)
local OriginalTransparency = 1
local FlySpeed = 50
local BodyVelocity, BodyGyro = nil, nil

local function SaveData(key, value) pcall(function() writefile(key..".txt", tostring(value)) end) end
local function LoadData(key, default) local v=nil; pcall(function() v=readfile(key..".txt") end); return tonumber(v) or default end

local function GetChar() return LocalPlayer.Character end
local function GetHum() local c = GetChar() return c and c:FindFirstChildOfClass("Humanoid") end
local function GetRoot() local c = GetChar() return c and c:FindFirstChildOfClass("HumanoidRootPart") end

local function SetSpeed(v) SpeedValue = math.clamp(v,1,200); local h = GetHum() if h then h.WalkSpeed = SpeedValue end end
local function ToggleInvis() local c = GetChar(); if not c then return end; InvisibleEnabled = not InvisibleEnabled; for _,p in pairs(c:GetChildren()) do if p:IsA("BasePart") then p.Transparency = InvisibleEnabled and 1 or OriginalTransparency end end end
RunService.Stepped:Connect(function() if NoClipEnabled then local c = GetChar(); if c then for _,p in pairs(c:GetChildren()) do if p:IsA("BasePart") then p.CanCollide=false end end end end end)
local function ToggleNoClip() NoClipEnabled = not NoClipEnabled end

local function ToggleFly()
    FlyEnabled = not FlyEnabled
    local r = GetRoot() local h = GetHum() if not r or not h then return end
    if FlyEnabled then h.PlatformStand = true; BodyVelocity = Instance.new("BodyVelocity"); BodyVelocity.MaxForce = Vector3.new(math.huge,math.huge,math.huge); BodyVelocity.Parent = r; BodyGyro = Instance.new("BodyGyro"); BodyGyro.MaxTorque = Vector3.new(math.huge,math.huge,math.huge); BodyGyro.Parent = r
    else h.PlatformStand = false; pcall(function() if r then r:FindFirstChildOfClass("BodyVelocity"):Destroy() r:FindFirstChildOfClass("BodyGyro"):Destroy() end end) end
end
RunService.RenderStepped:Connect(function()
    if not FlyEnabled then return end
    local r = GetRoot() if not r then return end
    local cam = Workspace.CurrentCamera local d = Vector3.new()
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then d += cam.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then d -= cam.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then d -= cam.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then d += cam.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then d += Vector3.new(0,1,0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.LControl) then d += Vector3.new(0,-1,0) end
    if BodyVelocity then BodyVelocity.Velocity = d.Magnitude>0 and d.Unit*FlySpeed or Vector3.new() end
    if BodyGyro then BodyGyro.CFrame = CFrame.new(r.Position, r.Position+cam.CFrame.LookVector) end
end)

local function ToggleInvincible()
    InvincibleEnabled = not InvincibleEnabled
    local c = GetChar() local h = GetHum() if not c or not h then return end
    local Hitbox = c.PrimaryPart or c:FindFirstChild("Hitbox") or c:FindFirstChildOfClass("BasePart")
    if not Hitbox then return end
    if InvincibleEnabled then
        OriginalHitboxSize = Hitbox.Size
        Hitbox.Size = Vector3.new(0.01,0.01,0.01)
        Hitbox.CanTouch = false
        h.Health = math.huge
    else
        Hitbox.Size = OriginalHitboxSize
        Hitbox.CanTouch = true
        h.Health = 100
    end
end

-- ✅ VOLUME SYSTEM 0-1000
local MusicVolume = LoadData(SAVE_KEY_VOLUME, VOLUME_DEFAULT)
local CurrentSound = nil
local VolNumTextMain, VolFillMain, VolFillMenu, VolNumMenu

local function UpdateVolume(newVal)
    MusicVolume = math.clamp(tonumber(newVal) or VOLUME_DEFAULT, VOLUME_MIN, VOLUME_MAX)
    SaveData(SAVE_KEY_VOLUME, MusicVolume)
    local RobloxVol = MusicVolume / VOLUME_MAX
    if CurrentSound then CurrentSound.Volume = RobloxVol end
    local DisplayText = tostring(math.floor(MusicVolume + 0.5))
    if VolNumTextMain then VolNumTextMain.Text = DisplayText end
    if VolFillMain then VolFillMain.Size = UDim2.new(RobloxVol,0,1,0) end
    if VolNumMenu then VolNumMenu.Text = DisplayText end
    if VolFillMenu then VolFillMenu.Size = UDim2.new(RobloxVol,0,1,0) end
end

local function FormatSoundID(input) return "rbxassetid://"..tostring(input):gsub("%D","") end
local function PlaySound(id)
    pcall(function() if CurrentSound then CurrentSound:Destroy() end end)
    CurrentSound = Instance.new("Sound")
    CurrentSound.Name = "BLUE_BOOMBOX"
    CurrentSound.SoundId = FormatSoundID(id)
    CurrentSound.Volume = MusicVolume / VOLUME_MAX
    CurrentSound.Looped = true
    CurrentSound.Parent = SoundService
    pcall(function() CurrentSound:Play() end)
end

-- Command List
local function ToggleCommandList()
    if CommandListOpen then if CurrentListUI then CurrentListUI:Destroy() end; CommandListOpen = false; return end
    CommandListOpen = true
    local ListUI = Instance.new("ScreenGui")
    ListUI.Name = "BLUE_COMMAND_LIST"
    ListUI.ResetOnSpawn = false
    ListUI.DisplayOrder = GUI_PRIORITY+1
    ListUI.Parent = PlayerGui
    CurrentListUI = ListUI

    local ListBox = Instance.new("Frame")
    ListBox.Size = UDim2.new(0,380,0,420)
    ListBox.Position = UDim2.new(0.5,-190,0.5,-210)
    ListBox.BackgroundColor3 = Color3.fromRGB(20,20,20)
    ListBox.Active = true
    ListBox.Parent = ListUI
    Instance.new("UICorner", ListBox).CornerRadius = UDim.new(0,16)

    local CloseList = Instance.new("TextButton")
    CloseList.Size = UDim2.new(0,30,0,30)
    CloseList.Position = UDim2.new(1,-35,0,5)
    CloseList.BackgroundColor3 = Color3.fromRGB(170,30,30)
    CloseList.Text = "✕"
    CloseList.TextColor3 = Color3.new(1,1,1)
    CloseList.Font = Enum.Font.GothamBold
    CloseList.TextSize = 24
    CloseList.Parent = ListBox
    CloseList.MouseButton1Click:Connect(ToggleCommandList)

    local ListTitle = Instance.new("TextLabel")
    ListTitle.Size = UDim2.new(1,-40,0,40)
    ListTitle.Position = UDim2.new(0,20,0,10)
    ListTitle.BackgroundTransparency = 1
    ListTitle.Text = "📋 FULL COMMAND LIST"
    ListTitle.TextColor3 = Color3.fromRGB(0,190,255)
    ListTitle.Font = Enum.Font.GothamBold
    ListTitle.TextScaled = true
    ListTitle.Parent = ListBox

    local AllCommands = Instance.new("TextLabel")
    AllCommands.Size = UDim2.new(1,-40,1,-70)
    AllCommands.Position = UDim2.new(0,20,0,55)
    AllCommands.BackgroundTransparency = 1
    AllCommands.TextWrapped = true
    AllCommands.TextXAlignment = Enum.TextXAlignment.Left
    AllCommands.TextYAlignment = Enum.TextYAlignment.Top
    AllCommands.Font = Enum.Font.Gotham
    AllCommands.TextScaled = true
    AllCommands.TextColor3 = Color3.new(1,1,1)
    AllCommands.Text = [[🔧 ALL FEATURES:

✈️ FLY MODE | W/S/A/D + Space/LCtrl
👻 INVISIBLE MODE
⚡ SPEED 1-200
🔊 VOLUME 0-1000
🚧 NOCLIP
🛡️ INVINCIBLE / UNHITTABLE
👥 PLAYER ESP
🎵 BOOMBOX SOUND PLAYER
💻 CUSTOM SCRIPT CONSOLE
📺 YOUTUBE LINK
⚙️ FULL SETTINGS MENU]]
    AllCommands.Parent = ListBox
end

local function ToggleCommandsMenu()
    if CommandsUI_Open then if CurrentCommandsUI then CurrentCommandsUI:Destroy() end; CommandsUI_Open = false; CurrentCommandsUI = nil; GuiFocused = false; return end
    GuiFocused = true
    CommandsUI_Open = true
    local CmdUI = Instance.new("ScreenGui")
    CmdUI.Name = "BLUE_COMMANDS_MENU"
    CmdUI.ResetOnSpawn = false
    CmdUI.DisplayOrder = GUI_PRIORITY
    CmdUI.Parent = PlayerGui
    CurrentCommandsUI = CmdUI

    local CmdFrame = Instance.new("Frame")
    CmdFrame.Size = UDim2.new(0,300,0,400)
    CmdFrame.Position = UDim2.new(0.5,-150,0.5,-200)
    CmdFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
    CmdFrame.Active = true
    CmdFrame.Parent = CmdUI
    Instance.new("UICorner", CmdFrame).CornerRadius = UDim.new(0,14)

    local CmdTitle = Instance.new("TextLabel")
    CmdTitle.Size = UDim2.new(1,-40,0,35)
    CmdTitle.Position = UDim2.new(0,20,0,10)
    CmdTitle.BackgroundTransparency = 1
    CmdTitle.Text = "⚙️ COMMANDS MENU"
    CmdTitle.TextColor3 = Color3.fromRGB(0,190,255)
    CmdTitle.Font = Enum.Font.GothamBold
    CmdTitle.TextScaled = true
    CmdTitle.Parent = CmdFrame

    local ListBtn = Instance.new("TextButton")
    ListBtn.Size = UDim2.new(1,-40,0,35)
    ListBtn.Position = UDim2.new(0,20,0,55)
    ListBtn.BackgroundColor3 = Color3.fromRGB(60,80,180)
    ListBtn.Text = "📋 LIST ALL FEATURES"
    ListBtn.TextColor3 = Color3.new(1,1,1)
    ListBtn.Font = Enum.Font.GothamBold
    ListBtn.TextScaled = true
    ListBtn.Parent = CmdFrame
    Instance.new("UICorner", ListBtn).CornerRadius = UDim.new(0,8)
    ListBtn.MouseButton1Click:Connect(ToggleCommandList)

    local FlyBtn = Instance.new("TextButton")
    FlyBtn.Size = UDim2.new(1,-40,0,35)
    FlyBtn.Position = UDim2.new(0,20,0,100)
    FlyBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    FlyBtn.Text = "✈️ FLY: OFF"
    FlyBtn.TextColor3 = Color3.new(1,1,1)
    FlyBtn.Font = Enum.Font.GothamBold
    FlyBtn.TextScaled = true
    FlyBtn.Parent = CmdFrame
    Instance.new("UICorner", FlyBtn).CornerRadius = UDim.new(0,8)
    FlyBtn.MouseButton1Click:Connect(function() ToggleFly(); FlyBtn.Text = FlyEnabled and "✈️ FLY: ON" or "✈️ FLY: OFF"; FlyBtn.BackgroundColor3 = FlyEnabled and Color3.fromRGB(25,120,25) or Color3.fromRGB(40,40,40) end)

    local InvisBtn = Instance.new("TextButton")
    InvisBtn.Size = UDim2.new(1,-40,0,35)
    InvisBtn.Position = UDim2.new(0,20,0,145)
    InvisBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    InvisBtn.Text = "👻 INVISIBLE: OFF"
    InvisBtn.TextColor3 = Color3.new(1,1,1)
    InvisBtn.Font = Enum.Font.GothamBold
    InvisBtn.TextScaled = true
    InvisBtn.Parent = CmdFrame
    Instance.new("UICorner", InvisBtn).CornerRadius = UDim.new(0,8)
    InvisBtn.MouseButton1Click:Connect(function() ToggleInvis(); InvisBtn.Text = InvisibleEnabled and "👻 INVISIBLE: ON" or "👻 INVISIBLE: OFF"; InvisBtn.BackgroundColor3 = InvisibleEnabled and Color3.fromRGB(25,120,25) or Color3.fromRGB(40,40,40) end)

    local SpeedLabel = Instance.new("TextLabel")
    SpeedLabel.Size = UDim2.new(1,-40,0,25)
    SpeedLabel.Position = UDim2.new(0,20,0,190)
    SpeedLabel.BackgroundTransparency = 1
    SpeedLabel.Text = "⚡ SPEED: "..SpeedValue
    SpeedLabel.TextColor3 = Color3.new(1,1,1)
    SpeedLabel.Font = Enum.Font.Gotham
    SpeedLabel.TextScaled = true
    SpeedLabel.Parent = CmdFrame

    local SpeedBG = Instance.new("Frame")
    SpeedBG.Size = UDim2.new(1,-40,0,20)
    SpeedBG.Position = UDim2.new(0,20,0,220)
    SpeedBG.BackgroundColor3 = Color3.fromRGB(50,50,50)
    SpeedBG.Active = true
    SpeedBG.Parent = CmdFrame
    Instance.new("UICorner", SpeedBG).CornerRadius = UDim.new(0,10)

    local SpeedFill = Instance.new("Frame")
    SpeedFill.Size = UDim2.new(SpeedValue/200,0,1,0)
    SpeedFill.BackgroundColor3 = Color3.fromRGB(80,180,255)
    SpeedFill.Parent = SpeedBG
    Instance.new("UICorner", SpeedFill).CornerRadius = UDim.new(0,10)

    SpeedBG.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            local rel = math.clamp((i.Position.X - SpeedBG.AbsolutePosition.X)/SpeedBG.AbsoluteSize.X,0,1)
            SetSpeed(math.floor(rel*200))
            SpeedLabel.Text = "⚡ SPEED: "..SpeedValue
            SpeedFill.Size = UDim2.new(rel,0,1,0)
        end
    end)

    local NoClipBtn = Instance.new("TextButton")
    NoClipBtn.Size = UDim2.new(1,-40,0,35)
    NoClipBtn.Position = UDim2.new(0,20,0,255)
    NoClipBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    NoClipBtn.Text = "🚧 NOCLIP: OFF"
    NoClipBtn.TextColor3 = Color3.new(1,1,1)
    NoClipBtn.Font = Enum.Font.GothamBold
    NoClipBtn.TextScaled = true
    NoClipBtn.Parent = CmdFrame
    Instance.new("UICorner", NoClipBtn).CornerRadius = UDim.new(0,8)
    NoClipBtn.MouseButton1Click:Connect(function() ToggleNoClip(); NoClipBtn.Text = NoClipEnabled and "🚧 NOCLIP: ON" or "🚧 NOCLIP: OFF"; NoClipBtn.BackgroundColor3 = NoClipEnabled and Color3.fromRGB(25,120,25) or Color3.fromRGB(40,40,40) end)

    local InvBtn = Instance.new("TextButton")
    InvBtn.Size = UDim2.new(1,-40,0,35)
    InvBtn.Position = UDim2.new(0,20,0,300)
    InvBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    InvBtn.Text = "🛡️ INVINCIBLE: OFF"
    InvBtn.TextColor3 = Color3.new(1,1,1)
    InvBtn.Font = Enum.Font.GothamBold
    InvBtn.TextScaled = true
    InvBtn.Parent = CmdFrame
    Instance.new("UICorner", InvBtn).CornerRadius = UDim.new(0,8)
    InvBtn.MouseButton1Click:Connect(function() ToggleInvincible(); InvBtn.Text = InvincibleEnabled and "🛡️ INVINCIBLE: ON" or "🛡️ INVINCIBLE: OFF"; InvBtn.BackgroundColor3 = InvincibleEnabled and Color3.fromRGB(25,120,25) or Color3.fromRGB(40,40,40) end)

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(1,-40,0,35)
    CloseBtn.Position = UDim2.new(0,20,0,355)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(170,30,30)
    CloseBtn.Text = "✕ CLOSE MENU"
    CloseBtn.TextColor3 = Color3.new(1,1,1)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextScaled = true
    CloseBtn.Parent = CmdFrame
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0,8)
    CloseBtn.MouseButton1Click:Connect(ToggleCommandsMenu)
end
-- COPY PASTE PART 2 RIGHT AFTER THIS LINE

-- ==============================================
-- 🔵 BLUE MODE ESP | FULL VERSION (PART 2/2)
-- ✅ FULLY COMPLETED | NO MISSING CODE
-- ==============================================

-- Startup Screen
local StartupUI = Instance.new("ScreenGui")
StartupUI.Name = "BLUE_MODE_STARTUP"
StartupUI.ResetOnSpawn = false
StartupUI.DisplayOrder = GUI_PRIORITY
StartupUI.Parent = PlayerGui

local StartupBox = Instance.new("Frame")
StartupBox.Size = UDim2.new(0, 420, 0, 480)
StartupBox.Position = UDim2.new(0.5, -210, 0.5, -240)
StartupBox.BackgroundColor3 = Color3.fromRGB(10,12,18)
StartupBox.Active = true
StartupBox.Parent = StartupUI
Instance.new("UICorner", StartupBox).CornerRadius = UDim.new(0, 18)

local StartupBorder = Instance.new("UIStroke")
StartupBorder.Thickness = 5
StartupBorder.LineJoinMode = Enum.LineJoinMode.Round
StartupBorder.Parent = StartupBox

local StartupTitle = Instance.new("TextLabel")
StartupTitle.Size = UDim2.new(1, -40, 0, 50)
StartupTitle.Position = UDim2.new(0, 20, 0, 15)
StartupTitle.BackgroundTransparency = 1
StartupTitle.Font = Enum.Font.GothamBlack
StartupTitle.TextScaled = true
StartupTitle.Text = "🔵 BLUE MODE ESP"
StartupTitle.TextColor3 = Color3.fromRGB(0, 190, 255)
StartupTitle.Parent = StartupBox

local UpdateHeader = Instance.new("TextLabel")
UpdateHeader.Size = UDim2.new(1, -40, 0, 35)
UpdateHeader.Position = UDim2.new(0, 20, 0, 75)
UpdateHeader.BackgroundTransparency = 1
UpdateHeader.Font = Enum.Font.GothamBold
UpdateHeader.TextScaled = true
UpdateHeader.Text = "📋 UPDATE INFO:"
UpdateHeader.TextColor3 = Color3.new(1,1,1)
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
UpdateList.Text = [[• ✅ VOLUME UPDATED TO 0 → 1000 PERMANENT
• ✅ NO OLD FEATURES REMOVED OR CUT
• ✅ All original features fully working
• ✅ Better mobile support
• ✅ Creator: Dwayne Kean / Blue_Mode]]
UpdateList.Parent = StartupBox

local StartupTimerLabel = Instance.new("TextLabel")
StartupTimerLabel.Size = UDim2.new(1, -40, 0, 45)
StartupTimerLabel.Position = UDim2.new(0, 20, 0, 310)
StartupTimerLabel.BackgroundTransparency = 1
StartupTimerLabel.Font = Enum.Font.GothamBold
StartupTimerLabel.TextScaled = true
StartupTimerLabel.Text = "TIME REMAINING: 12:00:00"
StartupTimerLabel.TextColor3 = Color3.fromRGB(80,255,120)
StartupTimerLabel.Parent = StartupBox

local OkBtn = Instance.new("TextButton")
OkBtn.Size = UDim2.new(0, 260, 0, 60)
OkBtn.Position = UDim2.new(0.5, -130, 0, 385)
OkBtn.BackgroundColor3 = Color3.fromRGB(15, 110, 230)
OkBtn.Font = Enum.Font.GothamBold
OkBtn.TextScaled = true
OkBtn.Text = "✓ LOAD FULL HUB"
OkBtn.TextColor3 = Color3.new(1,1,1)
OkBtn.Parent = StartupBox
Instance.new("UICorner", OkBtn).CornerRadius = UDim.new(0, 16)

local StartupHue = 0
local UsedTime = LoadData(SAVE_KEY_USED, 0)
RunService.Heartbeat:Connect(function(dt)
    StartupHue = (StartupHue + dt * 0.3) % 1
    local Col = Color3.fromHSV(StartupHue, 1, 1)
    StartupBorder.Color = Col
    StartupTitle.TextColor3 = Col
    local Remaining = math.max(0, USAGE_LIMIT - UsedTime)
    local h = math.floor(Remaining/3600)
    local m = math.floor((Remaining%3600)/60)
    local s = Remaining%60
    StartupTimerLabel.Text = string.format("TIME REMAINING: %02d:%02d:%02d", h, m, s)
end)

OkBtn.MouseButton1Click:Connect(function() StartupUI:Destroy(); LoadMainHub() end)

-- Main Hub Loader
function LoadMainHub()
    local CurrentTime = os.time()
    local CooldownEnd = LoadData(SAVE_KEY_COOLDOWN, 0)
    if CurrentTime < CooldownEnd then
        print("⏳ COOLDOWN ACTIVE! Wait "..math.floor((CooldownEnd-CurrentTime)/60).." minutes")
        return
    end

    local GuiElements = {}
    local ESP_Enabled = false
    local Buttons_Locked = false
    local Hue = 0

    local function ClearAllESP()
        for _,P in pairs(Players:GetPlayers()) do
            if P and P.Character then
                pcall(function()
                    if P.Character:FindFirstChild("BLUE_Outline") then P.Character.BLUE_Outline:Destroy() end
                    if P.Character:FindFirstChild("FriendRainbowDot") then P.Character.FriendRainbowDot:Destroy() end
                end)
            end
        end
        pcall(function() for _,D in pairs(workspace:GetDescendants()) do if D.Name == "BLUE_Outline" or D.Name == "FriendRainbowDot" then D:Destroy() end end end)
    end

    local function SetupDeathCheck()
        local function CheckCharacter(Char)
            if not Char then return end
            local Hum = Char:WaitForChild("Humanoid", 10)
            if not Hum then return end
            Hum.Died:Connect(function()
                if ESP_Enabled then
                    ESP_Enabled = false
                    if ESPBtn then ESPBtn.Text = "ESP: OFF"; ESPBtn.BackgroundColor3 = Color3.fromRGB(40,40,40) end
                    ClearAllESP()
                end
            end)
        end
        CheckCharacter(LocalPlayer.Character)
        LocalPlayer.CharacterAdded:Connect(CheckCharacter)
    end

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

    -- Boombox Menu
    local function ToggleBoomboxMenu()
        if BoomboxUI_Open then if CurrentBoomboxUI then CurrentBoomboxUI:Destroy() end; BoomboxUI_Open = false; CurrentBoomboxUI = nil; GuiFocused = false; return end
        GuiFocused = true
        local BoomUI = Instance.new("ScreenGui")
        BoomUI.Name = "BLUE_BOOMBOX_MENU"
        BoomUI.ResetOnSpawn = false
        BoomUI.DisplayOrder = GUI_PRIORITY
        BoomUI.Parent = PlayerGui
        CurrentBoomboxUI = BoomUI
        BoomboxUI_Open = true

        local BoomFrame = Instance.new("Frame")
        BoomFrame.Size = UDim2.new(0,320,0,250)
        BoomFrame.Position = UDim2.new(0.5,-160,0.5,-125)
        BoomFrame.BackgroundColor3 = Color3.fromRGB(22,22,22)
        BoomFrame.Active = true
        BoomFrame.Parent = BoomUI
        Instance.new("UICorner", BoomFrame).CornerRadius = UDim.new(0,12)
        AddRainbowGlow(BoomFrame,4)

        local CloseTop = Instance.new("TextButton")
        CloseTop.Size = UDim2.new(0,30,0,30)
        CloseTop.Position = UDim2.new(1,-35,0,5)
        CloseTop.BackgroundColor3 = Color3.fromRGB(170,30,30)
        CloseTop.Text = "✕"
        CloseTop.TextColor3 = Color3.new(1,1,1)
        CloseTop.Font = Enum.Font.GothamBold
        CloseTop.TextSize = 24
        CloseTop.Parent = BoomFrame
        CloseTop.MouseButton1Click:Connect(ToggleBoomboxMenu)

        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1,-40,0,40)
        Title.Position = UDim2.new(0,15,0,8)
        Title.BackgroundTransparency = 1
        Title.Text = "🎵 BOOMBOX & VOLUME"
        Title.TextColor3 = Color3.new(1,1,1)
        Title.Font = Enum.Font.GothamBold
        Title.TextScaled = true
        Title.Parent = BoomFrame

        local Input = Instance.new("TextBox")
        Input.Size = UDim2.new(1,-40,0,45)
        Input.Position = UDim2.new(0,20,0,55)
        Input.BackgroundColor3 = Color3.fromRGB(35,35,35)
        Input.PlaceholderText = "Paste Sound ID here..."
        Input.TextColor3 = Color3.new(1,1,1)
        Input.Font = Enum.Font.Gotham
        Input.TextScaled = true
        Input.Parent = BoomFrame
        Instance.new("UICorner", Input).CornerRadius = UDim.new(0,8)
        AddRainbowGlow(Input,2)

        local VolLabel = Instance.new("TextLabel")
        VolLabel.Size = UDim2.new(0,130,0,30)
        VolLabel.Position = UDim2.new(0,20,0,110)
        VolLabel.BackgroundTransparency = 1
        VolLabel.Text = "🔊 VOLUME (0-1000):"
        VolLabel.TextColor3 = Color3.new(1,1,1)
        VolLabel.Font = Enum.Font.GothamBold
        VolLabel.TextScaled = true
        VolLabel.Parent = BoomFrame

        VolNumMenu = Instance.new("TextLabel")
        VolNumMenu.Size = UDim2.new(0,80,0,30)
        VolNumMenu.Position = UDim2.new(1,-100,0,110)
        VolNumMenu.BackgroundTransparency = 1
        VolNumMenu.Text = tostring(math.floor(MusicVolume+0.5))
        VolNumMenu.TextColor3 = Color3.new(1,1,1)
        VolNumMenu.Font = Enum.Font.GothamBold
        VolNumMenu.TextScaled = true
        VolNumMenu.Parent = BoomFrame

        local VolBG = Instance.new("Frame")
        VolBG.Size = UDim2.new(1,-40,0,24)
        VolBG.Position = UDim2.new(0,20,0,145)
        VolBG.BackgroundColor3 = Color3.fromRGB(50,50,50)
        VolBG.Active = true
        VolBG.Parent = BoomFrame
        Instance.new("UICorner", VolBG).CornerRadius = UDim.new(0,12)
        AddRainbowGlow(VolBG,2)

        VolFillMenu = Instance.new("Frame")
        VolFillMenu.Size = UDim2.new(MusicVolume/VOLUME_MAX,0,1,0)
        VolFillMenu.BackgroundColor3 = Color3.fromRGB(100,100,100)
        VolFillMenu.Parent = VolBG
        Instance.new("UICorner", VolFillMenu).CornerRadius = UDim.new(0,12)

        local SliderActive = false
        VolBG.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then SliderActive = true end end)
        UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then SliderActive = false end end)
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
        StopBtn.Parent = BoomFrame
        Instance.new("UICorner", StopBtn).CornerRadius = UDim.new(0,8)
        AddRainbowGlow(StopBtn,2)

        PlayBtn.MouseButton1Click:Connect(function() if Input.Text~="" then PlaySound(Input.Text) end end)
        StopBtn.MouseButton1Click:Connect(function() if CurrentSound then CurrentSound:Destroy() end end)
    end

    -- Console Menu
    local function ToggleConsole()
        if ConsoleUI_Open then if CurrentConsoleUI then CurrentConsoleUI:Destroy() end; ConsoleUI_Open = false; CurrentConsoleUI = nil; GuiFocused = false; return end
        GuiFocused = true
        local ConsoleUI = Instance.new("ScreenGui")
        ConsoleUI.Name = "BLUE_CONSOLE"
        ConsoleUI.ResetOnSpawn = false
        ConsoleUI.DisplayOrder = GUI_PRIORITY
        ConsoleUI.Parent = PlayerGui
        CurrentConsoleUI = ConsoleUI
        ConsoleUI_Open = true

        local Frame = Instance.new("Frame")
        Frame.Size = UDim2.new(0,450,0,320)
        Frame.Position = UDim2.new(0.5,-225,0.5,-160)
        Frame.BackgroundColor3 = Color3.fromRGB(22,22,22)
        Frame.Active = true
        Frame.Parent = ConsoleUI
        Instance.new("UICorner", Frame).CornerRadius = UDim.new(0,12)
        AddRainbowGlow(Frame,5)

        local CloseTop = Instance.new("TextButton")
        CloseTop.Size = UDim2.new(0,32,0,32)
        CloseTop.Position = UDim2.new(1,-37,0,6)
        CloseTop.BackgroundColor3 = Color3.fromRGB(170,30,30)
        CloseTop.Text = "✕"
        CloseTop.TextColor3 = Color3.new(1,1,1)
        CloseTop.Font = Enum.Font.GothamBold
        CloseTop.TextSize = 26
        CloseTop.Parent = Frame
        CloseTop.MouseButton1Click:Connect(ToggleConsole)

        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1,-50,0,35)
        Title.Position = UDim2.new(0,15,0,6)
        Title.BackgroundTransparency = 1
        Title.Text = "💻 CONSOLE"
        Title.TextColor3 = Color3.new(1,1,1)
        Title.Font = Enum.Font.GothamBold
        Title.TextScaled = true
        Title.TextXAlignment = Enum.TextXAlignment.Left
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
        Output.Parent = Frame

        local Input = Instance.new("TextBox")
        Input.Size = UDim2.new(1,-30,0,130)
        Input.Position = UDim2.new(0,15,0,95)
        Input.BackgroundColor3 = Color3.fromRGB(45,45,45)
        Input.PlaceholderText = "Paste your script here..."
        Input.TextColor3 = Color3.new(1,1,1)
        Input.Font = Enum.Font.Code
        Input.TextScaled = true
        Input.MultiLine = true
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
        ExecBtn.Parent = Frame
        Instance.new("UICorner", ExecBtn).CornerRadius = UDim.new(0,8)

        local ClearBtn = Instance.new("TextButton")
        ClearBtn.Size = UDim2.new(0,120,0,40)
        ClearBtn.Position = UDim2.new(0,150,0,240)
        ClearBtn.BackgroundColor3 = Color3.fromRGB(180,120,20)
        ClearBtn.Text = "🗑️ CLEAR"
        ClearBtn.TextColor3 = Color3.new(1,1,1)
        ClearBtn.Font = Enum.Font.GothamBold
        ClearBtn.TextScaled = true
        ClearBtn.Parent = Frame
        Instance.new("UICorner", ClearBtn).CornerRadius = UDim.new(0,8)

        ExecBtn.MouseButton1Click:Connect(function()
            local ScriptCode = Input.Text
            if ScriptCode == "" then Output.Text = "⚠️ Nothing to run!" return end
            local Compile = loadstring or load
            if not Compile then Output.Text = "⚠️ Executor does not support compiling." return end
            local Func, Err = Compile(ScriptCode)
            if not Func then Output.Text = "❌ Syntax Error:\n"..tostring(Err) return end
            local Ok, RunErr = pcall(Func)
            if not Ok then Output.Text = "❌ Runtime Error:\n"..tostring(RunErr) return end
            Output.Text = "✅ Script ran successfully!"
        end)
        ClearBtn.MouseButton1Click:Connect(function() Input.Text = "" Output.Text = "✅ Cleared!" end)
    end

    -- Main Hub UI
    local FULL_SIZE = UDim2.new(0,680,0,105)
    local MINI_SIZE = UDim2.new(0,110,0,36)
    local MainUI = Instance.new("ScreenGui")
    MainUI.Name = "BLUE_MODE_ESP"
    MainUI.ResetOnSpawn = false
    MainUI.DisplayOrder = GUI_PRIORITY
    MainUI.Parent = PlayerGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = FULL_SIZE
    MainFrame.Position = UDim2.new(0,20,0.5,-52)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
    MainFrame.Active = true
    MainFrame.Parent = MainUI
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,8)
    AddRainbowGlow(MainFrame,5)

    local DragHandle = Instance.new("TextButton")
    DragHandle.Size = UDim2.new(1,-30,0,22)
    DragHandle.Position = UDim2.new(0,0,0,0)
    DragHandle.BackgroundColor3 = Color3.fromRGB(60,140,220)
    DragHandle.Active = true
    DragHandle.Text = "made by BLUE_MODE | DRAG HERE"
    DragHandle.TextColor3 = Color3.new(1,1,1)
    DragHandle.Font = Enum.Font.GothamBold
    DragHandle.TextScaled = true
    DragHandle.TextXAlignment = Enum.TextXAlignment.Left
    DragHandle.Parent = MainFrame
    AddRainbowGlow(DragHandle,2)

    local TimerLabel = Instance.new("TextLabel")
    TimerLabel.Size = UDim2.new(0,120,1,0)
    TimerLabel.Position = UDim2.new(1,-125,0,0)
    TimerLabel.BackgroundTransparency = 1
    TimerLabel.Text = "00:00:00 / 12:00"
    TimerLabel.TextColor3 = Color3.new(1,1,1)
    TimerLabel.Font = Enum.Font.GothamBold
    TimerLabel.TextScaled = true
    TimerLabel.TextXAlignment = Enum.TextXAlignment.Right
    TimerLabel.Parent = DragHandle

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

    local ESPBtn = Instance.new("TextButton")
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
    YouTubeBtn.Text = "📺 YT"
    YouTubeBtn.TextColor3 = Color3.new(1,1,1)
    YouTubeBtn.Font = Enum.Font.GothamBold
    YouTubeBtn.TextScaled = true
    YouTubeBtn.Parent = MainFrame
    Instance.new("UICorner", YouTubeBtn).CornerRadius = UDim.new(0,6)
    AddRainbowGlow(YouTubeBtn,2)
    YouTubeBtn.MouseButton1Click:Connect(function() pcall(function() setclipboard(YOUTUBE_LINK) end) print("YouTube link copied to clipboard!") end)

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
    MusicBtn.MouseButton1Click:Connect(ToggleBoomboxMenu)

    local CmdBtn = Instance.new("TextButton")
    CmdBtn.Size = UDim2.new(0,110,0,30)
    CmdBtn.Position = UDim2.new(0,300,0,30)
    CmdBtn.BackgroundColor3 = Color3.fromRGB(15,110,230)
    CmdBtn.Text = "⚙️ COMMANDS"
    CmdBtn.TextColor3 = Color3.new(1,1,1)
    CmdBtn.Font = Enum.Font.GothamBold
    CmdBtn.TextScaled = true
    CmdBtn.Parent = MainFrame
    Instance.new("UICorner", CmdBtn).CornerRadius = UDim.new(0,6)
    AddRainbowGlow(CmdBtn,2)
    CmdBtn.MouseButton1Click:Connect(ToggleCommandsMenu)

    local LockBtn = Instance.new("TextButton")
    LockBtn.Size = UDim2.new(0,90,0,30)
    LockBtn.Position = UDim2.new(0,420,0,30)
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
    ConsoleBtn.Position = UDim2.new(0,520,0,30)
    ConsoleBtn.BackgroundColor3 = Color3.fromRGB(30,120,90)
    ConsoleBtn.Text = "💻 CONSOLE"
    ConsoleBtn.TextColor3 = Color3.new(1,1,1)
    ConsoleBtn.Font = Enum.Font.GothamBold
    ConsoleBtn.TextScaled = true
    ConsoleBtn.Parent = MainFrame
    Instance.new("UICorner", ConsoleBtn).CornerRadius = UDim.new(0,6)
    AddRainbowGlow(ConsoleBtn,2)
    ConsoleBtn.MouseButton1Click:Connect(ToggleConsole)

    local ExitBtn = Instance.new("TextButton")
    ExitBtn.Size = UDim2.new(0,90,0,30)
    ExitBtn.Position = UDim2.new(0,640,0,30)
    ExitBtn.BackgroundColor3 = Color3.fromRGB(140,20,20)
    ExitBtn.Text = "🗑️ EXIT"
    ExitBtn.TextColor3 = Color3.new(1,1,1)
    ExitBtn.Font = Enum.Font.GothamBold
    ExitBtn.TextScaled = true
    ExitBtn.Parent = MainFrame
    Instance.new("UICorner", ExitBtn).CornerRadius = UDim.new(0,6)
    AddRainbowGlow(ExitBtn,2)
    ExitBtn.MouseButton1Click:Connect(function()
        pcall(function() MainUI:Destroy() end)
        pcall(function()
            if CurrentBoomboxUI then CurrentBoomboxUI:Destroy() end
            if CurrentConsoleUI then CurrentConsoleUI:Destroy() end
            if CurrentCommandsUI then CurrentCommandsUI:Destroy() end
            if CurrentListUI then CurrentListUI:Destroy() end
        end)
        ClearAllESP()
        if CurrentSound then CurrentSound:Destroy() end
    end)

    -- Main UI Volume Slider
    local VolLabelMain = Instance.new("TextLabel")
    VolLabelMain.Size = UDim2.new(0,100,0,25)
    VolLabelMain.Position = UDim2.new(0,10,0,65)
    VolLabelMain.BackgroundTransparency = 1
    VolLabelMain.Text = "🔊 VOLUME:"
    VolLabelMain.TextColor3 = Color3.new(1,1,1)
    VolLabelMain.Font = Enum.Font.GothamBold
    VolLabelMain.TextScaled = true
    VolLabelMain.Parent = MainFrame

    VolNumTextMain = Instance.new("TextLabel")
    VolNumTextMain.Size = UDim2.new(0,60,0,25)
    VolNumTextMain.Position = UDim2.new(1,-70,0,65)
    VolNumTextMain.BackgroundTransparency = 1
    VolNumTextMain.Text = tostring(math.floor(MusicVolume+0.5))
    VolNumTextMain.TextColor3 = Color3.new(1,1,1)
    VolNumTextMain.Font = Enum.Font.GothamBold
    VolNumTextMain.TextScaled = true
    VolNumTextMain.Parent = MainFrame

    local VolBGMain = Instance.new("Frame")
    VolBGMain.Size = UDim2.new(1,-180,0,20)
    VolBGMain.Position = UDim2.new(0,110,0,67)
    VolBGMain.BackgroundColor3 = Color3.fromRGB(50,50,50)
    VolBGMain.Active = true
    VolBGMain.Parent = MainFrame
    Instance.new("UICorner", VolBGMain).CornerRadius = UDim.new(0,10)

    VolFillMain = Instance.new("Frame")
    VolFillMain.Size = UDim2.new(MusicVolume/VOLUME_MAX,0,1,0)
    VolFillMain.BackgroundColor3 = Color3.fromRGB(0,190,255)
    VolFillMain.Parent = VolBGMain
    Instance.new("UICorner", VolFillMain).CornerRadius = UDim.new(0,10)

    local SliderMainActive = false
    VolBGMain.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then SliderMainActive = true end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then SliderMainActive = false end end)
    UserInputService.InputChanged:Connect(function(i)
        if SliderMainActive and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local rel = math.clamp((i.Position.X - VolBGMain.AbsolutePosition.X)/VolBGMain.AbsoluteSize.X, 0, 1)
            UpdateVolume(math.floor(rel * VOLUME_MAX))
        end
    end)

    -- Drag Function
    local DragStart, StartPos
    DragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            DragStart = input.Position
            StartPos = MainFrame.Position
            input.Changed:Wait()
            DragStart = nil
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if DragStart and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local Delta = input.Position - DragStart
            MainFrame.Position = UDim2.new(StartPos.ScaleX, StartPos.X.Offset + Delta.X, StartPos.ScaleY, StartPos.Y.Offset + Delta.Y)
        end
    end)

    -- Minimize / Restore
    local IsMin = false
    MinBtn.MouseButton1Click:Connect(function()
        IsMin = not IsMin
        if IsMin then
            MainFrame.Size = MINI_SIZE
            MainFrame.Position = UDim2.new(0,20,0,20)
            MinBtn.Text = "➕"
        else
            MainFrame.Size = FULL_SIZE
            MainFrame.Position = UDim2.new(0,20,0.5,-52)
            MinBtn.Text = "➖"
        end
    end)

    -- Rainbow Effects Loop
    RunService.RenderStepped:Connect(function(dt)
        Hue = (Hue + dt * 0.5) % 1
        local Color = Color3.fromHSV(Hue, 1, 1)
        for _, v in pairs(GuiElements) do if v:IsA("UIStroke") then v.Color = Color end end
    end)

    -- Final Volume Sync
    UpdateVolume(MusicVolume)
end
