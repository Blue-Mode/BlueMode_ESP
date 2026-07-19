-- 🌈 BLUE MODE HUB UNIVERSAL SCRIPT
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local SoundService = game:GetService("SoundService")

-- State
local HubOpen = false
local HubUI = nil
local CurrentSound = nil
local MusicVolume = 500 -- default mid value

-- Rainbow outline helper
local function AddRainbowGlow(target, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness or 3
    stroke.Parent = target
    return stroke
end

-- Console runner
local function RunConsole(code)
    local func, err = loadstring(code)
    if func then
        local ok, runErr = pcall(func)
        if not ok then warn(runErr) end
    else
        warn(err)
    end
end

local function EnableESP()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local highlight = Instance.new("Highlight")
            highlight.Name = "RainbowESP"
            highlight.FillTransparency = 1
            highlight.OutlineTransparency = 0
            highlight.Parent = plr.Character
        end
    end
end

local function PlayMusic(id)
    if CurrentSound then CurrentSound:Destroy() end
    CurrentSound = Instance.new("Sound")
    CurrentSound.SoundId = "rbxassetid://"..id
    CurrentSound.Looped = true
    CurrentSound.Volume = MusicVolume
    CurrentSound.Parent = SoundService
    CurrentSound:Play()
end

local function StopMusic()
    if CurrentSound then CurrentSound:Stop() end
end

local function UpdateVolume(newVol)
    MusicVolume = math.clamp(newVol, 0, 1000)
    if CurrentSound then CurrentSound.Volume = MusicVolume end
end

local function CreateHub()
    HubUI = Instance.new("ScreenGui")
    HubUI.Name = "BLUE_MODE_HUB"
    HubUI.ResetOnSpawn = false
    HubUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    HubUI.DisplayOrder = 2147483647
    HubUI.Parent = CoreGui

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0,600,0,450)
    Frame.Position = UDim2.new(0.5,-300,0.5,-225)
    Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
    Frame.Parent = HubUI
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0,12)
    AddRainbowGlow(Frame,5)

    local BgImage = Instance.new("ImageLabel")
    BgImage.Size = UDim2.new(1,0,1,0)
    BgImage.BackgroundTransparency = 1
    BgImage.Image = "rbxassetid://YOUR_IMAGE_ID"
    BgImage.ScaleType = Enum.ScaleType.Crop
    BgImage.ZIndex = 0
    BgImage.Parent = Frame

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1,0,0,40)
    Title.Text = "🌈 BLUE MODE HUB"
    Title.TextColor3 = Color3.new(1,1,1)
    Title.Font = Enum.Font.GothamBold
    Title.TextScaled = true
    Title.BackgroundTransparency = 1
    Title.Parent = Frame
    AddRainbowGlow(Title,3)

    local ESPBtn = Instance.new("TextButton")
    ESPBtn.Size = UDim2.new(0,120,0,40)
    ESPBtn.Position = UDim2.new(0,20,0,60)
    ESPBtn.Text = "ESP"
    ESPBtn.Parent = Frame
    AddRainbowGlow(ESPBtn,2)
    ESPBtn.MouseButton1Click:Connect(EnableESP)

    local ConsoleBtn = Instance.new("TextButton")
    ConsoleBtn.Size = UDim2.new(0,120,0,40)
    ConsoleBtn.Position = UDim2.new(0,20,0,110)
    ConsoleBtn.Text = "Console"
    ConsoleBtn.Parent = Frame
    AddRainbowGlow(ConsoleBtn,2)
    ConsoleBtn.MouseButton1Click:Connect(function()
        RunConsole("print('Hello from BLUE MODE HUB console!')")
    end)

    local MusicBtn = Instance.new("TextButton")
    MusicBtn.Size = UDim2.new(0,120,0,40)
    MusicBtn.Position = UDim2.new(0,20,0,160)
    MusicBtn.Text = "Music"
    MusicBtn.Parent = Frame
    AddRainbowGlow(MusicBtn,2)
    MusicBtn.MouseButton1Click:Connect(function()
        PlayMusic("1848354536")
    end)

    local StopBtn = Instance.new("TextButton")
    StopBtn.Size = UDim2.new(0,120,0,40)
    StopBtn.Position = UDim2.new(0,160,0,160)
    StopBtn.Text = "Stop"
    StopBtn.Parent = Frame
    AddRainbowGlow(StopBtn,2)
    StopBtn.MouseButton1Click:Connect(StopMusic)

    local VolLabel = Instance.new("TextLabel")
    VolLabel.Size = UDim2.new(0,120,0,30)
    VolLabel.Position = UDim2.new(0,20,0,210)
    VolLabel.Text = "Volume (0–1000):"
    VolLabel.TextColor3 = Color3.new(1,1,1)
    VolLabel.Font = Enum.Font.GothamBold
    VolLabel.TextScaled = true
    VolLabel.BackgroundTransparency = 1
    VolLabel.Parent = Frame

    local VolBox = Instance.new("TextBox")
    VolBox.Size = UDim2.new(0,120,0,30)
    VolBox.Position = UDim2.new(0,160,0,210)
    VolBox.Text = tostring(MusicVolume)
    VolBox.TextColor3 = Color3.new(1,1,1)
    VolBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
    VolBox.Font = Enum.Font.Code
    VolBox.TextScaled = true
    VolBox.Parent = Frame
    Instance.new("UICorner", VolBox).CornerRadius = UDim.new(0,6)
    AddRainbowGlow(VolBox,2)

    VolBox.FocusLost:Connect(function()
        local val = tonumber(VolBox.Text)
        if val then UpdateVolume(val) end
        VolBox.Text = tostring(MusicVolume)
    end)

    local CommandBtn = Instance.new("TextButton")
    CommandBtn.Size = UDim2.new(0,120,0,40)
    CommandBtn.Position = UDim2.new(0,20,0,260)
    CommandBtn.Text = "Commands"
    CommandBtn.Parent = Frame
    AddRainbowGlow(CommandBtn,2)
    CommandBtn.MouseButton1Click:Connect(function()
        EnableESP()
        print("Fly/InfYield placeholder")
    end)

    local RobotBtn = Instance.new("TextButton")
    RobotBtn.Size = UDim2.new(0,120,0,40)
    RobotBtn.Position = UDim2.new(0,20,0,310)
    RobotBtn.Text = "🤖 AI Helper"
    RobotBtn.Parent = Frame
    AddRainbowGlow(RobotBtn,2)
    RobotBtn.MouseButton1Click:Connect(function()
        print("AI Helper activated")
    end)

    -- Arsenal Button
    local ArsenalBtn = Instance.new("TextButton")
    ArsenalBtn.Size = UDim2.new(0,120,0,40)
    ArsenalBtn.Position = UDim2.new(0,300,0,60)
    ArsenalBtn.Text = "Arsenal"
    ArsenalBtn.Parent = Frame
    AddRainbowGlow(ArsenalBtn,2)
    ArsenalBtn.MouseButton1Click:Connect(function()
        RunConsole("print('Load Arsenal scripts here')")
    end)

    -- Blox Fruits Button
    local BloxBtn = Instance.new("TextButton")
    BloxBtn.Size = UDim2.new(0,120,0,40)
    BloxBtn.Position = UDim2.new(0,300,0,110)
    BloxBtn.Text = "Blox Fruits"
    BloxBtn.Parent = Frame
    AddRainbowGlow(BloxBtn,2)
    BloxBtn.MouseButton1Click:Connect(function()
        RunConsole("print('Load Blox Fruits scripts here')")
    end)

    -- Adopt Me Button
    local AdoptBtn = Instance.new("TextButton")
    AdoptBtn.Size = UDim2.new(0,120,0,40)
    AdoptBtn.Position = UDim2.new(0,300,0,160)
    AdoptBtn.Text = "Adopt Me"
    AdoptBtn.Parent = Frame
    AddRainbowGlow(AdoptBtn,2)
    AdoptBtn.MouseButton1Click:Connect(function()
        RunConsole("print('Load Adopt Me scripts here')")
    end)

    -- Brookhaven Button
    local BrookBtn = Instance.new("TextButton")
    BrookBtn.Size = UDim2.new(0,120,0,40)
    BrookBtn.Position = UDim2.new(0,300,0,210)
    BrookBtn.Text = "Brookhaven"
    BrookBtn.Parent = Frame
    AddRainbowGlow(BrookBtn,2)
    BrookBtn.MouseButton1Click:Connect(function()
        RunConsole("print('Load Brookhaven scripts here')")
    end)

    -- Close Button
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0,80,0,30)
    CloseBtn.Position = UDim2.new(1,-90,0,10)
    CloseBtn.Text = "Close"
    CloseBtn.TextColor3 = Color3.new(1,1,1)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(160,40,40)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextScaled = true
    CloseBtn.Parent = Frame
    AddRainbowGlow(CloseBtn,2)
    CloseBtn.MouseButton1Click:Connect(function()
        HubUI.Enabled = false
    end)

    local DeleteBtn = Instance.new("TextButton")
    DeleteBtn.Size = UDim2.new(0,80,0,30)
    DeleteBtn.Position = UDim2.new(1,-90,0,50)
    DeleteBtn.Text = "Delete"
    DeleteBtn.TextColor3 = Color3.new(1,1,1)
    DeleteBtn.BackgroundColor3 = Color3.fromRGB(200,30,30)
    DeleteBtn.Font = Enum.Font.GothamBold
    DeleteBtn.TextScaled = true
    DeleteBtn.Parent = Frame
    AddRainbowGlow(DeleteBtn,2)
    DeleteBtn.MouseButton1Click:Connect(function()
        HubUI:Destroy()
        HubOpen = false
    end)

    -- Minimize Button
    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.new(0,80,0,30)
    MinBtn.Position = UDim2.new(1,-90,0,90)
    MinBtn.Text = "Minimize"
    MinBtn.TextColor3 = Color3.new(1,1,1)
    MinBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.TextScaled = true
    MinBtn.Parent = Frame
    AddRainbowGlow(MinBtn,2)

    -- Mini Icon when minimized
    local MiniIcon = Instance.new("TextButton")
    MiniIcon.Size = UDim2.new(0,60,0,30)
    MiniIcon.Position = UDim2.new(0,20,0,70)
    MiniIcon.Text = "🔵 HUB"
    MiniIcon.TextColor3 = Color3.new(1,1,1)
    MiniIcon.BackgroundColor3 = Color3.fromRGB(40,40,120)
    MiniIcon.Font = Enum.Font.GothamBold
    MiniIcon.TextScaled = true
    MiniIcon.Visible = false
    MiniIcon.Parent = HubUI
    AddRainbowGlow(MiniIcon,2)

    -- Minimize logic
    MinBtn.MouseButton1Click:Connect(function()
        Frame.Visible = false
        MiniIcon.Visible = true
    end)

    MiniIcon.MouseButton1Click:Connect(function()
        Frame.Visible = true
        MiniIcon.Visible = false
    end)

    -- Make MiniIcon draggable
    local dragging, dragInput, dragStart, startPos
    MiniIcon.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MiniIcon.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    MiniIcon.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MiniIcon.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- Start Button
local StartBtn = Instance.new("TextButton")
StartBtn.Size = UDim2.new(0,160,0,40)
StartBtn.Position = UDim2.new(0,20,0,20)
StartBtn.Text = "Start BLUE MODE HUB"
StartBtn.TextColor3 = Color3.new(1,1,1)
StartBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
StartBtn.Font = Enum.Font.GothamBold
StartBtn.TextScaled = true
StartBtn.Parent = CoreGui
AddRainbowGlow(StartBtn,3)

StartBtn.MouseButton1Click:Connect(function()
    if not HubOpen then
        CreateHub()
        HubOpen = true
    else
        HubUI.Enabled = not HubUI.Enabled
    end
end)

-- Main Button (top of hub)
    local MainBtn = Instance.new("TextButton")
    MainBtn.Size = UDim2.new(0,120,0,40)
    MainBtn.Position = UDim2.new(0,300,0,10)
    MainBtn.Text = "Main"
    MainBtn.TextColor3 = Color3.new(1,1,1)
    MainBtn.BackgroundColor3 = Color3.fromRGB(70,70,150)
    MainBtn.Font = Enum.Font.GothamBold
    MainBtn.TextScaled = true
    MainBtn.Parent = Frame
    AddRainbowGlow(MainBtn,2)

    -- Info Panel
    local InfoFrame = Instance.new("Frame")
    InfoFrame.Size = UDim2.new(0,400,0,200)
    InfoFrame.Position = UDim2.new(0.5,-200,0.5,-100)
    InfoFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
    InfoFrame.Visible = false
    InfoFrame.Parent = HubUI
    Instance.new("UICorner", InfoFrame).CornerRadius = UDim.new(0,12)
    AddRainbowGlow(InfoFrame,3)

    local InfoLabel = Instance.new("TextLabel")
    InfoLabel.Size = UDim2.new(1,0,0,40)
    InfoLabel.Text = "Created by DWAYNE KEAN T FRANCISCO"
    InfoLabel.TextColor3 = Color3.new(1,1,1)
    InfoLabel.Font = Enum.Font.GothamBold
    InfoLabel.TextScaled = true
    InfoLabel.BackgroundTransparency = 1
    InfoLabel.Parent = InfoFrame

    -- YouTube Link Button
    local YTBtn = Instance.new("TextButton")
    YTBtn.Size = UDim2.new(0,200,0,40)
    YTBtn.Position = UDim2.new(0.5,-100,0,60)
    YTBtn.Text = "YouTube Link"
    YTBtn.TextColor3 = Color3.new(1,1,1)
    YTBtn.BackgroundColor3 = Color3.fromRGB(200,0,0)
    YTBtn.Font = Enum.Font.GothamBold
    YTBtn.TextScaled = true
    YTBtn.Parent = InfoFrame
    AddRainbowGlow(YTBtn,2)

    YTBtn.MouseButton1Click:Connect(function()
        setclipboard("https://youtube.com/@blue_mode?si=Qj56WVOkuiVaoNL6")
        print("YouTube link copied to clipboard!")
    end)

    -- Roblox Profile Button
    local ProfileBtn = Instance.new("TextButton")
    ProfileBtn.Size = UDim2.new(0,200,0,40)
    ProfileBtn.Position = UDim2.new(0.5,-100,0,110)
    ProfileBtn.Text = "Roblox Profile: dwaynekean015"
    ProfileBtn.TextColor3 = Color3.new(1,1,1)
    ProfileBtn.BackgroundColor3 = Color3.fromRGB(0,120,255)
    ProfileBtn.Font = Enum.Font.GothamBold
    ProfileBtn.TextScaled = true
    ProfileBtn.Parent = InfoFrame
    AddRainbowGlow(ProfileBtn,2)

    ProfileBtn.MouseButton1Click:Connect(function()
        setclipboard("https://www.roblox.com/users/profile?username=dwaynekean015")
        print("Roblox profile link copied to clipboard!")
    end)

    -- Toggle Info Panel
    MainBtn.MouseButton1Click:Connect(function()
        InfoFrame.Visible = not InfoFrame.Visible
    end)

-- 🌈 Part 12: Music Save Slots

-- Functions to save and load music IDs
local function SaveMusicSlot(slotName, musicId)
    if writefile then
        writefile(slotName..".txt", musicId)
        print("Saved music ID "..musicId.." to "..slotName)
    else
        warn("Executor does not support writefile")
    end
end

local function LoadMusicSlot(slotName)
    if readfile and isfile and isfile(slotName..".txt") then
        local id = readfile(slotName..".txt")
        PlayMusic(id)
        print("Loaded music ID "..id.." from "..slotName)
    else
        warn("Executor does not support readfile or slot not found")
    end
end

-- Add Save/Load buttons inside CreateHub()
local function AddMusicSlots(Frame, VolBox)
    -- Slot 1
    local SaveBtn1 = Instance.new("TextButton")
    SaveBtn1.Size = UDim2.new(0,120,0,30)
    SaveBtn1.Position = UDim2.new(0,160,0,250)
    SaveBtn1.Text = "Save Slot 1"
    SaveBtn1.TextColor3 = Color3.new(1,1,1)
    SaveBtn1.BackgroundColor3 = Color3.fromRGB(80,120,80)
    SaveBtn1.Font = Enum.Font.GothamBold
    SaveBtn1.TextScaled = true
    SaveBtn1.Parent = Frame
    AddRainbowGlow(SaveBtn1,2)
    SaveBtn1.MouseButton1Click:Connect(function()
        SaveMusicSlot("slot1", VolBox.Text)
    end)

    local LoadBtn1 = Instance.new("TextButton")
    LoadBtn1.Size = UDim2.new(0,120,0,30)
    LoadBtn1.Position = UDim2.new(0,300,0,250)
    LoadBtn1.Text = "Load Slot 1"
    LoadBtn1.TextColor3 = Color3.new(1,1,1)
    LoadBtn1.BackgroundColor3 = Color3.fromRGB(120,80,80)
    LoadBtn1.Font = Enum.Font.GothamBold
    LoadBtn1.TextScaled = true
    LoadBtn1.Parent = Frame
    AddRainbowGlow(LoadBtn1,2)
    LoadBtn1.MouseButton1Click:Connect(function()
        LoadMusicSlot("slot1")
    end)

    -- Slot 2
    local SaveBtn2 = Instance.new("TextButton")
    SaveBtn2.Size = UDim2.new(0,120,0,30)
    SaveBtn2.Position = UDim2.new(0,160,0,290)
    SaveBtn2.Text = "Save Slot 2"
    SaveBtn2.TextColor3 = Color3.new(1,1,1)
    SaveBtn2.BackgroundColor3 = Color3.fromRGB(80,120,80)
    SaveBtn2.Font = Enum.Font.GothamBold
    SaveBtn2.TextScaled = true
    SaveBtn2.Parent = Frame
    AddRainbowGlow(SaveBtn2,2)
    SaveBtn2.MouseButton1Click:Connect(function()
        SaveMusicSlot("slot2", VolBox.Text)
    end)

    local LoadBtn2 = Instance.new("TextButton")
    LoadBtn2.Size = UDim2.new(0,120,0,30)
    LoadBtn2.Position = UDim2.new(0,300,0,290)
    LoadBtn2.Text = "Load Slot 2"
    LoadBtn2.TextColor3 = Color3.new(1,1,1)
    LoadBtn2.BackgroundColor3 = Color3.fromRGB(120,80,80)
    LoadBtn2.Font = Enum.Font.GothamBold
    LoadBtn2.TextScaled = true
    LoadBtn2.Parent = Frame
    AddRainbowGlow(LoadBtn2,2)
    LoadBtn2.MouseButton1Click:Connect(function()
        LoadMusicSlot("slot2")
    end)

    -- Slot 3
    local SaveBtn3 = Instance.new("TextButton")
    SaveBtn3.Size = UDim2.new(0,120,0,30)
    SaveBtn3.Position = UDim2.new(0,160,0,330)
    SaveBtn3.Text = "Save Slot 3"
    SaveBtn3.TextColor3 = Color3.new(1,1,1)
    SaveBtn3.BackgroundColor3 = Color3.fromRGB(80,120,80)
    SaveBtn3.Font = Enum.Font.GothamBold
    SaveBtn3.TextScaled = true
    SaveBtn3.Parent = Frame
    AddRainbowGlow(SaveBtn3,2)
    SaveBtn3.MouseButton1Click:Connect(function()
        SaveMusicSlot("slot3", VolBox.Text)
    end)

    local LoadBtn3 = Instance.new("TextButton")
    LoadBtn3.Size = UDim2.new(0,120,0,30)
    LoadBtn3.Position = UDim2.new(0,300,0,330)
    LoadBtn3.Text = "Load Slot 3"
    LoadBtn3.TextColor3 = Color3.new(1,1,1)
    LoadBtn3.BackgroundColor3 = Color3.fromRGB(120,80,80)
    LoadBtn3.Font = Enum.Font.GothamBold
    LoadBtn3.TextScaled = true
    LoadBtn3.Parent = Frame
    AddRainbowGlow(LoadBtn3,2)
    LoadBtn3.MouseButton1Click:Connect(function()
        LoadMusicSlot("slot3")
    end)
end

-- 🌈 Part 13: Saved Music Viewer

local function ShowSavedMusic(Frame)
    -- Viewer Panel
    local ViewerFrame = Instance.new("Frame")
    ViewerFrame.Size = UDim2.new(0,400,0,180)
    ViewerFrame.Position = UDim2.new(0.5,-200,0.5,-90)
    ViewerFrame.BackgroundColor3 = Color3.fromRGB(35,35,35)
    ViewerFrame.Visible = false
    ViewerFrame.Parent = HubUI
    Instance.new("UICorner", ViewerFrame).CornerRadius = UDim.new(0,12)
    AddRainbowGlow(ViewerFrame,3)

    local ViewerTitle = Instance.new("TextLabel")
    ViewerTitle.Size = UDim2.new(1,0,0,40)
    ViewerTitle.Text = "🎵 Saved Music Slots"
    ViewerTitle.TextColor3 = Color3.new(1,1,1)
    ViewerTitle.Font = Enum.Font.GothamBold
    ViewerTitle.TextScaled = true
    ViewerTitle.BackgroundTransparency = 1
    ViewerTitle.Parent = ViewerFrame

    -- Slot Labels
    local Slot1Label = Instance.new("TextLabel")
    Slot1Label.Size = UDim2.new(1,0,0,30)
    Slot1Label.Position = UDim2.new(0,0,0,50)
    Slot1Label.TextColor3 = Color3.new(1,1,1)
    Slot1Label.Font = Enum.Font.Code
    Slot1Label.TextScaled = true
    Slot1Label.BackgroundTransparency = 1
    Slot1Label.Parent = ViewerFrame

    local Slot2Label = Slot1Label:Clone()
    Slot2Label.Position = UDim2.new(0,0,0,90)
    Slot2Label.Parent = ViewerFrame

    local Slot3Label = Slot1Label:Clone()
    Slot3Label.Position = UDim2.new(0,0,0,130)
    Slot3Label.Parent = ViewerFrame

    -- Button to open viewer
    local ViewerBtn = Instance.new("TextButton")
    ViewerBtn.Size = UDim2.new(0,120,0,40)
    ViewerBtn.Position = UDim2.new(0,300,0,370)
    ViewerBtn.Text = "View Saved IDs"
    ViewerBtn.TextColor3 = Color3.new(1,1,1)
    ViewerBtn.BackgroundColor3 = Color3.fromRGB(100,100,180)
    ViewerBtn.Font = Enum.Font.GothamBold
    ViewerBtn.TextScaled = true
    ViewerBtn.Parent = Frame
    AddRainbowGlow(ViewerBtn,2)

    ViewerBtn.MouseButton1Click:Connect(function()
        -- Update labels with saved IDs
        if readfile and isfile then
            if isfile("slot1.txt") then
                Slot1Label.Text = "Slot 1: "..readfile("slot1.txt")
            else
                Slot1Label.Text = "Slot 1: [empty]"
            end
            if isfile("slot2.txt") then
                Slot2Label.Text = "Slot 2: "..readfile("slot2.txt")
            else
                Slot2Label.Text = "Slot 2: [empty]"
            end
            if isfile("slot3.txt") then
                Slot3Label.Text = "Slot 3: "..readfile("slot3.txt")
            else
                Slot3Label.Text = "Slot 3: [empty]"
            end
        else
            Slot1Label.Text = "Executor does not support readfile"
            Slot2Label.Text = ""
            Slot3Label.Text = ""
        end
        ViewerFrame.Visible = not ViewerFrame.Visible
    end)
end
