-- ==============================================
-- BLUE MODE BOOMBOX | FULL SCRIPT
-- ==============================================
if getgenv().BlueModeBoombox then return end
getgenv().BlueModeBoombox = true

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local SoundService = game:GetService("SoundService")

-- SETTINGS
local MAX_Z = 2147483647
local BG_ASSET = "rbxassetid://YOUR_IMAGE_ID" -- Replace with your Roblox image decal ID
local YT_LINK = "https://youtube.com/@blue_modeishF2neAkj4OM5zDyw"
local hue, vol = 0, 500
local currentSound = nil
local rainbowObjs, friendDots = {}, {}
local ESP_Enabled, minimized = true, false

-- RAINBOW OUTLINE
local function addRainbowOutline(obj)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 3
    stroke.LineJoinMode = Enum.LineJoinMode.Round
    stroke.Color = Color3.new(1,0,0)
    stroke.Parent = obj
    table.insert(rainbowObjs, stroke)
    Instance.new("UICorner", obj).CornerRadius = UDim.new(0, 10)
end

-- FRIEND DOT ESP
local function updateFriendESP()
    if not ESP_Enabled then
        for _, dot in pairs(friendDots) do if dot then dot:Destroy() end end
        table.clear(friendDots)
        return
    end
    for _, Player in pairs(Players:GetPlayers()) do
        if Player == Players.LocalPlayer then continue end
        local Head = Player.Character and Player.Character:FindFirstChild("Head")
        local Humanoid = Player.Character and Player.Character:FindFirstChild("Humanoid")
        if Head and Humanoid and Humanoid.Health > 0 then
            local isFriend = pcall(function() return Players.LocalPlayer:IsFriendsWith(Player.UserId) end)
            if isFriend and not friendDots[Player.UserId] then
                local Dot = Instance.new("BillboardGui")
                Dot.Size = UDim2.new(0,20,0,20)
                Dot.AlwaysOnTop = true
                Dot.StudsOffset = Vector3.new(0,3.5,0)
                Dot.Adornee = Head
                Dot.Parent = CoreGui
                local Circle = Instance.new("Frame")
                Circle.Size = UDim2.new(1,0,1,0)
                Circle.BackgroundTransparency = 0
                Instance.new("UICorner", Circle).CornerRadius = UDim.new(1,0)
                Circle.Parent = Dot
                friendDots[Player.UserId] = Circle
            end
        else
            if friendDots[Player.UserId] then friendDots[Player.UserId]:Destroy() friendDots[Player.UserId] = nil end
        end
    end
end

-- GUI SETUP
local Gui = Instance.new("ScreenGui", CoreGui)
Gui.Name = "BlueModeBoombox"
Gui.DisplayOrder = MAX_Z
Gui.IgnoreGuiInset = true

local MainWin = Instance.new("Frame", Gui)
MainWin.Size = UDim2.new(0,580,0,520)
MainWin.Position = UDim2.new(0.5,-290,0.5,-260)
MainWin.BackgroundColor3 = Color3.fromRGB(30,35,50)
addRainbowOutline(MainWin)

local BG = Instance.new("ImageLabel", MainWin)
BG.Size = UDim2.new(1,0,1,0)
BG.Image = BG_ASSET
BG.BackgroundTransparency = 1
BG.ZIndex = -1

-- ESP Toggle
local ESP_Box = Instance.new("TextButton", MainWin)
ESP_Box.Size = UDim2.new(0,55,0,55)
ESP_Box.Position = UDim2.new(0,15,0,75)
ESP_Box.BackgroundColor3 = Color3.fromRGB(50,170,70)
ESP_Box.Text = "ESP\nON"
ESP_Box.MouseButton1Click:Connect(function()
    ESP_Enabled = not ESP_Enabled
    ESP_Box.Text = ESP_Enabled and "ESP\nON" or "ESP\nOFF"
    ESP_Box.BackgroundColor3 = ESP_Enabled and Color3.fromRGB(50,170,70) or Color3.fromRGB(190,40,40)
    updateFriendESP()
end)
addRainbowOutline(ESP_Box)

-- Boombox ID
local ID_Box = Instance.new("TextBox", MainWin)
ID_Box.Size = UDim2.new(1,-30,0,160)
ID_Box.Position = UDim2.new(0,15,0,145)
ID_Box.PlaceholderText = "Boombox\nID"
ID_Box.Font = Enum.Font.GothamBold
ID_Box.TextSize = 48
ID_Box.TextColor3 = Color3.new(1,1,1)
addRainbowOutline(ID_Box)

-- Play Button
local PlayBtn = Instance.new("TextButton", MainWin)
PlayBtn.Size = UDim2.new(0,330,0,90)
PlayBtn.Position = UDim2.new(0,80,0,310)
PlayBtn.Text = "Play"
PlayBtn.BackgroundColor3 = Color3.fromRGB(35,100,190)
PlayBtn.MouseButton1Click:Connect(function()
    local id = ID_Box.Text:gsub("%D","")
    if id == "" then return end
    if currentSound then currentSound:Destroy() end
    currentSound = Instance.new("Sound", SoundService)
    currentSound.SoundId = "rbxassetid://"..id
    currentSound.Volume = vol/1000
    currentSound.Looped = true
    currentSound:Play()
end)
addRainbowOutline(PlayBtn)

-- Stop Button
local StopBtn = Instance.new("TextButton", MainWin)
StopBtn.Size = UDim2.new(0,145,0,90)
StopBtn.Position = UDim2.new(0,420,0,310)
StopBtn.Text = "Stop"
StopBtn.BackgroundColor3 = Color3.fromRGB(190,40,40)
StopBtn.MouseButton1Click:Connect(function()
    if currentSound then currentSound:Destroy() currentSound = nil end
end)
addRainbowOutline(StopBtn)

-- Clear Button
local ClearBtn = Instance.new("TextButton", MainWin)
ClearBtn.Size = UDim2.new(0,250,0,80)
ClearBtn.Position = UDim2.new(0,80,0,410)
ClearBtn.Text = "Clear"
ClearBtn.BackgroundColor3 = Color3.fromRGB(55,60,80)
ClearBtn.MouseButton1Click:Connect(function() ID_Box.Text = "" end)
addRainbowOutline(ClearBtn)

-- Volume Slider
local SliderBg = Instance.new("Frame", MainWin)
SliderBg.Size = UDim2.new(1,-30,0,50)
SliderBg.Position = UDim2.new(0,15,0,505)
SliderBg.BackgroundColor3 = Color3.fromRGB(30,35,50)
addRainbowOutline(SliderBg)

local SliderFill = Instance.new("Frame", SliderBg)
SliderFill.Size = UDim2.new(0.5,0,1,0)
SliderFill.BackgroundColor3 = Color3.fromRGB(50,200,50)

UIS.InputChanged:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseMovement and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
        local pos = math.clamp(i.Position.X - SliderBg.AbsolutePosition.X, 0, SliderBg.AbsoluteSize.X)
        local pct = pos / SliderBg.AbsoluteSize.X
        vol = math.floor(pct * 999) + 1
        SliderFill.Size = UDim2.new(pct,0,1,0)
        if currentSound then currentSound.Volume = vol/1000 end
    end
end)

-- Rainbow Animation
RunService.Heartbeat:Connect(function(dt)
    hue = (hue + dt*0.5) % 1
    local col = Color3.fromHSV(hue,1,1)
    for _, stroke in pairs(rainbowObjs) do if stroke.Parent then stroke.Color = col end end
    for _, dot in pairs(friendDots) do if dot then dot.BackgroundColor3 = col end end
    updateFriendESP()
end)

print("✅ Blue Mode Boombox Full Script Loaded")
