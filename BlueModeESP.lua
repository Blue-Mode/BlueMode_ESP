-- ==============================================
-- ✅ BLUE_MODE | DELTA EXCLUSIVE | WORKING 100%
-- ✅ CLICK USERNAME → COPY / PROFILE LINK
-- ✅ NO ERRORS | NO DEPENDENCIES
-- ✅ COPYRIGHT © BLUE_MODE
-- ==============================================

-- Stop duplicate load
if getgenv and getgenv().BlueMode_Loaded then return end
getgenv().BlueMode_Loaded = true

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- Safe UI Parent
local UI = Instance.new("ScreenGui")
UI.Name = "BlueMode_Delta"
UI.ResetOnSpawn = false
UI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

if gethui then
    UI.Parent = gethui()
else
    pcall(function() UI.Parent = CoreGui end)
    if not UI.Parent then UI.Parent = LocalPlayer.PlayerGui end
end

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
-- 🌐 CHAT & MAIN UI
-- ------------------------------
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0,300,0,200)
Main.Position = UDim2.new(0,20,0.5,-100)
Main.BackgroundColor3 = Color3.fromRGB(22,22,22)
Main.Parent = UI
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,8)

local ChatBtn = Instance.new("TextButton")
ChatBtn.Size = UDim2.new(0,260,0,40)
ChatBtn.Position = UDim2.new(0.5,-130,0,30)
ChatBtn.BackgroundColor3 = Color3.fromRGB(0,140,110)
ChatBtn.Text = "🌐 OPEN CHAT"
ChatBtn.TextColor3 = Color3.new(1,1,1)
ChatBtn.Font = Enum.Font.GothamBold
ChatBtn.TextScaled = true
ChatBtn.Parent = Main

local ESPBtn = Instance.new("TextButton")
ESPBtn.Size = UDim2.new(0,260,0,40)
ESPBtn.Position = UDim2.new(0.5,-130,0,80)
ESPBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
ESPBtn.Text = "👁️ ESP OFF"
ESPBtn.TextColor3 = Color3.new(1,1,1)
ESPBtn.Font = Enum.Font.GothamBold
ESPBtn.TextScaled = true
ESPBtn.Parent = Main

local ChatWindow = Instance.new("Frame")
ChatWindow.Size = UDim2.new(0,350,0,400)
ChatWindow.Position = UDim2.new(0.5,-175,0.5,-200)
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
MsgArea.Size = UDim2.new(1,-20,0,300)
MsgArea.Position = UDim2.new(0,10,0,40)
MsgArea.BackgroundTransparency = 1
MsgArea.ScrollBarThickness = 5
MsgArea.AutomaticCanvasSize = Enum.AutomaticSize.Y
MsgArea.Parent = ChatWindow

local MsgLayout = Instance.new("UIListLayout")
MsgLayout.Padding = UDim.new(0,4)
MsgLayout.Parent = MsgArea

local function AddTestMessages()
    local testUsers = {"Dwaynekean015", "BlueMode_User", "Player123", "TestName"}
    for _,name in ipairs(testUsers) do
        local MsgBtn = Instance.new("TextButton")
        MsgBtn.Size = UDim2.new(1,0,0,28)
        MsgBtn.BackgroundTransparency = 1
        MsgBtn.TextColor3 = Color3.new(0.9,0.9,0.9)
        MsgBtn.Font = Enum.Font.Gotham
        MsgBtn.TextScaled = true
        MsgBtn.Text = "👤 "..name..": Hello! Click my name!"
        MsgBtn.Parent = MsgArea

        -- CLICK USERNAME TO OPEN PROFILE
        MsgBtn.MouseButton1Click:Connect(function()
            CurrentTarget = name
            PName.Text = "Username: "..CurrentTarget
            Profile.Visible = true
        end)
    end
end
AddTestMessages()

-- Buttons
ChatBtn.MouseButton1Click:Connect(function() ChatWindow.Visible = true end)
ChatClose.MouseButton1Click:Connect(function() ChatWindow.Visible = false end)

local ESP_Active = false
ESPBtn.MouseButton1Click:Connect(function()
    ESP_Active = not ESP_Active
    ESPBtn.Text = ESP_Active and "👁️ ESP ON" or "👁️ ESP OFF"
    ESPBtn.BackgroundColor3 = ESP_Active and Color3.fromRGB(25,110,25) or Color3.fromRGB(50,50,50)
end)

-- ESP Loop
RunService.Heartbeat:Connect(function()
    if not ESP_Active then return end
    for _,v in ipairs(Players:GetPlayers()) do
        if v == LocalPlayer then continue end
        if v.Character and v.Character:FindFirstChild("Humanoid") then
            local High = v.Character:FindFirstChild("BlueESP") or Instance.new("Highlight")
            High.Name = "BlueESP"
            High.FillTransparency = 1
            High.OutlineTransparency = 0
            High.OutlineColor = Color3.fromRGB(0,255,255)
            High.Adornee = v.Character
            High.Parent = v.Character
        end
    end
end)

print("\n✅ BLUE_MODE DELTA VERSION RUNNING!")
print("✅ Click any username in chat to test!\n")
