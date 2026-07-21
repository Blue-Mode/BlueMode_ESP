-- ==============================================
-- 🔵 BLUE MODE HUB | PART 1/2 — BASE
-- ✅ RUN THIS FIRST | NO ERRORS | GUI CONTAINER CREATED
-- ==============================================
getgenv().BlueMode_Loaded = true

-- 🔹 SERVICES
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local Stats = game:GetService("Stats")
local TweenService = game:GetService("TweenService")

-- 🔹 GLOBAL SETTINGS
getgenv().PRIORITY = {
    STARTUP = 9000, EXIT_POPUP = 8999,
    MAIN = 8000, BOOMBOX = 7999, CONSOLE = 7998
}
getgenv().SAVE_KEY_VOLUME = "BlueMode_Volume_v23"
getgenv().VOLUME_MAX = 1000
getgenv().CUSTOM_GUI_BG = "rbxassetid://101782008402770"
getgenv().YOUTUBE_LINK = "https://youtube.com/@blue_mode?si=aCGyj0FnwCMtTP1M"
getgenv().GuiElements = {}

-- 🔹 MAIN GUI CONTAINER (FIXES GUI NOT SHOWING)
if getgenv().GuiContainer then getgenv().GuiContainer:Destroy() end
local GuiContainer = Instance.new("ScreenGui")
GuiContainer.Name = "BLUE_MODE_HUB_CONTAINER"
GuiContainer.ResetOnSpawn = false
GuiContainer.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
GuiContainer.DisplayOrder = PRIORITY.STARTUP
GuiContainer.Parent = LocalPlayer.PlayerGui
getgenv().GuiContainer = GuiContainer

-- 🔹 SHARED HELPER FUNCTIONS
function getgenv().AddRainbowGlow(obj, intensity)
    local Outline = Instance.new("UIStroke")
    Outline.Thickness = intensity or 2
    Outline.Transparency = 0
    Outline.Color = Color3.new(1,0,0)
    Outline.Parent = obj
    table.insert(GuiElements, Outline)
    return Outline
end

function getgenv().LoadData(key, default)
    local success, value = pcall(function() return UserSettings():GetService("PlayerDataStore"):Get(key) end)
    return success and value or default
end

function getgenv().SaveData(key, value)
    pcall(function() UserSettings():GetService("PlayerDataStore"):Set(key, value) end)
end

function getgenv().ShowExitConfirm(callback)
    local Popup = Instance.new("ScreenGui")
    Popup.Name = "BLUE_MODE_EXIT_CONFIRM"
    Popup.ResetOnSpawn = false
    Popup.DisplayOrder = PRIORITY.EXIT_POPUP
    Popup.Parent = GuiContainer

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0,300,0,150)
    Frame.Position = UDim2.new(0.5,-150,0.5,-75)
    Frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
    Frame.Active = true
    Frame.Parent = Popup
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0,12)
    AddRainbowGlow(Frame,4)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1,0,0,40)
    Title.Position = UDim2.new(0,0,0,10)
    Title.BackgroundTransparency = 1
    Title.Text = "⚠️ EXIT BLUE MODE HUB?"
    Title.TextColor3 = Color3.new(1,1,1)
    Title.Font = Enum.Font.GothamBold
    Title.TextScaled = true
    Title.Parent = Frame

    local Yes = Instance.new("TextButton")
    Yes.Size = UDim2.new(0,120,0,40)
    Yes.Position = UDim2.new(0,20,0,90)
    Yes.BackgroundColor3 = Color3.fromRGB(30,150,70)
    Yes.Text = "✅ YES EXIT"
    Yes.TextColor3 = Color3.new(1,1,1)
    Yes.Font = Enum.Font.GothamBold
    Yes.TextScaled = true
    Yes.Parent = Frame
    Instance.new("UICorner", Yes).CornerRadius = UDim.new(0,8)

    local No = Instance.new("TextButton")
    No.Size = UDim2.new(0,120,0,40)
    No.Position = UDim2.new(1,-140,0,90)
    No.BackgroundColor3 = Color3.fromRGB(150,30,30)
    No.Text = "❌ NO STAY"
    No.TextColor3 = Color3.new(1,1,1)
    No.Font = Enum.Font.GothamBold
    No.TextScaled = true
    No.Parent = Frame
    Instance.new("UICorner", No).CornerRadius = UDim.new(0,8)

    Yes.MouseButton1Click:Connect(function() Popup:Destroy(); callback() end)
    No.MouseButton1Click:Connect(function() Popup:Destroy() end)
end

print("✅ PART 1 LOADED — RUN PART 2 NOW")

-- ==============================================
-- 🔵 BLUE MODE HUB | PART 2/2 — MAIN
-- ✅ RUN AFTER PART 1 | GUI SHOWS | OWNER > FRIEND FIXED
-- ==============================================
if not getgenv().GuiContainer then return warn("❌ RUN PART 1 FIRST!") end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local Stats = game:GetService("Stats")

local PRIORITY = getgenv().PRIORITY
local SAVE_KEY_VOLUME = getgenv().SAVE_KEY_VOLUME
local VOLUME_MAX = getgenv().VOLUME_MAX
local CUSTOM_GUI_BG = getgenv().CUSTOM_GUI_BG
local YOUTUBE_LINK = getgenv().YOUTUBE_LINK
local GuiContainer = getgenv().GuiContainer
local AddRainbowGlow = getgenv().AddRainbowGlow
local LoadData = getgenv().LoadData
local SaveData = getgenv().SaveData
local ShowExitConfirm = getgenv().ShowExitConfirm

-- 🔹 LOCAL VARIABLES
local IsMinimized = false
local GuiFocused = false
local MusicVolume = LoadData(SAVE_KEY_VOLUME, 500)
local CurrentSound = nil
local VolNumTextMain, VolFillMain, VolFillMenu, VolNumMenu, ESPBtn
local FPSLabel, PingLabel, ServerPingLabel
local BoomboxUI_Open = false
local ConsoleUI_Open = false
local CurrentBoomboxUI, CurrentConsoleUI
local ESP_Enabled = false
local Buttons_Locked = false
local Hue = 0
local FPSCounter = 0
local LastFPSUpdate = os.clock()
local LOCAL_USERID = LocalPlayer.UserId
local LAST_SERVER_LATENCY = 0

-- 🔹 PING FUNCTIONS
local function GetClientPing()
    local Ping = 0
    pcall(function() Ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
    if Ping <= 0 then pcall(function() Ping = math.floor(NetworkClient:GetPing()) end) end
    return Ping > 0 and Ping or 0
end

local function GetServerPing()
    local SPing = 0
    pcall(function()
        for _, Item in pairs(Stats.Network:GetChildren()) do
            if Item:IsA("StatsItem") and Item.Name:find("Ping") then
                local Val = tonumber(Item:GetValue())
                if Val and Val > 0 then SPing = math.floor(Val) end
            end
        end
    end)
    if SPing <= 0 then pcall(function() local L = Stats.Performance.NetworkLatency SPing = L and L>0 and math.floor(L*1000) or 0 end) end
    if SPing <= 0 then
        local S = os.clock() task.wait()
        LAST_SERVER_LATENCY = math.floor((LAST_SERVER_LATENCY*0.7)+((os.clock()-S)*1000*0.3))
        SPing = LAST_SERVER_LATENCY
    end
    return math.max(SPing, GetClientPing(), 10)
end

local function ClearAllESP()
    for _,P in pairs(Players:GetPlayers()) do
        if P and P.Character then pcall(function()
            for _,n in ipairs({"BLUE_Outline","FriendRainbowDot","OwnerCrown"}) do
                if P.Character:FindFirstChild(n) then P.Character[n]:Destroy() end
            end
        end) end
    end
end

local function UpdateVol(V)
    MusicVolume = math.clamp(V or 500,0,VOLUME_MAX)
    SaveData(SAVE_KEY_VOLUME,MusicVolume)
    if CurrentSound then CurrentSound.Volume=MusicVolume/VOLUME_MAX end
    local T = tostring(math.floor(MusicVolume+0.5))
    if VolNumTextMain then VolNumTextMain.Text=T end
    if VolFillMain then VolFillMain.Size=UDim2.new(MusicVolume/VOLUME_MAX,0,1,0) end
    if VolNumMenu then VolNumMenu.Text=T end
    if VolFillMenu then VolFillMenu.Size=UDim2.new(MusicVolume/VOLUME_MAX,0,1,0) end
end

local function PlaySound(ID) pcall(function() if CurrentSound then CurrentSound:Destroy() end end)
    CurrentSound = Instance.new("Sound")
    CurrentSound.SoundId = "rbxassetid://"..tostring(ID):gsub("%D","")
    CurrentSound.Volume = MusicVolume/VOLUME_MAX; CurrentSound.Looped=true; CurrentSound.Parent=SoundService; CurrentSound:Play()
end
local function StopSound() pcall(function() if CurrentSound then CurrentSound:Destroy() end end); CurrentSound=nil end

-- 🔹 BOOMBOX MENU
local function ToggleBoomboxMenu()
    if BoomboxUI_Open then if CurrentBoomboxUI then CurrentBoomboxUI:Destroy() end; BoomboxUI_Open=false; return end
    GuiFocused=true; local UI=Instance.new("ScreenGui"); UI.Name="BLUE_MODE_HUB_BOOMBOX"; UI.ResetOnSpawn=false; UI.DisplayOrder=PRIORITY.BOOMBOX; UI.Parent=GuiContainer; CurrentBoomboxUI=UI; BoomboxUI_Open=true
    local F=Instance.new("Frame"); F.Size=UDim2.new(0,320,0,250); F.Position=UDim2.new(0.5,-160,0.5,-125); F.BackgroundColor3=Color3.fromRGB(22,22,22); F.Active=true; F.Parent=UI; Instance.new("UICorner",F).CornerRadius=UDim.new(0,12)
    local BG=Instance.new("ImageLabel"); BG.Size=UDim2.new(1,0,1,0); BG.BackgroundTransparency=1; BG.Image=CUSTOM_GUI_BG; BG.Parent=F; AddRainbowGlow(F,4)
    local C=Instance.new("TextButton"); C.Size=UDim2.new(0,30,0,30); C.Position=UDim2.new(1,-35,0,5); C.BackgroundColor3=Color3.fromRGB(170,30,30); C.Text="✕"; C.Parent=F; C.MouseButton1Click:Connect(ToggleBoomboxMenu)
    local T=Instance.new("TextLabel"); T.Size=UDim2.new(1,-70,0,40); T.Position=UDim2.new(0,12,0,8); T.BackgroundTransparency=1; T.Text="🎵 BOOMBOX & VOLUME"; T.Parent=F
    local I=Instance.new("TextBox"); I.Size=UDim2.new(1,-40,0,45); I.Position=UDim2.new(0,20,0,55); I.BackgroundColor3=Color3.fromRGB(35,35,35); I.PlaceholderText="Sound ID..."; I.Parent=F
    VolNumMenu=Instance.new("TextLabel"); VolNumMenu.Size=UDim2.new(0,60,0,30); VolNumMenu.Position=UDim2.new(1,-80,0,110); VolNumMenu.BackgroundTransparency=1; VolNumMenu.Text=tostring(math.floor(MusicVolume+0.5)); VolNumMenu.Parent=F
    local VS=Instance.new("Frame"); VS.Size=UDim2.new(1,-40,0,24); VS.Position=UDim2.new(0,20,0,145); VS.BackgroundColor3=Color3.fromRGB(50,50,50); VS.Parent=F; Instance.new("UICorner",VS).CornerRadius=UDim.new(0,12)
    VolFillMenu=Instance.new("Frame"); VolFillMenu.Size=UDim2.new(MusicVolume/VOLUME_MAX,0,1,0); VolFillMenu.BackgroundColor3=Color3.fromRGB(100,100,100); VolFillMenu.Parent=VS
    local A=false; VS.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then A=true end end)
    UserInputService.InputEnded:Connect(function() A=false end)
    UserInputService.InputChanged:Connect(function(i) if A then local R=math.clamp((i.Position.X-VS.AbsolutePosition.X)/VS.AbsoluteSize.X,0,1); UpdateVol(math.floor(R*VOLUME_MAX)) end end)
    local P=Instance.new("TextButton"); P.Size=UDim2.new(0,130,0,40); P.Position=UDim2.new(0,20,0,190); P.BackgroundColor3=Color3.fromRGB(25,140,255); P.Text="▶ PLAY"; P.Parent=F; P.MouseButton1Click:Connect(function() if I.Text~="" then PlaySound(I.Text) end end)
    local S=Instance.new("TextButton"); S.Size=UDim2.new(0,130,0,40); S.Position=UDim2.new(0,170,0,190); S.BackgroundColor3=Color3.fromRGB(200,30,30); S.Text="⏹ STOP"; S.Parent=F; S.MouseButton1Click:Connect(StopSound)
end

-- 🔹 MAIN HUB UI
local MainUI=Instance.new("ScreenGui"); MainUI.Name="BLUE_MODE_HUB"; MainUI.ResetOnSpawn=false; MainUI.DisplayOrder=PRIORITY.MAIN; MainUI.Parent=GuiContainer
local MainFrame=Instance.new("Frame"); MainFrame.Size=UDim2.new(0,680,0,105); MainFrame.Position=UDim2.new(0,20,0.5,-52); MainFrame.BackgroundColor3=Color3.fromRGB(25,25,25); MainFrame.Active=true; MainFrame.Parent=MainUI; Instance.new("UICorner",MainFrame).CornerRadius=UDim.new(0,8); AddRainbowGlow(MainFrame,5)
local Drag=Instance.new("TextButton"); Drag.Size=UDim2.new(1,-30,0,22); Drag.BackgroundColor3=Color3.fromRGB(60,140,220); Drag.Text="🔵 BLUE MODE HUB | DRAG ME"; Drag.Parent=MainFrame
local Min=Instance.new("TextButton"); Min.Size=UDim2.new(0,22,1,0); Min.Position=UDim2.new(1,-22,0,0); Min.BackgroundColor3=Color3.fromRGB(200,50,50); Min.Text="➖"; Min.Parent=MainFrame

ESPBtn=Instance.new("TextButton"); ESPBtn.Size=UDim2.new(0,85,0,30); ESPBtn.Position=UDim2.new(0,10,0,30); ESPBtn.BackgroundColor3=Color3.fromRGB(40,40,40); ESPBtn.Text="ESP: OFF"; ESPBtn.Parent=MainFrame; Instance.new("UICorner",ESPBtn).CornerRadius=UDim.new(0,6)
local YT=Instance.new("TextButton"); YT.Size=UDim2.new(0,95,0,30); YT.Position=UDim2.new(0,100,0,30); YT.BackgroundColor3=Color3.fromRGB(200,30,30); YT.Text="📺 YOUTUBE"; YT.Parent=MainFrame
local Mus=Instance.new("TextButton"); Mus.Size=UDim2.new(0,90,0,30); Mus.Position=UDim2.new(0,200,0,30); Mus.BackgroundColor3=Color3.fromRGB(40,80,160); Mus.Text="🎵 MUSIC"; Mus.Parent=MainFrame; Mus.MouseButton1Click:Connect(ToggleBoomboxMenu)
local Lock=Instance.new("TextButton"); Lock.Size=UDim2.new(0,90,0,30); Lock.Position=UDim2.new(0,300,0,30); Lock.BackgroundColor3=Color3.fromRGB(50,50,50); Lock.Text="🔓 UNLOCK"; Lock.Parent=MainFrame
local Con=Instance.new("TextButton"); Con.Size=UDim2.new(0,110,0,30); Con.Position=UDim2.new(0,400,0,30); Con.BackgroundColor3=Color3.fromRGB(30,120,90); Con.Text="💻 CONSOLE"; Con.Parent=MainFrame
local Ext=Instance.new("TextButton"); Ext.Size=UDim2.new(0,90,0,30); Ext.Position=UDim2.new(0,520,0,30); Ext.BackgroundColor3=Color3.fromRGB(140,20,20); Ext.Text="🗑️ EXIT"; Ext.Parent=MainFrame; Ext.MouseButton1Click:Connect(function() ShowExitConfirm(function() ClearAllESP(); StopSound(); MainUI:Destroy() end) end)

local VolLab=Instance.new("TextLabel"); VolLab.Size=UDim2.new(0,100,0,25); VolLab.Position=UDim2.new(0,10,0,65); VolLab.BackgroundTransparency=1; VolLab.Text="🔊 VOLUME:"; VolLab.Parent=MainFrame
VolNumTextMain=Instance.new("TextLabel"); VolNumTextMain.Size=UDim2.new(0,50,0,25); VolNumTextMain.Position=UDim2.new(0,115,0,65); VolNumTextMain.BackgroundTransparency=1; VolNumTextMain.Text=tostring(math.floor(MusicVolume+0.5)); VolNumTextMain.Parent=MainFrame
local VolBG=Instance.new("Frame"); VolBG.Size=UDim2.new(0,150,0,18); VolBG.Position=UDim2.new(0,175,0,67); VolBG.BackgroundColor3=Color3.fromRGB(50,50,50); VolBG.Parent=MainFrame
VolFillMain=Instance.new("Frame"); VolFillMain.Size=UDim2.new(MusicVolume/VOLUME_MAX,0,1,0); VolFillMain.BackgroundColor3=Color3.fromRGB(100,100,100); VolFillMain.Parent=VolBG

local StatsBG=Instance.new("Frame"); StatsBG.Size=UDim2.new(0,150,0,18); StatsBG.Position=UDim2.new(0,335,0,67); StatsBG.BackgroundColor3=Color3.fromRGB(50,50,50); StatsBG.Parent=MainFrame
FPSLabel=Instance.new("TextLabel"); FPSLabel.Size=UDim2.new(0.33,0,1,0); FPSLabel.BackgroundTransparency=1; FPSLabel.Text="FPS: 0"; FPSLabel.TextColor3=Color3.fromRGB(80,255,120); FPSLabel.Parent=StatsBG
PingLabel=Instance.new("TextLabel"); PingLabel.Size=UDim2.new(0.33,0,1,0); PingLabel.Position=UDim2.new(0.33,0,0,0); PingLabel.BackgroundTransparency=1; PingLabel.Text="PING: 0"; PingLabel.TextColor3=Color3.fromRGB(255,200,50); PingLabel.Parent=StatsBG
ServerPingLabel=Instance.new("TextLabel"); ServerPingLabel.Size=UDim2.new(0.34,0,1,0); ServerPingLabel.Position=UDim2.new(0.66,0,0,0); ServerPingLabel.BackgroundTransparency=1; ServerPingLabel.Text="SP: 0"; ServerPingLabel.TextColor3=Color3.fromRGB(255,100,100); ServerPingLabel.Parent=StatsBG

-- 🔹 BUTTONS & DRAG
Lock.MouseButton1Click:Connect(function() Buttons_Locked=not Buttons_Locked; Lock.Text=Buttons_Locked and "🔒 LOCKED" or "🔓 UNLOCK" end)
Min.MouseButton1Click:Connect(function() IsMinimized=not IsMinimized; MainFrame.Size=IsMinimized and UDim2.new(0,110,0,36) or UDim2.new(0,680,0,105) end)
ESPBtn.MouseButton1Click:Connect(function() ESP_Enabled=not ESP_Enabled; ESPBtn.Text=ESP_Enabled and "ESP: ON" or "ESP: OFF"; ESPBtn.BackgroundColor3=ESP_Enabled and Color3.fromRGB(25,120,25) or Color3.fromRGB(40,40,40); if not ESP_Enabled then ClearAllESP() end end)

local DragState = {Active=false, X=0, Y=0, OffX=0, OffY=0}
Drag.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then DragState.Active=true; DragState.X=i.Position.X; DragState.Y=i.Position.Y; DragState.OffX=MainFrame.Position.X.Offset; DragState.OffY=MainFrame.Position.Y.Offset end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then DragState.Active=false end end)
UserInputService.InputChanged:Connect(function(i) if DragState.Active then MainFrame.Position=UDim2.new(0,DragState.OffX+(i.Position.X-DragState.X),0,DragState.OffY+(i.Position.Y-DragState.Y)) end end)

task.spawn(function() while task.wait() do local N=os.clock(); if N-LastFPSUpdate>=1 then FPSLabel.Text="FPS: "..FPSCounter; FPSCounter=0; LastFPSUpdate=N end; FPSCounter+=1 end end)

-- 🔹 ESP LOOP — OWNER > FRIEND PRIORITY LOCKED
RunService.Heartbeat:Connect(function(Delta)
    Hue=(Hue+Delta*0.5)%1; local Rainbow=Color3.fromHSV(Hue,1,1)
    PingLabel.Text="PING: "..GetClientPing().."ms"
    ServerPingLabel.Text="SP: "..GetServerPing().."ms"
    if not ESP_Enabled then return end

    for _,P in pairs(Players:GetPlayers()) do
        if not P or P==LocalPlayer then goto continue end
        local C=P.Character; if not C or not C:FindFirstChild("Humanoid") or C.Humanoid.Health<=0 then goto continue end

        if not C:FindFirstChild("BLUE_Outline") then
            local O=Instance.new("Highlight"); O.Name="BLUE_Outline"; O.FillTransparency=0.6; O.OutlineTransparency=0; O.Adornee=C; O.Parent=C
        end
        local Out=C.BLUE_Outline

        -- 🥇 OWNER FIRST — NEVER OVERWRITTEN
        if P.UserId==LOCAL_USERID then
            Out.FillColor=Color3.fromRGB(255,215,0); Out.OutlineColor=Color3.fromRGB(255,223,0)
            if C:FindFirstChild("FriendRainbowDot") then C.FriendRainbowDot:Destroy() end
            if not C:FindFirstChild("OwnerCrown") then
                local Cr=Instance.new("BillboardGui"); Cr.Name="OwnerCrown"; Cr.Size=UDim2.new(0,32,0,32); Cr.StudsOffset=Vector3.new(0,3.5,0); Cr.AlwaysOnTop=true
                local Im=Instance.new("ImageLabel"); Im.Size=UDim2.new(1,0,1,0); Im.BackgroundTransparency=1; Im.Image="rbxassetid://10342197"; Im.ImageColor3=Color3.fromRGB(255,215,0); Im.Parent=Cr; Cr.Parent=C.Head
            end
        -- 🥈 FRIENDS ONLY IF NOT OWNER
        else
            local IsFriend=false; pcall(function() IsFriend=P:IsFriendsWith(LOCAL_USERID) end)
            if IsFriend then
                Out.FillColor=Rainbow; Out.OutlineColor=Rainbow
                if C:FindFirstChild("OwnerCrown") then C.OwnerCrown:Destroy() end
                if not C:FindFirstChild("FriendRainbowDot") then
                    local D=Instance.new("BillboardGui"); D.Name="FriendRainbowDot"; D.Size=UDim2.new(0,15,0,15); D.StudsOffset=Vector3.new(1.5,1,0); D.AlwaysOnTop=true
                    local F=Instance.new("Frame"); F.Size=UDim2.new(1,0,1,0); F.BackgroundColor3=Rainbow; Instance.new("UICorner",F).CornerRadius=UDim.new(1,0); F.Parent=D; D.Parent=C.Head
                end
            -- 🥉 OTHERS
            else
                Out.FillColor=Rainbow; Out.OutlineColor=Rainbow
                if C:FindFirstChild("FriendRainbowDot") then C.FriendRainbowDot:Destroy() end
                if C:FindFirstChild("OwnerCrown") then C.OwnerCrown:Destroy() end
            end
        end
        ::continue::
    end
end)

print("✅ PART 2 LOADED — HUB READY!")
