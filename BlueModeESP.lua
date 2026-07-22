-- ==============================================
-- BLUE MODE HUB | PART 1/2
-- ORIGINAL — NO CHANGES
-- ==============================================
if getgenv().BlueMode_Loaded then return end
getgenv().BlueMode_Loaded = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local Stats = game:GetService("Stats")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

CUSTOM_GUI_BG = "rbxassetid://101782008402770"
PRIORITY = {
    STARTUP = 800,
    MAIN = 799,
    BOOMBOX = 798,
    CONSOLE = 797
}
YOUTUBE_LINK = "https://youtube.com/@blue_mode"
SAVE_KEY_VOLUME = "BlueMode_Volume"
VOLUME_MAX = 1000
VOLUME_MULTIPLIER = 2.0
OWNER_USERID = LocalPlayer.UserId

GuiContainer = Instance.new("Folder")
GuiContainer.Name = "BLUE_MODE_HUB"
GuiContainer.Parent = CoreGui

BoomboxUI_Open = false
ConsoleUI_Open = false
GuiElements = {}

local function SaveData(key, val) pcall(function() writefile(key..".txt", tostring(val)) end) end
local function LoadData(key, def) local v=nil; pcall(function() v=readfile(key..".txt") end); return tonumber(v) or def end

local function AddRainbowGlow(obj, t)
    local s = Instance.new("UIStroke")
    s.Name = "Rainbow"
    s.Thickness = t or 2
    s.Transparency = 0
    s.Parent = obj
    table.insert(GuiElements, s)
end

local function ShowExitConfirm(cb)
    local g = Instance.new("ScreenGui")
    g.Parent = GuiContainer
    local f = Instance.new("Frame")
    f.Size = UDim2.fromOffset(300,150)
    f.Position = UDim2.new(0.5,-150,0.5,-75)
    f.BackgroundColor3 = Color3.fromRGB(20,20,20)
    f.CornerRadius = UDim.new(0,8)
    f.Parent = g
    AddRainbowGlow(f,3)
    local t = Instance.new("TextLabel")
    t.Size = UDim2.new(1,0,0,40)
    t.BackgroundTransparency = 1
    t.Text = "EXIT BLUE MODE HUB?"
    t.TextColor3 = Color3.new(1,1,1)
    t.Font = Enum.Font.GothamBold
    t.Parent = f
    local y = Instance.new("TextButton")
    y.Size = UDim2.fromOffset(100,35)
    y.Position = UDim2.new(0.5,-110,0.6,-17)
    y.BackgroundColor3 = Color3.fromRGB(30,150,30)
    y.Text = "YES"
    y.TextColor3 = Color3.new(1,1,1)
    y.CornerRadius = UDim.new(0,6)
    y.Parent = f
    local n = Instance.new("TextButton")
    n.Size = UDim2.fromOffset(100,35)
    n.Position = UDim2.new(0.5,10,0.6,-17)
    n.BackgroundColor3 = Color3.fromRGB(150,30,30)
    n.Text = "NO"
    n.TextColor3 = Color3.new(1,1,1)
    n.CornerRadius = UDim.new(0,6)
    n.Parent = f
    y.MouseButton1Click:Connect(function() g:Destroy(); cb() end)
    n.MouseButton1Click:Connect(function() g:Destroy() end)
end

local Startup = Instance.new("ScreenGui")
Startup.Name = "Startup"
Startup.Parent = GuiContainer
local Box = Instance.new("Frame")
Box.Size = UDim2.fromOffset(350,220)
Box.Position = UDim2.new(0.5,-175,0.5,-110)
Box.BackgroundColor3 = Color3.fromRGB(15,15,15)
Box.CornerRadius = UDim.new(0,10)
Box.Parent = Startup
AddRainbowGlow(Box,4)
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,50)
Title.BackgroundTransparency = 1
Title.Text = "🔵 BLUE MODE HUB"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true
Title.Parent = Box
local Info = Instance.new("TextLabel")
Info.Size = UDim2.new(1,-20,0,80)
Info.Position = UDim2.new(0,10,0,60)
Info.BackgroundTransparency = 1
Info.Text = "✅ ESP | FRIEND RAINBOW\n✅ OWNER GOLDEN OUTLINE\n✅ FPS / PING / SERVER PING\n✅ VOLUME BYPASS\n✅ DRAGGABLE GUI"
Info.TextColor3 = Color3.fromRGB(200,200,200)
Info.Font = Enum.Font.Gotham
Info.TextScaled = true
Info.TextXAlignment = Enum.TextXAlignment.Left
Info.Parent = Box
local Ok = Instance.new("TextButton")
Ok.Size = UDim2.fromOffset(180,40)
Ok.Position = UDim2.new(0.5,-90,0.8,-20)
Ok.BackgroundColor3 = Color3.fromRGB(25,120,200)
Ok.Text = "LOAD HUB"
Ok.TextColor3 = Color3.new(1,1,1)
Ok.Font = Enum.Font.GothamBold
Ok.CornerRadius = UDim.new(0,8)
Ok.Parent = Box
AddRainbowGlow(Ok,2)

Ok.MouseButton1Click:Connect(function()
    Startup:Destroy()
    task.spawn(LoadMainHub)
end)

local h = 0
RunService.Heartbeat:Connect(function(d)
    h = (h + d*0.4) % 1
    local c = Color3.fromHSV(h,1,1)
    for _,s in next,GuiElements do s.Color = c end
end)

print("✅ PART 1 LOADED — RUN PART 2")

-- ==============================================
-- BLUE MODE HUB | PART 2/2
-- ESP 100% ORIGINAL — NO CHANGES
-- ==============================================
function LoadMainHub()
    local MusicVol = LoadData(SAVE_KEY_VOLUME, 750)
    local CurrentSound = nil
    local ESP_Enabled = false
    local Hue = 0
    local FPS = 0
    local LastFPS = os.clock()
    local LocalPlayer = game.Players.LocalPlayer
    local LocalID = LocalPlayer.UserId

    -- ONLY SOUND FIX — NOT RELATED TO ESP
    local SG = Instance.new("SoundGroup")
    SG.Name = "BlueModeSG"
    SG.Volume = 2
    SG.Parent = game.SoundService

    local function IsFriend(p)
        if p==LocalPlayer then return false end
        local ok,r = pcall(function() return p:IsFriendsWith(LocalID) end)
        if ok then return r end
        ok,r = pcall(function() return LocalPlayer:IsFriendsWith(p.UserId) end)
        return ok and r
    end

    local function ClearESP()
        for _,p in next,game.Players:GetPlayers() do
            if p.Character then
                pcall(function()
                    p.Character:FindFirstChild("BLUE_Outline"):Destroy()
                    p.Character:FindFirstChild("FriendDot"):Destroy()
                    p.Character:FindFirstChild("OwnerDot"):Destroy()
                end)
            end
        end
    end

    local function GetPing()
        local p=0
        pcall(function() p=math.floor(game.Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
        return p>0 and p or 0
    end

    local function UpdateVol(v)
        MusicVol = math.clamp(tonumber(v) or 750,0,VOLUME_MAX)
        SaveData(SAVE_KEY_VOLUME,MusicVol)
        if CurrentSound then CurrentSound.Volume = (MusicVol/VOLUME_MAX)*VOLUME_MULTIPLIER end
    end

    local function PlaySound(id)
        pcall(function() CurrentSound:Destroy() end)
        CurrentSound = Instance.new("Sound")
        CurrentSound.SoundId = "rbxassetid://"..tonumber(id:gsub("%D",""))
        CurrentSound.Volume = (MusicVol/VOLUME_MAX)*VOLUME_MULTIPLIER
        CurrentSound.SoundGroup = SG
        CurrentSound.Looped = true
        CurrentSound.Parent = game.SoundService
        CurrentSound:Play()
    end

    -- MAIN GUI
    local Main = Instance.new("ScreenGui")
    Main.Parent = GuiContainer
    Main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.fromOffset(650,100)
    Frame.Position = UDim2.new(0,20,0.5,-50)
    Frame.BackgroundColor3 = Color3.fromRGB(22,22,22)
    Frame.CornerRadius = UDim.new(0,8)
    Frame.Active = true
    Frame.Draggable = true
    Frame.Parent = Main
    AddRainbowGlow(Frame,3)

    local ESPBtn = Instance.new("TextButton")
    ESPBtn.Size = UDim2.fromOffset(90,30)
    ESPBtn.Position = UDim2.fromOffset(10,35)
    ESPBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    ESPBtn.Text = "ESP: OFF"
    ESPBtn.TextColor3 = Color3.new(1,1,1)
    ESPBtn.CornerRadius = UDim.new(0,6)
    ESPBtn.Parent = Frame

    local FPSLab = Instance.new("TextLabel")
    FPSLab.Size = UDim2.fromOffset(80,25)
    FPSLab.Position = UDim2.fromOffset(120,37)
    FPSLab.BackgroundTransparency = 1
    FPSLab.Text = "FPS: 0"
    FPSLab.TextColor3 = Color3.fromRGB(80,255,80)
    FPSLab.Parent = Frame

    local PingLab = Instance.new("TextLabel")
    PingLab.Size = UDim2.fromOffset(80,25)
    PingLab.Position = UDim2.fromOffset(210,37)
    PingLab.BackgroundTransparency = 1
    PingLab.Text = "PING: 0"
    PingLab.TextColor3 = Color3.fromRGB(255,200,50)
    PingLab.Parent = Frame

    -- TOGGLE ESP
    ESPBtn.MouseButton1Click:Connect(function()
        ESP_Enabled = not ESP_Enabled
        ESPBtn.Text = ESP_Enabled and "ESP: ON" or "ESP: OFF"
        ESPBtn.BackgroundColor3 = ESP_Enabled and Color3.fromRGB(20,100,20) or Color3.fromRGB(40,40,40)
        if not ESP_Enabled then ClearESP() end
    end)

    -- FPS COUNTER
    task.spawn(function()
        while task.wait() do
            if os.clock()-LastFPS >=1 then
                FPSLab.Text = "FPS: "..FPS
                FPS = 0
                LastFPS = os.clock()
            end
            FPS +=1
        end
    end)

    -- ⚠️ YOUR EXACT ORIGINAL ESP LOOP — NOT ONE LINE CHANGED
    RunService.Heartbeat:Connect(function(delta)
        Hue = (Hue + delta*0.5) % 1
        local Rainbow = Color3.fromHSV(Hue,1,1)
        local Gold = Color3.fromRGB(255,215,0)

        for _,s in next,GuiElements do s.Color = Rainbow end
        PingLab.Text = "PING: "..GetPing().."ms"

        if not ESP_Enabled then return end

        for _,Player in next,game.Players:GetPlayers() do
            if Player == LocalPlayer then continue end
            if not Player.Character then continue end
            local Char = Player.Character
            local Hum = Char:FindFirstChild("Humanoid")
            if not Hum or Hum.Health <=0 then
                pcall(function() Char.BLUE_Outline:Destroy() end)
                continue
            end

            -- OUTLINE
            local Outline = Char:FindFirstChild("BLUE_Outline") or Instance.new("ForceField")
            Outline.Name = "BLUE_Outline"
            Outline.Visible = true
            if Player.UserId == OWNER_USERID then
                Outline.Color = Gold
                Outline.Transparency = 0.2
            elseif IsFriend(Player) then
                Outline.Color = Rainbow
                Outline.Transparency = 0.2
            else
                Outline.Color = Color3.new(1,0,0)
                Outline.Transparency = 0.3
            end
            Outline.Parent = Char

            -- FRIEND DOT
            if IsFriend(Player) then
                local Dot = Char:FindFirstChild("FriendDot") or Instance.new("BillboardGui")
                Dot.Name = "FriendDot"
                Dot.AlwaysOnTop = true
                Dot.Size = UDim2.fromOffset(10,10)
                Dot.StudsOffset = Vector3.new(0,2.5,0)
                local Fr = Dot:FindFirstChild("Frame") or Instance.new("Frame")
                Fr.Size = UDim2.new(1,0,1,0)
                Fr.BackgroundColor3 = Rainbow
                Fr.CornerRadius = UDim.new(0.5,0)
                Fr.Parent = Dot
                Dot.Parent = Char
            else
                pcall(function() Char.FriendDot:Destroy() end)
            end

            -- OWNER DOT
            if Player.UserId == OWNER_USERID then
                local GDot = Char:FindFirstChild("OwnerDot") or Instance.new("BillboardGui")
                GDot.Name = "OwnerDot"
                GDot.AlwaysOnTop = true
                GDot.Size = UDim2.fromOffset(14,14)
                GDot.StudsOffset = Vector3.new(0,3,0)
                local GF = GDot:FindFirstChild("Frame") or Instance.new("Frame")
                GF.Size = UDim2.new(1,0,1,0)
                GF.BackgroundColor3 = Gold
                GF.CornerRadius = UDim.new(0.5,0)
                GF.Parent = GDot
                GDot.Parent = Char
            else
                pcall(function() Char.OwnerDot:Destroy() end)
            end
        end
    end)

    print("✅ BLUE MODE HUB FULLY LOADED — ESP UNCHANGED")
end
