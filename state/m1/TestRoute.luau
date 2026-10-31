-- Live Humanoid navigation; no parcel/character relocation after pickup setup.
local bridge=game.ServerStorage.M1StudioTests
local p=game.Players:GetPlayers()[1]; local H=game:GetService('HttpService')
bridge:Invoke('NewPracticeRun',nil,1)
p.Character:PivotTo(CFrame.new(20,3,-5)); task.wait(.4)
local function inspect() return bridge:Invoke('Inspect') end
local function req(action)
    return bridge:Invoke('Request',p,{action=action,cycleId=inspect().state.cycleId,requestId=H:GenerateGUID(false)})
end
assert(req('Pickup'),'Route pickup failed')
local started=os.clock(); local rests=0; local peakSpeed=0
local nodes={Vector3.new(20,3,-35),Vector3.new(66,3,-35),Vector3.new(66,3,-84),Vector3.new(20,3,-92),Vector3.new(20,3,-242),Vector3.new(20,3,-359),Vector3.new(47,3,-359),Vector3.new(47,3,-391),Vector3.new(20,3,-392),Vector3.new(20,3,-542),Vector3.new(20,3,-692),Vector3.new(20,3,-726)}
for index,node in ipairs(nodes) do
    local deadline=os.clock()+35; local lastMove=0
    while (p.Character.HumanoidRootPart.Position-node).Magnitude>2.5 do
        assert(os.clock()<deadline,'Navigation stuck at node '..index)
        local i=inspect(); assert(i.state.carrier==p.UserId,'Unexpected carry loss at node '..index)
        peakSpeed=math.max(peakSpeed,i.parcel.AssemblyLinearVelocity.Magnitude)
        local value=i.state.players[tostring(p.UserId)].stamina
        if value<20 then
            p.Character.Humanoid:MoveTo(p.Character.HumanoidRootPart.Position); task.wait(.2)
            assert(req('Drop'),'Rest placement failed'); rests+=1; task.wait(8.2)
            assert(req('Pickup'),'Rest pickup failed'); deadline+=9; lastMove=0
        end
        if os.clock()-lastMove>2 then p.Character.Humanoid:MoveTo(node); lastMove=os.clock() end
        task.wait(.1)
    end
end
task.wait(.3)
assert(req('Deliver'),'Route delivery failed')
return {ok=true,elapsed=os.clock()-started,rests=rests,peakPackageSpeed=peakSpeed,gateOpen=inspect().state.gateOpen,checkpoint=inspect().state.checkpoint}
