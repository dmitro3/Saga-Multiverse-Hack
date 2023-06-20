CatStateBase = BaseClass:New(nil, BaseClass)

function CatStateBase:Start( ... )
    Debug.Log(self.stateName..":Start")
end

function CatStateBase:FixedUpdate( ... )
    Debug.Log(self.stateName..":FixedUpdate")
end

function CatStateBase:End( ... )
    Debug.Log(self.stateName..":End")
end

 --[[*
     * judgment logic
     * whether the cat needs to escape the room at the moment
     * whether the cat is currently sick
     * whether the cat needs to eat, drink and pull at present
     * whether the cat is currently summoned to pet the cat
     * current cat weight judgment：move、rest、sleep、amuse yourself
]]--

--normal state：overall checks the current state and switches to substates
CatStateNormal = BaseClass:New(nil, BaseClass)

function CatStateNormal:Start( ... )
    Debug.Log(self.stateName..":Start")
    self.cat.catCtrl:StopAnimation("left")
    self.cat.catCtrl:StopAnimation("right")
end

function CatStateNormal:FixedUpdate( ... )
    -- Debug.Log(self.stateName..":FixedUpdate")

    if(self.cat.catCtrl.isGetOut) then
        self.cat:EnterState("CatStateGoOut")
    elseif(self.cat.catCtrl.isSick) then
        self.cat:EnterState("CatStateSick")
    elseif(self.cat.catCtrl.isClean) then
       self.cat:EnterState("CatStateCacation")
    elseif(self.cat.catCtrl.isEat) then
        self.cat:EnterState("CatStateEat")
    elseif(self.cat.catCtrl.isDrink) then
        self.cat:EnterState("CatStateDrink")
    elseif(self.cat.catCtrl.isCalled) then
        self.cat:EnterState("CatStateCall")
    elseif(self.cat.catCtrl.isStroked) then
        self.cat:EnterState("CatStateStroke")
    else
        if(self.cat.CatModule.stamina <= 20) then
            self.cat:EnterState(self:CheckWeight(10,90,30,10))
        elseif(self.cat.CatModule.stamina <= 50) then
            self.cat:EnterState(self:CheckWeight(20,40,40,20))
        elseif(self.cat.CatModule.stamina <= 80) then
            self.cat:EnterState(self:CheckWeight(40,20,30,30))
        else
            self.cat:EnterState(self:CheckWeight(40,10,20,40))
        end
    end

end

function CatStateNormal:CheckWeight( moveNum,sleepNum,restNum,playNum )
    -- body
    local all = moveNum + sleepNum + restNum + playNum
    local num = math.random(all)
    if(num < moveNum) then
        return "CatStateMove"
    elseif(num < moveNum + sleepNum) then
        return "CatStateSleep"
    elseif(num < moveNum + sleepNum + restNum) then
        return "CatStateRest"
    elseif(num <= all) then
        return "CatStatePlay"
    end
end

function CatStateNormal:End( ... )
    Debug.Log(self.stateName..":End")
end

--escape the room
CatStateGoOut = BaseClass:New(nil, BaseClass)

function CatStateGoOut:Start( ... )
    Debug.Log(self.stateName..":Start")
end

function CatStateGoOut:FixedUpdate( ... )
    Debug.Log(self.stateName..":FixedUpdate")
end

function CatStateGoOut:End( ... )
    Debug.Log(self.stateName..":End")
end


--be ill
CatStateSick = BaseClass:New(nil, BaseClass)

function CatStateSick:Start( ... )
    Debug.Log(self.stateName..":Start")
    self:InitPath()
    self.curTime = 0
    self.sitTime = 0
    self.num = 0
end

function CatStateSick:FixedUpdate( ... )
    Debug.Log(self.stateName..":FixedUpdate")
    if(not self.cat.catCtrl.isSick) then
        self.cat:EnterState("CatStateNormal")
        return
    end
    self.curTime = self.curTime + Time.deltaTime
    if(self.num == 1) then
        self.sitTime = self.sitTime + Time.deltaTime
        if(self.sitTime > 20) then
            self.cat.catCtrl:ShowAnimation("sneeze")
            self.cat.catCtrl:StopAnimation("sit")
            self:InitPath()
            self.num = 0
        end
    else
        if(self.cat.catCtrl:SickMoving(self.pot.transform)) then
            local num = math.random(2)
            if(num == 1) then
                self.cat.catCtrl:ShowAnimation("sit")
                self.cat.catCtrl:ShowAnimation("sneeze")
            else
                self:InitPath()
            end
        end
    end
end

function CatStateSick:End( ... )
    Debug.Log(self.stateName..":End")
    self.cat.catCtrl:CloseSick()
    self.cat.catCtrl:StopAnimation("sit")
    self.cat.catCtrl:StopAnimation("sneeze")
end

function CatStateSick:InitPath( ... )
    -- body
    self.pot = _G["PathController"].GetSickPot()
    Debug.Log("wayfinding end"..self.pot.name)
    self.cat.catCtrl:SickSetting(self.pot.transform)
end


--poop
CatStateCacation = BaseClass:New(nil, BaseClass)

function CatStateCacation:Start( ... )
    Debug.Log(self.stateName..":Start")
    if(not self.cat.Manager.isDefecating) then
        self.cat.Manager.isDefecating = true
    end
    self.step = 1
    self.pot = _G["PathController"].GetToiletPot(1)
    self.cat.catCtrl:MoveSetting(self.pot.transform)
end

function CatStateCacation:FixedUpdate( ... )
    Debug.Log(self.stateName..":FixedUpdate")
    if(self.cat.catCtrl:Moving(self.pot.transform)) then
        --judge the timing after the pathfinding is over，when the time is over, the state ends
        _G["PathController"].DelData(self.cat.pot.name)
        _G["PathController"].SaveData(self.pot.name,self.cat.CatModule.catId)
        self.cat.pot = self.pot
        if(self.step == 1) then
            self.step = 2
            self.pot = _G["PathController"].GetToiletPot(2)
            self.cat.catCtrl:MoveSetting(self.pot.transform)
        elseif(self.step == 2) then
            self.step = 3
            self.cat.catCtrl:EventSetting("clean",self.pot,function ( ... )
                -- body
                self.step = 4
                self.pot = _G["PathController"].GetToiletPot(1)
                self.cat.catCtrl:MoveSetting(self.pot.transform)
            end)
        elseif(self.step == 4) then
            self.step = 5
            self.pot = _G["PathController"].GetPot()
            self.cat.catCtrl:MoveSetting(self.pot.transform)
        elseif(self.step == 5) then
            self.cat:EnterState("CatStateNormal")
        end
    end
end

function CatStateCacation:End( ... )
    Debug.Log(self.stateName..":End")
    if(self.cat.Manager.isDefecating) then
        self.cat.Manager.isDefecating = false
        self.cat.catCtrl.isClean = false
    end
end



--have a meal
CatStateEat = BaseClass:New(nil, BaseClass)

function CatStateEat:Start( ... )
    Debug.Log(self.stateName..":Start")
    if(not self.cat.Manager.isEating) then
        self.cat.Manager.isEating = true
    end
    self.step = 1
    self.pot = _G["PathController"].GetEatPot(1)
    self.cat.catCtrl:MoveSetting(self.pot.transform)
end

function CatStateEat:FixedUpdate( ... )
    Debug.Log(self.stateName..":FixedUpdate")
    if(self.cat.catCtrl:Moving(self.pot.transform)) then
        --judge the timing after the pathfinding is over，when the time is over, the state ends
        _G["PathController"].DelData(self.cat.pot.name)
        _G["PathController"].SaveData(self.pot.name,self.cat.CatModule.catId)
        self.cat.pot = self.pot
        if(self.step == 1) then
            self.step = 2
            self.pot = _G["PathController"].GetEatPot(2)
            self.cat.catCtrl:MoveSetting(self.pot.transform)
        elseif(self.step == 2) then
            self.step = 3
            self.cat.catCtrl:EventSetting("eat",self.pot,function ( ... )
                -- body
                self.step = 4
                self.pot = _G["PathController"].GetEatPot(1)
                self.cat.catCtrl:MoveSetting(self.pot.transform)
            end)
        elseif(self.step == 4) then
            self.step = 5
            self.pot = _G["PathController"].GetPot()
            self.cat.catCtrl:MoveSetting(self.pot.transform)
        elseif(self.step == 5) then
            self.cat:EnterState("CatStateNormal")
        end
    end
end

function CatStateEat:End( ... )
    Debug.Log(self.stateName..":End")
    if(self.cat.Manager.isEating) then
        self.cat.Manager.isEating = false
        self.cat.catCtrl.isEat = false
    end
end



--drink water
CatStateDrink = BaseClass:New(nil, BaseClass)

function CatStateDrink:Start( ... )
    Debug.Log(self.stateName..":Start")
    if(not self.cat.Manager.isDrinking) then
        self.cat.Manager.isDrinking = true
    end
    self.step = 1
    self.pot = _G["PathController"].GetDrinkPot(1)
    self.cat.catCtrl:MoveSetting(self.pot.transform)
end

function CatStateDrink:FixedUpdate( ... )
    Debug.Log(self.stateName..":FixedUpdate")
    if(self.cat.catCtrl:Moving(self.pot.transform)) then
        --judge the timing after the pathfinding is over，when the time is over, the state ends
        _G["PathController"].DelData(self.cat.pot.name)
        _G["PathController"].SaveData(self.pot.name,self.cat.CatModule.catId)
        self.cat.pot = self.pot
        if(self.step == 1) then
            self.step = 2
            self.pot = _G["PathController"].GetDrinkPot(2)
            self.cat.catCtrl:MoveSetting(self.pot.transform)
        elseif(self.step == 2) then
            self.step = 3
            self.cat.catCtrl:EventSetting("drink",self.pot,function ( ... )
                -- body
                self.step = 4
                self.pot = _G["PathController"].GetDrinkPot(1)
                self.cat.catCtrl:MoveSetting(self.pot.transform)
            end)
        elseif(self.step == 4) then
            self.step = 5
            self.pot = _G["PathController"].GetPot()
            self.cat.catCtrl:MoveSetting(self.pot.transform)
        elseif(self.step == 5) then
            self.cat:EnterState("CatStateNormal")
        end
    end
end

function CatStateDrink:End( ... )
    Debug.Log(self.stateName..":End")
    if(self.cat.Manager.isDrinking) then
        self.cat.Manager.isDrinking = false
        self.cat.catCtrl.isDrink = false
    end
end




--summon
CatStateCall = BaseClass:New(nil, BaseClass)

function CatStateCall:Start( ... )
    Debug.Log(self.stateName..":Start")
    if(self.cat.callFlag) then
        Debug.Log("answer the call")
        self.cat.catCtrl:ShowAnimation("idle")
        self.pot = self.cat.catCtrl:CalledSetting()
        self.flag = 1
    end
end

function CatStateCall:FixedUpdate( ... )
    Debug.Log(self.stateName..":FixedUpdate")
    if(not self.cat.catCtrl.isCalled) then
        self.cat:EnterState("CatStateNormal")
    else
        if(self.cat.callFlag) then
            if(self.flag == 1) then
                if(self.cat.catCtrl:CalledMoveToMaster(self.pot)) then
                    Debug.Log("move in response to call")
                    self.flag = 2
                end
            elseif(self.flag == 2) then
                if(self.cat.catCtrl:LookMaster()) then
                    Debug.Log("responding to the call to turn over")
                    self.flag = 3
                    if(_G["PublicEvent"].readyCalled ~= nil) then
                        _G["PublicEvent"].readyCalled()
                    end

                    --CS.RoleController.Instance.gameObject:GetComponent("TouchCat"):SetTarget(self.cat.catCtrl,false)
                end
            end
        end
    end
end

function CatStateCall:End( ... )
    Debug.Log(self.stateName..":End")
    self.cat.catCtrl.isCalled = false
    if(self.cat.callFlag) then
        self.cat.catCtrl:CloseMove()
        self.cat.catCtrl:ShowAnimation("idle")
        self.cat.catCtrl:HideOthers()
    end
end



--call for masturbation
CatStateStroke = BaseClass:New(nil, BaseClass)

function CatStateStroke:Start( ... )
    Debug.Log(self.stateName..":Start")
    if(self.cat.strokeFlag) then
        self.cat.catCtrl:ShowAnimation("idle")
    else
        self.cat.catCtrl:ShowAnimation("idle")
        self.pot = _G["PathController"].GetGroundPot()    --temporary，you should determine the location that is not in the same area as the player
        self.cat.catCtrl:RunAwaySetting(self.pot.transform,1)
    end

end

function CatStateStroke:FixedUpdate( ... )
    -- Debug.Log(self.stateName..":FixedUpdate")
    if(not self.cat.catCtrl.isStroked) then
        self.cat:EnterState("CatStateNormal")
        return
    end

    if(self.cat.strokeFlag) then
        if(self.cat.catCtrl:LookMaster()) then
            Debug.Log("toward the player")
        end
    else
        Debug.Log("escape player")
        if(self.cat.catCtrl:RunAwayMaster(self.pot.transform)) then
            _G["PathController"].DelData(self.cat.pot.name)
            _G["PathController"].SaveData(self.pot.name,self.cat.CatModule.catId)   
            self.cat.pot = self.pot
            self.cat:EnterState("CatStateNormal")
        end
    end
end

function CatStateStroke:End( ... )
    Debug.Log(self.stateName..":End")
    self.cat.catCtrl.isStroked = false
    if(self.cat.strokeFlag) then
        self.cat.catCtrl:ShowAnimation("idle")
        self.cat.catCtrl:HideOthers()
    else
        self.cat.catCtrl:CloseRunAway()
    end
end



--current cat weight judgment：move、rest、sleep、amuse yourself
--move
CatStateMove = BaseClass:New(nil, BaseClass)

function CatStateMove:Start( ... )
    Debug.Log(self.stateName..":Start")
    --enable pathfinding to create a path
    self:InitPath()
    --start the clock
    self.curTime = 0
end

function CatStateMove:FixedUpdate( ... )
    self.curTime = self.curTime + Time.deltaTime
    --pathfinding
    if(self.cat.catCtrl:Moving(self.pot.transform)) then
        --judge the timing after the pathfinding is over，when the time is over, the state ends
        _G["PathController"].DelData(self.cat.pot.name)
        _G["PathController"].SaveData(self.pot.name,self.cat.CatModule.catId)
        self.cat.pot = self.pot
        if(math.ceil(self.curTime) >= 300) then
            self.cat:EnterState("CatStateNormal")
        else
            self:InitPath()
        end
    end
    --all decisions are interruptable
    self.cat:CheckSpecialState()
end

function CatStateMove:End( ... )
    Debug.Log(self.stateName..":End")
    --turn off pathfinding
    self.cat.catCtrl:CloseMove()
    --turn off timing
end


function CatStateMove:InitPath( ... )
    -- body
    self.pot = _G["PathController"].GetPot()
    self.cat.catCtrl:MoveSetting(self.pot.transform)
end


--rest personality 1independence 2clingy 3lively 4timid 5laziness
CatStateRest = BaseClass:New(nil, BaseClass)

function CatStateRest:Start( ... )
    Debug.Log(self.stateName..":Start")
    --fixed party、sit
    self.actionName = self:CheckLoopAction(self.cat.CatModule.character)
    Debug.Log(self.actionName)
    self.cat.catCtrl:ShowAnimation(self.actionName)
    --start the clock
    self.curTime = 0
    self.curRandomTime = 0
end

function CatStateRest:FixedUpdate( ... )
    -- Debug.Log(self.stateName..":FixedUpdate")
    --in the absence of a random action，determine whether the time is up，timeout ends the state
    self.curTime = self.curTime + Time.deltaTime
    self.curRandomTime = self.curRandomTime + Time.deltaTime
    
    if(math.ceil(self.curTime) >= 600) then
        self.cat:EnterState("CatStateNormal")
    else
        --any special decision can interrupt the state
        if(self.cat:CheckSpecialState()) then
            Debug.Log("any special decision can interrupt the resting state")
        else
            --call random actions at intervals
            if(self.actionName == "prostrated") then
                if(math.ceil(self.curRandomTime) > 30) then
                    self.curRandomTime = 0
                    local aniTab = {"rolling","tickle","lickbuttocks"}
                    local num = self:CheckRandomPlayboard( self.cat.CatModule.character )
                    self.cat.catCtrl:ShowAnimation(aniTab[num])
                end
            elseif(self.actionName == "sit") then
                if(math.ceil(self.curRandomTime) > 30) then
                    self.curRandomTime = 0
                    local aniTab = {"lickpaw","lickbody","kun"}
                    local num = self:CheckRandomSit( self.cat.CatModule.character )
                    self.cat.catCtrl:ShowAnimation(aniTab[num])
                end
            end
        end
    end
end


function CatStateRest:End( ... )
    Debug.Log(self.stateName..":End")
    --restoring action
    self.cat.catCtrl:StopAnimation(self.actionName)
    --turn off timing
end

--cycle during rest
function CatStateRest:CheckLoopAction( character )
    -- body
    local prostratedNum = 0
    local sitNum = 0
    if(character == 1) then
        prostratedNum = 200
        sitNum = 400
    elseif(character == 2) then
        prostratedNum = 50
        sitNum = 50
    elseif(character == 3) then
        prostratedNum = 50
        sitNum = 50
    elseif(character == 4) then
        prostratedNum = 50
        sitNum = 50
    elseif(character == 5) then
        prostratedNum = 400
        sitNum = 200
    end

    local all = prostratedNum + sitNum
    local num = math.random(all)
    if(num < prostratedNum) then
        return "prostrated"
    else
        return "sit"
    end
end

--random moves to lie down while resting
function CatStateRest:CheckRandomPlayboard( character )
    -- body
    local num1 = 0
    local num2 = 0
    local num3 = 0
    if(character == 1) then
        num1 = 25
        num2 = 50
        num3 = 100
    elseif(character == 2) then
        num1 = 50
        num2 = 50
        num3 = 50
    elseif(character == 3) then
        num1 = 50
        num2 = 50
        num3 = 50
    elseif(character == 4) then
        num1 = 50
        num2 = 50
        num3 = 50
    elseif(character == 5) then
        num1 = 10
        num2 = 50
        num3 = 50
    end
    local all = num1 + num2 + num3
    local num = math.random(all)
    if(num < num1) then
        return 1
    elseif(num < num1 + num2) then
        return 2
    else
        return 3
    end
end

--rest while sitting random action
function CatStateRest:CheckRandomSit( character )
    -- body
    local num1 = 0
    local num2 = 0
    local num3 = 0
    if(character == 1) then
        num1 = 50
        num2 = 100
        num3 = 50
    elseif(character == 2) then
        num1 = 50
        num2 = 50
        num3 = 50
    elseif(character == 3) then
        num1 = 100
        num2 = 50
        num3 = 50
    elseif(character == 4) then
        num1 = 50
        num2 = 100
        num3 = 50
    elseif(character == 5) then
        num1 = 50
        num2 = 50
        num3 = 100
    end
    local all = num1 + num2 + num3
    local num = math.random(all)
    if(num < num1) then
        return 1
    elseif(num < num1 + num2) then
        return 2
    else
        return 3
    end
end


--sleep
CatStateSleep = BaseClass:New(nil, BaseClass)

function CatStateSleep:Start( ... )
    Debug.Log(self.stateName..":Start")
    --sleep choice
    self.sleepAnimations = {
        [1] = {"sleep"},
        [2] = {"prostrated","liesleep"},
        [3] = {"prostrated","sidesleep"},
    }
    self.sleepIndex = self:CheckSleepIndex(self.cat.CatModule.character)
    for i=1,#self.sleepAnimations[self.sleepIndex] do
        local actionName = self.sleepAnimations[self.sleepIndex][i]
        self.cat.catCtrl:ShowAnimation(actionName)
    end

    --start the clock
    self.curTime = 0
end

function CatStateSleep:FixedUpdate( ... )
    -- Debug.Log(self.stateName..":FixedUpdate")
    --timeout ends the state
    self.curTime = self.curTime + Time.deltaTime
    if(math.ceil(self.curTime) >= 600) then
        self.cat:EnterState("CatStateNormal")
    else
        --any special decision can interrupt the state
        if(self.cat:CheckSpecialState()) then
            Debug.Log("any special decision can interrupt the resting state")
        end
    end
end

function CatStateSleep:End( ... )
    Debug.Log(self.stateName..":End")
    --restoring action
    for i=1,#self.sleepAnimations[self.sleepIndex] do
        local actionName = self.sleepAnimations[self.sleepIndex][i]
        self.cat.catCtrl:StopAnimation(actionName)
    end
    --turn off timing
end

function CatStateSleep:CheckSleepIndex( character )
    -- body
    local num1 = 0
    local num2 = 0
    local num3 = 0
    if(character == 1) then
        num1 = 100
        num2 = 20
        num3 = 40
    elseif(character == 2) then
        num1 = 20
        num2 = 100
        num3 = 40
    elseif(character == 3) then
        num1 = 40
        num2 = 100
        num3 = 20
    elseif(character == 4) then
        num1 = 100
        num2 = 20
        num3 = 40
    elseif(character == 5) then
        num1 = 20
        num2 = 100
        num3 = 40
    end
    local all = num1 + num2 + num3
    local num = math.random(all)
    if(num < num1) then
        return 1
    elseif(num < num1 + num2) then
        return 2
    else
        return 3
    end
end


--amuse yourself
CatStatePlay = BaseClass:New(nil, BaseClass)

function CatStatePlay:Start( ... )
    Debug.Log(self.stateName..":Start")
    --selective action
    self.playTime = {
        [1] = 1.133,
        [2] = 4.833+7.833,
        [3] = 1.033+1.8+0.8,
    }
    self.playAnimations = {
        [1] = {"somersault_jump"},
        [2] = {"prostrated","rolling"},
        [3] = {"stand_up"},
    }
    self.playIndex = self:CheckPlayIndex(self.cat.CatModule.character)
    for i=1,#self.playAnimations[self.playIndex] do
        local actionName = self.playAnimations[self.playIndex][i]
        self.cat.catCtrl:ShowAnimation(actionName)
    end
    --start the clock
    self.curTime = 0
    Debug.Log("play time = "..self.playTime[self.playIndex])
end

function CatStatePlay:FixedUpdate( ... )
    -- Debug.Log(self.stateName..":FixedUpdate")
    --wait for the end of the action，end state
    self.curTime = self.curTime + Time.deltaTime
    if(self.curTime > self.playTime[self.playIndex]) then
        self.cat:EnterState("CatStateNormal")
    end
end

function CatStatePlay:End( ... )
    Debug.Log(self.stateName..":End")
    --restoring action
    for i=1,#self.playAnimations[self.playIndex] do
        local actionName = self.playAnimations[self.playIndex][i]
        self.cat.catCtrl:StopAnimation(actionName)
    end
end

function CatStatePlay:CheckPlayIndex( character )
    -- body
    local num1 = 0
    local num2 = 0
    local num3 = 0
    if(character == 1) then
        num1 = 50
        num2 = 50
        num3 = 50
    elseif(character == 2) then
        num1 = 50
        num2 = 50
        num3 = 100
    elseif(character == 3) then
        num1 = 100
        num2 = 50
        num3 = 50
    elseif(character == 4) then
        num1 = 50
        num2 = 50
        num3 = 50
    elseif(character == 5) then
        num1 = 10
        num2 = 20
        num3 = 10
    end
    local all = num1 + num2 + num3
    local num = math.random(all)
    if(num < num1) then
        return 1
    elseif(num < num1 + num2) then
        return 2
    else
        return 3
    end
end
