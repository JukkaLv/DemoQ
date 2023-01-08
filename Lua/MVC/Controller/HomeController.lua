local HomeController = {}
HomeController.__index = HomeController
local ControllerBase = require 'MVC.Controller.ControllerBase'
setmetatable(HomeController, ControllerBase)

local Notifier = require 'Framework.Notifier'

function HomeController.Create()
    local copy = {}
    setmetatable(copy, HomeController)
    copy:Init()
    return copy
end

function HomeController:Init()
    self:InitBeginAdvanturePanel()
end

function HomeController:InitBeginAdvanturePanel()
    HomeController.LoadView("BeginAdvanturePanelView")
    HomeController.LoadView("SelectCharacterItemView")

    local view = HomeController.GetView("BeginAdvanturePanelView")
    view.btn_go_OnClick = function() self:OnBtnGoAdvanture() end
end

function HomeController:Dispose()
    HomeController.UnloadView("BeginAdvanturePanelView")
    HomeController.UnloadView("SelectCharacterItemView")
end

function HomeController:ShowBeginAdvanturePanel()
    local vm = {}
    -- vm.view_xxx = {}
    -- vm.view_xxx.tmptxt_xxx = {text = "HAHAHAHAHAHAHAHA!!!!"}
    -- vm.view_xxx.btn_xxx = {interactable = true}
    HomeController.GetView("BeginAdvanturePanelView"):Open(vm)
end

function HomeController:OnBtnGoAdvanture()
    self.myView:Close()
end

return HomeController