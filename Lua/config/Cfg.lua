local Cfg = {}

local tinsert = table.insert
local tconcat = table.concat

local function ttostring2(x, result)
    local t = type(x)
    if t == "table" then
        tinsert(result, "{")
        for k, v in pairs(x) do
            tinsert(result, tostring(k))
            tinsert(result, "=")
            ttostring2(v, result)
            tinsert(result, ",")
        end

        tinsert(result, "}")
    elseif t == "string" then
        tinsert(result, x)
    else
        tinsert(result, tostring(x))
    end
end

local function ttostring(t)
    local out = {}
    ttostring2(t, out)
    return tconcat(out)
end

local byteBufIns = CS.Bright.Serialization.ByteBuf()
local byteBufFuns = {
    readBool = byteBufIns.ReadBool,
    writeBool = byteBufIns.WriteBool,
    readByte = byteBufIns.ReadByte,
    writeByte = byteBufIns.WriteByte,
    readShort = byteBufIns.ReadShort,
    writeShort = byteBufIns.WriteShort,
    readFshort = byteBufIns.ReadFshort,
    writeInt = byteBufIns.WriteInt,
    readInt = byteBufIns.ReadInt,
    writeFint = byteBufIns.WriteFint,
    readFint = byteBufIns.ReadFint,
    readLong = byteBufIns.ReadLong,
    writeLong = byteBufIns.WriteLong,
    readFlong = byteBufIns.ReadFlong,
    writeFlong = byteBufIns.WriteFlong,
    readFloat = byteBufIns.ReadFloat,
    writeFloat = byteBufIns.WriteFloat,
    readDouble = byteBufIns.ReadDouble,
    writeDouble = byteBufIns.WriteDouble,
    readSize = byteBufIns.ReadSize,
    writeSize = byteBufIns.WriteSize,
    readString = byteBufIns.ReadString,
    writeString = byteBufIns.WriteString,
    readBytes = byteBufIns.ReadBytes,
    writeBytes = byteBufIns.WriteBytes
}

local enumDefs = {}
-- local constDefs = {}

local tables = {}

local function Load(typeDefs)
    enumDefs = typeDefs.enums
    -- constDefs = typeDefs.consts

    local loader = CS.Framework.Luban.LubanLoader()
    loader:AddLoadPath('Assets/Luban/Bin/')

    local tableDefs = typeDefs.tables
    local beanDefs = typeDefs.beans
    for _, t in pairs(tableDefs) do
        local buf = loader:Load(t.file)

        local valueType = beanDefs[t.value_type]
        local mode = t.mode

        local tableDatas
        if mode == "map" then
            tableDatas = {}
			local index = t.index
            for i = 1, buf:ReadSize() do
                local v = valueType._deserialize(buf)
                tableDatas[v[index]] = v
            end
        elseif mode == "list" then
            tableDatas = {}
            for i = 1, buf:ReadSize() do
                local v = valueType._deserialize(buf)
                tinsert(tableDatas, v)
            end
        else
            assert(buf:ReadSize() == 1)
            tableDatas = valueType._deserialize(buf)
        end
		--print(ttostring(tableDatas))
        tables[t.name] = tableDatas
    end
end

---@param typeName string
---@param key string
function Cfg.GetEnum(typeName, key)
    local def = enumDefs[typeName]
    return key and def[key] or def
end

-- ---@param typeName string
-- ---@param field string
-- function Cfg.GetConst(typeName, field)
--     local def = constDefs[typeName]
--     return field and def[field] or constDefs
-- end

function Cfg.GetData(tblName, ...)
    local tbl = tables[tblName]
    assert(tbl ~= nil, 'Error! config table not exists: '..tblName)

	local keys = {...}
	for i,key in ipairs(keys) do
		assert(tbl[key] ~= nil, 'Error! key not exists: '..tblName..' -> '..ttostring(keys) .. ' => ' .. key)
		tbl = tbl[key]
	end
	return tbl
end

function Cfg.Init()
    local t = os.clock()
    local cfgTypeDefs = require("config.Types").InitTypes(byteBufFuns)
    Load(cfgTypeDefs)
    local cost = os.clock() - t
    print("Configs Loaded. cost "..cost.." ms")
end

return Cfg
