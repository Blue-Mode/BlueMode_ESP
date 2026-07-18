-- ==============================================
-- BLUE MODE HUB | COMPACT FINAL VERSION
-- ✅ SMALLER / MORE COMPACT WINDOW
-- ✅ Exact Feature List from your design
-- ✅ Visible Rainbow Outline + Rainbow Text
-- ✅ Open Main Hub Button
-- ✅ Made by DwayneKeanTFrancisco / Blue_Mode
-- ==============================================
if getgenv().BlueModeHub_Loaded then return end
getgenv().BlueModeHub_Loaded = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 10) or game:GetService("CoreGui")

-- ==============================================
-- ✅ RAINBOW ANIMATION SYSTEM
-- ==============================================
local RainbowElements = {}
local Hue = 0

local function AddRainbowBorder(target, thickness)
    if not target then return end
    local Outline = Instance.new("UIStroke")
    Outline.Name = "RainbowOutline"
    Outline.Thickness = thickness or 8
    Outline.Transparency = 0
    Outline.LineJoinMode = Enum.LineJoinMode.Round
    Outline.Parent = target
    table.insert(RainbowElements, Outline)
end

local function AddRainbowText(target)
    if not target then return end
    table.insert(RainbowElements, target)
end

RunService.Heartbeat:Connect(function(dt)
    Hue = (Hue + dt * 0.2) % 1
    local Color = Color3.fromHSV(Hue, 1, 1)
    for _,v in pairs(RainbowElements) do
        if v:IsA("UIStroke") then
            v.Color = Color
        elseif v:IsA("TextLabel") or v:IsA("TextButton") then
            v.TextColor3 = Color
        end
    end
end)

-- ==============================================
-- ✅ SMALLER STARTUP SCREEN (EXACT DESIGN)
-- ==============================================
local StartupUI = Instance.new("ScreenGui")
StartupUI.Name = "BLUE_MODE_HUB_STARTUP"
StartupUI.ResetOnSpawn = false
StartupUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
StartupUI.Parent = PlayerGui

-- ✅ SMALLER / COMPACT MAIN FRAME
local StartupFrame = Instance.new("Frame")
StartupFrame.Size = UDim2.new(0,460,0,580) -- Smaller size
StartupFrame.Position = UDim2.new(0.5,-230,0.5,-290)
StartupFrame.BackgroundColor3 = Color3.fromRGB(10,10,10)
StartupFrame.Active = true
StartupFrame.Parent = StartupUI
Instance.new("UICorner", StartupFrame).CornerRadius = UDim.new(0,20)
AddRainbowBorder(StartupFrame, 8) -- ✅ Visible Rainbow Outline

-- TITLE
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,-60,0,60)
Title.Position = UDim2.new(0,30,0,20)
Title.BackgroundTransparency = 1
Title.Text = "🔵 BLUE MODE HUB"
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true
Title.TextXAlignment = Enum.TextXAlignment.Center
Title.Parent = StartupFrame
AddRainbowText(Title)

-- FEATURE LIST HEADER
local ListHeader = Instance.new("TextLabel")
ListHeader.Size = UDim2.new(1,-60,0,50)
ListHeader.Position = UDim2.new(0,30,0,90)
ListHeader.BackgroundTransparency = 1
ListHeader.Text = "📋 FEATURE LIST:"
ListHeader.Font = Enum.Font.GothamBold
ListHeader.TextScaled = true
ListHeader.TextXAlignment = Enum.TextXAlignment.Left
ListHeader.Parent = StartupFrame
AddRainbowText(ListHeader)

-- ✅ YOUR EXACT FEATURE LIST
local FeatureList = Instance.new("TextLabel")
FeatureList.Size = UDim2.new(1,-80,0,260)
FeatureList.Position = UDim2.new(0,40,0,150)
FeatureList.BackgroundTransparency = 1
FeatureList.Text = [[• ESP / FRIEND DOT
• CONSOLE
• MADE BY: DWAYNEKEANTFRANCISCO
• MADE BY: BLUE_MODE
• DELETE BUTTON
• MUSIC]]
FeatureList.Font = Enum.Font.GothamBold
FeatureList.TextScaled = true
FeatureList.TextXAlignment = Enum.TextXAlignment.Left
FeatureList.TextYAlignment = Enum.TextYAlignment.Top
FeatureList.TextLineHeight = 1.6
FeatureList.Parent = StartupFrame
AddRainbowText(FeatureList)

-- ✅ OPEN MAIN HUB BUTTON
local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0,320,0,55)
OpenBtn.Position = UDim2.new(0.5,-160,0,440)
OpenBtn.BackgroundColor3 = Color3.fromRGB(25,25,25)
OpenBtn.Text = "▶ OPEN MAIN HUB"
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextScaled = true
OpenBtn.Parent = StartupFrame
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0,14)
AddRainbowBorder(OpenBtn, 3)
AddRainbowText(OpenBtn)

-- BUTTON ACTION
OpenBtn.MouseButton1Click:Connect(function()
    StartupUI:Destroy()
    print("✅ Opening Main Hub...")
    LoadMainHub()
end)

-- ==============================================
-- ✅ MAIN HUB (MATCHES SMALLER SCALE)
-- ==============================================
function LoadMainHub()
    local MainUI = Instance.new("ScreenGui")
    MainUI.Name = "BLUE_MODE_HUB_MAIN"
    MainUI.ResetOnSpawn = false
    MainUI.Parent = PlayerGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0,580,0,100) -- Also compact
    MainFrame.Position = UDim2.new(0,20,0.5,-50)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15,15,15)
    MainFrame.Active = true
    MainFrame.Parent = MainUI
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,10)
    AddRainbowBorder(MainFrame, 5)

    local Bar = Instance.new("TextLabel")
    Bar.Size = UDim2.new(1,-40,0,25)
    Bar.Position = UDim2.new(0,10,0,5)
    Bar.BackgroundTransparency = 1
    Bar.Text = "🔵 BLUE MODE HUB | MAIN CONTROLS"
    Bar.Font = Enum.Font.GothamBold
    Bar.TextScaled = true
    Bar.Parent = MainFrame
    AddRainbowText(Bar)

    print("✅ MAIN HUB LOADED!")
end
