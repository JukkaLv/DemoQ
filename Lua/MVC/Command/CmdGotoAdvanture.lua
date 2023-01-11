local CmdGotoAdvanture = {}

function CmdGotoAdvanture.Excute(heroIds)
    -- 组织一次advanture
    local context = {
        scene = {
        },
        supply = 120,
        costPerMarch = 10,
        masterAttrs = {99, 99, 99, 99, 99},
        waves = {
            { rand = true, pool = { 1, 2, 3, 4, 5 } },
            { rand = true, pool = { 1, 2, 3, 4, 5 } },
            { rand = true, pool = { 1, 2, 3, 4, 5 } },
            { rand = true, pool = { 1, 2, 3, 4, 5 } },
            { rand = true, pool = { 1, 2, 3, 4, 5 } },
            { rand = true, pool = { 1, 2, 3, 4, 5 } },
            { rand = true, pool = { 1, 2, 3, 4, 5 } },
            { rand = true, pool = { 1, 2, 3, 4, 5 } },
            { rand = true, pool = { 1, 2, 3, 4, 5 } },
            { rand = false, slotId = 6 },
        },
        heros = {}
    }

    for i,wave in ipairs(context.waves) do
        wave.posx = 5 + (i - 1) * 25
    end

    for i,heroId in ipairs(heroIds) do
        local hero = {}
        hero.coord = i - 1
        hero.cfgID = heroId
        hero.camp = Cfg.GetEnum('gp.E_BattleCamp', 'Own')
        hero.isMaster = i == 0
        table.insert(context.heros, 1, hero)
    end

    -- -- 组织一次advanture
    -- local context = {
    --     scene = {
    --     },
    --     -- 玩家出场角色
    --     heros = {
    --         {coord=0, cfgID=101, camp=1, class=1}, -- class = 1 leader(主角是leader)
    --         {coord=4, cfgID=105, camp=1, class=0},
    --         {coord=3, cfgID=104, camp=1, class=0},
    --         {coord=2, cfgID=103, camp=1, class=0},
    --         {coord=1, cfgID=102, camp=1, class=0},
    --     },
    --     -- 多波次战斗
    --     waves = {
    --         {
    --             posx = 5,
    --             type = 'Battle', -- 战斗
    --             enemies = {
    --                 {coord=5, cfgID=202, camp=2, class=0},
    --                 {coord=6, cfgID=202, camp=2, class=0},
    --             },
    --         },
    --         {
    --             posx = 30,
    --             type = 'Battle', -- 战斗
    --             enemies = {
    --                 {coord=5, cfgID=202, camp=2, class=0},
    --                 {coord=6, cfgID=202, camp=2, class=0},
    --                 {coord=7, cfgID=202, camp=2, class=0},
    --                 {coord=8, cfgID=202, camp=2, class=0},
    --             },
    --         },
    --         {
    --             posx = 55,
    --             type = 'Battle', -- 战斗
    --             enemies = {
    --                 {coord=5, cfgID=201, camp=2, class=0},
    --             },
    --         },
    --     },
    -- }

    MVCFacade.ExcuteCommand("CmdLeaveHome")
    MVCFacade.ExcuteCommand("CmdEnterAdvanture", context)
end

return CmdGotoAdvanture