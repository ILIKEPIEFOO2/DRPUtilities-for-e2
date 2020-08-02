-- Author: ILIKEPIEFOO2
-- Heavily based upon: https://github.com/wiremod/wire/blob/master/lua/entities/gmod_wire_expression2/core/chat.lua

E2Lib.RegisterExtension("gravityGun", true, "Allows E2 chips to listen to gravity gun related triggers.")

local IsValid = IsValid

local GravPuntList = {
    last = { nil, nil, 0 }
}

local GravPickupList = {
    last = { nil, nil, 0 }
}

local GravDroppedList = {
    last = { nil, nil, 0 }
}

local GravPuntAlert = {}
local GravPickupAlert = {}
local GravDroppedAlert = {}

--[[************************************************************************]]--

registerCallback("destruct",function(self)
    GravPuntAlert[self.entity] = nil
    GravPickupAlert[self.entity] = nil
    GravDroppedAlert[self.entity] = nil
end)

hook.Add("GravGunPunt","Exp2GravPunt",function(ply,entity)
    local entry = { ply, entity, CurTime() }
    --GravPuntList[ply:EntIndex()] = entry
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
hook.Add("GravGunOnDropped","Exp2GravDropped",function(ply,entity)
    local entry = { ply, entity, CurTime() }
    --GravDroppedList[ply:EntIndex()] = entry
    GravDroppedList.last = entry
    for e in pairs(GravDroppedAlert) do
        if IsValid(e) then
            e.context.data.runByGravDrop = entry
            e:Execute()
            e.context.data.runByGravDrop = nil
        else
            GravDroppedAlert[e] = nil
         end
    end
end)
hook.Add("GravGunOnPickedUp","Exp2GravPickedup",function(ply,entity)
    local entry = { ply, entity, CurTime() }
    --GravPickupList[ply:EntIndex()] = entry
    GravPickupList.last = entry
    for e in pairs(GravPickupAlert) do
        if IsValid(e) then
            e.context.data.runByGravPickup = entry
            e:Execute()
            e.context.data.runByGravPickup = nil
        else
            GravPickupAlert[e] = nil
         end
    end
end)


--[[
hook.Add("EntityRemoved","Exp2GravPuntPlayerDisconnect", function(ply)
    GravPuntList[ply:EntIndex()] = nil
    GravPickupList[ply:EntIndex()] = nil
    GravDroppedList[ply:EntIndex()] = nil
end)
]]--

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

--- If <activate> == 0, the chip will no longer run on grav dropped events, otherwise it makes this chip execute when someone drops an entity.
e2function void runOnGravDrop(activate)
    if activate ~= 0 then
        GravDroppedAlert[self.entity] = true
    else
        GravDroppedAlert[self.entity] = nil
     end
end

--- If <activate> == 0, the chip will no longer run on grav pickup events, otherwise it makes this chip execute when someone picks up an entity.
e2function void runOnGravPickup(activate)
    if activate ~= 0 then
        GravPickupAlert[self.entity] = true
    else
        GravPickupAlert[self.entity] = nil
     end
end

--- Returns 1 if the chip is being executed because of a grav punt event. Return 0 otherwise.
e2function number gravPuntClk()
    return self.data.runByGravPunt and 1 or 0
end

--- Returns 1 if the chip is being executed because of a grav punt event caused by player <ply>. Returns 0 otherwise.
e2function number gravPuntClk(ply)
    if not IsValid(ply) then return 0 end
    local cause = self.data.runByGravPunt
    return cause and cause[1] == ply and 1 or 0
end

--- Returns 1 if the chip is being executed because of a grav punt event caused the entity <ent> to be punted. Returns 0 otherwise.
e2function number gravPuntedClk(ent)
    if not IsValid(ent) then return 0 end
    local cause = self.data.runByGravPunt
    return cause and cause[2] == ent and 1 or 0
end

--- Returns 1 if the chip is being executed because of a grav pickup event. Return 0 otherwise.
e2function number gravPickupClk()
    return self.data.runByGravPickup and 1 or 0
end

--- Returns 1 if the chip is being executed because of a grav pickup event caused by player <ply>. Returns 0 otherwise.
e2function number gravPickupClk(ply)
    if not IsValid(ply) then return 0 end
    local cause = self.data.runByGravPickup
    return cause and cause[1] == ply and 1 or 0
end

--- Returns 1 if the chip is being executed because of a grav dropped event. Return 0 otherwise.
e2function number gravDroppedClk()
    return self.data.runByGravDrop and 1 or 0
end

--- Returns 1 if the chip is being executed because of a grav dropped event caused by player <ply>. Returns 0 otherwise.
e2function number gravDroppedClk(ply)
    if not IsValid(ply) then return 0 end
    local cause = self.data.runByGravDrop
    return cause and cause[1] == ply and 1 or 0
end

--[[************************************************************************]]--

__e2setcost(3)

--- Returns the last player to have punted an entity.
e2function entity lastGravPunter()
    local entry = GravPuntList.last
    if not entry then return nil end
    
    local ply = entry[1]
    if not IsValid(ply) then return nil end
    if not ply:IsPlayer() then return nil end
    
    return ply
end

--- Returns the last entity to have been punted.
e2function entity lastGravPunted()
    local entry = GravPuntList.last
    if not entry then return nil end
    
    local ent = entry[2]
    if not IsValid(ent) then return nil end
    
    return ent
end

--- Returns the time the last entity was punted.
e2function number lastGravPuntWhen()
    local entry = GravPuntList.last
    if not entry then return 0 end

    return entry[3]
end


--- Returns the last player to have picked up an entity.
e2function entity lastGravPickup()
    local entry = GravPickupList.last
    if not entry then return nil end
    
    local ply = entry[1]
    if not IsValid(ply) then return nil end
    if not ply:IsPlayer() then return nil end
    
    return ply
end

--- Returns the last entity to have been picked up.
e2function entity lastGravPickedup()
    local entry = GravPickupList.last
    if not entry then return nil end
    
    local ent = entry[2]
    if not IsValid(ent) then return nil end
    
    return ent
end

--- Returns the time the last entity was picked up.
e2function number lastGravPickedupWhen()
    local entry = GravPickupList.last
    if not entry then return 0 end

    return entry[3]
end


--- Returns the last player to have picked up an entity.
e2function entity lastGravDrop()
    local entry = GravDroppedList.last
    if not entry then return nil end
    
    local ply = entry[1]
    if not IsValid(ply) then return nil end
    if not ply:IsPlayer() then return nil end
    
    return ply
end

--- Returns the last entity to have been picked up.
e2function entity lastGravDropped()
    local entry = GravDroppedList.last
    if not entry then return nil end
    
    local ent = entry[2]
    if not IsValid(ent) then return nil end
    
    return ent
end

--- Returns the time the last entity was picked up.
e2function number lastGravDroppedWhen()
    local entry = GravDroppedList.last
    if not entry then return 0 end

    return entry[3]
end
