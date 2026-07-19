-- 🌈 BLUE MODE HUB SCRIPT WITH MUSIC VOLUME (0–1000)
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local SoundService = game:GetService("SoundService")

-- State
local HubOpen = false
local HubUI = nil
local CurrentSound = nil
local MusicVolume = 500 -- default mid value

-- Helper: rainbow outline
local function AddRainbowGlow(target, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness or 3
    stroke.Parent = target
    return stroke
end

-- ESP: rainbow outline + friend dot
local function EnableESP()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local highlight = Instance.new("Highlight")
            highlight.Name = "RainbowESP"
            highlight.FillTransparency = 1
            highlight.OutlineTransparency = 0
            highlight.Parent = plr.Character

            if plr:IsFriendsWith(LocalPlayer.UserId) then
                local dot = Instance.new("BillboardGui")
                dot.Size = UDim2.new(0,10,0,10)
                dot.AlwaysOnTop = true
                dot.Parent = plr.Character.Head
                local frame = Instance.new("Frame")
                frame.Size = UDim2.new(1,0,1,0)
                frame.BackgroundColor3 = Color3.fromHSV(0,1,1)
                frame.Parent = dot
                AddRainbowGlow(frame, 2)
            end
        end
    end
end

-- Console: run loadstring
local function RunConsole(code)
    local func, err = loadstring(code)
    if func then
        local ok, runErr = pcall(func)
        if not ok then warn(runErr) end
    else
        warn(err)
    end
end

-- Music system
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

-- Close/Delete
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
