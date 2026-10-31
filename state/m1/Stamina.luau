-- Per-player state survives character replacement and practice delivery resets.
local M = {}
function M.new(config, count)
    assert(count >= 1 and count <= 4 and count % 1 == 0, 'Invalid fixed run count')
    return {config=config, count=count, players={}}
end
function M.get(self, id)
    if not self.players[id] then self.players[id]={value=self.config.StaminaCapacity,running=false} end
    return self.players[id]
end
function M.step(self, id, dt, carrying, moving)
    local p=M.get(self,id); local c=self.config
    local rate=carrying and -c.StaminaCapacity/c.Endurance[self.count] or c.Regeneration
    if carrying and moving and p.running then rate*=c.RunDrain end
    p.value=math.clamp(p.value+rate*dt,0,c.StaminaCapacity)
    return p.value
end
function M.eligible(self,id) return M.get(self,id).value>=self.config.ReceiveMinimum end
return M
