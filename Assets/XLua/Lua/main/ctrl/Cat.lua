require "main/ctrl/CatStateBase"
Cat = BaseClass:New(nil, BaseClass)


function Cat:Start( ... )
    --Debug.Log(self.catId..":Start")
end


function Cat:FixedUpdate( ... )
    --Debug.Log(self.catId..":FixedUpdate")
    if(self.curState) then
        self.curState:FixedUpdate()
    end
end



function Cat:OnDestroy( ... )
    --Debug.Log(self.catId..":Destroy")
end


function Cat:OnlyShowCat( id,pot,callback )
    -- body
    LuaManager:GetServerLua("https://petland-cat.oss-cn-shanghai.aliyuncs.com/CatsData/Cat_"..tostring(id)..".lua","main",function ( ... )
        local tab = GetLuaChunk("main")["Cat_"..tostring(id)]
        self.catObj = PoolManager:Spawn("L1_M_skin","cat",nil,true)--PoolManager:Spawn(tab.obj,"cat",nil,true)
        self.catCtrl = self.catObj:GetComponent("CatCtrl")
        self.catCtrl:ShowAnimation("sit")
        local colorR = Color(0,0,0)
        local colorG = Color(0,0,0)
        local colorB = Color(0,0,0)
        if(tab.shaderConfig.colorR) then
            colorR = Color(tab.shaderConfig.colorR[1]/255,tab.shaderConfig.colorR[2]/255,tab.shaderConfig.colorR[3]/255)
        end
        if(tab.shaderConfig.colorG) then
            colorG = Color(tab.shaderConfig.colorG[1]/255,tab.shaderConfig.colorG[2]/255,tab.shaderConfig.colorG[3]/255)
        end
        if(tab.shaderConfig.colorB) then
            colorB = Color(tab.shaderConfig.colorB[1]/255,tab.shaderConfig.colorB[2]/255,tab.shaderConfig.colorB[3]/255)
        end
        self.catCtrl:SetTextures(
            "cat",
            tab.shaderConfig.baseMap,
            tab.shaderConfig.maskR,
            tab.shaderConfig.maskG,
            tab.shaderConfig.maskB,
            colorR,
            colorG,
            colorB
            )
        
        for i,v in pairs(tab.blendShape) do
            self.catCtrl:SetBlendShape(i,v)
        end

        self.catObj.transform.position = _G["PathController"].living_room_37.transform.position
        callback(tab.obj)
    end)
end



--initialize basic data
function Cat:Init( CatModule,Manager )
    -- body
    if(CatModule ~= nil) then
        Debug.Log("initialize cat："..tostring(CatModule.catId))
        --configuration data
        self.Manager = Manager
        self.CatModule = CatModule
        self.catId = self.CatModule.catId
        self.catDataId = self.catId + 100000
        --instantiated cat
        LuaManager:GetServerLua("https://petland-cat.oss-cn-shanghai.aliyuncs.com/CatsData/Cat_"..tostring(self.catDataId)..".lua","main",function ( ... )
            -- body
            local tab = GetLuaChunk("main")["Cat_"..tostring(self.catDataId)]

            --temporary code
            -- self.catObj = PoolManager:Spawn("Cat","main",nil,true)
            -- self.catObj.name = "Cat_ID_"..self.CatModule.catId
            -- self.catCtrl = self.catObj:GetComponent("CatCtrl")
            -- self.catCtrl.catId = self.catId

            --real code
            self.catObj = PoolManager:Spawn("L1_M_skin","cat",nil,true)--PoolManager:Spawn(tab.obj,"cat",nil,true)
            self.catObj.name = "Cat_ID_"..self.CatModule.catId
            self.catCtrl = self.catObj:GetComponent("CatCtrl")
            self.catCtrl.catId = self.catId
            local colorR = Color(0,0,0)
            local colorG = Color(0,0,0)
            local colorB = Color(0,0,0)
            local colorEyeL = Color(0,0,0)
            local colorEyeR = Color(0,0,0)
            if(tab.shaderConfig.colorR) then
                colorR = Color(tab.shaderConfig.colorR[1]/255,tab.shaderConfig.colorR[2]/255,tab.shaderConfig.colorR[3]/255)
            end
            if(tab.shaderConfig.colorG) then
                colorG = Color(tab.shaderConfig.colorG[1]/255,tab.shaderConfig.colorG[2]/255,tab.shaderConfig.colorG[3]/255)
            end
            if(tab.shaderConfig.colorB) then
                colorB = Color(tab.shaderConfig.colorB[1]/255,tab.shaderConfig.colorB[2]/255,tab.shaderConfig.colorB[3]/255)
            end
            if(tab.eyesConfig.left) then
                colorEyeL = Color(tab.eyesConfig.left[1]/255,tab.eyesConfig.left[2]/255,tab.eyesConfig.left[3]/255)
            end
            if(tab.eyesConfig.right) then
                colorEyeR = Color(tab.eyesConfig.right[1]/255,tab.eyesConfig.right[2]/255,tab.eyesConfig.right[3]/255)
            end
            self.catCtrl:SetTextures(
                "cat",
                tab.shaderConfig.baseMap,
                tab.shaderConfig.maskR,
                tab.shaderConfig.maskG,
                tab.shaderConfig.maskB,
                colorR,
                colorG,
                colorB,
                colorEyeL,
                colorEyeR
                )
            
            for i,v in pairs(tab.blendShape) do
                self.catCtrl:SetBlendShape(i,v)
            end


            self:InitAI()
            if(CatModule.status == 0) then
                self:ShowCat(CatModule)
            -- elseif(CatModule.status == 0 and CatModule.health == 0) then
            --     Debug.LogError("CatModule.health = "..CatModule.health)
            --     self.Manager.SendMsgRecoverShelterReq(CatModule.catId)
            else
                Debug.LogError(self.catId.." status === "..CatModule.status)
                self:HideCat()
                --self:DelCat()
            end
        end)
        
    end
end

function Cat:CheckShow( CatModule )
    -- body
    self.CatModule = CatModule
    if(CatModule.status == 0 and not self.catObj.activeSelf) then
        self:ShowCat(CatModule)
    -- elseif(CatModule.status == 0 and CatModule.health == 0 and self.catObj.activeSelf) then
    --     self.Manager.SendMsgRecoverShelterReq(CatModule.catId)
    elseif(self.catObj.activeSelf) then
        self:HideCat()
        --self:DelCat()
    end
end


function Cat:InitAI()
    -- body
    self.catCtrl.isAI = true

    self.CatStateNormal = CatStateNormal:New()
    self.CatStateNormal.stateName = "CatStateNormal"
    self.CatStateNormal.cat = self

    self.CatStateGoOut = CatStateGoOut:New()
    self.CatStateGoOut.stateName = "CatStateGoOut"
    self.CatStateGoOut.cat = self

    self.CatStateSick = CatStateSick:New()
    self.CatStateSick.stateName = "CatStateSick"
    self.CatStateSick.cat = self

    self.CatStateCacation = CatStateCacation:New()
    self.CatStateCacation.stateName = "CatStateCacation"
    self.CatStateCacation.cat = self

    self.CatStateEat = CatStateEat:New()
    self.CatStateEat.stateName = "CatStateEat"
    self.CatStateEat.cat = self

    self.CatStateDrink = CatStateDrink:New()
    self.CatStateDrink.stateName = "CatStateDrink"
    self.CatStateDrink.cat = self

    self.CatStateCall = CatStateCall:New()
    self.CatStateCall.stateName = "CatStateCall"
    self.CatStateCall.cat = self

    self.CatStateStroke = CatStateStroke:New()
    self.CatStateStroke.stateName = "CatStateStroke"
    self.CatStateStroke.cat = self

    self.CatStateMove = CatStateMove:New()
    self.CatStateMove.stateName = "CatStateMove"
    self.CatStateMove.cat = self

    self.CatStateRest = CatStateRest:New()
    self.CatStateRest.stateName = "CatStateRest"
    self.CatStateRest.cat = self

    self.CatStateSleep = CatStateSleep:New()
    self.CatStateSleep.stateName = "CatStateSleep"
    self.CatStateSleep.cat = self

    self.CatStatePlay = CatStatePlay:New()
    self.CatStatePlay.stateName = "CatStatePlay"
    self.CatStatePlay.cat = self



    --self:EnterState("CatStateNormal")

end

function Cat:ShowCat( CatModule )
    -- body
    self.catObj:SetActive(true)
    self.pot = _G["PathController"].GetGroundPot()
    self.catObj.transform.position = self.pot.transform.position
    self.catCtrl.agent.enabled = true
    _G["PathController"].SaveData(self.pot.name,self.CatModule.catId)
    if(self.curState == nil) then
        self:EnterState("CatStateNormal")
    end

    if(CatModule == nil) then
        self.Manager.SendMsgCatInfoReq(self.catId)
    else
        self:UpdateCatModule( CatModule )
    end
end

function Cat:HideCat( ... )
    -- body
    self:ExitState()
    if(self.pot) then
        _G["PathController"].DelData(self.pot.name)
        self.pot = nil
    end
    self.catObj:SetActive(false)

    TimeManager:OverTime("cat_check_sick_"..self.catId)
    TimeManager:OverTime("cat_hunger_"..self.catId)
    TimeManager:OverTime("cat_thirsty_"..self.catId)
    TimeManager:OverTime("cat_defecate_"..self.catId)
end

function Cat:DelCat( ... )
    _G["Cats"][self.catId] = nil
    TimeManager:OverTime("cat_check_sick_"..self.catId)
    TimeManager:OverTime("cat_hunger_"..self.catId)
    TimeManager:OverTime("cat_thirsty_"..self.catId)
    TimeManager:OverTime("cat_defecate_"..self.catId)
    if(self.catObj ~= nil) then
        GameObject.Destroy(self.catObj)
        self.catObj = nil
    end
    self.CatStateNormal = nil
    self.CatStateGoOut = nil
    self.CatStateSick = nil
    self.CatStateCacation = nil
    self.CatStateEat = nil
    self.CatStateDrink = nil
    self.CatStateCall = nil
    self.CatStateStroke = nil
    self.CatStateMove = nil
    self.CatStateRest = nil
    self.CatStateSleep = nil
    self.CatStatePlay = nil
    
    self.Manager = nil
    self.CatModule = nil
    self.catId = nil
    self.catDataId = nil
    self.catCtrl = nil
    self = nil
end


function Cat:EnterState( stateName )
    -- body
    if(self.curState) then
        self.curState:End()
    end
    self.curState = self[stateName]
    self.curState:Start()
    Debug.LogError(stateName)
end

function Cat:ExitState( ... )
    -- body
    if(self.curState) then
        self.curState:End()
    end
    self.curState = nil
end


function Cat:CheckSpecialState( ... )
    -- body
    if(self.catCtrl.isGetOut) then
        self:EnterState("CatStateGoOut")
    elseif(self.catCtrl.isSick) then
        self:EnterState("CatStateSick")
    elseif(self.catCtrl.isClean and not self.Manager.isDefecating) then
        self:EnterState("CatStateCacation")
    elseif(self.catCtrl.isEat and not self.Manager.isEating) then
        self:EnterState("CatStateEat")
    elseif(self.catCtrl.isDrink and not self.Manager.isDrinking) then
        self:EnterState("CatStateDrink")
    elseif(self.catCtrl.isCalled) then
        self:EnterState("CatStateCall")
    elseif(self.catCtrl.isStroked) then
        self:EnterState("CatStateStroke")
    else
        return false
    end
    return true
end


--refreshing cat data
function Cat:UpdateCatModule( CatModule )
    -- body
    self.CatModule = CatModule
    if(self.catObj.activeSelf) then
        self:CheckSick()
        self:CheckDataEvent()
        self:CatTimeSetting()
        -- if(CatModule.health == 0) then
        --     self.Manager.SendMsgRecoverShelterReq(CatModule.catId)
        -- end
    end
end


function Cat:CheckStroke( callback )
    -- body
    local num = math.random(100)
    if(num < 10) then
        self.strokeFlag = false
    else
        self.strokeFlag = true
    end
    self.catCtrl.isStroked = true
    callback(self.strokeFlag)
end


function Cat:CheckCalled( callback )
    -- body
    local num = math.random(100)
    if(num < 10) then
        self.callFlag = false
    else
        self.callFlag = true
        self.catCtrl.isCalled = true
    end
    callback(self.callFlag)
end





--test for illness
function Cat:CheckSick()
    if(self.catObj.activeSelf) then
        if(self.CatModule.sick == 0) then
            self.catCtrl.isSick = false
        else
            self.catCtrl.isSick = true
        end
        TimeManager:StartTime("cat_check_sick_"..self.catId,0,60,true,function ( t )
            self.Manager.SendMsgCatSickJudgeReq(self.catId)
        end)
    end
end

--detected numerical event（whether to eat, drink and pull）
function Cat:CheckDataEvent()
    -- body
    if(self.catObj.activeSelf) then
        --hunger degree
        local food_val = math.ceil(self.CatModule.maxHungerNumerial - (self.CatModule.maxHungerTime - self.CatModule.nowHungerTime) / self.CatModule.everyTimeHungerTime)
        self:CheckEat(self.CatModule,food_val)
        --thirsty city
        local water_val = math.ceil(self.CatModule.maxThirstyNumerial - (self.CatModule.maxThirstyTime - self.CatModule.nowThirstyTime) / self.CatModule.everyTimeThirstyTime)
        self:CheckDrink(self.CatModule,water_val)
        --defecation value
        local defecate_val = math.floor((self.CatModule.maxDefecateTime - self.CatModule.nowDefecateTime) / self.CatModule.everyTimeDefecateTime)
        self:CheckDefecate(self.CatModule,defecate_val)
    end
end


function Cat:CatTimeSetting()
    -- body
    if(self.catObj.activeSelf) then
        local hunger_during = math.ceil(self.CatModule.everyTimeHungerTime / 1000)
        local food_time_offset = self.CatModule.maxHungerTime - TimeManager:GetTimeStamp(false)
        Debug.Log("hunger_during = "..hunger_during)
        TimeManager:StartTime("cat_hunger_"..self.CatModule.catId,0,hunger_during,true,function ( t )
            self.CatModule.maxHungerTime = TimeManager:GetTimeStamp(false) + food_time_offset
            local food_val = math.ceil(self.CatModule.maxHungerNumerial - (self.CatModule.maxHungerTime - self.CatModule.nowHungerTime) / self.CatModule.everyTimeHungerTime)
            self:CheckEat( self.CatModule,food_val )
        end)

        local thirsty_during = math.ceil(self.CatModule.everyTimeThirstyTime / 1000)
        Debug.Log("thirsty_during = "..thirsty_during)
        local water_time_offset = self.CatModule.maxThirstyTime - TimeManager:GetTimeStamp(false)
        TimeManager:StartTime("cat_thirsty_"..self.CatModule.catId,0,thirsty_during,true,function ( t )
            self.CatModule.maxThirstyTime = TimeManager:GetTimeStamp(false) + water_time_offset
            local water_val = math.ceil(self.CatModule.maxThirstyNumerial - (self.CatModule.maxThirstyTime - self.CatModule.nowThirstyTime) / self.CatModule.everyTimeThirstyTime)
            self:CheckDrink( self.CatModule,water_val )
        end)

        local defecate_during = math.ceil(self.CatModule.everyTimeDefecateTime / 1000)
        Debug.Log("defecate_during = "..defecate_during)
        local defecate_time_offset = self.CatModule.maxDefecateTime - TimeManager:GetTimeStamp(false)
        TimeManager:StartTime("cat_defecate_"..self.CatModule.catId,0,defecate_during,true,function ( t )
            self.CatModule.maxDefecateTime = TimeManager:GetTimeStamp(false) + defecate_time_offset
            local defecate_val = math.floor((self.CatModule.maxDefecateTime - self.CatModule.nowDefecateTime) / self.CatModule.everyTimeDefecateTime)
            self:CheckDefecate( self.CatModule,defecate_val )
        end)
    end
end

function Cat:CheckEat( CatModule,food_val )
    -- body
    Debug.Log("food_val = "..food_val)
    if(food_val < CatModule.maxHungerNumerial / 2) then --real code
        --hunger:determine cat food quantity，trigger feeding
        if(playerData.userTools.catBowl.surplusVolume > 0) then
            self.Manager.SendMsgCatEatReq(CatModule)
        else
            Debug.Log("no cat food")
            --prompt to add cat food
        end
    end
end

function Cat:CheckDrink( CatModule,water_val )
    -- body
    Debug.Log("water_val = "..water_val)
    if(water_val < CatModule.maxThirstyNumerial / 2) then --real code
        --thirst:determine the amount of water in the cat's bowl，trigger drinking
        if(playerData.userTools.catWater.surplusVolume > 0) then
            self.Manager.SendMsgCatDrinkReq(CatModule)
        else
            Debug.Log("no water")
            --prompt to add water
        end
    end
end

function Cat:CheckDefecate( CatModule,defecate_val )
    -- body
    Debug.Log("defecate_val = "..defecate_val)
    if(defecate_val >= CatModule.maxDefecateNumerial) then --real code
        --not sure whether you need to determine the litter amount，only cats go to the bathroom，let's say we want to judge cat litter
        if(playerData.userTools.catToilet.surplusVolume > 0) then
            self.Manager.SendMsgCatCacationReq(CatModule)
        else
            Debug.Log("no cat litter")
            --prompt to add cat litter
        end
    end
end

--cat defecation
function Cat:CatCacationActCallback( data )
    -- body
    -- if(not self.Manager.isDefecating) then
    --     self.Manager.isDefecating = true
    -- end
    --the cat performs a bowel movement
    self.catCtrl.isClean = true
end

--cat drink water
function Cat:CatDrinkAckCallback( data )
    -- if(not self.Manager.isDrinking) then
    --     self.Manager.isDrinking = true
    -- end
    --cat drinking water
    self.catCtrl.isDrink = true
end

--cat feeding
function Cat:CatEatAckCallback( data )
    -- body
    -- if(not self.Manager.isEating) then
    --     self.Manager.isEating = true
    -- end
    --cat show dinner
    self.catCtrl.isEat = true
end

--diagnosis of illness
function Cat:CatSickJudgeAckCallback( data )
    -- body
    self.CatModule.sick = data.isSick
    if(self.CatModule.sick == 0) then
        self.catCtrl.isSick = false
    else
        self.catCtrl.isSick = true
    end
end





return Cat

