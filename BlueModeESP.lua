-- ==============================================
-- ESP Script | PERMANENT RAINBOW · ALL FEATURES KEPT
-- made by BLUE_MODE
-- UNLOCK CODE: Blue_Mode192823
-- Version: 2.5 FINAL | PART 1 OF 2
-- ==============================================

if getgenv().BlueMode_Loaded then return end
getgenv().BlueMode_Loaded = true

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- Compatibility Fallbacks
local function SafeWriteFile(key, val) pcall(function() if writefile then writefile(key..".txt", tostring(val)) end end) end
local function SafeReadFile(key, default) local v=nil pcall(function() if readfile then v=readfile(key..".txt") end end) return tonumber(v) or default end
local function SafeCopy(text) pcall(function() if setclipboard then setclipboard(text) end end) end

-- ALL OLD SETTINGS KEPT
local USAGE_LIMIT = 12*3600
local COOLDOWN = 12*3600
local YOUTUBE_LINK = "https://youtube.com/@blue_mode?si=aCGyj0FnwCMtTP1M"
local SAVE_USED = "BlueMode_UsedTime_v2"
local SAVE_COOLDOWN = "BlueMode_CooldownEnd_v2"
local SAVE_VOL = "BlueMode_Volume_v2"
local MAX_Z = 2147483647 -- ALWAYS ON TOP

-- Clear ESP (OLD FUNCTION KEPT)
local function ClearESP()
    for _,P in pairs(Players:GetPlayers()) do if P and P.Character then pcall(function()
        if P.Character:FindFirstChild("BLUE_Outline") then P.Character.BLUE_Outline:Destroy() end
        if P.Character:FindFirstChild("FriendRainbowDot") then P.Character.FriendRainbowDot:Destroy() end
    end) end end
    pcall(function() for _,D in pairs(workspace:GetDescendants()) do if D.Name=="BLUE_Outline" or D.Name=="FriendRainbowDot" then D:Destroy() end end end)
end

-- Cooldown Check (OLD KEPT)
local Now = os.time()
local CooldownEnd = SafeReadFile(SAVE_COOLDOWN, 0)
if Now < CooldownEnd then print("⏳ COOLDOWN: Wait "..math.floor((CooldownEnd-Now)/60).." mins") return end

-- Load Saved Data
local UsedTime = SafeReadFile(SAVE_USED, 0)
local LastCheck = os.time()
local MusicVolume = math.clamp(SafeReadFile(SAVE_VOL, 500), 0, 1000)

-- ALL GLOBALS KEPT
local CurrentSound = nil
local VolNumMain, VolFillMain, VolNumMenu, VolFillMenu
local AllRainbowOutlines = {}
local BoomUI = nil
local ConsoleUI = nil
local MainUI = nil
local MenuOpen = false

-- Permanent Rainbow Function (NEW BUT NO OLD FEATURES REMOVED)
local function AddPermanentRainbow(target, thickness)
    if not target then return end
    local Outline = Instance.new("UIStroke")
    Outline.Name = "PermanentRainbow"
    Outline.Thickness = thickness or 3
    Outline.Transparency = 0
    Outline.LineJoinMode = Enum.LineJoinMode.Round
    Outline.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    Outline.Parent = target
    table.insert(AllRainbowOutlines, Outline)
    return Outline
end

-- Touch Lock (NO CAMERA INTERFERENCE — KEPT)
local function SetTouchLock(on) if MainUI then MainUI.Modal = on end end
local function UpdateTouchLock() SetTouchLock(MenuOpen) end

-- Volume 0-1000 (KEPT)
local function UpdateVolume(v)
    MusicVolume = math.clamp(tonumber(v) or 500, 0, 1000)
    SafeWriteFile(SAVE_VOL, MusicVolume)
    local norm = MusicVolume/1000
    if CurrentSound then CurrentSound.Volume = norm end
    local txt = math.floor(MusicVolume).."/1000"
    if VolNumMain then VolNumMain.Text = txt end
    if VolFillMain then VolFillMain.Size = UDim2.new(norm,0,1,0) end
    if VolNumMenu then VolNumMenu.Text = txt end
    if VolFillMenu then VolFillMenu.Size = UDim2.new(norm,0,1,0) end
end

-- Sound Helpers (KEPT)
local function FormatID(i) return "rbxassetid://"..tostring(i):gsub("%D","") end
local function PlaySound(id)
    pcall(function() if CurrentSound then CurrentSound:Destroy() end end)
    CurrentSound = Instance.new("Sound")
    CurrentSound.Name = "BLUE_BOOMBOX"
    CurrentSound.SoundId = FormatID(id)
    CurrentSound.Volume = MusicVolume/1000
    CurrentSound.Looped = true
    CurrentSound.Parent = SoundService
    pcall(function() CurrentSound:Play() end)
end

-- ==============================================
-- 🎵 FULL BOOMBOX MENU (KEPT 100%)
-- ==============================================
local function OpenBoombox()
    if BoomUI then BoomUI:Destroy(); BoomUI=nil end
    if ConsoleUI then ConsoleUI:Destroy(); ConsoleUI=nil end
    MenuOpen = true; UpdateTouchLock()

    BoomUI = Instance.new("ScreenGui")
    BoomUI.Name = "BLUE_BOOMBOX"
    BoomUI.ResetOnSpawn = false
    BoomUI.ZIndexBehavior = Enum.ZIndexBehavior.Global
    BoomUI.DisplayOrder = MAX_Z
    BoomUI.IgnoreGuiInset = true
    BoomUI.Parent = CoreGui

    local F = Instance.new("Frame")
    F.Size = UDim2.new(0,320,0,250)
    F.Position = UDim2.new(0.5,-160,0.5,-125)
    F.BackgroundColor3 = Color3.fromRGB(22,22,22)
    F.Active = true; F.ClipsDescendants = true
    F.Parent = BoomUI
    Instance.new("UICorner",F).CornerRadius = UDim.new(0,12)
    AddPermanentRainbow(F,4)

    local X = Instance.new("TextButton")
    X.Size=UDim2.new(0,30,0,30); X.Position=UDim2.new(1,-35,0,5)
    X.BackgroundColor3=Color3.fromRGB(170,30,30); X.Text="✕"
    X.TextColor3=Color3.new(1,1,1); X.Font=Enum.Font.GothamBold; X.TextSize=24
    X.Parent=F; AddPermanentRainbow(X,2)
    X.MouseButton1Click:Connect(function() BoomUI:Destroy();BoomUI=nil;MenuOpen=(ConsoleUI~=nil);UpdateTouchLock() end)

    local T = Instance.new("TextLabel")
    T.Size=UDim2.new(1,0,0,40); T.Position=UDim2.new(0,0,0,8)
    T.BackgroundTransparency=1; T.Text="🎵 BOOMBOX & VOLUME"
    T.Font=Enum.Font.GothamBold; T.TextColor3=Color3.new(1,1,1); T.TextScaled=true
    T.Parent=F

    local I = Instance.new("TextBox")
    I.Size=UDim2.new(1,-40,0,45); I.Position=UDim2.new(0,20,0,55)
    I.BackgroundColor3=Color3.fromRGB(35,35,35)
    I.PlaceholderText="Paste Sound ID..."
    I.TextColor3=Color3.new(1,1,1); I.Font=Enum.Font.Gotham; I.TextScaled=true
    I.Parent=F; Instance.new("UICorner",I).CornerRadius=UDim.new(0,8)
    AddPermanentRainbow(I,2)

    local VL = Instance.new("TextLabel")
    VL.Size=UDim2.new(0,120,0,30); VL.Position=UDim2.new(0,20,0,110)
    VL.BackgroundTransparency=1; VL.Text="🔊 VOLUME:"
    VL.Font=Enum.Font.GothamBold; VL.TextColor3=Color3.new(1,1,1); VL.TextScaled=true; VL.TextXAlignment=0
    VL.Parent=F

    VolNumMenu = Instance.new("TextLabel")
    VolNumMenu.Size=UDim2.new(0,80,0,30); VolNumMenu.Position=UDim2.new(1,-100,0,110)
    VolNumMenu.BackgroundTransparency=1; VolNumMenu.Text=math.floor(MusicVolume).."/1000"
    VolNumMenu.Font=Enum.Font.GothamBold; VolNumMenu.TextColor3=Color3.new(1,1,1); VolNumMenu.TextScaled=true; VolNumMenu.TextXAlignment=2
    VolNumMenu.Parent=F

    local VB = Instance.new("Frame")
    VB.Size=UDim2.new(1,-40,0,24); VB.Position=UDim2.new(0,20,0,145)
    VB.BackgroundColor3=Color3.fromRGB(50,50,50); VB.Active=true; VB.ClipsDescendants=true
    VB.Parent=F; Instance.new("UICorner",VB).CornerRadius=UDim.new(0,12)
    AddPermanentRainbow(VB,2)

    VolFillMenu = Instance.new("Frame")
    VolFillMenu.Size=UDim2.new(MusicVolume/1000,0,1,0)
    VolFillMenu.BackgroundColor3=Color3.fromRGB(100,100,100)
    VolFillMenu.Parent=VB; Instance.new("UICorner",VolFillMenu).CornerRadius=UDim.new(0,12)

    local SA=false
    VB.InputBegan:Connect(function(i) if i.UserInputType.Name:match("MouseButton1|Touch") then SA=true; SetTouchLock(true) end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType.Name:match("MouseButton1|Touch") then if SA then SA=false; task.wait(0.05); UpdateTouchLock() end end end)
    UserInputService.InputChanged:Connect(function(i) if SA and i.UserInputType.Name:match("MouseMovement|Touch") then
        local r=math.clamp((i.Position.X-VB.AbsolutePosition.X)/VB.AbsoluteSize.X,0,1)
        UpdateVolume(r*1000)
    end end)

    local PB = Instance.new("TextButton")
    PB.Size=UDim2.new(0,130,0,40); PB.Position=UDim2.new(0,20,0,190)
    PB.BackgroundColor3=Color3.fromRGB(25,140,255); PB.Text="▶ PLAY"
    PB.TextColor3=Color3.new(1,1,1); PB.Font=Enum.Font.GothamBold; PB.TextScaled=true
    PB.Parent=F; Instance.new("UICorner",PB).CornerRadius=UDim.new(0,8)
    AddPermanentRainbow(PB,2)
    PB.MouseButton1Click:Connect(function() if I.Text~="" then PlaySound(I.Text) end end)

    local SB = Instance.new("TextButton")
    SB.Size=UDim2.new(0,130,0,40); SB.Position=UDim2.new(0,170,0,190)
    SB.BackgroundColor3=Color3.fromRGB(200,30,30); SB.Text="⏹ STOP"
    SB.TextColor3=Color3.new(1,1,1); SB.Font=Enum.Font.GothamBold; SB.TextScaled=true
    SB.Parent=F; Instance.new("UICorner",SB).CornerRadius=UDim.new(0,8)
    AddPermanentRainbow(SB,2)
    SB.MouseButton1Click:Connect(function() if CurrentSound then pcall(function() CurrentSound:Destroy() end) end end)
end

-- ==============================================
-- 💻 FULL CONSOLE MENU (KEPT 100%)
-- ==============================================
local function ToggleConsole()
    if ConsoleUI then ConsoleUI:Destroy();ConsoleUI=nil;MenuOpen=(BoomUI~=nil);UpdateTouchLock();return end
    if BoomUI then BoomUI:Destroy();BoomUI=nil end
    MenuOpen=true;UpdateTouchLock()

    ConsoleUI = Instance.new("ScreenGui")
    ConsoleUI.Name="BLUE_CONSOLE"
    ConsoleUI.ResetOnSpawn=false
    ConsoleUI.ZIndexBehavior=Enum.ZIndexBehavior.Global
    ConsoleUI.DisplayOrder=MAX_Z
    ConsoleUI.IgnoreGuiInset=true
    ConsoleUI.Parent=CoreGui

    local F=Instance.new("Frame")
    F.Size=UDim2.new(0,350,0,320); F.Position=UDim2.new(0.5,-175,0.5,-160)
    F.BackgroundColor3=Color3.fromRGB(22,22,22); F.Active=true; F.ClipsDescendants=true
    F.Parent=ConsoleUI; Instance.new("UICorner",F).CornerRadius=UDim.new(0,12)
    AddPermanentRainbow(F,4)

    local X=Instance.new("TextButton")
    X.Size=UDim2.new(0,30,0,30); X.Position=UDim2.new(1,-35,0,5)
    X.BackgroundColor3=Color3.fromRGB(170,30,30); X.Text="✕"
    X.TextColor3=Color3.new(1,1,1); X.Font=Enum.Font.GothamBold; X.TextSize=24
    X.Parent=F; AddPermanentRainbow(X,2)
    X.MouseButton1Click:Connect(function() ConsoleUI:Destroy();ConsoleUI=nil;MenuOpen=(BoomUI~=nil);UpdateTouchLock() end)

    local T=Instance.new("TextLabel")
    T.Size=UDim2.new(1,0,0,35); T.Position=UDim2.new(0,0,0,8)
    T.BackgroundTransparency=1; T.Text="💻 EXECUTION CONSOLE"
    T.Font=Enum.Font.GothamBold; T.TextColor3=Color3.new(1,1,1); T.TextScaled=true
    T.Parent=F

    local C=Instance.new("TextBox")
    C.Size=UDim2.new(1,-30,0,170); C.Position=UDim2.new(0,15,0,50)
    C.BackgroundColor3=Color3.fromRGB(30,30,30); C.PlaceholderText="Paste code here..."
    C.TextColor3=Color3.new(1,1,1); C.Font=Enum.Font.Code; C.TextWrapped=true; C.MultiLine=true
    C.Parent=F; Instance.new("UICorner",C).CornerRadius=UDim.new(0,8)
    AddPermanentRainbow(C,2)

    local L=Instance.new("TextBox")
    L.Size=UDim2.new(1,-30,0,50); L.Position=UDim2.new(0,15,0,230)
    L.BackgroundColor3=Color3.fromRGB(25,25,25); L.Text="Console ready..."
    L.TextColor3=Color3.new(1,1,1); L.Font=Enum.Font.Code; L.ReadOnly=true; L.TextWrapped=true; L.MultiLine=true
    L.Parent=F; Instance.new("UICorner",L).CornerRadius=UDim.new(0,8)
    AddPermanentRainbow(L,2)

    local EB=Instance.new("TextButton")
    EB.Size=UDim2.new(0,90,0,30); EB.Position=UDim2.new(0,15,0,290)
    EB.BackgroundColor3=Color3.fromRGB(20,120,20); EB.Text="▶ EXECUTE"
    EB.TextColor3=Color3.new(1,1,1); EB.Font=Enum.Font.GothamBold; EB.TextScaled=true
    EB.Parent=F; Instance.new("UICorner",EB).CornerRadius=UDim.new(0,6)
    AddPermanentRainbow(EB,2)
    EB.MouseButton1Click:Connect(function()
        if C.Text=="" then return end
        local ok,err = pcall(loadstring or load, C.Text)
        L.Text = ok and "✅ SUCCESS!" or "❌ ERROR: "..tostring(err)
    end)

    local CB=Instance.new("TextButton")
    CB.Size=UDim2.new(0,90,0,30); CB.Position=UDim2.new(0,115,0,290)
    CB.BackgroundColor3=Color3.fromRGB(150,80,20); CB.Text="🗑️ CLEAR"
    CB.TextColor3=Color3.new(1,1,1); CB.Font=Enum.Font.GothamBold; CB.TextScaled=true
    CB.Parent=F; Instance.new("UICorner",CB).CornerRadius=UDim.new(0,6)
    AddPermanentRainbow(CB,2)
    CB.MouseButton1Click:Connect(function() C.Text=""; L.Text="Cleared" end)

    local XB=Instance.new("TextButton")
    XB.Size=UDim2.new(0,90,0,30); XB.Position=UDim2.new(0,215,0,290)
    XB.BackgroundColor3=Color3.fromRGB(140,20,20); XB.Text="✖ CLOSE"
    XB.TextColor3=Color3.new(1,1,1); XB.Font=Enum.Font.GothamBold; XB.TextScaled=true
    XB.Parent=F; Instance.new("UICorner",XB).CornerRadius=UDim.new(0,6)
    AddPermanentRainbow(XB,2)
    XB.MouseButton1Click:Connect(function() ConsoleUI:Destroy();ConsoleUI=nil;MenuOpen=(BoomUI~=nil);UpdateTouchLock() end)
end

-- ==============================================
-- 🎮 MAIN UI (ALWAYS ON TOP — KEPT 100%)
-- ==============================================
MainUI = Instance.new("ScreenGui")
MainUI.Name="BLUE_MODE_ESP"
MainUI.ResetOnSpawn=false
MainUI.ZIndexBehavior=Enum.ZIndexBehavior.Global
MainUI.DisplayOrder=MAX_Z
MainUI.IgnoreGuiInset=true
MainUI.Modal=false
MainUI.Parent=CoreGui

-- Auto-refresh always on top (KEPT)
task.spawn(function() while MainUI and MainUI.Parent do pcall(function()
    MainUI.DisplayOrder=MAX_Z
    if BoomUI then BoomUI.DisplayOrder=MAX_Z end
    if ConsoleUI then ConsoleUI.DisplayOrder=MAX_Z end
end) task.wait(1) end end)

-- Auto-hide on ESC menu (KEPT)
UserInputService.MenuOpened:Connect(function()
    if MainUI then MainUI.Visible=false end
    if BoomUI then BoomUI.Visible=false end
    if ConsoleUI then ConsoleUI.Visible=false end
end)
UserInputService.MenuClosed:Connect(function()
    if MainUI then MainUI.Visible=true end
    if BoomUI then BoomUI.Visible=true end
    if ConsoleUI then ConsoleUI.Visible=true end
end)

local MAIN_SIZE=UDim2.new(0,660,0,105); MIN_SIZE=UDim2.new(0,50,0,50)
local MF=Instance.new("Frame")
MF.Size=MAIN_SIZE; MF.Position=UDim2.new(0,20,0.5,-52)
MF.BackgroundColor3=Color3.fromRGB(25,25,25); MF.Active=true; MF.ClipsDescendants=false; MF.ZIndex=10
MF.Parent=MainUI; Instance.new("UICorner",MF).CornerRadius=UDim.new(0,8)
AddPermanentRainbow(MF,5)

local DB=Instance.new("TextButton") -- Drag Bar
DB.Size=UDim2.new(1,-25,0,22); DB.BackgroundColor3=Color3.fromRGB(60,140,220)
DB.Active=true; DB.Text="made by BLUE_MODE | DRAG HERE"
DB.TextColor3=Color3.new(1,1,1); DB.Font=Enum.Font.GothamBold; DB.TextScaled=true; DB.TextXAlignment=0
DB.Parent=MF; AddPermanentRainbow(DB,2)

local TL=Instance.new("TextLabel") -- Timer
TL.Size=UDim2.new(0,100,1,0); TL.Position=UDim2.new(1,-105,0,0)
TL.BackgroundTransparency=1; TL.Text="00:00:00 / 12:00:00"
TL.Font=Enum.Font.GothamBold; TL.TextColor3=Color3.new(1,1,1); TL.TextScaled=true; TL.TextXAlignment=2
TL.Parent=DB

local MB=Instance.new("TextButton") -- Min Button
MB.Size=UDim2.new(0,22,1,0); MB.Position=UDim2.new(1,-22,0,0)
MB.BackgroundColor3=Color3.fromRGB(160,40,40); MB.Text="➖"
MB.TextColor3=Color3.new(1,1,1); MB.Font=Enum.Font.GothamBold; MB.TextScaled=true
MB.Parent=MF; AddPermanentRainbow(MB,2)

-- ALL MAIN BUTTONS (KEPT — 6 TOTAL)
local ESPB=Instance.new("TextButton")
ESPB.Size=UDim2.new(0,85,0,30); ESPB.Position=UDim2.new(0,10,0,30)
ESPB.BackgroundColor3=Color3.fromRGB(40,40,40); ESPB.Text="ESP: OFF"
ESPB.TextColor3=Color3.new(1,1,1); ESPB.Font=Enum.Font.GothamBold; ESPB.TextScaled=true
ESPB.Parent=MF; Instance.new("UICorner",ESPB).CornerRadius=UDim.new(0,6)
AddPermanentRainbow(ESPB,2)

local YB=Instance.new("TextButton")
YB.Size=UDim2.new(0,95,0,30); YB.Position=UDim2.new(0,100,0,30)
YB.BackgroundColor3=Color3.fromRGB(200,30,30); YB.Text="📺 YOUTUBE"
YB.TextColor3=Color3.new(1,1,1); YB.Font=Enum.Font.GothamBold; YB.TextScaled=true
YB.Parent=MF; Instance.new("UICorner",YB).CornerRadius=UDim.new(0,6)
AddPermanentRainbow(YB,2)

local BB=Instance.new("TextButton")
BB.Size=UDim2.new(0,90,0,30); BB.Position=UDim2.new(0,200,0,30)
BB.BackgroundColor3=Color3.fromRGB(40,80,160); BB.Text="🎵 MUSIC"
BB.TextColor3=Color3.new(1,1,1); BB.Font=Enum.Font.GothamBold; BB.TextScaled=true
BB.Parent=MF; Instance.new("UICorner",BB).CornerRadius=UDim.new(0,6)
AddPermanentRainbow(BB,2)

local CB2=Instance.new("TextButton")
CB2.Size=UDim2.new(0,95,0,30); CB2.Position=UDim2.new(0,300,0,30)
CB2.BackgroundColor3=Color3.fromRGB(30,100,90); CB2.Text="💻 CONSOLE"
CB2.TextColor3=Color3.new(1,1,1); CB2.Font=Enum.Font.GothamBold; CB2.TextScaled=true
CB2.Parent=MF; Instance.new("UICorner",CB2).CornerRadius=UDim.new(0,6)
AddPermanentRainbow(CB2,2)

local LB=Instance.new("TextButton")
LB.Size=UDim2.new(0,90,0,30); LB.Position=UDim2.new(0,405,0,30)
LB.BackgroundColor3=Color3.fromRGB(50,50,50); LB.Text="🔓 UNLOCKED"
LB.TextColor3=Color3.new(1,1,1); LB.Font=Enum.Font.GothamBold; LB.TextScaled=true
LB.Parent=MF; Instance.new("UICorner",LB).CornerRadius=UDim.new(0,6)
AddPermanentRainbow(LB,2)

local DB2=Instance.new("TextButton") -- Exit
DB2.Size=UDim2.new(0,90,0,30); DB2.Position=UDim2.new(0,505,0,30)
DB2.BackgroundColor3=Color3.fromRGB(140,20,20); DB2.Text="🗑️ EXIT"
DB2.TextColor3=Color3.new(1,1,1); DB2.Font=Enum.Font.GothamBold; DB2.TextScaled=true
DB2.Parent=MF; Instance.new("UICorner",DB2).CornerRadius=UDim.new(0,6)
AddPermanentRainbow(DB2,2)

-- MAIN VOLUME SLIDER 0-1000 (KEPT)
local VLM=Instance.new("TextLabel")
VLM.Size=UDim2.new(0,70,0,25); VLM.Position=UDim2.new(0,10,0,65)
VLM.BackgroundTransparency=1; VLM.Text="🔊 VOLUME:"
VLM.Font=Enum.Font.Gotham; VLM.TextColor3=Color3.new(1,1,1); VLM.TextScaled=true; VLM.TextXAlignment=0
VLM.Parent=MF

VolNumMain=Instance.new("TextLabel")
VolNumMain.Size=UDim2.new(0,55,0,25); VolNumMain.Position=UDim2.new(0,85,0,65)
VolNumMain.BackgroundTransparency=1; VolNumMain.Text=math.floor(MusicVolume).."/1000"
VolNumMain.Font=Enum.Font.GothamBold; VolNumMain.TextColor3=Color3.new(1,1,1); VolNumMain.TextScaled=true; VolNumMain.TextXAlignment=2
VolNumMain.Parent=MF

local VBM=Instance.new("Frame")
VBM.Size=UDim2.new(0,150,0,18); VBM.Position=UDim2.new(0,145,0,67)
VBM.BackgroundColor3=Color3.fromRGB(50,50,50); VBM.Active=true; VBM.ClipsDescendants=true; VBM.ZIndex=15
VBM.Parent=MF; Instance.new("UICorner",VBM).CornerRadius=UDim.new(0,9)
AddPermanentRainbow(VBM,2)

VolFillMain=Instance.new("Frame")
VolFillMain.Size=UDim2.new(MusicVolume/1000,0,1,0)
VolFillMain.BackgroundColor3=Color3.fromRGB(100,100,100)
VolFillMain.Parent=VBM; Instance.new("UICorner",VolFillMain).CornerRadius=UDim.new(0,9)

local VSA=false
VBM.InputBegan:Connect(function(i) if i.UserInputType.Name:match("MouseButton1|Touch") then VSA=true; SetTouchLock(true) end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType.Name:match("MouseButton1|Touch") then if VSA then VSA=false; task.wait(0.05); UpdateTouchLock() end end end)
UserInputService.InputChanged:Connect(function(i) if VSA and i.UserInputType.Name:match("MouseMovement|Touch") then
    local r=math.clamp((i.Position.X-VBM.AbsolutePosition.X)/VBM.AbsoluteSize.X,0,1)
    UpdateVolume(r*1000)
end end)

-- STATES (KEPT)
local ESP_ON=false; LOCKED=false; HUE=0; SMALL=false

-- DRAG SYSTEM (KEPT — NO CAMERA MOVE)
local D={A=false,SX=0,SY=0,PX=0,PY=0}
DB.InputBegan:Connect(function(i)
    if LOCKED then return end
    if i.UserInputType.Name:match("MouseButton1|Touch") then
        D.A=true; D.SX=i.Position.X; D.SY=i.Position.Y
        D.PX=MF.Position.X.Offset; D.PY=MF.Position.Y.Offset
        SetTouchLock(true)
    end
end)
UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType.Name:match("MouseButton1|Touch") then if D.A then D.A=false; task.wait(0.05); UpdateTouchLock() end end
end)
UserInputService.InputChanged:Connect(function(i)
    if not D.A or LOCKED then return end
    if i.UserInputType.Name:match("MouseMovement|Touch") then
        MF.Position=UDim2.new(0,D.PX+(i.Position.X-D.SX),0,D.PY+(i.Position.Y-D.SY))
    end
end)

-- ALL BUTTON ACTIONS (KEPT 100%)
ESPB.MouseButton1Click:Connect(function()
    ESP_ON=not ESP_ON
    ESPB.Text=ESP_ON and "ESP: ON" or "ESP: OFF"
    ESPB.BackgroundColor3=ESP_ON and Color3.fromRGB(25,120,25) or Color3.fromRGB(40,40,40)
    if not ESP_ON then ClearESP() end
end)

YB.MouseButton1Click:Connect(function()
    SafeCopy(YOUTUBE_LINK)
    YB.Text="✅ COPIED!"
    task.wait(1.5); YB.Text="📺 YOUTUBE"
end)

BB.MouseButton1Click:Connect(OpenBoombox)
CB2.MouseButton1Click:Connect(ToggleConsole)

LB.MouseButton1Click:Connect(function()
    LOCKED=not LOCKED
    LB.Text=LOCKED and "🔒 LOCKED" or "🔓 UNLOCKED"
    LB.BackgroundColor3=LOCKED and Color3.fromRGB(180,40,40) or Color3.fromRGB(50,50,50)
end)

MB.MouseButton1Click:Connect(function()
    SMALL=not SMALL
    if SMALL then
        MF.Size=MIN_SIZE
        ESPB.Visible=false;YB.Visible=false;BB.Visible=false;CB2.Visible=false;LB.Visible=false;DB2.Visible=false
        VLM.Visible=false;VolNumMain.Visible=false;VBM.Visible=false
        DB.Text=""; MB.Text="➕"
    else
        MF.Size=MAIN_SIZE
        ESPB.Visible=true;YB.Visible=true;BB.Visible=true;CB2.Visible=true;LB.Visible=true;DB2.Visible=true
        VLM.Visible=true;VolNumMain.Visible=true;VBM.Visible=true
        DB.Text="made by BLUE_MODE | DRAG HERE"; MB.Text="➖"
    end
end)

DB2.MouseButton1Click:Connect(function()
    ClearESP()
    pcall(function() if CurrentSound then CurrentSound:Destroy() end end)
    if BoomUI then BoomUI:Destroy() end
    if ConsoleUI then ConsoleUI:Destroy() end
    MainUI:Destroy()
    getgenv().BlueMode_Loaded=nil
end)
-- ==============================================
-- END OF PART 1 — PASTE PART 2 RIGHT AFTER THIS
-- ==============================================

-- ==============================================
-- 🚀 MAIN LOOP | PART 2 OF 2
-- ALL FEATURES: PERMANENT RAINBOW · TIMER · ESP · FRIEND DOT
-- ==============================================
RunService.Heartbeat:Connect(function(dt)
    if not MainUI or not MainUI.Parent then return end

    -- ⏳ USAGE TIMER (KEPT)
    local N=os.time()
    UsedTime += math.max(0,N-LastCheck); LastCheck=N
    SafeWriteFile(SAVE_USED, UsedTime)
    local REMAIN=math.max(0,USAGE_LIMIT-UsedTime)
    TL.Text=string.format("%02d:%02d:%02d / 12:00:00", math.floor(REMAIN/3600), math.floor((REMAIN%3600)/60), REMAIN%60)
    if REMAIN<=0 then
        SafeWriteFile(SAVE_COOLDOWN, os.time()+COOLDOWN)
        pcall(function() if delfile then delfile(SAVE_USED..".txt") end end)
        DB2:Fire(); return
    end

    -- ✅ PERMANENT RAINBOW ANIMATION (NEVER STOPS — ALL UI)
    HUE = (HUE + dt*0.5) % 1
    local RAINBOW = Color3.fromHSV(HUE,1,1)
    for _,Outline in ipairs(AllRainbowOutlines) do Outline.Color = RAINBOW end
    if VolFillMain then VolFillMain.BackgroundColor3 = RAINBOW end
    if VolFillMenu then VolFillMenu.BackgroundColor3 = RAINBOW end
    TL.TextColor3 = RAINBOW

    -- 👁️ FULL ESP + FRIEND DOT (KEPT 100%)
    if not ESP_ON then return end
    for _,P in pairs(Players:GetPlayers()) do
        if P==LocalPlayer then continue end
        local Char=P.Character
        if not Char then continue end
        local Hum=Char:FindFirstChildOfClass("Humanoid")
        if not Hum or Hum.Health<=0 then
            pcall(function()
                if Char:FindFirstChild("BLUE_Outline") then Char.BLUE_Outline:Destroy() end
                if Char:FindFirstChild("FriendRainbowDot") then Char.FriendRainbowDot:Destroy() end
            end)
            continue
        end

        -- Player Rainbow Outline
        local Outline = Char:FindFirstChild("BLUE_Outline") or Instance.new("Highlight", Char)
        Outline.Name = "BLUE_Outline"
        Outline.FillTransparency = 1
        Outline.OutlineTransparency = 0
        Outline.OutlineColor = RAINBOW
        Outline.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

        -- Friend Rainbow Dot Above Head
        local IsFriend = false
        pcall(function() IsFriend = LocalPlayer:IsFriendsWith(P.UserId) end)
        local Head = Char:FindFirstChild("Head")
        local Dot = Char:FindFirstChild("FriendRainbowDot")

        if IsFriend and Head then
            if not Dot then
                Dot = Instance.new("BillboardGui", Char)
                Dot.Name = "FriendRainbowDot"
                Dot.AlwaysOnTop = true
                Dot.Size = UDim2.new(0,18,0,18)
                Dot.StudsOffset = Vector3.new(0,3,0)
                Dot.Adornee = Head
                local Circle = Instance.new("Frame", Dot)
                Circle.Size = UDim2.new(1,0,1,0)
                Circle.BackgroundColor3 = RAINBOW
                Instance.new("UICorner", Circle).CornerRadius = UDim.new(1,0)
            else
                Dot.Frame.BackgroundColor3 = RAINBOW
            end
        elseif Dot then
            Dot:Destroy()
        end
    end
end)

print("✅ BLUE MODE ESP v2.5 FULLY LOADED!")
print("✅ ALL FEATURES INTACT: Permanent Rainbow · Always On Top · No Touch Block · Console · 0-1000 Volume · ESP · Friend Dot · Drag · Lock · Minimize")
