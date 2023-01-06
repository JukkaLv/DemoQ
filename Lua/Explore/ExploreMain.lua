
require('UnityDefines')
local Timer = require('Framework.Timer')
CommonUtils = require('utils.CommonUtils') -- 通用方法集

-- Lua端游戏主体
ExploreMain = {}
function ExploreMain.Update(deltaTime)
    Timer.UpdateAll(deltaTime)
end
ExploreMain.ui = require('Explore.ExploreUI').Create()

-- 创建一个Mono代理给Demo
CS.Framework.Lua.LuaMonoBehaivour.Create(ExploreMain, "ExploreMain")