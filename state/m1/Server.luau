-- Authoritative M1 loop. Module allows Studio tests to call the same request boundary.
local Players = game:GetService('Players')
local RS = game:GetService('ReplicatedStorage')
local RunService = game:GetService('RunService')
local PhysicsService = game:GetService('PhysicsService')
local Shared = RS:WaitForChild('PackageProblemsM1')
local Config = require(Shared.Config)
local Net = Shared.Remotes
local World = workspace:WaitForChild('PackageProblemsM1')
local Stamina=require(script.Parent.Stamina)
local Transfer=require(script.Parent.Transfer)
local preset=RunService:IsStudio() and (script.Parent:GetAttribute('PracticePlayerCount') or 1) or 1
local stamina=Stamina.new(Config,preset)
local charges,catchers,bases={},{},{}
local flight,flightSerial=nil,0
local lastVitals=os.clock()
local updateVitals
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
local function vitals()
    local out={}
    for _,p in ipairs(Players:GetPlayers()) do
        local v=Stamina.get(stamina,p.UserId)
        out[tostring(p.UserId)]={stamina=v.value,running=v.running,chargeAt=charges[p.UserId],catchUntil=catchers[p.UserId] and catchers[p.UserId].expires}
    end
    return out
end
local function speed(p)
    local _,h=character(p); if not h then return end
    local base=bases[p.UserId]
    if not base or base.h~=h then base={h=h,speed=h.WalkSpeed}; bases[p.UserId]=base end
    h.WalkSpeed=(state.carrier==p.UserId and Config.CarrySpeed or base.speed)*(Stamina.get(stamina,p.UserId).running and Config.RunSpeed or 1)
end
local function snapshot()
    return {cycleId=state.cycleId, version=state.version, phase=state.phase,
        packageState=state.packageState, carrier=state.carrier, gateOpen=state.gateOpen,
        checkpoint=state.checkpoint, completed=metrics.deliveries, enduranceCount=stamina.count, players=vitals(), flightId=flight and flight.id,
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
    local old=Players:GetPlayerByUserId(state.carrier)
    if old then charges[old.UserId]=nil end
    carrierHumanoid=nil; savedSpeed=nil; state.carrier=0; pending=nil
    if positionAlign then positionAlign:Destroy(); positionAlign=nil end
    if orientationAlign then orientationAlign:Destroy(); orientationAlign=nil end
    followErrorAt=nil; carryStarted=nil
    if old then speed(old) end
end
local function setCarrier(p)
    local _,h,r=character(p); if not h then return false end
    release(); flight=nil; table.clear(catchers); state.carrier=p.UserId; state.packageState='Carried'
    carrierHumanoid=h; speed(p)
    parcel.AssemblyLinearVelocity=Vector3.zero; parcel.AssemblyAngularVelocity=Vector3.zero
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
    release(); flight=nil; table.clear(catchers); state.packageState='Recovering'
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
    release(); flight=nil; table.clear(charges); table.clear(catchers); if parcel then parcel:Destroy() end
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
    if state.packageState=='Thrown' then return false,'Catch or place the package first.' end
    if state.checkpoint<Config.CheckpointCount then return false,'Follow either marked route to the destination.' end
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
local function exhaust(p)
    local cf=placement(p)
    if not cf and (outside() or not clearSpace(parcel.CFrame)) then recover('Exhausted in blocked space')
    else
        release(); if cf then parcel.CFrame=cf end
        parcel.AssemblyLinearVelocity=Vector3.zero; parcel.AssemblyAngularVelocity=Vector3.zero
        state.packageState='Dropped'; publish()
    end
    Net.Response:FireClient(p,{ok=true,message='Exhausted — package released. Rest or ask a teammate.'})
end
updateVitals=function()
    local now=os.clock(); local dt=now-lastVitals; lastVitals=now
    for _,p in ipairs(Players:GetPlayers()) do
        local _,h,root=character(p)
        local moving=root and Vector3.new(root.AssemblyLinearVelocity.X,0,root.AssemblyLinearVelocity.Z).Magnitude>1
        local value=Stamina.step(stamina,p.UserId,dt,state.carrier==p.UserId,moving or (h and h.MoveDirection.Magnitude>0.05))
        if state.carrier==p.UserId and value<=0 then exhaust(p) end
        speed(p)
    end
end
local function action(p,data)
    if data.action=='Sync' then Net.State:FireClient(p,snapshot()); return true,'Ready.' end
    if data.cycleId~=state.cycleId then return false,'That delivery has already changed.' end
    if state.phase~='Active' then return false,'Delivery complete. Returning to depot…' end
    if not character(p) then return false,'Wait for your character to respawn.' end
    if data.action=='SetRunning' then
        if type(data.running)~='boolean' then return false,'Invalid running flag.' end
        Stamina.get(stamina,p.UserId).running=data.running; speed(p); publish(); return true,'Running updated.'
    elseif data.action=='BeginThrow' then
        if state.carrier~=p.UserId then return false,'Pick up the package first.' end
        if charges[p.UserId] then return false,'Already charging.' end
        charges[p.UserId]=workspace:GetServerTimeNow(); publish(); return true,'Release F / Throw to launch.'
    elseif data.action=='CancelThrow' then
        charges[p.UserId]=nil; publish(); return true,'Throw cancelled.'
    elseif data.action=='ReleaseThrow' then
        if state.carrier~=p.UserId or not charges[p.UserId] then return false,'No charged throw.' end
        local velocity=Transfer.launch(data.aim,workspace:GetServerTimeNow()-charges[p.UserId],Config)
        if not velocity then charges[p.UserId]=nil; publish(); return false,'Invalid aim.' end
        if not clearSpace(parcel.CFrame) then charges[p.UserId]=nil; publish(); return false,'No room to throw.' end
        release(); flightSerial+=1
        flight={id=flightSerial,previous=parcel.Position,started=os.clock(),origin=parcel.Position}
        state.packageState='Thrown'; parcel.AssemblyLinearVelocity=velocity; parcel.AssemblyAngularVelocity=Vector3.zero
        parcel:SetNetworkOwner(nil); publish(); return true,'Thrown — look at the parcel and press E to catch.'
    elseif data.action=='Catch' then
        if not flight or data.flightId~=flight.id or not Transfer.finite(data.aim) then return false,'No matching flight.' end
        if not Stamina.eligible(stamina,p.UserId) then return false,'Rest until stamina reaches 10.' end
        local _,_,root=character(p); local delta=parcel.Position-(root.Position+Vector3.new(0,1.5,0))
        if delta.Magnitude>Config.CatchTargetRange or (delta.Magnitude>0.01 and delta.Unit:Dot(data.aim.Unit)<math.cos(math.rad(Config.CatchAngle))) then return false,'Look at the nearby parcel.' end
        if workspace:Raycast(root.Position+Vector3.new(0,1.5,0),delta,queryParams()) then return false,'Catch is obstructed.' end
        if catchers[p.UserId] then return false,'Catch already armed for this flight.' end
        catchers[p.UserId]={flightId=flight.id,expires=workspace:GetServerTimeNow()+Config.CatchSeconds}
        publish(); return true,'Ready to catch.'
    elseif data.action=='Pickup' then
        if state.packageState=='Thrown' then return false,'Look at the parcel and catch it.' end
        if not Stamina.eligible(stamina,p.UserId) then return false,'Rest until stamina reaches 10.' end
        if state.carrier~=0 then return false,'Already carried.' end
        if not near(p,parcel.Position) then return false,'Move closer to the package.' end
        setCarrier(p); publish(); return true,'Package picked up.'
    elseif data.action=='Drop' then
        if state.carrier~=p.UserId then return false,'You are not carrying the package.' end
        charges[p.UserId]=nil
        local cf=placement(p); if not cf then publish(); return false,'No room to place.' end
        release(); parcel.CFrame=cf; parcel.AssemblyLinearVelocity=Vector3.zero; parcel.AssemblyAngularVelocity=Vector3.zero
        state.packageState='Dropped'; publish(); return true,'Package placed.'
    elseif data.action=='RequestHandoff' then
        if not Stamina.eligible(stamina,p.UserId) then return false,'Rest until stamina reaches 10.' end
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
        if not Stamina.eligible(stamina,recipient.UserId) then return false,'Recipient needs at least 10 stamina.' end
        setCarrier(recipient); publish(); return true,'Package handed over.'
    elseif data.action=='Switch' then
        if state.carrier==p.UserId then return false,'Place the package to free your hands.' end
        if not near(p,World.Switch.Position) then return false,'Move closer to the switch.' end
        state.gateOpen=true; World.Gate.CanCollide=false; World.Gate.Transparency=0.8
        publish(); return true,'Gate latched open until the next delivery.'
    elseif data.action=='Deliver' then return deliver(p)
    elseif data.action=='Recover' then
        if flight then return false,'Wait for the package to land.' end
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
    updateVitals()
    local ok,message=action(p,data)
    if ok then metrics.accepted+=1 else metrics.rejected+=1 end
    return ok,message
end
local function bindCharacter(p,c)
    local cons=playerConnections[p] or {}; playerConnections[p]=cons
    for _,co in ipairs(cons) do co:Disconnect() end; table.clear(cons)
    if state.carrier==p.UserId then recover('Character replaced') end
    charges[p.UserId]=nil; catchers[p.UserId]=nil; Stamina.get(stamina,p.UserId).running=false; bases[p.UserId]=nil
    local function part(v) if v:IsA('BasePart') then v.CollisionGroup='M1Players' end end
    for _,v in ipairs(c:GetDescendants()) do part(v) end
    table.insert(cons,c.DescendantAdded:Connect(part))
    task.spawn(function()
        local h=c:WaitForChild('Humanoid',10); if not h or p.Character~=c then return end
        table.insert(cons,h.Died:Connect(function()
            charges[p.UserId]=nil; catchers[p.UserId]=nil; Stamina.get(stamina,p.UserId).running=false
            if state.carrier==p.UserId then recover('Carrier reset') end
            if pending and pending.recipient==p.UserId then pending=nil end
            publish()
        end))
        speed(p)
        if state.phase=='Active' and state.checkpoint>=2 then c:PivotTo(CFrame.new(checkpointPosition()+Vector3.new(5,2,0))) end
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
        playerConnections[p]=nil; limits[p]=nil; stamina.players[p.UserId]=nil; bases[p.UserId]=nil; charges[p.UserId]=nil; catchers[p.UserId]=nil
    end))
    table.insert(connections,Net.Request.OnServerEvent:Connect(function(p,data)
        local ok,message=M.Handle(p,data); Net.Response:FireClient(p,{requestId=type(data)=='table' and data.requestId or '',ok=ok,message=message})
    end))
    startCycle(false)
    table.insert(connections,RunService.Heartbeat:Connect(function(dt)
        updateVitals()
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
        if flight then
            local a,b=flight.previous,parcel.Position; local delta=b-a; local impact
            if delta.Magnitude>0.001 then
                local hit=workspace:Blockcast(CFrame.new(a),parcel.Size,delta,queryParams())
                if hit then impact=math.clamp(hit.Distance/delta.Magnitude,0,1) end
            end
            if not clearSpace(parcel.CFrame) then impact=impact or 0 end
            local candidates={}
            for id,armed in pairs(catchers) do
                local p=Players:GetPlayerByUserId(id); local _,_,root=character(p)
                if root and armed.flightId==flight.id and workspace:GetServerTimeNow()<=armed.expires and Stamina.eligible(stamina,id) then
                    local center=root.Position+Vector3.new(0,1.5,0)
                    local t,dist=Transfer.intercept(a,b,center,Config.CatchRadius)
                    if t and not workspace:Raycast(center,a+delta*t-center,queryParams()) then table.insert(candidates,{t=t,distance=dist,id=id,player=p}) end
                end
            end
            local winner=Transfer.winner(candidates,impact)
            if winner then metrics.catches=(metrics.catches or 0)+1; setCarrier(winner.player); publish()
            elseif impact or os.clock()-flight.started>8 then
                metrics.impacts=(metrics.impacts or 0)+1
                metrics.lastFlight={distance=(b-flight.origin).Magnitude,speed=parcel.AssemblyLinearVelocity.Magnitude}
                flight=nil; table.clear(catchers); state.packageState='Dropped'; publish()
            else flight.previous=b end
        end
        accumulator+=dt; if accumulator<0.1 then return end; accumulator=0
        publish()
        if outside() then recover('Out of bounds'); return end
        if pending and workspace:GetServerTimeNow()>=pending.expires then pending=nil; publish() end
        local nextIndex=state.checkpoint+1
        local cp=World.Markers:FindFirstChild('Checkpoint'..nextIndex)
        if cp and state.packageState~='Thrown' and (parcel.Position-cp.Position).Magnitude<10 then
            for _,p in ipairs(Players:GetPlayers()) do
                if near(p,cp.Position+Vector3.new(0,2,0)) then state.checkpoint=nextIndex; publish(); break end
            end
        end
    end))
    if RunService:IsStudio() then
        local bridge=Instance.new('BindableFunction'); bridge.Name='M1StudioTests'; bridge.Parent=game:GetService('ServerStorage')
        bridge.OnInvoke=function(op,p,data)
            if op=='Inspect' then return M.Inspect() end
            if op=='NewPracticeRun' then stamina=Stamina.new(Config,data); startCycle(true); return true end
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
