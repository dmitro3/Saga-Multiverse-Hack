ParkView = {}
local self = ParkView

function ParkView.Start()
	self.onePaw = 300
	self.oneStamina = 30
	self.totalPaw = 0
	self.isCreatRewardList = false
	self.tabCatMsgList = {}
	self.InitBtns()
	self.InitDatas()
end

function ParkView.InitBtns()
	self.btn_quit:GetComponent("Button").onClick:RemoveAllListeners()
    self.btn_quit:GetComponent("Button").onClick:AddListener(self.Quit)
	--top listcorrelation
	self.btn_add_paw:GetComponent("Button").onClick:RemoveAllListeners()
    self.btn_add_paw:GetComponent("Button").onClick:AddListener(self.ClickAddPaw)
    self.btn_add_zoo:GetComponent("Button").onClick:RemoveAllListeners()
    self.btn_add_zoo:GetComponent("Button").onClick:AddListener(self.ClickAddZoo)
	--top listend

	--RewardListcorrelation
	self.btn_RewardList:GetComponent("Button").onClick:RemoveAllListeners()
    self.btn_RewardList:GetComponent("Button").onClick:AddListener(self.OpenRewardList)
    self.rewardList:GetComponent("Button").onClick:RemoveAllListeners()
    self.rewardList:GetComponent("Button").onClick:AddListener(self.CloseRewardList)
    self.rewardList_btnClose:GetComponent("Button").onClick:RemoveAllListeners()
    self.rewardList_btnClose:GetComponent("Button").onClick:AddListener(self.CloseRewardList)
    --RewardListend

    --TodayRewardcorrelation
    self.btn_TodayReward:GetComponent("Button").onClick:RemoveAllListeners()
    self.btn_TodayReward:GetComponent("Button").onClick:AddListener(self.OpenTodayRewardList)
    self.todayAward:GetComponent("Button").onClick:RemoveAllListeners()
    self.todayAward:GetComponent("Button").onClick:AddListener(self.CloseToadyRewardList)
    self.todayAward_btnClose:GetComponent("Button").onClick:RemoveAllListeners()
    self.todayAward_btnClose:GetComponent("Button").onClick:AddListener(self.CloseToadyRewardList)
    --TodayRewardend

    --chooseCatcorrelation
	self.btn_Cats:GetComponent("Button").onClick:RemoveAllListeners()
    self.btn_Cats:GetComponent("Button").onClick:AddListener(self.OpenCatList) 
    self.catlist_btnClose:GetComponent("Button").onClick:RemoveAllListeners()
    self.catlist_btnClose:GetComponent("Button").onClick:AddListener(self.CloseCatList) 
    self.catlist_btn_max:GetComponent("Button").onClick:RemoveAllListeners()
    self.catlist_btn_max:GetComponent("Button").onClick:AddListener(self.ClickCatListMaxBtn) 
    self.catlist_btn_confirm:GetComponent("Button").onClick:RemoveAllListeners()
    self.catlist_btn_confirm:GetComponent("Button").onClick:AddListener(self.ClickCatListConfirmBtn) 
    self.catlist_btn_cancel:GetComponent("Button").onClick:RemoveAllListeners()
    self.catlist_btn_cancel:GetComponent("Button").onClick:AddListener(self.ClickCatListCancelBtn) 
    --catlist_btnClose
    --chooseCatend   

    --one click to collect related
    self.btn_Chest:GetComponent("Button").onClick:RemoveAllListeners()
    self.btn_Chest:GetComponent("Button").onClick:AddListener(self.GetChest) 
    --one-click collection ends

    self.btn_close_result:GetComponent("Button").onClick:RemoveAllListeners()
    self.btn_close_result:GetComponent("Button").onClick:AddListener(self.CloseReceiveProps) 
end

function ParkView.InitDatas()
    -- body
    for i=1,#playerData.itemList do
        local ItemModule = playerData.itemList[i]
        -- Debug.LogError("ItemModule.propId = ".. ItemModule.propId  .. "   " .. ItemModule.propCount)
        if(ItemModule.propId == 10001) then
            self.text_paw_num:GetComponent("TextMeshProUGUI").text = ItemModule.propCount
            self.totalPaw = ItemModule.propCount
        end
        if(ItemModule.propId == 10002) then
            self.text_zoo_num:GetComponent("TextMeshProUGUI").text = ItemModule.propCount
        end
    end
end

function ParkView.ClickAddPaw()
	-- Debug.LogError("ClickAddPaw")
end

function ParkView.ClickAddZoo()
	-- Debug.LogError("ClickAddZoo")
end

--RewardListcorrelation
function ParkView.OpenRewardList()
	-- body
	if not self.isCreatRewardList then
		-- 
		for k,v in pairs(gachaCilent) do
			-- Debug.LogError(k .. "   " .. v.id .. "  " .. v.itemID .. "   " .. v.probability)
			local obj = GameObject.Instantiate(self.rewardList_item.gameObject,self.rewardListRoot.transform)			
			local itemData = item[v.itemID]			
			obj.transform:Find("rewardList_item_prep"):GetComponent("TextMeshProUGUI").text = v.probability * 100 .. "%"
			PoolManager:SpawnAsync(itemData.pic,"main",typeof(CS.UnityEngine.Sprite),false,function ( sprite )
                obj.transform:Find("rewardList_item_icon"):GetComponent("Image").sprite = sprite
            end)
            obj:SetActive(true)
		end
		self.isCreatRewardList = true
	end
	self.rewardList.gameObject:SetActive(true)
end

function ParkView.CloseRewardList()
	self.rewardList.gameObject:SetActive(false)
end
--RewardListend

--TodayRewardcorrelation
function ParkView.OpenTodayRewardList()	
	-- Debug.LogError("OpenTodayRewardList")
	local GetPlayGroundHistoryReq = {}
    GetPlayGroundHistoryReq.token = playerData.baseData.data.token    
	PublicClient.SendMsgPlayGroundHistoryReq(GetPlayGroundHistoryReq,function(data)
		self.CreateTodayRewardList(data.pmList)		
	end)		
end

function ParkView.CreateTodayRewardList(pmList)
	self.tabRewardObjList = ClearObjs(self.tabRewardObjList)

	for i,v in ipairs(pmList) do
		local obj = GameObject.Instantiate(self.todayAward_item.gameObject,self.todayAwardRoot.transform)		
		local GetPropsModule = v
        if(GetPropsModule.type == 1 or GetPropsModule.type == 2) then
            local itemData = item[GetPropsModule.id]                                                    
            PoolManager:SpawnAsync(itemData.pic,"main",typeof(CS.UnityEngine.Sprite),false,function ( sprite )
                obj.transform:Find("todayAward_item_icon"):GetComponent("Image").sprite = sprite
            end)
            obj.transform:Find("todayAward_item_Name"):GetComponent("TextMeshProUGUI").text = itemData.name
        elseif(GetPropsModule.type == 3) then
        elseif(GetPropsModule.type == 4) then
        end

        obj.transform:Find("todayAward_item_Count"):GetComponent("TextMeshProUGUI").text =  "x" .. GetPropsModule.count
        obj.transform:Find("todayAward_item_time"):GetComponent("TextMeshProUGUI").text = tostring(os.date("%m-%d %H:%M",math.floor(tonumber(GetPropsModule.time)/1000)))
        obj:SetActive(true)
        self.tabRewardObjList[i] = obj
	end
	self.todayAward.gameObject:SetActive(true)	
end

function ParkView.CloseToadyRewardList()
	self.todayAward.gameObject:SetActive(false)	
end
--TodayRewardend

--chooseCatcorrelation
function ParkView.OpenCatList()
	local GetPlayGroundCatListReq = {}
    GetPlayGroundCatListReq.token = playerData.baseData.data.token        
	PublicClient.SendMsgPlayGroundCatListReq(GetPlayGroundCatListReq,function(data)
		self.CreateCatList(data.catList)		
	end)	
end

function ParkView.CreateCatList(catList)
	self.tabCatList = ClearObjs(self.tabCatList)
	self.tabCatMsgList = {}	
	local nowTime = os.time() * 1000
	-- Debug.LogError("nowTime === " .. nowTime)
	for i,v in ipairs(catList) do
		local obj = GameObject.Instantiate(self.cat_item.gameObject,self.catListRoot.transform)	
		local catMsg = v
		-- Debug.LogError(v.catId .. "   " .. v.health)
		self.tabCatList[catMsg.catId] = obj		

		PoolManager:SpawnAsync(catMsg.catImage,"main",typeof(CS.UnityEngine.Sprite),false,function ( sprite )
            obj.transform:Find("cat_item_icon"):GetComponent("Image").sprite = sprite
        end)
		obj.transform:Find("cat_item_lv"):GetComponent("TextMeshProUGUI").text =  "LV." .. catMsg.level
		obj.transform:Find("cat_item_name"):GetComponent("TextMeshProUGUI").text =  catMsg.name
		obj.transform:Find("cat_item_name/Image/cat_item_staminaCount"):GetComponent("TextMeshProUGUI").text = tostring(catMsg.stamina)

		local tab = {}
		tab.obj = obj
		tab._obj_Complete = obj.transform:Find("cat_item_obj_Complete").gameObject
		tab._obj_Consumption = obj.transform:Find("cat_item_obj_Consumption").gameObject
		tab._obj_Remaining = obj.transform:Find("cat_item_obj_Remaining").gameObject
		tab._obj_wait = obj.transform:Find("cat_item_obj_wait").gameObject
		tab._btn_collect = obj.transform:Find("cat_item_btn_collect"):GetComponent("Button")		
		tab._btn_play = obj.transform:Find("cat_item_btn_play"):GetComponent("Button")			
		tab._obj_PlayTimes = obj.transform:Find("cat_item_obj_PlayTimes").gameObject
		tab._obj_CollectionTimes = obj.transform:Find("cat_item_obj_CollectionTimes").gameObject
		tab._btn_Reduce = obj.transform:Find("cat_item_btn_Reduce"):GetComponent("Button")
		tab._btn_Add = obj.transform:Find("cat_item_btn_Add"):GetComponent("Button")
		tab._item_input = obj.transform:Find("cat_item_input"):GetComponent("TMP_InputField")
		tab._item_select = obj.transform:Find("cat_item_select"):GetComponent("Toggle")
		tab._obj_mask = obj.transform:Find("cat_item_obj_mask").gameObject
		
		tab._btn_collect.onClick:RemoveAllListeners()
		tab._btn_play.onClick:RemoveAllListeners()	
		tab._btn_Reduce.onClick:RemoveAllListeners()
		tab._btn_Add.onClick:RemoveAllListeners()
		tab._item_select.onValueChanged:RemoveAllListeners()
		
		tab.isEnding = false
		tab.isRemaining = false
		tab.isTog = false
		tab.msg = catMsg
		tab.playCount = 0
		self.tabCatMsgList[catMsg.catId] = tab
		if catMsg.status == 5 then
			tab._obj_PlayTimes:SetActive(false)
			tab._obj_CollectionTimes:SetActive(true)

			tab._btn_Reduce.interactable = false
			tab._btn_Add.interactable = false
			tab._item_input.interactable = false

			-- if catMsg.receiveStatus == 1 then
			if catMsg.endTime ~= 0 and nowTime > catMsg.endTime then
				--settled
				tab.isEnding = true
				tab._obj_Complete:SetActive(true)
				tab._obj_Consumption:SetActive(false)
				tab._obj_Remaining:SetActive(false)
				tab._obj_wait:SetActive(false)
				tab._btn_collect.gameObject:SetActive(true)
				tab._btn_play.gameObject:SetActive(false)
				local _count =math.floor((catMsg.endTime - catMsg.startTime) / catMsg.useTime)
				tab._item_input.text = tostring(_count)

				tab._btn_collect.onClick:AddListener(function()                   
			        self.SendMsgPlayGroundReceiveReq(catMsg.catId)			           
			    end)		
			else
				--in progress
				tab.isRemaining = true
				tab._obj_Complete:SetActive(false)
				tab._obj_Consumption:SetActive(false)
				tab._obj_Remaining:SetActive(true)
				tab._obj_wait:SetActive(true)
				tab._btn_collect.gameObject:SetActive(false)
				tab._btn_play.gameObject:SetActive(false)
				tab._item_input.text = "-"
				local _count =math.floor((catMsg.endTime - catMsg.startTime) / catMsg.useTime)
				local _remainTime = math.floor(catMsg.endTime / 1000) - os.time()
				-- Debug.LogError((catMsg.endTime - catMsg.startTime) / 1000)
				local _hour = math.floor(_remainTime / 3600)
				local _min = math.floor((_remainTime - 3600 * _hour)/60)
				obj.transform:Find("cat_item_obj_Remaining/tex_hour"):GetComponent("TextMeshProUGUI").text = tostring(_hour)
				obj.transform:Find("cat_item_obj_Remaining/tex_min"):GetComponent("TextMeshProUGUI").text = tostring(_min)
				obj.transform:Find("cat_item_obj_Remaining/get_icon_Stamina/get_count_Stamina"):GetComponent("TextMeshProUGUI").text = self.oneStamina * _count
				obj.transform:Find("cat_item_obj_Remaining/get_icon_Paw/get_count_Paw"):GetComponent("TextMeshProUGUI").text = self.onePaw * _count
			end
		else
			tab._obj_PlayTimes:SetActive(true)
			tab._obj_CollectionTimes:SetActive(false)
			--not started
			tab._obj_Complete:SetActive(false)
			tab._obj_Consumption:SetActive(true)
			tab._obj_Remaining:SetActive(false)
			tab._obj_wait:SetActive(false)
			tab._btn_collect.gameObject:SetActive(false)
			tab._btn_play.gameObject:SetActive(true)

			tab._btn_play.onClick:AddListener(function()                   
		        self.SendMsgPlayGroundReq(catMsg.catId,self.tabCatMsgList[catMsg.catId].playCount)			           
		    end)

		    if catMsg.piCount == 0 then
		    	tab._item_input.text = "0"
		    	tab._btn_Reduce.interactable = false
				tab._btn_Add.interactable = false
				tab._item_input.interactable = false
				tab._btn_collect.interactable = false
			else
				tab._item_input.text = "1"
				self.tabCatMsgList[catMsg.catId].playCount = 1
				tab._btn_Reduce.interactable = false
				if catMsg.piCount == 1 then
					tab._btn_Add.interactable = false
				end
		    end
		    self.SetPlayMsg(catMsg.catId,self.tabCatMsgList[catMsg.catId].playCount)
		    tab._btn_Reduce.onClick:AddListener(function()                   
		        self.tabCatMsgList[catMsg.catId].playCount = self.tabCatMsgList[catMsg.catId].playCount - 1
		        tab._btn_Add.interactable = true
		        if self.tabCatMsgList[catMsg.catId].playCount == 1 then
		        	tab._btn_Reduce.interactable = false
		        end
		        tab._item_input.text = tostring(self.tabCatMsgList[catMsg.catId].playCount)		
		        self.SetPlayMsg(catMsg.catId,self.tabCatMsgList[catMsg.catId].playCount)	           
		    end)

		    tab._btn_Add.onClick:AddListener(function()                   
		        self.tabCatMsgList[catMsg.catId].playCount = self.tabCatMsgList[catMsg.catId].playCount + 1		
		        tab._btn_Reduce.interactable = true
		        if self.tabCatMsgList[catMsg.catId].playCount == catMsg.piCount then
		        	tab._btn_Add.interactable = false
		        end
		        tab._item_input.text = tostring(self.tabCatMsgList[catMsg.catId].playCount)
		        self.SetPlayMsg(catMsg.catId,self.tabCatMsgList[catMsg.catId].playCount)          
		    end)
		    tab._item_input.onEndEdit:AddListener(function(endVal) 
		    	local inputN = tonumber(endVal)
		    	if inputN > catMsg.piCount then
		    		inputN = catMsg.piCount
		    	end   
		    	self.tabCatMsgList[catMsg.catId].playCount = inputN  
		    	tab._item_input.text = tostring(self.tabCatMsgList[catMsg.catId].playCount) 

		    	if self.tabCatMsgList[catMsg.catId].playCount == catMsg.piCount then
		        	tab._btn_Add.interactable = false
		        	if catMsg.piCount > 1 then
		        		tab._btn_Reduce.interactable = true
		        	end
		        end
		        if self.tabCatMsgList[catMsg.catId].playCount == 1 then
		        	tab._btn_Reduce.interactable = false
		        	if catMsg.piCount > 1 then
		        		tab._btn_Add.interactable = true
		        	end
		        end
			end)
			tab._item_select.onValueChanged:RemoveAllListeners()
			tab._item_select.onValueChanged:AddListener(function ( isOn )                   
		        if(isOn) then            
		            self.tabCatMsgList[catMsg.catId].isTog = isOn  
		        end
		    end)
		end
		obj:SetActive(true)
	end

	self.catList:SetActive(true)
end

function ParkView.SetPlayMsg(catId,pCount)
	-- Debug.LogError(catId)
	local obj = self.tabCatMsgList[catId].obj
	
	local _remainTime = self.tabCatMsgList[catId].msg.useTime / 1000 * pCount
	local _hour = math.floor(_remainTime / 3600)
	local _min = math.floor((_remainTime - 3600 * _hour)/60)
	obj.transform:Find("cat_item_obj_Consumption/tex_hour"):GetComponent("TextMeshProUGUI").text = tostring(_hour)
	obj.transform:Find("cat_item_obj_Consumption/tex_min"):GetComponent("TextMeshProUGUI").text = tostring(_min)
	obj.transform:Find("cat_item_obj_Consumption/get_icon_Stamina/get_count_Stamina"):GetComponent("TextMeshProUGUI").text = self.oneStamina * pCount
	obj.transform:Find("cat_item_obj_Consumption/get_icon_Paw/get_count_Paw"):GetComponent("TextMeshProUGUI").text = self.onePaw * pCount
end

function ParkView.SendMsgPlayGroundReceiveReq(catId)	
	local GetPlayGroundReceiveReq = {}
    GetPlayGroundReceiveReq.token = playerData.baseData.data.token   
    GetPlayGroundReceiveReq.catId = catId   
	PublicClient.SendMsgPlayGroundReceiveReq(GetPlayGroundReceiveReq,function(data)
		self.OpenCatList()			
		self.ShowReceiveProps(data.pmList)
	end)	
end

function ParkView.SendMsgPlayGroundReq(catId,pCount)
	if pCount == 0 then
		return
	end

	MessageBox("TIPS","Are you sure you want to start playing?","Confirm",function ()
        local GetPlayGroundReq = {}
	    GetPlayGroundReq.token = playerData.baseData.data.token   
	    GetPlayGroundReq.catId = catId
	    GetPlayGroundReq.count = pCount
		PublicClient.SendMsgPlayGroundReq(GetPlayGroundReq,function(data)
			self.InitDatas()
			self.OpenCatList()
		end)
    end)
end

function ParkView.SendMsgMostPlayGroundReq()
	local GetMostPlayGroundReq = {}
	GetMostPlayGroundReq.token = playerData.baseData.data.token
	GetMostPlayGroundReq.catList = {}
	for k,v in pairs(self.tabCatMsgList) do
		if v.isTog then
			local tab = {}
			tab.catId = v.msg.catId
			tab.count = v.playCount			
			table.insert(GetMostPlayGroundReq.catList,tab)
		end
	end	
	if #GetMostPlayGroundReq.catList == 0 then
		return
	end		
	PublicClient.SendMsgMostPlayGroundReq(GetMostPlayGroundReq,function(data)
		self.InitDatas()
		self.OpenCatList()
		self.catlist_btn_max:SetActive(true)
		self.catlist_btn_List:SetActive(false)
	end)
end

function ParkView.ClickCatListMaxBtn()
	self.catlist_btn_max:SetActive(false)
	self.catlist_btn_List:SetActive(true)
	--listopen both options	
	for k,v in pairs(self.tabCatMsgList) do
		if v.isEnding or v.isRemaining then
			v._obj_mask:SetActive(true)
		else
			v._btn_play.gameObject:SetActive(false)
			v._item_select.gameObject:SetActive(true)
			if v.msg.piCount > 0 then
				v._item_select.isOn = true
				v.isTog = true
			else
				v._item_select.isOn = false
				v.isTog = false
			end
		end
	end

	local totalPlayCount = math.floor(self.totalPaw / self.onePaw)

end

function ParkView.ClickCatListConfirmBtn()
	MessageBox("TIPS","Are you sure you want to start playing?","Confirm",function ()
        self.SendMsgMostPlayGroundReq()
    end)
end

function ParkView.ClickCatListCancelBtn()
	self.catlist_btn_max:SetActive(true)
	self.catlist_btn_List:SetActive(false)
	--listturn off all options

	for k,v in pairs(self.tabCatMsgList) do
		if v.isEnding or v.isRemaining then
			v._obj_mask:SetActive(false)
		else
			v._btn_play.gameObject:SetActive(true)
			v._item_select.gameObject:SetActive(false)	
			v.isTog = false		
		end
	end
end

function ParkView.CloseCatList()
	self.catList:SetActive(false)
end
--chooseCatend  

--one click to collect related
function ParkView.GetChest()
 	local GetAllPlayGroundReceiveReq = {}
    GetAllPlayGroundReceiveReq.token = playerData.baseData.data.token   
   	Debug.LogError("GetChest")
	PublicClient.SendMsgAllPlayGroundReceiveReq(GetAllPlayGroundReceiveReq,function(data)			
		self.ShowReceiveProps(data.pmList)
	end)	
end 
--one-click collection ends

function ParkView.ShowReceiveProps(pmList)
	self.receiveObjs = ClearObjs(self.receiveObjs)
	 for i=1,#pmList do
        local GetPropsModule = pmList[i]
        if(GetPropsModule.type == 1 or GetPropsModule.type == 2) then
            local itemData = item[GetPropsModule.id]
            local obj = GameObject.Instantiate(self.item_receive_result,self.group_result.transform)
            obj:SetActive(true)
            self.receiveObjs[GetPropsModule.id] = obj
            obj.transform:Find("text_name"):GetComponent("TextMeshProUGUI").text = itemData.name
            obj.transform:Find("text_num"):GetComponent("TextMeshProUGUI").text = GetPropsModule.count
            PoolManager:SpawnAsync(itemData.pic,"main",typeof(CS.UnityEngine.Sprite),false,function ( sprite )
                obj.transform:Find("icon"):GetComponent("Image").sprite = sprite
            end)
        elseif(GetPropsModule.type == 3) then
        elseif(GetPropsModule.type == 4) then
        end
    end
    self.receive_resultPanel:SetActive(true)
end

function ParkView.CloseReceiveProps()
	self.receive_resultPanel:SetActive(false)
end

function ParkView.Quit()    
	SceneLoadManager:ChangeScene("main","main",function() 
		UIManager:DelUI("park_view")          
        UIManager:RefreshUI("main_view",0.1)              
    end)
end

function ParkView.OnDestroy()
    self.tabRewardObjList = nil
    self.tabCatList = nil
    self.tabCatMsgList = nil
    self.receiveObjs = nil
end
