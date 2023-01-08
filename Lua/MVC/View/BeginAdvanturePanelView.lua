-- 本脚本为自动生成，不要手动修改，以免被覆盖
local Notifier = require 'Framework.Notifier'
local BeginAdvanturePanelView = {}
BeginAdvanturePanelView.__index = BeginAdvanturePanelView
BeginAdvanturePanelView.__PREFAB_ASSET = 'Assets/Demo/Resources/UI/PanelView_BeginAdvanture.prefab'
function BeginAdvanturePanelView.Create(facade)
	local copy = {}
	setmetatable(copy, BeginAdvanturePanelView)
	copy:Init(facade)
	return copy
end

function BeginAdvanturePanelView:Init(facade)
	assert(facade ~= nil, 'Error! BeginAdvanturePanelView facade is nil')
	facade:SetComps(self)
	self.viewName = facade.viewName
	self.gameObject = facade.gameObject
	self.transform = facade.transform
	self.btn_slotSkills_OnClick = nil
	self.btn_slotSkills.onClick:AddListener(function() if self.btn_slotSkills_OnClick ~= nil then self.btn_slotSkills_OnClick() end end)
	self.btn_pos1_OnClick = nil
	self.btn_pos1.onClick:AddListener(function() if self.btn_pos1_OnClick ~= nil then self.btn_pos1_OnClick() end end)
	self.btn_pos2_OnClick = nil
	self.btn_pos2.onClick:AddListener(function() if self.btn_pos2_OnClick ~= nil then self.btn_pos2_OnClick() end end)
	self.btn_pos3_OnClick = nil
	self.btn_pos3.onClick:AddListener(function() if self.btn_pos3_OnClick ~= nil then self.btn_pos3_OnClick() end end)
	self.btn_pos4_OnClick = nil
	self.btn_pos4.onClick:AddListener(function() if self.btn_pos4_OnClick ~= nil then self.btn_pos4_OnClick() end end)
	self.btn_go_OnClick = nil
	self.btn_go.onClick:AddListener(function() if self.btn_go_OnClick ~= nil then self.btn_go_OnClick() end end)
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
	end
	if viewModel.btn_pos1 ~= nil then
		if viewModel.btn_pos1.enabled ~= nil then self.btn_pos1.enabled = viewModel.btn_pos1.enabled end
		if viewModel.btn_pos1.interactable ~= nil then self.btn_pos1.interactable = viewModel.btn_pos1.interactable end
	end
	if viewModel.btn_pos2 ~= nil then
		if viewModel.btn_pos2.enabled ~= nil then self.btn_pos2.enabled = viewModel.btn_pos2.enabled end
		if viewModel.btn_pos2.interactable ~= nil then self.btn_pos2.interactable = viewModel.btn_pos2.interactable end
	end
	if viewModel.btn_pos3 ~= nil then
		if viewModel.btn_pos3.enabled ~= nil then self.btn_pos3.enabled = viewModel.btn_pos3.enabled end
		if viewModel.btn_pos3.interactable ~= nil then self.btn_pos3.interactable = viewModel.btn_pos3.interactable end
	end
	if viewModel.btn_pos4 ~= nil then
		if viewModel.btn_pos4.enabled ~= nil then self.btn_pos4.enabled = viewModel.btn_pos4.enabled end
		if viewModel.btn_pos4.interactable ~= nil then self.btn_pos4.interactable = viewModel.btn_pos4.interactable end
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
		if viewModel.bottom.actived ~= nil then self.bottom:SetActive(viewModel.bottom.actived) end
		if viewModel.bottom.position ~= nil then self.bottom.transform.localPosition = viewModel.bottom.position end
		if viewModel.bottom.rotation ~= nil then self.bottom.transform.localRotation = viewModel.bottom.rotation end
		if viewModel.bottom.euler ~= nil then self.bottom.transform.localEulerAngles = viewModel.bottom.euler end
		if viewModel.bottom.scale ~= nil then self.bottom.transform.localScale = viewModel.bottom.scale end
		if viewModel.bottom.parent ~= nil then self.bottom.transform.parent = viewModel.bottom.parent end
	end
	if viewModel.btn_go ~= nil then
		if viewModel.btn_go.enabled ~= nil then self.btn_go.enabled = viewModel.btn_go.enabled end
		if viewModel.btn_go.interactable ~= nil then self.btn_go.interactable = viewModel.btn_go.interactable end
	end
end

return BeginAdvanturePanelView