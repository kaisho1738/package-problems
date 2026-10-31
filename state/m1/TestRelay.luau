-- Execute in a solo Server context. Uses live boundary; relocation is fixture setup, not route evidence.
local bridge=game.ServerStorage.M1StudioTests
local p=game.Players:GetPlayers()[1]
local Http=game:GetService('HttpService')
local passed={}
local function check(name,value) assert(value,name); table.insert(passed,name) end
local function info() return bridge:Invoke('Inspect') end
local function req(action,extra)
    local d={action=action,requestId=Http:GenerateGUID(false),cycleId=info().state.cycleId}
    for k,v in pairs(extra or {}) do d[k]=v end
    return bridge:Invoke('Request',p,d)
end
local function move(pos) p.Character:PivotTo(CFrame.new(pos)); p.Character.HumanoidRootPart.AssemblyLinearVelocity=Vector3.zero end
local c=require(game.ReplicatedStorage.PackageProblemsM1.Config)
local S=require(game.ServerScriptService.PackageProblemsM1.Stamina)
local T=require(game.ServerScriptService.PackageProblemsM1.Transfer)
for count,seconds in ipairs(c.Endurance) do
    local s=S.new(c,count)
    check('Endurance '..count,S.step(s,1,seconds,true,false)==0)
    check('Regen '..count,S.step(s,1,10,false,true)==100)
    S.get(s,1).running=true
    check('Run drain '..count,S.step(s,1,seconds/1.5,true,true)<.001)
    check('Zero receive denied '..count,not S.eligible(s,1))
end
check('Invalid aim rejected',not T.launch(Vector3.new(0/0,0,1),1,c))
check('Charge capped',math.abs(T.launch(Vector3.new(0,0,-1),10,c).Magnitude-95)<.001)
check('Minimum throw',math.abs(T.launch(Vector3.new(0,0,-1),0,c).Magnitude-55)<.001)
local a,b=Vector3.new(-20,0,0),Vector3.new(20,0,0)
local t,d=T.intercept(a,b,Vector3.zero,6)
check('Swept interception',math.abs(t-.35)<.001)
check('Impact wins tie',not T.winner({{id=1,t=t,distance=d}},t))
check('Contest stable ID',T.winner({{id=2,t=t,distance=d},{id=1,t=t,distance=d}},.9).id==1)
bridge:Invoke('NewPracticeRun',nil,4); task.wait(.3)
move(Vector3.new(20,3,-5)); task.wait(.3)
check('Live pickup',req('Pickup'))
check('Server owned',info().parcel:GetNetworkOwner()==nil)
check('Carry walking speed',math.abs(p.Character.Humanoid.WalkSpeed-13.6)<.01)
check('Begin charge',req('BeginThrow'))
check('No auto-release at full charge',task.wait(1.2) and info().state.packageState=='Carried')
check('Invalid launch denied',not req('ReleaseThrow',{aim=Vector3.zero}))
check('Charge cancelled on invalid launch',info().state.players[tostring(p.UserId)].chargeAt==nil)
task.wait(.4)
check('Begin charge again',req('BeginThrow')); task.wait(.3)
check('Launch',req('ReleaseThrow',{aim=Vector3.new(0,0,-1)}))
check('Thrown state',info().state.packageState=='Thrown')
check('Air pickup rejected',not req('Pickup'))
check('Stale catch denied',not req('Catch',{flightId=-1,aim=Vector3.new(0,0,-1)}))
task.wait(2)
check('World impact ends flight',info().state.packageState=='Dropped')
check('Flight remains server owned',info().parcel:GetNetworkOwner()==nil)
bridge:Invoke('NewPracticeRun',nil,4); task.wait(.5); move(Vector3.new(20,3,-5)); task.wait(.2)
check('Pickup for exhaustion',req('Pickup'))
task.wait(18.4)
check('Stationary exhaustion releases',info().state.carrier==0 and info().state.packageState=='Dropped')
check('Low receive denied',not req('Pickup'))
check('Speed restored',math.abs(p.Character.Humanoid.WalkSpeed-16)<.01)
task.wait(1.2)
check('Rest permits pickup',req('Pickup'))
check('Reset keeps fixed count',info().state.enduranceCount==4)
req('Drop')
for cycle=1,10 do
    bridge:Invoke('NewPracticeRun',nil,1); task.wait(.15)
    -- Walk checkpoint state in order with the real resting parcel and player, not direct state writes.
    local parcel=info().parcel
    for index=2,c.CheckpointCount do
        local pos=workspace.PackageProblemsM1.Markers['Checkpoint'..index].Position
        move(pos+Vector3.new(0,3,4)); parcel.CFrame=CFrame.new(pos+Vector3.new(0,1.6,0)); parcel.AssemblyLinearVelocity=Vector3.zero
        task.wait(.2)
        check('Ordered checkpoint '..cycle..'/'..index,info().state.checkpoint==index)
    end
    local pad=workspace.PackageProblemsM1.Markers.DeliveryPad
    move(pad.Position+Vector3.new(0,3,4)); parcel.CFrame=CFrame.new(pad.Position+Vector3.new(0,1.6,0)); parcel.AssemblyLinearVelocity=Vector3.zero
    task.wait(.4); check('Delivery '..cycle,req('Deliver'))
    check('Duplicate delivery '..cycle,not req('Deliver'))
    check('Stable listeners '..cycle,info().connections==4)
    check('No carry constraints '..cycle,info().carryConstraints==1)
    task.wait(5.2)
    check('Automatic next cycle '..cycle,info().state.phase=='Active')
end
return {passed=passed,count=#passed,metrics=info().metrics}
