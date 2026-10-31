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
local state,context,feedbackUntil,lastRefresh=nil,nil,0,0
local function send(action,extra)
    if not state and action~='Sync' then return end
    local data={action=action,cycleId=state and state.cycleId or 0,requestId=Http:GenerateGUID(false)}
    if extra then for k,v in pairs(extra) do data[k]=v end end
    net.Request:FireServer(data)
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
    elseif parcel and close(world.Markers.DeliveryPad.Position+Vector3.new(0,2,0)) and (state.carrier==player.UserId or state.carrier==0) then context='Deliver'; text='E · Deliver package'
    elseif pending and state.carrier==player.UserId then context='AcceptHandoff'; text='E · Accept handoff'
    elseif state.carrier~=0 and state.carrier~=player.UserId and carrierRoot and close(carrierRoot.Position) then context='RequestHandoff'; text='E · Request handoff'
    elseif not state.gateOpen and close(world.Switch.Position) then context='Switch'; text='E · Open gate (free hand)'
    elseif parcel and state.carrier==0 and close(parcel.Position) then context='Pickup'; text='E · Pick up package'
    elseif state.carrier==player.UserId then text='Carry to the yellow pad · Q to place'
    end
    panel.Context.Text=text; panel.Context.Active=context~=nil
    panel.Context.BackgroundColor3=context and Color3.fromRGB(234,187,76) or Color3.fromRGB(85,91,97)
    panel.Context.TextColor3=context and Color3.fromRGB(22,28,34) or Color3.fromRGB(240,240,240)
    panel.Drop.Visible=state.carrier==player.UserId and state.phase=='Active'
    panel.Recover.Visible=state.phase=='Active'
    local who=carrier and carrier.DisplayName or 'Nobody'
    gui.Header.Status.Text=string.format('Practice delivery %d  ·  Carrier: %s',state.cycleId,who)
    gui.Header.Hint.Text=state.phase=='Result' and 'Delivered — nice work!' or 'Yellow pad = destination   •   Blue signs = free alternate route'
    gui.Result.Visible=state.phase=='Result'
    if pending and state.carrier==player.UserId then
        local recipient=Players:GetPlayerByUserId(pending.recipient)
        gui.Handoff.Visible=true
        gui.Handoff.Text=(recipient and recipient.DisplayName or 'Teammate')..' requests the package. Press E / Accept handoff.'
    else gui.Handoff.Visible=false end
end
local function interact()
    if not context then return end
    send(context,context=='AcceptHandoff' and {token=state.pending and state.pending.token} or nil)
end
panel.Context.Activated:Connect(interact)
panel.Drop.Activated:Connect(function() send('Drop') end)
panel.Recover.Activated:Connect(function() send('Recover') end)
local function inspect() gui.Inspect.Visible=not gui.Inspect.Visible end
panel.Info.Activated:Connect(inspect)
UIS.InputBegan:Connect(function(input,processed)
    if processed or UIS:GetFocusedTextBox() then return end
    if input.KeyCode==Enum.KeyCode.E then interact()
    elseif input.KeyCode==Enum.KeyCode.Q then send('Drop')
    elseif input.KeyCode==Enum.KeyCode.I then inspect() end
end)
net.State.OnClientEvent:Connect(function(s)
    if state and s.version<state.version then return end
    state=s; refresh()
end)
net.Response.OnClientEvent:Connect(function(response)
    if response.message then gui.Feedback.Text=response.message; gui.Feedback.Visible=true; feedbackUntil=os.clock()+3 end
end)
RunService.RenderStepped:Connect(function()
    local now=os.clock()
    if now-lastRefresh>=0.1 then lastRefresh=now; refresh() end
    if gui.Feedback.Visible and now>feedbackUntil then gui.Feedback.Visible=false end
end)
task.spawn(function()
    repeat send('Sync'); task.wait(2) until state
end)
player.CharacterAdded:Connect(function() task.defer(function() send('Sync') end) end)
