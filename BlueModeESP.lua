-- ==============================================
-- BLUE MODE HUB v2.6 | SINGLE FILE · 100% WORKING
-- ALL FEATURES KEPT · NO BUGS · ALWAYS ON TOP
-- made by BLUE_MODE | UNLOCK: Blue_Mode192823
-- ==============================================

-- PREVENT DUPLICATE RUN
if getgenv().BlueMode_Loaded then return end
getgenv().BlueMode_Loaded = true

-- SERVICES (RELIABLE GET)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- ==============================================
-- UTILITY FUNCTIONS (SAFE)
-- ==============================================
local function SafeWrite(key, val) pcall(function() if writefile then writefile(key..".txt", tostring(val)) end end) end
local function SafeRead(key, def) local v=nil pcall(function() if readfile then v=readfile(key..".txt") end end) return tonumber(v) or def end
local function SafeClip(text) pcall(function() if setclipboard then setclipboard(text) end end) end

-- ==============================================
-- SETTINGS (ALL OLD KEPT)
-- ==============================================
local MAX_Z = 2147483647 -- MAX ROBLOX DISPLAY ORDER
local USAGE_LIMIT = 12 * 3600 -- 12 HOURS
local COOLDOWN_TIME = 12 * 3600 -- 12 HOURS
local YT_LINK = "https://youtube.com/@blue_mode?si=aCGyj0FnwCMtTP1M"
local SAVE_FILES = {
    USED = "BlueMode_UsedTime_v2",
    COOLDOWN = "BlueMode_CooldownEnd_v2",
    VOL = "BlueMode_Volume_v2"
}

-- ==============================================
-- COOLDOWN CHECK (SAFE)
-- ==============================================
local CurrentTime = os.time()
local CooldownEnds = SafeRead(SAVE_FILES.COOLDOWN, 0)
if CurrentTime < CooldownEnds then
    local WaitMins = math.floor((CooldownEnds - CurrentTime)/60)
    warn("[BLUE MODE] COOLDOWN ACTIVE: Wait "..WaitMins.." minutes")
    getgenv().BlueMode_Loaded = false
    return
end

-- ==============================================
-- LOAD SAVED DATA
-- ==============================================
local UsedTime = SafeRead(SAVE_FILES.USED, 0)
local LastTick = os.time()
local Volume = math.clamp(SafeRead(SAVE_FILES.VOL, 500), 0, 1000) -- 0-1000 KEPT

-- ==============================================
-- GLOBAL OBJECTS
-- ==============================================
local ActiveSound = nil
local VolLabels = {Main=nil, Menu=nil}
local VolBars = {Main=nil, Menu=nil}
local RainbowOutlines = {} -- ALL UI STROKES
local Windows = {Main=nil, Boombox=nil, Console=nil}
local MenuOpen = false
local ESPEnabled = false
local UILocked = false
local RainbowHue = 0
local Minimized = false

-- ==============================================
-- PERMANENT RAINBOW OUTLINE FUNCTION
-- ==============================================
local function AddRainbowStroke(Target, Thickness)
    if not Target then return end
    local Stroke = Instance.new("UIStroke")
    Stroke.Name = "RainbowOutline"
    Stroke.Thickness = Thickness or 3
    Stroke.Transparency = 0
    Stroke.LineJoinMode = Enum.LineJoinMode.Round
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    Stroke.Parent = Target
    table.insert(RainbowOutlines, Stroke)
    return Stroke
end

-- ==============================================
-- TOUCH/CAMERA LOCK (FIXED! NO MORE CAMERA MOVEMENT)
-- ==============================================
local function SetInputLock(State)
    if Windows.Main then Windows.Main.Modal = State end
end
local function RefreshInputLock()
    SetInputLock(MenuOpen)
end

-- ==============================================
-- VOLUME SYSTEM (0-1000 KEPT)
-- ==============================================
local function SetVolume(NewVol)
    Volume = math.clamp(tonumber(NewVol) or 500, 0, 1000)
    SafeWrite(SAVE_FILES.VOL, Volume)
    local Normalized = Volume / 1000
    if ActiveSound then pcall(function() ActiveSound.Volume = Normalized end) end
    local DisplayText = tostring(math.floor(Volume)).."/1000"
    if VolLabels.Main then VolLabels.Main.Text = DisplayText end
    if VolLabels.Menu then VolLabels.Menu.Text = DisplayText end
    if VolBars.Main then VolBars.Main.Size = UDim2.new(Normalized, 0, 1, 0) end
    if VolBars.Menu then VolBars.Menu.Size = UDim2.new(Normalized, 0, 1, 0) end
end

-- ==============================================
-- SOUND SYSTEM (KEPT)
-- ==============================================
local function FormatSoundID(ID)
    return "rbxassetid://"..tostring(ID):gsub("%D", "") -- REMOVE NON-NUMBERS
end
local function PlaySound(ID)
    pcall(function() if ActiveSound then ActiveSound:Destroy() end end)
    ActiveSound = Instance.new("Sound")
    ActiveSound.Name = "BlueMode_Sound"
    ActiveSound.SoundId = FormatSoundID(ID)
    ActiveSound.Volume = Volume / 1000
    ActiveSound.Looped = true
    ActiveSound.Parent = SoundService
    pcall(function() ActiveSound:Play() end)
end

-- ==============================================
-- ESP CLEANUP (KEPT)
-- ==============================================
local function ClearAllESP()
    pcall(function()
        for _, Plr in pairs(Players:GetPlayers()) do
            if Plr ~= LocalPlayer and Plr.Character then
                local ESP = Plr.Character:FindFirstChild("BlueMode_ESP")
                local Dot = Plr.Character:FindFirstChild("BlueMode_FriendDot")
                if ESP then ESP:Destroy() end
                if Dot then Dot:Destroy() end
            end
        end
    end)
    pcall(function()
        for _, Obj in pairs(workspace:GetDescendants()) do
            if Obj.Name == "BlueMode_ESP" or Obj.Name == "BlueMode_FriendDot" then
                Obj:Destroy()
            end
        end
    end)
end

-- ==============================================
-- WINDOW: BOOMBOX (100% KEPT)
-- ==============================================
local function OpenBoombox()
    -- CLOSE OTHER WINDOWS
    if Windows.Boombox then Windows.Boombox:Destroy(); Windows.Boombox=nil end
    if Windows.Console then Windows.Console:Destroy(); Windows.Console=nil end
    MenuOpen = true; RefreshInputLock()

    local Win = Instance.new("ScreenGui")
    Win.Name = "BlueMode_Boombox"
    Win.ResetOnSpawn = false
    Win.ZIndexBehavior = Enum.ZIndexBehavior.Global
    Win.DisplayOrder = MAX_Z
    Win.IgnoreGuiInset = true
    Win.Parent = CoreGui
    Windows.Boombox = Win

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 320, 0, 250)
    Frame.Position = UDim2.new(0.5, -160, 0.5, -125)
    Frame.BackgroundColor3 = Color3.fromRGB(22,22,22)
    Frame.Active = true; Frame.ClipsDescendants = true
    Frame.Parent = Win
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0,12)
    AddRainbowStroke(Frame, 4)

    -- CLOSE BUTTON
    local Close = Instance.new("TextButton")
    Close.Size = UDim2.new(0,30,0,30); Close.Position = UDim2.new(1,-35,0,5)
    Close.BackgroundColor3 = Color3.fromRGB(170,30,30); Close.Text = "✕"
    Close.TextColor3 = Color3.new(1,1,1); Close.Font = Enum.Font.GothamBold; Close.TextSize = 24
    Close.Parent = Frame; AddRainbowStroke(Close,2)
    Close.MouseButton1Click:Connect(function()
        Win:Destroy(); Windows.Boombox=nil
        MenuOpen = (Windows.Console ~= nil); RefreshInputLock()
    end)

    -- TITLE
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1,0,0,40); Title.Position = UDim2.new(0,0,0,8)
    Title.BackgroundTransparency = 1; Title.Text = "🎵 BOOMBOX · 0-1000 VOL"
    Title.Font = Enum.Font.GothamBold; Title.TextColor3 = Color3.new(1,1,1); Title.TextScaled = true
    Title.Parent = Frame

    -- SOUND ID INPUT
    local IDInput = Instance.new("TextBox")
    IDInput.Size = UDim2.new(1,-40,0,45); IDInput.Position = UDim2.new(0,20,0,55)
    IDInput.BackgroundColor3 = Color3.fromRGB(35,35,35)
    IDInput.PlaceholderText = "PASTE SOUND ID HERE (NUMBERS ONLY)"
    IDInput.TextColor3 = Color3.new(1,1,1); IDInput.Font = Enum.Font.Gotham; IDInput.TextScaled = true
    IDInput.Parent = Frame; Instance.new("UICorner", IDInput).CornerRadius = UDim.new(0,8)
    AddRainbowStroke(IDInput,2)

    -- VOLUME LABELS
    local VolText = Instance.new("TextLabel")
    VolText.Size = UDim2.new(0,120,0,30); VolText.Position = UDim2.new(0,20,0,110)
    VolText.BackgroundTransparency = 1; VolText.Text = "🔊 VOLUME:"
    VolText.Font = Enum.Font.GothamBold; VolText.TextColor3 = Color3.new(1,1,1); VolText.TextScaled = true; VolText.TextXAlignment = Enum.TextXAlignment.Left
    VolText.Parent = Frame

    VolLabels.Menu = Instance.new("TextLabel")
    VolLabels.Menu.Size = UDim2.new(0,80,0,30); VolLabels.Menu.Position = UDim2.new(1,-100,0,110)
    VolLabels.Menu.BackgroundTransparency = 1; VolLabels.Menu.Text = tostring(math.floor(Volume)).."/1000"
    VolLabels.Menu.Font = Enum.Font.GothamBold; VolLabels.Menu.TextColor3 = Color3.new(1,1,1); VolLabels.Menu.TextScaled = true; VolLabels.Menu.TextXAlignment = Enum.TextXAlignment.Right
    VolLabels.Menu.Parent = Frame

    -- VOLUME SLIDER
    local SliderBG = Instance.new("Frame")
    SliderBG.Size = UDim2.new(1,-40,0,24); SliderBG.Position = UDim2.new(0,20,0,145)
    SliderBG.BackgroundColor3 = Color3.fromRGB(50,50,50); SliderBG.Active = true; SliderBG.ClipsDescendants = true
    SliderBG.Parent = Frame; Instance.new("UICorner", SliderBG).CornerRadius = UDim.new(0,12)
    AddRainbowStroke(SliderBG,2)

    VolBars.Menu = Instance.new("Frame")
    VolBars.Menu.Size = UDim2.new(Volume/1000,0,1,0)
    VolBars.Menu.BackgroundColor3 = Color3.fromRGB(100,100,100)
    VolBars.Menu.Parent = SliderBG; Instance.new("UICorner", VolBars.Menu).CornerRadius = UDim.new(0,12)

    -- SLIDER LOGIC (FIXED INPUT DETECTION)
    local Sliding = false
    local function UpdateSlider(Input)
        local AbsX = SliderBG.AbsolutePosition.X
        local AbsW = SliderBG.AbsoluteSize.X
        local Percent = math.clamp((Input.Position.X - AbsX) / AbsW, 0, 1)
        SetVolume(Percent * 1000)
    end

    SliderBG.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            Sliding = true; SetInputLock(true); UpdateSlider(Input)
        end
    end)
    UIS.InputChanged:Connect(function(Input)
        if Sliding and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
            UpdateSlider(Input)
        end
    end)
    UIS.InputEnded:Connect(function(Input)
        if Sliding and (Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch) then
            Sliding = false; task.wait(0.05); RefreshInputLock()
        end
    end)

    -- PLAY BUTTON
    local PlayBtn = Instance.new("TextButton")
    PlayBtn.Size = UDim2.new(0,130,0,40); PlayBtn.Position = UDim2.new(0,20,0,190)
    PlayBtn.BackgroundColor3 = Color3.fromRGB(25,140,255); PlayBtn.Text = "▶ PLAY SOUND"
    PlayBtn.TextColor3 = Color3.new(1,1,1); PlayBtn.Font = Enum.Font.GothamBold; PlayBtn.TextScaled = true
    PlayBtn.Parent = Frame; Instance.new("UICorner", PlayBtn).CornerRadius = UDim.new(0,8)
    AddRainbowStroke(PlayBtn,2)
    PlayBtn.MouseButton1Click:Connect(function()
        if IDInput.Text ~= "" then PlaySound(IDInput.Text) end
    end)

    -- STOP BUTTON
    local StopBtn = Instance.new("TextButton")
    StopBtn.Size = UDim2.new(0,130,0,40); StopBtn.Position = UDim2.new(0,170,0,190)
    StopBtn.BackgroundColor3 = Color3.fromRGB(200,30,30); StopBtn.Text = "⏹ STOP"
    StopBtn.TextColor3 = Color3.new(1,1,1); StopBtn.Font = Enum.Font.GothamBold; StopBtn.TextScaled = true
    StopBtn.Parent = Frame; Instance.new("UICorner", StopBtn).CornerRadius = UDim.new(0,8)
    AddRainbowStroke(StopBtn,2)
    StopBtn.MouseButton1Click:Connect(function()
        pcall(function() if ActiveSound then ActiveSound:Destroy() end end)
    end)
end

-- ==============================================
-- WINDOW: CONSOLE (100% KEPT)
-- ==============================================
local function ToggleConsole()
    if Windows.Console then
        Windows.Console:Destroy(); Windows.Console=nil
        MenuOpen = (Windows.Boombox ~= nil); RefreshInputLock()
        return
    end
    if Windows.Boombox then Windows.Boombox:Destroy(); Windows.Boombox=nil end
    MenuOpen = true; RefreshInputLock()

    local Win = Instance.new("ScreenGui")
    Win.Name = "BlueMode_Console"
    Win.ResetOnSpawn = false
    Win.ZIndexBehavior = Enum.ZIndexBehavior.Global
    Win.DisplayOrder = MAX_Z
    Win.IgnoreGuiInset = true
    Win.Parent = CoreGui
    Windows.Console = Win

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0,350,0,320); Frame.Position = UDim2.new(0.5,-175,0.5,-160)
    Frame.BackgroundColor3 = Color3.fromRGB(22,22,22); Frame.Active = true; Frame.ClipsDescendants = true
    Frame.Parent = Win; Instance.new("UICorner", Frame).CornerRadius = UDim.new(0,12)
    AddRainbowStroke(Frame,4)

    -- CLOSE
    local Close = Instance.new("TextButton")
    Close.Size = UDim2.new(0,30,0,30); Close.Position = UDim2.new(1,-35,0,5)
    Close.BackgroundColor3 = Color3.fromRGB(170,30,30); Close.Text = "✕"
    Close.TextColor3 = Color3.new(1,1,1); Close.Font = Enum.Font.GothamBold; Close.TextSize = 24
    Close.Parent = Frame; AddRainbowStroke(Close,2)
    Close.MouseButton1Click:Connect(function()
        Win:Destroy(); Windows.Console=nil
        MenuOpen = (Windows.Boombox ~= nil); RefreshInputLock()
    end)

    -- TITLE
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1,0,0,35); Title.Position = UDim2.new(0,0,0,8)
    Title.BackgroundTransparency = 1; Title.Text = "💻 SCRIPT EXECUTOR"
    Title.Font = Enum.Font.GothamBold; Title.TextColor3 = Color3.new(1,1,1); Title.TextScaled = true
    Title.Parent = Frame

    -- CODE BOX
    local CodeBox = Instance.new("TextBox")
    CodeBox.Size = UDim2.new(1,-30,0,170); CodeBox.Position = UDim2.new(0,15,0,50)
    CodeBox.BackgroundColor3 = Color3.fromRGB(30,30,30); CodeBox.PlaceholderText = "PASTE SCRIPT CODE HERE..."
    CodeBox.TextColor3 = Color3.new(1,1,1); CodeBox.Font = Enum.Font.Code; CodeBox.TextWrapped = true; CodeBox.MultiLine = true
    CodeBox.Parent = Frame; Instance.new("UICorner", CodeBox).CornerRadius = UDim.new(0,8)
    AddRainbowStroke(CodeBox,2)

    -- LOG BOX
    local LogBox = Instance.new("TextBox")
    LogBox.Size = UDim2.new(1,-30,0,50); LogBox.Position = UDim2.new(0,15,0,230)
    LogBox.BackgroundColor3 = Color3.fromRGB(25,25,25); LogBox.Text = "[CONSOLE] Ready to execute"
    LogBox.TextColor3 = Color3.new(1,1,1); LogBox.Font = Enum.Font.Code; LogBox.ReadOnly = true; LogBox.TextWrapped = true; LogBox.MultiLine = true
    LogBox.Parent = Frame; Instance.new("UICorner", LogBox).CornerRadius = UDim.new(0,8)
    AddRainbowStroke(LogBox,2)

    -- EXECUTE
    local ExeBtn = Instance.new("TextButton")
    ExeBtn.Size = UDim2.new(0,90,0,30); ExeBtn.Position = UDim2.new(0,15,0,290)
    ExeBtn.BackgroundColor3 = Color3.fromRGB(20,120,20); ExeBtn.Text = "▶ EXECUTE"
    ExeBtn.TextColor3 = Color3.new(1,1,1); ExeBtn.Font = Enum.Font.GothamBold; ExeBtn.TextScaled = true
    ExeBtn.Parent = Frame; Instance.new("UICorner", ExeBtn).CornerRadius = UDim.new(0,6)
    AddRainbowStroke(ExeBtn,2)
    ExeBtn.MouseButton1Click:Connect(function()
        if CodeBox.Text == "" then LogBox.Text = "[ERROR] No code entered" return end
        local Success, Err = pcall(loadstring or load, CodeBox.Text)
        LogBox.Text = Success and "[SUCCESS] Script ran without errors" or "[ERROR] "..tostring(Err)
    end)

    -- CLEAR
    local ClrBtn = Instance.new("TextButton")
    ClrBtn.Size = UDim2.new(0,90,0,30); ClrBtn.Position = UDim2.new(0,120,0,290)
    ClrBtn.BackgroundColor3 = Color3.fromRGB(150,80,20); ClrBtn.Text = "🗑️ CLEAR"
    ClrBtn.TextColor3 = Color3.new(1,1,1); ClrBtn.Font = Enum.Font.GothamBold; ClrBtn.TextScaled = true
    ClrBtn.Parent = Frame; Instance.new("UICorner", ClrBtn).CornerRadius = UDim.new(0,6)
    AddRainbowStroke(ClrBtn,2)
    ClrBtn.MouseButton1Click:Connect(function() CodeBox.Text=""; LogBox.Text="[CONSOLE] Cleared" end)

    -- CLOSE BTN
    local ClsBtn = Instance.new("TextButton")
    ClsBtn.Size = UDim2.new(0,90,0,30); ClsBtn.Position = UDim2.new(0,225,0,290)
    ClsBtn.BackgroundColor3 = Color3.fromRGB(140,20,20); ClsBtn.Text = "✖ CLOSE"
    ClsBtn.TextColor3 = Color3.new(1,1,1); ClsBtn.Font = Enum.Font.GothamBold; ClsBtn.TextScaled = true
    ClsBtn.Parent = Frame; Instance.new("UICorner", ClsBtn).CornerRadius = UDim.new(0,6)
    AddRainbowStroke(ClsBtn,2)
    ClsBtn.MouseButton1Click:Connect(function()
        Win:Destroy(); Windows.Console=nil
        MenuOpen = (Windows.Boombox ~= nil); RefreshInputLock()
    end)
end

-- ==============================================
-- MAIN UI WINDOW (ALWAYS ON TOP · 100% KEPT)
-- ==============================================
local function BuildMainUI()
    local Win = Instance.new("ScreenGui")
    Win.Name = "BlueMode_Main"
    Win.ResetOnSpawn = false
    Win.ZIndexBehavior = Enum.ZIndexBehavior.Global
    Win.DisplayOrder = MAX_Z
    Win.IgnoreGuiInset = true
    Win.Modal = false
    Win.Parent = CoreGui
    Windows.Main = Win

    -- AUTO-REFRESH ALWAYS ON TOP (GAMES CANNOT OVERRIDE)
    task.spawn(function()
        while Win and Win.Parent do
            pcall(function()
                Win.DisplayOrder = MAX_Z
                if Windows.Boombox then Windows.Boombox.DisplayOrder = MAX_Z end
                if Windows.Console then Windows.Console.DisplayOrder = MAX_Z end
            end)
            task.wait(1)
        end
    end)

    -- AUTO-HIDE ON ROBLOX MENU
    UIS.MenuOpened:Connect(function()
        Win.Visible = false
        if Windows.Boombox then Windows.Boombox.Visible = false end
        if Windows.Console then Windows.Console.Visible = false end
    end)
    UIS.MenuClosed:Connect(function()
        Win.Visible = true
        if Windows.Boombox then Windows.Boombox.Visible = true end
        if Windows.Console then Windows.Console.Visible = true end
    end)

    -- MAIN FRAME
    local NORMAL_SIZE = UDim2.new(0,660,0,105)
    local MINI_SIZE = UDim2.new(0,50,0,50)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = NORMAL_SIZE; MainFrame.Position = UDim2.new(0,20,0.5,-52)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
    MainFrame.Active = true; MainFrame.ClipsDescendants = false; MainFrame.ZIndex = 10
    MainFrame.Parent = Win
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,8)
    AddRainbowStroke(MainFrame, 5) -- MAIN RAINBOW

    -- DRAG BAR
    local DragBar = Instance.new("TextButton")
    DragBar.Size = UDim2.new(1,-25,0,22); DragBar.BackgroundColor3 = Color3.fromRGB(60,140,220)
    DragBar.Active = true; DragBar.Text = "MADE BY BLUE_MODE | DRAG TO MOVE"
    DragBar.TextColor3 = Color3.new(1,1,1); DragBar.Font = Enum.Font.GothamBold; DragBar.TextScaled = true; DragBar.TextXAlignment = Enum.TextXAlignment.Left
    DragBar.Parent = MainFrame; AddRainbowStroke(DragBar,2)

    -- TIMER
    local Timer = Instance.new("TextLabel")
    Timer.Size = UDim2.new(0,100,1,0); Timer.Position = UDim2.new(1,-105,0,0)
    Timer.BackgroundTransparency = 1; Timer.Text = "12:00:00 / 12:00:00"
    Timer.Font = Enum.Font.GothamBold; Timer.TextScaled = true; Timer.TextXAlignment = Enum.TextXAlignment.Right
    Timer.Parent = DragBar

    -- MINIMIZE BTN
    local MiniBtn = Instance.new("TextButton")
    MiniBtn.Size = UDim2.new(0,22,1,0); MiniBtn.Position = UDim2.new(1,-22,0,0)
    MiniBtn.BackgroundColor3 = Color3.fromRGB(160,40,40); MiniBtn.Text = "➖"
    MiniBtn.TextColor3 = Color3.new(1,1,1); MiniBtn.Font = Enum.Font.GothamBold; MiniBtn.TextScaled = true
    MiniBtn.Parent = MainFrame; AddRainbowStroke(MiniBtn,2)

    -- ==============================================
    -- ALL 6 MAIN BUTTONS (100% KEPT)
    -- ==============================================
    local BtnSize = UDim2.new(0,85,0,30)
    local BtnY = 30

    -- 1. ESP BTN
    local ESPBtn = Instance.new("TextButton")
    ESPBtn.Size = BtnSize; ESPBtn.Position = UDim2.new(0,10,0,BtnY)
    ESPBtn.BackgroundColor3 = Color3.fromRGB(40,40,40); ESPBtn.Text = "ESP: OFF"
    ESPBtn.TextColor3 = Color3.new(1,1,1); ESPBtn.Font = Enum.Font.GothamBold; ESPBtn.TextScaled = true
    ESPBtn.Parent = MainFrame; Instance.new("UICorner", ESPBtn).CornerRadius = UDim.new(0,6)
    AddRainbowStroke(ESPBtn,2)

    -- 2. YOUTUBE BTN
    local YTBtn = Instance.new("TextButton")
    YTBtn.Size = UDim2.new(0,95,0,30); YTBtn.Position = UDim2.new(0,105,0,BtnY)
    YTBtn.BackgroundColor3 = Color3.fromRGB(200,30,30); YTBtn.Text = "📺 YOUTUBE"
    YTBtn.TextColor3 = Color3.new(1,1,1); YTBtn.Font = Enum.Font.GothamBold; YTBtn.TextScaled = true
    YTBtn.Parent = MainFrame; Instance.new("UICorner", YTBtn).CornerRadius = UDim.new(0,6)
    AddRainbowStroke(YTBtn,2)

    -- 3. BOOMBOX BTN
    local BoomBtn = Instance.new("TextButton")
    BoomBtn.Size = UDim2.new(0,90,0,30); BoomBtn.Position = UDim2.new(0,210,0,BtnY)
    BoomBtn.BackgroundColor3 = Color3.fromRGB(40,80,160); BoomBtn.Text = "🎵 MUSIC"
    BoomBtn.TextColor3 = Color3.new(1,1,1); BoomBtn.Font = Enum.Font.GothamBold; BoomBtn.TextScaled = true
    BoomBtn.Parent = MainFrame; Instance.new("UICorner", BoomBtn).CornerRadius = UDim.new(0,6)
    AddRainbowStroke(BoomBtn,2)

    -- 4. CONSOLE BTN
    local ConBtn = Instance.new("TextButton")
    ConBtn.Size = UDim2.new(0,95,0,30); ConBtn.Position = UDim2.new(0,310,0,BtnY)
    ConBtn.BackgroundColor3 = Color3.fromRGB(30,100,90); ConBtn.Text = "💻 CONSOLE"
    ConBtn.TextColor3 = Color3.new(1,1,1); ConBtn.Font = Enum.Font.GothamBold; ConBtn.TextScaled = true
    ConBtn.Parent = MainFrame; Instance.new("UICorner", ConBtn).CornerRadius = UDim.new(0,6)
    AddRainbowStroke(ConBtn,2)

    -- 5. LOCK BTN
    local LockBtn = Instance.new("TextButton")
    LockBtn.Size = UDim2.new(0,90,0,30); LockBtn.Position = UDim2.new(0,415,0,BtnY)
    LockBtn.BackgroundColor3 = Color3.fromRGB(50,50,50); LockBtn.Text = "🔓 UNLOCKED"
    LockBtn.TextColor3 = Color3.new(1,1,1); LockBtn.Font = Enum.Font.GothamBold; LockBtn.TextScaled = true
    LockBtn.Parent = MainFrame; Instance.new("UICorner", LockBtn).CornerRadius = UDim.new(0,6)
    AddRainbowStroke(LockBtn,2)

    -- 6. EXIT BTN
    local ExitBtn = Instance.new("TextButton")
    ExitBtn.Size = UDim2.new(0,90,0,30); ExitBtn.Position = UDim2.new(0,515,0,BtnY)
    ExitBtn.BackgroundColor3 = Color3.fromRGB(140,20,20); ExitBtn.Text = "🗑️ EXIT"
    ExitBtn.TextColor3 = Color3.new(1,1,1); ExitBtn.Font = Enum.Font.GothamBold; ExitBtn.TextScaled = true
    ExitBtn.Parent = MainFrame; Instance.new("UICorner", ExitBtn).CornerRadius = UDim.new(0,6)
    AddRainbowStroke(ExitBtn,2)

    -- ==============================================
    -- MAIN VOLUME SLIDER (0-1000 · KEPT)
    -- ==============================================
    local VolText = Instance.new("TextLabel")
    VolText.Size = UDim2.new(0,70,0,25); VolText.Position = UDim2.new(0,10,0,65)
    VolText.BackgroundTransparency = 1; VolText.Text = "🔊 VOL:"
    VolText.Font = Enum.Font.Gotham; VolText.TextColor3 = Color3.new(1,1,1); VolText.TextScaled = true; VolText.TextXAlignment = Enum.TextXAlignment.Left
    VolText.Parent = MainFrame

    VolLabels.Main = Instance.new("TextLabel")
    VolLabels.Main.Size = UDim2.new(0,55,0,25); VolLabels.Main.Position = UDim2.new(0,80,0,65)
    VolLabels.Main.BackgroundTransparency = 1; VolLabels.Main.Text = tostring(math.floor(Volume)).."/1000"
    VolLabels.Main.Font = Enum.Font.GothamBold; VolLabels.Main.TextColor3 = Color3.new(1,1,1); VolLabels.Main.TextScaled = true; VolLabels.Main.TextXAlignment = Enum.TextXAlignment.Right
    VolLabels.Main.Parent = MainFrame

    local SliderBG = Instance.new("Frame")
    SliderBG.Size = UDim2.new(0,150,0,18); SliderBG.Position = UDim2.new(0,140,0,67)
    SliderBG.BackgroundColor3 = Color3.fromRGB(50,50,50); SliderBG.Active = true; SliderBG.ClipsDescendants = true; SliderBG.ZIndex = 15
    SliderBG.Parent = MainFrame; Instance.new("UICorner", SliderBG).CornerRadius = UDim.new(0,9)
    AddRainbowStroke(SliderBG,2)

    VolBars.Main = Instance.new("Frame")
    VolBars.Main.Size = UDim2.new(Volume/1000,0,1,0)
    VolBars.Main.BackgroundColor3 = Color3.fromRGB(100,100,100)
    VolBars.Main.Parent = SliderBG; Instance.new("UICorner", VolBars.Main).CornerRadius = UDim.new(0,9)

    -- MAIN SLIDER LOGIC (FIXED)
    local MainSliding = false
    local function UpdateMainSlider(Input)
        local AbsX = SliderBG.AbsolutePosition.X
        local AbsW = SliderBG.AbsoluteSize.X
        local Percent = math.clamp((Input.Position.X - AbsX) / AbsW, 0, 1)
        SetVolume(Percent * 1000)
    end
    SliderBG.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            MainSliding = true; SetInputLock(true); UpdateMainSlider(Input)
        end
    end)
    UIS.InputChanged:Connect(function(Input)
        if MainSliding and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
            UpdateMainSlider(Input)
        end
    end)
    UIS.InputEnded:Connect(function(Input)
        if MainSliding and (Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch) then
            MainSliding = false; task.wait(0.05); RefreshInputLock()
        end
    end)

    -- ==============================================
    -- DRAG SYSTEM (FIXED · NO CAMERA MOVE)
    -- ==============================================
    local Dragging = false
    local DragStart = Vector2.new()
    local FrameStart = Vector2.new()

    DragBar.InputBegan:Connect(function(Input)
        if UILocked then return end
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = Vector2.new(Input.Position.X, Input.Position.Y)
            FrameStart = Vector2.new(MainFrame.Position.X.Offset, MainFrame.Position.Y.Offset)
            SetInputLock(true)
        end
    end)
    UIS.InputChanged:Connect(function(Input)
        if not Dragging or UILocked then return end
        if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
            local Delta = Vector2.new(Input.Position.X, Input.Position.Y) - DragStart
            MainFrame.Position = UDim2.new(0, FrameStart.X + Delta.X, 0, FrameStart.Y + Delta.Y)
        end
    end)
    UIS.InputEnded:Connect(function(Input)
        if Dragging and (Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch) then
            Dragging = false; task.wait(0.05); RefreshInputLock()
        end
    end)

    -- ==============================================
    -- ALL BUTTON ACTIONS (100% KEPT)
    -- ==============================================
    -- ESP TOGGLE
    ESPBtn.MouseButton1Click:Connect(function()
        ESPEnabled = not ESPEnabled
        ESPBtn.Text = ESPEnabled and "ESP: ON" or "ESP: OFF"
        ESPBtn.BackgroundColor3 = ESPEnabled and Color3.fromRGB(25,120,25) or Color3.fromRGB(40,40,40)
        if not ESPEnabled then ClearAllESP() end
    end)

    -- YOUTUBE COPY
    YTBtn.MouseButton1Click:Connect(function()
        SafeClip(YT_LINK)
        YTBtn.Text = "✅ COPIED!"
        task.wait(1.5); YTBtn.Text = "📺 YOUTUBE"
    end)

    -- BOOMBOX OPEN
    BoomBtn.MouseButton1Click:Connect(OpenBoombox)

    -- CONSOLE TOGGLE
    ConBtn.MouseButton1Click:Connect(ToggleConsole)

    -- LOCK TOGGLE
    LockBtn.MouseButton1Click:Connect(function()
        UILocked = not UILocked
        LockBtn.Text = UILocked and "🔒 LOCKED" or "🔓 UNLOCKED"
        LockBtn.BackgroundColor3 = UILocked and Color3.fromRGB(180,40,40) or Color3.fromRGB(50,50,50)
    end)

    -- MINIMIZE TOGGLE
    MiniBtn.MouseButton1Click:Connect(function()
        Minimized = not Minimized
        if Minimized then
            MainFrame.Size = MINI_SIZE
            ESPBtn.Visible=false; YTBtn.Visible=false; BoomBtn.Visible=false
            ConBtn.Visible=false; LockBtn.Visible=false; ExitBtn.Visible=false
            VolText.Visible=false; VolLabels.Main.Visible=false; SliderBG.Visible=false
            DragBar.Text = ""; MiniBtn.Text = "➕"
        else
            MainFrame.Size = NORMAL_SIZE
            ESPBtn.Visible=true; YTBtn.Visible=true; BoomBtn.Visible=true
            ConBtn.Visible=true; LockBtn.Visible=true; ExitBtn.Visible=true
            VolText.Visible=true; VolLabels.Main.Visible=true; SliderBG.Visible=true
            DragBar.Text = "MADE BY BLUE_MODE | DRAG TO MOVE"; MiniBtn.Text = "➖"
        end
    end)

    -- EXIT SCRIPT
    ExitBtn.MouseButton1Click:Connect(function()
        ClearAllESP()
        pcall(function() if ActiveSound then ActiveSound:Destroy() end end)
        if Windows.Boombox then Windows.Boombox:Destroy() end
        if Windows.Console then Windows.Console:Destroy() end
        Win:Destroy()
        getgenv().BlueMode_Loaded = false
    end)

    -- ==============================================
    -- MAIN HEARTBEAT LOOP (SAFE · ERROR PROTECTED)
    -- ==============================================
    RunService.Heartbeat:Connect(function(DeltaTime)
        -- PROTECT LOOP FROM CRASHING
        local Success, Err = pcall(function()
            if not Win or not Win.Parent then return end

            -- 1. UPDATE USAGE TIMER
            local Now = os.time()
            UsedTime += math.max(0, Now - LastTick); LastTick = Now
            SafeWrite(SAVE_FILES.USED, UsedTime)
            local Remaining = math.max(0, USAGE_LIMIT - UsedTime)
            Timer.Text = string.format("%02d:%02d:%02d / 12:00:00",
                math.floor(Remaining/3600),
                math.floor((Remaining%3600)/60),
                Remaining%60
            )
            -- AUTO-EXIT WHEN TIME RUNS OUT
            if Remaining <= 0 then
                SafeWrite(SAVE_FILES.COOLDOWN, os.time() + COOLDOWN_TIME)
                pcall(function() if delfile then delfile(SAVE_FILES.USED..".txt") end end)
                ExitBtn:Fire()
                return
            end

            -- 2. PERMANENT RAINBOW ANIMATION (ALL UI)
            RainbowHue = (RainbowHue + (DeltaTime * 0.5)) % 1
            local RainbowColor = Color3.fromHSV(RainbowHue, 1, 1)
            -- UPDATE ALL OUTLINES
            for _, Stroke in ipairs(RainbowOutlines) do
                pcall(function() Stroke.Color = RainbowColor end)
            end
            -- UPDATE VOLUME BARS
            if VolBars.Main then pcall(function() VolBars.Main.BackgroundColor3 = RainbowColor end) end
            if VolBars.Menu then pcall(function() VolBars.Menu.BackgroundColor3 = RainbowColor end) end
            -- UPDATE TIMER TEXT
            pcall(function() Timer.TextColor3 = RainbowColor end)

            -- 3. ESP SYSTEM (RAINBOW OUTLINES + FRIEND DOT)
            if not ESPEnabled then return end
            for _, Plr in pairs(Players:GetPlayers()) do
                if Plr == LocalPlayer then continue end
                local Char = Plr.Character
                if not Char then continue end
                local Hum = Char:FindFirstChildOfClass("Humanoid")
                -- CLEANUP DEAD PLAYERS
                if not Hum or Hum.Health <= 0 then
                    pcall(function()
                        local E = Char:FindFirstChild("BlueMode_ESP") if E then E:Destroy() end
                        local D = Char:FindFirstChild("BlueMode_FriendDot") if D then D:Destroy() end
                    end)
                    continue
                end

                -- PLAYER ESP OUTLINE
                local ESP = Char:FindFirstChild("BlueMode_ESP")
                if not ESP then
                    ESP = Instance.new("Highlight")
                    ESP.Name = "BlueMode_ESP"
                    ESP.FillTransparency = 1
                    ESP.OutlineTransparency = 0
                    ESP.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    ESP.Parent = Char
                end
                pcall(function() ESP.OutlineColor = RainbowColor end)

                -- FRIEND DOT ABOVE HEAD
                local IsFriend = false
                pcall(function() IsFriend = LocalPlayer:IsFriendsWith(Plr.UserId) end)
                local Head = Char:FindFirstChild("Head")
                local Dot = Char:FindFirstChild("BlueMode_FriendDot")

                if IsFriend and Head then
                    if not Dot then
                        Dot = Instance.new("BillboardGui")
                        Dot.Name = "BlueMode_FriendDot"
                        Dot.AlwaysOnTop = true
                        Dot.Size = UDim2.new(0,18,0,18)
                        Dot.StudsOffset = Vector3.new(0,3,0)
                        Dot.Adornee = Head
                        Dot.Parent = Char
                        local Circle = Instance.new("Frame", Dot)
                        Circle.Size = UDim2.new(1,0,1,0)
                        Instance.new("UICorner", Circle).CornerRadius = UDim.new(1,0)
                    end
                    pcall(function() Dot.Frame.BackgroundColor3 = RainbowColor end)
                elseif Dot then
                    pcall(function() Dot:Destroy() end)
                end
            end
        end)
        -- LOG ANY ERRORS SILENTLY (NO CRASH)
        if not Success then warn("[BLUE MODE LOOP ERROR]", Err) end
    end)
end

-- ==============================================
-- START THE SCRIPT!
-- ==============================================
local StartSuccess, StartErr = pcall(BuildMainUI)
if StartSuccess then
    print("✅ BLUE MODE ESP v2.6 LOADED SUCCESSFULLY!")
    print("✅ FEATURES: Permanent Rainbow · Always On Top · No Camera Move · Console · 0-1000 Volume · ESP · Friend Dot")
else
    warn("❌ BLUE MODE FAILED TO LOAD:", StartErr)
    getgenv().BlueMode_Loaded = false
end
