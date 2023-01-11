_ENV = _G._ENV_ADVANTURE

-- 探险中重整队伍，准备行进
local AdvantureStateLineUp = {}
local FSMachine = require 'Framework.FSMachine'
AdvantureStateLineUp.__index = AdvantureStateLineUp
setmetatable(AdvantureStateLineUp, FSMachine.State)

function AdvantureStateLineUp.Create()
    local copy = {}
    setmetatable(copy, AdvantureStateLineUp)
    copy:Init()
    return copy
end

function AdvantureStateLineUp:OnEnter()
    -- 先跑回队列， 以当前相机焦点为领队位置
    local leadPos = virtualCameraTarget.position
    virtualCameraTarget.position = leadPos
    for i,actor in ipairs(advantureInst.actors) do
        local linePos = Vector3(leadPos.x - ((i-1) * 1.5), ACTOR_GROUND_Y, 0)
        actor.fsm:Switch("RUN", linePos, 1)
    end
end

function AdvantureStateLineUp:OnUpdate()
    if CommonUtils.TestEverybodyInList(advantureInst.actors, self.CheckActorState, self, 1) then
        if advantureInst:GetCurrWave().context.rand then
            Notifier.Dispatch("SHOW_ADVANTURE_VIEW")
        else
            advantureInst.fsm:Switch("WALK")
        end
    end
end

function AdvantureStateLineUp:CheckActorState(actor)
    return actor.fsm.currStateName == "IDLE"
end

return AdvantureStateLineUp