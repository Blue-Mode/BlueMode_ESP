-- ==============================================
-- BLUE MODE BOOMBOX | FRIEND RAINBOW DOT ESP ADDED
-- BACKGROUND: rbxassetid://101782008402770
-- ✅ FRIENDS GET RAINBOW DOT ABOVE HEAD | WORKS THROUGH WALLS
-- ==============================================
if getgenv().BlueModeBoombox then return end
getgenv().BlueModeBoombox = true

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")

-- SETTINGS
local MAX_Z = 2147483647
local BG_ASSET = "rbxassetid://101782008402770"
local YT_LINK = "https://youtube.com/@blue_mode?si=F2aeKujfOM5v2yw"
local hue = 0
local vol = 500
local currentSound = nil
local rainbowObjs = {}
local friendDots = {}
local minimized = false
local ESP_Enabled = true
local dragActive, dragStartPos, frameStartPos

-- ==============================================
-- RAINBOW OUTLINE SYSTEM
-- ==============================================
local function addRainbowOutline(obj)
    if not obj then return end
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 3
    stroke.LineJoinMode = Enum.LineJoinMode.Round
    stroke.Color = Color3.new(0,1,0)
    stroke.Parent = obj
    table.insert(rainbowObjs, stroke)
    Instance.new("UICorner", obj).CornerRadius = UDim.new(0, 10)
    return obj
end

-- ==============================================
-- FRIEND RAINBOW DOT ESP SYSTEM
-- ==============================================
local function updateFriendESP()
    if not ESP_Enabled then
        for _, dot in pairs(friendDots) do
            if dot then dot:Destroy() end
        end
        table.clear(friendDots)
        return
    end

    for _, Player in pairs(Players:GetPlayers()) do
        if Player == Players.LocalPlayer then continue end
        local Character = Player.Character
        if not Character then continue end
        local Head = Character:FindFirstChild("Head")
        if not Head then continue end
        local Humanoid = Character:FindFirstChild("Humanoid")
        if not Humanoid or Humanoid.Health <= 0 then
            if friendDots[Player.UserId] then friendDots[Player.UserId]:Destroy() friendDots[Player.UserId] = nil end
            continue
        end

        local isFriend = pcall(function() return Players.LocalPlayer:IsFriendsWith(Player.UserId) end)
        if isFriend then
            if not friendDots[Player.UserId] then
                local Dot = Instance.new("BillboardGui")
                Dot.Name = "BlueMode_FriendDot"
                Dot.AlwaysOnTop = true
                Dot.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                Dot.Size = UDim2.new(0, 20, 0, 20)
                Dot.StudsOffset = Vector3.new(0, 3.5, 0) -- Above head
                Dot.Adornee = Head
                Dot.Parent = CoreGui

                local Circle = Instance.new("Frame")
                Circle.Size = UDim2.new(1, 0, 1, 0)
                Circle.BackgroundTransparency = 0
                Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)
                Circle.Parent = Dot

                friendDots[Player.UserId] = Circle
            end
        else
            if friendDots[Player.UserId] then friendDots[Player.UserId]:Destroy() friendDots[Player.UserId] = nil end
        end
    end
end

-- ==============================================
-- MAIN GUI
-- ==============================================
local Gui = Instance.new("ScreenGui")
Gui.Name = "BlueModeBoombox"
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.DisplayOrder = MAX_Z
Gui.IgnoreGuiInset = true
Gui.ResetOnSpawn = false
Gui.Enabled = true
Gui.Parent = CoreGui

-- MAIN WINDOW FRAME
local MainWin = Instance.new("Frame")
MainWin.Size = UDim2.new(0, 580, 0, 520)
MainWin.Position = UDim2.new(0.5, -290, 0.5, -260)
MainWin.BackgroundColor3 = Color3.fromRGB(30, 35, 50)
MainWin.BackgroundTransparency = 0
MainWin.Active = true
MainWin.ClipsDescendants = false
MainWin.Visible = true
MainWin.Parent = Gui
addRainbowOutline(MainWin)

-- BACKGROUND IMAGE
task.wait(0.1)
local BG = Instance.new("ImageLabel")
BG.Size = UDim2.new(1,0,1,0)
BG.Position = UDim2.new(0,0,0,0)
BG.BackgroundTransparency = 1
BG.Image = BG_ASSET
BG.ScaleType = Enum.ScaleType.Fill
BG.ZIndex = -1
BG.Visible = true
BG.Parent = MainWin

-- TOP DRAG BAR
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, -90, 0, 50)
TopBar.Position = UDim2.new(0, 10, 0, 10)
TopBar.BackgroundColor3 = Color3.fromRGB(45, 50, 70)
TopBar.Active = true
TopBar.Visible = true
TopBar.Parent = MainWin

local DragLabel = Instance.new("TextLabel")
DragLabel.Size = UDim2.new(1,0,1,0)
DragLabel.BackgroundTransparency = 1
DragLabel.Text = "Drag Here"
DragLabel.Font = Enum.Font.Gotham
DragLabel.TextSize = 24
DragLabel.TextColor3 = Color3.new(1,1,1)
DragLabel.Visible = true
DragLabel.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 300, 1, 0)
Title.Position = UDim2.new(0.5, -150, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Blue Mode Boombox"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 34
Title.TextColor3 = Color3.new(1,1,1)
Title.Visible = true
Title.Parent = TopBar

-- MINIMIZE BUTTON
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 45, 0, 45)
MinBtn.Position = UDim2.new(1, -90, 0, 12)
MinBtn.BackgroundColor3 = Color3.fromRGB(55, 60, 80)
MinBtn.Text = "⬇"
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 26
MinBtn.TextColor3 = Color3.new(1,1,1)
MinBtn.Visible = true
MinBtn.Parent = MainWin
addRainbowOutline(MinBtn)

-- CLOSE BUTTON
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 45, 0, 45)
CloseBtn.Position = UDim2.new(1, -47, 0, 12)
CloseBtn.BackgroundColor3 = Color3.fromRGB(190, 40, 40)
CloseBtn.Text = "✕"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 26
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.Visible = true
CloseBtn.Parent = MainWin
addRainbowOutline(CloseBtn)

-- ESP TOGGLE
local ESP_Box = Instance.new("Frame")
ESP_Box.Size = UDim2.new(0, 55, 0, 55)
ESP_Box.Position = UDim2.new(0, 15, 0, 75)
ESP_Box.BackgroundColor3 = Color3.fromRGB(50, 170, 70)
ESP_Box.Visible = true
ESP_Box.Parent = MainWin
addRainbowOutline(ESP_Box)

local ESP_Text = Instance.new("TextLabel")
ESP_Text.Size = UDim2.new(1,0,1,0)
ESP_Text.BackgroundTransparency = 1
ESP_Text.Text = "ESP\nON"
ESP_Text.Font = Enum.Font.GothamBold
ESP_Text.TextSize = 18
ESP_Text.TextColor3 = Color3.new(1,1,1)
ESP_Text.Visible = true
ESP_Text.Parent = ESP_Box

-- BOOMBOX ID BOX
local ID_Box = Instance.new("TextBox")
ID_Box.Size = UDim2.new(1, -30, 0, 160)
ID_Box.Position = UDim2.new(0, 15, 0, 145)
ID_Box.BackgroundColor3 = Color3.fromRGB(25, 30, 45)
ID_Box.PlaceholderText = "Boombox\nID"
ID_Box.Font = Enum.Font.GothamBold
ID_Box.TextSize = 48
ID_Box.TextColor3 = Color3.new(1,1,1)
ID_Box.TextWrapped = true
ID_Box.TextAlign = Enum.TextXAlignment.Center
ID_Box.Visible = true
ID_Box.Parent = MainWin
addRainbowOutline(ID_Box)

-- LINK YOUTUBE BUTTON
local LinkBtn = Instance.new("TextButton")
LinkBtn.Size = UDim2.new(0, 55, 0, 55)
LinkBtn.Position = UDim2.new(0, 15, 0, 320)
LinkBtn.BackgroundColor3 = Color3.fromRGB(50, 170, 70)
LinkBtn.Text = "Link\nYT"
LinkBtn.Font = Enum.Font.GothamBold
LinkBtn.TextSize = 16
LinkBtn.TextColor3 = Color3.new(1,1,1)
LinkBtn.TextWrapped = true
LinkBtn.Visible = true
LinkBtn.Parent = MainWin
addRainbowOutline(LinkBtn)

-- MAIN BUTTONS
local function MakeBtn(text, pos, size, color)
    local Btn = Instance.new("TextButton")
    Btn.Size = size
    Btn.Position = pos
    Btn.BackgroundColor3 = color
    Btn.Text = text
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 42
    Btn.TextColor3 = Color3.new(1,1,1)
    Btn.Visible = true
    Btn.Parent = MainWin
    addRainbowOutline(Btn)
    return Btn
end

local PlayBtn = MakeBtn("Play", UDim2.new(0,80,0,310), UDim2.new(0,330,0,90), Color3.fromRGB(35, 100, 190))
local StopBtn = MakeBtn("Stop", UDim2.new(0,420,0,310), UDim2.new(0,145,0,90), Color3.fromRGB(190, 40, 40))
local ClearBtn = MakeBtn("Clear", UDim2.new(0,80,0,410), UDim2.new(0,250,0,80), Color3.fromRGB(55, 60, 80))
local VolBtn = MakeBtn("500\n1000", UDim2.new(0,340,0,410), UDim2.new(0,110,0,80), Color3.fromRGB(55, 60, 80))
local DeleteBtn = MakeBtn("Delete", UDim2.new(0,460,0,410), UDim2.new(0,110,0,80), Color3.fromRGB(190, 40, 40))

-- VOLUME SLIDER
local SliderBg = Instance.new("Frame")
SliderBg.Size = UDim2.new(1, -30, 0, 50)
SliderBg.Position = UDim2.new(0,15,0,505)
SliderBg.BackgroundColor3 = Color3.fromRGB(30, 35, 50)
SliderBg.Visible = true
SliderBg.Parent = MainWin
addRainbowOutline(SliderBg)

local SliderFill = Instance.new("Frame")
SliderFill.Size = UDim2.new(0.5,0,1,0)
SliderFill.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
SliderFill.ZIndex = 2
SliderFill.Visible = true
SliderFill.Parent = SliderBg
Instance.new("UICorner", SliderFill).CornerRadius = UDim.new(0,15)

-- MINIMIZED WINDOW
local MiniWin = Instance.new("Frame")
MiniWin.Size = UDim2.new(0, 240, 0, 90)
MiniWin.Position = UDim2.new(0.5, -120, 0.9, -110)
MiniWin.BackgroundColor3 = Color3.fromRGB(30, 35, 50)
MiniWin.Active = true
MiniWin.Visible = false
MiniWin.Parent = Gui
addRainbowOutline(MiniWin)

local MiniBG = Instance.new("ImageLabel")
MiniBG.Size = UDim2.new(1,0,1,0)
MiniBG.BackgroundTransparency = 1
MiniBG.Image = BG_ASSET
MiniBG.ScaleType = Enum.ScaleType.Fill
MiniBG.ZIndex = -1
MiniBG.Visible = true
MiniBG.Parent = MiniWin

local MiniTitle = Instance.new("TextLabel")
MiniTitle.Size = UDim2.new(1, -60, 1, 0)
MiniTitle.Position = UDim2.new(0,10,0,0)
MiniTitle.BackgroundTransparency = 1
MiniTitle.Text = "Blue Mode\nBoombox"
MiniTitle.Font = Enum.Font.GothamBold
MiniTitle.TextSize = 22
MiniTitle.TextColor3 = Color3.new(1,1,1)
MiniTitle.Visible = true
MiniTitle.Parent = MiniWin

local ExpandBtn = Instance.new("TextButton")
ExpandBtn.Size = UDim2.new(0, 45, 0, 45)
ExpandBtn.Position = UDim2.new(1, -50, 0, 22)
ExpandBtn.BackgroundColor3 = Color3.fromRGB(55, 60, 80)
ExpandBtn.Text = "⬆"
ExpandBtn.Font = Enum.Font.GothamBold
ExpandBtn.TextSize = 22
ExpandBtn.TextColor3 = Color3.new(1,1,1)
ExpandBtn.Visible = true
ExpandBtn.Parent = MiniWin
addRainbowOutline(ExpandBtn)

-- DRAG SYSTEM
local function MakeDraggable(frame, dragArea)
    dragArea.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragActive = true
            dragStartPos = UIS:GetMouseLocation()
            frameStartPos = frame.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragActive and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = UIS:GetMouseLocation() - dragStartPos
            frame.Position = UDim2.new(
                frameStartPos.X.Scale, frameStartPos.X.Offset + delta.X,
                frameStartPos.Y.Scale, frameStartPos.Y.Offset + delta.Y
            )
        end
    end)
    UIS.InputEnded:Connect(function() dragActive = false end)
end

MakeDraggable(MainWin, TopBar)
MakeDraggable(MiniWin, MiniWin)

-- BUTTON FUNCTIONS
MinBtn.MouseButton1Click:Connect(function()
    minimized = true
    MainWin.Visible = false
    MiniWin.Visible = true
end)

ExpandBtn.MouseButton1Click:Connect(function()
    minimized = false
    MainWin.Visible = true
    MiniWin.Visible = false
end)

CloseBtn.MouseButton1Click:Connect(function()
    if currentSound then currentSound:Destroy() end
    for _, dot in pairs(friendDots) do if dot then dot.Parent:Destroy() end end
    Gui:Destroy()
    getgenv().BlueModeBoombox = nil
end)

LinkBtn.MouseButton1Click:Connect(function()
    setclipboard(YT_LINK)
    print("✅ YouTube link copied!")
end)

ESP_Box.MouseButton1Click:Connect(function()
    ESP_Enabled = not ESP_Enabled
    ESP_Box.BackgroundColor3 = ESP_Enabled and Color3.fromRGB(50,170,70) or Color3.fromRGB(190,40,40)
    ESP_Text.Text = ESP_Enabled and "ESP\nON" or "ESP\nOFF"
    updateFriendESP()
end)

PlayBtn.MouseButton1Click:Connect(function()
    local id = ID_Box.Text:gsub("%D", "")
    if id == "" then return end
    if currentSound then currentSound:Destroy() end
    currentSound = Instance.new("Sound")
    currentSound.SoundId = "rbxassetid://"..id
    currentSound.Volume = vol / 1000
    currentSound.Looped = true
    currentSound.Parent = SoundService
    currentSound:Play()
end)

StopBtn.MouseButton1Click:Connect(function()
    if currentSound then currentSound:Destroy() currentSound = nil end
end)

ClearBtn.MouseButton1Click:Connect(function()
    ID_Box.Text = ""
end)

DeleteBtn.MouseButton1Click:Connect(function()
    if currentSound then currentSound:Destroy() end
    for _, dot in pairs(friendDots) do if dot then dot.Parent:Destroy() end end
    Gui:Destroy()
    getgenv().BlueModeBoombox = nil
end)

-- VOLUME SLIDER
local volDrag = false
SliderBg.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        volDrag = true
    end
end)
UIS.InputChanged:Connect(function(i)
    if volDrag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local pos = math.clamp(i.Position.X - SliderBg.AbsolutePosition.X, 0, SliderBg.AbsoluteSize.X)
        local pct = pos / SliderBg.AbsoluteSize.X
        vol = math.floor(pct * 999) + 1
        SliderFill.Size = UDim2.new(pct, 0, 1, 0)
        VolBtn.Text = vol.."\n1000"
        if currentSound then currentSound.Volume = vol / 1000 end
    end
end)
UIS.InputEnded:Connect(function() volDrag = false end)

-- ==============================================
-- MAIN ANIMATION LOOP
-- ==============================================
RunService.Heartbeat:Connect(function(dt)
    hue = (hue + dt * 0.5) % 1
    local col = Color3.fromHSV(hue, 1, 1)

    -- RAINBOW OUTLINES
    for _, stroke in pairs(rainbowObjs) do
        if stroke and stroke.Parent then stroke.Color = col end
    end

    -- FRIEND DOT RAINBOW + UPDATE
    for userId, dot in pairs(friendDots) do
        if dot then dot.BackgroundColor3 = col end
    end
    updateFriendESP()
end)

print("✅ BLUE MODE BOOMBOX | FRIEND RAINBOW DOT ESP ACTIVE!")
print("✅ Toggle ESP ON to see your friends through walls!")
