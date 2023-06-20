CatHouseView = {}
local self = CatHouseView

function CatHouseView.Start( ... )
    -- body
    self.btn_quit:GetComponent("Button").onClick:RemoveAllListeners()
    self.btn_quit:GetComponent("Button").onClick:AddListener(self.Quit)

    self.Init()
end



function CatHouseView.Update( ... )
    -- body
end


function CatHouseView.OnDestroy( ... )
    -- body
end


function CatHouseView.Init( ... )
    -- body
    self.ShowCatHouseModule(playerData.userTools.catHouse)
end


function CatHouseView.Quit( ... )
    -- body
    UIManager:ShowUIAsync("main","main_view")
    UIManager:DelUI("cat_house_view")
end


function CatHouseView.ShowCatHouseModule( CatHouseModule )
    -- body
    local catHouseData = cat_house[CatHouseModule.toolLevel] 
    self.text_house_level:GetComponent("TextMeshProUGUI").text = "Lv."..CatHouseModule.toolLevel
    self.text_house_doc:GetComponent("TextMeshProUGUI").text = "Recover "..catHouseData.effect[2].." point "..catHouseData.effect[1].." min"
  
   

    PoolManager:SpawnAsync("cultivate_cat_nest_scene_0"..catHouseData.image,"main",typeof(CS.UnityEngine.Sprite),false,function ( sprite )
        self.icon_cat_house:GetComponent("Image").sprite = sprite
        self.icon_cat_house:GetComponent("Image"):SetNativeSize()
    end)


    self.btn_add_house_level:GetComponent("Button").onClick:RemoveAllListeners()
    self.btn_add_house_level:GetComponent("Button").onClick:AddListener(function ( ... )
        -- body
        --upgrade
        self.UpgradeHouseLevel( CatHouseModule )
    end)
end


function CatHouseView.UpgradeHouseLevel( CatHouseModule )
    local catHouseData = cat_house[CatHouseModule.toolLevel]
    local nextcatHouseData = cat_house[CatHouseModule.toolLevel + 1]
    if(nextcatHouseData) then
        UIManager:ShowUIAsync("main","box_upgrade",nil,function ( obj )
            -- body
            local offset = nextcatHouseData.effect[2] - catHouseData.effect[2]
            local str = "Upgrading to LV"..tostring(CatHouseModule.toolLevel + 1).." consumes "..CatHouseModule.upLevelMoneyCount.." PAW and increase stamina recovery speed by "..offset
            obj.transform:Find("text_msg"):GetComponent("TextMeshProUGUI").text = str
            obj.transform:Find("btn_upgrade"):GetComponent("Button").onClick:RemoveAllListeners()
            obj.transform:Find("btn_upgrade"):GetComponent("Button").onClick:AddListener(function ( ... )
                -- body
                self.SendMsgHouseUpLevelReq( CatHouseModule )
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



function CatHouseView.SendMsgHouseUpLevelReq( CatHouseModule )
    -- body
    local catHouseData = cat_house[CatHouseModule.toolLevel]
    local nextcatHouseData = cat_house[CatHouseModule.toolLevel + 1]
    local HouseUpLevelReq = {}
    HouseUpLevelReq.token = playerData.baseData.data.token
    HouseUpLevelReq.houseId = CatHouseModule.id
    PublicClient.SendMsgHouseUpLevelReq( HouseUpLevelReq,function ( data )
        -- body
        playerData.userTools.catHouse = data.tool
        self.ShowCatHouseModule(playerData.userTools.catHouse)
        UIManager:ShowUIAsync("main","result_level_up",nil,function ( obj )
            
            local item_msg = obj.transform:Find("group/item_msg")
            local itemLevelUpObj = GameObject.Instantiate(item_msg.gameObject,item_msg.parent)
            itemLevelUpObj:SetActive(true)
            
            itemLevelUpObj.transform:Find("text_left_msg"):GetComponent("TextMeshProUGUI").text = "LV."..CatHouseModule.toolLevel
            itemLevelUpObj.transform:Find("text_right_msg"):GetComponent("TextMeshProUGUI").text = "LV."..data.tool.toolLevel
            local itemLevelUpMsgObj = GameObject.Instantiate(item_msg.gameObject,item_msg.parent)
            itemLevelUpMsgObj:SetActive(true)
            
            itemLevelUpMsgObj.transform:Find("text_left_msg"):GetComponent("TextMeshProUGUI").text = "Recover "..catHouseData.effect[2].." point "..catHouseData.effect[1].." min"
            itemLevelUpMsgObj.transform:Find("text_right_msg"):GetComponent("TextMeshProUGUI").text = "Recover "..nextcatHouseData.effect[2].." point "..nextcatHouseData.effect[1].." min"
            obj.transform:Find("btn_quit"):GetComponent("Button").onClick:RemoveAllListeners()
            obj.transform:Find("btn_quit"):GetComponent("Button").onClick:AddListener(function ( ... )
                -- body
                UIManager:DelUI("result_level_up")
            end)
        end)
    end )
end
