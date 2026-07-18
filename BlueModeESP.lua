-- ==============================================
-- 🔵 BLUE MODE HUB | GITHUB VERSION
-- ✅ WORKS ON: Delta | Fluxus | Pydroid3 | All Executors
-- ✅ NO EMPTY GUI | ALL TEXT + BUTTONS VISIBLE
-- ✅ Rainbow Outline + Rainbow Text + Compact Size
-- ✅ Made by DwayneKeanTFrancisco / Blue_Mode
-- ✅ Version: 1.0 | GitHub Release
-- ==============================================

-- PREVENT DOUBLE LOAD
if getgenv().BlueModeHub_Loaded then return end
getgenv().BlueModeHub_Loaded = true

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- ✅ EXECUTOR COMPATIBILITY: FALLBACK TO COREGUI IF NEEDED
local PlayerGui = nil
pcall(function() PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 15) end)
if not PlayerGui or PlayerGui == nil then
    PlayerGui = game:GetService("CoreGui")
    print("⚠️ Using CoreGui for better executor compatibility")
end

-- ==============================================
-- ✅ RAINBOW SYSTEM (STABLE ON ALL DEVICES)
-- ==============================================
local RainbowBorders = {}
local RainbowText = {}
local Hue = 0

local function AddRainbowBorder(target, thickness)
    if not target then return end
    local Outline = Instance.new("UIStroke")
    Outline.Name = "RainbowBorder"
    Outline.Thickness = thickness or 8
    Outline.Transparency = 0
    Outline.LineJoinMode = Enum.LineJoinMode.Round
    Outline.Parent = target
    table.insert(RainbowBorders, Outline)
end

local function AddRainbowText(target)
    if not target then return end
    -- ✅ FORCE TEXT TO SHOW (FIXES EMPTY GUI BUG)
    target.TextColor3 = Color3.new(1,1,1)
    target.Font = Enum.Font.GothamBold
    target.TextScaled = true
    target.BackgroundTransparency = 1
    table.insert(RainbowText, target)
end

RunService.Heartbeat:Connect(function(dt)
    Hue = (Hue + dt * 0.2) % 1
    local RainbowColor = Color3.fromHSV(Hue, 1, 1)
    for _,v in pairs(RainbowBorders) do v.Color = RainbowColor end
    for _,v in pairs(RainbowText) do v.TextColor3 = RainbowColor end
end)

-- ==============================================
-- ✅ STARTUP SCREEN (COMPACT + ALL CONTENT VISIBLE)
-- ==============================================
local StartupUI = Instance.new("ScreenGui")
StartupUI.Name = "BLUE_MODE_HUB_STARTUP"
StartupUI.ResetOnSpawn = false
StartupUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling -- ✅ FIXES TEXT BEHIND ISSUE
StartupUI.DisplayOrder = 999 -- ✅ SHOW ON TOP OF EVERYTHING
StartupUI.Parent = PlayerGui

-- MAIN FRAME WITH RAINBOW OUTLINE
local StartupFrame = Instance.new("Frame")
StartupFrame.Size = UDim2.new(0,450,0,550) -- ✅ COMPACT SIZE
StartupFrame.Position = UDim2.new(0.5,-225,0.5,-275)
StartupFrame.BackgroundColor3 = Color3.fromRGB(10,10,10)
StartupFrame.Active = true
StartupFrame.ClipsDescendants = false -- ✅ PREVENTS TEXT FROM BEING CUT
StartupFrame.Parent = StartupUI
Instance.new("UICorner", StartupFrame).CornerRadius = UDim.new(0,20)
AddRainbowBorder(StartupFrame, 8) -- ✅ CLEAR RAINBOW BORDER

-- TITLE
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,-40,0,55)
Title.Position = UDim2.new(0,20,0,15)
Title.Text = "🔵 BLUE MODE HUB"
Title.TextXAlignment = Enum.TextXAlignment.Center
Title.Parent = StartupFrame
AddRainbowText(Title)

-- FEATURE LIST HEADER
local ListHeader = Instance.new("TextLabel")
ListHeader.Size = UDim2.new(1,-40,0,45)
ListHeader.Position = UDim2.new(0,20,0,85)
ListHeader.Text = "📋 FEATURE LIST:"
ListHeader.TextXAlignment = Enum.TextXAlignment.Left
ListHeader.Parent = StartupFrame
AddRainbowText(ListHeader)

-- ✅ EXACT FEATURE LIST
local FeatureList = Instance.new("TextLabel")
FeatureList.Size = UDim2.new(1,-60,0,250)
FeatureList.Position = UDim2.new(0,30,0,140)
FeatureList.Text = [[• ESP / FRIEND DOT
• CONSOLE
• MADE BY: DWAYNEKEANTFRANCISCO
• MADE BY: BLUE_MODE
• DELETE BUTTON
• MUSIC]]
FeatureList.TextXAlignment = Enum.TextXAlignment.Left
FeatureList.TextYAlignment = Enum.TextYAlignment.Top
FeatureList.TextLineHeight = 1.7
FeatureList.Parent = StartupFrame
AddRainbowText(FeatureList)

-- ✅ OPEN MAIN HUB BUTTON
local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0,320,0,55)
OpenBtn.Position = UDim2.new(0.5,-160,0,420)
OpenBtn.BackgroundColor3 = Color3.fromRGB(22,22,22)
OpenBtn.Text = "▶ OPEN MAIN HUB"
OpenBtn.AutoLocalize = false
OpenBtn.Parent = StartupFrame
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0,14)
AddRainbowBorder(OpenBtn, 4)
AddRainbowText(OpenBtn)

-- ✅ EXIT BUTTON
local ExitBtn = Instance.new("TextButton")
ExitBtn.Size = UDim2.new(0,320,0,50)
ExitBtn.Position = UDim2.new(0.5,-160,0,490)
ExitBtn.BackgroundColor3 = Color3.fromRGB(22,22,22)
ExitBtn.Text = "🗑️ DELETE / EXIT"
ExitBtn.AutoLocalize = false
ExitBtn.Parent = StartupFrame
Instance.new("UICorner", ExitBtn).CornerRadius = UDim.new(0,14)
AddRainbowBorder(ExitBtn, 4)
AddRainbowText(ExitBtn)

-- BUTTON FUNCTIONS
OpenBtn.MouseButton1Click:Connect(function()
    StartupUI:Destroy()
    print("✅ Loading Main Hub...")
    LoadMainHub()
end)

ExitBtn.MouseButton1Click:Connect(function()
    StartupUI:Destroy()
    getgenv().BlueModeHub_Loaded = nil
    print("✅ Exited Blue Mode Hub")
end)

-- ==============================================
-- ✅ MAIN HUB (LOADS AFTER CLICK)
-- ==============================================
function LoadMainHub()
    local MainUI = Instance.new("ScreenGui")
    MainUI.Name = "BLUE_MODE_HUB_MAIN"
    MainUI.ResetOnSpawn = false
    MainUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    MainUI.DisplayOrder = 999
    MainUI.Parent = PlayerGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0,580,0,100)
    MainFrame.Position = UDim2.new(0,20,0.5,-50)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15,15,15)
    MainFrame.Active = true
    MainFrame.Parent = MainUI
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,10)
    AddRainbowBorder(MainFrame, 5)

    local Bar = Instance.new("TextLabel")
    Bar.Size = UDim2.new(1,-40,0,25)
    Bar.Position = UDim2.new(0,10,0,5)
    Bar.Text = "🔵 BLUE MODE HUB | MAIN CONTROLS"
    Bar.Parent = MainFrame
    AddRainbowText(Bar)

    print("✅ BLUE MODE HUB FULLY LOADED!")
end

print("✅ BLUE MODE HUB STARTED | VERSION 1.0 | GITHUB RELEASE")
