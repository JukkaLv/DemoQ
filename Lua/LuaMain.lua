local cfg = require 'config.Cfg'
cfg.Init('Assets/LubanGen/Bin/') -- 初始化游戏配置

require('UnityDefines')
local Timer = require('Framework.Timer')

serpent = require('utils.serpent') -- 格式化打印Table的工具
CommonUtils = require('utils.CommonUtils') -- 通用工具方法集
ViewUtils = require("utils.ViewUtils") -- UI工具方法集

-- Lua端游戏主体
Game = {}

-- 创建一个Mono代理给Demo
CS.Framework.Lua.LuaMonoBehaivour.Create(Game, "LuaGame")
-- Mono代理Update回调
function Game.Update(deltaTime)
    Timer.UpdateAll(deltaTime)
    if Game.advanture ~= nil then
        Game.advanture:Update(deltaTime)
    end
end

GameObject.DontDestroyOnLoad(GameObject.Find("UI"))
-- 启动MVC
require 'MVC.MVCFacade'
MVCFacade.Initialize(GameObject.Find("UI/Canvas2D").transform)
MVCFacade.ExcuteCommand('CmdInitHome')
MVCFacade.ExcuteCommand('CmdShowBeginAdvanture')
-- MVCFacade.ExcuteCommand('CmdInitHome')
-- MVCFacade.ExcuteCommand('CmdShowMyView', "HeiHeiHei")


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
-- Game.advanture = require('Advanture.Advanture').Create(context)
