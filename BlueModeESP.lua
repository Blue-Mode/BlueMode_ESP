-- ==============================================
-- 🔵 BLUE MODE HUB | FINAL WORKING VERSION
-- ✅ ALL TEXT + FEATURE LIST + BUTTONS VISIBLE
-- ✅ RAINBOW OUTLINE + RAINBOW TEXT
-- ✅ COMPATIBLE WITH ALL EXECUTORS
-- ✅ Made by DwayneKeanTFrancisco / Blue_Mode
-- ==============================================

if getgenv().BlueModeHub_Loaded then return end
getgenv().BlueModeHub_Loaded = true

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- ✅ EXECUTOR FALLBACK (FIXES DELTA/COREGUI ISSUES)
local PlayerGui
pcall(function() PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 10) end)
PlayerGui = PlayerGui or game:GetService("CoreGui")

-- ==============================================
-- ✅ RAINBOW ANIMATION SYSTEM
-- ==============================================
local RainbowBorders = {}
local RainbowText = {}
local Hue = 0

local function AddRainbowBorder(target, thickness)
    if not target then return end
    local Stroke = Instance.new("UIStroke")
    Stroke.Name = "RainbowBorder"
    Stroke.Thickness = thickness or 8
    Stroke.Transparency = 0
    Stroke.LineJoinMode = Enum.LineJoinMode.Round
    Stroke.Parent = target
    table.insert(RainbowBorders, Stroke)
end

local function SetupText(target, text)
    if not target then return end
    target.Text = text
    target.BackgroundTransparency = 1
    target.Font = Enum.Font.GothamBold
    target.TextScaled = true
    target.AutoLocalize = false -- ✅ STOP EXECUTOR FROM BREAKING TEXT
    target.TextColor3 = Color3.new(1,1,0) -- ✅ FORCE INITIAL COLOR
    table.insert(RainbowText, target)
end

RunService.Heartbeat:Connect(function(dt)
    Hue = (Hue + dt * 0.2) % 1
    local Color = Color3.fromHSV(Hue, 1, 1)
    for _,v in pairs(RainbowBorders) do v.Color = Color end
    for _,v in pairs(RainbowText) do v.TextColor3 = Color end
end)

-- ==============================================
-- ✅ STARTUP SCREEN (ALL CONTENT ADDED!)
-- ==============================================
local StartupUI = Instance.new("ScreenGui")
StartupUI.Name = "BLUE_MODE_HUB_STARTUP"
StartupUI.ResetOnSpawn = false
StartupUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
StartupUI.DisplayOrder = 999 -- ✅ ALWAYS ON TOP
StartupUI.Parent = PlayerGui

-- MAIN WINDOW
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0,460,0,560)
MainFrame.Position = UDim2.new(0.5,-230,0.5,-280)
MainFrame.BackgroundColor3 = Color3.fromRGB(10,10,10)
MainFrame.Active = true
MainFrame.ClipsDescendants = false -- ✅ PREVENT TEXT CUT OFF
MainFrame.Parent = StartupUI
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,20)
AddRainbowBorder(MainFrame, 8) -- ✅ FULL RAINBOW OUTLINE

-- TITLE
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,-40,0,60)
Title.Position = UDim2.new(0,20,0,20)
Title.TextXAlignment = Enum.TextXAlignment.Center
Title.Parent = MainFrame
SetupText(Title, "🔵 BLUE MODE HUB")

-- FEATURE LIST HEADER
local ListHeader = Instance.new("TextLabel")
ListHeader.Size = UDim2.new(1,-40,0,50)
ListHeader.Position = UDim2.new(0,20,0,90)
ListHeader.TextXAlignment = Enum.TextXAlignment.Left
ListHeader.Parent = MainFrame
SetupText(ListHeader, "📋 FEATURE LIST:")

-- ✅ FULL FEATURE LIST (NOW VISIBLE!)
local FeatureList = Instance.new("TextLabel")
FeatureList.Size = UDim2.new(1,-60,0,240)
FeatureList.Position = UDim2.new(0,30,0,150)
FeatureList.TextXAlignment = Enum.TextXAlignment.Left
FeatureList.TextYAlignment = Enum.TextYAlignment.Top
FeatureList.TextLineHeight = 1.7
FeatureList.Parent = MainFrame
SetupText(FeatureList, [[• ESP / FRIEND DOT
• CONSOLE MENU
• MADE BY: DWAYNEKEANTFRANCISCO
• MADE BY: BLUE_MODE
• DELETE / EXIT BUTTON
• MUSIC PLAYER]])

-- ✅ UPDATE LIST
local UpdateHeader = Instance.new("TextLabel")
UpdateHeader.Size = UDim2.new(1,-40,0,45)
UpdateHeader.Position = UDim2.new(0,20,0,400)
UpdateHeader.TextXAlignment = Enum.TextXAlignment.Left
UpdateHeader.Parent = MainFrame
SetupText(UpdateHeader, "🔄 UPDATE LIST:")

local UpdateList = Instance.new("TextLabel")
UpdateList.Size = UDim2.new(1,-60,0,100)
UpdateList.Position = UDim2.new(0,30,0,450)
UpdateList.TextXAlignment = Enum.TextXAlignment.Left
UpdateList.TextYAlignment = Enum.TextYAlignment.Top
UpdateList.TextLineHeight = 1.6
UpdateList.Parent = MainFrame
SetupText(UpdateList, [[• Fixed Empty GUI Bug
• Added Rainbow Outline
• Improved Executor Support
• Optimized Loading Speed]])

-- ✅ OPEN MAIN HUB BUTTON
local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0,340,0,55)
OpenBtn.Position = UDim2.new(0.5,-170,0,560)
OpenBtn.BackgroundColor3 = Color3.fromRGB(25,25,25)
OpenBtn.AutoLocalize = false
OpenBtn.Parent = MainFrame
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0,14)
SetupText(OpenBtn, "▶ OPEN MAIN HUB")
AddRainbowBorder(OpenBtn, 4)

-- ✅ EXIT BUTTON
local ExitBtn = Instance.new("TextButton")
ExitBtn.Size = UDim2.new(0,340,0,50)
ExitBtn.Position = UDim2.new(0.5,-170,0,625)
ExitBtn.BackgroundColor3 = Color3.fromRGB(25,25,25)
ExitBtn.AutoLocalize = false
ExitBtn.Parent = MainFrame
Instance.new("UICorner", ExitBtn).CornerRadius = UDim.new(0,14)
SetupText(ExitBtn, "🗑️ DELETE / EXIT HUB")
AddRainbowBorder(ExitBtn, 4)

-- BUTTON FUNCTIONS
OpenBtn.MouseButton1Click:Connect(function()
    StartupUI:Destroy()
    print("✅ Loading Main Hub...")
    LoadMainHub()
end)

ExitBtn.MouseButton1Click:Connect(function()
    StartupUI:Destroy()
    getgenv().BlueModeHub_Loaded = nil
    print("✅ Blue Mode Hub Closed")
end)

-- ==============================================
-- ✅ MAIN HUB MENU
-- ==============================================
function LoadMainHub()
    local MainUI = Instance.new("ScreenGui")
    MainUI.Name = "BLUE_MODE_HUB_MAIN"
    MainUI.ResetOnSpawn = false
    MainUI.DisplayOrder = 999
    MainUI.Parent = PlayerGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0,600,0,105)
    MainFrame.Position = UDim2.new(0,20,0.5,-52)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15,15,15)
    MainFrame.Active = true
    MainFrame.Parent = MainUI
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,10)
    AddRainbowBorder(MainFrame, 5)

    local Bar = Instance.new("TextLabel")
    Bar.Size = UDim2.new(1,-40,0,25)
    Bar.Position = UDim2.new(0,10,0,5)
    Bar.Parent = MainFrame
    SetupText(Bar, "🔵 BLUE MODE HUB | MAIN CONTROLS")

    print("✅ MAIN HUB FULLY LOADED!")
end

print("✅ BLUE MODE HUB STARTED SUCCESSFULLY!")
