ConfigCenter = {}

local tbls = {}
tbls['ExampleActor'] = require 'config.ExampleActor'
tbls['ExampleSkill'] = require 'config.ExampleSkill'
tbls['ExampleSkillLevel'] = require 'config.ExampleSkillLevel'

function ConfigCenter.Find(tblName, ...)
	local tbl = tbls[tblName]
	assert(tbl ~= nil, 'Error! config table not exists: '..tblName)
	local keys = {...}
	for i,key in ipairs(keys) do
		assert(tbl[key] ~= nil, 'Error! key not exists: '..tblName..' -> '..tostring(keys) .. ' => ' .. key)
		tbl = tbl[key]
	end
	return tbl
end

return ConfigCenter