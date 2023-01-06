
local setmetatable = setmetatable
local pairs = pairs
local ipairs = ipairs
local tinsert = table.insert

local function SimpleClass()
    local class = {}
    class.__index = class
    class.New = function(...)
        local ctor = class.ctor
        local o = ctor and ctor(...) or {}
        setmetatable(o, class)
        return o
    end
    return class
end


local function get_map_size(m)
    local n = 0
    for _ in pairs(m) do
        n = n + 1
    end
    return n
end

local enums =
{
    ---@class gp.HeroClass
     ---@field public NORMAL integer
     ---@field public RARE integer
     ---@field public EPIC integer
     ---@field public LEGEND integer
    ['gp.HeroClass'] = {   NORMAL=1,  RARE=2,  EPIC=3,  LEGEND=4,  };
}


local function InitTypes(methods)
    local readBool = methods.readBool
    local readByte = methods.readByte
    local readShort = methods.readShort
    local readFshort = methods.readFshort
    local readInt = methods.readInt
    local readFint = methods.readFint
    local readLong = methods.readLong
    local readFlong = methods.readFlong
    local readFloat = methods.readFloat
    local readDouble = methods.readDouble
    local readSize = methods.readSize

    local readString = methods.readString

    local function readVector2(bs)
        return { x = readFloat(bs), y = readFloat(bs) }
    end

    local function readVector3(bs)
        return { x = readFloat(bs), y = readFloat(bs), z = readFloat(bs) }
    end

    local function readVector4(bs)
        return { x = readFloat(bs), y = readFloat(bs), z = readFloat(bs), w = readFloat(bs) }
    end

    local function readList(bs, keyFun)
        local list = {}
        local v
        for i = 1, readSize(bs) do
            tinsert(list, keyFun(bs))
        end
        return list
    end

    local readArray = readList

    local function readSet(bs, keyFun)
        local set = {}
        local v
        for i = 1, readSize(bs) do
            tinsert(set, keyFun(bs))
        end
        return set
    end

    local function readMap(bs, keyFun, valueFun)
        local map = {}
        for i = 1, readSize(bs) do
            local k = keyFun(bs)
            local v = valueFun(bs)
            map[k] = v
        end
        return map
    end

    local function readNullableBool(bs)
        if readBool(bs) then
            return readBool(bs)
        end
    end

    local beans = {}
    do
    ---@class gp.GlobalDefines 
     ---@field public global_a integer
     ---@field public global_b string
     ---@field public global_c number
     ---@field public global_d string[]
        local class = SimpleClass()
        class._id = -531279728
        class['_type_'] = 'gp.GlobalDefines'
        local id2name = {  }
        class._deserialize = function(bs)
            local o = {
            global_a = readInt(bs),
            global_b = readString(bs),
            global_c = readFloat(bs),
            global_d = readList(bs, readString),
            }
            setmetatable(o, class)
            return o
        end
        beans[class['_type_']] = class
    end
    do
    ---@class gp.Actor 
     ---@field public id integer
     ---@field public name string
     ---@field public class integer
     ---@field public level integer
     ---@field public hudOffset number
     ---@field public skillIds integer[]
        local class = SimpleClass()
        class._id = 1117036688
        class['_type_'] = 'gp.Actor'
        local id2name = {  }
        class._deserialize = function(bs)
            local o = {
            id = readInt(bs),
            name = readString(bs),
            class = readInt(bs),
            level = readInt(bs),
            hudOffset = readFloat(bs),
            skillIds = readList(bs, readInt),
            }
            setmetatable(o, class)
            return o
        end
        beans[class['_type_']] = class
    end
    do
    ---@class gp.Skill 
     ---@field public id integer
     ---@field public name string
     ---@field public isUlt boolean
        local class = SimpleClass()
        class._id = 1133887724
        class['_type_'] = 'gp.Skill'
        local id2name = {  }
        class._deserialize = function(bs)
            local o = {
            id = readInt(bs),
            name = readString(bs),
            isUlt = readBool(bs),
            }
            setmetatable(o, class)
            return o
        end
        beans[class['_type_']] = class
    end
    do
    ---@class gp.SkillLevel 
     ---@field public skillId integer
     ---@field public levelInfos gp.SkillLevelInfo[]
        local class = SimpleClass()
        class._id = -350708232
        class['_type_'] = 'gp.SkillLevel'
        local id2name = {  }
        class._deserialize = function(bs)
            local o = {
            skillId = readInt(bs),
            levelInfos = readList(bs, beans['gp.SkillLevelInfo']._deserialize),
            }
            setmetatable(o, class)
            return o
        end
        beans[class['_type_']] = class
    end
    do
    ---@class gp.SkillLevelInfo 
     ---@field public level integer
     ---@field public exp integer
        local class = SimpleClass()
        class._id = 1363917510
        class['_type_'] = 'gp.SkillLevelInfo'
        local id2name = {  }
        class._deserialize = function(bs)
            local o = {
            level = readInt(bs),
            exp = readInt(bs),
            }
            setmetatable(o, class)
            return o
        end
        beans[class['_type_']] = class
    end

    local tables =
    {
    { name='TblGlobalDefines', file='gp_tblglobaldefines', mode='one', value_type='gp.GlobalDefines'},
    { name='TblActor', file='gp_tblactor', mode='map', index='id', value_type='gp.Actor' },
    { name='TblSkill', file='gp_tblskill', mode='map', index='id', value_type='gp.Skill' },
    { name='TblSkillLevel', file='gp_tblskilllevel', mode='map', index='skillId', value_type='gp.SkillLevel' },
    }
    return { enums = enums, beans = beans, tables = tables }
    end

return { InitTypes = InitTypes }

