-- BLUE MODE ESP v2.9 FULL | FIXED GUI + RAINBOW CONSOLE
-- UNLOCK: Blue_Mode192823 | NO CUTOFFS
if getgenv().BlueMode then return end
getgenv().BlueMode = true

-- SERVICES
local plr = game:GetService("Players").LocalPlayer
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local ss = game:GetService("SoundService")
local cg = game:GetService("CoreGui")

-- UTILS
local function wf(k,v) pcall(function() if writefile then writefile(k..".txt",tostring(v)) end end) end
local function rf(k,d) local r=nil pcall(function() if readfile then r=readfile(k..".txt") end end) return tonumber(r) or d end
local function sc(t) pcall(function() if setclipboard then setclipboard(t) end end) end

-- SETTINGS
local MAX_Z = 2147483647
local LIMIT = 43200
local CD = 43200
local YT = "https://youtube.com/@blue_mode?si=aCGyj0FnwCMtTP1M"
local F = {U="BM_U",C="BM_C",V="BM_V"}

-- COOLDOWN
local tm = os.time()
local ce = rf(F.C,0)
if tm < ce then warn("[BLUE] COOLDOWN: "..math.floor((ce-tm)/60).."m") getgenv().BlueMode=false return end

-- DATA
local used = rf(F.U,0)
local lt = os.time()
local vol = math.clamp(rf(F.V,500),1,1000) -- 1 TO 1000 ONLY

-- GLOBALS
local snd = nil
local vL = {}
local vB = {}
local rainbowObjs = {}
local wins = {Main=nil,Music=nil,Console=nil}
local mOpen = false
local esp = false
local lck = false
local hue = 0
local min = false

-- ✅ RAINBOW HELPER
local function addRainbow(obj, isText)
    if not obj then return end
    if isText then
        table.insert(rainbowObjs, {Type="Text", Obj=obj})
    else
        local stroke = Instance.new("UIStroke")
        stroke.Thickness = 3
        stroke.LineJoinMode = Enum.LineJoinMode.Round
        stroke.Parent = obj
        table.insert(rainbowObjs, {Type="Stroke", Obj=stroke})
    end
    return obj
end

-- MODAL LOCK
local function modal(s) if wins.Main then wins.Main.Modal = s end end
local function refModal() modal(mOpen) end

-- ✅ VOLUME SYSTEM
local function setVol(v)
    vol = math.clamp(tonumber(v) or 500,1,1000)
    wf(F.V,vol)
    local n = vol/1000
    if snd then pcall(function() snd.Volume = n end) end
    local txt = tostring(math.floor(vol)).."/1000"
    if vL.M then vL.M.Text = txt end
    if vL.S then vL.S.Text = txt end
    if vB.M then vB.M.Size = UDim2.new(n,0,1,0) end
    if vB.S then vB.S.Size = UDim2.new(n,0,1,0) end
end

-- SOUND
local function play(id)
    pcall(function() if snd then snd:Destroy() end end)
    snd = Instance.new("Sound")
    snd.SoundId = "rbxassetid://"..tostring(id):gsub("%D","")
    snd.Volume = vol/1000
    snd.Looped = true
    snd.Parent = ss
    pcall(function() snd:Play() end)
end

-- CLEAR ESP
local function clrEsp()
    pcall(function()
        for _,p in pairs(game.Players:GetPlayers()) do
            if p~=plr and p.Character then
                local e=p.Character:FindFirstChild("BM_ESP") if e then e:Destroy() end
                local d=p.Character:FindFirstChild("BM_DOT") if d then d:Destroy() end
            end
        end
    end)
end

-- ==============================================
-- 🎵 MUSIC WINDOW (TOGGLE LIKE BEFORE)
-- ==============================================
local function openMusic()
    if wins.Music then wins.Music:Destroy() wins.Music=nil mOpen=(wins.Console~=nil) refModal() return end
    if wins.Console then wins.Console:Destroy() wins.Console=nil end
    mOpen=true refModal()

    local g = Instance.new("ScreenGui")
    g.Name="BM_MUSIC" g.ZIndexBehavior=2 g.DisplayOrder=MAX_Z g.IgnoreGuiInset=true g.Parent=cg
    wins.Music=g

    local f = Instance.new("Frame")
    f.Size=UDim2.new(0,340,0,260) f.Position=UDim2.new(0.5,-170,0.5,-130)
    f.BackgroundColor3=Color3.new(0.08,0.08,0.08) f.Active=true f.Parent=g
    Instance.new("UICorner",f).CornerRadius=UDim.new(0,12) addRainbow(f)

    local x = Instance.new("TextButton")
    x.Size=UDim2.new(0,32,0,32) x.Position=UDim2.new(1,-37,0,5)
    x.BackgroundColor3=Color3.new(0.66,0.12,0.12) x.Text="✕"
    x.TextColor3=Color3.new(1,1,1) x.Font=Enum.Font.GothamBold x.TextSize=24
    x.Parent=f addRainbow(x) addRainbow(x,true)
    x.MouseButton1Click:Connect(function() g:Destroy() wins.Music=nil mOpen=(wins.Console~=nil) refModal() end)

    local t = Instance.new("TextLabel")
    t.Size=UDim2.new(1,0,0,40) t.Position=UDim2.new(0,0,0,8)
    t.BackgroundTransparency=1 t.Text="🎵 BOOMBOX · 1-1000 VOL"
    t.Font=Enum.Font.GothamBold t.TextScaled=true t.Parent=f addRainbow(t,true)

    local id = Instance.new("TextBox")
    id.Size=UDim2.new(1,-40,0,45) id.Position=UDim2.new(0,20,0,55)
    id.BackgroundColor3=Color3.new(0.14,0.14,0.14)
    id.PlaceholderText="PASTE SOUND ID"
    id.TextColor3=Color3.new(1,1,1) id.Font=Enum.Font.Gotham id.TextScaled=true
    id.Parent=f Instance.new("UICorner",id).CornerRadius=UDim.new(0,8) addRainbow(id)

    local vt = Instance.new("TextLabel")
    vt.Size=UDim2.new(0,120,0,30) vt.Position=UDim2.new(0,20,0,115)
    vt.BackgroundTransparency=1 vt.Text="🔊 VOLUME:"
    vt.Font=Enum.Font.GothamBold vt.TextScaled=true vt.Parent=f addRainbow(vt,true)

    vL.S = Instance.new("TextLabel")
    vL.S.Size=UDim2.new(0,90,0,30) vL.S.Position=UDim2.new(1,-110,0,115)
    vL.S.BackgroundTransparency=1 vL.S.Text=tostring(math.floor(vol)).."/1000"
    vL.S.Font=Enum.Font.GothamBold vL.S.TextScaled=true vL.S.Parent=f addRainbow(vL.S,true)

    local sb = Instance.new("Frame")
    sb.Size=UDim2.new(1,-40,0,24) sb.Position=UDim2.new(0,20,0,150)
    sb.BackgroundColor3=Color3.new(0.2,0.2,0.2) sb.Active=true
    sb.Parent=f Instance.new("UICorner",sb).CornerRadius=UDim.new(0,12) addRainbow(sb)

    vB.S = Instance.new("Frame")
    vB.S.Size=UDim2.new(vol/1000,0,1,0)
    vB.S.BackgroundColor3=Color3.new(0.4,0.4,0.4)
    vB.S.Parent=sb Instance.new("UICorner",vB.S).CornerRadius=UDim.new(0,12)

    local sl=false
    local function upd(i)
        local p = math.clamp((i.Position.X-sb.AbsolutePosition.X)/sb.AbsoluteSize.X,0,1)
        setVol((p*999)+1)
    end
    sb.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            sl=true modal(true) upd(i)
        end
    end)
    uis.InputChanged:Connect(function(i)
        if sl and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then upd(i) end
    end)
    uis.InputEnded:Connect(function(i)
        if sl then sl=false wait(0.05) refModal() end
    end)

    local pb = Instance.new("TextButton")
    pb.Size=UDim2.new(0,140,0,40) pb.Position=UDim2.new(0,20,0,195)
    pb.BackgroundColor3=Color3.new(0.1,0.55,1) pb.Text="▶ PLAY"
    pb.TextColor3=Color3.new(1,1,1) pb.Font=Enum.Font.GothamBold pb.TextScaled=true
    pb.Parent=f Instance.new("UICorner",pb).CornerRadius=UDim.new(0,8) addRainbow(pb) addRainbow(pb,true)
    pb.MouseButton1Click:Connect(function() if id.Text~="" then play(id.Text) end end)

    local sB = Instance.new("TextButton")
    sB.Size=UDim2.new(0,140,0,40) sB.Position=UDim2.new(0,180,0,195)
    sB.BackgroundColor3=Color3.new(0.78,0.12,0.12) sB.Text="⏹ STOP"
    sB.TextColor3=Color3.new(1,1,1) sB.Font=Enum.Font.GothamBold sB.TextScaled=true
    sB.Parent=f Instance.new("UICorner",sB).CornerRadius=UDim.new(0,8) addRainbow(sB) addRainbow(sB,true)
    sB.MouseButton1Click:Connect(function() pcall(function() if snd then snd:Destroy() end end) end)
end

-- ==============================================
-- 💻 CONSOLE (EXACTLY YOUR REQUEST)
-- ==============================================
local function openConsole()
    -- ✅ TOGGLE: CLICK AGAIN TO CLOSE, CLOSES MUSIC IF OPEN
    if wins.Console then wins.Console:Destroy() wins.Console=nil mOpen=(wins.Music~=nil) refModal() return end
    if wins.Music then wins.Music:Destroy() wins.Music=nil end
    mOpen=true refModal()

    local g = Instance.new("ScreenGui")
    g.Name="BM_CONSOLE" g.ZIndexBehavior=2 g.DisplayOrder=MAX_Z g.IgnoreGuiInset=true g.Parent=cg
    wins.Console=g

    local f = Instance.new("Frame")
    f.Size=UDim2.new(0,400,0,380) f.Position=UDim2.new(0.5,-200,0.5,-190)
    f.BackgroundColor3=Color3.new(0.08,0.08,0.08) f.Active=true f.Parent=g
    Instance.new("UICorner",f).CornerRadius=UDim.new(0,14) addRainbow(f)

    local x = Instance.new("TextButton")
    x.Size=UDim2.new(0,32,0,32) x.Position=UDim2.new(1,-37,0,5)
    x.BackgroundColor3=Color3.new(0.66,0.12,0.12) x.Text="✕"
    x.TextColor3=Color3.new(1,1,1) x.Font=Enum.Font.GothamBold x.TextSize=24
    x.Parent=f addRainbow(x) addRainbow(x,true)
    x.MouseButton1Click:Connect(function() g:Destroy() wins.Console=nil mOpen=(wins.Music~=nil) refModal() end)

    local t = Instance.new("TextLabel")
    t.Size=UDim2.new(1,0,0,40) t.Position=UDim2.new(0,0,0,8)
    t.BackgroundTransparency=1 t.Text="💻 LUA CONSOLE · LOADSTRING"
    t.Font=Enum.Font.GothamBold t.TextScaled=true t.Parent=f addRainbow(t,true)

    local cb = Instance.new("TextBox")
    cb.Size=UDim2.new(1,-30,0,190) cb.Position=UDim2.new(0,15,0,50)
    cb.BackgroundColor3=Color3.new(0.12,0.12,0.12)
    cb.PlaceholderText="PASTE ANY LUA SCRIPT OR LOADSTRING HERE"
    cb.TextColor3=Color3.new(1,1,1) cb.Font=Enum.Font.Code
    cb.TextSize=12 cb.TextWrapped=true cb.MultiLine=true cb.ClearTextOnFocus=false
    cb.Parent=f Instance.new("UICorner",cb).CornerRadius=UDim.new(0,8) addRainbow(cb)

    local lg = Instance.new("TextBox")
    lg.Size=UDim2.new(1,-30,0,55) lg.Position=UDim2.new(0,15,0,250)
    lg.BackgroundColor3=Color3.new(0.1,0.1,0.1)
    lg.Text="[READY] Paste code then click EXECUTE"
    lg.TextColor3=Color3.new(0.3,1,0.4) lg.Font=Enum.Font.Code lg.TextSize=11
    lg.ReadOnly=true lg.TextWrapped=true lg.MultiLine=true
    lg.Parent=f Instance.new("UICorner",lg).CornerRadius=UDim.new(0,8) addRainbow(lg) addRainbow(lg,true)

    -- ✅ EXECUTE BUTTON
    local ex = Instance.new("TextButton")
    ex.Size=UDim2.new(0,110,0,35) ex.Position=UDim2.new(0,15,0,315)
    ex.BackgroundColor3=Color3.new(0.08,0.6,0.15) ex.Text="▶ EXECUTE"
    ex.TextColor3=Color3.new(1,1,1) ex.Font=Enum.Font.GothamBold ex.TextScaled=true
    ex.Parent=f Instance.new("UICorner",ex).CornerRadius=UDim.new(0,6) addRainbow(ex) addRainbow(ex,true)
    ex.MouseButton1Click:Connect(function()
        local code = cb.Text:gsub("^%s+",""):gsub("%s+$","")
        if code == "" then
            lg.TextColor3=Color3.new(1,0.3,0.3)
            lg.Text = "[ERROR] No code entered!"
            return
        end
        local fn, err = loadstring(code)
        if not fn then
            lg.TextColor3=Color3.new(1,0.3,0.3)
            lg.Text = "[SYNTAX ERROR] "..tostring(err)
            return
        end
        local ok, runErr = pcall(fn)
        if ok then
            lg.TextColor3=Color3.new(0.3,1,0.4)
            lg.Text = "[SUCCESS] Script ran without errors!"
        else
            lg.TextColor3=Color3.new(1,0.3,0.3)
            lg.Text = "[RUNTIME ERROR] "..tostring(runErr)
        end
    end)

    -- ✅ CLEAR BUTTON
    local cl = Instance.new("TextButton")
    cl.Size=UDim2.new(0,110,0,35) cl.Position=UDim2.new(0,145,0,315)
    cl.BackgroundColor3=Color3.new(0.6,0.35,0.08) cl.Text="🗑️ CLEAR"
    cl.TextColor3=Color3.new(1,1,1) cl.Font=Enum.Font.GothamBold cl.TextScaled=true
    cl.Parent=f Instance.new("UICorner",cl).CornerRadius=UDim.new(0,6) addRainbow(cl) addRainbow(cl,true)
    cl.MouseButton1Click:Connect(function()
        cb.Text=""
        lg.Text="[CLEARED] Ready for new code"
        lg.TextColor3=Color3.new(1,1,1)
    end)

    -- ✅ CLOSE BUTTON
    local cx = Instance.new("TextButton")
    cx.Size=UDim2.new(0,110,0,35) cx.Position=UDim2.new(0,275,0,315)
    cx.BackgroundColor3=Color3.new(0.55,0.08,0.08) cx.Text="✖ CLOSE"
    cx.TextColor3=Color3.new(1,1,1) cx.Font=Enum.Font.GothamBold cx.TextScaled=true
    cx.Parent=f Instance.new("UICorner",cx).CornerRadius=UDim.new(0,6) addRainbow(cx) addRainbow(cx,true)
    cx.MouseButton1Click:Connect(function()
        g:Destroy() wins.Console=nil mOpen=(wins.Music~=nil) refModal()
    end)
end

-- ==============================================
-- 🎮 MAIN UI (FIXED FROM YOUR SCREENSHOT)
-- ==============================================
local function buildMain()
    local g = Instance.new("ScreenGui")
    g.Name="BM_MAIN" g.ZIndexBehavior=2 g.DisplayOrder=MAX_Z g.IgnoreGuiInset=true g.Modal=false g.Parent=cg
    wins.Main=g

    coroutine.wrap(function()
        while g and g.Parent do
            pcall(function()
                g.DisplayOrder=MAX_Z
                if wins.Music then wins.Music.DisplayOrder=MAX_Z end
                if wins.Console then wins.Console.DisplayOrder=MAX_Z end
            end)
            wait(1)
        end
    end)()

    uis.MenuOpened:Connect(function()
        g.Visible=false if wins.Music then wins.Music.Visible=false end if wins.Console then wins.Console.Visible=false end
    end)
    uis.MenuClosed:Connect(function()
        g.Visible=true if wins.Music then wins.Music.Visible=true end if wins.Console then wins.Console.Visible=true end
    end)

    local NORM = UDim2.new(0,720,0,110)
    local SMOL = UDim2.new(0,55,0,55)
    local mf = Instance.new("Frame")
    mf.Size=NORM mf.Position=UDim2.new(0,20,0.5,-55)
    mf.BackgroundColor3=Color3.new(0.08,0.08,0.08) mf.Active=true mf.ZIndex=10
    mf.Parent=g Instance.new("UICorner",mf).CornerRadius=UDim.new(0,10) addRainbow(mf)

    local db = Instance.new("TextButton")
    db.Size=UDim2.new(1,-130,0,25) db.Position=UDim2.new(0,5,0,5)
    db.BackgroundColor3=Color3.new(0.24,0.55,0.86)
    db.Active=true db.Text="MADE BY BLUE_MODE | DRAG TO MOVE"
    db.TextColor3=Color3.new(1,1,1) db.Font=Enum.Font.GothamBold db.TextScaled=true db.TextXAlignment=0
    db.Parent=mf addRainbow(db) addRainbow(db,true)

    local tmLabel = Instance.new("TextLabel")
    tmLabel.Size=UDim2.new(0,115,0,25) tmLabel.Position=UDim2.new(1,-125,0,5)
    tmLabel.BackgroundColor3=Color3.new(0.15,0.15,0.15)
    tmLabel.Text="12:00:00"
    tmLabel.Font=Enum.Font.GothamBold tmLabel.TextScaled=true tmLabel.TextXAlignment=1
    tmLabel.Parent=mf Instance.new("UICorner",tmLabel).CornerRadius=UDim.new(0,6) addRainbow(tmLabel) addRainbow(tmLabel,true)

    local mb = Instance.new("TextButton")
    mb.Size=UDim2.new(0,25,0,25) mb.Position=UDim2.new(1,-30,0,35)
    mb.BackgroundColor3=Color3.new(0.63,0.16,0.16) mb.Text="➖"
    mb.TextColor3=Color3.new(1,1,1) mb.Font=Enum.Font.GothamBold mb.TextScaled=true
    mb.Parent=mf addRainbow(mb) addRainbow(mb,true)

    local function btn(sz,pos,bg,txt)
        local b = Instance.new("TextButton")
        b.Size=sz b.Position=pos b.BackgroundColor3=bg
        b.Text=txt b.TextColor3=Color3.new(1,1,1)
        b.Font=Enum.Font.GothamBold b.TextScaled=true
        b.Parent=mf Instance.new("UICorner",b).CornerRadius=UDim.new(0,6) addRainbow(b) addRainbow(b,true)
        return b
    end

    local bEsp = btn(UDim2.new(0,90,0,32),UDim2.new(0,10,0,35),Color3.new(0.16,0.16,0.16),"ESP: OFF")
    local bYt  = btn(UDim2.new(0,70,0,32),UDim2.new(0,110,0,35),Color3.new(0.78,0.12,0.12),"📺 YT")
    local bMu  = btn(UDim2.new(0,95,0,32),UDim2.new(0,190,0,35),Color3.new(0.16,0.31,0.63),"🎵 MUSIC")
    local bCn  = btn(UDim2.new(0,105,0,32),UDim2.new(0,295,0,35),Color3.new(0.12,0.39,0.35),"💻 CONSOLE")
    local bLk  = btn(UDim2.new(0,100,0,32),UDim2.new(0,410,0,35),Color3.new(0.2,0.2,0.2),"🔓 UNLOCK")
    local bEx  = btn(UDim2.new(0,80,0,32),UDim2.new(0,520,0,35),Color3.new(0.55,0.08,0.08),"🗑️ EXIT")

    local vt = Instance.new("TextLabel")
    vt.Size=UDim2.new(0,45,0,28) vt.Position=UDim2.new(0,10,0,72)
    vt.BackgroundTransparency=1 vt.Text="🔊"
    vt.Font=Enum.Font.Gotham vt.TextScaled=true vt.Parent=mf addRainbow(vt,true)

    vL.M = Instance.new("TextLabel")
    vL.M.Size=UDim2.new(0,75,0,28) vL.M.Position=UDim2.new(0,50,0,72)
    vL.M.BackgroundTransparency=1 vL.M.Text=tostring(math.floor(vol)).."/1000"
    vL.M.Font=Enum.Font.GothamBold vL.M.TextScaled=true vL.M.Parent=mf addRainbow(vL.M,true)

    local vs = Instance.new("Frame")
    vs.Size=UDim2.new(0,200,0,20) vs.Position=UDim2.new(0,130,0,76)
    vs.BackgroundColor3=Color3.new(0.2,0.2,0.2) vs.Active=true vs.ZIndex=15
    vs.Parent=mf Instance.new("UICorner",vs).CornerRadius=UDim.new(0,9) addRainbow(vs)

    vB.M = Instance.new("Frame")
    vB.M.Size=UDim2.new(vol/1000,0,1,0)
    vB.M.BackgroundColor3=Color3.new(0.4,0.4,0.4)
    vB.M.Parent=vs Instance.new("UICorner",vB.M).CornerRadius=UDim.new(0,9)

    local msl=false
    local function mupd(i)
        local p = math.clamp((i.Position.X-vs.AbsolutePosition.X)/vs.AbsoluteSize.X,0,1)
        setVol((p*999)+1)
    end
    vs.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            msl=true modal(true) mupd(i)
        end
    end)
    uis.InputChanged:Connect(function(i)
        if msl and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then mupd(i) end
    end)
    uis.InputEnded:Connect(function(i)
        if msl then msl=false wait(0.05) refModal() end
    end)

    local dr=false local ds=Vector2.new() local fs=Vector2.new()
    db.InputBegan:Connect(function(i)
        if lck then return end
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            dr=true ds=Vector2.new(i.Position.X,i.Position.Y)
            fs=Vector2.new(mf.Position.X.Offset,mf.Position.Y.Offset)
            modal(true)
        end
    end)
    uis.InputChanged:Connect(function(i)
        if not dr or lck then return end
        if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then
            local d = Vector2.new(i.Position.X,i.Position.Y)-ds
            mf.Position=UDim2.new(0,fs.X+d.X,0,fs.Y+d.Y)
        end
    end)
    uis.InputEnded:Connect(function(i)
        if dr then dr=false wait(0.05) refModal() end
    end)

    bEsp.MouseButton1Click:Connect(function()
        esp=not esp
        bEsp.Text=esp and "ESP: ON" or "ESP: OFF"
        bEsp.BackgroundColor3=esp and Color3.new(0.1,0.47,0.1) or Color3.new(0.16,0.16,0.16)
        if not esp then clrEsp() end
    end)

    bYt.MouseButton1Click:Connect(function()
        sc(YT) bYt.Text="✅ OK" wait(1.5) bYt.Text="📺 YT"
    end)

    bMu.MouseButton1Click:Connect(openMusic)
    bCn.MouseButton1Click:Connect(openConsole)

    bLk.MouseButton1Click:Connect(function()
        lck=not lck
        bLk.Text=lck and "🔒 LOCKED" or "🔓 UNLOCK"
        bLk.BackgroundColor3=lck and Color3.new(0.7,0.16,0.16) or Color3.new(0.2,0.2,0.2)
    end)

    mb.MouseButton1Click:Connect(function()
        min=not min
        if min then
            mf.Size=SMOL
            bEsp.Visible=false bYt.Visible=false bMu.Visible=false
            bCn.Visible=false bLk.Visible=false bEx.Visible=false
            vt.Visible=false vL.M.Visible=false vs.Visible=false
            db.Text="" mb.Text="➕"
        else
            mf.Size=NORM
            bEsp.Visible=true bYt.Visible=true bMu.Visible=true
            bCn.Visible=true bLk.Visible=true bEx.Visible=true
            vt.Visible=true vL.M.Visible=true vs.Visible=true
            db.Text="MADE BY BLUE_MODE | DRAG TO MOVE" mb.Text="➖"
        end
    end)

    bEx.MouseButton1Click:Connect(function()
        clrEsp()
        pcall(function() if snd then snd:Destroy() end end)
        if wins.Music then wins.Music:Destroy() end
        if wins.Console then wins.Console:Destroy() end
        g:Destroy() getgenv().BlueMode=false
    end)

    rs.Heartbeat:Connect(function(dt)
        pcall(function()
            if not g or not g.Parent then return end

            local n = os.time()
            used = used + math.max(0,n-lt); lt = n
            wf(F.U,used)
            local rem = math.max(0,LIMIT-used)
            tmLabel.Text = string.format("%02d:%02d:%02d",math.floor(rem/3600),math.floor((rem%3600)/60),rem%60)
            if rem<=0 then
                wf(F.C,os.time()+CD)
                bEx:Fire() return
            end

            hue = (hue + (dt*0.5)) % 1
            local rc = Color3.fromHSV(hue,1,1)
            for _,obj in pairs(rainbowObjs) do
                if obj.Type=="Stroke" and obj.Obj then obj.Obj.Color=rc end
                if obj.Type=="Text" and obj.Obj then obj.Obj.TextColor3=rc end
            end
            if vB.M then vB.M.BackgroundColor3=rc end
            if vB.S then vB.S.BackgroundColor3=rc end

            if not esp then return end
            for _,p in pairs(game.Players:GetPlayers()) do
                if p==plr then continue end
                local c = p.Character
                if not c then continue end
                local h = c:FindFirstChildOfClass("Humanoid")
                if not h or h.Health<=0 then
                    local e=c:FindFirstChild("BM_ESP") if e then e:Destroy() end
                    local d=c:FindFirstChild("BM_DOT") if d then d:Destroy() end
                    continue
                end
                local e = c:FindFirstChild("BM_ESP")
                if not e then
                    e = Instance.new("Highlight")
                    e.Name="BM_ESP" e.FillTransparency=1 e.OutlineTransparency=0
                    e.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
                    e.Parent=c
                end
                e.OutlineColor = rc
                local fr=false pcall(function() fr=plr:IsFriendsWith(p.UserId) end)
                local hd = c:FindFirstChild("Head")
                local dot = c:FindFirstChild("BM_DOT")
                if fr and hd then
                    if not dot then
                        dot = Instance.new("BillboardGui")
                        dot.Name="BM_DOT" dot.AlwaysOnTop=true
                        dot.Size=UDim2.new(0,16,0,16) dot.StudsOffset=Vector3.new(0,3,0)
                        dot.Adornee=hd dot.Parent=c
                        local ci=Instance.new("Frame",dot)
                        ci.Size=UDim2.new(1,0,1,0)
                        Instance.new("UICorner",ci).CornerRadius=UDim.new(1,0)
                    end
                    dot.Frame.BackgroundColor3 = rc
                elseif dot then dot:Destroy() end
            end
        end)
    end)
end

-- RUN
local ok,err = pcall(buildMain)
if ok then
    print("✅ BLUE MODE LOADED SUCCESSFULLY")
    print("✅ CONSOLE: RUNS ANY LUA / LOADSTRING")
    print("✅ VOLUME: 1-1000 | FULL RAINBOW")
else
    warn("❌ LOAD FAILED:",err)
    getgenv().BlueMode=false
end
