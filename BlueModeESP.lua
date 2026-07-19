-- ScreenGui + Boombox Frame
local ScreenGui = Instance.new("ScreenGui", game.Players.LocalPlayer:WaitForChild("PlayerGui"))
local BoomboxFrame = Instance.new("Frame")
BoomboxFrame.Size = UDim2.new(0,400,0,350)
BoomboxFrame.Position = UDim2.new(0.5,-200,0.5,-175)
BoomboxFrame.BackgroundColor3 = Color3.fromRGB(25,25,40)
BoomboxFrame.Parent = ScreenGui

-- Background image
local Bg = Instance.new("ImageLabel")
Bg.Size = UDim2.new(1,0,1,0)
Bg.Position = UDim2.new(0,0,0,0)
Bg.Image = "rbxassetid://101782008402770" -- ✅ mountain background
Bg.ScaleType = Enum.ScaleType.Crop
Bg.ZIndex = 0
Bg.Parent = BoomboxFrame
BoomboxFrame.BackgroundTransparency = 1

-- Rounded corners + rainbow outline
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0,12)
UICorner.Parent = BoomboxFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 3
UIStroke.Parent = BoomboxFrame

-- Rainbow animation for outline
task.spawn(function()
    while UIStroke.Parent do
        for i = 0,1,0.01 do
            UIStroke.Color = Color3.fromHSV(i,1,1)
            task.wait(0.05)
        end
    end
end)

-- Drag logic with lock toggle
local UserInputService = game:GetService("UserInputService")
local dragging, dragInput, dragStart, startPos
local dragEnabled = true

BoomboxFrame.InputBegan:Connect(function(input)
    if dragEnabled and input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = BoomboxFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

BoomboxFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging and dragEnabled then
        local delta = input.Position - dragStart
        BoomboxFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Sound object
local Sound = Instance.new("Sound")
Sound.Parent = game:GetService("SoundService")
Sound.Volume = 1
Sound.Looped = true
Sound.SoundId = "rbxassetid://1848354533" -- replace with your music ID

-- Play Button
local PlayBtn = Instance.new("TextButton")
PlayBtn.Size = UDim2.new(0,120,0,50)
PlayBtn.Position = UDim2.new(0,30,0,200)
PlayBtn.Text = "PLAY"
PlayBtn.Font = Enum.Font.GothamBold
PlayBtn.TextScaled = true
PlayBtn.Parent = BoomboxFrame
PlayBtn.MouseButton1Click:Connect(function() Sound:Play() end)

-- Stop Button
local StopBtn = Instance.new("TextButton")
StopBtn.Size = UDim2.new(0,120,0,50)
StopBtn.Position = UDim2.new(0,170,0,200)
StopBtn.Text = "STOP"
StopBtn.Font = Enum.Font.GothamBold
StopBtn.TextScaled = true
StopBtn.Parent = BoomboxFrame
StopBtn.MouseButton1Click:Connect(function() Sound:Stop() end)

-- Volume TextBox
local Slider = Instance.new("TextBox")
Slider.Size = UDim2.new(0,120,0,50)
Slider.Position = UDim2.new(0,310,0,200)
Slider.Text = "Volume (1-1000)"
Slider.Font = Enum.Font.GothamBold
Slider.TextScaled = true
Slider.Parent = BoomboxFrame
Slider.FocusLost:Connect(function()
    local val = tonumber(Slider.Text)
    if val then
        val = math.clamp(val,1,1000)
        Sound.Volume = val/1000
    end
end)

-- Lock/Unlock Button
local LockBtn = Instance.new("TextButton")
LockBtn.Size = UDim2.new(0,120,0,40)
LockBtn.Position = UDim2.new(0,30,0,260)
LockBtn.Text = "LOCK DRAG"
LockBtn.Font = Enum.Font.GothamBold
LockBtn.TextScaled = true
LockBtn.Parent = BoomboxFrame
LockBtn.MouseButton1Click:Connect(function()
    dragEnabled = not dragEnabled
    LockBtn.Text = dragEnabled and "LOCK DRAG" or "UNLOCK DRAG"
end)

-- Minimize Button
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0,120,0,40)
MinBtn.Position = UDim2.new(0,170,0,260)
MinBtn.Text = "MINIMIZE"
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextScaled = true
MinBtn.Parent = BoomboxFrame

-- MiniIcon with your logo
local MiniIcon = Instance.new("ImageButton")
MiniIcon.Size = UDim2.new(0,80,0,80)
MiniIcon.Position = UDim2.new(0,20,0,70)
MiniIcon.Image = "rbxassetid://<YOUR_LOGO_ASSET_ID>" -- 🔹 replace with your logo asset ID
MiniIcon.Visible = false
MiniIcon.Parent = ScreenGui

-- MiniIcon drag logic
local draggingMini, dragInputMini, dragStartMini, startPosMini
MiniIcon.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingMini = true
        dragStartMini = input.Position
        startPosMini = MiniIcon.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                draggingMini = false
            end
        end)
    end
end)

MiniIcon.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInputMini = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInputMini and draggingMini then
        local delta = input.Position - dragStartMini
        MiniIcon.Position = UDim2.new(
            startPosMini.X.Scale,
            startPosMini.X.Offset + delta.X,
            startPosMini.Y.Scale,
            startPosMini.Y.Offset + delta.Y
        )
    end
end)

-- Minimize logic
MinBtn.MouseButton1Click:Connect(function()
    BoomboxFrame.Visible = false
    MiniIcon.Visible = true
end)

MiniIcon.MouseButton1Click:Connect(function()
    BoomboxFrame.Visible = true
    MiniIcon.Visible = false
end)
