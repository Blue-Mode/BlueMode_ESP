-- BLUE MODE ESP v2.8 | 1-1000 VOL | LUA CONSOLE + LOADSTRING
-- UNLOCK: Blue_Mode192823 | 100% MOBILE COMPATIBLE
if getgenv().BlueMode then return end
getgenv().BlueMode = true

local plr = game.Players.LocalPlayer
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local ss = game:GetService("SoundService")
local cg = game:GetService("CoreGui")

local function wf(k,v) pcall(function() if writefile then writefile(k..".txt",tostring(v)) end end) end
local function rf(k,d) local r=nil pcall(function() if readfile then r=readfile(k..".txt") end end) return tonumber(r) or d end
local function sc(t) pcall(function() if setclipboard then setclipboard(t) end end) end

local MAX_Z = 2147483647
local LIMIT = 43200
local CD = 43200
local YT = "https://youtube.com/@blue_mode?si=aCGyj0FnwCMtTP1M"
local F = {U="BM_U",C="BM_C",V="BM_V"}

local tm = os.time()
local ce = rf(F.C,0)
if tm < ce then warn("[BLUE] COOLDOWN "..math.floor((ce-tm)/60).."m") getgenv().BlueMode=false return end

local used = rf(F.U,0)
local lt = os.time()
-- ✅ VOLUME = 1 TO 1000 (NEVER 0)
local vol = math.clamp(rf(F.V,500),1,1000)

local snd = nil
local vL = {}
local vB = {}
local sk = {}
local w = {M=nil,S=nil,C=nil}
local mOpen = false
local esp = false
local lck = false
local hue = 0
local min = false

local function add(o,t)
    if not o then return end
    local s = Instance.new("UIStroke")
    s.Thickness = t or 3
    s.LineJoinMode = Enum.LineJoinMode.Round
    s.Parent = o
    table.insert(sk,s)
    return s
end

local function modal(s) if w.M then w.M.Modal = s end end
local function refModal() modal(mOpen) end

-- ✅ VOLUME 1-1000 SYSTEM
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

local function play(id)
    pcall(function() if snd then snd:Destroy() end end)
    snd = Instance.new("Sound")
    snd.SoundId = "rbxassetid://"..tostring(id):gsub("%D","")
    snd.Volume = vol/1000
    snd.Looped = true
    snd.Parent = ss
    pcall(function() snd:Play() end)
end

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
-- 🎵 MUSIC WINDOW
-- ==============================================
local function oMusic()
    if w.S then w.S:Destroy() w.S=nil end
    if w.C then w.C:Destroy() w.C=nil end
    mOpen=true refModal()

    local g = Instance.new("ScreenGui")
    g.Name="BM_S" g.ZIndexBehavior=2 g.DisplayOrder=MAX_Z g.IgnoreGuiInset=true g.Parent=cg
    w.S=g

    local f = Instance.new("Frame")
    f.Size=UDim2.new(0,320,0,250) f.Position=UDim2.new(0.5,-160,0.5,-125)
    f.BackgroundColor3=Color3.new(0.08,0.08,0.08) f.Active=true f.Parent=g
    Instance.new("UICorner",f).CornerRadius=UDim.new(0,12) add(f,4)

    local x = Instance.new("TextButton")
    x.Size=UDim2.new(0,30,0,30) x.Position=UDim2.new(1,-35,0,5)
    x.BackgroundColor3=Color3.new(0.66,0.12,0.12) x.Text="✕"
    x.TextColor3=Color3.new(1,1,1) x.Font=Enum.Font.GothamBold x.TextSize=24
    x.Parent=f add(x,2)
    x.MouseButton1Click:Connect(function() g:Destroy() w.S=nil mOpen=(w.C~=nil) refModal() end)

    local t = Instance.new("TextLabel")
    t.Size=UDim2.new(1,0,0,40) t.Position=UDim2.new(0,0,0,8)
    t.BackgroundTransparency=1 t.Text="🎵 BOOMBOX · 1-1000 VOL"
    t.Font=Enum.Font.GothamBold t.TextColor3=Color3.new(1,1,1) t.TextScaled=true t.Parent=f

    local id = Instance.new("TextBox")
    id.Size=UDim2.new(1,-40,0,45) id.Position=UDim2.new(0,20,0,55)
    id.BackgroundColor3=Color3.new(0.14,0.14,0.14)
    id.PlaceholderText="PASTE SOUND ID"
    id.TextColor3=Color3.new(1,1,1) id.Font=Enum.Font.Gotham id.TextScaled=true
    id.Parent=f Instance.new("UICorner",id).CornerRadius=UDim.new(0,8) add(id,2)

    local vt = Instance.new("TextLabel")
    vt.Size=UDim2.new(0,120,0,30) vt.Position=UDim2.new(0,20,0,110)
    vt.BackgroundTransparency=1 vt.Text="🔊 VOLUME:"
    vt.Font=Enum.Font.GothamBold vt.TextColor3=Color3.new(1,1,1) vt.TextScaled=true vt.TextXAlignment=0 vt.Parent=f

    vL.S = Instance.new("TextLabel")
    vL.S.Size=UDim2.new(0,80,0,30) vL.S.Position=UDim2.new(1,-100,0,110)
    vL.S.BackgroundTransparency=1 vL.S.Text=tostring(math.floor(vol)).."/1000"
    vL.S.Font=Enum.Font.GothamBold vL.S.TextColor3=Color3.new(1,1,1) vL.S.TextScaled=true vL.S.TextXAlignment=2 vL.S.Parent=f

    local sb = Instance.new("Frame")
    sb.Size=UDim2.new(1,-40,0,24) sb.Position=UDim2.new(0,20,0,145)
    sb.BackgroundColor3=Color3.new(0.2,0.2,0.2) sb.Active=true
    sb.Parent=f Instance.new("UICorner",sb).CornerRadius=UDim.new(0,12) add(sb,2)

    vB.S = Instance.new("Frame")
    vB.S.Size=UDim2.new(vol/1000,0,1,0)
    vB.S.BackgroundColor3=Color3.new(0.4,0.4,0.4)
    vB.S.Parent=sb Instance.new("UICorner",vB.S).CornerRadius=UDim.new(0,12)

    local sl=false
    local function upd(i)
        local p = math.clamp((i.Position.X-sb.AbsolutePosition.X)/sb.AbsoluteSize.X,0,1)
        -- ✅ 1 TO 1000
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
        if sl and (i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch) then
            sl=false wait(0.05) refModal()
        end
    end)

    local pb = Instance.new("TextButton")
    pb.Size=UDim2.new(0,130,0,40) pb.Position=UDim2.new(0,20,0,190)
    pb.BackgroundColor3=Color3.new(0.1,0.55,1) pb.Text="▶ PLAY"
    pb.TextColor3=Color3.new(1,1,1) pb.Font=Enum.Font.GothamBold pb.TextScaled=true
    pb.Parent=f Instance.new("UICorner",pb).CornerRadius=UDim.new(0,8) add(pb,2)
    pb.MouseButton1Click:Connect(function() if id.Text~="" then play(id.Text) end end)

    local sB = Instance.new("TextButton")
    sB.Size=UDim2.new(0,130,0,40) sB.Position=UDim2.new(0,170,0,190)
    sB.BackgroundColor3=Color3.new(0.78,0.12,0.12) sB.Text="⏹ STOP"
    sB.TextColor3=Color3.new(1,1,1) sB.Font=Enum.Font.GothamBold sB.TextScaled=true
    sB.Parent=f Instance.new("UICorner",sB).CornerRadius=UDim.new(0,8) add(sB,2)
    sB.MouseButton1Click:Connect(function() pcall(function() if snd then snd:Destroy() end end) end)
end

-- ==============================================
-- 💻 CONSOLE: LUA + LOADSTRING (ANY SCRIPT)
-- ==============================================
local function tCon()
    if w.C then w.C:Destroy() w.C=nil mOpen=(w.S~=nil) refModal() return end
    if w.S then w.S:Destroy() w.S=nil end
    mOpen=true refModal()

    local g = Instance.new("ScreenGui")
    g.Name="BM_C" g.ZIndexBehavior=2 g.DisplayOrder=MAX_Z g.IgnoreGuiInset=true g.Parent=cg
    w.C=g

    local f = Instance.new("Frame")
    f.Size=UDim2.new(0,380,0,350) f.Position=UDim2.new(0.5,-190,0.5,-175)
    f.BackgroundColor3=Color3.new(0.08,0.08,0.08) f.Active=true f.Parent=g
    Instance.new("UICorner",f).CornerRadius=UDim.new(0,12) add(f,4)

    local x = Instance.new("TextButton")
    x.Size=UDim2.new(0,30,0,30) x.Position=UDim2.new(1,-35,0,5)
    x.BackgroundColor3=Color3.new(0.66,0.12,0.12) x.Text="✕"
    x.TextColor3=Color3.new(1,1,1) x.Font=Enum.Font.GothamBold x.TextSize=24
    x.Parent=f add(x,2)
    x.MouseButton1Click:Connect(function() g:Destroy() w.C=nil mOpen=(w.S~=nil) refModal() end)

    local t = Instance.new("TextLabel")
    t.Size=UDim2.new(1,0,0,35) t.Position=UDim2.new(0,0,0,8)
    t.BackgroundTransparency=1 t.Text="💻 LUA CONSOLE · LOADSTRING"
    t.Font=Enum.Font.GothamBold t.TextColor3=Color3.new(1,1,1) t.TextScaled=true t.Parent=f

    -- ✅ CODE BOX (PASTE ANY LUA SCRIPT / LOADSTRING HERE)
    local cb = Instance.new("TextBox")
    cb.Size=UDim2.new(1,-30,0,180) cb.Position=UDim2.new(0,15,0,50)
    cb.BackgroundColor3=Color3.new(0.12,0.12,0.12)
    cb.PlaceholderText = [[PASTE ANY LUA SCRIPT OR LOADSTRING HERE
Examples:
  loadstring(game:HttpGet("URL"))()
  print("Hello World")
  game.Players.LocalPlayer.Character:Destroy()]]
    cb.TextColor3=Color3.new(1,1,1) cb.Font=Enum.Font.Code
    cb.TextSize=12 cb.TextWrapped=true cb.MultiLine=true cb.ClearTextOnFocus=false
    cb.Parent=f Instance.new("UICorner",cb).CornerRadius=UDim.new(0,8) add(cb,2)

    -- LOG
    local lg = Instance.new("TextBox")
    lg.Size=UDim2.new(1,-30,0,50) lg.Position=UDim2.new(0,15,0,240)
    lg.BackgroundColor3=Color3.new(0.1,0.1,0.1)
    lg.Text="[READY] Paste Lua script and click EXECUTE"
    lg.TextColor3=Color3.new(0.3,1,0.4) lg.Font=Enum.Font.Code lg.TextSize=11
    lg.ReadOnly=true lg.TextWrapped=true lg.MultiLine=true
    lg.Parent=f Instance.new("UICorner",lg).CornerRadius=UDim.new(0,8) add(lg,2)

    -- ✅ EXECUTE BUTTON (RUNS ANY LUA / LOADSTRING)
    local ex = Instance.new("TextButton")
    ex.Size=UDim2.new(0,100,0,32) ex.Position=UDim2.new(0,15,0,300)
    ex.BackgroundColor3=Color3.new(0.08,0.6,0.15) ex.Text="▶ EXECUTE"
    ex.TextColor3=Color3.new(1,1,1) ex.Font=Enum.Font.GothamBold ex.TextScaled=true
    ex.Parent=f Instance.new("UICorner",ex).CornerRadius=UDim.new(0,6) add(ex,2)
    ex.MouseButton1Click:Connect(function()
        local code = cb.Text
        if code:gsub("%s","") == "" then
            lg.TextColor3=Color3.new(1,0.3,0.3)
            lg.Text = "[ERROR] No code entered"
            return
        end
        -- ✅ RUN ANY LUA SCRIPT OR LOADSTRING
        local fn, err = loadstring(code)
        if not fn then
            lg.TextColor3=Color3.new(1,0.3,0.3)
            lg.Text = "[SYNTAX ERROR] "..tostring(err)
            return
        end
        local ok, runErr = pcall(fn)
        if ok then
            lg.TextColor3=Color3.new(0.3,1,0.4)
            lg.Text = "[SUCCESS] Script executed!"
        else
            lg.TextColor3=Color3.new(1,0.3,0.3)
            lg.Text = "[RUNTIME ERROR] "..tostring(runErr)
        end
    end)

    -- CLEAR
    local cl = Instance.new("TextButton")
    cl.Size=UDim2.new(0,100,0,32) cl.Position=UDim2.new(0,125,0,300)
    cl.BackgroundColor3=Color3.new(0.6,0.35,0.08) cl.Text="🗑️ CLEAR"
    cl.TextColor3=Color3.new(1,1,1) cl.Font=Enum.Font.GothamBold cl.TextScaled=true
    cl.Parent=f Instance.new("UICorner",cl).CornerRadius=UDim.new(0,6) add(cl,2)
    cl.MouseButton1Click:Connect(function() cb.Text="" lg.Text="[CLEARED]" lg.TextColor3=Color3.new(1,1,1) end)

    -- CLOSE
    local cx = Instance.new("TextButton")
    cx.Size=UDim2.new(0,100,0,32) cx.Position=UDim2.new(0,235,0,300)
    cx.BackgroundColor3=Color3.new(0.55,0.08,0.08) cx.Text="✖ CLOSE"
    cx.TextColor3=Color3.new(1,1,1) cx.Font=Enum.Font.GothamBold cx.TextScaled=true
    cx.Parent=f Instance.new("UICorner",cx).CornerRadius=UDim.new(0,6) add(cx,2)
    cx.MouseButton1Click:Connect(function() g:Destroy() w.C=nil mOpen=(w.S~=nil) refModal() end)
end

-- ==============================================
-- 🎮 MAIN UI
-- ==============================================
local function build()
    local g = Instance.new("ScreenGui")
    g.Name="BM_MAIN" g.ZIndexBehavior=2 g.DisplayOrder=MAX_Z g.IgnoreGuiInset=true g.Modal=false g.Parent=cg
    w.M=g

    -- Always on top refresh
    coroutine.wrap(function()
        while g and g.Parent do
            pcall(function()
                g.DisplayOrder=MAX_Z
                if w.S then w.S.DisplayOrder=MAX_Z end
                if w.C then w.C.DisplayOrder=MAX_Z end
            end)
            wait(1)
        end
    end)()

    uis.MenuOpened:Connect(function()
        g.Visible=false if w.S then w.S.Visible=false end if w.C then w.C.Visible=false end
    end)
    uis.MenuClosed:Connect(function()
        g.Visible=true if w.S then w.S.Visible=true end if w.C then w.C.Visible=true end
    end)

    local NORM = UDim2.new(0,680,0,105)
    local SMOL = UDim2.new(0,50,0,50)
    local mf = Instance.new("Frame")
    mf.Size=NORM mf.Position=UDim2.new(0,20,0.5,-52)
    mf.BackgroundColor3=Color3.new(0.1,0.1,0.1) mf.Active=true mf.ZIndex=10
    mf.Parent=g Instance.new("UICorner",mf).CornerRadius=UDim.new(0,8) add(mf,5)

    -- DRAG BAR
    local db = Instance.new("TextButton")
    db.Size=UDim2.new(1,-25,0,22) db.BackgroundColor3=Color3.new(0.24,0.55,0.86)
    db.Active=true db.Text="BLUE MODE ESP | DRAG ME"
    db.TextColor3=Color3.new(1,1,1) db.Font=Enum.Font.GothamBold db.TextScaled=true db.TextXAlignment=0
    db.Parent=mf add(db,2)

    -- TIMER
    local tm = Instance.new("TextLabel")
    tm.Size=UDim2.new(0,100,1,0) tm.Position=UDim2.new(1,-105,0,0)
    tm.BackgroundTransparency=1 tm.Text="12:00:00"
    tm.Font=Enum.Font.GothamBold tm.TextScaled=true tm.TextXAlignment=2 tm.Parent=db

    -- MIN BTN
    local mb = Instance.new("TextButton")
    mb.Size=UDim2.new(0,22,1,0) mb.Position=UDim2.new(1,-22,0,0)
    mb.BackgroundColor3=Color3.new(0.63,0.16,0.16) mb.Text="➖"
    mb.TextColor3=Color3.new(1,1,1) mb.Font=Enum.Font.GothamBold mb.TextScaled=true
    mb.Parent=mf add(mb,2)

    -- ALL 6 BUTTONS
    local function btn(sz,pos,bg,txt)
        local b = Instance.new("TextButton")
        b.Size=sz b.Position=pos b.BackgroundColor3=bg
        b.Text=txt b.TextColor3=Color3.new(1,1,1)
        b.Font=Enum.Font.GothamBold b.TextScaled=true
        b.Parent=mf Instance.new("UICorner",b).CornerRadius=UDim.new(0,6) add(b,2)
        return b
    end

    local bEsp = btn(UDim2.new(0,85,0,30),UDim2.new(0,10,0,30),Color3.new(0.16,0.16,0.16),"ESP: OFF")
    local bYt  = btn(UDim2.new(0,95,0,30),UDim2.new(0,105,0,30),Color3.new(0.78,0.12,0.12),"📺 YT")
    local bMu  = btn(UDim2.new(0,90,0,30),UDim2.new(0,210,0,30),Color3.new(0.16,0.31,0.63),"🎵 MUSIC")
    local bCn  = btn(UDim2.new(0,95,0,30),UDim2.new(0,310,0,30),Color3.new(0.12,0.39,0.35),"💻 CONSOLE")
    local bLk  = btn(UDim2.new(0,90,0,30),UDim2.new(0,415,0,30),Color3.new(0.2,0.2,0.2),"🔓 UNLOCK")
    local bEx  = btn(UDim2.new(0,90,0,30),UDim2.new(0,515,0,30),Color3.new(0.55,0.08,0.08),"🗑️ EXIT")

    -- MAIN VOLUME SLIDER (1-1000)
    local vt = Instance.new("TextLabel")
    vt.Size=UDim2.new(0,40,0,25) vt.Position=UDim2.new(0,10,0,65)
    vt.BackgroundTransparency=1 vt.Text="🔊"
    vt.Font=Enum.Font.Gotham vt.TextColor3=Color3.new(1,1,1) vt.TextScaled=true vt.Parent=mf

    vL.M = Instance.new("TextLabel")
    vL.M.Size=UDim2.new(0,60,0,25) vL.M.Position=UDim2.new(0,45,0,65)
    vL.M.BackgroundTransparency=1 vL.M.Text=tostring(math.floor(vol)).."/1000"
    vL.M.Font=Enum.Font.GothamBold vL.M.TextColor3=Color3.new(1,1,1) vL.M.TextScaled=true vL.M.TextXAlignment=0 vL.M.Parent=mf

    local vs = Instance.new("Frame")
    vs.Size=UDim2.new(0,160,0,18) vs.Position=UDim2.new(0,110,0,68)
    vs.BackgroundColor3=Color3.new(0.2,0.2,0.2) vs.Active=true vs.ZIndex=15
    vs.Parent=mf Instance.new("UICorner",vs).CornerRadius=UDim.new(0,9) add(vs,2)

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
        if msl and (i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch) then
            msl=false wait(0.05) refModal()
        end
    end)

    -- DRAG SYSTEM
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
        if dr and (i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch) then
            dr=false wait(0.05) refModal()
        end
    end)

    -- BUTTON ACTIONS
    bEsp.MouseButton1Click:Connect(function()
        esp=not esp
        bEsp.Text=esp and "ESP: ON" or "ESP: OFF"
        bEsp.BackgroundColor3=esp and Color3.new(0.1,0.47,0.1) or Color3.new(0.16,0.16,0.16)
        if not esp then clrEsp() end
    end)

    bYt.MouseButton1Click:Connect(function()
        sc(YT) bYt.Text="✅ COPIED" wait(1.5) bYt.Text="📺 YT"
    end)

    bMu.MouseButton1Click:Connect(oMusic)
    bCn.MouseButton1Click:Connect(tCon)

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
            db.Text="BLUE MODE ESP | DRAG ME" mb.Text="➖"
        end
    end)

    bEx.MouseButton1Click:Connect(function()
        clrEsp()
        pcall(function() if snd then snd:Destroy() end end)
        if w.S then w.S:Destroy() end if w.C then w.C:Destroy() end
        g:Destroy() getgenv().BlueMode=false
    end)

    -- MAIN LOOP
    rs.Heartbeat:Connect(function(dt)
        pcall(function()
            if not g or not g.Parent then return end

            -- TIMER
            local n = os.time()
            used = used + math.max(0,n-lt); lt = n
            wf(F.U,used)
            local rem = math.max(0,LIMIT-used)
            tm.Text = string.format("%02d:%02d:%02d",math.floor(rem/3600),math.floor((rem%3600)/60),rem%60)
            if rem<=0 then
                wf(F.C,os.time()+CD)
                bEx:Fire() return
            end

            -- ✅ PERMANENT RAINBOW (ALL UI)
            hue = (hue + (dt*0.5)) % 1
            local rc = Color3.fromHSV(hue,1,1)
            for _,s in pairs(sk) do s.Color = rc end
            if vB.M then vB.M.BackgroundColor3 = rc end
            if vB.S then vB.S.BackgroundColor3 = rc end
            tm.TextColor3 = rc

            -- ESP + FRIEND DOT
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

                -- FRIEND DOT
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
local ok,err = pcall(build)
if ok then
    print("✅ BLUE MODE v2.8 LOADED!")
    print("✅ 1-1000 VOL | LUA CONSOLE + LOADSTRING | RAINBOW | ESP")
else
    warn("❌ FAILED:",err)
    getgenv().BlueMode=false
end
