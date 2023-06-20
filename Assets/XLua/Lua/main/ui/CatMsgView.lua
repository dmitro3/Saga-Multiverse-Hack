CatMsgView = {}
local self = CatMsgView
local actionIds = {401,402,403,404}

--220910
function CatMsgView.Start( ... )
    -- body
    self.curCatModule = nil
    self.isLeaving = true
    self.chooseCatIndex = 0
    self.btn_quit:GetComponent("Button").onClick:RemoveAllListeners()
    self.btn_quit:GetComponent("Button").onClick:AddListener(self.Quit)
    MainStart.UICatCamera:SetActive(true)
    self.InitCats()
end


function CatMsgView.Update( ... )
    -- body
end


function CatMsgView.OnDestroy( ... )
    -- body
    self.isLeaving = false
    TimeManager:OverTime("cur_cat_hunger")
    TimeManager:OverTime("cur_cat_thirsty")
    TimeManager:OverTime("cur_cat_clean")
    TimeManager:OverTime("cur_cat_happiness")
end


function CatMsgView.Quit( ... )
    -- body
    MainStart.UICatCamera:SetActive(false)
    CS.RoleController.Instance.gameObject:SetActive(true)
    UIManager:ShowUIAsync("main","main_view")
    UIManager:DelUI("cat_msg_view")
end


function CatMsgView.InitCats( chooseCatIndex )
    -- body
    GetUserCatList(function ( data )
        -- body
        self.catHeads = ClearObjs(self.catHeads)
        for i=1,#playerData.catList do
            local CatModule = playerData.catList[i]
            Debug.LogWarning("catId = "..CatModule.catId)
            local obj = GameObject.Instantiate(self.item_cat,self.item_cat.transform.parent)
            self.catHeads[CatModule.catId] = obj
            obj:SetActive(true)
            obj.transform:Find("text_cat_name"):GetComponent("TextMeshProUGUI").text = CatModule.name
            obj.transform:Find("text_cat_level"):GetComponent("TextMeshProUGUI").text = "LV."..CatModule.level
            obj:GetComponent("Toggle").onValueChanged:RemoveAllListeners()
            obj:GetComponent("Toggle").onValueChanged:AddListener(function ( isOn )
                -- body
                if(isOn) then
                    self.chooseCatIndex = CatModule.catId
                    self.ShowChooseCurCatMsg(CatModule)
                    self.ShowCatActions(CatModule)
                end
            end)
            obj:GetComponent("Toggle").isOn = true
        end

        if(chooseCatIndex) then
            self.catHeads[chooseCatIndex]:GetComponent("Toggle").isOn = true
        end
    end)


end


function CatMsgView.ShowBoxUpLevel( CatModule )
    -- body
    self.box_level_up:SetActive(true)
    self.text_cur_level:GetComponent("TextMeshProUGUI").text = "level "..tostring(CatModule.level)
    self.text_next_level:GetComponent("TextMeshProUGUI").text = "level "..tostring(CatModule.level + 1)
    self.text_cur_loverly_num:GetComponent("TextMeshProUGUI").text = CatModule.charm
    self.text_next_loverly_num:GetComponent("TextMeshProUGUI").text  = tostring(CatModule.charm + CatModule.charmAdd)
    self.text_cur_strong_num:GetComponent("TextMeshProUGUI").text = CatModule.strength
    self.text_next_strong_num:GetComponent("TextMeshProUGUI").text = tostring(CatModule.strength + CatModule.strengthAdd)
    self.text_cost_num:GetComponent("TextMeshProUGUI").text = cat_level[CatModule.level].cost[3]
    self.btn_upgrade:GetComponent("Button").onClick:RemoveAllListeners()
    self.btn_upgrade:GetComponent("Button").onClick:AddListener(function ( ... )
        -- body
        self.SendMsgUpCatLevelReq( CatModule )
    end)
end

function  CatMsgView.SendMsgUpCatLevelReq( CatModule )
    -- body
    local UpCatLevelReq = {}
    UpCatLevelReq.token = playerData.baseData.data.token
    UpCatLevelReq.catId = CatModule.catId
    PublicClient.SendMsgUpCatLevelReq(UpCatLevelReq,function ( data )
        -- body
        self.box_level_up:SetActive(false)
        self.ShowBoxUpLevelResult(CatModule)
        --update cat properties，update backpack
        self.InitCats( self.chooseCatIndex )
        GetUserItems()
    end)
end

function CatMsgView.ShowBoxUpLevelResult( CatModule )
    -- body
    self.box_level_up_result:SetActive(true)
    self.text_cur_cat_level_result:GetComponent("TextMeshProUGUI").text = "Level   "..tostring(CatModule.level+1)
    self.text_cur_loverly_num_result:GetComponent("TextMeshProUGUI").text = CatModule.charm
    self.text_next_loverly_num_result:GetComponent("TextMeshProUGUI").text  = tostring(CatModule.charm + CatModule.charmAdd)
    self.text_cur_strong_num_result:GetComponent("TextMeshProUGUI").text = CatModule.strength
    self.text_next_strong_num_result:GetComponent("TextMeshProUGUI").text = tostring(CatModule.strength + CatModule.strengthAdd)

end



function CatMsgView.ShowCatActions( CatModule )
    -- body
    self.actionObjs = ClearObjs(self.actionObjs)
    for i=1,#actionIds do
        local id = actionIds[i]
        local actionData = cat_action[id]
        local obj = GameObject.Instantiate(self.item_action,self.item_action.transform.parent)
        self.actionObjs[id] = obj
        obj:SetActive(true)
        PoolManager:SpawnAsync(actionData.pic,"main",typeof(CS.UnityEngine.Sprite),false,function ( sprite )
            obj.transform:Find("icon_action"):GetComponent("Image").sprite = sprite
        end)
        if(CatModule.intimacy < actionData.needIntimacy) then
            obj.transform:Find("icon_action"):GetComponent("CanvasGroup").alpha = 0.5
        else
            obj.transform:Find("icon_action"):GetComponent("CanvasGroup").alpha = 1
        end

        local PointerDown = obj:GetComponent("EventTrigger").triggers[0]
        PointerDown.callback:AddListener(function ( data )
            -- body
            self.box_action:SetActive(true)
            self.icon_cur_action:GetComponent("Image").sprite = obj.transform:Find("icon_action"):GetComponent("Image").sprite
            self.text_action_name:GetComponent("TextMeshProUGUI").text = actionData.name
            self.text_action_basics:GetComponent("TextMeshProUGUI").text = "Unlocking: \nIntimacy reached "..actionData.needIntimacy
            self.text_action_doc:GetComponent("TextMeshProUGUI").text = actionData.actionIntro
            if(CatModule.intimacy < actionData.needIntimacy) then
                self.icon_cur_action:GetComponent("CanvasGroup").alpha = 0.5
            else
                self.icon_cur_action:GetComponent("CanvasGroup").alpha = 1
            end
        end)

        local PointerUp = obj:GetComponent("EventTrigger").triggers[1]
        PointerUp.callback:AddListener(function ( data )
            -- body
            self.box_action:SetActive(false)
        end)
        
    end
end



function CatMsgView.ShowChooseCurCatMsg( CatModule )
    -- body
    self.curCatModule = CatModule
    self.text_cur_cat_name:GetComponent("TextMeshProUGUI").text = CatModule.name
    if(CatModule.sex == 1) then
        self.cur_cat_sex_1:SetActive(true)
        self.cur_cat_sex_2:SetActive(false)
    else
        self.cur_cat_sex_1:SetActive(false)
        self.cur_cat_sex_2:SetActive(true)
    end
    self.text_cur_cat_level:GetComponent("TextMeshProUGUI").text = "LV."..CatModule.level
    local maxGrowth = cat_level[CatModule.level].levelNext
    self.text_cur_cat_level_progress:GetComponent("TextMeshProUGUI").text = CatModule.growth.."/"..maxGrowth
    self.progress_cur_cat_level:GetComponent("Slider").value = CatModule.growth/maxGrowth
    self.btn_cur_cat_upgrade:GetComponent("Button").onClick:RemoveAllListeners()
    self.btn_cur_cat_upgrade:GetComponent("Button").onClick:AddListener(function ( ... )
        -- body
        if(CatModule.status == 0) then
            self.ShowBoxUpLevel(CatModule)
        else
            ShowMainBoxMsg("Your cat is not at home and can't do anything.")
        end
    end)

    self.progress_cur_cat_healthy:GetComponent("Slider").value = CatModule.health/100

    self.text_cur_cat_lovely_num:GetComponent("TextMeshProUGUI").text = CatModule.charm
    self.text_cur_cat_lovely_add:GetComponent("TextMeshProUGUI").text = "(+"..CatModule.charmAdd..")"

    self.text_cur_cat_strong_num:GetComponent("TextMeshProUGUI").text = CatModule.strength
    self.text_cur_cat_strong_add:GetComponent("TextMeshProUGUI").text = "(+"..CatModule.strengthAdd..")"

    local yearNum = math.floor((TimeManager.Now - CatModule.birthday) / (1000*60*60*CatModule.ageCoefficient*365))
    local dayNum = math.floor((TimeManager.Now - CatModule.birthday) / (1000*60*60*CatModule.ageCoefficient) - (yearNum * 365))
    local strAge = ""
    if(yearNum == 0) then
        if(dayNum > 1) then
            strAge = tostring(dayNum).." Days"
        else
            strAge = "1 Day"
        end
    else
        if(yearNum > 1) then
            strAge = tostring(yearNum).." Years"
        elseif(yearNum == 1) then
            strAge = "1 Year"
        end

        if(dayNum > 1) then
            strAge = strAge.." & "..tostring(dayNum).." Days"
        elseif(dayNum == 1) then
            strAge = strAge.."& 1 Day"
        end
    end
    self.text_cur_cat_age:GetComponent("TextMeshProUGUI").text = strAge
    local birthday = TimeManager:GetDateTime(CatModule.birthday,-5)
    self.text_cur_cat_birthday:GetComponent("TextMeshProUGUI").text = birthday:ToString("MMMM", CS.System.Globalization.CultureInfo("en-us")).." "..birthday:ToString("dd").." "..birthday.Year

    self.text_cur_cat_generation:GetComponent("TextMeshProUGUI").text = ConvertToRoman(CatModule.generation)
    --1 Maverick 2 Sticky 3 Lively 4 Timid 5 Lazy
    local characterTab = {"Maverick","Sticky","Lively","Timid","Lazy"}
    self.text_cur_cat_character:GetComponent("TextMeshProUGUI").text = characterTab[CatModule.character]

    self.UpdateHungerState(CatModule)
    local food_time_offset = CatModule.maxHungerTime - TimeManager:GetTimeStamp(false)
    TimeManager:StartTime("cur_cat_hunger",0,1,false,function ( t )
        if(self.isLeaving) then
            CatModule.maxHungerTime = TimeManager:GetTimeStamp(false) + food_time_offset
            self.UpdateHungerState(CatModule)
        end
    end)
    self.UpdateThirstyState( CatModule )
    local water_time_offset = CatModule.maxThirstyTime - TimeManager:GetTimeStamp(false)
    TimeManager:StartTime("cur_cat_thirsty",0,1,false,function ( t )
        if(self.isLeaving) then
            CatModule.maxThirstyTime = TimeManager:GetTimeStamp(false) + water_time_offset
            self.UpdateThirstyState(CatModule)
        end
    end)
    self.UpdateCleanState( CatModule )
    local clean_time_offset = CatModule.maxCleanTime - TimeManager:GetTimeStamp(false)
    TimeManager:StartTime("cur_cat_clean",0,1,false,function ( t )
        if(self.isLeaving) then
            CatModule.maxCleanTime = TimeManager:GetTimeStamp(false) + clean_time_offset
            self.UpdateCleanState(CatModule)
        end
    end)

    self.UpdateStaminaState(CatModule)

    self.UpdateHappinessState(CatModule)
    local happiness_time_offset = CatModule.maxHappinessTime - TimeManager:GetTimeStamp(false)
    TimeManager:StartTime("cur_cat_happiness",0,1,false,function ( t )
        if(self.isLeaving) then
            CatModule.maxHappinessTime = TimeManager:GetTimeStamp(false) + happiness_time_offset
            self.UpdateHappinessState(CatModule)
        end
    end)
end


function CatMsgView.UpdateHungerState( CatModule )
    -- body
    local food_val = math.ceil(CatModule.maxHungerNumerial - (CatModule.maxHungerTime - CatModule.nowHungerTime) / CatModule.everyTimeHungerTime)
    self.food_empty:SetActive(false)
    if(food_val > CatModule.maxHungerNumerial / 2) then
        self.icon_cur_cat_food_1:SetActive(true)
        self.icon_cur_cat_food_2:SetActive(false)
        self.progress_cur_cat_food_1:GetComponent("Slider").value = food_val / CatModule.maxHungerNumerial
    else
        if(food_val <= 0) then
            food_val = 0
            self.food_empty:SetActive(true)
        end
        self.icon_cur_cat_food_1:SetActive(false)
        self.icon_cur_cat_food_2:SetActive(true)
        self.progress_cur_cat_food_2:GetComponent("Slider").value = food_val / CatModule.maxHungerNumerial
    end
end

function CatMsgView.UpdateThirstyState( CatModule )
    -- body
    local water_val = math.ceil(CatModule.maxThirstyNumerial - (CatModule.maxThirstyTime - CatModule.nowThirstyTime) / CatModule.everyTimeThirstyTime)
    self.water_empty:SetActive(false)
    if(water_val > CatModule.maxThirstyNumerial / 2) then
        self.icon_cur_cat_water_1:SetActive(true)
        self.icon_cur_cat_water_2:SetActive(false)
        self.progress_cur_cat_water_1:GetComponent("Slider").value = water_val / CatModule.maxThirstyNumerial
    else
        if(water_val <= 0) then
            water_val = 0
            self.water_empty:SetActive(true)
        end
        self.icon_cur_cat_water_1:SetActive(false)
        self.icon_cur_cat_water_2:SetActive(true)
        self.progress_cur_cat_water_2:GetComponent("Slider").value = water_val / CatModule.maxThirstyNumerial
    end
end

function CatMsgView.UpdateCleanState( CatModule )
    -- body
    local clean_val = math.ceil(CatModule.maxCleanNumerial - (CatModule.maxCleanTime - CatModule.nowCleanTime) / CatModule.everyTimeCleanTime)
    -- Debug.LogError(clean_val)
    self.clean_empty:SetActive(false)
    if(clean_val > CatModule.maxCleanNumerial / 2) then
        self.icon_cur_cat_clean_1:SetActive(true)
        self.icon_cur_cat_clean_2:SetActive(false)
        self.progress_cur_cat_clean_1:GetComponent("Slider").value = clean_val / CatModule.maxCleanNumerial
    else
        if(clean_val <= 0) then
            clean_val = 0
            self.clean_empty:SetActive(true)
        end
        self.icon_cur_cat_clean_1:SetActive(false)
        self.icon_cur_cat_clean_2:SetActive(true)
        self.progress_cur_cat_clean_2:GetComponent("Slider").value = clean_val / CatModule.maxCleanNumerial
    end
end

function CatMsgView.UpdateStaminaState( CatModule )
    self.stamina_empty:SetActive(false)
    if(CatModule.stamina > 0) then
        self.icon_cur_cat_stamina_1:SetActive(true)
        self.icon_cur_cat_stamina_2:SetActive(false)
        self.progress_cur_cat_stamina_1:GetComponent("Slider").value = CatModule.stamina / CatModule.maxStaminaNumerial
    else
        self.icon_cur_cat_stamina_1:SetActive(false)
        self.icon_cur_cat_stamina_2:SetActive(true)
        self.progress_cur_cat_stamina_2:GetComponent("Slider").value = 0
    end
end


function CatMsgView.UpdateHappinessState( CatModule )
    -- body

    local happiness_val = math.floor(CatModule.maxHappinessNumerial - (CatModule.maxHappinessTime - CatModule.nowHappinessTime) / CatModule.everyTimeHappinessTime)
    if(happiness_val < 0) then
        happiness_val = 0
    end
    self.progress_heart:GetComponent("Image").fillAmount = happiness_val / CatModule.maxHappinessNumerial
    self.text_intimacy_num:GetComponent("TextMeshProUGUI").text = CatModule.intimacy

    self.btn_heart:GetComponent("Button").onClick:RemoveAllListeners()
    self.btn_heart:GetComponent("Button").onClick:AddListener(function ( ... )
        -- body
        self.ShowAwards(CatModule)
    end)
end


function CatMsgView.TouchDown( data )
    -- body
    if(data.pointerEnter) then
        local CatModule = self.curCatModule
        local cat_msg = nil
        local isSubMsg = false
        local attributeNum = ""
        local attributeBasicsNum = ""
        local attributeGrowthBonusNum = ""
        if(self.icon_cur_cat_healthy == data.pointerEnter) then
            cat_msg = cat_attribute_intro[1]
            attributeNum = CatModule.health
        elseif(self.icon_cur_cat_food_1 == data.pointerEnter or self.icon_cur_cat_food_2 == data.pointerEnter) then
            cat_msg = cat_attribute_intro[2]
            local food_val = math.ceil(CatModule.maxHungerNumerial - (CatModule.maxHungerTime - CatModule.nowHungerTime) / CatModule.everyTimeHungerTime)
            attributeNum = food_val
        elseif(self.icon_cur_cat_water_1 == data.pointerEnter or self.icon_cur_cat_water_2 == data.pointerEnter) then
            cat_msg = cat_attribute_intro[3]
            local water_val = math.ceil(CatModule.maxThirstyNumerial - (CatModule.maxThirstyTime - CatModule.nowThirstyTime) / CatModule.everyTimeThirstyTime)
            attributeNum = water_val
        elseif(self.icon_cur_cat_clean_1 == data.pointerEnter or self.icon_cur_cat_clean_2 == data.pointerEnter) then
            cat_msg = cat_attribute_intro[4]
            local clean_val = math.ceil(CatModule.maxCleanNumerial - (CatModule.maxCleanTime - CatModule.nowCleanTime) / CatModule.everyTimeCleanTime)
            attributeNum = clean_val
        elseif(self.icon_cur_cat_stamina_1 == data.pointerEnter or self.icon_cur_cat_stamina_2 == data.pointerEnter) then
            cat_msg = cat_attribute_intro[11]
            attributeNum = CatModule.stamina
        elseif(self.text_strong == data.pointerEnter or self.icon_strong == data.pointerEnter) then
            cat_msg = cat_attribute_intro[5]
            isSubMsg = true
            attributeBasicsNum = CatModule.basicsStrength
            attributeGrowthBonusNum = CatModule.strengthAdd
            attributeNum = CatModule.strength
        elseif(self.text_lovely == data.pointerEnter or self.icon_lovely == data.pointerEnter) then
            cat_msg = cat_attribute_intro[6]
            isSubMsg = true
            attributeBasicsNum = CatModule.basicsCharm
            attributeGrowthBonusNum = CatModule.charmAdd
            attributeNum = CatModule.charm
        elseif(self.age == data.pointerEnter) then
            cat_msg = cat_attribute_intro[7]
        elseif(self.birthday == data.pointerEnter) then
            cat_msg = cat_attribute_intro[8]
        elseif(self.generation == data.pointerEnter) then
            cat_msg = cat_attribute_intro[9]
        elseif(self.character == data.pointerEnter) then
            cat_msg = cat_attribute_intro[10]
        end

        if(attributeNum ~= "") then
            if(attributeNum < 0) then
                attributeNum = 0
            end
        end

        if(cat_msg) then
            self.box_attribute:SetActive(true)
            self.text_attribute_basics:SetActive(isSubMsg)
            self.text_attribute_growth_bonus:SetActive(isSubMsg)
            self.text_attribute_num:GetComponent("TextMeshProUGUI").text = attributeNum
            self.text_attribute_basics_num:GetComponent("TextMeshProUGUI").text = attributeBasicsNum
            self.text_attribute_growth_bonus_num:GetComponent("TextMeshProUGUI").text = attributeGrowthBonusNum
            local pot = Vector3(self.bg_attribute_box.transform.position.x,data.pointerEnter.transform.position.y,0)
            self.bg_attribute_box.transform.position = pot
            self.text_attribute_name:GetComponent("TextMeshProUGUI").text = cat_msg.name
            self.text_attribute_doc:GetComponent("TextMeshProUGUI").text = cat_msg.intro
        end
    end
end

function CatMsgView.TouchUp( data )
    -- body
    self.box_attribute:SetActive(false)
end


function CatMsgView.ShowAwards( CatModule )
    -- body
    self.panel_normal:SetActive(false)
    self.panel_award:SetActive(true)
    self.awardObjs = ClearObjs(self.awardObjs)
    for i=1,#intimacy_reward do
        local rewardData = intimacy_reward[i]
        local obj = GameObject.Instantiate(self.tog_award,self.tog_award.transform.parent)
        self.awardObjs[i] = obj
        obj:SetActive(true)
        local lockObj = obj.transform:Find("lock").gameObject
        local unlockObj = obj.transform:Find("unlock").gameObject
        local itemObj = obj.transform:Find("group/item_award").gameObject
        local picName = ""
        local awardNum = ""
        if(CatModule.intimacy < rewardData.needIntimacy) then
            lockObj:SetActive(true)
            unlockObj:SetActive(false)
            lockObj.transform:Find("text_num"):GetComponent("TextMeshProUGUI").text = rewardData.needIntimacy
            
            if(rewardData.reward[1] == 1 or rewardData.reward[1] == 2) then
                local itemAwardObj = GameObject.Instantiate(itemObj,itemObj.transform.parent)
                itemAwardObj:SetActive(true)
                local itemID = rewardData.reward[2]
                local itemData = item[itemID]
                picName = itemData.pic.."_g"
                awardNum = rewardData.reward[3]
                PoolManager:SpawnAsync(picName,"main",typeof(CS.UnityEngine.Sprite),false,function ( sprite )
                    itemAwardObj.transform:Find("icon"):GetComponent("Image").sprite = sprite
                end)
                itemAwardObj.transform:Find("text_num"):GetComponent("TextMeshProUGUI").text = awardNum
        
            elseif(rewardData.reward[1] == 4) then
                local itemAwardObj = GameObject.Instantiate(itemObj,itemObj.transform.parent)
                itemAwardObj:SetActive(true)
                local actionID = rewardData.reward[2]
                local actionData = cat_action[actionID]
                picName = actionData.pic
                PoolManager:SpawnAsync(picName,"main",typeof(CS.UnityEngine.Sprite),false,function ( sprite )
                    itemAwardObj.transform:Find("icon"):GetComponent("Image").sprite = sprite
                end)
                itemAwardObj.transform:Find("text_num"):GetComponent("TextMeshProUGUI").text = awardNum
        
            else
                for n=1,#rewardData.reward do
                    local tab = rewardData.reward[n]
                    local itemAwardObj = GameObject.Instantiate(itemObj,itemObj.transform.parent)
                    itemAwardObj:SetActive(true)
                    if(tab[1] == 1 or tab[1] == 2) then
                        local itemID = tab[2]
                        local itemData = item[itemID]
                        picName = itemData.pic.."_g"
                        awardNum = tab[3]
                    elseif(tab[1] == 4) then
                        local actionID = tonumber(tab[2]) 
                        local actionData = cat_action[actionID]
                        picName = actionData.pic
                    end
                    PoolManager:SpawnAsync(picName,"main",typeof(CS.UnityEngine.Sprite),false,function ( sprite )
                        itemAwardObj.transform:Find("icon"):GetComponent("Image").sprite = sprite
                    end)
                    itemAwardObj.transform:Find("text_num"):GetComponent("TextMeshProUGUI").text = awardNum
                end
            end
            
        else
            lockObj:SetActive(false)
            unlockObj:SetActive(true)
            unlockObj.transform:Find("text_num"):GetComponent("TextMeshProUGUI").text = rewardData.needIntimacy

            if(rewardData.reward[1] == 1 or rewardData.reward[1] == 2) then
                local itemAwardObj = GameObject.Instantiate(itemObj,itemObj.transform.parent)
                itemAwardObj:SetActive(true)
                local itemID = rewardData.reward[2]
                local itemData = item[itemID]
                picName = itemData.pic
                awardNum = rewardData.reward[3]
                PoolManager:SpawnAsync(picName,"main",typeof(CS.UnityEngine.Sprite),false,function ( sprite )
                    itemAwardObj.transform:Find("icon"):GetComponent("Image").sprite = sprite
                end)
                itemAwardObj.transform:Find("text_num"):GetComponent("TextMeshProUGUI").text = awardNum
        
            elseif(rewardData.reward[1] == 4) then
                local itemAwardObj = GameObject.Instantiate(itemObj,itemObj.transform.parent)
                itemAwardObj:SetActive(true)
                local actionID = rewardData.reward[2]
                local actionData = cat_action[actionID]
                picName = actionData.pic
                PoolManager:SpawnAsync(picName,"main",typeof(CS.UnityEngine.Sprite),false,function ( sprite )
                    itemAwardObj.transform:Find("icon"):GetComponent("Image").sprite = sprite
                end)
                itemAwardObj.transform:Find("text_num"):GetComponent("TextMeshProUGUI").text = awardNum
        
            else
                for n=1,#rewardData.reward do
                    local tab = rewardData.reward[n]
                    local itemAwardObj = GameObject.Instantiate(itemObj,itemObj.transform.parent)
                    itemAwardObj:SetActive(true)
                    if(tab[1] == 1 or tab[1] == 2) then
                        local itemID = ttab[2]
                        local itemData = item[itemID]
                        picName = itemData.pic
                        awardNum = tab[3]
                    elseif(tab[1] == 4) then
                        local actionID = tab[2]
                        local actionData = cat_action[actionID]
                        picName = actionData.pic
                    end
                    PoolManager:SpawnAsync(picName,"main",typeof(CS.UnityEngine.Sprite),false,function ( sprite )
                        itemAwardObj.transform:Find("icon"):GetComponent("Image").sprite = sprite
                    end)
                    itemAwardObj.transform:Find("text_num"):GetComponent("TextMeshProUGUI").text = awardNum
                end
            end
        end
        
        
    end
end


