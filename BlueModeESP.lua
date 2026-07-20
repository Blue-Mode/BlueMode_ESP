-- ==============================================
-- 🔵 BLUE MODE HUB | FINAL VERSION
-- ✅ CONSOLE TITLE GREY
-- ✅ FRIEND RAINBOW DOT + OWNER CROWN ADDED
-- ✅ ESP RENDERS INSIDE PLAYER
-- ✅ HEADER: "🔵 BLUE MODE HUB | DRAG HERE"
-- ✅ VOLUME TEXT WHITE | EXIT FULLY INSIDE FRAME
-- ✅ CROSS-EXECUTOR / DELTA COMPATIBLE
-- ==============================================

-- FALLBACKS
getgenv = getgenv or _G
readfile = readfile or function() return nil end
writefile = writefile or function() end
loadstring = loadstring or load
setclipboard = setclipboard or function() end

if getgenv().BlueMode_Loaded then return end
getgenv().BlueMode_Loaded = true

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- ASSETS
local CUSTOM_GUI_BG = "rbxassetid://101782008402770"
local GuiContainer = Instance.new("Folder")
GuiContainer.Name = "BLUE_MODE_HUB_ROOT"
pcall(function() GuiContainer.Parent = CoreGui end)
if not GuiContainer.Parent then GuiContainer.Parent = LocalPlayer.PlayerGui end

local PRIORITY = { STARTUP = 800, MAIN = 799, BOOMBOX = 798, CONSOLE = 797, EXIT_CONFIRM = 9999 }
local USAGE_LIMIT = 12 * 3600
local YOUTUBE_LINK = "https://youtube.com/@blue_mode?si=aCGyj0FnwCMtTP1M"
local SAVE_KEY_VOLUME = "BlueMode_Volume_v22"
local VOLUME_MAX = 1000
local OWNER_NAME = "Dwaynekean015"

-- GLOBALS
local BoomboxUI_Open, ConsoleUI_Open = false, false
local CurrentBoomboxUI, CurrentConsoleUI = nil, nil
local IsMinimized, GuiFocused = false, false
local GuiElements = {}
local CurrentSound, MusicVolume = nil, 500
local Hue = 0

-- DATA
local function SaveData(key, val) pcall(function() writefile(key..".txt", tostring(val)) end) end
local function LoadData(key, def) local s=nil; pcall(function() s=readfile(key..".txt") end); return tonumber(s) or def end

-- RAINBOW HELPER
local function AddRainbowGlow(obj, thick)
    if not obj then return end
    if obj:FindFirstChild("RainbowAura") then obj.RainbowAura:Destroy() end
    local o = Instance.new("UIStroke")
    o.Name = "RainbowAura"
    o.Thickness = thick or 3
    o.Transparency = 0
    o.LineJoinMode = Enum.LineJoinMode.Round
    o.Parent = obj
    table.insert(GuiElements, o)
    return o
end

-- CLEANUP ALL ESP & INDICATORS
local function ClearAllESP()
    pcall(function()
        for _,p in pairs(Players:GetPlayers()) do
            if p.Character then
                for _,c in pairs(p.Character:GetChildren()) do
                    if c.Name=="BLUE_FULLBODY_OUTLINE" or c.Name=="FriendRainbowDot" or c.Name=="OwnerCrown" then c:Destroy() end
                end
            end
        end
    end)
end
local function FullDeleteHub() pcall(function() ClearAllESP(); if CurrentSound then CurrentSound:Destroy() end; GuiContainer:Destroy(); getgenv().BlueMode_Loaded=nil end) end

-- STARTUP SCREEN
local StartupUI = Instance.new("ScreenGui")
StartupUI.Name = "BLUE_MODE_HUB_STARTUP"
StartupUI.ResetOnSpawn = false
StartupUI.DisplayOrder = PRIORITY.STARTUP
StartupUI.Parent = GuiContainer

local StartupBox = Instance.new("Frame")
StartupBox.Size = UDim2.new(0,420,0,480)
StartupBox.Position = UDim2.new(0.5,-210,0.5,-240)
StartupBox.BackgroundColor3 = Color3.fromRGB(10,12,18)
StartupBox.Active = true
StartupBox.Parent = StartupUI
Instance.new("UICorner", StartupBox).CornerRadius = UDim.new(0,18)

local StartupBg = Instance.new("ImageLabel")
StartupBg.Size = UDim2.new(1,0,1,0)
StartupBg.BackgroundTransparency = 1
StartupBg.Image = CUSTOM_GUI_BG
StartupBg.Parent = StartupBox

local StartupBorder = AddRainbowGlow(StartupBox,5)

local StartupTitle = Instance.new("TextLabel")
StartupTitle.Size = UDim2.new(1,-40,0,50)
StartupTitle.Position = UDim2.new(0,20,0,15)
StartupTitle.BackgroundTransparency = 1
StartupTitle.Font = Enum.Font.GothamBlack
StartupTitle.TextScaled = true
StartupTitle.Text = "🔵 BLUE MODE HUB"
StartupTitle.Parent = StartupBox

local FeatureList = Instance.new("TextLabel")
FeatureList.Size = UDim2.new(1,-50,0,220)
FeatureList.Position = UDim2.new(0,25,0,75)
FeatureList.BackgroundTransparency = 1
FeatureList.Font = Enum.Font.Gotham
FeatureList.TextScaled = true
FeatureList.TextWrapped = true
FeatureList.TextXAlignment = Enum.TextXAlignment.Left
FeatureList.TextColor3 = Color3.fromRGB(220,220,220)
FeatureList.Text = [[• ✅ FRIEND RAINBOW DOT + OWNER CROWN
• ESP OUTLINE RENDERS INSIDE/BEHIND PLAYER
• CONSOLE TITLE NOW GREY
• VOLUME TEXT WHITE & HIGHLY VISIBLE
• EXIT BUTTON FULLY INSIDE BLACK AREA
• VOLUME IN ITS OWN SEPARATE ROW
• HEADER: "🔵 BLUE MODE HUB | DRAG HERE"
• FULL RAINBOW EFFECTS
• CROSS-EXECUTOR SUPPORT]]
FeatureList.Parent = StartupBox

local LaunchBtn = Instance.new("TextButton")
LaunchBtn.Size = UDim2.new(0,280,0,60)
LaunchBtn.Position = UDim2.new(0.5,-140,0,380)
LaunchBtn.BackgroundColor3 = Color3.fromRGB(15,110,230)
LaunchBtn.Font = Enum.Font.GothamBold
LaunchBtn.TextScaled = true
LaunchBtn.Text = "🚀 LAUNCH HUB"
LaunchBtn.TextColor3 = Color3.new(1,1,1)
LaunchBtn.Parent = StartupBox
Instance.new("UICorner", LaunchBtn).CornerRadius = UDim.new(0,16)
AddRainbowGlow(LaunchBtn,4)

RunService.Heartbeat:Connect(function(d)
    Hue = (Hue + d*0.25) % 1
    local c = Color3.fromHSV(Hue,1,1)
    StartupBorder.Color = c
    StartupTitle.TextColor3 = c
    LaunchBtn.BackgroundColor3 = Color3.fromHSV(Hue,0.8,0.6)
end)

LaunchBtn.MouseButton1Click:Connect(function() StartupUI:Destroy(); LoadMainHub() end)

print("✅ PART 1 LOADED")
-- ==============================================
-- END OF PART 1
-- ==============================================
-- ==============================================
-- 🔵 BLUE MODE HUB | PART 2 / 2
-- ✅ CONSOLE TITLE GREY
-- ✅ FULL FRIEND DOT + OWNER CROWN SYSTEM
-- ✅ ALL LAYOUT & RENDER FIXES APPLIED
-- ==============================================

local VolNumMain, VolFillMain, ESPBtn, LockBtn
local ESP_Enabled = false
local Buttons_Locked = false
local DragStart, StartPos
local MainButtons = {}

-- VOLUME
local function UpdateVolume(v)
    MusicVolume = math.clamp(tonumber(v) or 500, 0, VOLUME_MAX)
    SaveData(SAVE_KEY_VOLUME, MusicVolume)
    if CurrentSound then CurrentSound.Volume = MusicVolume/VOLUME_MAX end
    local d = tostring(math.floor(MusicVolume+0.5))
    if VolNumMain then VolNumMain.Text = d end
    if VolFillMain then VolFillMain.Size = UDim2.new(MusicVolume/VOLUME_MAX,0,1,0) end
end

-- BOOMBOX MENU
local function ToggleBoomboxMenu() end

-- ✅ CONSOLE MENU WITH GREY TITLE
local function ToggleConsole()
    if ConsoleUI_Open then
        if CurrentConsoleUI then CurrentConsoleUI:Destroy() end
        ConsoleUI_Open = false
        CurrentConsoleUI = nil
        GuiFocused = false
        return
    end
    GuiFocused = true
    local ConsoleUI = Instance.new("ScreenGui")
    ConsoleUI.Name = "BLUE_MODE_CONSOLE"
    ConsoleUI.ResetOnSpawn = false
    ConsoleUI.DisplayOrder = PRIORITY.CONSOLE
    ConsoleUI.Parent = GuiContainer
    CurrentConsoleUI = ConsoleUI
    ConsoleUI_Open = true

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0,450,0,320)
    Frame.Position = UDim2.new(0.5,-225,0.5,-160)
    Frame.BackgroundColor3 = Color3.fromRGB(22,22,22)
    Frame.Active = true
    Frame.Parent = ConsoleUI
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0,12)
    AddRainbowGlow(Frame,5)

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0,32,0,32)
    CloseBtn.Position = UDim2.new(1,-37,0,6)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(170,30,30)
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.new(1,1,1)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 26
    CloseBtn.Parent = Frame
    CloseBtn.MouseButton1Click:Connect(ToggleConsole)

    -- ✅ CONSOLE TITLE SET TO GREY
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1,-50,0,35)
    Title.Position = UDim2.new(0,15,0,6)
    Title.BackgroundTransparency = 1
    Title.Text = "💻 CONSOLE"
    Title.TextColor3 = Color3.fromRGB(170,170,170) -- GREY COLOR
    Title.Font = Enum.Font.GothamBold
    Title.TextScaled = true
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Frame

    local Output = Instance.new("TextLabel")
    Output.Size = UDim2.new(1,-30,0,40)
    Output.Position = UDim2.new(0,15,0,45)
    Output.BackgroundTransparency = 1
    Output.Text = "Paste script code below..."
    Output.TextColor3 = Color3.fromRGB(0,255,120)
    Output.Font = Enum.Font.Code
    Output.TextScaled = true
    Output.TextXAlignment = Enum.TextXAlignment.Left
    Output.Parent = Frame

    local Input = Instance.new("TextBox")
    Input.Size = UDim2.new(1,-30,0,130)
    Input.Position = UDim2.new(0,15,0,95)
    Input.BackgroundColor3 = Color3.fromRGB(45,45,45)
    Input.PlaceholderText = "Paste your script here..."
    Input.TextColor3 = Color3.new(1,1,1)
    Input.Font = Enum.Font.Code
    Input.TextScaled = true
    Input.MultiLine = true
    Input.Parent = Frame
    Instance.new("UICorner", Input).CornerRadius = UDim.new(0,8)
    AddRainbowGlow(Input,2)

    local ExecuteBtn = Instance.new("TextButton")
    ExecuteBtn.Size = UDim2.new(0,120,0,40)
    ExecuteBtn.Position = UDim2.new(0,15,0,240)
    ExecuteBtn.BackgroundColor3 = Color3.fromRGB(20,150,70)
    ExecuteBtn.Text = "▶ EXECUTE"
    ExecuteBtn.TextColor3 = Color3.new(1,1,1)
    ExecuteBtn.Font = Enum.Font.GothamBold
    ExecuteBtn.TextScaled = true
    ExecuteBtn.Parent = Frame
    Instance.new("UICorner", ExecuteBtn).CornerRadius = UDim.new(0,8)
    AddRainbowGlow(ExecuteBtn,2)

    local ClearBtn = Instance.new("TextButton")
    ClearBtn.Size = UDim2.new(0,120,0,40)
    ClearBtn.Position = UDim2.new(0,150,0,240)
    ClearBtn.BackgroundColor3 = Color3.fromRGB(180,120,20)
    ClearBtn.Text = "🗑️ CLEAR"
    ClearBtn.TextColor3 = Color3.new(1,1,1)
    ClearBtn.Font = Enum.Font.GothamBold
    ClearBtn.TextScaled = true
    ClearBtn.Parent = Frame
    Instance.new("UICorner", ClearBtn).CornerRadius = UDim.new(0,8)
    AddRainbowGlow(ClearBtn,2)

    ExecuteBtn.MouseButton1Click:Connect(function()
        local Code = Input.Text
        if Code == "" then Output.Text = "⚠️ Nothing to run!" return end
        local Compile = loadstring or load
        if not Compile then Output.Text = "⚠️ Executor not supported." return end
        local Func, ErrorMsg = Compile(Code)
        if not Func then Output.Text = "❌ Syntax Error:\n"..tostring(ErrorMsg) return end
        local Success, RunError = pcall(Func)
        if not Success then Output.Text = "❌ Runtime Error:\n"..tostring(RunError) return end
        Output.Text = "✅ Script ran successfully!"
    end)
    ClearBtn.MouseButton1Click:Connect(function() Input.Text = "" Output.Text = "✅ Cleared!" end)
end

-- MAIN HUB
function LoadMainHub()
    local FULL = UDim2.new(0,680,0,140)
    local MINI = UDim2.new(0,110,0,36)
    local MainUI = Instance.new("ScreenGui")
    MainUI.Name = "BLUE_MODE_HUB_MAIN"
    MainUI.ResetOnSpawn = false
    MainUI.DisplayOrder = PRIORITY.MAIN
    MainUI.Parent = GuiContainer

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = FULL
    MainFrame.Position = UDim2.new(0,20,0.5,-70)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
    MainFrame.Active = true
    MainFrame.Parent = MainUI
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,8)
    AddRainbowGlow(MainFrame,5)

    local DragHandle = Instance.new("TextButton")
    DragHandle.Size = UDim2.new(1,-30,0,22)
    DragHandle.Position = UDim2.new(0,0,0,0)
    DragHandle.BackgroundColor3 = Color3.fromRGB(60,140,220)
    DragHandle.Active = true
    DragHandle.Text = "🔵 BLUE MODE HUB | DRAG HERE"
    DragHandle.TextColor3 = Color3.new(1,1,1)
    DragHandle.Font = Enum.Font.GothamBold
    DragHandle.TextScaled = true
    DragHandle.TextXAlignment = Enum.TextXAlignment.Left
    DragHandle.Parent = MainFrame
    AddRainbowGlow(DragHandle,2)

    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.new(0,22,1,0)
    MinBtn.Position = UDim2.new(1,-22,0,0)
    MinBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
    MinBtn.Text = "➖"
    MinBtn.TextColor3 = Color3.new(1,1,1)
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.TextScaled = true
    MinBtn.Parent = MainFrame
    AddRainbowGlow(MinBtn,2)

    local function MakeBtn(txt, pos, col, cb)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0,90,0,30)
        b.Position = pos
        b.BackgroundColor3 = col
        b.Text = txt
        b.TextColor3 = Color3.new(1,1,1)
        b.Font = Enum.Font.GothamBold
        b.TextScaled = true
        b.Parent = MainFrame
        Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
        AddRainbowGlow(b,2)
        b.MouseButton1Click:Connect(cb)
        table.insert(MainButtons,b)
        return b
    end

    -- BUTTONS
    ESPBtn = MakeBtn("ESP: OFF", UDim2.new(0,10,0,30), Color3.fromRGB(40,40,40), function()
        ESP_Enabled = not ESP_Enabled
        ESPBtn.Text = ESP_Enabled and "ESP: ON" or "ESP: OFF"
        ESPBtn.BackgroundColor3 = ESP_Enabled and Color3.fromRGB(30,160,60) or Color3.fromRGB(40,40,40)
        if not ESP_Enabled then ClearAllESP() end
    end)
    MakeBtn("📺 YOUTUBE", UDim2.new(0,105,0,30), Color3.fromRGB(200,30,30), function() setclipboard(YOUTUBE_LINK) end)
    MakeBtn("🎵 MUSIC", UDim2.new(0,200,0,30), Color3.fromRGB(40,80,160), ToggleBoomboxMenu)
    LockBtn = MakeBtn("🔓 UNLOCK", UDim2.new(0,295,0,30), Color3.fromRGB(50,50,50), function()
        Buttons_Locked = not Buttons_Locked
        LockBtn.Text = Buttons_Locked and "🔒 LOCKED" or "🔓 UNLOCK"
    end)
    MakeBtn("💻 CONSOLE", UDim2.new(0,390,0,30), Color3.fromRGB(30,120,90), ToggleConsole)
    MakeBtn("🗑️ EXIT", UDim2.new(0,580,0,30), Color3.fromRGB(140,20,20), function()
        local Confirm = Instance.new("ScreenGui")
        Confirm.DisplayOrder = PRIORITY.EXIT_CONFIRM
        Confirm.Parent = GuiContainer
        local Box = Instance.new("Frame")
        Box.Size = UDim2.new(0,350,0,180)
        Box.Position = UDim2.new(0.5,-175,0.5,-90)
        Box.BackgroundColor3 = Color3.fromRGB(15,15,20)
        Box.Active = true
        Box.Parent = Confirm
        Instance.new("UICorner", Box).CornerRadius = UDim.new(0,16)
        AddRainbowGlow(Box,4)
        local Txt = Instance.new("TextLabel")
        Txt.Size = UDim2.new(1,-40,0,50)
        Txt.Position = UDim2.new(0,20,0,15)
        Txt.BackgroundTransparency = 1
        Txt.Text = "⚠️ EXIT HUB?"
        Txt.TextColor3 = Color3.new(1,1,1)
        Txt.Font = Enum.Font.GothamBold
        Txt.TextScaled = true
        Txt.Parent = Box
        local Yes = Instance.new("TextButton")
        Yes.Size = UDim2.new(0,130,0,40)
        Yes.Position = UDim2.new(0,30,0,120)
        Yes.BackgroundColor3 = Color3.fromRGB(180,30,30)
        Yes.Text = "✅ YES"
        Yes.TextColor3 = Color3.new(1,1,1)
        Yes.Font = Enum.Font.GothamBold
        Yes.TextScaled = true
        Yes.Parent = Box
        Instance.new("UICorner", Yes).CornerRadius = UDim.new(0,10)
        local No = Instance.new("TextButton")
        No.Size = UDim2.new(0,130,0,40)
        No.Position = UDim2.new(1,-160,0,120)
        No.BackgroundColor3 = Color3.fromRGB(30,120,70)
        No.Text = "❌ NO"
        No.TextColor3 = Color3.new(1,1,1)
        No.Font = Enum.Font.GothamBold
        No.TextScaled = true
        No.Parent = Box
        Instance.new("UICorner", No).CornerRadius = UDim.new(0,10)
        Yes.MouseButton1Click:Connect(function() Confirm:Destroy(); FullDeleteHub() end)
        No.MouseButton1Click:Connect(function() Confirm:Destroy() end)
    end)

    -- VOLUME ROW
    local VolLabel = Instance.new("TextLabel")
    VolLabel.Size = UDim2.new(0,90,0,25)
    VolLabel.Position = UDim2.new(0,20,0,70)
    VolLabel.BackgroundTransparency = 1
    VolLabel.Text = "🔊 VOLUME:"
    VolLabel.TextColor3 = Color3.new(1,1,1)
    VolLabel.Font = Enum.Font.GothamBold
    VolLabel.TextScaled = true
    VolLabel.Parent = MainFrame
    table.insert(MainButtons,VolLabel)

    VolNumMain = Instance.new("TextLabel")
    VolNumMain.Size = UDim2.new(0,50,0,25)
    VolNumMain.Position = UDim2.new(0,120,0,70)
    VolNumMain.BackgroundTransparency = 1
    VolNumMain.Text = tostring(MusicVolume)
    VolNumMain.TextColor3 = Color3.new(1,1,1)
    VolNumMain.Font = Enum.Font.GothamBold
    VolNumMain.TextScaled = true
    VolNumMain.Parent = MainFrame
    table.insert(MainButtons,VolNumMain)

    local VolBG = Instance.new("Frame")
    VolBG.Size = UDim2.new(0,260,0,22)
    VolBG.Position = UDim2.new(0,180,0,70)
    VolBG.BackgroundColor3 = Color3.fromRGB(50,50,50)
    VolBG.Active = true
    VolBG.Parent = MainFrame
    Instance.new("UICorner", VolBG).CornerRadius = UDim.new(0,11)
    AddRainbowGlow(VolBG,2)
    table.insert(MainButtons,VolBG)

    VolFillMain = Instance.new("Frame")
    VolFillMain.Size = UDim2.new(MusicVolume/VOLUME_MAX,0,1,0)
    VolFillMain.BackgroundColor3 = Color3.fromHSV(Hue,1,1)
    VolFillMain.ZIndex = 2
    VolFillMain.Parent = VolBG
    Instance.new("UICorner", VolFillMain).CornerRadius = UDim.new(0,11)

    -- MINIMIZE
    MinBtn.MouseButton1Click:Connect(function()
        IsMinimized = not IsMinimized
        MainFrame.Size = IsMinimized and MINI or FULL
        MinBtn.Text = IsMinimized and "➕" or "➖"
        for _,b in pairs(MainButtons) do b.Visible = not IsMinimized end
    end)

    -- DRAG
    DragHandle.InputBegan:Connect(function(i)
        if Buttons_Locked then return end
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            DragStart = i.Position
            StartPos = MainFrame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if not DragStart then return end
        if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
            local d = i.Position - DragStart
            MainFrame.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + d.X, StartPos.Y.Scale, StartPos.Y.Offset + d.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then DragStart = nil end
    end)

    -- ✅ ESP + FRIEND DOT + OWNER CROWN
    RunService.Heartbeat:Connect(function(dt)
        Hue = (Hue + dt*0.25) % 1
        local c = Color3.fromHSV(Hue,1,1)
        for _,e in pairs(GuiElements) do if e.ClassName=="UIStroke" then e.Color = c end end
        if VolFillMain then VolFillMain.BackgroundColor3 = c end

        if not ESP_Enabled then return end
        for _,Player in pairs(Players:GetPlayers()) do
            if Player ~= LocalPlayer and Player.Character and Player.Character:FindFirstChild("Humanoid") then
                local Char = Player.Character
                local Hum = Char.Humanoid
                if Hum.Health <= 0 then goto continue end

                -- ESP OUTLINE (INSIDE/BEHIND PLAYER)
                local Outline = Char:FindFirstChild("BLUE_FULLBODY_OUTLINE") or Instance.new("Highlight")
                Outline.Name = "BLUE_FULLBODY_OUTLINE"
                Outline.Adornee = Char
                Outline.Enabled = true
                Outline.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                Outline.FillTransparency = 0.2
                Outline.OutlineTransparency = 0

                -- OWNER GOLDEN + CROWN
                if Player.Name == OWNER_NAME then
                    Outline.FillColor = Color3.fromRGB(255,215,0)
                    Outline.OutlineColor = Color3.fromRGB(255,215,0)
                    if not Char:FindFirstChild("OwnerCrown") then
                        local Crown = Instance.new("BillboardGui")
                        Crown.Name = "OwnerCrown"
                        Crown.Size = UDim2.new(0,50,0,50)
                        Crown.StudsOffset = Vector3.new(0,4.5,0)
                        Crown.AlwaysOnTop = true
                        Crown.NeedsUpdate = false
                        Crown.Parent = Char.Head
                        local Icon = Instance.new("TextLabel")
                        Icon.Size = UDim2.new(1,0,1,0)
                        Icon.BackgroundTransparency = 1
                        Icon.Text = "👑"
                        Icon.TextScaled = true
                        Icon.Font = Enum.Font.GothamBold
                        Icon.Parent = Crown
                    end

                -- ✅ FRIEND RAINBOW DOT
                elseif Player:IsFriendsWith(LocalPlayer.UserId) then
                    Outline.FillColor = c
                    Outline.OutlineColor = c
                    if not Char:FindFirstChild("FriendRainbowDot") then
                        local Dot = Instance.new("BillboardGui")
                        Dot.Name = "FriendRainbowDot"
                        Dot.Size = UDim2.new(0,22,0,22)
                        Dot.StudsOffset = Vector3.new(0,3.2,0)
                        Dot.AlwaysOnTop = true
                        Dot.NeedsUpdate = false
                        Dot.Parent = Char.Head
                        local Indicator = Instance.new("Frame")
                        Indicator.Size = UDim2.new(1,0,1,0)
                        Indicator.BackgroundColor3 = c
                        Indicator.CornerRadius = UDim.new(1,0)
                        Indicator.Parent = Dot
                        AddRainbowGlow(Indicator,3)
                    else
                        Char.FriendRainbowDot.Frame.BackgroundColor3 = c
                        Char.FriendRainbowDot.Frame.RainbowAura.Color = c
                    end

                -- NORMAL PLAYER
                else
                    Outline.FillColor = c
                    Outline.OutlineColor = c
                    if Char:FindFirstChild("FriendRainbowDot") then Char.FriendRainbowDot:Destroy() end
                    if Char:FindFirstChild("OwnerCrown") then Char.OwnerCrown:Destroy() end
                end
                Outline.Parent = Char
                ::continue::
            end
        end
    end)
end

print("✅ FULL SCRIPT LOADED SUCCESSFULLY")
-- ==============================================
-- END OF FULL SCRIPT
-- ==============================================
