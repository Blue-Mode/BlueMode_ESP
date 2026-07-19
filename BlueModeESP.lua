-- ScreenGui + Boombox Frame
local ScreenGui = Instance.new("ScreenGui", game.Players.LocalPlayer:WaitForChild("PlayerGui"))
local BoomboxFrame = Instance.new("Frame")
BoomboxFrame.Size = UDim2.new(0,420,0,380)
BoomboxFrame.Position = UDim2.new(0.5,-210,0.5,-190)
BoomboxFrame.BackgroundColor3 = Color3.fromRGB(25,25,40)
BoomboxFrame.Parent = ScreenGui

-- Background image
local Bg = Instance.new("ImageLabel")
Bg.Size = UDim2.new(1,0,1,0)
Bg.Position = UDim2.new(0,0,0,0)
Bg.Image = "rbxassetid://101782008402770" -- mountain background
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

task.spawn(function()
    while UIStroke.Parent do
        for i = 0,1,0.01 do
            UIStroke.Color = Color3.fromHSV(i,1,1)
            task.wait(0.05)
        end
    end
end)

-- Title Label
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,40)
Title.Position = UDim2.new(0,0,0,0)
Title.Text = "BLUE MODE"
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true
Title.BackgroundTransparency = 1
Title.Parent = BoomboxFrame

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

-- Sound object
local Sound = Instance.new("Sound")
Sound.Parent = game:GetService("SoundService")
Sound.Volume = 1
Sound.Looped = true

-- Input Box for Music ID / Link
local InputBox = Instance.new("TextBox")
InputBox.Size = UDim2.new(0,380,0,40)
InputBox.Position = UDim2.new(0,20,0,60)
InputBox.Text = "Enter Music ID or Link"
InputBox.Font = Enum.Font.GothamBold
InputBox.TextScaled = true
InputBox.BackgroundColor3 = Color3.fromRGB(0,0,0)
InputBox.TextColor3 = Color3.new(1,1,1)
InputBox.Parent = BoomboxFrame

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

-- Play Button
local PlayBtn = Instance.new("TextButton")
PlayBtn.Size = UDim2.new(0,120,0,50)
PlayBtn.Position = UDim2.new(0,30,0,120)
PlayBtn.Text = "PLAY"
PlayBtn.Font = Enum.Font.GothamBold
PlayBtn.TextScaled = true
PlayBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
PlayBtn.Parent = BoomboxFrame

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

-- Stop Button
local StopBtn = Instance.new("TextButton")
StopBtn.Size = UDim2.new(0,120,0,50)
StopBtn.Position = UDim2.new(0,170,0,120)
StopBtn.Text = "STOP"
StopBtn.Font = Enum.Font.GothamBold
StopBtn.TextScaled = true
StopBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
StopBtn.Parent = BoomboxFrame

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

-- Volume Box
local VolumeBox = Instance.new("TextBox")
VolumeBox.Size = UDim2.new(0,120,0,50)
VolumeBox.Position = UDim2.new(0,310,0,120)
VolumeBox.Text = "Volume (1-1000)"
VolumeBox.Font = Enum.Font.GothamBold
VolumeBox.TextScaled = true
VolumeBox.BackgroundColor3 = Color3.fromRGB(0,0,0)
VolumeBox.TextColor3 = Color3.new(1,1,1)
VolumeBox.Parent = BoomboxFrame

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
