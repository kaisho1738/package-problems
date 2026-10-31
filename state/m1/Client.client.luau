local Players=game:GetService('Players')
local RS=game:GetService('ReplicatedStorage')
local UIS=game:GetService('UserInputService')
local RunService=game:GetService('RunService')
local Http=game:GetService('HttpService')
local player=Players.LocalPlayer
local shared=RS:WaitForChild('PackageProblemsM1')
local net=shared.Remotes
local gui=player:WaitForChild('PlayerGui'):WaitForChild('PackageProblemsM1')
local world=workspace:WaitForChild('PackageProblemsM1')
local panel=gui.Actions
local Config=require(shared.Config)
local charging=false
local chargeInput=nil
local runToggle=false
local displayedStamina=100
local highlight=Instance.new('Highlight'); highlight.Name='CatchTarget'; highlight.FillTransparency=0.7; highlight.Enabled=false; highlight.Parent=gui
local function aim() return workspace.CurrentCamera.CFrame.LookVector end

local state,context,feedbackUntil,lastRefresh=nil,nil,0,0
local sent,sendOrder={},{}
local function send(action,extra)
    if not state and action~='Sync' then return end
    local data={action=action,cycleId=state and state.cycleId or 0,requestId=Http:GenerateGUID(false)}
    if extra then for k,v in pairs(extra) do data[k]=v end end
    if RunService:IsStudio() then
        sent[data.requestId]={at=os.clock(),action=action}; table.insert(sendOrder,data.requestId)
        if #sendOrder>64 then sent[table.remove(sendOrder,1)]=nil end
    end
    net.Request:FireServer(data)
end
local function mine() return state and state.players and state.players[tostring(player.UserId)] end
local function catchTarget(parcel,root)
    local me=mine()
    if not parcel or state.packageState~='Thrown' or not me or me.stamina<Config.ReceiveMinimum then return false end
    local delta=parcel.Position-(root.Position+Vector3.new(0,1.5,0))
    if delta.Magnitude>Config.CatchTargetRange or (delta.Magnitude>0.01 and delta.Unit:Dot(aim())<math.cos(math.rad(Config.CatchAngle))) then return false end
    local params=RaycastParams.new(); params.FilterType=Enum.RaycastFilterType.Exclude
    local ignore={parcel,world.Markers}
    for _,p in ipairs(Players:GetPlayers()) do if p.Character then table.insert(ignore,p.Character) end end
    params.FilterDescendantsInstances=ignore; params.RespectCanCollide=true
    return workspace:Raycast(root.Position+Vector3.new(0,1.5,0),delta,params)==nil
end
local function refresh()
    local c=player.Character; local r=c and c:FindFirstChild('HumanoidRootPart')
    if not state or not r then context=nil; return end
    local parcel=world:FindFirstChild('LivePackage')
    local carrier=Players:GetPlayerByUserId(state.carrier)
    local carrierRoot=carrier and carrier.Character and carrier.Character:FindFirstChild('HumanoidRootPart')
    local function close(pos) return (r.Position-pos).Magnitude<=8 end
    local text='Move toward the package'; context=nil
    local pending=state.pending
    if state.phase=='Result' then text='Delivered! Returning to depot…'
    elseif catchTarget(parcel,r) then context='Catch'; text='E · Catch'
    elseif state.packageState~='Thrown' and parcel and close(world.Markers.DeliveryPad.Position+Vector3.new(0,2,0)) and (state.carrier==player.UserId or state.carrier==0) then context='Deliver'; text='E · Deliver package'
    elseif pending and state.carrier==player.UserId then context='AcceptHandoff'; text='E · Accept handoff'
    elseif state.carrier~=0 and state.carrier~=player.UserId and carrierRoot and close(carrierRoot.Position) then context='RequestHandoff'; text='E · Request handoff'
    elseif not state.gateOpen and close(world.Switch.Position) then context='Switch'; text='E · Open gate (free hand)'
    elseif parcel and state.packageState~='Thrown' and state.carrier==0 and close(parcel.Position) then context='Pickup'; text='E · Pick up package'
    elseif state.carrier==player.UserId then text='Carry to the yellow pad · Q to place'
    end
    panel.Context.Text=text; panel.Context.Active=context~=nil
    panel.Context.BackgroundColor3=context and Color3.fromRGB(234,187,76) or Color3.fromRGB(85,91,97)
    panel.Context.TextColor3=context and Color3.fromRGB(22,28,34) or Color3.fromRGB(240,240,240)
    panel.Drop.Visible=state.carrier==player.UserId and state.phase=='Active'
    highlight.Adornee=parcel; highlight.Enabled=context=='Catch'
    panel.Throw.Visible=panel.Drop.Visible
    panel.Run.Visible=state.phase=='Active'
    panel.Run.Text=(mine() and mine().running) and 'Run: ON' or 'Run: OFF'
    if not panel.Throw.Visible then charging=false end
    panel.Recover.Visible=state.phase=='Active'
    local who=carrier and carrier.DisplayName or 'Nobody'
    gui.Header.Status.Text=string.format('Practice delivery %d  ·  Carrier: %s',state.cycleId,who)
    gui.Header.Hint.Text=state.phase=='Result' and 'Delivered — nice work!' or string.format('Checkpoint %d/%d · Place/rest or relay · %d-player endurance',state.checkpoint,Config.CheckpointCount,state.enduranceCount)
    gui.Result.Visible=state.phase=='Result'
    if pending and state.carrier==player.UserId then
        local recipient=Players:GetPlayerByUserId(pending.recipient)
        gui.Handoff.Visible=true
        gui.Handoff.Text=(recipient and recipient.DisplayName or 'Teammate')..' requests the package. Press E / Accept handoff.'
    else gui.Handoff.Visible=false end
end
local function interact()
    if not context then return end
    send(context,context=='AcceptHandoff' and {token=state.pending and state.pending.token} or context=='Catch' and {flightId=state.flightId,aim=aim()} or nil)
end
panel.Context.Activated:Connect(interact)
panel.Drop.Activated:Connect(function() charging=false; send('Drop') end)
panel.Recover.Activated:Connect(function() send('Recover') end)
local function inspect() gui.Inspect.Visible=not gui.Inspect.Visible end
panel.Info.Activated:Connect(inspect)
local function beginThrow()
    if charging or not state or state.carrier~=player.UserId then return end
    charging=true; send('BeginThrow')
end
local function releaseThrow()
    if not charging then return end
    charging=false; send('ReleaseThrow',{aim=aim()})
end
panel.Throw.InputBegan:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then chargeInput=i; beginThrow() end
end)
panel.Run.Activated:Connect(function() runToggle=not (mine() and mine().running); send('SetRunning',{running=runToggle}) end)
UIS.InputEnded:Connect(function(i)
    if i.KeyCode==Enum.KeyCode.F or i==chargeInput then chargeInput=nil; releaseThrow() end
    if i.KeyCode==Enum.KeyCode.LeftShift then send('SetRunning',{running=false}) end
end)
UIS.WindowFocusReleased:Connect(function() charging=false; runToggle=false; send('CancelThrow'); send('SetRunning',{running=false}) end)
UIS.TextBoxFocused:Connect(function() charging=false; send('CancelThrow'); send('SetRunning',{running=false}) end)
UIS.InputBegan:Connect(function(input,processed)
    if processed or UIS:GetFocusedTextBox() then return end
    if input.KeyCode==Enum.KeyCode.E then interact()
    elseif input.KeyCode==Enum.KeyCode.Q then charging=false; send('Drop')
    elseif input.KeyCode==Enum.KeyCode.F then beginThrow()
    elseif input.KeyCode==Enum.KeyCode.LeftShift then send('SetRunning',{running=true})
    elseif input.KeyCode==Enum.KeyCode.I then inspect() end
end)
net.State.OnClientEvent:Connect(function(s)
    if state and s.version<state.version then return end
    state=s; refresh()
end)
net.Response.OnClientEvent:Connect(function(response)
    local sample=sent[response.requestId]
    if sample then
        gui:SetAttribute('LastResponseMs',(os.clock()-sample.at)*1000)
        gui:SetAttribute('LastResponseAction',sample.action)
        gui:SetAttribute('LastResponseOK',response.ok)
        sent[response.requestId]=nil
    end
    if response.message then gui.Feedback.Text=response.message; gui.Feedback.Visible=true; feedbackUntil=os.clock()+3 end
end)
RunService.RenderStepped:Connect(function(dt)
    local now=os.clock()
    local me=mine()
    if me then
        displayedStamina+=(me.stamina-displayedStamina)*math.min(1,dt*15)
        gui.Stamina.Text=string.format('Stamina %d / 100%s',math.ceil(displayedStamina),me.stamina<=Config.LowStamina and ' · PLACE / RELAY' or '')
        gui.Stamina.BackgroundColor3=me.stamina<=Config.LowStamina and Color3.fromRGB(145,61,35) or Color3.fromRGB(31,40,48)
        gui.Charge.Visible=me.chargeAt~=nil
        gui.Charge.Text=me.chargeAt and string.format('Throw %d%% · release F / Throw',math.floor(math.clamp((workspace:GetServerTimeNow()-me.chargeAt)/Config.ChargeSeconds,0,1)*100)) or ''
        if me.catchUntil and me.catchUntil>workspace:GetServerTimeNow() then gui.Charge.Visible=true; gui.Charge.Text='Ready to catch' end
    end
    local touch=UIS.PreferredInput==Enum.PreferredInput.Touch
    panel.Drop.Text=touch and 'Place' or 'Q · Place'
    panel.Throw.Text=touch and 'Hold to throw' or 'Hold F · Throw'
    panel.Info.Text=touch and 'Info' or 'I · Info'
    if touch then panel.Context.Text=panel.Context.Text:gsub('E · ','') end
    if now-lastRefresh>=0.1 then lastRefresh=now; refresh() end
    if gui.Feedback.Visible and now>feedbackUntil then gui.Feedback.Visible=false end
end)
task.spawn(function()
    repeat send('Sync'); task.wait(2) until state
end)
player.CharacterAdded:Connect(function() task.defer(function() send('Sync') end) end)
