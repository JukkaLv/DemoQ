local CmdLeaveHome = {}

function CmdLeaveHome.Excute()
    MVCFacade.UnregisterController('AdvanturePrepareController')
end

return CmdLeaveHome