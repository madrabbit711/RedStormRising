local writeInterval = 10

if stateFileExists() then
    log:info("State file exists - will set up from saved state")
    readState()
    spawnFromState()
    ctld.nextGroupId = rsrState.ctld.nextGroupId
    ctld.nextUnitId = rsrState.ctld.nextUnitId
else
    log:info("No state file exists - setting up from scratch")
end

mist.scheduleFunction(writeState, {true}, timer.getTime() + writeInterval, writeInterval)
