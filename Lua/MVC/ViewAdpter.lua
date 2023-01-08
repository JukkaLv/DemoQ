local ViewAdpter = {}

local Notifier = require 'Framework.Notifier'

function ViewAdpter.Initialize()
    Notifier.AddListener("__OPEN_VIEW_BEFORE", ViewAdpter.OnOpenViewBefore)
    Notifier.AddListener("__CLOSE_VIEW_AFTER", ViewAdpter.OnCloseViewAfter)
end

function ViewAdpter.OnOpenViewBefore(view)
    view.transform:SetParent(MVCFacade.VIEW_CANVAS_2D, false)
end

function ViewAdpter.OnCloseViewAfter(view)
end

return ViewAdpter