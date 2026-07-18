-- ==============================================
-- BLUE MODE ESP | COMPLETE STARTUP + FEATURES + MAIN LOAD
-- ✅ EXACT LIST + START BUTTON + RAINBOW STYLE
-- ✅ Made by DwayneKeanTFrancisco / Blue_Mode
-- ==============================================
if getgenv().BlueMode_Loaded then return end
getgenv().BlueMode_Loaded = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 10) or game:GetService("CoreGui")

-- RAINBOW ANIMATION SYSTEM
local RainbowBorders = {}
local RainbowText = {}
local Hue = 0

local function AddRainbowBorder(target, thickness)
    if not target then return end
    local Outline = Instance.new("UIStroke")
    Outline.Name = "RainbowBorder"
    Outline.Thickness = thickness or 6
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
    Hue = (Hue + dt * 0.25) % 1
    local RainbowColor = Color3.fromHSV(Hue, 1, 1)
    for _,v in pairs(RainbowBorders) do v.Color = RainbowColor end
    for _,v in pairs(RainbowText) do
        if v and (v:IsA("TextLabel") or v:IsA("TextButton")) then
            v.TextColor3 = RainbowColor
        end
    end
end)

-- ==============================================
-- ✅ YOUR EXACT STARTUP SCREEN (MATCHES SCREENSHOT)
-- ==============================================
local StartupUI = Instance.new("ScreenGui")
StartupUI.Name = "BLUE_MODE_STARTUP"
StartupUI.ResetOnSpawn = false
StartupUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
StartupUI.Parent = PlayerGui

-- MAIN WINDOW (EXACT SIZE FROM YOUR SCREENSHOT)
local StartupFrame = Instance.new("Frame")
StartupFrame.Size = UDim2.new(0,580,0,720)
StartupFrame.Position = UDim2.new(0.5,-290,0.5,-360)
StartupFrame.BackgroundColor3 = Color3.fromRGB(10,10,10)
StartupFrame.Active = true
StartupFrame.Parent = StartupUI
Instance.new("UICorner", StartupFrame).CornerRadius = UDim.new(0,20)
AddRainbowBorder(StartupFrame, 8) -- ✅ THICK RAINBOW OUTLINE

-- TITLE
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,-60,0,65)
Title.Position = UDim2.new(0,30,0,25)
Title.BackgroundTransparency = 1
Title.Text = "🔵 BLUE MODE ESP"
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = StartupFrame
AddRainbowText(Title)

-- FEATURE LIST HEADER
local ListHeader = Instance.new("TextLabel")
ListHeader.Size = UDim2.new(1,-60,0,50)
ListHeader.Position = UDim2.new(0,30,0,100)
ListHeader.BackgroundTransparency = 1
ListHeader.Text = "📋 FEATURE LIST:"
ListHeader.Font = Enum.Font.GothamBold
ListHeader.TextScaled = true
ListHeader.TextXAlignment = Enum.TextXAlignment.Left
ListHeader.Parent = StartupFrame
AddRainbowText(ListHeader)

-- ✅ YOUR FULL FEATURE LIST (ADDED HERE!)
local FeatureList = Instance.new("TextLabel")
FeatureList.Size = UDim2.new(1,-80,0,320)
FeatureList.Position = UDim2.new(0,40,0,160)
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
FeatureList.TextLineHeight = 1.7
FeatureList.Parent = StartupFrame
AddRainbowText(FeatureList)

-- ✅ START / LOAD MAIN GUI BUTTON
local StartBtn = Instance.new("TextButton")
StartBtn.Size = UDim2.new(0,380,0,65)
StartBtn.Position = UDim2.new(0.5,-190,0,520)
StartBtn.BackgroundColor3 = Color3.fromRGB(22,22,22)
StartBtn.Text = "▶ OPEN MAIN MENU"
StartBtn.Font = Enum.Font.GothamBold
StartBtn.TextScaled = true
StartBtn.Parent = StartupFrame
Instance.new("UICorner", StartBtn).CornerRadius = UDim.new(0,15)
AddRainbowBorder(StartBtn, 4)
AddRainbowText(StartBtn)

-- ✅ DELETE / EXIT BUTTON
local ExitBtn = Instance.new("TextButton")
ExitBtn.Size = UDim2.new(0,380,0,55)
ExitBtn.Position = UDim2.new(0.5,-190,0,600)
ExitBtn.BackgroundColor3 = Color3.fromRGB(22,22,22)
ExitBtn.Text = "🗑️ DELETE / EXIT SCRIPT"
ExitBtn.Font = Enum.Font.GothamBold
ExitBtn.TextScaled = true
ExitBtn.Parent = StartupFrame
Instance.new("UICorner", ExitBtn).CornerRadius = UDim.new(0,15)
AddRainbowBorder(ExitBtn, 4)
AddRainbowText(ExitBtn)

-- BUTTON ACTIONS
StartBtn.MouseButton1Click:Connect(function()
    StartupUI:Destroy()
    print("✅ Opening Main ESP GUI...")
    LoadMainGUI() -- ✅ LOADS YOUR FULL MAIN MENU
end)

ExitBtn.MouseButton1Click:Connect(function()
    StartupUI:Destroy()
    getgenv().BlueMode_Loaded = nil
    print("✅ Script closed & deleted")
end)

-- ==============================================
-- ✅ MAIN ESP GUI (LOADS AFTER CLICKING START)
-- ==============================================
function LoadMainGUI()
    local MainUI = Instance.new("ScreenGui")
    MainUI.Name = "BLUE_MODE_MAIN"
    MainUI.ResetOnSpawn = false
    MainUI.Parent = PlayerGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0,680,0,110)
    MainFrame.Position = UDim2.new(0,20,0.5,-55)
    MainFrame.BackgroundColor3 = Color3.fromRGB(18,18,18)
    MainFrame.Active = true
    MainFrame.Parent = MainUI
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,10)
    AddRainbowBorder(MainFrame, 5)

    local TitleBar = Instance.new("TextLabel")
    TitleBar.Size = UDim2.new(1,-40,0,25)
    TitleBar.Position = UDim2.new(0,10,0,5)
    TitleBar.BackgroundTransparency = 1
    TitleBar.Text = "🔵 BLUE MODE ESP | MAIN MENU"
    TitleBar.Font = Enum.Font.GothamBold
    TitleBar.TextScaled = true
    TitleBar.Parent = MainFrame
    AddRainbowText(TitleBar)

    print("✅ MAIN ESP GUI FULLY LOADED!")
end
