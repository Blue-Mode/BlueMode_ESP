-- ==============================================
-- UNFINISH POPUP SCRIPT
-- ✅ Shows "Unfinish" text + OK button
-- ✅ Click OK to close/hide the screen
-- ✅ Works on all executors (Delta, etc.)
-- ==============================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 10) or game:GetService("CoreGui")

-- CREATE POPUP SCREEN
local PopupGui = Instance.new("ScreenGui")
PopupGui.Name = "Unfinish_Popup"
PopupGui.ResetOnSpawn = false
PopupGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
PopupGui.Parent = PlayerGui

-- DIM BACKGROUND (DARKEN SCREEN)
local DimBackground = Instance.new("Frame")
DimBackground.Size = UDim2.new(1,0,1,0)
DimBackground.Position = UDim2.new(0,0,0,0)
DimBackground.BackgroundColor3 = Color3.new(0,0,0)
DimBackground.BackgroundTransparency = 0.5
DimBackground.Parent = PopupGui

-- MAIN POPUP BOX
local PopupBox = Instance.new("Frame")
PopupBox.Size = UDim2.new(0,350,0,180)
PopupBox.Position = UDim2.new(0.5,-175,0.5,-90)
PopupBox.BackgroundColor3 = Color3.fromRGB(30,30,30)
PopupBox.Parent = PopupGui
Instance.new("UICorner", PopupBox).CornerRadius = UDim.new(0,15)

-- UNFINISH TEXT
local UnfinishText = Instance.new("TextLabel")
UnfinishText.Size = UDim2.new(1,-40,0,60)
UnfinishText.Position = UDim2.new(0,20,0,25)
UnfinishText.BackgroundTransparency = 1
UnfinishText.Text = "Unfinish"
UnfinishText.TextColor3 = Color3.new(1,1,1)
UnfinishText.Font = Enum.Font.GothamBold
UnfinishText.TextScaled = true
UnfinishText.Parent = PopupBox

-- OK BUTTON
local OkButton = Instance.new("TextButton")
OkButton.Size = UDim2.new(0,140,0,45)
OkButton.Position = UDim2.new(0.5,-70,1,-65)
OkButton.BackgroundColor3 = Color3.fromRGB(40,120,200)
OkButton.Text = "OK"
OkButton.TextColor3 = Color3.new(1,1,1)
OkButton.Font = Enum.Font.GothamBold
OkButton.TextScaled = true
OkButton.Parent = PopupBox
Instance.new("UICorner", OkButton).CornerRadius = UDim.new(0,10)

-- ✅ CLOSE POPUP WHEN OK CLICKED
OkButton.MouseButton1Click:Connect(function()
    PopupGui:Destroy() -- Removes everything completely
end)

print("✅ Unfinish popup loaded! Click OK to close.")
