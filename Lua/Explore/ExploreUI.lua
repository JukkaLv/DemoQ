require 'Advanture.AdvantureGlobalDefines'

local ExploreUI = {}
ExploreUI.__index = ExploreUI

local SWITCH_MODEL = 1
local GOLD_MODEL = 1
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

    GOLD_MODEL = 3
    self:OnClickChangeGoldModel()

    self.playerGo.transform:SetAsLastSibling()
    require('Framework.Timer').Create(0.08, 1, 
    function ()
        self.playerGo.transform.localPosition = self.mapGo[self.nowIndex].transform.localPosition
    end, self):Play()

    GameObject.Find("ChangeModelBtn").transform:GetComponent("Button").onClick:AddListener(function () self:OnClickChangeModel() end)
    GameObject.Find("ResetBtn").transform:GetComponent("Button").onClick:AddListener(function () self:OnClickReset() end)
    GameObject.Find("ChangeGoldBtn").transform:GetComponent("Button").onClick:AddListener(function () self:OnClickChangeGoldModel() end)
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
        self.mapGo[index].transform:Find("BtnMask").gameObject:SetActive(data ~= -1)
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
        item.transform:Find("BtnMask").gameObject:SetActive(false)
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
            item.transform:Find("BtnMask").gameObject:SetActive(false)
        elseif SWITCH_MODEL == 2 then
            local data = self.mapData[index]
            item.transform:Find("BtnMask").gameObject:SetActive(false)
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

    for index, go in ipairs(self.mapGo) do
        go.transform:Find("ShowMask").gameObject:SetActive(true)
    end

    local nowAround = self:GetNowIndexAround()
    for _, index in ipairs(nowAround) do
        self.mapGo[index].transform:Find("ShowMask").gameObject:SetActive(false)
    end
    self.mapGo[self.nowIndex].transform:Find("ShowMask").gameObject:SetActive(false)
end

function ExploreUI:OpenCard(index)
    table.insert(self.mapOpen , index)
    self.mapCanOpen = self:GetMapCanOpen()
    self:PlayOpenCardAnim(index)
end

function ExploreUI:PlayOpenCardAnim(indexList)
    local function anime(index)
        self.mapGo[index].transform:DOLocalRotate(Vector3(0,-90,0) , 0.4)
        require('Framework.Timer').Create(0.4, 1,function ()
            self.mapGo[index].transform.localRotation = Quaternion(0,90,0,90)
            self.mapGo[index].transform:DOLocalRotate(Vector3(0,0,0) , 0.4)
            self:RefreshMap()
        end, self):Play()
    end
    if type(indexList) == "number" then
        anime(indexList)
    else
        for _, index in ipairs(indexList) do
            anime(indexList)
        end
    end
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

function ExploreUI:GetNowIndexAround()
    local tmp = {}
    if self.nowIndex % 7 == 1 then -- 左一列
        table.insert(tmp , self.nowIndex + 1)
        if self.nowIndex - 7 >= 1 then 
            table.insert(tmp , self.nowIndex - 7) 
            table.insert(tmp , self.nowIndex - 6) 
        end
        if self.nowIndex + 7 <= #self.mapData then 
            table.insert(tmp , self.nowIndex + 7) 
            table.insert(tmp , self.nowIndex + 8) 
        end
    elseif self.nowIndex % 7 == 0 then --右一列
        table.insert(tmp , self.nowIndex - 1)
        if self.nowIndex - 7 >= 1 then 
            table.insert(tmp , self.nowIndex - 7) 
            table.insert(tmp , self.nowIndex - 8) 
        end
        if self.nowIndex + 7 <= #self.mapData then 
            table.insert(tmp , self.nowIndex + 7) 
            table.insert(tmp , self.nowIndex + 6) 
        end
    else
        table.insert(tmp , self.nowIndex + 1)
        table.insert(tmp , self.nowIndex - 1)
        if self.nowIndex - 7 >= 1 then 
            table.insert(tmp , self.nowIndex - 7) 
            table.insert(tmp , self.nowIndex - 8) 
            table.insert(tmp , self.nowIndex - 6) 
        end
        if self.nowIndex + 7 <= #self.mapData then 
            table.insert(tmp , self.nowIndex + 7) 
            table.insert(tmp , self.nowIndex + 8) 
            table.insert(tmp , self.nowIndex + 6) 
        end
    end

    return tmp
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
            self:RefreshMap()
        end
        return
    elseif SWITCH_MODEL == 2 then 
        if  self.energy <= 0 then return end
        self:UseEnergy()
        if self:GetIndexIsOpen(index) then
            self:Move(index)
            self.nowIndex = index
            self:SetInputLock(false , 0.5)
            self:RefreshMap()
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
            if GOLD_MODEL == 1 then
                self:ShowHint("获得10金币")
            elseif GOLD_MODEL == 2 then
                local rand = math.random(1,100)
                if rand > 50 then
                    self:ShowHint("获得10金币")
                end
            elseif GOLD_MODEL == 3 then
                local usedEnergy = MAX_ENERGY-self.energy
                local gold = math.floor(10+10^(math.random(0,math.floor(usedEnergy/5*10))/10))
                self:ShowHint("获得".. gold .."金币")
            end
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

function ExploreUI:OnClickChangeGoldModel()
    local text = ""
    if GOLD_MODEL == 1 then
        GOLD_MODEL = 2
        text = "金币50%"
    elseif GOLD_MODEL == 2 then
        GOLD_MODEL = 3
        text = "金币递增"
    elseif GOLD_MODEL == 3 then
        GOLD_MODEL = 1
        text = "金币固定"
    end
    GameObject.Find("ChangeGoldBtn").transform:Find("Text"):GetComponent("Text").text = text
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
