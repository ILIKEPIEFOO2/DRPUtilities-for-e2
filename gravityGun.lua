-- Author: ILIKEPIEFOO2
-- Heavily based upon: https://github.com/wiremod/wire/blob/master/lua/entities/gmod_wire_expression2/core/chat.lua

local IsValid = IsValid

local GravPuntList = {
    last = { nil, 0, 0, 0 }
}

local GravPuntAlert = {}

--[[************************************************************************]]--

registerCallback("destruct",function(self)
    GravPuntAlert[self.entity] = nil
end)

hook.Add("playerWalletChanged","Exp2GravPunt",function(ply,entity)
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
