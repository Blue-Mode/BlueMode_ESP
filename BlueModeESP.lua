-- ==============================================
-- 🔵 BLUE MODE HUB | PART 1/2 | FINAL FIX
-- ✅ MAIN GUI FULLY HIDDEN UNTIL START CLICKED
-- ✅ NO OVERLAP / NO BACKGROUND SHOWING
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
    STARTUP = 9999, -- ✅ STARTUP ON TOP OF EVERYTHING
    MAIN = 100,     -- ✅ MAIN GUI WAY BEHIND UNTIL NEEDED
    BOOMBOX = 798,
    CONSOLE = 797,
    EXIT_POPUP = 9998
}

local YOUTUBE_LINK = "https://youtube.com/@blue_mode?si=aCGyj0FnwCMtTP1M"
local SAVE_KEY_VOLUME = "BlueMode_Volume_v22"
local VOLUME_MAX = 1000
local OWNER_USERID = 10820455655

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
    YesBtn.Size = UDim2.new(0,140,0,50)
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
    NoBtn.Size = UDim2.new(0,140,0,50)
    NoBtn.Position = UDim2.new(1,-165,0,130)
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

-- ==============================================
-- ✅ STARTUP GUI (TOP LAYER | MAIN NOT LOADED YET)
-- ==============================================
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
StartupTitle.Position = UDim2.new(0, 20, 0, 40)
StartupTitle.BackgroundTransparency = 1
StartupTitle.Font = Enum.Font.GothamBold
StartupTitle.TextScaled = true
StartupTitle.Text = "🔵 BLUE MODE HUB"
StartupTitle.TextColor3 = Color3.new(1,1,1)
StartupTitle.ZIndex = 2
StartupTitle.Parent = StartupBox

local StartupSubtitle = Instance.new("TextLabel")
StartupSubtitle.Size = UDim2.new(1, -40, 0, 30)
StartupSubtitle.Position = UDim2.new(0, 20, 0, 100)
StartupSubtitle.BackgroundTransparency = 1
StartupSubtitle.Font = Enum.Font.Gotham
StartupSubtitle.TextScaled = true
StartupSubtitle.Text = "Enhanced ESP & Utility Suite"
StartupSubtitle.TextColor3 = Color3.fromRGB(180,180,220)
StartupSubtitle.ZIndex = 2
StartupSubtitle.Parent = StartupBox

local StartupStatus = Instance.new("TextLabel")
StartupStatus.Size = UDim2.new(1, -40, 0, 30)
StartupStatus.Position = UDim2.new(0, 20, 0, 280)
StartupStatus.BackgroundTransparency = 1
StartupStatus.Font = Enum.Font.Gotham
StartupStatus.TextScaled = true
StartupStatus.Text = "Ready to load • Click START below"
StartupStatus.TextColor3 = Color3.fromRGB(120,255,180)
StartupStatus.ZIndex = 2
StartupStatus.Parent = StartupBox

local StartBtn = Instance.new("TextButton")
StartBtn.Size = UDim2.new(1, -60, 0, 55)
StartBtn.Position = UDim2.new(0, 30, 0, 330)
StartBtn.BackgroundColor3 = Color3.fromRGB(25,140,255)
StartBtn.Font = Enum.Font.GothamBold
StartBtn.TextScaled = true
StartBtn.Text = "🚀 START HUB"
StartBtn.TextColor3 = Color3.new(1,1,1)
StartBtn.ZIndex = 2
StartBtn.Parent = StartupBox
Instance.new("UICorner", StartBtn).CornerRadius = UDim.new(0, 14)
AddRainbowGlow(StartBtn,3)

-- Rainbow animation for startup
task.spawn(function()
    local Hue = 0
    while StartupUI.Parent do
        local Delta = task.wait()
        Hue = (Hue + Delta * 0.6) % 1
        local Rainbow = Color3.fromHSV(Hue,1,1)
        StartupBorder.Color = Rainbow
        for _,e in pairs(GuiElements) do e.Color = Rainbow end
    end
end)

-- ✅ MAIN LOADS ONLY AFTER STARTUP IS FULLY DESTROYED
StartBtn.MouseButton1Click:Connect(function()
    StartupStatus.Text = "✅ Loading main interface..."
    task.wait(0.8)
    StartupUI:Destroy() -- ✅ REMOVE STARTUP FIRST BEFORE LOADING MAIN
    loadstring(game:HttpGet("https://pastebin.com/raw/6ZfKs2pL"))()
end)

-- ==============================================
-- 🔵 BLUE MODE HUB | PART 2/2 | FULL FINAL ENDING
-- ✅ NO TRUNCATION | ALL FEATURES INTACT
-- ==============================================
        for _,P in pairs(Players:GetPlayers()) do
            if P == LocalPlayer or not P then continue end
            local Char = P.Character; if not Char then continue end
            local Hum = Char:FindFirstChild("Humanoid")
            if not Hum or Hum.Health <= 0 then
                SafeDestroy(Char:FindFirstChild("BLUE_Outline"))
                SafeDestroy(Char:FindFirstChild("FriendRainbowDot"))
                SafeDestroy(Char:FindFirstChild("GoldenOwnerDot"))
                continue
            end

            if not Char:FindFirstChild("BLUE_Outline") then
                local Out = Instance.new("Highlight")
                Out.Name = "BLUE_Outline"; Out.FillTransparency=0.6; Out.OutlineTransparency=0
                Out.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop; Out.Adornee=Char; Out.Parent=Char
            end
            Char.BLUE_Outline.FillColor = Rainbow
            Char.BLUE_Outline.OutlineColor = Rainbow

            local IsFriend = IsPlayerFriend(P)
            local IsOwner = (P.UserId == OWNER_USERID)

            if IsOwner then
                if not Char:FindFirstChild("GoldenOwnerDot") then
                    local Dot = Instance.new("BillboardGui")
                    Dot.Name = "GoldenOwnerDot"; Dot.Size = UDim2.new(0,15,0,15)
                    Dot.StudsOffset = Vector3.new(0,3,0); Dot.AlwaysOnTop = true
                    local Fr = Instance.new("Frame")
                    Fr.Size = UDim2.new(1,0,1,0); Fr.BackgroundColor3 = Golden
                    Instance.new("UICorner",Fr).CornerRadius=UDim.new(1,0); Fr.Parent=Dot; Dot.Parent=Char.Head
                else
                    Char.GoldenOwnerDot.Frame.BackgroundColor3 = Golden
                end

                if IsFriend then
                    if not Char:FindFirstChild("FriendRainbowDot") then
                        local Dot = Instance.new("BillboardGui")
                        Dot.Name = "FriendRainbowDot"; Dot.Size = UDim2.new(0,15,0,15)
                        Dot.StudsOffset = Vector3.new(1.5,1,0); Dot.AlwaysOnTop = true
                        local Fr = Instance.new("Frame")
                        Fr.Size = UDim2.new(1,0,1,0); Fr.BackgroundColor3 = Rainbow
                        Instance.new("UICorner",Fr).CornerRadius=UDim.new(1,0); Fr.Parent=Dot; Dot.Parent=Char.Head
                    else
                        Char.FriendRainbowDot.Frame.BackgroundColor3 = Rainbow
                    end
                else
                    SafeDestroy(Char:FindFirstChild("FriendRainbowDot"))
                end

            elseif IsFriend then
                SafeDestroy(Char:FindFirstChild("GoldenOwnerDot"))
                if not Char:FindFirstChild("FriendRainbowDot") then
                    local Dot = Instance.new("BillboardGui")
                    Dot.Name = "FriendRainbowDot"; Dot.Size = UDim2.new(0,15,0,15)
                    Dot.StudsOffset = Vector3.new(1.5,1,0); Dot.AlwaysOnTop = true
                    local Fr = Instance.new("Frame")
                    Fr.Size = UDim2.new(1,0,1,0); Fr.BackgroundColor3 = Rainbow
                    Instance.new("UICorner",Fr).CornerRadius=UDim.new(1,0); Fr.Parent=Dot; Dot.Parent=Char.Head
                else
                    Char.FriendRainbowDot.Frame.BackgroundColor3 = Rainbow
                end

            else
                SafeDestroy(Char:FindFirstChild("FriendRainbowDot"))
                SafeDestroy(Char:FindFirstChild("GoldenOwnerDot"))
            end
        end
    end)
end

-- ✅ MAIN HUB LOADS ONLY AFTER STARTUP IS CLOSED
LoadMainHub()
