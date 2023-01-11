local CmdEnterAdvanture = {}

function CmdEnterAdvanture.Excute(context)
    local advantureCtrler = MVCFacade.RegisterController('AdvantureController')
    advantureCtrler.context = context
    advantureCtrler.restSupply = context.supply

    Game.advanture = require('Advanture.Advanture').Create(context)
end

return CmdEnterAdvanture