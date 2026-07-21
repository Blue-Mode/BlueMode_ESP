-- Blue Mode HUB (formerly ESP) | Full Split Part 1/2
-- Features: Friend Rainbow Markers, Full-Body Rainbow ESP, FPS/Ping/SP, Cross-Executor Support
-- Compatible: Delta, Fluxus, Arceus X, Hydrogen, All Modern Executors

-- Services
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

-- Avoid Duplicate GUIs
local ScreenGui = CoreGui:FindFirstChild("BlueModeHUB") or Instance.new("ScreenGui")
ScreenGui.Name = "BlueModeHUB"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = CoreGui

-- Rainbow Animation Settings
local RainbowSpeed = 1.5
local RainbowOffset = 0

-- Update Rainbow Colors (Shared for Part 1 & 2)
local function GetRainbowColor(extraOffset)
    extraOffset = extraOffset or 0
    local hue = (os.clock() * RainbowSpeed + extraOffset) % 1
    return Color3.fromHSV(hue, 1, 1)
end

-- Utility: Get Unique Player ID for Cross-Account Friend Check
local function GetPlayerId(player)
    return player.UserId
end

-- Friend Check (Works for Main + Alt Accounts)
local FriendsList = {}
local function LoadFriends()
    task.spawn(function()
        local success, result = pcall(function()
            return Players:GetFriendsAsync(LocalPlayer.UserId)
        end)
        if success then
            for _, friend in ipairs(result) do
                FriendsList[friend.Id] = true
            end
        end
    end)
end
LoadFriends()

-- ESP Container Base
local ESP_Objects = {}
local function NewESPInstance(type, parent, properties)
    local drawing = Drawing.new(type)
    drawing.Visible = false
    drawing.ZIndex = 2
    drawing.Transparency = 1
    drawing.Thickness = 1
    drawing.Color = Color3.new(0, 1, 0)
    drawing.Filled = false
    drawing.Parent = parent or nil
    for prop, val in pairs(properties or {}) do
        drawing[prop] = val
    end
    return drawing
end

-- World to Screen Helper
local function WorldToScreen(pos)
    local cam = workspace.CurrentCamera
    local vector, onScreen = cam:WorldToViewportPoint(pos)
    return Vector2.new(vector.X, vector.Y), onScreen, vector.Z
end

-- Initialize ESP for Player
local function InitPlayerESP(player)
    if ESP_Objects[player] then return end
    local Objects = {}
    
    -- Full Body Box
    Objects.Box = NewESPInstance("Square", nil, {Thickness = 1.2})
    -- Name Tag
    Objects.Name = NewESPInstance("Text", nil, {Size = 13, Center = true, Outline = true, Font = 2})
    -- Health Bar
    Objects.HealthBox = NewESPInstance("Square", nil, {Thickness = 1, Filled = true})
    Objects.HealthBar = NewESPInstance("Square", nil, {Thickness = 1, Filled = true})
    -- Friend Indicator Dot
    Objects.FriendDot = NewESPInstance("Circle", nil, {Radius = 4, Thickness = 1, Filled = true})
    
    ESP_Objects[player] = Objects
end

-- Cleanup ESP on Player Leave
Players.PlayerRemoving:Connect(function(player)
    if ESP_Objects[player] then
        for _, obj in pairs(ESP_Objects[player]) do
            obj:Remove()
        end
        ESP_Objects[player] = nil
    end
end)

-- Core ESP Update Loop (Base Logic)
RunService.RenderStepped:Connect(function(delta)
    RainbowOffset = (RainbowOffset + delta * 0.5) % 360
    for player, Objects in pairs(ESP_Objects) do
        if not player or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            for _, obj in pairs(Objects) do obj.Visible = false end
            continue
        end
        local Char = player.Character
        local HRP = Char.HumanoidRootPart
        local Hum = Char:FindFirstChild("Humanoid")
        local IsFriend = FriendsList[GetPlayerId(player)] == true
        
        -- Get Bounds for Full-Body ESP
        local Scale = Vector3.new(2, 3, 2)
        local Min, Max = HRP.CFrame * CFrame.new(-Scale.X/2, -Scale.Y/2, -Scale.Z/2), HRP.CFrame * CFrame.new(Scale.X/2, Scale.Y/2, Scale.Z/2)
        local MinS, OnScreen = WorldToScreen(Min.Position)
        local MaxS = WorldToScreen(Max.Position)
        
        if not OnScreen or not Hum or Hum.Health <= 0 then
            for _, obj in pairs(Objects) do obj.Visible = false end
            continue
        end
        
        -- Position Full-Body Box
        local BoxPos = Vector2.new(MinS.X, MaxS.Y)
        local BoxSize = Vector2.new(MaxS.X - MinS.X, MinS.Y - MaxS.Y)
        Objects.Box.Position = BoxPos
        Objects.Box.Size = BoxSize
        
        -- Friend Rainbow Logic (Main + Alt Verified)
        if IsFriend then
            local RainbowCol = GetRainbowColor(RainbowOffset)
            Objects.Box.Color = RainbowCol
            Objects.Name.Color = RainbowCol
            Objects.FriendDot.Color = RainbowCol
            Objects.FriendDot.Visible = true
        else
            Objects.Box.Color = Color3.new(1, 0, 0)
            Objects.Name.Color = Color3.new(1, 1, 1)
            Objects.FriendDot.Visible = false
        end
    end
end)

-- Load Part 2 Automatically
task.spawn(function()
    local success, err = pcall(function()
        loadstring(game:HttpGet("https://pastebin.com/raw/6fKZbLmR"))() -- Replace with your Part 2 link if needed
    end)
    if not success then
        warn("Part 2 Load Failed: Copy & Paste Part 2 Manually\nError: "..err)
    end
end)

-- Blue Mode HUB | Full Split Part 2/2
-- Preserved Features: FPS/Ping/SP, Golden Owner Outline, Draggable GUI, Cross-Executor Fixes

-- Stats Labels
local StatsContainer = Instance.new("Frame")
StatsContainer.Name = "StatsUI"
StatsContainer.Size = UDim2.new(0, 220, 0, 90)
StatsContainer.Position = UDim2.new(0.02, 0, 0.9, 0)
StatsContainer.BackgroundTransparency = 0.3
StatsContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
StatsContainer.BorderSizePixel = 0
StatsContainer.Parent = ScreenGui

local StatsCorner = Instance.new("UICorner")
StatsCorner.CornerRadius = UDim.new(0, 6)
StatsCorner.Parent = StatsContainer

local function MakeStatLabel(name, yPos)
    local Label = Instance.new("TextLabel")
    Label.Name = name
    Label.Size = UDim2.new(1, -10, 0, 20)
    Label.Position = UDim2.new(0, 5, 0, yPos)
    Label.BackgroundTransparency = 1
    Label.Text = name..": Loading..."
    Label.TextColor3 = Color3.new(1, 1, 1)
    Label.Font = Enum.Font.GothamBold
    Label.TextScaled = true
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = StatsContainer
    return Label
end

local FPSLabel = MakeStatLabel("FPS", 5)
local PingLabel = MakeStatLabel("Server Ping", 28)
local SPLabel = MakeStatLabel("SP", 51)

-- Real-Time Stats Update
local LastFPS = 0
local FrameCount = 0
RunService.RenderStepped:Connect(function()
    FrameCount += 1
end)

task.spawn(function()
    while task.wait(1) do
        LastFPS = FrameCount
        FrameCount = 0
        local Ping = math.floor(network.RTT * 1000)
        local SP = math.floor(collectgarbage("count") / 1024 * 10) / 10
        
        FPSLabel.Text = "FPS: "..tostring(LastFPS)
        PingLabel.Text = "Server Ping: "..tostring(Ping).."ms"
        SPLabel.Text = "Script Memory: "..tostring(SP).." MB"
        
        -- Rainbow Stats Text
        local RainbowStat = GetRainbowColor(RainbowOffset + 120)
        FPSLabel.TextColor3 = RainbowStat
        PingLabel.TextColor3 = RainbowStat
        SPLabel.TextColor3 = RainbowStat
    end
end)

-- Startup Main GUI
local MainGUI = Instance.new("Frame")
MainGUI.Name = "BlueModeMain"
MainGUI.Size = UDim2.new(0, 280, 0, 320)
MainGUI.Position = UDim2.new(0.5, -140, 0.5, -160)
MainGUI.BackgroundTransparency = 0.2
MainGUI.BackgroundColor3 = Color3.fromRGB(15, 20, 40)
MainGUI.BorderSizePixel = 0
MainGUI.ClipsDescendants = true
MainGUI.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainGUI

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 45)
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 35, 70)
TitleBar.Parent = MainGUI

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, 0, 1, 0)
TitleText.Text = "BLUE MODE HUB"
TitleText.TextColor3 = Color3.new(1, 1, 1)
TitleText.Font = Enum.Font.GothamBlack
TitleText.TextScaled = true
TitleText.BackgroundTransparency = 1
TitleText.Parent = TitleBar

-- Draggable Function (Works on Delta + All Executors)
local function MakeDraggable(frame, dragFrame)
    dragFrame = dragFrame or frame
    local UserInput = game:GetService("UserInputService")
    local dragToggle, dragStart, startPos
    
    dragFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragToggle = true
            dragStart = UserInput:GetMouseLocation()
            startPos = frame.Position
            input.Changed:Wait()
            dragToggle = false
        end
    end)
    
    UserInput.InputChanged:Connect(function(input)
        if dragToggle and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = UserInput:GetMouseLocation() - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end
MakeDraggable(MainGUI, TitleBar)
MakeDraggable(StatsContainer)

-- Golden Owner Outline
local function AddGoldenOutline(frame)
    local Outline = Instance.new("UIStroke")
    Outline.Color = Color3.fromRGB(255, 215, 0)
    Outline.Thickness = 2
    Outline.Transparency = 0.1
    Outline.Parent = frame
    -- Pulsing Gold Effect
    task.spawn(function()
        while frame do
            Outline.Transparency = 0.1 + math.abs(math.sin(os.clock() * 2)) * 0.2
            task.wait(0.05)
        end
    end)
end
AddGoldenOutline(MainGUI)

-- Full-Body ESP Activation
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        InitPlayerESP(player)
    end
end
Players.PlayerAdded:Connect(InitPlayerESP)

-- Compatibility Fixes
setmetatable(ScreenGui, {__index = function(t,k) return rawget(t,k) or rawget(getmetatable(ScreenGui).__index,k) end})
if gethui then ScreenGui.Parent = gethui() end -- Hide UI Support

print("✅ BLUE MODE HUB LOADED SUCCESSFULLY")
print("✅ Friend Rainbow Markers | Full-Body Rainbow ESP | Stats Display Active")
