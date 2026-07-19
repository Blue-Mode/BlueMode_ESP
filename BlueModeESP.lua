-- ScreenGui + Hub Frame
local ScreenGui = Instance.new("ScreenGui", game.Players.LocalPlayer:WaitForChild("PlayerGui"))
local HubFrame = Instance.new("Frame")
HubFrame.Size = UDim2.new(0,450,0,550)
HubFrame.Position = UDim2.new(0.5,-225,0.5,-275)
HubFrame.BackgroundColor3 = Color3.fromRGB(25,25,40)
HubFrame.Visible = false
HubFrame.Parent = ScreenGui

-- Background image (replace with your asset ID)
local Bg = Instance.new("ImageLabel")
Bg.Size = UDim2.new(1,0,1,0)
Bg.Position = UDim2.new(0,0,0,0)
Bg.Image = "rbxassetid://<YOUR_IMAGE_ID>" -- put your mountain background asset ID here
Bg.ScaleType = Enum.ScaleType.Crop
Bg.ZIndex = 0
Bg.Parent = HubFrame
HubFrame.BackgroundTransparency = 1

-- Rounded corners + rainbow outline
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0,12)
UICorner.Parent = HubFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 3
UIStroke.Parent = HubFrame

-- Rainbow animation for outline
task.spawn(function()
    while UIStroke.Parent do
        for i = 0,1,0.01 do
            UIStroke.Color = Color3.fromHSV(i,1,1)
            task.wait(0.05)
        end
    end
end)

-- Header bar (draggable)
local Header = Instance.new("TextLabel")
Header.Size = UDim2.new(1,0,0,35)
Header.Text = "BLUE MODE HUB | DRAG HERE"
Header.BackgroundColor3 = Color3.fromRGB(40,40,70)
Header.TextColor3 = Color3.new(1,1,1)
Header.Font = Enum.Font.GothamBold
Header.TextScaled = true
Header.Parent = HubFrame

-- Launcher cube button
local Launcher = Instance.new("TextButton")
Launcher.Size = UDim2.new(0,80,0,80)
Launcher.Position = UDim2.new(0.5,-40,0,10)
Launcher.Text = "BLUE MODE HUB"
Launcher.Font = Enum.Font.GothamBold
Launcher.TextScaled = true
Launcher.Parent = ScreenGui

local LaunchStroke = Instance.new("UIStroke")
LaunchStroke.Thickness = 3
LaunchStroke.Parent = Launcher

-- Rainbow text + outline animation
task.spawn(function()
    while Launcher.Parent do
        for i = 0,1,0.01 do
            local rainbow = Color3.fromHSV(i,1,1)
            Launcher.TextColor3 = rainbow
            LaunchStroke.Color = rainbow
            task.wait(0.05)
        end
    end
end)

-- Launcher logic
Launcher.MouseButton1Click:Connect(function()
    HubFrame.Visible = not HubFrame.Visible
end)

-- Function to create cube buttons inside hub
local function CreateCubeButton(name, pos, scriptLink)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0,100,0,100)
    Btn.Position = pos
    Btn.Text = name
    Btn.Font = Enum.Font.GothamBold
    Btn.TextScaled = true
    Btn.Parent = HubFrame

    local BtnStroke = Instance.new("UIStroke")
    BtnStroke.Thickness = 2
    BtnStroke.Parent = Btn

    -- Rainbow text + outline animation
    task.spawn(function()
        while Btn.Parent do
            for i = 0,1,0.01 do
                local rainbow = Color3.fromHSV(i,1,1)
                Btn.TextColor3 = rainbow
                BtnStroke.Color = rainbow
                task.wait(0.05)
            end
        end
    end)

    -- Keyless loadstring logic
    Btn.MouseButton1Click:Connect(function()
        loadstring(game:HttpGet(scriptLink))()
    end)
end

-- Universal cube buttons
CreateCubeButton("Arsenal", UDim2.new(0,30,0,60), "https://raw.githubusercontent.com/xx-oboro/roblox/main/arsenal.lua")
CreateCubeButton("Blox Fruits", UDim2.new(0,150,0,60), "https://raw.githubusercontent.com/ThatMG393/roblox-scripts/master/bloxfruit.luau")
CreateCubeButton("Adopt Me", UDim2.new(0,270,0,60), "https://raw.githubusercontent.com/BloxZilla/AdoptMe/main/Keyless/Universal-NonSkid/Updated.lua")
CreateCubeButton("Brookhaven", UDim2.new(0,30,0,180), "https://raw.githubusercontent.com/Laelmano24/brookhaven-tool/main/src/main.luau")
CreateCubeButton("Build a Boat", UDim2.new(0,150,0,180), "https://raw.githubusercontent.com/Alive-Debug/BABFT/main/babft.lua")

-- YouTube Button
local YTBtn = Instance.new("TextButton")
YTBtn.Size = UDim2.new(0,200,0,50)
YTBtn.Position = UDim2.new(0.5,-100,1,-70)
YTBtn.Text = "YouTube: BLUE_MODE"
YTBtn.Font = Enum.Font.GothamBold
YTBtn.TextScaled = true
YTBtn.Parent = HubFrame

local YTStroke = Instance.new("UIStroke")
YTStroke.Thickness = 2
YTStroke.Parent = YTBtn

-- Rainbow text + outline animation
task.spawn(function()
    while YTBtn.Parent do
        for i = 0,1,0.01 do
            local rainbow = Color3.fromHSV(i,1,1)
            YTBtn.TextColor3 = rainbow
            YTStroke.Color = rainbow
            task.wait(0.05)
        end
    end
end)

-- Copy YouTube link to clipboard
YTBtn.MouseButton1Click:Connect(function()
    setclipboard("https://youtube.com/@blue_mode?si=6xIZvTu6hZ9h3Zsw")
    print("YouTube link copied to clipboard!")
end)

-- Special Rainbow ESP
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function EnableRainbowESP()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            -- Rainbow outline
            local highlight = Instance.new("Highlight")
            highlight.Name = "RainbowESP"
            highlight.FillTransparency = 1
            highlight.OutlineTransparency = 0
            highlight.Parent = plr.Character

            task.spawn(function()
                while highlight.Parent do
                    for i = 0,1,0.01 do
                        highlight.OutlineColor3 = Color3.fromHSV(i,1,1)
                        task.wait(0.05)
                    end
                end
            end)

            -- Friend rainbow dot
            if LocalPlayer:IsFriendsWith(plr.UserId) then
                local dot = Instance.new("BillboardGui")
                dot.Size = UDim2.new(0,20,0,20)
                dot.AlwaysOnTop = true
                dot.Parent = plr.Character:FindFirstChild("Head")

                local circle = Instance.new("Frame")
                circle.Size = UDim2.new(1,0,1,0)
                circle.Parent = dot
                Instance.new("UICorner", circle).CornerRadius = UDim.new(1,0)

                task.spawn(function()
                    while circle.Parent do
                        for i = 0,1,0.01 do
                            circle.BackgroundColor3 = Color3.fromHSV(i,1,1)
                            task.wait(0.05)
                        end
                    end
                end)
            end
        end
    end
end

-- ESP Button inside hub
local ESPBtn = Instance.new("TextButton")
ESPBtn.Size = UDim2.new(0,100,0,100)
ESPBtn.Position = UDim2.new(0,270,0,180)
ESPBtn.Text = "ESP"
ESPBtn.Font = Enum.Font.GothamBold
ESPBtn.TextScaled = true
ESPBtn.Parent = HubFrame

local ESPStroke = Instance.new("UIStroke")
ESPStroke.Thickness = 2
ESPStroke.Parent = ESPBtn

task.spawn(function()
    while ESPBtn.Parent do
        for i = 0,1,0.01 do
            local rainbow = Color3.fromHSV(i,1,1)
            ESPBtn.TextColor3 = rainbow
            ESPStroke.Color = rainbow
            task.wait(0.05)
        end
    end
end)

ESPBtn.MouseButton1Click:Connect(function()
    EnableRainbowESP()
end)
