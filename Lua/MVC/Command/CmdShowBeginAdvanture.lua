local CmdShowBeginAdvanture = {} -- show MyView

function CmdShowBeginAdvanture.Excute()
    local homeController = MVCFacade.GetController('HomeController')
    homeController:ShowBeginAdvanturePanel()
end

return CmdShowBeginAdvanture