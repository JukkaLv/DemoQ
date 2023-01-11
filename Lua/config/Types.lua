
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
    ---@class gp.E_ValueCompare
     ---@field public Equal integer
     ---@field public NEqual integer
     ---@field public Greater integer
     ---@field public GEqual integer
     ---@field public Less integer
     ---@field public LEqual integer
    ['gp.E_ValueCompare'] = {   Equal=0,  NEqual=1,  Greater=2,  GEqual=3,  Less=4,  LEqual=5,  };
    ---@class gp.E_Element
     ---@field public None integer
     ---@field public Fire integer
     ---@field public Water integer
     ---@field public Wind integer
     ---@field public Earth integer
     ---@field public Light integer
     ---@field public Dark integer
    ['gp.E_Element'] = {   None=0,  Fire=1,  Water=2,  Wind=4,  Earth=8,  Light=16,  Dark=32,  };
    ---@class gp.E_BattleCamp
     ---@field public Own integer
     ---@field public Opp integer
     ---@field public All integer
    ['gp.E_BattleCamp'] = {   Own=1,  Opp=2,  All=3,  };
    ---@class gp.E_BattleAttribute
     ---@field public Hp integer
     ---@field public HpPer integer
     ---@field public MaxHp integer
     ---@field public Atk integer
     ---@field public Def integer
     ---@field public MAtk integer
     ---@field public MDef integer
     ---@field public Spd integer
    ['gp.E_BattleAttribute'] = {   Hp=0,  HpPer=1,  MaxHp=2,  Atk=3,  Def=4,  MAtk=5,  MDef=6,  Spd=7,  };
    ---@class gp.E_BattleSkillType
     ---@field public Normal integer
     ---@field public Slot integer
    ['gp.E_BattleSkillType'] = {   Normal=0,  Slot=1,  };
    ---@class gp.E_TS_Method
     ---@field public None integer
     ---@field public Random integer
     ---@field public Nearest integer
     ---@field public Farest integer
     ---@field public Match integer
     ---@field public All integer
     ---@field public Self integer
     ---@field public AttrLowest integer
     ---@field public AttrHighest integer
    ['gp.E_TS_Method'] = {   None=0,  Random=1,  Nearest=2,  Farest=3,  Match=4,  All=5,  Self=6,  AttrLowest=7,  AttrHighest=8,  };
    ---@class gp.E_ADV_EVT_TYPE
     ---@field public Chest integer
     ---@field public Battle integer
     ---@field public Dialog integer
    ['gp.E_ADV_EVT_TYPE'] = {   Chest=0,  Battle=1,  Dialog=2,  };
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
    ---@class gp.Actor 
     ---@field public id integer
     ---@field public name string
     ---@field public element integer
     ---@field public maxHP integer
     ---@field public speed integer
     ---@field public size integer
     ---@field public skills integer[]
     ---@field public prefab string
     ---@field public icon string
        local class = SimpleClass()
        class._id = 1117036688
        class['_type_'] = 'gp.Actor'
        local id2name = {  }
        class._deserialize = function(bs)
            local o = {
            id = readInt(bs),
            name = readString(bs),
            element = readInt(bs),
            maxHP = readInt(bs),
            speed = readInt(bs),
            size = readInt(bs),
            skills = readList(bs, readInt),
            prefab = readString(bs),
            icon = readString(bs),
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
     ---@field public startCD integer
     ---@field public intervalCD integer
     ---@field public priority integer
     ---@field public power integer
     ---@field public type integer
     ---@field public elements integer[]
     ---@field public enterAction string
     ---@field public castAction string
     ---@field public targetFilter gp.B_TF
     ---@field public targetSelector gp.B_TS
     ---@field public desc string
        local class = SimpleClass()
        class._id = 1133887724
        class['_type_'] = 'gp.Skill'
        local id2name = {  }
        class._deserialize = function(bs)
            local o = {
            id = readInt(bs),
            name = readString(bs),
            startCD = readInt(bs),
            intervalCD = readInt(bs),
            priority = readInt(bs),
            power = readInt(bs),
            type = readInt(bs),
            elements = readList(bs, readInt),
            enterAction = readBool(bs) and readString(bs) or nil,
            castAction = readBool(bs) and readString(bs) or nil,
            targetFilter = beans['gp.B_TF']._deserialize(bs),
            targetSelector = beans['gp.B_TS']._deserialize(bs),
            desc = readString(bs),
            }
            setmetatable(o, class)
            return o
        end
        beans[class['_type_']] = class
    end
    do
    ---@class gp.B_TF 
     ---@field public camp integer
     ---@field public dist gp.B_TF_Dist
     ---@field public attr gp.B_TF_Attr
     ---@field public exSelf boolean
        local class = SimpleClass()
        class._id = 174605684
        class['_type_'] = 'gp.B_TF'
        local id2name = {  }
        class._deserialize = function(bs)
            local o = {
            camp = readInt(bs),
            dist = beans['gp.B_TF_Dist']._deserialize(bs),
            attr = beans['gp.B_TF_Attr']._deserialize(bs),
            exSelf = readBool(bs),
            }
            setmetatable(o, class)
            return o
        end
        beans[class['_type_']] = class
    end
    do
    ---@class gp.B_TF_Dist 
     ---@field public isOn boolean
     ---@field public value integer
     ---@field public comp integer
        local class = SimpleClass()
        class._id = -1069007439
        class['_type_'] = 'gp.B_TF_Dist'
        local id2name = {  }
        class._deserialize = function(bs)
            local o = {
            isOn = readBool(bs),
            value = readInt(bs),
            comp = readInt(bs),
            }
            setmetatable(o, class)
            return o
        end
        beans[class['_type_']] = class
    end
    do
    ---@class gp.B_TF_Attr 
     ---@field public isOn boolean
     ---@field public attr integer
     ---@field public value integer
     ---@field public comp integer
        local class = SimpleClass()
        class._id = -1069086212
        class['_type_'] = 'gp.B_TF_Attr'
        local id2name = {  }
        class._deserialize = function(bs)
            local o = {
            isOn = readBool(bs),
            attr = readInt(bs),
            value = readInt(bs),
            comp = readInt(bs),
            }
            setmetatable(o, class)
            return o
        end
        beans[class['_type_']] = class
    end
    do
    ---@class gp.B_TS 
     ---@field public method integer
     ---@field public attr integer
     ---@field public amount integer
        local class = SimpleClass()
        class._id = 174605697
        class['_type_'] = 'gp.B_TS'
        local id2name = {  }
        class._deserialize = function(bs)
            local o = {
            method = readInt(bs),
            attr = readInt(bs),
            amount = readInt(bs),
            }
            setmetatable(o, class)
            return o
        end
        beans[class['_type_']] = class
    end
    do
    ---@class gp.AdvantureSlot 
     ---@field public id integer
     ---@field public weight integer
     ---@field public elements integer[]
     ---@field public evtType integer
     ---@field public evtBody gp.B_ADV_EVT
        local class = SimpleClass()
        class._id = 643347533
        class['_type_'] = 'gp.AdvantureSlot'
        local id2name = {  }
        class._deserialize = function(bs)
            local o = {
            id = readInt(bs),
            weight = readInt(bs),
            elements = readList(bs, readInt),
            evtType = readInt(bs),
            evtBody = beans['gp.B_ADV_EVT']._deserialize(bs),
            }
            setmetatable(o, class)
            return o
        end
        beans[class['_type_']] = class
    end
    do
    ---@class gp.B_ADV_EVT 
        local class = SimpleClass()
        class._id = -816509355
        class['_type_'] = 'gp.B_ADV_EVT'
        local id2name = {  [154307703] = 'gp.B_ADV_EVT_CHEST',  [453925346] = 'gp.B_ADV_EVT_BATTLE',  [517998194] = 'gp.B_ADV_EVT_DIALOG',  }
        class._deserialize = function(bs)
            local id = readInt(bs)
            return beans[id2name[id]]._deserialize(bs)
        end
        beans[class['_type_']] = class
    end
    do
    ---@class gp.B_ADV_EVT_CHEST :gp.B_ADV_EVT 
     ---@field public chestModel string
     ---@field public coin integer
        local class = SimpleClass()
        class._id = 154307703
        class['_type_'] = 'gp.B_ADV_EVT_CHEST'
        local id2name = {  }
        class._deserialize = function(bs)
            local o = {
            chestModel = readString(bs),
            coin = readInt(bs),
            }
            setmetatable(o, class)
            return o
        end
        beans[class['_type_']] = class
    end
    do
    ---@class gp.B_ADV_EVT_BATTLE :gp.B_ADV_EVT 
     ---@field public enemies integer[]
        local class = SimpleClass()
        class._id = 453925346
        class['_type_'] = 'gp.B_ADV_EVT_BATTLE'
        local id2name = {  }
        class._deserialize = function(bs)
            local o = {
            enemies = readList(bs, readInt),
            }
            setmetatable(o, class)
            return o
        end
        beans[class['_type_']] = class
    end
    do
    ---@class gp.B_ADV_EVT_DIALOG :gp.B_ADV_EVT 
     ---@field public dialog string
        local class = SimpleClass()
        class._id = 517998194
        class['_type_'] = 'gp.B_ADV_EVT_DIALOG'
        local id2name = {  }
        class._deserialize = function(bs)
            local o = {
            dialog = readString(bs),
            }
            setmetatable(o, class)
            return o
        end
        beans[class['_type_']] = class
    end

    local tables =
    {
    { name='TblActor', file='gp_tblactor', mode='map', index='id', value_type='gp.Actor' },
    { name='TblSkill', file='gp_tblskill', mode='map', index='id', value_type='gp.Skill' },
    { name='TblAdvantureSlot', file='gp_tbladvantureslot', mode='map', index='id', value_type='gp.AdvantureSlot' },
    }
    return { enums = enums, beans = beans, tables = tables }
    end

return { InitTypes = InitTypes }

