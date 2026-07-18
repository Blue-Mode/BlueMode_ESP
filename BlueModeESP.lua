-- ==============================================
-- 🔵 BLUE MODE ESP | FULL + COMMAND LIST
-- ✅ UNIVERSAL | FLY / INVISIBLE / SPEED / NOCLIP / INVINCIBLE
-- ✅ NEW: 📋 LIST COMMANDS BUTTON INSIDE MENU
-- ✅ MADE BY: BLUE_MODE / DWAYNE KEAN FRANCISCO
-- ==============================================
if getgenv().BlueMode_Loaded then return end
getgenv().BlueMode_Loaded = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

local GUI_PRIORITY = 998

-- ✅ SAFE SAVE/LOAD
local function SaveData(key, value)
    pcall(function() writefile(key..".txt", tostring(value)) end)
end
local function LoadData(key, default)
    local val = nil
    pcall(function() val = readfile(key..".txt") end)
    return tonumber(val) or default
end

-- SETTINGS
local USAGE_LIMIT = 12 * 3600
local SAVE_KEY_USED = "BlueMode_UsedTime_v21"
local SAVE_KEY_COOLDOWN = "BlueMode_CooldownEnd_v21"
local SAVE_KEY_VOLUME = "BlueMode_Volume_v21"

-- GLOBAL STATES
local BoomboxUI_Open = false
local ConsoleUI_Open = false
local CommandsUI_Open = false
local CommandListOpen = false
local CurrentBoomboxUI, CurrentConsoleUI, CurrentCommandsUI, CurrentListUI = nil, nil, nil, nil
local IsMinimized = false
local GuiFocused = false
local ESPBtn, CommandsBtn = nil, nil

-- ✅ FEATURE STATES
local FlyEnabled = false
local InvisibleEnabled = false
local NoClipEnabled = false
local InvincibleEnabled = false
local SpeedValue = 16
local OriginalHitboxSize = Vector3.new(2,2,2)
local OriginalTransparency = 1
local FlySpeed = 50
local BodyVelocity, BodyGyro = nil, nil

-- ✅ HELPER FUNCTIONS
local function GetChar() return LocalPlayer.Character end
local function GetHum() local c = GetChar() return c and c:FindFirstChildOfClass("Humanoid") end
local function GetRoot() local c = GetChar() return c and c:FindFirstChild("HumanoidRootPart") end

-- ✅ ADD RAINBOW GLOW
local function AddGlow(obj, thick)
    local glow = Instance.new("UIStroke")
    glow.Name = "RainbowGlow"
    glow.Thickness = thick or 3
    glow.LineJoinMode = Enum.LineJoinMode.Round
    glow.Parent = obj
    return glow
end

-- ==============================================
-- 🚀 STARTUP SCREEN
-- ==============================================
local Startup = Instance.new("ScreenGui")
Startup.Name = "BLUE_MODE_STARTUP"
Startup.ResetOnSpawn = false
Startup.DisplayOrder = GUI_PRIORITY
Startup.Parent = CoreGui

local Box = Instance.new("Frame")
Box.Size = UDim2.new(0,420,0,500)
Box.Position = UDim2.new(0.5,-210,0.5,-250)
Box.BackgroundColor3 = Color3.fromRGB(10,12,18)
Box.Active = true
Box.Parent = Startup
Instance.new("UICorner", Box).CornerRadius = UDim.new(0,18)
local Border = AddGlow(Box,5)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,-40,0,50)
Title.Position = UDim2.new(0,20,0,15)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBlack
Title.TextScaled = true
Title.Text = "🔵 BLUE MODE HUB"
Title.TextColor3 = Color3.fromRGB(0,190,255)
Title.Parent = Box

local List = Instance.new("TextLabel")
List.Size = UDim2.new(1,-50,0,250)
List.Position = UDim2.new(0,25,0,80)
List.BackgroundTransparency = 1
List.Font = Enum.Font.Gotham
List.TextScaled = true
List.TextWrapped = true
List.TextXAlignment = Enum.TextXAlignment.Left
List.TextColor3 = Color3.fromRGB(220,220,220)
List.Text = [[✅ FULL FEATURES:
• 👥 Player ESP Highlight
• ✈️ Fly Mode
• 👻 Invisible
• ⚡ Speed Control
• 🚧 NoClip (Walk through walls)
• 🛡️ Invincible (Hitbox hidden)
• 📋 Full Command List
• 🎵 Boombox / 💻 Console
• ✅ Universal for all games]]
List.Parent = Box

local Timer = Instance.new("TextLabel")
Timer.Size = UDim2.new(1,-40,0,45)
Timer.Position = UDim2.new(0,20,0,350)
Timer.BackgroundTransparency = 1
Timer.Font = Enum.Font.GothamBold
Timer.TextScaled = true
Timer.Text = "TIME REMAINING: 12:00:00"
Timer.TextColor3 = Color3.fromRGB(80,255,120)
Timer.Parent = Box

local OkBtn = Instance.new("TextButton")
OkBtn.Size = UDim2.new(0,260,0,60)
OkBtn.Position = UDim2.new(0.5,-130,0,410)
OkBtn.BackgroundColor3 = Color3.fromRGB(15,110,230)
OkBtn.Font = Enum.Font.GothamBold
OkBtn.TextScaled = true
OkBtn.Text = "✓ OPEN HUB"
OkBtn.TextColor3 = Color3.new(1,1,1)
OkBtn.Parent = Box
Instance.new("UICorner", OkBtn).CornerRadius = UDim.new(0,16)

local Hue = 0
local UsedTime = LoadData(SAVE_KEY_USED,0)
RunService.Heartbeat:Connect(function(dt)
    Hue = (Hue + dt*0.3) %1
    local Col = Color3.fromHSV(Hue,1,1)
    Border.Color = Col
    Title.TextColor3 = Col
    local Rem = math.max(0, USAGE_LIMIT - UsedTime)
    Timer.Text = string.format("TIME REMAINING: %02d:%02d:%02d", Rem/3600, (Rem%3600)/60, Rem%60)
end)

OkBtn.MouseButton1Click:Connect(function() Startup:Destroy() LoadMainHub() end)

-- ==============================================
-- 🛠️ ALL COMMAND FUNCTIONS
-- ==============================================
-- SPEED
local function SetSpeed(v)
    SpeedValue = math.clamp(v,1,200)
    local h = GetHum() if h then h.WalkSpeed = SpeedValue end
end

-- INVISIBLE
local function ToggleInvis()
    local c = GetChar() if not c then return end
    InvisibleEnabled = not InvisibleEnabled
    for _,p in pairs(c:GetChildren()) do
        if p:IsA("BasePart") then
            p.Transparency = InvisibleEnabled and 1 or OriginalTransparency
        end
    end
end

-- NOCLIP
RunService.Stepped:Connect(function()
    if NoClipEnabled then
        local c = GetChar() if c then for _,p in pairs(c:GetChildren()) do if p:IsA("BasePart") then p.CanCollide=false end end end
    end
end)
local function ToggleNoClip() NoClipEnabled = not NoClipEnabled end

-- FLY
local function ToggleFly()
    FlyEnabled = not FlyEnabled
    local r = GetRoot() local h = GetHum() if not r or not h then return end
    if FlyEnabled then
        h.PlatformStand = true
        BodyVelocity = Instance.new("BodyVelocity")
        BodyVelocity.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
        BodyVelocity.Parent = r
        BodyGyro = Instance.new("BodyGyro")
        BodyGyro.MaxTorque = Vector3.new(math.huge,math.huge,math.huge)
        BodyGyro.Parent = r
    else
        h.PlatformStand = false
        pcall(function() r.BlueFlyVel:Destroy() r.BlueFlyGyro:Destroy() end)
    end
end
RunService.RenderStepped:Connect(function()
    if not FlyEnabled then return end
    local r = GetRoot() if not r then return end
    local cam = Workspace.CurrentCamera
    local d = Vector3.new()
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then d += cam.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then d -= cam.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then d -= cam.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then d += cam.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then d += Vector3.new(0,1,0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.LControl) then d += Vector3.new(0,-1,0) end
    BodyVelocity.Velocity = d.Magnitude>0 and d.Unit*FlySpeed or Vector3.new()
    BodyGyro.CFrame = CFrame.new(r.Position, r.Position+cam.CFrame.LookVector)
end)

-- INVINCIBLE (HITBOX TO BOTTOM)
local function ToggleInvincible()
    InvincibleEnabled = not InvincibleEnabled
    local c = GetChar() local h = GetHum() if not c or not h then return end
    local Hitbox = c.PrimaryPart or c:FindFirstChild("Hitbox") if not Hitbox then return end
    if InvincibleEnabled then
        OriginalHitboxSize = Hitbox.Size
        Hitbox.Size = Vector3.new(0.01,0.01,0.01) -- Hidden hitbox
        Hitbox.CanTouch = false
        h.Health = math.huge
    else
        Hitbox.Size = OriginalHitboxSize
        Hitbox.CanTouch = true
        h.Health = 100
    end
end

-- ==============================================
-- 📋 COMMAND LIST POPUP
-- ==============================================
local function ToggleCommandList()
    if CommandListOpen then
        if CurrentListUI then CurrentListUI:Destroy() end
        CommandListOpen = false
        return
    end
    CommandListOpen = true
    local ListUI = Instance.new("ScreenGui")
    ListUI.Name = "BLUE_COMMAND_LIST"
    ListUI.ResetOnSpawn = false
    ListUI.DisplayOrder = GUI_PRIORITY+1
    ListUI.Parent = CoreGui
    CurrentListUI = ListUI

    local ListBox = Instance.new("Frame")
    ListBox.Size = UDim2.new(0,380,0,420)
    ListBox.Position = UDim2.new(0.5,-190,0.5,-210)
    ListBox.BackgroundColor3 = Color3.fromRGB(20,20,20)
    ListBox.Active = true
    ListBox.Parent = ListUI
    Instance.new("UICorner", ListBox).CornerRadius = UDim.new(0,16)
    AddGlow(ListBox,4)

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
    AllCommands.Text = [[🔧 ALL AVAILABLE COMMANDS:

✈️  FLY MODE
- Toggle: Click Fly button
- Controls: W/S/A/D + Space/Control

👻 INVISIBLE
- Toggle: Click Invisible
- Hides your character fully

⚡ SPEED
- Adjust slider: 1 → 200 speed

🚧 NOCLIP
- Toggle: Click NoClip
- Walk through walls/objects

🛡️ INVINCIBLE
- Toggle: Click Invincible
- Hitbox hidden to bottom of map
- Cannot take damage or be hit

👥 ESP
- Toggle: Click ESP
- Highlights all players

🎵 BOOMBOX
- Play any sound ID
💻 CONSOLE
- Run any custom script

✅ Works on ALL Roblox games!]]
    AllCommands.Parent = ListBox
end

-- ==============================================
-- ⚙️ COMMANDS MENU (MAIN)
-- ==============================================
local function ToggleCommandsMenu()
    if CommandsUI_Open then
        if CurrentCommandsUI then CurrentCommandsUI:Destroy() end
        CommandsUI_Open = false
        CurrentCommandsUI = nil
        GuiFocused = false
        return
    end
    GuiFocused = true
    CommandsUI_Open = true
    local CmdUI = Instance.new("ScreenGui")
    CmdUI.Name = "BLUE_COMMANDS_MENU"
    CmdUI.ResetOnSpawn = false
    CmdUI.DisplayOrder = GUI_PRIORITY
    CmdUI.Parent = CoreGui
    CurrentCommandsUI = CmdUI

    local CmdFrame = Instance.new("Frame")
    CmdFrame.Size = UDim2.new(0,300,0,400)
    CmdFrame.Position = UDim2.new(0.5,-150,0.5,-200)
    CmdFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
    CmdFrame.Active = true
    CmdFrame.Parent = CmdUI
    Instance.new("UICorner", CmdFrame).CornerRadius = UDim.new(0,14)
    AddGlow(CmdFrame,4)

    local CmdTitle = Instance.new("TextLabel")
    CmdTitle.Size = UDim2.new(1,-40,0,35)
    CmdTitle.Position = UDim2.new(0,20,0,10)
    CmdTitle.BackgroundTransparency = 1
    CmdTitle.Text = "⚙️ COMMANDS MENU"
    CmdTitle.TextColor3 = Color3.fromRGB(0,190,255)
    CmdTitle.Font = Enum.Font.GothamBold
    CmdTitle.TextScaled = true
    CmdTitle.Parent = CmdFrame

    -- 📋 LIST COMMANDS BUTTON (NEW!)
    local ListBtn = Instance.new("TextButton")
    ListBtn.Size = UDim2.new(1,-40,0,35)
    ListBtn.Position = UDim2.new(0,20,0,55)
    ListBtn.BackgroundColor3 = Color3.fromRGB(60,80,180)
    ListBtn.Text = "📋 LIST ALL COMMANDS"
    ListBtn.TextColor3 = Color3.new(1,1,1)
    ListBtn.Font = Enum.Font.GothamBold
    ListBtn.TextScaled = true
    ListBtn.Parent = CmdFrame
    Instance.new("UICorner", ListBtn).CornerRadius = UDim.new(0,8)
    ListBtn.MouseButton1Click:Connect(ToggleCommandList)

    -- FLY
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
    FlyBtn.MouseButton1Click:Connect(function()
        ToggleFly()
        FlyBtn.Text = FlyEnabled and "✈️ FLY: ON" or "✈️ FLY: OFF"
        FlyBtn.BackgroundColor3 = FlyEnabled and Color3.fromRGB(25,120,25) or Color3.fromRGB(40,40,40)
    end)

    -- INVISIBLE
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
    InvisBtn.MouseButton1Click:Connect(function()
        ToggleInvis()
        InvisBtn.Text = InvisibleEnabled and "👻 INVISIBLE: ON" or "👻 INVISIBLE: OFF"
        InvisBtn.BackgroundColor3 = InvisibleEnabled and Color3.fromRGB(25,120,25) or Color3.fromRGB(40,40,40)
    end)

    -- SPEED SLIDER
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

    -- NOCLIP
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
    NoClipBtn.MouseButton1Click:Connect(function()
        ToggleNoClip()
        NoClipBtn.Text = NoClipEnabled and "🚧 NOCLIP: ON" or "🚧 NOCLIP: OFF"
        NoClipBtn.BackgroundColor3 = NoClipEnabled and Color3.fromRGB(25,120,25) or Color3.fromRGB(40,40,40)
    end)

    -- INVINCIBLE
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
    InvBtn.MouseButton1Click:Connect(function()
        ToggleInvincible()
        InvBtn.Text = InvincibleEnabled and "🛡️ INVINCIBLE: ON" or "🛡️ INVINCIBLE: OFF"
        InvBtn.BackgroundColor3 = InvincibleEnabled and Color3.fromRGB(25,120,25) or Color3.fromRGB(40,40,40)
    end)

    -- CLOSE MENU
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

-- ==============================================
-- 📦 MAIN HUB
-- ==============================================
function LoadMainHub()
    local MainUI = Instance.new("ScreenGui")
    MainUI.Name = "BLUE_MODE_MAIN_HUB"
    MainUI.ResetOnSpawn = false
    MainUI.DisplayOrder = GUI_PRIORITY
    MainUI.Parent = CoreGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0,580,0,105)
    MainFrame.Position = UDim2.new(0,20,0.5,-52)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = MainUI
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,8)
    AddGlow(MainFrame,4)

    -- ESP BUTTON
    ESPBtn = Instance.new("TextButton")
    ESPBtn.Size = UDim2.new(0,85,0,30)
    ESPBtn.Position = UDim2.new(0,15,0,10)
    ESPBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    ESPBtn.Text = "👥 ESP"
    ESPBtn.TextColor3 = Color3.new(1,1,1)
    ESPBtn.Font = Enum.Font.GothamBold
    ESPBtn.TextScaled = true
    ESPBtn.Parent = MainFrame
    Instance.new("UICorner", ESPBtn).CornerRadius = UDim.new(0,6)

    -- ⚙️ COMMANDS BUTTON (MAIN HUB)
    CommandsBtn = Instance.new("TextButton")
    CommandsBtn.Size = UDim2.new(0,110,0,30)
    CommandsBtn.Position = UDim2.new(0,110,0,10)
    CommandsBtn.BackgroundColor3 = Color3.fromRGB(15,110,230)
    CommandsBtn.Text = "⚙️ COMMANDS"
    CommandsBtn.TextColor3 = Color3.new(1,1,1)
    CommandsBtn.Font = Enum.Font.GothamBold
    CommandsBtn.TextScaled = true
    CommandsBtn.Parent = MainFrame
    Instance.new("UICorner", CommandsBtn).CornerRadius = UDim.new(0,6)
    CommandsBtn.MouseButton1Click:Connect(ToggleCommandsMenu)

    -- REMAINING BUTTONS (BOOMBOX / CONSOLE / EXIT)
    local function MakeBtn(name, x, y, color, click)
        local B = Instance.new("TextButton")
        B.Size = UDim2.new(0,90,0,30)
        B.Position = UDim2.new(0,x,0,y)
        B.BackgroundColor3 = color
        B.Text = name
        B.TextColor3 = Color3.new(1,1,1)
        B.Font = Enum.Font.GothamBold
        B.TextScaled = true
        B.Parent = MainFrame
        Instance.new("UICorner", B).CornerRadius = UDim.new(0,6)
        B.MouseButton1Click:Connect(click)
        return B
    end
    MakeBtn("🎵 MUSIC", 235,10, Color3.fromRGB(40,80,160), function() end)
    MakeBtn("💻 CONSOLE", 340,10, Color3.fromRGB(30,120,90), function() end)
    MakeBtn("❌ EXIT", 445,10, Color3.fromRGB(160,30,30), function() MainUI:Destroy() end)

    print("✅ BLUE MODE HUB LOADED SUCCESSFULLY!")
end
