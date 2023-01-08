local BeginAdvantureController = {}
BeginAdvantureController.__index = BeginAdvantureController
local ControllerBase = require 'MVC.Controller.ControllerBase'
setmetatable(BeginAdvantureController, ControllerBase)

local Notifier = require 'Framework.Notifier'

function BeginAdvantureController.Create()
    local copy = {}
    setmetatable(copy, BeginAdvantureController)
    copy:Init()
    return copy
end

function BeginAdvantureController:Init()
    self.panelView = BeginAdvantureController.LoadView("BeginAdvanturePanelView")
    self.itemView = BeginAdvantureController.LoadView("SelectHeroItemView")

    self.panelView.bottom_ItemTemplate = self.itemView
    self.panelView.btn_go_OnClick = function() self:OnBtnGo() end

    Notifier.AddListener("SHOW_SKILL_TIP", self.OnShowSkillTip, self)
    Notifier.AddListener("CLICK_HERO_BOTTOM", self.OnClickHeroBottom, self)
end

function BeginAdvantureController:Dispose()
    Notifier.RemoveListener("SHOW_SKILL_TIP", self.OnShowSkillTip, self)
    Notifier.RemoveListener("CLICK_HERO_BOTTOM", self.OnClickHeroBottom, self)

    BeginAdvantureController.UnloadView("BeginAdvanturePanelView")
    BeginAdvantureController.UnloadView("SelectHeroItemView")
    self.panelView = nil
    self.itemView = nil
end

function BeginAdvantureController:ShowPanel(vm)
    self.panelVM = vm
    self.panelView:Open(vm)
end

function BeginAdvantureController:OnBtnGo()
    self.panelView:Close()
end

function BeginAdvantureController:OnShowSkillTip(noti)
    print("BINGO! "..noti[1].name)
end

function BeginAdvantureController:OnClickHeroBottom(noti)
    print("CHOOSE! "..noti[1].name)
end

return BeginAdvantureController