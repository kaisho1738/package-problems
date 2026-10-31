-- Server fixture: teleports the real test character between valid locations.
-- This verifies request/cycle invariants, NOT navigation feel or anti-teleport security.
local b=game.ServerStorage:WaitForChild('M1StudioTests')
local p=assert(game.Players:GetPlayers()[1]); local Http=game:GetService('HttpService')
local passed={}
local function info() return b:Invoke('Inspect') end
local function req(action,extra)
    local d={action=action,requestId=Http:GenerateGUID(false),cycleId=info().state.cycleId}
    for k,v in pairs(extra or {}) do d[k]=v end
    local ok,message=b:Invoke('Request',p,d); return ok,message
end
local function at(pos)
    local r=info(); local delta=pos-p.Character.HumanoidRootPart.Position
    if r.state.carrier==p.UserId then
        r.parcel.CFrame=r.parcel.CFrame+delta; r.parcel.AssemblyLinearVelocity=Vector3.zero
    end
    p.Character:PivotTo(CFrame.new(pos)); p.Character.HumanoidRootPart.AssemblyLinearVelocity=Vector3.zero
end
local baseline=info().connections
if info().state.carrier==p.UserId then req('Drop') end
for i=1,3 do
    if info().state.phase=='Result' then task.wait(5.2) end
    local cycle=info().state.cycleId
    at(Vector3.new(20,3,-5)); task.wait(.2)
    assert(req('Pickup'),'Pickup failed'); task.wait(2.1)
    at(Vector3.new(20,3,-89)); task.wait(.8)
    assert(info().state.checkpoint==2,'Checkpoint not reached')
    at(Vector3.new(20,3,-126)); task.wait(.8)
    local ok,message=req('Deliver'); assert(ok,message)
    assert(not req('Deliver'),'Duplicate delivery accepted')
    task.wait(5.2)
    local r=info()
    assert(r.state.cycleId==cycle+1 and r.state.phase=='Active','Next cycle failed')
    assert(r.state.checkpoint==1 and not r.state.gateOpen,'World not reset')
    assert(r.connections==baseline,'Connection count grew')
    assert(r.carryConstraints==1,'Carry constraints leaked')
    assert(not req('Pickup',{cycleId=cycle}),'Stale request accepted')
    table.insert(passed,{cycle=cycle,completed=r.state.completed,connections=r.connections,parcelChildren=r.carryConstraints})
end
return passed
