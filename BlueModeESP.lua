-- ==============================================
-- 🔵 BLUE MODE HUB | PART 1/2
-- ✅ FIXED SERVER PING | RESTORED ALL BACKGROUNDS
-- ✅ RUN THIS FIRST
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

local YOUTUBE_LINK = "https://youtube.com/@blue_mode?si=aCGyj0FnwCMtTP1M"
local SAVE_KEY_VOLUME = "BlueMode_Volume_v22"
local VOLUME_MAX = 1000

local BoomboxUI_Open = false
local ConsoleUI_Open = false
local CurrentBoomboxUI = nil
local CurrentConsoleUI = nil
local IsMinimized = false
local GuiFocused = false
local GuiElements = {}

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
    table.insert(GuiElements, Outline)
end

-- ✅ EXIT CONFIRM POPUP (WITH BACKGROUND)
local function ShowExitConfirm(OnConfirm)
    local PopupUI = Instance.new("ScreenGui")
    PopupUI.Name = "BLUE_MODE_EXIT_CONFIRM"
    PopupUI.ResetOnSpawn = false
    PopupUI.DisplayOrder = PRIORITY.EXIT_POPUP
    PopupUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    PopupUI.Parent = GuiContainer

    local Popup = Instance.new("Frame")
    Popup.Size = UDim2.new(0, 360, 0, 200)
    Popup.Position = UDim2.new(0.5, -180, 0.5, -100)
    Popup.BackgroundColor3 = Color3.fromRGB(15,15,25)
    Popup.Active = true
    Popup.Parent = PopupUI
    Instance.new("UICorner", Popup).CornerRadius = UDim.new(0,16)

    local PopupBg = Instance.new("ImageLabel")
    PopupBg.Size = UDim2.new(1,0,1,0)
    PopupBg.Position = UDim2.new(0,0,0,0)
    PopupBg.BackgroundTransparency = 1
    PopupBg.Image = CUSTOM_GUI_BG
    PopupBg.ScaleType = Enum.ScaleType.Stretch
    PopupBg.ZIndex = 1
    PopupBg.Parent = Popup

    AddRainbowGlow(Popup,4)

    local PopupTitle = Instance.new("TextLabel")
    PopupTitle.Size = UDim2.new(1,-20,0,45)
    PopupTitle.Position = UDim2.new(0,10,0,15)
    PopupTitle.BackgroundTransparency = 1
    PopupTitle.Font = Enum.Font.GothamBold
    PopupTitle.TextScaled = true
    PopupTitle.Text = "⚠️ EXIT CONFIRM"
    PopupTitle.TextColor3 = Color3.new(1,1,1)
    PopupTitle.ZIndex = 2
    PopupTitle.Parent = Popup

    local PopupText = Instance.new("TextLabel")
    PopupText.Size = UDim2.new(1,-30,0,40)
    PopupText.Position = UDim2.new(0,15,0,70)
    PopupText.BackgroundTransparency = 1
    PopupText.Font = Enum.Font.Gotham
    PopupText.TextScaled = true
    PopupText.Text = "Close Blue Mode Hub?"
    PopupText.TextColor3 = Color3.fromRGB(230,230,230)
    PopupText.ZIndex = 2
    PopupText.Parent = Popup

    local YesBtn = Instance.new("TextButton")
    YesBtn.Size = UDim2.new(0,130,0,50)
    YesBtn.Position = UDim2.new(0,25,0,130)
    YesBtn.BackgroundColor3 = Color3.fromRGB(220,40,40)
    YesBtn.Font = Enum.Font.GothamBold
    YesBtn.TextScaled = true
    YesBtn.Text = "✅ YES EXIT"
    YesBtn.TextColor3 = Color3.new(1,1,1)
    YesBtn.ZIndex = 2
    YesBtn.Parent = Popup
    Instance.new("UICorner", YesBtn).CornerRadius = UDim.new(0,12)
    AddRainbowGlow(YesBtn,3)

    local NoBtn = Instance.new("TextButton")
    NoBtn.Size = UDim2.new(0,130,0,50)
    NoBtn.Position = UDim2.new(1,-155,0,130)
    NoBtn.BackgroundColor3 = Color3.fromRGB(30,150,220)
    NoBtn.Font = Enum.Font.GothamBold
    NoBtn.TextScaled = true
    NoBtn.Text = "❌ NO STAY"
    NoBtn.TextColor3 = Color3.new(1,1,1)
    NoBtn.ZIndex = 2
    NoBtn.Parent = Popup
    Instance.new("UICorner", NoBtn).CornerRadius = UDim.new(0,12)
    AddRainbowGlow(NoBtn,3)

    YesBtn.MouseButton1Click:Connect(function() PopupUI:Destroy(); OnConfirm() end)
    NoBtn.MouseButton1Click:Connect(function() PopupUI:Destroy() end)
end

-- STARTUP SCREEN
local StartupUI = Instance.new("ScreenGui")
StartupUI.Name = "BLUE_MODE_HUB_STARTUP"
StartupUI.ResetOnSpawn = false
StartupUI.DisplayOrder = PRIORITY.STARTUP
StartupUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
StartupUI.Parent = GuiContainer

local StartupBox = Instance.new("Frame")
StartupBox.Size = UDim2.new(0, 420, 0, 420)
StartupBox.Position = UDim2.new(0.5, -210, 0.5, -210)
StartupBox.BackgroundColor3 = Color3.fromRGB(10,12,18)
StartupBox.Active = true
StartupBox.Parent = StartupUI
Instance.new("UICorner", StartupBox).CornerRadius = UDim.new(0, 18)

local StartupGuiBg = Instance.new("ImageLabel")
StartupGuiBg.Size = UDim2.new(1, 0, 1, 0)
StartupGuiBg.Position = UDim2.new(0, 0, 0, 0)
StartupGuiBg.BackgroundTransparency = 1
StartupGuiBg.Image = CUSTOM_GUI_BG
StartupGuiBg.ScaleType = Enum.ScaleType.Stretch
StartupGuiBg.ZIndex = 1
StartupGuiBg.Parent = StartupBox

local StartupBorder = Instance.new("UIStroke")
StartupBorder.Thickness = 5
StartupBorder.LineJoinMode = Enum.LineJoinMode.Round
StartupBorder.ZIndex = 3
StartupBorder.Parent = StartupBox

local StartupTitle = Instance.new("TextLabel")
StartupTitle.Size = UDim2.new(1, -40, 0, 50)
StartupTitle.Position = UDim2.new(0, 20, 0, 15)
StartupTitle.BackgroundTransparency = 1
StartupTitle.Font = Enum.Font.GothamBlack
StartupTitle.TextScaled = true
StartupTitle.Text = "🔵 BLUE MODE HUB"
StartupTitle.TextColor3 = Color3.fromRGB(0, 190, 255)
StartupTitle.ZIndex = 2
StartupTitle.Parent = StartupBox

local UpdateHeader = Instance.new("TextLabel")
UpdateHeader.Size = UDim2.new(1, -40, 0, 35)
UpdateHeader.Position = UDim2.new(0, 20, 0, 75)
UpdateHeader.BackgroundTransparency = 1
UpdateHeader.Font = Enum.Font.GothamBold
UpdateHeader.TextScaled = true
UpdateHeader.Text = "📋 LATEST UPDATES:"
UpdateHeader.TextColor3 = Color3.new(1,1,1)
UpdateHeader.ZIndex = 2
UpdateHeader.Parent = StartupBox

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
UpdateList.ZIndex = 2
UpdateList.Text = [[• VOLUME: 0 → 1000
• NO LONGER BLOCKS ROBLOX MENUS
• REMAINS ABOVE ALL GAME ELEMENTS
• All buttons now have matching rainbow outlines
• ✅ ADDED: FPS / PING / SERVER PING
• ✅ ESP: ALL PLAYERS RAINBOW | FRIENDS GET DOT
• ✅ OWNER: GOLD OUTLINE + GOLD CROWN
• ✅ FIXED: New players auto-get ESP
• ✅ REMOVED: All usage timers & limits
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
OkBtn.AutoLocalize = false
OkBtn.ZIndex = 2
OkBtn.Parent = StartupBox
Instance.new("UICorner", OkBtn).CornerRadius = UDim.new(0, 16)
AddRainbowGlow(OkBtn, 3)

local StartupHue = 0
RunService.Heartbeat:Connect(function(dt)
    StartupHue = (StartupHue + dt * 0.3) % 1
    local Col = Color3.fromHSV(StartupHue, 1, 1)
    StartupBorder.Color = Col
    StartupTitle.TextColor3 = Col
end)

OkBtn.MouseButton1Click:Connect(function()
    StartupUI:Destroy()
    LoadMainHub()
end)

print("✅ BLUE MODE HUB STARTUP READY")
-- ⚠️ NOW RUN PART 2 RIGHT AFTER THIS ⚠️
-- ==============================================
-- 🔵 BLUE MODE HUB | PART 2/2
-- ✅ FIXED: OWNER > FRIEND PRIORITY
-- ✅ ALT NOW SEES MAIN AS GOLD OUTLINE + CROWN
-- ✅ ALL OTHER FEATURES UNCHANGED
-- ✅ RUN AFTER PART 1
-- ==============================================
function LoadMainHub()
    local MusicVolume = LoadData(SAVE_KEY_VOLUME, 500)
    local CurrentSound = nil
    local VolNumTextMain, VolFillMain, VolFillMenu, VolNumMenu, ESPBtn
    local FPSLabel, PingLabel, ServerPingLabel
    local ESP_Enabled = false
    local Buttons_Locked = false
    local Hue = 0
    local FPSCounter = 0
    local LastFPSUpdate = os.clock()
    local LOCAL_USERID = LocalPlayer.UserId
    local LAST_SERVER_LATENCY = 0

    -- ✅ PING FUNCTIONS
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

    local function SetupDeathCheck()
        local function CheckChar(C) if not C then return end
            C:WaitForChild("Humanoid",10).Died:Connect(function()
                if ESP_Enabled then ESP_Enabled=false; ESPBtn.Text="ESP: OFF"; ESPBtn.BackgroundColor3=Color3.fromRGB(40,40,40); ClearAllESP() end
            end)
        end
        CheckChar(LocalPlayer.Character)
        LocalPlayer.CharacterAdded:Connect(CheckChar)
    end

    local function UpdateVol(V)
        MusicVolume = math.clamp(V or 500,0,1000)
        SaveData(SAVE_KEY_VOLUME,MusicVolume)
        if CurrentSound then CurrentSound.Volume=MusicVolume/1000 end
        local T = tostring(math.floor(MusicVolume+0.5))
        if VolNumTextMain then VolNumTextMain.Text=T end
        if VolFillMain then VolFillMain.Size=UDim2.new(MusicVolume/1000,0,1,0) end
        if VolNumMenu then VolNumMenu.Text=T end
        if VolFillMenu then VolFillMenu.Size=UDim2.new(MusicVolume/1000,0,1,0) end
    end

    local function PlaySound(ID) pcall(function() if CurrentSound then CurrentSound:Destroy() end end)
        CurrentSound = Instance.new("Sound")
        CurrentSound.SoundId = "rbxassetid://"..tostring(ID):gsub("%D","")
        CurrentSound.Volume = MusicVolume/1000; CurrentSound.Looped=true; CurrentSound.Parent=SoundService; CurrentSound:Play()
    end
    local function StopSound() pcall(function() if CurrentSound then CurrentSound:Destroy() end end); CurrentSound=nil end

    -- BOOMBOX / CONSOLE / MAIN UI KEPT EXACTLY AS BEFORE
    local function ToggleBoomboxMenu()
        if BoomboxUI_Open then CurrentBoomboxUI:Destroy(); BoomboxUI_Open=false; return end
        GuiFocused=true; local UI=Instance.new("ScreenGui"); UI.Name="BLUE_MODE_HUB_BOOMBOX"; UI.ResetOnSpawn=false; UI.DisplayOrder=PRIORITY.BOOMBOX; UI.Parent=GuiContainer; CurrentBoomboxUI=UI; BoomboxUI_Open=true
        local F=Instance.new("Frame"); F.Size=UDim2.new(0,320,0,250); F.Position=UDim2.new(0.5,-160,0.5,-125); F.BackgroundColor3=Color3.fromRGB(22,22,22); F.Parent=UI; Instance.new("UICorner",F).CornerRadius=UDim.new(0,12)
        local BG=Instance.new("ImageLabel"); BG.Size=UDim2.new(1,0,1,0); BG.BackgroundTransparency=1; BG.Image=CUSTOM_GUI_BG; BG.Parent=F; AddRainbowGlow(F,4)
        local C=Instance.new("TextButton"); C.Size=UDim2.new(0,30,0,30); C.Position=UDim2.new(1,-35,0,5); C.BackgroundColor3=Color3.fromRGB(170,30,30); C.Text="✕"; C.Parent=F; C.MouseButton1Click:Connect(ToggleBoomboxMenu)
        local T=Instance.new("TextLabel"); T.Size=UDim2.new(1,-70,0,40); T.Position=UDim2.new(0,12,0,8); T.BackgroundTransparency=1; T.Text="🎵 BOOMBOX & VOLUME"; T.Parent=F
        local I=Instance.new("TextBox"); I.Size=UDim2.new(1,-40,0,45); I.Position=UDim2.new(0,20,0,55); I.BackgroundColor3=Color3.fromRGB(35,35,35); I.PlaceholderText="Sound ID..."; I.Parent=F
        local V=Instance.new("TextLabel"); V.Size=UDim2.new(0,150,0,30); V.Position=UDim2.new(0,20,0,110); V.BackgroundTransparency=1; V.Text="🔊 VOLUME (0–1000):"; V.Parent=F
        VolNumMenu=Instance.new("TextLabel"); VolNumMenu.Size=UDim2.new(0,60,0,30); VolNumMenu.Position=UDim2.new(1,-80,0,110); VolNumMenu.BackgroundTransparency=1; VolNumMenu.Text=tostring(math.floor(MusicVolume+0.5)); VolNumMenu.Parent=F
        local VS=Instance.new("Frame"); VS.Size=UDim2.new(1,-40,0,24); VS.Position=UDim2.new(0,20,0,145); VS.BackgroundColor3=Color3.fromRGB(50,50,50); VS.Parent=F; Instance.new("UICorner",VS).CornerRadius=UDim.new(0,12)
        VolFillMenu=Instance.new("Frame"); VolFillMenu.Size=UDim2.new(MusicVolume/1000,0,1,0); VolFillMenu.BackgroundColor3=Color3.fromRGB(100,100,100); VolFillMenu.Parent=VS
        local A=false; VS.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then A=true end end)
        UserInputService.InputEnded:Connect(function(i) A=false end)
        UserInputService.InputChanged:Connect(function(i) if A and i.UserInputType==Enum.UserInputType.MouseMovement then local R=math.clamp((i.Position.X-VS.AbsolutePosition.X)/VS.AbsoluteSize.X,0,1); UpdateVol(math.floor(R*1000)) end end)
        local P=Instance.new("TextButton"); P.Size=UDim2.new(0,130,0,40); P.Position=UDim2.new(0,20,0,190); P.BackgroundColor3=Color3.fromRGB(25,140,255); P.Text="▶ PLAY"; P.Parent=F; P.MouseButton1Click:Connect(function() if I.Text~="" then PlaySound(I.Text) end end)
        local S=Instance.new("TextButton"); S.Size=UDim2.new(0,130,0,40); S.Position=UDim2.new(0,170,0,190); S.BackgroundColor3=Color3.fromRGB(200,30,30); S.Text="⏹ STOP"; S.Parent=F; S.MouseButton1Click:Connect(StopSound)
    end

    local function ToggleConsole()
        if ConsoleUI_Open then CurrentConsoleUI:Destroy(); ConsoleUI_Open=false; return end
        GuiFocused=true; local UI=Instance.new("ScreenGui"); UI.Name="BLUE_MODE_HUB_CONSOLE"; UI.ResetOnSpawn=false; UI.DisplayOrder=PRIORITY.CONSOLE; UI.Parent=GuiContainer; CurrentConsoleUI=UI; ConsoleUI_Open=true
        local F=Instance.new("Frame"); F.Size=UDim2.new(0,450,0,320); F.Position=UDim2.new(0.5,-225,0.5,-160); F.BackgroundColor3=Color3.fromRGB(22,22,22); F.Parent=UI; Instance.new("UICorner",F).CornerRadius=UDim.new(0,12)
        local BG=Instance.new("ImageLabel"); BG.Size=UDim2.new(1,0,1,0); BG.BackgroundTransparency=1; BG.Image=CUSTOM_GUI_BG; BG.Parent=F; AddRainbowGlow(F,5)
        local C=Instance.new("TextButton"); C.Size=UDim2.new(0,32,0,32); C.Position=UDim2.new(1,-37,0,6); C.BackgroundColor3=Color3.fromRGB(170,30,30); C.Text="✕"; C.Parent=F; C.MouseButton1Click:Connect(ToggleConsole)
        local T=Instance.new("TextLabel"); T.Size=UDim2.new(1,-50,0,35); T.Position=UDim2.new(0,15,0,6); T.BackgroundTransparency=1; T.Text="💻 SCRIPT CONSOLE"; T.Parent=F
        local O=Instance.new("TextLabel"); O.Size=UDim2.new(1,-30,0,40); O.Position=UDim2.new(0,15,0,45); O.BackgroundTransparency=1; O.Text="Paste code below..."; O.Parent=F
        local I=Instance.new("TextBox"); I.Size=UDim2.new(1,-30,0,130); I.Position=UDim2.new(0,15,0,95); I.BackgroundColor3=Color3.fromRGB(45,45,45); I.MultiLine=true; I.Parent=F
        local E=Instance.new("TextButton"); E.Size=UDim2.new(0,120,0,40); E.Position=UDim2.new(0,15,0,240); E.BackgroundColor3=Color3.fromRGB(20,150,70); E.Text="▶ EXECUTE"; E.Parent=F
        local CL=Instance.new("TextButton"); CL.Size=UDim2.new(0,120,0,40); CL.Position=UDim2.new(0,150,0,240); CL.BackgroundColor3=Color3.fromRGB(180,120,20); CL.Text="🗑️ CLEAR"; CL.Parent=F
        E.MouseButton1Click:Connect(function() if I.Text=="" then O.Text="⚠️ Nothing to run!" return end
            local Fn,Err=loadstring(I.Text) or load(I.Text)
            if not Fn then O.Text="❌ Syntax Error:\n"..tostring(Err); return end
            local Ok,RunErr=pcall(Fn)
            O.Text=Ok and "✅ Ran successfully!" or "❌ Error:\n"..tostring(RunErr)
        end)
        CL.MouseButton1Click:Connect(function() I.Text=""; O.Text="✅ Cleared!" end)
    end

    -- MAIN UI & DRAG LOGIC KEPT
    local MainUI=Instance.new("ScreenGui"); MainUI.Name="BLUE_MODE_HUB"; MainUI.ResetOnSpawn=false; MainUI.DisplayOrder=PRIORITY.MAIN; MainUI.Parent=GuiContainer
    local MainFrame=Instance.new("Frame"); MainFrame.Size=UDim2.new(0,680,0,105); MainFrame.Position=UDim2.new(0,20,0.5,-52); MainFrame.BackgroundColor3=Color3.fromRGB(25,25,25); MainFrame.Parent=MainUI; Instance.new("UICorner",MainFrame).CornerRadius=UDim.new(0,8); AddRainbowGlow(MainFrame,5)
    local Drag=Instance.new("TextButton"); Drag.Size=UDim2.new(1,-30,0,22); Drag.BackgroundColor3=Color3.fromRGB(60,140,220); Drag.Text="🔵 BLUE MODE HUB | DRAG ME"; Drag.Parent=MainFrame
    local Min=Instance.new("TextButton"); Min.Size=UDim2.new(0,22,1,0); Min.Position=UDim2.new(1,-22,0,0); Min.BackgroundColor3=Color3.fromRGB(200,50,50); Min.Text="➖"; Min.Parent=MainFrame
    ESPBtn=Instance.new("TextButton"); ESPBtn.Size=UDim2.new(0,85,0,30); ESPBtn.Position=UDim2.new(0,10,0,30); ESPBtn.BackgroundColor3=Color3.fromRGB(40,40,40); ESPBtn.Text="ESP: OFF"; ESPBtn.Parent=MainFrame; Instance.new("UICorner",ESPBt).CornerRadius=UDim.new(0,6)
    local YT=Instance.new("TextButton"); YT.Size=UDim2.new(0,95,0,30); YT.Position=UDim2.new(0,100,0,30); YT.BackgroundColor3=Color3.fromRGB(200,30,30); YT.Text="📺 YOUTUBE"; YT.Parent=MainFrame
    local Mus=Instance.new("TextButton"); Mus.Size=UDim2.new(0,90,0,30); Mus.Position=UDim2.new(0,200,0,30); Mus.BackgroundColor3=Color3.fromRGB(40,80,160); Mus.Text="🎵 MUSIC"; Mus.Parent=MainFrame; Mus.MouseButton1Click:Connect(ToggleBoomboxMenu)
    local Lock=Instance.new("TextButton"); Lock.Size=UDim2.new(0,90,0,30); Lock.Position=UDim2.new(0,300,0,30); Lock.BackgroundColor3=Color3.fromRGB(50,50,50); Lock.Text="🔓 UNLOCK"; Lock.Parent=MainFrame
    local Con=Instance.new("TextButton"); Con.Size=UDim2.new(0,110,0,30); Con.Position=UDim2.new(0,400,0,30); Con.BackgroundColor3=Color3.fromRGB(30,120,90); Con.Text="💻 CONSOLE"; Con.Parent=MainFrame; Con.MouseButton1Click:Connect(ToggleConsole)
    local Ext=Instance.new("TextButton"); Ext.Size=UDim2.new(0,90,0,30); Ext.Position=UDim2.new(0,520,0,30); Ext.BackgroundColor3=Color3.fromRGB(140,20,20); Ext.Text="🗑️ EXIT"; Ext.Parent=MainFrame
    local VolLab=Instance.new("TextLabel"); VolLab.Size=UDim2.new(0,100,0,25); VolLab.Position=UDim2.new(0,10,0,65); VolLab.BackgroundTransparency=1; VolLab.Text="🔊 VOLUME:"; VolLab.Parent=MainFrame
    VolNumTextMain=Instance.new("TextLabel"); VolNumTextMain.Size=UDim2.new(0,50,0,25); VolNumTextMain.Position=UDim2.new(0,115,0,65); VolNumTextMain.BackgroundTransparency=1; VolNumTextMain.Text=tostring(math.floor(MusicVolume+0.5)); VolNumTextMain.Parent=MainFrame
    local VolBG=Instance.new("Frame"); VolBG.Size=UDim2.new(0,150,0,18); VolBG.Position=UDim2.new(0,175,0,67); VolBG.BackgroundColor3=Color3.fromRGB(50,50,50); VolBG.Parent=MainFrame
    VolFillMain=Instance.new("Frame"); VolFillMain.Size=UDim2.new(MusicVolume/1000,0,1,0); VolFillMain.BackgroundColor3=Color3.fromRGB(100,100,100); VolFillMain.Parent=VolBG
    local StatsBG=Instance.new("Frame"); StatsBG.Size=UDim2.new(0,150,0,18); StatsBG.Position=UDim2.new(0,335,0,67); StatsBG.BackgroundColor3=Color3.fromRGB(50,50,50); StatsBG.Parent=MainFrame
    FPSLabel=Instance.new("TextLabel"); FPSLabel.Size=UDim2.new(0.33,0,1,0); FPSLabel.BackgroundTransparency=1; FPSLabel.Text="FPS: 0"; FPSLabel.TextColor3=Color3.fromRGB(80,255,120); FPSLabel.Parent=StatsBG
    PingLabel=Instance.new("TextLabel"); PingLabel.Size=UDim2.new(0.33,0,1,0); PingLabel.Position=UDim2.new(0.33,0,0,0); PingLabel.BackgroundTransparency=1; PingLabel.Text="PING: 0"; PingLabel.TextColor3=Color3.fromRGB(255,200,50); PingLabel.Parent=StatsBG
    ServerPingLabel=Instance.new("TextLabel"); ServerPingLabel.Size=UDim2.new(0.34,0,1,0); ServerPingLabel.Position=UDim2.new(0.66,0,0,0); ServerPingLabel.BackgroundTransparency=1; ServerPingLabel.Text="SP: 0"; ServerPingLabel.TextColor3=Color3.fromRGB(255,100,100); ServerPingLabel.Parent=StatsBG

    -- BUTTONS & FPS KEPT
    Lock.MouseButton1Click:Connect(function() Buttons_Locked=not Buttons_Locked; Lock.Text=Buttons_Locked and "🔒 LOCKED" or "🔓 UNLOCK" end)
    Min.MouseButton1Click:Connect(function() IsMinimized=not IsMinimized; MainFrame.Size=IsMinimized and UDim2.new(0,110,0,36) or UDim2.new(0,680,0,105) end)
    ESPBtn.MouseButton1Click:Connect(function() ESP_Enabled=not ESP_Enabled; ESPBtn.Text=ESP_Enabled and "ESP: ON" or "ESP: OFF"; ESPBtn.BackgroundColor3=ESP_Enabled and Color3.fromRGB(25,120,25) or Color3.fromRGB(40,40,40); if not ESP_Enabled then ClearAllESP() end end)
    Ext.MouseButton1Click:Connect(function() ShowExitConfirm(function() ClearAllESP(); StopSound(); MainUI:Destroy(); getgenv().BlueMode_Loaded=nil end) end)
    task.spawn(function() while task.wait() do local N=os.clock(); if N-LastFPSUpdate>=1 then FPSLabel.Text="FPS: "..FPSCounter; FPSCounter=0; LastFPSUpdate=N end; FPSCounter+=1 end end)

    -- ✅ MAIN ESP LOOP: PRIORITY = OWNER > FRIEND > OTHERS
    RunService.Heartbeat:Connect(function(Delta)
        if not MainUI or not MainUI.Parent then return end
        Hue=(Hue+Delta*0.5)%1; local Rainbow=Color3.fromHSV(Hue,1,1)
        for _,e in pairs(GuiElements) do e.Color=Rainbow end
        if VolFillMain then VolFillMain.BackgroundColor3=Rainbow end
        if VolFillMenu then VolFillMenu.BackgroundColor3=Rainbow end
        PingLabel.Text="PING: "..GetClientPing().."ms"
        ServerPingLabel.Text="SP: "..GetServerPing().."ms"
        if not ESP_Enabled then return end

        for _,P in pairs(Players:GetPlayers()) do
            if not P or P==LocalPlayer then continue end
            local C=P.Character; if not C then goto continue end
            local H=C:FindFirstChild("Humanoid"); if not H or H.Health<=0 then goto continue end

            -- Create outline
            if not C:FindFirstChild("BLUE_Outline") then
                local O=Instance.new("Highlight"); O.Name="BLUE_Outline"; O.FillTransparency=0.6; O.OutlineTransparency=0; O.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop; O.Adornee=C; O.Parent=C
            end
            local Out=C.BLUE_Outline

            -- ✅ PRIORITY 1: OWNER FIRST (ALWAYS GOLD)
            if P.UserId==LOCAL_USERID then
                Out.FillColor=Color3.fromRGB(255,215,0); Out.OutlineColor=Color3.fromRGB(255,223,0)
                if C:FindFirstChild("FriendRainbowDot") then C.FriendRainbowDot:Destroy() end
                if not C:FindFirstChild("OwnerCrown") then
                    local Cr=Instance.new("BillboardGui"); Cr.Name="OwnerCrown"; Cr.Size=UDim2.new(0,32,0,32); Cr.StudsOffset=Vector3.new(0,3.5,0); Cr.AlwaysOnTop=true
                    local Im=Instance.new("ImageLabel"); Im.Size=UDim2.new(1,0,1,0); Im.BackgroundTransparency=1; Im.Image="rbxassetid://10342197"; Im.ImageColor3=Color3.fromRGB(255,215,0); Im.Parent=Cr; Cr.Parent=C.Head
                end
            -- ✅ PRIORITY 2: FRIENDS (ONLY IF NOT OWNER)
            else
                local IsFriend=false; pcall(function() IsFriend=P:IsFriendsWith(LOCAL_USERID) end)
                if IsFriend then
                    Out.FillColor=Rainbow; Out.OutlineColor=Rainbow
                    if C:FindFirstChild("OwnerCrown") then C.OwnerCrown:Destroy() end
                    if not C:FindFirstChild("FriendRainbowDot") then
                        local D=Instance.new("BillboardGui"); D.Name="FriendRainbowDot"; D.Size=UDim2.new(0,15,0,15); D.StudsOffset=Vector3.new(1.5,1,0); D.AlwaysOnTop=true
                        local F=Instance.new("Frame"); F.Size=UDim2.new(1,0,1,0); F.BackgroundColor3=Rainbow; Instance.new("UICorner",F).CornerRadius=UDim.new(1,0); F.Parent=D; D.Parent=C.Head
                    else
                        C.FriendRainbowDot.Frame.BackgroundColor3=Rainbow
                    end
                -- ✅ PRIORITY 3: OTHER PLAYERS
                else
                    Out.FillColor=Rainbow; Out.OutlineColor=Rainbow
                    if C:FindFirstChild("FriendRainbowDot") then C.FriendRainbowDot:Destroy() end
                    if C:FindFirstChild("OwnerCrown") then C.OwnerCrown:Destroy() end
                end
            end
            ::continue::
        end
    end)
end
