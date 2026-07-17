-- ==============================================
-- ✅ BLUE_MODE | GITHUB + DELTA PERFECT VERSION
-- ✅ LOADS INSTANTLY FROM RAW LINK
-- ✅ CLICK USERNAME → COPY / PROFILE
-- ✅ NO ERRORS | WORKS EVERYWHERE
-- ✅ COPYRIGHT © BLUE_MODE
-- ==============================================

-- Prevent duplicate load
if getgenv and getgenv().BlueMode_Loaded then return end
getgenv().BlueMode_Loaded = true

-- Only use universal services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- Safe UI parent (works on all executors)
local UI = Instance.new("ScreenGui")
UI.Name = "BlueMode_GitHub"
UI.ResetOnSpawn = false
UI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
UI.DisplayOrder = 10000

if gethui then
    UI.Parent = gethui()
else
    pcall(function() UI.Parent = CoreGui end)
    if not UI.Parent then
        pcall(function() UI.Parent = LocalPlayer:WaitForChild("PlayerGui", 10) end)
    end
end

-- Load notification (confirms script ran)
pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "✅ BLUE_MODE",
        Text = "Loaded from GitHub successfully!",
        Duration = 3
    })
end)

-- ------------------------------
-- 👤 USER PROFILE POPUP
-- ------------------------------
local CurrentTarget = ""

local Profile = Instance.new("Frame")
Profile.Size = UDim2.new(0,260,0,170)
Profile.Position = UDim2.new(0.5,-130,0.5,-85)
Profile.BackgroundColor3 = Color3.fromRGB(25,25,25)
Profile.Visible = false
Profile.ZIndex = 100
Profile.Parent = UI
Instance.new("UICorner", Profile).CornerRadius = UDim.new(0,10)

local PTitle = Instance.new("TextLabel")
PTitle.Size = UDim2.new(1,0,0,35)
PTitle.Position = UDim2.new(0,0,0,5)
PTitle.BackgroundTransparency = 1
PTitle.Text = "👤 USER PROFILE"
PTitle.TextColor3 = Color3.new(1,1,1)
PTitle.Font = Enum.Font.GothamBold
PTitle.TextScaled = true
PTitle.Parent = Profile

local PName = Instance.new("TextLabel")
PName.Size = UDim2.new(1,-20,0,30)
PName.Position = UDim2.new(0,10,0,45)
PName.BackgroundTransparency = 1
PName.Text = "Username: ---"
PName.TextColor3 = Color3.fromRGB(0,210,255)
PName.Font = Enum.Font.GothamBold
PName.TextScaled = true
PName.Parent = Profile

local CopyUserBtn = Instance.new("TextButton")
CopyUserBtn.Size = UDim2.new(0,220,0,35)
CopyUserBtn.Position = UDim2.new(0.5,-110,0,85)
CopyUserBtn.BackgroundColor3 = Color3.fromRGB(20,120,180)
CopyUserBtn.Text = "📋 COPY USERNAME"
CopyUserBtn.TextColor3 = Color3.new(1,1,1)
CopyUserBtn.Font = Enum.Font.GothamBold
CopyUserBtn.TextScaled = true
CopyUserBtn.Parent = Profile

local CopyLinkBtn = Instance.new("TextButton")
CopyLinkBtn.Size = UDim2.new(0,220,0,35)
CopyLinkBtn.Position = UDim2.new(0.5,-110,0,125)
CopyLinkBtn.BackgroundColor3 = Color3.fromRGB(20,150,70)
CopyLinkBtn.Text = "🔗 COPY PROFILE LINK"
CopyLinkBtn.TextColor3 = Color3.new(1,1,1)
CopyLinkBtn.Font = Enum.Font.GothamBold
CopyLinkBtn.TextScaled = true
CopyLinkBtn.Parent = Profile

local PClose = Instance.new("TextButton")
PClose.Size = UDim2.new(0,30,0,30)
PClose.Position = UDim2.new(1,-35,0,5)
PClose.BackgroundColor3 = Color3.fromRGB(170,30,30)
PClose.Text = "✕"
PClose.TextColor3 = Color3.new(1,1,1)
PClose.Font = Enum.Font.GothamBold
PClose.TextScaled = true
PClose.Parent = Profile

-- Profile Actions
PClose.MouseButton1Click:Connect(function() Profile.Visible = false end)
CopyUserBtn.MouseButton1Click:Connect(function()
    if CurrentTarget == "" then return end
    pcall(function() if setclipboard then setclipboard(CurrentTarget) end end)
    CopyUserBtn.Text = "✅ COPIED!"
    task.delay(1.5, function() CopyUserBtn.Text = "📋 COPY USERNAME" end)
end)
CopyLinkBtn.MouseButton1Click:Connect(function()
    if CurrentTarget == "" then return end
    local link = "https://www.roblox.com/users/profile?username="..CurrentTarget
    pcall(function() if setclipboard then setclipboard(link) end end)
    CopyLinkBtn.Text = "✅ LINK COPIED!"
    task.delay(1.5, function() CopyLinkBtn.Text = "🔗 COPY PROFILE LINK" end)
end)

-- ------------------------------
-- 🎮 MAIN UI & CHAT
-- ------------------------------
local MainBtn = Instance.new("TextButton")
MainBtn.Size = UDim2.new(0,220,0,50)
MainBtn.Position = UDim2.new(0,15,0.5,-25)
MainBtn.BackgroundColor3 = Color3.fromRGB(0,140,110)
MainBtn.Text = "🌐 BLUE_MODE"
MainBtn.TextColor3 = Color3.new(1,1,1)
MainBtn.Font = Enum.Font.GothamBold
MainBtn.TextScaled = true
MainBtn.Active = true
MainBtn.Draggable = true
MainBtn.Parent = UI
Instance.new("UICorner", MainBtn).CornerRadius = UDim.new(0,10)

local ChatWindow = Instance.new("Frame")
ChatWindow.Size = UDim2.new(0,340,0,380)
ChatWindow.Position = UDim2.new(0.5,-170,0.5,-190)
ChatWindow.BackgroundColor3 = Color3.fromRGB(20,20,20)
ChatWindow.Visible = false
ChatWindow.Parent = UI
Instance.new("UICorner", ChatWindow).CornerRadius = UDim.new(0,10)

local ChatClose = Instance.new("TextButton")
ChatClose.Size = UDim2.new(0,30,0,30)
ChatClose.Position = UDim2.new(1,-35,0,5)
ChatClose.BackgroundColor3 = Color3.fromRGB(170,30,30)
ChatClose.Text = "✕"
ChatClose.TextColor3 = Color3.new(1,1,1)
ChatClose.Font = Enum.Font.GothamBold
ChatClose.TextScaled = true
ChatClose.Parent = ChatWindow

local MsgArea = Instance.new("ScrollingFrame")
MsgArea.Size = UDim2.new(1,-20,1,-50)
MsgArea.Position = UDim2.new(0,10,0,40)
MsgArea.BackgroundTransparency = 1
MsgArea.ScrollBarThickness = 5
MsgArea.AutomaticCanvasSize = Enum.AutomaticSize.Y
MsgArea.Parent = ChatWindow

local MsgLayout = Instance.new("UIListLayout")
MsgLayout.Padding = UDim.new(0,5)
MsgLayout.Parent = MsgArea

-- Clickable test messages
local testNames = {"Dwaynekean015", "BlueMode_Official", "Player_Alpha", "TestUser99"}
for _,name in ipairs(testNames) do
    local Msg = Instance.new("TextButton")
    Msg.Size = UDim2.new(1,0,0,28)
    Msg.BackgroundTransparency = 1
    Msg.TextColor3 = Color3.new(0.9,0.9,0.9)
    Msg.Font = Enum.Font.Gotham
    Msg.TextScaled = true
    Msg.Text = "👤 "..name..": Click my name!"
    Msg.Parent = MsgArea

    Msg.MouseButton1Click:Connect(function()
        CurrentTarget = name
        PName.Text = "Username: "..CurrentTarget
        Profile.Visible = true
    end)
end

-- Buttons
MainBtn.MouseButton1Click:Connect(function() ChatWindow.Visible = true end)
ChatClose.MouseButton1Click:Connect(function() ChatWindow.Visible = false end)

print("✅ BLUE_MODE | GITHUB VERSION RUNNING!")
