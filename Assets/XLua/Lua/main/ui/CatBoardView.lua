CatBoardView = {}
local self = CatBoardView

function CatBoardView.Start( ... )
    -- body
    self.btn_quit:GetComponent("Button").onClick:RemoveAllListeners()
    self.btn_quit:GetComponent("Button").onClick:AddListener(self.Quit)

    self.Init()
end



function CatBoardView.Update( ... )
    -- body
end


function CatBoardView.OnDestroy( ... )
    -- body
end


function CatBoardView.Init( ... )
    -- body
    self.ShowCatScratchingBoardModule(playerData.userTools.catScratchingBoard)
end


function CatBoardView.Quit( ... )
    -- body
    UIManager:ShowUIAsync("main","main_view")
    UIManager:DelUI("cat_board_view")
end


function CatBoardView.ShowCatScratchingBoardModule( CatScratchingBoardModule )
    -- body
    local catBoardData = cat_scratchingPost[CatScratchingBoardModule.toolLevel] 
    self.text_board_level:GetComponent("TextMeshProUGUI").text = "Lv."..CatScratchingBoardModule.toolLevel
    self.text_progress_board_num:GetComponent("TextMeshProUGUI").text = CatScratchingBoardModule.surplusVolume.."/"..CatScratchingBoardModule.sumVolume
    local board_num = CatScratchingBoardModule.surplusVolume/CatScratchingBoardModule.sumVolume
    self.progress_board:GetComponent("Slider").value = board_num
    if(board_num > 0) then
        self.icon_board_1:SetActive(true)
        self.icon_board_2:SetActive(false)
    else
        self.icon_board_1:SetActive(false)
        self.icon_board_2:SetActive(true)
    end

    if(CatScratchingBoardModule.surplusVolume == CatScratchingBoardModule.sumVolume) then
        self.icon_money:SetActive(false)
        self.btn_recover:SetActive(false)
    else
        self.icon_money:SetActive(true)
        self.btn_recover:SetActive(true)
        self.text_money_num:GetComponent("TextMeshProUGUI").text = tostring(CatScratchingBoardModule.sumVolume - CatScratchingBoardModule.surplusVolume)
        self.btn_recover:GetComponent("Button").onClick:RemoveAllListeners()
        self.btn_recover:GetComponent("Button").onClick:AddListener(function ( ... )
            -- body
            --repair durability
            self.ShowRecoverBox(CatScratchingBoardModule)
        end)
    end

    PoolManager:SpawnAsync("cultivate_scratching_board_scene_0"..catBoardData.image,"main",typeof(CS.UnityEngine.Sprite),false,function ( sprite )
        self.icon_cat_board:GetComponent("Image").sprite = sprite
        self.icon_cat_board:GetComponent("Image"):SetNativeSize()
    end)


    self.btn_add_board_level:GetComponent("Button").onClick:RemoveAllListeners()
    self.btn_add_board_level:GetComponent("Button").onClick:AddListener(function ( ... )
        -- body
        --upgrade
        self.UpgradeBoardLevel( CatScratchingBoardModule )
    end)
end


function CatBoardView.UpgradeBoardLevel( CatScratchingBoardModule )
    local catBoardData = cat_scratchingPost[CatScratchingBoardModule.toolLevel]
    local nextCatBoardData = cat_scratchingPost[CatScratchingBoardModule.toolLevel + 1]
    if(nextCatBoardData) then
        UIManager:ShowUIAsync("main","box_upgrade",nil,function ( obj )
            -- body
            local offset = nextCatBoardData.endurance - catBoardData.endurance
            local str = "Upgrading to LV"..tostring(CatScratchingBoardModule.toolLevel + 1).." consumes "..CatScratchingBoardModule.upLevelMoneyCount.." PAW and increases the capacity by "..offset
            obj.transform:Find("text_msg"):GetComponent("TextMeshProUGUI").text = str
            obj.transform:Find("btn_upgrade"):GetComponent("Button").onClick:RemoveAllListeners()
            obj.transform:Find("btn_upgrade"):GetComponent("Button").onClick:AddListener(function ( ... )
                -- body
                self.SendMsgBoardUpLevelReq( CatScratchingBoardModule )
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



function CatBoardView.SendMsgBoardUpLevelReq( CatScratchingBoardModule )
    -- body
    local BoardUpLevelReq = {}
    BoardUpLevelReq.token = playerData.baseData.data.token
    BoardUpLevelReq.boardId = CatScratchingBoardModule.id
    PublicClient.SendMsgBoardUpLevelReq( BoardUpLevelReq,function ( data )
        -- body
        playerData.userTools.catScratchingBoard = data.tool
        self.ShowCatScratchingBoardModule(playerData.userTools.catScratchingBoard)
        UIManager:ShowUIAsync("main","result_level_up",nil,function ( obj )
            
            local item_msg = obj.transform:Find("group/item_msg")
            local itemLevelUpObj = GameObject.Instantiate(item_msg.gameObject,item_msg.parent)
            itemLevelUpObj:SetActive(true)
            
            itemLevelUpObj.transform:Find("text_left_msg"):GetComponent("TextMeshProUGUI").text = "LV."..CatScratchingBoardModule.toolLevel
            itemLevelUpObj.transform:Find("text_right_msg"):GetComponent("TextMeshProUGUI").text = "LV."..data.tool.toolLevel
            local itemLevelUpMsgObj = GameObject.Instantiate(item_msg.gameObject,item_msg.parent)
            itemLevelUpMsgObj:SetActive(true)
            
            itemLevelUpMsgObj.transform:Find("text_left_msg"):GetComponent("TextMeshProUGUI").text = "Max Volum    "..CatScratchingBoardModule.sumVolume
            itemLevelUpMsgObj.transform:Find("text_right_msg"):GetComponent("TextMeshProUGUI").text = data.tool.sumVolume.."(+"..tostring(data.tool.sumVolume - CatScratchingBoardModule.sumVolume)..")"
            obj.transform:Find("btn_quit"):GetComponent("Button").onClick:RemoveAllListeners()
            obj.transform:Find("btn_quit"):GetComponent("Button").onClick:AddListener(function ( ... )
                -- body
                UIManager:DelUI("result_level_up")
            end)
        end)
    end )
end


function CatBoardView.ShowRecoverBox(CatScratchingBoardModule)
    UIManager:ShowUIAsync("main","box_recover",nil,function ( obj )
        -- body
        local str = "Consumes "..CatScratchingBoardModule.repairMoneyCount.." PAW and durability repair to full"
        obj.transform:Find("text_msg"):GetComponent("TextMeshProUGUI").text = str
        obj.transform:Find("btn_recover"):GetComponent("Button").onClick:RemoveAllListeners()
        obj.transform:Find("btn_recover"):GetComponent("Button").onClick:AddListener(function ( ... )
            -- body
            self.SendMsgRepairBoardReq( CatScratchingBoardModule )
            UIManager:DelUI("box_recover")
        end)
        obj.transform:Find("btn_quit"):GetComponent("Button").onClick:RemoveAllListeners()
        obj.transform:Find("btn_quit"):GetComponent("Button").onClick:AddListener(function ( ... )
            -- body
            UIManager:DelUI("box_recover")
        end)
    end)
end

function CatBoardView.SendMsgRepairBoardReq( CatScratchingBoardModule )
    -- body
    local RepairBoardReq = {}
    RepairBoardReq.token = playerData.baseData.data.token
    PublicClient.SendMsgRepairBoardReq( RepairBoardReq,function ( data )
        -- body
        self.SendMsgGetCatBoardInfoReq()
        UIManager:ShowUIAsync("main","result_repair",nil,function ( obj )
            
            local item_msg = obj.transform:Find("group/item_msg")
            local itemRecoverObj = GameObject.Instantiate(item_msg.gameObject,item_msg.parent)
            itemRecoverObj:SetActive(true)
            
            itemRecoverObj.transform:Find("text_left_msg"):GetComponent("TextMeshProUGUI").text = "Durability    "..CatScratchingBoardModule.surplusVolume
            itemRecoverObj.transform:Find("text_right_msg"):GetComponent("TextMeshProUGUI").text = CatScratchingBoardModule.sumVolume
            
            obj.transform:Find("btn_quit"):GetComponent("Button").onClick:RemoveAllListeners()
            obj.transform:Find("btn_quit"):GetComponent("Button").onClick:AddListener(function ( ... )
                -- body
                UIManager:DelUI("result_repair")
            end)
        end)
    end )
end


function CatBoardView.SendMsgGetCatBoardInfoReq( ... )
    -- body
    local GetCatBoardInfoReq = {}
    GetCatBoardInfoReq.token = playerData.baseData.data.token
    PublicClient.SendMsgGetCatBoardInfoReq( GetCatBoardInfoReq,function ( data )
        -- body
        playerData.userTools.catScratchingBoard = data.catBoard
        self.ShowCatScratchingBoardModule(playerData.userTools.catScratchingBoard)
    end )
end
