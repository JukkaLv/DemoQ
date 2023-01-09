-- 本脚本为自动生成，不要手动修改，以免被覆盖
local Notifier = require 'Framework.Notifier'
local SkillTipView = {}
SkillTipView.__index = SkillTipView
SkillTipView.__PREFAB_ASSET = 'Assets/Demo/Resources/UI/TipView_Skill.prefab'
function SkillTipView.Create(facade, inherit)
	local copy = {}
	setmetatable(copy, SkillTipView)
	copy:Init(facade)
	if inherit ~= nil then
		copy.elements_ItemTemplate = inherit.elements_ItemTemplate
	end
	return copy
end

function SkillTipView:Init(facade)
	assert(facade ~= nil, 'Error! SkillTipView facade is nil')
	facade:SetComps(self)
	self.viewName = facade.viewName
	self.gameObject = facade.gameObject
	self.transform = facade.transform
	self.btn_bg_OnClick = nil
	self.btn_bg_OnClickNoti = nil
	self.btn_bg.onClick:AddListener(function()
		if self.btn_bg_OnClick ~= nil then self.btn_bg_OnClick() end
		if self.btn_bg_OnClickNoti ~= nil and self.btn_bg_OnClickNoti.name ~= nil then Notifier.Dispatch(self.btn_bg_OnClickNoti.name, self.btn_bg_OnClickNoti.body) end 
	end)
	self.elements_ItemTemplate = nil
	self.__elements_POOL = {}
end

function SkillTipView:Open(viewModel)
	assert(self.gameObject ~= nil, 'Error! SkillTipView has been disposed.')
	Notifier.Dispatch('__OPEN_VIEW_BEFORE', self)
	self.gameObject:SetActive(true)
	if viewModel ~= nil then self:Render(viewModel) end
	Notifier.Dispatch('__OPEN_VIEW_AFTER', self)
end

function SkillTipView:Close()
	assert(self.gameObject ~= nil, 'Error! SkillTipView has been disposed.')
	Notifier.Dispatch('__CLOSE_VIEW_BEFORE', self)
	self.gameObject:SetActive(false)
	Notifier.Dispatch('__CLOSE_VIEW_AFTER', self)
end

function SkillTipView:Dispose()
	assert(self.gameObject ~= nil, 'Error! SkillTipView has been disposed.')
	GameObject.Destroy(self.gameObject)
	self.gameObject = nil
	self.transform = nil
end

function SkillTipView:Render(viewModel)
	assert(viewModel ~= nil, 'Error! SkillTipView view model is nil')
	if viewModel.btn_bg ~= nil then
		if viewModel.btn_bg.enabled ~= nil then self.btn_bg.enabled = viewModel.btn_bg.enabled end
		if viewModel.btn_bg.interactable ~= nil then self.btn_bg.interactable = viewModel.btn_bg.interactable end
		if viewModel.btn_bg.OnClickNoti ~= nil then self.btn_bg_OnClickNoti = viewModel.btn_bg.OnClickNoti end
	end
	if viewModel.txt_name ~= nil then
		if viewModel.txt_name.enabled ~= nil then self.txt_name.enabled = viewModel.txt_name.enabled end
		if viewModel.txt_name.text ~= nil then self.txt_name.text = viewModel.txt_name.text end
		if viewModel.txt_name.color ~= nil then self.txt_name.color = viewModel.txt_name.color end
	end
	if viewModel.txt_cd ~= nil then
		if viewModel.txt_cd.enabled ~= nil then self.txt_cd.enabled = viewModel.txt_cd.enabled end
		if viewModel.txt_cd.text ~= nil then self.txt_cd.text = viewModel.txt_cd.text end
		if viewModel.txt_cd.color ~= nil then self.txt_cd.color = viewModel.txt_cd.color end
	end
	if viewModel.txt_desc ~= nil then
		if viewModel.txt_desc.enabled ~= nil then self.txt_desc.enabled = viewModel.txt_desc.enabled end
		if viewModel.txt_desc.text ~= nil then self.txt_desc.text = viewModel.txt_desc.text end
		if viewModel.txt_desc.color ~= nil then self.txt_desc.color = viewModel.txt_desc.color end
	end
	if viewModel.txt_element ~= nil then
		if viewModel.txt_element.enabled ~= nil then self.txt_element.enabled = viewModel.txt_element.enabled end
		if viewModel.txt_element.text ~= nil then self.txt_element.text = viewModel.txt_element.text end
		if viewModel.txt_element.color ~= nil then self.txt_element.color = viewModel.txt_element.color end
	end
	if viewModel.elements ~= nil then
		if viewModel.elements.items ~= nil then
			assert(self.elements_ItemTemplate ~= nil, 'SkillTipView.elements item template is nil')
			local minLen = math.min(#self.__elements_POOL, #viewModel.elements.items)
			for i=1,minLen do
				self.__elements_POOL[i].gameObject:SetActive(true)
				self.__elements_POOL[i]:Render(viewModel.elements.items[i])
			end
			for i=minLen+1,#self.__elements_POOL do
				self.__elements_POOL[i].gameObject:SetActive(false)
			end
			for i=minLen+1,#viewModel.elements.items do
				local ITEM_VIEW = require('MVC.View.'..self.elements_ItemTemplate.viewName)
				local itemViewGO = GameObject.Instantiate(self.elements_ItemTemplate.gameObject, Vector3.zero, Quaternion.identity, self.elements.transform)
				local itemView = ITEM_VIEW.Create(itemViewGO:GetComponent('LuaViewFacade'), self.elements_ItemTemplate)
				table.insert(self.__elements_POOL, itemView)
				itemViewGO.transform:SetParent(self.elements.transform, false)
				itemViewGO:SetActive(true)
				itemView:Render(viewModel.elements.items[i])
			end
		end
	end
end

return SkillTipView