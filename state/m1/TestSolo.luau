-- Execute only in a Studio SERVER after starting M1. Tests the actual request boundary.
assert(game:GetService('RunService'):IsStudio(),'Studio only')
local b=game.ServerStorage:WaitForChild('M1StudioTests')
local p=assert(game.Players:GetPlayers()[1],'Need a real client')
local Http=game:GetService('HttpService')
local passed={}
local function inspect() return b:Invoke('Inspect') end
local function request(action,extra)
    local data={action=action,requestId=Http:GenerateGUID(false),cycleId=inspect().state.cycleId}
    for k,v in pairs(extra or {}) do data[k]=v end
    return b:Invoke('Request',p,data)
end
local function check(name,condition) assert(condition,name); table.insert(passed,name) end
local function at(pos)
    p.Character:PivotTo(CFrame.new(pos)); p.Character.HumanoidRootPart.AssemblyLinearVelocity=Vector3.zero
    task.wait(.2)
end
if inspect().state.phase=='Result' then task.wait(5.2) end
check('Out-of-range pickup denied',not request('Pickup'))
at(Vector3.new(20,3,-5))
local data={action='Pickup',requestId=Http:GenerateGUID(false),cycleId=inspect().state.cycleId}
check('Valid pickup accepted',b:Invoke('Request',p,data))
check('Duplicate pickup denied',not b:Invoke('Request',p,data))
check('Carrier speed 13.6',math.abs(p.Character.Humanoid.WalkSpeed-13.6)<.01)
check('Physical parcel is server-owned',inspect().parcel:GetNetworkOwner()==nil)
check('Stale cycle denied',not request('Drop',{cycleId=-1}))
check('Cannot recall held parcel',not request('Recover'))
task.wait(.5)
local obstacle=Instance.new('Part'); obstacle.Name='M1TemporaryBlockedDrop'
obstacle.Anchored=true; obstacle.Size=Vector3.new(20,10,12); obstacle.Position=Vector3.new(20,5,-9); obstacle.Parent=workspace
local blocked=not request('Drop'); obstacle:Destroy()
check('Blocked drop retains carrier',blocked and inspect().state.carrier==p.UserId)
check('Wrong-position delivery denied',not request('Deliver'))
check('Valid drop accepted',request('Drop'))
check('Original speed restored',math.abs(p.Character.Humanoid.WalkSpeed-16)<.01)
local parcel=inspect().parcel
parcel.CFrame=CFrame.new(20,-30,-10); task.wait(.5)
check('Out-of-bounds automatic recovery',inspect().metrics.recoveries>0 and inspect().parcel.Position.Y>0)
check('Recovery does not advance checkpoint',inspect().state.checkpoint==1)
at(Vector3.new(20,3,-5)); check('Pickup after recovery',request('Pickup'))
p.Character.Humanoid.Health=0; task.wait(.5)
check('Death clears carrier',inspect().state.carrier==0)
check('Only one live parcel',#(function() local a={} for _,v in ipairs(workspace.PackageProblemsM1:GetChildren()) do if v.Name=='LivePackage' then table.insert(a,v) end end return a end)()==1)
return passed
