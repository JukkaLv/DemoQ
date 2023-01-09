-- 本脚本为自动生成，不要手动修改，以免被覆盖
local Notifier = require 'Framework.Notifier'
local BeginAdvanturePanelView = {}
BeginAdvanturePanelView.__index = BeginAdvanturePanelView
BeginAdvanturePanelView.__PREFAB_ASSET = 'Assets/Demo/Resources/UI/PanelView_BeginAdvanture.prefab'
function BeginAdvanturePanelView.Create(facade, inherit)
	local copy = {}
	setmetatable(copy, BeginAdvanturePanelView)
	copy:Init(facade)
	if inherit ~= nil then
		copy.bottom_ItemTemplate = inherit.bottom_ItemTemplate
	end
	return copy
end

function BeginAdvanturePanelView:Init(facade)
	assert(facade ~= nil, 'Error! BeginAdvanturePanelView facade is nil')
	facade:SetComps(self)
	self.viewName = facade.viewName
	self.gameObject = facade.gameObject
	self.transform = facade.transform
	self.btn_slotSkills_OnClick = nil
	self.btn_slotSkills_OnClickNoti = nil
	self.btn_slotSkills.onClick:AddListener(function()
		if self.btn_slotSkills_OnClick ~= nil then self.btn_slotSkills_OnClick() end
		if self.btn_slotSkills_OnClickNoti ~= nil and self.btn_slotSkills_OnClickNoti.name ~= nil then Notifier.Dispatch(self.btn_slotSkills_OnClickNoti.name, self.btn_slotSkills_OnClickNoti.body) end 
	end)
	self.btn_pos1_OnClick = nil
	self.btn_pos1_OnClickNoti = nil
	self.btn_pos1.onClick:AddListener(function()
		if self.btn_pos1_OnClick ~= nil then self.btn_pos1_OnClick() end
		if self.btn_pos1_OnClickNoti ~= nil and self.btn_pos1_OnClickNoti.name ~= nil then Notifier.Dispatch(self.btn_pos1_OnClickNoti.name, self.btn_pos1_OnClickNoti.body) end 
	end)
	self.btn_pos2_OnClick = nil
	self.btn_pos2_OnClickNoti = nil
	self.btn_pos2.onClick:AddListener(function()
		if self.btn_pos2_OnClick ~= nil then self.btn_pos2_OnClick() end
		if self.btn_pos2_OnClickNoti ~= nil and self.btn_pos2_OnClickNoti.name ~= nil then Notifier.Dispatch(self.btn_pos2_OnClickNoti.name, self.btn_pos2_OnClickNoti.body) end 
	end)
	self.btn_pos3_OnClick = nil
	self.btn_pos3_OnClickNoti = nil
	self.btn_pos3.onClick:AddListener(function()
		if self.btn_pos3_OnClick ~= nil then self.btn_pos3_OnClick() end
		if self.btn_pos3_OnClickNoti ~= nil and self.btn_pos3_OnClickNoti.name ~= nil then Notifier.Dispatch(self.btn_pos3_OnClickNoti.name, self.btn_pos3_OnClickNoti.body) end 
	end)
	self.btn_pos4_OnClick = nil
	self.btn_pos4_OnClickNoti = nil
	self.btn_pos4.onClick:AddListener(function()
		if self.btn_pos4_OnClick ~= nil then self.btn_pos4_OnClick() end
		if self.btn_pos4_OnClickNoti ~= nil and self.btn_pos4_OnClickNoti.name ~= nil then Notifier.Dispatch(self.btn_pos4_OnClickNoti.name, self.btn_pos4_OnClickNoti.body) end 
	end)
	self.bottom_ItemTemplate = nil
	self.__bottom_POOL = {}
	self.btn_go_OnClick = nil
	self.btn_go_OnClickNoti = nil
	self.btn_go.onClick:AddListener(function()
		if self.btn_go_OnClick ~= nil then self.btn_go_OnClick() end
		if self.btn_go_OnClickNoti ~= nil and self.btn_go_OnClickNoti.name ~= nil then Notifier.Dispatch(self.btn_go_OnClickNoti.name, self.btn_go_OnClickNoti.body) end 
	end)
end

function BeginAdvanturePanelView:Open(viewModel)
	assert(self.gameObject ~= nil, 'Error! BeginAdvanturePanelView has been disposed.')
	Notifier.Dispatch('__OPEN_VIEW_BEFORE', self)
	self.gameObject:SetActive(true)
	if viewModel ~= nil then self:Render(viewModel) end
	Notifier.Dispatch('__OPEN_VIEW_AFTER', self)
end

function BeginAdvanturePanelView:Close()
	assert(self.gameObject ~= nil, 'Error! BeginAdvanturePanelView has been disposed.')
	Notifier.Dispatch('__CLOSE_VIEW_BEFORE', self)
	self.gameObject:SetActive(false)
	Notifier.Dispatch('__CLOSE_VIEW_AFTER', self)
end

function BeginAdvanturePanelView:Dispose()
	assert(self.gameObject ~= nil, 'Error! BeginAdvanturePanelView has been disposed.')
	GameObject.Destroy(self.gameObject)
	self.gameObject = nil
	self.transform = nil
end

function BeginAdvanturePanelView:Render(viewModel)
	assert(viewModel ~= nil, 'Error! BeginAdvanturePanelView view model is nil')
	if viewModel.btn_slotSkills ~= nil then
		if viewModel.btn_slotSkills.enabled ~= nil then self.btn_slotSkills.enabled = viewModel.btn_slotSkills.enabled end
		if viewModel.btn_slotSkills.interactable ~= nil then self.btn_slotSkills.interactable = viewModel.btn_slotSkills.interactable end
		if viewModel.btn_slotSkills.OnClickNoti ~= nil then self.btn_slotSkills_OnClickNoti = viewModel.btn_slotSkills.OnClickNoti end
	end
	if viewModel.btn_pos1 ~= nil then
		if viewModel.btn_pos1.enabled ~= nil then self.btn_pos1.enabled = viewModel.btn_pos1.enabled end
		if viewModel.btn_pos1.interactable ~= nil then self.btn_pos1.interactable = viewModel.btn_pos1.interactable end
		if viewModel.btn_pos1.OnClickNoti ~= nil then self.btn_pos1_OnClickNoti = viewModel.btn_pos1.OnClickNoti end
	end
	if viewModel.btn_pos2 ~= nil then
		if viewModel.btn_pos2.enabled ~= nil then self.btn_pos2.enabled = viewModel.btn_pos2.enabled end
		if viewModel.btn_pos2.interactable ~= nil then self.btn_pos2.interactable = viewModel.btn_pos2.interactable end
		if viewModel.btn_pos2.OnClickNoti ~= nil then self.btn_pos2_OnClickNoti = viewModel.btn_pos2.OnClickNoti end
	end
	if viewModel.btn_pos3 ~= nil then
		if viewModel.btn_pos3.enabled ~= nil then self.btn_pos3.enabled = viewModel.btn_pos3.enabled end
		if viewModel.btn_pos3.interactable ~= nil then self.btn_pos3.interactable = viewModel.btn_pos3.interactable end
		if viewModel.btn_pos3.OnClickNoti ~= nil then self.btn_pos3_OnClickNoti = viewModel.btn_pos3.OnClickNoti end
	end
	if viewModel.btn_pos4 ~= nil then
		if viewModel.btn_pos4.enabled ~= nil then self.btn_pos4.enabled = viewModel.btn_pos4.enabled end
		if viewModel.btn_pos4.interactable ~= nil then self.btn_pos4.interactable = viewModel.btn_pos4.interactable end
		if viewModel.btn_pos4.OnClickNoti ~= nil then self.btn_pos4_OnClickNoti = viewModel.btn_pos4.OnClickNoti end
	end
	if viewModel.img_role_1 ~= nil then
		if viewModel.img_role_1.enabled ~= nil then self.img_role_1.enabled = viewModel.img_role_1.enabled end
		if viewModel.img_role_1.color ~= nil then self.img_role_1.color = viewModel.img_role_1.color end
		if viewModel.img_role_1.sprite ~= nil then self.img_role_1.sprite = viewModel.img_role_1.sprite end
	end
	if viewModel.img_role_2 ~= nil then
		if viewModel.img_role_2.enabled ~= nil then self.img_role_2.enabled = viewModel.img_role_2.enabled end
		if viewModel.img_role_2.color ~= nil then self.img_role_2.color = viewModel.img_role_2.color end
		if viewModel.img_role_2.sprite ~= nil then self.img_role_2.sprite = viewModel.img_role_2.sprite end
	end
	if viewModel.img_role_3 ~= nil then
		if viewModel.img_role_3.enabled ~= nil then self.img_role_3.enabled = viewModel.img_role_3.enabled end
		if viewModel.img_role_3.color ~= nil then self.img_role_3.color = viewModel.img_role_3.color end
		if viewModel.img_role_3.sprite ~= nil then self.img_role_3.sprite = viewModel.img_role_3.sprite end
	end
	if viewModel.img_role_4 ~= nil then
		if viewModel.img_role_4.enabled ~= nil then self.img_role_4.enabled = viewModel.img_role_4.enabled end
		if viewModel.img_role_4.color ~= nil then self.img_role_4.color = viewModel.img_role_4.color end
		if viewModel.img_role_4.sprite ~= nil then self.img_role_4.sprite = viewModel.img_role_4.sprite end
	end
	if viewModel.bottom ~= nil then
		if viewModel.bottom.items ~= nil then
			assert(self.bottom_ItemTemplate ~= nil, 'BeginAdvanturePanelView.bottom item template is nil')
			local minLen = math.min(#self.__bottom_POOL, #viewModel.bottom.items)
			for i=1,minLen do
				self.__bottom_POOL[i].gameObject:SetActive(true)
				self.__bottom_POOL[i]:Render(viewModel.bottom.items[i])
			end
			for i=minLen+1,#self.__bottom_POOL do
				self.__bottom_POOL[i].gameObject:SetActive(false)
			end
			for i=minLen+1,#viewModel.bottom.items do
				local ITEM_VIEW = require('MVC.View.'..self.bottom_ItemTemplate.viewName)
				local itemViewGO = GameObject.Instantiate(self.bottom_ItemTemplate.gameObject, Vector3.zero, Quaternion.identity, self.bottom.transform)
				local itemView = ITEM_VIEW.Create(itemViewGO:GetComponent('LuaViewFacade'), self.bottom_ItemTemplate)
				table.insert(self.__bottom_POOL, itemView)
				itemViewGO.transform:SetParent(self.bottom.transform, false)
				itemViewGO:SetActive(true)
				itemView:Render(viewModel.bottom.items[i])
			end
		end
	end
	if viewModel.btn_go ~= nil then
		if viewModel.btn_go.enabled ~= nil then self.btn_go.enabled = viewModel.btn_go.enabled end
		if viewModel.btn_go.interactable ~= nil then self.btn_go.interactable = viewModel.btn_go.interactable end
		if viewModel.btn_go.OnClickNoti ~= nil then self.btn_go_OnClickNoti = viewModel.btn_go.OnClickNoti end
	end
	if viewModel.label_1 ~= nil then
		if viewModel.label_1.enabled ~= nil then self.label_1.enabled = viewModel.label_1.enabled end
		if viewModel.label_1.text ~= nil then self.label_1.text = viewModel.label_1.text end
		if viewModel.label_1.color ~= nil then self.label_1.color = viewModel.label_1.color end
	end
	if viewModel.label_2 ~= nil then
		if viewModel.label_2.enabled ~= nil then self.label_2.enabled = viewModel.label_2.enabled end
		if viewModel.label_2.text ~= nil then self.label_2.text = viewModel.label_2.text end
		if viewModel.label_2.color ~= nil then self.label_2.color = viewModel.label_2.color end
	end
	if viewModel.label_3 ~= nil then
		if viewModel.label_3.enabled ~= nil then self.label_3.enabled = viewModel.label_3.enabled end
		if viewModel.label_3.text ~= nil then self.label_3.text = viewModel.label_3.text end
		if viewModel.label_3.color ~= nil then self.label_3.color = viewModel.label_3.color end
	end
	if viewModel.label_4 ~= nil then
		if viewModel.label_4.enabled ~= nil then self.label_4.enabled = viewModel.label_4.enabled end
		if viewModel.label_4.text ~= nil then self.label_4.text = viewModel.label_4.text end
		if viewModel.label_4.color ~= nil then self.label_4.color = viewModel.label_4.color end
	end
end

return BeginAdvanturePanelView