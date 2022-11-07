require 'Advanture.AdvantureGlobalDefines'

local ExploreUI = {}
ExploreUI.__index = ExploreUI

local SWITCH_MODEL = 1
local MAX_ENERGY = 40
local INPUT_LOCK = false

--todo 到下一层  触发事件的表现

function ExploreUI.Create()
    assert(exploreuiInst == nil, 'Error! duplicate advanture instance.')
    exploreuiInst = {}
    setmetatable(exploreuiInst, ExploreUI)
    exploreuiInst:Init()
    return exploreuiInst
end

function ExploreUI:Init()
    self.mapConfig = require('Explore.Map') -- 初始化游戏配置
    self.cardParentGo = GameObject.Find("Card")
    self.cardGo = self.cardParentGo.transform:Find("Model").gameObject
    self.energyText = GameObject.Find("Energy/Value"):GetComponent("Text")
    self.energyImage = GameObject.Find("Energy/Image"):GetComponent("Image")
    self.playerGo = GameObject.Find("Player").gameObject
    self.ShowText = GameObject.Find("ShowText"):GetComponent("Text")
    self.ShowText.gameObject:SetActive(false)
    self.cardGo:SetActive(false)

    self.nowLayer = 1
    self.nowIndex = 0
    self.energy = MAX_ENERGY
    self.mapGo = {}
    self.mapData = {}
    self.mapOpen = {}
    self.mapCanOpen = {}
    self:InitMap()
    self:RefreshEnergy()

    self.playerGo.transform:SetAsLastSibling()
    require('Framework.Timer').Create(0.08, 1, 
    function ()
        self.playerGo.transform.localPosition = self.mapGo[self.nowIndex].transform.localPosition
    end, self):Play()

    GameObject.Find("ChangeModelBtn").transform:GetComponent("Button").onClick:AddListener(function () self:OnClickChangeModel() end)
    GameObject.Find("ResetBtn").transform:GetComponent("Button").onClick:AddListener(function () self:OnClickReset() end)
end

function ExploreUI:InitMap()
    local config = self.mapConfig[self.nowLayer]
    if config == nil then return end

    for index, value in ipairs(config) do
        table.insert(self.mapData , value)
    end
    -- for index, value in ipairs(config) do
    --     local i = math.ceil(index/7)
    --     local j = i==1 and index or index % 7 
    --     if self.map[i] == nil then self.map[i] = {} end
    --     self.map[i][j] = value
    -- end

    for index, data in ipairs(self.mapData) do
        if self.mapGo[index] == nil then
            self.mapGo[index] = self:CreateObject(self.cardGo.gameObject)
            self.mapGo[index].name = "Model" .. index
            self:SetParent(self.mapGo[index].transform , self.cardParentGo.transform)
        end
        self.mapGo[index].transform:Find("Back").gameObject:SetActive(data ~= -1)
        self.mapGo[index].transform:Find("Button").gameObject:SetActive(data ~= -1)
        self.mapGo[index].transform:Find("Mask").gameObject:SetActive(data ~= -1)
        self.mapGo[index].transform:Find("Gold").gameObject:SetActive(false)
        self.mapGo[index].transform:Find("Reward").gameObject:SetActive(false)
        self.mapGo[index].transform:Find("Enemy").gameObject:SetActive(false)
        self.mapGo[index].transform:Find("Boss").gameObject:SetActive(false)
        self.mapGo[index].transform:Find("Begin").gameObject:SetActive(false)
        self.mapGo[index].transform:Find("Transfer").gameObject:SetActive(false)
        self.mapGo[index].transform:Find("Opened").gameObject:SetActive(false)        
        self.mapGo[index].transform:Find("Button"):GetComponent("Button").onClick:RemoveAllListeners()
        self.mapGo[index].transform:Find("Button"):GetComponent("Button").onClick:AddListener(function () self:OnClickCard(index) end)

        if data == 0 then
            self.nowIndex = index
        end
    end
    self:OpenCard(self.nowIndex)
    self:Move(self.nowIndex , false)
end

function ExploreUI:CreateObject(model)
    local go = Object.Instantiate(model)
    go:SetActive(true)
    return go
end

function ExploreUI:SetParent(trans , parent)
    trans:SetParent(parent)
    trans.localScale = Vector3.one
    trans.localRotation = Quaternion.identity
    trans.localPosition = Vector3.zero
end

function ExploreUI:RefreshMap()
    -- 刷新显示
    for _, index in ipairs(self.mapOpen) do
        local data = self.mapData[index]
        local item = self.mapGo[index]
        item.transform:Find("Mask").gameObject:SetActive(false)
        item.transform:Find("Opened").gameObject:SetActive(SWITCH_MODEL == 2)
        if data == 0 then
            item.transform:Find("Begin").gameObject:SetActive(true)
        elseif data == 1 then
            item.transform:Find("Transfer").gameObject:SetActive(true)
        elseif data == 2 then
            item.transform:Find("Gold").gameObject:SetActive(true)
        elseif data == 3 then
            item.transform:Find("Reward").gameObject:SetActive(true)
        elseif data == 4 then
            item.transform:Find("Enemy").gameObject:SetActive(true)
        elseif data == 5 then
            item.transform:Find("Boss").gameObject:SetActive(true)
        end
    end
    
    for _, index in ipairs(self.mapCanOpen) do
        local item = self.mapGo[index]
        if SWITCH_MODEL == 1 then
            item.transform:Find("Mask").gameObject:SetActive(false)
        elseif SWITCH_MODEL == 2 then
            local data = self.mapData[index]
            item.transform:Find("Mask").gameObject:SetActive(false)
            if data == 0 then
                item.transform:Find("Begin").gameObject:SetActive(true)
            elseif data == 1 then
                item.transform:Find("Transfer").gameObject:SetActive(true)
            elseif data == 2 then
                item.transform:Find("Gold").gameObject:SetActive(true)
            elseif data == 3 then
                item.transform:Find("Reward").gameObject:SetActive(true)
            elseif data == 4 then
                item.transform:Find("Enemy").gameObject:SetActive(true)
            elseif data == 5 then
                item.transform:Find("Boss").gameObject:SetActive(true)
            end
        end
    end
end

function ExploreUI:OpenCard(index)
    table.insert(self.mapOpen , index)
    -- 可以翻开的卡牌
    self.mapCanOpen = self:GetMapCanOpen()
    self:RefreshMap()    
end

function ExploreUI:GetMapCanOpen()
    local canOpenCard = {}
    for _, index in ipairs(self.mapOpen) do
        if index % 7 == 1 then -- 左一列
            table.insert(canOpenCard , index + 1)
        elseif index % 7 == 0 then --右一列
            table.insert(canOpenCard , index - 1)
        else
            table.insert(canOpenCard , index + 1)
            table.insert(canOpenCard , index - 1)
        end

        if index - 7 >= 1 then table.insert(canOpenCard , index - 7) end
        if index + 7 <= #self.mapData then table.insert(canOpenCard , index + 7) end
    end

    --去重、去掉已经开启的
    local tmp = {}
    for _, index in ipairs(canOpenCard) do
        tmp[index] = 1
    end
    for _, index in ipairs(self.mapOpen) do
        if tmp[index] == 1 then
            tmp[index] = nil
        end
    end

    canOpenCard = {}
    for index, _ in pairs(tmp) do
        table.insert(canOpenCard , index)
    end

    return canOpenCard
end

function ExploreUI:OnClickCard(index)
    if INPUT_LOCK then return end
    self:SetInputLock(true)
    if SWITCH_MODEL == 1 then
        if not self:GetIndexIsOpen(index) then
            if  self.energy <= 0 then return end
            self.nowIndex = index
            self:UseEnergy()
            self:OpenCard(index)
            self:PlayOpenAnime(index)
            self:Move(index)
            self:SetInputLock(false , 1)
        else
            self.nowIndex = index
            self:Move(index)
            self:SetInputLock(false , 0.5)
        end
        return
    elseif SWITCH_MODEL == 2 then 
        if  self.energy <= 0 then return end
        self:UseEnergy()
        if self:GetIndexIsOpen(index) then
            self:Move(index)
            self.nowIndex = index
            self:SetInputLock(false , 0.5)
            return
        end
        if self:GetIndexIsCanOpen(index) then
            self:Move(index)
            self.nowIndex = index
            self:OpenCard(index)
            self:PlayOpenAnime(index)
            self:SetInputLock(false , 1)
            return
        end
    end
    self:SetInputLock(false)
end

function ExploreUI:SetInputLock(lock , time)
    time = time == nil and 0 or time
    require('Framework.Timer').Create(time, 1, 
    function ()
        INPUT_LOCK =lock
    end, self):Play()
end

function ExploreUI:PlayOpenAnime(index)
    require('Framework.Timer').Create(0.5, 1, 
    function ()
        local data = self.mapData[index]
        local item = self.mapGo[index]
        if data == 0 then
            
        elseif data == 1 then
            self:NextLayer()
        elseif data == 2 then
            self:ShowHint("一些金币")
        elseif data == 3 then
            self:ShowHint("发现宝箱")
        elseif data == 4 then
            self:ShowHint("遇到敌人")
        elseif data == 5 then
            self:ShowHint("遇到Boss")
        end
    end, self):Play()    
end

function ExploreUI:ShowHint(text)
    self.ShowText.text = text
    self.ShowText.gameObject:SetActive(true)
    require('Framework.Timer').Create(0.5, 1, function ()
        self.ShowText.gameObject:SetActive(false)
    end, self):Play()    
end

function ExploreUI:Move(index , palyAnime)
    palyAnime = palyAnime == nil and true or palyAnime
    -- 移动
    local row = index % 7 == 0 and 7 or index % 7
    local line = math.floor((index-1)/7)
    local x = -(row-4)*300
    local y = 350*line -1200
    local z = y + 500
    self.cardParentGo.transform.localPosition = Vector3( x, y , z)

    if palyAnime then
        self.playerGo.transform:DOLocalMove(self.mapGo[index].transform.localPosition , 0.5)
    end
end

function ExploreUI:UseEnergy()
    self.energy = self.energy - 1
    self:RefreshEnergy()
end

function ExploreUI:RefreshEnergy()
    self.energyText.text = "体力： ".. self.energy .."/" .. MAX_ENERGY
    self.energyImage.fillAmount = self.energy / MAX_ENERGY
end

function ExploreUI:OnClickChangeModel()
    SWITCH_MODEL = SWITCH_MODEL == 1 and  2 or 1
    GameObject.Find("ChangeModelBtn").transform:Find("Text"):GetComponent("Text").text = "方式" .. SWITCH_MODEL
    self:OnClickReset()
end

function ExploreUI:OnClickReset()
    self.nowLayer = 1
    self.nowIndex = 0
    self.energy = MAX_ENERGY
    self.mapData = {}
    self.mapOpen = {}
    self:InitMap()
    self:RefreshEnergy()
    self.playerGo.transform.localPosition = self.mapGo[self.nowIndex].transform.localPosition
end

function ExploreUI:GetIndexIsOpen(index)
    for _, i in ipairs(self.mapOpen) do
        if i == index then
            return true
        end
    end
    return false
end

function ExploreUI:GetIndexIsCanOpen(index)
    for _, i in ipairs(self.mapCanOpen) do
        if i == index then
            return true
        end
    end
    return false
end

function ExploreUI:NextLayer()
    self.nowLayer = self.nowLayer + 1
    self.nowIndex = 0
    self.energy = MAX_ENERGY
    self.mapData = {}
    self.mapOpen = {}
    self:InitMap()
    self:RefreshEnergy()
    require('Framework.Timer').Create(0.08, 1, 
    function ()
        self.playerGo.transform.localPosition = self.mapGo[self.nowIndex].transform.localPosition
    end, self):Play()
end

return ExploreUI
