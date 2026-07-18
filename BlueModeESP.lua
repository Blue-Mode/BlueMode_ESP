-- ==============================================
-- BLUE MODE ESP | DOTS FULLY REMOVED ON OFF/EXIT
-- ✅ Dots Vanish Instantly When ESP: OFF / EXIT / DEATH
-- ✅ Drag Stays In Place, No Snapping
-- ✅ Big Drag Area + Timer Never Blocks
-- ✅ Cross-Executor Compatible
-- ==============================================
if getgenv().BlueMode_Loaded then return end
getgenv().BlueMode_Loaded = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 10) or game:GetService("CoreGui")

-- SETTINGS
local USAGE_LIMIT = 12 * 3600
local SAVE_KEY_USED = "BlueMode_UsedTime_v33"

-- DATA HELPERS
local function SaveData(key, value) pcall(function() writefile(key..".txt", tostring(value)) end) end
local function LoadData(key, default) local v=nil; pcall(function() v=readfile(key..".txt") end); return tonumber(v) or default end

-- ✅ FULL CLEANUP: OUTLINES + ALL DOTS EVERYWHERE
local function ClearAllESP()
    -- Clean all players
    for _,P in pairs(Players:GetPlayers()) do
        if P and P.Character then
            pcall(function()
                local Char = P.Character
                -- Remove outlines
                for _,Obj in pairs(Char:GetChildren()) do
                    if Obj.Name == "BLUE_Outline" or Obj:IsA("Highlight") then Obj:Destroy() end
                end
                -- Remove ALL friend dots
                for _,Obj in pairs(Char:GetChildren()) do
                    if Obj.Name == "FriendRainbowDot" or Obj:IsA("BillboardGui") then Obj:Destroy() end
                end
                -- Extra check on Head for leftovers
                local Head = Char:FindFirstChild("Head")
                if Head then
                    for _,Obj in pairs(Head:GetChildren()) do
                        if Obj.Name == "FriendRainbowDot" or Obj:IsA("BillboardGui") then Obj:Destroy() end
                    end
                end
            end)
        end
    end
    -- Clean any leftover dots anywhere in PlayerGui
    pcall(function()
        for _,Obj in pairs(PlayerGui:GetDescendants()) do
            if Obj.Name == "FriendRainbowDot" then Obj:Destroy() end
        end
    end)
end

-- GLOBALS
local UsedTime = LoadData(SAVE_KEY_USED, 0)
local LastCheckTime = os.time()
local GuiElements = {}
local ESP_Enabled = false
local Hue = 0
local IsMinimized = false
local ESPBtn, MainUI, MainFrame, TimerLabel

-- DEATH CHECK: CLEAN EVERYTHING
local function SetupDeathCheck()
    local function CheckChar(Char)
        if not Char then return end
        local Hum = Char:WaitForChild("Humanoid", 10)
        if Hum then
            Hum.Died:Connect(function()
                if ESP_Enabled then
                    ESP_Enabled = false
                    ESPBtn.Text = "ESP: OFF"
                    ESPBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
                    ClearAllESP() -- DOTS + OUTLINES GONE
                end
            end)
        end
    end
    CheckChar(LocalPlayer.Character)
    LocalPlayer.CharacterAdded:Connect(CheckChar)
end

-- RAINBOW GLOW
local function AddRainbowGlow(target, thickness)
    if not target then return end
    local Outline = Instance.new("UIStroke")
    Outline.Name = "RainbowAura"
    Outline.Thickness = thickness or 3
    Outline.Transparency = 0
    Outline.LineJoinMode = Enum.LineJoinMode.Round
    Outline.Parent = target
    table.insert(GuiElements, Outline)
end

-- PERFECT DRAG SYSTEM
local function MakeDraggable(Frame, DragBar, LockBtnRef)
    local State = {Locked=false, Dragging=false, StartDiffX=0, StartDiffY=0}
    local ScreenSize = UserInputService:GetScreenSize()

    LockBtnRef.MouseButton1Click:Connect(function()
        State.Locked = not State.Locked
        LockBtnRef.Text = State.Locked and "🔒" or "🔓"
    end)

    DragBar.InputBegan:Connect(function(Input)
        if State.Locked then return end
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            State.Dragging = true
            State.StartDiffX = Input.Position.X - Frame.Position.X.Offset
            State.StartDiffY = Input.Position.Y - Frame.Position.Y.Offset
        end
    end)

    UserInputService.InputEnded:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            State.Dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(Input)
        if State.Dragging and not State.Locked then
            if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                local NewX = Input.Position.X - State.StartDiffX
                local NewY = Input.Position.Y - State.StartDiffY
                NewX = math.clamp(NewX, 0, ScreenSize.X - Frame.AbsoluteSize.X)
                NewY = math.clamp(NewY, 0, ScreenSize.Y - Frame.AbsoluteSize.Y)
                Frame.Position = UDim2.new(0, NewX, 0, NewY)
            end
        end
    end)
end

-- ====================== MAIN GUI ======================
local FULL_SIZE = UDim2.new(0,680,0,120)
local MINI_SIZE = UDim2.new(0,320,0,70)

MainUI = Instance.new("ScreenGui")
MainUI.Name = "BLUE_MODE_ESP"
MainUI.ResetOnSpawn = false
MainUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
MainUI.Parent = PlayerGui

MainFrame = Instance.new("Frame")
MainFrame.Size = FULL_SIZE
MainFrame.Position = UDim2.new(0,50,0,200)
MainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
MainFrame.Parent = MainUI
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,8)
AddRainbowGlow(MainFrame,5)

-- BIG DRAG AREA
local MainDragBar = Instance.new("TextButton")
MainDragBar.Size = UDim2.new(1,-70,0,60)
MainDragBar.Position = UDim2.new(0,5,0,5)
MainDragBar.BackgroundColor3 = Color3.fromRGB(60,140,220)
MainDragBar.Active = true
MainDragBar.Text = "🔵 DRAG ANYWHERE HERE"
MainDragBar.TextColor3 = Color3.new(1,1,1)
MainDragBar.Font = Enum.Font.GothamBold
MainDragBar.TextScaled = true
MainDragBar.Parent = MainFrame
AddRainbowGlow(MainDragBar,2)

-- TIMER: BOTTOM RIGHT (NO BLOCK)
TimerLabel = Instance.new("TextLabel")
TimerLabel.Size = UDim2.new(0,130,0,25)
TimerLabel.Position = UDim2.new(1,-135,1,-30)
TimerLabel.BackgroundTransparency = 1
TimerLabel.Text = "00:00:00 / 12:00"
TimerLabel.TextColor3 = Color3.new(1,1,1)
TimerLabel.Font = Enum.Font.GothamBold
TimerLabel.TextScaled = true
TimerLabel.Parent = MainFrame

-- BUTTONS
local MainLockBtn = Instance.new("TextButton")
MainLockBtn.Size = UDim2.new(0,28,0,28)
MainLockBtn.Position = UDim2.new(1,-65,0,5)
MainLockBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
MainLockBtn.Text = "🔓"
MainLockBtn.TextColor3 = Color3.new(1,1,1)
MainLockBtn.Font = Enum.Font.GothamBold
MainLockBtn.TextScaled = true
MainLockBtn.Parent = MainFrame
Instance.new("UICorner", MainLockBtn).CornerRadius = UDim.new(0,6)

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0,28,0,28)
MinBtn.Position = UDim2.new(1,-35,0,5)
MinBtn.BackgroundColor3 = Color3.fromRGB(200,120,20)
MinBtn.Text = "➖"
MinBtn.TextColor3 = Color3.new(1,1,1)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextScaled = true
MinBtn.Parent = MainFrame
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0,6)
AddRainbowGlow(MinBtn,2)

MakeDraggable(MainFrame, MainDragBar, MainLockBtn)

ESPBtn = Instance.new("TextButton")
ESPBtn.Size = UDim2.new(0,90,0,32)
ESPBtn.Position = UDim2.new(0,10,0,42)
ESPBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
ESPBtn.Text = "ESP: OFF"
ESPBtn.TextColor3 = Color3.new(1,1,1)
ESPBtn.Font = Enum.Font.GothamBold
ESPBtn.TextScaled = true
ESPBtn.Parent = MainFrame
Instance.new("UICorner", ESPBtn).CornerRadius = UDim.new(0,6)
