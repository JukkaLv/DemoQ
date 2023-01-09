local ViewUtils = {}

local cfg = require 'config.Cfg'

function ViewUtils.GetElementSprite(element)
    if element == cfg.GetEnum('gp.E_Element', 'Fire') then
        return Resources.Load("Sprites/SpriteAssets/Icon/icon_fire", typeof(Sprite)) -- todo replace AssetManager
    elseif element == cfg.GetEnum('gp.E_Element', 'Water') then
        return Resources.Load("Sprites/SpriteAssets/Icon/icon_water", typeof(Sprite)) -- todo replace AssetManager
    elseif element == cfg.GetEnum('gp.E_Element', 'Wind') then
        return Resources.Load("Sprites/SpriteAssets/Icon/icon_wind", typeof(Sprite)) -- todo replace AssetManager
    elseif element == cfg.GetEnum('gp.E_Element', 'Earth') then
        return Resources.Load("Sprites/SpriteAssets/Icon/icon_earth", typeof(Sprite)) -- todo replace AssetManager
    elseif element == cfg.GetEnum('gp.E_Element', 'Light') then
        return Resources.Load("Sprites/SpriteAssets/Icon/icon_light", typeof(Sprite)) -- todo replace AssetManager
    elseif element == cfg.GetEnum('gp.E_Element', 'Dark') then
        return Resources.Load("Sprites/SpriteAssets/Icon/icon_dark", typeof(Sprite)) -- todo replace AssetManager
    else
        return Resources.Load("Sprites/SpriteAssets/Icon/icon_none", typeof(Sprite)) -- todo replace AssetManager
    end
end

function ViewUtils.GetActorSprite(actorCfgId)
    local path = "Sprites/SpriteAssets/Character/" .. cfg.GetData("TblActor", actorCfgId).icon
    return Resources.Load(path, typeof(Sprite))
end

return ViewUtils