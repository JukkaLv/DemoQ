require('UnityDefines')

-- Global Defines
serpent = require('utils.serpent') -- 格式化打印Table的工具
CommonUtils = require('utils.CommonUtils') -- 通用工具方法集
ViewUtils = require("utils.ViewUtils") -- UI工具方法集
Notifier = require 'Framework.Notifier'
 -- 初始化游戏配置
Cfg = require 'config.Cfg'
Cfg.Init('Assets/LubanGen/Bin/')
-- Lua端游戏主体
Game = {}

-- 创建一个Mono代理给Demo
CS.Framework.Lua.LuaMonoBehaivour.Create(Game, "LuaGame")
-- Mono代理Update回调
local Timer = require('Framework.Timer')
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
MVCFacade.ExcuteCommand('CmdEnterHome')

Notifier.Dispatch("SHOW_ADVANTURE_PREPARE_VIEW")