local CmdLeaveHome = {}

function CmdLeaveHome.Excute()
    MVCFacade.UnregisterController('AdvantureController')
end

return CmdLeaveHome