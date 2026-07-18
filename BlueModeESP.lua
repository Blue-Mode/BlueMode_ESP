-- ==============================================
-- 🔵 BLUE MODE ESP | PART 1/2
-- ==============================================
if getgenv().BlueMode_Loaded then return end
getgenv().BlueMode_Loaded = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- LAYER ORDER
local GuiContainer = Instance.new("Folder")
GuiContainer.Name = "BLUE_MODE_GUI_ROOT"
GuiContainer.Parent = CoreGui

local PRIORITY = {
    STARTUP = 100,
    MAIN = 99,
    BOOMBOX = 98,
    CONSOLE = 97,
    COMMAND = 96
}

-- SETTINGS
local USAGE_LIMIT = 12 * 3600
local YOUTUBE_LINK = "https://youtube.com/@blue_mode?si=aCGyj0FnwCMtTP1M"
local SAVE_KEY_USED = "BlueMode_UsedTime_v20"
local SAVE_KEY_COOLDOWN = "BlueMode_CooldownEnd_v20"
local SAVE_KEY_VOLUME = "BlueMode_Volume_v20"
local VOLUME_MAX = 1000

-- GLOBAL STATES
local BoomboxUI_Open = false
local ConsoleUI_Open = false
local CommandUI_Open = false
local CommandListUI_Open = false
local CurrentBoomboxUI, CurrentConsoleUI, CurrentCommandUI, CurrentCommandListUI
local IsMinimized = false
local GuiFocused = false
local ESP_Enabled = false
local Buttons_Locked = false
local StartupUI, MainUI, ESPBtn, LockBtn, MinBtn
local MusicVolume = 500
local CurrentSound = nil
local VolNumTextMain, VolFillMain, VolFillMenu, VolNumMenu
local GuiElements = {}
local Hue = 0
local PRESET_COMMANDS = {
    {Name = "ESP ON", Desc = "Turn ESP highlights on", Action = function() ESP_Enabled = true; ESPBtn.Text = "ESP: ON"; ESPBtn.BackgroundColor3 = Color3.fromRGB(25,120,25) end},
    {Name = "ESP OFF", Desc = "Turn ESP highlights off", Action = function() ESP_Enabled = false; ClearAllESP(); ESPBtn.Text = "ESP: OFF"; ESPBtn.BackgroundColor3 = Color3.fromRGB(40,40,40) end},
    {Name = "UNLOCK GUI", Desc = "Unlock drag & buttons", Action = function() Buttons_Locked = false; LockBtn.Text = "🔓 UNLOCK"; LockBtn.BackgroundColor3 = Color3.fromRGB(50,50,50) end},
    {Name = "LOCK GUI", Desc = "Lock drag & buttons", Action = function() Buttons_Locked = true; LockBtn.Text = "🔒 LOCKED"; LockBtn.BackgroundColor3 = Color3.fromRGB(180,40,40) end},
    {Name = "VOLUME MAX", Desc = "Set volume to 1000", Action = function() UpdateVolume(1000) end},
    {Name = "VOLUME MUTE", Desc = "Set volume to 0", Action = function() UpdateVolume(0) end},
    {Name = "CLEAR ESP", Desc = "Remove all ESP effects", Action = function() ClearAllESP() end},
    {Name = "MINIMIZE", Desc = "Shrink main menu", Action = function() MinBtn:Fire() end}
}

-- DATA HELPERS
local function SaveData(key, value) pcall(function() writefile(key..".txt", tostring(value)) end) end
local function LoadData(key, default) local v=nil; pcall(function() v=readfile(key..".txt") end); return tonumber(v) or default end

-- AUTO-HIDE ROBLOX MENUS
UserInputService.MenuOpened:Connect(function()
    if StartupUI then StartupUI.Visible = false end
    if MainUI then MainUI.Visible = false end
    if CurrentBoomboxUI then CurrentBoomboxUI.Visible = false end
    if CurrentConsoleUI then CurrentConsoleUI.Visible = false end
    if CurrentCommandUI then CurrentCommandUI.Visible = false end
    if CurrentCommandListUI then CurrentCommandListUI.Visible = false end
end)
UserInputService.MenuClosed:Connect(function()
    if StartupUI then StartupUI.Visible = true end
    if MainUI then MainUI.Visible = true end
    if CurrentBoomboxUI then CurrentBoomboxUI.Visible = true end
    if CurrentConsoleUI then CurrentConsoleUI.Visible = true end
    if CurrentCommandUI then CurrentCommandUI.Visible = true end
    if CurrentCommandListUI then CurrentCommandListUI.Visible = true end
end)

-- SHARED FUNCTIONS
local function ClearAllESP()
    for _,P in pairs(Players:GetPlayers()) do
        if P and P.Character then
            pcall(function()
                if P.Character:FindFirstChild("BLUE_Outline") then P.Character.BLUE_Outline:Destroy() end
                if P.Character:FindFirstChild("FriendRainbowDot") then P.Character.FriendRainbowDot:Destroy() end
            end)
        end
    end
    pcall(function() for _,D in pairs(workspace:GetDescendants()) do if D.Name == "BLUE_Outline" or D.Name == "FriendRainbowDot" then D:Destroy() end end end)
end

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

function UpdateVolume(newVol)
    MusicVolume = math.clamp(tonumber(newVol) or 500, 0, VOLUME_MAX)
    SaveData(SAVE_KEY_VOLUME, MusicVolume)
    if CurrentSound then CurrentSound.Volume = MusicVolume / VOLUME_MAX end
    local Val = tostring(math.floor(MusicVolume + 0.5))
    if VolNumTextMain then VolNumTextMain.Text = Val end
    if VolFillMain then VolFillMain.Size = UDim2.new(MusicVolume/VOLUME_MAX,0,1,0) end
    if VolNumMenu then VolNumMenu.Text = Val end
    if VolFillMenu then VolFillMenu.Size = UDim2.new(MusicVolume/VOLUME_MAX,0,1,0) end
end

local function FormatSoundID(input) return "rbxassetid://"..tostring(input):gsub("%D","") end
local function PlaySound(id)
    pcall(function() if CurrentSound then CurrentSound:Destroy() end end)
    CurrentSound = Instance.new("Sound")
    CurrentSound.Name = "BLUE_BOOMBOX"
    CurrentSound.SoundId = FormatSoundID(id)
    CurrentSound.Volume = MusicVolume / VOLUME_MAX
    CurrentSound.Looped = true
    CurrentSound.Parent = SoundService
    pcall(function() CurrentSound:Play() end)
end

-- STARTUP SCREEN
StartupUI = Instance.new("ScreenGui")
StartupUI.Name = "BLUE_MODE_STARTUP"
StartupUI.ResetOnSpawn = false
StartupUI.DisplayOrder = PRIORITY.STARTUP
StartupUI.Parent = GuiContainer

local StartupBox = Instance.new("Frame")
StartupBox.Size = UDim2.new(0, 420, 0, 480)
StartupBox.Position = UDim2.new(0.5, -210, 0.5, -240)
StartupBox.BackgroundColor3 = Color3.fromRGB(10,12,18)
StartupBox.Active = true
StartupBox.Parent = StartupUI
Instance.new("UICorner", StartupBox).CornerRadius = UDim.new(0, 18)

local StartupBorder = Instance.new("UIStroke")
StartupBorder.Thickness = 5
StartupBorder.Parent = StartupBox

local StartupTitle = Instance.new("TextLabel")
StartupTitle.Size = UDim2.new(1, -40, 0, 50)
StartupTitle.Position = UDim2.new(0, 20, 0, 15)
StartupTitle.BackgroundTransparency = 1
StartupTitle.Font = Enum.Font.GothamBlack
StartupTitle.TextScaled = true
StartupTitle.Text = "🔵 BLUE MODE ESP"
StartupTitle.Parent = StartupBox

local UpdateList = Instance.new("TextLabel")
UpdateList.Size = UDim2.new(1, -50, 0, 220)
UpdateList.Position = UDim2.new(0, 25, 0, 75)
UpdateList.BackgroundTransparency = 1
UpdateList.Font = Enum.Font.Gotham
UpdateList.TextScaled = true
UpdateList.TextWrapped = true
UpdateList.TextXAlignment = Enum.TextXAlignment.Left
UpdateList.TextColor3 = Color3.fromRGB(220,220,220)
UpdateList.Text = [[• ✅ NEW: COMMAND SYSTEM + COMMAND LIST
• ✅ AUTO-HIDE WHEN ESC/SETTINGS IS OPEN
• ✅ NEVER BLOCKS ROBLOX MENUS
• VOLUME: 0 → 1000
• Creator: Dwayne Kean / Blue_Mode]]
UpdateList.Parent = StartupBox

local StartupTimerLabel = Instance.new("TextLabel")
StartupTimerLabel.Size = UDim2.new(1, -40, 0, 45)
StartupTimerLabel.Position = UDim2.new(0, 20, 0, 310)
StartupTimerLabel.BackgroundTransparency = 1
StartupTimerLabel.Font = Enum.Font.GothamBold
StartupTimerLabel.TextScaled = true
StartupTimerLabel.TextColor3 = Color3.fromRGB(80,255,120)
StartupTimerLabel.Parent = StartupBox

local OkBtn = Instance.new("TextButton")
OkBtn.Size = UDim2.new(0, 260, 0, 60)
OkBtn.Position = UDim2.new(0.5, -130, 0, 385)
OkBtn.BackgroundColor3 = Color3.fromRGB(15, 110, 230)
OkBtn.Font = Enum.Font.GothamBold
OkBtn.TextScaled = true
OkBtn.Text = "✓ OK / LOAD MAIN HUB"
OkBtn.TextColor3 = Color3.new(1,1,1)
OkBtn.Parent = StartupBox
Instance.new("UICorner", OkBtn).CornerRadius = UDim.new(0, 16)

local StartupHue = 0
local UsedTime = LoadData(SAVE_KEY_USED, 0)
RunService.Heartbeat:Connect(function(dt)
    StartupHue = (StartupHue + dt * 0.3) % 1
    local Col = Color3.fromHSV(StartupHue, 1, 1)
    StartupBorder.Color = Col
    StartupTitle.TextColor3 = Col
    local Remaining = math.max(0, USAGE_LIMIT - UsedTime)
    local h = math.floor(Remaining/3600)
    local m = math.floor((Remaining%3600)/60)
    local s = Remaining%60
    StartupTimerLabel.Text = string.format("TIME REMAINING: %02d:%02d:%02d", h, m, s)
end)

OkBtn.MouseButton1Click:Connect(function()
    StartupUI:Destroy()
    LoadMainHub()
end)

print("✅ PART 1 LOADED | NOW ADD PART 2")

-- ==============================================
-- 🔵 BLUE MODE ESP | PART 2/2
-- ==============================================
function LoadMainHub()
    local CurrentTime = os.time()
    local CooldownEnd = LoadData(SAVE_KEY_COOLDOWN, 0)
    if CurrentTime < CooldownEnd then
        print("⏳ COOLDOWN! Wait "..math.floor((CooldownEnd-CurrentTime)/60).." mins")
        return
    end

    local LastCheckTime = os.time()
    MusicVolume = LoadData(SAVE_KEY_VOLUME, 500)

    -- DEATH CHECK
    local function SetupDeathCheck()
        local function CheckCharacter(Char)
            if not Char then return end
            local Hum = Char:WaitForChild("Humanoid", 10)
            if not Hum then return end
            Hum.Died:Connect(function()
                if ESP_Enabled then ESP_Enabled = false; ESPBtn.Text = "ESP: OFF"; ESPBtn.BackgroundColor3 = Color3.fromRGB(40,40,40); ClearAllESP() end
            end)
        end
        CheckCharacter(LocalPlayer.Character)
        LocalPlayer.CharacterAdded:Connect(CheckCharacter)
    end

    -- COMMAND SYSTEM
    local function ToggleCommandMenu()
        if CommandUI_Open then CurrentCommandUI:Destroy(); CommandUI_Open = false; GuiFocused = false; return end
        GuiFocused = true
        local CmdUI = Instance.new("ScreenGui")
        CmdUI.Name = "BLUE_COMMAND_MENU"
        CmdUI.ResetOnSpawn = false
        CmdUI.DisplayOrder = PRIORITY.COMMAND
        CmdUI.Parent = GuiContainer
        CurrentCommandUI = CmdUI; CommandUI_Open = true

        local CmdFrame = Instance.new("Frame")
        CmdFrame.Size = UDim2.new(0,400,0,280)
        CmdFrame.Position = UDim2.new(0.5,-200,0.5,-140)
        CmdFrame.BackgroundColor3 = Color3.fromRGB(22,22,22)
        CmdFrame.Active = true
        CmdFrame.Parent = CmdUI
        Instance.new("UICorner", CmdFrame).CornerRadius = UDim.new(0,12)
        AddRainbowGlow(CmdFrame,4)

        local CloseTop = Instance.new("TextButton")
        CloseTop.Size = UDim2.new(0,32,0,32)
        CloseTop.Position = UDim2.new(1,-37,0,6)
        CloseTop.BackgroundColor3 = Color3.fromRGB(170,30,30)
        CloseTop.Text = "✕"; CloseTop.TextColor3 = Color3.new(1,1,1)
        CloseTop.Font = Enum.Font.GothamBold; CloseTop.TextSize = 26
        CloseTop.Parent = CmdFrame
        CloseTop.MouseButton1Click:Connect(function() ToggleCommandMenu() end)

        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1,-50,0,35)
        Title.Position = UDim2.new(0,15,0,6)
        Title.BackgroundTransparency = 1
        Title.Text = "⚡ COMMAND EXECUTOR"
        Title.TextColor3 = Color3.new(1,1,1); Title.Font = Enum.Font.GothamBold
        Title.TextScaled = true; Title.Parent = CmdFrame

        local CmdInput = Instance.new("TextBox")
        CmdInput.Size = UDim2.new(1,-30,0,45)
        CmdInput.Position = UDim2.new(0,15,0,55)
        CmdInput.BackgroundColor3 = Color3.fromRGB(35,35,35)
        CmdInput.PlaceholderText = "Search command or type code..."
        CmdInput.TextColor3 = Color3.new(1,1,1); CmdInput.Font = Enum.Font.Gotham
        CmdInput.TextScaled = true; CmdInput.Parent = CmdFrame
        Instance.new("UICorner", CmdInput).CornerRadius = UDim.new(0,8)
        AddRainbowGlow(CmdInput,2)

        local StatusLabel = Instance.new("TextLabel")
        StatusLabel.Size = UDim2.new(1,-30,0,30)
        StatusLabel.Position = UDim2.new(0,15,0,110)
        StatusLabel.BackgroundTransparency = 1
        StatusLabel.Text = "Ready"; StatusLabel.TextColor3 = Color3.fromRGB(180,180,180)
        StatusLabel.Font = Enum.Font.Gotham; StatusLabel.TextScaled = true; StatusLabel.Parent = CmdFrame

        local RunBtn = Instance.new("TextButton")
        RunBtn.Size = UDim2.new(0,150,0,45)
        RunBtn.Position = UDim2.new(0,15,0,160)
        RunBtn.BackgroundColor3 = Color3.fromRGB(25,140,25)
        RunBtn.Text = "▶ EXECUTE"; RunBtn.TextColor3 = Color3.new(1,1,1)
        RunBtn.Font = Enum.Font.GothamBold; RunBtn.TextScaled = true; RunBtn.Parent = CmdFrame
        Instance.new("UICorner", RunBtn).CornerRadius = UDim.new(0,8)
        AddRainbowGlow(RunBtn,2)

        local ListBtn = Instance.new("TextButton")
        ListBtn.Size = UDim2.new(0,180,0,45)
        ListBtn.Position = UDim2.new(0,170,0,160)
        ListBtn.BackgroundColor3 = Color3.fromRGB(30,100,180)
        ListBtn.Text = "📋 COMMAND LIST"; ListBtn.TextColor3 = Color3.new(1,1,1)
        ListBtn.Font = Enum.Font.GothamBold; ListBtn.TextScaled = true; ListBtn.Parent = CmdFrame
        Instance.new("UICorner", ListBtn).CornerRadius = UDim.new(0,8)
        AddRainbowGlow(ListBtn,2)

        RunBtn.MouseButton1Click:Connect(function()
            local Input = CmdInput.Text:upper()
            local Found = false
            for _,Cmd in pairs(PRESET_COMMANDS) do
                if Cmd.Name:upper() == Input or Cmd.Name:upper():find(Input) then
                    pcall(Cmd.Action)
                    StatusLabel.Text = "✅ Ran: "..Cmd.Name
                    StatusLabel.TextColor3 = Color3.fromRGB(80,255,120)
                    Found = true; break
                end
            end
            if not Found and Input ~= "" then
                local Load = loadstring or load
                if Load then local F,E = Load(CmdInput.Text); if F then pcall(F); StatusLabel.Text = "✅ Custom code ran" end end
            end
            task.wait(2.5); StatusLabel.Text = "Ready"; StatusLabel.TextColor3 = Color3.fromRGB(180,180,180)
        end)
        ListBtn.MouseButton1Click:Connect(ToggleCommandList)
    end

    function ToggleCommandList()
        if CommandListUI_Open then CurrentCommandListUI:Destroy(); CommandListUI_Open = false; return end
        local ListUI = Instance.new("ScreenGui")
        ListUI.Name = "BLUE_COMMAND_LIST"
        ListUI.ResetOnSpawn = false
        ListUI.DisplayOrder = PRIORITY.COMMAND -1
        ListUI.Parent = GuiContainer
        CurrentCommandListUI = ListUI; CommandListUI_Open = true

        local ListFrame = Instance.new("Frame")
        ListFrame.Size = UDim2.new(0,380,0,350)
        ListFrame.Position = UDim2.new(0.5,-190,0.5,-175)
        ListFrame.BackgroundColor3 = Color3.fromRGB(22,22,22)
        ListFrame.Active = true; ListFrame.Parent = ListUI
        Instance.new("UICorner", ListFrame).CornerRadius = UDim.new(0,12)
        AddRainbowGlow(ListFrame,4)

        local CloseBtn = Instance.new("TextButton")
        CloseBtn.Size = UDim2.new(0,32,0,32)
        CloseBtn.Position = UDim2.new(1,-37,0,6)
        CloseBtn.BackgroundColor3 = Color3.fromRGB(170,30,30)
        CloseBtn.Text = "✕"; CloseBtn.Parent = ListFrame
        CloseBtn.MouseButton1Click:Connect(ToggleCommandList)

        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1,-50,0,35)
        Title.Position = UDim2.new(0,15,0,6)
        Title.BackgroundTransparency = 1
        Title.Text = "📋 ALL COMMANDS"; Title.TextColor3 = Color3.new(1,1,1)
        Title.Font = Enum.Font.GothamBold; Title.TextScaled = true; Title.Parent = ListFrame

        local Scrolling = Instance.new("ScrollingFrame")
        Scrolling.Size = UDim2.new(1,-30,1,-60)
        Scrolling.Position = UDim2.new(0,15,0,45)
        Scrolling.BackgroundTransparency = 1
        Scrolling.ScrollBarThickness = 6; Scrolling.Parent = ListUI
        Instance.new("UIListLayout", Scrolling).Padding = UDim.new(0,6)

        for _,Cmd in pairs(PRESET_COMMANDS) do
            local CmdBtn = Instance.new("TextButton")
            CmdBtn.Size = UDim2.new(1,0,0,36)
            CmdBtn.BackgroundColor3 = Color3.fromRGB(35,35,35)
            CmdBtn.Text = Cmd.Name.." | "..Cmd.Desc
            CmdBtn.TextColor3 = Color3.new(1,1,1); CmdBtn.Font = Enum.Font.Gotham
            CmdBtn.TextScaled = true; CmdBtn.Parent = Scrolling
            Instance.new("UICorner", CmdBtn).CornerRadius = UDim.new(0,6)
            CmdBtn.MouseButton1Click:Connect(function() pcall(Cmd.Action); ToggleCommandList() end)
        end
        Scrolling.CanvasSize = UDim2.new(0,0,#PRESET_COMMANDS*42,0)
    end

    -- BOOMBOX MENU
    local function ToggleBoomboxMenu()
        if BoomboxUI_Open then CurrentBoomboxUI:Destroy(); BoomboxUI_Open = false; GuiFocused = false; return end
        GuiFocused = true
        local BoomUI = Instance.new("ScreenGui")
        BoomUI.Name = "BLUE_BOOMBOX_MENU"
        BoomUI.ResetOnSpawn = false
        BoomUI.DisplayOrder = PRIORITY.BOOMBOX
        BoomUI.Parent = GuiContainer
        CurrentBoomboxUI = BoomUI; BoomboxUI_Open = true

        local BoomFrame = Instance.new("Frame")
        BoomFrame.Size = UDim2.new(0,320,0,250)
        BoomFrame.Position = UDim2.new(0.5,-160,0.5,-125)
        BoomFrame.BackgroundColor3 = Color3.fromRGB(22,22,22)
        BoomFrame.Active = true; BoomFrame.Parent = BoomUI
        Instance.new("UICorner", BoomFrame).CornerRadius = UDim.new(0,12)
        AddRainbowGlow(BoomFrame,4)

        local CloseTop = Instance.new("TextButton")
        CloseTop.Size = UDim2.new(0,30,0,30)
        CloseTop.Position = UDim2.new(1,-35,0,5)
        CloseTop.BackgroundColor3 = Color3.fromRGB(170,30,30)
        CloseTop.Text = "✕"; CloseTop.Parent = BoomFrame
        CloseTop.MouseButton1Click:Connect(function() ToggleBoomboxMenu() end)

        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1,-40,0,40)
        Title.Position = UDim2.new(0,15,0,8)
        Title.BackgroundTransparency = 1
        Title.Text = "🎵 BOOMBOX & VOLUME"
        Title.TextColor3 = Color3.new(1,1,1); Title.Font = Enum.Font.GothamBold
        Title.TextScaled = true; Title.Parent = BoomFrame

        local Input = Instance.new("TextBox")
        Input.Size = UDim2.new(1,-40,0,45)
        Input.Position = UDim2.new(0,20,0,55)
        Input.BackgroundColor3 = Color3.fromRGB(35,35,35)
        Input.PlaceholderText = "Paste Sound ID here..."
        Input.TextColor3 = Color3.new(1,1,1); Input.Parent = BoomFrame
        Instance.new("UICorner", Input).CornerRadius = UDim.new(0,8)

        local VolLabel = Instance.new("TextLabel")
        VolLabel.Size = UDim2.new(0,150,0,30)
        VolLabel.Position = UDim2.new(0,20,0,110)
        VolLabel.BackgroundTransparency = 1
        VolLabel.Text = "🔊 VOLUME (0–1000):"
        VolLabel.TextColor3 = Color3.new(1,1,1); VolLabel.Parent = BoomFrame

        VolNumMenu = Instance.new("TextLabel")
        VolNumMenu.Size = UDim2.new(0,60,0,30)
        VolNumMenu.Position = UDim2.new(1,-80,0,110)
        VolNumMenu.BackgroundTransparency = 1
        VolNumMenu.Text = tostring(math.floor(MusicVolume+0.5)); VolNumMenu.Parent = BoomFrame

        local VolBG = Instance.new("Frame")
        VolBG.Size = UDim2.new(1,-40,0,24)
        VolBG.Position = UDim2.new(0,20,0,145)
        VolBG.BackgroundColor3 = Color3.fromRGB(50,50,50)
        VolBG.Active = true; VolBG.Parent = BoomFrame
        Instance.new("UICorner", VolBG).CornerRadius = UDim.new(0,12)

        VolFillMenu = Instance.new("Frame")
        VolFillMenu.Size = UDim2.new(MusicVolume/VOLUME_MAX,0,1,0)
        VolFillMenu.BackgroundColor3 = Color3.fromRGB(100,100,100); VolFillMenu.Parent = VolBG
        Instance.new("UICorner", VolFillMenu).CornerRadius = UDim.new(0,12)

        local SliderActive = false
        VolBG.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then SliderActive = true end end)
        UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then SliderActive = false end end)
        UserInputService.InputChanged:Connect(function(i)
            if SliderActive and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                local rel = math.clamp((i.Position.X - VolBG.AbsolutePosition.X)/VolBG.AbsoluteSize.X, 0, 1)
                UpdateVolume(math.floor(rel * VOLUME_MAX))
            end
        end)

        local PlayBtn = Instance.new("TextButton")
        PlayBtn.Size = UDim2.new(0,130,0,40)
        PlayBtn.Position = UDim2.new(0,20,0,190)
        PlayBtn.BackgroundColor3 = Color3.fromRGB(25,140,255)
        PlayBtn.Text = "▶ PLAY SOUND"; PlayBtn.TextColor3 = Color3.new(1,1,1)
        PlayBtn.Parent = BoomFrame
        Instance.new("UICorner", PlayBtn).CornerRadius = UDim.new(0,8)

        local StopBtn = Instance.new("TextButton")
        StopBtn.Size = UDim2.new(0,130,0,40)
        StopBtn.Position = UDim2.new(0,170,0,190)
        StopBtn.BackgroundColor3 = Color3.fromRGB(200,30,30)
        StopBtn.Text = "⏹ STOP SOUND"; StopBtn.Parent = BoomFrame
        Instance.new("UICorner", StopBtn).CornerRadius = UDim.new(0,8)

        PlayBtn.MouseButton1Click:Connect(function() if Input.Text~="" then PlaySound(Input.Text) end end)
        StopBtn.MouseButton1Click:Connect(function() if CurrentSound then CurrentSound:Destroy() end end)
    end

    -- CONSOLE MENU
    local function ToggleConsole()
        if ConsoleUI_Open then CurrentConsoleUI:Destroy(); ConsoleUI_Open = false; GuiFocused = false; return end
        GuiFocused = true
        local ConsoleUI = Instance.new("ScreenGui")
        ConsoleUI.Name = "BLUE_CONSOLE"
        ConsoleUI.ResetOnSpawn = false
        ConsoleUI.DisplayOrder = PRIORITY.CONSOLE
        ConsoleUI.Parent = GuiContainer
        CurrentConsoleUI = ConsoleUI; ConsoleUI_Open = true

        local Frame = Instance.new("Frame")
        Frame.Size = UDim2.new(0,450,0,320)
        Frame.Position = UDim2.new(0.5,-225,0.5,-160)
        Frame.BackgroundColor3 = Color3.fromRGB(22,22,22)
        Frame.Active = true; Frame.Parent = ConsoleUI
        Instance.new("UICorner", Frame).CornerRadius = UDim.new(0,12)
        AddRainbowGlow(Frame,5)

        local CloseTop = Instance.new("TextButton")
        CloseTop.Size = UDim2.new(0,32,0,32)
        CloseTop.Position = UDim2.new(1,-37,0,6)
        CloseTop.BackgroundColor3 = Color3.fromRGB(170,30,30)
        CloseTop.Text = "✕"; CloseTop.Parent = Frame
        CloseTop.MouseButton1Click:Connect(function() ToggleConsole() end)

        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1,-50,0,35)
        Title.Position = UDim2.new(0,15,0,6)
        Title.BackgroundTransparency = 1
        Title.Text = "💻 CONSOLE"; Title.TextColor3 = Color3.new(1,1,1)
        Title.Font = Enum.Font.GothamBold; Title.Parent = Frame

        local Output = Instance.new("TextLabel")
        Output.Size = UDim2.new(1,-30,0,40)
        Output.Position = UDim2.new(0,15,0,45)
        Output.BackgroundTransparency = 1
        Output.Text = "Paste script code below..."; Output.TextColor3 = Color3.fromRGB(0,255,120)
        Output.Font = Enum.Font.Code; Output.Parent = Frame

        local Input = Instance.new("TextBox")
        Input.Size = UDim2.new(1,-30,0,130)
        Input.Position = UDim2.new(0,15,0,95)
        Input.BackgroundColor3 = Color3.fromRGB(45,45,45)
        Input.PlaceholderText = "Paste your script here..."
        Input.TextColor3 = Color3.new(1,1,1); Input.Font = Enum.Font.Code
        Input.MultiLine = true; Input.Parent = Frame
        Instance.new("UICorner", Input).CornerRadius = UDim.new(0,8)

        local ExecBtn = Instance.new("TextButton")
        ExecBtn.Size = UDim2.new(0,120,0,40)
        ExecBtn.Position = UDim2.new(0,15,0,240)
        ExecBtn.BackgroundColor3 = Color3.fromRGB(20,150,70)
        ExecBtn.Text = "▶ EXECUTE"; ExecBtn.Parent = Frame
        Instance.new("UICorner", ExecBtn).CornerRadius = UDim.new(0,8)

        local ClearBtn = Instance.new("TextButton")
        ClearBtn.Size = UDim2.new(0,120,0,40)
        ClearBtn.Position = UDim2.new(0,150,0,240)
        ClearBtn.BackgroundColor3 = Color3.fromRGB(180,120,20)
        ClearBtn.Text = "🗑️ CLEAR"; ClearBtn.Parent = Frame
        Instance.new("UICorner", ClearBtn).CornerRadius = UDim.new(0,8)

        ExecBtn.MouseButton1Click:Connect(function()
            local Code = Input.Text; if Code == "" then Output.Text = "⚠️ Nothing to run!"; return end
            local Load = loadstring or load; if not Load then Output.Text = "⚠️ Not supported"; return end
            local F,E = Load(Code); if not F then Output.Text = "❌ Error: "..tostring(E); return end
            local Ok,R = pcall(F); if Ok then Output.Text = "✅ Ran successfully!" else Output.Text = "❌ Error: "..tostring(R) end
        end)
        ClearBtn.MouseButton1Click:Connect(function() Input.Text = ""; Output.Text = "✅ Cleared!" end)
    end

    -- MAIN UI LAYOUT
    local FULL_SIZE = UDim2.new(0,790,0,105)
    local MINI_SIZE = UDim2.new(0,110,0,36)
    MainUI = Instance.new("ScreenGui")
    MainUI.Name = "BLUE_MODE_ESP"
    MainUI.ResetOnSpawn = false
    MainUI.DisplayOrder = PRIORITY.MAIN
    MainUI.Parent = GuiContainer

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = FULL_SIZE
    MainFrame.Position = UDim2.new(0,20,0.5,-52)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
    MainFrame.Active = true; MainFrame.Parent = MainUI
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,8)
    AddRainbowGlow(MainFrame,5)

    local DragHandle = Instance.new("TextButton")
    DragHandle.Size = UDim2.new(1,-30,0,22)
    DragHandle.Position = UDim2.new(0,0,0,0)
    DragHandle.BackgroundColor3 = Color3.fromRGB(60,140,220)
    DragHandle.Text = "made by BLUE_MODE | DRAG HERE"
    DragHandle.TextColor3 = Color3.new(1,1,1); DragHandle.Font = Enum.Font.GothamBold
    DragHandle.TextScaled = true; DragHandle.Active = true; DragHandle.Parent = MainFrame

    local TimerLabel = Instance.new("TextLabel")
    TimerLabel.Size = UDim2.new(0,120,1,0)
    TimerLabel.Position = UDim2.new(1,-125,0,0)
    TimerLabel.BackgroundTransparency = 1
    TimerLabel.Text = "00:00:00 / 12:00"; TimerLabel.TextColor3 = Color3.new(1,1,1)
    TimerLabel.Font = Enum.Font.GothamBold; TimerLabel.TextScaled = true; TimerLabel.TextXAlignment = Enum.TextXAlignment.Right
    TimerLabel.Parent = DragHandle

    MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.new(0,22,1,0)
    MinBtn.Position = UDim2.new(1,-22,0,0)
    MinBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
    MinBtn.Text = "➖"; MinBtn.TextColor3 = Color3.new(1,1,1)
    MinBtn.Font = Enum.Font.GothamBold; MinBtn.Parent = MainFrame

    -- BUTTONS
    ESPBtn = Instance.new("TextButton")
    ESPBtn.Size = UDim2.new(0,85,0,30)
    ESPBtn.Position = UDim2.new(0,10,0,30)
    ESPBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    ESPBtn.Text = "ESP: OFF"; ESPBtn.TextColor3 = Color3.new(1,1,1)
    ESPBtn.Font = Enum.Font.GothamBold; ESPBtn.Parent = MainFrame
    Instance.new("UICorner", ESPBtn).CornerRadius = UDim.new(0,6)

    local YouTubeBtn = Instance.new("TextButton")
    YouTubeBtn.Size = UDim2.new(0,95,0,30)
    YouTubeBtn.Position = UDim2.new(0,100,0,30)
    YouTubeBtn.BackgroundColor3 = Color3.fromRGB(200,30,30)
    YouTubeBtn.Text = "📺 YT"; YouTubeBtn.TextColor3 = Color3.new(1,1,1)
    YouTubeBtn.Font = Enum.Font.GothamBold; YouTubeBtn.Parent = MainFrame
    Instance.new("UICorner", YouTubeBtn).CornerRadius = UDim.new(0,6)

    local MusicBtn = Instance.new("TextButton")
    MusicBtn.Size = UDim2.new(0,90,0,30)
    MusicBtn.Position = UDim2.new(0,200,0,30)
    MusicBtn.BackgroundColor3 = Color3.fromRGB(40,80,160)
    MusicBtn.Text = "🎵 MUSIC"; MusicBtn.TextColor3 = Color3.new(1,1,1)
    MusicBtn.Font = Enum.Font.GothamBold; MusicBtn.Parent = MainFrame
    Instance.new("UICorner", MusicBtn).CornerRadius = UDim.new(0,6)

    LockBtn = Instance.new("TextButton")
    LockBtn.Size = UDim2.new(0,90,0,30)
    LockBtn.Position = UDim2.new(0,300,0,30)
    LockBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    LockBtn.Text = "🔓 UNLOCK"; LockBtn.TextColor3 = Color3.new(1,1,1)
    LockBtn.Font = Enum.Font.GothamBold; LockBtn.Parent = MainFrame
    Instance.new("UICorner", LockBtn).CornerRadius = UDim.new(0,6)

    local ConsoleBtn = Instance.new("TextButton")
    ConsoleBtn.Size = UDim2.new(0,110,0,30)
    ConsoleBtn.Position = UDim2.new(0,400,0,30)
    ConsoleBtn.BackgroundColor3 = Color3.fromRGB(30,120,90)
    ConsoleBtn.Text = "💻 CONSOLE"; ConsoleBtn.TextColor3 = Color3.new(1,1,1)
    ConsoleBtn.Font = Enum.Font.GothamBold; ConsoleBtn.Parent = MainFrame
    Instance.new("UICorner", ConsoleBtn).CornerRadius = UDim.new(0,6)

    -- NEW COMMAND BUTTON
    local CommandBtn = Instance.new("TextButton")
    CommandBtn.Size = UDim2.new(0,110,0,30)
    CommandBtn.Position = UDim2.new(0,520,0,30)
    CommandBtn.BackgroundColor3 = Color3.fromRGB(120,50,180)
    CommandBtn.Text = "⚡ COMMAND"; CommandBtn.TextColor3 = Color3.new(1,1,1)
    CommandBtn.Font = Enum.Font.GothamBold; CommandBtn.Parent = MainFrame
    Instance.new("UICorner", CommandBtn).CornerRadius = UDim.new(0,6)
    AddRainbowGlow(CommandBtn,2)

    local ExitBtn = Instance.new("TextButton")
    ExitBtn.Size = UDim2.new(0,90,0,30)
    ExitBtn.Position = UDim2.new(0,640,0,30)
    ExitBtn.BackgroundColor3 = Color3.fromRGB(140,20,20)
    ExitBtn.Text = "🗑️ EXIT"; ExitBtn.TextColor3 = Color3.new(1,1,1)
    ExitBtn.Font = Enum.Font.GothamBold; ExitBtn.Parent = MainFrame
    Instance.new("UICorner", ExitBtn).CornerRadius = UDim.new(0,6)

    -- VOLUME SLIDER
    local VolLabelMain = Instance.new("TextLabel")
    VolLabelMain.Size = UDim2.new(0,100,0,25)
    VolLabelMain.Position = UDim2.new(0,10,0,65)
    VolLabelMain.BackgroundTransparency = 1
    VolLabelMain.Text = "🔊 VOLUME:"; VolLabelMain.TextColor3 = Color3.new(1,1,1)
    VolLabelMain.Font = Enum.Font.Gotham; VolLabelMain.Parent = MainFrame

    VolNumTextMain = Instance.new("TextLabel")
    VolNumTextMain.Size = UDim2.new(0,50,0,25)
    VolNumTextMain.Position = UDim2.new(0,115,0,65)
    VolNumTextMain.BackgroundTransparency = 1
    VolNumTextMain.Text = tostring(math.floor(MusicVolume+0.5)); VolNumTextMain.Parent = MainFrame

    local VolBGMain = Instance.new("Frame")
    VolBGMain.Size = UDim2.new(0,150,0,18)
    VolBGMain.Position = UDim2.new(0,175,0,67)
    VolBGMain.BackgroundColor3 = Color3.fromRGB(50,50,50)
    VolBGMain.Active = true; VolBGMain.Parent = MainFrame
    Instance.new("UICorner", VolBGMain).CornerRadius = UDim.new(0,9)

    VolFillMain = Instance.new("Frame")
    VolFillMain.Size = UDim2.new(MusicVolume/VOLUME_MAX,0,1,0)
    VolFillMain.BackgroundColor3 = Color3.fromRGB(100,100,100); VolFillMain.Parent = VolBGMain
    Instance.new("UICorner", VolFillMain).CornerRadius = UDim.new(0,9)

    local SliderActiveMain = false
    VolBGMain.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then SliderActiveMain = true end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then SliderActiveMain = false end end)
    UserInputService.InputChanged:Connect(function(i)
        if SliderActiveMain and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local rel = math.clamp((i.Position.X - VolBGMain.AbsolutePosition.X)/VolBGMain.AbsoluteSize.X, 0, 1)
            UpdateVolume(math.floor(rel * VOLUME_MAX))
        end
    end)

    -- DRAG & TOGGLES
    local DragState = {Active=false, StartX=0, StartY=0, PosX=0, PosY=0}
    DragHandle.InputBegan:Connect(function(Input)
        GuiFocused = true
        if Buttons_Locked then return end
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            DragState.Active = true
            DragState.StartX = Input.Position.X
            DragState.StartY = Input.Position.Y
            DragState.PosX = MainFrame.Position.X.Offset
            DragState.PosY = MainFrame.Position.Y.Offset
        end
    end)
    UserInputService.InputEnded:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            DragState.Active = false
            task.delay(0.2, function() GuiFocused = false end)
        end
    end)
    UserInputService.InputChanged:Connect(function(Input)
        if DragState.Active and not Buttons_Locked then
            MainFrame.Position = UDim2.new(0, DragState.PosX + (Input.Position.X - DragState.StartX), 0, DragState.PosY + (Input.Position.Y - DragState.StartY))
        end
    end)

    LockBtn.MouseButton1Click:Connect(function()
        Buttons_Locked = not Buttons_Locked
        LockBtn.Text = Buttons_Locked and "🔒 LOCKED" or "🔓 UNLOCK"
        LockBtn.BackgroundColor3 = Buttons_Locked and Color3.fromRGB(180,40,40) or Color3.fromRGB(50,50,50)
    end)

    MinBtn.MouseButton1Click:Connect(function()
        IsMinimized = not IsMinimized
        if IsMinimized then
            MainFrame.Size = MINI_SIZE
            ESPBtn.Visible = false; YouTubeBtn.Visible = false; MusicBtn.Visible = false
            LockBtn.Visible = false; ConsoleBtn.Visible = false; CommandBtn.Visible = false; ExitBtn.Visible = false
            VolLabelMain.Visible = false; VolNumTextMain.Visible = false; VolBGMain.Visible = false
            DragHandle.Text = ""; MinBtn.Text = "➕"
            TimerLabel.Size = UDim2.new(1,-28,1,0); TimerLabel.Position = UDim2.new(0,4,0,0)
        else
            MainFrame.Size = FULL_SIZE
            ESPBtn.Visible = true; YouTubeBtn.Visible = true; MusicBtn.Visible = true
            LockBtn.Visible = true; ConsoleBtn.Visible = true; CommandBtn.Visible = true; ExitBtn.Visible = true
            VolLabelMain.Visible = true; VolNumTextMain.Visible = true; VolBGMain.Visible = true
            DragHandle.Text = "made by BLUE_MODE | DRAG HERE"; MinBtn.Text = "➖"
            TimerLabel.Size = UDim2.new(0,120,1,0); TimerLabel.Position = UDim2.new(1,-125,0,0)
        end
    end)

    ESPBtn.MouseButton1Click:Connect(function()
        ESP_Enabled = not ESP_Enabled
        ESPBtn.Text = ESP_Enabled and "ESP: ON" or "ESP: OFF"
        ESPBtn.BackgroundColor3 = ESP_Enabled and Color3.fromRGB(25,120,25) or Color3.fromRGB(40,40,40)
        if not ESP_Enabled then ClearAllESP() end
    end)

    YouTubeBtn.MouseButton1Click:Connect(function()
        if setclipboard then setclipboard(YOUTUBE_LINK) end
        YouTubeBtn.Text = "✅ COPIED!"
        task.wait(1.5); YouTubeBtn.Text = "📺 YT"
    end)

    MusicBtn.MouseButton1Click:Connect(ToggleBoomboxMenu)
    ConsoleBtn.MouseButton1Click:Connect(ToggleConsole)
    CommandBtn.MouseButton1Click:Connect(ToggleCommandMenu)

    ExitBtn.MouseButton1Click:Connect(function()
        ClearAllESP(); pcall(function() if CurrentSound then CurrentSound:Destroy() end end)
        if CurrentBoomboxUI then CurrentBoomboxUI:Destroy() end
        if CurrentConsoleUI then CurrentConsoleUI:Destroy() end
        if CurrentCommandUI then CurrentCommandUI:Destroy() end
        if CurrentCommandListUI then CurrentCommandListUI:Destroy() end
        MainUI:Destroy(); getgenv().BlueMode_Loaded = nil
    end)

    SetupDeathCheck()

    -- MAIN LOOP
    RunService.Heartbeat:Connect(function(Delta)
        if not MainUI or not MainUI.Parent then return end
        local Now = os.time()
        UsedTime = UsedTime + math.max(0, Now - LastCheckTime)
        LastCheckTime = Now
        SaveData(SAVE_KEY_USED, UsedTime)
        local Remaining = math.max(0, USAGE_LIMIT - UsedTime)
        local h = math.floor(Remaining/3600); local m = math.floor((Remaining%3600)/60); local s = Remaining%60
        TimerLabel.Text = string.format("%02d:%02d:%02d / 12:00",h,m,s)
        if Remaining <= 0 then SaveData(SAVE_KEY_COOLDOWN, os.time() + COOLDOWN); pcall(function() delfile(SAVE_KEY_USED..".txt") end); ExitBtn:Fire(); return end

        Hue = (Hue + Delta*0.5) % 1
        local Rainbow = Color3.fromHSV(Hue,1,1)
        for _,e in pairs(GuiElements) do e.Color = Rainbow end
        if VolFillMain then VolFillMain.BackgroundColor3 = Rainbow end
        if VolFillMenu then VolFillMenu.BackgroundColor3 = Rainbow end
        TimerLabel.TextColor3 = Rainbow

        if not ESP_Enabled then return end
        for _,P in pairs(Players:GetPlayers()) do
            if P == LocalPlayer then continue end
            local Char = P.Character; if not Char then continue end
            local Hum = Char:FindFirstChildOfClass("Humanoid"); if not Hum or Hum.Health <= 0 then continue end

            local Outline = Char:FindFirstChild("BLUE_Outline") or Instance.new("Highlight",Char)
            Outline.Name = "BLUE_Outline"; Outline.FillTransparency = 1; Outline.OutlineTransparency = 0
            Outline.OutlineColor = Rainbow; Outline.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

            local IsFriend = false; pcall(function() IsFriend = LocalPlayer:IsFriendsWith(P.UserId) end)
            local Head = Char:FindFirstChild("Head"); local Dot = Char:FindFirstChild("FriendRainbowDot")
            if IsFriend and Head then
                if not Dot then
                    Dot = Instance.new("BillboardGui",Head); Dot.Name = "FriendRainbowDot"
                    Dot.AlwaysOnTop = true; Dot.Size = UDim2.new(0,16,0,16)
                    Dot.Studs
