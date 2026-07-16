-- ==============================================
-- ESP Script | FINAL VERSION
-- made by BLUE_MODE
-- YouTube: https://youtube.com/@blue_mode?si=aCGyj0FnwCMtTP1M
-- ==============================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local ESP_Enabled = false
local Buttons_Locked = false
local RAINBOW_SPEED = 1
local YOUTUBE_LINK = "https://youtube.com/@blue_mode?si=aCGyj0FnwCMtTP1M"
local MAIN_SIZE = UDim2.new(0, 420, 0, 80)
local MAIN_POS = UDim2.new(0, 20, 0.5, 0)
local SQUARE_SIZE = UDim2.new(0, 50, 0, 50)
local IsSmall = false

local UI = Instance.new("ScreenGui")
UI.Name = "BLUE_MODE_ESP"
UI.ResetOnSpawn = false
UI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
UI.DisplayOrder = 999
UI.Parent = game.CoreGui

local StartupText = Instance.new("TextLabel")
StartupText.Size = UDim2.new(0, 300, 0, 50)
StartupText.Position = UDim2.new(0.5, -150, 0.3, 0)
StartupText.BackgroundTransparency = 1
StartupText.Text = "✨ MADE BY BLUE_MODE ✨"
StartupText.TextColor3 = Color3.fromRGB(0, 255, 255)
StartupText.Font = Enum.Font.GothamBold
StartupText.TextScaled = true
StartupText.Parent = UI
task.delay(1, function() StartupText:Destroy() end)

local MainBar = Instance.new("Frame")
MainBar.Size = MAIN_SIZE
MainBar.Position = MAIN_POS
MainBar.BackgroundColor3 = Color3.fromRGB(25,25,25)
MainBar.BorderSizePixel = 2
MainBar.BorderColor3 = Color3.fromRGB(70,70,70)
MainBar.Active = true
MainBar.ClipsDescendants = false
MainBar.Parent = UI

local DragBar = Instance.new("Frame")
DragBar.Size = UDim2.new(1, -25, 0, 22)
DragBar.Position = UDim2.new(0, 0, 0, 0)
DragBar.BackgroundColor3 = Color3.fromRGB(60, 140, 220)
DragBar.Active = true
DragBar.Parent = MainBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "made by BLUE_MODE | DRAG HERE"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true
Title.Parent = DragBar

local ResizeBtn = Instance.new("TextButton")
ResizeBtn.Size = UDim2.new(0, 22, 1, 0)
ResizeBtn.Position = UDim2.new(1, -22, 0, 0)
ResizeBtn.BackgroundColor3 = Color3.fromRGB(160, 40, 40)
ResizeBtn.Text = "❌"
ResizeBtn.TextColor3 = Color3.new(1,1,1)
ResizeBtn.Font = Enum.Font.GothamBold
ResizeBtn.TextScaled = true
ResizeBtn.BorderSizePixel = 0
ResizeBtn.AutoLocalize = false
ResizeBtn.Parent = MainBar

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 90, 0, 30)
ToggleBtn.Position = UDim2.new(0, 10, 0, 32)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
ToggleBtn.Text = "ESP: OFF"
ToggleBtn.TextColor3 = Color3.new(1,1,1)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextScaled = true
ToggleBtn.BorderSizePixel = 0
ToggleBtn.AutoLocalize = false
ToggleBtn.Parent = MainBar

local YtBtn = Instance.new("TextButton")
YtBtn.Size = UDim2.new(0, 100, 0, 30)
YtBtn.Position = UDim2.new(0, 105, 0, 32)
YtBtn.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
YtBtn.Text = "📺 YOUTUBE"
YtBtn.TextColor3 = Color3.new(1,1,1)
YtBtn.Font = Enum.Font.GothamBold
YtBtn.TextScaled = true
YtBtn.BorderSizePixel = 0
YtBtn.AutoLocalize = false
YtBtn.Parent = MainBar

local DeleteBtn = Instance.new("TextButton")
DeleteBtn.Size = UDim2.new(0, 90, 0, 30)
DeleteBtn.Position = UDim2.new(0, 210, 0, 32)
DeleteBtn.BackgroundColor3 = Color3.fromRGB(140, 20, 20)
DeleteBtn.Text = "🗑️ DELETE"
DeleteBtn.TextColor3 = Color3.new(1,1,1)
DeleteBtn.Font = Enum.Font.GothamBold
DeleteBtn.TextScaled = true
DeleteBtn.BorderSizePixel = 0
DeleteBtn.AutoLocalize = false
DeleteBtn.Parent = MainBar

local SliderBG = Instance.new("Frame")
SliderBG.Size = UDim2.new(0, 70, 0, 26)
SliderBG.Position = UDim2.new(0, 310, 0, 32)
SliderBG.BackgroundColor3 = Color3.fromRGB(50,50,50)
SliderBG.Parent = MainBar

local SliderKnob = Instance.new("TextButton")
SliderKnob.Size = UDim2.new(0, 32, 1, 0)
SliderKnob.Position = UDim2.new(0, 0, 0, 0)
SliderKnob.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
SliderKnob.Text = "🔓"
SliderKnob.TextColor3 = Color3.new(0,0,0)
SliderKnob.Font = Enum.Font.GothamBold
SliderKnob.TextScaled = true
SliderKnob.BorderSizePixel = 0
SliderKnob.AutoLocalize = false
SliderKnob.ZIndex = 100
SliderKnob.Parent = SliderBG

local function SetLockState(locked)
    Buttons_Locked = locked
    if locked then
        TweenService:Create(SliderKnob, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {Position = UDim2.new(0, 38, 0, 0)}):Play()
        SliderKnob.Text = "🔒"
        SliderKnob.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
        DragBar.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
        Title.Text = "🔒 LOCKED"
    else
        TweenService:Create(SliderKnob, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {Position = UDim2.new(0, 0, 0, 0)}):Play()
        SliderKnob.Text = "🔓"
        SliderKnob.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
        DragBar.BackgroundColor3 = Color3.fromRGB(60, 140, 220)
        Title.Text = "made by BLUE_MODE | DRAG HERE"
    end
end

local Drag = {Active = false, StartX = 0, StartY = 0, StartPosX = 0, StartPosY = 0}
DragBar.InputBegan:Connect(function(Input)
    if Buttons_Locked then return end
    local IsMouse = Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch
    if not IsMouse then return end
    Drag.Active = true
    Drag.StartX = Input.Position.X
    Drag.StartY = Input.Position.Y
    Drag.StartPosX = MainBar.Position.X.Offset
    Drag.StartPosY = MainBar.Position.Y.Offset
end)

UserInputService.InputEnded:Connect(function(Input)
    local IsMouse = Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch
    if IsMouse then Drag.Active = false end
end)

UserInputService.InputChanged:Connect(function(Input)
    if not Drag.Active or Buttons_Locked then return end
    local IsMove = Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch
    if not IsMove then return end
    MainBar.Position = UDim2.new(0, Drag.StartPosX + (Input.Position.X - Drag.StartX), 0, Drag.StartPosY + (Input.Position.Y - Drag.StartY))
end)

local SliderActive = false
SliderKnob.InputBegan:Connect(function(Input)
    local IsMouse = Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch
    if IsMouse then SliderActive = true; Drag.Active = false end
end)

UserInputService.InputChanged:Connect(function(Input)
    if not SliderActive then return end
    local IsMove = Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch
    if not IsMove then return end
    SliderKnob.Position = UDim2.new(0, math.clamp(Input.Position.X - SliderBG.AbsolutePosition.X - 16, 0, 38), 0, 0)
end)

UserInputService.InputEnded:Connect(function()
    if not SliderActive then return end
    SliderActive = false
    SetLockState(SliderKnob.Position.X.Offset >= 20)
end)

ResizeBtn.MouseButton1Click:Connect(function()
    IsSmall = not IsSmall
    if IsSmall then
        MainBar.Size = SQUARE_SIZE
        DragBar.Visible = false
        ToggleBtn.Visible = false
        YtBtn.Visible = false
        DeleteBtn.Visible = false
        SliderBG.Visible = false
        Title.Text = "🔹"
        ResizeBtn.Text = "➕"
    else
        MainBar.Size = MAIN_SIZE
        DragBar.Visible = true
        ToggleBtn.Visible = true
        YtBtn.Visible = true
        DeleteBtn.Visible = true
        SliderBG.Visible = true
        Title.Text = "made by BLUE_MODE | DRAG HERE"
        ResizeBtn.Text = "❌"
    end
end)

ToggleBtn.MouseButton1Click:Connect(function()
    ESP_Enabled = not ESP_Enabled
    ToggleBtn.Text = ESP_Enabled and "ESP: ON" or "ESP: OFF"
    ToggleBtn.BackgroundColor3 = ESP_Enabled and Color3.fromRGB(25, 110, 25) or Color3.fromRGB(40,40,40)
    if not ESP_Enabled then
        for _, Plr in pairs(Players:GetPlayers()) do
            if Plr.Character then
                local Out = Plr.Character:FindFirstChild("BLUE_MODE_Outline")
                if Out then Out:Destroy() end
            end
        end
    end
end)

YtBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(YOUTUBE_LINK)
        YtBtn.Text = "✅ COPIED!"
        task.wait(1.5)
        YtBtn.Text = "📺 YOUTUBE"
    end
end)

DeleteBtn.MouseButton1Click:Connect(function()
    ESP_Enabled = false
    for _, Plr in pairs(Players:GetPlayers()) do
        if Plr.Character then
            local Out = Plr.Character:FindFirstChild("BLUE_MODE_Outline")
            if Out then Out:Destroy() end
        end
    end
    UI:Destroy()
end)

local function SetOutline(char, enable)
    if not char then return end
    local Out = char:FindFirstChild("BLUE_MODE_Outline")
    if enable and not Out then
        Out = Instance.new("Highlight")
        Out.Name = "BLUE_MODE_Outline"
        Out.FillTransparency = 1
        Out.OutlineTransparency = 0
        Out.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        Out.Adornee = char
        Out.Parent = char
    elseif not enable and Out then Out:Destroy() end
end

local Hue = 0
RunService.RenderStepped:Connect(function(deltaTime)
    if not UI or not UI.Parent then return end
    Hue = (Hue + deltaTime * RAINBOW_SPEED) % 1
    local RainbowColor = Color3.fromHSV(Hue, 1, 1)
    MainBar.BorderColor3 = RainbowColor
    if not ESP_Enabled then return end
    for _, Player in pairs(Players:GetPlayers()) do
        if Player == LocalPlayer then continue end
        local Character = Player.Character
        if not Character then continue end
        local Humanoid = Character:FindFirstChildOfClass("Humanoid")
        if not Humanoid or Humanoid.Health <= 0 then
            SetOutline(Character, false)
        else
            SetOutline(Character, true)
            local Outline = Character:FindFirstChild("BLUE_MODE_Outline")
            if Outline then Outline.OutlineColor = RainbowColor end
        end
    end
end)

Players.PlayerAdded:Connect(function(Player)
    Player.CharacterAdded:Connect(function()
        task.wait(0.1)
        if ESP_Enabled and Player.Character then
            SetOutline(Player.Character, true)
        end
    end)
end)
