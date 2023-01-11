-- 本脚本为自动生成，不要手动修改，以免被覆盖
local Notifier = require 'Framework.Notifier'
local ElementView = {}
ElementView.__index = ElementView
ElementView.__PREFAB_ASSET = 'Assets/Demo/Resources/Views/ElementView.prefab'
function ElementView.Create(facade, inherit)
	local copy = {}
	setmetatable(copy, ElementView)
	copy:Init(facade)
	if inherit ~= nil then
	end
	return copy
end

function ElementView:Init(facade)
	assert(facade ~= nil, 'Error! ElementView facade is nil')
	facade:SetComps(self)
	self.viewName = 'ElementView'
	self.viewTblPath = { 'ElementView' }
	self.gameObject = facade.gameObject
	self.transform = facade.transform
end

function ElementView:Open(viewModel)
	assert(self.gameObject ~= nil, 'Error! ElementView has been disposed.')
	Notifier.Dispatch('__OPEN_VIEW_BEFORE', self)
	self.gameObject:SetActive(true)
	if viewModel ~= nil then self:Render(viewModel) end
	Notifier.Dispatch('__OPEN_VIEW_AFTER', self)
end

function ElementView:Close()
	assert(self.gameObject ~= nil, 'Error! ElementView has been disposed.')
	Notifier.Dispatch('__CLOSE_VIEW_BEFORE', self)
	self.gameObject:SetActive(false)
	Notifier.Dispatch('__CLOSE_VIEW_AFTER', self)
end

function ElementView:Dispose()
	assert(self.gameObject ~= nil, 'Error! ElementView has been disposed.')
	GameObject.Destroy(self.gameObject)
	self.gameObject = nil
	self.transform = nil
end

function ElementView:Render(viewModel)
	 if type(viewModel) ~= 'table' then return end
	if viewModel.img_icon ~= nil then
		if viewModel.img_icon.enabled ~= nil then self.img_icon.enabled = viewModel.img_icon.enabled end
		if viewModel.img_icon.color ~= nil then self.img_icon.color = viewModel.img_icon.color end
		if viewModel.img_icon.sprite ~= nil then self.img_icon.sprite = viewModel.img_icon.sprite end
	end
end

return ElementView