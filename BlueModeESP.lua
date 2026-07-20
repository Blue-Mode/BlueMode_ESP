-- ==============================================
-- 🔵 BLUE MODE HUB | PART 1/2
-- ✅ NO EXTRA FEATURES | EXACTLY AS REQUESTED
-- Creator: Dwaynekean015
-- ==============================================
if getgenv().BlueMode_Loaded then return end
getgenv().BlueMode_Loaded = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local NetworkClient = game:GetService("NetworkClient")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

local CUSTOM_GUI_BG = "rbxassetid://101782008402770"

local GuiContainer = Instance.new("Folder")
GuiContainer.Name = "BLUE_MODE_HUB_ROOT"
GuiContainer.Parent = CoreGui

local PRIORITY = {
    STARTUP = 800, MAIN = 799, BOOMBOX = 798, CONSOLE = 797, EXIT_CONFIRM = 9999
}

local YOUTUBE_LINK = "https://youtube.com/@blue_mode?si=aCGyj0FnwCMtTP1M"
local SAVE_KEY_VOLUME = "BlueMode_Volume_v22"
local VOLUME_MAX = 1000
local OLD_LIGHTING = Lighting.Technology

if not getping then
    getping = function()
        local s = os.clock()
        task.wait()
        return math.floor((os.clock() - s) * 1000)
    end
end

local BoomboxUI_Open = false
local ConsoleUI_Open = false
local CurrentBoomboxUI, CurrentConsoleUI = nil, nil
local IsMinimized = false
local GuiElements = {}
local Hue = 0

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

-- STARTUP SCREEN
local StartupUI = Instance.new("ScreenGui")
StartupUI.Name = "BLUE_MODE_HUB_STARTUP"
StartupUI.ResetOnSpawn = false
StartupUI.DisplayOrder = PRIORITY.STARTUP
StartupUI.Parent = GuiContainer

local StartupBox = Instance.new("Frame")
StartupBox.Size = UDim2.new(0,420,0,420)
StartupBox.Position = UDim2.new(0.5,-210,0.5,-210)
StartupBox.BackgroundColor3 = Color3.fromRGB(10,12,18)
StartupBox.Active = true
StartupBox.Parent = StartupUI
Instance.new("UICorner", StartupBox).CornerRadius = UDim.new(0,18)

local StartupGuiBg = Instance.new("ImageLabel")
StartupGuiBg.Size = UDim2.new(1,0,1,0)
StartupGuiBg.BackgroundTransparency = 1
StartupGuiBg.Image = CUSTOM_GUI_BG
StartupGuiBg.ScaleType = Enum.ScaleType.Stretch
StartupGuiBg.Parent = StartupBox

local StartupBorder = Instance.new("UIStroke")
StartupBorder.Thickness = 5
StartupBorder.Parent = StartupBox

local StartupTitle = Instance.new("TextLabel")
StartupTitle.Size = UDim2.new(1,-40,0,50)
StartupTitle.Position = UDim2.new(0,20,0,15)
StartupTitle.BackgroundTransparency = 1
StartupTitle.Font = Enum.Font.GothamBlack
StartupTitle.TextScaled = true
StartupTitle.Text = "🔵 BLUE MODE HUB"
StartupTitle.TextColor3 = Color3.fromRGB(0,190,255)
StartupTitle.Parent = StartupBox

local UpdateHeader = Instance.new("TextLabel")
UpdateHeader.Size = UDim2.new(1,-40,0,35)
UpdateHeader.Position = UDim2.new(0,20,0,75)
UpdateHeader.BackgroundTransparency = 1
UpdateHeader.Font = Enum.Font.GothamBold
UpdateHeader.TextScaled = true
UpdateHeader.Text = "📋 UPDATES"
UpdateHeader.Parent = StartupBox

local UpdateList = Instance.new("TextLabel")
UpdateList.Size = UDim2.new(1,-50,0,220)
UpdateList.Position = UDim2.new(0,25,0,115)
UpdateList.BackgroundTransparency = 1
UpdateList.Font = Enum.Font.Gotham
UpdateList.TextScaled = true
UpdateList.TextWrapped = true
UpdateList.TextXAlignment = Enum.TextXAlignment.Left
UpdateList.TextColor3 = Color3.fromRGB(220,220,220)
UpdateList.Text = [[• ✅ ESP INSTANT ON JOIN/RESPAWN
• ✅ OWNER = GOLD | FRIENDS = RAINBOW + DOT | ALL OTHERS = RAINBOW
• ✅ NO ENEMY RED COLORING
• ✅ ALL FEATURES UNCHANGED]]
UpdateList.Parent = StartupBox

local OkBtn = Instance.new("TextButton")
OkBtn.Size = UDim2.new(0,260,0,60)
OkBtn.Position = UDim2.new(0.5,-130,0,340)
OkBtn.BackgroundColor3 = Color3.fromRGB(15,110,230)
OkBtn.Font = Enum.Font.GothamBold
OkBtn.TextScaled = true
OkBtn.Text = "✓ LOAD MAIN HUB"
OkBtn.TextColor3 = Color3.new(1,1,1)
OkBtn.Parent = StartupBox
Instance.new("UICorner", OkBtn).CornerRadius = UDim.new(0,16)
AddRainbowGlow(OkBtn,3)

RunService.Heartbeat:Connect(function(dt)
    Hue = (Hue + dt*0.3) % 1
    local Col = Color3.fromHSV(Hue,1,1)
    StartupBorder.Color = Col
    StartupTitle.TextColor3 = Col
end)

OkBtn.MouseButton1Click:Connect(function()
    StartupUI:Destroy()
    LoadMainHub()
end)

-- EXIT CONFIRM
local function ShowExitConfirm()
    local ConfirmUI = Instance.new("ScreenGui")
    ConfirmUI.Name = "BLUE_MODE_EXIT_CONFIRM"
    ConfirmUI.ResetOnSpawn = false
    ConfirmUI.DisplayOrder = PRIORITY.EXIT_CONFIRM
    ConfirmUI.Parent = GuiContainer

    local Popup = Instance.new("Frame")
    Popup.Size = UDim2.new(0,380,0,220)
    Popup.Position = UDim2.new(0.5,-190,0.5,-110)
    Popup.BackgroundColor3 = Color3.fromRGB(15,15,25)
    Popup.Active = true
    Popup.Parent = ConfirmUI
    Instance.new("UICorner", Popup).CornerRadius = UDim.new(0,16)

    local PopupBg = Instance.new("ImageLabel")
    PopupBg.Size = UDim2.new(1,0,1,0)
    PopupBg.BackgroundTransparency = 1
    PopupBg.Image = CUSTOM_GUI_BG
    PopupBg.ScaleType = Enum.ScaleType.Stretch
    PopupBg.Parent = Popup
    AddRainbowGlow(Popup,4)

    local PopupTitle = Instance.new("TextLabel")
    PopupTitle.Size = UDim2.new(1,-20,0,45)
    PopupTitle.Position = UDim2.new(0,10,0,12)
    PopupTitle.BackgroundTransparency = 1
    PopupTitle.Font = Enum.Font.GothamBold
    PopupTitle.TextScaled = true
    PopupTitle.Text = "⚠️ EXIT CONFIRM"
    PopupTitle.Parent = Popup

    local PopupText = Instance.new("TextLabel")
    PopupText.Size = UDim2.new(1,-30,0,40)
    PopupText.Position = UDim2.new(0,15,0,65)
    PopupText.BackgroundTransparency = 1
    PopupText.Font = Enum.Font.Gotham
    PopupText.TextScaled = true
    PopupText.Text = "Close Blue Mode Hub?"
    PopupText.TextColor3 = Color3.fromRGB(230,230,230)
    PopupText.Parent = Popup

    local YesBtn = Instance.new("TextButton")
    YesBtn.Size = UDim2.new(0,140,0,50)
    YesBtn.Position = UDim2.new(0,30,0,140)
    YesBtn.BackgroundColor3 = Color3.fromRGB(220,40,40)
    YesBtn.Font = Enum.Font.GothamBold
    YesBtn.TextScaled = true
    YesBtn.Text = "✅ YES EXIT"
    YesBtn.TextColor3 = Color3.new(1,1,1)
    YesBtn.Parent = Popup
    Instance.new("UICorner", YesBtn).CornerRadius = UDim.new(0,12)
    AddRainbowGlow(YesBtn,3)

    local NoBtn = Instance.new("TextButton")
    NoBtn.Size = UDim2.new(0,140,0,50)
    NoBtn.Position = UDim2.new(1,-170,0,140)
    NoBtn.BackgroundColor3 = Color3.fromRGB(30,150,220)
    NoBtn.Font = Enum.Font.GothamBold
    NoBtn.TextScaled = true
    NoBtn.Text = "❌ NO STAY"
    NoBtn.TextColor3 = Color3.new(1,1,1)
    NoBtn.Parent = Popup
    Instance.new("UICorner", NoBtn).CornerRadius = UDim.new(0,12)
    AddRainbowGlow(NoBtn,3)

    YesBtn.MouseButton1Click:Connect(function()
        ConfirmUI:Destroy()
        GuiContainer:Destroy()
        Lighting.Technology = OLD_LIGHTING
        getgenv().BlueMode_Loaded = nil
    end)
    NoBtn.MouseButton1Click:Connect(function() ConfirmUI:Destroy() end)
end

-- SCRIPT CONSOLE
local function ToggleConsole()
    if ConsoleUI_Open then
        if CurrentConsoleUI then CurrentConsoleUI:Destroy() end
        ConsoleUI_Open = false
        CurrentConsoleUI = nil
        return
    end
    ConsoleUI_Open = true
    local ConsoleUI = Instance.new("ScreenGui")
    ConsoleUI.Name = "BLUE_MODE_HUB_CONSOLE"
    ConsoleUI.ResetOnSpawn = false
    ConsoleUI.DisplayOrder = PRIORITY.CONSOLE
    ConsoleUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ConsoleUI.Parent = GuiContainer
    CurrentConsoleUI = ConsoleUI

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0,450,0,320)
    Frame.Position = UDim2.new(0.5,-225,0.5,-160)
    Frame.BackgroundColor3 = Color3.fromRGB(22,22,22)
    Frame.Active = true
    Frame.ClipsDescendants = false
    Frame.Parent = ConsoleUI
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0,12)

    local ConsoleGuiBg = Instance.new("ImageLabel")
    ConsoleGuiBg.Size = UDim2.new(1,0,1,0)
    ConsoleGuiBg.BackgroundTransparency = 1
    ConsoleGuiBg.Image = CUSTOM_GUI_BG
    ConsoleGuiBg.ScaleType = Enum.ScaleType.Stretch
    ConsoleGuiBg.ZIndex = 1
    ConsoleGuiBg.Parent = Frame
    AddRainbowGlow(Frame,5)

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0,32,0,32)
    CloseBtn.Position = UDim2.new(1,-37,0,6)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(170,30,30)
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.new(1,1,1)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 26
    CloseBtn.ZIndex = 3
    CloseBtn.Parent = Frame
    CloseBtn.MouseButton1Click:Connect(function() ToggleConsole() end)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1,-50,0,35)
    Title.Position = UDim2.new(0,15,0,6)
    Title.BackgroundTransparency = 1
    Title.Text = "💻 SCRIPT CONSOLE"
    Title.TextColor3 = Color3.new(1,1,1)
    Title.Font = Enum.Font.GothamBold
    Title.TextScaled = true
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.ZIndex = 2
    Title.Parent = Frame

    local Status = Instance.new("TextLabel")
    Status.Size = UDim2.new(1,-30,0,30)
    Status.Position = UDim2.new(0,15,0,45)
    Status.BackgroundTransparency = 1
    Status.Text = "Ready — Paste code then click Execute"
    Status.TextColor3 = Color3.fromRGB(0,255,120)
    Status.Font = Enum.Font.Code
    Status.TextScaled = true
    Status.TextXAlignment = Enum.TextXAlignment.Left
    Status.ZIndex = 2
    Status.Parent = Frame

    local Input = Instance.new("TextBox")
    Input.Size = UDim2.new(1,-30,0,140)
    Input.Position = UDim2.new(0,15,0,85)
    Input.BackgroundColor3 = Color3.fromRGB(45,45,45)
    Input.PlaceholderText = "Paste your Lua script here..."
    Input.TextColor3 = Color3.new(1,1,1)
    Input.Font = Enum.Font.Code
    Input.TextScaled = true
    Input.MultiLine = true
    Input.TextXAlignment = Enum.TextXAlignment.Left
    Input.TextYAlignment = Enum.TextYAlignment.Top
    Input.ZIndex = 2
    Input.Parent = Frame
    Instance.new("UICorner", Input).CornerRadius = UDim.new(0,8)
    AddRainbowGlow(Input,2)

    local ExecBtn = Instance.new("TextButton")
    ExecBtn.Size = UDim2.new(0,120,0,40)
    ExecBtn.Position = UDim2.new(0,15,0,240)
    ExecBtn.BackgroundColor3 = Color3.fromRGB(20,150,70)
    ExecBtn.Text = "▶ EXECUTE"
    ExecBtn.TextColor3 = Color3.new(1,1,1)
    ExecBtn.Font = Enum.Font.GothamBold
    ExecBtn.TextScaled = true
    ExecBtn.ZIndex = 2
    ExecBtn.Parent = Frame
    Instance.new("UICorner", ExecBtn).CornerRadius = UDim.new(0,8)
    AddRainbowGlow(ExecBtn,2)

    local ClearBtn = Instance.new("TextButton")
    ClearBtn.Size = UDim2.new(0,120,0,40)
    ClearBtn.Position = UDim2.new(0,150,0,240)
    ClearBtn.BackgroundColor3 = Color3.fromRGB(180,120,20)
    ClearBtn.Text = "🗑️ CLEAR"
    ClearBtn.TextColor3 = Color3.new(1,1,1)
    ClearBtn.Font = Enum.Font.GothamBold
    ClearBtn.TextScaled = true
    ClearBtn.ZIndex = 2
    ClearBtn.Parent = Frame
    Instance.new("UICorner", ClearBtn).CornerRadius = UDim.new(0,8)
    AddRainbowGlow(ClearBtn,2)

    ExecBtn.MouseButton1Click:Connect(function()
        local Code = Input.Text
        if Code == "" then Status.Text = "⚠️ No code entered!" Status.TextColor3 = Color3.fromRGB(255,200,0) return end
        local Compile = loadstring or load
        if not Compile then Status.Text = "❌ Executor does not support script running" Status.TextColor3 = Color3.fromRGB(255,50,50) return end
        local Func, Err = Compile(Code)
        if not Func then Status.Text = "❌ Syntax Error: "..tostring(Err) Status.TextColor3 = Color3.fromRGB(255,50,50) return end
        local Ok, RunErr = pcall(Func)
        if not Ok then Status.Text = "❌ Runtime Error: "..tostring(RunErr) Status.TextColor3 = Color3.fromRGB(255,50,50) return end
        Status.Text = "✅ Script executed successfully!" Status.TextColor3 = Color3.fromRGB(0,255,120)
    end)

    ClearBtn.MouseButton1Click:Connect(function()
        Input.Text = ""
        Status.Text = "✅ Cleared — Ready for new code"
        Status.TextColor3 = Color3.fromRGB(0,255,120)
    end)
end

-- RUN PART 2 AFTER THIS
            if IsOwner then
                Highlight.FillColor = Color3.fromRGB(255,215,0)
                Highlight.OutlineColor = Color3.fromRGB(255,215,0)
                if DotCache[Player.UserId] then
                    DotCache[Player.UserId]:Destroy()
                    DotCache[Player.UserId] = nil
                end
            elseif IsFriend then
                Highlight.FillColor = Rainbow
                Highlight.OutlineColor = Rainbow
                local Dot = DotCache[Player.UserId]
                if not Dot then
                    Dot = Instance.new("BillboardGui")
                    Dot.Name = "BlueMode_FriendDot"
                    Dot.AlwaysOnTop = true
                    Dot.Size = UDim2.new(0,12,0,12)
                    Dot.StudOffset = Vector3.new(0, 3, 0)
                    Dot.Parent = Head
                    local DotFrame = Instance.new("Frame")
                    DotFrame.Size = UDim2.new(1,0,1,0)
                    DotFrame.BackgroundColor3 = Rainbow
                    DotFrame.CornerRadius = UDim.new(1,0)
                    DotFrame.Parent = Dot
                    DotCache[Player.UserId] = Dot
                else
                    Dot.Frame.BackgroundColor3 = Rainbow
                end
            else
                Highlight.FillColor = Rainbow
                Highlight.OutlineColor = Rainbow
                if DotCache[Player.UserId] then
                    DotCache[Player.UserId]:Destroy()
                    DotCache[Player.UserId] = nil
                end
            end
        end
    end)
end

print("✅ BLUE MODE HUB LOADED SUCCESSFULLY!")
print("✅ Owner = Gold | Friends = Rainbow ESP + Rainbow Dot | All Others = Rainbow ESP")
print("✅ No enemy red coloring added — exactly as requested!")
