--[[ luxxs v8.2 | DrHub | MM2 | Aimbot + AutoWin + Skins + Preview ]] local __LX_ok,__LX_err=xpcall(function()
local TweenService=game:GetService("TweenService")
local UIS=game:GetService("UserInputService")
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local Lighting=game:GetService("Lighting")
local HttpService=game:GetService("HttpService")
local VU=game:GetService("VirtualUser")
local LP=Players.LocalPlayer
local __errs={}
local function __safe(name,f)
    local ok,e=xpcall(f,function(m) return tostring(m).."\n"..tostring(debug.traceback()) end)
    if not ok then __errs[#__errs+1]=name..": "..tostring(e); warn("[luxxs] module '"..name.."' failed: "..tostring(e)) end
end

local FOLDER="luxxs"
local TELEGRAM_LINK="https://t.me/NurHuboffical"
local hasFS=type(writefile)=="function" and type(readfile)=="function" and type(isfile)=="function"
local function ensureFolder() if type(makefolder)=="function" and type(isfolder)=="function" and not isfolder(FOLDER) then pcall(makefolder,FOLDER) end end

-- THEME
local ACCENTS={Lime=Color3.fromRGB(196,255,61),Coral=Color3.fromRGB(255,104,84),Ice=Color3.fromRGB(110,214,255),Violet=Color3.fromRGB(158,110,255),Gold=Color3.fromRGB(255,196,70),Rose=Color3.fromRGB(255,96,160)}
local ACCENT_NAMES={"Lime","Coral","Ice","Violet","Gold","Rose"}
local ACC_NAME="Lime"
if hasFS then pcall(function() local p=FOLDER.."/accent.txt"; if isfile(p) then local n=readfile(p); if ACCENTS[n] then ACC_NAME=n end end end) end
local ACC=ACCENTS[ACC_NAME]

local C={bg=Color3.fromRGB(11,11,14),panel=Color3.fromRGB(16,16,20),row=Color3.fromRGB(24,24,30),line=Color3.fromRGB(40,40,48),off=Color3.fromRGB(58,58,68),text=Color3.fromRGB(232,232,226),dim=Color3.fromRGB(122,122,136)}
local WHITE=Color3.fromRGB(255,255,255)
local AIM_RED=Color3.fromRGB(255,64,64)
local BODY_GRAY=Color3.fromRGB(196,196,206)
local F_HEAD,F_BODY,F_MONO,F_SEC=Enum.Font.Michroma,Enum.Font.SourceSansSemibold,Enum.Font.RobotoMono,Enum.Font.Oswald

local themed={}
local function T(o,p,fn) themed[#themed+1]={o,p,fn}; o[p]=fn and fn(ACC) or ACC end
local function setAccent(c) ACC=c; for _,t in ipairs(themed) do pcall(function() t[1][t[2]]=t[3] and t[3](ACC) or ACC end) end end

local PALETTE={Lime=ACCENTS.Lime,Coral=ACCENTS.Coral,Ice=ACCENTS.Ice,Violet=ACCENTS.Violet,Gold=ACCENTS.Gold,Red=Color3.fromRGB(255,60,60),Green=Color3.fromRGB(70,230,110),Blue=Color3.fromRGB(70,110,255),Pink=Color3.fromRGB(255,110,200),White=Color3.fromRGB(255,255,255)}
local COLOR_NAMES={"Rainbow","Lime","Coral","Ice","Violet","Gold","Red","Green","Blue","Pink","White"}
local WING_COLORS={"White","Gold","Rainbow","Ice","Violet","Pink","Coral"}
local ROLE_COLORS={Murderer=Color3.fromRGB(255,60,60),Sheriff=Color3.fromRGB(70,130,255),Innocent=Color3.fromRGB(70,230,110)}
local ROLE_NAMES={"Murderer","Sheriff","Innocent"}
local HAT_COLORS={"Custom","Rainbow","Lime","Coral","Ice","Violet","Gold","Red","Green","Blue","Pink","White"}
local QB_POSITIONS={"Left","Right","Bottom","Top","Left-Top","Left-Bottom","Right-Top","Right-Bottom"}
local SCREEN_RATIOS={"Default","16:9","16:10","4:3","21:9","1:1"}

_G.LUXXS_HAT_H=280; _G.LUXXS_HAT_S=0.7; _G.LUXXS_HAT_V=1
local TRAILC={H=200,S=0.9,V=1}

local function getColor(n,t,o)
    if n=="Rainbow" then return Color3.fromHSV((((t or 0)*0.2)+(o or 0))%1,0.85,1) end
    if n=="Custom" then return Color3.fromHSV(((_G.LUXXS_HAT_H%360)/360),math.clamp(_G.LUXXS_HAT_S,0,1),math.clamp(_G.LUXXS_HAT_V,0,1)) end
    return PALETTE[n] or ACC
end
local function tcol(n,t,o)
    if n=="Custom" then return Color3.fromHSV((TRAILC.H%360)/360,math.clamp(TRAILC.S,0,1),math.clamp(TRAILC.V,0,1)) end
    return getColor(n,t,o)
end

local connections={} local function track(c) connections[#connections+1]=c; return c end
local function tween(o,ti,p,s,d) local tw=TweenService:Create(o,TweenInfo.new(ti,s or Enum.EasingStyle.Quint,d or Enum.EasingDirection.Out),p); tw:Play(); return tw end
local function corner(o,r) local c=Instance.new("UICorner"); c.CornerRadius=UDim.new(0,r); c.Parent=o; return c end
local function stroke(o,col,th,tr) local s=Instance.new("UIStroke"); s.Color=col; s.Thickness=th or 1; s.Transparency=tr or 0; s.ApplyStrokeMode=Enum.ApplyStrokeMode.Border; s.Parent=o; return s end
local function gradient(f,rot,seq,tseq)
    local g=Instance.new("UIGradient"); g.Rotation=rot or 0
    if seq then g.Color=seq end
    if tseq then g.Transparency=tseq end
    g.Parent=f; return g
end

local GradRefresh={}
local Flags,Setters,Defaults={},{},{} local function register(k,d,s) Flags[k]=d; Defaults[k]=d; Setters[k]=s end

local gui=Instance.new("ScreenGui")
gui.Name="luxxs"; gui.ResetOnSpawn=false; gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling; gui.IgnoreGuiInset=true
local okP,parent=pcall(function() return (gethui and gethui()) or game:GetService("CoreGui") end)
if not okP or not parent then parent=LP:WaitForChild("PlayerGui") end
if parent:FindFirstChild("luxxs") then parent.luxxs:Destroy() end
if parent:FindFirstChild("luxxsKey") then parent.luxxsKey:Destroy() end
if parent:FindFirstChild("luxxsFPS") then parent.luxxsFPS:Destroy() end
gui.Parent=parent

for _,e in ipairs(Lighting:GetChildren()) do
    if e:IsA("BlurEffect") or e:IsA("DepthOfFieldEffect") then
        pcall(function() e.Enabled=false end)
    end
    if e.Name:sub(1,6)=="luxxs_" then
        pcall(function() e:Destroy() end)
    end
end

print("[luxxs] v5.4 loaded")

-- ============ ЗАГРУЗОЧНЫЙ ЭКРАН ============
do
    local sg=Instance.new("ScreenGui"); sg.Name="luxxsKey"; sg.ResetOnSpawn=false; sg.IgnoreGuiInset=true; sg.DisplayOrder=999; sg.Parent=parent
    local root=Instance.new("CanvasGroup"); root.Size=UDim2.new(1,0,1,0); root.BackgroundTransparency=1; root.BorderSizePixel=0; root.Parent=sg
    do
        local bgf=Instance.new("Frame"); bgf.Size=UDim2.new(1,0,1,0); bgf.BackgroundColor3=WHITE; bgf.BorderSizePixel=0; bgf.ZIndex=0; bgf.Parent=root
        gradient(bgf,90,ColorSequence.new(Color3.fromRGB(22,22,28),Color3.fromRGB(8,8,10)))
    end
    local function hair(y) local f=Instance.new("Frame"); f.Position=UDim2.new(0,0,y,0); f.Size=UDim2.new(1,0,0,1); f.BorderSizePixel=0; f.BackgroundTransparency=0.85; f.Parent=root; T(f,"BackgroundColor3") end
    hair(0.1) hair(0.9)
    local function ctext(txt,ax,px)
        local l=Instance.new("TextLabel"); l.BackgroundTransparency=1; l.AnchorPoint=Vector2.new(ax,0); l.Position=UDim2.new(px,ax==0 and 18 or -18,0.1,8); l.Size=UDim2.new(0,220,0,16); l.Font=F_MONO; l.TextSize=11; l.TextColor3=C.dim; l.TextXAlignment=ax==0 and Enum.TextXAlignment.Left or Enum.TextXAlignment.Right; l.Text=txt; l.Parent=root
    end
    ctext("LUXXS // LOADING",0,0) ctext("DRHUB",1,1)

    local word="LUXXS"; local LW=62; local total=LW*#word
    local holder=Instance.new("Frame"); holder.AnchorPoint=Vector2.new(0.5,0.5); holder.Position=UDim2.new(0.5,0,0.36,0); holder.Size=UDim2.new(0,total,0,84); holder.BackgroundTransparency=1; holder.ClipsDescendants=true; holder.Parent=root
    local letters={}
    for i=1,#word do
        local l=Instance.new("TextLabel"); l.BackgroundTransparency=1; l.Size=UDim2.new(0,LW,0,84); l.Position=UDim2.new(0,(i-1)*LW,0,98); l.Font=F_HEAD; l.TextSize=52; l.Text=word:sub(i,i); l.TextColor3=C.text; l.Parent=holder
        letters[i]=l
    end
    local ul=Instance.new("Frame"); ul.AnchorPoint=Vector2.new(0.5,0); ul.Position=UDim2.new(0.5,0,0.36,52); ul.Size=UDim2.new(0,0,0,2); ul.BorderSizePixel=0; ul.Parent=root; T(ul,"BackgroundColor3")

    local statusLbl=Instance.new("TextLabel"); statusLbl.BackgroundTransparency=1; statusLbl.AnchorPoint=Vector2.new(0.5,0); statusLbl.Position=UDim2.new(0.5,0,0.58,0); statusLbl.Size=UDim2.new(0,400,0,18); statusLbl.Font=F_MONO; statusLbl.TextSize=13; statusLbl.TextColor3=C.dim; statusLbl.Text="INITIALIZING"; statusLbl.TextTransparency=1; statusLbl.Parent=root

    local barBg=Instance.new("Frame"); barBg.AnchorPoint=Vector2.new(0.5,0); barBg.Position=UDim2.new(0.5,0,0.64,0); barBg.Size=UDim2.new(0,320,0,3); barBg.BackgroundColor3=C.off; barBg.BorderSizePixel=0; barBg.Parent=root; corner(barBg,2)
    local barFill=Instance.new("Frame"); barFill.Size=UDim2.new(0,0,1,0); barFill.BorderSizePixel=0; barFill.Parent=barBg; corner(barFill,2); T(barFill,"BackgroundColor3")

    local subLbl=Instance.new("TextLabel"); subLbl.BackgroundTransparency=1; subLbl.AnchorPoint=Vector2.new(0.5,0); subLbl.Position=UDim2.new(0.5,0,0.66,6); subLbl.Size=UDim2.new(0,400,0,16); subLbl.Font=F_MONO; subLbl.TextSize=11; subLbl.TextColor3=C.dim; subLbl.Text=""; subLbl.TextTransparency=1; subLbl.Parent=root

    task.spawn(function()
        task.wait(0.2)
        for i,l in ipairs(letters) do tween(l,0.7,{Position=UDim2.new(0,(i-1)*LW,0,0)}); task.wait(0.08) end
        task.wait(0.25); tween(ul,0.6,{Size=UDim2.new(0,total,0,2)})
        task.wait(0.3); tween(statusLbl,0.35,{TextTransparency=0}); tween(subLbl,0.35,{TextTransparency=0})
        local steps={
            {t=0.15,txt="Checking integrity...",sub="verifying files"},
            {t=0.4,txt="Loading modules...",sub="drhub core"},
            {t=0.65,txt="Connecting...",sub="t.me/NurHuboffical"},
            {t=0.9,txt="Almost ready...",sub="preparing UI"},
            {t=1.0,txt="Access granted",sub="welcome, "..LP.Name}
        }
        for _,s in ipairs(steps) do
            statusLbl.Text=s.txt
            subLbl.Text=s.sub
            tween(barFill,0.35,{Size=UDim2.new(s.t,0,1,0)})
            task.wait(0.35)
        end
        T(statusLbl,"TextColor3")
        task.wait(0.4)
        tween(root,0.5,{GroupTransparency=1})
        task.wait(0.55)
        sg:Destroy()
    end)
end

task.wait(3.5)
print("[luxxs] loading done, building UI")

local function notify(text)
    local f=Instance.new("Frame"); f.AnchorPoint=Vector2.new(1,1); f.Size=UDim2.new(0,250,0,34); f.Position=UDim2.new(1,280,1,-20); f.BackgroundColor3=C.panel; f.BorderSizePixel=0; f.ZIndex=20; f.Parent=gui; stroke(f,C.line,1,0)
    local bar=Instance.new("Frame"); bar.Size=UDim2.new(0,3,1,0); bar.BorderSizePixel=0; bar.BackgroundColor3=ACC; bar.ZIndex=21; bar.Parent=f
    local l=Instance.new("TextLabel"); l.BackgroundTransparency=1; l.Size=UDim2.new(1,-20,1,0); l.Position=UDim2.new(0,14,0,0); l.Font=F_MONO; l.TextSize=12; l.TextColor3=C.text; l.TextXAlignment=Enum.TextXAlignment.Left; l.Text=text; l.ZIndex=21; l.Parent=f
    tween(f,0.4,{Position=UDim2.new(1,-20,1,-20)})
    task.delay(2.6,function() tween(f,0.3,{Position=UDim2.new(1,280,1,-20)},Enum.EasingStyle.Quint,Enum.EasingDirection.In); task.delay(0.35,function() f:Destroy() end) end)
end

local function makeDraggable(handle,target,onClick)
    local dragging,startPos,startInput,moved=false,nil,nil,false
    local conn1
    conn1=handle.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            dragging=true; moved=false; startInput=input.Position; startPos=target.Position
            local c2
            c2=input.Changed:Connect(function() if input.UserInputState==Enum.UserInputState.End then dragging=false; c2:Disconnect(); if not moved and onClick then onClick() end end end)
        end
    end)
    track(conn1)
    track(UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
            local delta=input.Position-startInput
            if delta.Magnitude>5 then moved=true end
            if moved then tween(target,0.08,{Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)},Enum.EasingStyle.Linear) end
        end
    end))
end

-- COSMETICS
local Cos={}
local function destroyCos(n) if Cos[n] then for _,o in ipairs(Cos[n].objs) do pcall(function() o:Destroy() end) end Cos[n]=nil end end
local function newPart(sz,p) local pt=Instance.new("Part"); pt.Size=sz; pt.CanCollide=false; pt.CanQuery=false; pt.CanTouch=false; pt.Massless=true; pt.Anchored=false; pt.Parent=p; return pt end

local function buildWings()
    destroyCos("wings")
    local char=LP.Character; local torso=char and (char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")); if not torso then return end
    local model=Instance.new("Model"); model.Name="luxxsWings"; local feathers={}
    for _,side in ipairs({-1,1}) do for i=1,6 do
        local len=4.2-i*0.35
        local p=newPart(Vector3.new(len,0.5,0.08),model); p.Material=Enum.Material.Neon
        local w=Instance.new("Weld"); w.Part0=torso; w.Part1=p; w.Parent=p
        feathers[#feathers+1]={part=p,weld=w,side=side,i=i,len=len}
    end end
    model.Parent=char; Cos.wings={objs={model},model=model,feathers=feathers}
end

local function buildHat()
    destroyCos("hat")
    local char=LP.Character; local head=char and char:FindFirstChild("Head"); if not head then return end
    local model=Instance.new("Model"); model.Name="luxxsHat"; local slices={}
    -- smooth single cone (no stacked layers, so no banding)
    local okCone=pcall(function()
        local cone=Instance.new("ConeHandleAdornment")
        cone.Name="luxxsCone"; cone.Adornee=head; cone.Radius=1.75; cone.Height=1.0
        cone.AlwaysOnTop=false; cone.ZIndex=1
        cone.CFrame=CFrame.new(0,0.42,0)*CFrame.Angles(math.pi/2,0,0)
        cone.Parent=model
        slices[1]=cone
    end)
    if not okCone then
        local N=30
        for i=1,N do
            local k=(i-1)/N; local r=2.4*(1-k)^1.05+0.05
            local p=newPart(Vector3.new(0.07,r*2,r*2),model); p.Shape=Enum.PartType.Cylinder; p.Material=Enum.Material.SmoothPlastic; p.CastShadow=false
            local w=Instance.new("Weld"); w.Part0=head; w.Part1=p; w.C0=CFrame.new(0,0.52+(i-1)*0.036,0)*CFrame.Angles(0,0,math.pi/2); w.Parent=p; slices[i]=p
        end
    end
    model.Parent=char; Cos.hat={objs={model},model=model,slices=slices}
end

local function buildTrail()
    destroyCos("trail")
    local char=LP.Character; local hrp=char and char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    local a0=Instance.new("Attachment"); a0.Name="luxxsA0"; a0.Parent=hrp
    local a1=Instance.new("Attachment"); a1.Name="luxxsA1"; a1.Parent=hrp
    local tr=Instance.new("Trail"); tr.Attachment0=a0; tr.Attachment1=a1; tr.LightEmission=1; tr.FaceCamera=true
    tr.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.1),NumberSequenceKeypoint.new(1,1)}); tr.Parent=hrp
    Cos.trail={objs={a0,a1,tr},a0=a0,a1=a1,trail=tr}
end

local function colorSeq(name,t)
    if name=="Custom" then return ColorSequence.new(tcol(name,t,0)) end
    if name=="Rainbow" then local kp={} for k=0,6 do kp[#kp+1]=ColorSequenceKeypoint.new(k/6,getColor(name,t,-k/6*0.8)) end return ColorSequence.new(kp) end
    return ColorSequence.new(getColor(name))
end

track(RunService.Heartbeat:Connect(function()
    local t=os.clock()
    local w=Cos.wings
    if w and w.model.Parent then
        local flap=math.sin(t*(Flags["Visuals/Wing Speed"] or 3))*0.2
        for _,f in ipairs(w.feathers) do
            local a=math.rad(10+f.i*12)+flap*(0.5+f.i*0.12)
            local theta=(f.side==1) and a or (math.pi-a)
            f.weld.C0=CFrame.new(f.side*0.5,0.45,0.6)*CFrame.Angles(0,f.side*-0.35,0)*CFrame.Angles(0,0,theta)*CFrame.new(f.len/2,0,0)
            f.part.Color=getColor(Flags["Visuals/Wing Color"],t,f.i*0.05)
        end
    end
    local h=Cos.hat
    if h and h.model.Parent then local htr=(Flags["Visuals/Hat Transparency"] or 35)/100; for i,sl in ipairs(h.slices) do local hc=getColor(Flags["Visuals/Hat Color"],t,i*0.02); if sl:IsA("HandleAdornment") then sl.Color3=hc else sl.Color=hc end; sl.Transparency=htr end end
    local tr=Cos.trail
    if tr and tr.trail.Parent then
        local width=(Flags["Visuals/Trail Width"] or 4)*0.4
        tr.a0.Position=Vector3.new(0,width/2,0); tr.a1.Position=Vector3.new(0,-width/2,0)
        tr.trail.Lifetime=math.max(0.1,(Flags["Visuals/Trail Length"] or 10)/10); tr.trail.Color=colorSeq(Flags["Visuals/Trail Color"],t)
    end
end))

do
    local orig=setmetatable({},{__mode="k"})
    local function apply(on)
        local c=LP.Character; local head=c and c:FindFirstChild("Head"); if not head then return end
        if on then
            if orig[head]==nil then orig[head]=head.Transparency end
            head.Transparency=1
            for _,d in ipairs(head:GetChildren()) do if d:IsA("Decal") or d:IsA("Texture") then d.Transparency=1 end end
        else
            head.Transparency=orig[head] or 0
            for _,d in ipairs(head:GetChildren()) do if d:IsA("Decal") or d:IsA("Texture") then d.Transparency=0 end end
        end
    end
    local was=false
    track(RunService.Heartbeat:Connect(function()
        if Flags["Visuals/Fake Headless"] then was=true; apply(true)
        elseif was then was=false; apply(false) end
    end))
    _G.LUXXS_HEADLESS_RESTORE=function() apply(false) end
end

local enableFlyMove
track(LP.CharacterAdded:Connect(function(c)
    c:WaitForChild("HumanoidRootPart",10); c:WaitForChild("Head",10); task.wait(0.3)
    if Flags["Visuals/Wings"] then buildWings() end
    if Flags["Visuals/Chinese Hat"] then buildHat() end
    if Flags["Visuals/Trail"] then buildTrail() end
    if Flags["Move/Fly"] and enableFlyMove then enableFlyMove() end
end))

-- SCREEN RATIO
local ScreenRes={Bars={}}
do
    local barsFolder=Instance.new("Frame"); barsFolder.Name="luxxsScreenBars"; barsFolder.Size=UDim2.new(1,0,1,0); barsFolder.BackgroundTransparency=1; barsFolder.ZIndex=0; barsFolder.Parent=gui
    local topBar=Instance.new("Frame"); topBar.Position=UDim2.new(0,0,0,0); topBar.Size=UDim2.new(1,0,0,0); topBar.BackgroundColor3=Color3.new(0,0,0); topBar.BorderSizePixel=0; topBar.ZIndex=0; topBar.Parent=barsFolder
    local botBar=Instance.new("Frame"); botBar.AnchorPoint=Vector2.new(0,1); botBar.Position=UDim2.new(0,0,1,0); botBar.Size=UDim2.new(1,0,0,0); botBar.BackgroundColor3=Color3.new(0,0,0); botBar.BorderSizePixel=0; botBar.ZIndex=0; botBar.Parent=barsFolder
    ScreenRes.Bars={top=topBar,bot=botBar,folder=barsFolder}
    local RATIOS={["16:9"]=16/9,["16:10"]=16/10,["4:3"]=4/3,["21:9"]=21/9,["1:1"]=1.0}
    function ScreenRes.apply(mode,animate)
        local cam=workspace.CurrentCamera; if not cam then return end
        local vp=cam.ViewportSize
        local ti=animate and 0.35 or 0.001
        if mode=="Default" then
            tween(ScreenRes.Bars.top,ti,{Size=UDim2.new(1,0,0,0)})
            tween(ScreenRes.Bars.bot,ti,{Size=UDim2.new(1,0,0,0)})
            return
        end
        local targetRatio=RATIOS[mode]
        if not targetRatio then return end
        local currentRatio=vp.X/vp.Y
        local barH=0
        if currentRatio>targetRatio then
            local targetH=vp.X/targetRatio
            barH=(vp.Y-targetH)/2
        end
        if barH<0 then barH=0 end
        tween(ScreenRes.Bars.top,ti,{Size=UDim2.new(1,0,0,barH)})
        tween(ScreenRes.Bars.bot,ti,{Size=UDim2.new(1,0,0,barH)})
    end
end

-- WINDOW
local W,H=972,460
local main=Instance.new("CanvasGroup")
main.AnchorPoint=Vector2.new(0.5,0.5); main.Position=UDim2.new(0.5,0,0.5,0); main.Size=UDim2.new(0,W,0,H)
main.BackgroundColor3=C.bg; main.BorderSizePixel=0; main.GroupTransparency=1; main.Visible=false; main.Parent=gui
corner(main,16); T(stroke(main,ACC,1.5,0.35),"Color"); main.BackgroundColor3=Color3.fromRGB(12,11,17)
do local bgF=Instance.new("Frame"); bgF.Size=UDim2.new(1,0,1,0); bgF.BackgroundColor3=WHITE; bgF.BorderSizePixel=0; bgF.ZIndex=0; bgF.Parent=main; gradient(bgF,125,ColorSequence.new(Color3.fromRGB(24,19,36),Color3.fromRGB(10,10,14))) end
local scale=Instance.new("UIScale"); scale.Scale=0.9; scale.Parent=main

local top=Instance.new("Frame"); top.Size=UDim2.new(1,0,0,44); top.BackgroundColor3=WHITE; top.BorderSizePixel=0; top.Parent=main; gradient(top,0,ColorSequence.new(Color3.fromRGB(34,26,48),Color3.fromRGB(15,15,21)))
do
local topLine=Instance.new("Frame"); topLine.Position=UDim2.new(0,0,1,-1); topLine.Size=UDim2.new(1,0,0,1); topLine.BackgroundColor3=C.line; topLine.BorderSizePixel=0; topLine.Parent=top
local mark=Instance.new("Frame"); mark.Position=UDim2.new(0,16,0,18); mark.Size=UDim2.new(0,8,0,8); mark.Rotation=45; mark.BorderSizePixel=0; mark.Parent=top; T(mark,"BackgroundColor3")
local title=Instance.new("TextLabel"); title.BackgroundTransparency=1; title.Position=UDim2.new(0,34,0,0); title.Size=UDim2.new(0,90,1,0); title.Font=F_HEAD; title.TextSize=15; title.TextXAlignment=Enum.TextXAlignment.Left; title.TextColor3=C.text; title.Text="LUXXS"; title.Parent=top
local sub=Instance.new("TextLabel"); sub.BackgroundTransparency=1; sub.Position=UDim2.new(0,130,0,2); sub.Size=UDim2.new(0,120,1,0); sub.Font=F_MONO; sub.TextSize=11; sub.TextXAlignment=Enum.TextXAlignment.Left; sub.TextColor3=C.dim; sub.Text="by DrHub"; sub.Parent=top
local ver=Instance.new("TextLabel"); ver.BackgroundTransparency=1; ver.AnchorPoint=Vector2.new(1,0); ver.Position=UDim2.new(1,-52,0,0); ver.Size=UDim2.new(0,160,1,0); ver.Font=F_MONO; ver.TextSize=11; ver.TextXAlignment=Enum.TextXAlignment.Right; ver.TextColor3=C.dim; ver.Text="v8.2 // MM2"; ver.Parent=top
end
local closeBtn=Instance.new("TextButton"); closeBtn.AnchorPoint=Vector2.new(1,0.5); closeBtn.Position=UDim2.new(1,-10,0.5,0); closeBtn.Size=UDim2.new(0,28,0,28); closeBtn.BackgroundColor3=C.row; closeBtn.BorderSizePixel=0; closeBtn.Text="X"; closeBtn.Font=F_MONO; closeBtn.TextSize=13; closeBtn.TextColor3=C.dim; closeBtn.AutoButtonColor=false; closeBtn.Parent=top

local side=Instance.new("Frame"); side.Position=UDim2.new(0,0,0,44); side.Size=UDim2.new(0,150,0,H-44-24); side.BackgroundColor3=C.panel; side.BorderSizePixel=0; side.Parent=main
do
local sideLine=Instance.new("Frame"); sideLine.Position=UDim2.new(1,-1,0,0); sideLine.Size=UDim2.new(0,1,1,0); sideLine.BackgroundColor3=C.line; sideLine.BorderSizePixel=0; sideLine.Parent=side
end
local sideList=Instance.new("ScrollingFrame"); sideList.Active=true; sideList.ScrollBarThickness=3; sideList.ScrollBarImageColor3=C.dim; sideList.ScrollingDirection=Enum.ScrollingDirection.Y; sideList.CanvasSize=UDim2.new(0,0,0,0); sideList.BorderSizePixel=0; sideList.BackgroundTransparency=1; sideList.Position=UDim2.new(0,0,0,12); sideList.Size=UDim2.new(1,-1,1,-12); sideList.Parent=side
local indicator=Instance.new("Frame"); indicator.Size=UDim2.new(0,2,0,22); indicator.Position=UDim2.new(0,0,0,6); indicator.BorderSizePixel=0; indicator.ZIndex=3; indicator.Parent=sideList; T(indicator,"BackgroundColor3")

local foot=Instance.new("Frame"); foot.Position=UDim2.new(0,0,1,-24); foot.Size=UDim2.new(1,0,0,24); foot.BackgroundColor3=C.panel; foot.BorderSizePixel=0; foot.Parent=main
do
local footLine=Instance.new("Frame"); footLine.Size=UDim2.new(1,0,0,1); footLine.BackgroundColor3=C.line; footLine.BorderSizePixel=0; footLine.Parent=foot
local footL=Instance.new("TextLabel"); footL.BackgroundTransparency=1; footL.Position=UDim2.new(0,14,0,0); footL.Size=UDim2.new(0.6,0,1,0); footL.Font=F_MONO; footL.TextSize=10; footL.TextXAlignment=Enum.TextXAlignment.Left; footL.TextColor3=C.dim; footL.Text="RIGHTSHIFT = TOGGLE   |   t.me/NurHuboffical"; footL.Parent=foot
end
local footR=Instance.new("TextLabel"); footR.BackgroundTransparency=1; footR.AnchorPoint=Vector2.new(1,0); footR.Position=UDim2.new(1,-14,0,0); footR.Size=UDim2.new(0.4,0,1,0); footR.Font=F_MONO; footR.TextSize=10; footR.TextXAlignment=Enum.TextXAlignment.Right; footR.TextColor3=C.dim; footR.Text="ROLE  INNOCENT"; footR.Parent=foot

local pages=Instance.new("Frame"); pages.BackgroundTransparency=1; pages.Position=UDim2.new(0,162,0,54); pages.Size=UDim2.new(0,542,0,H-24-54-10); pages.ClipsDescendants=true; pages.Parent=main
local previewPanel=Instance.new("Frame"); previewPanel.Position=UDim2.new(0,712,0,54); previewPanel.Size=UDim2.new(0,252,0,372); previewPanel.BorderSizePixel=0; previewPanel.Parent=main

local tabs,currentTab,switching={},nil,false

local function restyleTabs()
    for _,t in ipairs(tabs) do
        local on=(t==currentTab)
        t.nm.TextColor3=on and C.text or C.dim
        t.num.TextColor3=on and ACC or C.dim
        t.button.BackgroundColor3=on and ACC or C.row; t.button.BackgroundTransparency=on and 0.82 or 1
    end
end

local function selectTab(tab)
    if currentTab==tab or switching then return end
    switching=true; local old=currentTab; currentTab=tab
    tween(indicator,0.3,{Position=UDim2.new(0,0,0,6+tab.index*36)})
    restyleTabs()
    if old then tween(old.page,0.15,{GroupTransparency=1}); task.delay(0.15,function() old.page.Visible=false end) end
    task.delay(old and 0.12 or 0,function()
        tab.page.GroupTransparency=1; tab.page.Visible=true
        tween(tab.page,0.25,{GroupTransparency=0})
        task.delay(0.25,function() switching=false end)
    end)
end

local function hairline(parent,y)
    local f=Instance.new("Frame"); f.Position=UDim2.new(0,0,1,y or -1); f.Size=UDim2.new(1,0,0,1); f.BackgroundColor3=C.line; f.BackgroundTransparency=1; f.BorderSizePixel=0; f.Parent=parent; return f
end

local function createTab(name)
    local index=#tabs
    local button=Instance.new("TextButton"); button.Size=UDim2.new(1,-16,0,34); button.Position=UDim2.new(0,8,0,index*36+6); button.BackgroundColor3=C.row; button.BackgroundTransparency=1; button.BorderSizePixel=0; button.Text=""; button.AutoButtonColor=false; button.Parent=sideList; corner(button,8); sideList.CanvasSize=UDim2.new(0,0,0,(index+1)*36+16)
    local num=Instance.new("TextLabel"); num.BackgroundTransparency=1; num.Position=UDim2.new(0,16,0,0); num.Size=UDim2.new(0,24,1,0); num.Font=F_MONO; num.TextSize=11; num.TextXAlignment=Enum.TextXAlignment.Left; num.TextColor3=C.dim; num.Text=string.format("%02d",index+1); num.Parent=button
    local nm=Instance.new("TextLabel"); nm.BackgroundTransparency=1; nm.Position=UDim2.new(0,46,0,0); nm.Size=UDim2.new(1,-50,1,0); nm.Font=F_SEC; nm.TextSize=16; nm.TextXAlignment=Enum.TextXAlignment.Left; nm.TextColor3=C.dim; nm.Text=string.upper(name); nm.Parent=button

    local page=Instance.new("CanvasGroup"); page.Size=UDim2.new(1,0,1,0); page.BackgroundTransparency=1; page.Visible=false; page.GroupTransparency=1; page.Parent=pages
    local scroll=Instance.new("ScrollingFrame"); scroll.Size=UDim2.new(1,0,1,0); scroll.BackgroundTransparency=1; scroll.BorderSizePixel=0; scroll.ScrollBarThickness=2; scroll.CanvasSize=UDim2.new(0,0,0,0); scroll.AutomaticCanvasSize=Enum.AutomaticSize.Y; scroll.Parent=page
    T(scroll,"ScrollBarImageColor3")
    local function mkCol(xs,xo) local f=Instance.new("Frame"); f.BackgroundTransparency=1; f.Position=UDim2.new(xs,xo,0,0); f.Size=UDim2.new(0.5,-4,0,0); f.AutomaticSize=Enum.AutomaticSize.Y; f.Parent=scroll; local l=Instance.new("UIListLayout"); l.Padding=UDim.new(0,2); l.SortOrder=Enum.SortOrder.LayoutOrder; l.Parent=f; return f end
    local colL=mkCol(0,0); local colR=mkCol(0.5,4)
    local hL,hR=0,0
    local COLH=H-24-54-10-12
    local function slot(h)
        if hL+h<=COLH then hL=hL+h+2; return colL end
        if hR+h<=COLH then hR=hR+h+2; return colR end
        if hR<hL then hR=hR+h+2; return colR end
        hL=hL+h+2; return colL
    end
    local pad=Instance.new("UIPadding"); pad.PaddingRight=UDim.new(0,8); pad.PaddingTop=UDim.new(0,2); pad.PaddingBottom=UDim.new(0,10); pad.Parent=scroll

    local tab={button=button,page=page,scroll=scroll,index=index,name=name,num=num,nm=nm}; table.insert(tabs,tab)
    button.MouseButton1Click:Connect(function() selectTab(tab) end)
    button.MouseEnter:Connect(function() if currentTab~=tab then tween(nm,0.15,{TextColor3=C.text}) end end)
    button.MouseLeave:Connect(function() if currentTab~=tab then tween(nm,0.15,{TextColor3=C.dim}) end end)

    function tab:Label(text)
        local f=Instance.new("Frame"); f.Size=UDim2.new(1,0,0,30); f.BackgroundTransparency=1; f.Parent=slot(30)
        local l=Instance.new("TextLabel"); l.BackgroundTransparency=1; l.Position=UDim2.new(0,0,0,6); l.Size=UDim2.new(1,0,0,18); l.Font=F_SEC; l.TextSize=13; l.TextXAlignment=Enum.TextXAlignment.Left; l.TextColor3=C.dim; l.Text=string.upper(text); l.Parent=f
        hairline(f,-3)
        local ac=Instance.new("Frame"); ac.Position=UDim2.new(0,0,1,-3); ac.Size=UDim2.new(0,28,0,1); ac.BorderSizePixel=0; ac.Parent=f; T(ac,"BackgroundColor3")
    end

    function tab:Label2(text,font,size,color)
        local l=Instance.new("TextLabel"); l.Size=UDim2.new(1,0,0,(#text>36) and 28 or 18); l.TextWrapped=true; l.BackgroundTransparency=1; l.Font=font or F_MONO; l.TextSize=size or 11; l.TextColor3=color or C.dim; l.TextXAlignment=Enum.TextXAlignment.Left; l.Text=text; l.Parent=slot(l.Size.Y.Offset)
        return l
    end

    function tab:Frame(h) local f=Instance.new("Frame"); f.Size=UDim2.new(1,0,0,h); f.BackgroundTransparency=1; f.Parent=slot(h); return f end

    function tab:Toggle(text,default,callback)
        local key=name.."/"..text; local state=default or false
        local row=Instance.new("TextButton"); row.Size=UDim2.new(1,0,0,34); row.BackgroundColor3=C.row; row.BackgroundTransparency=0.55; corner(row,8); row.BorderSizePixel=0; row.AutoButtonColor=false; row.Text=""; row.Parent=slot(34)
        hairline(row)
        local lbl=Instance.new("TextLabel"); lbl.BackgroundTransparency=1; lbl.Position=UDim2.new(0,10,0,0); lbl.Size=UDim2.new(1,-60,1,0); lbl.Font=F_BODY; lbl.TextSize=14; lbl.TextColor3=C.text; lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.Text=text; lbl.Parent=row
        local box=Instance.new("Frame"); box.AnchorPoint=Vector2.new(1,0.5); box.Position=UDim2.new(1,-10,0.5,0); box.Size=UDim2.new(0,36,0,18); box.BackgroundColor3=state and ACC or C.off; box.BorderSizePixel=0; box.Parent=row; corner(box,9)
        T(box,"BackgroundColor3",function(a) return state and a or C.off end)
        local inner=Instance.new("Frame"); inner.AnchorPoint=Vector2.new(0,0.5); inner.Position=UDim2.new(0,state and 20 or 2,0.5,0); inner.Size=UDim2.new(0,14,0,14); inner.BackgroundColor3=WHITE; inner.BorderSizePixel=0; inner.Parent=box; corner(inner,7)
        local function paint() tween(box,0.18,{BackgroundColor3=state and ACC or C.off}); tween(inner,0.18,{Position=UDim2.new(0,state and 20 or 2,0.5,0)}) end
        register(key,state,function(v)
            state=v and true or false; Flags[key]=state; paint()
            if callback then task.spawn(callback,state) end
        end)
        row.MouseButton1Click:Connect(function() Setters[key](not state) end)
        row.MouseEnter:Connect(function() tween(row,0.12,{BackgroundTransparency=0.3}) end)
        row.MouseLeave:Connect(function() tween(row,0.12,{BackgroundTransparency=0.55}) end)
    end

    function tab:Button(text,callback)
        local wrap=Instance.new("Frame"); wrap.Size=UDim2.new(1,0,0,38); wrap.BackgroundTransparency=1; wrap.Parent=slot(38)
        local b=Instance.new("TextButton"); b.Position=UDim2.new(0,10,0,4); b.Size=UDim2.new(1,-20,0,30); b.BackgroundColor3=ACC; b.BackgroundTransparency=0.88; corner(b,8); b.BorderSizePixel=0; b.AutoButtonColor=false; b.Font=F_MONO; b.TextSize=12; b.Text=string.upper(text); b.Parent=wrap
        T(b,"TextColor3"); local bs=stroke(b,ACC,1,0.4); T(bs,"Color")
        b.MouseEnter:Connect(function() b.BackgroundColor3=ACC; tween(b,0.12,{BackgroundTransparency=0}); b.TextColor3=C.bg end)
        b.MouseLeave:Connect(function() tween(b,0.12,{BackgroundTransparency=0.88}); b.TextColor3=ACC end)
        b.MouseButton1Click:Connect(function() if callback then task.spawn(callback) end end)
    end

    function tab:Input(text,default,callback)
        local row=Instance.new("Frame"); row.Size=UDim2.new(1,0,0,38); row.BackgroundColor3=C.row; row.BackgroundTransparency=0.55; corner(row,8); row.Parent=slot(38)
        hairline(row)
        local lbl=Instance.new("TextLabel"); lbl.BackgroundTransparency=1; lbl.Position=UDim2.new(0,10,0,0); lbl.Size=UDim2.new(0.5,-10,1,0); lbl.Font=F_BODY; lbl.TextSize=14; lbl.TextColor3=C.text; lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.Text=text; lbl.Parent=row
        local boxF=Instance.new("Frame"); boxF.AnchorPoint=Vector2.new(1,0.5); boxF.Position=UDim2.new(1,-10,0.5,0); boxF.Size=UDim2.new(0.5,-10,0,26); boxF.BackgroundColor3=C.bg; boxF.BorderSizePixel=0; boxF.Parent=row
        local bs=stroke(boxF,ACC,1,0.4); T(bs,"Color")
        local tb=Instance.new("TextBox"); tb.BackgroundTransparency=1; tb.Size=UDim2.new(1,-12,1,0); tb.Position=UDim2.new(0,6,0,0); tb.Font=F_MONO; tb.TextSize=13; tb.TextColor3=C.text; tb.PlaceholderColor3=C.dim; tb.PlaceholderText="value"; tb.Text=tostring(default or ""); tb.ClearTextOnFocus=false; tb.TextXAlignment=Enum.TextXAlignment.Center; tb.Parent=boxF
        tb.FocusLost:Connect(function(enter) if callback then task.spawn(callback,tb.Text,tb) end end)
        return tb
    end

    function tab:Slider(text,min,max,default,callback,gradFn)
        local key=name.."/"..text; local value=default or min
        local row=Instance.new("Frame"); row.Size=UDim2.new(1,0,0,46); row.BackgroundColor3=C.row; row.BackgroundTransparency=0.55; corner(row,8); row.Parent=slot(46)
        hairline(row)
        local lbl=Instance.new("TextLabel"); lbl.BackgroundTransparency=1; lbl.Position=UDim2.new(0,10,0,4); lbl.Size=UDim2.new(0.6,0,0,20); lbl.Font=F_BODY; lbl.TextSize=14; lbl.TextColor3=C.text; lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.Text=text; lbl.Parent=row
        local val=Instance.new("TextLabel"); val.BackgroundTransparency=1; val.AnchorPoint=Vector2.new(1,0); val.Position=UDim2.new(1,-10,0,4); val.Size=UDim2.new(0,100,0,20); val.Font=F_MONO; val.TextSize=13; val.TextXAlignment=Enum.TextXAlignment.Right; val.Text=tostring(value); val.Parent=row; T(val,"TextColor3")
        local bar=Instance.new("Frame"); bar.Position=UDim2.new(0,10,0,33); bar.Size=UDim2.new(1,-20,0,5); bar.BackgroundColor3=C.off; bar.BorderSizePixel=0; bar.Parent=row
        local fill=Instance.new("Frame"); fill.Size=UDim2.new((value-min)/(max-min),0,1,0); fill.BorderSizePixel=0; fill.Parent=bar; T(fill,"BackgroundColor3")
        local gradObj
        if gradFn then
            bar.Size=UDim2.new(1,-20,0,8); bar.Position=UDim2.new(0,10,0,31); bar.BackgroundColor3=WHITE; fill.BackgroundTransparency=1
            gradObj=Instance.new("UIGradient"); gradObj.Color=gradFn(); gradObj.Parent=bar
            GradRefresh[key]=function() gradObj.Color=gradFn() end
        end
        local knob=Instance.new("Frame"); knob.AnchorPoint=Vector2.new(0.5,0.5); knob.Position=UDim2.new((value-min)/(max-min),0,0.5,0); knob.Size=UDim2.new(0,14,0,14); knob.BackgroundColor3=WHITE; knob.BorderSizePixel=0; knob.ZIndex=3; knob.Parent=bar; corner(bar,3); corner(fill,3); corner(knob,7); T(stroke(knob,ACC,2,0),"Color")
        register(key,value,function(v)
            v=math.clamp(math.floor((tonumber(v) or min)+0.5),min,max); value=v; Flags[key]=v
            val.Text=tostring(v)
            local r=(v-min)/(max-min)
            fill.Size=UDim2.new(r,0,1,0); knob.Position=UDim2.new(r,0,0.5,0)
            if callback then task.spawn(callback,v) end
        end)
        local hit=Instance.new("TextButton"); hit.BackgroundTransparency=1; hit.Text=""; hit.Position=UDim2.new(0,0,0,22); hit.Size=UDim2.new(1,0,0,24); hit.Parent=row
        local sliding=false
        local function update(x) local rel=math.clamp((x-bar.AbsolutePosition.X)/math.max(bar.AbsoluteSize.X,1),0,1); Setters[key](min+(max-min)*rel) end
        hit.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then sliding=true; scroll.ScrollingEnabled=false; update(i.Position.X) end end)
        track(UIS.InputEnded:Connect(function(i) if sliding and (i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch) then sliding=false; scroll.ScrollingEnabled=true end end))
        track(UIS.InputChanged:Connect(function(i) if sliding and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then update(i.Position.X) end end))
    end

    function tab:Choice(text,options,default,callback)
        local key=name.."/"..text; local idx=table.find(options,default) or 1
        local row=Instance.new("TextButton"); row.Size=UDim2.new(1,0,0,34); row.BackgroundColor3=C.row; row.BackgroundTransparency=0.55; corner(row,8); row.BorderSizePixel=0; row.AutoButtonColor=false; row.Text=""; row.Parent=slot(34)
        hairline(row)
        local lbl=Instance.new("TextLabel"); lbl.BackgroundTransparency=1; lbl.Position=UDim2.new(0,10,0,0); lbl.Size=UDim2.new(0.5,-10,1,0); lbl.Font=F_BODY; lbl.TextSize=14; lbl.TextColor3=C.text; lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.Text=text; lbl.Parent=row
        local val=Instance.new("TextLabel"); val.BackgroundTransparency=1; val.AnchorPoint=Vector2.new(1,0); val.Position=UDim2.new(1,-10,0,0); val.Size=UDim2.new(0.5,-10,1,0); val.Font=F_MONO; val.TextSize=13; val.TextXAlignment=Enum.TextXAlignment.Right; val.Text="< "..options[idx].." >"; val.Parent=row; T(val,"TextColor3")
        register(key,options[idx],function(v)
            local i=table.find(options,v); if not i then return end
            idx=i; Flags[key]=options[i]; val.Text="< "..options[i].." >"
            if callback then task.spawn(callback,options[i]) end
        end)
        row.MouseButton1Click:Connect(function() Setters[key](options[idx%#options+1]) end)
        row.MouseButton2Click:Connect(function() Setters[key](options[(idx-2)%#options+1]) end)
        row.MouseEnter:Connect(function() tween(row,0.12,{BackgroundTransparency=0.3}) end)
        row.MouseLeave:Connect(function() tween(row,0.12,{BackgroundTransparency=0.55}) end)
    end

    function tab:List(text,items,default,callback)
        local key=name.."/"..text
        local lf=Instance.new("Frame"); lf.Size=UDim2.new(1,0,0,180); lf.BackgroundTransparency=1; lf.Parent=slot(180)
        local header=Instance.new("TextLabel"); header.BackgroundTransparency=1; header.Position=UDim2.new(0,0,0,0); header.Size=UDim2.new(1,0,0,16); header.Font=F_SEC; header.TextSize=13; header.TextXAlignment=Enum.TextXAlignment.Left; header.TextColor3=C.text; header.Text=string.upper(text); header.Parent=lf
        local sf=Instance.new("ScrollingFrame"); sf.Position=UDim2.new(0,0,0,18); sf.Size=UDim2.new(1,0,1,-18); sf.BackgroundColor3=C.row; sf.BackgroundTransparency=0.45; sf.BorderSizePixel=0; sf.ScrollBarThickness=3; sf.CanvasSize=UDim2.new(0,0,0,#items*28+10); sf.Parent=lf
        corner(sf,8); T(sf,"ScrollBarImageColor3")
        local ll=Instance.new("UIListLayout"); ll.Padding=UDim.new(0,2); ll.SortOrder=Enum.SortOrder.LayoutOrder; ll.Parent=sf
        local pd=Instance.new("UIPadding"); pd.PaddingTop=UDim.new(0,4); pd.PaddingLeft=UDim.new(0,4); pd.PaddingRight=UDim.new(0,6); pd.PaddingBottom=UDim.new(0,4); pd.Parent=sf
        local btns={}
        local current=default or items[1]
        local function paint()
            for n,b in pairs(btns) do
                local on=(n==current)
                b.BackgroundColor3=on and ACC or C.bg
                b.BackgroundTransparency=on and 0.55 or 0.45
                b.TextColor3=on and C.text or C.dim
            end
        end
        register(key,current,function(v)
            current=v; Flags[key]=v; paint()
            if callback then task.spawn(callback,v) end
        end)
        for i,name in ipairs(items) do
            local b=Instance.new("TextButton"); b.Size=UDim2.new(1,0,0,26); b.BorderSizePixel=0; b.AutoButtonColor=false; b.Font=F_BODY; b.TextSize=14
            b.TextXAlignment=Enum.TextXAlignment.Left; b.Text="  "..name; b.LayoutOrder=i; b.Parent=sf; corner(b,6)
            b.MouseButton1Click:Connect(function() Setters[key](name) end)
            b.MouseEnter:Connect(function() if name~=current then b.BackgroundTransparency=0.15 end end)
            b.MouseLeave:Connect(function() if name~=current then b.BackgroundTransparency=0.45 end end)
            btns[name]=b
        end
        paint()
    end
    return tab
end

local function fitScale() local cam=workspace.CurrentCamera; local vp=cam and cam.ViewportSize or Vector2.new(1280,720); return math.min(1,(vp.X-20)/W,(vp.Y-20)/H) end
local isOpen,busy=false,false
local MenuAlpha=0.94
local MenuScale=1

local function openMenu()
    if busy or isOpen then return end
    busy=true; isOpen=true
    main.Visible=true
    local fit=fitScale(); scale.Scale=fit*0.94*MenuScale; main.GroupTransparency=1
    tween(scale,0.35,{Scale=fit*MenuScale}); tween(main,0.3,{GroupTransparency=1-MenuAlpha})
    task.delay(0.35,function() busy=false end)
end

local function closeMenu()
    if busy or not isOpen then return end
    busy=true; isOpen=false
    tween(scale,0.25,{Scale=fitScale()*0.94*MenuScale},Enum.EasingStyle.Quint,Enum.EasingDirection.In); tween(main,0.25,{GroupTransparency=1},Enum.EasingStyle.Quint,Enum.EasingDirection.In)
    task.delay(0.26,function() main.Visible=false; busy=false end)
end

local function toggleMenu() if isOpen then closeMenu() else openMenu() end end

closeBtn.MouseButton1Click:Connect(closeMenu)
closeBtn.MouseEnter:Connect(function() tween(closeBtn,0.12,{BackgroundColor3=Color3.fromRGB(190,56,56)}); closeBtn.TextColor3=WHITE end)
closeBtn.MouseLeave:Connect(function() tween(closeBtn,0.12,{BackgroundColor3=C.row}); closeBtn.TextColor3=C.dim end)

local teleportToGun
local QB_COLORS={"Accent","Rainbow","Lime","Coral","Ice","Violet","Gold","Red","Green","Blue","Pink","White"}
local QB_ACTIONS={
    {label="Aimbot",flag="Aimbot/Enable",icon="AIM",def=true},
    {label="Auto Shoot",flag="Aimbot/Auto Shoot",icon="SHT",def=true},
    {label="Fly",flag="Move/Fly",icon="FLY",def=true},
    {label="Noclip",flag="Move/Noclip",icon="NLP",def=true},
    {label="Bunnyhop",flag="Move/Bunnyhop",icon="BHP",def=true},
    {label="Auto Win",flag="Aimbot/Auto Win",icon="AWN",def=true},
    {label="Auto Farm",flag="Farm/Enable Farm",icon="FRM",def=true},
    {label="Anti Aim",flag="Anti Aim/Anti Aim",icon="AAM",def=true},
    {label="TP Gun",flag="__tpgun",icon="TPG",def=true,action=function() if teleportToGun then teleportToGun() end end},
    {label="Spin",flag="Move/Spin",icon="SPN",def=false},
    {label="ESP Box",flag="Visuals/ESP Box",icon="BOX",def=false},
    {label="Chams",flag="Visuals/Chams",icon="CHM",def=false},
    {label="Skeleton",flag="Visuals/Skeleton",icon="SKL",def=false},
    {label="Tracers",flag="Visuals/Tracers",icon="TRC",def=false},
    {label="Gun ESP",flag="Visuals/Gun ESP",icon="GUN",def=false},
    {label="Wings",flag="Visuals/Wings",icon="WNG",def=false},
    {label="Chinese Hat",flag="Visuals/Chinese Hat",icon="HAT",def=false},
    {label="Headless",flag="Visuals/Fake Headless",icon="HDL",def=false},
    {label="Legless",flag="Visuals/Legless",icon="LGL",def=false},
    {label="Trail",flag="Visuals/Trail",icon="TRL",def=false},
}
local setQuickBarVisible,applyQbPosition,refreshQuickBar
__safe("quickbar",function()
local QuickBar=Instance.new("CanvasGroup")
QuickBar.AnchorPoint=Vector2.new(0,0.5)
QuickBar.Position=UDim2.new(0,24,0.5,0)
QuickBar.Size=UDim2.new(0,80,0,0)
QuickBar.AutomaticSize=Enum.AutomaticSize.Y
QuickBar.BackgroundColor3=C.bg
QuickBar.BackgroundTransparency=0.1
QuickBar.GroupTransparency=1
QuickBar.BorderSizePixel=0
QuickBar.ZIndex=6
QuickBar.Visible=false
QuickBar.Parent=gui
corner(QuickBar,14)
local qbStroke=stroke(QuickBar,ACC,1.5,0.35); T(qbStroke,"Color")

local qbHandle=Instance.new("Frame")
qbHandle.Size=UDim2.new(1,0,0,16)
qbHandle.BackgroundColor3=WHITE
qbHandle.BackgroundTransparency=0.9
qbHandle.BorderSizePixel=0
qbHandle.ZIndex=8
qbHandle.Parent=QuickBar
corner(qbHandle,8)
local qbHandleBar=Instance.new("Frame")
qbHandleBar.AnchorPoint=Vector2.new(0.5,0.5)
qbHandleBar.Position=UDim2.new(0.5,0,0.5,0)
qbHandleBar.Size=UDim2.new(0,30,0,3)
qbHandleBar.BackgroundColor3=WHITE
qbHandleBar.BackgroundTransparency=0.35
qbHandleBar.BorderSizePixel=0
qbHandleBar.ZIndex=9
qbHandleBar.Parent=qbHandle
corner(qbHandleBar,3)

local qbLayout=Instance.new("UIListLayout")
qbLayout.Padding=UDim.new(0,4)
qbLayout.SortOrder=Enum.SortOrder.LayoutOrder
qbLayout.HorizontalAlignment=Enum.HorizontalAlignment.Center
qbLayout.Parent=QuickBar

local qbPad=Instance.new("UIPadding")
qbPad.PaddingTop=UDim.new(0,20)
qbPad.PaddingBottom=UDim.new(0,8)
qbPad.PaddingLeft=UDim.new(0,7)
qbPad.PaddingRight=UDim.new(0,7)
qbPad.Parent=QuickBar

local qbScroll=Instance.new("ScrollingFrame")
qbScroll.Size=UDim2.new(1,0,0,100); qbScroll.BackgroundTransparency=1; qbScroll.BorderSizePixel=0
qbScroll.ScrollBarThickness=3; qbScroll.ScrollBarImageColor3=C.dim
qbScroll.CanvasSize=UDim2.new(0,0,0,0); qbScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
qbScroll.ScrollingDirection=Enum.ScrollingDirection.Y; qbScroll.LayoutOrder=1; qbScroll.ZIndex=7; qbScroll.Parent=QuickBar
local qbList=Instance.new("UIListLayout"); qbList.Padding=UDim.new(0,4); qbList.SortOrder=Enum.SortOrder.LayoutOrder
qbList.HorizontalAlignment=Enum.HorizontalAlignment.Center; qbList.Parent=qbScroll

local qbToggle=Instance.new("TextButton")
qbToggle.Size=UDim2.new(0,22,0,44)
qbToggle.BackgroundColor3=C.bg
qbToggle.BackgroundTransparency=0.15
qbToggle.BorderSizePixel=0
qbToggle.Text="‹"
qbToggle.Font=F_MONO
qbToggle.TextSize=18
qbToggle.TextColor3=C.text
qbToggle.AutoButtonColor=false
qbToggle.ZIndex=7
qbToggle.Visible=false
qbToggle.Parent=gui
corner(qbToggle,10)
stroke(qbToggle,C.line,1,0.3)

local qbPositions={
    ["Left"]=function() QuickBar.AnchorPoint=Vector2.new(0,0.5); QuickBar.Position=UDim2.new(0,24,0.5,0); qbToggle.AnchorPoint=Vector2.new(0,0.5); qbToggle.Position=UDim2.new(0,4,0.5,0) end,
    ["Right"]=function() QuickBar.AnchorPoint=Vector2.new(1,0.5); QuickBar.Position=UDim2.new(1,-24,0.5,0); qbToggle.AnchorPoint=Vector2.new(1,0.5); qbToggle.Position=UDim2.new(1,-4,0.5,0) end,
    ["Bottom"]=function() QuickBar.AnchorPoint=Vector2.new(0.5,1); QuickBar.Position=UDim2.new(0.5,0,1,-24); qbToggle.AnchorPoint=Vector2.new(0.5,1); qbToggle.Position=UDim2.new(0.5,0,1,-4) end,
    ["Top"]=function() QuickBar.AnchorPoint=Vector2.new(0.5,0); QuickBar.Position=UDim2.new(0.5,0,0,24); qbToggle.AnchorPoint=Vector2.new(0.5,0); qbToggle.Position=UDim2.new(0.5,0,0,4) end,
    ["Left-Top"]=function() QuickBar.AnchorPoint=Vector2.new(0,0); QuickBar.Position=UDim2.new(0,24,0,80); qbToggle.AnchorPoint=Vector2.new(0,0); qbToggle.Position=UDim2.new(0,4,0,80) end,
    ["Left-Bottom"]=function() QuickBar.AnchorPoint=Vector2.new(0,1); QuickBar.Position=UDim2.new(0,24,1,-80); qbToggle.AnchorPoint=Vector2.new(0,1); qbToggle.Position=UDim2.new(0,4,1,-80) end,
    ["Right-Top"]=function() QuickBar.AnchorPoint=Vector2.new(1,0); QuickBar.Position=UDim2.new(1,-24,0,80); qbToggle.AnchorPoint=Vector2.new(1,0); qbToggle.Position=UDim2.new(1,-4,0,80) end,
    ["Right-Bottom"]=function() QuickBar.AnchorPoint=Vector2.new(1,1); QuickBar.Position=UDim2.new(1,-24,1,-80); qbToggle.AnchorPoint=Vector2.new(1,1); qbToggle.Position=UDim2.new(1,-4,1,-80) end,
}
local currentQbPos="Left"
local qbEnabled,qbExpanded=false,false
local qbShown=UDim2.new(0,24,0.5,0)
local qbToken=0
local qbAnimUntil=0

local function qbArrowFor(pos,expanded)
    local d
    if pos:find("Left") then d="L" elseif pos:find("Right") then d="R" elseif pos=="Top" then d="T" else d="B" end
    local closeArrow={L="‹",R="›",T="▲",B="▼"}
    local openArrow={L="›",R="‹",T="▼",B="▲"}
    return expanded and closeArrow[d] or openArrow[d]
end
local function qbSetArrow() qbToggle.Text=qbArrowFor(currentQbPos,qbExpanded) end

local function qbHiddenFrom(p)
    local o=140
    if currentQbPos:find("Left") then return UDim2.new(p.X.Scale,p.X.Offset-o,p.Y.Scale,p.Y.Offset)
    elseif currentQbPos:find("Right") then return UDim2.new(p.X.Scale,p.X.Offset+o,p.Y.Scale,p.Y.Offset)
    elseif currentQbPos=="Top" then return UDim2.new(p.X.Scale,p.X.Offset,p.Y.Scale,p.Y.Offset-o)
    else return UDim2.new(p.X.Scale,p.X.Offset,p.Y.Scale,p.Y.Offset+o) end
end

local function qbPop()
    local s=qbToggle.Size
    qbToggle.Size=UDim2.new(0,s.X.Offset-6,0,s.Y.Offset)
    tween(qbToggle,0.35,{Size=UDim2.new(0,22,0,44)},Enum.EasingStyle.Back,Enum.EasingDirection.Out)
end

local function qbExpand()
    qbToken+=1
    qbExpanded=true
    QuickBar.Visible=true
    if QuickBar.GroupTransparency>0.95 then QuickBar.Position=qbHiddenFrom(qbShown) end
    qbAnimUntil=os.clock()+0.55
    tween(QuickBar,0.5,{Position=qbShown,GroupTransparency=0},Enum.EasingStyle.Back,Enum.EasingDirection.Out)
    qbSetArrow(); qbPop()
end

local function qbCollapse()
    qbToken+=1
    local my=qbToken
    if qbExpanded and os.clock()>qbAnimUntil then qbShown=QuickBar.Position end
    qbExpanded=false
    tween(QuickBar,0.4,{Position=qbHiddenFrom(qbShown),GroupTransparency=1},Enum.EasingStyle.Quint,Enum.EasingDirection.In)
    qbSetArrow(); qbPop()
    task.delay(0.42,function()
        if qbToken==my and not qbExpanded then QuickBar.Visible=false end
    end)
end

function applyQbPosition(pos,animate)
    if not qbPositions[pos] then pos="Left" end
    currentQbPos=pos
    qbPositions[pos]()
    qbShown=QuickBar.Position
    qbSetArrow()
    if not qbEnabled then
        QuickBar.Position=qbHiddenFrom(qbShown)
        return
    end
    if qbExpanded then
        if animate then
            QuickBar.Position=qbHiddenFrom(qbShown)
            qbAnimUntil=os.clock()+0.55
            tween(QuickBar,0.45,{Position=qbShown},Enum.EasingStyle.Back,Enum.EasingDirection.Out)
        end
    else
        QuickBar.Position=qbHiddenFrom(qbShown)
    end
end

function setQuickBarVisible(on)
    on=on and true or false
    if qbEnabled==on then return end
    qbEnabled=on
    if on then
        qbPositions[currentQbPos]()
        qbShown=QuickBar.Position
        qbToggle.Visible=true
        qbToggle.BackgroundTransparency=1
        tween(qbToggle,0.4,{BackgroundTransparency=0.15},Enum.EasingStyle.Quint)
        qbExpand()
    else
        qbCollapse()
        tween(qbToggle,0.35,{BackgroundTransparency=1},Enum.EasingStyle.Quint)
        task.delay(0.45,function()
            if not qbEnabled then qbToggle.Visible=false end
        end)
    end
end

makeDraggable(qbHandle,QuickBar,nil)

qbToggle.MouseButton1Click:Connect(function()
    if not qbEnabled then return end
    if qbExpanded then qbCollapse() else qbExpand() end
end)
qbToggle.MouseEnter:Connect(function() tween(qbToggle,0.15,{BackgroundTransparency=0}) end)
qbToggle.MouseLeave:Connect(function() if qbEnabled then tween(qbToggle,0.15,{BackgroundTransparency=0.15}) end end)

local function qbCurrentColor()
    local n=Flags["Misc/Quick Bar Color"] or "Accent"
    if n=="Accent" then return ACC end
    return getColor(n,os.clock(),0)
end
local quickButtons={}
local function makeQuickButton(label,flagKey,iconText,defVisible,action)
    local b=Instance.new("TextButton")
    b.Size=UDim2.new(1,0,0,42)
    b.BackgroundColor3=C.row
    b.BackgroundTransparency=0.4
    b.BorderSizePixel=0
    b.AutoButtonColor=false
    b.Font=F_MONO
    b.TextSize=11
    b.TextColor3=C.dim
    b.Text=iconText or label
    b.LayoutOrder=#quickButtons+1
    b.Parent=qbScroll
    corner(b,9)
    local bs=stroke(b,C.line,1,0.4)
    local function paint()
        local on=Flags[flagKey]
        if action then on=false end
        local qc=qbCurrentColor()
        b.BackgroundColor3=on and qc or C.row
        b.BackgroundTransparency=on and 0.2 or 0.4
        b.TextColor3=action and qc or (on and C.bg or C.dim)
        bs.Color=(on or action) and qc or C.line
        bs.Transparency=on and 0 or 0.4
    end
    b.MouseButton1Click:Connect(function()
        if action then pcall(action); return end
        local newVal=not Flags[flagKey]
        if Setters[flagKey] then Setters[flagKey](newVal) else Flags[flagKey]=newVal end
        paint(); notify((newVal and "ON  " or "OFF ")..label)
    end)
    b.MouseEnter:Connect(function() if not Flags[flagKey] then b.BackgroundTransparency=0.15 end end)
    b.MouseLeave:Connect(paint)
    quickButtons[#quickButtons+1]={btn=b,flag=flagKey,paint=paint,label=label,def=defVisible}
    paint()
    return b
end

for _,act in ipairs(QB_ACTIONS) do makeQuickButton(act.label,act.flag,act.icon,act.def,act.action) end

function refreshQuickBar()
    local qc=qbCurrentColor()
    qbStroke.Color=qc
    for _,qb in ipairs(quickButtons) do
        local v=Flags["Misc/QB "..qb.label]
        if v==nil then v=qb.def end
        qb.btn.Visible=v and true or false
        qb.paint()
    end
    local cam=workspace.CurrentCamera
    local maxH=cam and cam.ViewportSize.Y*0.55 or 220
    qbScroll.Size=UDim2.new(1,0,0,math.clamp(qbList.AbsoluteContentSize.Y,40,maxH))
end
refreshQuickBar()

task.spawn(function()
    while gui.Parent do
        task.wait(0.25)
        refreshQuickBar()
    end
end)

end) -- /quickbar scope

makeDraggable(top,main)
track(UIS.InputBegan:Connect(function(input,processed) if not processed and input.KeyCode==Enum.KeyCode.RightShift then toggleMenu() end end))

-- HOME BAR: thin pill at the bottom edge of the screen (iPhone home indicator)
-- tap it or swipe up = open menu, swipe down = close
__safe("homebar",function()
    local hit=Instance.new("TextButton")
    hit.Name="luxxsHomeBar"
    hit.AnchorPoint=Vector2.new(0.5,1)
    hit.Position=UDim2.new(0.5,0,1,0)
    hit.Size=UDim2.new(0,260,0,38)
    hit.BackgroundTransparency=1
    hit.Text=""
    hit.AutoButtonColor=false
    hit.ZIndex=30
    hit.Parent=gui

    local pill=Instance.new("Frame")
    pill.AnchorPoint=Vector2.new(0.5,1)
    pill.Position=UDim2.new(0.5,0,1,-8)
    pill.Size=UDim2.new(0,140,0,5)
    pill.BackgroundColor3=WHITE
    pill.BackgroundTransparency=0.35
    pill.BorderSizePixel=0
    pill.ZIndex=31
    pill.Parent=hit
    corner(pill,3)
    stroke(pill,Color3.new(0,0,0),1,0.75)

    local pressing=false
    local startX,startY,moved=0,0,0

    local function rest()
        tween(pill,0.25,{Size=UDim2.new(0,140,0,5),Position=UDim2.new(0.5,0,1,-8),BackgroundTransparency=0.35})
    end

    hit.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            pressing=true
            startX=i.Position.X
            startY=i.Position.Y
            moved=0
            tween(pill,0.12,{Size=UDim2.new(0,175,0,6),BackgroundTransparency=0.05})
        end
    end)

    track(UIS.InputChanged:Connect(function(i)
        if not pressing then return end
        if i.UserInputType~=Enum.UserInputType.MouseMovement and i.UserInputType~=Enum.UserInputType.Touch then return end
        local dy=i.Position.Y-startY
        moved=math.max(moved,math.abs(dy),math.abs(i.Position.X-startX))
        pill.Position=UDim2.new(0.5,0,1,-8+math.clamp(dy,-26,10)*0.6)
    end))

    track(UIS.InputEnded:Connect(function(i)
        if not pressing then return end
        if i.UserInputType~=Enum.UserInputType.MouseButton1 and i.UserInputType~=Enum.UserInputType.Touch then return end
        pressing=false
        local dy=i.Position.Y-startY
        if dy<-22 then
            openMenu()
        elseif dy>22 then
            closeMenu()
        elseif moved<10 then
            toggleMenu()
        end
        rest()
    end))
end)

-- ROLE DETECTION
local function scanName(name)
    local n=string.lower(name)
    if n=="knife" or n:find("knife") or n:find("murderknife") then return "Murderer" end
    if n=="gun" or n=="revolver" or n=="sheriff gun" or n:find("revolver") or (n:find("gun") and not n:find("shotgun") and not n:find("stun")) then return "Sheriff" end
    return nil
end
local function scanContainer(container,deep)
    if not container then return nil end
    local list=deep and container:GetDescendants() or container:GetChildren()
    for _,obj in ipairs(list) do
        if obj:IsA("Tool") or obj:IsA("Model") or obj:IsA("Part") or obj:IsA("MeshPart") then
            local r=scanName(obj.Name); if r then return r end
        end
    end
    return nil
end
local MM2Roles={}
local MM2State={active={},have=false}
do
    local RS=game:GetService("ReplicatedStorage")
    local function ingest(data,full)
        if type(data)~="table" then return end
        local act=full and {} or MM2State.active
        local roles=full and {} or MM2Roles
        for name,info in pairs(data) do
            if type(info)=="table" and info.Role then
                local nm=tostring(name)
                roles[nm]=string.lower(tostring(info.Role))
                if info.Dead or info.Killed then act[nm]=nil else act[nm]=true end
            end
        end
        if full then MM2Roles=roles; MM2State.active=act; MM2State.have=next(act)~=nil end
    end
    task.spawn(function()
        while gui.Parent do
            local rf=RS:FindFirstChild("GetPlayerData",true)
            if rf and rf:IsA("RemoteFunction") then pcall(function() ingest(rf:InvokeServer(),true) end) end
            task.wait(1.5)
        end
    end)
    local ev=RS:FindFirstChild("PlayerDataChanged",true)
    if ev and ev:IsA("RemoteEvent") then track(ev.OnClientEvent:Connect(function(d) pcall(ingest,d) end)) end
end
local function getRole(plr)
    local char=plr.Character; if not char then return "Innocent" end
    local md=MM2Roles[plr.Name]
    if md then
        if md=="murderer" or md=="murder" then return "Murderer" end
        if md=="sheriff" or md=="hero" then return "Sheriff" end
        if md=="innocent" then return "Innocent" end
    end
    if plr.Team then
        local tl=string.lower(plr.Team.Name)
        if tl=="murderer" then return "Murderer" end
        if tl=="sheriff" then return "Sheriff" end
        if tl=="innocent" then return "Innocent" end
    end
    for _,src in ipairs({plr,char}) do
        for _,attr in ipairs({"Role","MM2Role","MurderRole","PlayerRole","Team","role","mm2role"}) do
            local v=src:GetAttribute(attr)
            if v~=nil then
                local rl=string.lower(tostring(v))
                if rl=="murderer" or rl=="murder" then return "Murderer" end
                if rl=="sheriff" then return "Sheriff" end
                if rl=="innocent" then return "Innocent" end
            end
        end
    end
    for _,obj in ipairs(char:GetChildren()) do if obj:IsA("Tool") then local r=scanName(obj.Name); if r then return r end end end
    local r=scanContainer(char,true); if r then return r end
    local bp=plr:FindFirstChildOfClass("Backpack") or plr:FindFirstChild("Backpack")
    if bp then
        for _,obj in ipairs(bp:GetChildren()) do if obj:IsA("Tool") then local rr=scanName(obj.Name); if rr then return rr end end end
        r=scanContainer(bp,true); if r then return r end
    end
    return "Innocent"
end
local roleCache={}
local function getRoleCached(plr)
    local c=roleCache[plr]; local now=os.clock()
    if c and now-c.t<0.3 then return c.r end
    local r=getRole(plr); roleCache[plr]={r=r,t=now}; return r
end
Players.PlayerRemoving:Connect(function(p) roleCache[p]=nil end)

-- ESP
local ESPFolder=Instance.new("Folder"); ESPFolder.Name="luxxsESP"; ESPFolder.Parent=gui
local espData={}
local function setLine(f,p1,p2,thick)
    local dx,dy=p2.X-p1.X,p2.Y-p1.Y
    f.Position=UDim2.new(0,(p1.X+p2.X)*0.5,0,(p1.Y+p2.Y)*0.5)
    f.Size=UDim2.new(0,math.sqrt(dx*dx+dy*dy),0,thick)
    f.Rotation=math.deg(math.atan2(dy,dx))
end
local BONES={{"Head","UpperTorso"},{"UpperTorso","LowerTorso"},{"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},{"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},{"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},{"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},{"Head","Torso"},{"Torso","Left Arm"},{"Torso","Right Arm"},{"Torso","Left Leg"},{"Torso","Right Leg"}}

local function createESP(plr)
    if espData[plr] or plr==LP then return end
    local d={}
    d.box=Instance.new("Frame"); d.box.BackgroundTransparency=1; d.box.BorderSizePixel=0; d.box.ZIndex=2; d.box.Parent=ESPFolder; d.boxStroke=stroke(d.box,ACC,1.2,0)
    local function mkLabel(size,font)
        local l=Instance.new("TextLabel"); l.BackgroundTransparency=1; l.Font=font or F_MONO; l.TextSize=size; l.TextColor3=WHITE; l.TextStrokeTransparency=0.4; l.TextStrokeColor3=Color3.new(0,0,0); l.Size=UDim2.new(0,260,0,size+2); l.TextXAlignment=Enum.TextXAlignment.Center; l.ZIndex=4; l.Parent=ESPFolder; return l
    end
    d.role=mkLabel(13,F_SEC); d.name=mkLabel(12); d.dist=mkLabel(11); d.held=mkLabel(11)
    d.tracer=Instance.new("Frame"); d.tracer.AnchorPoint=Vector2.new(0.5,0.5); d.tracer.BorderSizePixel=0; d.tracer.ZIndex=2; d.tracer.Parent=ESPFolder
    d.hpBg=Instance.new("Frame"); d.hpBg.BackgroundColor3=Color3.fromRGB(14,14,16); d.hpBg.BorderSizePixel=0; d.hpBg.ZIndex=3; d.hpBg.Parent=ESPFolder
    d.hpFill=Instance.new("Frame"); d.hpFill.AnchorPoint=Vector2.new(0,1); d.hpFill.BackgroundColor3=Color3.fromRGB(70,230,110); d.hpFill.BorderSizePixel=0; d.hpFill.Size=UDim2.new(1,0,1,0); d.hpFill.Position=UDim2.new(0,0,1,0); d.hpFill.ZIndex=4; d.hpFill.Parent=d.hpBg
    d.box3={}
    for i=1,12 do local f=Instance.new("Frame"); f.AnchorPoint=Vector2.new(0.5,0.5); f.BorderSizePixel=0; f.BackgroundColor3=WHITE; f.Visible=false; f.ZIndex=3; f.Parent=ESPFolder; d.box3[i]=f end
    d.skeleton={}
    for i=1,#BONES do local f=Instance.new("Frame"); f.AnchorPoint=Vector2.new(0.5,0.5); f.BorderSizePixel=0; f.BackgroundColor3=WHITE; f.Visible=false; f.ZIndex=3; f.Parent=ESPFolder; d.skeleton[i]=f end
    espData[plr]=d
end

local function removeESP(plr)
    local d=espData[plr]; if not d then return end
    for k,v in pairs(d) do
        if typeof(v)=="Instance" then pcall(function() v:Destroy() end)
        elseif type(v)=="table" then for _,o in pairs(v) do pcall(function() o:Destroy() end) end end
    end
    espData[plr]=nil
end

for _,plr in ipairs(Players:GetPlayers()) do if plr~=LP then createESP(plr) end end
Players.PlayerAdded:Connect(function(plr) task.wait(0.2); createESP(plr) end)
Players.PlayerRemoving:Connect(function(plr) removeESP(plr) end)

local function espAnyOn() return Flags["Visuals/ESP Box"] or Flags["Visuals/Held Item"] or Flags["Visuals/Role"] or Flags["Visuals/Name"] or Flags["Visuals/Health"] or Flags["Visuals/Distance"] or Flags["Visuals/Tracers"] or Flags["Visuals/Skeleton"] or Flags["Visuals/Chams"] or Flags["Visuals/Glow"] end

-- TAP PLAYER (ESP) -> TELEPORT
do
    local GuiService=game:GetService("GuiService")
    local pop=Instance.new("TextButton"); pop.Name="luxxsTapTP"; pop.AnchorPoint=Vector2.new(0.5,1); pop.Size=UDim2.new(0,190,0,34)
    pop.BackgroundColor3=Color3.fromRGB(16,16,20); pop.BackgroundTransparency=0.06; pop.BorderSizePixel=0; pop.AutoButtonColor=true
    pop.Font=F_SEC; pop.TextSize=14; pop.TextColor3=WHITE; pop.Text="TELEPORT"; pop.Visible=false; pop.ZIndex=60; pop.Parent=ESPFolder
    corner(pop,10); local popStroke=stroke(pop,ACC,1.5,0)
    local target,token=nil,0
    local function hide() pop.Visible=false; target=nil end
    pop.Activated:Connect(function()
        local plr=target; hide()
        if not plr then return end
        local r=plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        local me=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if r and me then
            me.CFrame=r.CFrame*CFrame.new(0,0,3); me.AssemblyLinearVelocity=Vector3.zero
            notify("Teleported to "..plr.Name)
        end
    end)
    track(UIS.InputBegan:Connect(function(input,gp)
        if gp then return end
        local ut=input.UserInputType
        if ut~=Enum.UserInputType.Touch and ut~=Enum.UserInputType.MouseButton1 then return end
        if not Flags["Visuals/Tap to Teleport"] then return end
        local px,py=input.Position.X,input.Position.Y
        local inset=0; pcall(function() inset=GuiService:GetGuiInset().Y end)
        local now=os.clock(); local best,bestArea,hitY
        for plr,d in pairs(espData) do
            if d.rt and now-d.rt<0.25 then
                for _,yy in ipairs({py,py+inset}) do
                    if px>=d.rx and px<=d.rx+d.rw and yy>=d.ry and yy<=d.ry+d.rh then
                        local a=d.rw*d.rh
                        if not best or a<bestArea then best,bestArea,hitY=plr,a,yy end
                    end
                end
            end
        end
        if not best then hide(); return end
        target=best; token+=1; local my=token
        local cam=workspace.CurrentCamera; local vpx=cam and cam.ViewportSize.X or 800
        pop.Text="TELEPORT  >  "..best.Name
        pop.Position=UDim2.new(0,math.clamp(px,100,vpx-100),0,math.max(hitY-26,44))
        popStroke.Color=ACC; pop.Visible=true
        task.delay(4,function() if token==my then hide() end end)
    end))
end

track(RunService.RenderStepped:Connect(function()
    local cam=workspace.CurrentCamera; if not cam then return end
    local vp=cam.ViewportSize; local t=os.clock()
    local anyOn=espAnyOn()
    for plr,d in pairs(espData) do
        local char=plr.Character; local hum=char and char:FindFirstChildOfClass("Humanoid"); local hrp=char and char:FindFirstChild("HumanoidRootPart")
        local visible=false; local minX,minY,maxX,maxY=math.huge,math.huge,-math.huge,-math.huge
        if char and hum and hrp and hum.Health>0 and anyOn then
            for _,p in ipairs(char:GetChildren()) do
                if p:IsA("BasePart") then
                    local sp,onS=cam:WorldToViewportPoint(p.Position)
                    if onS and sp.Z>0 then visible=true; minX=math.min(minX,sp.X-10); maxX=math.max(maxX,sp.X+10); minY=math.min(minY,sp.Y-10); maxY=math.max(maxY,sp.Y+10) end
                end
            end
        end
        if visible then
            local role=getRoleCached(plr); local rcol=ROLE_COLORS[role] or WHITE
            local ecol=Flags["Visuals/Color by Role"] and rcol or getColor(Flags["Visuals/ESP Color"],t,0)
            local w,h=maxX-minX,maxY-minY; local cx=(minX+maxX)*0.5
            d.rx,d.ry,d.rw,d.rh,d.rt=minX,minY,w,h,t; d.box.Visible=false; d.box.Position=UDim2.new(0,minX,0,minY); d.box.Size=UDim2.new(0,w,0,h); d.boxStroke.Color=ecol
            d.role.Visible=Flags["Visuals/Role"]; d.role.Text=string.upper(role); d.role.TextColor3=rcol; d.role.Position=UDim2.new(0,cx-130,0,minY-48)
            d.name.Visible=Flags["Visuals/Name"]; d.name.Text=plr.Name; d.name.TextColor3=ecol; d.name.Position=UDim2.new(0,cx-130,0,minY-32)
            local dist=(hrp.Position-cam.CFrame.Position).Magnitude
            d.dist.Visible=Flags["Visuals/Distance"]; d.dist.Text="["..math.floor(dist).."m]"; d.dist.Position=UDim2.new(0,cx-130,0,minY+h+2)
            do
                local tl=char:FindFirstChildOfClass("Tool")
                d.held.Visible=(Flags["Visuals/Held Item"] and tl~=nil) and true or false
                if tl then d.held.Text="["..tl.Name.."]"; d.held.TextColor3=Color3.fromRGB(255,214,120); d.held.Position=UDim2.new(0,cx-130,0,minY+h+14) end
            end
            d.hpBg.Visible=Flags["Visuals/Health"]; d.hpBg.Position=UDim2.new(0,minX-6,0,minY); d.hpBg.Size=UDim2.new(0,3,0,h); d.hpFill.Size=UDim2.new(1,0,math.clamp(hum.Health/hum.MaxHealth,0,1),0)
            d.tracer.Visible=Flags["Visuals/Tracers"]
            if d.tracer.Visible then d.tracer.BackgroundColor3=ecol; setLine(d.tracer,Vector2.new(vp.X*0.5,vp.Y),Vector2.new(cx,minY+h),1) end
            if Flags["Visuals/ESP Box"] then
                local look=hrp.CFrame.LookVector
                local yaw=math.atan2(-look.X,-look.Z)
                local bcf=CFrame.new(hrp.Position+Vector3.new(0,0.15,0))*CFrame.Angles(0,yaw,0)
                local hx,hy,hz=2,2.9,1.2
                local pts={}
                local n=0
                for xi=-1,1,2 do for yi=-1,1,2 do for zi=-1,1,2 do
                    n+=1; local sp3=cam:WorldToViewportPoint(bcf*Vector3.new(hx*xi,hy*yi,hz*zi))
                    pts[n]={Vector2.new(sp3.X,sp3.Y),sp3.Z>0}
                end end end
                local E={{1,2},{3,4},{5,6},{7,8},{1,3},{2,4},{5,7},{6,8},{1,5},{2,6},{3,7},{4,8}}
                for i,e in ipairs(E) do
                    local pa,pb=pts[e[1]],pts[e[2]]; local ln=d.box3[i]
                    if pa[2] and pb[2] then ln.Visible=true; ln.BackgroundColor3=ecol; setLine(ln,pa[1],pb[1],1.5) else ln.Visible=false end
                end
            else for _,ln in ipairs(d.box3) do ln.Visible=false end end
            local skelOn=Flags["Visuals/Skeleton"]
            for i,bone in ipairs(BONES) do
                local ln=d.skeleton[i]
                if skelOn then
                    local p1=char:FindFirstChild(bone[1]); local p2=char:FindFirstChild(bone[2])
                    if p1 and p2 then
                        local s1,o1=cam:WorldToViewportPoint(p1.Position); local s2,o2=cam:WorldToViewportPoint(p2.Position)
                        if o1 and o2 and s1.Z>0 and s2.Z>0 then ln.Visible=true; ln.BackgroundColor3=ecol; setLine(ln,Vector2.new(s1.X,s1.Y),Vector2.new(s2.X,s2.Y),1.5)
                        else ln.Visible=false end
                    else ln.Visible=false end
                else ln.Visible=false end
            end
        else
            d.box.Visible=false; d.role.Visible=false; d.name.Visible=false; d.dist.Visible=false; d.held.Visible=false; d.hpBg.Visible=false; d.tracer.Visible=false
            for _,ln in ipairs(d.skeleton) do ln.Visible=false end
            for _,ln in ipairs(d.box3) do ln.Visible=false end
        end
    end
end))

-- CHAMS / GLOW
do
local chamsMap={}
local function dropCham(plr) local h=chamsMap[plr]; if h then pcall(function() h:Destroy() end); chamsMap[plr]=nil end end
Players.PlayerRemoving:Connect(dropCham)
track(RunService.Heartbeat:Connect(function()
    local chams,glow=Flags["Visuals/Chams"],Flags["Visuals/Glow"]
    local t=os.clock()
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr~=LP then
            local char=plr.Character; local hum=char and char:FindFirstChildOfClass("Humanoid")
            if (chams or glow) and char and hum and hum.Health>0 then
                local h=chamsMap[plr]
                if not h or not h.Parent or h.Adornee~=char then
                    if h then pcall(function() h:Destroy() end) end
                    h=Instance.new("Highlight"); h.Name="luxxsCham"; h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop; h.Adornee=char
                    local ok=pcall(function() h.Parent=char end)
                    if not ok or not h.Parent then h.Parent=ESPFolder end
                    chamsMap[plr]=h
                end
                local col
                if Flags["Visuals/Color by Role"] then col=ROLE_COLORS[getRoleCached(plr)] or WHITE else col=getColor(Flags["Visuals/ESP Color"],t,0) end
                h.FillColor=col; h.OutlineColor=col
                h.FillTransparency=chams and math.clamp((Flags["Visuals/Chams Fill"] or 50)/100,0,1) or 1
                h.OutlineTransparency=glow and 0.1 or (chams and 0.55 or 1)
                h.Enabled=true
            else
                dropCham(plr)
            end
        end
    end
end))
end

-- GUN ESP
local GunESP,GunFolder,dropGunVisual
do
GunESP={set={},vis={}}
GunFolder=Instance.new("Folder"); GunFolder.Name="luxxsGun"; GunFolder.Parent=gui
local GUN_DROP_NAMES={GunDrop=true,["Gun Drop"]=true,DroppedGun=true,SheriffGun=true}
local function gunPartOf(o)
    if o:IsA("BasePart") and GUN_DROP_NAMES[o.Name] then return o end
    if o:IsA("Tool") and o.Parent==workspace and scanName(o.Name)=="Sheriff" then
        return o:FindFirstChild("Handle") or o:FindFirstChildWhichIsA("BasePart")
    end
    return nil
end
local function gunStillValid(p)
    if not p or not p.Parent then return false end
    if GUN_DROP_NAMES[p.Name] then return p:IsDescendantOf(workspace) end
    local tool=p.Parent
    return tool:IsA("Tool") and tool.Parent==workspace
end
local function addGun(o) local p=gunPartOf(o); if p then GunESP.set[p]=true end end
function dropGunVisual(p)
    local v=GunESP.vis[p]; if not v then return end
    pcall(function() v.hl:Destroy() end); pcall(function() v.bb:Destroy() end)
    GunESP.vis[p]=nil
end
for _,o in ipairs(workspace:GetDescendants()) do addGun(o) end
track(workspace.DescendantAdded:Connect(addGun))
track(workspace.DescendantRemoving:Connect(function(o) if GunESP.set[o] then GunESP.set[o]=nil; dropGunVisual(o) end end))

local function nearestGun()
    local hrp=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart"); if not hrp then return nil end
    local best,bd=nil,math.huge
    for p in pairs(GunESP.set) do
        if gunStillValid(p) then
            local d=(p.Position-hrp.Position).Magnitude
            if d<bd then best,bd=p,d end
        end
    end
    return best
end

track(RunService.RenderStepped:Connect(function()
    local on=Flags["Visuals/Gun ESP"]
    local cam=workspace.CurrentCamera
    local t=os.clock()
    for p in pairs(GunESP.set) do
        if not gunStillValid(p) then
            GunESP.set[p]=nil; dropGunVisual(p)
        elseif on then
            local v=GunESP.vis[p]
            if not v then
                local hl=Instance.new("Highlight"); hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop; hl.FillTransparency=0.35; hl.OutlineTransparency=0; hl.Adornee=p; hl.Parent=GunFolder
                local bb=Instance.new("BillboardGui"); bb.AlwaysOnTop=true; bb.Size=UDim2.new(0,120,0,34); bb.StudsOffset=Vector3.new(0,2.5,0); bb.Adornee=p; bb.Parent=GunFolder
                local l=Instance.new("TextLabel"); l.BackgroundTransparency=1; l.Size=UDim2.new(1,0,1,0); l.Font=F_MONO; l.TextSize=13; l.TextStrokeTransparency=0.3; l.TextStrokeColor3=Color3.new(0,0,0); l.Text="GUN"; l.Parent=bb
                v={hl=hl,bb=bb,lbl=l}; GunESP.vis[p]=v
            end
            local col=getColor(Flags["Visuals/Gun Color"] or "Gold",t,0)
            v.hl.FillColor=col; v.hl.OutlineColor=col; v.lbl.TextColor3=col
            local dist=cam and math.floor((p.Position-cam.CFrame.Position).Magnitude) or 0
            v.lbl.Text="GUN ["..dist.."m]"
        else
            dropGunVisual(p)
        end
    end
end))

function teleportToGun()
    local p=nearestGun()
    if not p then notify("Gun not found") return end
    local hrp=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    hrp.CFrame=CFrame.new(p.Position+Vector3.new(0,3,0))
    hrp.AssemblyLinearVelocity=Vector3.zero
    notify("Teleported to gun")
end
end

-- AIM PARTS
local AIM_PARTS_DATA={
    {name="Head",x=33,y=12,w=24,h=24,r=12,dx=45,dy=24},
    {name="Chest",x=27,y=43,w=36,h=30,r=4,dx=45,dy=58},
    {name="Stomach",x=30,y=73,w=30,h=30,r=3,dx=45,dy=88},
    {name="Left Arm",x=12,y=45,w=13,h=60,r=5,dx=18,dy=75},
    {name="Right Arm",x=65,y=45,w=13,h=60,r=5,dx=72,dy=75},
    {name="Left Leg",x=25,y=104,w=18,h=62,r=5,dx=34,dy=135},
    {name="Right Leg",x=47,y=104,w=18,h=62,r=5,dx=56,dy=135}}
local AIM_NAMES={} for i,a in ipairs(AIM_PARTS_DATA) do AIM_NAMES[i]=a.name end

local function resolveBodyPart(char,name)
    if not char then return nil end
    if name=="Head" then return char:FindFirstChild("Head") end
    if name=="Chest" then return char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") end
    if name=="Stomach" then return char:FindFirstChild("LowerTorso") or char:FindFirstChild("Torso") end
    if name=="Left Arm" then return char:FindFirstChild("LeftUpperArm") or char:FindFirstChild("Left Arm") end
    if name=="Right Arm" then return char:FindFirstChild("RightUpperArm") or char:FindFirstChild("Right Arm") end
    if name=="Left Leg" then return char:FindFirstChild("LeftUpperLeg") or char:FindFirstChild("Left Leg") end
    if name=="Right Leg" then return char:FindFirstChild("RightUpperLeg") or char:FindFirstChild("Right Leg") end
    return char:FindFirstChild("Head")
end

local function hasWeapon()
    local char=LP.Character
    if not char then return false end
    for _,obj in ipairs(char:GetChildren()) do
        if obj:IsA("Tool") then
            local n=string.lower(obj.Name)
            if n:find("knife") or n:find("murder") or n:find("gun") or n:find("revolver") or n:find("pistol") or n:find("sheriff") then return true end
        end
    end
    return false
end

local rayParams=RaycastParams.new()
do
    local ok=pcall(function() rayParams.FilterType=Enum.RaycastFilterType.Exclude end)
    if not ok then pcall(function() rayParams.FilterType=Enum.RaycastFilterType.Blacklist end) end
end
local function hasLineOfSight(fromPos,targetChar,targetPos)
    rayParams.FilterDescendantsInstances={LP.Character}
    local result=workspace:Raycast(fromPos,targetPos-fromPos,rayParams)
    if not result then return true end
    return result.Instance:IsDescendantOf(targetChar)
end

-- AIMBOT
local Shoot={log={}}
do
local VIM=nil
pcall(function() VIM=game:GetService("VirtualInputManager") end)

local fovCircle=Instance.new("Frame"); fovCircle.AnchorPoint=Vector2.new(0.5,0.5); fovCircle.Position=UDim2.new(0.5,0,0.5,0); fovCircle.BackgroundTransparency=1; fovCircle.BorderSizePixel=0; fovCircle.Visible=false; fovCircle.ZIndex=2; fovCircle.Parent=gui; corner(fovCircle,9999)
local fovStroke=stroke(fovCircle,ACC,2,0.1); T(fovStroke,"Color"); fovCircle.BackgroundTransparency=1
local fovLbl=Instance.new("TextLabel"); fovLbl.BackgroundTransparency=1; fovLbl.AnchorPoint=Vector2.new(0.5,1); fovLbl.Position=UDim2.new(0.5,0,0,-4); fovLbl.Size=UDim2.new(0,180,0,14); fovLbl.Font=F_MONO; fovLbl.TextSize=11; fovLbl.TextColor3=WHITE; fovLbl.TextStrokeTransparency=0.4; fovLbl.Parent=fovCircle

local function getFovRadiusPx() local cam=workspace.CurrentCamera; if not cam then return 200 end; return ((Flags["Aimbot/FOV"] or 120)/180)*math.min(cam.ViewportSize.X,cam.ViewportSize.Y) end

local function findAimbotTarget(ignoreFov)
    local cam=workspace.CurrentCamera; if not cam then return nil end
    local center=Vector2.new(cam.ViewportSize.X*0.5,cam.ViewportSize.Y*0.5)
    local radius=getFovRadiusPx()
    local partName=Flags["Aimbot/Body Part"] or "Head"
    local best,bestDist=nil,math.huge
    local origin=cam.CFrame.Position
    local skipInno=Flags["Aimbot/Skip Innocents"]
    local wall=true
    local myRole=getRoleCached(LP)
    do
        local mc=LP.Character
        if mc then for _,t in ipairs(mc:GetChildren()) do if t:IsA("Tool") then local hr=scanName(t.Name); if hr then myRole=hr end end end end
    end
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr~=LP then
            local char=plr.Character; local hum=char and char:FindFirstChildOfClass("Humanoid")
            if char and hum and hum.Health>0 then
                local ok=true
                if skipInno then
                    local r=getRoleCached(plr)
                    if myRole~="Murderer" and (r=="Innocent" or r==myRole) then ok=false end
                end
                if ok then
                    local part=resolveBodyPart(char,partName)
                    if part then
                        local sp=cam:WorldToViewportPoint(part.Position)
                        if sp.Z>0 then
                            local dist=(Vector2.new(sp.X,sp.Y)-center).Magnitude
                            if (ignoreFov or dist<=radius) and dist<bestDist then
                                if (not wall) or hasLineOfSight(origin,char,part.Position) then best,bestDist={player=plr,part=part,char=char},dist end
                            end
                        end
                    end
                end
            end
        end
    end
    return best
end

Shoot.findAim=function() return findAimbotTarget(false) or findAimbotTarget(true) end
local aimLastShot=0
local function clickCenter()
    if UIS.TouchEnabled or not VIM then return end -- virtual mouse clicks hide the mobile joystick
    local cam=workspace.CurrentCamera; if not cam then return end
    local vp=cam.ViewportSize
    pcall(function() VIM:SendMouseButtonEvent(vp.X*0.5,vp.Y*0.5,0,true,game,0) end)
    task.wait(0.01)
    pcall(function() VIM:SendMouseButtonEvent(vp.X*0.5,vp.Y*0.5,0,false,game,0) end)
end

local function getEquippedWeaponTool()
    local char=LP.Character; if not char then return nil end
    for _,t in ipairs(char:GetChildren()) do
        if t:IsA("Tool") then
            local n=string.lower(t.Name)
            if n:find("knife") or n:find("murder") or n:find("gun") or n:find("revolver") or n:find("pistol") or n:find("sheriff") then return t end
        end
    end
    return nil
end

track(RunService.RenderStepped:Connect(function(dt)
    local cam=workspace.CurrentCamera; if not cam then return end
    local showFov=Flags["Aimbot/Enable"] and Flags["Aimbot/Show FOV"]
    fovCircle.Visible=showFov and true or false
    if showFov then
        local rr=getFovRadiusPx()
        fovCircle.Size=UDim2.new(0,rr*2,0,rr*2)
        fovLbl.Visible=false
    end
    if not Flags["Aimbot/Enable"] then return end
    if Flags["Aimbot/Weapon Only"] and not hasWeapon() then return end
    local target=findAimbotTarget()
    if target then
        local smooth=0.3
        local alpha=math.clamp(1-smooth,0.03,1)*math.min(1,dt*60)
        if not Flags["Aimbot/Silent Aim"] then cam.CFrame=cam.CFrame:Lerp(CFrame.new(cam.CFrame.Position,target.part.Position),alpha) end
        if Flags["Aimbot/Auto Shoot"] then
            local tool=getEquippedWeaponTool()
            if tool then
                local tn=string.lower(tool.Name)
                local isKnife=tn:find("knife") or tn:find("murder")
                local now=os.clock()
                local delay=(Flags["Aimbot/Shoot Delay (ms)"] or 100)/1000
                if now-aimLastShot>=delay then
                    aimLastShot=now
                    pcall(function() tool:Activate() end)
                    if not isKnife then clickCenter(); if (not Flags["Aimbot/Silent Aim"]) and Shoot.fireGun then Shoot.fireGun(tool,target.part.Position) end end
                end
            end
        end
    end
end))
end

-- FARM
local Farm={Depth=8,Enabled=false,Mode="Under Map",Speed=80,TeleportDelay=0.15,AntiAFK=false,ReturnOnFinish=false,ReturnPos=nil,LoopThread=nil,Collected=0,Status="idle"}
local setAntiAFK,disableFly,enableFly,setNoclip,startFarm,stopFarm
do
local antiAfkConn=nil
function setAntiAFK(on)
    if antiAfkConn then antiAfkConn:Disconnect(); antiAfkConn=nil end
    if not on then return end
    antiAfkConn=LP.Idled:Connect(function() VU:CaptureController(); VU:ClickButton2(Vector2.new()) end)
end
local coinSet,coinConns={}, {}
local function isCoin(o) return o:IsA("BasePart") and (o.Name=="Coin" or o.Name:find("Coin") or o.Name:find("coin")) end
local function startCoinCache()
    for _,c in ipairs(coinConns) do c:Disconnect() end
    coinConns={}; coinSet={}
    for _,o in ipairs(workspace:GetDescendants()) do if isCoin(o) then coinSet[o]=true end end
    coinConns[1]=workspace.DescendantAdded:Connect(function(o) if isCoin(o) then coinSet[o]=true end end)
    coinConns[2]=workspace.DescendantRemoving:Connect(function(o)
        if coinSet[o] then
            coinSet[o]=nil
            local hrp=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if Farm.Enabled and hrp and (hrp.Position-o.Position).Magnitude<12 then Farm.Collected+=1 end
        end
    end)
end
local function getNearestCoin(pos,skip)
    local best,bestDist,now=nil,math.huge,os.clock()
    for p in pairs(coinSet) do
        if p.Parent and not (skip[p] and skip[p]>now) then
            local d=(p.Position-pos).Magnitude
            if d<bestDist then best,bestDist=p,d end
        end
    end
    return best
end
local flyConn,flyBodyVel,flyBodyGyro=nil,nil,nil
function disableFly()
    if flyConn then flyConn:Disconnect(); flyConn=nil end
    local char=LP.Character
    if char then
        local hrp=char:FindFirstChild("HumanoidRootPart")
        if hrp then
            if flyBodyVel then flyBodyVel:Destroy(); flyBodyVel=nil end
            if flyBodyGyro then flyBodyGyro:Destroy(); flyBodyGyro=nil end
        end
    end
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    if hum then hum.PlatformStand=false end
end
function enableFly()
    disableFly()
    local char=LP.Character
    local hrp=char and char:FindFirstChild("HumanoidRootPart")
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end
    flyBodyVel=Instance.new("BodyVelocity"); flyBodyVel.MaxForce=Vector3.new(9e9,9e9,9e9); flyBodyVel.Velocity=Vector3.zero; flyBodyVel.Parent=hrp
    flyBodyGyro=Instance.new("BodyGyro"); flyBodyGyro.MaxTorque=Vector3.new(9e9,9e9,9e9); flyBodyGyro.P=2000; flyBodyGyro.CFrame=hrp.CFrame; flyBodyGyro.Parent=hrp
    hum.PlatformStand=true
    local cam=workspace.CurrentCamera
    flyConn=RunService.RenderStepped:Connect(function()
        if not Farm.Enabled or not hrp or not hrp.Parent then return end
        local moveDir=Vector3.zero
        local look=cam.CFrame.LookVector; local right=cam.CFrame.RightVector
        if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir+=look end
        if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir-=look end
        if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir-=right end
        if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir+=right end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then moveDir+=Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir-=Vector3.new(0,1,0) end
        if moveDir.Magnitude>0 then moveDir=moveDir.Unit end
        flyBodyVel.Velocity=moveDir*Farm.Speed
        flyBodyGyro.CFrame=cam.CFrame
    end)
end
local noclipConn=nil
function setNoclip(on)
    if noclipConn then noclipConn:Disconnect(); noclipConn=nil end
    if not on then
        local char=LP.Character
        if char then for _,p in ipairs(char:GetDescendants()) do if p:IsA("BasePart") then pcall(function() p.CanCollide=true end) end end end
        return
    end
    noclipConn=RunService.Stepped:Connect(function()
        if not Farm.Enabled then return end
        local char=LP.Character; if not char then return end
        for _,p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") and p.CanCollide then pcall(function() p.CanCollide=false end) end
        end
    end)
end
local function teleportTo(pos)
    local char=LP.Character; local hrp=char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    hrp.CFrame=CFrame.new(pos+Vector3.new(0,3,0)); return true
end
function startFarm()
    if Farm.LoopThread then return end
    local hrp0=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if Farm.ReturnOnFinish and hrp0 then Farm.ReturnPos=hrp0.CFrame end
    Farm.LoopThread=task.spawn(function()
        startCoinCache()
        local skip={}
        local cur=nil
        local tries={}
        local lastCollect=0
        while Farm.Enabled do
            local dt=RunService.Heartbeat:Wait()
            local now=os.clock()
            local char=LP.Character
            local hrp=char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local tooFast = Farm.Mode=="Teleport" and (now-lastCollect)<0.13
                if tooFast then Farm.Status="cooldown"; task.wait(0.05)
                else
                    local coin
                    if (Farm.Mode=="Smooth" or Farm.Mode=="Under Map") and cur and cur.Parent and coinSet[cur] and not (skip[cur] and skip[cur]>now) then coin=cur
                    else coin=getNearestCoin(hrp.Position,skip); cur=coin end
                    if coin then
                        Farm.Status="to coin"
                        local target=coin.Position
                        if Farm.Mode=="Teleport" then
                            hrp.CFrame=CFrame.new(target)
                            hrp.AssemblyLinearVelocity=Vector3.zero
                            if type(firetouchinterest)=="function" then
                                pcall(firetouchinterest,hrp,coin,0)
                                pcall(firetouchinterest,hrp,coin,1)
                            end
                            if Farm.TeleportDelay>0 then task.wait(Farm.TeleportDelay) end
                            lastCollect=os.clock()
                        else
                            local under=(Farm.Mode=="Under Map")
                            local smooth=(Farm.Mode=="Smooth") or under
                            local goal=under and Vector3.new(target.X,target.Y-Farm.Depth,target.Z) or target
                            local d=goal-hrp.Position
                            local dist=d.Magnitude
                            local spd=Farm.Speed
                            if smooth then spd=math.min(Farm.Speed,math.max(12,dist*6)) end
                            local step=spd*dt
                            local npos=(dist<=step or dist<0.01) and goal or (hrp.Position+d.Unit*step)
                            local rot=hrp.CFrame.Rotation
                            if smooth and (d.X*d.X+d.Z*d.Z)>1 then
                                rot=rot:Lerp(CFrame.lookAt(Vector3.zero,Vector3.new(d.X,0,d.Z)),math.min(1,dt*10))
                            end
                            hrp.CFrame=CFrame.new(npos)*rot
                            hrp.AssemblyLinearVelocity=Vector3.zero
                            local flat=math.sqrt((target.X-hrp.Position.X)^2+(target.Z-hrp.Position.Z)^2)
                            if under then
                                if flat<3 then
                                    if type(firetouchinterest)=="function" then
                                        pcall(firetouchinterest,hrp,coin,0)
                                        pcall(firetouchinterest,hrp,coin,1)
                                    end
                                    local st=tries[coin]; if not st then st=os.clock(); tries[coin]=st end
                                    local el=os.clock()-st
                                    if el>0.3 and el<0.45 then hrp.CFrame=CFrame.new(target)*rot end
                                    if el>=0.6 then skip[coin]=os.clock()+8; tries[coin]=nil end
                                end
                            elseif dist<4 and type(firetouchinterest)=="function" then
                                pcall(firetouchinterest,hrp,coin,0)
                                pcall(firetouchinterest,hrp,coin,1)
                            end
                        end
                        if Farm.Mode~="Under Map" and (hrp.Position-target).Magnitude<(Farm.Mode=="Smooth" and 1.2 or 4) then skip[coin]=os.clock()+8 end
                    else Farm.Status="no coins"; task.wait(0.2) end
                end
            end
        end
        if Farm.ReturnOnFinish and Farm.ReturnPos then teleportTo(Farm.ReturnPos.Position) end
        Farm.Status="idle"
    end)
end
function stopFarm()
    Farm.Enabled=false
    if Farm.LoopThread then pcall(function() task.cancel(Farm.LoopThread) end); Farm.LoopThread=nil end
    for _,c in ipairs(coinConns) do c:Disconnect() end
    coinConns={}
    disableFly(); setNoclip(false)
end
end

-- FLY + NOCLIP
local Move={Fly=false,Speed=60,Noclip=false}
local flyUpBtn,flyDownBtn,disableFlyMove,setNoclipMove
do
local mvConn,mvVel,mvGyro,mvControls=nil,nil,nil,nil
local upHeld,downHeld=false,false
local function mkFlyBtn(txt,yOff)
    local b=Instance.new("TextButton"); b.AnchorPoint=Vector2.new(1,0.5); b.Position=UDim2.new(1,-24,0.5,yOff); b.Size=UDim2.new(0,54,0,44)
    b.BackgroundColor3=C.bg; b.BackgroundTransparency=0.1; b.BorderSizePixel=0; b.Text=txt; b.Font=F_MONO; b.TextSize=14; b.TextColor3=C.text
    b.AutoButtonColor=false; b.Visible=false; b.ZIndex=5; b.Parent=gui
    local s=stroke(b,ACC,1.5,0); T(s,"Color"); return b
end
flyUpBtn,flyDownBtn=mkFlyBtn("UP",-28),mkFlyBtn("DN",28)
local function bindHold(b,setter)
    b.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then setter(true); b.BackgroundColor3=ACC; b.TextColor3=C.bg end end)
    b.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then setter(false); b.BackgroundColor3=C.bg; b.TextColor3=C.text end end)
end
bindHold(flyUpBtn,function(v) upHeld=v end)
bindHold(flyDownBtn,function(v) downHeld=v end)
local function getMoveVector()
    if mvControls then
        local ok,v=pcall(function() return mvControls:GetMoveVector() end)
        if ok and typeof(v)=="Vector3" then return v end
    end
    local hum=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    local cam=workspace.CurrentCamera
    if hum and cam then return cam.CFrame:VectorToObjectSpace(hum.MoveDirection) end
    return Vector3.zero
end
function disableFlyMove()
    if mvConn then mvConn:Disconnect(); mvConn=nil end
    if mvVel then pcall(function() mvVel:Destroy() end); mvVel=nil end
    if mvGyro then pcall(function() mvGyro:Destroy() end); mvGyro=nil end
    local hum=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.PlatformStand=false; pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end) end
end
enableFlyMove=function()
    disableFlyMove()
    local char=LP.Character
    local hrp=char and char:FindFirstChild("HumanoidRootPart")
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end
    if not mvControls then
        pcall(function()
            local pm=LP:FindFirstChild("PlayerScripts") and LP.PlayerScripts:FindFirstChild("PlayerModule")
            if pm then mvControls=require(pm):GetControls() end
        end)
    end
    mvVel=Instance.new("BodyVelocity"); mvVel.MaxForce=Vector3.new(9e9,9e9,9e9); mvVel.Velocity=Vector3.zero; mvVel.Parent=hrp
    mvGyro=Instance.new("BodyGyro"); mvGyro.MaxTorque=Vector3.new(9e9,9e9,9e9); mvGyro.P=9e4; mvGyro.D=800; mvGyro.CFrame=hrp.CFrame; mvGyro.Parent=hrp
    hum.PlatformStand=true
    mvConn=RunService.RenderStepped:Connect(function()
        if not hrp.Parent then return end
        local cam=workspace.CurrentCamera; if not cam then return end
        local mv=getMoveVector()
        local dir=cam.CFrame:VectorToWorldSpace(Vector3.new(mv.X,0,mv.Z))
        if UIS:IsKeyDown(Enum.KeyCode.W) and mv.Magnitude==0 then dir+=cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) or UIS:IsKeyDown(Enum.KeyCode.E) or upHeld then dir+=Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) or UIS:IsKeyDown(Enum.KeyCode.Q) or downHeld then dir-=Vector3.new(0,1,0) end
        if dir.Magnitude>1 then dir=dir.Unit end
        mvVel.Velocity=dir*Move.Speed
        local look=cam.CFrame.LookVector
        if Vector3.new(look.X,0,look.Z).Magnitude>0.01 then
            mvGyro.CFrame=CFrame.lookAt(hrp.Position,hrp.Position+Vector3.new(look.X,0,look.Z))
        end
    end)
end
local ncConn,ncTouched=nil,{}
function setNoclipMove(on)
    if ncConn then ncConn:Disconnect(); ncConn=nil end
    if on then
        ncConn=RunService.Stepped:Connect(function()
            local char=LP.Character; if not char then return end
            for _,p in ipairs(char:GetDescendants()) do
                if p:IsA("BasePart") and p.CanCollide then ncTouched[p]=true; p.CanCollide=false end
            end
        end)
    else
        for p in pairs(ncTouched) do if p.Parent then pcall(function() p.CanCollide=true end) end end
        ncTouched={}
    end
end
end

-- AUTO WIN
local AutoWin={Enabled=false,Teleport=true,AutoEquip=true,Delay=0.2,Thread=nil,Status="idle"}
local startAutoWin,stopAutoWin
do
local VIM=nil
pcall(function() VIM=game:GetService("VirtualInputManager") end)
local function isWeaponTool(t)
    local n=string.lower(t.Name)
    return (n:find("knife")~=nil) or (n:find("gun")~=nil) or (n:find("revolver")~=nil) or (n:find("pistol")~=nil) or (n:find("sheriff")~=nil) or (n:find("murder")~=nil)
end
local function isKnife(t) local n=string.lower(t.Name); return n:find("knife") or n:find("murder") end
local function getEquippedWeapon()
    local char=LP.Character; if not char then return nil end
    local t=char:FindFirstChildOfClass("Tool")
    if t and isWeaponTool(t) then return t end
    return nil
end
local function equipWeapon()
    local char=LP.Character; if not char then return nil end
    local hum=char:FindFirstChildOfClass("Humanoid"); if not hum then return nil end
    local current=getEquippedWeapon(); if current then return current end
    local bp=LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack")
    if not bp then return nil end
    for _,t in ipairs(bp:GetChildren()) do
        if t:IsA("Tool") and isWeaponTool(t) then
            pcall(function() hum:EquipTool(t) end); task.wait(0.25)
            return getEquippedWeapon() or t
        end
    end
    return nil
end
local function isAlive(plr)
    local c=plr and plr.Character
    local h=c and c:FindFirstChildOfClass("Humanoid")
    local r=c and c:FindFirstChild("HumanoidRootPart")
    if c and h and r and h.Health>0 then return c,h,r end
    return nil
end
local function findTarget(myRole)
    local _,_,myRoot=isAlive(LP); if not myRoot then return nil end
    local best,bestScore=nil,math.huge
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr~=LP then
            local c,h,r=isAlive(plr)
            if c and MM2State.have and not MM2State.active[plr.Name] then c=nil end
            if c then
                local role=getRoleCached(plr); local score=nil
                if myRole=="Murderer" then score=(role=="Sheriff") and 0 or 1
                elseif myRole=="Sheriff" then if role=="Murderer" then score=0 end end
                if score then
                    local combined=score*100000+(r.Position-myRoot.Position).Magnitude
                    if combined<bestScore then bestScore=combined; best={plr=plr,char=c,hum=h,root=r,role=role} end
                end
            end
        end
    end
    return best
end
local function myOrigin()
    local c=LP.Character; local h=c and (c:FindFirstChild("Head") or c:FindFirstChild("HumanoidRootPart"))
    return h and h.Position or Vector3.zero
end
local function aimPos(char)
    local r=char:FindFirstChild("HumanoidRootPart"); local head=char:FindFirstChild("Head") or r
    if not head then return Vector3.zero end
    local ping=0.08; pcall(function() ping=LP:GetNetworkPing() end)
    local v=r and r.AssemblyLinearVelocity or Vector3.zero
    return head.Position+Vector3.new(v.X,0,v.Z)*(ping+0.05)
end
local rsShoot,rsShootT={},0
local function sharedShootRemotes()
    local now=os.clock()
    if now-rsShootT>10 then
        rsShootT=now; rsShoot={}
        pcall(function()
            for _,d in ipairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
                if d:IsA("RemoteEvent") then
                    local n=string.lower(d.Name)
                    if n:find("shoot") or n:find("gunfire") then rsShoot[#rsShoot+1]=d end
                end
            end
        end)
    end
    return rsShoot
end
local function fireRemotes(tool,pos,targetChar)
    local cf=CFrame.new(pos)
    local ocf=(myOrigin()-pos).Magnitude>0.1 and CFrame.new(myOrigin(),pos) or cf
    for _,d in ipairs(tool:GetDescendants()) do
        if d:IsA("RemoteEvent") then
            pcall(function() d:FireServer(ocf,cf) end)
            pcall(function() d:FireServer(cf) end)
            pcall(function() d:FireServer(pos) end)
            pcall(function() d:FireServer(1,cf,"AH2") end)
            pcall(function() d:FireServer(1,pos,"AH2") end)
            pcall(function() d:FireServer(targetChar) end)
        elseif d:IsA("RemoteFunction") then
            task.spawn(function()
                pcall(function() d:InvokeServer(1,pos,"AH2") end)
                pcall(function() d:InvokeServer(ocf,cf) end)
                pcall(function() d:InvokeServer(cf) end)
                pcall(function() d:InvokeServer(pos) end)
            end)
        end
    end
    for _,d in ipairs(sharedShootRemotes()) do pcall(function() d:FireServer(ocf,cf) end) end
end
local function fireGun(tool,pos)
    local cf=CFrame.new(pos)
    local ocf=(myOrigin()-pos).Magnitude>0.1 and CFrame.new(myOrigin(),pos) or cf
    for _,d in ipairs(tool:GetDescendants()) do
        if d:IsA("RemoteFunction") then
            task.spawn(function() pcall(function() d:InvokeServer(1,pos,"AH2") end) end)
        elseif d:IsA("RemoteEvent") then
            pcall(function() d:FireServer(ocf,cf) end)
        end
    end
    for _,d in ipairs(sharedShootRemotes()) do pcall(function() d:FireServer(ocf,cf) end) end
end
local function touchKill(tool,targetChar)
    if type(firetouchinterest)~="function" then return end
    local handle=tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart")
    if not handle then return end
    for _,p in ipairs(targetChar:GetChildren()) do
        if p:IsA("BasePart") then
            pcall(firetouchinterest,handle,p,0)
            pcall(firetouchinterest,handle,p,1)
        end
    end
end
local function clickAt(vec2)
    if not VIM or UIS.TouchEnabled then return end -- virtual mouse clicks hide the mobile joystick
    pcall(function() VIM:SendMouseButtonEvent(vec2.X,vec2.Y,0,true,game,0) end)
    task.wait(0.01)
    pcall(function() VIM:SendMouseButtonEvent(vec2.X,vec2.Y,0,false,game,0) end)
end
local function aimAt(target)
    local cam=workspace.CurrentCamera; if not cam then return end
    cam.CFrame=CFrame.lookAt(cam.CFrame.Position,target)
end
local function step()
    local _,_,hrp=isAlive(LP); if not hrp then AutoWin.Status="waiting"; return end
    local myRole=getRoleCached(LP)
    if myRole~="Murderer" and myRole~="Sheriff" then AutoWin.Status="innocent"; return end
    local target=findTarget(myRole); if not target then AutoWin.Status="no targets"; return end
    local tool=AutoWin.AutoEquip and equipWeapon() or getEquippedWeapon()
    if not tool then AutoWin.Status="no weapon"; return end
    local cam=workspace.CurrentCamera
    local tRoot=target.root
    local tHead=target.char:FindFirstChild("Head") or tRoot
    local isKnifeW=isKnife(tool)
    AutoWin.Status=(myRole=="Sheriff" and "shoot " or "stab ")..target.plr.Name
    if AutoWin.Teleport then
        if isKnifeW then hrp.CFrame=tRoot.CFrame*CFrame.new(0,0,1.8)
        else
            local back=tRoot.CFrame*CFrame.new(0,0.5,6)
            hrp.CFrame=CFrame.lookAt(back.Position,tHead.Position)
        end
        hrp.AssemblyLinearVelocity=Vector3.zero
        task.wait(0.05)
    end
    if not Flags["Aimbot/Silent Aim"] then aimAt(tHead.Position) end
    task.wait(0.02)
    if isKnifeW then
        touchKill(tool,target.char)
        pcall(function() tool:Activate() end)
        fireRemotes(tool,tRoot.Position,target.char)
        task.wait(0.05)
        local hum=target.char:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health>0 then
            touchKill(tool,target.char)
            pcall(function() tool:Activate() end)
        end
    else
        pcall(function() tool:Activate() end)
        fireGun(tool,aimPos(target.char))
        fireRemotes(tool,aimPos(target.char),target.char)
        if cam then local vp=cam.ViewportSize; clickAt(Vector2.new(vp.X*0.5,vp.Y*0.5)) end
        task.wait(0.02)
        fireRemotes(tool,aimPos(target.char),target.char)
        pcall(function() tool:Activate() end)
        task.wait(0.05)
        local hum=target.char:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health>0 and cam then
            local vp=cam.ViewportSize
            clickAt(Vector2.new(vp.X*0.5,vp.Y*0.5))
            fireRemotes(tool,aimPos(target.char),target.char)
        end
    end
    task.wait(0.15)
end
local function autoWinLoop()
    while AutoWin.Enabled do
        local ok,err=pcall(step)
        if not ok then AutoWin.Status="err: "..tostring(err) end
        task.wait(AutoWin.Delay)
    end
    AutoWin.Status="idle"
end
function startAutoWin() AutoWin.Enabled=true; if not AutoWin.Thread then AutoWin.Thread=task.spawn(autoWinLoop) end end
function stopAutoWin() AutoWin.Enabled=false; if AutoWin.Thread then pcall(function() task.cancel(AutoWin.Thread) end); AutoWin.Thread=nil end; AutoWin.Status="idle" end
local hooked=setmetatable({},{__mode="k"})
local function assistShot(tool)
    if Shoot.hookActive then return end
    local isK=isKnife(tool) and true or false
    local pos,ch,tg
    if Flags["Aimbot/Enable"] and Flags["Aimbot/Silent Aim"] and Shoot.findAim then
        tg=Shoot.findAim()
        if tg then
            local r=tg.char:FindFirstChild("HumanoidRootPart"); local ping=0.08; pcall(function() ping=LP:GetNetworkPing() end)
            local v=r and r.AssemblyLinearVelocity or Vector3.zero
            local dist=(tg.part.Position-myOrigin()).Magnitude
            local lead=ping+0.05+(isK and dist/110 or 0)
            pos=tg.part.Position+Vector3.new(v.X,0,v.Z)*lead; ch=tg.char
        end
    end
    if not pos and not isK and Flags["Aimbot/Shot Assist"] then
        local t=findTarget("Sheriff")
        if t then pos=aimPos(t.char); ch=t.char end
    end
    if not pos then return end
    if isK then
        fireRemotes(tool,pos,ch)
        if ch and (pos-myOrigin()).Magnitude<12 then touchKill(tool,ch) end
        return
    end
    fireGun(tool,pos); fireRemotes(tool,pos,ch)
end
local function hookTool(t)
    if hooked[t] or not t:IsA("Tool") then return end
    if not isWeaponTool(t) then return end
    hooked[t]=true
    t.Activated:Connect(function() assistShot(t) end)
end
local function hookChar(c)
    for _,t in ipairs(c:GetChildren()) do hookTool(t) end
    track(c.ChildAdded:Connect(hookTool))
end
if LP.Character then hookChar(LP.Character) end
track(LP.CharacterAdded:Connect(hookChar))
Shoot.debug=function()
    local out={}
    out[#out+1]="role: "..tostring(getRoleCached(LP)).." hook: "..tostring(Shoot.hookActive)
    local t=findTarget("Sheriff"); out[#out+1]="murderer: "..(t and t.plr.Name or "none")
    local tool=getEquippedWeapon()
    if not tool then
        local bp=LP:FindFirstChildOfClass("Backpack")
        if bp then for _,x in ipairs(bp:GetChildren()) do if x:IsA("Tool") and isWeaponTool(x) then tool=x; break end end end
    end
    out[#out+1]="tool: "..(tool and tool.Name or "none")
    if tool then for _,d in ipairs(tool:GetDescendants()) do if d:IsA("RemoteEvent") or d:IsA("RemoteFunction") then out[#out+1]=d.ClassName..": "..d:GetFullName() end end end
    for _,d in ipairs(sharedShootRemotes()) do out[#out+1]="shared: "..d:GetFullName() end
    local txt=table.concat(out,"\n")
    if type(setclipboard)=="function" then pcall(setclipboard,txt) end
    notify(out[1].." | "..out[2].." | "..out[3].." (full info copied)")
end
-- SILENT AIM HOOK: rewrites the target of the game's own shot / knife throw
__safe("silent aim hook",function()
local hm,gnm,ccf=hookmetamethod,getnamecallmethod,checkcaller
if type(hm)=="function" and type(gnm)=="function" then
    local function pickTarget(isK)
        local tg
        if Flags["Aimbot/Enable"] and Flags["Aimbot/Silent Aim"] and Shoot.findAim then tg=Shoot.findAim() end
        if tg then
            local r=tg.char:FindFirstChild("HumanoidRootPart"); local ping=0.08; pcall(function() ping=LP:GetNetworkPing() end)
            local v=r and r.AssemblyLinearVelocity or Vector3.zero
            local dist=(tg.part.Position-myOrigin()).Magnitude
            return tg.part.Position+Vector3.new(v.X,0,v.Z)*(ping+0.05+(isK and dist/110 or 0))
        end
        if (not isK) and Flags["Aimbot/Shot Assist"] then
            local t=findTarget("Sheriff")
            if t then return aimPos(t.char) end
        end
        return nil
    end
    local old
    local hookFn=function(self,...)
        local m=gnm()
        if (m=="FireServer" or m=="InvokeServer") and not (ccf and ccf()) then
            local ok,res=pcall(function()
                if typeof(self)~="Instance" or not (self:IsA("RemoteEvent") or self:IsA("RemoteFunction")) then return nil end
                local ch=LP.Character; if not ch then return nil end
                local nm=string.lower(self.Name)
                local mine=self:IsDescendantOf(ch)
                if not (mine or nm:find("shoot") or nm:find("throw") or nm:find("knife")) then return nil end
                if Flags["Aimbot/Log Shots"] then
                    local la=table.pack(...)
                    local parts={}
                    for i=1,la.n do
                        local ok2,sv=pcall(tostring,la[i])
                        parts[#parts+1]=typeof(la[i])..":"..(ok2 and sv or "?")
                    end
                    Shoot.log[#Shoot.log+1]=m.." | "..self:GetFullName().." | "..table.concat(parts,", ")
                    if #Shoot.log>60 then table.remove(Shoot.log,1) end
                end
                local tool=self:FindFirstAncestorOfClass("Tool") or ch:FindFirstChildOfClass("Tool")
                if not tool or not isWeaponTool(tool) then return nil end
                local pos=pickTarget(isKnife(tool) and true or false)
                if not pos then return nil end
                local a=table.pack(...)
                local cfs,v3s={},{}
                for i=1,a.n do
                    local t=typeof(a[i])
                    if t=="CFrame" then cfs[#cfs+1]=i elseif t=="Vector3" then v3s[#v3s+1]=i end
                end
                if #cfs==0 and #v3s==0 then return nil end
                if #cfs>=1 then a[cfs[#cfs]]=CFrame.new(pos) end
                if #v3s>=1 then a[v3s[#v3s]]=pos end
                return a
            end)
            if ok and res then return old(self,table.unpack(res,1,res.n)) end
        end
        return old(self,...)
    end
    if type(newcclosure)=="function" then local okc,nf=pcall(newcclosure,hookFn); if okc and nf then hookFn=nf end end
    task.delay(4,function()
        local okh=pcall(function() old=hm(game,"__namecall",hookFn) end)
        Shoot.hookActive=(okh and old~=nil) and true or false
    end)
end
end)
Shoot.fireRemotes=fireRemotes; Shoot.touchKill=touchKill; Shoot.fireGun=fireGun
end

-- WALKSPEED + SPIN
local Move2={WalkSpeed=16,SpinSpeed=0,SpinEnabled=false}
local applyWalkSpeed,startSpin,stopSpin
do
local spinAngle=0; local spinThread=nil
function applyWalkSpeed(v)
    v=tonumber(v) or 16; Move2.WalkSpeed=v
    local char=LP.Character; local hum=char and char:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed=v end
end
track(LP.CharacterAdded:Connect(function(c)
    local hum=c:WaitForChild("Humanoid",10)
    if hum then task.wait(0.4); hum.WalkSpeed=Move2.WalkSpeed end
end))
local function spinLoop()
    while Move2.SpinEnabled do
        local dt=RunService.RenderStepped:Wait()
        local char=LP.Character; local hrp=char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            spinAngle=spinAngle+math.rad(Move2.SpinSpeed)*dt
            if spinAngle>math.pi*2 then spinAngle=spinAngle-math.pi*2 end
            hrp.CFrame=CFrame.new(hrp.Position)*CFrame.Angles(0,spinAngle,0)
        end
    end
end
function startSpin() if spinThread then return end; Move2.SpinEnabled=true; spinThread=task.spawn(spinLoop) end
function stopSpin() Move2.SpinEnabled=false; if spinThread then pcall(function() task.cancel(spinThread) end); spinThread=nil end end
end

-- BUNNYHOP
local BHop={Enabled=false,Accel=40,Max=120,Boost=4,lastJump=0,vel=nil}
do
    track(UIS.JumpRequest:Connect(function() BHop.lastJump=os.clock() end))
    track(RunService.Heartbeat:Connect(function(dt)
        if not BHop.Enabled or Move.Fly then BHop.vel=nil; return end
        local char=LP.Character
        local hum=char and char:FindFirstChildOfClass("Humanoid")
        local hrp=char and char:FindFirstChild("HumanoidRootPart")
        if not hum or not hrp or hum.Health<=0 then BHop.vel=nil; return end
        local held=UIS:IsKeyDown(Enum.KeyCode.Space) or (os.clock()-BHop.lastJump<0.25)
        local wish=hum.MoveDirection
        local grounded=hum.FloorMaterial~=Enum.Material.Air
        if not held or wish.Magnitude<0.1 then if grounded then BHop.vel=nil end; return end
        wish=wish.Unit
        local v=hrp.AssemblyLinearVelocity
        local h=BHop.vel or Vector3.new(v.X,0,v.Z)
        if grounded then
            local spd=math.min(math.max(h.Magnitude,hum.WalkSpeed)+BHop.Boost,BHop.Max)
            h=wish*spd
            local jy=hum.UseJumpPower and hum.JumpPower or math.sqrt(2*workspace.Gravity*hum.JumpHeight)
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
            hrp.AssemblyLinearVelocity=Vector3.new(h.X,jy,h.Z)
        else
            local spd=h.Magnitude
            if spd>0.1 then
                local d=h.Unit:Lerp(wish,math.clamp(dt*4,0,1))
                if d.Magnitude>0.01 then h=d.Unit*spd end
            else h=wish*hum.WalkSpeed end
            h=h+wish*BHop.Accel*dt
            if h.Magnitude>BHop.Max then h=h.Unit*BHop.Max end
            hrp.AssemblyLinearVelocity=Vector3.new(h.X,v.Y,h.Z)
        end
        BHop.vel=h
    end))
end

local Skin,SKIN_NAMES
do
-- SKINS
Skin={meshOK={},orig=setmetatable({},{__mode="k"}),applied=setmetatable({},{__mode="k"}),live={},cfg={KnifeMesh="",KnifeTex="",GunMesh="",GunTex=""}}
local MAT=Enum.Material
local SKINS,KN_LIST,GN_LIST={},{},{}
local function D(kind,name,ar,ag,ab,br,bg,bb,mat,fl)
    fl=fl or {}
    local d={k=kind,a=Color3.fromRGB(ar,ag,ab),b=Color3.fromRGB(br,bg,bb),mat=mat,trail=fl.trail~=false,spark=fl.spark or false,rainbow=fl.rainbow or false,mesh=fl.mesh,tex=fl.tex}
    d.t=d.b
    SKINS[name]=d
    local l=(kind=="Knife") and KN_LIST or GN_LIST; l[#l+1]=name
end
local RB={rainbow=true,spark=true}
-- knives
D("Knife","Chroma",255,0,0,255,255,0,MAT.Neon,RB)
D("Knife","Chroma Slasher",255,40,40,255,200,0,MAT.Neon,RB)
D("Knife","Chroma Boneblade",235,230,210,255,255,255,MAT.Neon,RB)
D("Knife","Harvester",40,15,55,255,125,20,MAT.Metal,{spark=true})
D("Knife","Icepiercer",130,210,255,235,250,255,MAT.Ice,{spark=true})
D("Knife","Batwing",25,20,35,140,70,230,MAT.Metal)
D("Knife","Gingerblade",215,40,45,255,255,255,MAT.SmoothPlastic,{trail=false})
D("Knife","Heartblade",255,50,110,255,190,210,MAT.Neon,{spark=true})
D("Knife","Corrupt",18,18,20,200,0,0,MAT.Metal)
D("Knife","Seer",0,200,255,255,255,255,MAT.Neon,{spark=true,mesh="156467990"})
D("Knife","Eternal",255,215,90,255,255,255,MAT.Neon,{spark=true})
D("Knife","Nikilis",60,0,0,255,70,0,MAT.Neon,{spark=true})
D("Knife","Candy",255,150,210,120,220,255,MAT.Neon,{spark=true})
D("Knife","Boneblade",235,230,210,150,145,130,MAT.SmoothPlastic,{trail=false})
D("Knife","Elderwood Blade",70,120,50,150,100,50,MAT.Wood,{trail=false})
D("Knife","Blossom Blade",255,170,200,255,255,255,MAT.Neon,{spark=true})
D("Knife","Slasher",90,0,0,255,40,40,MAT.Neon,{spark=true})
D("Knife","Ghostblade",200,225,255,255,255,255,MAT.Neon,{spark=true})
D("Knife","Peppermint",255,255,255,220,30,40,MAT.SmoothPlastic,{trail=false})
D("Knife","Sakura",255,190,215,255,120,170,MAT.Neon,{spark=true})
D("Knife","Clockwork",150,110,40,220,180,90,MAT.Metal,{trail=false})
D("Knife","Cookieblade",190,130,70,110,70,30,MAT.SmoothPlastic,{trail=false})
D("Knife","Hallows Blade",255,120,0,30,0,40,MAT.Metal,{spark=true})
D("Knife","Tides",0,120,200,120,230,230,MAT.Neon,{spark=true})
D("Knife","Fang",240,240,235,160,0,0,MAT.SmoothPlastic,{trail=false,mesh="116693735"})
D("Knife","Deathshard",60,60,70,200,20,20,MAT.Metal,{mesh="62350856"})
D("Knife","Saw",150,150,160,255,140,30,MAT.Metal,{trail=false,mesh="170903610"})
D("Knife","Heat",255,90,0,255,200,40,MAT.Neon,{spark=true,mesh="105351545"})
D("Knife","Splitter",140,150,170,80,140,220,MAT.Metal,{mesh="22787189"})
D("Knife","Shadow",10,10,14,120,50,200,MAT.Metal,{mesh="86494914"})
D("Knife","Prince",230,190,60,120,60,200,MAT.Metal,{spark=true,mesh="71037101"})
D("Knife","Ghost",210,230,255,255,255,255,MAT.Neon,{spark=true,mesh="64220952"})
D("Knife","Blood",110,0,0,200,20,20,MAT.Metal,{mesh="51757162"})
D("Knife","Classic Knife",190,195,205,255,255,255,MAT.Metal,{trail=false,mesh="121946387"})
-- guns
D("Gun","Chroma Luger",255,0,0,255,255,0,MAT.Neon,RB)
D("Gun","Prismatic",255,0,180,0,200,255,MAT.Neon,RB)
D("Gun","Luger",40,40,45,200,170,80,MAT.Metal,{trail=false,mesh="95354288"})
D("Gun","Gingerscope",215,40,45,40,150,60,MAT.SmoothPlastic,{trail=false})
D("Gun","Darkshot",15,15,18,70,70,80,MAT.Metal)
D("Gun","Laser",0,170,255,180,240,255,MAT.Neon,{spark=true,mesh="18268645"})
D("Gun","Sunset",255,110,50,255,60,130,MAT.Neon,{spark=true})
D("Gun","Iceflake",150,220,255,255,255,255,MAT.Ice,{spark=true})
D("Gun","Spectral",120,255,230,255,255,255,MAT.Neon,{spark=true})
D("Gun","Shark",60,110,160,220,230,240,MAT.SmoothPlastic,{trail=false,mesh="118281463"})
D("Gun","Heartbreaker",255,60,130,255,200,220,MAT.Neon,{spark=true})
D("Gun","Blaster",255,200,40,255,100,20,MAT.Neon,{spark=true})
D("Gun","Cookiecannon",190,130,70,255,255,255,MAT.SmoothPlastic,{trail=false})
D("Gun","Pumpkin",255,120,0,40,20,0,MAT.SmoothPlastic,{spark=true})
D("Gun","Elderwood Revolver",70,120,50,150,100,50,MAT.Wood,{trail=false})
D("Gun","Golden Gun",230,185,40,255,240,170,MAT.Metal,{spark=true})
D("Gun","Phaser",80,200,255,255,255,255,MAT.Neon,{spark=true,mesh="69567827"})
D("Gun","Classic Revolver",70,70,78,190,160,80,MAT.Metal,{trail=false,mesh="97885508"})
SKIN_NAMES={"Off"}
for _,n in ipairs(KN_LIST) do SKIN_NAMES[#SKIN_NAMES+1]=n end
for _,n in ipairs(GN_LIST) do SKIN_NAMES[#SKIN_NAMES+1]=n end
Skin.defs=SKINS; Skin.knives=KN_LIST; Skin.guns=GN_LIST

local function toolKind(t) local r=scanName(t.Name); if r=="Murderer" then return "Knife" elseif r=="Sheriff" then return "Gun" end; return nil end
local function assetId(v) local x=tostring(v or ""):gsub("%s+",""); if x=="" then return "" end; if x:match("^%d+$") then return "rbxassetid://"..x end; return x end
local function saveProps(tool)
    if Skin.orig[tool] then return end
    local o={}
    for _,d in ipairs(tool:GetDescendants()) do
        if d:IsA("BasePart") then
            local e={Color=d.Color,Material=d.Material,Transparency=d.Transparency}
            if d:IsA("MeshPart") then e.TextureID=d.TextureID end
            o[d]=e
        elseif d:IsA("SpecialMesh") then o[d]={TextureId=d.TextureId,VertexColor=d.VertexColor} end
    end
    Skin.orig[tool]=o
end
local function restoreTool(tool)
    for _,d in ipairs(tool:GetDescendants()) do if d.Name=="luxxsFx" or d.Name=="luxxsCustom" then pcall(function() d:Destroy() end) end end
    local o=Skin.orig[tool]
    if o then for inst,e in pairs(o) do if inst.Parent then for k,v in pairs(e) do pcall(function() inst[k]=v end) end end end end
    Skin.applied[tool]=nil; Skin.live[tool]=nil
end
local function applyTool(tool,kind)
    local skinName=Flags["Skins/"..kind.." Skin"] or "Off"
    local def=SKINS[skinName]
    local mesh=assetId(Skin.cfg[kind.."Mesh"]); local tex=assetId(Skin.cfg[kind.."Tex"])
    local scl=(Flags["Skins/Mesh Scale %"] or 100)/100
    local sig=skinName.."|"..mesh.."|"..tex.."|"..scl
    if Skin.applied[tool]==sig then return end
    restoreTool(tool); Skin.applied[tool]=sig
    if not def and mesh=="" and tex=="" then return end
    saveProps(tool)
    if def and def.model then Skin.applyModel(tool,def); return end
    local handle=tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart",true)
    local parts={}
    if def then
        local i=0
        for _,d in ipairs(tool:GetDescendants()) do
            if d:IsA("BasePart") then i+=1; parts[#parts+1]=d; d.Material=def.mat; d.Color=(i%2==0) and (def.b or def.a) or def.a
                if d:IsA("MeshPart") then d.TextureID="" end
            elseif d:IsA("SpecialMesh") then d.TextureId=""; d.VertexColor=Vector3.new(1,1,1) end
        end
    end
    if mesh~="" and handle then
        for _,d in ipairs(tool:GetDescendants()) do if d:IsA("BasePart") then d.Transparency=1 end end
        local cp=Instance.new("Part"); cp.Name="luxxsCustom"; cp.Size=Vector3.new(1,1,1); cp.CanCollide=false; cp.CanQuery=false; cp.CanTouch=false; cp.Massless=true
        if def then cp.Color=def.a; cp.Material=def.mat end
        local sm=Instance.new("SpecialMesh"); sm.MeshType=Enum.MeshType.FileMesh; sm.MeshId=mesh; sm.TextureId=tex; sm.Scale=Vector3.new(scl,scl,scl); sm.Parent=cp
        local w=Instance.new("Weld"); w.Part0=handle; w.Part1=cp; w.Parent=cp
        cp.Parent=tool; parts[#parts+1]=cp
    elseif tex~="" then
        for _,d in ipairs(tool:GetDescendants()) do
            if d:IsA("MeshPart") then d.TextureID=tex elseif d:IsA("SpecialMesh") then d.TextureId=tex end
        end
    end
    local tr,pe
    if def and handle then
        local col=def.t or def.a
        if def.trail then
            local sz=handle.Size; local m=math.max(sz.X,sz.Y,sz.Z)
            local ax=(sz.X==m) and Vector3.new(1,0,0) or ((sz.Y==m) and Vector3.new(0,1,0) or Vector3.new(0,0,1))
            local a0=Instance.new("Attachment"); a0.Name="luxxsFx"; a0.Position=ax*(m/2); a0.Parent=handle
            local a1=Instance.new("Attachment"); a1.Name="luxxsFx"; a1.Position=-ax*(m/2); a1.Parent=handle
            tr=Instance.new("Trail"); tr.Name="luxxsFx"; tr.Attachment0=a0; tr.Attachment1=a1; tr.Lifetime=0.4; tr.LightEmission=0.8; tr.FaceCamera=true
            tr.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.2),NumberSequenceKeypoint.new(1,1)})
            tr.Color=ColorSequence.new(col); tr.Parent=handle
        end
        if def.spark then
            pe=Instance.new("ParticleEmitter"); pe.Name="luxxsFx"; pe.Rate=18; pe.Lifetime=NumberRange.new(0.4,0.8); pe.Speed=NumberRange.new(1,3); pe.LightEmission=1
            pe.Size=NumberSequence.new({NumberSequenceKeypoint.new(0,0.2),NumberSequenceKeypoint.new(1,0)})
            pe.Color=ColorSequence.new(col); pe.Parent=handle
        end
    end
    if def and def.rainbow then Skin.live[tool]={parts=parts,tr=tr,pe=pe} end
    if def and def.mesh and mesh=="" and handle then
        task.spawn(function()
            local id="rbxassetid://"..def.mesh
            if Skin.meshOK[id]==nil then
                local ok=false
                local probe=Instance.new("SpecialMesh"); probe.MeshType=Enum.MeshType.FileMesh; probe.MeshId=id
                pcall(function()
                    game:GetService("ContentProvider"):PreloadAsync({probe},function(_,st) ok=(st==Enum.AssetFetchStatus.Success) end)
                end)
                probe:Destroy()
                Skin.meshOK[id]=ok
            end
            if not Skin.meshOK[id] then return end
            if Skin.applied[tool]~=sig or not tool.Parent or not handle.Parent then return end
            for _,d in ipairs(tool:GetDescendants()) do if d:IsA("BasePart") and d.Name~="luxxsCustom" then d.Transparency=1 end end
            local cp=Instance.new("Part"); cp.Name="luxxsCustom"; cp.Size=Vector3.new(1,1,1); cp.CanCollide=false; cp.CanQuery=false; cp.CanTouch=false; cp.Massless=true
            cp.Color=def.a; cp.Material=def.mat
            local sm=Instance.new("SpecialMesh"); sm.MeshType=Enum.MeshType.FileMesh; sm.MeshId=id; sm.TextureId=def.tex and ("rbxassetid://"..def.tex) or ""; sm.Scale=Vector3.new(scl,scl,scl); sm.Parent=cp
            local w=Instance.new("Weld"); w.Part0=handle; w.Part1=cp; w.Parent=cp
            cp.Parent=tool; parts[#parts+1]=cp
        end)
    end
end
local function skinRoots() local r={}; if LP.Character then r[#r+1]=LP.Character end; local bp=LP:FindFirstChildOfClass("Backpack"); if bp then r[#r+1]=bp end; return r end
function Skin.refresh()
    local on=Flags["Skins/Enable"]
    for _,root in ipairs(skinRoots()) do
        for _,t in ipairs(root:GetChildren()) do
            if t:IsA("Tool") then local k=toolKind(t)
                if k then if on then applyTool(t,k) elseif Skin.applied[t] then restoreTool(t) end end
            end
        end
    end
end
function Skin.restoreAll() for _,root in ipairs(skinRoots()) do for _,t in ipairs(root:GetChildren()) do if t:IsA("Tool") then pcall(restoreTool,t) end end end end
track(RunService.Heartbeat:Connect(function()
    if next(Skin.live)==nil then return end
    local hue=(os.clock()*0.35)%1
    for tool,l in pairs(Skin.live) do
        if not tool.Parent then Skin.live[tool]=nil
        else
            for i,p in ipairs(l.parts) do if p.Parent then p.Color=Color3.fromHSV((hue+i*0.07)%1,0.85,1) end end
            local c=Color3.fromHSV(hue,0.85,1)
            if l.tr and l.tr.Parent then l.tr.Color=ColorSequence.new(c) end
            if l.pe and l.pe.Parent then l.pe.Color=ColorSequence.new(c) end
        end
    end
end))

-- SKIN LIBRARY: real models taken from the game / from other players
Skin.listeners={Knife={},Gun={}}
local libSigs={}
local function modelSig(m)
    local t={}
    for _,d in ipairs(m:GetDescendants()) do
        if d:IsA("MeshPart") then t[#t+1]=d.MeshId.."|"..d.TextureID
        elseif d:IsA("SpecialMesh") then t[#t+1]=d.MeshId.."|"..d.TextureId
        elseif d:IsA("BasePart") then t[#t+1]=d.Name.."|"..tostring(d.Size) end
    end
    table.sort(t)
    return table.concat(t,";")
end
local function sanitize(m)
    for _,d in ipairs(m:GetDescendants()) do
        pcall(function()
            if d:IsA("LuaSourceContainer") or d:IsA("RemoteEvent") or d:IsA("RemoteFunction") or d:IsA("BindableEvent") or d:IsA("BindableFunction")
                or d:IsA("Weld") or d:IsA("WeldConstraint") or d:IsA("Motor6D") or d:IsA("ManualWeld") or d:IsA("Sound") then d:Destroy() end
        end)
    end
end
function Skin.addModel(kind,baseName,source)
    local ok,res=pcall(function()
        local clone=source:Clone(); sanitize(clone)
        local handle=clone:FindFirstChild("Handle") or clone:FindFirstChildWhichIsA("BasePart",true)
        if not handle then clone:Destroy(); return nil end
        local sg=modelSig(clone)
        if sg=="" or libSigs[sg] then clone:Destroy(); return nil end
        libSigs[sg]=true
        local grip=CFrame.new(); if source:IsA("Tool") then pcall(function() grip=source.Grip end) end
        local name=baseName; local n=1
        while SKINS[name] do n+=1; name=baseName.." "..n end
        local col=handle.Color
        SKINS[name]={k=kind,model=clone,grip=grip,srcHandle=handle,a=col,b=col:Lerp(Color3.new(1,1,1),0.4),mat=handle.Material,trail=false,spark=false,rainbow=false,game=true}
        local l=(kind=="Knife") and Skin.knives or Skin.guns
        l[#l+1]=name; SKIN_NAMES[#SKIN_NAMES+1]=name
        for _,fn in ipairs(Skin.listeners[kind]) do pcall(fn,name) end
        return name
    end)
    if ok then return res end
    return nil
end
function Skin.applyModel(tool,def)
    local handle=tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart",true)
    if not handle then return end
    for _,d in ipairs(tool:GetDescendants()) do if d:IsA("BasePart") then d.Transparency=1 end end
    local grip=CFrame.new(); pcall(function() grip=tool.Grip end)
    local base=grip*def.grip:Inverse()
    local c=def.model:Clone()
    local ch=c:FindFirstChild("Handle") or c:FindFirstChildWhichIsA("BasePart",true)
    if not ch then c:Destroy(); return end
    local holder=Instance.new("Model"); holder.Name="luxxsCustom"
    local list={}
    for _,p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then list[#list+1]=p end end
    local chcf=ch.CFrame
    for _,p in ipairs(list) do
        local rel=chcf:ToObjectSpace(p.CFrame)
        p.Anchored=false; p.CanCollide=false; p.CanQuery=false; p.CanTouch=false; p.Massless=true
        local w=Instance.new("Weld"); w.Part0=handle; w.Part1=p; w.C0=base*rel; w.Parent=p
    end
    for _,p in ipairs(list) do if not p.Parent:IsA("BasePart") then p.Parent=holder end end
    c:Destroy()
    holder.Parent=tool
end
local function scanRoot(root,out,depth)
    local n=0
    for _,d in ipairs(root:GetDescendants()) do
        n+=1; if n%400==0 then task.wait() end
        if (d:IsA("Tool") or (d:IsA("Model") and d:FindFirstChild("Handle"))) and d:FindFirstChild("Handle") then
            local path=string.lower(d:GetFullName())
            local kind
            if path:find("knife") or path:find("knives") or path:find("blade") or path:find("melee") then kind="Knife"
            elseif path:find("gun") or path:find("revolver") or path:find("pistol") or path:find("shoot") then kind="Gun" end
            if not kind then
                for _,x in ipairs(d:GetDescendants()) do
                    local xn=string.lower(x.Name)
                    if xn:find("knife") or xn:find("throw") or xn:find("stab") then kind="Knife"; break end
                    if xn:find("shoot") or xn:find("gun") or xn:find("fire") then kind="Gun"; break end
                end
            end
            out[#out+1]={inst=d,kind=kind or "Knife",path=d:GetFullName()}
        end
    end
end
Skin.scanLog={}
function Skin.scan(extraPath)
    local roots={}
    local g=game
    if extraPath and extraPath~="" then
        local cur=g
        for part in tostring(extraPath):gsub("^game%.",""):gmatch("[^%.]+") do cur=cur and cur:FindFirstChild(part) end
        if cur then roots[#roots+1]=cur end
    end
    for _,svc in ipairs({"ReplicatedStorage","ReplicatedFirst","StarterPack","Lighting"}) do
        local ok,sv=pcall(function() return g:GetService(svc) end)
        if ok and sv then roots[#roots+1]=sv end
    end
    local found={}
    for _,r in ipairs(roots) do pcall(scanRoot,r,found) end
    local added=0; Skin.scanLog={}
    for _,f in ipairs(found) do
        Skin.scanLog[#Skin.scanLog+1]=f.kind.." | "..f.path
        local parentName=f.inst.Parent and f.inst.Parent.Name or ""
        local nm=f.inst.Name
        if nm=="Knife" or nm=="Gun" then nm=parentName.." "..nm end
        if Skin.addModel(f.kind,nm,f.inst) then added+=1 end
    end
    return added,#found
end
local function capturePlayers()
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr~=LP and plr.Character then
            for _,t in ipairs(plr.Character:GetChildren()) do
                if t:IsA("Tool") then
                    local r=scanName(t.Name)
                    if r then Skin.addModel(r=="Murderer" and "Knife" or "Gun",((r=="Murderer") and "Knife - " or "Gun - ")..plr.Name,t) end
                end
            end
        end
    end
end
Skin.capturePlayers=capturePlayers
task.spawn(function()
    task.wait(3)
    pcall(Skin.scan,"")
    while gui.Parent do
        if Flags["Skins/Auto Capture Skins"] ~= false then pcall(capturePlayers) end
        task.wait(2)
    end
end)
task.spawn(function()
    while gui.Parent do
        task.wait(0.25); pcall(Skin.refresh)
        if Flags["Skins/Enable"] then
            local char=LP.Character
            if char then for _,t in ipairs(char:GetChildren()) do if t:IsA("Tool") then local k=toolKind(t); if k then pcall(applyTool,t,k) end end end end
        end
    end
end)
end

-- FPS
local FPS={Enabled=false,Target=10000,Current=0}
local originalFpsCap=nil
local function applyFpsCap(cap) if type(setfpscap)=="function" then pcall(setfpscap,cap) end FPS.Current=cap end
local function enableFps() if type(getfpscap)=="function" then local ok,cur=pcall(getfpscap); if ok then originalFpsCap=cur end end; applyFpsCap(FPS.Target); notify("FPS unlocked to "..FPS.Target) end
local function disableFps() if originalFpsCap then applyFpsCap(originalFpsCap) else applyFpsCap(60) end end
local fpsGui=Instance.new("ScreenGui"); fpsGui.Name="luxxsFPS"; fpsGui.ResetOnSpawn=false; fpsGui.IgnoreGuiInset=true; fpsGui.DisplayOrder=100; fpsGui.Parent=parent
local fpsFrame=Instance.new("Frame"); fpsFrame.AnchorPoint=Vector2.new(1,0); fpsFrame.Position=UDim2.new(1,-12,0,12); fpsFrame.Size=UDim2.new(0,84,0,24); fpsFrame.BackgroundColor3=C.bg; fpsFrame.BackgroundTransparency=0.1; fpsFrame.BorderSizePixel=0; fpsFrame.ZIndex=5; fpsFrame.Parent=fpsGui
stroke(fpsFrame,C.line,1,0)
local fpsNum=Instance.new("TextLabel"); fpsNum.BackgroundTransparency=1; fpsNum.Position=UDim2.new(0,10,0,0); fpsNum.Size=UDim2.new(1,-12,1,0); fpsNum.Font=F_MONO; fpsNum.TextSize=12; fpsNum.TextColor3=C.text; fpsNum.TextXAlignment=Enum.TextXAlignment.Left; fpsNum.Text="0 FPS"; fpsNum.ZIndex=6; fpsNum.Parent=fpsFrame
local FpsCounter={Avg=0,Max=0,Frames=0,Last=tick()}
task.spawn(function()
    while fpsGui.Parent do
        RunService.RenderStepped:Wait()
        FpsCounter.Frames+=1
        local elapsed=tick()-FpsCounter.Last
        if elapsed>=0.25 then
            local fps=math.floor(FpsCounter.Frames/elapsed+0.5)
            FpsCounter.Frames=0; FpsCounter.Last=tick()
            FpsCounter.Avg=FpsCounter.Avg==0 and fps or (FpsCounter.Avg*0.9+fps*0.1)
            if fps>FpsCounter.Max then FpsCounter.Max=fps end
            fpsNum.Text=tostring(fps).." FPS"
        end
    end
end)
makeDraggable(fpsFrame,fpsFrame)

-- TABS
local visTab=createTab("Visuals")
visTab:Label("ESP")
visTab:Toggle("ESP Box",false)
visTab:Toggle("Tap to Teleport",true)
visTab:Toggle("Role",false)
visTab:Toggle("Color by Role",false)
visTab:Toggle("Name",false)
visTab:Toggle("Health",false)
visTab:Toggle("Distance",false)
visTab:Toggle("Tracers",false)
visTab:Toggle("Skeleton",false)
visTab:Toggle("Chams",false)
visTab:Toggle("Glow",false)
visTab:Slider("Chams Fill",0,100,50)
visTab:Choice("ESP Color",COLOR_NAMES,"Lime")
visTab:Label("Gun ESP")
visTab:Toggle("Gun ESP",false)
visTab:Choice("Gun Color",COLOR_NAMES,"Gold")
visTab:Button("Teleport to Gun",teleportToGun)
visTab:Label("Wings")
visTab:Toggle("Wings",false,function(s) if s then buildWings() else destroyCos("wings") end end)
visTab:Choice("Wing Color",WING_COLORS,"White")
visTab:Slider("Wing Speed",1,10,3)
visTab:Label("Chinese Hat")
visTab:Toggle("Chinese Hat",false,function(s) if s then buildHat() else destroyCos("hat") end end)
local function refreshHatGrads() for _,k in ipairs({"Visuals/Hat Saturation","Visuals/Hat Shade"}) do local f=GradRefresh[k]; if f then f() end end end
visTab:Choice("Hat Color",HAT_COLORS,"Custom")
visTab:Slider("Hat Hue",0,360,280,function(v) _G.LUXXS_HAT_H=v; refreshHatGrads() end,function()
    local kp={} for k=0,6 do kp[#kp+1]=ColorSequenceKeypoint.new(k/6,Color3.fromHSV(k/6,1,1)) end return ColorSequence.new(kp)
end)
visTab:Slider("Hat Saturation",0,100,70,function(v) _G.LUXXS_HAT_S=v/100; refreshHatGrads() end,function()
    local h=_G.LUXXS_HAT_H/360; return ColorSequence.new(Color3.fromHSV(h,0,_G.LUXXS_HAT_V),Color3.fromHSV(h,1,_G.LUXXS_HAT_V))
end)
visTab:Slider("Hat Shade",0,100,100,function(v) _G.LUXXS_HAT_V=v/100; refreshHatGrads() end,function()
    local h=_G.LUXXS_HAT_H/360; return ColorSequence.new(Color3.new(0,0,0),Color3.fromHSV(h,_G.LUXXS_HAT_S,1))
end)
visTab:Slider("Hat Transparency",0,100,35)
local PRESETS={Red={0,1,1},Orange={25,1,1},Gold={45,0.85,1},Yellow={55,1,1},Lime={90,1,1},Green={130,1,0.9},Mint={160,0.7,1},Cyan={185,1,1},Sky={205,0.7,1},Blue={225,1,1},Indigo={255,0.9,0.9},Violet={275,0.8,1},Purple={290,1,0.8},Magenta={310,1,1},Pink={330,0.6,1},Rose={345,0.8,1},White={0,0,1},Silver={0,0,0.7},Gray={0,0,0.45},Black={0,0,0.08},Brown={25,0.7,0.5}}
local PRESET_NAMES={"Red","Orange","Gold","Yellow","Lime","Green","Mint","Cyan","Sky","Blue","Indigo","Violet","Purple","Magenta","Pink","Rose","White","Silver","Gray","Black","Brown"}
local function applyPreset(prefix,name)
    local p=PRESETS[name]; if not p then return end
    local function set(k,v) local f=Setters["Visuals/"..prefix.." "..k]; if f then pcall(f,v) end end
    set("Hue",p[1]); set("Saturation",math.floor(p[2]*100+0.5)); set("Shade",math.floor(p[3]*100+0.5))
    local cf=Setters["Visuals/"..prefix.." Color"]; if cf then pcall(cf,"Custom") end
end
visTab:List("Hat Preset",PRESET_NAMES,"Violet",function(v) applyPreset("Hat",v) end)
visTab:Label("Legless")
visTab:Toggle("Legless",false)
visTab:Choice("Legless Side",{"Left","Right"},"Left")
visTab:Slider("Chain Length",50,150,100)
visTab:Label("Held Item")
visTab:Toggle("Held Item",false)
visTab:Label("Back Track")
visTab:Toggle("Back Track",false)
visTab:Toggle("Back Track Self",false)
visTab:Slider("Track Length",1,4,2)
_G.LUXXS_CLEAN={}
__safe("backtrack",function()
local tracks={}
local acc=0
local function clearAll()
    for _,t in pairs(tracks) do for _,l in ipairs(t.lines) do pcall(function() l:Destroy() end) end end
    tracks={}
end
table.insert(_G.LUXXS_CLEAN,clearAll)
track(RunService.Heartbeat:Connect(function(dt)
    acc+=dt; if acc<0.1 then return end; acc=0
    local on,selfOn=Flags["Visuals/Back Track"],Flags["Visuals/Back Track Self"]
    local life=Flags["Visuals/Track Length"] or 2
    local now=os.clock()
    for _,plr in ipairs(Players:GetPlayers()) do
        local want
        if plr==LP then want=selfOn else want=on end
        local t=tracks[plr]
        if want then
            local c=plr.Character; local hrp=c and c:FindFirstChild("HumanoidRootPart"); local hum=c and c:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum.Health>0 then
                if not t then t={pts={},lines={}}; tracks[plr]=t end
                local feet=hrp.Position-Vector3.new(0,hrp.Size.Y/2+hum.HipHeight,0)
                local last=t.pts[#t.pts]
                if not last or (last.p-feet).Magnitude>0.15 then t.pts[#t.pts+1]={p=feet,t=now} end
            end
        end
        if t then
            while t.pts[1] and now-t.pts[1].t>life do table.remove(t.pts,1) end
            if not want then t.pts={} end
        end
    end
end))
track(RunService.RenderStepped:Connect(function()
    local cam=workspace.CurrentCamera; if not cam then return end
    local now=os.clock(); local life=Flags["Visuals/Track Length"] or 2
    for plr,t in pairs(tracks) do
        if not plr.Parent then
            for _,l in ipairs(t.lines) do pcall(function() l:Destroy() end) end
            tracks[plr]=nil
        else
            local n=#t.pts-1
            for i=1,math.max(n,#t.lines) do
                local ln=t.lines[i]
                if i<=n then
                    if not ln then
                        ln=Instance.new("Frame"); ln.AnchorPoint=Vector2.new(0.5,0.5); ln.BorderSizePixel=0; ln.ZIndex=2; ln.Parent=ESPFolder; t.lines[i]=ln
                    end
                    local a,b=t.pts[i],t.pts[i+1]
                    local sa=cam:WorldToViewportPoint(a.p); local sb=cam:WorldToViewportPoint(b.p)
                    if sa.Z>0 and sb.Z>0 then
                        ln.Visible=true; setLine(ln,Vector2.new(sa.X,sa.Y),Vector2.new(sb.X,sb.Y),2)
                        ln.BackgroundTransparency=math.clamp((now-b.t)/life,0,1)*0.9
                        local col
                        if plr~=LP and Flags["Visuals/Color by Role"] then col=ROLE_COLORS[getRoleCached(plr)] or WHITE else col=getColor(Flags["Visuals/ESP Color"],now,i*0.05) end
                        ln.BackgroundColor3=col
                    else ln.Visible=false end
                elseif ln then ln.Visible=false end
            end
        end
    end
end))
end)
visTab:Label("X-Ray")
visTab:Toggle("X-Ray",false)
visTab:Slider("X-Ray Strength",10,95,60)
__safe("xray",function()
local xr={orig={},gen=0}
local function isSkip(p)
    if not p:IsA("BasePart") or p:IsA("Terrain") then return true end
    local n=string.lower(p.Name)
    if n=="humanoidrootpart" or n:find("coin") or n=="gundrop" then return true end
    local top=p
    while top.Parent and top.Parent~=workspace do top=top.Parent end
    return Players:GetPlayerFromCharacter(top)~=nil
end
local function applyPart(p,amt)
    if isSkip(p) then return end
    if xr.orig[p]==nil then xr.orig[p]=p.LocalTransparencyModifier end
    p.LocalTransparencyModifier=amt
end
local function applyAll()
    xr.gen+=1; local my=xr.gen
    task.spawn(function()
        local amt=(Flags["Visuals/X-Ray Strength"] or 60)/100
        local n=0
        for _,d in ipairs(workspace:GetDescendants()) do
            if xr.gen~=my or not Flags["Visuals/X-Ray"] then return end
            pcall(applyPart,d,amt)
            n+=1; if n%250==0 then task.wait() end
        end
    end)
end
local function restore()
    xr.gen+=1
    for p,o in pairs(xr.orig) do if p.Parent then pcall(function() p.LocalTransparencyModifier=o end) end end
    xr.orig={}
end
table.insert(_G.LUXXS_CLEAN,restore)
local prev=nil
task.spawn(function()
    local lastStrength=nil
    while gui.Parent do
        local on=Flags["Visuals/X-Ray"] and true or false
        local st=Flags["Visuals/X-Ray Strength"]
        if on and (not prev or st~=lastStrength) then applyAll() elseif (not on) and prev then restore() end
        prev=on; lastStrength=st
        task.wait(0.4)
    end
end)
track(workspace.DescendantAdded:Connect(function(d)
    if Flags["Visuals/X-Ray"] then task.defer(function() pcall(applyPart,d,(Flags["Visuals/X-Ray Strength"] or 60)/100) end) end
end))
end)
visTab:Label("Sky Color")
visTab:Toggle("Sky Tint",false)
__safe("sky",function()
local SK={H=210,S=0.55,V=1}
local sky={orig=nil,atmo=nil,made=false,aorig=nil}
local function col() return Color3.fromHSV((SK.H%360)/360,math.clamp(SK.S,0,1),math.clamp(SK.V,0,1)) end
local function save()
    if sky.orig then return end
    sky.orig={Ambient=Lighting.Ambient,Out=Lighting.OutdoorAmbient,Top=Lighting.ColorShift_Top,Bot=Lighting.ColorShift_Bottom}
end
local function atmo()
    local a=Lighting:FindFirstChildOfClass("Atmosphere")
    if a then
        if not sky.aorig then sky.aorig={Color=a.Color,Decay=a.Decay,Density=a.Density,Haze=a.Haze,Glare=a.Glare}; sky.atmo=a end
        return a
    end
    if not sky.atmo or not sky.atmo.Parent then
        local n=Instance.new("Atmosphere"); n.Name="luxxsAtmo"; n.Parent=Lighting; sky.atmo=n; sky.made=true
    end
    return sky.atmo
end
local function apply()
    save(); local c=col()
    Lighting.Ambient=c:Lerp(Color3.new(0,0,0),0.4); Lighting.OutdoorAmbient=c:Lerp(Color3.new(0,0,0),0.3)
    Lighting.ColorShift_Top=c; Lighting.ColorShift_Bottom=c:Lerp(Color3.new(1,1,1),0.3)
    local a=atmo(); a.Color=c; a.Decay=c:Lerp(Color3.new(0,0,0),0.4); a.Density=(Flags["Visuals/Sky Density"] or 60)/100; a.Haze=8; a.Glare=0
end
local function restore()
    if sky.orig then
        Lighting.Ambient=sky.orig.Ambient; Lighting.OutdoorAmbient=sky.orig.Out; Lighting.ColorShift_Top=sky.orig.Top; Lighting.ColorShift_Bottom=sky.orig.Bot
        sky.orig=nil
    end
    if sky.made and sky.atmo then pcall(function() sky.atmo:Destroy() end); sky.atmo=nil; sky.made=false
    elseif sky.aorig and sky.atmo and sky.atmo.Parent then
        for k,v in pairs(sky.aorig) do pcall(function() sky.atmo[k]=v end) end
    end
    sky.aorig=nil
end
table.insert(_G.LUXXS_CLEAN,restore)
visTab:Slider("Sky Hue",0,360,210,function(v) SK.H=v end,function()
    local kp={} for k=0,6 do kp[#kp+1]=ColorSequenceKeypoint.new(k/6,Color3.fromHSV(k/6,1,1)) end return ColorSequence.new(kp)
end)
visTab:Slider("Sky Saturation",0,100,55,function(v) SK.S=v/100 end)
visTab:Slider("Sky Shade",0,100,100,function(v) SK.V=v/100 end)
visTab:Slider("Sky Density",0,100,60)
visTab:List("Sky Preset",PRESET_NAMES,"Sky",function(v) applyPreset("Sky",v) end)
task.spawn(function()
    local was=false
    while gui.Parent do
        local on=Flags["Visuals/Sky Tint"] and true or false
        if on then pcall(apply) elseif was then pcall(restore) end
        was=on
        task.wait(0.4)
    end
end)
end)
visTab:Label("Trail")
visTab:Toggle("Trail",false,function(s) if s then buildTrail() else destroyCos("trail") end end)
visTab:Toggle("Fake Headless",false)
local TRAIL_COLORS={"Custom"}
for _,n in ipairs(COLOR_NAMES) do TRAIL_COLORS[#TRAIL_COLORS+1]=n end
local function refreshTrailGrads() for _,k in ipairs({"Visuals/Trail Saturation","Visuals/Trail Shade"}) do local f=GradRefresh[k]; if f then f() end end end
visTab:Choice("Trail Color",TRAIL_COLORS,"Rainbow")
visTab:Slider("Trail Hue",0,360,200,function(v) TRAILC.H=v; refreshTrailGrads() end,function()
    local kp={} for k=0,6 do kp[#kp+1]=ColorSequenceKeypoint.new(k/6,Color3.fromHSV(k/6,1,1)) end return ColorSequence.new(kp)
end)
visTab:Slider("Trail Saturation",0,100,90,function(v) TRAILC.S=v/100; refreshTrailGrads() end,function()
    local h=TRAILC.H/360; return ColorSequence.new(Color3.fromHSV(h,0,TRAILC.V),Color3.fromHSV(h,1,TRAILC.V))
end)
visTab:Slider("Trail Shade",0,100,100,function(v) TRAILC.V=v/100; refreshTrailGrads() end,function()
    local h=TRAILC.H/360; return ColorSequence.new(Color3.new(0,0,0),Color3.fromHSV(h,TRAILC.S,1))
end)
visTab:List("Trail Preset",PRESET_NAMES,"Cyan",function(v) applyPreset("Trail",v) end)
visTab:Slider("Trail Length",1,30,10)
visTab:Slider("Trail Width",1,10,4)

do
local aimTab=createTab("Aimbot")
aimTab:Label("Aim")
aimTab:Toggle("Enable",false)
aimTab:Toggle("Auto Shoot",true)
aimTab:Toggle("Silent Aim",true)
aimTab:Toggle("Log Shots",false)
aimTab:Button("Copy Shot Log",function()
    local txt="hook: "..tostring(Shoot.hookActive).."\n"..table.concat(Shoot.log,"\n")
    if type(setclipboard)=="function" then pcall(setclipboard,txt) end
    notify("Shot log copied ("..#Shoot.log.." calls, hook "..tostring(Shoot.hookActive)..")")
end)
aimTab:Slider("Shoot Delay (ms)",10,500,100)
aimTab:Toggle("Skip Innocents",true)
aimTab:Toggle("Weapon Only",true)
aimTab:Toggle("Shot Assist",true)
aimTab:Choice("Body Part",AIM_NAMES,"Head")
aimTab:Slider("FOV",10,360,120)
aimTab:Toggle("Show FOV",true)
aimTab:Label("Auto Win")
aimTab:Toggle("Auto Win",false,function(s) if s then startAutoWin() else stopAutoWin() end end)
aimTab:Toggle("Auto Teleport",true,function(s) AutoWin.Teleport=s end)
aimTab:Toggle("Auto Equip Weapon",true,function(s) AutoWin.AutoEquip=s end)
aimTab:Slider("Auto Win Delay (ms)",50,600,200,function(v) AutoWin.Delay=(tonumber(v) or 200)/1000 end)
aimTab:Button("Show AutoWin Status",function() notify("AutoWin: "..AutoWin.Status) end)
aimTab:Button("Debug Shoot",function() if Shoot.debug then Shoot.debug() end end)
end

do
local moveTab=createTab("Move")
moveTab:Label("Fly")
moveTab:Toggle("Fly",false,function(state)
    Move.Fly=state
    if state then enableFlyMove() else disableFlyMove() end
    local show=state and UIS.TouchEnabled
    flyUpBtn.Visible=show; flyDownBtn.Visible=show
    notify(state and "Fly ON" or "Fly OFF")
end)
moveTab:Slider("Fly Speed",10,300,60,function(v) Move.Speed=v end)
moveTab:Label("Noclip")
moveTab:Toggle("Noclip",false,function(state) Move.Noclip=state; setNoclipMove(state); notify(state and "Noclip ON" or "Noclip OFF") end)
moveTab:Label("Teleport")
moveTab:Button("Teleport to Gun",teleportToGun)
moveTab:Label("Walkspeed & Spin")
moveTab:Slider("WalkSpeed",16,1000,16,function(v) applyWalkSpeed(v) end)
moveTab:Button("Reset WalkSpeed (16)",function() applyWalkSpeed(16); local s=Setters["Move/WalkSpeed"]; if s then s(16) end end)
moveTab:Toggle("Spin",false,function(s) if s then startSpin() else stopSpin() end end)
moveTab:Slider("Spin Speed",0,1000,0,function(v) Move2.SpinSpeed=v end)
moveTab:Button("Reset Spin (0)",function() Move2.SpinSpeed=0; local s=Setters["Move/Spin Speed"]; if s then s(0) end end)
moveTab:Label("Bunnyhop")
moveTab:Toggle("Bunnyhop",false,function(s) BHop.Enabled=s; notify(s and "Bhop ON" or "Bhop OFF") end)
moveTab:Slider("Bhop Accel",0,300,40,function(v) BHop.Accel=v end)
moveTab:Slider("Bhop Boost/hop",0,30,4,function(v) BHop.Boost=v end)
moveTab:Slider("Bhop Max Speed",20,400,120,function(v) BHop.Max=v end)
moveTab:Label("Jump")
moveTab:Toggle("Jump Power",false,function(on)
    if not on then local h=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid"); if h then pcall(function() h.JumpPower=50 end) end end
end)
moveTab:Slider("Jump Power Value",50,10000,100)
moveTab:Toggle("Infinite Jump",false)
moveTab:Label("Protection")
moveTab:Toggle("Anti Fling",false)
end

do
local farmTab=createTab("Farm")
farmTab:Label("Coin auto-farm")
farmTab:Toggle("Enable Farm",false,function(state)
    Farm.Enabled=state
    if state then
        startFarm()
        if Farm.Mode~="Teleport" then setNoclip(true) end
        notify("Farm ON ("..Farm.Mode..")")
    else stopFarm(); notify("Farm OFF") end
end)
farmTab:Choice("Mode",{"Under Map","Smooth","Teleport","Fly","Noclip"},"Under Map",function(v)
    Farm.Mode=v
    if Farm.Enabled then disableFly(); setNoclip(v~="Teleport") end
end)
farmTab:Slider("Under Map Depth",3,40,8,function(v) Farm.Depth=v end)
farmTab:Slider("Speed (safe)",5,400,80,function(v) Farm.Speed=v end)
farmTab:Slider("Teleport Delay (ms)",0,500,150,function(v) Farm.TeleportDelay=(tonumber(v) or 0)/1000 end)
farmTab:Toggle("Anti-AFK",false,function(state) Farm.AntiAFK=state; setAntiAFK(state) end)
farmTab:Toggle("Return to Start",false,function(state) Farm.ReturnOnFinish=state end)
farmTab:Button("Reset Counter",function() Farm.Collected=0; notify("Counter reset") end)
farmTab:Button("Show Status",function() notify("Collected: "..Farm.Collected.." | "..Farm.Status) end)
end

-- LEGLESS (one leg removed, a chain hangs from the hip)
do
local lg={model=nil,links={},orig={},key=nil}
local function legParts(char,side)
    local names=(side=="Left") and {"LeftUpperLeg","LeftLowerLeg","LeftFoot","Left Leg"} or {"RightUpperLeg","RightLowerLeg","RightFoot","Right Leg"}
    local out={}
    for _,n in ipairs(names) do local p=char:FindFirstChild(n); if p and p:IsA("BasePart") then out[#out+1]=p end end
    return out
end
local function restore()
    for p,tr in pairs(lg.orig) do if p.Parent then pcall(function() p.Transparency=tr end) end end
    lg.orig={}
    if lg.model then pcall(function() lg.model:Destroy() end); lg.model=nil end
    lg.links={}; lg.key=nil
end
local function build(char,side)
    local hum=char:FindFirstChildOfClass("Humanoid")
    local r15=hum and hum.RigType==Enum.HumanoidRigType.R15
    local root=(r15 and char:FindFirstChild("LowerTorso")) or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
    if not root then return false end
    local sx=(side=="Left") and 0.95 or -0.95
    local hip=r15 and Vector3.new(sx,0.0,0.05) or Vector3.new(sx,-0.7,0.1)
    local model=Instance.new("Model"); model.Name="luxxsLegless"
    local anchor=Instance.new("Part"); anchor.Size=Vector3.new(0.2,0.2,0.2); anchor.Transparency=1
    anchor.CanCollide=false; anchor.CanQuery=false; anchor.CanTouch=false; anchor.Massless=true; anchor.Parent=model
    local w=Instance.new("Weld"); w.Part0=root; w.Part1=anchor; w.C0=CFrame.new(hip); w.Parent=anchor
    local function mk(size,col)
        local p=Instance.new("Part"); p.Size=size; p.Color=col; p.Material=Enum.Material.Metal
        p.CanCollide=false; p.CanQuery=false; p.CanTouch=false; p.Massless=true; p.Parent=model
        return p
    end
    local len=(Flags["Visuals/Chain Length"] or 100)/100
    local count=math.max(6,math.floor(13*len))
    local links={}
    for i=1,count do
        local horizontal=(i%2==0)
        local p=mk(horizontal and Vector3.new(0.2,0.06,0.12) or Vector3.new(0.06,0.2,0.12),Color3.fromRGB(175,180,192))
        local lw=Instance.new("Weld"); lw.Part0=anchor; lw.Part1=p; lw.Parent=p
        links[#links+1]={w=lw,i=i,hor=horizontal,out=(side=="Left") and 1 or -1}
    end
    model.Parent=char
    lg.model=model; lg.links=links
    return true
end
_G.LUXXS_SPIKE_RESTORE=restore
track(RunService.Heartbeat:Connect(function()
    local on=Flags["Visuals/Legless"]
    local char=LP.Character
    if not on or not char then
        if lg.model or next(lg.orig) then restore() end
        return
    end
    local side=Flags["Visuals/Legless Side"] or "Left"
    local key=side.."|"..tostring(Flags["Visuals/Chain Length"] or 100)
    if (not lg.model) or (not lg.model.Parent) or lg.key~=key then
        restore()
        if not build(char,side) then return end
        lg.key=key
    end
    for _,p in ipairs(legParts(char,side)) do
        if lg.orig[p]==nil then lg.orig[p]=p.Transparency end
        p.Transparency=1
    end
    local t=os.clock()
    for _,l in ipairs(lg.links) do
        local sway=math.sin(t*2.2+l.i*0.45)*0.018*l.i
        local sway2=math.cos(t*1.7+l.i*0.4)*0.012*l.i
        local bow=math.sin(math.min(l.i/13,1)*math.pi)*0.12*l.out
        l.w.C0=CFrame.new(sway+bow,-0.12-l.i*0.19,sway2)*CFrame.Angles(0,l.hor and math.pi/2 or 0,0)
    end
end))
end

-- ANTI AIM (dodge when someone shoots / throws at you)
do
local aaTab=createTab("Anti Aim")
aaTab:Label("Dodge shots and knife throws")
aaTab:Toggle("Anti Aim",false)
aaTab:Choice("Anti Aim Mode",{"On Shot","Aimed","Jitter"},"On Shot")
aaTab:Toggle("Dodge Melee",true)
aaTab:Slider("Melee Range",4,25,12)
aaTab:Slider("Dodge Distance",1,10,4)
aaTab:Slider("Dodge Speed (ms)",40,400,110)
aaTab:Label("On Shot: dodges right after a shot / throw at you")
aaTab:Label("Aimed: dodges while an armed player aims at you")
aaTab:Label("Jitter: always shakes sideways")
aaTab:Label("Dodge Melee: dodges an armed player who runs at you to stab")
local rp=RaycastParams.new()
pcall(function() rp.FilterType=Enum.RaycastFilterType.Exclude end)
local last,threatUntil,threatPos=0,0,nil
local pending,lastTrig=false,0
local function armedTool(c)
    for _,t in ipairs(c:GetChildren()) do if t:IsA("Tool") and scanName(t.Name) then return true end end
    return false
end
local function myRoot() local c=LP.Character; return c and c:FindFirstChild("HumanoidRootPart") end
local vrp=RaycastParams.new()
pcall(function() vrp.FilterType=Enum.RaycastFilterType.Exclude end)
pcall(function() vrp.RespectCanCollide=true end)
local function canSee(fromPos,shooter)
    local me=LP.Character; local mr=me and me:FindFirstChild("HumanoidRootPart"); if not mr then return false end
    local list={me}; if shooter then list[2]=shooter end
    vrp.FilterDescendantsInstances=list
    return workspace:Raycast(fromPos,mr.Position-fromPos,vrp)==nil
end
local function trigger(pos)
    local now=os.clock()
    if now-lastTrig<0.6 then return end
    lastTrig=now
    threatUntil=now+0.35
    threatPos=pos
    pending=true
end
local function threatFrom(myPos)
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr~=LP then
            local c=plr.Character; local r=c and c:FindFirstChild("HumanoidRootPart"); local h=c and c:FindFirstChildOfClass("Humanoid")
            if r and h and h.Health>0 and armedTool(c) then
                local v=myPos-r.Position
                if v.Magnitude>2 and v.Magnitude<200 and r.CFrame.LookVector:Dot(v.Unit)>0.8 and canSee((c:FindFirstChild("Head") or r).Position,c) then return r.Position end
            end
        end
    end
    return nil
end
local function meleeThreat(myPos)
    local rng=Flags["Anti Aim/Melee Range"] or 12
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr~=LP then
            local c=plr.Character; local r=c and c:FindFirstChild("HumanoidRootPart"); local h=c and c:FindFirstChildOfClass("Humanoid")
            if r and h and h.Health>0 and armedTool(c) then
                local v=myPos-r.Position
                if v.Magnitude>0.5 and v.Magnitude<rng then
                    local closing=r.AssemblyLinearVelocity:Dot(v.Unit)>3
                    if (r.CFrame.LookVector:Dot(v.Unit)>0.35 or v.Magnitude<5) and (closing or v.Magnitude<7) and canSee((c:FindFirstChild("Head") or r).Position,c) then return r.Position end
                end
            end
        end
    end
    return nil
end
local watched={}
local function watch(plr)
    if plr==LP or watched[plr] then return end
    watched[plr]=true
    local function hook(c)
        task.spawn(function()
            local hum=c:WaitForChild("Humanoid",5); if not hum then return end
            local an=hum:FindFirstChildOfClass("Animator") or hum:WaitForChild("Animator",5); if not an then return end
            track(an.AnimationPlayed:Connect(function()
                if not Flags["Anti Aim/Anti Aim"] then return end
                local r=c:FindFirstChild("HumanoidRootPart"); local me=myRoot()
                if not r or not me or not armedTool(c) then return end
                local v=me.Position-r.Position; local dist=v.Magnitude
                if dist>1 and dist<250 and r.CFrame.LookVector:Dot(v.Unit)>0.5 and canSee((c:FindFirstChild("Head") or r).Position,c) then trigger(r.Position) end
            end))
        end)
    end
    if plr.Character then hook(plr.Character) end
    track(plr.CharacterAdded:Connect(hook))
end
for _,p in ipairs(Players:GetPlayers()) do watch(p) end
track(Players.PlayerAdded:Connect(watch))
track(workspace.DescendantAdded:Connect(function(o)
    if not Flags["Anti Aim/Anti Aim"] or not o:IsA("BasePart") then return end
    local n=string.lower(o.Name)
    if not (n:find("knife") or n:find("bullet") or n:find("projectile") or n:find("throw")) then return end
    local m=o:FindFirstAncestorOfClass("Model")
    if m and Players:GetPlayerFromCharacter(m) then return end
    local me=myRoot()
    if me and (o.Position-me.Position).Magnitude<200 and canSee(o.Position,o) then trigger(o.Position) end
end))
track(RunService.Heartbeat:Connect(function()
    if not Flags["Anti Aim/Anti Aim"] or Farm.Enabled then return end
    local now=os.clock()
    if now-last<(Flags["Anti Aim/Dodge Speed (ms)"] or 110)/1000 then return end
    local char=LP.Character; local hrp=char and char:FindFirstChild("HumanoidRootPart")
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum or hum.Health<=0 then return end
    local mode=Flags["Anti Aim/Anti Aim Mode"] or "On Shot"
    local from
    local melee=Flags["Anti Aim/Dodge Melee"] and meleeThreat(hrp.Position) or nil
    if melee then
        from=melee
    elseif mode=="On Shot" then
        if not pending or now>threatUntil or not threatPos then pending=false; return end
        from=threatPos
    elseif mode=="Aimed" then
        from=threatFrom(hrp.Position)
        if not from then return end
    end
    last=now
    if mode=="On Shot" and not melee then pending=false end
    local side
    if from then
        local dir=(hrp.Position-from); dir=Vector3.new(dir.X,0,dir.Z)
        if dir.Magnitude<0.1 then return end
        side=dir.Unit:Cross(Vector3.new(0,1,0))
    else
        side=hrp.CFrame.RightVector
    end
    local dist=(Flags["Anti Aim/Dodge Distance"] or 4)*(0.5+math.random()*0.5)
    if math.random()<0.5 then dist=-dist end
    local off=side*dist
    if melee then
        local away=hrp.Position-melee; away=Vector3.new(away.X,0,away.Z)
        if away.Magnitude>0.1 then off=side*(math.abs(dist)+3)*(dist<0 and -1 or 1)+away.Unit*4 end
    end
    rp.FilterDescendantsInstances={char}
    if workspace:Raycast(hrp.Position,off,rp) then
        if not melee then return end
        off=side*-1*off:Dot(side)
        if workspace:Raycast(hrp.Position,off,rp) then return end
    end
    hrp.CFrame=hrp.CFrame+off
end))
end

-- CROSSHAIR
do
local CROSS={H=120,S=0.9,V=1}
local chTab=createTab("Crosshair")
chTab:Label("Custom crosshair")
chTab:Toggle("Crosshair",false)
chTab:Choice("Crosshair Style",{"Cross","Plus","Dot","Circle","Circle Dot","X","T Shape","Square","Diamond"},"Cross")
local function refreshGr() for _,k in ipairs({"Crosshair/Cross Saturation","Crosshair/Cross Shade"}) do local f=GradRefresh[k]; if f then f() end end end
chTab:Choice("Crosshair Color",HAT_COLORS,"Custom")
chTab:Slider("Cross Hue",0,360,120,function(v) CROSS.H=v; refreshGr() end,function()
    local kp={} for k=0,6 do kp[#kp+1]=ColorSequenceKeypoint.new(k/6,Color3.fromHSV(k/6,1,1)) end return ColorSequence.new(kp)
end)
chTab:Slider("Cross Saturation",0,100,90,function(v) CROSS.S=v/100; refreshGr() end,function()
    local h=CROSS.H/360; return ColorSequence.new(Color3.fromHSV(h,0,CROSS.V),Color3.fromHSV(h,1,CROSS.V))
end)
chTab:Slider("Cross Shade",0,100,100,function(v) CROSS.V=v/100; refreshGr() end,function()
    local h=CROSS.H/360; return ColorSequence.new(Color3.new(0,0,0),Color3.fromHSV(h,CROSS.S,1))
end)
chTab:Slider("Crosshair Size",2,60,12)
chTab:Slider("Crosshair Thickness",1,8,2)
chTab:Slider("Crosshair Gap",0,30,4)
chTab:Slider("Crosshair Opacity",10,100,100)
chTab:Toggle("Crosshair Outline",true)
chTab:Toggle("Crosshair Spin",false)
chTab:Slider("Spin Speed",10,360,90)
local root=Instance.new("Frame"); root.Name="luxxsCrosshair"; root.AnchorPoint=Vector2.new(0.5,0.5); root.Position=UDim2.new(0.5,0,0.5,0)
root.Size=UDim2.new(0,0,0,0); root.BackgroundTransparency=1; root.ZIndex=30; root.Visible=false; root.Parent=ESPFolder
local elems,sig={},""
local function rebuild()
    for _,c in ipairs(root:GetChildren()) do c:Destroy() end
    elems={}
    local style=Flags["Crosshair/Crosshair Style"] or "Cross"
    local L=Flags["Crosshair/Crosshair Size"] or 12; local Th=Flags["Crosshair/Crosshair Thickness"] or 2; local G=Flags["Crosshair/Crosshair Gap"] or 4
    local outline=Flags["Crosshair/Crosshair Outline"]
    local function outl(parent)
        local o=Instance.new("UIStroke"); o.Color=Color3.new(0,0,0); o.Thickness=1; o.ApplyStrokeMode=Enum.ApplyStrokeMode.Border; o.Parent=parent
        elems[#elems+1]={s=o,out=true}
    end
    local function bar(cx,cy,w,h,rot,round)
        local f=Instance.new("Frame"); f.AnchorPoint=Vector2.new(0.5,0.5); f.Position=UDim2.new(0,cx,0,cy); f.Size=UDim2.new(0,w,0,h)
        f.BorderSizePixel=0; f.ZIndex=30; f.Rotation=rot or 0; f.Parent=root
        if round then corner(f,math.max(w,h)) end
        elems[#elems+1]={f=f}
        if outline then outl(f) end
        return f
    end
    local function hollow(sz,rot,round)
        local f=Instance.new("Frame"); f.AnchorPoint=Vector2.new(0.5,0.5); f.Position=UDim2.new(0,0,0,0); f.Size=UDim2.new(0,sz,0,sz)
        f.BackgroundTransparency=1; f.BorderSizePixel=0; f.ZIndex=30; f.Rotation=rot or 0; f.Parent=root
        if round then corner(f,sz) end
        local st=Instance.new("UIStroke"); st.Thickness=Th; st.ApplyStrokeMode=Enum.ApplyStrokeMode.Border; st.Parent=f
        elems[#elems+1]={s=st}
        if outline then
            local o=Instance.new("Frame"); o.AnchorPoint=Vector2.new(0.5,0.5); o.Size=UDim2.new(0,sz+Th*2+2,0,sz+Th*2+2); o.BackgroundTransparency=1; o.BorderSizePixel=0; o.ZIndex=29; o.Rotation=rot or 0; o.Parent=root
            o.Position=UDim2.new(0,0,0,0)
            if round then corner(o,sz+Th*2+2) end
            outl(o)
        end
    end
    local h=G+L/2
    if style=="Cross" then
        bar(0,-h,Th,L); bar(0,h,Th,L); bar(-h,0,L,Th); bar(h,0,L,Th)
    elseif style=="Plus" then
        bar(0,0,Th,L*2); bar(0,0,L*2,Th)
    elseif style=="Dot" then
        local d=math.max(Th*2,L/3); bar(0,0,d,d,0,true)
    elseif style=="Circle" then
        hollow(L*2,0,true)
    elseif style=="Circle Dot" then
        hollow(L*2,0,true); bar(0,0,math.max(Th*2,4),math.max(Th*2,4),0,true)
    elseif style=="X" then
        local k=h*0.7071
        for _,sx in ipairs({-1,1}) do for _,sy in ipairs({-1,1}) do bar(sx*k,sy*k,Th,L,(sx*sy>0) and -45 or 45) end end
    elseif style=="T Shape" then
        bar(-h,0,L,Th); bar(h,0,L,Th); bar(0,h,Th,L)
    elseif style=="Square" then
        hollow(L*2,0,false)
    elseif style=="Diamond" then
        hollow(L*1.5,45,false)
    end
end
local function chCol(t)
    local n=Flags["Crosshair/Crosshair Color"] or "Custom"
    if n=="Custom" then return Color3.fromHSV((CROSS.H%360)/360,math.clamp(CROSS.S,0,1),math.clamp(CROSS.V,0,1)) end
    return getColor(n,t,0)
end
track(RunService.RenderStepped:Connect(function(dt)
    local on=Flags["Crosshair/Crosshair"]
    root.Visible=on and true or false
    if not on then return end
    local sg=table.concat({tostring(Flags["Crosshair/Crosshair Style"]),tostring(Flags["Crosshair/Crosshair Size"]),tostring(Flags["Crosshair/Crosshair Thickness"]),tostring(Flags["Crosshair/Crosshair Gap"]),tostring(Flags["Crosshair/Crosshair Outline"])},"|")
    if sg~=sig then sig=sg; rebuild() end
    local col=chCol(os.clock())
    local tr=1-(Flags["Crosshair/Crosshair Opacity"] or 100)/100
    for _,e in ipairs(elems) do
        if e.f then e.f.BackgroundColor3=col; e.f.BackgroundTransparency=tr
        elseif e.s and not e.out then e.s.Color=col; e.s.Transparency=tr
        elseif e.s then e.s.Transparency=tr end
    end
    if Flags["Crosshair/Crosshair Spin"] then root.Rotation=(root.Rotation+(Flags["Crosshair/Spin Speed"] or 90)*dt)%360 else root.Rotation=0 end
end))
end

-- SCREEN
do
local screenTab=createTab("Screen")
screenTab:Label("Camera")
screenTab:Toggle("Custom FOV",false)
screenTab:Slider("Camera FOV",30,120,70)
screenTab:Label("Stretch")
screenTab:Toggle("Stretch Screen",false)
screenTab:Slider("Stretch Height (%)",30,100,65)
screenTab:Slider("Stretch Width (%)",100,200,100)
screenTab:Label("Bars")
screenTab:Choice("Aspect Bars",SCREEN_RATIOS,"Default",function(v) ScreenRes.apply(v,true) end)
screenTab:Button("Reset Screen",function()
    local function set(k,v) local f=Setters[k]; if f then pcall(f,v) end end
    set("Screen/Custom FOV",false); set("Screen/Camera FOV",70)
    set("Screen/Stretch Screen",false); set("Screen/Stretch Height (%)",65); set("Screen/Stretch Width (%)",100)
    notify("Screen reset")
end)
pcall(function() RunService:UnbindFromRenderStep("luxxsScreen") end)
local fovWas=false
RunService:BindToRenderStep("luxxsScreen",Enum.RenderPriority.Camera.Value+1,function()
    local cam=workspace.CurrentCamera; if not cam then return end
    if Flags["Screen/Custom FOV"] then cam.FieldOfView=Flags["Screen/Camera FOV"] or 70; fovWas=true
    elseif fovWas then fovWas=false; cam.FieldOfView=70 end
    if Flags["Screen/Stretch Screen"] then
        local sy=(Flags["Screen/Stretch Height (%)"] or 65)/100
        local sx=(Flags["Screen/Stretch Width (%)"] or 100)/100
        cam.CFrame=cam.CFrame*CFrame.new(0,0,0,sx,0,0,0,sy,0,0,0,1)
    end
end)
end

-- MISC
do
local miscTab=createTab("Misc")
local function charOf(plr)
    local c=plr and plr.Character
    local h=c and c:FindFirstChildOfClass("Humanoid")
    local r=c and c:FindFirstChild("HumanoidRootPart")
    if c and h and r and h.Health>0 then return c,h,r end
    return nil
end
local function tpToRole(role)
    local _,_,me=charOf(LP); if not me then notify("No character") return end
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr~=LP and getRoleCached(plr)==role then
            local _,_,r=charOf(plr)
            if r then me.CFrame=r.CFrame*CFrame.new(0,0,3); me.AssemblyLinearVelocity=Vector3.zero; notify("TP to "..role); return end
        end
    end
    notify(role.." not found")
end
miscTab:Label("Teleport")
miscTab:Button("Teleport to Murderer",function() tpToRole("Murderer") end)
miscTab:Button("Teleport to Sheriff",function() tpToRole("Sheriff") end)

miscTab:Label("Quick Bar")
miscTab:Toggle("Quick Bar",false,function(s) setQuickBarVisible(s); notify(s and "Quick Bar ON" or "Quick Bar OFF") end)
miscTab:Choice("Quick Bar Position",QB_POSITIONS,"Left",function(v) applyQbPosition(v,true); notify("QB: "..v) end)
miscTab:Choice("Quick Bar Color",QB_COLORS,"Accent",function() refreshQuickBar() end)
miscTab:Label("Quick Bar Buttons")
for _,act in ipairs(QB_ACTIONS) do
    miscTab:Toggle("QB "..act.label,act.def,function() refreshQuickBar() end)
end
miscTab:Label2("Стрелка у края экрана сворачивает/разворачивает панель",F_MONO,10,C.dim)

miscTab:Label("Screen")
miscTab:Choice("Aspect Ratio",SCREEN_RATIOS,"Default",function(v) ScreenRes.apply(v,true); notify("Screen: "..v) end)
miscTab:Label2("Cinematic bars для имитации другого соотношения",F_MONO,10,C.dim)
end

-- INFO
local setTab=createTab("Info")
setTab:Label("About luxxs")
setTab:Label2("luxxs v8.2 - crafted by DrHub",F_MONO,12,C.text)
setTab:Label2("Best scripts: luXxS, drHub, NurHub",F_MONO,12,C.text)
setTab:Label2("Telegram: "..TELEGRAM_LINK,F_MONO,11,C.dim)
setTab:Button("Copy Telegram link",function()
    if type(setclipboard)=="function" then pcall(setclipboard,TELEGRAM_LINK); notify("Link copied!") else notify(TELEGRAM_LINK) end
end)
setTab:Label("Interface")
setTab:Choice("Accent",ACCENT_NAMES,ACC_NAME,function(n)
    setAccent(ACCENTS[n]); restyleTabs(); if refreshQuickBar then refreshQuickBar() end
    if hasFS then ensureFolder(); pcall(function() writefile(FOLDER.."/accent.txt",n) end) end
end)
setTab:Label("Appearance")
setTab:Slider("Menu Opacity %",20,100,94,function(v) MenuAlpha=math.clamp(v/100,0,1); if isOpen then main.GroupTransparency=1-MenuAlpha end end)
setTab:Slider("Menu Scale %",70,130,100,function(v) MenuScale=math.clamp((tonumber(v) or 100)/100,0.5,2); if isOpen then scale.Scale=fitScale()*MenuScale end end)
setTab:Label("Configs")
do
local SLOTS={"1","2","3","4","5"}
local function cfgPath(s) return FOLDER.."/config_"..s..".json" end
local function isSettingsKey(k) return k:sub(1,9)=="Settings/" or k:sub(1,8)=="Shaders/" or k:find(" Preset",1,true)~=nil end
local function saveConfig(slot)
    if not hasFS then notify("FS not available") return end
    ensureFolder(); local data={}
    for k,v in pairs(Flags) do if not isSettingsKey(k) then data[k]=v end end
    local ok=pcall(function() writefile(cfgPath(slot),HttpService:JSONEncode(data)) end)
    notify(ok and ("Saved slot "..slot) or "Save error")
end
local function loadConfig(slot,silent)
    if not hasFS then if not silent then notify("FS not available") end return end
    local path=cfgPath(slot)
    if not isfile(path) then if not silent then notify("Slot "..slot.." empty") end return end
    local ok,data=pcall(function() return HttpService:JSONDecode(readfile(path)) end)
    if not ok or type(data)~="table" then notify("Read error") return end
    for k,v in pairs(data) do if Setters[k] and not isSettingsKey(k) then Setters[k](v) end end
    notify("Loaded slot "..slot)
end
setTab:Choice("Config Slot",SLOTS,"1")
setTab:Button("Save Config",function() saveConfig(Flags["Info/Config Slot"] or "1") end)
setTab:Button("Load Config",function() loadConfig(Flags["Info/Config Slot"] or "1") end)
setTab:Button("Reset All",function()
    for k,d in pairs(Defaults) do if not isSettingsKey(k) and Setters[k] then Setters[k](d) end end
    notify("Settings reset")
end)
end
setTab:Button("Close Menu",closeMenu)
setTab:Button("Unload luxxs",function()
    for _,c in ipairs(connections) do pcall(function() c:Disconnect() end) end
    destroyCos("wings"); destroyCos("hat"); destroyCos("trail"); pcall(_G.LUXXS_HEADLESS_RESTORE); pcall(_G.LUXXS_SPIKE_RESTORE); for _,f in ipairs(_G.LUXXS_CLEAN or {}) do pcall(f) end; pcall(function() RunService:UnbindFromRenderStep("luxxsScreen") end)
    for plr in pairs(espData) do removeESP(plr) end
    for p in pairs(GunESP.vis) do dropGunVisual(p) end
    pcall(function() GunFolder:Destroy() end)
    pcall(disableFlyMove); pcall(setNoclipMove,false)
    pcall(stopAutoWin); pcall(stopSpin)
    BHop.Enabled=false
    pcall(Skin.restoreAll)
    stopFarm(); disableFps(); gui:Destroy(); fpsGui:Destroy()
end)

-- SKINS TAB
do
local skinTab=createTab("Skins")
skinTab:Label("Weapon skins (visual)")
skinTab:Toggle("Enable",false,function() Skin.refresh() end)
do
local rainGrads={}
local function mkSeq(def)
    if def.rainbow then
        local kp={} for k=0,6 do kp[#kp+1]=ColorSequenceKeypoint.new(k/6,Color3.fromHSV(k/6,0.85,1)) end
        return ColorSequence.new(kp)
    end
    return ColorSequence.new(def.a,def.b)
end
local function drawIcon(parent,kind,def)
    local box=Instance.new("Frame"); box.Size=UDim2.new(1,0,0,62); box.BackgroundColor3=Color3.fromRGB(14,14,18); box.BorderSizePixel=0; box.Parent=parent; corner(box,8)
    local glow=Instance.new("Frame"); glow.AnchorPoint=Vector2.new(0.5,0.5); glow.Position=UDim2.new(0.5,0,0.5,0); glow.Size=UDim2.new(0.8,0,0.8,0); glow.BackgroundColor3=def and def.b or C.dim; glow.BackgroundTransparency=0.85; glow.BorderSizePixel=0; glow.Parent=box; corner(glow,30)
    if not def then
        local x=Instance.new("TextLabel"); x.BackgroundTransparency=1; x.Size=UDim2.new(1,0,1,0); x.Font=F_SEC; x.TextSize=18; x.TextColor3=C.dim; x.Text="OFF"; x.Parent=box
        return box
    end
    if def.model then
        local vf=Instance.new("ViewportFrame"); vf.Size=UDim2.new(1,0,1,0); vf.BackgroundTransparency=1; vf.BorderSizePixel=0; vf.Ambient=Color3.fromRGB(190,190,190); vf.LightColor=Color3.new(1,1,1); vf.Parent=box
        local cam=Instance.new("Camera"); cam.Parent=vf; vf.CurrentCamera=cam
        local m=Instance.new("Model"); m.Parent=vf
        pcall(function()
            for _,p in ipairs(def.model:GetDescendants()) do
                if p:IsA("BasePart") then local c=p:Clone(); for _,x in ipairs(c:GetChildren()) do if x:IsA("BasePart") then x:Destroy() end end; c.Anchored=true; c.Parent=m end
            end
            local cf,sz=m:GetBoundingBox()
            local md=math.max(sz.X,sz.Y,sz.Z,0.5)
            local dir=(cf.RightVector*0.8+cf.UpVector*0.35+cf.LookVector*0.9).Unit
            cam.FieldOfView=40
            cam.CFrame=CFrame.lookAt(cf.Position+dir*md*1.9,cf.Position)
        end)
        return box
    end
    local function part(p,x,y,w,h,rot,seq,rnd)
        local f=Instance.new("Frame"); f.AnchorPoint=Vector2.new(0.5,0.5); f.Position=UDim2.new(0,x,0,y); f.Size=UDim2.new(0,w,0,h); f.Rotation=rot or 0
        f.BackgroundColor3=Color3.new(1,1,1); f.BorderSizePixel=0; f.Parent=p
        if rnd then corner(f,rnd) end
        local g=Instance.new("UIGradient"); g.Color=seq; g.Parent=f
        if def.rainbow then rainGrads[#rainGrads+1]=g end
        return f
    end
    local seq=mkSeq(def)
    local dark=ColorSequence.new(def.a:Lerp(Color3.new(0,0,0),0.55),def.a:Lerp(Color3.new(0,0,0),0.3))
    local stage=Instance.new("Frame"); stage.AnchorPoint=Vector2.new(0.5,0.5); stage.Position=UDim2.new(0.5,0,0.5,0); stage.Size=UDim2.new(0,76,0,52); stage.BackgroundTransparency=1; stage.Parent=box
    if kind=="Knife" then
        local k=Instance.new("Frame"); k.AnchorPoint=Vector2.new(0.5,0.5); k.Position=UDim2.new(0.5,0,0.5,0); k.Size=UDim2.new(0,70,0,16); k.BackgroundTransparency=1; k.Rotation=-35; k.Parent=stage
        part(k,10,8,20,6,0,dark,3)
        part(k,22,8,4,15,0,seq,2)
        part(k,46,8,46,10,0,seq,5)
        part(k,40,8,32,3,0,ColorSequence.new(Color3.new(1,1,1)),1).BackgroundTransparency=0.55
    else
        local g=Instance.new("Frame"); g.AnchorPoint=Vector2.new(0.5,0.5); g.Position=UDim2.new(0.5,0,0.5,0); g.Size=UDim2.new(0,70,0,40); g.BackgroundTransparency=1; g.Parent=stage
        part(g,40,12,52,9,0,seq,3)
        part(g,22,15,28,16,0,seq,4)
        part(g,17,31,10,20,14,dark,3)
        part(g,38,22,8,5,0,dark,2)
        part(g,52,10,24,2,0,ColorSequence.new(Color3.new(1,1,1)),1).BackgroundTransparency=0.6
    end
    return box
end
local function gallery(title,kind,names,key)
    skinTab:Label2(title,F_MONO,10,C.dim)
    local f=skinTab:Frame(138)
    local sf=Instance.new("ScrollingFrame"); sf.Size=UDim2.new(1,0,1,0); sf.BackgroundColor3=C.row; sf.BackgroundTransparency=0.45; sf.BorderSizePixel=0
    sf.ScrollBarThickness=3; sf.ScrollingDirection=Enum.ScrollingDirection.X; sf.CanvasSize=UDim2.new(0,0,0,0); sf.AutomaticCanvasSize=Enum.AutomaticSize.X; sf.Parent=f
    corner(sf,8); T(sf,"ScrollBarImageColor3")
    local ll=Instance.new("UIListLayout"); ll.FillDirection=Enum.FillDirection.Horizontal; ll.Padding=UDim.new(0,6); ll.SortOrder=Enum.SortOrder.LayoutOrder; ll.Parent=sf
    local pd=Instance.new("UIPadding"); pd.PaddingTop=UDim.new(0,6); pd.PaddingLeft=UDim.new(0,6); pd.PaddingRight=UDim.new(0,6); pd.Parent=sf
    local cards={}
    local current="Off"
    local function paint()
        for n,c in pairs(cards) do
            local on=(n==current)
            c.st.Color=on and ACC or C.dim; c.st.Thickness=on and 2 or 1; c.st.Transparency=on and 0 or 0.7
            c.lbl.TextColor3=on and C.text or C.dim
        end
    end
    register(key,"Off",function(v)
        if v~="Off" and not Skin.defs[v] then return end
        current=v; Flags[key]=v; paint()
        task.spawn(function() task.wait(0.05); Skin.refresh() end)
    end)
    local order={"Off"}
    for _,n in ipairs(names) do order[#order+1]=n end
    local nextOrder=0
    local function addCard(n)
        if cards[n] then return end
        nextOrder+=1; local i=nextOrder
        local card=Instance.new("TextButton"); card.Size=UDim2.new(0,88,0,118); card.BackgroundColor3=C.bg; card.BackgroundTransparency=0.35; card.BorderSizePixel=0
        card.AutoButtonColor=false; card.Text=""; card.LayoutOrder=i; card.Parent=sf; corner(card,10)
        local st=stroke(card,C.dim,1,0.7)
        local pad=Instance.new("UIPadding"); pad.PaddingTop=UDim.new(0,4); pad.PaddingLeft=UDim.new(0,4); pad.PaddingRight=UDim.new(0,4); pad.Parent=card
        drawIcon(card,kind,Skin.defs[n])
        local lbl=Instance.new("TextLabel"); lbl.BackgroundTransparency=1; lbl.Position=UDim2.new(0,0,0,66); lbl.Size=UDim2.new(1,0,0,44); lbl.Font=F_BODY; lbl.TextSize=12
        lbl.TextWrapped=true; lbl.TextColor3=C.dim; lbl.Text=n; lbl.Parent=card
        cards[n]={st=st,lbl=lbl}
        card.MouseButton1Click:Connect(function() Setters[key](n) end)
        paint()
    end
    for _,n in ipairs(order) do addCard(n) end
    Skin.listeners[kind][#Skin.listeners[kind]+1]=addCard
    paint()
end
gallery("Knife skins (tap a card)","Knife",Skin.knives,"Skins/Knife Skin")
gallery("Gun skins (tap a card)","Gun",Skin.guns,"Skins/Gun Skin")
track(RunService.Heartbeat:Connect(function()
    if #rainGrads==0 then return end
    local o=Vector2.new(((os.clock()*0.4)%2)-1,0)
    for _,g in ipairs(rainGrads) do if g.Parent then g.Offset=o end end
end))
end
skinTab:Label("Game skins")
skinTab:Toggle("Auto Capture Skins",true)
skinTab:Button("Scan Game Skins",function()
    task.spawn(function()
        local added,total=Skin.scan(Skin.cfg.Folder or "")
        notify("Scan: "..total.." models found, "..added.." new")
    end)
end)
skinTab:Button("Copy Skins Of Players",function()
    Skin.capturePlayers(); notify("Captured weapons of other players")
end)
skinTab:Input("Skin Folder","",function(txt) Skin.cfg.Folder=txt end)
skinTab:Button("Dump Skin Data",function()
    local out={"count knives="..#Skin.knives.." guns="..#Skin.guns}
    for _,l in ipairs(Skin.scanLog) do out[#out+1]=l end
    local txt=table.concat(out,"\n")
    if type(setclipboard)=="function" then pcall(setclipboard,txt) end
    notify("Skin data copied ("..#Skin.scanLog.." paths)")
end)
skinTab:Label("Custom mesh")
skinTab:Input("Knife MeshId","",function(txt) Skin.cfg.KnifeMesh=txt; Skin.refresh() end)
skinTab:Input("Knife TextureId","",function(txt) Skin.cfg.KnifeTex=txt; Skin.refresh() end)
skinTab:Input("Gun MeshId","",function(txt) Skin.cfg.GunMesh=txt; Skin.refresh() end)
skinTab:Input("Gun TextureId","",function(txt) Skin.cfg.GunTex=txt; Skin.refresh() end)
skinTab:Slider("Mesh Scale %",10,500,100,function() Skin.refresh() end)
skinTab:Button("Remove all skins",function()
    Setters["Skins/Knife Skin"]("Off"); Setters["Skins/Gun Skin"]("Off")
    Skin.cfg.KnifeMesh=""; Skin.cfg.KnifeTex=""; Skin.cfg.GunMesh=""; Skin.cfg.GunTex=""
    Skin.refresh(); notify("Skins removed")
end)
end

__safe("move+",function()
track(RunService.Heartbeat:Connect(function()
    if not Flags["Move/Jump Power"] then return end
    local c=LP.Character; local h=c and c:FindFirstChildOfClass("Humanoid"); if not h then return end
    if h.UseJumpPower==false then h.UseJumpPower=true end
    h.JumpPower=Flags["Move/Jump Power Value"] or 100
end))
track(UIS.JumpRequest:Connect(function()
    if not Flags["Move/Infinite Jump"] then return end
    local c=LP.Character; local h=c and c:FindFirstChildOfClass("Humanoid")
    if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
end))
track(RunService.Stepped:Connect(function()
    if not Flags["Move/Anti Fling"] then return end
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr~=LP then
            local c=plr.Character
            if c then for _,p in ipairs(c:GetChildren()) do if p:IsA("BasePart") and p.CanCollide then p.CanCollide=false end end end
        end
    end
    local c=LP.Character; local hrp=c and c:FindFirstChild("HumanoidRootPart")
    if hrp then
        if not Flags["Move/Spin"] and hrp.AssemblyAngularVelocity.Magnitude>60 then hrp.AssemblyAngularVelocity=Vector3.zero end
        if not (Flags["Move/Fly"] or Flags["Move/Jump Power"] or Flags["Move/Bunnyhop"]) and hrp.AssemblyLinearVelocity.Magnitude>350 then hrp.AssemblyLinearVelocity=Vector3.zero end
    end
end))
end)

__safe("hitbox",function()
local hbTab=createTab("Hitbox")
hbTab:Label("Hitbox Expander")
hbTab:Toggle("Hitbox Expander",false)
hbTab:Choice("Hitbox Part",{"HumanoidRootPart","Head"},"HumanoidRootPart")
hbTab:Slider("Hitbox Size",2,60,12)
hbTab:Slider("Hitbox Transparency",0,100,70)
hbTab:Choice("Hitbox Targets",{"Everyone","Skip Innocents"},"Everyone")
hbTab:Label2("Resizes other players on your screen only.",F_MONO,10,C.dim)
hbTab:Label("Hit Marker")
hbTab:Toggle("Hit Marker",true)
hbTab:Toggle("Hit Sound",true)
hbTab:Slider("Hit Volume",1,100,60)
local hsId="rbxasset://sounds/electronicpingshort.wav"
hbTab:Input("Hit Sound ID",hsId,function(t) if t and t~="" then hsId=(t:match("^%d+$") and ("rbxassetid://"..t)) or t end end)

local orig={}
local function restoreAll()
    for p,o in pairs(orig) do if p.Parent then pcall(function() p.Size=o.s; p.Transparency=o.t; p.CanCollide=o.c; p.Massless=o.m end) end end
    orig={}
end
table.insert(_G.LUXXS_CLEAN,restoreAll)
track(RunService.Heartbeat:Connect(function()
    if not Flags["Hitbox/Hitbox Expander"] then if next(orig) then restoreAll() end return end
    local partName=Flags["Hitbox/Hitbox Part"] or "HumanoidRootPart"
    local sz=Flags["Hitbox/Hitbox Size"] or 12
    local tr=(Flags["Hitbox/Hitbox Transparency"] or 70)/100
    local skip=Flags["Hitbox/Hitbox Targets"]=="Skip Innocents"
    local myRole=skip and getRoleCached(LP) or nil
    local active={}
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr~=LP then
            local c=plr.Character; local p=c and c:FindFirstChild(partName); local hum=c and c:FindFirstChildOfClass("Humanoid")
            if p and p:IsA("BasePart") and hum and hum.Health>0 then
                local ok=true
                if skip and myRole~="Murderer" and getRoleCached(plr)=="Innocent" then ok=false end
                if ok then
                    active[p]=true
                    if not orig[p] then orig[p]={s=p.Size,t=p.Transparency,c=p.CanCollide,m=p.Massless} end
                    p.Size=Vector3.new(sz,sz,sz); p.Transparency=tr; p.CanCollide=false; p.Massless=true
                end
            end
        end
    end
    for p,o in pairs(orig) do
        if not active[p] then
            if p.Parent then pcall(function() p.Size=o.s; p.Transparency=o.t; p.CanCollide=o.c; p.Massless=o.m end) end
            orig[p]=nil
        end
    end
end))

-- hit marker
local hm=Instance.new("Frame"); hm.Name="luxxsHit"; hm.AnchorPoint=Vector2.new(0.5,0.5); hm.Position=UDim2.new(0.5,0,0.5,0); hm.Size=UDim2.new(0,0,0,0); hm.BackgroundTransparency=1; hm.Visible=false; hm.ZIndex=40; hm.Parent=gui
local hl={}
for i=1,4 do
    local f=Instance.new("Frame"); f.AnchorPoint=Vector2.new(0.5,0.5); f.Size=UDim2.new(0,9,0,2); f.BorderSizePixel=0; f.BackgroundColor3=WHITE; f.ZIndex=40; f.Parent=hm
    local a=math.rad(45+90*(i-1)); f.Position=UDim2.new(0,math.cos(a)*10,0,math.sin(a)*10); f.Rotation=math.deg(a); hl[i]=f
end
local hmTok,lastAtk=0,0
local function holding()
    local c=LP.Character; if not c then return false end
    for _,t in ipairs(c:GetChildren()) do if t:IsA("Tool") and scanName(t.Name) then return true end end
    return false
end
local function showHit(kill)
    hmTok+=1; local my=hmTok
    hm.Visible=true
    for _,f in ipairs(hl) do f.BackgroundColor3=kill and Color3.fromRGB(255,60,60) or WHITE end
    if Flags["Hitbox/Hit Sound"] then
        pcall(function()
            local snd=Instance.new("Sound"); snd.SoundId=hsId; snd.Volume=(Flags["Hitbox/Hit Volume"] or 60)/50
            snd.Parent=game:GetService("SoundService"); snd:Play(); game:GetService("Debris"):AddItem(snd,3)
        end)
    end
    task.delay(0.35,function() if hmTok==my then hm.Visible=false end end)
end
track(UIS.InputBegan:Connect(function(i)
    local ut=i.UserInputType
    if ut==Enum.UserInputType.Touch or ut==Enum.UserInputType.MouseButton1 then lastAtk=os.clock() end
end))
local function hookPlr(plr)
    if plr==LP then return end
    local function onChar(c)
        local h=c:WaitForChild("Humanoid",5); if not h then return end
        local last=h.Health
        track(h.HealthChanged:Connect(function(hp)
            if hp<last and Flags["Hitbox/Hit Marker"] and os.clock()-lastAtk<1.2 and holding() then showHit(hp<=0) end
            last=hp
        end))
    end
    if plr.Character then task.spawn(onChar,plr.Character) end
    track(plr.CharacterAdded:Connect(function(c) task.spawn(onChar,c) end))
end
for _,p in ipairs(Players:GetPlayers()) do hookPlr(p) end
track(Players.PlayerAdded:Connect(hookPlr))
end)

__safe("hud",function()
local hudTab=createTab("HUD")
hudTab:Label("Watermark")
hudTab:Toggle("Watermark",true)
hudTab:Label("Spectators")
hudTab:Toggle("Spectator List",true)
hudTab:Label("Radar")
hudTab:Toggle("Radar",false)
hudTab:Slider("Radar Range",30,500,120)
hudTab:Slider("Radar Size",80,220,130)
hudTab:Label("Alerts")
hudTab:Toggle("Gun Drop Alert",true)
local t0=os.clock()

-- watermark
local wm=Instance.new("Frame"); wm.Name="luxxsWatermark"; wm.Position=UDim2.new(0,10,0,80); wm.Size=UDim2.new(0,0,0,24); wm.AutomaticSize=Enum.AutomaticSize.X
wm.BackgroundColor3=C.bg; wm.BackgroundTransparency=0.25; wm.BorderSizePixel=0; wm.ZIndex=30; wm.Parent=gui; corner(wm,6)
local wmBar=Instance.new("Frame"); wmBar.Size=UDim2.new(1,0,0,2); wmBar.BorderSizePixel=0; wmBar.ZIndex=31; wmBar.Parent=wm; T(wmBar,"BackgroundColor3")
local wmPad=Instance.new("UIPadding"); wmPad.PaddingLeft=UDim.new(0,10); wmPad.PaddingRight=UDim.new(0,10); wmPad.Parent=wm
local wmL=Instance.new("TextLabel"); wmL.BackgroundTransparency=1; wmL.Size=UDim2.new(0,0,1,0); wmL.AutomaticSize=Enum.AutomaticSize.X; wmL.Font=F_MONO; wmL.TextSize=12; wmL.TextColor3=C.text; wmL.Text="luxxs"; wmL.ZIndex=31; wmL.Parent=wm
makeDraggable(wm,wm)

-- spectators
local sp=Instance.new("Frame"); sp.Name="luxxsSpec"; sp.Position=UDim2.new(0,10,0,112); sp.Size=UDim2.new(0,150,0,0); sp.AutomaticSize=Enum.AutomaticSize.Y
sp.BackgroundColor3=C.bg; sp.BackgroundTransparency=0.25; sp.BorderSizePixel=0; sp.ZIndex=30; sp.Parent=gui; corner(sp,6)
local spBar=Instance.new("Frame"); spBar.Size=UDim2.new(1,0,0,2); spBar.BorderSizePixel=0; spBar.ZIndex=31; spBar.Parent=sp; T(spBar,"BackgroundColor3")
local spPad=Instance.new("UIPadding"); spPad.PaddingLeft=UDim.new(0,8); spPad.PaddingRight=UDim.new(0,8); spPad.PaddingTop=UDim.new(0,5); spPad.PaddingBottom=UDim.new(0,5); spPad.Parent=sp
local spL=Instance.new("TextLabel"); spL.BackgroundTransparency=1; spL.Size=UDim2.new(1,0,0,0); spL.AutomaticSize=Enum.AutomaticSize.Y; spL.Font=F_MONO; spL.TextSize=11; spL.TextColor3=C.text
spL.TextXAlignment=Enum.TextXAlignment.Left; spL.TextYAlignment=Enum.TextYAlignment.Top; spL.TextWrapped=true; spL.RichText=true; spL.ZIndex=31; spL.Text="SPECTATORS"; spL.Parent=sp
makeDraggable(sp,sp)
local seen={}

-- radar
local rd=Instance.new("Frame"); rd.Name="luxxsRadar"; rd.AnchorPoint=Vector2.new(1,0); rd.Position=UDim2.new(1,-12,0,80); rd.Size=UDim2.new(0,130,0,130)
rd.BackgroundColor3=C.bg; rd.BackgroundTransparency=0.35; rd.BorderSizePixel=0; rd.ZIndex=30; rd.Visible=false; rd.Parent=gui; corner(rd,999)
T(stroke(rd,ACC,1.5,0.2),"Color")
local function rline(w,h) local f=Instance.new("Frame"); f.AnchorPoint=Vector2.new(0.5,0.5); f.Position=UDim2.new(0.5,0,0.5,0); f.Size=UDim2.new(0,w,0,h); f.BackgroundColor3=C.line; f.BackgroundTransparency=0.4; f.BorderSizePixel=0; f.ZIndex=31; f.Parent=rd; return f end
local rl1,rl2=rline(1,130),rline(130,1)
local me=Instance.new("Frame"); me.AnchorPoint=Vector2.new(0.5,0.5); me.Position=UDim2.new(0.5,0,0.5,0); me.Size=UDim2.new(0,7,0,7); me.BorderSizePixel=0; me.ZIndex=33; me.Parent=rd; corner(me,4); T(me,"BackgroundColor3")
makeDraggable(rd,rd)
local dots={}

local acc,frames,fps=0,0,60
track(RunService.RenderStepped:Connect(function(dt)
    frames+=1; acc+=dt
    local cam=workspace.CurrentCamera
    -- radar every frame
    local ron=Flags["HUD/Radar"] and cam~=nil
    rd.Visible=ron and true or false
    if ron then
        local R0=(Flags["HUD/Radar Size"] or 130)
        rd.Size=UDim2.new(0,R0,0,R0); rl1.Size=UDim2.new(0,1,0,R0); rl2.Size=UDim2.new(0,R0,0,1)
        local R=R0/2-4
        local range=Flags["HUD/Radar Range"] or 120
        local cf=cam.CFrame
        local look=Vector3.new(cf.LookVector.X,0,cf.LookVector.Z)
        if look.Magnitude<0.01 then look=Vector3.new(0,0,-1) end
        look=look.Unit
        local right=Vector3.new(-look.Z,0,look.X)
        local mc=LP.Character; local mr=mc and mc:FindFirstChild("HumanoidRootPart")
        local mp=mr and mr.Position or cf.Position
        for _,plr in ipairs(Players:GetPlayers()) do
            if plr~=LP then
                local c=plr.Character; local r=c and c:FindFirstChild("HumanoidRootPart"); local h=c and c:FindFirstChildOfClass("Humanoid")
                local dot=dots[plr]
                if r and h and h.Health>0 then
                    if not dot then dot=Instance.new("Frame"); dot.AnchorPoint=Vector2.new(0.5,0.5); dot.Size=UDim2.new(0,6,0,6); dot.BorderSizePixel=0; dot.ZIndex=32; dot.Parent=rd; corner(dot,3); dots[plr]=dot end
                    local d=r.Position-mp
                    local px,py=d:Dot(right)/range*R,-d:Dot(look)/range*R
                    local m=math.sqrt(px*px+py*py)
                    if m>R then px,py=px/m*R,py/m*R end
                    dot.Position=UDim2.new(0.5,px,0.5,py)
                    dot.BackgroundColor3=ROLE_COLORS[getRoleCached(plr)] or WHITE
                    dot.Visible=true
                elseif dot then dot.Visible=false end
            end
        end
    else
        for _,d in pairs(dots) do d.Visible=false end
    end
    if acc<0.5 then return end
    fps=math.floor(frames/acc+0.5); frames=0; acc=0
    wm.Visible=Flags["HUD/Watermark"] and true or false
    if wm.Visible then
        local ping=0; pcall(function() ping=math.floor(LP:GetNetworkPing()*1000+0.5) end)
        local up=math.floor(os.clock()-t0)
        wmL.Text=string.format("luxxs  |  %d fps  |  %d ms  |  %02d:%02d:%02d",fps,ping,math.floor(up/3600),math.floor(up/60)%60,up%60)
    end
end))

task.spawn(function()
    while gui.Parent do
        sp.Visible=Flags["HUD/Spectator List"] and true or false
        if sp.Visible then
            if not MM2State.have then seen={} end
            for n in pairs(MM2State.active) do seen[n]=true end
            local names={}
            for n in pairs(seen) do
                if n~=LP.Name and not MM2State.active[n] and Players:FindFirstChild(n) then names[#names+1]=n end
            end
            table.sort(names)
            spL.Text="SPECTATORS (dead players)\n"..((#names>0) and table.concat(names,"\n") or "none")
        end
        task.wait(1)
    end
end)

local lastDrop=0
track(workspace.DescendantAdded:Connect(function(o)
    if not Flags["HUD/Gun Drop Alert"] then return end
    if string.lower(o.Name)~="gundrop" then return end
    if not (o:IsA("BasePart") or o:IsA("Model")) then return end
    if os.clock()-lastDrop<3 then return end
    lastDrop=os.clock()
    notify("Sheriff dropped the gun!")
    pcall(function()
        local snd=Instance.new("Sound"); snd.SoundId="rbxasset://sounds/electronicpingshort.wav"; snd.Volume=1
        snd.Parent=game:GetService("SoundService"); snd:Play(); game:GetService("Debris"):AddItem(snd,3)
    end)
end))
end)

-- FPS TAB
do
local fpsTab=createTab("FPS")
fpsTab:Label("Unlocker")
fpsTab:Toggle("Enable Unlock",false,function(state) FPS.Enabled=state; if state then enableFps() else disableFps() end end)
fpsTab:Slider("Target FPS",60,10000,10000,function(v) FPS.Target=v; if FPS.Enabled then applyFpsCap(v) end end)
fpsTab:Button("60 FPS",function() Setters["FPS/Target FPS"](60) end)
fpsTab:Button("120 FPS",function() Setters["FPS/Target FPS"](120) end)
fpsTab:Button("240 FPS",function() Setters["FPS/Target FPS"](240) end)
fpsTab:Button("1000 FPS",function() Setters["FPS/Target FPS"](1000) end)
fpsTab:Toggle("Show Counter",true,function(state) fpsFrame.Visible=state end)
fpsTab:Label("Optimization")
local fxOrig={shadows=Lighting.GlobalShadows,fog=Lighting.FogEnd}
local fxChanged={shadows=false,fog=false}
local fxOff={}
fpsTab:Toggle("Remove Shadows",false,function(state)
    if state then fxChanged.shadows=true; Lighting.GlobalShadows=false
    elseif fxChanged.shadows then fxChanged.shadows=false; Lighting.GlobalShadows=fxOrig.shadows end
end)
fpsTab:Toggle("Remove Fog",false,function(state)
    if state then fxChanged.fog=true; Lighting.FogEnd=1e6
    elseif fxChanged.fog then fxChanged.fog=false; Lighting.FogEnd=fxOrig.fog end
end)
fpsTab:Toggle("Remove Effects",false,function(state)
    if state then
        for _,e in ipairs(Lighting:GetChildren()) do
            if (e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect")) and e.Enabled then fxOff[#fxOff+1]=e; e.Enabled=false end
        end
    else
        for _,e in ipairs(fxOff) do if e.Parent then e.Enabled=true end end
        fxOff={}
    end
end)
end

__safe("keybinds",function()
local kb=createTab("Keybinds")
kb:Label2("Tap a function, then press a key. Backspace clears.",F_MONO,10,C.dim)
local list={}
for k,d in pairs(Defaults) do
    if type(d)=="boolean" and k:sub(1,9)~="Settings/" and k:sub(1,8)~="Shaders/" and k:sub(1,9)~="Keybinds/" and not k:find(" Preset",1,true) then list[#list+1]=k end
end
table.sort(list)
local map,refresh={},{}
local listening=nil
local function rebuild()
    map={}
    for _,k in ipairs(list) do
        local v=Flags["Keybinds/"..k]
        if v and v~="None" then map[v]=map[v] or {}; table.insert(map[v],k) end
    end
end
for _,k in ipairs(list) do
    local fk="Keybinds/"..k
    local f=kb:Frame(30)
    local b=Instance.new("TextButton"); b.Size=UDim2.new(1,0,1,-2); b.BackgroundColor3=C.row; b.BackgroundTransparency=0.55; b.BorderSizePixel=0; b.AutoButtonColor=false; b.Text=""; b.Parent=f; corner(b,8)
    local l=Instance.new("TextLabel"); l.BackgroundTransparency=1; l.Position=UDim2.new(0,10,0,0); l.Size=UDim2.new(1,-90,1,0); l.Font=F_BODY; l.TextSize=13; l.TextColor3=C.text; l.TextXAlignment=Enum.TextXAlignment.Left; l.TextTruncate=Enum.TextTruncate.AtEnd; l.Text=string.gsub(k,"/"," > "); l.Parent=b
    local v=Instance.new("TextLabel"); v.BackgroundTransparency=1; v.AnchorPoint=Vector2.new(1,0); v.Position=UDim2.new(1,-10,0,0); v.Size=UDim2.new(0,76,1,0); v.Font=F_MONO; v.TextSize=12; v.TextXAlignment=Enum.TextXAlignment.Right; v.Parent=b
    local function paint()
        local val=Flags[fk] or "None"
        if listening==fk then v.Text="..."; v.TextColor3=ACC else v.Text="["..val.."]"; v.TextColor3=(val=="None") and C.dim or ACC end
    end
    refresh[fk]=paint
    register(fk,"None",function(val) Flags[fk]=val; paint(); rebuild() end)
    paint()
    b.MouseButton1Click:Connect(function()
        local prev=listening
        listening=fk; paint()
        if prev and refresh[prev] then refresh[prev]() end
    end)
end
track(UIS.InputBegan:Connect(function(i,gp)
    if i.UserInputType~=Enum.UserInputType.Keyboard then return end
    if listening then
        local fk=listening; listening=nil
        local nm=i.KeyCode.Name
        if i.KeyCode==Enum.KeyCode.Backspace or i.KeyCode==Enum.KeyCode.Escape then nm="None" end
        Setters[fk](nm)
        return
    end
    if gp then return end
    local fl=map[i.KeyCode.Name]
    if fl then
        for _,k in ipairs(fl) do
            local s=Setters[k]; if s then s(not Flags[k]) end
        end
    end
end))
end)

-- PROFILE
local profileTab=createTab("Profile")
profileTab:Label("Player")
local profUser=profileTab:Label2("USER      "..LP.Name,F_MONO,13,C.text)
local profRole=profileTab:Label2("ROLE      Innocent",F_MONO,13,C.text)
local profSession=profileTab:Label2("SESSION   00:00:00",F_MONO,12,C.dim)
local profCoins=profileTab:Label2("COINS     0",F_MONO,12,C.dim)
local profFps=profileTab:Label2("FPS       0 | avg 0 | max 0",F_MONO,12,C.dim)
profileTab:Button("Refresh",function()
    profUser.Text="USER      "..LP.Name
    profRole.Text="ROLE      "..getRole(LP)
    profCoins.Text="COINS     "..Farm.Collected
    notify("Refreshed")
end)

-- PREVIEW
local function solid(p,x,y,w,h,color,z,r)
    local f=Instance.new("Frame"); f.Position=UDim2.new(0,x,0,y); f.Size=UDim2.new(0,w,0,h); f.BackgroundColor3=color; f.BorderSizePixel=0; f.ZIndex=z or 1; f.Parent=p
    if r and r>0 then corner(f,r) end
    return f
end
local function line(p,x1,y1,x2,y2,thick,color,z)
    local dx,dy=x2-x1,y2-y1
    local f=Instance.new("Frame"); f.AnchorPoint=Vector2.new(0.5,0.5); f.Position=UDim2.new(0,(x1+x2)/2,0,(y1+y2)/2); f.Size=UDim2.new(0,math.sqrt(dx*dx+dy*dy),0,thick); f.Rotation=math.deg(math.atan2(dy,dx)); f.BackgroundColor3=color; f.BorderSizePixel=0; f.ZIndex=z or 1; f.Parent=p
    return f
end

local function buildPreview(panel)
    local PW,PH=252,372
    panel.BackgroundColor3=WHITE; panel.ClipsDescendants=true; corner(panel,14)
    gradient(panel,90,ColorSequence.new(Color3.fromRGB(34,24,50),Color3.fromRGB(8,8,12)))
    T(stroke(panel,ACC,1.5,0.4),"Color")

    for i,y in ipairs({308,318,331,348,370}) do
        local f=solid(panel,0,y,PW,1,WHITE,1); f.BackgroundTransparency=0.9-i*0.02; T(f,"BackgroundColor3")
    end
    for i=-5,5 do
        local l=line(panel,126+i*6,300,126+i*44,372,1,WHITE,1); l.BackgroundTransparency=0.9; T(l,"BackgroundColor3")
    end

    local scanBand=solid(panel,0,0,PW,38,WHITE,2); T(scanBand,"BackgroundColor3")
    gradient(scanBand,90,nil,NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(1,0.8)}))
    local scanLine=solid(panel,0,0,PW,1,WHITE,2); scanLine.BackgroundTransparency=0.3; T(scanLine,"BackgroundColor3")

    local beam=solid(panel,0,0,170,300,WHITE,1); beam.AnchorPoint=Vector2.new(0.5,0); beam.Position=UDim2.new(0.5,0,0,24); beam.BackgroundTransparency=0; T(beam,"BackgroundColor3")
    gradient(beam,90,nil,NumberSequence.new({NumberSequenceKeypoint.new(0,0.9),NumberSequenceKeypoint.new(1,1)}))
    local orbit=solid(panel,0,0,210,210,WHITE,1,9999); orbit.AnchorPoint=Vector2.new(0.5,0.5); orbit.Position=UDim2.new(0.5,0,0,205); orbit.BackgroundTransparency=1
    local orbitS=stroke(orbit,ACC,2,0); T(orbitS,"Color")
    local og=Instance.new("UIGradient"); og.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(0.3,0.9),NumberSequenceKeypoint.new(1,1)}); og.Parent=orbitS

    local dot=solid(panel,12,10,5,5,WHITE,9); T(dot,"BackgroundColor3")
    local cap=Instance.new("TextLabel"); cap.BackgroundTransparency=1; cap.Position=UDim2.new(0,24,0,3); cap.Size=UDim2.new(0,80,0,18); cap.Font=F_MONO; cap.TextSize=10; cap.TextColor3=C.dim; cap.TextXAlignment=Enum.TextXAlignment.Left; cap.Text="PREVIEW // LIVE"; cap.ZIndex=9; cap.Parent=panel
    local aimCap=Instance.new("TextLabel"); aimCap.BackgroundTransparency=1; aimCap.AnchorPoint=Vector2.new(1,0); aimCap.Position=UDim2.new(1,-12,0,3); aimCap.Size=UDim2.new(0,130,0,18); aimCap.Font=F_MONO; aimCap.TextSize=10; aimCap.TextXAlignment=Enum.TextXAlignment.Right; aimCap.ZIndex=9; aimCap.Parent=panel; T(aimCap,"TextColor3")
    local hdr=solid(panel,0,23,PW,1,C.line,3)

    local strip=solid(panel,0,PH-26,PW,26,Color3.fromRGB(12,12,15),8); strip.BackgroundTransparency=0.05
    solid(panel,0,PH-26,PW,1,C.line,9)
    local tagsL=Instance.new("TextLabel"); tagsL.BackgroundTransparency=1; tagsL.Position=UDim2.new(0,10,0,PH-26); tagsL.Size=UDim2.new(1,-20,0,26); tagsL.Font=F_MONO; tagsL.TextSize=10; tagsL.TextColor3=C.dim; tagsL.TextXAlignment=Enum.TextXAlignment.Left; tagsL.TextTruncate=Enum.TextTruncate.AtEnd; tagsL.Text="NO MODULES"; tagsL.ZIndex=10; tagsL.Parent=panel

    local glow={}
    for i=1,4 do
        local s=230-i*40
        local c=solid(panel,0,0,s,s,WHITE,1,9999); c.AnchorPoint=Vector2.new(0.5,0.5); c.Position=UDim2.new(0.5,0,0,200); c.BackgroundTransparency=0.95; glow[i]=c
    end

    local shadow=solid(panel,0,0,120,22,Color3.new(0,0,0),1,9999); shadow.AnchorPoint=Vector2.new(0.5,0.5); shadow.Position=UDim2.new(0.5,0,0,310); shadow.BackgroundTransparency=0.35
    local ring1=solid(panel,0,0,110,20,WHITE,1,9999); ring1.AnchorPoint=Vector2.new(0.5,0.5); ring1.Position=UDim2.new(0.5,0,0,310); ring1.BackgroundTransparency=1
    local ring1S=stroke(ring1,ACC,1.5,0.2)
    local ring2=solid(panel,0,0,110,20,WHITE,1,9999); ring2.AnchorPoint=Vector2.new(0.5,0.5); ring2.Position=UDim2.new(0.5,0,0,310); ring2.BackgroundTransparency=1
    local ring2S=stroke(ring2,ACC,1,0.6)

    local particles={}
    math.randomseed(os.time())
    for i=1,14 do
        local f=solid(panel,0,0,2,2,WHITE,2)
        particles[i]={f=f,x=math.random(12,238),y=math.random(40,330),sp=math.random(8,24),ph=math.random()*6}
    end

    local fovRing=solid(panel,0,0,100,100,WHITE,2,9999); fovRing.AnchorPoint=Vector2.new(0.5,0.5); fovRing.Position=UDim2.new(0.5,0,0,207); fovRing.BackgroundTransparency=1; fovRing.Visible=false
    local fovS=stroke(fovRing,ACC,1,0.45)
    local tracer=solid(panel,126,309,1,37,ACC,2); tracer.Visible=false

    local fig=Instance.new("Frame"); fig.AnchorPoint=Vector2.new(0.5,0.5); fig.Position=UDim2.new(0.5,0,0,207); fig.Size=UDim2.new(0,90,0,170); fig.BackgroundTransparency=1; fig.Parent=panel
    local figScale=Instance.new("UIScale"); figScale.Scale=1.2; figScale.Parent=fig
    local body=Instance.new("Frame"); body.Size=UDim2.new(1,0,1,0); body.BackgroundTransparency=1; body.Parent=fig

    local trailF={}
    for k=1,14 do local f=solid(body,0,0,12,10,WHITE,1,4); f.AnchorPoint=Vector2.new(0.5,0.5); f.Visible=false; trailF[k]=f end

    local wingF={}
    local lens={64,60,55,49,43,37}
    for _,side in ipairs({-1,1}) do for i=1,6 do
        local f=solid(body,0,0,lens[i],8,WHITE,1,4); f.AnchorPoint=Vector2.new(0.5,0.5); f.Visible=false
        gradient(f,0,nil,NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(1,0.65)}))
        wingF[#wingF+1]={f=f,side=side,i=i,len=lens[i]}
    end end

    local overlays={}
    for _,a in ipairs(AIM_PARTS_DATA) do local ov=solid(body,a.x,a.y,a.w,a.h,AIM_RED,4,a.r); ov.BackgroundTransparency=1; overlays[a.name]=ov end

    local bodyParts={}
    local function seg(x,y,w,h,r)
        local f=solid(body,x,y,w,h,BODY_GRAY,3,r)
        gradient(f,90,ColorSequence.new(WHITE,Color3.fromRGB(122,122,136)))
        local s=Instance.new("UIStroke"); s.Thickness=1; s.Color=WHITE; s.Transparency=0.78; s.ApplyStrokeMode=Enum.ApplyStrokeMode.Border; s.Parent=f
        bodyParts[#bodyParts+1]={f=f,s=s}
        return f
    end
    seg(41,35,8,8,2)
    seg(33,12,24,24,12)
    seg(27,43,36,30,4)
    seg(30,73,30,18,3)
    seg(28,91,34,13,3)
    seg(13,45,12,31,5); seg(12,77,10,28,4); seg(11,105,8,8,4)
    seg(65,45,12,31,5); seg(68,77,10,28,4); seg(71,105,8,8,4)
    seg(26,104,17,35,5); seg(28,140,13,26,4); seg(25,165,18,5,2)
    seg(47,104,17,35,5); seg(49,140,13,26,4); seg(47,165,18,5,2)
    for _,j in ipairs({{27,48},{63,48},{19,77},{71,77},{35,104},{55,104},{34,140},{56,140}}) do seg(j[1]-3,j[2]-3,6,6,3) end
    local visor=solid(body,37,20,16,5,Color3.fromRGB(26,26,32),4,2); visor.BackgroundTransparency=0.15
    local visorGlint=solid(body,39,21,6,1,WHITE,5); T(visorGlint,"BackgroundColor3")
    local emblem=Instance.new("TextLabel"); emblem.BackgroundTransparency=1; emblem.Position=UDim2.new(0,27,0,52); emblem.Size=UDim2.new(0,36,0,14); emblem.Font=F_HEAD; emblem.TextSize=8; emblem.TextTransparency=0.2; emblem.Text="LX"; emblem.ZIndex=4; emblem.Parent=body; T(emblem,"TextColor3")
    local belt=solid(body,28,91,34,2,WHITE,4); belt.BackgroundTransparency=0.4; T(belt,"BackgroundColor3")

    local skel=Instance.new("Frame"); skel.Size=UDim2.new(1,0,1,0); skel.BackgroundTransparency=1; skel.ZIndex=6; skel.Visible=false; skel.Parent=body
    local J={head={45,24},neck={45,40},shL={27,48},shR={63,48},elL={18,78},elR={72,78},haL={15,108},haR={75,108},pel={45,98},hipL={35,104},hipR={55,104},knL={34,140},knR={56,140},ftL={34,166},ftR={56,166}}
    local BPREV={{"head","neck"},{"neck","pel"},{"neck","shL"},{"neck","shR"},{"shL","elL"},{"elL","haL"},{"shR","elR"},{"elR","haR"},{"pel","hipL"},{"pel","hipR"},{"hipL","knL"},{"knL","ftL"},{"hipR","knR"},{"knR","ftR"}}
    local skelParts={}
    for _,b in ipairs(BPREV) do local a,c=J[b[1]],J[b[2]]; skelParts[#skelParts+1]=line(skel,a[1],a[2],c[1],c[2],2,WHITE,6) end
    for _,p in pairs(J) do skelParts[#skelParts+1]=solid(skel,p[1]-2.5,p[2]-2.5,5,5,WHITE,7,3) end

    local hatS={}
    local brim=solid(body,3,11,84,4,WHITE,5,2)
    gradient(brim,0,ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(140,140,140)),ColorSequenceKeypoint.new(0.5,WHITE),ColorSequenceKeypoint.new(1,Color3.fromRGB(130,130,130))}))
    brim.Visible=false; hatS[1]=brim
    for i=1,44 do
        local t=(i-1)/43
        local w=56*(1-t)+2
        local hf=solid(body,45-w/2,13-i,w,1,WHITE,5,1)
        gradient(hf,0,ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(160,160,160)),ColorSequenceKeypoint.new(0.45,WHITE),ColorSequenceKeypoint.new(1,Color3.fromRGB(130,130,130))}))
        hf.Visible=false; hatS[#hatS+1]=hf
    end

    local aimUI={}
    for _,a in ipairs(AIM_PARTS_DATA) do
        local dotb=Instance.new("TextButton"); dotb.AnchorPoint=Vector2.new(0.5,0.5); dotb.Position=UDim2.new(0,a.dx,0,a.dy); dotb.Size=UDim2.new(0,11,0,11); dotb.BackgroundColor3=Color3.fromRGB(230,230,240); dotb.BackgroundTransparency=0.4; dotb.BorderSizePixel=0; dotb.Text=""; dotb.AutoButtonColor=false; dotb.ZIndex=12; dotb.Parent=body; corner(dotb,6)
        local ds=stroke(dotb,WHITE,1,0.5)
        local ui={a=a,dot=dotb,ds=ds,hover=false}
        dotb.MouseEnter:Connect(function() ui.hover=true end)
        dotb.MouseLeave:Connect(function() ui.hover=false end)
        dotb.MouseButton1Click:Connect(function() Setters["Aimbot/Body Part"](a.name) end)
        aimUI[#aimUI+1]=ui
    end
    local aimDot=solid(body,45,24,6,6,AIM_RED,13,3); aimDot.AnchorPoint=Vector2.new(0.5,0.5)
    local ret={}
    for i=1,4 do ret[i]=solid(body,0,0,(i<=2) and 6 or 1,(i<=2) and 1 or 6,AIM_RED,13); ret[i].AnchorPoint=Vector2.new(0.5,0.5) end

    local boxF=solid(fig,2,6,86,164,WHITE,7); boxF.BackgroundTransparency=1; boxF.Visible=false
    local br={}
    for i=1,8 do br[i]=solid(fig,0,0,2,2,WHITE,8); br[i].Visible=false end
    local box3={}
    for i=1,12 do box3[i]=solid(fig,0,0,2,2,WHITE,8); box3[i].AnchorPoint=Vector2.new(0.5,0.5); box3[i].Visible=false end
    local function setBox3(x,y,w,h,col,vis)
        local dx,dy=12,10
        local fx,fy,fw,fh=x,y+dy,w-dx,h-dy
        local bx,by=x+dx,y
        local P={Vector2.new(fx,fy),Vector2.new(fx+fw,fy),Vector2.new(fx+fw,fy+fh),Vector2.new(fx,fy+fh),
                 Vector2.new(bx,by),Vector2.new(bx+fw,by),Vector2.new(bx+fw,by+fh),Vector2.new(bx,by+fh)}
        local E={{1,2},{2,3},{3,4},{4,1},{5,6},{6,7},{7,8},{8,5},{1,5},{2,6},{3,7},{4,8}}
        for i,e in ipairs(E) do
            local f=box3[i]; f.Visible=vis
            if vis then f.BackgroundColor3=col; setLine(f,P[e[1]],P[e[2]],1.5) end
        end
    end
    local function setBrackets(x,y,w,h,col,vis)
        local L=math.min(14,w*0.3,h*0.2)
        local specs={{x,y,L,2},{x,y,2,L},{x+w-L,y,L,2},{x+w-2,y,2,L},{x,y+h-2,L,2},{x,y+h-L,2,L},{x+w-L,y+h-2,L,2},{x+w-2,y+h-L,2,L}}
        for i,s in ipairs(specs) do local f=br[i]; f.Visible=vis; f.Position=UDim2.new(0,s[1],0,s[2]); f.Size=UDim2.new(0,s[3],0,s[4]); f.BackgroundColor3=col end
    end
    local function espLabel(font,size) local l=Instance.new("TextLabel"); l.BackgroundTransparency=1; l.Size=UDim2.new(0,130,0,13); l.Font=font; l.TextSize=size; l.ZIndex=8; l.Visible=false; l.TextStrokeTransparency=0.5; l.TextStrokeColor3=Color3.new(0,0,0); l.Parent=fig; return l end
    local roleL=espLabel(F_SEC,10)
    local nameL=espLabel(F_MONO,9); nameL.Text="PLAYER"
    local distL=espLabel(F_MONO,8); distL.TextColor3=WHITE; distL.Text="[42m]"
    local hpBar=solid(fig,-5,6,3,164,Color3.fromRGB(14,14,16),8); hpBar.Visible=false
    local hpFill=solid(hpBar,0,0,3,100,Color3.fromRGB(70,230,110),9); hpFill.AnchorPoint=Vector2.new(0,1); hpFill.Position=UDim2.new(0,0,1,0); hpFill.Size=UDim2.new(1,0,0.72,0)

    local gunPrev=Instance.new("TextLabel"); gunPrev.BackgroundTransparency=1; gunPrev.Size=UDim2.new(0,90,0,12); gunPrev.Position=UDim2.new(0,-100,0,150); gunPrev.Font=F_MONO; gunPrev.TextSize=9; gunPrev.Text="GUN [18m]"; gunPrev.Visible=false; gunPrev.ZIndex=8; gunPrev.TextStrokeTransparency=0.5; gunPrev.Parent=fig
    local gunBody=solid(fig,-90,164,22,5,WHITE,8,1); gunBody.Visible=false
    local gunGrip=solid(fig,-90,166,5,10,WHITE,8,1); gunGrip.Visible=false

    local boxTop=6
    local aimPosX,aimPosY=45,24
    local tagAcc=0.3
    track(RunService.RenderStepped:Connect(function(dt)
        if not isOpen then return end
        local t=os.clock()
        local role="Murderer"
        local rcol=ROLE_COLORS[role] or WHITE
        local ecol=Flags["Visuals/Color by Role"] and rcol or getColor(Flags["Visuals/ESP Color"],t,0)
        local pulse=(math.sin(t*1.4)+1)/2
        for i,c in ipairs(glow) do c.BackgroundColor3=ACC; c.BackgroundTransparency=0.955-i*0.006-pulse*0.01 end
        dot.BackgroundTransparency=pulse*0.7; og.Rotation=(t*80)%360
        local ys=34+((t*0.33)%1)*296
        scanLine.Position=UDim2.new(0,0,0,ys); scanBand.Position=UDim2.new(0,0,0,ys-38)
        local rp=(t*0.55)%1
        ring2.Size=UDim2.new(0,90+rp*100,0,16+rp*26); ring2S.Transparency=0.3+rp*0.7
        for _,p in ipairs(particles) do
            p.y=p.y-p.sp*dt
            if p.y<30 then p.y=338; p.x=math.random(12,238) end
            p.f.Position=UDim2.new(0,p.x+math.sin(t*0.8+p.ph)*6,0,p.y)
            p.f.BackgroundTransparency=1-((p.y-30)/308)*0.55
            p.f.BackgroundColor3=ACC
        end
        body.Position=UDim2.new(0,0,0,math.sin(t*2)*1.5)
        local hatOn=Flags["Visuals/Chinese Hat"]
        boxTop=boxTop+((hatOn and -36 or 6)-boxTop)*0.2
        local bh=170-boxTop
        local boxOn=Flags["Visuals/ESP Box"]
        local box3On=boxOn
        local box2On=boxOn and not box3On
        boxF.Visible=box2On; boxF.BackgroundColor3=ecol; boxF.BackgroundTransparency=0.95
        boxF.Position=UDim2.new(0,2,0,boxTop); boxF.Size=UDim2.new(0,86,0,bh)
        setBrackets(2,boxTop,86,bh,ecol,box2On)
        setBox3(4,boxTop,82,bh,ecol,box3On and true or false)
        roleL.Visible=Flags["Visuals/Role"]; roleL.Text=string.upper(role); roleL.TextColor3=rcol; roleL.Position=UDim2.new(0,-20,0,boxTop-26)
        nameL.Visible=Flags["Visuals/Name"]; nameL.TextColor3=ecol; nameL.Position=UDim2.new(0,-20,0,boxTop-14)
        distL.Visible=Flags["Visuals/Distance"]; distL.Position=UDim2.new(0,-20,0,170+3)
        hpBar.Visible=Flags["Visuals/Health"]; hpBar.Position=UDim2.new(0,-5,0,boxTop); hpBar.Size=UDim2.new(0,3,0,bh); hpFill.Size=UDim2.new(1,0,0.7+math.sin(t)*0.2,0)
        tracer.Visible=Flags["Visuals/Tracers"]; tracer.BackgroundColor3=ecol
        local skelOn=Flags["Visuals/Skeleton"]; skel.Visible=skelOn
        if skelOn then for _,s in ipairs(skelParts) do s.BackgroundColor3=ecol end end
        local chams,glowOn=Flags["Visuals/Chams"],Flags["Visuals/Glow"]
        for _,p in ipairs(bodyParts) do
            p.f.BackgroundColor3=chams and ecol or BODY_GRAY; p.f.BackgroundTransparency=chams and 0.25 or 0
            p.s.Color=glowOn and ecol or WHITE; p.s.Transparency=glowOn and 0.05 or 0.78; p.s.Thickness=glowOn and 2 or 1
        end
        visor.BackgroundColor3=chams and Color3.fromRGB(20,20,24) or Color3.fromRGB(26,26,32)
        for i,s in ipairs(hatS) do s.Visible=hatOn; if hatOn then s.BackgroundColor3=getColor(Flags["Visuals/Hat Color"],t,i*0.04); s.BackgroundTransparency=(Flags["Visuals/Hat Transparency"] or 35)/100 end end
        local gunOn=Flags["Visuals/Gun ESP"]
        local gcol=getColor(Flags["Visuals/Gun Color"] or "Gold",t,0)
        gunPrev.Visible=gunOn; gunBody.Visible=gunOn; gunGrip.Visible=gunOn
        if gunOn then gunPrev.TextColor3=gcol; gunBody.BackgroundColor3=gcol; gunGrip.BackgroundColor3=gcol end
        local wingsOn=Flags["Visuals/Wings"]
        local flap=math.sin(t*(Flags["Visuals/Wing Speed"] or 3))*0.2
        for _,w in ipairs(wingF) do
            w.f.Visible=wingsOn
            if wingsOn then
                local a=math.rad(8+(w.i-1)*14)+flap*(0.4+w.i*0.12); local dx,dy=w.side*math.cos(a),-math.sin(a); local sx=(w.side==-1) and 28 or 62
                w.f.Position=UDim2.new(0,sx+dx*w.len/2,0,50+dy*w.len/2); w.f.Rotation=math.deg(math.atan2(dy,dx)); w.f.BackgroundColor3=getColor(Flags["Visuals/Wing Color"],t,w.i*0.05)
            end
        end
        local trailOn=Flags["Visuals/Trail"]
        local tlen=math.clamp(Flags["Visuals/Trail Length"] or 10,1,30)
        local count=math.clamp(math.floor(tlen/30*14)+3,3,14)
        local twidth=Flags["Visuals/Trail Width"] or 4
        for k,f in ipairs(trailF) do
            local show=trailOn and k<=count; f.Visible=show
            if show then local fall=k/count; f.Position=UDim2.new(0,16-k*8,0,100+math.sin(t*4+k*0.6)*4*fall); f.Size=UDim2.new(0,12,0,math.max(2,twidth*2.4*(1-fall*0.85))); f.BackgroundTransparency=0.1+fall*0.85; f.BackgroundColor3=tcol(Flags["Visuals/Trail Color"],t,-k*0.04) end
        end
        local aimOn=Flags["Aimbot/Enable"]
        fovRing.Visible=aimOn and Flags["Aimbot/Show FOV"] or false
        if fovRing.Visible then local r=24+((Flags["Aimbot/FOV"] or 120)-10)/350*94; fovRing.Size=UDim2.new(0,r*2,0,r*2); fovS.Color=ACC end
        ring1S.Color=ACC; ring2S.Color=ACC
        local sel=Flags["Aimbot/Body Part"]; local ap=(math.sin(t*5)+1)/2
        for pn,ov in pairs(overlays) do ov.BackgroundTransparency=(pn==sel) and (0.6-ap*0.2) or 1 end
        local selPart=nil
        for _,a in ipairs(AIM_PARTS_DATA) do if a.name==sel then selPart=a; break end end
        if selPart then
            local k=math.clamp(dt*12,0,1)
            aimPosX=aimPosX+(selPart.dx-aimPosX)*k; aimPosY=aimPosY+(selPart.dy-aimPosY)*k
        end
        aimDot.Position=UDim2.new(0,aimPosX,0,aimPosY)
        local g=7+ap*4
        ret[1].Position=UDim2.new(0,aimPosX-g-3,0,aimPosY); ret[2].Position=UDim2.new(0,aimPosX+g+3,0,aimPosY)
        ret[3].Position=UDim2.new(0,aimPosX,0,aimPosY-g-3); ret[4].Position=UDim2.new(0,aimPosX,0,aimPosY+g+3)
        for _,u in ipairs(aimUI) do
            if u.a.name==sel then u.dot.BackgroundColor3=AIM_RED; u.dot.BackgroundTransparency=0.2; u.dot.Size=UDim2.new(0,11,0,11); u.ds.Transparency=0.1
            elseif u.hover then u.dot.BackgroundColor3=Color3.fromRGB(255,170,170); u.dot.BackgroundTransparency=0.2; u.dot.Size=UDim2.new(0,13,0,13); u.ds.Transparency=0.2
            else u.dot.BackgroundColor3=Color3.fromRGB(230,230,240); u.dot.BackgroundTransparency=0.45; u.dot.Size=UDim2.new(0,11,0,11); u.ds.Transparency=0.55 end
        end
        aimCap.Text=aimOn and ("AIM / "..string.upper(tostring(sel))) or "AIM OFF"
        tagAcc+=dt
        if tagAcc>=0.25 then
            tagAcc=0
            local tg={}
            local function add(k,n) if Flags[k] then tg[#tg+1]=n end end
            add("Visuals/ESP Box","BOX") add("Visuals/Name","NAME") add("Visuals/Role","ROLE") add("Visuals/Health","HP") add("Visuals/Distance","DIST")
            add("Visuals/Tracers","TRC") add("Visuals/Skeleton","SKEL") add("Visuals/Chams","CHAMS") add("Visuals/Glow","GLOW") add("Visuals/Gun ESP","GUN")
            add("Visuals/Chinese Hat","HAT") add("Visuals/Wings","WINGS") add("Visuals/Trail","TRAIL")
            if aimOn then tg[#tg+1]="AIM"; if Flags["Aimbot/Skip Innocents"] then tg[#tg+1]="NO-INNO" end end
            if Flags["Aimbot/Auto Win"] then tg[#tg+1]="AUTOWIN" end
            if Flags["Move/Bunnyhop"] then tg[#tg+1]="BHOP" end
            tagsL.Text=#tg>0 and table.concat(tg," / ") or "NO MODULES"
        end
    end))
end

buildPreview(previewPanel)
selectTab(visTab)
print("[luxxs] UI built, ready")

-- PROFILE UPDATER
task.spawn(function()
    local startTick=tick()
    while gui.Parent do
        task.wait(1)
        local s=math.floor(tick()-startTick)
        local hh=math.floor(s/3600); local mm=math.floor((s%3600)/60); local ss=s%60
        local role=getRoleCached(LP)
        profSession.Text=string.format("SESSION   %02d:%02d:%02d",hh,mm,ss)
        profRole.Text="ROLE      "..role
        profCoins.Text="COINS     "..Farm.Collected
        profFps.Text="FPS       "..(FPS.Current or 0).." | avg "..math.floor(FpsCounter.Avg).." | max "..FpsCounter.Max
        footR.Text="ROLE  "..string.upper(role)
        footR.TextColor3=(role~="Innocent") and (ROLE_COLORS[role] or C.dim) or C.dim
    end
end)

-- keeps the mobile joystick visible while aimbot / auto win are on
task.spawn(function()
    while gui.Parent do
        task.wait(0.4)
        if UIS.TouchEnabled and not UIS.KeyboardEnabled and (Flags["Aimbot/Enable"] or Flags["Aimbot/Auto Win"]) then
            pcall(function()
                local pg=LP:FindFirstChildOfClass("PlayerGui")
                local tg=pg and pg:FindFirstChild("TouchGui")
                if not tg then return end
                if not tg.Enabled then tg.Enabled=true end
                local f=tg:FindFirstChild("TouchControlFrame")
                if f then
                    if not f.Visible then f.Visible=true end
                    for _,n in ipairs({"DynamicThumbstickFrame","ThumbstickFrame"}) do
                        local t=f:FindFirstChild(n)
                        if t and not t.Visible then t.Visible=true end
                    end
                end
            end)
        end
    end
end)
task.spawn(function()
    local t0=os.clock()
    while parent:FindFirstChild("luxxsKey") and os.clock()-t0<8 do task.wait(0.1) end
    task.wait(0.2)
    openMenu()
end)
if #__errs>0 then notify("Module error (see console): "..__errs[1]:sub(1,70)) end
notify("luxxs v8.2 // swipe the bottom bar")
end,function(e) return tostring(e).."\n"..tostring(debug.traceback()) end)

if not __LX_ok then
    -- the script crashed: show the exact error on screen so it can be read / copied
    warn("[luxxs] CRASH: "..tostring(__LX_err))
    pcall(function()
        local host=(gethui and gethui()) or game:GetService("CoreGui")
        local sg=Instance.new("ScreenGui"); sg.Name="luxxsError"; sg.ResetOnSpawn=false; sg.IgnoreGuiInset=true; sg.DisplayOrder=1000; sg.Parent=host
        local f=Instance.new("Frame"); f.AnchorPoint=Vector2.new(0.5,0.5); f.Position=UDim2.new(0.5,0,0.5,0); f.Size=UDim2.new(0.9,0,0.6,0); f.BackgroundColor3=Color3.fromRGB(20,14,16); f.BorderSizePixel=0; f.Parent=sg
        Instance.new("UICorner",f).CornerRadius=UDim.new(0,10)
        local st=Instance.new("UIStroke"); st.Color=Color3.fromRGB(255,84,84); st.Thickness=2; st.Parent=f
        local t=Instance.new("TextLabel"); t.BackgroundTransparency=1; t.Position=UDim2.new(0,12,0,8); t.Size=UDim2.new(1,-24,0,24); t.Font=Enum.Font.RobotoMono; t.TextSize=16; t.TextColor3=Color3.fromRGB(255,120,120); t.TextXAlignment=Enum.TextXAlignment.Left; t.Text="luxxs crashed - send this text to the developer"; t.Parent=f
        local box=Instance.new("TextBox"); box.Position=UDim2.new(0,12,0,40); box.Size=UDim2.new(1,-24,1,-96); box.BackgroundColor3=Color3.fromRGB(10,8,10); box.BorderSizePixel=0; box.ClearTextOnFocus=false; box.TextEditable=false; box.MultiLine=true; box.TextWrapped=true; box.TextXAlignment=Enum.TextXAlignment.Left; box.TextYAlignment=Enum.TextYAlignment.Top; box.Font=Enum.Font.RobotoMono; box.TextSize=13; box.TextColor3=Color3.fromRGB(235,235,235); box.Text=tostring(__LX_err); box.Parent=f
        local function btn(txt,x,cb)
            local b=Instance.new("TextButton"); b.AnchorPoint=Vector2.new(0,1); b.Position=UDim2.new(0,x,1,-10); b.Size=UDim2.new(0,130,0,32); b.BackgroundColor3=Color3.fromRGB(60,30,34); b.BorderSizePixel=0; b.Font=Enum.Font.RobotoMono; b.TextSize=14; b.TextColor3=Color3.fromRGB(255,255,255); b.Text=txt; b.Parent=f
            Instance.new("UICorner",b).CornerRadius=UDim.new(0,8)
            b.MouseButton1Click:Connect(cb)
        end
        btn("COPY",12,function() if setclipboard then pcall(setclipboard,tostring(__LX_err)); t.Text="copied!" end end)
        btn("CLOSE",152,function() sg:Destroy() end)
    end)
end
