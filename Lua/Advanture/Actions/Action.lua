_ENV = _G._ENV_ADVANTURE

local Action = {}
Action.__index = Action

function Action.Create(actionName, caster, skill, targets, ...)
    local ACTION = require('Advanture.Actions.'..actionName)
    assert(ACTION ~= nil, 'Error! action not exists: '..actionName)
    setmetatable(ACTION, Action)

    local copy = {}
    setmetatable(copy, ACTION)
    copy:Init(actionName, caster, skill, targets, ...)
    return copy
end

function Action:Init(name, caster, skill, targets, ...)
    self.name = name
    self.caster = caster
    self.skill = skill
    self.targets = targets
    self.events = {}  -- key time, value eventFunc
    self.eventsCount = 0
    self.timer = 0
    self.done = false
    self:InitEvents(...)
end

function Action:Dispose()
    self.done = true -- 调用Dispose视为强制中断action
    self.name = nil
    self.caster = nil
    self.skill = nil
    self.targets = nil
    for event,_ in pairs(self.events) do
        event:Dispose()
    end
    self.events = nil
    self.eventsCount = 0
end

function Action:InitEvents(...)
end

function Action:AddEvent(time, eventName, ...)
    local EVENT_BASE = require('Advanture.Actions.Events.EventBase')
    local EVENT = require('Advanture.Actions.Events.'..eventName)
    assert(EVENT ~= nil, 'Error! event not exists: '..eventName)
    setmetatable(EVENT, EVENT_BASE)

    local event = {}
    setmetatable(event, EVENT)
    event:Init(eventName, self, time, self.caster, ...);
    self.events[event] = time
    self.eventsCount = self.eventsCount + 1
end

function Action:Update(deltaTime)
    if self.done then return end
    self.timer = self.timer + deltaTime
    for event,time in pairs(self.events) do
        if event.state == 0 then
            if self.timer >= time then
                event:Enter()
                if self.done then return end  -- 事件逻辑有可能导致action被中断，所以这里要判断一下
            end
        end
        if event.state == 1 then
            event:Update(deltaTime)
            if self.done then return end  -- 同上
        end
        if event.state == 2 then
            self.events[event] = nil
            self.eventsCount = self.eventsCount - 1
        end
    end
    if self.eventsCount == 0 then
        self.done = true
    end
end

return Action