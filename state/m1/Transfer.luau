-- Geometry and deterministic arbitration shared by the live server and fixtures.
local M={}
function M.finite(v)
    return typeof(v)=='Vector3' and v.X==v.X and v.Y==v.Y and v.Z==v.Z
        and math.abs(v.X)<1e6 and math.abs(v.Y)<1e6 and math.abs(v.Z)<1e6 and v.Magnitude>0.001
end
function M.launch(aim,charge,c)
    if not M.finite(aim) then return end
    aim=aim.Unit
    local flat=Vector3.new(aim.X,0,aim.Z)
    if flat.Magnitude<0.001 then return end
    local angle=math.clamp(math.asin(aim.Y),math.rad(c.MinElevation),math.rad(c.MaxElevation))
    return (flat.Unit*math.cos(angle)+Vector3.yAxis*math.sin(angle))
        *(c.ThrowMin+(c.ThrowMax-c.ThrowMin)*math.clamp(charge/c.ChargeSeconds,0,1))
end
function M.intercept(a,b,center,radius)
    local d=b-a; local o=a-center; local q=d:Dot(d)
    if o:Dot(o)<=radius*radius then return 0,o.Magnitude end
    if q<1e-8 then return end
    local v=o:Dot(d); local disc=v*v-q*(o:Dot(o)-radius*radius)
    if disc<0 then return end
    local t=(-v-math.sqrt(disc))/q
    if t>=0 and t<=1 then return t,(a+d*t-center).Magnitude end
end
function M.winner(candidates,impact)
    table.sort(candidates,function(a,b)
        if math.abs(a.t-b.t)>1e-6 then return a.t<b.t end
        if math.abs(a.distance-b.distance)>1e-6 then return a.distance<b.distance end
        return a.id<b.id
    end)
    local first=candidates[1]
    if first and (not impact or first.t<impact-1e-6) then return first end
end
return M
