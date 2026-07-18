-- ==============================================
-- BLUE MODE ESP | FIXED GLOBAL COUNTDOWN
-- ✅ Global Timer fully working now
-- ✅ Original ESP features UNCHANGED
-- ✅ No extra features, no errors
-- ✅ Works on Delta & all executors
-- ==============================================
if getgenv().BlueMode_Loaded then return end
getgenv().BlueMode_Loaded = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 10) or game:GetService("CoreGui")

-- ==============================================
-- 🕒 FIXED & WORKING GLOBAL COUNTDOWN
-- ==============================================
local function LoadGlobalCountdown()
    local PopupGui = Instance.new("ScreenGui")
    PopupGui.Name = "BlueMode_GlobalTimer"
    PopupGui.ResetOnSpawn = false
    PopupGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    PopupGui.Parent = PlayerGui

    local Background = Instance.new("Frame")
    Background.Size = UDim2.new(0, 380, 0, 210)
    Background.Position = UDim2.new(0.5, -190, 0.5, -105)
    Background.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    Instance.new("UICorner", Background).CornerRadius = UDim.new(0, 16)
    Background.Parent = PopupGui

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -40, 0, 55)
    Title.Position = UDim2.new(0, 20, 0, 20)
    Title.BackgroundTransparency = 1
    Title.Text = "Unfinish"
    Title.TextColor3 = Color3.fromRGB(255, 70, 70)
    Title.Font = Enum.Font.GothamBold
    Title.TextScaled = true
    Title.Parent = Background

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -40, 0, 30)
    Label.Position = UDim2.new(0, 20, 0, 80)
    Label.BackgroundTransparency = 1
    Label.Text = "Global Countdown"
    Label.TextColor3 = Color3.fromRGB(80, 190, 255)
    Label.Font = Enum.Font.GothamSemibold
    Label.TextScaled = true
    Label.Parent = Background

    local TimerText = Instance.new("TextLabel")
    TimerText.Size = UDim2.new(1, -40, 0, 55)
    TimerText.Position = UDim2.new(0, 20, 0, 110)
    TimerText.BackgroundTransparency = 1
    TimerText.Text = "Loading..."
    TimerText.TextColor3 = Color3.fromRGB(255, 210, 60)
    TimerText.Font = Enum.Font.GothamBold
    TimerText.TextScaled = true
    TimerText.Parent = Background

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 150, 0, 45)
    CloseBtn.Position = UDim2.new(0.5, -75, 1, -55)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(35, 150, 90)
    CloseBtn.Text = "OK"
    CloseBtn.TextColor3 = Color3.new(1, 1, 1)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextScaled = true
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 10)
    CloseBtn.Parent = Background

    -- ✅ SET YOUR EXACT GLOBAL RELEASE TIME HERE
    local GLOBAL_RELEASE = 1784474940 -- Replace with your correct timestamp

    -- ✅ UPDATES EVERY SECOND FOR ACCURACY
    task.spawn(function()
        while PopupGui.Parent do
            local CurrentUnix = os.time()
            local Remaining = math.max(0, GLOBAL_RELEASE - CurrentUnix)

            local Days = math.floor(Remaining / 86400)
            local Hours = math.floor((Remaining % 86400) / 3600)
            local Mins = math.floor((Remaining % 3600) / 60)
            local Secs = Remaining % 60

            if Remaining <= 0 then
                TimerText.Text = "✅ RELEASED!"
                Label.Text = "Global Release • Live Now"
            else
                TimerText.Text = Days > 0 
                    and string.format("%d Day • %02d:%02d:%02d", Days, Hours, Mins, Secs)
                    or string.format("%02d:%02d:%02d", Hours, Mins, Secs)
            end

            task.wait(1)
        end
    end)

    CloseBtn.MouseButton1Click:Connect(function()
        PopupGui:Destroy()
    end)
end

-- Show automatically on load
task.spawn(LoadGlobalCountdown)

-- ==============================================
-- YOUR ORIGINAL ESP SCRIPT (UNCHANGED)
-- ==============================================
local USAGE_LIMIT = 12 * 3600
local COOLDOWN = 12 * 3600
local SAVE_KEY_USED = "BlueMode_UsedTime_v19"
local SAVE_KEY_COOLDOWN = "BlueMode_CooldownEnd_v19"

local function SaveData(key, value) pcall(function() writefile(key..".txt", tostring(value)) end) end
local function LoadData(key, default) local v=nil; pcall(function() v=readfile(key..".txt") end); return tonumber(v) or default end

local CurrentTime = os.time()
local CooldownEnd = LoadData(SAVE_KEY_COOLDOWN, 0)
if CurrentTime < CooldownEnd then
    print("⏳ COOLDOWN ACTIVE! Wait "..math.floor((CooldownEnd-CurrentTime)/60).." mins")
    return
end

local UsedTime = LoadData(SAVE_KEY_USED, 0)
local LastCheckTime = os.time()
local GuiElements = {}
local ESP_Enabled = false
local Hue = 0

local function ClearAllESP()
    for _,P in pairs(Players:GetPlayers()) do
        if P and P.Character then
            pcall(function()
                if P.Character:FindFirstChild("BLUE_Outline") then P.Character.BLUE_Outline:Destroy() end
                if P.Character:FindFirstChild("FriendRainbowDot") then P.Character.FriendRainbowDot:Destroy() end
            end)
        end
    end
    pcall(function()
        for _,D in pairs(workspace:GetDescendants()) do
            if D.Name == "BLUE_Outline" or D.Name == "FriendRainbowDot" then D:Destroy() end
        end
    end)
end

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

local MainUI = Instance.new("ScreenGui")
MainUI.Name = "BLUE_MODE_ESP"
MainUI.ResetOnSpawn = false
MainUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
MainUI.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0,220,0,70)
MainFrame.Position = UDim2.new(0,20,0.5,-35)
MainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
MainFrame.Active = true
MainFrame.Parent = MainUI
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,8)
AddRainbowGlow(MainFrame,5)

local DragHandle = Instance.new("TextButton")
DragHandle.Size = UDim2.new(1,0,0,22)
DragHandle.BackgroundColor3 = Color3.fromRGB(60,140,220)
DragHandle.Active = true
DragHandle.Text = "BLUE MODE ESP | DRAG"
DragHandle.TextColor3 = Color3.new(1,1,1)
DragHandle.Font = Enum.Font.GothamBold
DragHandle.TextScaled = true
DragHandle.TextXAlignment = Enum.TextXAlignment.Left
DragHandle.Parent = MainFrame

local TimerLabel = Instance.new("TextLabel")
TimerLabel.Size = UDim2.new(1,-10,0,22)
TimerLabel.Position = UDim2.new(0,0,0,22)
TimerLabel.BackgroundTransparency = 1
TimerLabel.Text = "00:00:00 / 12:00"
TimerLabel.TextColor3 = Color3.new(1,1,1)
TimerLabel.Font = Enum.Font.GothamBold
TimerLabel.TextScaled = true
TimerLabel.TextXAlignment = Enum.TextXAlignment.Center
TimerLabel.Parent = MainFrame

local ESPBtn = Instance.new("TextButton")
ESPBn = ESPBtn
ESPBn.Size = UDim2.new(0,190,0,30)
ESPBn.Position = UDim2.new(0,15,0,40)
ESPBn.BackgroundColor3 = Color3.fromRGB(40,40,40)
ESPBn.Text = "ESP: OFF"
ESPBn.TextColor3 = Color3.new(1,1,1)
ESPBn.Font = Enum.Font.GothamBold
ESPBn.TextScaled = true
ESPBn.Parent = MainFrame
Instance.new("UICorner", ESPBn).CornerRadius = UDim.new(0,6)
AddRainbowGlow(ESPBn,2)

local DragState = {Active=false, StartX=0, StartY=0, PosX=0, PosY=0}
DragHandle.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
        DragState.Active = true
        DragState.StartX = Input.Position.X
        DragState.StartY = Input.Position.Y
        DragState.PosX = MainFrame.Position.X.Offset
        DragState.PosY = MainFrame.Position.Y.Offset
    end
end)
UserInputService.InputEnded:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
        DragState.Active = false
    end
end)
UserInputService.InputChanged:Connect(function(Input)
    if DragState.Active then
        MainFrame.Position = UDim2.new(0, DragState.PosX + (Input.Position.X - DragState.StartX), 0, DragState.PosY + (Input.Position.Y - DragState.StartY))
    end
end)

ESPBn.MouseButton1Click:Connect(function()
    ESP_Enabled = not ESP_Enabled
    ESPBtn.Text = ESP_Enabled and "ESP: ON" or "ESP: OFF"
    ESPBtn.BackgroundColor3 = ESP_Enabled and Color3.fromRGB(25,120,25) or Color3.fromRGB(40,40,40)
    if not ESP_Enabled then ClearAllESP() end
end)

RunService.Heartbeat:Connect(function(Delta)
    if not MainUI or not MainUI.Parent then return end

    local Now = os.time()
    UsedTime = UsedTime + math.max(0, Now - LastCheckTime)
    LastCheckTime = Now
    SaveData(SAVE_KEY_USED, UsedTime)
    local Remaining = math.max(0, USAGE_LIMIT - UsedTime)
    local h = math.floor(Remaining/3600)
    local m = math.floor((Remaining%3600)/60)
    local s = Remaining%60
    TimerLabel.Text = string.format("%02d:%02d:%02d / 12:00",h,m,s)

    if Remaining <= 0 then
        SaveData(SAVE_KEY_COOLDOWN, os.time() + COOLDOWN)
        pcall(function() delfile(SAVE_KEY_USED..".txt") end)
        ClearAllESP()
        MainUI:Destroy()
        getgenv().BlueMode_Loaded = nil
        return
    end

    Hue = (Hue + Delta*0.5) % 1
    local Rainbow = Color3.fromHSV(Hue,1,1)
    for _,e in pairs(GuiElements) do e.Color = Rainbow end
    TimerLabel.TextColor3 = Rainbow

    if not ESP_Enabled then return end
    for _,P in pairs(Players:GetPlayers()) do
        if P == LocalPlayer then continue end
        local Char = P.Character
        if not Char then continue end
        local Hum = Char:FindFirstChildOfClass("Humanoid")
        if not Hum or Hum.Health <= 0 then
            pcall(function()
                if Char:FindFirstChild("BLUE_Outline") then Char.BLUE_Outline:Destroy() end
                if Char:FindFirstChild("FriendRainbowDot") then Char.FriendRainbowDot:Destroy() end
            end)
            continue
        end

        local Outline = Char:FindFirstChild("BLUE_Outline") or Instance.new("Highlight",Char)
        Outline.Name = "BLUE_Outline"
        Outline.FillTransparency = 1
        Outline.OutlineTransparency = 0
        Outline.OutlineColor = Rainbow
        Outline.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

        local IsFriend = false
        pcall(function() IsFriend = LocalPlayer:IsFriendsWith(P.UserId) end)
        local Head = Char:FindFirstChild("Head")
        local Dot = Char:FindFirstChild("FriendRainbowDot")
        if IsFriend and Head then
            if not Dot then
                Dot = Instance.new("BillboardGui",Head)
                Dot.Name = "FriendRainbowDot"
                Dot.AlwaysOnTop = true
                Dot.Size = UDim2.new(0,16,0,16)
                Dot.StudsOffset = Vector3.new(0,2,0)
                local Circ = Instance.new("Frame",Dot)
                Circ.Size = UDim2.new(1,0,1,0)
                Circ.BackgroundColor3 = Rainbow
                Instance.new("UICorner",Circ).CornerRadius = UDim.new(1,0)
            end
        elseif Dot then
            Dot:Destroy()
        end
    end
end)

print("✅ BLUE MODE ESP | GLOBAL COUNTDOWN FIXED & WORKING")
