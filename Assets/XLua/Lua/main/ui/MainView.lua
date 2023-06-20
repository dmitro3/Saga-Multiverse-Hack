require "public/data/globle/globleData"
MainView = {}
local self = MainView

function MainView.Start( ... )
    -- body
    CheckYield()
    self.btn_menu_cats:GetComponent("Button").onClick:RemoveAllListeners()
    self.btn_menu_cats:GetComponent("Button").onClick:AddListener(self.OnClickMenuCats)
    
    self.btn_menu_toilet:GetComponent("Button").onClick:RemoveAllListeners()
    self.btn_menu_toilet:GetComponent("Button").onClick:AddListener(self.OnClickToilet)
    self.btn_menu_bowl:GetComponent("Button").onClick:RemoveAllListeners()
    self.btn_menu_bowl:GetComponent("Button").onClick:AddListener(self.OnClickFood)
    self.btn_menu_board:GetComponent("Button").onClick:RemoveAllListeners()
    self.btn_menu_board:GetComponent("Button").onClick:AddListener(self.OnClickBoard)
    self.btn_menu_nest:GetComponent("Button").onClick:RemoveAllListeners()
    self.btn_menu_nest:GetComponent("Button").onClick:AddListener(self.OnClickHouse)
    self.btn_shop:GetComponent("Button").onClick:RemoveAllListeners()
    self.btn_shop:GetComponent("Button").onClick:AddListener(self.OnClickShop)
    self.btn_pack:GetComponent("Button").onClick:RemoveAllListeners()
    self.btn_pack:GetComponent("Button").onClick:AddListener(self.OnClickMenuPackage)
    self.btn_mission:GetComponent("Button").onClick:RemoveAllListeners()
    self.btn_mission:GetComponent("Button").onClick:AddListener(self.OnClickMission)
    self.btn_map:GetComponent("Button").onClick:RemoveAllListeners()
    self.btn_map:GetComponent("Button").onClick:AddListener(self.OnClickMap)
    self.btn_hospital:GetComponent("Button").onClick:RemoveAllListeners()
    self.btn_hospital:GetComponent("Button").onClick:AddListener(self.OnClickHospital)
    self.btn_email:GetComponent("Button").onClick:RemoveAllListeners()
    self.btn_email:GetComponent("Button").onClick:AddListener(self.OnClickMail)

    self.btn_aid_station:GetComponent("Button").onClick:RemoveAllListeners()
    self.btn_aid_station:GetComponent("Button").onClick:AddListener(self.ShowShelter)

    self.btn_amusement_park:GetComponent("Button").onClick:RemoveAllListeners()
    self.btn_amusement_park:GetComponent("Button").onClick:AddListener(self.ShowPlayGround)    

    self.OnEnable()
end


function MainView.OnEnable( ... )
    -- body
    self.InitPlayerDatas()
    self.InitDatas()
    self.InitCatRoomUI()
    self.UpdateAllStates()
end

function MainView.InitPlayerDatas()
    GetUserInfo(function ( data )
        -- body
        self.text_player_name:GetComponent("TextMeshProUGUI").text = playerData.userInfo.userName
        if(playerData.userInfo.sex == 1) then
            self.icon_man:SetActive(true)
            self.icon_woman:SetActive(false)
        else
            self.icon_man:SetActive(false)
            self.icon_woman:SetActive(true)
        end
        self.text_charitable_num:GetComponent("TextMeshProUGUI").text = playerData.userInfo.charitableValue
    end)
end


function MainView.InitDatas( ... )
    -- body
    for i=1,#playerData.itemList do
        local ItemModule = playerData.itemList[i]
        --Debug.LogError("ItemModule.propId = "..ItemModule.propId)
        if(ItemModule.propId == 10001) then
            self.text_paw_num:GetComponent("TextMeshProUGUI").text = ItemModule.propCount
        end
        if(ItemModule.propId == 10002) then
            self.text_zoo_num:GetComponent("TextMeshProUGUI").text = ItemModule.propCount
        end
    end
end




function MainView.UpdateAllStates( ... )
    -- body
    self.stateObjs = ClearObjs(self.stateObjs)
    --diagnosis of illness status
    GetUserCatList(function ( data )
        self.illCats = {}
        for i=1,#playerData.catList do
            local CatModule = playerData.catList[i]
            if(CatModule.status == 0 and CatModule.sick ~= 0) then
                local hintData = hint[1]
                if(self.stateObjs[1] == nil) then
                    local obj = GameObject.Instantiate(self.item_state_msg,self.item_state_msg.transform.parent)
                    obj:SetActive(true)
                    self.stateObjs[1] = obj
                    self.CheckShowAllStateFlag()
                    obj.transform:Find("text_state_msg"):GetComponent("TextMeshProUGUI").text = hintData.content
                    PoolManager:SpawnAsync(hintData.pic,"main",typeof(CS.UnityEngine.Sprite),false,function ( sprite )
                        obj.transform:Find("icon"):GetComponent("Image").sprite = sprite
                        obj.transform:Find("icon"):GetComponent("Image"):SetNativeSize()
                    end)
                    obj:GetComponent("Button").onClick:RemoveAllListeners()
                    obj:GetComponent("Button").onClick:AddListener(function ( ... )
                        -- body
                        if(#self.illCats > 0) then
                            self.ShowBoxStateMsg(hintData.tips,function ( ... )
                                -- body
                                self.SendMsgSendToHospitalReq(self.illCats,function ( ... )
                                    -- body
                                    --hidden cat
                                    for i=1,#self.illCats do
                                        MainStart.HideCat( self.illCats[i] )
                                    end
                                    --open the hospital
                                    self.GoToHospital()
                                    --remove label
                                    local objFlag = self.stateObjs[1]
                                    GameObject.Destroy(objFlag)
                                    self.stateObjs[1] = nil
                                    --clear data
                                    self.illCats = {}
                                end)
                            end)
                        else
                            local objFlag = self.stateObjs[1]
                            GameObject.Destroy(objFlag)
                            self.stateObjs[1] = nil
                        end
                    end)
                end
                table.insert(self.illCats,CatModule.catId)
            end
        end
    end)
end


function MainView.ShowBoxStateMsg(msg,okCallback,quitCallback)
    UIManager:ShowUIAsync("main","box_state_msg",nil,function ( obj )
        -- body
        obj.transform:Find("text_msg"):GetComponent("TextMeshProUGUI").text = msg
        obj.transform:Find("btn_ok"):GetComponent("Button").onClick:RemoveAllListeners()
        obj.transform:Find("btn_ok"):GetComponent("Button").onClick:AddListener(function ( ... )
            -- body
            if(okCallback) then
                okCallback()
            end
            UIManager:DelUI("box_state_msg")
        end)
        obj.transform:Find("btn_quit"):GetComponent("Button").onClick:RemoveAllListeners()
        obj.transform:Find("btn_quit"):GetComponent("Button").onClick:AddListener(function ( ... )
            -- body
            if(quitCallback) then
                quitCallback()
            end
            UIManager:DelUI("box_state_msg")
        end)
    end)
end

function MainView.SendMsgSendToHospitalReq( illCats,callback )
    -- body
    local SendToHospitalReq = {}
    SendToHospitalReq.token = playerData.baseData.data.token
    SendToHospitalReq.catIds = illCats
    PublicClient.SendMsgSendToHospitalReq(SendToHospitalReq,function ( data )
        -- body
        if(callback) then
            callback()
        end
    end)
end



function MainView.InitCatRoomUI( ... )
    -- body
    self.catStateObjs = ClearObjs(self.catStateObjs)
    self.catCallObjs = ClearObjs(self.catCallObjs)
    for i,v in pairs(_G["Cats"]) do
        local catId = i
        local catObj = v.catObj
        local catCtrl = v.catCtrl
        local catStateObj = GameObject.Instantiate(self.btn_cat_state,self.btn_cat_state.transform.parent)
        catStateObj.name = "btn_cat_state_"..catId
        v.catStateObj = catStateObj
        catStateObj:GetComponent("CatState").cat = catCtrl
        catStateObj:SetActive(true)
        self.catStateObjs[catId] = catStateObj
        catStateObj.transform:Find("btn_emo"):GetComponent("Button").onClick:RemoveAllListeners()
        catStateObj.transform:Find("btn_emo"):GetComponent("Button").onClick:AddListener(function ( ... )
            v:CheckStroke(function ( isStroke )
                -- body
                if(isStroke) then
                    self.touchCatId = catId
                    UIManager:ShowUIAsync("main","touch_cat_view",nil,function ( ... )
                        -- body
                        CS.RoleController.Instance.gameObject:GetComponent("TouchCat"):SetTarget(catCtrl,true)
                        UIManager:HideUI("main_view")
                    end)
                else
                    Debug.LogError("refuse to be wanked")
                end

            end)
            
        end)

        if(v.CatModule.status == 0) then
            local catCallObj = GameObject.Instantiate(self.item_call_cat,self.item_call_cat.transform.parent)
            catCallObj:SetActive(true)
            self.catCallObjs[catId] = catCallObj
            catCallObj.transform:Find("text_call_cat_name"):GetComponent("TextMeshProUGUI").text = playerData.catMap[catId].name
            catCallObj.transform:Find("text_call_cat_level"):GetComponent("TextMeshProUGUI").text = playerData.catMap[catId].level
            catCallObj:GetComponent("Button").onClick:RemoveAllListeners()
            catCallObj:GetComponent("Button").onClick:AddListener(function ( ... )
                -- body
                Debug.LogError("cat-summoning"..catId)
                v:CheckCalled(function ( callFlag )
                    -- body
                    if(callFlag) then
                        self.touchCatId = catId
                        UIManager:ShowUIAsync("main","touch_cat_view",nil,function ( ... )
                            -- body
                            CS.RoleController.Instance.gameObject:GetComponent("TouchCat"):SetTarget(catCtrl,false)
                            UIManager:HideUI("main_view")
                        end)
                    else
                        MessageBox("TIPS","The cat refused to be summoned","OK")
                    end
                end)
            end)
        end
    end
end

function MainView.UpdateAllCatStates( ... )
    -- body
    self.catStates = ClearObjs(self.catStates)
    self.tog_all_states:GetComponent("Toggle").isOn = false
    for i=1,#playerData.catList do
        local CatModule = playerData.catList[i]
        local food_val = math.ceil(CatModule.maxHungerNumerial - (CatModule.maxHungerTime - CatModule.nowHungerTime) / CatModule.everyTimeHungerTime)
        local water_val = math.ceil(CatModule.maxThirstyNumerial - (CatModule.maxThirstyTime - CatModule.nowThirstyTime) / CatModule.everyTimeThirstyTime)
        local defecate_val = math.floor((CatModule.maxDefecateTime - CatModule.nowDefecateTime) / CatModule.everyTimeDefecateTime)
        if(self.catStates[tostring(CatModule.catId).."_food"] == nil) then
            local obj = GameObject.Instantiate(self.item_cat_state,self.item_cat_state.transform.parent)
            obj:SetActive(true)
            self.catStates[tostring(CatModule.catId).."_food"] = obj
            obj.transform:Find("text_cat_state_name"):GetComponent("TextMeshProUGUI").text = CatModule.name
            obj.transform:Find("press_cat_state_value"):GetComponent("Slider").value = food_val / CatModule.maxHungerNumerial
            PoolManager:SpawnAsync("home_state_food","main",typeof(CS.UnityEngine.Sprite),false,function ( sprite )
                obj.transform:Find("icon_cat_state"):GetComponent("Image").sprite = sprite
                obj.transform:Find("icon_cat_state"):GetComponent("Image"):SetNativeSize()
            end)
        else
            self.catStates[tostring(CatModule.catId).."_food"].transform:Find("press_cat_state_value"):GetComponent("Slider").value = food_val / CatModule.maxHungerNumerial
        end

        if(self.catStates[tostring(CatModule.catId).."_water"] == nil) then
            local obj = GameObject.Instantiate(self.item_cat_state,self.item_cat_state.transform.parent)
            obj:SetActive(true)
            self.catStates[tostring(CatModule.catId).."_water"] = obj
            obj.transform:Find("text_cat_state_name"):GetComponent("TextMeshProUGUI").text = CatModule.name
            obj.transform:Find("press_cat_state_value"):GetComponent("Slider").value = water_val / CatModule.maxThirstyNumerial
            PoolManager:SpawnAsync("home_state_water","main",typeof(CS.UnityEngine.Sprite),false,function ( sprite )
                obj.transform:Find("icon_cat_state"):GetComponent("Image").sprite = sprite
                obj.transform:Find("icon_cat_state"):GetComponent("Image"):SetNativeSize()
            end)
        else
            self.catStates[tostring(CatModule.catId).."_water"].transform:Find("press_cat_state_value"):GetComponent("Slider").value = water_val / CatModule.maxThirstyNumerial
        end

        if(self.catStates[tostring(CatModule.catId).."_clean"] == nil) then
            local obj = GameObject.Instantiate(self.item_cat_state,self.item_cat_state.transform.parent)
            obj:SetActive(true)
            self.catStates[tostring(CatModule.catId).."_clean"] = obj
            obj.transform:Find("text_cat_state_name"):GetComponent("TextMeshProUGUI").text = CatModule.name
            obj.transform:Find("press_cat_state_value"):GetComponent("Slider").value = defecate_val / CatModule.maxDefecateNumerial
            PoolManager:SpawnAsync("home_state_clean","main",typeof(CS.UnityEngine.Sprite),false,function ( sprite )
                obj.transform:Find("icon_cat_state"):GetComponent("Image").sprite = sprite
                obj.transform:Find("icon_cat_state"):GetComponent("Image"):SetNativeSize()
            end)
        else
            self.catStates[tostring(CatModule.catId).."_clean"].transform:Find("press_cat_state_value"):GetComponent("Slider").value = defecate_val / CatModule.maxDefecateNumerial
        end
        
    end
end



function MainView.Update( ... )
    -- body
end


function MainView.OnDestroy( ... )
    -- body
end

function MainView.OnClickMenuCats( ... )
    -- body
    UIManager:ShowUIAsync("main","cat_msg_view",nil,function ( ... )
        -- body
        CS.RoleController.Instance.gameObject:SetActive(false)
        UIManager:HideUI("main_view")
    end)
end

function MainView.OnClickMenuPackage( ... )
    -- body
    UIManager:ShowUIAsync("main","package_view",nil,function ( ... )
        -- body
        CS.RoleController.Instance.gameObject:SetActive(false)
        UIManager:HideUI("main_view")
    end)
end


function MainView.OnClickToilet( ... )
    -- body
    UIManager:ShowUIAsync("main","cat_toilet_view",nil,function ( ... )
        -- body
        UIManager:HideUI("main_view")
    end)
end

function MainView.OnClickFood( ... )
    -- body
    UIManager:ShowUIAsync("main","cat_bowl_view",nil,function ( ... )
        -- body
        UIManager:HideUI("main_view")
    end)
end

function MainView.OnClickBoard( ... )
    -- body
    UIManager:ShowUIAsync("main","cat_board_view",nil,function ( ... )
        -- body
        UIManager:HideUI("main_view")
    end)
end

function MainView.OnClickHouse( ... )
    -- body
    UIManager:ShowUIAsync("main","cat_house_view",nil,function ( ... )
        -- body
        UIManager:HideUI("main_view")
    end)
end


function MainView.OnClickShop( ... )
    -- body
    UIManager:ShowUIAsync("main","bg_shop",UIManager:GetRootNode("shrink").root)
    UIManager:ShowUIAsync("main","shop_view",nil,function ( ... )
        -- body
        CS.RoleController.Instance.gameObject:SetActive(false)
        UIManager:HideUI("main_view")
    end)
end

function MainView.OnClickHospital( ... )
    -- body
    if(#self.illCats > 0) then
        local hintData = hint[1]
        self.ShowBoxStateMsg(hintData.tips,function ( ... )
            -- body
            self.SendMsgSendToHospitalReq(self.illCats,function ( ... )
                -- body
                --hidden cat
                for i=1,#self.illCats do
                    MainStart.HideCat( self.illCats[i] )
                end
                --open the hospital
                self.GoToHospital()
                --remove label
                local objFlag = self.stateObjs[1]
                GameObject.Destroy(objFlag)
                self.stateObjs[1] = nil
                --clear data
                self.illCats = {}
            end)
        end)
    else
        if(self.stateObjs[1] ~= nil) then
            local objFlag = self.stateObjs[1]
            GameObject.Destroy(objFlag)
            self.stateObjs[1] = nil
        end
        self.GoToHospital()
    end
end


function MainView.GoToHospital( ... )
    -- body
    UIManager:ShowUIAsync("main","bg_hospital",UIManager:GetRootNode("shrink").root)
    UIManager:ShowUIAsync("main","hospital_view",nil,function ( ... )
        -- body
        CS.RoleController.Instance.gameObject:SetActive(false)
        self.panel_map:SetActive(false)
        UIManager:HideUI("main_view")
    end)
end

function MainView.OnClickQuestion( ... )
    -- body
    UIManager:ShowUIAsync("main","question_view")
end

function MainView.OnClickMission( ... )
    -- body
    UIManager:ShowUIAsync("main","mission_view")
end


function MainView.OnClickMap( ... )
    -- body
    self.panel_map:SetActive(true)
end


function MainView.CheckShowAllStateFlag( ... )
    -- body
    if(self.tog_all_states:GetComponent("Toggle").isOn == false) then
        self.flag_all_states:SetActive(true)
    end
end


function MainView.EnterCallCat( obj )
    -- body
    if(self.state_call_cat == nil) then
        self.state_call_cat = GameObject.Instantiate(self.btn_keep_state,self.btn_keep_state.transform.parent)
        PoolManager:SpawnAsync("space_callcat","main",typeof(CS.UnityEngine.Sprite),false,function ( sprite )
            self.state_call_cat.transform:Find("icon_state"):GetComponent("Image").sprite = sprite
            self.state_call_cat.transform:Find("icon_state"):GetComponent("Image"):SetNativeSize()
        end)
    end
    self.state_call_cat:SetActive(true)
    self.state_call_cat.transform:SetAsLastSibling()
    self.state_call_cat:GetComponent("SpaceState").space = obj
    self.state_call_cat:GetComponent("Button").onClick:RemoveAllListeners()
    self.state_call_cat:GetComponent("Button").onClick:AddListener(function ( ... )
        -- body
        self.box_call_cat:SetActive(true)
        self.box_call_cat.transform:SetAsLastSibling()
    end)
end


function MainView.ExitCallCat()
    -- body
    self.state_call_cat:SetActive(false)
    self.box_call_cat:SetActive(false)
end

function MainView.OnClickMail()
    UIManager:ShowUIAsync("main","mail_view")
end


function MainView.ShowShelter( ... )
    -- body
    UIManager:ShowUIAsync("main","bg_shelter",UIManager:GetRootNode("shrink").root)
    UIManager:ShowUIAsync("main","shelter_view",nil,function ( ... )
        -- body
        CS.RoleController.Instance.gameObject:SetActive(false)
        self.panel_map:SetActive(false)
        UIManager:HideUI("main_view")
    end)
    
end

function MainView.ShowPlayGround()    
    MainStart.DelAllCat()
    SceneLoadManager:ChangeScene("main","PlayGround",function()         
        UIManager:ShowUIAsync("main","park_view",nil,function ( ... )             
            self.panel_map:SetActive(false)              
            UIManager:HideUI("main_view")     
        end)        
    end)
end
