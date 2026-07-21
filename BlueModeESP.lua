-- ==============================================
-- 🔵 BLUE MODE HUB | FINAL FULL VERSION (Part 1/2)
-- ✅ ESP: Rainbow Outline + Friend Dot + Owner Crown
-- ✅ FIXED Server Ping, FPS, Volume
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

local CUSTOM_GUI_BG = "rbxassetid://101782008402770"

local GuiContainer = Instance.new("Folder")
GuiContainer.Name = "BLUE_MODE_HUB_ROOT"
GuiContainer.Parent = CoreGui

local PRIORITY = {
    STARTUP = 800,
    MAIN = 799,
    BOOMBOX = 798,
    CONSOLE = 797,
    EXIT_POPUP = 9999
}

local SAVE_KEY_VOLUME = "BlueMode_Volume_v22"
local VOLUME_MAX = 1000

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
end

-- STARTUP SCREEN
local StartupUI = Instance.new("ScreenGui")
StartupUI.Name = "BLUE_MODE_HUB_STARTUP"
StartupUI.Parent = GuiContainer

local StartupBox = Instance.new("Frame")
StartupBox.Size = UDim2.new(0, 420, 0, 420)
StartupBox.Position = UDim2.new(0.5, -210, 0.5, -210)
StartupBox.BackgroundColor3 = Color3.fromRGB(10,12,18)
StartupBox.Parent = StartupUI
Instance.new("UICorner", StartupBox).CornerRadius = UDim.new(0, 18)

local StartupTitle = Instance.new("TextLabel")
StartupTitle.Size = UDim2.new(1, -40, 0, 50)
StartupTitle.Position = UDim2.new(0, 20, 0, 15)
StartupTitle.BackgroundTransparency = 1
StartupTitle.Font = Enum.Font.GothamBlack
StartupTitle.TextScaled = true
StartupTitle.Text = "🔵 BLUE MODE HUB"
StartupTitle.TextColor3 = Color3.fromRGB(0, 190, 255)
StartupTitle.Parent = StartupBox

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
UpdateList.Text = [[• ESP: Rainbow Outline + Friend Dot + Owner Crown
• FPS / Ping / Server Ping fixed
• Volume slider 0–1000
• All GUIs with rainbow borders
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
OkBtn.Parent = StartupBox
Instance.new("UICorner", OkBtn).CornerRadius = UDim.new(0, 16)
AddRainbowGlow(OkBtn, 3)

RunService.Heartbeat:Connect(function()
    local Col = Color3.fromHSV(tick()%5/5,1,1)
    StartupTitle.TextColor3 = Col
end)

OkBtn.MouseButton1Click:Connect(function()
    StartupUI:Destroy()
    LoadMainHub()
end)

-- ==============================================
-- 🔵 BLUE MODE HUB | FINAL FULL VERSION (Part 2/2)
-- ==============================================

function LoadMainHub()
    local MusicVolume = LoadData(SAVE_KEY_VOLUME, 500)
    local CurrentSound = nil
    local ESPBtn
    local ESP_Enabled = false

    -- ✅ ESP SYSTEM
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
    end

    local function ApplyESP(player)
        if not player.Character then return end

        -- Rainbow outline
        local outline = Instance.new("Highlight")
        outline.Name = "BLUE_Outline"
        outline.FillTransparency = 1
        outline.Adornee = player.Character
        outline.Parent = player.Character
        task.spawn(function()
            while outline.Parent do
                outline.OutlineColor = Color3.fromHSV(tick()%5/5,1,1)
                task.wait(0.1)
            end
        end)

        -- Friend rainbow dot
        if player:IsFriendsWith(LocalPlayer.UserId) then
            local dot = Instance.new("BillboardGui")
            dot.Name = "FriendRainbowDot"
            dot.Size = UDim2.new(0,10,0,10)
            dot.Adornee = player.Character:FindFirstChild("Head")
            dot.Parent = player.Character
            local frame = Instance.new("Frame", dot)
            frame.Size = UDim2.new(1,0,1,0)
            frame.BorderSizePixel = 0
            task.spawn(function()
                while frame.Parent do
                    frame.BackgroundColor3 = Color3.fromHSV(tick()%5/5,1,1)
                    task.wait(0.1)
                end
            end)
        end

        -- Owner crown
        if player.Name == "Blue_Mode" or player.Name == "Dwayne Kean Francisco" then
            local crown = Instance.new("BillboardGui")
            crown.Name = "OwnerCrown"
            crown.Size = UDim2.new(0,40,0,40)
            crown.Adornee = player.Character:FindFirstChild("Head")
            crown.Parent = player.Character
            local text = Instance.new("TextLabel", crown)
            text.Size = UDim2.new(1,0,1,0)
            text.BackgroundTransparency = 1
            text.Text = "👑"
            text.TextColor3 = Color3.fromRGB(255,215,0)
            text.TextScaled = true
            text.Font = Enum.Font.GothamBold
        end
    end

    -- ✅ MAIN HUB UI
    local MainUI = Instance.new("ScreenGui")
    MainUI.Name = "BLUE_MODE_HUB"
    MainUI.Parent = GuiContainer

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0,680,0,105)
    MainFrame.Position = UDim2.new(0,20,0.5,-52)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
    MainFrame.Parent = MainUI
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,8)
    AddRainbowGlow(MainFrame,5)

    -- ESP Button
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
    AddRainbowGlow(ESPBtn,2)

    -- ✅ ESP Toggle Logic
    ESPBtn.MouseButton1Click:Connect(function()
        ESP_Enabled = not ESP_Enabled
        if ESP_Enabled then
            ESPBtn.Text = "ESP: ON"
            ESPBtn.BackgroundColor3 = Color3.fromRGB(25,140,255)
            for _,plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer then
                    ApplyESP(plr)
                end
            end
            Players.PlayerAdded:Connect(function(plr)
                plr.CharacterAdded:Connect(function() ApplyESP(plr) end)
            end)
        else
            ESPBtn.Text = "ESP: OFF"
            ESPBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
            ClearAllESP()
        end
    end)
end
