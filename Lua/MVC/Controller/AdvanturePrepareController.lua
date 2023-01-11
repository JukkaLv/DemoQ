local AdvanturePrepareController = {}
AdvanturePrepareController.__index = AdvanturePrepareController
local ControllerBase = require 'MVC.Controller.ControllerBase'
setmetatable(AdvanturePrepareController, ControllerBase)

local Notifier = require 'Framework.Notifier'

function AdvanturePrepareController.Create()
    local copy = {}
    setmetatable(copy, AdvanturePrepareController)
    copy:InitBase()
    copy:Init()
    return copy
end

function AdvanturePrepareController:Init()
    self.choosedHeros = {0, 0, 0, 0}
    self.panelView = self:LoadView("AdvanturePrepareView")
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
    Notifier.AddListener("SHOW_ADVANTURE_PREPARE_VIEW", self.ShowPanel, self)
end

function AdvanturePrepareController:Dispose()
    Notifier.RemoveListener("SHOW_SKILL_TIP", self.OnShowSkillTip, self)
    Notifier.RemoveListener("CHOOSE_HERO", self.OnChooseHero, self)
    Notifier.RemoveListener("SHOW_ADVANTURE_PREPARE_VIEW", self.ShowPanel, self)

    self:UnloadAllViews()

    self.panelView:Close()
    self.slotSkillTipView:Close()
    self.skillTipView:Close()

    self.choosedHeros = nil
    self.panelVM = nil
    self.panelView = nil
    self.slotSkillTipView = nil
    self.skillTipView = nil
end

function AdvanturePrepareController:ShowPanel()
    local vm = {}
    vm.img_role_1 = { enabled = false }
    vm.img_role_2 = { enabled = false }
    vm.img_role_3 = { enabled = false }
    vm.img_role_4 = { enabled = false }
    vm.btn_go = { interactable = false }

    vm.bottom = { items = {} }
    for id=102,107 do
        local actorTbl = Cfg.GetData("TblActor", id)
        local vm_item = {}
        vm_item.actorTblId = id
        vm_item.txt_name = { text = actorTbl.name }
        vm_item.txt_hp = { text = "生命值:"..actorTbl.maxHP }
        vm_item.txt_spd = { text = "速度:"..actorTbl.speed }
        vm_item.img_element = { sprite = ViewUtils.GetElementSprite(actorTbl.element) }

        local skillTbl1 = Cfg.GetData("TblSkill", actorTbl.skills[1])
        vm_item.txt_skill_1 = { text = skillTbl1.name }
        vm_item.btn_skill_1 = { OnClickNoti = { name = "SHOW_SKILL_TIP", body = { skillTbl1 } } }
        
        local skillTbl2 = Cfg.GetData("TblSkill", actorTbl.skills[2])
        vm_item.txt_skill_2 = { text = skillTbl2.name }
        vm_item.btn_skill_2 = { OnClickNoti = { name = "SHOW_SKILL_TIP", body = { skillTbl2 } } }

        vm_item.btn_root = { OnClickNoti = { name = "CHOOSE_HERO", body = { actorTbl, #vm.bottom.items + 1 } } }
        vm_item.img_check = { enabled = false }

        table.insert(vm.bottom.items, vm_item)
    end

    self.panelVM = vm
    self.panelView:Open(vm)
end

function AdvanturePrepareController:OnBtnGo()
    table.insert(self.choosedHeros, 1, 101) -- 塞入master
    
    -- todo Move to Game FSM
    MVCFacade.ExcuteCommand('CmdGotoAdvanture', self.choosedHeros)
end

function AdvanturePrepareController:OnShowSkillTip(notiData)
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

function AdvanturePrepareController:OnShowSlotSkills()
    local masterTbl = Cfg.GetData("TblActor", 101)
    local vm = {}
    vm.content = { items = {} }
    for _,skillId in ipairs(masterTbl.skills) do
        local skillTbl = Cfg.GetData("TblSkill", skillId)
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

function AdvanturePrepareController:OnChooseHero(notiData)
    local actorTbl = notiData[1]
    local listIdx = notiData[2]
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
        vm.bottom = { items = CommonUtils.CreateArray(#self.panelVM.bottom.items, 0) }
        vm.bottom.items[listIdx] = { img_check = { enabled = true } }
        self.panelView:Render(vm)
    end
end

function AdvanturePrepareController:OnRemoveHero(pos)
    local actorTblId = self.choosedHeros[pos]
    if actorTblId > 0 then
        self.choosedHeros[pos] = 0

        local vm = {}
        vm["img_role_"..pos] = { enabled = false }
        vm["label_"..pos] = { text = "未上阵" }
        vm.btn_go = { interactable = false }
        vm.bottom = { items = CommonUtils.CreateArray(#self.panelVM.bottom.items, 0) }
        local listIdx = CommonUtils.IndexOf(self.panelVM.bottom.items, function(item_vm) return item_vm.actorTblId == actorTblId end)[1]
        vm.bottom.items[listIdx] = { img_check = { enabled = false } }
        self.panelView:Render(vm)
    end
end

return AdvanturePrepareController