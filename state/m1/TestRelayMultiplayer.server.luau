-- Temporary Studio test only; supports real 2/3/4-client configurations.
local TS=game:GetService('StudioTestService')
if not game:GetService('RunService'):IsStudio() then return end
local arg=TS:GetTestArgs()
if type(arg)~='string' or not arg:match('^Relay%d$') then return end
local count=tonumber(arg:sub(-1)); local passed={}
local ok,err=xpcall(function()
    local Players=game.Players; local Http=game:GetService('HttpService')
    local deadline=os.clock()+30
    repeat task.wait(.1) until #Players:GetPlayers()==count or os.clock()>deadline
    assert(#Players:GetPlayers()==count,'Clients did not arrive')
    for _,p in ipairs(Players:GetPlayers()) do
        while not (p.Character and p.Character:FindFirstChild('HumanoidRootPart')) and os.clock()<deadline do task.wait(.1) end
    end
    local bridge=game.ServerStorage:WaitForChild('M1StudioTests',10)
    local function info() return bridge:Invoke('Inspect') end
    local function check(n,v) assert(v,n); table.insert(passed,n) end
    local function req(p,action,extra)
        local d={action=action,requestId=Http:GenerateGUID(false),cycleId=info().state.cycleId}
        for k,v in pairs(extra or {}) do d[k]=v end
        return bridge:Invoke('Request',p,d)
    end
    bridge:Invoke('NewPracticeRun',nil,count)
    local a,b=table.unpack(Players:GetPlayers())
    a.Character:PivotTo(CFrame.new(18,3,-5)); b.Character:PivotTo(CFrame.new(22,3,-5)); task.wait(.5)
    local r={}
    task.spawn(function() r[1]=req(a,'Pickup') end); task.spawn(function() r[2]=req(b,'Pickup') end)
    task.wait(.2); check('One pickup winner',r[1]~=r[2])
    local carrier=Players:GetPlayerByUserId(info().state.carrier); local receiver=carrier==a and b or a
    check('Consent request',req(receiver,'RequestHandoff'))
    local token=info().state.pending.token
    check('Carrier consent',req(carrier,'AcceptHandoff',{token=token}))
    check('One receiver',info().state.carrier==receiver.UserId)
    check('Replay rejected',not req(carrier,'AcceptHandoff',{token=token}))
    req(receiver,'Drop'); task.wait(.2)
    bridge:Invoke('NewPracticeRun',nil,count); task.wait(.2)
    a.Character:PivotTo(CFrame.new(20,3,-5)); b.Character:PivotTo(CFrame.new(20,3,-23)); task.wait(.4)
    check('Pickup for throw',req(a,'Pickup')); task.wait(.4)
    check('Begin throw',req(a,'BeginThrow')); task.wait(.8)
    check('Release throw',req(a,'ReleaseThrow',{aim=Vector3.new(0,0,-1)}))
    local i=info(); local dir=i.parcel.Position-(b.Character.HumanoidRootPart.Position+Vector3.new(0,1.5,0))
    check('Arm aimed catch',req(b,'Catch',{flightId=i.state.flightId,aim=dir.Unit}))
    task.wait(.5)
    check('Actual airborne catch',info().state.carrier==b.UserId)
    check('Catch server ownership',info().parcel:GetNetworkOwner()==nil)
    check('Previous carrier speed restored',math.abs(a.Character.Humanoid.WalkSpeed-16)<.01)
    check('Catch counter',info().metrics.catches>=1)
    local before=info().state.players[tostring(b.UserId)].stamina
    b.Character.Humanoid.Health=0; task.wait(.3)
    check('Death releases',info().state.carrier==0)
    check('Death does not refill',info().state.players[tostring(b.UserId)].stamina<before+5)
    a:Kick('Relay disconnect fixture'); task.wait(1)
    check('Fixed endurance after departure',info().state.enduranceCount==count)
end,debug.traceback)
TS:EndTest({ok=ok,error=not ok and err or nil,passed=passed,count=count})
