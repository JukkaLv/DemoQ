-- 本脚本为自动生成，不要手动修改，以免被覆盖
local Notifier = require 'Framework.Notifier'
local SlotSkillTipItemView = {}
SlotSkillTipItemView.__index = SlotSkillTipItemView
SlotSkillTipItemView.__PREFAB_ASSET = 'Assets/Demo/Resources/Views/SlotSkillTipItemView.prefab'
function SlotSkillTipItemView.Create(facade, inherit)
	local copy = {}
	setmetatable(copy, SlotSkillTipItemView)
	copy:Init(facade)
	if inherit ~= nil then
		copy.elements_ItemTemplate = inherit.elements_ItemTemplate
	end
	return copy
end

function SlotSkillTipItemView:Init(facade)
	assert(facade ~= nil, 'Error! SlotSkillTipItemView facade is nil')
	facade:SetComps(self)
	self.viewName = 'SlotSkillTipItemView'
	self.viewTblPath = { 'SlotSkillTipItemView' }
	self.gameObject = facade.gameObject
	self.transform = facade.transform
	self.elements_ItemTemplate = nil
	self.__elements_POOL = {}
end

function SlotSkillTipItemView:Open(viewModel)
	assert(self.gameObject ~= nil, 'Error! SlotSkillTipItemView has been disposed.')
	Notifier.Dispatch('__OPEN_VIEW_BEFORE', self)
	self.gameObject:SetActive(true)
	if viewModel ~= nil then self:Render(viewModel) end
	Notifier.Dispatch('__OPEN_VIEW_AFTER', self)
end

function SlotSkillTipItemView:Close()
	assert(self.gameObject ~= nil, 'Error! SlotSkillTipItemView has been disposed.')
	Notifier.Dispatch('__CLOSE_VIEW_BEFORE', self)
	self.gameObject:SetActive(false)
	Notifier.Dispatch('__CLOSE_VIEW_AFTER', self)
end

function SlotSkillTipItemView:Dispose()
	assert(self.gameObject ~= nil, 'Error! SlotSkillTipItemView has been disposed.')
	GameObject.Destroy(self.gameObject)
	self.gameObject = nil
	self.transform = nil
end

function SlotSkillTipItemView:Render(viewModel)
	 if type(viewModel) ~= 'table' then return end
	if viewModel.elements ~= nil then
		if viewModel.elements.items ~= nil then
			assert(self.elements_ItemTemplate ~= nil, 'SlotSkillTipItemView.elements item template is nil')
			local minLen = math.min(#self.__elements_POOL, #viewModel.elements.items)
			for i=1,minLen do
				self.__elements_POOL[i].gameObject:SetActive(true)
				self.__elements_POOL[i]:Render(viewModel.elements.items[i])
			end
			for i=minLen+1,#self.__elements_POOL do
				self.__elements_POOL[i].gameObject:SetActive(false)
			end
			for i=minLen+1,#viewModel.elements.items do
				local ITEM_VIEW = require('MVC.View.'..self.elements_ItemTemplate.viewTblPath[1])
				if #self.elements_ItemTemplate.viewTblPath > 1 then
					for j=2, #self.elements_ItemTemplate.viewTblPath do
						ITEM_VIEW = ITEM_VIEW[self.elements_ItemTemplate.viewTblPath[j]]
					end
				end
				local itemViewGO = GameObject.Instantiate(self.elements_ItemTemplate.gameObject, Vector3.zero, Quaternion.identity, self.elements.transform)
				local itemView = ITEM_VIEW.Create(itemViewGO:GetComponent('LuaViewFacade'), self.elements_ItemTemplate)
				table.insert(self.__elements_POOL, itemView)
				itemViewGO.transform:SetParent(self.elements.transform, false)
				itemViewGO:SetActive(true)
				itemView:Render(viewModel.elements.items[i])
			end
		end
	end
	if viewModel.txt_desc ~= nil then
		if viewModel.txt_desc.enabled ~= nil then self.txt_desc.enabled = viewModel.txt_desc.enabled end
		if viewModel.txt_desc.text ~= nil then self.txt_desc.text = viewModel.txt_desc.text end
		if viewModel.txt_desc.color ~= nil then self.txt_desc.color = viewModel.txt_desc.color end
	end
end

return SlotSkillTipItemView