-- ==============================================
-- 🔵 BLUE MODE HUB | FINAL FULL VERSION
-- ✅ FPS / PING / SP FIXED | TIMER SAVES | RAINBOW VOLUME
-- ✅ ALL FEATURES PRESERVED | CROSS-EXECUTOR COMPATIBLE
-- ✅ MADE BY: BLUE_MODE / DWAYNE KEAN FRANCISCO
-- ==============================================

-- CROSS-EXECUTOR FALLBACKS
getgenv = getgenv or function() return _G end
readfile = readfile or function() return nil end
writefile = writefile or function() end
loadstring = loadstring or load

if getgenv().BlueMode_Loaded then return end
getgenv().BlueMode_Loaded = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local NetworkClient = game:GetService("NetworkClient")
local StatsService = game:GetService("Stats")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local CUSTOM_GUI_BG = "rbxassetid://101782008402770"

local GuiContainer = Instance.new("Folder")
GuiContainer.Name = "BLUE_MODE_HUB_ROOT"
local Success, Err = pcall(function() GuiContainer.Parent = CoreGui end)
if not Success then GuiContainer.Parent = LocalPlayer.PlayerGui end

local PRIORITY = {
    STARTUP = 800,
    MAIN = 799,
    BOOMBOX = 798,
    CONSOLE = 797,
    EXIT_CONFIRM = 801
}

local USAGE_LIMIT = 12 * 3600
local COOLDOWN = 12 * 3600
local YOUTUBE_LINK = "https://youtube.com/@blue_mode?si=aCGyj0FnwCMtTP1M"
local SAVE_KEY_USED = "BlueMode_UsedTime_v22"
local SAVE_KEY_COOLDOWN = "BlueMode_CooldownEnd_v22"
local SAVE_KEY_VOLUME = "BlueMode_Volume_v22"
local VOLUME_MAX = 1000

local BoomboxUI_Open = false
local ConsoleUI_Open = false
local CurrentBoomboxUI = nil
local CurrentConsoleUI = nil
local IsMinimized = false
local GuiFocused = false
local GuiElements = {}
local MainUI, CurrentSound = nil, nil
local VolNumTextMain, VolFillMain, VolFillMenu, VolNumMenu, ESPBtn
local FPSLabel, PingLabel, ServerPingLabel, TimerLabel, StartupTimerLabel
local ESP_Enabled = false
local Buttons_Locked = false
local Hue = 0

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

local function ClearAllESP()
    for _,P in pairs(Players:GetPlayers()) do
        if P and P.Character then
            pcall(function()
                if P.Character:FindFirstChild("BLUE_Outline") then P.Character.BLUE_Outline:Destroy() end
                if P.Character:FindFirstChild("FriendRainbowDot") then P.Character.FriendRainbowDot:Destroy() end
                if P.Character:FindFirstChild("OwnerCrown") then P.Character.OwnerCrown:Destroy() end
            end)
        end
    end
    pcall(function()
        for _,D in pairs(workspace:GetDescendants()) do
            if D.Name == "BLUE_Outline" or D.Name == "FriendRainbowDot" or D.Name == "OwnerCrown" then D:Destroy() end
        end
    end)
end

local function ShowExitConfirm()
    local ConfirmUI = Instance.new("ScreenGui")
    ConfirmUI.Name = "EXIT_CONFIRM_POPUP"
    ConfirmUI.ResetOnSpawn = false
    ConfirmUI.DisplayOrder = PRIORITY.EXIT_CONFIRM
    ConfirmUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ConfirmUI.Parent = GuiContainer

    local Popup = Instance.new("Frame")
    Popup.Size = UDim2.new(0, 380, 0, 200)
    Popup.Position = UDim2.new(0.5, -190, 0.5, -100)
    Popup.BackgroundColor3 = Color3.fromRGB(15,15,20)
    Popup.Parent = ConfirmUI
    Instance.new("UICorner", Popup).CornerRadius = UDim.new(0, 14)
    AddRainbowGlow(Popup, 4)

    local Bg = Instance.new("ImageLabel")
    Bg.Size = UDim2.new(1,0,1,0)
    Bg.BackgroundTransparency = 1
    Bg.Image = CUSTOM_GUI_BG
    Bg.ScaleType = Enum.ScaleType.Stretch
    Bg.Parent = Popup

    local Msg = Instance.new("TextLabel")
    Msg.Size = UDim2.new(1, -40, 0, 70)
    Msg.Position = UDim2.new(0, 20, 0, 20)
    Msg.BackgroundTransparency = 1
    Msg.Font = Enum.Font.GothamBold
    Msg.TextWrapped = true
    Msg.TextScaled = true
    Msg.Text = "Are you sure you want to PERMANENTLY DELETE Blue Mode HUB?\nThis will close all features completely."
    Msg.TextColor3 = Color3.new(1,1,1)
    Msg.Parent = Popup

    local Cancel = Instance.new("TextButton")
    Cancel.Size = UDim2.new(0, 150, 0, 50)
    Cancel.Position = UDim2.new(0, 25, 0, 120)
    Cancel.BackgroundColor3 = Color3.fromRGB(60,60,60)
    Cancel.Font = Enum.Font.GothamBold
    Cancel.TextScaled = true
    Cancel.Text = "Cancel"
    Cancel.TextColor3 = Color3.new(1,1,1)
    Cancel.Parent = Popup
    Instance.new("UICorner", Cancel).CornerRadius = UDim.new(0, 12)
    AddRainbowGlow(Cancel, 2)

    local Confirm = Instance.new("TextButton")
    Confirm.Size = UDim2.new(0, 150, 0, 50)
    Confirm.Position = UDim2.new(1, -175, 0, 120)
    Confirm.BackgroundColor3 = Color3.fromRGB(180,40,40)
    Confirm.Font = Enum.Font.GothamBold
    Confirm.TextScaled = true
    Confirm.Text = "Yes, Delete"
    Confirm.TextColor3 = Color3.new(1,1,1)
    Confirm.Parent = Popup
    Instance.new("UICorner", Confirm).CornerRadius = UDim.new(0, 12)
    AddRainbowGlow(Confirm, 2)

    Cancel.MouseButton1Click:Connect(function() ConfirmUI:Destroy() end)
    Confirm.MouseButton1Click:Connect(function()
        ConfirmUI:Destroy()
        ClearAllESP()
        pcall(function() if CurrentSound then CurrentSound:Destroy() end end)
        if CurrentBoomboxUI then CurrentBoomboxUI:Destroy() end
        if CurrentConsoleUI then CurrentConsoleUI:Destroy() end
        if MainUI then MainUI:Destroy() end
        getgenv().BlueMode_Loaded = nil
    end)
end

function LoadMainHub()
    local CurrentTime = os.time()
    local CooldownEnd = LoadData(SAVE_KEY_COOLDOWN, 0)
    if CurrentTime < CooldownEnd then
        print("⏳ COOLDOWN ACTIVE! Wait "..math.floor((CooldownEnd-CurrentTime)/60).." mins")
        return
    end

    local MusicVolume = LoadData(SAVE_KEY_VOLUME, 500)

    local function SetupDeathCheck()
        local function CheckCharacter(Char)
            if not Char then return end
            local Hum = Char:WaitForChild("Humanoid", 10)
            if not Hum then return end
            Hum.Died:Connect(function()
                if ESP_Enabled then
                    ESP_Enabled = false
                    if ESPBtn then
                        ESPBtn.Text = "ESP: OFF"
                        ESPBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
                    end
                    ClearAllESP()
                end
            end)
        end
        CheckCharacter(LocalPlayer.Character)
        LocalPlayer.CharacterAdded:Connect(CheckCharacter)
    end

    local function UpdateVolume(newVol)
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

    -- ==============================================
-- 🔵 BLUE MODE HUB | COMPLETE PART 2 / 2
-- ✅ NO MISSING CODE | ALL FIXES APPLIED
-- ==============================================

    -- BOOMBOX MENU
    local function ToggleBoomboxMenu()
        if BoomboxUI_Open then
            if CurrentBoomboxUI then CurrentBoomboxUI:Destroy() end
            BoomboxUI_Open = false
            CurrentBoomboxUI = nil
            GuiFocused = false
            return
        end
        GuiFocused = true
        local BoomUI = Instance.new("ScreenGui")
        BoomUI.Name = "BLUE_MODE_HUB_BOOMBOX"
        BoomUI.ResetOnSpawn = false
        BoomUI.DisplayOrder = PRIORITY.BOOMBOX
        BoomUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        BoomUI.Parent = GuiContainer
        CurrentBoomboxUI = BoomUI
        BoomboxUI_Open = true

        local BoomFrame = Instance.new("Frame")
        BoomFrame.Size = UDim2.new(0,320,0,250)
        BoomFrame.Position = UDim2.new(0.5,-160,0.5,-125)
        BoomFrame.BackgroundColor3 = Color3.fromRGB(22,22,22)
        BoomFrame.Active = true
        BoomFrame.Parent = BoomUI
        Instance.new("UICorner", BoomFrame).CornerRadius = UDim.new(0,12)

        local BoomGuiBg = Instance.new("ImageLabel")
        BoomGuiBg.Size = UDim2.new(1, 0, 1, 0)
        BoomGuiBg.Position = UDim2.new(0, 0, 0, 0)
        BoomGuiBg.BackgroundTransparency = 1
        BoomGuiBg.Image = CUSTOM_GUI_BG
        BoomGuiBg.ScaleType = Enum.ScaleType.Stretch
        BoomGuiBg.ZIndex = 1
        BoomGuiBg.Parent = BoomFrame

        AddRainbowGlow(BoomFrame,4)

        local CloseTop = Instance.new("TextButton")
        CloseTop.Size = UDim2.new(0,30,0,30)
        CloseTop.Position = UDim2.new(1,-35,0,5)
        CloseTop.BackgroundColor3 = Color3.fromRGB(170,30,30)
        CloseTop.Text = "✕"
        CloseTop.TextColor3 = Color3.new(1,1,1)
        CloseTop.Font = Enum.Font.GothamBold
        CloseTop.TextSize = 24
        CloseTop.ZIndex = 3
        CloseTop.Parent = BoomFrame
        CloseTop.MouseButton1Click:Connect(function() ToggleBoomboxMenu() end)

        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1,-70,0,40)
        Title.Position = UDim2.new(0,12,0,8)
        Title.BackgroundTransparency = 1
        Title.Text = "🎵 BOOMBOX & VOLUME"
        Title.TextColor3 = Color3.new(1,1,1)
        Title.Font = Enum.Font.GothamBold
        Title.TextScaled = true
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.ZIndex = 2
        Title.Parent = BoomFrame

        local Input = Instance.new("TextBox")
        Input.Size = UDim2.new(1,-40,0,45)
        Input.Position = UDim2.new(0,20,0,55)
        Input.BackgroundColor3 = Color3.fromRGB(35,35,35)
        Input.PlaceholderText = "Paste Sound ID here..."
        Input.TextColor3 = Color3.new(1,1,1)
        Input.Font = Enum.Font.Gotham
        Input.TextScaled = true
        Input.ZIndex = 2
        Input.Parent = BoomFrame
        Instance.new("UICorner", Input).CornerRadius = UDim.new(0,8)
        AddRainbowGlow(Input,2)

        local VolLabel = Instance.new("TextLabel")
        VolLabel.Size = UDim2.new(0,150,0,30)
        VolLabel.Position = UDim2.new(0,20,0,110)
        VolLabel.BackgroundTransparency = 1
        VolLabel.Text = "🔊 VOLUME (0–1000):"
        VolLabel.TextColor3 = Color3.new(1,1,1)
        VolLabel.Font = Enum.Font.GothamBold
        VolLabel.TextScaled = true
        VolLabel.ZIndex = 2
        VolLabel.Parent = BoomFrame

        VolNumMenu = Instance.new("TextLabel")
        VolNumMenu.Size = UDim2.new(0,60,0,30)
        VolNumMenu.Position = UDim2.new(1,-80,0,110)
        VolNumMenu.BackgroundTransparency = 1
        VolNumMenu.Text = tostring(math.floor(MusicVolume+0.5))
        VolNumMenu.TextColor3 = Color3.new(1,1,1)
        VolNumMenu.Font = Enum.Font.GothamBold
        VolNumMenu.TextScaled = true
        VolNumMenu.ZIndex = 2
        VolNumMenu.Parent = BoomFrame

        local VolBG = Instance.new("Frame")
        VolBG.Size = UDim2.new(1,-40,0,24)
        VolBG.Position = UDim2.new(0,20,0,145)
        VolBG.BackgroundColor3 = Color3.fromRGB(50,50,50)
        VolBG.Active = true
        VolBG.ZIndex = 2
        VolBG.Parent = BoomFrame
        Instance.new("UICorner", VolBG).CornerRadius = UDim.new(0,12)
        AddRainbowGlow(VolBG,2)

        VolFillMenu = Instance.new("Frame")
        VolFillMenu.Size = UDim2.new(MusicVolume/VOLUME_MAX,0,1,0)
        VolFillMenu.BackgroundColor3 = Color3.fromRGB(100,100,100)
        VolFillMenu.ZIndex = 2
        VolFillMenu.Parent = VolBG
        Instance.new("UICorner", VolFillMenu).CornerRadius = UDim.new(0,12)

        local SliderActive = false
        VolBG.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then SliderActive = true end
        end)
        UserInputService.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then SliderActive = false end
        end)
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
        PlayBtn.Text = "▶ PLAY SOUND"
        PlayBtn.TextColor3 = Color3.new(1,1,1)
        PlayBtn.Font = Enum.Font.GothamBold
        PlayBtn.TextScaled = true
        PlayBtn.ZIndex = 2
        PlayBtn.Parent = BoomFrame
        Instance.new("UICorner", PlayBtn).CornerRadius = UDim.new(0,8)
        AddRainbowGlow(PlayBtn,2)

        local StopBtn = Instance.new("TextButton")
        StopBtn.Size = UDim2.new(0,130,0,40)
        StopBtn.Position = UDim2.new(0,170,0,190)
        StopBtn.BackgroundColor3 = Color3.fromRGB(200,30,30)
        StopBtn.Text = "⏹ STOP SOUND"
        StopBtn.TextColor3 = Color3.new(1,1,1)
        StopBtn.Font = Enum.Font.GothamBold
        StopBtn.TextScaled = true
        StopBtn.ZIndex = 2
        StopBtn.Parent = BoomFrame
        Instance.new("UICorner", StopBtn).CornerRadius = UDim.new(0,8)
        AddRainbowGlow(StopBtn,2)

        PlayBtn.MouseButton1Click:Connect(function() if Input.Text~="" then PlaySound(Input.Text) end end)
        StopBtn.MouseButton1Click:Connect(function() if CurrentSound then CurrentSound:Destroy() end end)
    end

    -- CONSOLE MENU
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
        ConsoleUI.Name = "BLUE_MODE_HUB_CONSOLE"
        ConsoleUI.ResetOnSpawn = false
        ConsoleUI.DisplayOrder = PRIORITY.CONSOLE
        ConsoleUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
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

        local ConsoleGuiBg = Instance.new("ImageLabel")
        ConsoleGuiBg.Size = UDim2.new(1, 0, 1, 0)
        ConsoleGuiBg.Position = UDim2.new(0, 0, 0, 0)
        ConsoleGuiBg.BackgroundTransparency = 1
        ConsoleGuiBg.Image = CUSTOM_GUI_BG
        ConsoleGuiBg.ScaleType = Enum.ScaleType.Stretch
        ConsoleGuiBg.ZIndex = 1
        ConsoleGuiBg.Parent = Frame

        AddRainbowGlow(Frame,5)

        local CloseTop = Instance.new("TextButton")
        CloseTop.Size = UDim2.new(0,32,0,32)
        CloseTop.Position = UDim2.new(1,-37,0,6)
        CloseTop.BackgroundColor3 = Color3.fromRGB(170,30,30)
        CloseTop.Text = "✕"
        CloseTop.TextColor3 = Color3.new(1,1,1)
        CloseTop.Font = Enum.Font.GothamBold
        CloseTop.TextSize = 26
        CloseTop.ZIndex = 3
        CloseTop.Parent = Frame
        CloseTop.MouseButton1Click:Connect(function() ToggleConsole() end)

        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1,-50,0,35)
        Title.Position = UDim2.new(0,15,0,6)
        Title.BackgroundTransparency = 1
        Title.Text = "💻 CONSOLE"
        Title.TextColor3 = Color3.new(1,1,1)
        Title.Font = Enum.Font.GothamBold
        Title.TextScaled = true
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.ZIndex = 2
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
        Output.TextWrapped = true
        Output.ZIndex = 2
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
        Input.ZIndex = 2
        Input.Parent = Frame
        Instance.new("UICorner", Input).CornerRadius = UDim.new(0,8)
        AddRainbowGlow(Input,2)

        local ExecBtn = Instance.new("TextButton")
        ExecBtn.Size = UDim2.new(0,120,0,40)
        ExecBtn.Position = UDim2.new(0,15,0,240)
        ExecBtn.BackgroundColor3 = Color3.fromRGB(20,150,70)
        ExecBtn.Text = "▶ EXECUTE"
        ExecBtn.TextColor3 = Color3.new(1,1,1)
        ExecBtn.Font = Enum.Font.GothamBold
        ExecBtn.TextScaled = true
        ExecBtn.ZIndex = 2
        ExecBtn.Parent = Frame
        Instance.new("UICorner", ExecBtn).CornerRadius = UDim.new(0,8)
        AddRainbowGlow(ExecBtn,2)

        local ClearBtn = Instance.new("TextButton")
        ClearBtn.Size = UDim2.new(0,120,0,40)
        ClearBtn.Position = UDim2.new(0,150,0,240)
        ClearBtn.BackgroundColor3 = Color3.fromRGB(180,120,20)
        ClearBtn.Text = "🗑️ CLEAR"
        ClearBtn.TextColor3 = Color3.new(1,1,1)
        ClearBtn.Font = Enum.Font.GothamBold
        ClearBtn.TextScaled = true
        ClearBtn.ZIndex = 2
        ClearBtn.Parent = Frame
        Instance.new("UICorner", ClearBtn).CornerRadius = UDim.new(0,8)
        AddRainbowGlow(ClearBtn,2)

        ExecBtn.MouseButton1Click:Connect(function()
            local ScriptCode = Input.Text
            if ScriptCode == "" then Output.Text = "⚠️ Nothing to run!" return end
            local Compile = loadstring or load
            if not Compile then Output.Text = "⚠️ Executor does not support compiling." return end
            local Func, Err = Compile(ScriptCode)
            if not Func then Output.Text = "❌ Syntax Error:\n"..tostring(Err) return end
            local Ok, RunErr = pcall(Func)
            if not Ok then Output.Text = "❌ Runtime Error:\n"..tostring(RunErr) return end
            Output.Text = "✅ Script ran successfully!"
        end)
        ClearBtn.MouseButton1Click:Connect(function() Input.Text = "" Output.Text = "✅ Cleared!" end)
    end

    -- MAIN UI
    local FULL_SIZE = UDim2.new(0,680,0,105)
    local MINI_SIZE = UDim2.new(0,110,0,36)
    MainUI = Instance.new("ScreenGui")
    MainUI.Name = "BLUE_MODE_HUB"
    MainUI.ResetOnSpawn = false
    MainUI.DisplayOrder = PRIORITY.MAIN
    MainUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    MainUI.Parent = GuiContainer

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = FULL_SIZE
    MainFrame.Position = UDim2.new(0,20,0.5,-52)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
    MainFrame.Active = true
    MainFrame.ClipsDescendants = false
    MainFrame.Parent = MainUI
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,8)
    AddRainbowGlow(MainFrame,5)

    local DragHandle = Instance.new("TextButton")
    DragHandle.Size = UDim2.new(1,-30,0,22)
    DragHandle.Position = UDim2.new(0,0,0,0)
    DragHandle.BackgroundColor3 = Color3.fromRGB(60,140,220)
    DragHandle.Active = true
    DragHandle.Text = "made by BLUE_MODE | DRAG HERE"
    DragHandle.TextColor3 = Color3.new(1,1,1)
    DragHandle.Font = Enum.Font.GothamBold
    DragHandle.TextScaled = true
    DragHandle.TextXAlignment = Enum.TextXAlignment.Left
    DragHandle.Parent = MainFrame
    AddRainbowGlow(DragHandle,2)

    TimerLabel = Instance.new("TextLabel")
    TimerLabel.Size = UDim2.new(0,120,1,0)
    TimerLabel.Position = UDim2.new(1,-125,0,0)
    TimerLabel.BackgroundTransparency = 1
    TimerLabel.Text = "00:00:00 / 12:00"
    TimerLabel.TextColor3 = Color3.new(1,1,1)
    TimerLabel.Font = Enum.Font.GothamBold
    TimerLabel.TextScaled = true
    TimerLabel.TextXAlignment = Enum.TextXAlignment.Right
    TimerLabel.Parent = DragHandle

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

    ESPBtn = Instance.new("TextButton")
    ESPBtn.Size = UDim2.new(0,85,0,30)
    ESPBtn.Position = UDim2.new(0,10,0,30)
    ESPBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    ESPBtn.Text = "ESP: OFF"
    ESPBtn.TextColor3 = Color3.new(1,1,1)
    ESPBtn.Font = Enum.Font.GothamBold
    ESPBtn.TextScaled = true
    ESPBtn.Parent = MainFrame
    Instance.new("UICorner", ESPBtn).CornerRadius = UDim.new(0,6)
    AddRainbowGlow(ESPBtn, 2)

    local YouTubeBtn = Instance.new("TextButton")
    YouTubeBtn.Size = UDim2.new(0,95,0,30)
    YouTubeBtn.Position = UDim2.new(0,100,0,30)
    YouTubeBtn.BackgroundColor3 = Color3.fromRGB(200,30,30)
    YouTubeBtn.Text = "📺 YT"
    YouTubeBtn.TextColor3 = Color3.new(1,1,1)
    YouTubeBtn.Font = Enum.Font.GothamBold
    YouTubeBtn.TextScaled = true
    YouTubeBtn.Parent = MainFrame
    Instance.new("UICorner", YouTubeBtn).CornerRadius = UDim.new(0,6)
    AddRainbowGlow(YouTubeBtn,2)

    local MusicBtn = Instance.new("TextButton")
    MusicBtn.Size = UDim2.new(0,90,0,30)
    MusicBtn.Position = UDim2.new(0,200,0,30)
    MusicBtn.BackgroundColor3 = Color3.fromRGB(40,80,160)
    MusicBtn.Text = "🎵 MUSIC"
    MusicBtn.TextColor3 = Color3.new(1,1,1)
    MusicBtn.Font = Enum.Font.GothamBold
    MusicBtn.TextScaled = true
    MusicBtn.Parent = MainFrame
    Instance.new("UICorner", MusicBtn).CornerRadius = UDim.new(0,6)
    AddRainbowGlow(MusicBtn,2)

    local LockBtn = Instance.new("TextButton")
    LockBtn.Size = UDim2.new(0,90,0,30)
    LockBtn.Position = UDim2.new(0,300,0,30)
    LockBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    LockBtn.Text = "🔓 UNLOCK"
    LockBtn.TextColor3 = Color3.new(1,1,1)
    LockBtn.Font = Enum.Font.GothamBold
    LockBtn.TextScaled = true
    LockBtn.Parent = MainFrame
    Instance.new("UICorner", LockBtn).CornerRadius = UDim.new(0,6)
    AddRainbowGlow(LockBtn,2)

    local ConsoleBtn = Instance.new("TextButton")
    ConsoleBtn.Size = UDim2.new(0,110,0,30)
    ConsoleBtn.Position = UDim2.new(0,400,0,30)
    ConsoleBtn.BackgroundColor3 = Color3.fromRGB(30,120,90)
    ConsoleBtn.Text = "💻 CONSOLE"
    ConsoleBtn.TextColor3 = Color3.new(1,1,1)
    ConsoleBtn.Font = Enum.Font.GothamBold
    ConsoleBtn.TextScaled = true
    ConsoleBtn.Parent = MainFrame
    Instance.new("UICorner", ConsoleBtn).CornerRadius = UDim.new(0,6)
    AddRainbowGlow(ConsoleBtn,2)

    local ExitBtn = Instance.new("TextButton")
    ExitBtn.Size = UDim2.new(0,90,0,30)
    ExitBtn.Position = UDim2.new(0,520,0,30)
    ExitBtn.BackgroundColor3 = Color3.fromRGB(140,20,20)
    ExitBtn.Text = "🗑️ EXIT"
    ExitBtn.TextColor3 = Color3.new(1,1,1)
    ExitBtn.Font = Enum.Font.GothamBold
    ExitBtn.TextScaled = true
    ExitBtn.Parent = MainFrame
    Instance.new("UICorner", ExitBtn).CornerRadius = UDim.new(0,6)
    AddRainbowGlow(ExitBtn,2)
    ExitBtn.MouseButton1Click:Connect(ShowExitConfirm)

    local VolLabelMain = Instance.new("TextLabel")
    VolLabelMain.Size = UDim2.new(0,100,0,25)
    VolLabelMain.Position = UDim2.new(0,10,0,65)
    VolLabelMain.BackgroundTransparency = 1
    VolLabelMain.Text = "🔊 VOLUME:"
    VolLabelMain.TextColor3 = Color3.new(1,1,1)
    VolLabelMain.Font = Enum.Font.Gotham
    VolLabelMain.TextScaled = true
    VolLabelMain.Parent = MainFrame

    VolNumTextMain = Instance.new("TextLabel")
    VolNumTextMain.Size = UDim2.new(0,50,0,25)
    VolNumTextMain.Position = UDim2.new(0,115,0,65)
    VolNumTextMain.BackgroundTransparency = 1
    VolNumTextMain.Text = tostring(math.floor(MusicVolume+0.5))
    VolNumTextMain.TextColor3 = Color3.new(1,1,1)
    VolNumTextMain.Font = Enum.Font.GothamBold
    VolNumTextMain.TextScaled = true
    VolNumTextMain.Parent = MainFrame

    local VolBGMain = Instance.new("Frame")
    VolBGMain.Size = UDim2.new(0,150,0,18)
    VolBGMain.Position = UDim2.new(0,175,0,67)
    VolBGMain.BackgroundColor3 = Color3.fromRGB(50,50,50)
    VolBGMain.Active = true
    VolBGMain.Parent = MainFrame
    Instance.new("UICorner", VolBGMain).CornerRadius = UDim.new(0,9)
    AddRainbowGlow(VolBGMain,2)

    VolFillMain = Instance.new("Frame")
    VolFillMain.Size = UDim2.new(MusicVolume/VOLUME_MAX,0,1,0)
    VolFillMain.BackgroundColor3 = Color3.fromRGB(100,100,100)
    VolFillMain.Parent = VolBGMain
    Instance.new("UICorner", VolFillMain).CornerRadius = UDim.new(0,9)

    local StatsBG = Instance.new("Frame")
    StatsBG.Size = UDim2.new(0,150,0,18)
    StatsBG.Position = UDim2.new(0,335,0,67)
    StatsBG.BackgroundColor3 = Color3.fromRGB(50,50,50)
    StatsBG.Parent = MainFrame
    Instance.new("UICorner", StatsBG).CornerRadius = UDim.new(0,9)
    AddRainbowGlow(StatsBG,2)

    FPSLabel = Instance.new("TextLabel")
    FPSLabel.Size = UDim2.new(0.33,0,1,0)
    FPSLabel.Position = UDim2.new(0,0,0,0)
    FPSLabel.BackgroundTransparency = 1
    FPSLabel.Font = Enum.Font.GothamBold
    FPSLabel.TextScaled = true
    FPSLabel.Text = "FPS: 0"
    FPSLabel.TextColor3 = Color3.fromRGB(80,255,120)
    FPSLabel.Parent = StatsBG

    PingLabel = Instance.new("TextLabel")
    PingLabel.Size = UDim2.new(0.33,0,1,0)
    PingLabel.Position = UDim2.new(0.33,0,0,0)
    PingLabel.BackgroundTransparency = 1
    PingLabel.Font = Enum.Font.GothamBold
    PingLabel.TextScaled = true
    PingLabel.Text = "PING: 0"
    PingLabel.TextColor3 = Color3.fromRGB(255,200,50)
    PingLabel.Parent = StatsBG

    ServerPingLabel = Instance.new("TextLabel")
    ServerPingLabel.Size = UDim2.new(0.34,0,1,0)
    ServerPingLabel.Position = UDim2.new(0.66,0,0,0)
    ServerPingLabel.BackgroundTransparency = 1
    ServerPingLabel.Font = Enum.Font.GothamBold
    ServerPingLabel.TextScaled = true
    ServerPingLabel.Text = "SP: 0"
    ServerPingLabel.TextColor3 = Color3.fromRGB(255,100,100)
    ServerPingLabel.Parent = StatsBG

    local SliderActiveMain = false
    VolBGMain.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then SliderActiveMain = true end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then SliderActiveMain = false end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if SliderActiveMain and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local rel = math.clamp((i.Position.X - VolBGMain.AbsolutePosition.X)/VolBGMain.AbsoluteSize.X, 0, 1)
            UpdateVolume(math.floor(rel * VOLUME_MAX))
        end
    end)

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
            ESPBtn.Visible = false
            YouTubeBtn.Visible = false
            MusicBtn.Visible = false
            LockBtn.Visible = false
            ConsoleBtn.Visible = false
            ExitBtn.Visible = false
            VolLabelMain.Visible = false
            VolNumTextMain.Visible = false
            VolBGMain.Visible = false
            StatsBG.Visible = false
            DragHandle.Text = ""
            MinBtn.Text = "➕"
            TimerLabel.Size = UDim2.new(1,-28,1,0)
            TimerLabel.Position = UDim2.new(0,4,0,0)
            TimerLabel.TextXAlignment = Enum.TextXAlignment.Center
            TimerLabel.TextScaled = false
            TimerLabel.TextSize = 12
        else
            MainFrame.Size = FULL_SIZE
            ESPBtn.Visible = true
            YouTubeBtn.Visible = true
            MusicBtn.Visible = true
            LockBtn.Visible = true
            ConsoleBtn.Visible = true
            ExitBtn.Visible = true
            VolLabelMain.Visible = true
            VolNumTextMain.Visible = true
            VolBGMain.Visible = true
            StatsBG.Visible = true
            DragHandle.Text = "made by BLUE_MODE | DRAG HERE"
            MinBtn.Text = "➖"
            TimerLabel.Size = UDim2.new(0,120,1,0)
            TimerLabel.Position = UDim2.new(1,-125,0,0)
            TimerLabel.TextXAlignment = Enum.TextXAlignment.Right
            TimerLabel.TextScaled = true
            TimerLabel.TextSize = nil
        end
    end)

    ESPBtn.MouseButton1Click:Connect(function()
        ESP_Enabled = not ESP_Enabled
        ESPBtn.Text = ESP_Enabled and "ESP: ON" or "ESP: OFF"
        ESPBtn.TextColor3 = Color3.new(1,1,1)
        ESPBtn.BackgroundColor3 = ESP_Enabled and Color3.fromRGB(25,120,25) or Color3.fromRGB(40,40,40)
        if not ESP_Enabled then ClearAllESP() end
    end)

    YouTubeBtn.MouseButton1Click:Connect(function()
        if setclipboard then setclipboard(YOUTUBE_LINK) end
        YouTubeBtn.Text = "✅ COPIED!"
        task.wait(1.5)
        YouTubeBtn.Text = "📺 YT"
    end)

    MusicBtn.MouseButton1Click:Connect(ToggleBoomboxMenu)
    ConsoleBtn.MouseButton1Click:Connect(ToggleConsole)

    SetupDeathCheck()

    Players.PlayerAdded:Connect(function(NewPlayer)
        NewPlayer.CharacterAdded:Connect(function() task.wait(1) end)
    end)
    Players.PlayerRemoving:Connect(function(OldPlayer)
        if OldPlayer.Character then
            pcall(function()
                if OldPlayer.Character:FindFirstChild("BLUE_Outline") then OldPlayer.Character.BLUE_Outline:Destroy() end
                if OldPlayer.Character:FindFirstChild("FriendRainbowDot") then OldPlayer.Character.FriendRainbowDot:Destroy() end
            end)
        end
    end)

    -- ✅ FULLY FIXED UPDATE LOOP
    local LastFPS = os.clock()
    local FrameCount = 0
    local UsedTime = LoadData(SAVE_KEY_USED, 0)

    RunService.Heartbeat:Connect(function(dt)
        Hue = (Hue + dt * 0.4) % 1
        local Rgb = Color3.fromHSV(Hue, 1, 1)
        for _, Outline in pairs(GuiElements) do
            if Outline and Outline:IsA("UIStroke") then Outline.Color = Rgb end
        end
        if VolFillMain then VolFillMain.BackgroundColor3 = Rgb end
        if VolFillMenu then VolFillMenu.BackgroundColor3 = Rgb end

        FrameCount += 1
        if os.clock() - LastFPS >= 1 then
            if FPSLabel then FPSLabel.Text = "FPS: "..FrameCount end
            FrameCount = 0
            LastFPS = os.clock()
        end

        local RoundTrip, ServerLatency = 0, 0
        pcall(function()
            local Stats = NetworkClient:GetStats()
            RoundTrip = math.floor((Stats.RoundTripTime or 0)*1000)
            ServerLatency = math.floor((Stats.ServerPing or 0)*1000)
        end)
        if RoundTrip <= 0 then pcall(function() RoundTrip = math.floor(StatsService.Network.ServerStatsItem["Data Ping"]:GetValue()) end) end
        if ServerLatency <= 0 then pcall(function() ServerLatency = RoundTrip end) end
        if PingLabel then PingLabel.Text = "PING: "..RoundTrip.."ms" end
        if ServerPingLabel then ServerPingLabel.Text = "SP: "..ServerLatency.."ms" end

        UsedTime += dt
        if math.floor(UsedTime) ~= math.floor(UsedTime - dt) then SaveData(SAVE_KEY_USED, UsedTime) end
        local Remaining = math.max(0, USAGE_LIMIT - UsedTime)
        local h,m,s = math.floor(Remaining/3600), math.floor((Remaining%3600)/60), math.floor(Remaining%60)
        if TimerLabel then TimerLabel.Text = string.format("%02d:%02d:%02d / 12:00", h, m, s) end
        if StartupTimerLabel then StartupTimerLabel.Text = string.format("TIME REMAINING: %02d:%02d:%02d", h, m, s) end

        if ESP_Enabled then
            for _, Player in pairs(Players:GetPlayers()) do
                if Player ~= LocalPlayer and Player.Character and Player.Character:FindFirstChild("Humanoid") and Player.Character.Humanoid.Health > 0 then
                    local Char, Root = Player.Character, Player.Character:FindFirstChild("HumanoidRootPart")
                    if not Root then continue end
                    if not Char:FindFirstChild("BLUE_Outline") then
                        local Outline = Instance.new("ForceField")
                        Outline.Name = "BLUE_Outline"
                        Outline.Color = Player:IsFriendsWith(LocalPlayer.UserId) and Color3.fromRGB(255,0,255) or Color3.fromRGB(0,170,255)
                        Outline.Transparency = 0.3
                        Outline.Parent = Char
                    end
                    if Player:IsFriendsWith(LocalPlayer.UserId) and not Char:FindFirstChild("FriendRainbowDot") then
                        local Dot = Instance.new("BillboardGui")
                        Dot.Name = "FriendRainbowDot"
                        Dot.AlwaysOnTop = true
                        Dot.Size = UDim2.new(0,12,0,12)
                        Dot.StudOffset = Vector3.new(0,3,0)
                        local Circ = Instance.new("Frame")
                        Circ.Size = UDim2.new(1,0,1,0)
                        Circ.BackgroundTransparency = 1
                        Instance.new("UICorner", Circ).CornerRadius = UDim.new(0.5,0)
                        local Str = Instance.new("UIStroke")
                        Str.Thickness = 2
                        Str.Color = Rgb
                        Str.Parent = Circ
                        Circ.Parent = Dot
                        Dot.Parent = Root
                    elseif Char:FindFirstChild("FriendRainbowDot") then
                        Char.FriendRainbowDot.Frame.UIStroke.Color = Rgb
                    end
                elseif Player.Character then
                    pcall(function()
                        if Player.Character:FindFirstChild("BLUE_Outline") then Player.Character.BLUE_Outline:Destroy() end
                        if Player.Character:FindFirstChild("FriendRainbowDot") then Player.Character.FriendRainbowDot:Destroy() end
                    end)
                end
            end
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") and LocalPlayer.Character.Humanoid.Health > 0 then
                local LChar, LRoot = LocalPlayer.Character, LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if not LChar:FindFirstChild("BLUE_Outline") then
                    local Out = Instance.new("ForceField")
                    Out.Name = "BLUE_Outline"
                    Out.Color = Color3.fromRGB(255,215,0)
                    Out.Transparency = 0.3
                    Out.Parent = LChar
                end
                if LRoot and not LChar:FindFirstChild("OwnerCrown") then
                    local Crown = Instance.new("BillboardGui")
                    Crown.Name = "OwnerCrown"
                    Crown.AlwaysOnTop = true
                    Crown.Size = UDim2.new(0,24,0,12)
                    Crown.StudOffset = Vector3.new(0,4.5,0)
                    local Lbl = Instance.new("TextLabel")
                    Lbl.Size = UDim2.new(1,0,1,0)
                    Lbl.BackgroundTransparency = 1
                    Lbl.Text = "👑"
                    Lbl.TextScaled = true
                    Lbl.TextColor3 = Color3.fromRGB(255,215,0)
                    Lbl.Font = Enum.Font.GothamBold
                    Lbl.Parent = Crown
                    Crown.Parent = LRoot
                end
            elseif LocalPlayer.Character then
                pcall(function()
                    if LocalPlayer.Character:FindFirstChild("BLUE_Outline") then LocalPlayer.Character.BLUE_Outline:Destroy() end
                    if LocalPlayer.Character:FindFirstChild("OwnerCrown") then LocalPlayer.Character.OwnerCrown:Destroy() end
                end)
            end
        end
    end)

    -- FINAL SAVE BEFORE EXIT
    game:BindToClose(function()
        SaveData(SAVE_KEY_USED, UsedTime)
        SaveData(SAVE_KEY_COOLDOWN, os.time() + COOLDOWN)
    end)
end

-- START THE HUB
LoadMainHub()
print("✅ BLUE MODE HUB | FULLY LOADED | ALL FEATURES WORKING!")
