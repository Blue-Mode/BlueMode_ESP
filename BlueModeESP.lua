-- 🌈 UNIVERSAL RAINBOW ERROR POPUP
local function AddRainbowGlow(target, thickness)
    local Outline = Instance.new("UIStroke")
    Outline.Name = "RainbowAura"
    Outline.Thickness = thickness or 3
    Outline.Transparency = 0
    Outline.Parent = target
    return Outline
end

local function ShowErrorPopup(message)
    local PopupUI = Instance.new("ScreenGui")
    PopupUI.Name = "ErrorPopup"
    PopupUI.ResetOnSpawn = false
    PopupUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    PopupUI.DisplayOrder = 2147483647
    PopupUI.Parent = CoreGui

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 320, 0, 180)
    Frame.Position = UDim2.new(0.5, -160, 0.5, -90)
    Frame.BackgroundColor3 = Color3.fromRGB(40,40,40)
    Frame.Parent = PopupUI
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0,12)
    AddRainbowGlow(Frame, 4)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1,0,0,40)
    Title.Text = "⚠️ ERROR"
    Title.TextColor3 = Color3.new(1,0.3,0.3)
    Title.Font = Enum.Font.GothamBold
    Title.TextScaled = true
    Title.BackgroundTransparency = 1
    Title.Parent = Frame
    AddRainbowGlow(Title, 2)

    local Msg = Instance.new("TextLabel")
    Msg.Size = UDim2.new(1,-20,0,60)
    Msg.Position = UDim2.new(0,10,0,50)
    Msg.Text = message or "An unknown error occurred."
    Msg.TextColor3 = Color3.new(1,1,1)
    Msg.Font = Enum.Font.Gotham
    Msg.TextWrapped = true
    Msg.TextScaled = true
    Msg.BackgroundTransparency = 1
    Msg.Parent = Frame
    AddRainbowGlow(Msg, 2)

    local OkBtn = Instance.new("TextButton")
    OkBtn.Size = UDim2.new(0,120,0,40)
    OkBtn.Position = UDim2.new(0,30,0,120)
    OkBtn.Text = "OK"
    OkBtn.BackgroundColor3 = Color3.fromRGB(25,140,255)
    OkBtn.TextColor3 = Color3.new(1,1,1)
    OkBtn.Font = Enum.Font.GothamBold
    OkBtn.TextScaled = true
    OkBtn.Parent = Frame
    Instance.new("UICorner", OkBtn).CornerRadius = UDim.new(0,8)
    AddRainbowGlow(OkBtn, 3)

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0,120,0,40)
    CloseBtn.Position = UDim2.new(0,170,0,120)
    CloseBtn.Text = "Close"
    CloseBtn.BackgroundColor3 = Color3.fromRGB(200,30,30)
    CloseBtn.TextColor3 = Color3.new(1,1,1)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextScaled = true
    CloseBtn.Parent = Frame
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0,8)
    AddRainbowGlow(CloseBtn, 3)

    OkBtn.MouseButton1Click:Connect(function()
        print("Error acknowledged.")
        PopupUI:Destroy()
    end)

    CloseBtn.MouseButton1Click:Connect(function()
        PopupUI:Destroy()
    end)
end

-- 🔧 Example integration:
-- ShowErrorPopup("Cooldown active! Please wait.")
-- ShowErrorPopup("Invalid Sound ID entered.")
