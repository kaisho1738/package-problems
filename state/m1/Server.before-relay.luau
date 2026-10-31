-- Authoritative M1 loop. Module allows Studio tests to call the same request boundary.
local Players = game:GetService('Players')
local RS = game:GetService('ReplicatedStorage')
local RunService = game:GetService('RunService')
local PhysicsService = game:GetService('PhysicsService')
local Shared = RS:WaitForChild('PackageProblemsM1')
local Config = require(Shared.Config)
local Net = Shared.Remotes
local World = workspace:WaitForChild('PackageProblemsM1')
local M = {}
local state = {cycleId=0, version=0, phase='Preparing', packageState='Available', carrier=0, gateOpen=false, checkpoint=1}
local parcel, positionAlign, orientationAlign, savedSpeed, carrierHumanoid
local pending, resultAt, followErrorAt, carryStarted, accumulator
local limits, playerConnections, characterLinks, connections = {}, {}, {}, {}
local metrics = {cycles=0, deliveries=0, recoveries=0, rejected=0, accepted=0}
local started = false

local function character(p)
    if not p or p.Parent ~= Players then return end
    local c=p.Character; if not c then return end
    local h=c:FindFirstChildOfClass('Humanoid'); local r=c:FindFirstChild('HumanoidRootPart')
    if h and r and h.Health>0 then return c,h,r end
end
local function snapshot()
    return {cycleId=state.cycleId, version=state.version, phase=state.phase,
        packageState=state.packageState, carrier=state.carrier, gateOpen=state.gateOpen,
        checkpoint=state.checkpoint, completed=metrics.deliveries,
        pending=pending and {recipient=pending.recipient,expires=pending.expires,token=pending.token} or nil}
end
local function publish()
    state.version+=1; Net.State:FireAllClients(snapshot())
end
local function queryParams()
    local p=RaycastParams.new(); p.FilterType=Enum.RaycastFilterType.Exclude
    local exclude={parcel, World.Markers}
    for _,v in ipairs(Players:GetPlayers()) do if v.Character then table.insert(exclude,v.Character) end end
    p.FilterDescendantsInstances=exclude; p.RespectCanCollide=true
    return p
end
local function near(p,point)
    local _,_,r=character(p)
    if not r or (r.Position-point).Magnitude>Config.Reach then return false end
    return workspace:Raycast(r.Position,point-r.Position,queryParams())==nil
end
local function release()
    if carrierHumanoid and carrierHumanoid.Parent and savedSpeed then carrierHumanoid.WalkSpeed=savedSpeed end
    carrierHumanoid=nil; savedSpeed=nil; state.carrier=0; pending=nil
    if positionAlign then positionAlign:Destroy(); positionAlign=nil end
    if orientationAlign then orientationAlign:Destroy(); orientationAlign=nil end
    followErrorAt=nil; carryStarted=nil
end
local function setCarrier(p)
    local _,h,r=character(p); if not h then return false end
    release(); state.carrier=p.UserId; state.packageState='Carried'
    carrierHumanoid=h; savedSpeed=h.WalkSpeed; h.WalkSpeed=Config.CarrySpeed
    parcel.Anchored=false; parcel:SetNetworkOwner(nil)
    positionAlign=Instance.new('AlignPosition'); positionAlign.Name='CarryPosition'
    positionAlign.Mode=Enum.PositionAlignmentMode.OneAttachment
    positionAlign.Attachment0=parcel.CarryAttachment; positionAlign.ApplyAtCenterOfMass=true
    positionAlign.MaxForce=parcel.AssemblyMass*workspace.Gravity*Config.ForceGravityMultiplier
    positionAlign.MaxVelocity=Config.MaxVelocity; positionAlign.Responsiveness=Config.Responsiveness
    positionAlign.Position=(r.CFrame*CFrame.new(Config.CarryOffset)).Position
    positionAlign.Parent=parcel
    orientationAlign=Instance.new('AlignOrientation'); orientationAlign.Name='CarryOrientation'
    orientationAlign.Mode=Enum.OrientationAlignmentMode.OneAttachment
    orientationAlign.Attachment0=parcel.CarryAttachment; orientationAlign.MaxTorque=parcel.AssemblyMass*3000
    orientationAlign.MaxAngularVelocity=8; orientationAlign.Responsiveness=15
    orientationAlign.CFrame=r.CFrame.Rotation; orientationAlign.Parent=parcel
    carryStarted=os.clock(); return true
end
local function checkpointPosition()
    return World.Markers['Checkpoint'..state.checkpoint].Position+Vector3.new(0,2,0)
end
local function recover(reason)
    if not parcel or state.phase~='Active' then return end
    release(); state.packageState='Recovering'
    parcel.Anchored=true; parcel.CFrame=CFrame.new(checkpointPosition())
    parcel.AssemblyLinearVelocity=Vector3.zero; parcel.AssemblyAngularVelocity=Vector3.zero
    parcel.Anchored=false; parcel:SetNetworkOwner(nil); state.packageState='Dropped'
    parcel:SetAttribute('LastRecovery',reason); metrics.recoveries+=1; publish()
end
local function outside()
    if not parcel then return true end
    local p=parcel.Position; local a,b=Config.BoundsMin,Config.BoundsMax
    return p.X<a.X or p.Y<a.Y or p.Z<a.Z or p.X>b.X or p.Y>b.Y or p.Z>b.Z
end
local function clearSpace(cf)
    local p=OverlapParams.new(); p.FilterType=Enum.RaycastFilterType.Exclude
    local exclude={parcel,World.Markers}
    for _,v in ipairs(Players:GetPlayers()) do if v.Character then table.insert(exclude,v.Character) end end
    p.FilterDescendantsInstances=exclude; p.RespectCanCollide=true
    return #workspace:GetPartBoundsInBox(cf,Vector3.new(2.9,2.9,2.9),p)==0
end
local function placement(p)
    local _,_,r=character(p); if not r then return end
    for _,distance in ipairs({4,5,3}) do
        local pos=(r.CFrame*CFrame.new(0,0,-distance)).Position
        local hit=workspace:Raycast(pos+Vector3.new(0,3,0),Vector3.new(0,-10,0),queryParams())
        if hit and hit.Normal.Y>0.8 then
            local cf=CFrame.new(hit.Position+Vector3.new(0,1.55,0))*r.CFrame.Rotation
            if clearSpace(cf) then return cf end
        end
    end
end
local function startCycle(returnPlayers)
    release(); if parcel then parcel:Destroy() end
    pending=nil; resultAt=nil; state.cycleId+=1; metrics.cycles+=1
    state.phase='Active'; state.packageState='Available'; state.checkpoint=1; state.gateOpen=false
    World.Gate.CanCollide=true; World.Gate.Transparency=0
    parcel=game:GetService('ServerStorage').PackageProblemsM1.StandardPackage:Clone()
    parcel.Name='LivePackage'; parcel.CollisionGroup='M1Package'; parcel.CFrame=CFrame.new(checkpointPosition()); parcel.Parent=World
    parcel:SetNetworkOwner(nil)
    if returnPlayers then
        for i,p in ipairs(Players:GetPlayers()) do
            local c=character(p)
            if c then c:PivotTo(CFrame.new(12+(i-1)*5,4,6)); local r=c:FindFirstChild('HumanoidRootPart'); r.AssemblyLinearVelocity=Vector3.zero end
        end
    end
    publish()
end
local function deliver(p)
    local pad=World.Markers.DeliveryPad
    if not near(p,pad.Position+Vector3.new(0,2,0)) then return false,'Move closer to the delivery pad.' end
    if state.checkpoint<2 then return false,'Follow either marked route to the destination.' end
    local cf
    if state.carrier==p.UserId then cf=placement(p)
    elseif state.carrier==0 and parcel.AssemblyLinearVelocity.Magnitude<2 then cf=parcel.CFrame
    else return false,'Place the package on the delivery pad.' end
    if not cf then return false,'No room to place.' end
    local offset=pad.CFrame:PointToObjectSpace(cf.Position)
    if math.abs(offset.X)>pad.Size.X/2-1.5 or math.abs(offset.Z)>pad.Size.Z/2-1.5 or math.abs(offset.Y)>4 then
        return false,'Move the package fully inside the delivery pad.'
    end
    if not near(p,parcel.Position) then return false,'The package is too far away.' end
    state.phase='Result'; release(); state.packageState='Delivered'; metrics.deliveries+=1
    parcel.Anchored=true; parcel.CFrame=CFrame.new(pad.Position+Vector3.new(0,1.6,0))
    resultAt=os.clock()+Config.ResultSeconds; publish(); return true,'Delivered! Returning to depot…'
end
local function action(p,data)
    if data.action=='Sync' then Net.State:FireClient(p,snapshot()); return true,'Ready.' end
    if data.cycleId~=state.cycleId then return false,'That delivery has already changed.' end
    if state.phase~='Active' then return false,'Delivery complete. Returning to depot…' end
    if not character(p) then return false,'Wait for your character to respawn.' end
    if data.action=='Pickup' then
        if state.carrier~=0 then return false,'Already carried.' end
        if not near(p,parcel.Position) then return false,'Move closer to the package.' end
        setCarrier(p); publish(); return true,'Package picked up.'
    elseif data.action=='Drop' then
        if state.carrier~=p.UserId then return false,'You are not carrying the package.' end
        local cf=placement(p); if not cf then return false,'No room to place.' end
        release(); parcel.CFrame=cf; parcel.AssemblyLinearVelocity=Vector3.zero; parcel.AssemblyAngularVelocity=Vector3.zero
        state.packageState='Dropped'; publish(); return true,'Package placed.'
    elseif data.action=='RequestHandoff' then
        local carrier=Players:GetPlayerByUserId(state.carrier)
        local _,_,root=character(carrier)
        if not root or carrier==p or not near(p,root.Position) or not near(p,parcel.Position) then return false,'Move closer to the carrier.' end
        if pending then return false,'A handoff request is already waiting.' end
        pending={recipient=p.UserId,expires=workspace:GetServerTimeNow()+Config.HandoffSeconds,token=data.requestId}
        publish(); return true,'Handoff requested. Waiting for the carrier.'
    elseif data.action=='AcceptHandoff' then
        if state.carrier~=p.UserId or not pending or data.token~=pending.token then return false,'No current handoff request.' end
        local recipient=Players:GetPlayerByUserId(pending.recipient)
        local _,_,r=character(recipient)
        if workspace:GetServerTimeNow()>=pending.expires or not r or not near(p,r.Position) or not near(recipient,parcel.Position) then
            pending=nil; publish(); return false,'Handoff expired or player moved away.'
        end
        setCarrier(recipient); publish(); return true,'Package handed over.'
    elseif data.action=='Switch' then
        if state.carrier==p.UserId then return false,'Place the package to free your hands.' end
        if not near(p,World.Switch.Position) then return false,'Move closer to the switch.' end
        state.gateOpen=true; World.Gate.CanCollide=false; World.Gate.Transparency=0.8
        publish(); return true,'Gate latched open until the next delivery.'
    elseif data.action=='Deliver' then return deliver(p)
    elseif data.action=='Recover' then
        local lim=limits[p]; local now=os.clock()
        if now-(lim.recoveredAt or -math.huge)<Config.RecoverCooldown then return false,'Recovery is cooling down.' end
        if state.carrier~=0 then return false,'A teammate is carrying it. Ask them to place it.' end
        local blocked=not clearSpace(parcel.CFrame)
        local _,_,r=character(p)
        local hit=workspace:Raycast(r.Position,parcel.Position-r.Position,queryParams())
        if not outside() and not blocked and (not hit or hit.Distance>=(r.Position-parcel.Position).Magnitude-1.6) then
            return false,'The package is reachable. Walk over and pick it up.'
        end
        lim.recoveredAt=now; recover('Manual recovery'); return true,'Package recovered to the last safe checkpoint.'
    end
    return false,'Unknown action.'
end
function M.Handle(p,data)
    if not p or p.Parent~=Players then return false,'Not a participant.' end
    if type(data)~='table' or type(data.action)~='string' or type(data.requestId)~='string' or #data.requestId>80 then return false,'Invalid request.' end
    local now=os.clock(); local lim=limits[p]
    if not lim then lim={tokens=12,at=now,seen={},order={}}; limits[p]=lim end
    lim.tokens=math.min(12,lim.tokens+(now-lim.at)*8); lim.at=now
    if lim.tokens<1 then return false,'Please slow down.' end
    lim.tokens-=1
    if lim.seen[data.requestId] then return false,'Request already processed.' end
    lim.seen[data.requestId]=true; table.insert(lim.order,data.requestId)
    if #lim.order>64 then lim.seen[table.remove(lim.order,1)]=nil end
    local ok,message=action(p,data)
    if ok then metrics.accepted+=1 else metrics.rejected+=1 end
    return ok,message
end
local function bindCharacter(p,c)
    local cons=playerConnections[p] or {}; playerConnections[p]=cons
    for _,co in ipairs(cons) do co:Disconnect() end; table.clear(cons)
    if state.carrier==p.UserId then recover('Character replaced') end
    local function part(v) if v:IsA('BasePart') then v.CollisionGroup='M1Players' end end
    for _,v in ipairs(c:GetDescendants()) do part(v) end
    table.insert(cons,c.DescendantAdded:Connect(part))
    task.spawn(function()
        local h=c:WaitForChild('Humanoid',10); if not h or p.Character~=c then return end
        table.insert(cons,h.Died:Connect(function() if state.carrier==p.UserId then recover('Carrier reset') end; if pending and pending.recipient==p.UserId then pending=nil; publish() end end))
        if state.phase=='Active' and state.checkpoint==2 then c:PivotTo(CFrame.new(checkpointPosition()+Vector3.new(5,2,0))) end
    end)
end
function M.Start()
    if started then return end; started=true; accumulator=0
    for _,name in ipairs({'M1Players','M1Package'}) do pcall(function() PhysicsService:RegisterCollisionGroup(name) end) end
    PhysicsService:CollisionGroupSetCollidable('M1Players','M1Players',false)
    PhysicsService:CollisionGroupSetCollidable('M1Players','M1Package',false)
    local function bind(p)
        characterLinks[p]=p.CharacterAdded:Connect(function(c) bindCharacter(p,c) end)
        if p.Character then bindCharacter(p,p.Character) end
    end
    table.insert(connections,Players.PlayerAdded:Connect(bind)); for _,p in ipairs(Players:GetPlayers()) do bind(p) end
    table.insert(connections,Players.PlayerRemoving:Connect(function(p)
        if state.carrier==p.UserId then recover('Carrier disconnected') end
        if pending and pending.recipient==p.UserId then pending=nil; publish() end
        if playerConnections[p] then for _,co in ipairs(playerConnections[p]) do co:Disconnect() end end
        if characterLinks[p] then characterLinks[p]:Disconnect(); characterLinks[p]=nil end
        playerConnections[p]=nil; limits[p]=nil
    end))
    table.insert(connections,Net.Request.OnServerEvent:Connect(function(p,data)
        local ok,message=M.Handle(p,data); Net.Response:FireClient(p,{requestId=type(data)=='table' and data.requestId or '',ok=ok,message=message})
    end))
    startCycle(false)
    table.insert(connections,RunService.Heartbeat:Connect(function(dt)
        if state.phase=='Result' then if os.clock()>=resultAt then startCycle(true) end; return end
        if not parcel or not parcel.Parent then startCycle(true); return end
        if state.carrier~=0 then
            local p=Players:GetPlayerByUserId(state.carrier); local _,_,r=character(p)
            if not r then recover('Carrier unavailable'); return end
            local goal=(r.CFrame*CFrame.new(Config.CarryOffset)).Position
            local ray=workspace:Blockcast(CFrame.new(r.Position),Vector3.new(3,3,3),goal-r.Position,queryParams())
            if ray then goal=r.Position+(goal-r.Position).Unit*math.max(0,ray.Distance-0.2) end
            positionAlign.Position=goal; orientationAlign.CFrame=r.CFrame.Rotation
            if (parcel.Position-goal).Magnitude>Config.FollowError then
                followErrorAt=followErrorAt or os.clock()
                if os.clock()-followErrorAt>Config.FollowErrorSeconds then recover('Obstructed carry'); return end
            else followErrorAt=nil end
        end
        accumulator+=dt; if accumulator<0.1 then return end; accumulator=0
        if outside() then recover('Out of bounds'); return end
        if pending and workspace:GetServerTimeNow()>=pending.expires then pending=nil; publish() end
        local cp=World.Markers.Checkpoint2
        if state.checkpoint==1 and (parcel.Position-cp.Position).Magnitude<9 then
            local p=Players:GetPlayerByUserId(state.carrier)
            if p and near(p,cp.Position+Vector3.new(0,2,0)) and carryStarted and os.clock()-carryStarted>2 then state.checkpoint=2; publish() end
        end
    end))
    if RunService:IsStudio() then
        local bridge=Instance.new('BindableFunction'); bridge.Name='M1StudioTests'; bridge.Parent=game:GetService('ServerStorage')
        bridge.OnInvoke=function(op,p,data)
            if op=='Inspect' then return M.Inspect() end
            if op=='Request' then return M.Handle(p,data) end
            return nil
        end
    end
    print('Package Problems M1 ready — one server-owned parcel; no HP, deadlines or rewards.')
end
function M.Inspect()
    return {state=snapshot(),metrics=table.clone(metrics),parcel=parcel,connections=#connections,
        carryConstraints=parcel and #parcel:GetChildren() or 0}
end
return M
