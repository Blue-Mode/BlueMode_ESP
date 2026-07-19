-- Part 1: Setup
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
Frame.Size = UDim2.new(0,400,0,500)
Frame.Position = UDim2.new(0.5,-200,0.5,-250)
Frame.BackgroundColor3 = Color3.fromRGB(40,40,60)
Frame.Parent = ScreenGui

-- Part 2: Rainbow Glow Helper
function AddRainbowGlow(btn, speed)
    spawn(function()
        while true do
            for i = 0, 255, speed do
                btn.BackgroundColor3 = Color3.fromHSV(i/255,1,1)
                wait()
            end
        end
    end)
end

-- Part 3: Console Runner (executor-safe + keyless)
function RunConsole(code)
    local safeLoadstring = loadstring or function() return function() end end
    local success, err = pcall(function()
        local func = safeLoadstring(code)
        if func then
            func()
        else
            warn("⚠️ Executor does not support loadstring.")
        end
    end)
    if not success then
        warn("⚠️ Console failed: ".. tostring(err))
    end
end

-- Part 4: ESP Placeholder
function EnableESP() print("ESP Enabled") end

-- Part 5: Music Placeholders
function PlayMusic(id) print("Play music ID: "..id) end
function StopMusic() print("Stop music") end

-- Part 6: Arsenal Button
local ArsenalBtn = Instance.new("TextButton")
ArsenalBtn.Size = UDim2.new(0,120,0,40)
ArsenalBtn.Position = UDim2.new(0,300,0,60)
ArsenalBtn.Text = "Arsenal"
ArsenalBtn.Parent = Frame
AddRainbowGlow(ArsenalBtn,2)
ArsenalBtn.MouseButton1Click:Connect(function()
    RunConsole("loadstring(game:HttpGet('https://raw.githubusercontent.com/xx-oboro/roblox/main/arsenal.lua'))()")
end)

-- Part 7: Blox Fruits Button
local BloxBtn = Instance.new("TextButton")
BloxBtn.Size = UDim2.new(0,120,0,40)
BloxBtn.Position = UDim2.new(0,300,0,110)
BloxBtn.Text = "Blox Fruits"
BloxBtn.Parent = Frame
AddRainbowGlow(BloxBtn,2)
BloxBtn.MouseButton1Click:Connect(function()
    RunConsole("loadstring(game:HttpGet('https://raw.githubusercontent.com/ThatMG393/roblox-scripts/master/bloxfruit.luau'))()")
end)

-- Part 8: Adopt Me Button
local AdoptBtn = Instance.new("TextButton")
AdoptBtn.Size = UDim2.new(0,120,0,40)
AdoptBtn.Position = UDim2.new(0,300,0,160)
AdoptBtn.Text = "Adopt Me"
AdoptBtn.Parent = Frame
AddRainbowGlow(AdoptBtn,2)
AdoptBtn.MouseButton1Click:Connect(function()
    RunConsole("loadstring(game:HttpGet('https://raw.githubusercontent.com/BloxZilla/AdoptMe/main/Keyless/Universal-NonSkid/Updated.lua'))()")
end)

-- Part 9: Brookhaven Button
local BrookBtn = Instance.new("TextButton")
BrookBtn.Size = UDim2.new(0,120,0,40)
BrookBtn.Position = UDim2.new(0,300,0,210)
BrookBtn.Text = "Brookhaven"
BrookBtn.Parent = Frame
AddRainbowGlow(BrookBtn,2)
BrookBtn.MouseButton1Click:Connect(function()
    RunConsole("loadstring(game:HttpGet('https://raw.githubusercontent.com/Laelmano24/brookhaven-tool/main/src/main.luau'))()")
end)

-- Part 10: Build a Boat Button
local BoatBtn = Instance.new("TextButton")
BoatBtn.Size = UDim2.new(0,120,0,40)
BoatBtn.Position = UDim2.new(0,300,0,260)
BoatBtn.Text = "Build a Boat"
BoatBtn.Parent = Frame
AddRainbowGlow(BoatBtn,2)
BoatBtn.MouseButton1Click:Connect(function()
    RunConsole("loadstring(game:HttpGet('https://raw.githubusercontent.com/Alive-Debug/BABFT/main/babft.lua'))()")
end)

-- Start Button (always visible)
local StartBtn = Instance.new("TextButton")
StartBtn.Size = UDim2.new(0,150,0,50)
StartBtn.Position = UDim2.new(0.5,-75,0,10)
StartBtn.Text = "Start BLUE MODE HUB"
StartBtn.Parent = Frame
AddRainbowGlow(StartBtn,3)
StartBtn.MouseButton1Click:Connect(function()
    Frame.Visible = true
    print("Hub Started")
end)

-- Part 11: Info Panel
function AddInfoPanel(frame)
    local InfoLabel = Instance.new("TextLabel")
    InfoLabel.Size = UDim2.new(0,380,0,30)
    InfoLabel.Position = UDim2.new(0,10,0,320)
    InfoLabel.Text = "Blue Mode Hub v1.0 - Keyless"
    InfoLabel.TextColor3 = Color3.new(1,1,1)
    InfoLabel.BackgroundTransparency = 1
    InfoLabel.Font = Enum.Font.GothamBold
    InfoLabel.TextScaled = true
    InfoLabel.Parent = frame
end

-- Part 12: Music Slots
function AddMusicSlots(frame)
    local MusicBtn = Instance.new("TextButton")
    MusicBtn.Size = UDim2.new(0,120,0,40)
    MusicBtn.Position = UDim2.new(0,20,0,360)
    MusicBtn.Text = "Play Music"
    MusicBtn.Parent = frame
    AddRainbowGlow(MusicBtn,2)
    MusicBtn.MouseButton1Click:Connect(function()
        PlayMusic("1234567890") -- replace with a Roblox audio ID
    end)

    local StopBtn = Instance.new("TextButton")
    StopBtn.Size = UDim2.new(0,120,0,40)
    StopBtn.Position = UDim2.new(0,160,0,360)
    StopBtn.Text = "Stop Music"
    StopBtn.Parent = frame
    AddRainbowGlow(StopBtn,2)
    StopBtn.MouseButton1Click:Connect(function()
        StopMusic()
    end)
end

-- Part 13: Saved Music Viewer
function ShowSavedMusic(frame)
    local SavedLabel = Instance.new("TextLabel")
    SavedLabel.Size = UDim2.new(0,380,0,30)
    SavedLabel.Position = UDim2.new(0,10,0,410)
    SavedLabel.Text = "Saved Music: None yet"
    SavedLabel.TextColor3 = Color3.new(1,1,1)
    SavedLabel.BackgroundTransparency = 1
    SavedLabel.Font = Enum.Font.Gotham
    SavedLabel.TextScaled = true
    SavedLabel.Parent = frame
end

-- Part 14: Rainbow ESP Upgrade
function RainbowESP() print("🌈 Rainbow ESP Activated") end

-- Part 15: ESP Toggle
function ToggleESP()
    EnableESP()
    print("ESP Toggled On/Off")
end

-- Part 16: Draggable Start Button
local UIS = game:GetService("UserInputService")
local dragging, dragInput, dragStart, startPos

StartBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = StartBtn.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

StartBtn.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        StartBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                      startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Part 17: Cutscene Hooks
function PlayCutscene() print("🎬 Cutscene Played") end

-- Part 18: Mission Placeholder
function LoadMission(id) print("🚀 Mission "..id.." Loaded") end

-- Part 19: Attach Panels
AddInfoPanel(Frame)
AddMusicSlots(Frame)
ShowSavedMusic(Frame)

-- Part 20: Final Glue
print("🌈 BLUE MODE HUB fully loaded and ready!")
