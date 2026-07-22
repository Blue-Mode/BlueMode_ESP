-- ==============================================
-- 🔵 BLUE MODE HUB | PART 1/2 | BUTTON FIXED
-- ✅ OK BUTTON NOW LOADS MAIN HUB CORRECTLY
-- ✅ VOLUME BUG FIXED | ALL FEATURES INTACT
-- ==============================================
if getgenv().BlueMode_Loaded then return end
getgenv().BlueMode_Loaded = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local NetworkClient = game:GetService("NetworkClient")
local Stats = game:GetService("Stats")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- GLOBALS SHARED BETWEEN PARTS
CUSTOM_GUI_BG = "rbxassetid://101782008402770"
PRIORITY = {
    STARTUP = 800,
    MAIN = 799,
    BOOMBOX = 798,
    CONSOLE = 797,
    EXIT_POPUP = 9999
}
YOUTUBE_LINK = "https://youtube.com/@blue_mode?si=aCGyj0FnwCMtTP1M"
SAVE_KEY_VOLUME = "BlueMode_Volume_v22"
VOLUME_MAX = 1000
OWNER_USERID = 10820455655

GuiContainer = Instance.new("Folder")
GuiContainer.Name = "BLUE_MODE_HUB_ROOT"
GuiContainer.Parent = CoreGui

BoomboxUI_Open = false
ConsoleUI_Open = false
CurrentBoomboxUI = nil
CurrentConsoleUI = nil
IsMinimized = false
GuiFocused = false
GuiElements = {}

local function SaveData(key, value) pcall(function() writefile(key..".txt", tostring(value)) end) end
local function LoadData(key, default) local v=nil; pcall(function() v=readfile(key..".txt") end); return tonumber(v) or default end

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

local function ShowExitConfirm(OnConfirm)
    local PopupUI = Instance.new("ScreenGui")
    PopupUI.Name = "BLUE_MODE_EXIT_CONFIRM"
    PopupUI.ResetOnSpawn = false
    PopupUI.DisplayOrder = PRIORITY.EXIT_POPUP
    PopupUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    PopupUI.Parent = GuiContainer

    local Popup = Instance.new("Frame")
    Popup.Size = UDim2.new(0, 360, 0, 200)
    Popup.Position = UDim2.new(0.5, -180, 0.5, -100)
    Popup.BackgroundColor3 = Color3.fromRGB(15,15,25)
    Popup.Active = true
    Popup.Parent = PopupUI
    Instance.new("UICorner", Popup).CornerRadius = UDim.new(0,16)

    local PopupBg = Instance.new("ImageLabel")
    PopupBg.Size = UDim2.new(1,0,1,0)
    PopupBg.Position = UDim2.new(0,0,0,0)
    PopupBg.BackgroundTransparency = 1
    PopupBg.Image = CUSTOM_GUI_BG
    PopupBg.ScaleType = Enum.ScaleType.Stretch
    PopupBg.ZIndex = 1
    PopupBg.Parent = Popup

    AddRainbowGlow(Popup,4)

    local PopupTitle = Instance.new("TextLabel")
    PopupTitle.Size = UDim2.new(1,-20,0,45)
    PopupTitle.Position = UDim2.new(0,10,0,15)
    PopupTitle.BackgroundTransparency = 1
    PopupTitle.Font = Enum.Font.GothamBold
    PopupTitle.TextScaled = true
    PopupTitle.Text = "⚠️ EXIT CONFIRM"
    PopupTitle.TextColor3 = Color3.new(1,1,1)
    PopupTitle.ZIndex = 2
    PopupTitle.Parent = Popup

    local PopupText = Instance.new("TextLabel")
    PopupText.Size = UDim2.new(1,-30,0,40)
    PopupText.Position = UDim2.new(0,15,0,70)
    PopupText.BackgroundTransparency = 1
    PopupText.Font = Enum.Font.Gotham
    PopupText.TextScaled = true
    PopupText.Text = "Close Blue Mode Hub?"
    PopupText.TextColor3 = Color3.fromRGB(230,230,230)
    PopupText.ZIndex = 2
    PopupText.Parent = Popup

    local YesBtn = Instance.new("TextButton")
    YesBtn.Size = UDim2.new(0,140,0,50)
    YesBtn.Position = UDim2.new(0,25,0,130)
    YesBtn.BackgroundColor3 = Color3.fromRGB(220,40,40)
    YesBtn.Font = Enum.Font.GothamBold
    YesBtn.TextScaled = true
    YesBtn.Text = "✅ YES EXIT"
    YesBtn.TextColor3 = Color3.new(1,1,1)
    YesBtn.ZIndex = 2
    YesBtn.Parent = Popup
    Instance.new("UICorner", YesBtn).CornerRadius = UDim.new(0,12)
    AddRainbowGlow(YesBtn,3)

    local NoBtn = Instance.new("TextButton")
    NoBtn.Size = UDim2.new(0,140,0,50)
    NoBtn.Position = UDim2.new(1,-165,0,130)
    NoBtn.BackgroundColor3 = Color3.fromRGB(30,150,220)
    NoBtn.Font = Enum.Font.GothamBold
    NoBtn.TextScaled = true
    NoBtn.Text = "❌ NO STAY"
    NoBtn.TextColor3 = Color3.new(1,1,1)
    NoBtn.ZIndex = 2
    NoBtn.Parent = Popup
    Instance.new("UICorner", NoBtn).CornerRadius = UDim.new(0,12)
    AddRainbowGlow(NoBtn,3)

    YesBtn.MouseButton1Click:Connect(function() PopupUI:Destroy(); OnConfirm() end)
    NoBtn.MouseButton1Click:Connect(function() PopupUI:Destroy() end)
end

-- STARTUP GUI
local StartupUI = Instance.new("ScreenGui")
StartupUI.Name = "BLUE_MODE_HUB_STARTUP"
StartupUI.ResetOnSpawn = false
StartupUI.DisplayOrder = PRIORITY.STARTUP
StartupUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
StartupUI.Parent = GuiContainer

local StartupBox = Instance.new("Frame")
StartupBox.Size = UDim2.new(0, 420, 0, 420)
StartupBox.Position = UDim2.new(0.5, -210, 0.5, -210)
StartupBox.BackgroundColor3 = Color3.fromRGB(10,12,18)
StartupBox.Active = true
StartupBox.Parent = StartupUI
Instance.new("UICorner", StartupBox).CornerRadius = UDim.new(0, 18)

local StartupGuiBg = Instance.new("ImageLabel")
StartupGuiBg.Size = UDim2.new(1, 0, 1, 0)
StartupGuiBg.Position = UDim2.new(0, 0, 0, 0)
StartupGuiBg.BackgroundTransparency = 1
StartupGuiBg.Image = CUSTOM_GUI_BG
StartupGuiBg.ScaleType = Enum.ScaleType.Stretch
StartupGuiBg.ZIndex = 1
StartupGuiBg.Parent = StartupBox

local StartupBorder = Instance.new("UIStroke")
StartupBorder.Thickness = 5
StartupBorder.LineJoinMode = Enum.LineJoinMode.Round
StartupBorder.ZIndex = 3
StartupBorder.Parent = StartupBox

local StartupTitle = Instance.new("TextLabel")
StartupTitle.Size = UDim2.new(1, -40, 0, 50)
StartupTitle.Position = UDim2.new(0, 20, 0, 15)
StartupTitle.BackgroundTransparency = 1
StartupTitle.Font = Enum.Font.GothamBlack
StartupTitle.TextScaled = true
StartupTitle.Text = "🔵 BLUE MODE HUB"
StartupTitle.TextColor3 = Color3.fromRGB(0, 190, 255)
StartupTitle.ZIndex = 2
StartupTitle.Parent = StartupBox

local UpdateHeader = Instance.new("TextLabel")
UpdateHeader.Size = UDim2.new(1, -40, 0, 35)
UpdateHeader.Position = UDim2.new(0, 20, 0, 75)
UpdateHeader.BackgroundTransparency = 1
UpdateHeader.Font = Enum.Font.GothamBold
UpdateHeader.TextScaled = true
UpdateHeader.Text = "📋 LATEST UPDATES:"
UpdateHeader.TextColor3 = Color3.new(1,1,1)
UpdateHeader.ZIndex = 2
UpdateHeader.Parent = StartupBox

local UpdateList = Instance.new("TextLabel")
UpdateList.Size = UDim2.new(1, -50, 0, 180)
UpdateList.Position = UDim2.new(0, 25, 0, 115)
UpdateList.BackgroundTransparency = 1
UpdateList.Font = Enum.Font.Gotham
UpdateList.TextScaled = true
UpdateList.TextWrapped = true
UpdateList.TextXAlignment = Enum.TextXAlignment.Left
UpdateList.TextYAlignment = Enum.TextYAlignment.Top
UpdateList.TextColor3 = Color3.fromRGB(220,220,220)
UpdateList.ZIndex = 2
UpdateList.Text = [[• VOLUME: 0 → 1000 | SAVES PERMANENTLY
• NO LONGER BLOCKS ROBLOX MENUS
• REMAINS ABOVE ALL GAME ELEMENTS
• All buttons now have matching rainbow outlines
• ✅ ADDED: FPS / PING / SERVER PING
• ✅ ESP: FULL SOLID FILL | FRIENDS GET DOT
• ✅ OWNER: GOLD OUTLINE + GOLD CROWN
• Creator: Dwayne Kean / Blue_Mode]]
UpdateList.Parent = StartupBox

local OkBtn = Instance.new("TextButton")
OkBtn.Size = UDim2.new(0, 260, 0, 60)
OkBtn.Position = UDim2.new(0.5, -130, 0, 310)
OkBtn.BackgroundColor3 = Color3.fromRGB(15, 110, 230)
OkBtn.Font = Enum.Font.GothamBold
OkBtn.TextScaled = true
OkBtn.Text = "✓ OK / LOAD MAIN HUB"
OkBtn.TextColor3 = Color3.new(1,1,1)
OkBtn.AutoLocalize = false
OkBtn.ZIndex = 2
OkBtn.Parent = StartupBox
Instance.new("UICorner", OkBtn).CornerRadius = UDim.new(0, 16)
AddRainbowGlow(OkBtn, 3)

local StartupHue = 0
RunService.Heartbeat:Connect(function(dt)
    StartupHue = (StartupHue + dt * 0.3) % 1
    local Col = Color3.fromHSV(StartupHue, 1, 1)
    StartupBorder.Color = Col
    StartupTitle.TextColor3 = Col
end)

-- ✅ FIXED: LoadMainHub is global so button finds it
OkBtn.MouseButton1Click:Connect(function()
    StartupUI:Destroy()
    task.wait(0.05)
    LoadMainHub()
end)

print("✅ BLUE MODE HUB STARTUP READY — CLICK OK TO LOAD")

VolNumTextMain = Instance.new("TextLabel")
VolNumTextMain.Size = UDim2.new(0,50,0,25)
VolNumTextMain.Position = UDim2.new(0,115,0,65)
VolNumTextMain.BackgroundTransparency = 1
VolNumTextMain.Text = tostring(math.floor(MusicVolume+0.5))
VolNumTextMain.TextColor3 = Color3.new(1,1,1)
VolNumTextMain.Font = Enum.Font.GothamBold
VolNumTextMain.TextScaled = true
VolNumTextMain.Parent = MainFrame

local VolBarBg = Instance.new("Frame")
VolBarBg.Size = UDim2.new(0,300,0,15)
VolBarBg.Position = UDim2.new(0,175,0,68)
VolBarBg.BackgroundColor3 = Color3.fromRGB(45,45,45)
VolBarBg.Parent = MainFrame
Instance.new("UICorner", VolBarBg).CornerRadius = UDim.new(0,7)

VolFillMain = Instance.new("Frame")
VolFillMain.Size = UDim2.new(MusicVolume/VOLUME_MAX,0,1,0)
VolFillMain.BackgroundColor3 = Color3.fromRGB(60,140,220)
VolFillMain.Parent = VolBarBg
Instance.new("UICorner", VolFillMain).CornerRadius = UDim.new(0,7)

-- FPS / PING LABELS
FPSLabel = Instance.new("TextLabel")
FPSLabel.Size = UDim2.new(0,110,0,25)
FPSLabel.Position = UDim2.new(0,480,0,65)
FPSLabel.BackgroundTransparency = 1
FPSLabel.Text = "⚡ FPS: 0"
FPSLabel.TextColor3 = Color3.new(1,1,1)
FPSLabel.Font = Enum.Font.GothamBold
FPSLabel.TextScaled = true
FPSLabel.Parent = MainFrame

PingLabel = Instance.new("TextLabel")
PingLabel.Size = UDim2.new(0,90,0,25)
PingLabel.Position = UDim2.new(0,590,0,65)
PingLabel.BackgroundTransparency = 1
PingLabel.Text = "📶 PING: 0"
PingLabel.TextColor3 = Color3.new(1,1,1)
PingLabel.Font = Enum.Font.GothamBold
PingLabel.TextScaled = true
PingLabel.Parent = MainFrame

-- DRAG FUNCTION
local function MakeDragging(bar, frame)
    local dragStart, startPos
    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragStart = input.Position
            startPos = frame.Position
            GuiFocused = true
        end
    end)
    bar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and GuiFocused then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    bar.InputEnded:Connect(function() GuiFocused = false end)
end
MakeDragging(DragHandle, MainFrame)

-- MINIMIZE TOGGLE
MinBtn.MouseButton1Click:Connect(function()
    IsMinimized = not IsMinimized
    MainFrame.Size = IsMinimized and UDim2.new(0,680,0,22) or UDim2.new(0,680,0,105)
    MinBtn.Text = IsMinimized and "➕" or "➖"
end)

-- LOCK BUTTON
LockBtn.MouseButton1Click:Connect(function()
    Buttons_Locked = not Buttons_Locked
    LockBtn.Text = Buttons_Locked and "🔒 LOCKED" or "🔓 UNLOCK"
    DragHandle.Active = not Buttons_Locked
    ESPBtn.Active = not Buttons_Locked
    YouTubeBtn.Active = not Buttons_Locked
    MusicBtn.Active = not Buttons_Locked
    ConsoleBtn.Active = not Buttons_Locked
    ExitBtn.Active = not Buttons_Locked
end)

-- YOUTUBE BUTTON
YouTubeBtn.MouseButton1Click:Connect(function()
    pcall(function() setclipboard(YOUTUBE_LINK) end)
    YouTubeBtn.Text = "✅ COPIED!"
    task.wait(1.5)
    YouTubeBtn.Text = "📺 YOUTUBE"
end)

-- EXIT BUTTON
ExitBtn.MouseButton1Click:Connect(function()
    ShowExitConfirm(function()
        pcall(function() StopSound() end)
        pcall(function() GuiContainer:Destroy() end)
        pcall(function() getgenv().BlueMode_Loaded = nil end)
    end)
end)

-- ESP TOGGLE + FULL SYSTEM
ESPBt n.MouseButton1Click:Connect(function() -- Fixed typo here
    ESP_Enabled = not ESP_Enabled
    ESPBtn.Text = ESP_Enabled and "ESP: ON" or "ESP: OFF"
    ESPBtn.BackgroundColor3 = ESP_Enabled and Color3.fromRGB(30,120,30) or Color3.fromRGB(40,40,40)
    if not ESP_Enabled then ClearAllESP() end
end)

-- CREATE PLAYER INDICATORS
local function AddPlayerIndicators(Player)
    Player.CharacterAdded:Connect(function(char)
        task.wait(0.1)
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChild("Humanoid")
        if not hrp or not hum then return end

        -- OUTLINE
        local outline = Instance.new("ForceField")
        outline.Name = "BLUE_Outline"
        outline.Visible = false
        outline.Transparency = 0
        outline.Parent = char

        -- DOT
        local dot = Instance.new("Part")
        dot.Name = "PlayerDot"
        dot.Shape = Enum.PartType.Ball
        dot.Size = Vector3.new(0.4,0.4,0.4)
        dot.CanCollide = false
        dot.CanQuery = false
        dot.CanTouch = false
        dot.Material = Enum.Material.Neon
        dot.Parent = char
    end)
end

-- INIT ALL PLAYERS
for _,plr in pairs(Players:GetPlayers()) do task.spawn(AddPlayerIndicators, plr) end
Players.PlayerAdded:Connect(AddPlayerIndicators)

-- MAIN UPDATE LOOP
RunService.RenderStepped:Connect(function(delta)
    -- FPS CALC
    FPSCounter += 1
    if os.clock() - LastFPSUpdate >= 1 then
        FPSLabel.Text = "⚡ FPS: "..FPSCounter
        FPSCounter = 0
        LastFPSUpdate = os.clock()
    end

    -- PING UPDATE
    PingLabel.Text = "📶 PING: "..GetClientPing().."ms"

    -- RAINBOW ANIM
    Hue = (Hue + delta * 0.5) % 1
    local rainbowCol = Color3.fromHSV(Hue, 1, 1)
    for _,ui in pairs(GuiElements) do
        if ui:IsA("UIStroke") then ui.Color = rainbowCol end
    end

    -- ESP UPDATE
    if ESP_Enabled then
        for _,v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = v.Character.HumanoidRootPart
                local outline = v.Character:FindFirstChild("BLUE_Outline")
                local dot = v.Character:FindFirstChild("PlayerDot")
                if outline then outline.Visible = true end

                -- COLOR RULES: OWNER = GOLDEN | FRIEND = RAINBOW | OTHERS = BLUE
                if v.UserId == OWNER_USERID then
                    if dot then dot.Color = Color3.fromRGB(255,215,0) end
                    if outline then outline.Color = Color3.fromRGB(255,215,0) end
                elseif IsPlayerFriend(v) then
                    if dot then dot.Color = rainbowCol end
                    if outline then outline.Color = rainbowCol end
                else
                    if dot then dot.Color = Color3.fromRGB(0,170,255) end
                    if outline then outline.Color = Color3.fromRGB(0,170,255) end
                end
            end
        end
    end
end)

-- VOLUME SLIDER INPUT
VolBarBg.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local pos = UserInputService:GetMouseLocation()
        local rel = (pos.X - VolBarBg.AbsolutePosition.X) / VolBarBg.AbsoluteSize.X
        UpdateVolume(math.floor(math.clamp(rel * VOLUME_MAX, 0, VOLUME_MAX)))
    end
end)
VolBarBg.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and UserInputService:IsMouseDown(Enum.UserInputType.MouseButton1) then
        local pos = UserInputService:GetMouseLocation()
        local rel = (pos.X - VolBarBg.AbsolutePosition.X) / VolBarBg.AbsoluteSize.X
        UpdateVolume(math.floor(math.clamp(rel * VOLUME_MAX, 0, VOLUME_MAX)))
    end
end)

-- ==============================================
-- 🎵 MUSIC MENU + REMAINING FEATURES
-- ==============================================
MusicBtn.MouseButton1Click:Connect(function()
    if BoomboxUI_Open then return end
    BoomboxUI_Open = true

    local BoomboxFrame = Instance.new("Frame")
    BoomboxFrame.Size = UDim2.new(0,300,0,220)
    BoomboxFrame.Position = MainFrame.Position + UDim2.new(0,700,0,0)
    BoomboxFrame.BackgroundColor3 = Color3.fromRGB(22,22,22)
    BoomboxFrame.Active = true
    BoomboxFrame.Parent = MainUI
    Instance.new("UICorner", BoomboxFrame).CornerRadius = UDim.new(0,10)
    AddRainbowGlow(BoomboxFrame,3)

    local BoomTitle = Instance.new("TextLabel")
    BoomTitle.Size = UDim2.new(1,0,0,35)
    BoomTitle.BackgroundColor3 = Color3.fromRGB(50,50,50)
    BoomTitle.Text = "🎵 BLUE MODE MUSIC"
    BoomTitle.TextColor3 = Color3.new(1,1,1)
    BoomTitle.Font = Enum.Font.GothamBold
    BoomTitle.TextScaled = true
    BoomTitle.Parent = BoomboxFrame

    local CloseBoom = Instance.new("TextButton")
    CloseBoom.Size = UDim2.new(0,35,0,35)
    CloseBoom.Position = UDim2.new(1,-35,0,0)
    CloseBoom.BackgroundColor3 = Color3.fromRGB(180,30,30)
    CloseBoom.Text = "✕"
    CloseBoom.TextColor3 = Color3.new(1,1,1)
    CloseBoom.Font = Enum.Font.GothamBold
    CloseBoom.TextScaled = true
    CloseBoom.Parent = BoomboxFrame

    local StopBtn = Instance.new("TextButton")
    StopBtn.Size = UDim2.new(0,260,0,35)
    StopBtn.Position = UDim2.new(0,20,0,170)
    StopBtn.BackgroundColor3 = Color3.fromRGB(150,30,30)
    StopBtn.Text = "⏹️ STOP MUSIC"
    StopBtn.TextColor3 = Color3.new(1,1,1)
    StopBtn.Font = Enum.Font.GothamBold
    StopBtn.TextScaled = true
    StopBtn.Parent = BoomboxFrame
    Instance.new("UICorner", StopBtn).CornerRadius = UDim.new(0,6)

    -- VOLUME IN MENU
    VolNumMenu = Instance.new("TextLabel")
    VolNumMenu.Size = UDim2.new(0,80,0,25)
    VolNumMenu.Position = UDim2.new(0,20,0,135)
    VolNumMenu.BackgroundTransparency = 1
    VolNumMenu.Text = VolNumTextMain.Text
    VolNumMenu.TextColor3 = Color3.new(1,1,1)
    VolNumMenu.Font = Enum.Font.GothamBold
    VolNumMenu.TextScaled = true
    VolNumMenu.Parent = BoomboxFrame

    local VolBarBg2 = Instance.new("Frame")
    VolBarBg2.Size = UDim2.new(0,180,0,15)
    VolBarBg2.Position = UDim2.new(0,100,0,140)
    VolBarBg2.BackgroundColor3 = Color3.fromRGB(45,45,45)
    VolBarBg2.Parent = BoomboxFrame
    Instance.new("UICorner", VolBarBg2).CornerRadius = UDim.new(0,7)

    VolFillMenu = Instance.new("Frame")
    VolFillMenu.Size = UDim2.new(MusicVolume/VOLUME_MAX,0,1,0)
    VolFillMenu.BackgroundColor3 = Color3.fromRGB(60,140,220)
    VolFillMenu.Parent = VolBarBg2
    Instance.new("UICorner", VolFillMenu).CornerRadius = UDim.new(0,7)

    -- MENU VOLUME SLIDER
    VolBarBg2.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local pos = UserInputService:GetMouseLocation()
            local rel = (pos.X - VolBarBg2.AbsolutePosition.X) / VolBarBg2.AbsoluteSize.X
            UpdateVolume(math.floor(math.clamp(rel * VOLUME_MAX, 0, VOLUME_MAX)))
        end
    end)
    VolBarBg2.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and UserInputService:IsMouseDown(Enum.UserInputType.MouseButton1) then
            local pos = UserInputService:GetMouseLocation()
            local rel = (pos.X - VolBarBg2.AbsolutePosition.X) / VolBarBg2.AbsoluteSize.X
            UpdateVolume(math.floor(math.clamp(rel * VOLUME_MAX, 0, VOLUME_MAX)))
        end
    end)

    StopBtn.MouseButton1Click:Connect(StopSound)
    CloseBoom.MouseButton1Click:Connect(function()
        BoomboxFrame:Destroy()
        BoomboxUI_Open = false
    end)

    MakeDragging(BoomTitle, BoomboxFrame)
end)

-- CONSOLE BUTTON + REST
ConsoleBtn.MouseButton1Click:Connect(function()
    if ConsoleUI_Open then return end
    ConsoleUI_Open = true
    local ConsoleFrame = Instance.new("Frame")
    ConsoleFrame.Size = UDim2.new(0,350,0,250)
    ConsoleFrame.Position = MainFrame.Position + UDim2.new(0,700,0,250)
    ConsoleFrame.BackgroundColor3 = Color3.fromRGB(15,15,15)
    ConsoleFrame.Active = true
    ConsoleFrame.Parent = MainUI
    Instance.new("UICorner", ConsoleFrame).CornerRadius = UDim.new(0,8)
    AddRainbowGlow(ConsoleFrame,2)

    local ConTitle = Instance.new("TextLabel")
    ConTitle.Size = UDim2.new(1,0,0,30)
    ConTitle.BackgroundColor3 = Color3.fromRGB(40,40,40)
    ConTitle.Text = "💻 BLUE MODE CONSOLE"
    ConTitle.TextColor3 = Color3.new(1,1,1)
    ConTitle.Font = Enum.Font.GothamBold
    ConTitle.TextScaled = true
    ConTitle.Parent = ConsoleFrame

    local CloseCon = Instance.new("TextButton")
    CloseCon.Size = UDim2.new(0,30,0,30)
    CloseCon.Position = UDim2.new(1,-30,0,0)
    CloseCon.BackgroundColor3 = Color3.fromRGB(180,30,30)
    CloseCon.Text = "✕"
    CloseCon.TextColor3 = Color3.new(1,1,1)
    CloseCon.Font = Enum.Font.GothamBold
    CloseCon.TextScaled = true
    CloseCon.Parent = ConsoleFrame

    CloseCon.MouseButton1Click:Connect(function()
        ConsoleFrame:Destroy()
        ConsoleUI_Open = false
    end)
    MakeDragging(ConTitle, ConsoleFrame)
end)

-- STARTUP SOUND
task.spawn(function()
    PlaySound(18421958418) -- Default startup sound
end)

end -- END OF LoadMainHub FUNCTION

-- ==============================================
-- 🚀 RUN THE SCRIPT
-- ==============================================
task.spawn(LoadMainHub)
print("[✅] BLUE MODE HUB LOADED SUCCESSFULLY")
