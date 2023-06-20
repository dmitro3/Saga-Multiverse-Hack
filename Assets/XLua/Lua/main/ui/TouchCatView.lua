TouchCatView = {}
local self = TouchCatView
local itemAct = {[7]=1005,[9]=1004,[10]=1006,[12]=1014}

function TouchCatView.Start( ... )
    -- body
    self.isLeaving = true
    -- self.btn_touch:GetComponent("Button").onClick:RemoveAllListeners()
    -- self.btn_touch:GetComponent("Button").onClick:AddListener(self.CheckTouch)
    self.btn_quit:GetComponent("Button").onClick:RemoveAllListeners()
    self.btn_quit:GetComponent("Button").onClick:AddListener(self.Quit)
    self.btn_comb:GetComponent("Button").onClick:RemoveAllListeners()
    self.btn_comb:GetComponent("Button").onClick:AddListener(self.OnClickComb)
    self.touch_head:GetComponent("Button").onClick:RemoveAllListeners()
    self.touch_head:GetComponent("Button").onClick:AddListener(self.OnClickHead)
    self.touch_body:GetComponent("Button").onClick:RemoveAllListeners()
    self.touch_body:GetComponent("Button").onClick:AddListener(self.OnClickBody)
    self.touch_chin:GetComponent("Button").onClick:RemoveAllListeners()
    self.touch_chin:GetComponent("Button").onClick:AddListener(self.OnClickChin)
    self.Init()
end


function TouchCatView.Init()
    -- body
    self.Camera = CS.RoleController.Instance.playerCamera
    self.catId = MainView.touchCatId
    self.cat = _G["Cats"][self.catId]
    self.TouchCat = CS.RoleController.Instance.gameObject:GetComponent("TouchCat")
    self.catCtrl = _G["Cats"][self.catId].catCtrl
    self.tools:SetActive(false)
    self.btns:SetActive(true)
    self.touch_head:GetComponent("TouchCatBtn").catPot = self.catCtrl.headPot
    self.touch_body:GetComponent("TouchCatBtn").catPot = self.catCtrl.bodyPot
    self.touch_chin:GetComponent("TouchCatBtn").catPot = self.catCtrl.chinPot
    self.btn_touch:SetActive(true)
    if(self.catCtrl.isCalled) then
        self.btn_touch:SetActive(false)
        _G["PublicEvent"].readyCalled = function ( ... )
            -- body
            self.tools:SetActive(true)
            self.btns:SetActive(false)
        end
    end
    self.InitDatas()
    self.UpdataItems()
end

function TouchCatView.InitDatas( ... )
    -- body
    for i=1,#playerData.itemList do
        local ItemModule = playerData.itemList[i]
        if(ItemModule.propId == 10001) then
            self.text_paw_num:GetComponent("TextMeshProUGUI").text = ItemModule.propCount
        end
        if(ItemModule.propId == 10002) then
            self.text_zoo_num:GetComponent("TextMeshProUGUI").text = ItemModule.propCount
        end
    end

    self.CatModule = nil
    for i=1,#playerData.catList do
        local cm = playerData.catList[i]
        if(cm.catId == self.catId) then
            self.CatModule = cm
            break
        end
    end

    self.UpdateHappinessState(self.CatModule)
    local happiness_time_offset = self.CatModule.maxHappinessTime - TimeManager:GetTimeStamp(false)
    TimeManager:StartTime("cur_cat_happiness",0,1,false,function ( t )
        if(self.isLeaving) then
            self.CatModule.maxHappinessTime = TimeManager:GetTimeStamp(false) + happiness_time_offset
            self.UpdateHappinessState(self.CatModule)
        end
    end)
end

function TouchCatView.UpdateHappinessState( CatModule )
    -- body
    local happiness_val = math.floor(CatModule.maxHappinessNumerial - (CatModule.maxHappinessTime - CatModule.nowHappinessTime) / CatModule.everyTimeHappinessTime)
    if(happiness_val < 0) then
        happiness_val = 0
    end
    self.progress_heart:GetComponent("Image").fillAmount = happiness_val / CatModule.maxHappinessNumerial
    self.text_intimacy_num:GetComponent("TextMeshProUGUI").text = CatModule.intimacy
end

function TouchCatView.UpdataItems( ... )
    -- body
    self.GetStrokeCatItems(function ( data )
        -- body
        self.itemTools = ClearObjs(self.itemTools)
        Debug.Log("number of cat lifting items："..#data.propList)
        for i=1,#data.propList do
            local StrokeCatPropModule = data.propList[i]
            local itemData = item[StrokeCatPropModule.propId]
            local obj = GameObject.Instantiate(self.item_tool,self.item_tool.transform.parent)
            obj:SetActive(true)
            self.itemTools[StrokeCatPropModule.propId] = obj
            PoolManager:SpawnAsync(itemData.pic,"main",typeof(CS.UnityEngine.Sprite),false,function ( sprite )
                obj.transform:Find("icon"):GetComponent("Image").sprite = sprite
            end)
            obj.transform:Find("text_num"):GetComponent("TextMeshProUGUI").text = StrokeCatPropModule.propCount
            obj:GetComponent("Button").onClick:RemoveAllListeners()
            obj:GetComponent("Button").onClick:AddListener(function ( ... )
                -- body
                --（cat-teasing stick 1004 cat feeding strip 1005 catgrass 1006 comb 1013 play ball1014 ）
                local playId = itemAct[StrokeCatPropModule.propType]
                Debug.Log(playId)
                self.SendMsgCatPlayReq(playId,StrokeCatPropModule.propId)
            end)
        end
    end)
end




--user lifting cat item list request
function TouchCatView.GetStrokeCatItems( callback )
    if(PublicClient.isConnect) then
        local StrokeCatItemReq = {}
        StrokeCatItemReq.token = playerData.baseData.data.token
        PublicClient.SendMsgStrokeCatItemReq(StrokeCatItemReq,function ( data )
            -- body
            --list of users' cat lifting items
            if(callback) then
                callback(data)
            end
        end)
    end
end


function TouchCatView.SendMsgCatPlayReq( playId,propId )
    -- body
    local CatPlayReq = {}
    CatPlayReq.token = playerData.baseData.data.token
    CatPlayReq.catId = self.catId
    CatPlayReq.playId = playId
    CatPlayReq.propId = propId
    PublicClient.SendMsgCatPlayReq(CatPlayReq,function ( data )
        -- body
        --（cat-teasing stick 1004 cat feeding strip 1005 catgrass 1006 comb 1013 play ball1014 ）
        Debug.Log("increased happiness value timestamp = "..data.addHappiness)
        Debug.Log("addCsCount = "..data.addCsCount)
        if(playId == 1013) then
            self.TouchCatAnimation( "carding" )
        elseif(playId == 1004) then
            self.TouchCatAnimation( "playstick" )
            self.UpdataItems()
        elseif(playId == 1005) then
            self.TouchCatAnimation( "nip" )
            self.UpdataItems()
        elseif(playId == 1006) then
            self.TouchCatAnimation( "sugar" )
            self.UpdataItems()
        elseif(playId == 1014) then
            self.TouchCatAnimation( "ball" )
            self.UpdataItems()
        end
    end)

end





function TouchCatView.OnClickComb( ... )
    -- body
    Debug.Log("comb comb cat")
    local playId = 1013
    self.SendMsgCatPlayReq(playId,0)
end



function TouchCatView.Update( ... )
    -- body
    if(self.downStart ~= nil) then
        local hOffset = (Input.mousePosition - self.downStart).normalized.x
        --self.TouchCat.Camera.transform.localPosition = self.saveCameraPot + Vector3(hOffset,0,0)
        self.TouchCat.Camera.transform:RotateAround(self.TouchCat.target.transform.position + Vector3(0, 0.25, 0), Vector3.up, hOffset);
    end


end


function TouchCatView.OnDestroy( ... )
    -- body
    self.isLeaving = false
end


function TouchCatView.Quit( ... )
    -- body
    self.catCtrl.isStroked = false
    self.catCtrl.isCalled = false
    CS.RoleController.Instance.gameObject:GetComponent("TouchCat"):EndTouch()
    UIManager:ShowUIAsync("main","main_view")
    UIManager:DelUI("touch_cat_view")
    TimeManager:OverTime("cur_cat_happiness")
end


function TouchCatView.TouchCatAnimation( aniName )
    -- body
    --self.TouchCat:CameraLookAtCat self.cat[aniName].transform.position
    local subObj = nil
    local doTime = 0
    local saveActive = self.tools.activeSelf
    local saveTouch = self.btn_touch.activeSelf
    util.coroutine_call(function ( ... )
        -- body!
        self.tools:SetActive(false)
        self.btn_touch:SetActive(false)
        if(self.cat[aniName] ~= nil) then
            self.TouchCat:CameraLookAtCat(self.cat[aniName],1)
            yield_return(WaitForSeconds(1))
            if(not self.isLeaving) then
                yield_break(0)
            end
        end

        if(aniName == "touch_head" or aniName == "touch_body" or aniName == "touch_chin" or aniName == "smell") then
            self.catCtrl.animator:SetBool(aniName,true)
            self.cat.arm_touch:SetActive(true)
            self.cat.arm_touch:GetComponent("Animator"):SetBool(aniName,true)
            
            subObj = self.cat.arm_touch
            if(aniName == "touch_head") then
                doTime = 3.067
            elseif(aniName == "touch_body") then
                doTime = 7.4
            elseif(aniName == "touch_chin") then
                doTime = 3.533
            elseif(aniName == "smell") then
                doTime = 5
            end
        elseif(aniName == "playstick") then
            self.catCtrl:ShowAnimation(aniName)
            self.cat.arm_playstick:SetActive(true)
            subObj = self.cat.arm_playstick
            doTime = 1.4+0.8
        elseif(aniName == "nip") then
            self.catCtrl:ShowAnimation(aniName)
            self.cat.arm_catnip:SetActive(true)
            subObj = self.cat.arm_catnip
            doTime = 4.6
        elseif(aniName == "sugar") then
            self.catCtrl:ShowAnimation(aniName)
            self.cat.arm_sugar:SetActive(true)
            subObj = self.cat.arm_sugar
            doTime = 4.6
        elseif(aniName == "ball") then
            self.catCtrl:ShowAnimation(aniName)
            self.cat.arm_ball:SetActive(true)
            self.cat.tool_ball:SetActive(true)
            subObj = self.cat.arm_ball
            doTime = 8.5
        elseif(aniName == "carding") then
            self.catCtrl:ShowAnimation(aniName)
            self.cat.arm_carding:SetActive(true)
            subObj = self.cat.arm_carding
            doTime = 3.967
        end
        yield_return(WaitForSeconds(doTime))
        if(not self.isLeaving) then
            yield_break(0)
        end
        if(subObj) then
            subObj:SetActive(false)
            self.cat.tool_ball:SetActive(false)
        end

        if(self.cat[aniName] ~= nil) then
            self.TouchCat:CameraReback(1)
            yield_return(WaitForSeconds(1))
            if(not self.isLeaving) then
                yield_break(0)
            end
        end
        self.tools:SetActive(saveActive)
        self.btn_touch:SetActive(saveTouch)
    end)()
    

end


function TouchCatView.TouchClick( p )
    -- body
    Debug.LogError("TouchClick")
    local ray = self.TouchCat.Camera:ScreenPointToRay(Input.mousePosition)
    local hitTab = CS.UnityEngine.Physics.RaycastAll(ray)
    if(hitTab.Length > 0) then
        self.TouchCatAnimation(hitTab[0].transform.name)
    end
end


function TouchCatView.TouchDown( p )
    -- body
    Debug.LogError("TouchDown")
    if(self.downStart == nil) then
        self.downStart = Input.mousePosition
        self.saveCameraPot = self.TouchCat.Camera.transform.localPosition
    end
end

function TouchCatView.TouchUp( p )
    -- body
    Debug.LogError("TouchUp")
    self.downStart = nil
end


function TouchCatView.OnClickHead( ... )
    -- body
    self.TouchCatAnimation( "touch_head" )
end

function TouchCatView.OnClickBody( ... )
    -- body
    self.TouchCatAnimation( "touch_body" )
end

function TouchCatView.OnClickChin( ... )
    -- body
    self.TouchCatAnimation( "touch_chin" )
end
