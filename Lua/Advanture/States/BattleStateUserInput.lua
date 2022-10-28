_ENV = _G._ENV_ADVANTURE

local Notifier = require 'Framework.Notifier'

-- 角色等待玩家输入指令
local BattleStateUserInput = {}
local FSMachine = require 'Framework.FSMachine'
BattleStateUserInput.__index = BattleStateUserInput
setmetatable(BattleStateUserInput, FSMachine.State)

function BattleStateUserInput.Create()
    local copy = {}
    setmetatable(copy, BattleStateUserInput)
    copy:Init()
    return copy
end

function BattleStateUserInput:OnEnter(actor)
    assert(actor ~= nil, "Error! BattleStateUserInput.OnEnter -> actor is nil.")
    self.actor = actor
    self.skill = nil
    Notifier.AddListener("_Battle_UI_Click_Skip", self.OnSkipClicked, self)
    Notifier.AddListener("_Battle_UI_Click_Confirm", self.OnConfirmClicked, self)
    Notifier.AddListener("_Battle_UI_Click_Cancel", self.OnCancelClicked, self)
    Notifier.AddListener("_Battle_UI_Click_Skill", self.OnSkillClicked, self)
    Notifier.AddListener("_Advanture_Click_Actor", self.OnTargetClicked, self)  -- 架起角色点击监听
    Notifier.Dispatch("_Battle_Actor_Input", self.actor)
end

function BattleStateUserInput:OnExit()
    Notifier.Dispatch("_Battle_Actor_Input_Done")
    Notifier.RemoveListener("_Advanture_Click_Actor", self.OnTargetClicked, self)  -- 移除角色点击监听
    Notifier.RemoveListener("_Battle_UI_Click_Skip", self.OnSkipClicked, self)
    Notifier.RemoveListener("_Battle_UI_Click_Confirm", self.OnConfirmClicked, self)
    Notifier.RemoveListener("_Battle_UI_Click_Cancel", self.OnCancelClicked, self)
    Notifier.RemoveListener("_Battle_UI_Click_Skill", self.OnSkillClicked, self)
    self:ReleaseAllEffects()
    self.actor = nil
    self.skill = nil
    self.plan = nil
    self.finalTargets = nil
end

function BattleStateUserInput:ReleaseAllEffects()
    if self.shades ~= nil then
        for _,shade in ipairs(self.shades) do
            shade:Dispose()
        end
    end
    self.shades = nil
    if self.lines ~= nil then
        for _,line in ipairs(self.lines) do
            GameObject.Destroy(line)
        end
    end
    self.lines = nil
    if self.marks ~= nil then
        for _,mark in ipairs(self.marks) do
            GameObject.Destroy(mark)
        end
    end
    self.marks = nil
end

-- UI点击跳过回合
function BattleStateUserInput:OnSkipClicked()
    battleInst.fsm:Switch("EXITACTOR", self.actor) -- 跳过DOACTOR阶段，直接EXITACTOR
end

-- UI点击技能后，判断逻辑是否可选，确认后在发送消息
function BattleStateUserInput:OnSkillClicked(skillIdx)
    local skill = self.actor.skills[skillIdx]
    if skill.cd > 0 then return end  -- 技能CD未好
    if skill == self.skill then return end  -- 已选择该技能

    self.skill = skill
    self.skillIdx = skillIdx

    self.allPlans = GetAllPlansForCastSkill(self.actor, self.skill)  -- 获取该技能施放计划书和目标查找表
    Notifier.Dispatch("_Battle_Skill_Selected", skillIdx) -- 通知UI高亮技能选中效果

    -- 先释放掉之前选中技能的虚影和线
    self:ReleaseAllEffects()
    -- 根据计划书画虚影和目标线
    self.shades = {}
    self.lines = {}
    for _,plan in ipairs(self.allPlans) do
        local casterPosition = nil
        if plan.needMove then  -- 需要移动的计划创建虚影
            local shade = self.actor:CreateShade(0.75, plan.standCoords[1])
            shade:SetPosition(BattleCoord2WorldPos(plan.standCoords[1], self.actor.context.cfgTbl.size))
            table.insert(self.shades, shade)
            casterPosition = shade.transform.position + Vector3(0, 2, 0)
        else 
            casterPosition = self.actor.position + Vector3(0, 2, 0)
        end
        -- 目标连线和脚底标记
        for _,target in ipairs(plan.targets) do
            local targetPosition = target.position + Vector3(0, 2, 0)
            local lineRes = target.context.camp == self.actor.context.camp and "ef_greenline" or "ef_redline"
            local line = DrawBezierCurve(lineRes, casterPosition, targetPosition)
            table.insert(self.lines, line)
        end
    end
end

-- 判断逻辑是否可选，确认后在发送消息
function BattleStateUserInput:OnTargetClicked(target)
    if self.skill == nil then return end  -- 还未选择技能

    self.plan = nil
     -- 找包含目标的计划，优先前面的计划
    for _,loopPlan in ipairs(self.allPlans) do
        for _,loopTarget in ipairs(loopPlan.targets) do
            if target == loopTarget then
                self.plan = loopPlan
                break
            end
        end
    end
    if self.plan == nil then return end  -- 点击的目标不在任何计划中

    Notifier.Dispatch("_Battle_Target_Selected", skillIdx) -- 通知UI显示确认/取消按钮

    self:ReleaseAllEffects()
    self.shades = {}
    self.lines = {}
    self.marks = {}

    local casterPosition = nil
    if self.plan.needMove then  -- 需要移动的计划创建虚影
        local shade = self.actor:CreateShade(0.75, self.plan.standCoords[1])
        shade:SetPosition(BattleCoord2WorldPos(self.plan.standCoords[1], self.actor.context.cfgTbl.size))
        table.insert(self.shades, shade)
        casterPosition = shade.transform.position + Vector3(0, 2, 0)
    else 
        casterPosition = self.actor.position + Vector3(0, 2, 0)
    end
    -- 目标连线和脚底标记
    local targetPosition = target.position + Vector3(0, 2, 0)
    local lineRes = target.context.camp == self.actor.context.camp and "ef_greenline" or "ef_redline"
    local line = DrawBezierCurve(lineRes, casterPosition, targetPosition)
    table.insert(self.lines, line)

    self.finalTargets = nil
    if self.skill.cfgTbl.isAOE then
        self.finalTargets = self.plan.targets
    else
        self.finalTargets = FindSkillAffectTargets(target, self.skill)
    end
    for _,finalTarget in ipairs(self.finalTargets) do
        local mark = DrawTargetMark(finalTarget, self.skill.cfgTbl.campFilter == 2 and Color.red or Color.green)
        table.insert(self.marks, mark)
    end
end

function BattleStateUserInput:OnConfirmClicked()
    self.skill.cd = self.skill.cfgTbl.intervalCD+1 -- 设置技能cd
    local newCoord = self.plan.needMove and self.plan.standCoords[1] or nil -- 技能移动只传最左边的坐标
    battleInst.fsm:Switch("DOACTOR", self.actor, self.skill, self.finalTargets, newCoord)  -- 带着计划书进入行动环节
end

function BattleStateUserInput:OnCancelClicked()
    Notifier.Dispatch("_Battle_Skill_Selected", self.skillIdx) -- 通知UI高亮技能选中效果
    -- 先释放掉之前选中技能的虚影和线
    self:ReleaseAllEffects()
    -- 根据计划书画虚影和目标线
    self.shades = {}
    self.lines = {}
    for _,plan in ipairs(self.allPlans) do
        local casterPosition = nil
        if plan.needMove then  -- 需要移动的计划创建虚影
            local shade = self.actor:CreateShade(0.75, plan.standCoords[1])
            shade:SetPosition(BattleCoord2WorldPos(plan.standCoords[1], self.actor.context.cfgTbl.size))
            table.insert(self.shades, shade)
            casterPosition = shade.transform.position + Vector3(0, 2, 0)
        else 
            casterPosition = self.actor.position + Vector3(0, 2, 0)
        end
        -- 目标连线和脚底标记
        for _,target in ipairs(plan.targets) do
            local targetPosition = target.position + Vector3(0, 2, 0)
            local lineRes = target.context.camp == self.actor.context.camp and "ef_greenline" or "ef_redline"
            local line = DrawBezierCurve(lineRes, casterPosition, targetPosition)
            table.insert(self.lines, line)
        end
    end
end

return BattleStateUserInput