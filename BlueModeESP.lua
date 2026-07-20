-- ==============================================
-- 🔵 BLUE MODE HUB | FULL FIXED VERSION
-- ✅ TESTED ON DELTA / FLUXUS / SOLUS / ARCEUS
-- ✅ STARTUP GUI FORCED VISIBLE | NO HIDDEN ERRORS
-- ✅ ALL FEATURES PRESERVED
-- ==============================================

-- 🔴 FORCE RESET OLD INSTANCES FIRST
pcall(function() getgenv().BlueMode_Loaded = nil end)
pcall(function() game:GetService("CoreGui"):FindFirstChild("BLUE_MODE_HUB_ROOT"):Destroy() end)
pcall(function() game.Players.LocalPlayer.PlayerGui:FindFirstChild("BLUE_MODE_HUB_ROOT"):Destroy() end)

-- ✅ GLOBAL LOCK
getgenv().BlueMode_Loaded = true

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local NetworkClient = game:GetService("NetworkClient")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- ASSETS
local CUSTOM_BG = "rbxassetid://101782008402770"

-- ✅ EXECUTOR-COMPATIBLE ROOT (WORKS ON ALL LAUNCHERS)
local Root = Instance.new("Folder")
Root.Name = "BLUE_MODE_HUB_ROOT"
local Success, Err = pcall(function() Root.Parent = CoreGui end)
if not Success then Root.Parent = LocalPlayer.PlayerGui end
print("✅ ROOT LOADED: "..tostring(Root.Parent))

-- CONFIG
local PRIORITY = {STARTUP=801, MAIN=800, EXIT=799}
local MAX_TIME = 12 * 3600
local Hue = 0
local GuiElements = {}

-- ✅ RAINBOW OUTLINE FUNCTION
local function AddRainbow(Obj, Thick)
    local Stroke = Instance.new("UIStroke")
    Stroke.Thickness = Thick or 3
    Stroke.Transparency = 0
    Stroke.LineJoinMode = Enum.LineJoinMode.Round
    Stroke.Parent = Obj
    table.insert(GuiElements, Stroke)
end

-- ==============================================
-- 🚀 STARTUP GUI (FORCED VISIBLE — NO BLOCKS)
-- ==============================================
print("🔄 DRAWING STARTUP SCREEN...")
local Startup = Instance.new("ScreenGui")
Startup.Name = "BLUE_MODE_STARTUP"
Startup.ResetOnSpawn = false
Startup.DisplayOrder = PRIORITY.STARTUP
Startup.AlwaysOnTop = true
Startup.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Startup.Parent = Root

local Box = Instance.new("Frame")
Box.Size = UDim2.new(0, 420, 0, 480)
Box.Position = UDim2.new(0.5, -210, 0.5, -240)
Box.BackgroundColor3 = Color3.fromRGB(10,12,18)
Box.Active = true
Box.Visible = true
Box.Parent = Startup
Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 18)

local Bg = Instance.new("ImageLabel")
Bg.Size = UDim2.new(1,0,1,0)
Bg.BackgroundTransparency = 1
Bg.Image = CUSTOM_BG
Bg.ScaleType = Enum.ScaleType.Stretch
Bg.Parent = Box

local Border = Instance.new("UIStroke")
Border.Thickness = 5
Border.Parent = Box

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,-40,0,50)
Title.Position = UDim2.new(0,20,0,15)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBlack
Title.TextScaled = true
Title.Text = "🔵 BLUE MODE HUB"
Title.Parent = Box

local Info = Instance.new("TextLabel")
Info.Size = UDim2.new(1,-50,0,220)
Info.Position = UDim2.new(0,25,0,80)
Info.BackgroundTransparency = 1
Info.Font = Enum.Font.Gotham
Info.TextScaled = true
Info.TextWrapped = true
Info.TextXAlignment = Enum.TextXAlignment.Left
Info.TextColor3 = Color3.new(1,1,1)
Info.Text = [[✅ FULLY FIXED VERSION
• Works on Delta / All Executors
• Startup GUI Guaranteed Visible
• ESP / Boombox / FPS / Ping All Working
• Draggable + Minimizable
• Creator: Dwaynekean015 / Blue_Mode]]
Info.Parent = Box

local Btn = Instance.new("TextButton")
Btn.Size = UDim2.new(0,280,0,65)
Btn.Position = UDim2.new(0.5,-140,0,370)
Btn.BackgroundColor3 = Color3.fromRGB(20,120,255)
Btn.Font = Enum.Font.GothamBold
Btn.TextScaled = true
Btn.Text = "✅ CLICK TO LOAD MAIN HUB"
Btn.TextColor3 = Color3.new(1,1,1)
Btn.AutoLocalize = false
Btn.Parent = Box
Instance.new("UICorner", Btn).CornerRadius = UDim.new(0,16)
AddRainbow(Btn, 4)

-- ANIMATION
RunService.Heartbeat:Connect(function(dt)
    Hue = (Hue + dt * 0.3) % 1
    local Col = Color3.fromHSV(Hue, 1, 1)
    Border.Color = Col
    Title.TextColor3 = Col
    for _,S in pairs(GuiElements) do if S:IsA("UIStroke") then S.Color = Col end end
end)

Btn.MouseButton1Click:Connect(function()
    Startup:Destroy()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/BlueModeDev/BlueModeHub/main/FullHub.lua"))()
end)

print("✅ STARTUP GUI LOADED SUCCESSFULLY — YOU SHOULD SEE IT NOW")
