CatBowlView = {}
local self = CatBowlView

function CatBowlView.Start( ... )
    -- body
    self.btn_quit:GetComponent("Button").onClick:RemoveAllListeners()
    self.btn_quit:GetComponent("Button").onClick:AddListener(self.Quit)
    self.item_water:GetComponent("Button").onClick:RemoveAllListeners()
    self.item_water:GetComponent("Button").onClick:AddListener(self.OnClickAddWater)

    self.Init()
end



function CatBowlView.Update( ... )
    -- body
end


function CatBowlView.OnDestroy( ... )
    -- body
end


function CatBowlView.Init()
    self.ShowCatBowlModule(playerData.userTools.catBowl)
    self.ShowCatWaterModule(playerData.userTools.catWater)
    self.SendMsgGetCatFoodWareHouseReq()
end

function CatBowlView.ShowCatBowlModule( CatBowlModule )
    -- body
    self.text_food_level:GetComponent("TextMeshProUGUI").text = "Lv."..CatBowlModule.toolLevel
    self.text_progress_food_num:GetComponent("TextMeshProUGUI").text = CatBowlModule.surplusVolume.."/"..CatBowlModule.sumVolume
    local num = CatBowlModule.surplusVolume/CatBowlModule.sumVolume
    self.progress_food:GetComponent("Slider").value = num
    if(num > 0) then
        self.icon_food_1:SetActive(true)
        self.icon_food_2:SetActive(false)
    else
        self.icon_food_1:SetActive(false)
        self.icon_food_2:SetActive(true)
    end

    self.food_state_1:SetActive(false)
    self.food_state_2:SetActive(false)
    self.food_state_3:SetActive(false)
    self.food_state_4:SetActive(false)

    if(num > 0.75) then
        self.food_state_4:SetActive(true)
    elseif(num > 0.5) then
        self.food_state_3:SetActive(true)
    elseif(num > 0.25) then
        self.food_state_2:SetActive(true)
    elseif(num > 0) then
        self.food_state_1:SetActive(true)
    end


    self.btn_add_food_level:GetComponent("Button").onClick:RemoveAllListeners()
    self.btn_add_food_level:GetComponent("Button").onClick:AddListener(function ( ... )
        -- body
        self.UpgradeFoodBowlLevel( CatBowlModule )
    end)

end


function CatBowlView.ShowCatWaterModule( CatWaterModule )
    -- body
    self.text_water_level:GetComponent("TextMeshProUGUI").text = "Lv."..CatWaterModule.toolLevel
    self.text_progress_water_num:GetComponent("TextMeshProUGUI").text = CatWaterModule.surplusVolume.."/"..CatWaterModule.sumVolume
    local num = CatWaterModule.surplusVolume/CatWaterModule.sumVolume
    self.progress_water:GetComponent("Slider").value = num
    if(num > 0) then
        self.icon_water_1:SetActive(true)
        self.icon_water_2:SetActive(false)
    else
        self.icon_water_1:SetActive(false)
        self.icon_water_2:SetActive(true)
    end

    self.water_state_1:SetActive(false)
    self.water_state_2:SetActive(false)
    self.water_state_3:SetActive(false)
    self.water_state_4:SetActive(false)

    if(num > 0.75) then
        self.water_state_4:SetActive(true)
    elseif(num > 0.5) then
        self.water_state_3:SetActive(true)
    elseif(num > 0.25) then
        self.water_state_2:SetActive(true)
    elseif(num > 0) then
        self.water_state_1:SetActive(true)
    end

    self.btn_add_water_level:GetComponent("Button").onClick:RemoveAllListeners()
    self.btn_add_water_level:GetComponent("Button").onClick:AddListener(function ( ... )
        -- body
        self.UpgradeWaterBowlLevel( CatWaterModule )
    end)
end


function CatBowlView.Quit( ... )
    -- body
    MainStart.AllCatsChecks()
    UIManager:ShowUIAsync("main","main_view")
    UIManager:DelUI("cat_bowl_view")
end

function CatBowlView.OnClickAddWater( ... )
    -- body
    local AddWaterReq = {}
    AddWaterReq.token = playerData.baseData.data.token
    PublicClient.SendMsgAddWaterReq(AddWaterReq,function ( data )
        -- body
        Debug.Log("finish filling")
        self.SendMsgGetCatWaterInfoReq()
    end)
end

--get water basin information
function CatBowlView.SendMsgGetCatWaterInfoReq()

    local CatWaterInfoReq = {}
    CatWaterInfoReq.token = playerData.baseData.data.token
    PublicClient.SendMsgGetCatWaterInfoReq(CatWaterInfoReq,function ( data )
        -- body
        playerData.userTools.catWater = data.catWater
        self.ShowCatWaterModule(playerData.userTools.catWater)
    end)
end

--get cat box information
function CatBowlView.SendMsgGetCatBowlInfoReq()

    local GetCatBowlInfoReq = {}
    GetCatBowlInfoReq.token = playerData.baseData.data.token
    PublicClient.SendMsgGetCatBowlInfoReq(GetCatBowlInfoReq,function ( data )
        -- body
        playerData.userTools.catBowl = data.catBowl
        self.ShowCatBowlModule(playerData.userTools.catBowl)
    end)
end

--obtain the cat granary
function CatBowlView.SendMsgGetCatFoodWareHouseReq( ... )
    -- body
    
    local GetCatFoodWareHouseReq = {}
    GetCatFoodWareHouseReq.token = playerData.baseData.data.token
    PublicClient.SendMsgGetCatFoodWareHouseReq(GetCatFoodWareHouseReq,function ( data )
        -- body
        if(#data.houseList == 0) then
            self.line_food_water:SetActive(false)
            self.food_part:SetActive(false)
        else
            self.line_food_water:SetActive(true)
            self.food_part:SetActive(true)
        end 
        self.foodObjs = ClearObjs(self.foodObjs)
        for i=1,#data.houseList do
            local CatWareHouseModule = data.houseList[i]
            if(CatWareHouseModule.propCount > 0) then
                local itemEffectData = cat_item_effect[CatWareHouseModule.brandId]
                local foodObj = GameObject.Instantiate(self.item_food,self.item_food.transform.parent)
                foodObj.name = "item_food_"..CatWareHouseModule.id
                foodObj:SetActive(true)
                self.foodObjs[CatWareHouseModule.id] = foodObj
                PoolManager:SpawnAsync(itemEffectData.pic,"main",typeof(CS.UnityEngine.Sprite),false,function ( sprite )
                    foodObj.transform:Find("icon_food"):GetComponent("Image").sprite = sprite
                end)
                foodObj.transform:Find("text_food_num"):GetComponent("TextMeshProUGUI").text = CatWareHouseModule.propCount
                foodObj:GetComponent("Button").onClick:RemoveAllListeners()
                foodObj:GetComponent("Button").onClick:AddListener(function ( ... )
                    -- body
                    self.OnClickAddFood(CatWareHouseModule)
                end)
            end
        end
    end)
end

function CatBowlView.OnClickAddFood( CatWareHouseModule )
    -- body

    local CatBowlModule = playerData.userTools.catBowl
    local val = CatBowlModule.sumVolume - CatBowlModule.surplusVolume
    local ReplenishCatFoodReq = {}
    ReplenishCatFoodReq.token = playerData.baseData.data.token
    ReplenishCatFoodReq.wareHouseId = CatWareHouseModule.id
    if(CatWareHouseModule.propCount > val) then 
        ReplenishCatFoodReq.addCount = val
    else
        ReplenishCatFoodReq.addCount = CatWareHouseModule.propCount
    end
    PublicClient.SendMsgReplenishCatFoodReq(ReplenishCatFoodReq,function ( data )
        -- body
        Debug.Log("finished adding cat food")
        self.SendMsgGetCatBowlInfoReq()
        self.SendMsgGetCatFoodWareHouseReq()
    end)
end

--upgrade the food bowl level
function CatBowlView.UpgradeFoodBowlLevel( CatBowlModule )
    -- body
    local catBowlData = cat_bowl[CatBowlModule.toolLevel]
    local nextCatBowlData = cat_bowl[CatBowlModule.toolLevel + 1]
    if(nextCatBowlData) then
        UIManager:ShowUIAsync("main","box_upgrade",nil,function ( obj )
            -- body
            local offset = nextCatBowlData.capacity - catBowlData.capacity
            local str = "Upgrading to LV"..tostring(CatBowlModule.toolLevel + 1).." consumes "..CatBowlModule.upLevelMoneyCount.." PAW and increases the capacity by "..offset
            obj.transform:Find("text_msg"):GetComponent("TextMeshProUGUI").text = str
            obj.transform:Find("btn_upgrade"):GetComponent("Button").onClick:RemoveAllListeners()
            obj.transform:Find("btn_upgrade"):GetComponent("Button").onClick:AddListener(function ( ... )
                -- body
                self.SendMsgBowlUpLevelReq( CatBowlModule )
                UIManager:DelUI("box_upgrade")
            end)
            obj.transform:Find("btn_quit"):GetComponent("Button").onClick:RemoveAllListeners()
            obj.transform:Find("btn_quit"):GetComponent("Button").onClick:AddListener(function ( ... )
                -- body
                UIManager:DelUI("box_upgrade")
            end)
        end)
    end
end


--upgrade the water bowl level
function CatBowlView.UpgradeWaterBowlLevel( CatWaterModule )
    -- body
    local catWaterData = cat_water[CatWaterModule.toolLevel]
    local nextCatWaterData = cat_water[CatWaterModule.toolLevel + 1]
    if(nextCatWaterData) then
        UIManager:ShowUIAsync("main","box_upgrade",nil,function ( obj )
            -- body
            local offset = nextCatWaterData.capacity - catWaterData.capacity
            local str = "Upgrading to LV"..tostring(CatWaterModule.toolLevel + 1).." consumes "..CatWaterModule.upLevelMoneyCount.." PAW and increases the capacity by "..offset
            obj.transform:Find("text_msg"):GetComponent("TextMeshProUGUI").text = str
            obj.transform:Find("btn_upgrade"):GetComponent("Button").onClick:RemoveAllListeners()
            obj.transform:Find("btn_upgrade"):GetComponent("Button").onClick:AddListener(function ( ... )
                -- body
                self.SendMsgWaterUpLevelReq( CatWaterModule )
                UIManager:DelUI("box_upgrade")
            end)
            obj.transform:Find("btn_quit"):GetComponent("Button").onClick:RemoveAllListeners()
            obj.transform:Find("btn_quit"):GetComponent("Button").onClick:AddListener(function ( ... )
                -- body
                UIManager:DelUI("box_upgrade")
            end)
        end)
    end
end



function CatBowlView.SendMsgBowlUpLevelReq( CatBowlModule )
    -- body
    local BowlUpLevelReq = {}
    BowlUpLevelReq.token = playerData.baseData.data.token
    BowlUpLevelReq.bowlId = CatBowlModule.id
    PublicClient.SendMsgBowlUpLevelReq( BowlUpLevelReq,function ( data )
        -- body
        playerData.userTools.catBowl = data.tool
        self.ShowCatBowlModule(playerData.userTools.catBowl)
        UIManager:ShowUIAsync("main","result_level_up",nil,function ( obj )
            -- _G["itemLevelUpObjs"] = ClearObjs(_G["itemLevelUpObjs"])
            local item_msg = obj.transform:Find("group/item_msg")
            local itemLevelUpObj = GameObject.Instantiate(item_msg.gameObject,item_msg.parent)
            itemLevelUpObj:SetActive(true)
            -- table.insert(_G["itemLevelUpObjs"],itemLevelUpObj)
            itemLevelUpObj.transform:Find("text_left_msg"):GetComponent("TextMeshProUGUI").text = "LV."..CatBowlModule.toolLevel
            itemLevelUpObj.transform:Find("text_right_msg"):GetComponent("TextMeshProUGUI").text = "LV."..data.tool.toolLevel
            local itemLevelUpMsgObj = GameObject.Instantiate(item_msg.gameObject,item_msg.parent)
            itemLevelUpMsgObj:SetActive(true)
            -- table.insert(_G["itemLevelUpObjs"],itemLevelUpMsgObj)
            itemLevelUpMsgObj.transform:Find("text_left_msg"):GetComponent("TextMeshProUGUI").text = "Max Volum    "..CatBowlModule.sumVolume
            itemLevelUpMsgObj.transform:Find("text_right_msg"):GetComponent("TextMeshProUGUI").text = data.tool.sumVolume.."(+"..tostring(data.tool.sumVolume - CatBowlModule.sumVolume)..")"
            obj.transform:Find("btn_quit"):GetComponent("Button").onClick:RemoveAllListeners()
            obj.transform:Find("btn_quit"):GetComponent("Button").onClick:AddListener(function ( ... )
                -- body
                UIManager:DelUI("result_level_up")
            end)
        end)
    end )
end


function CatBowlView.SendMsgWaterUpLevelReq( CatWaterModule )
    -- body
    local WaterUpLevelReq = {}
    WaterUpLevelReq.token = playerData.baseData.data.token
    WaterUpLevelReq.waterId = CatWaterModule.id
    PublicClient.SendMsgWaterUpLevelReq( WaterUpLevelReq,function ( data )
        -- body
        playerData.userTools.catBowl = data.tool
        self.ShowCatWaterModule(playerData.userTools.catBowl)
        UIManager:ShowUIAsync("main","result_level_up",nil,function ( obj )
            -- _G["itemLevelUpObjs"] = ClearObjs(_G["itemLevelUpObjs"])
            local item_msg = obj.transform:Find("group/item_msg")
            local itemLevelUpObj = GameObject.Instantiate(item_msg.gameObject,item_msg.parent)
            itemLevelUpObj:SetActive(true)
            -- table.insert(_G["itemLevelUpObjs"],itemLevelUpObj)
            itemLevelUpObj.transform:Find("text_left_msg"):GetComponent("TextMeshProUGUI").text = "LV."..CatWaterModule.toolLevel
            itemLevelUpObj.transform:Find("text_right_msg"):GetComponent("TextMeshProUGUI").text = "LV."..data.tool.toolLevel
            local itemLevelUpMsgObj = GameObject.Instantiate(item_msg.gameObject,item_msg.parent)
            itemLevelUpMsgObj:SetActive(true)
            -- table.insert(_G["itemLevelUpObjs"],itemLevelUpMsgObj)
            itemLevelUpMsgObj.transform:Find("text_left_msg"):GetComponent("TextMeshProUGUI").text = "Max Volum    "..CatWaterModule.sumVolume
            itemLevelUpMsgObj.transform:Find("text_right_msg"):GetComponent("TextMeshProUGUI").text = data.tool.sumVolume.."(+"..tostring(data.tool.sumVolume - CatWaterModule.sumVolume)..")"
            obj.transform:Find("btn_quit"):GetComponent("Button").onClick:RemoveAllListeners()
            obj.transform:Find("btn_quit"):GetComponent("Button").onClick:AddListener(function ( ... )
                -- body
                UIManager:DelUI("result_level_up")
            end)
        end)
    end )
end
