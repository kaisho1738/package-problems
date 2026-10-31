-- Edit-only extension, safe to rerun; original gate/bypass/depot preserved.
local w=workspace.PackageProblemsM1
if not game.ServerStorage:FindFirstChild('M1BeforeRelay') then
    local backup=Instance.new('Folder'); backup.Name='M1BeforeRelay'; backup.Parent=game.ServerStorage
    for _,v in ipairs({w,game.ReplicatedStorage.PackageProblemsM1,game.ServerScriptService.PackageProblemsM1,game.StarterGui.PackageProblemsM1,game.StarterPlayer.StarterPlayerScripts.PackageProblemsM1Client}) do v:Clone().Parent=backup end
end
local old=w:FindFirstChild('RelayCourse'); if old then old:Destroy() end
local course=Instance.new('Folder'); course.Name='RelayCourse'; course.Parent=w
local function part(name,size,pos,color,solid,parent)
    local p=Instance.new('Part'); p.Name=name; p.Size=size; p.Position=pos; p.Anchored=true; p.Color=color
    p.CanCollide=solid~=false; p.CanTouch=false; p.Parent=parent or course; return p
end
local blue=Color3.fromRGB(68,141,185); local gray=Color3.fromRGB(104,114,120)
part('RelayFloor',Vector3.new(24,.2,620),Vector3.new(20,.1,-430),gray)
for _,x in ipairs({7,33}) do part('Rail',Vector3.new(2,4,620),Vector3.new(x,2,-430),gray) end
-- 25-stud parcel shortcut across a low barrier; people walk around its eastern end.
part('ThrowBarrier',Vector3.new(20,5,2),Vector3.new(19,2.5,-370),blue)
part('WalkAround',Vector3.new(32,.2,50),Vector3.new(47,.1,-370),blue)
-- Open the eastern rail around the barrier, keeping the detour inside recovery bounds.
for _,v in ipairs(course:GetChildren()) do if v.Name=='Rail' and v.Position.X==33 then
    v:Destroy()
    part('EastRailNorth',Vector3.new(2,4,235),Vector3.new(33,2,-237.5),gray)
    part('EastRailSouth',Vector3.new(2,4,345),Vector3.new(33,2,-567.5),gray)
end end
for i,z in ipairs({-242,-392,-542,-692}) do
    local index=i+2; local cp=w.Markers:FindFirstChild('Checkpoint'..index)
    if not cp then cp=part('Checkpoint'..index,Vector3.new(16,.1,10),Vector3.new(20,.25,z),blue,false,w.Markers) end
    part('RestArea'..index,Vector3.new(20,.15,20),Vector3.new(20,.2,z),blue)
    local sign=part('RestSign'..index,Vector3.new(12,4,.3),Vector3.new(20,6,z-12),blue,false)
    local g=Instance.new('BillboardGui'); g.Size=UDim2.fromOffset(240,70); g.AlwaysOnTop=false; g.Parent=sign
    local l=Instance.new('TextLabel'); l.Size=UDim2.fromScale(1,1); l.BackgroundTransparency=1; l.TextColor3=Color3.new(1,1,1); l.TextScaled=true; l.Text='REST / RELAY\nCheckpoint '..index; l.Parent=g
end
w.Markers.DeliveryPad.Position=Vector3.new(20,.3,-730)
w.Geometry.DestinationFloor.Position=Vector3.new(20,.1,-730)
w.Geometry.DestinationSign.Position=Vector3.new(20,7,-743)
local gui=game.StarterGui.PackageProblemsM1
gui.ScreenInsets=Enum.ScreenInsets.CoreUISafeInsets
gui.Header.Size=UDim2.fromScale(.66,.17)
gui.Actions.AnchorPoint=Vector2.new(1,0); gui.Actions.Position=UDim2.fromScale(.98,.24); gui.Actions.Size=UDim2.fromScale(.26,.46)
gui.Actions.Limits.MinSize=Vector2.new(130,120); gui.Actions.Limits.MaxSize=Vector2.new(230,300)
gui.Actions.Layout:Destroy()
local grid=Instance.new('UIGridLayout'); grid.Name='Layout'; grid.CellSize=UDim2.new(.5,-3,0,42); grid.CellPadding=UDim2.fromOffset(6,6); grid.SortOrder=Enum.SortOrder.LayoutOrder; grid.Parent=gui.Actions
for _,name in ipairs({'Throw','Run'}) do
    if not gui.Actions:FindFirstChild(name) then local b=gui.Actions.Drop:Clone(); b.Name=name; b.Parent=gui.Actions end
end
for i,name in ipairs({'Context','Drop','Throw','Run','Recover','Info'}) do
    local b=gui.Actions[name]; b.LayoutOrder=i; b.Size=UDim2.new(1,0,0,42); b.TextSize=14
end
for i,name in ipairs({'Stamina','Charge'}) do
    local l=gui:FindFirstChild(name) or gui.Header.Status:Clone(); l.Name=name; l.Parent=gui
    l.Position=UDim2.fromScale(.02,.19+(i-1)*.07); l.Size=UDim2.fromScale(.63,.065); l.TextSize=15; l.Text=''
end
gui.Inspect.Text='STANDARD PARCEL\nE: interact / look at flying parcel to catch.\nQ: place and recover stamina. Shift: run.\nHold F, aim, release: throw. Teammates request handoff; carrier accepts.\nNo HP, deadline or strikes in practice.'
game.ServerScriptService.PackageProblemsM1:SetAttribute('PracticePlayerCount',1)
return 'Relay course and authored HUD installed.'
