-- Part 1: ScreenGui + Hub Frame
local ScreenGui = Instance.new("ScreenGui", game.Players.LocalPlayer:WaitForChild("PlayerGui"))
local HubFrame = Instance.new("Frame")
HubFrame.Size = UDim2.new(0,450,0,550)
HubFrame.Position = UDim2.new(0.5,-225,0.5,-275)
HubFrame.BackgroundColor3 = Color3.fromRGB(25,25,40)
HubFrame.Parent = ScreenGui

-- Part 2: Background image (mountain)
local Bg = Instance.new("ImageLabel")
Bg.Size = UDim2.new(1,0,1,0)
Bg.Position = UDim2.new(0,0,0,0)
Bg.Image = "rbxassetid://101782008402770" -- mountain background
Bg.ScaleType = Enum.ScaleType.Crop
Bg.ZIndex = 0
Bg.Parent = HubFrame
HubFrame.BackgroundTransparency = 1

-- Part 3: Rounded corners + rainbow outline
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0,12)
UICorner.Parent = HubFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 3
UIStroke.Parent = HubFrame

task.spawn(function()
    while UIStroke.Parent do
        for i = 0,1,0.01 do
            UIStroke.Color = Color3.fromHSV(i,1,1)
            task.wait(0.05)
        end
    end
end)

-- Part 4: Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,40)
Title.Position = UDim2.new(0,0,0,0)
Title.Text = "BLUE MODE HUB"
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true
Title.BackgroundTransparency = 1
Title.Parent = HubFrame

local TitleStroke = Instance.new("UIStroke")
TitleStroke.Thickness = 2
TitleStroke.Parent = Title

task.spawn(function()
    while Title.Parent do
        for i = 0,1,0.01 do
            local rainbow = Color3.fromHSV(i,1,1)
            Title.TextColor3 = rainbow
            TitleStroke.Color = rainbow
            task.wait(0.05)
        end
    end
end)

-- Part 5: Minimize button (mountain picture + rainbow outline)
local MinBtn = Instance.new("ImageButton")
MinBtn.Size = UDim2.new(0,100,0,40)
MinBtn.Position = UDim2.new(1,-110,0,10)
MinBtn.Image = "rbxassetid://101782008402770" -- mountain picture
MinBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
MinBtn.Parent = HubFrame

local MinStroke = Instance.new("UIStroke")
MinStroke.Thickness = 2
MinStroke.Parent = MinBtn

task.spawn(function()
    while MinBtn.Parent do
        for i = 0,1,0.01 do
            MinStroke.Color = Color3.fromHSV(i,1,1)
            task.wait(0.05)
        end
    end
end)

MinBtn.MouseButton1Click:Connect(function()
    HubFrame.Visible = false
    -- restore logic will be added in later parts
end)

-- Part 6: Player + ESP setup
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Part 7: Function to enable rainbow ESP
local function EnableRainbowESP()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            -- Rainbow outline for all players
            local highlight = Instance.new("Highlight")
            highlight.Name = "RainbowESP"
            highlight.FillTransparency = 1
            highlight.OutlineTransparency = 0
            highlight.Parent = plr.Character

            task.spawn(function()
                while highlight.Parent do
                    for i = 0,1,0.01 do
                        highlight.OutlineColor3 = Color3.fromHSV(i,1,1)
                        task.wait(0.05)
                    end
                end
            end)

            -- Rainbow dot for friends
            if LocalPlayer:IsFriendsWith(plr.UserId) then
                local dot = Instance.new("BillboardGui")
                dot.Size = UDim2.new(0,20,0,20)
                dot.AlwaysOnTop = true
                dot.Parent = plr.Character:FindFirstChild("Head")

                local circle = Instance.new("Frame")
                circle.Size = UDim2.new(1,0,1,0)
                circle.BackgroundColor3 = Color3.new(1,0,0)
                circle.Parent = dot
                Instance.new("UICorner", circle).CornerRadius = UDim.new(1,0)

                task.spawn(function()
                    while circle.Parent do
                        for i = 0,1,0.01 do
                            circle.BackgroundColor3 = Color3.fromHSV(i,1,1)
                            task.wait(0.05)
                        end
                    end
                end)
            end
        end
    end
end

-- Part 8: ESP Button
local ESPBtn = Instance.new("TextButton")
ESPBtn.Size = UDim2.new(0,120,0,50)
ESPBtn.Position = UDim2.new(0.5,-60,0,100)
ESPBtn.Text = "ENABLE ESP"
ESPBtn.Font = Enum.Font.GothamBold
ESPBtn.TextScaled = true
ESPBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
ESPBtn.Parent = HubFrame

-- Part 9: Rainbow outline + text for ESP button
local ESPStroke = Instance.new("UIStroke")
ESPStroke.Thickness = 2
ESPStroke.Parent = ESPBtn

task.spawn(function()
    while ESPBtn.Parent do
        for i = 0,1,0.01 do
            local rainbow = Color3.fromHSV(i,1,1)
            ESPBtn.TextColor3 = rainbow
            ESPStroke.Color = rainbow
            task.wait(0.05)
        end
    end
end)

-- Part 10: ESP button logic
ESPBtn.MouseButton1Click:Connect(function()
    EnableRainbowESP()
end)

-- Part 11: Drag logic + lock toggle
local UserInputService = game:GetService("UserInputService")
local dragging, dragInput, dragStart, startPos
local dragEnabled = true

HubFrame.InputBegan:Connect(function(input)
    if dragEnabled and input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = HubFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

HubFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging and dragEnabled then
        local delta = input.Position - dragStart
        HubFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Part 12: Lock/Unlock button
local LockBtn = Instance.new("TextButton")
LockBtn.Size = UDim2.new(0,120,0,40)
LockBtn.Position = UDim2.new(0,30,0,160)
LockBtn.Text = "LOCK DRAG"
LockBtn.Font = Enum.Font.GothamBold
LockBtn.TextScaled = true
LockBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
LockBtn.Parent = HubFrame

local LockStroke = Instance.new("UIStroke")
LockStroke.Thickness = 2
LockStroke.Parent = LockBtn

task.spawn(function()
    while LockBtn.Parent do
        for i = 0,1,0.01 do
            local rainbow = Color3.fromHSV(i,1,1)
            LockBtn.TextColor3 = rainbow
            LockStroke.Color = rainbow
            task.wait(0.05)
        end
    end
end)

LockBtn.MouseButton1Click:Connect(function()
    dragEnabled = not dragEnabled
    LockBtn.Text = dragEnabled and "LOCK DRAG" or "UNLOCK DRAG"
end)

-- Part 13: Sound object
local Sound = Instance.new("Sound")
Sound.Parent = game:GetService("SoundService")
Sound.Volume = 1
Sound.Looped = true

-- Part 14: Input Box for Music ID / Link
local InputBox = Instance.new("TextBox")
InputBox.Size = UDim2.new(0,380,0,40)
InputBox.Position = UDim2.new(0,20,0,220)
InputBox.Text = "Enter Music ID or Link"
InputBox.Font = Enum.Font.GothamBold
InputBox.TextScaled = true
InputBox.BackgroundColor3 = Color3.fromRGB(0,0,0)
InputBox.TextColor3 = Color3.new(1,1,1)
InputBox.Parent = HubFrame

local InputStroke = Instance.new("UIStroke")
InputStroke.Thickness = 2
InputStroke.Parent = InputBox

task.spawn(function()
    while InputBox.Parent do
        for i = 0,1,0.01 do
            local rainbow = Color3.fromHSV(i,1,1)
            InputBox.TextColor3 = rainbow
            InputStroke.Color = rainbow
            task.wait(0.05)
        end
    end
end)

-- Part 15: Play + Stop buttons
local PlayBtn = Instance.new("TextButton")
PlayBtn.Size = UDim2.new(0,120,0,50)
PlayBtn.Position = UDim2.new(0,30,0,280)
PlayBtn.Text = "PLAY"
PlayBtn.Font = Enum.Font.GothamBold
PlayBtn.TextScaled = true
PlayBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
PlayBtn.Parent = HubFrame

local PlayStroke = Instance.new("UIStroke")
PlayStroke.Thickness = 2
PlayStroke.Parent = PlayBtn

task.spawn(function()
    while PlayBtn.Parent do
        for i = 0,1,0.01 do
            local rainbow = Color3.fromHSV(i,1,1)
            PlayBtn.TextColor3 = rainbow
            PlayStroke.Color = rainbow
            task.wait(0.05)
        end
    end
end)

PlayBtn.MouseButton1Click:Connect(function()
    local text = InputBox.Text
    if tonumber(text) then
        Sound.SoundId = "rbxassetid://"..text
    elseif string.find(text,"http") then
        Sound.SoundId = text
    end
    Sound:Play()
end)

local StopBtn = Instance.new("TextButton")
StopBtn.Size = UDim2.new(0,120,0,50)
StopBtn.Position = UDim2.new(0,170,0,280)
StopBtn.Text = "STOP"
StopBtn.Font = Enum.Font.GothamBold
StopBtn.TextScaled = true
StopBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
StopBtn.Parent = HubFrame

local StopStroke = Instance.new("UIStroke")
StopStroke.Thickness = 2
StopStroke.Parent = StopBtn

task.spawn(function()
    while StopBtn.Parent do
        for i = 0,1,0.01 do
            local rainbow = Color3.fromHSV(i,1,1)
            StopBtn.TextColor3 = rainbow
            StopStroke.Color = rainbow
            task.wait(0.05)
        end
    end
end)

StopBtn.MouseButton1Click:Connect(function()
    Sound:Stop()
end)

-- Part 16: Volume Box
local VolumeBox = Instance.new("TextBox")
VolumeBox.Size = UDim2.new(0,120,0,50) -- same size as Play/Stop
VolumeBox.Position = UDim2.new(0,310,0,280)
VolumeBox.Text = "Volume (1-1000)"
VolumeBox.Font = Enum.Font.GothamBold
VolumeBox.TextScaled = true
VolumeBox.BackgroundColor3 = Color3.fromRGB(0,0,0)
VolumeBox.TextColor3 = Color3.new(1,1,1)
VolumeBox.Parent = HubFrame

local VolStroke = Instance.new("UIStroke")
VolStroke.Thickness = 2
VolStroke.Parent = VolumeBox

task.spawn(function()
    while VolumeBox.Parent do
        for i = 0,1,0.01 do
            local rainbow = Color3.fromHSV(i,1,1)
            VolumeBox.TextColor3 = rainbow
            VolStroke.Color = rainbow
            task.wait(0.05)
        end
    end
end)

VolumeBox.FocusLost:Connect(function()
    local val = tonumber(VolumeBox.Text)
    if val then
        val = math.clamp(val,1,1000)
        Sound.Volume = val/1000
    end
end)

-- Part 17: Clear Button
local ClearBtn = Instance.new("TextButton")
ClearBtn.Size = UDim2.new(0,120,0,50)
ClearBtn.Position = UDim2.new(0,30,0,340)
ClearBtn.Text = "CLEAR"
ClearBtn.Font = Enum.Font.GothamBold
ClearBtn.TextScaled = true
ClearBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
ClearBtn.Parent = HubFrame

local ClearStroke = Instance.new("UIStroke")
ClearStroke.Thickness = 2
ClearStroke.Parent = ClearBtn

task.spawn(function()
    while ClearBtn.Parent do
        for i = 0,1,0.01 do
            local rainbow = Color3.fromHSV(i,1,1)
            ClearBtn.TextColor3 = rainbow
            ClearStroke.Color = rainbow
            task.wait(0.05)
        end
    end
end)

ClearBtn.MouseButton1Click:Connect(function()
    InputBox.Text = ""
    VolumeBox.Text = "Volume (1-1000)"
    Sound:Stop()
end)

-- Part 18: Restore icon when minimized
local RestoreIcon = Instance.new("ImageButton")
RestoreIcon.Size = UDim2.new(0,60,0,60)
RestoreIcon.Position = UDim2.new(0,20,0,70)
RestoreIcon.Image = "rbxassetid://101782008402770" -- mountain picture
RestoreIcon.BackgroundColor3 = Color3.fromRGB(0,0,0)
RestoreIcon.Visible = false
RestoreIcon.Parent = ScreenGui

local RestoreStroke = Instance.new("UIStroke")
RestoreStroke.Thickness = 2
RestoreStroke.Parent = RestoreIcon

task.spawn(function()
    while RestoreIcon.Parent do
        for i = 0,1,0.01 do
            RestoreStroke.Color = Color3.fromHSV(i,1,1)
            task.wait(0.05)
        end
    end
end)

-- Part 19: Minimize logic update
MinBtn.MouseButton1Click:Connect(function()
    HubFrame.Visible = false
    RestoreIcon.Visible = true
end)

RestoreIcon.MouseButton1Click:Connect(function()
    HubFrame.Visible = true
    RestoreIcon.Visible = false
end)

-- Part 20: Final polish
print("✅ BLUE MODE HUB fully loaded with ESP, music controls, rainbow outlines, mountain background, minimize/restore, and lock drag toggle.")

