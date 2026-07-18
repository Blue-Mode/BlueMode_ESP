-- ==============================================
-- UNFINISH POPUP | GLOBAL RELEASE + COUNTDOWN
-- ✅ Shows "Unfinish" main text
-- ✅ "Global Release • Coming in 1 day" below
-- ✅ Live countdown timer (Hours : Minutes : Seconds)
-- ✅ OK button removes everything completely
-- ✅ Works on all executors
-- ==============================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 10) or game:GetService("CoreGui")

-- SET COUNTDOWN TIME: 1 FULL DAY = 86400 SECONDS
local RELEASE_TIME = 86400
local RemainingTime = RELEASE_TIME

-- CREATE POPUP SCREEN
local PopupGui = Instance.new("ScreenGui")
PopupGui.Name = "Unfinish_Release_Popup"
PopupGui.ResetOnSpawn = false
PopupGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
PopupGui.Parent = PlayerGui

-- DIM BACKGROUND
local DimBackground = Instance.new("Frame")
DimBackground.Size = UDim2.new(1,0,1,0)
DimBackground.Position = UDim2.new(0,0,0,0)
DimBackground.BackgroundColor3 = Color3.new(0,0,0)
DimBackground.BackgroundTransparency = 0.6
DimBackground.Parent = PopupGui

-- MAIN POPUP BOX
local PopupBox = Instance.new("Frame")
PopupBox.Size = UDim2.new(0,400,0,260)
PopupBox.Position = UDim2.new(0.5,-200,0.5,-130)
PopupBox.BackgroundColor3 = Color3.fromRGB(25,25,25)
PopupBox.Parent = PopupGui
Instance.new("UICorner", PopupBox).CornerRadius = UDim.new(0,16)

-- UNFINISH MAIN TEXT
local UnfinishText = Instance.new("TextLabel")
UnfinishText.Size = UDim2.new(1,-40,0,55)
UnfinishText.Position = UDim2.new(0,20,0,20)
UnfinishText.BackgroundTransparency = 1
UnfinishText.Text = "Unfinish"
UnfinishText.TextColor3 = Color3.fromRGB(255,80,80)
UnfinishText.Font = Enum.Font.GothamBold
UnfinishText.TextScaled = true
UnfinishText.Parent = PopupBox

-- GLOBAL RELEASE TEXT
local ReleaseText = Instance.new("TextLabel")
ReleaseText.Size = UDim2.new(1,-40,0,35)
ReleaseText.Position = UDim2.new(0,20,0,80)
ReleaseText.BackgroundTransparency = 1
ReleaseText.Text = "Global Release • Coming in 1 day"
ReleaseText.TextColor3 = Color3.fromRGB(80,200,255)
ReleaseText.Font = Enum.Font.GothamSemibold
ReleaseText.TextScaled = true
ReleaseText.Parent = PopupBox

-- LIVE COUNTDOWN TIMER
local CountdownLabel = Instance.new("TextLabel")
CountdownLabel.Size = UDim2.new(1,-40,0,50)
CountdownLabel.Position = UDim2.new(0,20,0,125)
CountdownLabel.BackgroundTransparency = 1
CountdownLabel.Text = "00h : 00m : 00s"
CountdownLabel.TextColor3 = Color3.fromRGB(255,210,80)
CountdownLabel.Font = Enum.Font.GothamBold
CountdownLabel.TextScaled = true
CountdownLabel.Parent = PopupBox

-- OK BUTTON
local OkButton = Instance.new("TextButton")
OkButton.Size = UDim2.new(0,160,0,45)
OkButton.Position = UDim2.new(0.5,-80,1,-65)
OkButton.BackgroundColor3 = Color3.fromRGB(30,140,70)
OkButton.Text = "OK"
OkButton.TextColor3 = Color3.new(1,1,1)
OkButton.Font = Enum.Font.GothamBold
OkButton.TextScaled = true
OkButton.Parent = PopupBox
Instance.new("UICorner", OkButton).CornerRadius = UDim.new(0,10)

-- UPDATE COUNTDOWN EVERY SECOND
RunService.Heartbeat:Connect(function(dt)
    if not PopupGui or not PopupGui.Parent then return end
    RemainingTime = math.max(0, RemainingTime - dt)
    
    local h = math.floor(RemainingTime / 3600)
    local m = math.floor((RemainingTime % 3600) / 60)
    local s = math.floor(RemainingTime % 60)
    CountdownLabel.Text = string.format("%02dh : %02dm : %02ds", h, m, s)
    
    if RemainingTime <= 0 then
        ReleaseText.Text = "Global Release • NOW LIVE!"
        CountdownLabel.Text = "✅ RELEASED!"
    end
end)

-- CLOSE EVERYTHING WHEN OK CLICKED
OkButton.MouseButton1Click:Connect(function()
    PopupGui:Destroy()
end)

print("✅ Unfinish release popup loaded!")

