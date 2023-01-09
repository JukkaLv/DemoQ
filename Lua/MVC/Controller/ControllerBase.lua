local ControllerBase = {}
ControllerBase.__index = ControllerBase

function ControllerBase:InitBase()
    self.viewRequests = {}
    self.views = {}
end

function ControllerBase:LoadView(VIEW_NAME)
    local VIEW = require('MVC.View.'..VIEW_NAME)
    assert(VIEW ~= nil, VIEW_NAME.." not found.")

    local request = self.viewRequests[VIEW_NAME]
    if request == nil then
    --     request = AssetManager.Instance:LoadPrefab(VIEW.__PREFAB_ASSET)  -- todo replace AssetManager
    --     viewRequests[VIEW_NAME] = request
    end

    local view = self.views[VIEW_NAME]
    if view == nil then
        -- local viewGO = CS.UnityEngine.GameObject.Instantiate(request.asset) -- todo replace AssetManager
        local viewPath, _ = string.gsub(VIEW.__PREFAB_ASSET, "Assets/Demo/Resources/", "")
        viewPath, _ = string.gsub(viewPath, ".prefab", "")
        local viewPrefab = Resources.Load(viewPath)
        local viewGO = CS.UnityEngine.GameObject.Instantiate(viewPrefab)

        view = VIEW.Create(viewGO:GetComponent("LuaViewFacade"))
        viewGO:SetActive(false)
        self.views[VIEW_NAME] = view
    end
    return view
end

function ControllerBase:UnloadView(VIEW_NAME)
    local view = self.views[VIEW_NAME]
    if view ~= nil then
        view:Dispose()
    end
    self.views[VIEW_NAME] = nil

    local request = self.viewRequests[VIEW_NAME]
    if request ~= nil then
        if request ~= nil then 
            -- AssetManager.Instance:Unload(request)  -- todo replace AssetManager
        end
    end
    self.viewRequests[VIEW_NAME] = nil
end

function ControllerBase:UnloadAllViews()
    local loadedViewNames = {}
    for VIEW_NAME,_ in pairs(self.viewRequests) do
        table.insert(loadedViewNames, VIEW_NAME)
    end
    for _,VIEW_NAME in ipairs(loadedViewNames) do
        self:UnloadView(VIEW_NAME)
    end
end

function ControllerBase:GetView(VIEW_NAME)
    local view = self.views[VIEW_NAME]
    assert(view ~= nil, VIEW_NAME.." not loaded.")
    return view
end

return ControllerBase