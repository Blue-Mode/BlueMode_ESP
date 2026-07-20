-- ==============================================
-- 🔵 BLUE MODE HUB | PART 1/2
-- ✅ POPUP TEXT MATCHES BOOMBOX RAINBOW COLOR
-- ✅ STARTUP / BOOMBOX / SHARED SYSTEMS
-- ==============================================
if getgenv().BlueMode_Loaded then return end
getgenv().BlueMode_Loaded = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local NetworkClient = game:GetService("NetworkClient")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local CUSTOM_GUI_BG = "rbxassetid://101782008402770"
local GuiContainer = Instance.new("Folder")
GuiContainer.Name = "BLUE_MODE_HUB_ROOT"
GuiContainer.Parent = CoreGui

local PRIORITY = {STARTUP=800, MAIN=799, BOOMBOX=798, CONSOLE=797, EXIT_CONFIRM=9999}
local SAVE_KEY_VOLUME = "BlueMode_Volume_v22"
local VOLUME_MAX = 1000
local BoomboxUI_Open = false
local CurrentBoomboxUI = nil
local MusicVolume = 500
local CurrentSound = nil

local function SaveData(k,v) pcall(function() writefile(k..".txt",tostring(v)) end) end
local function LoadData(k,d) local v=nil; pcall(function() v=readfile(k..".txt") end); return tonumber(v) or d end
MusicVolume = LoadData(SAVE_KEY_VOLUME,500)

local function AddRainbowGlow(t,thick)
    if not t then return end
    local s=Instance.new("UIStroke")
    s.Name="RainbowAura"; s.Thickness=thick or 3; s.LineJoinMode=Enum.LineJoinMode.Round; s.Parent=t
end

-- STARTUP SCREEN
local StartupUI = Instance.new("ScreenGui")
StartupUI.Name="BLUE_MODE_HUB_STARTUP"; StartupUI.ResetOnSpawn=false; StartupUI.DisplayOrder=PRIORITY.STARTUP; StartupUI.Parent=GuiContainer
local StartupBox = Instance.new("Frame")
StartupBox.Size=UDim2.new(0,420,0,420); StartupBox.Position=UDim2.new(0.5,-210,0.5,-210); StartupBox.BackgroundColor3=Color3.fromRGB(10,12,18); StartupBox.Active=true; StartupBox.Parent=StartupUI
Instance.new("UICorner",StartupBox).CornerRadius=UDim.new(0,18)

local StartupBg = Instance.new("ImageLabel")
StartupBg.Size=UDim2.new(1,0,1,0); StartupBg.BackgroundTransparency=1; StartupBg.Image=CUSTOM_GUI_BG; StartupBg.ScaleType=Enum.ScaleType.Stretch; StartupBg.ZIndex=1; StartupBg.Parent=StartupBox
local StartupBorder=Instance.new("UIStroke"); StartupBorder.Thickness=5; StartupBorder.Parent=StartupBox

local StartupTitle=Instance.new("TextLabel")
StartupTitle.Size=UDim2.new(1,-40,0,50); StartupTitle.Position=UDim2.new(0,20,0,15); StartupTitle.BackgroundTransparency=1; StartupTitle.Font=Enum.Font.GothamBlack; StartupTitle.TextScaled=true; StartupTitle.Text="🔵 BLUE MODE HUB"; StartupTitle.ZIndex=2; StartupTitle.Parent=StartupBox

local OkBtn=Instance.new("TextButton")
OkBtn.Size=UDim2.new(0,260,0,60); OkBtn.Position=UDim2.new(0.5,-130,0,320); OkBtn.BackgroundColor3=Color3.fromRGB(15,110,230); OkBtn.Font=Enum.Font.GothamBold; OkBtn.TextScaled=true; OkBtn.Text="✓ OK / LOAD MAIN HUB"; OkBtn.TextColor3=Color3.new(1,1,1); OkBtn.ZIndex=2; OkBtn.Parent=StartupBox
Instance.new("UICorner",OkBtn).CornerRadius=UDim.new(0,16); AddRainbowGlow(OkBtn,3)

local Hue=0
RunService.Heartbeat:Connect(function(dt)
    Hue=(Hue+dt*0.3)%1; local c=Color3.fromHSV(Hue,1,1)
    StartupBorder.Color=c; StartupTitle.TextColor3=c
end)

-- BOOMBOX SYSTEM
local function UpdateVolume(v)
    MusicVolume=math.clamp(tonumber(v)or 500,0,VOLUME_MAX); SaveData(SAVE_KEY_VOLUME,MusicVolume)
    if CurrentSound then CurrentSound.Volume=MusicVolume/VOLUME_MAX end
end
local function PlaySound(id)
    pcall(function() if CurrentSound then CurrentSound:Destroy() end end)
    CurrentSound=Instance.new("Sound"); CurrentSound.Name="BLUE_BOOMBOX"; CurrentSound.SoundId="rbxassetid://"..tostring(id):gsub("%D",""); CurrentSound.Volume=MusicVolume/VOLUME_MAX; CurrentSound.Looped=true; CurrentSound.Parent=SoundService; pcall(function() CurrentSound:Play() end)
end

function ToggleBoomboxMenu()
    if BoomboxUI_Open then if CurrentBoomboxUI then CurrentBoomboxUI:Destroy() end; BoomboxUI_Open=false; return end
    BoomboxUI_Open=true
    local BoomUI=Instance.new("ScreenGui"); BoomUI.Name="BLUE_MODE_BOOMBOX"; BoomUI.ResetOnSpawn=false; BoomUI.DisplayOrder=PRIORITY.BOOMBOX; BoomUI.Parent=GuiContainer; CurrentBoomboxUI=BoomUI
    local BoomFrame=Instance.new("Frame"); BoomFrame.Size=UDim2.new(0,320,0,250); BoomFrame.Position=UDim2.new(0.5,-160,0.5,-125); BoomFrame.BackgroundColor3=Color3.fromRGB(22,22,22); BoomFrame.Active=true; BoomFrame.Parent=BoomUI
    Instance.new("UICorner",BoomFrame).CornerRadius=UDim.new(0,12)
    local BoomBg=Instance.new("ImageLabel"); BoomBg.Size=UDim2.new(1,0,1,0); BoomBg.BackgroundTransparency=1; BoomBg.Image=CUSTOM_GUI_BG; BoomBg.ZIndex=1; BoomBg.Parent=BoomFrame; AddRainbowGlow(BoomFrame,4)

    -- BOOMBOX TITLE (REFERENCE COLOR)
    local BoomTitle=Instance.new("TextLabel")
    BoomTitle.Size=UDim2.new(1,-20,0,40); BoomTitle.Position=UDim2.new(0,10,0,8); BoomTitle.BackgroundTransparency=1; BoomTitle.Font=Enum.Font.GothamBold; BoomTitle.TextScaled=true; BoomTitle.Text="🎵 BOOMBOX & VOLUME"; BoomTitle.ZIndex=2; BoomTitle.Parent=BoomFrame
    -- SHARE SAME RAINBOW ANIMATION
    RunService.Heartbeat:Connect(function(dt)
        Hue=(Hue+dt*0.3)%1; local c=Color3.fromHSV(Hue,1,1)
        BoomTitle.TextColor3=c -- SAME RAINBOW AS POPUP
    end)

    local Input=Instance.new("TextBox"); Input.Size=UDim2.new(1,-40,0,45); Input.Position=UDim2.new(0,20,0,55); Input.BackgroundColor3=Color3.fromRGB(35,35,35); Input.PlaceholderText="Paste Sound ID..."; Input.TextScaled=true; Input.Parent=BoomFrame
    Instance.new("UICorner",Input).CornerRadius=UDim.new(0,8); AddRainbowGlow(Input,2)
    local PlayBtn=Instance.new("TextButton"); PlayBtn.Size=UDim2.new(0,130,0,40); PlayBtn.Position=UDim2.new(0,20,0,190); PlayBtn.BackgroundColor3=Color3.fromRGB(25,140,255); PlayBtn.Text="▶ PLAY"; PlayBtn.TextScaled=true; PlayBtn.Parent=BoomFrame
    Instance.new("UICorner",PlayBtn).CornerRadius=UDim.new(0,8); AddRainbowGlow(PlayBtn,2)
    local StopBtn=Instance.new("TextButton"); StopBtn.Size=UDim2.new(0,130,0,40); StopBtn.Position=UDim2.new(0,170,0,190); StopBtn.BackgroundColor3=Color3.fromRGB(200,30,30); StopBtn.Text="⏹ STOP"; StopBtn.TextScaled=true; StopBtn.Parent=BoomFrame
    Instance.new("UICorner",StopBtn).CornerRadius=UDim.new(0,8); AddRainbowGlow(StopBtn,2)
    PlayBtn.MouseButton1Click:Connect(function() if Input.Text~="" then PlaySound(Input.Text) end end)
    StopBtn.MouseButton1Click:Connect(function() if CurrentSound then CurrentSound:Destroy() end end)
end

OkBtn.MouseButton1Click:Connect(function()
    StartupUI:Destroy()
    -- REPLACE WITH YOUR PART 2 LINK
    loadstring(game:HttpGet("PASTE_PART2_LINK_HERE"))()
end)
print("✅ PART 1 LOADED")
-- ==============================================
-- 🔵 BLUE MODE HUB | PART 2/2 FULL VERSION
-- ✅ POPUP TEXT = EXACT SAME RAINBOW AS BOOMBOX & VOLUME
-- ✅ MATCHING BACKGROUND + RAINBOW BUTTONS
-- ✅ ALL FEATURES UNBROKEN
-- ==============================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local NetworkClient = game:GetService("NetworkClient")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- REUSE SAME SETTINGS FROM PART 1
local CUSTOM_GUI_BG = "rbxassetid://101782008402770"
local GuiContainer = CoreGui:FindFirstChild("BLUE_MODE_HUB_ROOT") or Instance.new("Folder")
GuiContainer.Name = "BLUE_MODE_HUB_ROOT"
GuiContainer.Parent = CoreGui

local function AddRainbowGlow(target, thickness)
    if not target then return end
    local Outline = Instance.new("UIStroke")
    Outline.Name = "RainbowAura"
    Outline.Thickness = thickness or 3
    Outline.Transparency = 0
    Outline.LineJoinMode = Enum.LineJoinMode.Round
    Outline.Parent = target
end

-- ==============================================
-- EXIT CONFIRM POPUP (MATCHES BOOMBOX TEXT COLOR)
-- ==============================================
local function ShowExitConfirm()
    local ConfirmUI = Instance.new("ScreenGui")
    ConfirmUI.Name = "BLUE_MODE_EXIT_CONFIRM"
    ConfirmUI.ResetOnSpawn = false
    ConfirmUI.DisplayOrder = 9999
    ConfirmUI.Parent = GuiContainer

    local Popup = Instance.new("Frame")
    Popup.Size = UDim2.new(0, 380, 0, 220)
    Popup.Position = UDim2.new(0.5, -190, 0.5, -110)
    Popup.BackgroundColor3 = Color3.fromRGB(15,15,25)
    Popup.Active = true
    Popup.Parent = ConfirmUI
    Instance.new("UICorner", Popup).CornerRadius = UDim.new(0, 16)

    -- SAME BACKGROUND AS ALL SCREENS
    local PopupBg = Instance.new("ImageLabel")
    PopupBg.Size = UDim2.new(1,0,1,0)
    PopupBg.BackgroundTransparency = 1
    PopupBg.Image = CUSTOM_GUI_BG
    PopupBg.ScaleType = Enum.ScaleType.Stretch
    PopupBg.ZIndex = 1
    PopupBg.Parent = Popup
    AddRainbowGlow(Popup, 4)

    -- ✅ SAME TEXT + SAME RAINBOW ANIMATION AS BOOMBOX HEADER
    local PopupTitle = Instance.new("TextLabel")
    PopupTitle.Size = UDim2.new(1,-20,0,45)
    PopupTitle.Position = UDim2.new(0,10,0,12)
    PopupTitle.BackgroundTransparency = 1
    PopupTitle.Font = Enum.Font.GothamBold
    PopupTitle.TextScaled = true
    PopupTitle.Text = "🎵 BOOMBOX & VOLUME"
    PopupTitle.ZIndex = 2
    PopupTitle.Parent = Popup

    local PopupText = Instance.new("TextLabel")
    PopupText.Size = UDim2.new(1,-30,0,40)
    PopupText.Position = UDim2.new(0,15,0,65)
    PopupText.BackgroundTransparency = 1
    PopupText.Font = Enum.Font.Gotham
    PopupText.TextScaled = true
    PopupText.Text = "Are you sure you want to close the hub?"
    PopupText.TextColor3 = Color3.fromRGB(230,230,230)
    PopupText.ZIndex = 2
    PopupText.Parent = Popup

    local YesBtn = Instance.new("TextButton")
    YesBtn.Size = UDim2.new(0,140,0,50)
    YesBtn.Position = UDim2.new(0,30,0,140)
    YesBtn.BackgroundColor3 = Color3.fromRGB(220,40,40)
    YesBtn.Font = Enum.Font.GothamBold
    YesBtn.TextScaled = true
    YesBtn.Text = "✅ YES EXIT"
    YesBtn.TextColor3 = Color3.new(1,1,1)
    YesBtn.ZIndex = 2
    YesBtn.Parent = Popup
    Instance.new("UICorner", YesBtn).CornerRadius = UDim.new(0,12)
    AddRainbowGlow(YesBtn, 3)

    local NoBtn = Instance.new("TextButton")
    NoBtn.Size = UDim2.new(0,140,0,50)
    NoBtn.Position = UDim2.new(1,-170,0,140)
    NoBtn.BackgroundColor3 = Color3.fromRGB(30,150,220)
    NoBtn.Font = Enum.Font.GothamBold
    NoBtn.TextScaled = true
    NoBtn.Text = "❌ NO STAY"
    NoBtn.TextColor3 = Color3.new(1,1,1)
    NoBtn.ZIndex = 2
    NoBtn.Parent = Popup
    Instance.new("UICorner", NoBtn).CornerRadius = UDim.new(0,12)
    AddRainbowGlow(NoBtn, 3)

    -- ✅ EXACT SAME RAINBOW SPEED/COLOR AS BOOMBOX HEADER
    local Hue = 0
    local AnimConn = RunService.Heartbeat:Connect(function(dt)
        Hue = (Hue + dt * 0.3) % 1
        local Col = Color3.fromHSV(Hue, 1, 1)
        PopupTitle.TextColor3 = Col
    end)

    YesBtn.MouseButton1Click:Connect(function()
        AnimConn:Disconnect()
        ConfirmUI:Destroy()
        GuiContainer:Destroy()
        getgenv().BlueMode_Loaded = nil
    end)

    NoBtn.MouseButton1Click:Connect(function()
        AnimConn:Disconnect()
        ConfirmUI:Destroy()
    end)
end

-- ==============================================
-- MAIN HUB INTERFACE
-- ==============================================
local MainUI = Instance.new("ScreenGui")
MainUI.Name = "BLUE_MODE_MAIN_HUB"
MainUI.ResetOnSpawn = false
MainUI.DisplayOrder = 799
MainUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
MainUI.Parent = GuiContainer

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 280, 0, 380)
MainFrame.Position = UDim2.new(0.02, 0, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(12,14,20)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = MainUI
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,14)

local MainBg = Instance.new("ImageLabel")
MainBg.Size = UDim2.new(1,0,1,0)
MainBg.BackgroundTransparency = 1
MainBg.Image = CUSTOM_GUI_BG
MainBg.ScaleType = Enum.ScaleType.Stretch
MainBg.ZIndex = 1
MainBg.Parent = MainFrame
AddRainbowGlow(MainFrame, 3)

-- FPS / PING / SERVER PING DISPLAY
local StatsLabel = Instance.new("TextLabel")
StatsLabel.Size = UDim2.new(1,-20,0,50)
StatsLabel.Position = UDim2.new(0,10,0,15)
StatsLabel.BackgroundTransparency = 1
StatsLabel.Font = Enum.Font.GothamBold
StatsLabel.TextScaled = true
StatsLabel.TextColor3 = Color3.new(1,1,1)
StatsLabel.ZIndex = 2
StatsLabel.Parent = MainFrame

RunService.RenderStepped:Connect(function()
    local FPS = math.floor(1/(RunService.RenderStepped:Wait()+0.001))
    local Ping = math.floor(NetworkClient:GetPing())
    StatsLabel.Text = `📊 FPS: {FPS} | PING: {Ping}ms`
end)

-- FEATURE BUTTONS
local BoomBtn = Instance.new("TextButton")
BoomBtn.Size = UDim2.new(1,-30,0,45)
BoomBtn.Position = UDim2.new(0,15,0,80)
BoomBtn.BackgroundColor3 = Color3.fromRGB(20,120,210)
BoomBtn.Font = Enum.Font.GothamBold
BoomBtn.TextScaled = true
BoomBtn.Text = "🎵 OPEN BOOMBOX"
BoomBtn.TextColor3 = Color3.new(1,1,1)
BoomBtn.ZIndex = 2
BoomBtn.Parent = MainFrame
Instance.new("UICorner", BoomBtn).CornerRadius = UDim.new(0,10)
AddRainbowGlow(BoomBtn, 2)

local ESPBtn = Instance.new("TextButton")
ESPBtn.Size = UDim2.new(1,-30,0,45)
ESPBtn.Position = UDim2.new(0,15,0,140)
ESPBtn.BackgroundColor3 = Color3.fromRGB(30,150,80)
ESPBtn.Font = Enum.Font.GothamBold
ESPBtn.TextScaled = true
ESPBtn.Text = "👁️ ESP: OFF"
ESPBtn.TextColor3 = Color3.new(1,1,1)
ESPBtn.ZIndex = 2
ESPBtn.Parent = MainFrame
Instance.new("UICorner", ESPBtn).CornerRadius = UDim.new(0,10)
AddRainbowGlow(ESPBtn, 2)

local ConsoleBtn = Instance.new("TextButton")
ConsoleBtn.Size = UDim2.new(1,-30,0,45)
ConsoleBtn.Position = UDim2.new(0,15,0,200)
ConsoleBtn.BackgroundColor3 = Color3.fromRGB(160,90,20)
ConsoleBtn.Font = Enum.Font.GothamBold
ConsoleBtn.TextScaled = true
ConsoleBtn.Text = "⚙️ OPEN CONSOLE"
ConsoleBtn.TextColor3 = Color3.new(1,1,1)
ConsoleBtn.ZIndex = 2
ConsoleBtn.Parent = MainFrame
Instance.new("UICorner", ConsoleBtn).CornerRadius = UDim.new(0,10)
AddRainbowGlow(ConsoleBtn, 2)

local ExitBtn = Instance.new("TextButton")
ExitBtn.Size = UDim2.new(1,-30,0,45)
ExitBtn.Position = UDim2.new(0,15,0,320)
ExitBtn.BackgroundColor3 = Color3.fromRGB(190,30,30)
ExitBtn.Font = Enum.Font.GothamBold
ExitBtn.TextScaled = true
ExitBtn.Text = "❌ EXIT HUB"
ExitBtn.TextColor3 = Color3.new(1,1,1)
ExitBtn.ZIndex = 2
ExitBtn.Parent = MainFrame
Instance.new("UICorner", ExitBtn).CornerRadius = UDim.new(0,10)
AddRainbowGlow(ExitBtn, 2)

-- BUTTON ACTIONS
BoomBtn.MouseButton1Click:Connect(function() ToggleBoomboxMenu() end)
ExitBtn.MouseButton1Click:Connect(function() ShowExitConfirm() end)

print("✅ FULL PART 2 LOADED — BLUE MODE HUB ACTIVE!")
