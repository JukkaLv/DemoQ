-- 本脚本为自动生成，不要手动修改，以免被覆盖
local Notifier = require 'Framework.Notifier'
local SelectHeroItemView = {}
SelectHeroItemView.__index = SelectHeroItemView
SelectHeroItemView.__PREFAB_ASSET = 'Assets/Demo/Resources/Views/SelectHeroItemView.prefab'

function SelectHeroItemView.Create(facade, inherit)
	local copy = {}
	setmetatable(copy, SelectHeroItemView)
	copy:Init(facade)
	if inherit ~= nil then
	end
	return copy
end

function SelectHeroItemView:Init(facade)
	assert(facade ~= nil, 'Error! SelectHeroItemView facade is nil')
	facade:SetComps(self)
	self.viewName = 'SelectHeroItemView'
	self.viewTblPath = { 'SelectHeroItemView' }
	self.gameObject = facade.gameObject
	self.transform = facade.transform
	self.btn_root_OnClick = nil
	self.btn_root_OnClickNoti = nil
	self.btn_root.onClick:AddListener(function()
		if self.btn_root_OnClick ~= nil then self.btn_root_OnClick() end
		if self.btn_root_OnClickNoti ~= nil and self.btn_root_OnClickNoti.name ~= nil then Notifier.Dispatch(self.btn_root_OnClickNoti.name, self.btn_root_OnClickNoti.body) end 
	end)
	self.btn_skill_1_OnClick = nil
	self.btn_skill_1_OnClickNoti = nil
	self.btn_skill_1.onClick:AddListener(function()
		if self.btn_skill_1_OnClick ~= nil then self.btn_skill_1_OnClick() end
		if self.btn_skill_1_OnClickNoti ~= nil and self.btn_skill_1_OnClickNoti.name ~= nil then Notifier.Dispatch(self.btn_skill_1_OnClickNoti.name, self.btn_skill_1_OnClickNoti.body) end 
	end)
	self.btn_skill_2_OnClick = nil
	self.btn_skill_2_OnClickNoti = nil
	self.btn_skill_2.onClick:AddListener(function()
		if self.btn_skill_2_OnClick ~= nil then self.btn_skill_2_OnClick() end
		if self.btn_skill_2_OnClickNoti ~= nil and self.btn_skill_2_OnClickNoti.name ~= nil then Notifier.Dispatch(self.btn_skill_2_OnClickNoti.name, self.btn_skill_2_OnClickNoti.body) end 
	end)
end

function SelectHeroItemView:Render(viewModel)
	 if type(viewModel) ~= 'table' then return end
	if viewModel.btn_root ~= nil then
		if viewModel.btn_root.enabled ~= nil then self.btn_root.enabled = viewModel.btn_root.enabled end
		if viewModel.btn_root.interactable ~= nil then self.btn_root.interactable = viewModel.btn_root.interactable end
		if viewModel.btn_root.OnClickNoti ~= nil then self.btn_root_OnClickNoti = viewModel.btn_root.OnClickNoti end
	end
	if viewModel.txt_name ~= nil then
		if viewModel.txt_name.enabled ~= nil then self.txt_name.enabled = viewModel.txt_name.enabled end
		if viewModel.txt_name.text ~= nil then self.txt_name.text = viewModel.txt_name.text end
		if viewModel.txt_name.color ~= nil then self.txt_name.color = viewModel.txt_name.color end
	end
	if viewModel.txt_hp ~= nil then
		if viewModel.txt_hp.enabled ~= nil then self.txt_hp.enabled = viewModel.txt_hp.enabled end
		if viewModel.txt_hp.text ~= nil then self.txt_hp.text = viewModel.txt_hp.text end
		if viewModel.txt_hp.color ~= nil then self.txt_hp.color = viewModel.txt_hp.color end
	end
	if viewModel.txt_spd ~= nil then
		if viewModel.txt_spd.enabled ~= nil then self.txt_spd.enabled = viewModel.txt_spd.enabled end
		if viewModel.txt_spd.text ~= nil then self.txt_spd.text = viewModel.txt_spd.text end
		if viewModel.txt_spd.color ~= nil then self.txt_spd.color = viewModel.txt_spd.color end
	end
	if viewModel.img_element ~= nil then
		if viewModel.img_element.enabled ~= nil then self.img_element.enabled = viewModel.img_element.enabled end
		if viewModel.img_element.color ~= nil then self.img_element.color = viewModel.img_element.color end
		if viewModel.img_element.sprite ~= nil then self.img_element.sprite = viewModel.img_element.sprite end
	end
	if viewModel.btn_skill_1 ~= nil then
		if viewModel.btn_skill_1.enabled ~= nil then self.btn_skill_1.enabled = viewModel.btn_skill_1.enabled end
		if viewModel.btn_skill_1.interactable ~= nil then self.btn_skill_1.interactable = viewModel.btn_skill_1.interactable end
		if viewModel.btn_skill_1.OnClickNoti ~= nil then self.btn_skill_1_OnClickNoti = viewModel.btn_skill_1.OnClickNoti end
	end
	if viewModel.btn_skill_2 ~= nil then
		if viewModel.btn_skill_2.enabled ~= nil then self.btn_skill_2.enabled = viewModel.btn_skill_2.enabled end
		if viewModel.btn_skill_2.interactable ~= nil then self.btn_skill_2.interactable = viewModel.btn_skill_2.interactable end
		if viewModel.btn_skill_2.OnClickNoti ~= nil then self.btn_skill_2_OnClickNoti = viewModel.btn_skill_2.OnClickNoti end
	end
	if viewModel.txt_skill_1 ~= nil then
		if viewModel.txt_skill_1.enabled ~= nil then self.txt_skill_1.enabled = viewModel.txt_skill_1.enabled end
		if viewModel.txt_skill_1.text ~= nil then self.txt_skill_1.text = viewModel.txt_skill_1.text end
		if viewModel.txt_skill_1.color ~= nil then self.txt_skill_1.color = viewModel.txt_skill_1.color end
	end
	if viewModel.txt_skill_2 ~= nil then
		if viewModel.txt_skill_2.enabled ~= nil then self.txt_skill_2.enabled = viewModel.txt_skill_2.enabled end
		if viewModel.txt_skill_2.text ~= nil then self.txt_skill_2.text = viewModel.txt_skill_2.text end
		if viewModel.txt_skill_2.color ~= nil then self.txt_skill_2.color = viewModel.txt_skill_2.color end
	end
	if viewModel.img_check ~= nil then
		if viewModel.img_check.enabled ~= nil then self.img_check.enabled = viewModel.img_check.enabled end
		if viewModel.img_check.color ~= nil then self.img_check.color = viewModel.img_check.color end
		if viewModel.img_check.sprite ~= nil then self.img_check.sprite = viewModel.img_check.sprite end
	end
end

return SelectHeroItemView