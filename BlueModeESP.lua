-- ==============================================
-- BLUE MODE ESP | NO BUTTON RESET ON DEATH
-- ✅ All Settings/Buttons Stay When You Die
-- ✅ Dots+Outlines Fully Clear On ESP OFF/EXIT/DEATH
-- ✅ Perfect Drag: No Snapping, Big Touch Target
-- ✅ Timer Bottom Right, Never Blocks Drag
-- ==============================================
if getgenv().BlueMode_Loaded then return end
getgenv().BlueMode_Loaded = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 10) or game:GetService("CoreGui")

-- SETTINGS
local USAGE_LIMIT = 12 * 3600
local SAVE_KEY_USED = "BlueMode_UsedTime_v34"
local SAVE_KEY_VOLUME = "BlueMode_Volume_v34"

-- DATA HELPERS
local function SaveData(key, value) pcall(function() writefile(key..".txt", tostring(value)) end) end
local function LoadData(key, default) local v=nil; pcall(function() v=readfile(key..".txt") end); return tonumber(v) or default end

-- ✅ CLEAR ONLY VISUALS — NO SETTING/UI RESET
local function ClearESPVisuals()
    for _,P in pairs(Players:GetPlayers()) do
        if P and P.Character then
            pcall(function()
                local Char = P.Character
                -- Remove outlines
                for _,Obj in pairs(Char:GetChildren()) do
                    if Obj.Name == "BLUE_Outline" or Obj:IsA("Highlight") then Obj:Destroy() end
                end
                -- Remove all friend dots
                for _,Obj in pairs(Char:GetChildren()) do
                    if Obj.Name == "FriendRainbowDot" or Obj:IsA("BillboardGui") then Obj:Destroy() end
                end
                local Head = Char:FindFirstChild("Head")
                if Head then
                    for _,Obj in pairs(Head:GetChildren()) do
                        if Obj.Name == "FriendRainbowDot" or Obj:IsA("BillboardGui") then Obj:Destroy() end
                    end
                end
            end)
        end
    end
    pcall(function()
        for _,Obj in pairs(PlayerGui:GetDescendants()) do
            if Obj.Name == "FriendRainbowDot" then Obj:Destroy() end
        end
    end)
end

-- GLOBALS
local UsedTime = LoadData(SAVE_KEY_USED, 0)
local LastCheckTime = os.time()
local MusicVolume = LoadData(SAVE_KEY_VOLUME, 0.5)
local CurrentSound = nil
local VolNumTextMain, VolFillMain
local GuiElements = {}
-- ✅ PERSISTENT STATES: Never reset on death
local ESP_Enabled = false
local Hue = 0
local IsMinimized = false
local GuiLocked = false
local ESPBtn, MainUI, MainFrame, TimerLabel, MinBtn, ExitBtn, MainLockBtn

-- ✅ DEATH HANDLER: CLEAR VISUALS ONLY — KEEP ALL SETTINGS
local function SetupDeathCheck()
    local function CheckChar(Char)
        if not Char then return end
        local Hum = Char:WaitForChild("Humanoid", 10)
        if Hum then
            Hum.Died:Connect(function()
                -- Only clear visuals, do NOT change buttons/states
                ClearESPVisuals()
            end)
        end
    end
    CheckChar(LocalPlayer.Character)
    LocalPlayer.CharacterAdded:Connect(function(NewChar)
        -- Restore ESP automatically if it was ON before death
        task.wait(1)
        if ESP_Enabled then
            ESPBtn.Text = "ESP: ON"
            ESPBtn.BackgroundColor3 = Color3.fromRGB(20,140,20)
        end
    end)
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

    -- Load saved lock state
    State.Locked = GuiLocked
    LockBtnRef.Text = State.Locked and "🔒" or "🔓"
    LockBtnRef.BackgroundColor3 = State.Locked and Color3.fromRGB(180,40,40) or Color3.fromRGB(50,50,50)

    LockBtnRef.MouseButton1Click:Connect(function()
        State.Locked = not State.Locked
        GuiLocked = State.Locked -- Save globally
        LockBtnRef.Text = State.Locked and "🔒" or "🔓"
        LockBtnRef.BackgroundColor3 = State.Locked and Color3.fromRGB(180,40,40) or Color3.fromRGB(50,50,50)
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

-- VOLUME
local function UpdateVolume(newVol)
    MusicVolume = math.clamp(newVol, 0, 1)
    SaveData(SAVE_KEY_VOLUME, MusicVolume)
    if CurrentSound then CurrentSound.Volume = MusicVolume end
    local Pct = math.floor(MusicVolume*100+0.5).."%"
    if VolNumTextMain then VolNumTextMain.Text = Pct end
    if VolFillMain then VolFillMain.Size = UDim2.new(MusicVolume,0,1,0) end
end

-- ====================== MAIN GUI ======================
local FULL_SIZE = UDim2.new(0,680,0,120)
local MINI_SIZE = UDim2.new(0,320,0,70)

MainUI = Instance.new("ScreenGui")
MainUI.Name = "BLUE_MODE_ESP"
MainUI.ResetOnSpawn = false -- ✅ GUI survives respawn
MainUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
MainUI.Parent = PlayerGui

MainFrame = Instance.new("Frame")
MainFrame.Size = IsMinimized and MINI_SIZE or FULL_SIZE -- ✅ Keep minimize state
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

-- TIMER: BOTTOM RIGHT
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
MainLockBtn = Instance.new("TextButton")
MainLockBtn.Size = UDim2.new(0,28,0,28)
MainLockBtn.Position = UDim2.new(1,-65,0,5)
MainLockBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
MainLockBtn.Text = "🔓"
MainLockBtn.TextColor3 = Color3.new(1,1,1)
MainLockBtn.Font = Enum.Font.GothamBold
MainLockBtn.TextScaled = true
MainLockBtn.Parent = MainFrame
Instance.new("UICorner", MainLockBtn).CornerRadius = UDim.new(0,6)

MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0,28,0,28)
MinBtn.Position = UDim2.new(1,-35,0,5)
MinBtn.BackgroundColor3 = Color3.fromRGB(200,120,20)
MinBtn.Text = IsMinimized and "➕" or "➖" -- ✅ Keep minimize icon
MinBtn.TextColor3 = Color3.new(1,1,1)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextScaled = true
MinBtn.Parent = MainFrame
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0,6)
AddRainbowGlow(MinBtn,2)

MakeDraggable(MainFrame, MainDragBar, MainLockBtn)

-- ESP BUTTON
ESPBtn = Instance.new("TextButton")
ESPBtn.Size = UDim2.new(0,90,0,32)
ESPBtn.Position = UDim2.new(0,10,0,42)
ESPBtn.BackgroundColor3 = ESP_Enabled and Color3.fromRGB(20,140,20) or Color3.fromRGB(40,40,40) -- ✅ Keep color
ESPBtn.Text = ESP_Enabled and "ESP: ON" or "ESP: OFF" -- ✅ Keep text state
ESPBtn.TextColor3 = Color3.new(1,1,1)
ESPBtn.Font = Enum.Font.GothamBold
ESPBtn.TextScaled = true
ESPBtn.Visible = not IsMinimized -- ✅ Hide if minimized
ESPBtn.Parent = MainFrame
Instance.new("UICorner", ESPBtn).CornerRadius = UDim.new(0,6)
AddRainbowGlow(ESPBtn,2)

-- EXIT BUTTON
ExitBtn = Instance.new("TextButton")
ExitBtn.Size = UDim2.new(0,90,0,32)
ExitBtn.Position = UDim2.new(0,110,0,42)
ExitBtn.BackgroundColor3 = Color3.fromRGB(180,30,30)
ExitBtn.Text = "🚪 EXIT"
ExitBtn.TextColor3 = Color3.new(1,1,1)
ExitBtn.Font = Enum.Font.GothamBold
ExitBtn.TextScaled = true
ExitBtn.Visible = not IsMinimized -- ✅ Hide if minimized
ExitBtn.Parent = MainFrame
Instance.new("UICorner", ExitBtn).CornerRadius = UDim.new(0,6)
AddRainbowGlow(ExitBtn,2)

-- MINIMIZE LOGIC
MinBtn.MouseButton1Click:Connect(function()
    IsMinimized = not IsMinimized
    if IsMinimized then
        MainFrame.Size = MINI_SIZE
        ESPBtn.Visible = false
        ExitBtn.Visible = false
        MinBtn.Text = "➕"
    else
        MainFrame.Size = FULL_SIZE
        ESPBtn.Visible = true
        ExitBtn.Visible = true
        MinBtn.Text = "➖"
    end
end)

-- ESP TOGGLE
ESPBtn.MouseButton1Click:Connect(function()
    ESP_Enabled = not ESP_Enabled
    if ESP_Enabled then
        ESPBtn.Text = "ESP: ON"
        ESPBtn.BackgroundColor3 = Color3.fromRGB(20,140,20)
    else
        ESPBtn.Text = "ESP: OFF"
        ESPBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
        ClearESPVisuals()
    end
end)

-- EXIT
ExitBtn.MouseButton1Click:Connect(function()
    ClearESPVisuals()
    if CurrentSound then CurrentSound:Destroy() end
    MainUI:Destroy()
    getgenv().BlueMode_Loaded = nil
end)

SetupDeathCheck()

-- MAIN LOOP
RunService.Heartbeat:Connect(function(Delta)
    if not MainUI or not MainUI.Parent then return end

    -- Timer
    local Now = os.time()
    UsedTime = UsedTime + math.max(0, Now - LastCheckTime)
    LastCheckTime = Now
    local Rem = math.max(0, USAGE_LIMIT - UsedTime)
    local H = math.floor(Rem/3600)
    local M = math.floor((Rem%3600)/60)
    local S = Rem%60
    TimerLabel.Text = string.format("%02d:%02d:%02d / 12:00",H,M,S)

    -- Rainbow
    Hue = (Hue + Delta*0.5) % 1
    local Rainbow = Color3.fromHSV(Hue,1,1)
    for _,v in pairs(GuiElements) do if v then v.Color = Rainbow end end

    -- ESP RUN
    if not ESP_Enabled then return end

    for _,P in pairs(Players:GetPlayers()) do
        if P == LocalPlayer then continue end
        local Char = P.Character
        if not Char then continue end
        local Head = Char:FindFirstChild("Head")
        local Hum = Char:FindFirstChild("Humanoid")
        if not Head or not Hum or Hum.Health <= 0 then
            continue
        end

        -- Outline
        local Outline = Char:FindFirstChild("BLUE_Outline") or Instance.new("Highlight", Char)
        Outline.Name = "BLUE_Outline"
        Outline.FillTransparency = 1
        Outline.OutlineTransparency = 0
        Outline.OutlineColor = Rainbow
        Outline.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

        -- Friend Dot
        if P:IsFriendsWith(LocalPlayer.UserId) then
            if not Head:FindFirstChild("FriendRainbowDot") then
                local Dot = Instance.new("BillboardGui")
                Dot.Name = "FriendRainbowDot"
                Dot.AlwaysOnTop = true
                Dot.Size = UDim2.new(0,22,0,22)
                Dot.StudsOffset = Vector3.new(0,2.5,0)
                Dot.Parent = Head
                local Circle = Instance.new("Frame", Dot)
                Circle.Size = UDim2.new(1,0,1,0)
                Circle.Position = UDim2.new(0.5,-11,0.5,-11)
                Circle.BackgroundTransparency = 1
                Instance.new("UICorner", Circle).CornerRadius = UDim.new(1,0)
                local Stroke = Instance.new("UIStroke", Circle)
                Stroke.Name = "RainbowAura"
                Stroke.Thickness = 3.5
                Stroke.Color = Rainbow
                table.insert(GuiElements, Stroke)
            end
        else
            if Head:FindFirstChild("FriendRainbowDot") then Head.FriendRainbowDot:Destroy() end
        end
    end
end)

print("✅ BLUE MODE ESP LOADED | NO RESET ON DEATH!")
