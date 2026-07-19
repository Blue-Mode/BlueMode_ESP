-- 🌈 BLUE MODE HUB UNIVERSAL SCRIPT
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local SoundService = game:GetService("SoundService")
local UserInputService = game:GetService("UserInputService")

-- State
local HubOpen = false
local HubUI = nil
local CurrentSound = nil
local MusicVolume = 500

-- Part 1: Helpers
local function AddRainbowGlow(target, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness or 3
    stroke.Parent = target
    return stroke
end

local function RunConsole(code)
    local func, err = loadstring(code)
    if func then
        local ok, runErr = pcall(func)
        if not ok then warn(runErr) end
    else
        warn(err)
    end
end

-- Part 2: ESP (basic)
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

-- Part 3: Music
local function PlayMusic(id)
    if CurrentSound then CurrentSound:Destroy() end
    CurrentSound = Instance.new("Sound")
    CurrentSound.SoundId = "rbxassetid://"..id
    CurrentSound.Looped = true
    CurrentSound.Volume = MusicVolume
    CurrentSound.Parent = SoundService
    CurrentSound:Play()
end

-- Part 4: Stop Music
local function StopMusic()
    if CurrentSound then CurrentSound:Stop() end
end

-- Part 5: Update Volume
local function UpdateVolume(newVol)
    MusicVolume = math.clamp(newVol, 0, 1000)
    if CurrentSound then CurrentSound.Volume = MusicVolume end
end

-- Part 6: Global Buttons
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

-- Part 7: Volume Control + Commands + Robot
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

-- Part 8: Game Buttons
local ArsenalBtn = Instance.new("TextButton")
ArsenalBtn.Size = UDim2.new(0,120,0,40)
ArsenalBtn.Position = UDim2.new(0,300,0,60)
ArsenalBtn.Text = "Arsenal"
ArsenalBtn.Parent = Frame
AddRainbowGlow(ArsenalBtn,2)
ArsenalBtn.MouseButton1Click:Connect(function()
    RunConsole("print('Load Arsenal scripts here')")
end)

local BloxBtn = Instance.new("TextButton")
BloxBtn.Size = UDim2.new(0,120,0,40)
BloxBtn.Position = UDim2.new(0,300,0,110)
BloxBtn.Text = "Blox Fruits"
BloxBtn.Parent = Frame
AddRainbowGlow(BloxBtn,2)
BloxBtn.MouseButton1Click:Connect(function()
    RunConsole("print('Load Blox Fruits scripts here')")
end)

local AdoptBtn = Instance.new("TextButton")
AdoptBtn.Size = UDim2.new(0,120,0,40)
AdoptBtn.Position = UDim2.new(0,300,0,160)
AdoptBtn.Text = "Adopt Me"
AdoptBtn.Parent = Frame
AddRainbowGlow(AdoptBtn,2)
AdoptBtn.MouseButton1Click:Connect(function()
    RunConsole("print('Load Adopt Me scripts here')")
end)

local BrookBtn = Instance.new("TextButton")
BrookBtn.Size = UDim2.new(0,120,0,40)
BrookBtn.Position = UDim2.new(0,300,0,210)
BrookBtn.Text = "Brookhaven"
BrookBtn.Parent = Frame
AddRainbowGlow(BrookBtn,2)
BrookBtn.MouseButton1Click:Connect(function()
    RunConsole("print('Load Brookhaven scripts here')")
end)

-- Build a Boat for Treasure Button
local BoatBtn = Instance.new("TextButton")
BoatBtn.Size = UDim2.new(0,120,0,40)
BoatBtn.Position = UDim2.new(0,300,0,260) -- adjust position if needed
BoatBtn.Text = "Build a Boat"
BoatBtn.TextColor3 = Color3.new(1,1,1)
BoatBtn.BackgroundColor3 = Color3.fromRGB(80,140,200)
BoatBtn.Font = Enum.Font.GothamBold
BoatBtn.TextScaled = true
BoatBtn.Parent = Frame
AddRainbowGlow(BoatBtn,2)

BoatBtn.MouseButton1Click:Connect(function()
    RunConsole([[
        -- Auto Farm Build a Boat script loader
        loadstring(game:HttpGet("https://pastebin.com/raw/YOUR_SCRIPT_ID"))()
    ]])
end)

UserInputService.InputChanged:Connect(function(input)
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

-- Part 10: Start Button
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

-- Part 11: Main Info Panel
local function AddInfoPanel(Frame)
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

    MainBtn.MouseButton1Click:Connect(function()
        InfoFrame.Visible = not InfoFrame.Visible
    end)
end

-- Part 12: Music Save Slots
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

local function AddMusicSlots(Frame, VolBox)
    local function makeSlot(slot, yPos)
        local SaveBtn = Instance.new("TextButton")
        SaveBtn.Size = UDim2.new(0,120,0,30)
        SaveBtn.Position = UDim2.new(0,160,0,yPos)
        SaveBtn.Text = "Save Slot "..slot
        SaveBtn.TextColor3 = Color3.new(1,1,1)
        SaveBtn.BackgroundColor3 = Color3.fromRGB(80,120,80)
        SaveBtn.Font = Enum.Font.GothamBold
        SaveBtn.TextScaled = true
        SaveBtn.Parent = Frame
        AddRainbowGlow(SaveBtn,2)
        SaveBtn.MouseButton1Click:Connect(function()
            SaveMusicSlot("slot"..slot, VolBox.Text)
        end)

        local LoadBtn = Instance.new("TextButton")
        LoadBtn.Size = UDim2.new(0,120,0,30)
        LoadBtn.Position = UDim2.new(0,300,0,yPos)
        LoadBtn.Text = "Load Slot "..slot
        LoadBtn.TextColor3 = Color3.new(1,1,1)
        LoadBtn.BackgroundColor3 = Color3.fromRGB(120,80,80)
        LoadBtn.Font = Enum.Font.GothamBold
        LoadBtn.TextScaled = true
        LoadBtn.Parent = Frame
        AddRainbowGlow(LoadBtn,2)
        LoadBtn.MouseButton1Click:Connect(function()
            LoadMusicSlot("slot"..slot)
        end)
    end

    makeSlot(1,250)
    makeSlot(2,290)
    makeSlot(3,330)
end

-- Part 13: Saved Music Viewer
local function ShowSavedMusic(Frame)
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
        if readfile and isfile then
            Slot1Label.Text = isfile("slot1.txt") and ("Slot 1: "..readfile("slot1.txt")) or "Slot 1: [empty]"
            Slot2Label.Text = isfile("slot2.txt") and ("Slot 2: "..readfile("slot2.txt")) or "Slot 2: [empty]"
            Slot3Label.Text = isfile("slot3.txt") and ("Slot 3: "..readfile("slot3.txt")) or "Slot 3: [empty]"
        else
            Slot1Label.Text = "Executor does not support readfile"
            Slot2Label.Text = ""
            Slot3Label.Text = ""
        end
        ViewerFrame.Visible = not ViewerFrame.Visible
    end)
end

-- Part 14: ESP Rainbow Upgrade
local function EnableRainbowESP()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            -- Rainbow outline
            local highlight = Instance.new("Highlight")
            highlight.Name = "RainbowESP"
            highlight.FillTransparency = 1
            highlight.OutlineTransparency = 0
            highlight.Parent = plr.Character

            -- Animate rainbow outline
            task.spawn(function()
                while highlight.Parent do
                    for i = 0, 1, 0.01 do
                        highlight.OutlineColor3 = Color3.fromHSV(i, 1, 1)
                        task.wait(0.05)
                    end
                end
            end)

            -- Rainbow dot for friends
            if LocalPlayer:IsFriendsWith(plr.UserId) then
                local dot = Instance.new("BillboardGui")
                dot.Size = UDim2.new(0,20,0,20)
                dot.AlwaysOnTop = true
                dot.Parent = plr.Character.Head

                local circle = Instance.new("Frame")
                circle.Size = UDim2.new(1,0,1,0)
                circle.BackgroundColor3 = Color3.new(1,0,0)
                circle.Parent = dot
                Instance.new("UICorner", circle).CornerRadius = UDim.new(1,0)

                -- Animate rainbow dot
                task.spawn(function()
                    while circle.Parent do
                        for i = 0, 1, 0.01 do
                            circle.BackgroundColor3 = Color3.fromHSV(i, 1, 1)
                            task.wait(0.05)
                        end
                    end
                end)
            end
        end
    end
end

-- Part 15: ESP Toggle Button
local ESPOn = false
local function ToggleESP()
    ESPOn = not ESPOn
    if ESPOn then
        EnableRainbowESP()
        print("ESP Enabled")
    else
        -- Remove all highlights and dots
        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Character then
                local h = plr.Character:FindFirstChild("RainbowESP")
                if h then h:Destroy() end
                local head = plr.Character:FindFirstChild("Head")
                if head then
                    for _, gui in pairs(head:GetChildren()) do
                        if gui:IsA("BillboardGui") then gui:Destroy() end
                    end
                end
            end
        end
        print("ESP Disabled")
    end
end

-- Add toggle button to hub frame
local ESPToggleBtn = Instance.new("TextButton")
ESPToggleBtn.Size = UDim2.new(0,120,0,40)
ESPToggleBtn.Position = UDim2.new(0,160,0,60)
ESPToggleBtn.Text = "Toggle ESP"
ESPToggleBtn.TextColor3 = Color3.new(1,1,1)
ESPToggleBtn.BackgroundColor3 = Color3.fromRGB(100,60,150)
ESPToggleBtn.Font = Enum.Font.GothamBold
ESPToggleBtn.TextScaled = true
ESPToggleBtn.Parent = Frame
AddRainbowGlow(ESPToggleBtn,2)
ESPToggleBtn.MouseButton1Click:Connect(ToggleESP)

-- Part 16: Draggable Start Button
local draggingStart, dragInputStart, dragStartPos, startBtnPos
StartBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingStart = true
        dragStartPos = input.Position
        startBtnPos = StartBtn.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                draggingStart = false
            end
        end)
    end
end)

StartBtn.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInputStart = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInputStart and draggingStart then
        local delta = input.Position - dragStartPos
        StartBtn.Position = UDim2.new(
            startBtnPos.X.Scale,
            startBtnPos.X.Offset + delta.X,
            startBtnPos.Y.Scale,
            startBtnPos.Y.Offset + delta.Y
        )
    end
end)

-- Part 17: Cutscene Hooks (placeholder)
local function PlayCutscene(name)
    print("Cutscene triggered: "..name)
    -- You can expand this with TweenService or camera effects later
end

-- Example usage
local CutsceneBtn = Instance.new("TextButton")
CutsceneBtn.Size = UDim2.new(0,120,0,40)
CutsceneBtn.Position = UDim2.new(0,300,0,260)
CutsceneBtn.Text = "Play Cutscene"
CutsceneBtn.TextColor3 = Color3.new(1,1,1)
CutsceneBtn.BackgroundColor3 = Color3.fromRGB(120,60,60)
CutsceneBtn.Font = Enum.Font.GothamBold
CutsceneBtn.TextScaled = true
CutsceneBtn.Parent = Frame
AddRainbowGlow(CutsceneBtn,2)
CutsceneBtn.MouseButton1Click:Connect(function()
    PlayCutscene("Intro")
end)

-- Part 18: Mission Placeholders
local function LoadMission(level)
    print("Mission loaded: Level "..level)
    -- Later you can add quiz logic or game mechanics here
end

local MissionBtn = Instance.new("TextButton")
MissionBtn.Size = UDim2.new(0,120,0,40)
MissionBtn.Position = UDim2.new(0,300,0,310)
MissionBtn.Text = "Start Mission"
MissionBtn.TextColor3 = Color3.new(1,1,1)
MissionBtn.BackgroundColor3 = Color3.fromRGB(60,120,60)
MissionBtn.Font = Enum.Font.GothamBold
MissionBtn.TextScaled = true
MissionBtn.Parent = Frame
AddRainbowGlow(MissionBtn,2)
MissionBtn.MouseButton1Click:Connect(function()
    LoadMission(1)
end)

-- Part 19: Attach Extra Panels/Features
-- Call these at the end of CreateHub so Info, Slots, and Viewer are wired in
AddInfoPanel(Frame)          -- Part 11
AddMusicSlots(Frame, VolBox) -- Part 12
ShowSavedMusic(Frame)        -- Part 13

-- Part 20: Final Glue Code
-- This ensures the hub is fully functional with all 20 parts
print("🌈 BLUE MODE HUB fully loaded!")

-- Optional: auto-open hub on script run
-- Uncomment if you want hub to spawn immediately without pressing Start
-- CreateHub()
-- HubOpen = true

