local CmdInitHomeController = {}

function CmdInitHomeController.Excute()
    MVCFacade.RegisterController('HomeController')
end

return CmdInitHomeController