-- 本脚本为自动生成，不要手动修改，以免被覆盖
local Notifier = require 'Framework.Notifier'
local SlotSkillTipView = {}
SlotSkillTipView.__index = SlotSkillTipView
SlotSkillTipView.__PREFAB_ASSET = 'Assets/Demo/Resources/Views/SlotSkillTipView.prefab'
function SlotSkillTipView.Create(facade, inherit)
	local copy = {}
	setmetatable(copy, SlotSkillTipView)
	copy:Init(facade)
	if inherit ~= nil then
		copy.content_ItemTemplate = inherit.content_ItemTemplate
	end
	return copy
end

function SlotSkillTipView:Init(facade)
	assert(facade ~= nil, 'Error! SlotSkillTipView facade is nil')
	facade:SetComps(self)
	self.viewName = 'SlotSkillTipView'
	self.viewTblPath = { 'SlotSkillTipView' }
	self.gameObject = facade.gameObject
	self.transform = facade.transform
	self.btn_bg_OnClick = nil
	self.btn_bg_OnClickNoti = nil
	self.btn_bg.onClick:AddListener(function()
		if self.btn_bg_OnClick ~= nil then self.btn_bg_OnClick() end
		if self.btn_bg_OnClickNoti ~= nil and self.btn_bg_OnClickNoti.name ~= nil then Notifier.Dispatch(self.btn_bg_OnClickNoti.name, self.btn_bg_OnClickNoti.body) end 
	end)
	self.content_ItemTemplate = nil
	self.__content_POOL = {}
end

function SlotSkillTipView:Open(viewModel)
	assert(self.gameObject ~= nil, 'Error! SlotSkillTipView has been disposed.')
	Notifier.Dispatch('__OPEN_VIEW_BEFORE', self)
	self.gameObject:SetActive(true)
	if viewModel ~= nil then self:Render(viewModel) end
	Notifier.Dispatch('__OPEN_VIEW_AFTER', self)
end

function SlotSkillTipView:Close()
	assert(self.gameObject ~= nil, 'Error! SlotSkillTipView has been disposed.')
	Notifier.Dispatch('__CLOSE_VIEW_BEFORE', self)
	self.gameObject:SetActive(false)
	Notifier.Dispatch('__CLOSE_VIEW_AFTER', self)
end

function SlotSkillTipView:Dispose()
	assert(self.gameObject ~= nil, 'Error! SlotSkillTipView has been disposed.')
	GameObject.Destroy(self.gameObject)
	self.gameObject = nil
	self.transform = nil
end

function SlotSkillTipView:Render(viewModel)
	 if type(viewModel) ~= 'table' then return end
	if viewModel.btn_bg ~= nil then
		if viewModel.btn_bg.enabled ~= nil then self.btn_bg.enabled = viewModel.btn_bg.enabled end
		if viewModel.btn_bg.interactable ~= nil then self.btn_bg.interactable = viewModel.btn_bg.interactable end
		if viewModel.btn_bg.OnClickNoti ~= nil then self.btn_bg_OnClickNoti = viewModel.btn_bg.OnClickNoti end
	end
	if viewModel.content ~= nil then
		if viewModel.content.items ~= nil then
			assert(self.content_ItemTemplate ~= nil, 'SlotSkillTipView.content item template is nil')
			local minLen = math.min(#self.__content_POOL, #viewModel.content.items)
			for i=1,minLen do
				self.__content_POOL[i].gameObject:SetActive(true)
				self.__content_POOL[i]:Render(viewModel.content.items[i])
			end
			for i=minLen+1,#self.__content_POOL do
				self.__content_POOL[i].gameObject:SetActive(false)
			end
			for i=minLen+1,#viewModel.content.items do
				local ITEM_VIEW = require('MVC.View.'..self.content_ItemTemplate.viewTblPath[1])
				if #self.content_ItemTemplate.viewTblPath > 1 then
					for j=2, #self.content_ItemTemplate.viewTblPath do
						ITEM_VIEW = ITEM_VIEW[self.content_ItemTemplate.viewTblPath[j]]
					end
				end
				local itemViewGO = GameObject.Instantiate(self.content_ItemTemplate.gameObject, Vector3.zero, Quaternion.identity, self.content.transform)
				local itemView = ITEM_VIEW.Create(itemViewGO:GetComponent('LuaViewFacade'), self.content_ItemTemplate)
				table.insert(self.__content_POOL, itemView)
				itemViewGO.transform:SetParent(self.content.transform, false)
				itemViewGO:SetActive(true)
				itemView:Render(viewModel.content.items[i])
			end
		end
	end
end

return SlotSkillTipView