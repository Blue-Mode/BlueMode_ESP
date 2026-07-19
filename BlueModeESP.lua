-- ==============================================
-- BLUE MODE HUB | FINAL FULL VERSION
-- NO TYPOS | CORRECT Z-ORDER | REDZ HUB STYLE
-- BACKGROUND: rbxassetid://85473171152747
-- YOUTUBE: https://youtube.com/@blue_mode?si=kCM2t8MILYWQzQzw
-- ==============================================
if getgenv().BlueModeHub then return end
getgenv().BlueModeHub = true

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local SoundService = game:GetService("SoundService")

-- SETTINGS
local BG_ASSET = "rbxassetid://85473171152747"
local YT_LINK = "https://youtube.com/@blue_mode?si=kCM2t8MILYWQzQzw"
local hue = 0
local vol = 500
local currentSound = nil
local rainbowObjs = {}
local friendDots = {}
local espEnabled = false
local minimized = false
local dragActive, dragStartPos, frameStartPos
local tabs = { Main = true, Music = false, Console = false }

-- ==============================================
-- RAINBOW OUTLINE SYSTEM
-- ==============================================
local function addRainbow(obj, isText)
    if not obj then return end
    if isText then
        table.insert(rainbowObjs, {Type = "Text", Obj = obj})
    else
        local stroke = Instance.new("UIStroke")
        stroke.Thickness = 3
        stroke.LineJoinMode = Enum.LineJoinMode.Round
        stroke.Parent = obj
        table.insert(rainbowObjs, {Type = "Stroke", Obj = stroke})
    end
    Instance.new("UICorner", obj).CornerRadius = UDim.new(0, 8)
    return obj
end

-- ==============================================
-- FRIEND RAINBOW DOT + PLAYER OUTLINE ESP
-- ==============================================
local function updateESP()
    if not espEnabled then
        for _, v in pairs(friendDots) do if v then v:Destroy() end end
        table.clear(friendDots)
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= Players.LocalPlayer and p.Character then
                local hl = p.Character:FindFirstChildOfClass("Highlight")
                if hl then hl:Destroy() end
            end
        end
        return
    end

    for _, p in pairs(Players:GetPlayers()) do
        if p == Players.LocalPlayer then continue end
        local char = p.Character
        if not char then continue end
        local head = char:FindFirstChild("Head")
        local hum = char:FindFirstChild("Humanoid")
        if not head or not hum or hum.Health <= 0 then
            if friendDots[p.UserId] then friendDots[p.UserId]:Destroy() friendDots[p.UserId] = nil end
            local hl = char:FindFirstChildOfClass("Highlight")
            if hl then hl:Destroy() end
            continue
        end

        -- Rainbow Outline for All Players
        local hl = char:FindFirstChildOfClass("Highlight") or Instance.new("Highlight", char)
        hl.Name = "BlueMode_ESP"
        hl.FillTransparency = 1
        hl.OutlineTransparency = 0
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

        -- Rainbow Dot for Friends
        local isFriend = pcall(function() return Players.LocalPlayer:IsFriendsWith(p.UserId) end)
        if isFriend then
            if not friendDots[p.UserId] then
                local dot = Instance.new("BillboardGui")
                dot.Name = "BlueMode_FriendDot"
                dot.AlwaysOnTop = true
                dot.Size = UDim2.new(0, 20, 0, 20)
                dot.StudsOffset = Vector3.new(0, 3.5, 0)
                dot.Adornee = head
                dot.Parent = CoreGui
                local circ = Instance.new("Frame", dot)
                circ.Size = UDim2.new(1, 0, 1, 0)
                circ.BackgroundColor3 = Color3.new(1, 0, 0)
                Instance.new("UICorner", circ).CornerRadius = UDim.new(1, 0)
                friendDots[p.UserId] = circ
            end
        else
            if friendDots[p.UserId] then friendDots[p.UserId]:Destroy() friendDots[p.UserId] = nil end
        end
    end
end

-- ==============================================
-- MAIN GUI | CORRECT Z-ORDER (ABOVE GAME, NOT SETTINGS)
-- ==============================================
local Gui = Instance.new("ScreenGui")
Gui.Name = "BlueModeHub"
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.DisplayOrder = 100 -- ✅ HIGH ENOUGH TO BE ABOVE GAME, NOT ABOVE ROBLOX MENU
Gui.IgnoreGuiInset = true
Gui.ResetOnSpawn = false
Gui.Enabled = true
Gui.Parent = CoreGui

-- MAIN WINDOW
local MainWin = Instance.new("Frame")
MainWin.Size = UDim2.new(0, 750, 0, 550)
MainWin.Position = UDim2.new(0.5, -375, 0.5, -275)
MainWin.BackgroundColor3 = Color3.fromRGB(18, 20, 28)
MainWin.Active = true
MainWin.ClipsDescendants = true
MainWin.Visible = true
MainWin.Parent = Gui
addRainbow(MainWin)

-- CUSTOM BACKGROUND
local HubBG = Instance.new("ImageLabel")
HubBG.Size = UDim2.new(1, 0, 1, 0)
HubBG.Position = UDim2.new(0, 0, 0, 0)
HubBG.BackgroundTransparency = 0.15
HubBG.Image = BG_ASSET
HubBG.ScaleType = Enum.ScaleType.Fill
HubBG.ZIndex = -1
HubBG.Parent = MainWin

-- TOP DRAG BAR
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, -80, 0, 45)
TopBar.Position = UDim2.new(0, 10, 0, 10)
TopBar.BackgroundColor3 = Color3.fromRGB(28, 30, 42)
TopBar.Active = true
TopBar.Parent = MainWin
addRainbow(TopBar)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Position = UDim2.new(0.5, -100, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "BLUE MODE HUB"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 26
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Parent = TopBar
addRainbow(Title, true)

-- MINIMIZE + CLOSE BUTTONS
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 35, 0, 35)
MinBtn.Position = UDim2.new(1, -75, 0, 5)
MinBtn.BackgroundColor3 = Color3.fromRGB(38, 40, 58)
MinBtn.Text = "⬇"
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 20
MinBtn.TextColor3 = Color3.new(1, 1, 1)
MinBtn.Parent = TopBar
addRainbow(MinBtn)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -38, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(160, 25, 25)
CloseBtn.Text = "✕"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 22
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Parent = TopBar
addRainbow(CloseBtn)

-- SEARCH BAR
local SearchBar = Instance.new("TextBox")
SearchBar.Size = UDim2.new(1, -20, 0, 40)
SearchBar.Position = UDim2.new(0, 10, 0, 65)
SearchBar.BackgroundColor3 = Color3.fromRGB(22, 24, 36)
SearchBar.PlaceholderText = "🔍 Search Features..."
SearchBar.Font = Enum.Font.Gotham
SearchBar.TextSize = 18
SearchBar.TextColor3 = Color3.new(1, 1, 1)
SearchBar.ClearTextOnFocus = false
SearchBar.Parent = MainWin
addRainbow(SearchBar)

-- TAB BUTTONS CONTAINER
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(0, 180, 1, -120)
TabContainer.Position = UDim2.new(0, 10, 0, 115)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = MainWin

local function CreateTabButton(name, posY)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 50)
    Btn.Position = UDim2.new(0, 0, 0, posY)
    Btn.BackgroundColor3 = name == "Main" and Color3.fromRGB(35, 70, 140) or Color3.fromRGB(28, 30, 42)
    Btn.Text = name
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 22
    Btn.TextColor3 = Color3.new(1, 1, 1)
    Btn.Parent = TabContainer
    addRainbow(Btn)
    return Btn
end

local Tab_Main = CreateTabButton("Main", 0)
local Tab_Music = CreateTabButton("Music", 60)
local Tab_Console = CreateTabButton("Console", 120)

-- CONTENT PANEL
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -210, 1, -120)
Content.Position = UDim2.new(0, 200, 0, 115)
Content.BackgroundColor3 = Color3.fromRGB(22, 24, 36)
Content.ClipsDescendants = true
Content.Parent = MainWin
addRainbow(Content)

-- ==============================================
-- MAIN TAB
-- ==============================================
local MainTab = Instance.new("Frame")
MainTab.Size = UDim2.new(1, 0, 1, 0)
MainTab.BackgroundTransparency = 1
MainTab.Visible = true
MainTab.Parent = Content

local function MakeMainButton(text, posY, color)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -20, 0, 55)
    Btn.Position = UDim2.new(0, 10, 0, posY)
    Btn.BackgroundColor3 = color
    Btn.Text = text
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 24
    Btn.TextColor3 = Color3.new(1, 1, 1)
    Btn.Parent = MainTab
    addRainbow(Btn)
    return Btn
end

local LinkBtn = MakeMainButton("🔗 LINK YOUTUBE", 10, Color3.fromRGB(170, 35, 35))
local ESPBtn = MakeMainButton("👁️ ESP: OFF", 75, Color3.fromRGB(35, 37, 55))
local DelBtn = MakeMainButton("🗑️ DELETE / EXIT", 140, Color3.fromRGB(160, 25, 25))

-- ==============================================
-- MUSIC TAB
-- ==============================================
local MusicTab = Instance.new("Frame")
MusicTab.Size = UDim2.new(1, 0, 1, 0)
MusicTab.BackgroundTransparency = 1
MusicTab.Visible = false
MusicTab.Parent = Content

local IDBox = Instance.new("TextBox")
IDBox.Size = UDim2.new(1, -20, 0, 70)
IDBox.Position = UDim2.new(0, 10, 0, 10)
IDBox.BackgroundColor3 = Color3.fromRGB(12, 14, 25)
IDBox.PlaceholderText = "🎵 Paste Sound ID / Boombox ID"
IDBox.Font = Enum.Font.Gotham
IDBox.TextSize = 22
IDBox.TextColor3 = Color3.new(1, 1, 1)
IDBox.Parent = MusicTab
addRainbow(IDBox)

local VolLabel = Instance.new("TextLabel")
VolLabel.Size = UDim2.new(0, 150, 0, 30)
VolLabel.Position = UDim2.new(0, 10, 0, 90)
VolLabel.BackgroundTransparency = 1
VolLabel.Text = "🔊 VOLUME: "..vol.."/1000"
VolLabel.Font = Enum.Font.GothamBold
VolLabel.TextSize = 20
VolLabel.TextColor3 = Color3.new(1, 1, 1)
VolLabel.Parent = MusicTab
addRainbow(VolLabel, true)

local VolSlider = Instance.new("Frame")
VolSlider.Size = UDim2.new(1, -20, 0, 35)
VolSlider.Position = UDim2.new(0, 10, 0, 125)
VolSlider.BackgroundColor3 = Color3.fromRGB(28, 30, 42)
VolSlider.Parent = MusicTab
addRainbow(VolSlider)

local VolFill = Instance.new("Frame")
VolFill.Size = UDim2.new(vol/1000, 0, 1, 0)
VolFill.BackgroundColor3 = Color3.fromHSV(0, 1, 1)
VolFill.Parent = VolSlider
Instance.new("UICorner", VolFill).CornerRadius = UDim.new(0, 15)

local PlayBtn = Instance.new("TextButton")
PlayBtn.Size = UDim2.new(0, 200, 0, 60)
PlayBtn.Position = UDim2.new(0, 10, 0, 175)
PlayBtn.BackgroundColor3 = Color3.fromRGB(25, 80, 160)
PlayBtn.Text = "▶ PLAY"
PlayBtn.Font = Enum.Font.GothamBold
PlayBtn.TextSize = 26
PlayBtn.TextColor3 = Color3.new(1, 1, 1)
PlayBtn.Parent = MusicTab
addRainbow(PlayBtn)

local StopBtn = Instance.new("TextButton")
StopBtn.Size = UDim2.new(0, 200, 0, 60)
StopBtn.Position = UDim2.new(0, 220, 0, 175)
StopBtn.BackgroundColor3 = Color3.fromRGB(170, 25, 25)
StopBtn.Text = "⏹ STOP"
StopBtn.Font = Enum.Font.GothamBold
StopBtn.TextSize = 26
StopBtn.TextColor3 = Color3.new(1, 1, 1)
StopBtn.Parent = MusicTab
addRainbow(StopBtn)

local ClearMusicBtn = Instance.new("TextButton")
ClearMusicBtn.Size = UDim2.new(1, -20, 0, 60)
ClearMusicBtn.Position = UDim2.new(0, 10, 0, 245)
ClearMusicBtn.BackgroundColor3 = Color3.fromRGB(45, 47, 65)
ClearMusicBtn.Text = "🗑️ CLEAR ID"
ClearMusicBtn.Font = Enum.Font.GothamBold
ClearMusicBtn.TextSize = 26
ClearMusicBtn.TextColor3 = Color3.new(1, 1, 1)
ClearMusicBtn.Parent = MusicTab
addRainbow(ClearMusicBtn)

-- ==============================================
-- CONSOLE TAB
-- ==============================================
local ConsoleTab = Instance.new("Frame")
ConsoleTab.Size = UDim2.new(1, 0, 1, 0)
ConsoleTab.BackgroundTransparency = 1
ConsoleTab.Visible = false
ConsoleTab.Parent = Content

local ScriptBox = Instance.new("TextBox")
ScriptBox.Size = UDim2.new(1, -20, 0, 180)
ScriptBox.Position = UDim2.new(0, 10, 0, 10)
ScriptBox.BackgroundColor3 = Color3.fromRGB(12, 14, 25)
ScriptBox.PlaceholderText = "📜 Paste Script / Loadstring Here"
ScriptBox.Font = Enum.Font.Code
ScriptBox.TextSize = 14
ScriptBox.TextColor3 = Color3.new(1, 1, 1)
ScriptBox.MultiLine = true
ScriptBox.ClearTextOnFocus = false
ScriptBox.Parent = ConsoleTab
addRainbow(ScriptBox)

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, -20, 0, 40)
Status.Position = UDim2.new(0, 10, 0, 200)
Status.BackgroundColor3 = Color3.fromRGB(18, 20, 32)
Status.Text = "[READY] Paste code then click EXECUTE"
Status.Font = Enum.Font.Code
Status.TextSize = 13
Status.TextColor3 = Color3.new(0.3, 1, 0.4)
Status.Parent = ConsoleTab
addRainbow(Status)

local ExecBtn = Instance.new("TextButton")
ExecBtn.Size = UDim2.new(0, 180, 0, 55)
ExecBtn.Position = UDim2.new(0, 10, 0, 255)
ExecBtn.BackgroundColor3 = Color3.fromRGB(15, 110, 35)
ExecBtn.Text = "▶ EXECUTE"
ExecBtn.Font = Enum.Font.GothamBold
ExecBtn.TextSize = 24
ExecBtn.TextColor3 = Color3.new(1, 1, 1)
ExecBtn.Parent = ConsoleTab
addRainbow(ExecBtn)

local ClearConBtn = Instance.new("TextButton")
ClearConBtn.Size = UDim2.new(0, 180, 0, 55)
ClearConBtn.Position = UDim2.new(0, 200, 0, 255)
ClearConBtn.BackgroundColor3 = Color3.fromRGB(110, 35, 35)
ClearConBtn.Text = "🗑️ CLEAR"
ClearConBtn.Font = Enum.Font.GothamBold
ClearConBtn.TextSize = 24
ClearConBtn.TextColor3 = Color3.new(1, 1, 1)
ClearConBtn.Parent = ConsoleTab
addRainbow(ClearConBtn)

-- ==============================================
-- DRAG & MINIMIZE
-- ==============================================
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragActive = true
        dragStartPos = UIS:GetMouseLocation()
        frameStartPos = MainWin.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragActive and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = UIS:GetMouseLocation() - dragStartPos
        MainWin.Position = UDim2.new(
            frameStartPos.X.Scale, frameStartPos.X.Offset + delta.X,
            frameStartPos.Y.Scale, frameStartPos.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function() dragActive = false end)

MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    MainWin.Visible = not minimized
    MinBtn.Text = minimized and "⬆" or "⬇"
end)

CloseBtn.MouseButton1Click:Connect(function()
    if currentSound then currentSound:Destroy() end
    for _, v in pairs(friendDots) do if v then v.Parent:Destroy() end end
    Gui:Destroy()
    getgenv().BlueModeHub = nil
end)

-- ==============================================
-- TAB SWITCHING
-- ==============================================
local function SwitchTab(tabName)
    tabs.Main = tabName == "Main"
    tabs.Music = tabName == "Music"
    tabs.Console = tabName == "Console"

    Tab_Main.BackgroundColor3 = tabs.Main and Color3.fromRGB(35, 70, 140) or Color3.fromRGB(28, 30, 42)
    Tab_Music.BackgroundColor3 = tabs.Music and Color3.fromRGB(35, 70, 140) or Color3.fromRGB(28, 30, 42)
    Tab_Console.BackgroundColor3 = tabs.Console and Color3.fromRGB(35, 70, 140) or Color3.fromRGB(28, 30, 42)

    MainTab.Visible = tabs.Main
    MusicTab.Visible = tabs.Music
    ConsoleTab.Visible = tabs.Console
end

Tab_Main.MouseButton1Click:Connect(function() SwitchTab("Main") end)
Tab_Music.MouseButton1Click:Connect(function() SwitchTab("Music") end)
Tab_Console.MouseButton1Click:Connect(function() SwitchTab("Console") end)

-- ==============================================
-- BUTTON FUNCTIONS
-- ==============================================
LinkBtn.MouseButton1Click:Connect(function()
    setclipboard(YT_LINK)
    LinkBtn.Text = "✅ LINK COPIED!"
    task.wait(1.5)
    LinkBtn.Text = "🔗 LINK YOUTUBE"
end)

ESPBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    ESPBtn.Text = espEnabled and "👁️ ESP: ON" or "👁️ ESP: OFF"
    ESPBtn.BackgroundColor3 = espEnabled and Color3.fromRGB(30, 140, 70) or Color3.fromRGB(35, 37, 55)
    updateESP()
end)

DelBtn.MouseButton1Click:Connect(function()
    if currentSound then currentSound:Destroy() end
    for _, v in pairs(friendDots) do if v then v.Parent:Destroy() end end
    Gui:Destroy()
    getgenv().BlueModeHub = nil
end)

-- MUSIC FUNCTIONS
PlayBtn.MouseButton1Click:Connect(function()
    local id = IDBox.Text:gsub("%D", "")
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

ClearMusicBtn.MouseButton1Click:Connect(function() IDBox.Text = "" end)

-- VOLUME SLIDER
local volDrag = false
VolSlider.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        volDrag = true
    end
end)

UIS.InputChanged:Connect(function(input)
    if volDrag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local pos = math.clamp((input.Position.X - VolSlider.AbsolutePosition.X) / VolSlider.AbsoluteSize.X, 0, 1)
        vol = math.floor(pos * 999) + 1
        VolFill.Size = UDim2.new(pos, 0, 1, 0)
        VolLabel.Text = "🔊 VOLUME: "..vol.."/1000"
        if currentSound then currentSound.Volume = vol / 1000 end
    end
end)

UIS.InputEnded:Connect(function() volDrag = false end)

-- CONSOLE FUNCTIONS
ExecBtn.MouseButton1Click:Connect(function()
    local code = ScriptBox.Text:gsub("^%s+", ""):gsub("%s+$", "")
    if code == "" then
        Status.TextColor3 = Color3.new(1, 0.3, 0.3)
        Status.Text = "[ERROR] No code entered!"
        return
    end
    local func, err = loadstring(code)
    if not func then
        Status.TextColor3 = Color3.new(1, 0.3, 0.3)
        Status.Text = "[SYNTAX ERROR] "..tostring(err)
        return
    end
    local success, runErr = pcall(func)
    if success then
        Status.TextColor3 = Color3.new(0.3, 1, 0.4)
        Status.Text = "[SUCCESS] Script executed!"
    else
        Status.TextColor3 = Color3.new(1, 0.3, 0.3)
        Status.Text = "[RUNTIME ERROR] "..tostring(runErr)
    end
end)

ClearConBtn.MouseButton1Click:Connect(function()
    ScriptBox.Text = ""
    Status.Text = "[CLEARED] Ready for new code"
    Status.TextColor3 = Color3.new(1, 1, 1)
end)

-- ==============================================
-- RAINBOW ANIMATION LOOP
-- ==============================================
RunService.Heartbeat:Connect(function(dt)
    hue = (hue + dt * 0.5) % 1
    local color = Color3.fromHSV(hue, 1, 1)

    -- Update all rainbow elements
    for _, item in pairs(rainbowObjs) do
        if item.Type == "Stroke" and item.Obj then item.Obj.Color = color end
        if item.Type == "Text" and item.Obj then item.Obj.TextColor3 = color end
    end

    VolFill.BackgroundColor3 = color

    -- Update friend dots
    for _, dot in pairs(friendDots) do
        if dot then dot.BackgroundColor3 = color end
    end

    -- Update ESP outlines
    if espEnabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= Players.LocalPlayer and p.Character then
                local hl = p.Character:FindFirstChildOfClass("Highlight")
                if hl then hl.OutlineColor = color end
            end
        end
    end

    updateESP()
end)

print("✅ BLUE MODE HUB | FULLY LOADED | NO TYPOS | CORRECT LAYER ORDER!")
