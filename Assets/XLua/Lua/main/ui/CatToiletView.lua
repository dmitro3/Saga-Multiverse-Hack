CatToiletView = {}
local self = CatToiletView

function CatToiletView.Start( ... )
    -- body
    self.btn_quit:GetComponent("Button").onClick:RemoveAllListeners()
    self.btn_quit:GetComponent("Button").onClick:AddListener(self.Quit)
    self.item_toilet_clean:GetComponent("Button").onClick:RemoveAllListeners()
    self.item_toilet_clean:GetComponent("Button").onClick:AddListener(self.OnClickCleanToilet)

    self.Init()
end



function CatToiletView.Update( ... )
    -- body
end


function CatToiletView.OnDestroy( ... )
    -- body
end


function CatToiletView.Init( ... )
    -- body
    self.ShowCatToiletModule(playerData.userTools.catToilet)
    self.SendMsgGetCatLitterWareHouseReq()
end


function CatToiletView.Quit( ... )
    -- body
    MainStart.AllCatsChecks()
    UIManager:ShowUIAsync("main","main_view")
    UIManager:DelUI("cat_toilet_view")
end


function CatToiletView.ShowCatToiletModule( CatToiletModule )
    -- body
    local catLitterData = cat_toilet[CatToiletModule.toolLevel]
    self.text_litter_level:GetComponent("TextMeshProUGUI").text = "Lv."..CatToiletModule.toolLevel
    self.text_progress_litter_num:GetComponent("TextMeshProUGUI").text = CatToiletModule.surplusVolume.."/"..CatToiletModule.sumVolume
    local litter_num = CatToiletModule.surplusVolume/CatToiletModule.sumVolume
    self.progress_litter:GetComponent("Slider").value = litter_num
    if(litter_num > 0) then
        self.icon_litter_1:SetActive(true)
        self.icon_litter_2:SetActive(false)
    else
        self.icon_litter_1:SetActive(false)
        self.icon_litter_2:SetActive(true)
    end


    PoolManager:SpawnAsync("cultivate_cat_toilet_scene_0"..catLitterData.image,"main",typeof(CS.UnityEngine.Sprite),false,function ( sprite )
        self.icon_cat_toilet:GetComponent("Image").sprite = sprite
        self.icon_cat_toilet:GetComponent("Image"):SetNativeSize()
    end)


    self.btn_add_litter_level:GetComponent("Button").onClick:RemoveAllListeners()
    self.btn_add_litter_level:GetComponent("Button").onClick:AddListener(function ( ... )
        -- body
        self.UpgradeLitterLevel( CatToiletModule )
    end)

    self.text_clean_level:GetComponent("TextMeshProUGUI").text = "Lv."..CatToiletModule.excrementLevel
    self.text_progress_clean_num:GetComponent("TextMeshProUGUI").text = CatToiletModule.catExcrement.."/"..CatToiletModule.sumCatExcrement
    local clean_num = CatToiletModule.catExcrement/CatToiletModule.sumCatExcrement
    self.progress_clean:GetComponent("Slider").value = clean_num
    if(CatToiletModule.catExcrement < CatToiletModule.sumCatExcrement) then
        self.icon_clean_1:SetActive(true)
        self.icon_clean_2:SetActive(false)
    else
        self.icon_clean_1:SetActive(false)
        self.icon_clean_2:SetActive(true)
    end

    self.btn_add_clean_level:GetComponent("Button").onClick:RemoveAllListeners()
    self.btn_add_clean_level:GetComponent("Button").onClick:AddListener(function ( ... )
        -- body
        self.UpgradeCleanLevel( CatToiletModule )
    end)

end


function CatToiletView.UpgradeLitterLevel( CatToiletModule )
    local catLitterData = cat_toilet[CatToiletModule.toolLevel]
    local nextCatLitterData = cat_toilet[CatToiletModule.toolLevel + 1]
    if(nextCatLitterData) then
        UIManager:ShowUIAsync("main","box_upgrade",nil,function ( obj )
            -- body
            local offset = nextCatLitterData.capacity - catLitterData.capacity
            local str = "Upgrading to LV"..tostring(CatToiletModule.toolLevel + 1).." consumes "..CatToiletModule.upLevelMoneyCount.." PAW and increases the capacity by "..offset
            obj.transform:Find("text_msg"):GetComponent("TextMeshProUGUI").text = str
            obj.transform:Find("btn_upgrade"):GetComponent("Button").onClick:RemoveAllListeners()
            obj.transform:Find("btn_upgrade"):GetComponent("Button").onClick:AddListener(function ( ... )
                -- body
                self.SendMsgToiletUpLevelReq( CatToiletModule )
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

function CatToiletView.UpgradeCleanLevel( CatToiletModule )
    local catLitterData = cat_toilet[CatToiletModule.toolLevel]
    local nextCatLitterData = cat_toilet[CatToiletModule.toolLevel + 1]
    if(nextCatLitterData) then
        UIManager:ShowUIAsync("main","box_upgrade",nil,function ( obj )
            -- body
            local offset = nextCatLitterData.catFecesCapacity - catLitterData.catFecesCapacity
            local str = "Upgrading to LV"..tostring(CatToiletModule.toolLevel + 1).." consumes "..CatToiletModule.upExcrementLevelMoneyCount.." PAW and increases the capacity by "..offset
            obj.transform:Find("text_msg"):GetComponent("TextMeshProUGUI").text = str
            obj.transform:Find("btn_upgrade"):GetComponent("Button").onClick:RemoveAllListeners()
            obj.transform:Find("btn_upgrade"):GetComponent("Button").onClick:AddListener(function ( ... )
                -- body
                self.SendMsgCatExcrementUpLevelReq( CatToiletModule )
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


function CatToiletView.SendMsgToiletUpLevelReq( CatToiletModule )
    -- body
    local ToiletUpLevelReq = {}
    ToiletUpLevelReq.token = playerData.baseData.data.token
    ToiletUpLevelReq.toiletId = CatToiletModule.id
    PublicClient.SendMsgToiletUpLevelReq( ToiletUpLevelReq,function ( data )
        -- body
        playerData.userTools.catToilet = data.tool
        self.ShowCatToiletModule(playerData.userTools.catToilet)
        UIManager:ShowUIAsync("main","result_level_up",nil,function ( obj )
            -- _G["itemLevelUpObjs"] = ClearObjs(_G["itemLevelUpObjs"])
            local item_msg = obj.transform:Find("group/item_msg")
            local itemLevelUpObj = GameObject.Instantiate(item_msg.gameObject,item_msg.parent)
            itemLevelUpObj:SetActive(true)
            -- table.insert(_G["itemLevelUpObjs"],itemLevelUpObj)
            itemLevelUpObj.transform:Find("text_left_msg"):GetComponent("TextMeshProUGUI").text = "LV."..CatToiletModule.toolLevel
            itemLevelUpObj.transform:Find("text_right_msg"):GetComponent("TextMeshProUGUI").text = "LV."..data.tool.toolLevel
            local itemLevelUpMsgObj = GameObject.Instantiate(item_msg.gameObject,item_msg.parent)
            itemLevelUpMsgObj:SetActive(true)
            -- table.insert(_G["itemLevelUpObjs"],itemLevelUpMsgObj)
            itemLevelUpMsgObj.transform:Find("text_left_msg"):GetComponent("TextMeshProUGUI").text = "Max Volum    "..CatToiletModule.sumVolume
            itemLevelUpMsgObj.transform:Find("text_right_msg"):GetComponent("TextMeshProUGUI").text = data.tool.sumVolume.."(+"..tostring(data.tool.sumVolume - CatToiletModule.sumVolume)..")"
            obj.transform:Find("btn_quit"):GetComponent("Button").onClick:RemoveAllListeners()
            obj.transform:Find("btn_quit"):GetComponent("Button").onClick:AddListener(function ( ... )
                -- body
                UIManager:DelUI("result_level_up")
            end)
        end)
    end )
end


function CatToiletView.SendMsgCatExcrementUpLevelReq( CatToiletModule )
    -- body
    local CatExcrementUpLevelReq = {}
    CatExcrementUpLevelReq.token = playerData.baseData.data.token
    CatExcrementUpLevelReq.toiletId = CatToiletModule.id
    PublicClient.SendMsgCatExcrementUpLevelReq( CatExcrementUpLevelReq,function ( data )
        -- body
        playerData.userTools.catToilet = data.tool
        self.ShowCatToiletModule(playerData.userTools.catToilet)
        UIManager:ShowUIAsync("main","result_level_up",nil,function ( obj )
            -- _G["itemLevelUpObjs"] = ClearObjs(_G["itemLevelUpObjs"])
            local item_msg = obj.transform:Find("group/item_msg")
            local itemLevelUpObj = GameObject.Instantiate(item_msg.gameObject,item_msg.parent)
            itemLevelUpObj:SetActive(true)
            -- table.insert(_G["itemLevelUpObjs"],itemLevelUpObj)
            itemLevelUpObj.transform:Find("text_left_msg"):GetComponent("TextMeshProUGUI").text = "LV."..CatToiletModule.excrementLevel
            itemLevelUpObj.transform:Find("text_right_msg"):GetComponent("TextMeshProUGUI").text = "LV."..data.tool.excrementLevel
            local itemLevelUpMsgObj = GameObject.Instantiate(item_msg.gameObject,item_msg.parent)
            itemLevelUpMsgObj:SetActive(true)
            -- table.insert(_G["itemLevelUpObjs"],itemLevelUpMsgObj)
            itemLevelUpMsgObj.transform:Find("text_left_msg"):GetComponent("TextMeshProUGUI").text = "Max Volum    "..CatToiletModule.sumCatExcrement
            itemLevelUpMsgObj.transform:Find("text_right_msg"):GetComponent("TextMeshProUGUI").text = data.tool.sumCatExcrement.."(+"..tostring(data.tool.sumCatExcrement - CatToiletModule.sumCatExcrement)..")"
            obj.transform:Find("btn_quit"):GetComponent("Button").onClick:RemoveAllListeners()
            obj.transform:Find("btn_quit"):GetComponent("Button").onClick:AddListener(function ( ... )
                -- body
                UIManager:DelUI("result_level_up")
            end)
        end)
    end )
end





function CatToiletView.SendMsgGetCatLitterWareHouseReq( ... )
    -- body
    
    local GetCatLitterWareHouseReq = {}
    GetCatLitterWareHouseReq.token = playerData.baseData.data.token
    PublicClient.SendMsgGetCatLitterWareHouseReq(GetCatLitterWareHouseReq,function ( data )
        -- body
        if(#data.houseList == 0) then
            self.line_litter_clean:SetActive(false)
            self.group_litter:SetActive(false)
        else
            self.line_litter_clean:SetActive(true)
            self.group_litter:SetActive(true)
        end 
        self.litterObjs = ClearObjs(self.litterObjs)
        for i=1,#data.houseList do
            local CatWareHouseModule = data.houseList[i]
            if(CatWareHouseModule.propCount > 0) then
                local itemEffectData = cat_item_effect[CatWareHouseModule.brandId]
                local litterObj = GameObject.Instantiate(self.item_litter,self.item_litter.transform.parent)
                litterObj.name = "item_litter_"..CatWareHouseModule.id
                litterObj:SetActive(true)
                self.litterObjs[CatWareHouseModule.id] = litterObj
                PoolManager:SpawnAsync(itemEffectData.pic,"main",typeof(CS.UnityEngine.Sprite),false,function ( sprite )
                    litterObj.transform:Find("icon_litter"):GetComponent("Image").sprite = sprite
                end)
                litterObj.transform:Find("text_litter_num"):GetComponent("TextMeshProUGUI").text = CatWareHouseModule.propCount
                litterObj:GetComponent("Button").onClick:RemoveAllListeners()
                litterObj:GetComponent("Button").onClick:AddListener(function ( ... )
                    -- body
                    self.OnClickAddLitter(CatWareHouseModule)
                end)
            end
        end
    end)
end


function CatToiletView.OnClickAddLitter( CatWareHouseModule )
    -- body

    local CatToiletModule = playerData.userTools.catToilet
    local val = CatToiletModule.sumVolume - CatToiletModule.surplusVolume
    local ReplenishCatLitterReq = {}
    ReplenishCatLitterReq.token = playerData.baseData.data.token
    ReplenishCatLitterReq.wareHouseId = CatWareHouseModule.id
    if(CatWareHouseModule.propCount > val) then 
        ReplenishCatLitterReq.addCount = val
    else
        ReplenishCatLitterReq.addCount = CatWareHouseModule.propCount
    end
    PublicClient.SendMsgReplenishCatLitterReq(ReplenishCatLitterReq,function ( data )
        -- body
        Debug.Log("finished adding kitty litter")
        self.SendMsgGetCatToiletInfoReq()
        self.SendMsgGetCatLitterWareHouseReq()
    end)
end


--get cat toilet information
function CatToiletView.SendMsgGetCatToiletInfoReq()

    local GetCatToiletInfoReq = {}
    GetCatToiletInfoReq.token = playerData.baseData.data.token
    PublicClient.SendMsgGetCatToiletInfoReq(GetCatToiletInfoReq,function ( data )
        -- body
        playerData.userTools.catToilet = data.catToilet
        self.ShowCatToiletModule(playerData.userTools.catToilet)
    end)
end


function CatToiletView.OnClickCleanToilet( ... )
    -- body
    local CleanExcrementReq = {}
    CleanExcrementReq.token = playerData.baseData.data.token
    PublicClient.SendMsgCleanExcrementReq(CleanExcrementReq,function ( data )
        -- body
        Debug.Log("finish cleaning the litter")
        self.SendMsgGetCatToiletInfoReq()
    end)
end
