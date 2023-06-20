CountryardView = {}
local self = CountryardView

function CountryardView.Start()
	self.InitBtns()
end

function CountryardView.InitBtns()
	--pillage panel---
	self.catlist_btnClose:GetComponent("Button").onClick:RemoveAllListeners()
    self.catlist_btnClose:GetComponent("Button").onClick:AddListener(self.CloseCatList) 
    self.catlist_btn_AllSetOut:GetComponent("Button").onClick:RemoveAllListeners()
    self.catlist_btn_AllSetOut:GetComponent("Button").onClick:AddListener(self.ClickCatAllSetOut) 
    self.catlist_btn_confirm:GetComponent("Button").onClick:RemoveAllListeners()
    self.catlist_btn_confirm:GetComponent("Button").onClick:AddListener(self.ClickCatListConfirmBtn) 
    self.catlist_btn_cancel:GetComponent("Button").onClick:RemoveAllListeners()
    self.catlist_btn_cancel:GetComponent("Button").onClick:AddListener(self.ClickCatListCancelBtn) 
    --end of plunder panel---

    --defensive panel--
    self.catdefense_btnClose:GetComponent("Button").onClick:RemoveAllListeners()
    self.catdefense_btnClose:GetComponent("Button").onClick:AddListener(self.CloseDefenseList) 
    --end of defensive panel--
   
    self.catgrass_btnClose:GetComponent("Button").onClick:RemoveAllListeners()
    self.catgrass_btnClose:GetComponent("Button").onClick:AddListener(self.CloseCatgrassList) 

    --CloseUnlockcondition
    --SendUnLockFieldReq
    --unlock block
    self.Unlockcondition_btnClose:GetComponent("Button").onClick:RemoveAllListeners()
    self.Unlockcondition_btnClose:GetComponent("Button").onClick:AddListener(self.CloseUnlockcondition)
    self.Unlockcondition_btn:GetComponent("Button").onClick:RemoveAllListeners()
    self.Unlockcondition_btn:GetComponent("Button").onClick:AddListener(self.SendUnLockFieldReq)
end	

--plunder panel list
function CountryardView.GetPlunderList()
	local GetAttackCatListReq = {}
    GetAttackCatListReq.token = playerData.baseData.data.token        
	PublicClient.SendMsgAttackCatListReq(GetAttackCatListReq,function(data)
		self.CreatePlunderList(data.catList)		
	end)	
end

function CountryardView.CreatePlunderList(catList)
	self.tabPlunderList = ClearObjs(self.tabPlunderList)
	self.tabPlunderMsgList = {}	
	local nowTime = os.time() * 1000

	for i,v in ipairs(catList) do
		local obj = GameObject.Instantiate(self.plunder_item.gameObject,self.plunderRoot.transform)	
		local catMsg = v
		
		self.tabPlunderList[catMsg.catId] = obj	

		PoolManager:SpawnAsync(catMsg.catImage,"main",typeof(CS.UnityEngine.Sprite),false,function ( sprite )
            obj.transform:Find("cat_item_icon"):GetComponent("Image").sprite = sprite
        end)
		obj.transform:Find("cat_item_lv"):GetComponent("TextMeshProUGUI").text =  "LV." .. catMsg.level
		obj.transform:Find("cat_item_name"):GetComponent("TextMeshProUGUI").text =  catMsg.name
		obj.transform:Find("cat_item_name/Image/cat_item_staminaCount"):GetComponent("TextMeshProUGUI").text = tostring(catMsg.stamina)

		local tab = {}
		tab.obj = obj
		tab._obj__state_1 = obj.transform:Find("cat_item_state_1").gameObject
		tab._obj__state_2 = obj.transform:Find("cat_item_state_2").gameObject

		tab._obj_Complete = obj.transform:Find("cat_item_obj_Complete").gameObject
		tab._btn_collect = obj.transform:Find("cat_item_btn_collect"):GetComponent("Button")

		tab._obj_Consumption = obj.transform:Find("cat_item_obj_Consumption").gameObject
		tab._tex_Consumption_hour = obj.transform:Find("cat_item_obj_Consumption/tex_hour"):GetComponent("TextMeshProUGUI").text
		tab._tex_Consumption_min = obj.transform:Find("cat_item_obj_Consumption/tex_min"):GetComponent("TextMeshProUGUI").text
		tab._tex_Consumption_Stamina = obj.transform:Find("cat_item_obj_Consumption/get_icon_Stamina/get_count_Stamina"):GetComponent("TextMeshProUGUI").text
		tab._btn_SetOut = obj.transform:Find("cat_item_btn_SetOut"):GetComponent("Button")

		tab._obj_Remaining = obj.transform:Find("cat_item_obj_Remaining").gameObject	
		tab._tex_Remaining_hour = obj.transform:Find("cat_item_obj_Remaining/tex_hour"):GetComponent("TextMeshProUGUI").text
		tab._tex_Remaining_min = obj.transform:Find("cat_item_obj_Remaining/tex_min"):GetComponent("TextMeshProUGUI").text	
		tab._obj_wait = obj.transform:Find("cat_item_obj_wait").gameObject
							
		tab._item_select = obj.transform:Find("cat_item_select"):GetComponent("Toggle")
		tab._obj_mask = obj.transform:Find("cat_item_obj_mask").gameObject

		tab.isEnding = false
		tab.isRemaining = false
		tab.isTog = false
		tab.msg = catMsg

		self.tabPlunderMsgList[catMsg.catId] = tab

		if catMsg.status == 1 then

		else

		end

		-- tab._item_select.onValueChanged:RemoveAllListeners()
		-- tab._item_select.onValueChanged:AddListener(function ( isOn )                   
	    --     if(isOn) then            
	    --         self.tabPlunderMsgList[catMsg.catId].isTog = isOn  
	    --     end
	    -- end)
	end
end

function CountryardView.ClickCatAllSetOut()
	self.catlist_btn_AllSetOut:SetActive(false)
	self.catlist_btn_List:SetActive(true)
	--listopen both options	
	for k,v in pairs(self.tabPlunderMsgList) do
		if v.isEnding or v.isRemaining then
			v._obj_mask:SetActive(true)
		else
			v._btn_SetOut.gameObject:SetActive(false)
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
end

function CountryardView.ClickCatListConfirmBtn()
	-- MessageBox("TIPS","Are you sure you want to start playing?","Confirm",function ()
    --     
    -- end)
end

function CountryardView.ClickCatListCancelBtn()
	self.catlist_btn_AllSetOut:SetActive(true)
	self.catlist_btn_List:SetActive(false)
	--listturn off all options

	for k,v in pairs(self.tabPlunderMsgList) do
		if v.isEnding or v.isRemaining then
			v._obj_mask:SetActive(false)
		else
			v._btn_SetOut.gameObject:SetActive(true)
			v._item_select.gameObject:SetActive(false)	
			v.isTog = false		
		end
	end
end

function CountryardView.CloseCatList()
	self.catList:SetActive(false)
end

--the plunder panel list ends

--defensive panel list

function CountryardView.GetDefenseCatList()
	local GetDefenseCatListReq = {}
    GetDefenseCatListReq.token = playerData.baseData.data.token        
	PublicClient.SendMsgDefenseCatListReq(GetDefenseCatListReq,function(data)
		self.CreateDefenseList(data.catList)		
	end)	
end

function CountryardView.CreateDefenseList(catList)
	--DefenseCatListReq
	self.tabDefenseList = ClearObjs(self.tabDefenseList)
	self.tabDefenseMsgList = {}	
	for i,v in ipairs(catList) do
		local obj = GameObject.Instantiate(self.defense_item.gameObject,self.defenseRoot.transform)	
		local catMsg = v		
		self.tabDefenseList[catMsg.catId] = obj	

		PoolManager:SpawnAsync(catMsg.catImage,"main",typeof(CS.UnityEngine.Sprite),false,function ( sprite )
            obj.transform:Find("cat_item_icon"):GetComponent("Image").sprite = sprite
        end)
		obj.transform:Find("cat_item_lv"):GetComponent("TextMeshProUGUI").text =  "LV." .. catMsg.level
		obj.transform:Find("cat_item_name"):GetComponent("TextMeshProUGUI").text =  catMsg.name
		obj.transform:Find("cat_item_name/name_item/img_staminaIcon/cat_item_staminaCount"):GetComponent("TextMeshProUGUI").text = tostring(catMsg.stamina)	
		obj.transform:Find("cat_item_name/name_item/img_attributesIcon/cat_item_AttributesCount"):GetComponent("TextMeshProUGUI").text = tostring(catMsg.health)	

		local tab = {}
		tab._obj_Consumption = obj.transform:Find("cat_item_obj_Consumption").gameObject
		tab._tex_Consumption_hour = obj.transform:Find("cat_item_obj_Consumption/tex_hour"):GetComponent("TextMeshProUGUI")
		tab._tex_Consumption_min = obj.transform:Find("cat_item_obj_Consumption/tex_min"):GetComponent("TextMeshProUGUI")
		tab._tex_Consumption_Stamina = obj.transform:Find("cat_item_obj_Consumption/get_icon_Stamina/get_count_Stamina"):GetComponent("TextMeshProUGUI")

		tab._obj_ConsumptionTime = obj.transform:Find("cat_item_obj_ConsumptionTime").gameObject
		-- tab._tex_ConsumptionTime_hour = obj.transform:Find("cat_item_obj_ConsumptionTime/tex_hour"):GetComponent("TextMeshProUGUI")
		-- tab._tex_ConsumptionTime_min = obj.transform:Find("cat_item_obj_ConsumptionTime/tex_min"):GetComponent("TextMeshProUGUI")
		-- tab._tex_ConsumptionTime_Stamina = obj.transform:Find("cat_item_obj_ConsumptionTime/get_icon_Stamina/get_count_Stamina"):GetComponent("TextMeshProUGUI")

		tab._obj_Remaining = obj.transform:Find("cat_item_obj_Remaining").gameObject
		tab._tex_Remaining_hour = obj.transform:Find("cat_item_obj_Remaining/tex_hour"):GetComponent("TextMeshProUGUI")
		tab._tex_Remaining_min = obj.transform:Find("cat_item_obj_Remaining/tex_min"):GetComponent("TextMeshProUGUI")
		tab._tex_Remaining_Stamina = obj.transform:Find("cat_item_obj_Remaining/get_icon_Stamina/get_count_Stamina"):GetComponent("TextMeshProUGUI")

		tab._btn_Reduce = obj.transform:Find("cat_item_btn_Reduce"):GetComponent("Button")
		tab._btn_Add = obj.transform:Find("cat_item_btn_Add"):GetComponent("Button")
		tab._item_input = obj.transform:Find("cat_item_input"):GetComponent("TMP_InputField")

		tab._btn_Defense = obj.transform:Find("cat_item_btn_Defense"):GetComponent("Button")
		tab._obj_Indefense = obj.transform:Find("cat_item_obj_Indefense").gameObject
		
		tab._btn_Defense.onClick:RemoveAllListeners()		
		tab._btn_Reduce.onClick:RemoveAllListeners()
		tab._btn_Add.onClick:RemoveAllListeners()
		
		tab.msg = catMsg
		tab.defenseCount = 0
		self.tabDefenseMsgList[catMsg.catId] = tab

		if catMsg.status == 2 then
			tab._item_input.text = "-"
			tab._btn_Reduce.interactable = false
			tab._btn_Add.interactable = false
			tab._item_input.interactable = false

			tab._obj_Consumption:SetActive(false)
			tab._obj_ConsumptionTime:SetActive(false)
			tab._obj_Remaining:SetActive(true)
			tab._btn_Defense:SetActive(false)
			tab._obj_Indefense:SetActive(true)

			local _remainTime = math.floor(catMsg.endTime / 1000) - os.time()				
			local _hour = math.floor(_remainTime / 3600)
			local _min = math.floor((_remainTime - 3600 * _hour)/60)
			tab._tex_Remaining_hour.text = tostring(_hour)
			tab._tex_Remaining_min.text = tostring(_min)
			tab._tex_Remaining_Stamina.text = "10"
		else
			if catMsg.piCount == 0 then
				tab._item_input.text = "-"
				tab._btn_Reduce.interactable = false
				tab._btn_Add.interactable = false
				tab._btn_Defense.interactable = false
				tab._item_input.interactable = false

				tab._obj_Consumption:SetActive(false)
				tab._obj_ConsumptionTime:SetActive(true)
				tab._obj_Remaining:SetActive(false)
				tab._btn_Defense:SetActive(true)
				tab._obj_Indefense:SetActive(false)
			else
				tab._item_input.text = "1"
				self.tabDefenseMsgList[catMsg.catId].defenseCount = 1
				tab._btn_Reduce.interactable = false
				if catMsg.piCount == 1 then
					tab._btn_Add.interactable = false
				end
				self.SetDefenseMsg(catMsg.catId,self.tabDefenseMsgList[catMsg.catId].defenseCount)
				tab._btn_Reduce.onClick:AddListener(function()                   
			        self.tabDefenseMsgList[catMsg.catId].defenseCount = self.tabDefenseMsgList[catMsg.catId].defenseCount - 1
			        tab._btn_Add.interactable = true
			        if self.tabDefenseMsgList[catMsg.catId].defenseCount == 1 then
			        	tab._btn_Reduce.interactable = false
			        end
			        tab._item_input.text = tostring(self.tabDefenseMsgList[catMsg.catId].defenseCount)		
			        self.SetDefenseMsg(catMsg.catId,self.tabDefenseMsgList[catMsg.catId].defenseCount)	           
			    end)

			    tab._btn_Add.onClick:AddListener(function()                   
			        self.tabDefenseMsgList[catMsg.catId].defenseCount = self.tabDefenseMsgList[catMsg.catId].defenseCount + 1		
			        tab._btn_Reduce.interactable = true
			        if self.tabDefenseMsgList[catMsg.catId].defenseCount == catMsg.piCount then
			        	tab._btn_Add.interactable = false
			        end
			        tab._item_input.text = tostring(self.tabDefenseMsgList[catMsg.catId].defenseCount)
			        self.SetDefenseMsg(catMsg.catId,self.tabDefenseMsgList[catMsg.catId].defenseCount)          
			    end)
			    tab._item_input.onEndEdit:AddListener(function(endVal) 
			    	local inputN = tonumber(endVal)
			    	if inputN > catMsg.piCount then
			    		inputN = catMsg.piCount
			    	end   
			    	self.tabDefenseMsgList[catMsg.catId].defenseCount = inputN  
			    	tab._item_input.text = tostring(self.tabDefenseMsgList[catMsg.catId].defenseCount) 

			    	if self.tabDefenseMsgList[catMsg.catId].defenseCount == catMsg.piCount then
			        	tab._btn_Add.interactable = false
			        	if catMsg.piCount > 1 then
			        		tab._btn_Reduce.interactable = true
			        	end
			        end
			        if self.tabDefenseMsgList[catMsg.catId].defenseCount == 1 then
			        	tab._btn_Reduce.interactable = false
			        	if catMsg.piCount > 1 then
			        		tab._btn_Add.interactable = true
			        	end
			        end
				end)

			    tab._btn_Defense.onClick:AddListener(function()                   
			        self.SendMsgDefenseReq(catMsg.catId,self.tabCatMsgList[catMsg.catId].playCount)			           
			    end)
			end
		end
		obj:SetActive(true)	
	end

	self.catDefenseList:SetActive(true)
end

function CountryardView.SetDefenseMsg(catId,pCount)
	-- Debug.LogError(catId)
	
	local _remainTime = self.tabCatMsgList[catId].msg.useTime / 1000 * pCount
	local _hour = math.floor(_remainTime / 3600)
	local _min = math.floor((_remainTime - 3600 * _hour)/60)

	self.tabCatMsgList[catId]._tex_Consumption_hour.text = tostring(_hour)
	self.tabCatMsgList[catId]._tex_Consumption_min.text = tostring(_hour)
	self.tabCatMsgList[catId]._tex_Consumption_Stamina.text = 10 * pCount
end

function CountryardView.SendMsgDefenseReq(catId,pCount)
	if pCount == 0 then
		return
	end
	
    local GetDefenseReq = {}
    GetDefenseReq.token = playerData.baseData.data.token   
    GetDefenseReq.catId = catId
    -- GetPlayGroundReq.count = pCount
	PublicClient.SendMsgDefenseReq(GetDefenseReq,function(data)			
		self.GetDefenseCatList()
	end)   
end

function CountryardView.CloseDefenseList()
	self.catDefenseList:SetActive(false)
end
--the defense panel list ends

--seed related list---
--request seed list
function CountryardView.GetUserSeedList(_fieldId)
	self.fieldId = _fieldId
	local GetUserSeedReq = {}
    GetUserSeedReq.token = playerData.baseData.data.token 
    PublicClient.SendMsgUserSeedReq(GetUserSeedReq,function(data)			
		self.CreateCatgrassList(data.itemList)
	end)   
end

function CountryardView.CreateCatgrassList(itemList)
	self.tabCatgrassList = ClearObjs(self.tabCatgrassList)
	for i,v in ipairs(itemList) do
		local obj = GameObject.Instantiate(self.catgrass_item.gameObject,self.catgrassRoot.transform)
		self.tabCatgrassList[v.id] = obj
		local itemProps = v
		if(itemProps.type == 1 or itemProps.type == 2) then
            local itemData = item[itemProps.propId]                      
            obj.transform:Find("catgrass_item_count"):GetComponent("TextMeshProUGUI").text = itemProps.propCount
            obj.transform:Find("catgrass_item_name"):GetComponent("TextMeshProUGUI").text = itemData.name
            PoolManager:SpawnAsync(itemData.pic,"main",typeof(CS.UnityEngine.Sprite),false,function ( sprite )
                obj.transform:Find("catgrass_item_icon"):GetComponent("Image").sprite = sprite
            end)
            --catgrass_item_obj_Consumption
            obj.transform:Find("catgrass_item_obj_Consumption"):GetComponent("TextMeshProUGUI").text = "Projected Revenue:" .. itemProps.saleCount
        elseif(itemProps.type == 3) then
        elseif(itemProps.type == 4) then
        end        

        obj.transform:Find("catgrass_item_btn_Sow"):GetComponent("Button").onClick:RemoveAllListeners()
    	obj.transform:Find("catgrass_item_btn_Sow"):GetComponent("Button").onClick:AddListener(function()
    		self.SendSeedReq(itemProps.id)
    	end) 
		obj:SetActive(true)	
	end
	self.CatgrassList:SetActive(true)
end

function CountryardView.SendSeedReq(_itemId)
	local GetSeedReq = {}
    GetSeedReq.token = playerData.baseData.data.token 
    GetSeedReq.fieldId = self.fieldId
    GetSeedReq.itemId = _itemId
    PublicClient.SendMsgSeedReq(GetSeedReq,function(data)
    	self.CatgrassList:SetActive(false)
	end)
end

function CountryardView.CloseCatgrassList()
	self.CatgrassList:SetActive(false)
end
--end of seed-related list---

--unlock correlation--
function CountryardView.OpenUnlockcondition()
	self.condition_one_Count:GetComponent("TextMeshProUGUI").text = "<color=#ff0000>999</color>/1000"
	self.condition_two_Count:GetComponent("TextMeshProUGUI").text = "10/10"
	self.Unlockcondition:SetActive(true)
end

function CountryardView.CloseUnlockcondition()
	self.Unlockcondition:SetActive(false)
end
function CountryardView.SendUnLockFieldReq()
	local GetUnLockFieldReq = {}
    GetUnLockFieldReq.token = playerData.baseData.data.token 
    GetUnLockFieldReq.fieldId = self.fieldId
    
    PublicClient.SendMsgUnLockFieldReq(GetUnLockFieldReq,function(data)
    	self.Unlockcondition:SetActive(false)
	end)
end
--unlock related end

function CountryardView.OnDestroy()
	self.tabPlunderMsgList = nil
	self.tabDefenseMsgList = nil
end
