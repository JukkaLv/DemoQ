local BeginAdvantureController = {}
BeginAdvantureController.__index = BeginAdvantureController
local ControllerBase = require 'MVC.Controller.ControllerBase'
setmetatable(BeginAdvantureController, ControllerBase)

local Notifier = require 'Framework.Notifier'
local cfg = require 'config.Cfg'

function BeginAdvantureController.Create()
    local copy = {}
    setmetatable(copy, BeginAdvantureController)
    copy:InitBase()
    copy:Init()
    return copy
end

function BeginAdvantureController:Init()
    self.panelView = self:LoadView("BeginAdvanturePanelView")
    self.slotSkillTipView = self:LoadView("SlotSkillTipView")
    self.skillTipView = self:LoadView("SkillTipView")
    local itemView = self:LoadView("SelectHeroItemView")
    local slotSkillTipItemView = self:LoadView("SlotSkillTipItemView")
    local elementView = self:LoadView("ElementView")

    self.panelView.bottom_ItemTemplate = itemView
    self.panelView.btn_go_OnClick = function() self:OnBtnGo() end
    self.panelView.btn_pos1_OnClick = function() self:OnRemoveHero(1) end
    self.panelView.btn_pos2_OnClick = function() self:OnRemoveHero(2) end
    self.panelView.btn_pos3_OnClick = function() self:OnRemoveHero(3) end
    self.panelView.btn_pos4_OnClick = function() self:OnRemoveHero(4) end
    self.panelView.btn_slotSkills_OnClick = function() self:OnShowSlotSkills() end

    self.slotSkillTipView.btn_bg_OnClick = function() self.slotSkillTipView:Close() end
    self.slotSkillTipView.content_ItemTemplate = slotSkillTipItemView
    slotSkillTipItemView.elements_ItemTemplate = elementView

    self.skillTipView.btn_bg_OnClick = function() self.skillTipView:Close() end
    self.skillTipView.elements_ItemTemplate = elementView

    Notifier.AddListener("SHOW_SKILL_TIP", self.OnShowSkillTip, self)
    Notifier.AddListener("CHOOSE_HERO", self.OnChooseHero, self)

    self.choosedHeros = {0, 0, 0, 0}
end

function BeginAdvantureController:Dispose()
    Notifier.RemoveListener("SHOW_SKILL_TIP", self.OnShowSkillTip, self)
    Notifier.RemoveListener("CHOOSE_HERO", self.OnChooseHero, self)

    self:UnloadAllViews()

    self.panelView = nil
    self.slotSkillTipView = nil
end

function BeginAdvantureController:ShowPanel(vm)
    self.panelView:Open(vm)
end

function BeginAdvantureController:OnBtnGo()
    self.panelView:Close()
end

function BeginAdvantureController:OnShowSkillTip(notiData)
    local skillTbl = notiData[1]
    local vm = {}
    vm.txt_name = { text = skillTbl.name }
    vm.txt_cd = { text = '冷却:'..skillTbl.intervalCD..'回合' }
    vm.txt_desc = { text = skillTbl.desc }
    vm.txt_element = { text = '产生元素:' }
    vm.elements = { items = {} }
    for _,element in ipairs(skillTbl.elements) do
        table.insert(vm.elements.items, { img_icon = { sprite = ViewUtils.GetElementSprite(element) } })
    end
    self.skillTipView:Open(vm)
    self.skillTipView.trans_content.anchoredPosition = Vector2(Input.mousePosition.x, Input.mousePosition.y)
end

function BeginAdvantureController:OnShowSlotSkills()
    local masterTbl = cfg.GetData("TblActor", 101)
    local vm = {}
    vm.content = { items = {} }
    for _,skillId in ipairs(masterTbl.skills) do
        local skillTbl = cfg.GetData("TblSkill", skillId)
        local item_vm = {}
        item_vm.txt_desc = { text = skillTbl.desc }
        item_vm.elements = { items = {} }
        for _,element in ipairs(skillTbl.elements) do
            table.insert(item_vm.elements.items, { img_icon = { sprite = ViewUtils.GetElementSprite(element) } })
        end
        table.insert(vm.content.items, item_vm)
    end
    self.slotSkillTipView:Open(vm)
end

function BeginAdvantureController:OnChooseHero(notiData)
    local actorTbl = notiData[1]
    local exist = false
    local firstEmptyIdx = 0
    for i,choosedActorId in ipairs(self.choosedHeros) do
        if choosedActorId == actorTbl.id then exist = true end
        if firstEmptyIdx == 0 and choosedActorId == 0 then firstEmptyIdx = i end
    end
    if not exist and firstEmptyIdx > 0 then
        self.choosedHeros[firstEmptyIdx] = actorTbl.id

        local vm = {}
        vm["img_role_"..firstEmptyIdx] = { enabled = true, sprite = ViewUtils.GetActorSprite(actorTbl.id) }
        vm["label_"..firstEmptyIdx] = { text = actorTbl.name }

        local ready = true
        for i,choosedActorId in ipairs(self.choosedHeros) do
            if choosedActorId == 0 then ready = false; break end
        end
        vm.btn_go = { interactable = ready }

        self.panelView:Render(vm)
    end
end

function BeginAdvantureController:OnRemoveHero(idx)
    if self.choosedHeros[idx] > 0 then
        self.choosedHeros[idx] = 0
        
        local vm = {}
        vm["img_role_"..idx] = { enabled = false }
        vm["label_"..idx] = { text = "未上阵" }
        vm.btn_go = { interactable = false }
        self.panelView:Render(vm)
    end
end

return BeginAdvantureController