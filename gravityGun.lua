-- Author: ILIKEPIEFOO2
-- Heavily based upon: https://github.com/wiremod/wire/blob/master/lua/entities/gmod_wire_expression2/core/chat.lua

E2Lib.RegisterExtension("gravityGun", true, "Allows E2 chips to listen to gravity gun related triggers.")

local IsValid = IsValid

local GravPuntList = {
    last = { nil, nil, 0 }
}

local GravPuntAlert = {}

--[[************************************************************************]]--

registerCallback("destruct",function(self)
    GravPuntAlert[self.entity] = nil
end)

hook.Add("GravGunPunt","Exp2GravPunt",function(ply,entity)
    local entry = { ply, entity, CurTime() }
    GravPuntList[ply:EntIndex()] = entry
    GravPuntList.last = entry
    for e in pairs(GravPuntAlert) do
        if IsValid(e) then
            e.context.data.runByGravPunt = entry
            e:Execute()
            e.context.data.runByGravPunt = nil
        else
            GravPuntAlert[e] = nil
         end
    end
end)
         



hook.Add("EntityRemoved","Exp2GravPuntPlayerDisconnect", function(ply)
    GravPuntList[ply:EntIndex()] = nil
end)

--[[************************************************************************]]--

__e2setcost(1)

--- If <activate> == 0, the chip will no longer run on grav punt events, otherwise it makes this chip execute when someone punts an entity.
e2function void runOnGravPunt(activate)
    if activate ~= 0 then
        GravPuntAlert[self.entity] = true
    else
        GravPuntAlert[self.entity] = nil
     end
end

--- Returns 1 if the chip is being executed because of a grav punt event. Return 0 otherwise.
e2function number gravPuntClk()
    return self.data.runByGravPunt and 1 or 0
end

--- Returns 1 if the chip is being executed because of a grab punt event caused by player <ply>. Returns 0 otherwise.
e2function number gravPuntClk(ply)
    if not IsValid(ply) then return 0 end
    local cause = self.data.runByGravPunt
    return cause and cause[1] == ply and 1 or 0
end

--- Returns 1 if the chip is being executed because of a grab punt event caused the entity <ent> to be punted. Returns 0 otherwise.
e2function number gravPuntedClk(ent)
    if not IsValid(ent) then return 0 end
    local cause = self.data.runByGravPunt
    return cause and cause[2] == ent and 1 or 0
end

--[[************************************************************************]]--
