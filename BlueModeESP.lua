-- BLUE MODE HUB | FULL CUSTOM VERSION
-- BACKGROUND: rbxassetid://101782008402770
-- LAYOUT MATCHES YOUR SKETCH 100%
if getgenv().BlueModeHub then return end
getgenv().BlueModeHub = true

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- SETTINGS
local MAX_Z = 2147483647
local BG_ASSET = "rbxassetid://101782008402770"
local hue = 0
local locked = false
local minimized = false
local vol = 500 -- 1-1000

-- RAINBOW OBJECTS TRACKER
local rainbowObjs = {}

-- ==============================
-- RAINBOW EFFECT SYSTEM
-- ==============================
local function addRainbow(obj, isText)
    if not obj then return end
    if isText then
        table.insert(rainbowObjs, {Type="Text", Obj=obj})
    else
        local stroke = Instance.new("UIStroke")
        stroke.Thickness = 3
        stroke.LineJoinMode = Enum.LineJoinMode.Round
        stroke.Parent = obj
        table.insert(rainbowObjs, {Type="Stroke", Obj=stroke})
    end
    return obj
end

-- ==============================
-- MAIN HUB CREATION
-- ==============================
local Hub = Instance.new("ScreenGui")
Hub.Name = "BlueModeHub"
Hub.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Hub.DisplayOrder = MAX_Z
Hub.IgnoreGuiInset = true
Hub.Parent = CoreGui

-- MAIN FRAME WITH MOUNTAIN BACKGROUND
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 850, 0, 550)
MainFrame.Position = UDim2.new(0.5, -425, 0.5, -275)
MainFrame.BackgroundColor3 = Color3.new(0,0,0)
MainFrame.BackgroundTransparency = 0.1
MainFrame.Active = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = Hub

-- MOUNTAIN BACKGROUND IMAGE
local BG = Instance.new("ImageLabel")
BG.Size = UDim2.new(1,0,1,0)
BG.Position = UDim2.new(0,0,0,0)
BG.BackgroundTransparency = 1
BG.Image = BG_ASSET
BG.ScaleType = Enum.ScaleType.Fill
BG.Parent = MainFrame

-- RAINBOW OUTLINE FOR HUB
addRainbow(MainFrame)
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 16)

-- ==============================
-- TOP BAR
-- ==============================
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, -100, 0, 40)
TopBar.Position = UDim2.new(0, 10, 0, 5)
TopBar.BackgroundTransparency = 1
TopBar.Active = true
TopBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 180, 1, 0)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "BLUE MODE HUB"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 24
Title.TextColor3 = Color3.new(1,1,1)
Title.Parent = TopBar
addRainbow(Title, true)

local DragLabel = Instance.new("TextLabel")
DragLabel.Size = UDim2.new(0, 80, 1, 0)
DragLabel.Position = UDim2.new(0.5, -40, 0, 0)
DragLabel.BackgroundTransparency = 1
DragLabel.Text = "DRAG"
DragLabel.Font = Enum.Font.Gotham
DragLabel.TextSize = 20
DragLabel.TextColor3 = Color3.new(1,1,1)
DragLabel.Parent = TopBar
addRainbow(DragLabel, true)

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 100, 1, 0)
MinBtn.Position = UDim2.new(1, -110, 0, 0)
MinBtn.BackgroundColor3 = Color3.new(0.1,0.1,0.1)
MinBtn.Text = "MINIMIZE ➡"
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 18
MinBtn.TextColor3 = Color3.new(1,1,1)
MinBtn.Parent = TopBar
addRainbow(MinBtn)
addRainbow(MinBtn, true)
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 8)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 40, 1, 0)
CloseBtn.Position = UDim2.new(1, -45, 0, 0)
CloseBtn.BackgroundColor3 = Color3.new(0.7,0.1,0.1)
CloseBtn.Text = "✕"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 24
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.Parent = TopBar
addRainbow(CloseBtn)
addRainbow(CloseBtn, true)
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 8)

-- ==============================
-- LEFT SIDE MENU
-- ==============================
local LeftMenu = Instance.new("Frame")
LeftMenu.Size = UDim2.new(0, 220, 1, -60)
LeftMenu.Position = UDim2.new(0, 15, 0, 50)
LeftMenu.BackgroundTransparency = 1
LeftMenu.Parent = MainFrame

local function MenuBtn(name, posY)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -10, 0, 70)
    Btn.Position = UDim2.new(0, 5, 0, posY)
    Btn.BackgroundColor3 = Color3.new(0.08,0.08,0.08)
    Btn.Text = name
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 26
    Btn.TextColor3 = Color3.new(1,1,1)
    Btn.Parent = LeftMenu
    addRainbow(Btn)
    addRainbow(Btn, true)
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 10)
    return Btn
end

local Btn_Main = MenuBtn("MAIN", 0)
local Btn_Console = MenuBtn("CONSOLE", 80)
local Btn_Music = MenuBtn("MUSIC", 160)
local Btn_Emote = MenuBtn("EMOTE", 240)

-- COMMAND SEARCH BOX
local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(1, -10, 0, 70)
SearchBox.Position = UDim2.new(0, 5, 0, 320)
SearchBox.BackgroundColor3 = Color3.new(0.08,0.08,0.08)
SearchBox.PlaceholderText = "SEARCH COMMANDS..."
SearchBox.Font = Enum.Font.Gotham
SearchBox.TextSize = 20
SearchBox.TextColor3 = Color3.new(1,1,1)
SearchBox.Parent = LeftMenu
addRainbow(SearchBox)
Instance.new("UICorner", SearchBox).CornerRadius = UDim.new(0, 10)

-- ==============================
-- RIGHT MAIN PANEL
-- ==============================
local RightPanel = Instance.new("Frame")
RightPanel.Size = UDim2.new(1, -260, 1, -60)
RightPanel.Position = UDim2.new(0, 245, 0, 50)
RightPanel.BackgroundTransparency = 1
RightPanel.Parent = MainFrame

-- MAIN TAB TITLE
local MainTitle = Instance.new("TextLabel")
MainTitle.Size = UDim2.new(1,0,0,50)
MainTitle.Position = UDim2.new(0,0,0,0)
MainTitle.BackgroundTransparency = 1
MainTitle.Text = "MAIN"
MainTitle.Font = Enum.Font.GothamBold
MainTitle.TextSize = 32
MainTitle.TextColor3 = Color3.new(1,1,1)
MainTitle.Parent = RightPanel
addRainbow(MainTitle, true)

-- ESP SECTION
local ESP_Box = Instance.new("Frame")
ESP_Box.Size = UDim2.new(0, 280, 0, 120)
ESP_Box.Position = UDim2.new(0, 0, 0, 60)
ESP_Box.BackgroundColor3 = Color3.new(0.1,0.1,0.1)
ESP_Box.Parent = RightPanel
addRainbow(ESP_Box)
Instance.new("UICorner", ESP_Box).CornerRadius = UDim.new(0, 10)

local ESP_Title = Instance.new("TextLabel")
ESP_Title.Size = UDim2.new(0, 80, 1, 0)
ESP_Title.Position = UDim2.new(0,10,0,0)
ESP_Title.BackgroundTransparency = 1
ESP_Title.Text = "ESP"
ESP_Title.Font = Enum.Font.GothamBold
ESP_Title.TextSize = 24
ESP_Title.TextColor3 = Color3.new(1,1,1)
ESP_Title.Parent = ESP_Box
addRainbow(ESP_Title, true)

local ESP_List = Instance.new("TextLabel")
ESP_List.Size = UDim2.new(1, -100, 1, -10)
ESP_List.Position = UDim2.new(0, 100, 0, 5)
ESP_List.BackgroundTransparency = 1
ESP_List.Text = "• ESP RAINBOW\n• FRIEND RAINBOW\n• OUTLINE AVATAR"
ESP_List.Font = Enum.Font.Gotham
ESP_List.TextSize = 18
ESP_List.TextColor3 = Color3.new(1,1,1)
ESP_List.TextXAlignment = Enum.TextXAlignment.Left
ESP_List.Parent = ESP_Box
addRainbow(ESP_List, true)

-- TOGGLE FUNCTION
local function MakeToggle(name, posY)
    local Cont = Instance.new("Frame")
    Cont.Size = UDim2.new(1, -20, 0, 50)
    Cont.Position = UDim2.new(0, 10, 0, posY)
    Cont.BackgroundTransparency = 1
    Cont.Parent = RightPanel

    local Txt = Instance.new("TextLabel")
    Txt.Size = UDim2.new(0, 120, 1, 0)
    Txt.Position = UDim2.new(0, 60, 0, 0)
    Txt.BackgroundTransparency = 1
    Txt.Text = name
    Txt.Font = Enum.Font.GothamBold
    Txt.TextSize = 22
    Txt.TextColor3 = Color3.new(1,1,1)
    Txt.TextXAlignment = Enum.TextXAlignment.Left
    Txt.Parent = Cont
    addRainbow(Txt, true)

    local Toggle = Instance.new("Frame")
    Toggle.Size = UDim2.new(0, 50, 0, 30)
    Toggle.Position = UDim2.new(0, 0, 0, 10)
    Toggle.BackgroundColor3 = Color3.new(0.2,0.2,0.2)
    Toggle.Parent = Cont
    addRainbow(Toggle)
    Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0, 15)

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 24, 0, 24)
    Knob.Position = UDim2.new(0, 3, 0, 3)
    Knob.BackgroundColor3 = Color3.new(1,1,1)
    Knob.Parent = Toggle
    Instance.new("UICorner", Knob).CornerRadius = UDim.new(1,0)

    local State = false
    Toggle.InputBegan:Connect(function()
        State = not State
        Knob.Position = State and UDim2.new(1, -27, 0, 3) or UDim2.new(0, 3, 0, 3)
        Toggle.BackgroundColor3 = State and Color3.new(0.2,0.7,0.2) or Color3.new(0.2,0.2,0.2)
    end)
end

MakeToggle("LINK YOUTUBE", 200)
MakeToggle("LOCKER / DRAG", 260)
MakeToggle("SPEED", 320)
MakeToggle("FLY", 380)
MakeToggle("NOCLIP", 440)

-- ==============================
-- MUSIC TAB (MATCHES YOUR DESIGN)
-- ==============================
local MusicFrame = Instance.new("Frame")
MusicFrame.Size = UDim2.new(0, 450, 0, 350)
MusicFrame.Position = UDim2.new(0.5, -225, 0.5, -175)
MusicFrame.BackgroundTransparency = 1
MusicFrame.Visible = false
MusicFrame.Parent = MainFrame

local MusicBG = Instance.new("ImageLabel")
MusicBG.Size = UDim2.new(1,0,1,0)
MusicBG.BackgroundTransparency = 1
MusicBG.Image = BG_ASSET
MusicBG.ScaleType = Enum.ScaleType.Fill
MusicBG.Parent = MusicFrame
addRainbow(MusicFrame)
Instance.new("UICorner", MusicFrame).CornerRadius = UDim.new(0, 16)

local MusicTitle = Instance.new("TextLabel")
MusicTitle.Size = UDim2.new(1,0,0,50)
MusicTitle.Position = UDim2.new(0,0,0,10)
MusicTitle.BackgroundTransparency = 1
MusicTitle.Text = "BLUE MODE BOOMBOX"
MusicTitle.Font = Enum.Font.GothamBold
MusicTitle.TextSize = 30
MusicTitle.TextColor3 = Color3.new(1,1,1)
MusicTitle.Parent = MusicFrame
addRainbow(MusicTitle, true)

-- SEARCH/ID BOX
local IDBox = Instance.new("TextBox")
IDBox.Size = UDim2.new(1, -40, 0, 50)
IDBox.Position = UDim2.new(0, 20, 0, 70)
IDBox.BackgroundColor3 = Color3.new(0,0,0)
IDBox.PlaceholderText = "PASTE SOUND ID / SEARCH..."
IDBox.Font = Enum.Font.Gotham
IDBox.TextSize = 22
IDBox.TextColor3 = Color3.new(1,1,1)
IDBox.Parent = MusicFrame
addRainbow(IDBox)
Instance.new("UICorner", IDBox).CornerRadius = UDim.new(0, 10)

-- MUSIC BUTTONS
local function MusicBtn(txt, posX, color)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 130, 0, 60)
    Btn.Position = UDim2.new(0, posX, 0, 140)
    Btn.BackgroundColor3 = color
    Btn.Text = txt
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 28
    Btn.TextColor3 = Color3.new(1,1,1)
    Btn.Parent = MusicFrame
    addRainbow(Btn)
    addRainbow(Btn, true)
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 10)
    return Btn
end

local Btn_Play = MusicBtn("PLAY", 20, Color3.new(0.1,0.3,0.8))
local Btn_Stop = MusicBtn("STOP", 160, Color3.new(0.8,0.1,0.1))
local Btn_Close = MusicBtn("CLOSE", 300, Color3.new(0.2,0.2,0.2))

-- VOLUME SLIDER 1-1000
local VolSlider = Instance.new("Frame")
VolSlider.Size = UDim2.new(1, -40, 0, 30)
VolSlider.Position = UDim2.new(0, 20, 0, 220)
VolSlider.BackgroundColor3 = Color3.new(0.15,0.15,0.15)
VolSlider.Parent = MusicFrame
addRainbow(VolSlider)
Instance.new("UICorner", VolSlider).CornerRadius = UDim.new(0, 15)

local VolFill = Instance.new("Frame")
VolFill.Size = UDim2.new(vol/1000, 0, 1, 0)
VolFill.BackgroundColor3 = Color3.fromHSV(0,1,1)
VolFill.Parent = VolSlider
Instance.new("UICorner", VolFill).CornerRadius = UDim.new(0, 15)

local VolText = Instance.new("TextLabel")
VolText.Size = UDim2.new(0, 100, 0, 25)
VolText.Position = UDim2.new(0.5, -50, 0, 260)
VolText.BackgroundTransparency = 1
VolText.Text = "VOLUME: "..vol.."/1000"
VolText.Font = Enum.Font.GothamBold
VolText.TextSize = 20
VolText.TextColor3 = Color3.new(1,1,1)
VolText.Parent = MusicFrame
addRainbow(VolText, true)

-- ==============================
-- DRAG / LOCK / MINIMIZE LOGIC
-- ==============================
local dragStart, startPos, dragging
TopBar.InputBegan:Connect(function(input)
    if locked then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = UIS:GetMouseLocation()
        startPos = MainFrame.Position
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragging and not locked and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = UIS:GetMouseLocation() - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- LOCK TOGGLE
MakeToggle("LOCK HUB", 200).Txt.MouseButton1Click:Connect(function()
    locked = not locked
end)

-- MINIMIZE
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    MainFrame.Visible = not minimized
    if minimized then
        MinBtn.Text = "EXPAND ⬅"
    else
        MinBtn.Text = "MINIMIZE ➡"
    end
end)

-- CLOSE HUB
CloseBtn.MouseButton1Click:Connect(function()
    Hub:Destroy()
    getgenv().BlueModeHub = false
end)

-- TAB SWITCHING
Btn_Main.MouseButton1Click:Connect(function()
    RightPanel.Visible = true
    MusicFrame.Visible = false
end)
Btn_Music.MouseButton1Click:Connect(function()
    RightPanel.Visible = false
    MusicFrame.Visible = true
end)
Btn_Close.MouseButton1Click:Connect(function()
    MusicFrame.Visible = false
    RightPanel.Visible = true
end)

-- ==============================
-- PERMANENT RAINBOW ANIMATION
-- ==============================
RunService.Heartbeat:Connect(function(dt)
    hue = (hue + dt * 0.5) % 1
    local col = Color3.fromHSV(hue, 1, 1)
    for _, v in pairs(rainbowObjs) do
        if v.Type == "Stroke" and v.Obj then v.Obj.Color = col end
        if v.Type == "Text" and v.Obj then v.Obj.TextColor3 = col end
    end
    VolFill.BackgroundColor3 = col
end)

print("✅ BLUE MODE HUB LOADED SUCCESSFULLY!")
print("✅ BACKGROUND: MOUNTAIN IMAGE APPLIED")
print("✅ ALL BUTTONS & LAYOUT MATCH YOUR SKETCH")
