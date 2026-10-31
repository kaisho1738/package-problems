-- Temporary Studio-only Script, removed from the place after automated tests.
local StudioTest=game:GetService('StudioTestService')
if not game:GetService('RunService'):IsStudio() then return end
if StudioTest:GetTestArgs()~='PackageProblemsM1' then return end
local passed={}
local ok,err=xpcall(function()
    local Players=game:GetService('Players'); local Http=game:GetService('HttpService')
    local deadline=os.clock()+25
    repeat task.wait(.2) until #Players:GetPlayers()==2 or os.clock()>deadline
    assert(#Players:GetPlayers()==2,'Two clients did not arrive')
    local a,b=table.unpack(Players:GetPlayers())
    repeat task.wait(.2) until (a.Character and a.Character:FindFirstChild('HumanoidRootPart') and b.Character and b.Character:FindFirstChild('HumanoidRootPart')) or os.clock()>deadline
    local bridge=game.ServerStorage:WaitForChild('M1StudioTests',10)
    local function info() return bridge:Invoke('Inspect') end
    local function req(p,action,extra)
        local d={action=action,requestId=Http:GenerateGUID(false),cycleId=info().state.cycleId}
        for k,v in pairs(extra or {}) do d[k]=v end
        return bridge:Invoke('Request',p,d)
    end
    local function check(name,condition) assert(condition,name); table.insert(passed,name) end
    a.Character:PivotTo(CFrame.new(18,3,-5)); b.Character:PivotTo(CFrame.new(22,3,-5)); task.wait(.5)
    local results={}
    task.spawn(function() results[1]=req(a,'Pickup') end)
    task.spawn(function() results[2]=req(b,'Pickup') end)
    task.wait(.5)
    check('Simultaneous pickup: exactly one winner',results[1]~=results[2])
    local carrier=Players:GetPlayerByUserId(info().state.carrier)
    local recipient=carrier==a and b or a
    check('One authorized carrier',carrier~=nil)
    local accepted,message=req(recipient,'AcceptHandoff',{token='fake'})
    check('Cannot accept another player ownership',not accepted)
    check('Nearby handoff request accepted',req(recipient,'RequestHandoff'))
    check('Request alone does not transfer',info().state.carrier==carrier.UserId)
    local token=info().state.pending.token
    check('Carrier consent transfers once',req(carrier,'AcceptHandoff',{token=token}))
    check('Recipient now carries',info().state.carrier==recipient.UserId)
    check('Previous carrier speed restored',math.abs(carrier.Character.Humanoid.WalkSpeed-16)<.01)
    check('Handoff retains server physics ownership',info().parcel:GetNetworkOwner()==nil)
    check('Replayed acceptance rejected',not req(carrier,'AcceptHandoff',{token=token}))
    check('Reverse request accepted',req(carrier,'RequestHandoff'))
    token=info().state.pending.token; task.wait(5.3)
    check('Expired consent rejected',not req(recipient,'AcceptHandoff',{token=token}))
    carrier.Character:PivotTo(CFrame.new(60,3,-10)); task.wait(.2)
    check('Distant handoff denied',not req(carrier,'RequestHandoff'))
    recipient:Kick('M1 automated carrier-disconnect test')
    local leaveDeadline=os.clock()+8
    repeat task.wait(.2) until (recipient.Parent~=Players and info().state.carrier==0) or os.clock()>leaveDeadline
    check('Kicked client actually disconnected',recipient.Parent~=Players)
    check('Carrier disconnect releases parcel',info().state.carrier==0)
    carrier.Character:PivotTo(CFrame.new(20,3,-5)); task.wait(.3)
    check('Survivor can pick up parcel',req(carrier,'Pickup'))
    check('Still exactly one parcel',info().parcel.Parent==workspace.PackageProblemsM1)
end,debug.traceback)
StudioTest:EndTest({ok=ok,error=not ok and err or nil,passed=passed})
