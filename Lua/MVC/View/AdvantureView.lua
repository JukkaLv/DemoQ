-- 本脚本为自动生成，不要手动修改，以免被覆盖
local Notifier = require 'Framework.Notifier'
local AdvantureView = {}
AdvantureView.__index = AdvantureView
AdvantureView.__PREFAB_ASSET = 'Assets/Demo/Resources/Views/AdvantureView.prefab'
function AdvantureView.Create(facade, inherit)
	local copy = {}
	setmetatable(copy, AdvantureView)
	copy:Init(facade)
	if inherit ~= nil then
		copy.list_attrs_ItemTemplate = inherit.list_attrs_ItemTemplate
	end
	return copy
end

function AdvantureView:Init(facade)
	assert(facade ~= nil, 'Error! AdvantureView facade is nil')
	facade:SetComps(self)
	self.viewName = 'AdvantureView'
	self.viewTblPath = { 'AdvantureView' }
	self.gameObject = facade.gameObject
	self.transform = facade.transform
	self.list_attrs_ItemTemplate = nil
	self.__list_attrs_POOL = {}
	self.itemview_attr = AdvantureView.MasterAttrItemView.Create(self.itemview_attr)
	self.btn_march_OnClick = nil
	self.btn_march_OnClickNoti = nil
	self.btn_march.onClick:AddListener(function()
		if self.btn_march_OnClick ~= nil then self.btn_march_OnClick() end
		if self.btn_march_OnClickNoti ~= nil and self.btn_march_OnClickNoti.name ~= nil then Notifier.Dispatch(self.btn_march_OnClickNoti.name, self.btn_march_OnClickNoti.body) end 
	end)
end

function AdvantureView:Open(viewModel)
	assert(self.gameObject ~= nil, 'Error! AdvantureView has been disposed.')
	Notifier.Dispatch('__OPEN_VIEW_BEFORE', self)
	self.gameObject:SetActive(true)
	if viewModel ~= nil then self:Render(viewModel) end
	Notifier.Dispatch('__OPEN_VIEW_AFTER', self)
end

function AdvantureView:Close()
	assert(self.gameObject ~= nil, 'Error! AdvantureView has been disposed.')
	Notifier.Dispatch('__CLOSE_VIEW_BEFORE', self)
	self.gameObject:SetActive(false)
	Notifier.Dispatch('__CLOSE_VIEW_AFTER', self)
end

function AdvantureView:Dispose()
	assert(self.gameObject ~= nil, 'Error! AdvantureView has been disposed.')
	GameObject.Destroy(self.gameObject)
	self.gameObject = nil
	self.transform = nil
end

function AdvantureView:Render(viewModel)
	 if type(viewModel) ~= 'table' then return end
	if viewModel.txt_progress ~= nil then
		if viewModel.txt_progress.enabled ~= nil then self.txt_progress.enabled = viewModel.txt_progress.enabled end
		if viewModel.txt_progress.text ~= nil then self.txt_progress.text = viewModel.txt_progress.text end
		if viewModel.txt_progress.color ~= nil then self.txt_progress.color = viewModel.txt_progress.color end
	end
	if viewModel.list_attrs ~= nil then
		if viewModel.list_attrs.items ~= nil then
			assert(self.list_attrs_ItemTemplate ~= nil, 'AdvantureView.list_attrs item template is nil')
			local minLen = math.min(#self.__list_attrs_POOL, #viewModel.list_attrs.items)
			for i=1,minLen do
				self.__list_attrs_POOL[i].gameObject:SetActive(true)
				self.__list_attrs_POOL[i]:Render(viewModel.list_attrs.items[i])
			end
			for i=minLen+1,#self.__list_attrs_POOL do
				self.__list_attrs_POOL[i].gameObject:SetActive(false)
			end
			for i=minLen+1,#viewModel.list_attrs.items do
				local ITEM_VIEW = require('MVC.View.'..self.list_attrs_ItemTemplate.viewTblPath[1])
				if #self.list_attrs_ItemTemplate.viewTblPath > 1 then
					for j=2, #self.list_attrs_ItemTemplate.viewTblPath do
						ITEM_VIEW = ITEM_VIEW[self.list_attrs_ItemTemplate.viewTblPath[j]]
					end
				end
				local itemViewGO = GameObject.Instantiate(self.list_attrs_ItemTemplate.gameObject, Vector3.zero, Quaternion.identity, self.list_attrs.transform)
				local itemView = ITEM_VIEW.Create(itemViewGO:GetComponent('LuaViewFacade'), self.list_attrs_ItemTemplate)
				table.insert(self.__list_attrs_POOL, itemView)
				itemViewGO.transform:SetParent(self.list_attrs.transform, false)
				itemViewGO:SetActive(true)
				itemView:Render(viewModel.list_attrs.items[i])
			end
		end
	end
	if viewModel.itemview_attr ~= nil then
		self.itemview_attr:Render(viewModel.itemview_attr)
	end
	if viewModel.btn_march ~= nil then
		if viewModel.btn_march.enabled ~= nil then self.btn_march.enabled = viewModel.btn_march.enabled end
		if viewModel.btn_march.interactable ~= nil then self.btn_march.interactable = viewModel.btn_march.interactable end
		if viewModel.btn_march.OnClickNoti ~= nil then self.btn_march_OnClickNoti = viewModel.btn_march.OnClickNoti end
	end
	if viewModel.txt_march ~= nil then
		if viewModel.txt_march.enabled ~= nil then self.txt_march.enabled = viewModel.txt_march.enabled end
		if viewModel.txt_march.text ~= nil then self.txt_march.text = viewModel.txt_march.text end
		if viewModel.txt_march.color ~= nil then self.txt_march.color = viewModel.txt_march.color end
	end
	if viewModel.txt_supply ~= nil then
		if viewModel.txt_supply.enabled ~= nil then self.txt_supply.enabled = viewModel.txt_supply.enabled end
		if viewModel.txt_supply.text ~= nil then self.txt_supply.text = viewModel.txt_supply.text end
		if viewModel.txt_supply.color ~= nil then self.txt_supply.color = viewModel.txt_supply.color end
	end
end

-- Auto Generate Internal View: AdvantureView.MasterAttrItemView
AdvantureView.MasterAttrItemView = {}
AdvantureView.MasterAttrItemView.__index = AdvantureView.MasterAttrItemView

function AdvantureView.MasterAttrItemView.Create(facade, inherit)
	local copy = {}
	setmetatable(copy, AdvantureView.MasterAttrItemView)
	copy:Init(facade)
	if inherit ~= nil then
	end
	return copy
end

function AdvantureView.MasterAttrItemView:Init(facade)
	assert(facade ~= nil, 'Error! AdvantureView.MasterAttrItemView facade is nil')
	facade:SetComps(self)
	self.viewName = 'MasterAttrItemView'
	self.viewTblPath = { 'AdvantureView', 'MasterAttrItemView' }
	self.gameObject = facade.gameObject
	self.transform = facade.transform
end

function AdvantureView.MasterAttrItemView:Render(viewModel)
	 if type(viewModel) ~= 'table' then return end
	if viewModel.txt_content ~= nil then
		if viewModel.txt_content.enabled ~= nil then self.txt_content.enabled = viewModel.txt_content.enabled end
		if viewModel.txt_content.text ~= nil then self.txt_content.text = viewModel.txt_content.text end
		if viewModel.txt_content.color ~= nil then self.txt_content.color = viewModel.txt_content.color end
	end
end

return AdvantureView