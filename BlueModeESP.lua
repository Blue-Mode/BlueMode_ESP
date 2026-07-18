-- ==============================================
-- 🔵 BLUE MODE HUB | COMPACT BOX VERSION
-- ✅ SMALL NEAT BOX
-- ✅ EXACT TITLE + EXACT FEATURES
-- ✅ RAINBOW OUTLINE + BUTTONS
-- ✅ WORKS ON ALL EXECUTORS
-- ==============================================
if getgenv().BlueModeHub_Loaded then return end
getgenv().BlueModeHub_Loaded = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- ✅ Bypass GUI block
local PlayerGui
pcall(function() PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 10) end)
PlayerGui = PlayerGui or game:GetService("CoreGui")

-- ==============================================
-- ✅ RAINBOW SYSTEM
-- ==============================================
local RainbowBorders = {}
local RainbowText = {}
local Hue = 0

local function AddRainbowBorder(obj, thick)
    local stroke = Instance.new("UIStroke")
    stroke.Name = "RainbowBorder"
    stroke.Thickness = thick or 7
    stroke.Transparency = 0
    stroke.LineJoinMode = Enum.LineJoinMode.Round
    stroke.Parent = obj
    table.insert(RainbowBorders, stroke)
end

local function SetupText(obj, text)
    obj.Text = text
    obj.BackgroundTransparency = 1
    obj.Font = Enum.Font.GothamBold
    obj.TextScaled = true
    obj.AutoLocalize = false
    obj.TextColor3 = Color3.new(0, 0.7, 1)
    table.insert(RainbowText, obj)
end

RunService.Heartbeat:Connect(function(dt)
    Hue = (Hue + dt * 0.2) % 1
    local col = Color3.fromHSV(Hue, 1, 1)
    for _,s in pairs(RainbowBorders) do s.Color = col end
    for _,t in pairs(RainbowText) do t.TextColor3 = col end
end)

-- ==============================================
-- ✅ SMALL COMPACT BOX GUI
-- ==============================================
local BoxUI = Instance.new("ScreenGui")
BoxUI.Name = "BLUE_MODE_HUB_BOX"
BoxUI.ResetOnSpawn = false
BoxUI.DisplayOrder = 999
BoxUI.Parent = PlayerGui

-- ✅ SMALL BOX FRAME
local BoxFrame = Instance.new("Frame")
BoxFrame.Size = UDim2.new(0, 380, 0, 480) -- Small neat box size
BoxFrame.Position = UDim2.new(0.5, -190, 0.5, -240)
BoxFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
BoxFrame.Active = true
BoxFrame.ClipsDescendants = false
BoxFrame.Parent = BoxUI
Instance.new("UICorner", BoxFrame).CornerRadius = UDim.new(0, 18)
AddRainbowBorder(BoxFrame, 7)

-- ✅ TITLE
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 0, 55)
Title.Position = UDim2.new(0, 20, 0, 15)
Title.TextXAlignment = Enum.TextXAlignment.Center
Title.Parent = BoxFrame
SetupText(Title, "🔵 BLUE MODE HUB")

-- ✅ FEATURE LIST HEADER
local ListHeader = Instance.new("TextLabel")
ListHeader.Size = UDim2.new(1, -40, 0, 40)
ListHeader.Position = UDim2.new(0, 20, 0, 75)
ListHeader.TextXAlignment = Enum.TextXAlignment.Left
ListHeader.Parent = BoxFrame
SetupText(ListHeader, "📋 FEATURE LIST:")

-- ✅ YOUR EXACT FEATURES
local Features = Instance.new("TextLabel")
Features.Size = UDim2.new(1, -60, 0, 220)
Features.Position = UDim2.new(0, 30, 0, 125)
Features.TextXAlignment = Enum.TextXAlignment.Left
Features.TextYAlignment = Enum.TextYAlignment.Top
Features.TextLineHeight = 1.8
Features.Parent = BoxFrame
SetupText(Features, [[• ESP / FRIEND DOT
• CONSOLE
• MADE BY: DWAYNEKEANTFRANCISCO
• MADE BY: BLUE_MODE
• DELETE BUTTON
• MUSIC]])

-- ✅ OPEN BUTTON
local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 280, 0, 50)
OpenBtn.Position = UDim2.new(0.5, -140, 0, 370)
OpenBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
OpenBtn.AutoLocalize = false
OpenBtn.Parent = BoxFrame
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 12)
SetupText(OpenBtn, "▶ OPEN MAIN HUB")
AddRainbowBorder(OpenBtn, 3)

-- ✅ EXIT BUTTON
local ExitBtn = Instance.new("TextButton")
ExitBtn.Size = UDim2.new(0, 280, 0, 45)
ExitBtn.Position = UDim2.new(0.5, -140, 0, 430)
ExitBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
ExitBtn.AutoLocalize = false
ExitBtn.Parent = BoxFrame
Instance.new("UICorner", ExitBtn).CornerRadius = UDim.new(0, 12)
SetupText(ExitBtn, "🗑️ DELETE / EXIT")
AddRainbowBorder(ExitBtn, 3)

-- BUTTON ACTIONS
OpenBtn.MouseButton1Click:Connect(function()
    BoxUI:Destroy()
    print("✅ Opening Main Hub...")
end)

ExitBtn.MouseButton1Click:Connect(function()
    BoxUI:Destroy()
    getgenv().BlueModeHub_Loaded = nil
    print("✅ Exited")
end)

print("✅ COMPACT BLUE MODE HUB BOX LOADED!")
