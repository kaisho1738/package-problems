-- One-time edit-mode authoring script. Not installed as a runtime generator.
assert(not workspace:FindFirstChild('PackageProblemsM1'),'M1 already exists; inspect before rebuilding')
local function make(class,name,parent,props)
    local o=Instance.new(class); o.Name=name
    for k,v in pairs(props or {}) do o[k]=v end
    o.Parent=parent; return o
end
local world=make('Model','PackageProblemsM1',workspace)
world.ModelStreamingMode=Enum.ModelStreamingMode.Persistent
local geometry=make('Folder','Geometry',world)
local markers=make('Folder','Markers',world)
local function part(name,size,pos,color,parent,solid)
    return make('Part',name,parent or geometry,{Anchored=true,Size=size,Position=pos,Color=color,
        Material=Enum.Material.SmoothPlastic,CanCollide=solid~=false,CanTouch=false})
end
local blue=Color3.fromRGB(68,141,185); local yellow=Color3.fromRGB(244,194,74)
local gray=Color3.fromRGB(104,114,120); local cream=Color3.fromRGB(233,232,213)
local function sign(name,text,pos,color)
    local p=part(name,Vector3.new(16,5,0.5),pos,color or blue,nil,false)
    local s=make('SurfaceGui','Sign',p,{Face=Enum.NormalId.Back,SizingMode=Enum.SurfaceGuiSizingMode.PixelsPerStud,PixelsPerStud=35})
    make('TextLabel','Text',s,{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text=text,TextScaled=true,
        TextColor3=Color3.fromRGB(255,255,255),Font=Enum.Font.GothamBold,TextWrapped=true})
    local other=s:Clone(); other.Name='ReverseSign'; other.Face=Enum.NormalId.Front; other.Parent=p
    return p
end
part('DepotFloor',Vector3.new(34,.2,28),Vector3.new(15,.1,0),cream)
part('MainPath',Vector3.new(16,.12,125),Vector3.new(20,.07,-67),gray)
part('AlternateOut',Vector3.new(50,.12,12),Vector3.new(43,.08,-35),blue)
part('AlternateSide',Vector3.new(12,.12,55),Vector3.new(66,.08,-58),blue)
part('AlternateIn',Vector3.new(50,.12,12),Vector3.new(43,.08,-84),blue)
part('DestinationFloor',Vector3.new(30,.2,24),Vector3.new(20,.1,-130),cream)
local pickup=part('Checkpoint1',Vector3.new(8,.2,8),Vector3.new(20,.25,-10),blue,markers,false)
local cp=part('Checkpoint2',Vector3.new(12,.1,8),Vector3.new(20,.16,-92),blue,markers,false)
local pad=part('DeliveryPad',Vector3.new(12,.2,10),Vector3.new(20,.3,-130),yellow,markers,false)
part('BarrierLeft',Vector3.new(29,12,2),Vector3.new(-1.5,6,-60),gray)
part('BarrierRight',Vector3.new(29,12,2),Vector3.new(41.5,6,-60),gray)
part('Gate',Vector3.new(14,10,2),Vector3.new(20,5,-60),yellow,world)
part('Switch',Vector3.new(3,3,2),Vector3.new(10,2,-55),yellow,world,false)
sign('DepotSign','PACKAGE PROBLEMS\nPractice depot',Vector3.new(20,7,12),blue)
sign('RouteSign','DELIVER AHEAD\nGate: place box, then use switch',Vector3.new(20,8,-29),blue)
sign('AlternateSign','FREE ALTERNATE ROUTE →\nFollow the blue path',Vector3.new(47,6,-28),blue)
sign('DestinationSign','DELIVERY\nPlace inside yellow pad + interact',Vector3.new(20,7,-143),Color3.fromRGB(148,105,28))
local storage=make('Folder','PackageProblemsM1',game:GetService('ServerStorage'))
local parcel=part('StandardPackage',Vector3.new(3,3,3),Vector3.new(0,3,0),Color3.fromRGB(181,133,79),storage,true)
parcel.Anchored=false; parcel.CollisionGroup='Default'
parcel.CustomPhysicalProperties=PhysicalProperties.new(.7,.5,0,100,100)
make('Attachment','CarryAttachment',parcel)
local shared=make('Folder','PackageProblemsM1',game:GetService('ReplicatedStorage'))
local remotes=make('Folder','Remotes',shared)
for _,n in ipairs({'Request','Response','State'}) do make('RemoteEvent',n,remotes) end
make('Folder','PackageProblemsM1',game:GetService('ServerScriptService'))
local gui=make('ScreenGui','PackageProblemsM1',game:GetService('StarterGui'),{ResetOnSpawn=false,ZIndexBehavior=Enum.ZIndexBehavior.Sibling})
local function label(name,parent,pos,size,text)
    return make('TextLabel',name,parent,{Position=pos,Size=size,Text=text,TextWrapped=true,TextSize=17,
        Font=Enum.Font.Gotham,TextColor3=Color3.fromRGB(245,245,239),BackgroundColor3=Color3.fromRGB(31,40,48),BorderSizePixel=0})
end
local header=make('Frame','Header',gui,{Position=UDim2.fromScale(.02,.02),Size=UDim2.fromScale(.65,.17),BackgroundTransparency=1})
label('Status',header,UDim2.fromScale(0,0),UDim2.fromScale(1,.48),'Package Problems · Practice')
label('Hint',header,UDim2.fromScale(0,.52),UDim2.fromScale(1,.48),'Pick up the package and deliver it to the yellow pad.')
local actions=make('Frame','Actions',gui,{AnchorPoint=Vector2.new(1,.5),Position=UDim2.fromScale(.98,.48),Size=UDim2.fromScale(.28,.49),BackgroundTransparency=1})
make('UISizeConstraint','Limits',actions,{MinSize=Vector2.new(140,200),MaxSize=Vector2.new(240,240)})
make('UIListLayout','Layout',actions,{Padding=UDim.new(0,7),SortOrder=Enum.SortOrder.LayoutOrder})
for i,item in ipairs({{'Context','E · Pick up package'},{'Drop','Q · Place package'},{'Recover','Recover stuck package'},{'Info','I · Package info'}}) do
    make('TextButton',item[1],actions,{LayoutOrder=i,Size=UDim2.new(1,0,0,45),BackgroundColor3=yellow,BorderSizePixel=0,
        Text=item[2],TextWrapped=true,TextSize=16,Font=Enum.Font.GothamBold,TextColor3=Color3.fromRGB(25,32,38)})
end
local feedback=label('Feedback',gui,UDim2.fromScale(.22,.77),UDim2.fromScale(.56,.1),''); feedback.Visible=false
local handoff=label('Handoff',gui,UDim2.fromScale(.2,.25),UDim2.fromScale(.55,.12),''); handoff.Visible=false
local result=label('Result',gui,UDim2.fromScale(.24,.4),UDim2.fromScale(.48,.2),'DELIVERED!\nReturning to the depot in 5 seconds.'); result.Visible=false; result.TextSize=23
local info=label('Inspect',gui,UDim2.fromScale(.2,.24),UDim2.fromScale(.55,.3),'STANDARD PACKAGE\nCarry carefully. Place it to free your hands.\nTeammates can request a handoff; you decide whether to accept.\nThis practice slice has no HP, timer, coins or strikes.'); info.Visible=false
return 'Authored M1 world, package template, remotes, and editable UI.'
