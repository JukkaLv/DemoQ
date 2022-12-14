_ENV = _G._ENV_ADVANTURE

local ActorRenderer = {}
ActorRenderer.__index = ActorRenderer

function ActorRenderer.Create(id, prefab, size)
    local copy = {}
    setmetatable(copy, ActorRenderer)
    copy:Init(id, prefab, size)
    return copy
end

function ActorRenderer:Init(id, prefab, size)
    self.id = id
    self.size = size
    self.rawAsset = Resources.Load("Actors/"..prefab)
    self.gameObject = GameObject.Instantiate(self.rawAsset, WORLD_ROOT)
    self.gameObject.name = "actor_"..id
    self.transform = self.gameObject.transform
    self.spriteRenderer = self.gameObject:GetComponentInChildren(typeof(SpriteRenderer))
    self.spriteRenderer.flipX = false
    self.eventTrigger = self.gameObject:GetComponentInChildren(typeof(CS.SpriteRendererEventTrigger))

    self.hpBar = {}
    self.hpBar.go = GameObject.Instantiate(Resources.Load("UI/hpBar"), WORLD_CANVAS)
    self.hpBar.front = self.hpBar.go.transform:Find("front")
    self.hpBar.middle = self.hpBar.go.transform:Find("middle")
    self.hpBar.go.name = "hpBar_"..id
    self.hpBar.go:SetActive(false)
    local hpBarSize = self.hpBar.go.transform.sizeDelta
    hpBarSize.x = hpBarSize.x * self.size
    self.hpBar.go.transform.sizeDelta = hpBarSize

    self.bufflayout = {}
    self.bufflayout.go = GameObject.Instantiate(Resources.Load("UI/bufflayout"), WORLD_CANVAS)
    self.bufflayout.go.name = "buffLayout_"..id
    self.bufflayout.template = self.bufflayout.go.transform:Find("img_icon").gameObject
    self.bufflayout.template:SetActive(false)
    self.bufflayout.icons = {}  -- 正在显示的buff icon, key:iconPath  value:iconTbl {img=ImageComp, count=计数}
    self.bufflayout.pool = { {img=self.bufflayout.template:GetComponent("Image"), count=0} }  -- 池中待用的buffTbl
end

function ActorRenderer:Dispose()
    self.eventTrigger.pointClickCallback = nil -- 先清理event回调，否则如果将来是资源回池的话会有问题
    GameObject.Destroy(self.hpBar.go)
    self.hpBar = nil
    GameObject.Destroy(self.bufflayout.go)
    self.bufflayout = nil
    GameObject.Destroy(self.gameObject) -- Demo先直接销毁掉
    self.gameObject = nil
    self.rawAsset = nil
    self.transform = nil
    self.spriteRenderer = nil
    self.eventTrigger = nil
end

function ActorRenderer:SetPosition(position)
    self.transform.localPosition = position
    self.hpBar.go.transform.localPosition = position + Vector3(0, -0.25, 0)
    self.bufflayout.go.transform.localPosition = position + Vector3(0, 0.1, 0)
end

-- 规范所有角色资源默认超右
function ActorRenderer:TurnFace(dir)
    self.spriteRenderer.flipX = dir < 0
end

function ActorRenderer:SetSortOrder(order)
    self.spriteRenderer.sortingOrder = order
end

function ActorRenderer:AddPointClick(callback)
    if self.eventTrigger.pointClickCallback == nil then self.eventTrigger.pointClickCallback = callback
    else self.eventTrigger.pointClickCallback = self.eventTrigger.pointClickCallback + callback end
end

function ActorRenderer:RemovePointClick(callback)
    if self.eventTrigger.pointClickCallback == nil then return end
    self.eventTrigger.pointClickCallback = self.eventTrigger.pointClickCallback - callback
end

function ActorRenderer:Clone()
    local clone = {}
    clone.gameObject = GameObject.Instantiate(self.rawAsset, WORLD_ROOT)
    clone.gameObject.name = self.gameObject.name.."_clone"
    clone.transform = clone.gameObject.transform
    clone.spriteRenderer = clone.gameObject:GetComponentInChildren(typeof(SpriteRenderer))
    clone.spriteRenderer.flipX = false
end

function ActorRenderer:SetHpBarVisible(visible)
    self.hpBar.go:SetActive(visible)
end

function ActorRenderer:SyncHpBar(hpPercent)
    if self.hpBar.tween ~= nil then DOTween.Kill(self.hpBar.tween) end
    if hpPercent < self.hpBar.front.localScale.x then
        self.hpBar.front.localScale = Vector3(hpPercent, 1, 1)
        self.hpBar.tween = self.hpBar.middle:DOScale(Vector3(hpPercent, 1, 1), 0.25)
    else
        self.hpBar.middle.localScale = Vector3(hpPercent, 1, 1)
        self.hpBar.tween = self.hpBar.front:DOScale(Vector3(hpPercent, 1, 1), 0.25)
    end
end

function ActorRenderer:AddBuffIcon(iconPath)
    if iconPath == nil or iconPath == '' then return end

    local iconTbl = self.bufflayout.icons[iconPath]
    if iconTbl == nil then
        if #self.bufflayout.pool > 0 then
            iconTbl = self.bufflayout.pool[1]
            table.remove(self.bufflayout.pool, 1)
        else
            iconTbl = {img=nil, count=0}
            iconTbl.img = GameObject.Instantiate(self.bufflayout.template, Vector3.zero, Quaternion.identity, self.bufflayout.template.transform.parent):GetComponent("Image")
        end
        iconTbl.img.gameObject:SetActive(true)
        iconTbl.img.sprite = Resources.Load(iconPath, typeof(Sprite))
        iconTbl.count = 1
        self.bufflayout.icons[iconPath] = iconTbl
    else
        iconTbl.count = iconTbl.count + 1
    end
end

function ActorRenderer:RemoveBuffIcon(iconPath)
    if iconPath == nil or iconPath == '' then return end
    
    local iconTbl = self.bufflayout.icons[iconPath]
    if iconTbl ~= nil then
        iconTbl.count = iconTbl.count - 1
        if iconTbl.count == 0 then
            iconTbl.img.gameObject:SetActive(false)
            table.insert(self.bufflayout.pool, iconTbl)
            self.bufflayout.icons[iconPath] = nil
        end
    end
end

return ActorRenderer