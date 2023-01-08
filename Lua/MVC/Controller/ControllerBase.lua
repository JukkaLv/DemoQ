local ControllerBase = {}
ControllerBase.__index = ControllerBase

local viewRequests = {}
local views = {}
function ControllerBase.LoadView(VIEW_NAME)
    local VIEW = require('MVC.View.'..VIEW_NAME)
    assert(VIEW ~= nil, VIEW_NAME.." not found.")
    local request = viewRequests[VIEW_NAME]
    if request == nil then
        request = CS.Framework.Asset.AssetManager.Instance:LoadPrefab(VIEW.__PREFAB_ASSET)
        viewRequests[VIEW_NAME] = request
    end

    local view = views[VIEW_NAME]
    if view == nil then
        local viewGO = CS.UnityEngine.GameObject.Instantiate(request.asset)
        view = VIEW.Create(viewGO:GetComponent("LuaViewFacade"))
        viewGO:SetActive(false)
        views[VIEW_NAME] = view
    end
    return view
end

function ControllerBase.UnloadView(VIEW_NAME)
    local view = views[VIEW_NAME]
    if view ~= nil then
        view:Dispose()
    end
    views[VIEW_NAME] = nil

    local request = viewRequests[VIEW_NAME]
    if request ~= nil then
        if request ~= nil then 
            CS.Framework.Asset.AssetManager.Instance:Unload(request)
        end
    end
    viewRequests[VIEW_NAME] = nil
end

function ControllerBase.GetView(VIEW_NAME)
    local view = views[VIEW_NAME]
    assert(view ~= nil, VIEW_NAME.." not loaded.")
    return view
end

return ControllerBase