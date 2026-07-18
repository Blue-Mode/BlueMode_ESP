-- ==============================================
-- BLUE MODE ESP
-- ✅ Dots Hide With ESP OFF/Exit
-- ✅ All Menus: Own Drag, Own Lock, Own Shrink
-- ✅ No Extra Features Added
-- ==============================================
if getgenv().BlueMode_Loaded then return end
getgenv().BlueMode_Loaded = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 10) or game:GetService("CoreGui")

-- SETTINGS
local YOUTUBE_LINK = "https://youtube.com/@blue_mode?si=aCGyj0FnwCMtTP1M"

-- STATES
local Boombox_Open = false
local Console_Open = false
local Boombox_Locked = false
local Console_Locked = false
local Main_Locked = false
local ESP_Enabled = false

-- CLEANUP DOTS + OUTLINES ONLY
local function ClearESP()
    for _,P in pairs(Players:GetPlayers()) do
        if P and P.Character then
            pcall(function()
                if P.Character:FindFirstChild("BLUE_Outline") then P.Character.BLUE_Outline:Destroy() end
                if P.Character:FindFirstChild("FriendRainbowDot") then P.Character.FriendRainbowDot:Destroy() end
            end)
        end
    end
end

-- DEATH: CLEAR VISUALS ONLY
local function SetupDeath()
    local function CheckChar(Char)
        if not Char then return end
        local Hum = Char:WaitForChild("Humanoid")
        if Hum then
            Hum.Died:Connect(ClearESP)
        end
    end
    CheckChar(LocalPlayer.Character)
    LocalPlayer.CharacterAdded:Connect(function()
        task.wait(1)
        if ESP_Enabled then
            ESPBtn.Text = "ESP: ON"
            ESPBtn.BackgroundColor3 = Color3.fromRGB(25,120,25)
        end
    end)
end

-- UNIVERSAL: OWN DRAG, OWN LOCK, OWN SHRINK
local function SetupMenu(Frame, DragBar, LockBtn, MinBtn, FullSize, MiniSize, LockRef)
    local DragState = {Active=false, sX=0, sY=0, pX=0, pY=0}
    local Screen = UserInputService:GetScreenSize()

    LockBtn.Text = LockRef and "🔒" or "🔓"
    LockBtn.BackgroundColor3 = LockRef and Color3.fromRGB(180,40,40) or Color3.fromRGB(50,50,50)
    LockBtn.MouseButton1Click:Connect(function()
        LockRef = not LockRef
        LockBtn.Text = LockRef and "🔒" or "🔓"
        LockBtn.BackgroundColor3 = LockRef and Color3.fromRGB(180,40,40) or Color3.fromRGB(50,50,50)
    end)

    DragBar.InputBegan:Connect(function(Input)
        if LockRef then return end
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            DragState.Active = true
            DragState.sX = Input.Position.X
            DragState.sY = Input.Position.Y
            DragState.pX = Frame.Position.X.Offset
            DragState.pY = Frame.Position.Y.Offset
        end
    end)
    UserInputService.InputEnded:Connect(function() DragState.Active = false end)
    UserInputService.InputChanged:Connect(function(Input)
        if DragState.Active and not LockRef then
            if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                local nX = math.clamp(DragState.pX + (Input.Position.X - DragState.sX), 0, Screen.X - Frame.AbsoluteSize.X)
                local nY = math.clamp(DragState.pY + (Input.Position.Y - DragState.sY), 0, Screen.Y - Frame.AbsoluteSize.Y)
                Frame.Position = UDim2.new(0,nX,0,nY)
            end
        end
    end)

    local IsMini = false
    MinBtn.MouseButton1Click:Connect(function()
        IsMini = not IsMini
        Frame.Size = IsMini and MiniSize or FullSize
        MinBtn.Text = IsMini and "➕" or "➖"
    end)
end

-- ====================== MAIN GUI ======================
local MainUI = Instance.new("ScreenGui")
MainUI.Name = "BLUE_MAIN"
MainUI.ResetOnSpawn = false
MainUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
MainUI.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0,680,0,105)
MainFrame.Position = UDim2.new(0,20,0.5,-52)
MainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
MainFrame.Parent = MainUI
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,8)

-- MAIN: DRAG AREA (TOP ONLY, NO BLOCK)
local MainDrag = Instance.new("TextButton")
MainDrag.Size = UDim2.new(1,-70,0,22)
MainDrag.Position = UDim2.new(0,0,0,0)
MainDrag.BackgroundColor3 = Color3.fromRGB(60,140,220)
MainDrag.Active = true
MainDrag.Text = "made by BLUE_MODE | DRAG HERE"
MainDrag.TextColor3 = Color3.new(1,1,1)
MainDrag.Font = Enum.Font.GothamBold
MainDrag.TextScaled = true
MainDrag.TextXAlignment = Enum.TextXAlignment.Left
MainDrag.Parent = MainFrame

-- MAIN: OWN LOCK + SHRINK
local MainLock = Instance.new("TextButton")
MainLock.Size = UDim2.new(0,22,0,22)
MainLock.Position = UDim2.new(1,-44,0,0)
MainLock.BackgroundColor3 = Color3.fromRGB(50,50,50)
MainLock.Text = "🔓"
MainLock.TextColor3 = Color3.new(1,1,1)
MainLock.Font = Enum.Font.GothamBold
MainLock.TextScaled = true
MainLock.Parent = MainFrame
Instance.new("UICorner", MainLock).CornerRadius = UDim.new(0,6)

local MainMin = Instance.new("TextButton")
MainMin.Size = UDim2.new(0,22,0,22)
MainMin.Position = UDim2.new(1,-22,0,0)
MainMin.BackgroundColor3 = Color3.fromRGB(200,120,20)
MainMin.Text = "➖"
MainMin.TextColor3 = Color3.new(1,1,1)
MainMin.Font = Enum.Font.GothamBold
MainMin.TextScaled = true
MainMin.Parent = MainFrame
Instance.new("UICorner", MainMin).CornerRadius = UDim.new(0,6)

-- MAIN BUTTONS
ESPBin = Instance.new("TextButton")
ESPBin.Size = UDim2.new(0,85,0,30)
ESPBin.Position = UDim2.new(0,10,0,30)
ESPBin.BackgroundColor3 = Color3.fromRGB(40,40,40)
ESPBin.Text = "ESP: OFF"
ESPBin.TextColor3 = Color3.new(1,1,1)
ESPBin.Font = Enum.Font.GothamBold
ESPBin.TextScaled = true
ESPBin.Parent = MainFrame
Instance.new("UICorner", ESPBin).CornerRadius = UDim.new(0,6)

local YouTubeBtn = Instance.new("TextButton")
YouTubeBtn.Size = UDim2.new(0,95,0,30)
YouTubeBtn.Position = UDim2.new(0,100,0,30)
YouTubeBtn.BackgroundColor3 = Color3.fromRGB(200,30,30)
YouTubeBtn.Text = "📺 YT"
YouTubeBtn.TextColor3 = Color3.new(1,1,1)
YouTubeBtn.Font = Enum.Font.GothamBold
YouTubeBtn.TextScaled = true
YouTubeBtn.Parent = MainFrame
Instance.new("UICorner", YouTubeBtn).CornerRadius = UDim.new(0,6)

local MusicBtn = Instance.new("TextButton")
MusicBtn.Size = UDim2.new(0,90,0,30)
MusicBtn.Position = UDim2.new(0,200,0,30)
MusicBtn.BackgroundColor3 = Color3.fromRGB(40,80,160)
MusicBtn.Text = "🎵 MUSIC"
MusicBtn.TextColor3 = Color3.new(1,1,1)
MusicBtn.Font = Enum.Font.GothamBold
MusicBtn.TextScaled = true
MusicBtn.Parent = MainFrame
Instance.new("UICorner", MusicBtn).CornerRadius = UDim.new(0,6)

local ConsoleBtn = Instance.new("TextButton")
ConsoleBtn.Size = UDim2.new(0,110,0,30)
ConsoleBtn.Position = UDim2.new(0,300,0,30)
ConsoleBtn.BackgroundColor3 = Color3.fromRGB(30,120,90)
ConsoleBtn.Text = "💻 CONSOLE"
ConsoleBtn.TextColor3 = Color3.new(1,1,1)
ConsoleBtn.Font = Enum.Font.GothamBold
ConsoleBtn.TextScaled = true
ConsoleBtn.Parent = MainFrame
Instance.new("UICorner", ConsoleBtn).CornerRadius = UDim.new(0,6)

local ExitBtn = Instance.new("TextButton")
ExitBtn.Size = UDim2.new(0,90,0,30)
ExitBtn.Position = UDim2.new(0,420,0,30)
ExitBtn.BackgroundColor3 = Color3.fromRGB(140,20,20)
ExitBtn.Text = "🗑️ EXIT"
ExitBtn.TextColor3 = Color3.new(1,1,1)
ExitBtn.Font = Enum.Font.GothamBold
ExitBtn.TextScaled = true
ExitBtn.Parent = MainFrame
Instance.new("UICorner", ExitBtn).CornerRadius = UDim.new(0,6)

-- APPLY MAIN SETTINGS
SetupMenu(MainFrame, MainDrag, MainLock, MainMin, UDim2.new(0,680,0,105), UDim2.new(0,110,0,36), Main_Locked)

-- ====================== BOOMBOX MENU ======================
local function ToggleBoombox()
    if Boombox_Open then
        if CurrentBoom then CurrentBoom:Destroy() end
        Boombox_Open = false
        return
    end
    CurrentBoom = Instance.new("ScreenGui")
    CurrentBoom.Name = "BLUE_BOOMBOX"
    CurrentBoom.ResetOnSpawn = false
    CurrentBoom.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    CurrentBoom.Parent = PlayerGui
    Boombox_Open = true

    local BoomFrame = Instance.new("Frame")
    BoomFrame.Size = UDim2.new(0,320,0,250)
    BoomFrame.Position = UDim2.new(0.5,-160,0.5,-125)
    BoomFrame.BackgroundColor3 = Color3.fromRGB(22,22,22)
    BoomFrame.Parent = CurrentBoom
    Instance.new("UICorner", BoomFrame).CornerRadius = UDim.new(0,12)

    -- BOOMBOX: OWN DRAG
    local BoomDrag = Instance.new("TextButton")
    BoomDrag.Size = UDim2.new(1,-70,0,22)
    BoomDrag.Position = UDim2.new(0,0,0,0)
    BoomDrag.BackgroundColor3 = Color3.fromRGB(60,140,220)
    BoomDrag.Active = true
    BoomDrag.Text = "🎵 BOOMBOX | DRAG HERE"
    BoomDrag.TextColor3 = Color3.new(1,1,1)
    BoomDrag.Font = Enum.Font.GothamBold
    BoomDrag.TextScaled = true
    BoomDrag.TextXAlignment = Enum.TextXAlignment.Left
    BoomDrag.Parent = BoomFrame

    -- BOOMBOX: OWN LOCK + SHRINK
    local BoomLock = Instance.new("TextButton")
    BoomLock.Size = UDim2.new(0,22,0,22)
    BoomLock.Position = UDim2.new(1,-44,0,0)
    BoomLock.BackgroundColor3 = Color3.fromRGB(50,50,50)
    BoomLock.Text = "🔓"
    BoomLock.TextColor3 = Color3.new(1,1,1)
    BoomLock.Font = Enum.Font.GothamBold
    BoomLock.TextScaled = true
    BoomLock.Parent = BoomFrame
    Instance.new("UICorner", BoomLock).CornerRadius = UDim.new(0,6)

    local BoomMin = Instance.new("TextButton")
    BoomMin.Size = UDim2.new(0,22,0,22)
    BoomMin.Position = UDim2.new(1,-22,0,0)
    BoomMin.BackgroundColor3 = Color3.fromRGB(200,120,20)
    BoomMin.Text = "➖"
    BoomMin.TextColor3 = Color3.new(1,1,1)
    BoomMin.Font = Enum.Font.GothamBold
    BoomMin.TextScaled = true
    BoomMin.Parent = BoomFrame
    Instance.new("UICorner", BoomMin).CornerRadius = UDim.new(0,6)

    SetupMenu(BoomFrame, BoomDrag, BoomLock, BoomMin, UDim2.new(0,320,0,250), UDim2.new(0,180,0,40), Boombox_Locked)
end

-- ====================== CONSOLE MENU ======================
local function ToggleConsole()
    if Console_Open then
        if CurrentCon then CurrentCon:Destroy() end
        Console_Open = false
        return
    end
    CurrentCon = Instance.new("ScreenGui")
    CurrentCon.Name = "BLUE_CONSOLE"
    CurrentCon.ResetOnSpawn = false
    CurrentCon.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    CurrentCon.Parent = PlayerGui
    Console_Open = true

    local ConFrame = Instance.new("Frame")
    ConFrame.Size = UDim2.new(0,450,0,320)
    ConFrame.Position = UDim2.new(0.5,-225,0.5,-160)
    ConFrame.BackgroundColor3 = Color3.fromRGB(22,22,22)
    ConFrame.Parent = CurrentCon
    Instance.new("UICorner", ConFrame).CornerRadius = UDim.new(0,12)

    -- CONSOLE: OWN DRAG
    local ConDrag = Instance.new("TextButton")
    ConDrag.Size = UDim2.new(1,-70,0,22)
    ConDrag.Position = UDim2.new(0,0,0,0)
    ConDrag.BackgroundColor3 = Color3.fromRGB(60,140,220)
    ConDrag.Active = true
    ConDrag.Text = "💻 CONSOLE | DRAG HERE"
    ConDrag.TextColor3 = Color3.new(1,1,1)
    ConDrag.Font = Enum.Font.GothamBold
    ConDrag.TextScaled = true
    ConDrag.TextXAlignment = Enum.TextXAlignment.Left
    ConDrag.Parent = ConFrame

    -- CONSOLE: OWN LOCK + SHRINK
    local ConLock = Instance.new("TextButton")
    ConLock.Size = UDim2.new(0,22,0,22)
    ConLock.Position = UDim2.new(1,-44,0,0)
    ConLock.BackgroundColor3 = Color3.fromRGB(50,50,50)
    ConLock.Text = "🔓"
    ConLock.TextColor3 = Color3.new(1,1,1)
    ConLock.Font = Enum.Font.GothamBold
    ConLock.TextScaled = true
    ConLock.Parent = ConFrame
    Instance.new("UICorner", ConLock).CornerRadius = UDim.new(0,6)

    local ConMin = Instance.new("TextButton")
    ConMin.Size = UDim2.new(0,22,0,22)
    ConMin.Position = UDim2.new(1,-22,0,0)
    ConMin.BackgroundColor3 = Color3.fromRGB(200,120,20)
    ConMin.Text = "➖"
    ConMin.TextColor3 = Color3.new(1,1,1)
    ConMin.Font = Enum.Font.GothamBold
    ConMin.TextScaled = true
    ConMin.Parent = ConFrame
    Instance.new("UICorner", ConMin).CornerRadius = UDim.new(0,6)

    SetupMenu(ConFrame, ConDrag, ConLock, ConMin, UDim2.new(0,450,0,320), UDim2.new(0,200,0,40), Console_Locked)
end

-- BUTTON ACTIONS
ESPBin.MouseButton1Click:Connect(function()
    ESP_Enabled = not ESP_Enabled
    ESPBin.Text = ESP_Enabled and "ESP: ON" or "ESP: OFF"
    ESPBin.BackgroundColor3 = ESP_Enabled and Color3.fromRGB(25,120,25) or Color3.fromRGB(40,40,40)
    if not ESP_Enabled then ClearESP() end
end)

YouTubeBtn.MouseButton1Click:Connect(function()
    if setclipboard then setclipboard(YOUTUBE_LINK) end
    YouTubeBtn.Text = "✅ COPIED!"
    task.wait(1.5)
    YouTubeBtn.Text = "📺 YT"
end)

MusicBtn.MouseButton1Click:Connect(ToggleBoombox)
ConsoleBtn.MouseButton1Click:Connect(ToggleConsole)

ExitBtn.MouseButton1Click:Connect(function()
    ClearESP()
    if CurrentBoom then CurrentBoom:Destroy() end
    if CurrentCon then CurrentCon:Destroy() end
    MainUI:Destroy()
    getgenv().BlueMode_Loaded = nil
end)

SetupDeath()

-- MAIN LOOP: FRIEND DOTS ONLY WHEN ESP ON
RunService.Heartbeat:Connect(function()
    if not ESP_Enabled then return end
    for _,P in pairs(Players:GetPlayers()) do
        if P == LocalPlayer then continue end
        local Char = P.Character
        if not Char then continue end
        local Hum = Char:FindFirstChildOfClass("Humanoid")
        if not Hum or Hum.Health <= 0 then
            pcall(function()
                if Char:FindFirstChild("BLUE_Outline") then Char.BLUE_Outline:Destroy() end
                if Char:FindFirstChild("FriendRainbowDot") then Char.FriendRainbowDot:Destroy() end
            end)
            continue
        end

        -- OUTLINE
        local Outline = Char:FindFirstChild("BLUE_Outline") or Instance.new("Highlight",Char)
        Outline.Name = "BLUE_Outline"
        Outline.FillTransparency = 1
        Outline.OutlineTransparency = 0
        Outline.OutlineColor = Color3.fromRGB(0,255,0)
        Outline.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

        -- FRIEND DOT: ONLY WHEN ESP ON
        local IsFriend = false
        pcall(function() IsFriend = LocalPlayer:IsFriendsWith(P.UserId) end)
        local Head = Char:FindFirstChild("Head")
        local Dot = Char:FindFirstChild("FriendRainbowDot")
        if IsFriend and Head then
            if not Dot then
                Dot = Instance.new("BillboardGui",Head)
                Dot.Name = "FriendRainbowDot"
                Dot.AlwaysOnTop = true
                Dot.Size = UDim2.new(0,16,0,16)
                Dot.StudsOffset = Vector3.new(0,2,0)
                local Circ = Instance.new("Frame",Dot)
                Circ.Size = UDim2.new(1,0,1,0)
                Circ.BackgroundColor3 = Color3.fromRGB(255,0,255)
                Instance.new("UICorner",Circ).CornerRadius = UDim.new(1,0)
            end
        elseif Dot then
            Dot:Destroy()
        end
    end
end)

print("✅ READY: Dots Fixed, All Menus Own Drag/Lock/Shrink")
