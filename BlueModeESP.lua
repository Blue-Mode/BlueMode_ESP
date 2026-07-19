-- 📟 UNIVERSAL CONSOLE GUI
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- State
local ConsoleOpen = false
local ConsoleUI = nil

-- Function to create console
local function CreateConsole()
    ConsoleUI = Instance.new("ScreenGui")
    ConsoleUI.Name = "UniversalConsole"
    ConsoleUI.ResetOnSpawn = false
    ConsoleUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ConsoleUI.DisplayOrder = 2147483647 -- always on top
    ConsoleUI.Parent = CoreGui

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 400, 0, 250)
    Frame.Position = UDim2.new(0.5, -200, 0.5, -125)
    Frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
    Frame.Parent = ConsoleUI
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0,10)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1,0,0,40)
    Title.Text = "📟 Universal Console"
    Title.TextColor3 = Color3.new(1,1,1)
    Title.Font = Enum.Font.GothamBold
    Title.TextScaled = true
    Title.BackgroundTransparency = 1
    Title.Parent = Frame

    local Input = Instance.new("TextBox")
    Input.Size = UDim2.new(1,-20,0,120)
    Input.Position = UDim2.new(0,10,0,50)
    Input.Text = ""
    Input.PlaceholderText = "Paste Lua/Python/loadstring code here..."
    Input.TextColor3 = Color3.new(1,1,1)
    Input.BackgroundColor3 = Color3.fromRGB(40,40,40)
    Input.Font = Enum.Font.Code
    Input.TextScaled = false
    Input.TextSize = 16
    Input.MultiLine = true
    Input.ClearTextOnFocus = false
    Input.Parent = Frame
    Instance.new("UICorner", Input).CornerRadius = UDim.new(0,8)

    local ExecBtn = Instance.new("TextButton")
    ExecBtn.Size = UDim2.new(0,120,0,40)
    ExecBtn.Position = UDim2.new(0,20,0,190)
    ExecBtn.Text = "▶ EXECUTE"
    ExecBtn.BackgroundColor3 = Color3.fromRGB(25,140,255)
    ExecBtn.TextColor3 = Color3.new(1,1,1)
    ExecBtn.Font = Enum.Font.GothamBold
    ExecBtn.TextScaled = true
    ExecBtn.Parent = Frame
    Instance.new("UICorner", ExecBtn).CornerRadius = UDim.new(0,8)

    local ClearBtn = Instance.new("TextButton")
    ClearBtn.Size = UDim2.new(0,120,0,40)
    ClearBtn.Position = UDim2.new(0,160,0,190)
    ClearBtn.Text = "🗑 CLEAR"
    ClearBtn.BackgroundColor3 = Color3.fromRGB(200,30,30)
    ClearBtn.TextColor3 = Color3.new(1,1,1)
    ClearBtn.Font = Enum.Font.GothamBold
    ClearBtn.TextScaled = true
    ClearBtn.Parent = Frame
    Instance.new("UICorner", ClearBtn).CornerRadius = UDim.new(0,8)

    -- Actions
    ExecBtn.MouseButton1Click:Connect(function()
        local code = Input.Text
        if code ~= "" then
            -- ⚠️ Lua execution only (Roblox cannot run Python natively)
            local func, err = loadstring(code)
            if func then
                pcall(func)
            else
                warn("Console Error: "..err)
            end
        end
    end)

    ClearBtn.MouseButton1Click:Connect(function()
        Input.Text = ""
    end)
end

-- Toggle Console Button
local ConsoleBtn = Instance.new("TextButton")
ConsoleBtn.Size = UDim2.new(0,120,0,40)
ConsoleBtn.Position = UDim2.new(0,20,0,20)
ConsoleBtn.Text = "📟 CONSOLE"
ConsoleBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
ConsoleBtn.TextColor3 = Color3.new(1,1,1)
ConsoleBtn.Font = Enum.Font.GothamBold
ConsoleBtn.TextScaled = true
ConsoleBtn.Parent = CoreGui

local clickCount = 0
ConsoleBtn.MouseButton1Click:Connect(function()
    clickCount += 1
    if clickCount == 1 then
        if not ConsoleOpen then
            CreateConsole()
            ConsoleOpen = true
        end
    elseif clickCount == 2 then
        if ConsoleUI then ConsoleUI:Destroy() end
        ConsoleOpen = false
        clickCount = 0
    end
end)
