local CmdShowBeginAdvanture = {}

local cfg = require 'config.Cfg'

function CmdShowBeginAdvanture.Excute()
    local controller = MVCFacade.GetController('BeginAdvantureController')

    local vm = {}
    vm.img_role_1 = { enabled = false }
    vm.img_role_2 = { enabled = false }
    vm.img_role_3 = { enabled = false }
    vm.img_role_4 = { enabled = false }

    vm.bottom = { items = {} }
    for id=102,107 do
        local actorTbl = cfg.GetData("TblActor", id)
        local vm_item = {}
        vm_item.txt_name = { text = actorTbl.name }
        vm_item.txt_hp = { text = "生命值:"..actorTbl.maxHP }
        vm_item.txt_spd = { text = "速度:"..actorTbl.speed }

        local skillTbl1 = cfg.GetData("TblSkill", actorTbl.skills[1])
        vm_item.txt_skill_1 = { text = skillTbl1.name }
        vm_item.btn_skill_1 = { OnClickNoti = { name = "SHOW_SKILL_TIP", body = { skillTbl1 } } }
        
        local skillTbl2 = cfg.GetData("TblSkill", actorTbl.skills[2])
        vm_item.txt_skill_2 = { text = skillTbl2.name }
        vm_item.btn_skill_2 = { OnClickNoti = { name = "SHOW_SKILL_TIP", body = { skillTbl2 } } }

        vm_item.btn_root = { OnClickNoti = { name = "CLICK_HERO_BOTTOM", body = { actorTbl } } }

        table.insert(vm.bottom.items, vm_item)
    end

    controller:ShowPanel(vm)
end

return CmdShowBeginAdvanture