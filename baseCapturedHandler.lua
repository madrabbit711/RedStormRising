require("mist_4_3_74")
local bases = require("bases")
local utils = require("utils")
local state = require("state")
local rsrConfig = require("RSR_config")
local baseOwnershipCheck = require("baseOwnershipCheck")

local M = {}

local log = mist.Logger:new("BaseCapturedHandler", "info")

function M.register()
    M.eventHandler = EVENTHANDLER:New():HandleEvent(EVENTS.BaseCaptured)
    function M.eventHandler:OnEventBaseCaptured(event)
        self:I({ event = event })
        local baseName = event.PlaceName
        local sideName = utils.getSideName(event.IniCoalition) --capturing side
        log:info("DCS baseCapturedHandler = $1 captured by $2", baseName, sideName)
		
		--QUICK INITIAL CHECK: determines if base owner according to DCS differs from that according to RSR
		--mr: just because DCS EH = base owner changed doesn't mean base change accoriding to RSR!
        local changedSide = state.checkBaseOwner(baseName, sideName) 
        if changedSide == false then
            log:info("Ignoring capture event for $1: no change of side ($2)", baseName, sideName)
            return
        end
		
		--[[
		-- mist.getUnitsInZones(unit_names, zone_names, zone_type) --need list of 'unit_names' first...
		-- ZONE_BASE:New(_triggerZone) --MOOSE: Adds zone to MOOSE system?
		-- ZONE_BASE.IsPointVec2InZone(_aircraft) -- MOOSE: Returns if a 2D point vector is within the zone
		--]]
		-- enumerate units within RSRbaseCaptureZones in-line with RSR radiuses
		
		--[[
        local message = baseName .. " has been captured by a " .. sideName .. " " .. event.IniTypeName
        self:I(message)
        trigger.action.outText(message, 10)
		--]]
		--MORE INTENSIVE CHECK: as DCS base owner has changed, recheck status of all logistics centres to determine true RSR base owner
		--baseOwnershipCheck.lua = all base side setting and capture messages
		
	
		baseOwnershipCheck.baseOwnership = baseOwnershipCheck.getAllBaseOwnership(false,"none","none")
		--baseOwnershipCheck.baseOwnership = baseOwnershipCheck.getAllBaseOwnership(false,baseName,"none")
		-- inefficient to check ALL bases given base known?  Should just pass base and update baseOwnershipCheck.lua for specific change

		--migrated to baseOwnershipCheck.lua
        --bases.configureForSide(baseName, sideName)
        --bases.resupply(baseName, sideName, rsrConfig)

    end
end

return M