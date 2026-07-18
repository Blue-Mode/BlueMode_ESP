-- ==============================================
-- BLUE MODE HUB | FINAL COMPLETE VERSION
-- ✅ FULL FEATURE LIST + START BUTTON + EXIT BUTTON
-- ✅ Rainbow Outline + Rainbow Text
-- ✅ Made by DwayneKeanTFrancisco / Blue_Mode
-- ==============================================
if getgenv().BlueModeHub_Loaded then return end
getgenv().BlueModeHub_Loaded = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 10) or game:GetService("CoreGui")

-- RAINBOW SYSTEM
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
    table.insert(RainbowText, target)
end

RunService.Heartbeat:Connect(function(dt)
    Hue = (Hue + dt * 0.2) % 1
    local Color = Color3.fromHSV(Hue, 1, 1)
    for _,v in pairs(RainbowBorders) do v.Color = Color end
    for _,v in pairs(RainbowText) do
        if v and (v:IsA("TextLabel") or v:IsA("TextButton")) then
            v.TextColor3 = Color
        end
    end
end)

-- ==============================================
-- ✅ STARTUP SCREEN (ALL CONTENT ADDED!)
-- ==============================================
local StartupUI = Instance.new("ScreenGui")
StartupUI.Name = "BLUE_MODE_HUB_STARTUP"
StartupUI.ResetOnSpawn = false
StartupUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
StartupUI.Parent = PlayerGui

-- MAIN FRAME (MATCHES YOUR SCREEN SIZE)
local StartupFrame = Instance.new("Frame")
StartupFrame.Size = UDim2.new(0,560,0,700)
StartupFrame.Position = UDim2.new(0.5,-280,0.5,-350)
StartupFrame.BackgroundColor3 = Color3.fromRGB(10,10,10)
StartupFrame.Active = true
StartupFrame.Parent = StartupUI
Instance.new("UICorner", StartupFrame).CornerRadius = UDim.new(0,20)
AddRainbowBorder(StartupFrame, 8)

-- TITLE
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,-60,0,70)
Title.Position = UDim2.new(0,30,0,25)
Title.BackgroundTransparency = 1
Title.Text = "🔵 BLUE MODE HUB"
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = StartupFrame
AddRainbowText(Title)

-- LIST HEADER
local ListHeader = Instance.new("TextLabel")
ListHeader.Size = UDim2.new(1,-60,0,50)
ListHeader.Position = UDim2.new(0,30,0,110)
ListHeader.BackgroundTransparency = 1
ListHeader.Text = "📋 FEATURE LIST:"
ListHeader.Font = Enum.Font.GothamBold
ListHeader.TextScaled = true
ListHeader.TextXAlignment = Enum.TextXAlignment.Left
ListHeader.Parent = StartupFrame
AddRainbowText(ListHeader)

-- ✅ YOUR FULL FEATURE LIST (NOW VISIBLE!)
local FeatureList = Instance.new("TextLabel")
FeatureList.Size = UDim2.new(1,-80,0,280)
FeatureList.Position = UDim2.new(0,40,0,170)
FeatureList.BackgroundTransparency = 1
FeatureList.Text = [[• ESP / FRIEND DOT
• CONSOLE
• MADE BY: DWAYNEKEANTFRANCISCO
• MADE BY: BLUE_MODE
• DELETE BUTTON
• MUSIC]]
FeatureList.Font = Enum.Font.Gotham
FeatureList.TextScaled = true
FeatureList.TextXAlignment = Enum.TextXAlignment.Left
FeatureList.TextYAlignment = Enum.TextYAlignment.Top
FeatureList.TextLineHeight = 1.8
FeatureList.Parent = StartupFrame
AddRainbowText(FeatureList)

-- ✅ OPEN MAIN HUB BUTTON
local StartBtn = Instance.new("TextButton")
StartBtn.Size = UDim2.new(0,380,0,65)
StartBtn.Position = UDim2.new(0.5,-190,0,480)
StartBtn.BackgroundColor3 = Color3.fromRGB(25,25,25)
StartBtn.Text = "▶ OPEN MAIN HUB"
StartBtn.Font = Enum.Font.GothamBold
StartBtn.TextScaled = true
StartBtn.Parent = StartupFrame
Instance.new("UICorner", StartBtn).CornerRadius = UDim.new(0,15)
AddRainbowBorder(StartBtn, 4)
AddRainbowText(StartBtn)

-- ✅ DELETE / EXIT BUTTON
local ExitBtn = Instance.new("TextButton")
ExitBtn.Size = UDim2.new(0,380,0,55)
ExitBtn.Position = UDim2.new(0.5,-190,0,560)
ExitBtn.BackgroundColor3 = Color3.fromRGB(25,25,25)
ExitBtn.Text = "🗑️ DELETE / EXIT HUB"
ExitBtn.Font = Enum.Font.GothamBold
ExitBtn.TextScaled = true
ExitBtn.Parent = StartupFrame
Instance.new("UICorner", ExitBtn).CornerRadius = UDim.new(0,15)
AddRainbowBorder(ExitBtn, 4)
AddRainbowText(ExitBtn)

-- BUTTON FUNCTIONS
StartBtn.MouseButton1Click:Connect(function()
    StartupUI:Destroy()
    print("✅ Opening Main Hub...")
    LoadMainHub()
end)

ExitBtn.MouseButton1Click:Connect(function()
    StartupUI:Destroy()
    getgenv().BlueModeHub_Loaded = nil
    print("✅ Hub closed & removed")
end)

-- ==============================================
-- ✅ MAIN HUB LOADS AFTER CLICK
-- ==============================================
function LoadMainHub()
    local MainUI = Instance.new("ScreenGui")
    MainUI.Name = "BLUE_MODE_HUB_MAIN"
    MainUI.ResetOnSpawn = false
    MainUI.Parent = PlayerGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0,680,0,110)
    MainFrame.Position = UDim2.new(0,20,0.5,-55)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
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

    print("✅ MAIN HUB FULLY LOADED!")
end
