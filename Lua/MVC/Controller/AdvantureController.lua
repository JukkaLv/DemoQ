local AdvantureController = {}
AdvantureController.__index = AdvantureController
local ControllerBase = require 'MVC.Controller.ControllerBase'
setmetatable(AdvantureController, ControllerBase)

local Notifier = require 'Framework.Notifier'

function AdvantureController.Create()
    local copy = {}
    setmetatable(copy, AdvantureController)
    copy:InitBase()
    copy:Init()
    return copy
end

function AdvantureController:Init()
    self.context = nil
    self.restSupply = 0
    self.panelView = self:LoadView("AdvantureView")

    self.panelView.list_attrs_ItemTemplate = self.panelView.itemview_attr
    self.panelView.btn_march_OnClick = function() self:OnBtnMarch() end

    -- self.choosedHeros = {0, 0, 0, 0}
    -- self.slotSkillTipView = self:LoadView("SlotSkillTipView")
    -- self.skillTipView = self:LoadView("SkillTipView")

    -- local itemView = self:LoadView("SelectHeroItemView")
    -- local slotSkillTipItemView = self:LoadView("SlotSkillTipItemView")
    -- local elementView = self:LoadView("ElementView")

    -- self.panelView.bottom_ItemTemplate = itemView
    -- self.panelView.btn_go_OnClick = function() self:OnBtnGo() end
    -- self.panelView.btn_pos1_OnClick = function() self:OnRemoveHero(1) end
    -- self.panelView.btn_pos2_OnClick = function() self:OnRemoveHero(2) end
    -- self.panelView.btn_pos3_OnClick = function() self:OnRemoveHero(3) end
    -- self.panelView.btn_pos4_OnClick = function() self:OnRemoveHero(4) end
    -- self.panelView.btn_slotSkills_OnClick = function() self:OnShowSlotSkills() end

    -- self.slotSkillTipView.btn_bg_OnClick = function() self.slotSkillTipView:Close() end
    -- self.slotSkillTipView.content_ItemTemplate = slotSkillTipItemView
    -- slotSkillTipItemView.elements_ItemTemplate = elementView

    -- self.skillTipView.btn_bg_OnClick = function() self.skillTipView:Close() end
    -- self.skillTipView.elements_ItemTemplate = elementView

    Notifier.AddListener("SHOW_ADVANTURE_VIEW", self.ShowPanel, self)
end

function AdvantureController:Dispose()
    Notifier.RemoveListener("SHOW_ADVANTURE_VIEW", self.ShowPanel, self)

    self:UnloadAllViews()

    self.panelView:Close()

    self.context = nil
    self.restSupply = nil
    self.panelView = nil
end

function AdvantureController:ShowPanel()
    local vm = {}
    local masterAttrNames = { "勇气", "机敏", "学识", "精神", "运气" }
    vm.list_attrs = { items = {} }
    for i=1,5 do
        table.insert(vm.list_attrs.items, { txt_content = { text = masterAttrNames[i].."："..self.context.masterAttrs[i] } })
    end
    self.panelView:Open(vm)
end

return AdvantureController