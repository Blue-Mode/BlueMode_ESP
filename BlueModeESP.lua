-- BACKGROUND IMAGE
local BG_ASSET = "rbxassetid://YOUR_MOUNTAIN_IMAGE_ID" -- replace with your mountain decal ID
local BG = Instance.new("ImageLabel", MainWin)
BG.Size = UDim2.new(1,0,1,0)
BG.Image = BG_ASSET
BG.BackgroundTransparency = 1
BG.ZIndex = -1

-- TITLE
local Title = Instance.new("TextLabel", MainWin)
Title.Size = UDim2.new(1,0,0,50)
Title.Text = "Blue Mode Boombox"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 34
Title.TextColor3 = Color3.new(1,1,1)
Title.BackgroundTransparency = 1

-- LINK BUTTON (RED)
local LinkBtn = Instance.new("TextButton", MainWin)
LinkBtn.Size = UDim2.new(0,55,0,55)
LinkBtn.Position = UDim2.new(0,15,0,320)
LinkBtn.Text = "Link\nYT"
LinkBtn.Font = Enum.Font.GothamBold
LinkBtn.TextSize = 16
LinkBtn.TextColor3 = Color3.new(1,1,1)
LinkBtn.BackgroundColor3 = Color3.fromRGB(190,40,40) -- RED for link
LinkBtn.MouseButton1Click:Connect(function()
    setclipboard(YT_LINK)
    print("✅ YouTube link copied!")
end)
addRainbowOutline(LinkBtn)

-- PLAY BUTTON (GREEN)
local PlayBtn = Instance.new("TextButton", MainWin)
PlayBtn.Size = UDim2.new(0,330,0,90)
PlayBtn.Position = UDim2.new(0,80,0,310)
PlayBtn.Text = "Play"
PlayBtn.BackgroundColor3 = Color3.fromRGB(50,170,70) -- GREEN
PlayBtn.MouseButton1Click:Connect(function()
    local id = ID_Box.Text:gsub("%D","")
    if id == "" then return end
    if currentSound then currentSound:Destroy() end
    currentSound = Instance.new("Sound", SoundService)
    currentSound.SoundId = "rbxassetid://"..id
    currentSound.Volume = vol/1000
    currentSound.Looped = true
    currentSound:Play()
end)
addRainbowOutline(PlayBtn)

-- STOP BUTTON (BLUE/WHITE)
local StopBtn = Instance.new("TextButton", MainWin)
StopBtn.Size = UDim2.new(0,145,0,90)
StopBtn.Position = UDim2.new(0,420,0,310)
StopBtn.Text = "Stop"
StopBtn.BackgroundColor3 = Color3.fromRGB(55,60,80) -- Neutral blue/white
StopBtn.MouseButton1Click:Connect(function()
    if currentSound then currentSound:Destroy() currentSound = nil end
end)
addRainbowOutline(StopBtn)

-- DELETE BUTTON (STRONG RED)
local DeleteBtn = Instance.new("TextButton", MainWin)
DeleteBtn.Size = UDim2.new(0,110,0,80)
DeleteBtn.Position = UDim2.new(0,460,0,410)
DeleteBtn.Text = "Delete"
DeleteBtn.BackgroundColor3 = Color3.fromRGB(190,40,40) -- Strong red
DeleteBtn.MouseButton1Click:Connect(function()
    if currentSound then currentSound:Destroy() end
    for _, dot in pairs(friendDots) do if dot then dot.Parent:Destroy() end end
    Gui:Destroy()
    getgenv().BlueModeBoombox = nil
end)
addRainbowOutline(DeleteBtn)
