MailView = {}
local self = MailView

function MailView.Start()
	-- Debug.LogError("MailView")
    self.tabMailItemList = {}       
    self.readMailId = 0 
	self.InitBtns()

    self.CreateMailList()
end

function MailView.InitBtns()
	self.mail_btn_close:GetComponent("Button").onClick:RemoveAllListeners()
    self.mail_btn_close:GetComponent("Button").onClick:AddListener(self.Quit)

    self.mail_tog_All:GetComponent("Toggle").onValueChanged:RemoveAllListeners()
    self.mail_tog_All:GetComponent("Toggle").onValueChanged:AddListener(function ( isOn )                   
        if(isOn) then            
            self.MailTogFilter(0)
        end
    end)

    self.mail_tog_Battle:GetComponent("Toggle").onValueChanged:RemoveAllListeners()
    self.mail_tog_Battle:GetComponent("Toggle").onValueChanged:AddListener(function ( isOn )                   
        if(isOn) then
            self.MailTogFilter(1)
        end
    end)

    self.mail_tog_Shelter:GetComponent("Toggle").onValueChanged:RemoveAllListeners()
    self.mail_tog_Shelter:GetComponent("Toggle").onValueChanged:AddListener(function ( isOn )                   
        if(isOn) then
            self.MailTogFilter(2)
        end
    end) 

    self.mail_tog_System:GetComponent("Toggle").onValueChanged:RemoveAllListeners()
    self.mail_tog_System:GetComponent("Toggle").onValueChanged:AddListener(function ( isOn )                   
        if(isOn) then
            self.MailTogFilter(3)
        end
    end) 

    self.mail_Drop_filiter:GetComponent("TMP_Dropdown").onValueChanged:RemoveAllListeners()
    self.mail_Drop_filiter:GetComponent("TMP_Dropdown").onValueChanged:AddListener(function ( index )                           
        self.MailDropFilter(index)
    end)   

    self.mail_btn_DeleteAll:GetComponent("Button").onClick:RemoveAllListeners()
    self.mail_btn_DeleteAll:GetComponent("Button").onClick:AddListener(self.DeleteAll)

    self.mail_btn_CollectAll:GetComponent("Button").onClick:RemoveAllListeners()
    self.mail_btn_CollectAll:GetComponent("Button").onClick:AddListener(self.CollectAll)   

    self.mail_obj_readPanel_btnClose:GetComponent("Button").onClick:RemoveAllListeners()
    self.mail_obj_readPanel_btnClose:GetComponent("Button").onClick:AddListener(self.CloseDetailsPanel)

    self.mail_obj_readPanel_btnPrev:GetComponent("Button").onClick:RemoveAllListeners()
    self.mail_obj_readPanel_btnPrev:GetComponent("Button").onClick:AddListener(self.ClickBtnPrev)

    self.mail_obj_readPanel_btnNext:GetComponent("Button").onClick:RemoveAllListeners()
    self.mail_obj_readPanel_btnNext:GetComponent("Button").onClick:AddListener(self.ClickBtnNext)

    self.mail_btn_readPanel_Delete:GetComponent("Button").onClick:RemoveAllListeners()
    self.mail_btn_readPanel_Delete:GetComponent("Button").onClick:AddListener(self.ClickBtnDelete)

    self.mail_btn_readPanel_Collect:GetComponent("Button").onClick:RemoveAllListeners()
    self.mail_btn_readPanel_Collect:GetComponent("Button").onClick:AddListener(self.ClickBtnCollect)
    
         
end

function MailView.CreateMailList()
    local index = 0  
    self.totalMailCount = 0  
    if playerData.mailList then
        for k,v in pairs(playerData.mailList) do           
            index = index + 1
            self.totalMailCount = self.totalMailCount + 1    
            local obj = GameObject.Instantiate(self.mail_obj_item.gameObject,self.main_list_Root.transform)
            local tabMailItem = {}
            tabMailItem.obj = obj
            tabMailItem.btn = obj:GetComponent("Button")
            tabMailItem.unRead = obj.transform:Find("mail_obj_item_UnreadBg").gameObject
            tabMailItem.unReadIcon_1 = obj.transform:Find("mail_obj_item_UnreadBg/mail_obj_icon_unread_1").gameObject
            tabMailItem.unReadIcon_2 = obj.transform:Find("mail_obj_item_UnreadBg/mail_obj_icon_unread_2").gameObject

            tabMailItem.read = obj.transform:Find("mail_obj_item_ReadBg").gameObject
            tabMailItem.readIcon_1 = obj.transform:Find("mail_obj_item_ReadBg/mail_obj_icon_read_1").gameObject
            tabMailItem.readIcon_2 = obj.transform:Find("mail_obj_item_ReadBg/mail_obj_icon_read_2").gameObject

            --BCB4B4 unread  ffffff read
            tabMailItem.tex_title = obj.transform:Find("mail_obj_tex_title"):GetComponent("TextMeshProUGUI")
            tabMailItem.tex_source = obj.transform:Find("mail_obj_tex_source"):GetComponent("TextMeshProUGUI")
            tabMailItem.tex_time = obj.transform:Find("mail_obj_tex_time"):GetComponent("TextMeshProUGUI")
            tabMailItem.mailMsg = mail[v.contentId]
            self.SetMailItemMsg(tabMailItem,v)

            tabMailItem.obj:SetActive(true)
            tabMailItem.mData = v
            tabMailItem.mIndex = index
            -- Debug.LogError(v.id .. "    " .. tostring(v.readStatue))
            tabMailItem.btn.onClick:RemoveAllListeners()
            tabMailItem.btn.onClick:AddListener(function ()                                   
                --single message read
                -- if not playerData.mailList[v.id].readStatue then
                --     local GetMailReadReq = {}
                --     GetMailReadReq.token =  playerData.baseData.data.token
                --     GetMailReadReq.ids = {v.id}

                --     PublicClient.SendMsgMailReadReq(GetMailReadReq,function ( data )            
                --         playerData.mailList[v.id].readStatue = true
                --         self.tabMailItemList[v.id].mData.readStatue = true
                --         self.SetMailItemMsg(self.tabMailItemList[v.id],playerData.mailList[v.id])
                --         self.OpenMailDetails(playerData.mailList[v.id],tabMailItem.mIndex)                        
                --     end)
                -- else
                --     self.OpenMailDetails(v,tabMailItem.mIndex)                    
                -- end
                self.ReadOneMail(tabMailItem.mData,tabMailItem.mIndex)
            end)                             
            
            self.tabMailItemList[v.id] = tabMailItem
        end
    end    	
end

function MailView.SetMailItemMsg(tabMailItem,data)
           
    if data.readStatue then
        tabMailItem.read:SetActive(true)
        tabMailItem.unRead:SetActive(false)
        --1.reward email，0text mail
        if data.type == 0 then
            tabMailItem.readIcon_1:SetActive(false)
            tabMailItem.readIcon_2:SetActive(true)
        elseif data.type == 1 then
            tabMailItem.readIcon_1:SetActive(true)
            tabMailItem.readIcon_2:SetActive(false)
        end
        local ctNum = math.floor(tonumber(data.createTime)/1000)
        -- Debug.LogError("data.sendUserName === " .. data.sendUserName)
        tabMailItem.tex_title.text = "<color=#ffffff>"  .. tabMailItem.mailMsg.title .. "</color>"
        tabMailItem.tex_source.text = "<color=#ffffff>"  .. data.sendUserName .. "</color>" 
        tabMailItem.tex_time.text ="<color=#ffffff>"  .. tostring(os.date("%Y-%m-%d",ctNum))  .. "</color>"
    else
        tabMailItem.read:SetActive(false)
        tabMailItem.unRead:SetActive(true)
        if data.type == 0 then
            tabMailItem.unReadIcon_1:SetActive(false)
            tabMailItem.unReadIcon_2:SetActive(true)
        elseif data.type == 1 then
            tabMailItem.unReadIcon_1:SetActive(true)
            tabMailItem.unReadIcon_2:SetActive(false)
        end
        local ctNum = math.floor(tonumber(data.createTime)/1000)    
        -- Debug.LogError("data.sendUserName === " .. data.sendUserName)    
        tabMailItem.tex_title.text = "<color=#bcb4b4>"  .. tabMailItem.mailMsg.title .. "</color>" --int you may need to read a table roll（to be confirmed）
        tabMailItem.tex_source.text = "<color=#bcb4b4>"  .. data.sendUserName .. "</color>" --int you may need to read a table roll（to be confirmed）
        tabMailItem.tex_time.text ="<color=#bcb4b4>"  .. tostring(os.date("%Y-%m-%d",ctNum)) .. "</color>"
    end
end

--open details
function MailView.OpenMailDetails(data,index)   
    --1.reward email，0text mail
    if index == 1 then
        self.mail_obj_readPanel_btnPrev:SetActive(false)
    else
        self.mail_obj_readPanel_btnPrev:SetActive(true)
    end

    if index == self.totalMailCount then
        self.mail_obj_readPanel_btnNext:SetActive(false)
    else
        self.mail_obj_readPanel_btnNext:SetActive(true)
    end    
    self.readIndex = index
    self.readMailId = data.id
    self.mail_tex_readPanel_title:GetComponent("TextMeshProUGUI").text = mail[data.contentId].title
    self.mail_tex_readPanel_source:GetComponent("TextMeshProUGUI").text = "From: " .. data.sendUserName
    self.mail_tex_readPanel_time:GetComponent("TextMeshProUGUI").text = "Time: " .. tostring(os.date("%Y-%m-%d",math.floor(tonumber(data.createTime)/1000)))
    if data.type == 0 then       
        local str = mail[data.contentId].content        
        if data.replaceContent and #data.replaceContent > 0 then
            for k,v in pairs(data.replaceContent) do                
                str = string.gsub(str,"{}",v, 1)
            end
        end        
        self.mail_obj_readPanel_noneReward_tex:GetComponent("TextMeshProUGUI").text = str
        self.mail_btn_readPanel_Collect:SetActive(false)
        self.mail_obj_readPanel_RewardList:SetActive(false)
        self.mail_obj_readPanel_haveReward:SetActive(false)
        self.mail_obj_readPanel_noneReward:SetActive(true)
    else       
        local str = mail[data.contentId].content          
        if data.replaceContent and #data.replaceContent > 0 then
            for k,v in pairs(data.replaceContent) do
                str = string.gsub(str,"{}",v, 1)
            end
        end
        self.mail_obj_readPanel_haveReward_tex:GetComponent("TextMeshProUGUI").text = str
        self.mail_btn_readPanel_Collect:SetActive(not data.statue)
        self.mail_obj_readPanel_RewardList:SetActive(true)
        self.mail_obj_readPanel_haveReward:SetActive(true)
        self.mail_obj_readPanel_noneReward:SetActive(false)
        
        local tempStr = Split(data.gifts,"&")
        local tabReward = {}
        for k,v in pairs(tempStr) do
            local _tab = {}
            local _temp = Split(v,"|")
            _tab.type = tonumber(_temp[1])
            _tab.id = tonumber(_temp[2])
            _tab.count = tonumber(_temp[3])
            table.insert(tabReward,_tab)
        end
        self.SetRewardList(tabReward)
        -- Debug.LogError("data.pmList === " .. #data.pmList)
        -- self.SetRewardList(data.pmList)
    end

	self.mail_obj_mainList:SetActive(false)
	self.mail_obj_readPanel:SetActive(true)    
end

function MailView.SetRewardList(pmList)    
    self.tabRewardObjList = ClearObjs(self.tabRewardObjList)
    for i=1,#pmList do
        local GetPropsModule = pmList[i]
        if(GetPropsModule.type == 1 or GetPropsModule.type == 2) then
            local itemData = item[GetPropsModule.id]
            local obj = GameObject.Instantiate(self.item_obj,self.mail_obj_readPanel_RewardRoot.transform)
            obj:SetActive(true)
            self.tabRewardObjList[GetPropsModule.id] = obj            
            obj.transform:Find("item_count"):GetComponent("TextMeshProUGUI").text = GetPropsModule.count
            PoolManager:SpawnAsync(itemData.pic,"main",typeof(CS.UnityEngine.Sprite),false,function ( sprite )
                obj.transform:Find("item_icon"):GetComponent("Image").sprite = sprite
            end)
        elseif(GetPropsModule.type == 3) then
        elseif(GetPropsModule.type == 4) then
        end
    end
end	

function MailView.DeleteAll()
	--Debug.LogError("DeleteAll")
    local deleteAllTab = {}
    for k,v in pairs(playerData.mailList) do
        --//type1.reward email，0text mail
        if v.type == 0 then
            if v.readStatue then
                table.insert(deleteAllTab,v.id)
            end
        else
            if v.statue then --received and read
                table.insert(deleteAllTab,v.id)
            end
        end
    end

    if #deleteAllTab == 0 then
        return
    end

    local GetMailDeleteReq = {}
    GetMailDeleteReq.token = playerData.baseData.data.token
    GetMailDeleteReq.ids = deleteAllTab
    PublicClient.SendMsgMailDeleteReq(GetMailDeleteReq,function ( data )            
        for k,v in pairs(deleteAllTab) do
            playerData.mailList[v] = nil
            self.tabMailItemList[v].obj:SetActive(false)
            self.tabMailItemList[v] = nil
        end
        self.totalMailCount = self.totalMailCount - #deleteAllTab
    end)
end

function MailView.CollectAll()
	--Debug.LogError("CollectAll")
    local collectAllTab = {}
    for k,v in pairs(playerData.mailList) do
        --//type1.reward email，0text mail
        if v.type == 1 then
            if not v.statue then --received and read
                table.insert(collectAllTab,v.id)
            end            
        end
    end

    if #collectAllTab == 0 then
        return
    end

    local GetMailReceiveReq = {}
    GetMailReceiveReq.token = playerData.baseData.data.token
    GetMailReceiveReq.ids = collectAllTab
    PublicClient.SendMsgMailReceiveReq(GetMailReceiveReq,function ( data )            
        for k,v in pairs(collectAllTab) do
            playerData.mailList[v].readStatue = true
            playerData.mailList[v].statue = true            
            self.SetMailItemMsg(self.tabMailItemList[v],playerData.mailList[v])
        end
    end)
end

function MailView.CloseDetailsPanel()
	self.mail_obj_mainList:SetActive(true)
 	self.mail_obj_readPanel:SetActive(false)
end 

function MailView.ClickBtnPrev()
 	self.readIndex = self.readIndex - 1
    local index = 1
    for k,v in pairs(playerData.mailList) do
        if index == self.readIndex then
            -- self.OpenMailDetails(v,self.readIndex)            
            self.ReadOneMail(v,self.readIndex)
            break
        end
        index = index + 1
    end
end  

function MailView.ClickBtnNext()
 	self.readIndex = self.readIndex + 1
    local index = 1
    for k,v in pairs(playerData.mailList) do
        if index == self.readIndex then
            -- self.OpenMailDetails(v,self.readIndex)
            self.ReadOneMail(v,self.readIndex)
            break
        end
        index = index + 1
    end
end

function MailView.ReadOneMail(data,index)
    if not playerData.mailList[data.id].readStatue then
        local GetMailReadReq = {}
        GetMailReadReq.token =  playerData.baseData.data.token
        GetMailReadReq.ids = {data.id}        
        PublicClient.SendMsgMailReadReq(GetMailReadReq,function ( _data )            
            playerData.mailList[data.id].readStatue = true
            self.tabMailItemList[data.id].mData.readStatue = true
            self.SetMailItemMsg(self.tabMailItemList[data.id],playerData.mailList[data.id])
            self.OpenMailDetails(playerData.mailList[data.id],index)                        
        end)
    else
        self.OpenMailDetails(data,index)                    
    end
end 

function MailView.ClickBtnDelete()
    if self.tabMailItemList[self.readMailId].mData.type == 1 and not self.tabMailItemList[self.readMailId].mData.statue then
        -- Debug.LogError("the award has not been claimed")
        return
    end
    local deleteAllTab = {self.readMailId}    

    local GetMailDeleteReq = {}
    GetMailDeleteReq.token = playerData.baseData.data.token
    GetMailDeleteReq.ids = deleteAllTab
    PublicClient.SendMsgMailDeleteReq(GetMailDeleteReq,function ( data )                    
        playerData.mailList[self.readMailId] = nil
        self.tabMailItemList[self.readMailId].obj:SetActive(false) 
        self.tabMailItemList[self.readMailId] = nil
        self.totalMailCount = self.totalMailCount - 1 

        self.CloseDetailsPanel()   
    end)
end 

function MailView.ClickBtnCollect()
 	
    local collectAllTab = {self.readMailId}    

    local GetMailReceiveReq = {}
    GetMailReceiveReq.token = playerData.baseData.data.token
    GetMailReceiveReq.ids = collectAllTab
    PublicClient.SendMsgMailReceiveReq(GetMailReceiveReq,function ( data )                        
        playerData.mailList[self.readMailId].statue = true            
        self.mail_btn_readPanel_Collect:SetActive(false)        
    end)
end


function MailView.MailTogFilter(_index)
    --tabMailItem.mailMsg
    if _index == 0 then        
        for k,v in pairs(self.tabMailItemList) do            
            v.obj:SetActive(true)            
        end   
    else
        for k,v in pairs(self.tabMailItemList) do                
            v.obj:SetActive(v.mailMsg.type == _index)                 
        end
    end
end

function MailView.MailDropFilter(_index)
    if _index == 0 then        
        for k,v in pairs(self.tabMailItemList) do            
            v.obj:SetActive(not v.readStatue)            
        end    
    else
        for k,v in pairs(self.tabMailItemList) do            
            v.obj:SetActive(v.readStatue)            
        end 
    end
end    

function MailView.Quit()    
	-- Debug.LogError("Quit")
    UIManager:DelUI("mail_view")
end

function MailView.OnDestroy()
    self.tabMailItemList = nil
    self.tabRewardObjList = nil
end
